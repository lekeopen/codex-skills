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

skills=(brand-system-builder social-distribution-setup)
for skill in "${skills[@]}"; do
  require_file "$skill/SKILL.md"
  require_file "$skill/agents/openai.yaml"

  if [[ -f "$skill/SKILL.md" ]]; then
    validate_frontmatter "$skill/SKILL.md"
  fi
done

require_file README.md
require_file LICENSE
require_file scripts/validate-skills.sh
require_file tests/fixtures/valid-rss.xml
require_file tests/fixtures/valid-publish-queue.json

if [[ -f scripts/validate-skills.sh ]] && ! bash -n scripts/validate-skills.sh; then
  fail 'validation entry point has invalid shell syntax'
fi

while IFS= read -r -d '' script; do
  if ! node --check "$script"; then
    fail "invalid Node.js syntax: $script"
  fi
done < <(find . -path './*/scripts/*.mjs' -type f -print0)

if [[ -f tests/fixtures/valid-rss.xml ]] \
  && ! node social-distribution-setup/scripts/inspect_rss.mjs tests/fixtures/valid-rss.xml; then
  fail 'RSS inspector rejected the valid fixture'
fi

if [[ -f tests/fixtures/valid-publish-queue.json ]] \
  && ! node social-distribution-setup/scripts/inspect_publish_queue.mjs tests/fixtures/valid-publish-queue.json; then
  fail 'publish queue inspector rejected the valid fixture'
fi

if ! node social-distribution-setup/scripts/generate_make_notes.mjs \
  --site https://example.test \
  --rss https://example.test/rss.xml \
  --platforms facebook,linkedin,x >/dev/null; then
  fail 'Make notes generator rejected deterministic arguments'
fi

if (( failures > 0 )); then
  printf 'Repository validation test failed with %d issue(s).\n' "$failures" >&2
  exit 1
fi

printf 'Repository validation test passed for: %s\n' "${skills[*]}"
