# Codex Skills Repository Design

## Goal

Create `lekeopen/codex-skills` as the public, long-term home for reusable Codex skills developed by lekeopen. The initial release contains `brand-system-builder` and `social-distribution-setup`; future skills are added as sibling directories.

## Repository Structure

```text
codex-skills/
├── README.md
├── LICENSE
├── scripts/
│   └── validate-skills.sh
├── brand-system-builder/
│   ├── SKILL.md
│   └── agents/openai.yaml
└── social-distribution-setup/
    ├── SKILL.md
    ├── agents/openai.yaml
    ├── scripts/
    ├── references/
    └── assets/
```

Each top-level skill directory is independently usable. A skill contains only runtime instructions and resources. Repository-wide contributor, release, and validation documentation stays at the repository root.

## Initial Cleanup

- Preserve the behavior and scope of both existing skills.
- Normalize skill metadata and add or refresh `agents/openai.yaml`.
- Remove release-process artifacts from `brand-system-builder` when they duplicate or narrate its development history.
- Retain supporting references only when the skill needs them at runtime; link them directly from `SKILL.md`.
- Keep existing scripts dependency-free unless a dependency is clearly justified.

## Validation

Repository validation must:

- discover every top-level directory containing `SKILL.md`;
- run the official skill validator for each skill when available;
- verify required metadata and `agents/openai.yaml`;
- run syntax checks and representative fixtures for bundled scripts;
- fail clearly and non-destructively.

The initial release is complete only when both skills validate and all bundled scripts pass their checks.

## Public Distribution

- Create a public GitHub repository at `lekeopen/codex-skills`.
- Use a permissive license so others can reuse and adapt the skills.
- Document installation by copying or linking an individual skill directory into the user's Codex skills directory.
- Publish the initial work on the default branch because this is a new repository with no existing production history.

## Maintenance Rules

- Add future skills as sibling directories; do not create a separate repository per skill by default.
- Keep each skill self-contained and independently valid.
- Avoid repository-wide dependencies that every skill must install.
- Update the root skill index and validation coverage whenever a skill is added, renamed, or removed.
- Never commit secrets, account credentials, generated private artifacts, or environment-specific paths.

## Risks and Controls

- **Accidental behavior changes:** compare content before and after cleanup and preserve workflow semantics.
- **Stale or missing UI metadata:** generate metadata from the final `SKILL.md` and validate it.
- **Unverified scripts:** exercise local-file fixtures without network or third-party side effects.
- **Future structural drift:** provide one repository validation entry point and concise contribution rules.
- **Public-data exposure:** inspect the complete staged diff before the first public push.

