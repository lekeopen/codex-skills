#!/usr/bin/env bash

set -u

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repository_root"

failures=0
temporary_root=""

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

cleanup() {
  if [[ -n "$temporary_root" && -d "$temporary_root" ]]; then
    rm -rf -- "$temporary_root"
  fi
}

trap cleanup EXIT

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

run_validator() {
  local root="$1"
  local output_file="$2"

  (
    cd "$root"
    bash scripts/validate-skills.sh
  ) >"$output_file" 2>&1
}

validate_brand_runtime_reference() {
  local root="$1"

  node - "$root" <<'NODE'
const fs = require('node:fs');
const path = require('node:path');

const root = process.argv[2];
const skillFile = path.join(root, 'brand-system-builder', 'SKILL.md');
const referenceFile = path.join(
  root,
  'brand-system-builder',
  'references',
  'lifecycle-foundations-and-governance.md',
);
const referenceTarget = '(references/lifecycle-foundations-and-governance.md)';
const requiredStages = ['02', '04', '09'];
const requiredHeadings = [
  'Brand foundation contract',
  'Identity coverage contract',
  'Production maintenance contract',
  'Change classification',
  'State validity and consumer tracking',
];
const issues = [];

function readRequiredFile(file) {
  try {
    return fs.readFileSync(file, 'utf8');
  } catch (error) {
    issues.push(`missing brand runtime reference file: ${path.relative(root, file)}`);
    return '';
  }
}

const skillContents = readRequiredFile(skillFile);
const referenceContents = readRequiredFile(referenceFile);
const stageSections = new Map();
let currentStage = null;

for (const line of skillContents.split(/\r?\n/)) {
  const stageMatch = line.match(/^### Stage (\d{2}) — /);
  if (stageMatch) {
    currentStage = stageMatch[1];
    stageSections.set(currentStage, []);
  } else if (currentStage !== null) {
    stageSections.get(currentStage).push(line);
  }
}

for (const stage of requiredStages) {
  const section = stageSections.get(stage);
  if (!section) {
    issues.push(`brand SKILL.md is missing Stage ${stage}`);
  } else if (!section.join('\n').includes(referenceTarget)) {
    issues.push(`brand SKILL.md Stage ${stage} must link lifecycle-foundations-and-governance.md`);
  }
}

const headings = new Set(
  [...referenceContents.matchAll(/^## (.+?)\r?$/gm)].map((match) => match[1]),
);
for (const heading of requiredHeadings) {
  if (!headings.has(heading)) {
    issues.push(`brand runtime reference is missing heading: ${heading}`);
  }
}

for (const issue of issues) console.error(`FAIL: ${issue}`);
if (issues.length > 0) process.exit(1);
NODE
}

make_fixture() {
  local fixture_root="$1"

  mkdir -p \
    "$fixture_root/scripts" \
    "$fixture_root/fixture-skill/agents" \
    "$fixture_root/fixture-skill/scripts" \
    "$fixture_root/tests/skills"
  cp scripts/validate-skills.sh "$fixture_root/scripts/validate-skills.sh"

  cat >"$fixture_root/README.md" <<'EOF'
# Fixture repository

- [`fixture-skill`](fixture-skill/)
EOF

  cat >"$fixture_root/fixture-skill/SKILL.md" <<'EOF'
---
name: fixture-skill
description: A deterministic fixture skill used by repository validation tests.
---

# Fixture Skill
EOF

  cat >"$fixture_root/fixture-skill/agents/openai.yaml" <<'EOF'
interface:
  display_name: "Fixture Skill"
  short_description: "Validate a deterministic repository fixture"
  default_prompt: "Use $fixture-skill to validate this fixture."
policy:
  allow_implicit_invocation: true
EOF

  cat >"$fixture_root/fixture-skill/scripts/check.mjs" <<'EOF'
console.log('fixture script passed');
EOF

  cat >"$fixture_root/tests/skills/fixture-skill.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
node fixture-skill/scripts/check.mjs >/dev/null
EOF
  chmod +x "$fixture_root/tests/skills/fixture-skill.sh"
}

expect_fixture_failure() {
  local fixture_name="$1"
  local expected_message="$2"
  local fixture_root="$temporary_root/$fixture_name"
  local output_file="$fixture_root/validator-output.txt"

  if run_validator "$fixture_root" "$output_file"; then
    fail "validator accepted invalid fixture: $fixture_name"
  elif ! grep -Fq "$expected_message" "$output_file"; then
    fail "validator failure for $fixture_name did not include: $expected_message"
    cat "$output_file"
  fi
}

require_file README.md
require_file CONTRIBUTING.md
require_file LICENSE
require_file .gitignore
require_file scripts/validate-skills.sh
require_exact_line .gitignore '/.superpowers/'

brand_contract_output="$(mktemp)"
if ! validate_brand_runtime_reference "$repository_root" >"$brand_contract_output" 2>&1; then
  fail 'brand runtime reference contract rejected the working tree'
  cat "$brand_contract_output"
fi
rm -f "$brand_contract_output"

if ! bash -n scripts/validate-skills.sh; then
  fail 'validation entry point has invalid shell syntax'
fi

if ! bash -n tests/validate-repository.sh; then
  fail 'repository validation test has invalid shell syntax'
fi

skill_files=()
while IFS= read -r skill_file; do
  skill_files+=("$skill_file")
done < <(find . -mindepth 2 -maxdepth 2 -name SKILL.md -type f | sort)

if (( ${#skill_files[@]} == 0 )); then
  fail 'no top-level skills were found'
fi

validator_output="$(mktemp)"
if ! run_validator "$repository_root" "$validator_output"; then
  fail 'repository validator rejected the working tree'
  cat "$validator_output"
elif ! grep -Fqx "Skill validation passed for ${#skill_files[@]} skill(s)." "$validator_output"; then
  fail 'repository validator omitted the dynamic success summary'
  cat "$validator_output"
fi
rm -f "$validator_output"

temporary_root="$(mktemp -d)"
baseline_root="$temporary_root/baseline"
make_fixture "$baseline_root"
baseline_output="$baseline_root/validator-output.txt"
if ! run_validator "$baseline_root" "$baseline_output"; then
  fail 'validator rejected the valid minimal fixture'
  cat "$baseline_output"
fi

brand_mutation_root="$temporary_root/brand-reference-mutation"
mkdir -p "$brand_mutation_root/brand-system-builder/references"
cp brand-system-builder/SKILL.md \
  "$brand_mutation_root/brand-system-builder/SKILL.md"
cp brand-system-builder/references/lifecycle-foundations-and-governance.md \
  "$brand_mutation_root/brand-system-builder/references/lifecycle-foundations-and-governance.md"
awk -v target='(references/lifecycle-foundations-and-governance.md)' '
  /^### Stage 04 — / { in_stage = 1 }
  /^### Stage 05 — / { in_stage = 0 }
  in_stage && index($0, target) { next }
  { print }
' "$brand_mutation_root/brand-system-builder/SKILL.md" \
  >"$brand_mutation_root/brand-system-builder/SKILL.md.tmp"
mv "$brand_mutation_root/brand-system-builder/SKILL.md.tmp" \
  "$brand_mutation_root/brand-system-builder/SKILL.md"
sed 's/^## Change classification$/## Removed classification heading/' \
  "$brand_mutation_root/brand-system-builder/references/lifecycle-foundations-and-governance.md" \
  >"$brand_mutation_root/brand-system-builder/references/lifecycle-foundations-and-governance.md.tmp"
mv "$brand_mutation_root/brand-system-builder/references/lifecycle-foundations-and-governance.md.tmp" \
  "$brand_mutation_root/brand-system-builder/references/lifecycle-foundations-and-governance.md"
brand_mutation_output="$brand_mutation_root/contract-output.txt"
if validate_brand_runtime_reference "$brand_mutation_root" \
  >"$brand_mutation_output" 2>&1; then
  fail 'brand runtime reference contract accepted an invalid mutation'
else
  for expected_message in \
    'brand SKILL.md Stage 04 must link lifecycle-foundations-and-governance.md' \
    'brand runtime reference is missing heading: Change classification'; do
    if ! grep -Fq "$expected_message" "$brand_mutation_output"; then
      fail "brand runtime mutation did not report: $expected_message"
    fi
  done
fi

name_mismatch_root="$temporary_root/name-mismatch"
cp -R "$baseline_root" "$name_mismatch_root"
sed 's/^name: fixture-skill$/name: wrong-name/' \
  "$name_mismatch_root/fixture-skill/SKILL.md" \
  >"$name_mismatch_root/fixture-skill/SKILL.md.tmp"
mv "$name_mismatch_root/fixture-skill/SKILL.md.tmp" \
  "$name_mismatch_root/fixture-skill/SKILL.md"
expect_fixture_failure \
  'name-mismatch' \
  'fixture-skill: frontmatter name must equal directory name'

invalid_metadata_root="$temporary_root/invalid-metadata"
cp -R "$baseline_root" "$invalid_metadata_root"
sed 's/^  short_description:.*$/  short_description: "Too short"/' \
  "$invalid_metadata_root/fixture-skill/agents/openai.yaml" \
  >"$invalid_metadata_root/fixture-skill/agents/openai.yaml.tmp"
mv "$invalid_metadata_root/fixture-skill/agents/openai.yaml.tmp" \
  "$invalid_metadata_root/fixture-skill/agents/openai.yaml"
expect_fixture_failure \
  'invalid-metadata' \
  'fixture-skill: interface.short_description must be 25-64 characters'

missing_index_root="$temporary_root/missing-index"
cp -R "$baseline_root" "$missing_index_root"
printf '# Fixture repository\n' >"$missing_index_root/README.md"
expect_fixture_failure \
  'missing-index' \
  'fixture-skill: README.md must link to fixture-skill/'

missing_hook_root="$temporary_root/missing-runtime-hook"
cp -R "$baseline_root" "$missing_hook_root"
rm -f "$missing_hook_root/tests/skills/fixture-skill.sh"
expect_fixture_failure \
  'missing-runtime-hook' \
  'fixture-skill: missing executable runtime validation hook: tests/skills/fixture-skill.sh'

failing_hook_root="$temporary_root/failing-runtime-hook"
cp -R "$baseline_root" "$failing_hook_root"
awk '
  /^node / { print "false" }
  { print }
' "$failing_hook_root/tests/skills/fixture-skill.sh" \
  >"$failing_hook_root/tests/skills/fixture-skill.sh.tmp"
mv "$failing_hook_root/tests/skills/fixture-skill.sh.tmp" \
  "$failing_hook_root/tests/skills/fixture-skill.sh"
chmod +x "$failing_hook_root/tests/skills/fixture-skill.sh"
expect_fixture_failure \
  'failing-runtime-hook' \
  'fixture-skill: runtime validation hook failed: tests/skills/fixture-skill.sh'

if (( failures > 0 )); then
  printf 'Repository validation test failed with %d issue(s).\n' "$failures" >&2
  exit 1
fi

printf 'Repository validation test passed for %d discovered skill(s).\n' "${#skill_files[@]}"
