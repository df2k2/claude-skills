<!-- source: https://docs.hyva.io/hyva-themes/performance/hyva-performance-tips.html -->

# Hyvä Performance Tips

These optimizations cover Magento configuration, images, JavaScript and Alpine.js, CSS patterns, and DOM size.

## Magento configuration

### Restrict allowed countries

Magento includes all countries in its directory JSON payload by default. This payload is loaded on every page that includes address forms or checkout. Restricting the list to the countries your store actually ships to can reduce this payload significantly.

Configure it in the Magento admin under `Stores → Configuration → General → General → Country Options → Allow Countries`.

## Images

Images are typically the largest payloads on any storefront page. Hyvä gives you full control over image markup in `.phtml` templates, so these improvements are straightforward to apply.

### Use lazy loading

Add `loading="lazy"` to every image that is not visible on initial load. Do not apply it to the LCP image (typically the hero or main product image), as that image should load as early as possible.

```
<img src="product.jpg" loading="lazy" width="400" height="400" alt="Product">
```

### Always set width and height

Set explicit `width` and `height` attributes on every image. Without them, the browser cannot reserve the correct amount of space before the image loads, which causes layout shift and hurts your CLS score.

### Use modern image formats

Serve images in WebP or AVIF where possible. Both formats produce significantly smaller files than JPEG or PNG at comparable visual quality. Use a `<picture>` element to provide a fallback for older browsers.

```
<picture>
  <source srcset="image.avif" type="image/avif">
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" width="800" height="600" alt="Product image">
</picture>
```

Automate image optimisation with Hyvä Commerce

[Hyvä Commerce Media Optimisation](../../hyva-commerce/features/media-optimization/index.html) can resize, compress, and convert images to WebP or AVIF across your entire storefront automatically, including images in CMS content and CSS, without touching any templates.

### Never use GIFs for animation

GIFs are large, CPU-intensive to decode, and cannot be lazy-loaded efficiently. Replace any animated GIF with a `<video>` element using the `autoplay`, `loop`, `muted`, and `playsinline` attributes. The visual result is identical, and the file size is typically 80 to 95 percent smaller.

```
<video autoplay loop muted playsinline width="800" height="450">
  <source src="animation.webm" type="video/webm">
  <source src="animation.mp4" type="video/mp4">
</video>
```

## JavaScript and Alpine.js

### Use `x-defer` for off-screen components

Components below the fold do not need to initialize when the page loads. Adding `x-defer="intersect"` delays initialization until the element is near the viewport, reducing main thread work during page load.

Be selective. Adding `x-defer` to every component on a page can increase main thread blocking time rather than reduce it. Test the impact on the specific pages where you apply it.

For more information, see the [`x-defer` documentation](../working-with-alpinejs/alpine-plugins/x-defer.html).

### Defer third-party scripts until user interaction

Third-party scripts such as analytics tags, tracking pixels, and marketing tools block the main thread when loaded on page load, directly hurting LCP and delaying interactivity. In most cases they serve no purpose until a real user is present.

Hyvä dispatches an `init-external-scripts` event the first time the visitor makes any interaction. Deferring script loading until this event fires means the browser has finished rendering before any third-party overhead begins. For scripts tied to a specific element, defer loading until the user interacts with that element rather than the whole page.

For a full guide including facade patterns and scroll-based loading, see [Loading External JavaScript](../writing-code/patterns/loading-external-javascript.html).

## CSS

### Avoid overusing arbitrary Tailwind values

Tailwind's JIT compiler only generates CSS for the classes you actually use, which keeps the stylesheet small. Arbitrary value classes such as `w-[123px]`, `text-[#ff3a00]`, or `mt-[37px]` each generate a unique CSS rule that cannot be shared with anything else. Overusing them gradually grows the stylesheet and negates the file size advantage Tailwind provides by default.

Prefer design token values from your Tailwind config wherever possible. Reserve arbitrary values for genuine one-off exceptions that cannot be expressed with a config value.

## DOM size

A large DOM slows down initial parsing, style calculation, and Alpine's component scanning. Keep the DOM as small as possible on initial load.

### Use `x-if` for rarely visible content

For content that is conditionally shown, prefer `x-if` over `x-show`. Elements wrapped in `x-if` are not added to the DOM until the condition is true, which keeps the initial DOM smaller. The trade-off is that the elements are also invisible to search engines, so use this only for content that does not need to be indexed.

`x-if` must always be placed on a `<template>` tag:

```
<template x-if="isOpen">
    <div>This content is only added to the DOM when isOpen is true.</div>
</template>
```

Avoid deeply nested template tags

Nesting `<template x-if>` inside another `<template x-if>` forces Alpine to evaluate each layer in sequence before any content is rendered. Deep nesting adds initialization overhead and makes the component harder to reason about. If you find yourself stacking template tags, it is a sign the logic should be simplified or moved into the component's data instead.

`x-show` is appropriate when content needs to be indexed or must toggle frequently, since it only applies a CSS property rather than adding or removing nodes.

### Load heavy off-screen blocks via AJAX

For complex blocks that appear below the fold, such as detailed mega menu panels or a cart drawer, consider removing them from the initial HTML response and fetching them via AJAX the first time the user needs them. This reduces the initial document size and the amount of work Alpine has to do on page load.

The trade-off is that the content is hidden from search engines and there is a small delay on first interaction.
