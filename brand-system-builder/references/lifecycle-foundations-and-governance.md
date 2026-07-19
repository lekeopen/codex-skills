# Lifecycle Foundations and Governance

Use this reference while completing Stage 02, Stage 04, Stage 09, and post-approval change control. Apply every item that is relevant to the tailored scope; explicitly mark reused, deferred, or excluded items rather than omitting them silently.

## Brand foundation contract

Turn abstract strategy into an actionable decision foundation. Establish, confirm, revise, or explicitly exclude:

- Purpose: why the brand exists.
- Vision: the future state it intends to help create.
- Mission: what it does to pursue that vision.
- Core values and principles: the standards that constrain behavior and decisions.
- Target audiences, positioning, differentiation, value proposition, and brand promise.
- Personality and the qualities the brand must consistently express.
- Core narrative and message hierarchy.
- Naming meaning and semantics.
- Brand architecture, including relationships among the parent brand, products, services, and sub-brands.
- Negative boundary: what the brand is not and must not become.

Do not promote unsupported foundation statements to approved decisions. Mark evidence level and approval status using the Stage 02 state model.

## Identity coverage contract

Identity Creation must cover the applicable visual, verbal, and experience dimensions as one coherent system.

### Visual identity

Establish or explicitly disposition:

- Logo concept, primary and secondary marks, symbols, and their relationships.
- Color, typography, layout, hierarchy, shape, and graphic language.
- Icon, illustration, photography, image, and motion style.
- Spatial and composition principles, distinctive recognition elements, and prohibited visual territory.

### Verbal identity

Establish or explicitly disposition:

- Brand voice, tone, vocabulary, and terminology rules.
- Message hierarchy, taglines, and core expressions.
- Context-specific tone variations.
- Positive examples, counterexamples, and prohibited expressions.
- Boundaries for AI-generated brand content.

### Experience identity

Define:

- The intended overall feeling of the brand.
- How the brand behaves at priority touchpoints.
- How visual, verbal, and interaction behavior remain consistent.
- How personality becomes observable experience.
- Which experience characteristics must remain stable across channels and versions.

Generated or exploratory identity work remains provisional until the applicable Gate explicitly approves it.

## Production maintenance contract

Treat production delivery as the start of governed maintenance, not the end of brand-system work.

Continuously manage:

- New touchpoints and assets entering the system.
- Consistency reviews and design-to-code drift detection.
- Design-token changes and synchronization with specifications and implementations.
- Template updates, outdated-asset detection, exceptions, and corrective fixes.
- Minor-version improvements, major-version evolution, and brand refreshes.
- Sub-brand creation or extension and brand mergers, splits, or retirement.
- Impact, compatibility, migration, rollback, and retained-history requirements.

For every downstream design tool, codebase, token set, component library, template, CMS, content system, or AI context, record the frozen brand-system version it consumes. Reconcile consumers after approved changes and identify lagging implementations as drift.

## Change classification

Classify every proposed or observed maintenance change before acting:

1. **Core-preserving correction**: fixes an error or inconsistency without changing brand recognition; use the smallest affected approval path.
2. **Incremental extension**: adds a touchpoint, asset, sub-brand, or capability while preserving the core; validate compatibility and reopen affected Stages and Gates.
3. **Major evolution**: changes positioning, architecture, identity, or recognition; reassess the project path and reopen all dependent decisions.
4. **Temporary exception**: time-bounded, owned, explicitly approved, and recorded with expiry and reconciliation conditions.
5. **Rejected drift**: an unapproved deviation that must not become precedent; correct it against the frozen baseline.

## State validity and consumer tracking

In addition to the workflow's fact, decision, assumption, candidate, recommendation, and open-question states, distinguish:

- **Frozen**: approved content or assets included in the current authoritative baseline.
- **Deprecated**: superseded content or assets prohibited for new use but retained for traceability, migration, rollback, or legacy consumers.

For each material decision and asset, record:

- Source and rationale.
- Approval and frozen-version status.
- Whether it remains valid, including review or expiry conditions.
- Superseding decision or asset when deprecated.
- Every known downstream consumer and its adopted version.
- Owner, migration state, and retirement criteria where applicable.

Never silently edit frozen decisions or erase deprecated records while an active consumer, migration, audit, or rollback requirement depends on them.
