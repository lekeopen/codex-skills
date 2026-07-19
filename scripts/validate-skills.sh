#!/usr/bin/env bash

set -u

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repository_root"

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

validate_yaml_file() {
  local file="$1"

  if ! ruby - "$file" <<'RUBY'
require 'yaml'

contents = File.read(ARGV.fetch(0))
parsed = YAML.safe_load(contents, permitted_classes: [], aliases: false)
abort 'YAML document must be a mapping' unless parsed.is_a?(Hash)
RUBY
  then
    fail "invalid YAML metadata: $file"
  fi
}

validate_skill_frontmatter() {
  local skill_file="$1"

  if ! ruby - "$skill_file" <<'RUBY'
require 'yaml'

contents = File.read(ARGV.fetch(0))
match = contents.match(/\A---\r?\n(.*?)\r?\n---\r?\n/m)
abort 'missing YAML frontmatter' unless match

frontmatter = YAML.safe_load(match[1], permitted_classes: [], aliases: false)
abort 'YAML frontmatter must be a mapping' unless frontmatter.is_a?(Hash)
abort 'YAML frontmatter must include name' unless frontmatter['name']
abort 'YAML frontmatter must include description' unless frontmatter['description']
RUBY
  then
    fail "invalid YAML frontmatter: $skill_file"
  fi
}

validate_forbidden_release_files() {
  local skill_directory="$1"
  local forbidden_file

  for forbidden_file in README.md CHANGELOG.md RELEASE_CHECKLIST.md VERSION; do
    if [[ -e "$skill_directory/$forbidden_file" ]]; then
      fail "forbidden skill-local release file: $skill_directory/$forbidden_file"
    fi
  done

  while IFS= read -r -d '' release_report; do
    fail "forbidden skill-local release file: $release_report"
  done < <(find "$skill_directory/docs" -maxdepth 1 -type f -name 'release-report-*.md' -print0 2>/dev/null)
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
  validate_skill_frontmatter "$skill_file"
  validate_forbidden_release_files "$skill_directory"

  if [[ ! -f "$metadata_file" ]]; then
    fail "missing required metadata: $metadata_file"
  else
    validate_yaml_file "$metadata_file"
  fi

  while IFS= read -r -d '' script; do
    if ! node --check "$script"; then
      fail "invalid Node.js syntax: $script"
    fi
  done < <(find "$skill_directory/scripts" -type f -name '*.mjs' -print0 2>/dev/null)
done

if ! node social-distribution-setup/scripts/inspect_rss.mjs tests/fixtures/valid-rss.xml; then
  fail 'RSS inspector rejected the valid fixture'
fi

if ! node social-distribution-setup/scripts/inspect_publish_queue.mjs tests/fixtures/valid-publish-queue.json; then
  fail 'publish queue inspector rejected the valid fixture'
fi

if (( failures > 0 )); then
  printf 'Skill validation failed with %d issue(s).\n' "$failures" >&2
  exit 1
fi

printf 'Skill validation passed for %d skill(s).\n' "${#skill_files[@]}"
