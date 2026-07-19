# Contributing

Keep changes small, maintainable, and compatible with existing skill behavior.

1. Put each skill in a top-level directory whose name matches its `SKILL.md` frontmatter.
2. Keep skill packages limited to runtime instructions, scripts, references, and output assets. Do not add skill-local release notes, changelogs, or READMEs.
3. Preserve existing workflows unless the change explicitly proposes and documents a behavior change.
4. Quote all string values in `agents/openai.yaml`; keep `short_description` between 25 and 64 characters and mention `$skill-name` in `default_prompt`.
5. Add every skill to the root README index.
6. When a skill contains scripts, add an executable runtime validation hook at `tests/skills/<name>.sh` that uses deterministic fixtures.
7. Never include credentials, tokens, private customer data, or unlicensed assets.
8. Run `bash tests/validate-repository.sh` and `bash scripts/validate-skills.sh` before submitting a change.

In a pull request, explain the user-facing purpose, compatibility risks, verification performed, and any behavior that could not be tested.
