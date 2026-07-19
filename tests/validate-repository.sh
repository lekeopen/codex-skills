#!/usr/bin/env bash

set -u

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repository_root"

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

require_file() {
  if [[ ! -f "$1" ]]; then
    fail "missing required file: $1"
  fi
}

require_exact_line() {
  local file="$1"
  local expected_line="$2"

  if [[ ! -f "$file" ]] || ! grep -Fqx "$expected_line" "$file"; then
    fail "missing required line in $file: $expected_line"
  fi
}

validate_brand_runtime_reference() {
  local skill_file="brand-system-builder/SKILL.md"
  local reference_file="brand-system-builder/references/lifecycle-foundations-and-governance.md"
  local reference_link='[Lifecycle foundations and governance](references/lifecycle-foundations-and-governance.md)'
  local link_count=0

  require_file "$reference_file"

  if [[ -f "$skill_file" ]]; then
    link_count="$(grep -Fc "$reference_link" "$skill_file")"
  fi

  if (( link_count < 3 )); then
    fail "brand runtime reference must be linked from strategy, identity, and governance sections"
  fi
}

validate_frontmatter() {
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

validate_validation_entrypoint() {
  local validator_output
  local expected_failure
  local expected_marker
  local expected_failures=6
  local actual_failures
  local validator_exit=0
  local expected_success_summary

  validator_output="$(mktemp)"
  if bash scripts/validate-skills.sh >"$validator_output" 2>&1; then
    :
  else
    validator_exit=$?
  fi

  for expected_marker in \
    'RSS inspector fixture passed.' \
    'Publish queue inspector fixture passed.' \
    'Make notes generator fixture passed.'; do
    if ! grep -Fqx "$expected_marker" "$validator_output"; then
      fail "validator did not report fixture success: $expected_marker"
    fi
  done

  if [[ "$validator_exit" -eq 0 ]]; then
    expected_success_summary="Skill validation passed for ${discovered_skill_count} skill(s)."
    if ! grep -Fqx "$expected_success_summary" "$validator_output"; then
      fail 'validator exited successfully without the expected success summary'
    fi
  else
    for expected_failure in \
      'FAIL: forbidden skill-local release file: brand-system-builder/README.md' \
      'FAIL: forbidden skill-local release file: brand-system-builder/CHANGELOG.md' \
      'FAIL: forbidden skill-local release file: brand-system-builder/RELEASE_CHECKLIST.md' \
      'FAIL: forbidden skill-local release file: brand-system-builder/VERSION' \
      'FAIL: forbidden skill-local release file: brand-system-builder/docs/release-report-v1.0.md' \
      'FAIL: missing required metadata: brand-system-builder/agents/openai.yaml'; do
      if ! grep -Fqx "$expected_failure" "$validator_output"; then
        fail "validator did not report its expected pre-Task-2 failure: $expected_failure"
      fi
    done

    actual_failures="$(grep -c '^FAIL:' "$validator_output")"
    if [[ "$actual_failures" -ne "$expected_failures" ]]; then
      fail "validator reported unexpected pre-Task-2 failures: $actual_failures"
    fi
  fi

  cat "$validator_output"
  rm -f "$validator_output"
}

skills=(brand-system-builder social-distribution-setup)
discovered_skill_count=0
while IFS= read -r skill_file; do
  discovered_skill_count=$((discovered_skill_count + 1))
done < <(find . -mindepth 2 -maxdepth 2 -name SKILL.md -type f | sort)

for skill in "${skills[@]}"; do
  require_file "$skill/SKILL.md"
  require_file "$skill/agents/openai.yaml"

  if [[ -f "$skill/SKILL.md" ]]; then
    validate_frontmatter "$skill/SKILL.md"
  fi
done

require_file README.md
require_file LICENSE
require_file .gitignore
require_file scripts/validate-skills.sh
require_file tests/fixtures/valid-rss.xml
require_file tests/fixtures/valid-publish-queue.json
require_exact_line .gitignore '/.superpowers/'
validate_brand_runtime_reference

if [[ -f scripts/validate-skills.sh ]] && ! bash -n scripts/validate-skills.sh; then
  fail 'validation entry point has invalid shell syntax'
fi

if [[ -f scripts/validate-skills.sh ]]; then
  validate_validation_entrypoint
fi

if (( failures > 0 )); then
  printf 'Repository validation test failed with %d issue(s).\n' "$failures" >&2
  exit 1
fi

printf 'Repository validation test passed for: %s\n' "${skills[*]}"
