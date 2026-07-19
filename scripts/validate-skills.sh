#!/usr/bin/env bash

set -u

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repository_root"

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

validate_skill_metadata() {
  local skill_directory="$1"
  local skill_file="$skill_directory/SKILL.md"
  local metadata_file="$skill_directory/agents/openai.yaml"
  local validation_output
  local validation_exit=0
  local validation_failures

  validation_output="$(node - "$skill_directory" "$skill_file" "$metadata_file" <<'NODE' 2>&1
const fs = require('node:fs');

const [skillName, skillFile, metadataFile] = process.argv.slice(2);
const issues = [];

function issue(message) {
  issues.push(`FAIL: ${skillName}: ${message}`);
}

function parseScalar(source, context) {
  const value = source.trim();

  if (value === '') return '';

  if (value.startsWith('"')) {
    if (!value.endsWith('"')) throw new Error(`${context} has an unterminated quoted string`);
    try {
      return JSON.parse(value);
    } catch {
      throw new Error(`${context} has an invalid double-quoted string`);
    }
  }

  if (value.startsWith("'")) {
    if (!value.endsWith("'")) throw new Error(`${context} has an unterminated quoted string`);
    return value.slice(1, -1).replace(/''/g, "'");
  }

  const withoutComment = value.replace(/\s+#.*$/, '').trimEnd();
  if (withoutComment === 'true') return true;
  if (withoutComment === 'false') return false;
  if (withoutComment === 'null' || withoutComment === '~') return null;
  if (/^[\[\]{}|>&*!]/.test(withoutComment)) {
    throw new Error(`${context} uses unsupported YAML syntax`);
  }
  return withoutComment;
}

function parseFlatMapping(source, context) {
  const result = {};

  for (const [index, rawLine] of source.split(/\r?\n/).entries()) {
    if (/^\s*(?:#.*)?$/.test(rawLine)) continue;
    if (/^\s/.test(rawLine)) throw new Error(`${context} line ${index + 1} must not be indented`);

    const match = rawLine.match(/^([A-Za-z_][A-Za-z0-9_-]*):(?:\s*(.*))?$/);
    if (!match) throw new Error(`${context} line ${index + 1} is not a simple key-value pair`);
    if (Object.hasOwn(result, match[1])) throw new Error(`${context} repeats key ${match[1]}`);
    result[match[1]] = parseScalar(match[2] ?? '', `${context}.${match[1]}`);
  }

  return result;
}

function parseNestedMapping(source, context) {
  const result = {};
  let section = null;

  for (const [index, rawLine] of source.split(/\r?\n/).entries()) {
    if (/^\s*(?:#.*)?$/.test(rawLine)) continue;
    if (rawLine.includes('\t')) throw new Error(`${context} line ${index + 1} contains a tab`);

    const topLevel = rawLine.match(/^([A-Za-z_][A-Za-z0-9_-]*):\s*$/);
    if (topLevel) {
      section = topLevel[1];
      if (Object.hasOwn(result, section)) throw new Error(`${context} repeats section ${section}`);
      result[section] = {};
      continue;
    }

    const nested = rawLine.match(/^  ([A-Za-z_][A-Za-z0-9_-]*):(?:\s*(.*))?$/);
    if (!nested || section === null) {
      throw new Error(`${context} line ${index + 1} must be a two-space-indented key-value pair`);
    }
    if (Object.hasOwn(result[section], nested[1])) {
      throw new Error(`${context}.${section} repeats key ${nested[1]}`);
    }
    result[section][nested[1]] = parseScalar(
      nested[2] ?? '',
      `${context}.${section}.${nested[1]}`,
    );
  }

  return result;
}

let frontmatter = {};
try {
  const skillContents = fs.readFileSync(skillFile, 'utf8');
  const match = skillContents.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
  if (!match) {
    issue(`missing YAML frontmatter: ${skillFile}`);
  } else {
    frontmatter = parseFlatMapping(match[1], `${skillFile} frontmatter`);
  }
} catch (error) {
  issue(`invalid YAML frontmatter in ${skillFile}: ${error.message}`);
}

if (typeof frontmatter.name !== 'string' || !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(frontmatter.name)) {
  issue(`frontmatter name must be a non-empty lowercase hyphen name: ${skillFile}`);
} else if (frontmatter.name !== skillName) {
  issue(`frontmatter name must equal directory name: ${skillFile}`);
}

if (typeof frontmatter.description !== 'string' || frontmatter.description.trim() === '') {
  issue(`frontmatter description must be a non-empty string: ${skillFile}`);
}

let metadata = {};
try {
  metadata = parseNestedMapping(fs.readFileSync(metadataFile, 'utf8'), metadataFile);
} catch (error) {
  issue(`invalid metadata in ${metadataFile}: ${error.message}`);
}

const displayName = metadata.interface?.display_name;
if (typeof displayName !== 'string' || displayName.trim() === '') {
  issue(`interface.display_name must be a non-empty string: ${metadataFile}`);
}

const shortDescription = metadata.interface?.short_description;
if (
  typeof shortDescription !== 'string'
  || shortDescription.length < 25
  || shortDescription.length > 64
) {
  issue(`interface.short_description must be 25-64 characters: ${metadataFile}`);
}

const defaultPrompt = metadata.interface?.default_prompt;
if (typeof defaultPrompt !== 'string' || !defaultPrompt.includes(`$${skillName}`)) {
  issue(`interface.default_prompt must contain $${skillName}: ${metadataFile}`);
}

if (metadata.policy?.allow_implicit_invocation !== true) {
  issue(`policy.allow_implicit_invocation must be true: ${metadataFile}`);
}

for (const message of issues) console.error(message);
if (issues.length > 0) process.exit(1);
NODE
)" || validation_exit=$?

  if (( validation_exit != 0 )); then
    if [[ -n "$validation_output" ]]; then
      printf '%s\n' "$validation_output" >&2
    fi
    validation_failures="$(printf '%s\n' "$validation_output" | grep -c '^FAIL:' || true)"
    if (( validation_failures == 0 )); then
      fail "$skill_directory: metadata validation could not run"
    else
      failures=$((failures + validation_failures))
    fi
  fi
}

validate_forbidden_release_files() {
  local skill_directory="$1"
  local forbidden_file

  for forbidden_file in README.md CHANGELOG.md RELEASE_CHECKLIST.md VERSION; do
    if [[ -e "$skill_directory/$forbidden_file" ]]; then
      fail "$skill_directory: forbidden skill-local release file: $skill_directory/$forbidden_file"
    fi
  done

  while IFS= read -r -d '' release_report; do
    fail "$skill_directory: forbidden skill-local release file: $release_report"
  done < <(find "$skill_directory/docs" -maxdepth 1 -type f -name 'release-report-*.md' -print0 2>/dev/null)
}

validate_readme_index() {
  local skill_directory="$1"

  if [[ ! -f README.md ]]; then
    fail "$skill_directory: missing repository index: README.md"
  elif ! grep -Fq "]($skill_directory/)" README.md \
    && ! grep -Fq "](./$skill_directory/)" README.md; then
    fail "$skill_directory: README.md must link to $skill_directory/"
  fi
}

validate_scripts() {
  local skill_directory="$1"
  local hook="tests/skills/$skill_directory.sh"
  local has_scripts=false

  while IFS= read -r -d '' script; do
    has_scripts=true
    if [[ "$script" == *.mjs ]] && ! node --check "$script"; then
      fail "$skill_directory: invalid Node.js syntax: $script"
    fi
  done < <(find "$skill_directory/scripts" -type f -print0 2>/dev/null)

  if [[ "$has_scripts" == true ]]; then
    if [[ ! -f "$hook" || ! -x "$hook" ]]; then
      fail "$skill_directory: missing executable runtime validation hook: $hook"
    elif ! "$hook"; then
      fail "$skill_directory: runtime validation hook failed: $hook"
    else
      printf 'Runtime hook passed: %s\n' "$hook"
    fi
  fi
}

skill_files=()
while IFS= read -r skill_file; do
  skill_files+=("$skill_file")
done < <(find . -mindepth 2 -maxdepth 2 -name SKILL.md -type f | sort)

if (( ${#skill_files[@]} == 0 )); then
  fail 'no top-level skills were found'
fi

for skill_file in "${skill_files[@]}"; do
  skill_directory="${skill_file#./}"
  skill_directory="${skill_directory%/SKILL.md}"
  metadata_file="$skill_directory/agents/openai.yaml"

  printf 'Validating skill: %s\n' "$skill_directory"
  if [[ ! -f "$metadata_file" ]]; then
    fail "$skill_directory: missing required metadata: $metadata_file"
  else
    validate_skill_metadata "$skill_directory"
  fi
  validate_forbidden_release_files "$skill_directory"
  validate_readme_index "$skill_directory"
  validate_scripts "$skill_directory"
done

if (( failures > 0 )); then
  printf 'Skill validation failed with %d issue(s).\n' "$failures" >&2
  exit 1
fi

printf 'Skill validation passed for %d skill(s).\n' "${#skill_files[@]}"
