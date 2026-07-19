# Codex Skills Repository Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish two normalized, validated Codex skills in the public `lekeopen/codex-skills` repository and establish a maintainable structure for future skills.

**Architecture:** Keep every skill self-contained in a top-level directory and keep repository governance, discovery, licensing, and validation at the root. Use dependency-free shell and Node.js checks so contributors can validate the repository without installing a project runtime.

**Tech Stack:** Markdown, YAML, POSIX shell, Node.js ESM, Git, GitHub CLI.

## Global Constraints

- Preserve the behavior and scope of both existing skills.
- Add future skills as sibling directories; do not create a separate repository per skill by default.
- Keep each skill self-contained and independently valid.
- Avoid repository-wide dependencies that every skill must install.
- Publish the repository publicly as `lekeopen/codex-skills` under a permissive license.
- Never commit secrets, account credentials, generated private artifacts, or environment-specific paths.

---

### Task 1: Establish repository validation contract

**Files:**
- Create: `scripts/validate-skills.sh`
- Create: `tests/fixtures/valid-rss.xml`
- Create: `tests/fixtures/valid-publish-queue.json`
- Create: `tests/validate-repository.sh`

**Interfaces:**
- Consumes: top-level directories containing `SKILL.md`.
- Produces: `scripts/validate-skills.sh`, an exit-code based validation entry point; fixture files consumed by script checks.

- [ ] **Step 1: Write the failing repository test**

Create `tests/validate-repository.sh` that requires both known skill directories, their `agents/openai.yaml` files, valid YAML frontmatter, a root README and license, and successful syntax and fixture runs for every bundled `.mjs` script.

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/validate-repository.sh`

Expected: non-zero exit because root metadata, `brand-system-builder/agents/openai.yaml`, and the validation entry point do not yet exist.

- [ ] **Step 3: Add the minimal validation entry point and fixtures**

Implement `scripts/validate-skills.sh` to discover `*/SKILL.md`, check required companion metadata, reject forbidden skill-local release files, run `node --check` for `.mjs`, and exercise the social distribution inspectors with deterministic fixtures.

- [ ] **Step 4: Run the focused validation contract**

Run: `bash tests/validate-repository.sh`

Expected: it still fails only on repository and skill normalization files that Task 2 creates; the shell itself must parse successfully with `bash -n`.

### Task 2: Normalize both skills and repository metadata

**Files:**
- Create: `README.md`
- Create: `LICENSE`
- Create: `CONTRIBUTING.md`
- Create: `.gitignore`
- Create: `brand-system-builder/agents/openai.yaml`
- Modify: `brand-system-builder/SKILL.md`
- Modify: `social-distribution-setup/agents/openai.yaml`
- Delete: `brand-system-builder/README.md`
- Delete: `brand-system-builder/CHANGELOG.md`
- Delete: `brand-system-builder/RELEASE_CHECKLIST.md`
- Delete: `brand-system-builder/VERSION`
- Delete: `brand-system-builder/docs/release-report-v1.0.md`
- Review and retain only runtime-relevant files under `brand-system-builder/docs/`.

**Interfaces:**
- Consumes: the existing skill instructions and the validation contract from Task 1.
- Produces: two independently discoverable skill packages and a public repository index.

- [ ] **Step 1: Capture pre-change behavior and structure**

Run: `find brand-system-builder social-distribution-setup -type f -maxdepth 3 -print | sort` and save the output in the task log, not the repository.

Expected: inventory includes both skill instructions, social scripts/resources, and brand release-process artifacts.

- [ ] **Step 2: Normalize skill metadata**

Remove development-status comments from `brand-system-builder/SKILL.md`, add `brand-system-builder/agents/openai.yaml`, and regenerate or review both `agents/openai.yaml` files so their display names, 25–64 character descriptions, `$skill-name` default prompts, and implicit-invocation policy match the final skills.

- [ ] **Step 3: Separate repository documentation from skill runtime content**

Create the root README with a two-skill index, per-skill installation examples, validation command, and future-skill directory convention. Add MIT license text, concise contribution rules, and ignores for OS/editor artifacts. Remove brand-local release narration; retain only references directly needed at runtime and link retained references from `SKILL.md`.

- [ ] **Step 4: Run the repository test**

Run: `bash tests/validate-repository.sh`

Expected: exit 0 with both skill names reported and all Node.js fixture checks passing.

### Task 3: Validate behavior and public-push safety

**Files:**
- Modify as needed: files identified by validation failures only.

**Interfaces:**
- Consumes: normalized repository from Tasks 1–2.
- Produces: fresh validation evidence and an inspected public diff.

- [ ] **Step 1: Run official skill validation**

Run the bundled `quick_validate.py` once for each skill directory.

Expected: both commands exit 0 and report valid skills.

- [ ] **Step 2: Run repository validation**

Run: `bash scripts/validate-skills.sh`

Expected: exit 0, two skills discovered, all metadata and scripts accepted.

- [ ] **Step 3: Inspect all public content for secrets and machine-specific paths**

Run: `rg -n "(api[_-]?key|secret|token|password|/Users/|BEGIN .*PRIVATE KEY)" --glob '!docs/superpowers/**' .`

Expected: no credentials or private local paths; ordinary instructional mentions of secrets are reviewed manually and accepted only when non-sensitive.

- [ ] **Step 4: Review the complete pending diff**

Run: `git status -sb` and `git diff --check`; after staging, run `git diff --cached --stat` and `git diff --cached --check`.

Expected: only intended repository files, no whitespace errors.

### Task 4: Initialize and publish the public repository

**Files:**
- Create through Git: `.git/` metadata and `origin` remote configuration.

**Interfaces:**
- Consumes: validated repository and authenticated GitHub CLI session.
- Produces: public `https://github.com/lekeopen/codex-skills` on default branch `main`.

- [ ] **Step 1: Verify GitHub prerequisites**

Run: `gh --version`, `gh auth status`, and `gh api orgs/lekeopen --jq .login`.

Expected: GitHub CLI is installed, authenticated, and the organization is accessible.

- [ ] **Step 2: Initialize Git and stage the reviewed repository**

Run: `git init -b main`, then stage only the reviewed paths explicitly.

Expected: branch is `main`; staged diff matches Task 3.

- [ ] **Step 3: Commit the initial public release**

Run: `git commit -m "publish initial Codex skills"`.

Expected: one root commit containing the validated repository.

- [ ] **Step 4: Create and push the public GitHub repository**

Run: `gh repo create lekeopen/codex-skills --public --source=. --remote=origin --push`.

Expected: repository is created, `origin` points to `lekeopen/codex-skills`, and `main` tracks `origin/main`.

- [ ] **Step 5: Verify the remote publication**

Run: `gh repo view lekeopen/codex-skills --json nameWithOwner,visibility,url,defaultBranchRef` and `git status -sb`.

Expected: `nameWithOwner` is `lekeopen/codex-skills`, visibility is public, default branch is `main`, and the working tree is clean.

### Task 5: Record the durable project decision

**Files:**
- No repository changes.

**Interfaces:**
- Consumes: verified remote publication result.
- Produces: one Knowledge OS decision recording the repository convention.

- [ ] **Step 1: Save the confirmed convention**

Run the Lezhi Bridge `remember` command with type `decision`, source `user_confirmed`, project `codex-skills`, and content stating that future reusable Codex skills are developed as sibling directories in the public `lekeopen/codex-skills` repository.

Expected: success or `duplicate=true`; no sensitive data is included.

