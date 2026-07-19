# Brand System Builder

Brand System Builder is a Codex skill for establishing, upgrading, integrating, formalizing, freezing, and governing a brand system across its lifecycle.

**Release:** v1.0.0  
**Status:** Released  
**Release date:** 2026-07-19

## Contents

- `SKILL.md` — the skill entry point and operating instructions.
- `VERSION` — the authoritative package version marker.
- `CHANGELOG.md` — release history.
- `RELEASE_CHECKLIST.md` — release gates and final package manifest.
- `docs/scope.md` — approved lifecycle scope.
- `docs/workflow.md` — approved workflow and revisions.
- `docs/test-scenarios.md` — approved validation scenarios.
- `docs/validation-v1.md` — retained validation and release-review history.
- `docs/release-report-v1.0.md` — v1.0 release record.

## Installation

Install the complete `brand-system-builder` directory in a Codex skills directory. The directory name must remain `brand-system-builder`, matching the `name` field in `SKILL.md`.

Example for a personal installation:

```bash
mkdir -p "$CODEX_HOME/skills"
cp -R /path/to/brand-system-builder "$CODEX_HOME/skills/brand-system-builder"
```

Restart Codex or begin a new task after installation so the skill catalog is refreshed. Confirm that `brand-system-builder` appears in the available skills list before relying on it.

## Usage

Invoke the skill by name or ask Codex for work that matches its trigger, for example:

```text
Use brand-system-builder to establish a brand system for this existing product.
```

The skill begins with project initiation and path selection. It requires explicit approval at applicable gates and does not authorize production changes, external writes, website engineering, or other out-of-scope implementation work.

Before production use, provide the relevant business context, existing assets, intended touchpoints, decision authority, constraints, and expected delivery boundary.

## Release boundary

Version 1.0 preserves the approved Scope, Workflow, Test Scenarios, and `SKILL.md` without release-stage modification. No v1.1 work is included.
