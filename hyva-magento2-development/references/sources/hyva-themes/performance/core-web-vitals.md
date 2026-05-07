<!-- source: https://docs.hyva.io/hyva-themes/performance/core-web-vitals.html -->

# Core Web Vitals

Google's Core Web Vitals are three metrics that measure real-world user experience. They directly influence search rankings and are the most reliable signal of how a storefront feels to visitors.

- **LCP (Largest Contentful Paint)**: how quickly the main content becomes visible.
- **CLS (Cumulative Layout Shift)**: how much elements jump around after the page starts rendering.
- **INP (Interaction to Next Paint)**: how responsive the page is to user input.

Measure first

Before optimizing, run your pages through [PageSpeed Insights](https://pagespeed.web.dev/) and check your CrUX field data. Real user data tells you which metric to focus on. See [Measuring Performance](measuring-performance.html) for a full overview of available tools.

## Largest Contentful Paint (LCP)

LCP marks the point when the largest visible element (usually a hero image or a heading) finishes loading. A good LCP score is under 2.5 seconds.

### Prioritize the LCP image

Add `fetchpriority="high"` and `loading="eager"` to the image most likely to be the LCP element, typically the hero image on the homepage or the main product image on the product detail page. Do not lazy load this image.

```
<img
  src="hero.jpg"
  fetchpriority="high"
  loading="eager"
  width="1200"
  height="600"
  alt="Hero image"
>
```

### Lazy load images below the fold

For all other images, use `loading="lazy"` to defer their download until the user scrolls toward them. This keeps the browser focused on the LCP image first.

### Defer non-critical JavaScript

Every render-blocking script delays LCP. Load scripts that are not needed for the initial render using the `defer` or `async` attribute.

### Font loading strategy

Web fonts can block rendering if not loaded carefully. To avoid this, use `font-display: swap` so the browser shows a fallback font immediately while the custom font downloads in the background. Set matching `line-height` and size values on your fallback so the swap causes minimal layout shift.

For detailed guidance, see the [custom fonts documentation](../building-your-theme/custom-fonts.html#preloading-fonts).

## Cumulative Layout Shift (CLS)

CLS measures the total amount of unexpected movement on a page during its lifetime. A good CLS score is under 0.1. Even small shifts, like a banner pushing content down, add up.

### Set dimensions on all images and videos

Always set `width` and `height` attributes on images and videos. Without them, the browser cannot reserve space before the media loads, causing a shift when each asset arrives.

```
<img src="product.jpg" width="400" height="400" alt="Product image">
```

### Reserve space for dynamically loaded content

Content injected after page load, like cookie banners, chat widgets, or promotional banners, causes layout shift if it pushes existing content down. Pre-allocate the space in CSS using `min-height` or use a placeholder element, so the page structure does not change when the content arrives.

### Avoid JavaScript-driven layout changes

Do not toggle element visibility or inject content above existing content after the initial render. If an element needs to appear conditionally, pre-allocate its space so the surrounding layout does not move.

## Interaction to Next Paint (INP)

INP measures how quickly the page responds to user input across the entire visit. A good INP score is under 200ms. Heavy JavaScript on the main thread is the most common cause of a poor INP score.

### Defer third-party scripts

Third-party scripts for chat widgets, analytics, cookie consent, and search autocomplete are the most common cause of high INP scores. These scripts run on the main thread and compete with user interactions.

Use a facade pattern to load them only when the user actually needs them:

- **Chat widgets**: load after the user scrolls or moves the mouse.
- **Search autocomplete**: load when the search field receives focus.
- **Video embeds**: show a thumbnail, then load the player when clicked.

See [Loading External JavaScript](../writing-code/patterns/loading-external-javascript.html) for implementation patterns.

Warning

Loading third-party scripts synchronously in the `<head>` is the single biggest INP killer on most Magento storefronts. Always defer or lazy-load them.

### Google Tag Manager and analytics

GTM can accumulate many tags over time, each adding to main thread load. Consider using [Partytown](https://partytown.builder.io/) to run analytics scripts in a web worker, which removes them from the main thread entirely and keeps INP scores healthy.
