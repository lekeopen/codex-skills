# RSS Requirements

## Required Item Fields

Each RSS item should include:

- `title`: readable post title
- `link`: canonical URL for the article
- `guid`: stable unique identifier, usually the canonical URL
- `pubDate`: valid RFC-compatible publication date
- `description`: short summary for social captions

Optional but useful:

- `category`
- `enclosure` image URL and MIME type

## Stability Rules

- Keep `guid` stable after first publication.
- Do not generate a new `guid` on every build.
- Use absolute links in deployed feeds.
- Sort newest first.
- Keep enough recent items in the feed for Make to catch up after a pause.

## Common Problems

- Missing `pubDate`: Make may fail to detect ordering reliably.
- Changing `guid`: platforms may repost old content.
- `Maximum number of returned items = 1`: only one item can be processed per run.
- RSS generated locally but not deployed: Make sees the old feed.
