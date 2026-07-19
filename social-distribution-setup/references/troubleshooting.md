# Troubleshooting

## New Website Article Did Not Post

Check in order:

1. Deployed RSS contains the article.
2. RSS item has stable `guid`, valid `pubDate`, and `link`.
3. Make scenario is active.
4. Make history has scheduled runs after the article publication time.
5. Make account has credits and is not paused.
6. RSS module maximum returned items is not `1`.
7. Destination modules are connected and not failing.

## Make Has No Recent Runs

Likely causes:

- Scenario is off.
- Scenario is paused because limits were exceeded.
- Schedule was changed but not saved.
- Workspace/account plan has no remaining credits.

## Make Says Free Plan Limit Was Reached

This usually means credits are exhausted, not data transfer. Frequent polling consumes credits even when no content is posted.

Mitigation:

- Change schedule to daily.
- Keep RSS maximum returned items around `10`.
- Wait for monthly quota reset or upgrade Make.

## Only One Article Posted

Most likely RSS `Maximum number of returned items` is `1`. Set it to `10`.

Also check whether the RSS feed still includes all missed articles and whether Make already marked some items as seen.

## Will Missed Items Post Later?

Usually yes only if:

- RSS still contains those items.
- Make has not already marked them as consumed.
- The module returns enough items in one run.

For guaranteed backfill, run a controlled replay or manually publish the missed items.

## X Did Not Post

Check:

- Buffer account is connected.
- Correct X profile is selected.
- Buffer queue is not paused.
- Text length is within platform limits.
- Buffer did not reject the post due to duplicate content or authorization issues.
