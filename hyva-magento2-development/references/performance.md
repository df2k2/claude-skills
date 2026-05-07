# Performance in Hyvä

## When to read this

You're optimizing Core Web Vitals (LCP, INP, CLS), tuning caching, debugging slow page loads, or making architectural decisions that affect performance.

## Why Hyvä is fast by default

- No Knockout, no RequireJS, no UI components — fewer JS bytes, no synchronous evaluation phase blocking render.
- Tailwind's purged CSS is one tiny file with no unused rules.
- Alpine is ~15 KB. Knockout was ~22 KB *plus* a lot of init overhead.
- Hyvä uses Magento's FPC and Varnish normally.
- Section data fetches are deduplicated and lazy.

You should be able to hit Lighthouse 95+ on a stock Hyvä install. If you don't, something custom is dragging it down.

## Core Web Vitals targets

| Metric | Target | What hits it in Hyvä |
| --- | --- | --- |
| LCP (Largest Contentful Paint) | < 2.5s | Hero/banner images, slow Tailwind builds → large CSS, missing image preload |
| INP (Interaction to Next Paint) | < 200ms | Heavy Alpine init on first interaction, expensive `x-effect`s, many large components |
| CLS (Cumulative Layout Shift) | < 0.1 | Images without dimensions, fonts swapping, lazy-loaded blocks shifting layout |

## Block-level FPC

Magento's full-page cache works normally. Hyvä's `private-content-loaded` event ensures personalized content (cart count, customer name) is filled in client-side after the cached page loads. So:

- Public content → cached HTML
- Personalized content → injected via JS reading section data
- Don't break this by putting customer-specific data into server-rendered blocks.

If you have a block that should *never* be cached:
```xml
<block name="my.dynamic" cacheable="false" template="..."/>
```
But this also disables FPC for the whole page. Almost always the right answer is to render an empty placeholder server-side and fill it client-side from section data or a small Ajax call.

## ESI (Varnish) for partial caching

If a block is mostly static but varies per customer group / store / etc., use ESI:
```xml
<block name="top.menu" ttl="3600" template="...">
    <arguments>
        <argument name="content_type" xsi:type="string">application/private</argument>
    </arguments>
</block>
```

ESI requires Varnish. Cache tags from view models in ESI-cached blocks need the `$block` argument:
```php
$current = $viewModels->require(CurrentProduct::class, $block);
```

See `templates-and-blocks.md` for the cache-tag pattern.

## View model cache tags

When a view model returns data that depends on specific entities (a product, a category), implement `IdentityInterface` so the FPC stores the right cache tags:

```php
namespace Acme\Module\ViewModel;

use Magento\Catalog\Model\Product;
use Magento\Framework\DataObject\IdentityInterface;
use Magento\Framework\View\Element\Block\ArgumentInterface;

class FeaturedProduct implements ArgumentInterface, IdentityInterface
{
    private ?Product $product = null;

    public function getProduct(): ?Product { /* … */ }

    public function getIdentities(): array
    {
        return $this->product
            ? [Product::CACHE_TAG . '_' . $this->product->getId()]
            : [];
    }
}
```

When the product is updated, Magento invalidates the cache tag, the FPC entry is invalidated, the next request rebuilds. Without this, your block can serve stale data.

## Critical CSS / preload

Hyvä injects critical CSS into `<head>` for first paint. Custom fonts and large images benefit from preload hints. Use the `headAdditional` block / view model to inject:

```php
<link rel="preload" href="<?= $escaper->escapeUrl($block->getViewFileUrl('fonts/Inter.woff2')) ?>"
      as="font" type="font/woff2" crossorigin>
```

Or via layout XML:
```xml
<referenceBlock name="head.additional">
    <block class="Magento\Framework\View\Element\Template"
           name="my.preload"
           template="Acme_Module::preload.phtml"/>
</referenceBlock>
```

For LCP image, set `fetchpriority="high"`:
```html
<img src="hero.jpg" alt="..." width="1200" height="600" fetchpriority="high">
```

Don't lazy-load LCP images.

## Image dimensions to avoid CLS

Every `<img>` should have `width` and `height` attributes (or `aspect-ratio` in CSS) so the browser can reserve space before the image loads.

For Magento product images, use the gallery view model which returns dimensions:
```php
$image = $block->getImage($product, 'category_page_grid');
?>
<img src="<?= $escaper->escapeUrl($image->getImageUrl()) ?>"
     width="<?= (int) $image->getWidth() ?>"
     height="<?= (int) $image->getHeight() ?>"
     alt="<?= $escaper->escapeHtmlAttr($image->getLabel()) ?>">
```

## Speculation Rules (for fast navigation)

Hyvä supports the [Speculation Rules API](https://developer.mozilla.org/en-US/docs/Web/API/Speculation_Rules_API) which prefetches/prerenders pages on hover. Configure in your theme's layout:

```html
<script type="speculationrules">
{
  "prerender": [{
    "where": { "href_matches": "/*" },
    "eagerness": "moderate"
  }]
}
</script>
```

Be careful — prerendering executes JS and counts as a page view. Test analytics/cookie consent before enabling.

## bfcache (back/forward cache)

The browser caches the entire page on back/forward. Hyvä is bfcache-friendly *if* you don't:
- Use `unload` event listeners
- Open WebSockets or unfinished fetches without cleanup
- Set `Cache-Control: no-store` on the response

Test with Chrome DevTools → Application → Back-forward cache.

## Watching what gets shipped

```bash
# Inspect the final styles.css size
ls -lh app/design/frontend/Acme/default/web/css/styles.css

# Inspect the rendered HTML's inline scripts
curl -s https://example.com/ | grep -oE '<script[^>]*>' | head -20
```

Run Lighthouse:
```bash
npx lighthouse https://example.com/ --view
```

Or use the [Hyvä Lighthouse CI integration](https://docs.hyva.io/hyva-themes/performance/measuring-performance.html).

## Hyvä-specific perf wins

- **Use Tailwind utility classes** instead of writing custom CSS in `theme/` whenever possible — utilities are deduplicated and tree-shaken.
- **Inline small SVGs** via `Hyva\Theme\ViewModel\Svg` — avoids HTTP round-trips for icons.
- **Defer non-critical JS** by putting `<script>` blocks at the end of components or using `defer` attributes for separate JS files.
- **Use `x-intersect` (`@alpinejs/intersect`)** for content below the fold:
  ```html
  <div x-data x-intersect.once="fetchData()">…</div>
  ```
- **Avoid synchronous `x-init` fetches** — they block first paint. Use a placeholder + async:
  ```html
  <div x-data="{ items: null }" x-init="fetch('/api').then(r => r.json()).then(d => items = d)">
      <div x-show="items === null">Loading…</div>
      <template x-if="items"><ul>…</ul></template>
  </div>
  ```
- **Avoid GraphQL waterfalls.** If a page needs 3 GraphQL queries, batch them in one request.
- **Don't ship 50 KB of dynamic Tailwind class data** with every page; share it via section data or a global JSON endpoint cached in localStorage.

## Profiling slow pages

1. Check the network waterfall — what's slow? CSS? JS? An XHR? An image?
2. If the response itself is slow (TTFB > 500ms), it's a server-side / FPC issue. Confirm Varnish/FPC is hot.
3. If the response is fast but the page is sluggish to interact, it's client-side. Profile in DevTools → Performance.
4. If Alpine init is slow, check how many components and how much data they're processing. Move heavy work into `x-intersect` or off the critical path.
5. If `private-content-loaded` is firing late, check whether the page has many `private_content_version` cookie races.

## Magento's built-in minification — keep it OFF for Hyvä

Hyvä's Tailwind build already produces minified CSS. Magento's bundler/minifier on top adds overhead and can cause issues. If you have mixed Hyvä + Luma store views, scope these settings per store view.

```bash
bin/magento config:set --scope=stores --scope-code=hyva_view dev/template/minify_html 0
bin/magento config:set --scope=stores --scope-code=hyva_view dev/js/merge_files 0
bin/magento config:set --scope=stores --scope-code=hyva_view dev/js/minify_files 0
bin/magento config:set --scope=stores --scope-code=hyva_view dev/css/merge_css_files 0
bin/magento config:set --scope=stores --scope-code=hyva_view dev/css/minify_files 0
```

## Don't

- Don't return a giant inline `<script>` with thousands of products — paginate or stream.
- Don't have many `setInterval`s firing — they keep the page out of bfcache.
- Don't lazy-load the LCP image.
- Don't preload everything — only the LCP image, critical fonts, and the JS that *must* run early.
- Don't reach for SSR + hydration patterns from Next.js. Hyvä is server-rendered HTML with progressive enhancement — that's already faster than hydration in most cases.

## Original sources

- `references/sources/hyva-themes/performance/index.md` — overview
- `references/sources/hyva-themes/performance/core-web-vitals.md` — LCP / INP / CLS targets
- `references/sources/hyva-themes/performance/hyva-performance-tips.md` — practical tips
- `references/sources/hyva-themes/performance/measuring-performance.md` — Lighthouse / CWV measurement
- `references/sources/hyva-themes/performance/block-html-full-page-caching.md` — FPC behavior
- `references/sources/hyva-themes/performance/view-model-cache-tags.md` — cache tags from view models (FPC, ESI)
- `references/sources/hyva-themes/performance/bfcache.md` — back/forward cache compatibility
- `references/sources/hyva-themes/performance/speculation-rules.md` — Speculation Rules API integration
- `references/sources/hyva-themes/faqs/critical-css.md` — critical CSS in Hyvä
