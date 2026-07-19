---
name: social-distribution-setup
description: Use when setting up, reusing, or debugging RSS-driven multi-platform social distribution for websites, especially Make.com scenarios that read RSS or publish queues and post to Facebook Pages, LinkedIn, Email, and X through Buffer. Also use when checking why new website content was not automatically shared, why only one RSS item was posted, whether Make.com limits paused a scenario, or how to make this workflow reusable across projects.
---

# Social Distribution Setup

## Purpose

Help a project expose reliable content sources and connect them to a low-maintenance social distribution workflow. The preferred baseline is: website generates RSS, Make.com polls RSS on a conservative schedule, Router fans out to social modules, and Buffer handles X.

This skill does not directly authorize or post to third-party accounts unless the user explicitly asks and authorizes that side effect.

## Default Architecture

Use this architecture unless the project clearly has different needs:

1. Website builds `public/rss.xml` from published content.
2. Optional `publish-queue.json` tracks intended channels and pending items.
3. Make.com uses `RSS > Watch RSS feed items` as the trigger.
4. Router sends each RSS bundle to enabled destinations:
   - Facebook Pages
   - LinkedIn Company Page
   - Buffer for X
   - Email, if needed
5. Make schedule is daily by default.

Recommended Make settings:

- Run scenario: `At regular intervals`
- Interval: `Every 1 day` or `1440` minutes
- RSS `Maximum number of returned items`: `10`
- Avoid 15-minute polling on Make Free unless the user accepts the credit cost.

## Workflow

### 1. Inspect the project source

Look for content sources and existing automation:

```bash
rg -n "rss|publish-queue|social|buffer|make|x" .
rg --files | rg "rss|publish-queue|content|news|docs"
```

If the project has an RSS feed, run:

```bash
node <skill>/scripts/inspect_rss.mjs public/rss.xml
```

For a deployed feed:

```bash
node <skill>/scripts/inspect_rss.mjs https://example.com/rss.xml
```

If the project has a publish queue, run:

```bash
node <skill>/scripts/inspect_publish_queue.mjs publish-queue.json
```

### 2. Verify RSS readiness

RSS items should have:

- Stable `guid`
- Absolute or resolvable `link`
- Valid `pubDate`
- Human-readable `title`
- Useful `description`

Read `references/rss-requirements.md` when RSS structure is missing, unstable, or generated from markdown/frontmatter.

### 3. Configure or audit Make.com

Use `references/make-rss-buffer.md` when creating or checking the scenario.

Minimum checks:

- Scenario is active, not paused.
- History shows scheduled runs after the last edit.
- RSS URL is the deployed URL, not localhost.
- RSS maximum returned items is higher than `1`; use `10` for normal low-volume sites.
- Schedule is daily unless the user needs faster distribution.
- Buffer route is used for X if direct X modules are unreliable or unavailable.

### 4. Diagnose failures by evidence

Use `references/troubleshooting.md` when the user reports:

- New article did not post.
- Make has no recent runs.
- Make says limits were exceeded.
- Only one item was posted.
- X/Buffer did not post.
- The user asks whether missed items will be backfilled.

Do not guess. Check the RSS, Make history, module settings, and platform connection state when available.

### 5. Generate project notes

For a new project, generate a setup note:

```bash
node <skill>/scripts/generate_make_notes.mjs \
  --site https://example.com \
  --rss https://example.com/rss.xml \
  --platforms facebook,linkedin,x,email
```

Use `assets/make-scenario-checklist.md` and `assets/social-post-template.md` as reusable output templates.

## Safety Rules

- Do not click Make `Run once` if it may publish content unless the user explicitly authorizes it.
- Do not store API keys, OAuth secrets, access tokens, or Buffer credentials in generated docs.
- Prefer daily polling on free Make plans to avoid credit exhaustion.
- If the user needs guaranteed backfill, propose a deliberate replay plan instead of assuming Make will post old items.
- For WeChat, Xiaohongshu, Douyin, or other high-friction platforms, state that first-party API authorization and content review constraints make them out of scope for the baseline workflow.

## When to Recommend a Bigger System

Recommend moving beyond Make/Buffer only if the user needs:

- Per-platform publishing state and audit logs.
- Guaranteed retries and idempotency across platforms.
- Approval workflows.
- Multiple brands/projects with centralized governance.
- Direct API integrations instead of no-code connectors.

Otherwise, keep the Make/RSS/Buffer workflow.
