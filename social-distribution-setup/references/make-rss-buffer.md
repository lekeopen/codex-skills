# Make RSS + Buffer Reference

## Standard Scenario

Use this structure for low-frequency website updates:

1. `RSS > Watch RSS feed items`
2. `Router`
3. `Facebook Pages > Create a Post`
4. `LinkedIn > Create a Company Text Post`
5. `Buffer > Create a status update` for X
6. Optional `Email > Send an Email`

## RSS Module

Recommended settings:

- URL: deployed RSS URL, for example `https://example.com/rss.xml`
- Maximum number of returned items: `10`

If this is `1`, a daily run can process only one new item. Use `10` for normal sites that may publish multiple articles in a day.

## Schedule

Recommended:

- `At regular intervals`
- `Every 1 day`

Avoid `Every 15 minutes` on Make Free. It can consume about 96 trigger checks per day even when no article is published.

## X Through Buffer

Use Buffer when direct X/Twitter modules are unavailable, unstable, or require paid developer access.

Posting template:

```text
{{title}}

{{description}}

Read more: {{link}}
```

For X, use a shorter version if descriptions are long:

```text
{{title}}

{{link}}
```

## Expected Behavior

When Make detects multiple new RSS items and `Maximum number of returned items` allows it, the trigger emits multiple bundles in one run. Each bundle should pass through the router and post to each enabled destination.
