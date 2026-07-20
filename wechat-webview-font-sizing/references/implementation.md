# Implementation Reference

## Official scope and default

The cited WeChat Pay guidance applies to merchant checkout H5 pages. Its default expectation is that text, icons, images, containers, and components scale with the user's font setting. First make the page wrap, grow, and scroll without overflow, overlap, or obstruction.

For specific content that is already large enough or cannot safely scale, the guidance documents two platform controls as part of a selective non-scaling implementation:

- iOS: apply `-webkit-text-size-adjust: 100% !important` and `text-size-adjust: 100% !important` to `body`.
- Android: after `WeixinJSBridgeReady`, invoke `setFontSizeCallback` with default level `2`, then listen for `menu:setfont` and adapt business styles from the reported font level or scale.

The official sample does not require resetting every later `menu:setfont` event to level `2`. Doing so is a stricter product decision that overrides the user's chosen WeChat font size and must be justified explicitly.

Source: https://pay.wechatpay.cn/doc/v2/partner/4011937062

## Selective non-scaling markup

Use this only after the product owner approves which content will not scale and why. It is not the default for an entire responsive product.

```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">

<style>
  body {
    -webkit-text-size-adjust: 100% !important;
    text-size-adjust: 100% !important;
  }
</style>

<script>
  function normalizeWeChatFontSize() {
    if (typeof WeixinJSBridge !== 'object' ||
        typeof WeixinJSBridge.invoke !== 'function') return;

    WeixinJSBridge.invoke('setFontSizeCallback', { fontSize: '2' });
    WeixinJSBridge.on('menu:setfont', ({ fontSize, fontScale }) => {
      document.documentElement.dataset.wechatFontSize = String(fontSize || '');
      document.documentElement.dataset.wechatFontScale = String(fontScale || '');
    });
  }

  document.addEventListener(
    'WeixinJSBridgeReady',
    normalizeWeChatFontSize,
    false
  );
  normalizeWeChatFontSize();
</script>
```

Frameworks may transform `<style>` blocks. Use their unprocessed-inline mechanism when necessary, then inspect the production artifact for the literal WebKit declaration.

If the product owner explicitly approves forcing the default level, the menu listener may call `setFontSizeCallback` again. Record that accessibility trade-off and verify it on both platforms; do not present it as the official default behavior.

## Acceptance matrix

Test at minimum:

| Platform | WeChat font | Pages |
|---|---|---|
| iOS | Standard and one larger level | Home, article, navigation |
| Android | Standard and one larger level | Home, article, navigation |
| Mobile Safari/Chrome | Default | Home and article |

Check text size, wrapping, clipping, navigation usability, pinch zoom, and any visible large-to-normal flash. For WeChat Pay checkout pages, also verify the official acceptance expectations at large font settings; do not generalize checkout-specific thresholds to unrelated products without confirming their requirements.
