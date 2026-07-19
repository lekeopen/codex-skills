#!/usr/bin/env bash

set -u

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repository_root"

node social-distribution-setup/scripts/inspect_rss.mjs \
  tests/fixtures/valid-rss.xml >/dev/null
node social-distribution-setup/scripts/inspect_publish_queue.mjs \
  tests/fixtures/valid-publish-queue.json >/dev/null
node social-distribution-setup/scripts/generate_make_notes.mjs \
  --site https://example.test \
  --rss https://example.test/rss.xml \
  --platforms facebook,linkedin,x >/dev/null

printf 'social-distribution-setup runtime validation passed.\n'
