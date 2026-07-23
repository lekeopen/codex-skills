---
name: evaluating-open-source-tools
description: Use when a user asks what an open-source project does, whether it is useful, whether to adopt it, or requests a practical test of a GitHub repository, CLI, plugin, framework, AI tool, or developer utility.
---

# Evaluating Open Source Tools

## Purpose

Produce an evidence-backed adoption verdict with the smallest test that can answer the user's real question. Reuse installed tools and existing capabilities before adding another dependency.

## Workflow

### 1. Define the decision

Identify the user's intended job, current alternative, production sensitivity, and acceptable test depth. If unstated, assume they want a low-risk evaluation, not installation into a live repository.

Default to a 30–60 minute evaluation: current-source orientation, one isolated smoke test, one core-value check, and a verdict. Expand into repeated benchmarks, red-team testing, or multi-day trials only when the user is making a material production-adoption decision and the earlier stages leave it unresolved.

### 2. Orient from primary sources

Check the repository, official documentation, package registry, releases, recent commits, issue tracker, license, supported platforms, and runtime requirements. Resolve renames, package aliases, and stable versus prerelease channels.

Separate:

- claimed capability;
- implemented and documented capability;
- capability verified in this evaluation.

Do not use stars, benchmark claims, or README breadth as proof of usefulness.

### 3. Check existing coverage

Compare the tool with capabilities already available in the user's stack. Prefer extending or reusing an existing Skill, plugin, CLI, framework, or automation when it already covers the job adequately.

State the unique value the candidate would need to prove. Stop with `skip` when it only duplicates existing behavior with more operational cost.

### 4. Test in stages

Use a temporary directory, disposable worktree, container, or test account. Never begin with a production repository, real secrets, or `curl | shell`.

Run only as deep as needed:

1. **Artifact check:** inspect package metadata, lifecycle scripts, dependency surface, and files the initializer may write.
2. **Smoke test:** run version, help, diagnostics, initialization, and cleanup using the user's normal installation path.
3. **Core-value test:** execute the smallest workflow that proves the claimed differentiator.
4. **Integration test:** compare against the current approach only when the smoke and core-value tests pass.

Pin a version for repeatable tests. Record the tested commit, package version, environment, commands, duration, and notable side effects.

After each stage, ask whether another stage could change the verdict. Stop when it could not.

### 5. Interpret failures correctly

Distinguish:

- host environment failures;
- installation or packaging failures;
- configuration or credential gaps;
- project defects;
- documented limitations;
- unverified claims.

Do not credit commands that only register metadata as successful execution. Confirm resulting state through an independent status read, generated artifacts, tests, or observable behavior.

### 6. Assess adoption risk

Review:

- files and global configuration modified;
- permissions and command allowlists added;
- network, telemetry, and external model use;
- storage, encryption, deletion, and cross-project isolation;
- mutable references such as `latest`;
- upgrade, rollback, uninstall, and abandoned-state behavior;
- maintenance concentration, issue quality, release stability, and license.

For agent harnesses and MCP tools, also check prompt-injection boundaries, tool permissions, memory leakage, daemon behavior, and model cost.

### 7. Stop and decide

Stop when the evidence supports one verdict:

- **adopt:** clear recurring value, stable operation, and acceptable risk;
- **limited pilot:** useful differentiator, but needs bounded real-world validation;
- **observe:** promising, but maturity or version churn is too high;
- **skip:** duplicated value, failed core workflow, or disproportionate cost/risk.

Do not expand into exhaustive red-team or repeated benchmark work unless the decision remains material and uncertain after the staged tests.
Do not invent numeric scores or acceptance thresholds unless the user requests a formal comparison or the project already defines them.

## Output

Keep the report compact:

1. What it is and what it can actually do.
2. Test environment and tested version.
3. Passed, failed, and not tested.
4. Side effects and production risks.
5. Fit against the user's existing stack.
6. Verdict and the smallest next step.

Label all conclusions as `observed`, `documented`, or `inferred`. Never imply a paid-model or production integration test ran when it did not.
