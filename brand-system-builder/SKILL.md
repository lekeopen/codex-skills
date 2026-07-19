---
name: brand-system-builder
description: Use when establishing, upgrading, integrating, formalizing, freezing, or governing a brand system across its lifecycle, including new brands, existing brands, and brands being adopted by an existing website.
---

<!--
Status: Release Candidate: Ready; not published
Version: v1
Source Task: Task 04 · SKILL.md Design
-->

# Brand System Builder

## Purpose

Build and govern a brand as a coherent, traceable system across its lifecycle:

Audit → Foundation → Identity → Systemization → Application → Validation → Integration → Freeze → Maintenance.

The goal is not merely to produce a brand guide. The goal is to establish an approved brand system that people, design tools, software systems, content workflows, and AI agents can apply consistently.

## Scope

Use this skill for:

- Creating a new brand from incomplete or early-stage inputs.
- Upgrading an existing brand while preserving valuable recognition.
- Establishing a brand system around an existing product.
- Adopting an approved brand system into an existing website.
- Upgrading a brand and integrating it into an existing website.
- Auditing brand assets, rules, touchpoints, and implementations.
- Defining brand strategy, identity, voice, and experience principles.
- Systemizing approved decisions into reusable rules and design decisions.
- Defining application rules for prioritized touchpoints.
- Mapping brand rules to website pages, components, states, and design variables.
- Consolidating approved decisions into an authoritative specification.
- Planning migration, rollout, version freezing, governance, and maintenance.
- Reviewing brand consistency, drift, exceptions, and proposed evolution.

Do not use this skill as a substitute for:

- Business strategy or full market research.
- Large-scale customer or user research.
- Trademark registration or legal conclusions.
- Copyright, licensing, or regulatory guarantees.
- Advertising, public relations, or social media operations.
- Full UI/UX product design.
- Product feature development.
- Website engineering or unrelated technical refactoring.
- Bulk content, campaign, video, or production-asset creation.
- Unapproved production changes or external-system writes.
- Final approval by the brand owner or accountable decision-maker.

Identify adjacent work and define handoff requirements without absorbing it into the brand workflow.

## Operating Principles

1. Diagnose before designing.
2. Start from available evidence, not aesthetic assumptions.
3. Preserve useful recognition before proposing replacement.
4. Separate facts, assumptions, proposals, approvals, and frozen decisions.
5. Make decisions before deepening deliverables.
6. Never treat exploratory output as an approved brand asset.
7. Tailor the workflow without bypassing dependencies.
8. Record the source and version of every reused decision.
9. Test brand rules against realistic content and touchpoints.
10. Keep brand changes separate from product, UX, and engineering changes.
11. Require explicit approval at every applicable Approval Gate.
12. Maintain traceability from business intent to production adoption.
13. Prefer reversible changes and define migration or rollback requirements.
14. Treat the approved specification as the single source of truth.

## Project Paths

At project initiation, classify the work using actual conditions rather than the user's label.

| Path | Use when |
|---|---|
| `N` — New Brand | No mature brand system or durable brand recognition exists. |
| `U` — Brand Upgrade | A brand, product, audience recognition, or meaningful assets already exist and the brand system must be established or changed. |
| `W` — Website Adoption | A valid brand system exists and only adoption into an existing website is in scope. |
| `U+W` — Upgrade and Adoption | The brand system must change and the changed system must be adopted by an existing website. |

An existing product does not automatically mean the brand foundation is mature.

An existing website does not automatically place website adoption in scope.

If scope or evidence changes, reassess the path before proceeding.

## Workflow Statuses

Assign one status to every stage during Stage 00:

- `Required`: The stage must be performed.
- `Conditional`: Perform it when stated conditions apply.
- `Reuse`: Confirm and reuse an existing approved result.
- `Skip`: Omit it with an explicit reason.

`Reuse` is not an undocumented skip. Record:

- Reused stage.
- Source and version.
- Applicable scope.
- Reason it remains valid.
- Downstream impact.
- Required confirmation.

For every `Skip`, record:

- Skipped stage.
- Reason.
- Evidence supporting the decision.
- Downstream impact.
- Required confirmation.

## Approval Protocol

Approval must be explicit. Silence, vague feedback, preference, or continued conversation is not approval.

At each applicable Approval Gate:

1. State exactly what is awaiting approval.
2. Summarize the proposed decision and material risks.
3. Ask for explicit approval, revision, or rejection.
4. Stop progression until the response is unambiguous.
5. Record:
   - Approved content.
   - Approver.
   - Date or version when available.
   - Reservations or exceptions.
   - Downstream impact.

If revision is requested, remain in the current stage.

If approval is withheld or ambiguous, do not promote the output to formal status.

## Cross-Stage Validation

Cross-Stage Validation is mandatory. It is not a separate Stage and does not create an additional Approval Gate.

Perform it:

1. Before every Stage Exit.
2. Before every applicable G0–G9 decision.
3. Cumulatively before System Freeze at G7.
4. Cumulatively before Delivery Freeze at G9.
5. Whenever an approved upstream decision changes.

For the current Stage, verify:

- Traceability from approved inputs, decisions, and constraints.
- Completeness of in-scope requirements, assets, touchpoints, integrations, and exceptions.
- Consistency across strategy, identity, system rules, applications, integrations, and implementation mappings.
- Compliance with Scope and the approved Workflow tailoring.
- Approval integrity: only approved decisions are authoritative.
- Version integrity for referenced inputs, assets, specifications, and baselines.
- Readiness and clarity for the next applicable Stage.

Record the Stage, path, evidence, result, approved exceptions, affected Stages, and any required reapproval. Use one result:

- `Pass`.
- `Pass with Approved Exception`.
- `Fail`.

A Stage with a `Fail` result cannot exit or pass its Gate. An exception is valid only when its impact, owner, and approval are recorded.

When an approved upstream decision changes, mark dependent downstream outputs provisionally invalid and revalidate only the affected Stages and artifacts. Return conflicts to the Stage that owns the conflicting decision. Do not freeze at G7 or G9 while a blocking inconsistency or unapproved deviation remains.

## Standard Workflow

### Stage 00 — Project Initiation and Path Selection

Purpose: Confirm objectives, boundaries, project path, and workflow tailoring.

#### Input

- Project summary.
- Current brand, product, and website state.
- Business objective.
- Available materials and assets.
- Intended audiences and channels.
- Time, organizational, and delivery constraints.
- Known immutable conditions.

#### Output

- Project Brief.
- Selected path: `N`, `U`, `W`, or `U+W`.
- Stage tailoring table.
- Decision-makers and participants.
- In-scope and out-of-scope work.
- Initial success criteria.
- Risks and dependencies.

#### Exit Criteria

- Project path is determined.
- Every stage is marked `Required`, `Conditional`, `Reuse`, or `Skip`.
- Decision authority is known.
- No material ambiguity blocks the start.
- Every skipped stage has a reason.

#### Approval Gate G0

Explicitly approve:

- Project path.
- Scope.
- Workflow tailoring.
- Success criteria.

Do not continue without G0.

### Stage 01 — Discovery and Current-State Audit

Purpose: Establish the factual baseline and determine what should be retained, improved, or replaced.

#### Input

- Stage 00 outputs.
- Existing brand assets and documentation.
- Product interfaces or websites.
- Content samples.
- Audience, user, or business feedback.
- Relevant market or category references.
- Technical and channel constraints.

#### Output

- Current-State Audit.
- Brand asset inventory.
- Touchpoint inventory.
- Consistency and usability findings.
- Retain / improve / replace recommendations.
- Website-state summary for `W` and `U+W`.
- Missing information and risks.
- Reusable-asset conclusions.

#### Exit Criteria

- Major assets and touchpoints are covered.
- Facts, problems, preferences, and assumptions are distinguished.
- Existing assets have clear treatment recommendations.
- No major information gap prevents subsequent decisions.

#### Approval Gate G1

- `N`: Confirm the factual baseline; formal asset disposition is normally unnecessary.
- `U`, `W`, `U+W`: Explicitly approve the audit and retain / improve / replace boundaries.

### Stage 02 — Brand Strategy Foundation

Purpose: Define what the brand represents and the criteria governing subsequent decisions.

#### Input

- Project Brief.
- Current-State Audit.
- Business objectives.
- Audiences.
- Product or service value.
- Available market and category information.
- Existing strategy materials.

#### Output

As applicable:

- Core brand proposition.
- Audience definition.
- Positioning.
- Core value and differentiation.
- Brand attributes.
- Brand promise.
- Personality and voice principles.
- Strategic decision constraints.

Mark every conclusion as one of:

- Confirmed fact.
- Approved decision.
- Working assumption.
- Candidate direction.
- Recommendation.
- Open question.

#### Exit Criteria

- The system can answer who the brand serves, what value it provides, and why it should be chosen.
- Strategy can guide visual, verbal, and touchpoint decisions.
- Strategic statements do not materially conflict.
- Existing strategy is marked as reused, revised, or replaced.

#### Approval Gate G2

- `N`: Approve the complete strategy foundation.
- `U`: Approve all strategic changes.
- `W`: Confirm the reused strategy and version.
- Any path: Approve whenever strategy is established or materially changed.

### Stage 03 — Brand Creative Direction

Purpose: Translate approved strategy into candidate identity directions, evaluate their strategic fit and implications for retained assets, and select one direction for formal Identity Creation in Stage 04.

#### Input

- Approved strategy foundation.
- Audit conclusions.
- Assets that must be retained.
- Priority touchpoints.
- Channel, accessibility, and production constraints.
- References and prohibited directions.

#### Output

- Two or three materially different creative directions.
- Core concept for each direction.
- Visual and verbal principles.
- Relationship to approved strategy.
- Benefits, risks, and suitable contexts.
- Recommended direction.
- Explicitly excluded directions.
- Selected identity direction.
- Implications for existing identity assets.
- Preliminary retain / refine / replace decisions for `U` and `U+W`.
- Constraints Stage 04 must follow.

#### Exit Criteria

- Directions differ strategically, not only cosmetically.
- Every direction traces to approved strategy.
- Impact on existing assets is explained.
- One primary direction is selected.
- Remaining disagreements do not block system development.
- The selected direction is specific enough for Stage 04 to create the identity system.
- G3 approval is not treated as approval of final identity assets or rules.

#### Approval Gate G3

Approve one creative direction before creating or changing a core brand system.

For a pure `W` path, reuse or skip this stage unless a new direction is genuinely required. Reopening creative direction means the work may no longer be a pure `W` project and requires path reassessment.

### Stage 04 — Core Brand System

Purpose: Own and complete Identity Creation by developing the G3-approved direction into the coherent, reusable core identity system defined by the tailored scope.

#### Input

- Approved creative direction or confirmed reused system.
- G3 approval record and selected identity direction.
- Strategy foundation.
- Retained assets.
- Retain / refine / replace decisions for existing identity assets.
- Intended media and touchpoints.
- Accessibility, language, licensing, and technical constraints.

#### Output

As scoped:

- Created, revised, or explicitly retained identity assets.
- Relationships and rules that make the identity assets a system.
- Mark and logo-system principles.
- Color system.
- Typography system.
- Layout and hierarchy principles.
- Graphic, icon, illustration, image, or motion principles.
- Brand voice and foundational language rules.
- Core design tokens or equivalent design decisions.
- Correct-use and prohibited-use boundaries.
- Old-to-new asset mapping for `U` and `U+W`.
- Unresolved identity exceptions that must be resolved before G4.

Do not mark generated or exploratory assets as formal until approved.

#### Exit Criteria

- Core elements do not conflict.
- The system supports identified priority touchpoints.
- Critical rules do not depend on undocumented judgment.
- Retained assets are incorporated correctly.
- Upgrade changes can be clearly explained.
- Licensing, accessibility, and implementation risks are identified without presenting legal guarantees.
- Every in-scope identity element is created, revised, retained, or explicitly excluded.
- Every identity result traces to the G3-approved direction.
- Identity Creation is not complete before G4.

#### Approval Gate G4

- Approve the completed formal identity system and its new or upgraded core brand system.
- For `W`, explicitly confirm the reused system and approve any digital-medium additions or exceptions.

### Stage 05 — Application and Touchpoint Rules

Purpose: Demonstrate that the core system works with realistic content, define controlled adaptation, and own General Integration for in-scope non-website systems and touchpoints.

#### Input

- Core brand system.
- Touchpoint priorities.
- Realistic content samples.
- Channel and production constraints.
- Existing product or communication templates.
- Existing product, system, repository, template, interface, content-structure, and production constraints.
- Stage 01 retain / improve / replace assessment.

#### Output

As scoped:

- Priority-touchpoint rules.
- Representative applications.
- Content-density and hierarchy rules.
- Cross-channel adaptation principles.
- Template requirements.
- Boundary and exception cases.
- Explicitly excluded touchpoints.
- General Brand-to-Touchpoint Mapping.
- Retain / adapt / replace / exclude classification for each in-scope integration target.
- Shared integration rules and system-specific exceptions.
- Ownership and authoritative-source mapping.
- Website-specific work transferred to Stage 06.

General Integration may cover, when selected during Stage 00 tailoring:

- Design tools and design-token systems.
- Code repositories, frontend themes, and component libraries.
- CMS platforms and asset libraries.
- Document, presentation, and other operational templates.
- Content-production systems.
- AI prompts, brand contexts, and agent-consumable rules.
- Other non-website products, channels, and operational environments already within Scope.

#### Exit Criteria

- High-priority touchpoints have a defined application.
- The system remains usable with realistic content.
- Cross-medium variation is controlled.
- Uncovered cases can be resolved from documented principles.
- Every in-scope non-website integration target has an explicit disposition.
- Shared rules and system-specific exceptions are distinguishable.
- Integration does not expand into unrelated product, UX, or engineering work.
- Website-specific requirements are transferred to Stage 06 for `W` and `U+W`.

#### Approval Gate G5

Explicitly approve public, high-impact, or high-frequency touchpoint rules.

Lower-risk examples may be approved with the consolidated specification.

### Stage 06 — Website Brand Adoption

Purpose: Specialize the Stage 05 integration model for an existing website rather than merely replacing its logo, colors, or fonts. Stage 06 does not own non-website Integration.

#### Input

- Core brand system.
- Website audit.
- Website information architecture.
- Page, component, breakpoint, and state inventory.
- Existing design system and frontend constraints.
- Content, SEO, accessibility, performance, and compatibility requirements.
- CMS, third-party, and release constraints.

#### Output

- Brand-to-Web Mapping.
- Mapping from brand elements to website layers.
- Page and component impact matrix.
- Website design-variable mapping.
- Scope of voice and content changes.
- Retain / adjust / refactor classification.
- Migration priorities.
- Compatibility and adoption risks.
- Acceptance criteria for later implementation.

Keep brand adoption separate from:

- Product feature work.
- Unrelated information-architecture changes.
- Unrelated UX redesign.
- Engineering implementation.
- Deployment.

#### Exit Criteria

- Brand rules map clearly to website elements.
- Critical pages, components, breakpoints, and interaction states are included.
- Brand changes and product-experience changes are separated.
- Content, SEO, accessibility, performance, and release effects are identified.
- Adoption scope can enter execution planning independently.
- Website-specific conflicts return to the owning Stage 04 or Stage 05 decision instead of creating an unreconciled website-only brand rule.

#### Approval Gate G6

Mandatory for `W` and `U+W`.

Approve:

- Adoption scope.
- Retained and changed elements.
- Priorities.
- Technical constraints.
- Accepted risks.

Do not begin website implementation under this skill.

### Stage 07 — Brand Specification Consolidation

Purpose: Consolidate approved decisions into one authoritative brand-system specification and establish System Freeze at G7.

#### Input

- Approved stage outputs.
- Approval records.
- Exceptions.
- Asset and version information.
- Known omissions.

#### Output

- Brand System Specification.
- Decision summary.
- Rules and asset index.
- Usage boundaries.
- Exceptions and known limitations.
- Version and applicable scope.
- Future-extension list.
- Frozen system version identifier.
- Decision and exception register.
- Inventory of included and excluded assets.
- Approved deferred items.

#### Exit Criteria

- The specification matches approved decisions.
- Rules do not conflict.
- Formal rules and exploration materials are separated.
- Users can locate decisions and their applicable scope.
- Version and authoritative source are clear.
- Cross-Stage Validation has passed cumulatively through Stage 07.
- No unresolved blocking contradiction remains.
- Every formal rule and asset has a versioned source and owner.

#### Approval Gate G7

Approve System Freeze: the formal brand-system baseline containing the approved assets, rules, exceptions, version, and applicability.

G7 establishes the authoritative baseline but does not imply that deployment or migration has been approved.

After G7, changes require change control and reapproval at every affected existing Gate. Stages 08 and 09 must reference the G7 baseline version.

### Stage 08 — Rollout and Migration Planning

Purpose: Define how the current state will transition to the approved state.

#### Input

- Approved Brand System Specification.
- Touchpoint and website impact matrices.
- Legacy asset inventory.
- Organizational, supplier, and release constraints.
- Business-critical dates.

#### Output

- Rollout Plan.
- Migration stages.
- Legacy-asset coexistence and retirement rules.
- Priorities and dependencies.
- Release batches.
- Responsibilities.
- Risk, rollback, and exception principles.
- Objective release-readiness conditions.

#### Exit Criteria

- Every affected asset and touchpoint has a destination.
- New and old versions have clear coexistence boundaries.
- Dependencies and owners are identified.
- High-risk changes have rollback principles.
- Readiness can be judged objectively.

#### Approval Gate G8

Mandatory before public release or material migration.

For specification-only engagements, reduce this stage to a documented handoff recommendation without implying execution approval.

### Stage 09 — Delivery, Governance, and Continued Evolution

Purpose: Ensure the brand can be used, maintained, and evolved without hidden knowledge, then establish Delivery Freeze at G9.

#### Input

- Brand System Specification.
- Rollout Plan where applicable.
- Formal asset inventory.
- Organizational roles and maintenance constraints.
- Exceptions and open items.

#### Output

- Formal delivery inventory.
- Brand ownership and maintenance responsibility.
- Version-management rules.
- New-request and exception process.
- Change-record mechanism.
- Review triggers.
- Future-work recommendations.
- Delivery version identifier.
- Reconciliation against the G7 System Freeze baseline.
- Approved post-G7 changes.
- Open items explicitly excluded from the frozen delivery.
- Freeze date.
- Approval status and authority.
- Formal strategy and identity decisions.
- Formal assets and tokens.
- Implementation mappings.
- Known exceptions and limitations.
- Superseded versions.
- Dependencies and sources.
- Recovery or rollback baseline.

#### Exit Criteria

- Assets, specification, and version agree.
- Ownership and maintenance are explicit.
- New touchpoints have an extension process.
- Open work has an owner and status.
- The project can close without relying on implicit knowledge.
- The frozen baseline is identifiable, reproducible, verifiable, and reversible.
- Cross-Stage Validation has passed cumulatively through Stage 09.
- Delivery contents reconcile with the G7 baseline and approved change records.
- Governance ownership is active.

#### Approval Gate G9

Approve Delivery Freeze and handoff acceptance: the formal delivery, implementation mappings, governance ownership, and recovery or rollback baseline.

Future material changes must reopen the affected stages and Approval Gates.

## Default Stage Tailoring

| Stage | `N` | `U` | `W` | `U+W` |
|---|---|---|---|---|
| 00 Initiation | Required | Required | Required | Required |
| 01 Audit | Required | Required | Required | Required |
| 02 Strategy | Required | Conditional / Reuse | Reuse / Conditional | Conditional |
| 03 Direction | Required | Required | Conditional / Reuse | Required |
| 04 Core System | Required | Required | Reuse / Conditional | Required |
| 05 Touchpoints | Required | Required | Conditional | Required |
| 06 Website Adoption | Conditional | Conditional | Required | Required |
| 07 Consolidation | Required | Required | Required | Required |
| 08 Rollout | Conditional | Required | Required | Required |
| 09 Governance | Required | Required | Required | Required |

The defaults guide Stage 00. They do not replace project-specific path approval.

## Minimum Viable Workflow

Every project retains:

1. Stage 00 — Confirm path, scope, and tailoring.
2. Stage 01 — Establish sufficient factual evidence.
3. Stage 07 — Establish one authoritative version.
4. Stage 09 — Establish delivery and maintenance responsibility.

When reusing strategy, identity, rules, or assets, also record their source, version, approval status, and applicable scope.

## Stage Merging

Small projects may merge:

- Stage 00 + Stage 01.
- Stage 02 + Stage 03.
- Stage 04 + Stage 05.
- Stage 07 + Stage 09.

Merging does not remove any Input, Output, Exit Criteria, or applicable Approval Gate.

## Skip Rules

Skip a stage only when all are true:

- A trustworthy and applicable existing result is available.
- No new downstream decision depends on the stage.
- Skipping does not conceal material risk.
- The reason and impact are recorded.
- Required confirmation is obtained.

## Rollback Rules

Reopen only affected decisions:

- Material business-objective or audience change → Stage 02.
- Creative direction fails priority touchpoints → Stage 03.
- Core rules conflict under realistic use → Stage 04.
- Website constraints make adoption infeasible → Stage 04 or Stage 06.
- Material rollout-scope change → Stage 08.

Rollback does not mean restarting the entire project.

## Change Control

After an Approval Gate, record every proposed change with:

- Reason.
- Affected stages.
- Affected outputs and assets.
- Compatibility and migration impact.
- Required renewed approvals.
- Release or schedule impact.
- Rollback requirements.

Do not silently edit an approved or frozen decision.

## Scope-Control Rules

Stop or isolate requests that introduce:

- Product feature development.
- Website engineering.
- Unrelated UX or information-architecture redesign.
- Marketing execution.
- Unapproved large-scale content rewriting.
- Unscoped touchpoint production.
- Unapproved deployment or external-system modification.

Record such requests as possible follow-up work and define the required handoff.

## Completion Definition

The workflow is complete only when:

- Path and tailored scope were approved.
- Every included stage meets its Exit Criteria.
- Every applicable Gate has an explicit decision.
- Every reuse and skip is documented.
- Formal decisions are separated from exploration.
- The authoritative version is identifiable.
- Delivery and maintenance responsibility are explicit.
- Open work is not represented as complete.
- Future extensions have a defined entry point.

Report:

- Completed path and stages.
- Approval status for G0–G9.
- Reused and skipped stages.
- Frozen or current specification version.
- Known exceptions and unresolved risks.
- Out-of-scope follow-up work.
- Maintenance owner and next review trigger.
