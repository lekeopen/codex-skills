---
name: wechat-webview-font-sizing
description: Use when a responsive website looks enlarged, old-age-mode-like, reflowed, clipped, or inconsistent inside the WeChat embedded browser, especially when ordinary mobile browsers render correctly or CSS text-size-adjust changes do not survive production builds.
---

# WeChat WebView Font Sizing

## Purpose

Diagnose WeChat-controlled H5 font scaling and make the layout resilient to the user's selected text size. Use selective font normalization only when the product owner explicitly approves the accessibility trade-off. Treat real iOS and Android WeChat tests as the acceptance authority.

## Workflow

1. Inspect the shared layout, viewport meta, global CSS, build pipeline, and existing mobile tests.
2. Reproduce with the same URL, device, WeChat account, and WeChat font-size setting. A normal Chrome mobile preview is not equivalent to WeChat.
3. Inspect the built or deployed HTML. Do not assume source CSS survived minification or prefix optimization.
4. Adapt wrapping, scrolling, container sizing, and spacing first. Read [references/implementation.md](references/implementation.md) when selective non-scaling is justified for specific content.
5. Add regression tests for the chosen policy, checking both source and final build output when declarations or bridge calls are required.
6. Run the project's unit tests, type checks, production build, and mobile E2E tests.
7. Deploy only with explicit authorization. Verify the live HTML, then ask the user to close the old WeChat page and reopen the link.
8. Record iOS and Android results separately. Do not call the fix complete from Chrome emulation alone.

## Decision Rules

- Start with a responsive viewport: `width=device-width, initial-scale=1, viewport-fit=cover`.
- Keep pinch zoom enabled; never add `user-scalable=no` or `maximum-scale=1`.
- Default to allowing text and related content to scale, with layouts that wrap, grow, and scroll without clipping or overlap.
- For selectively non-scaling content on iOS WeChat, place both text-size-adjust declarations on `body` in CSS that the production build preserves, then implement the approved business-level sizing policy.
- For selectively non-scaling content on Android WeChat, use `WeixinJSBridgeReady`, `setFontSizeCallback`, and `menu:setfont` as documented by WeChat. Treat resetting on every menu event as an explicit product policy, not an official accessibility default.
- If the framework removes `-webkit-text-size-adjust`, use an unprocessed inline style or configure the CSS build target; verify the artifact.
- Do not copy a fixed 1280/1320px news-site layout into a responsive product merely because it visually resists font scaling.
- Adapt layout to scaled content unless a documented, product-approved exception requires selective normalization.

## Failure Diagnosis

| Symptom | Likely cause | Check |
|---|---|---|
| Works in Safari/Chrome, fails in WeChat | WeChat font setting, not browser autosizing | Real WeChat test and bridge availability |
| Source has WebKit prefix, production does not | CSS optimizer removed it | Generated HTML/CSS and deployed asset |
| iOS still enlarges | Rule targets `html` or is overridden | Computed `body` declaration and `!important` |
| Android still enlarges | Bridge never ran or menu reset it | Ready event, immediate path, and `menu:setfont` listener |
| Page flashes large then normal | Bridge becomes available after first paint | Expected bridge timing; minimize but do not hide content blindly |

## Safety

Explain that forcing the default WeChat font level overrides a user's chosen large-text preference. Prefer resilient large-text layouts for accessibility-critical or regulated services.
