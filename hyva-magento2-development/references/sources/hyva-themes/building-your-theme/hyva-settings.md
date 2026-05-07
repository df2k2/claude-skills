<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/hyva-settings.html -->

# Hyvä Theme Settings Reference

The Hyvä Theme Module (`hyva-themes/magento2-theme-module`) provides configuration options that control storefront performance, component behavior, and feature toggles. These Hyvä theme settings manage everything from deferred Alpine.js component loading to browser navigation prefetching.

Access all Hyvä theme settings in the Magento Admin under **Stores > Configuration > Hyvä Themes**.

Version Compatibility

This reference covers settings from the latest version of `hyva-themes/magento2-theme-module`. The module can be safely updated to the latest version at any time.

## Message Display Settings in Hyvä Themes

The **Success Message Default Timeout** setting controls how long success messages stay visible on the storefront. Set a value in milliseconds to auto-hide success messages after a delay, or leave the field empty to keep messages visible until the customer dismisses them manually.

**Path:** Hyvä Themes > General > Message Display

- **Default:** empty (messages persist until dismissed) — this is the recommended setting
- **If a timeout is desired:** Common values range from 3000–10000 ms

This setting only affects success messages. Error and warning messages always remain visible until the customer closes them.

## Hyvä Demo Content Settings

The **Show Homepage Content** toggle controls whether the default Hyvä demo homepage content is displayed. This demo content ships with every Hyvä theme installation and is useful during initial setup.

**Path:** Hyvä Themes > General > Hyvä Demo Content

- **Default:** `Yes`
- **When to disable:** The demo homepage content is only intended for demo instances. Set this to `No` or remove the homepage content in your child theme to replace it with your own content.

## Deferred Alpine.js Component Settings

Hyvä themes can defer the initialization of Alpine.js components to improve page interactivity and reduce main thread blocking time. The deferred component settings control which components are delayed and how long the browser waits before initializing them.

**Path:** Hyvä Themes > General > Deferred Alpine.js Components

### Defer Until Idle Timeout

The **Defer until idle timeout** sets the delay in milliseconds before deferred Alpine.js components initialize. The browser waits for the main thread to be idle, then starts initializing deferred components after this timeout.

- **Default:** `4000` (4 seconds)
- **Lower values** (e.g. `2000`) make components interactive sooner but may compete with critical rendering
- **Higher values** give priority to above-the-fold content but delay below-the-fold interactivity

### Defer Components List

The **Defer components** field lists CSS selectors for Alpine.js components that should be deferred. Each selector identifies a component whose initialization will be delayed.

- **Default:** A predefined list of selectors for common Hyvä components
- **Best practice:** Prefer adding the `x-defer` directive directly in your template files instead of using this admin setting. The template-level approach gives you finer control over the deferral trigger (`intersect`, `interact`, `idle`, or `event:eventname`). See [The Alpine.js x-defer plugin](../working-with-alpinejs/alpine-plugins/x-defer.html) for details.

When to Use the Admin Setting vs. Template Directives

Use the admin setting when you need to defer third-party components that you cannot easily modify at the template level. For your own theme templates, the `x-defer` directive is the preferred approach because it lets you choose the exact trigger type per component.

## View Transition Animation Settings

The **Enable View Transition Gallery** setting controls a CSS view transition animation that plays when a customer navigates from the product listing page to the product image gallery.

**Path:** Hyvä Themes > General > Animations and Transitions

- **Default:** `No`
- **When to enable:** Turn this on if you want a smooth visual transition effect between the product list and product detail gallery. This uses the browser's View Transitions API, which is supported in all major browsers.

## Speculation Rules Settings for Navigation Prefetching

Speculation rules tell the browser which pages to prefetch or prerender before a customer clicks a link, enabling near-instant page loads. Hyvä themes include built-in support for the Speculation Rules API, enabled by default since Hyvä 1.4.0.

**Path:** Hyvä Themes > General > Speculation Rules

### Speculation Method

The **Method** setting determines what the browser does with speculated links:

- **`Prefetch`** (default) - Downloads the page HTML and critical resources in advance. This is lightweight and safe for most stores.
- **`Prerender`** - Fully renders the page in a hidden tab for instant display on click. Uses more memory and CPU, and can trigger analytics events prematurely. Best for stores with a small number of high-probability next pages.
- **`Disabled`** - Turns off speculative loading entirely.

### Speculation Eagerness

The **Eagerness** setting controls when the browser begins speculating on links:

- **`Immediate`** - Speculates on all qualifying links as soon as the page loads
- **`Eager`** - Speculates quickly, before the user shows intent
- **`Moderate`** (default) - Speculates when the user hovers over a link
- **`Conservative`** - Speculates only on mouse-down or touch-start

For a deeper dive into speculation rules, trade-offs, and analytics considerations, see [Speculation Rules](../performance/speculation-rules.html).

## Compare Products Settings in Hyvä Catalog

The compare products settings control the visibility of "Add to Compare" buttons and the compare sidebar across the Hyvä storefront. These settings are mirrored from **Catalog > Catalog > Storefront** for convenience.

**Path:** Hyvä Themes > Catalog > Compare Products

| Setting | Default | Effect |
| --- | --- | --- |
| **Show Add To Compare On Product Page** | `Yes` | Displays the compare button on product detail pages |
| **Show Add To Compare In Product List** | `Yes` | Displays the compare button in category listing pages |
| **Show Compare Sidebar On Product List** | `Yes` | Shows the compare sidebar widget on listing pages |

Set all three to `No` if your store does not use the product comparison feature. This removes unnecessary UI elements and simplifies the product pages.

## Recently Viewed Products Settings

The recently viewed products settings control whether and where the "Recently Viewed" product block appears on the Hyvä storefront. These settings are mirrored from **Catalog > Recently Viewed/Compared Products**.

**Path:** Hyvä Themes > Catalog > Recently Viewed Products

| Setting | Default | Effect |
| --- | --- | --- |
| **Enable Recently Viewed Products** | `No` | Master toggle for the entire recently viewed feature |
| **Show on Product Detail Pages** | `No` | Displays the recently viewed block on product pages |
| **Show on Product Listing Pages** | `No` | Displays the recently viewed block on category pages |

Enable the Master Toggle First

The **Enable Recently Viewed Products** setting must be set to `Yes` before the other two display settings have any effect. If the master toggle is `No`, the recently viewed block will not appear anywhere regardless of the other settings.

## Cross-sell Products Settings

The **Max Product Count for Crosssell list** setting limits how many cross-sell products are displayed in the shopping cart.

**Path:** Hyvä Themes > Catalog > Crosssell Products

- **Default:** `4`
- **Acceptable range:** Any positive integer. Higher values show more products but increase the cart page size and load time.

Cross-sell products are configured per product in the Magento Admin under **Catalog > Products > Related Products, Up-Sells, and Cross-Sells**.

## Client-Side Breadcrumbs on Product Pages

The **Enable on Product Detail Pages** setting switches breadcrumb rendering from server-side to client-side JavaScript on product detail pages. This can be useful when the server-side breadcrumb cache causes incorrect category paths.

**Path:** Hyvä Themes > Catalog > Client-Side Breadcrumbs

- **Default:** `No`

Performance Impact with Large Category Trees

Enabling client-side breadcrumbs triggers a JavaScript category tree lookup on every product page load. On stores with thousands of categories, this can noticeably slow down product page rendering. Only enable this setting if you are experiencing incorrect breadcrumb paths and your category tree is not excessively large.

## Product List Item Cache Settings

The product list item cache settings control HTML caching for individual product items on category listing pages. Caching product list item HTML reduces PHP processing time and speeds up category page rendering in Hyvä themes.

**Path:** Hyvä Themes > Catalog > Developer

| Setting | Default | Effect |
| --- | --- | --- |
| **Enable Product List Item block\_html Caching** | `Yes` | Caches the rendered HTML of each product item block |
| **Product List Item Block Cache Lifetime** | `3600` (1 hour) | How long cached product HTML remains valid, in seconds |

Keep caching enabled for best performance. Reduce the cache lifetime if your product data changes frequently (e.g., flash sales with rapidly changing prices). Increase the lifetime for catalogs that rarely change.

## Google GTag Integration Settings

The Google GTag settings control Google Analytics and Tag Manager behavior in Hyvä themes. These settings are mirrored from **Sales > Google API > Google GTag** for convenience.

**Path:** Hyvä Themes > Google GTag > GTag

| Setting | Default | Effect |
| --- | --- | --- |
| **Anonymize IP** | `Yes` | Anonymizes visitor IP addresses in Google tracking data. Required for GDPR compliance in many jurisdictions. |
| **Lazyload Tag Manager** | `No` | Defers GTM script loading until the first user interaction (click, scroll, or keypress). |

Enable GTM Lazy Loading for Better Performance

Setting **Lazyload Tag Manager** to `Yes` can significantly improve your Lighthouse performance score by deferring third-party JavaScript. The trade-off is that GTM tags will not fire until the user interacts with the page, which means early page-view events may be delayed.

## Page Builder Background Image Settings

The **Enable lazy-loading for background images** setting controls whether Adobe Commerce Page Builder background images use lazy loading in Hyvä themes. Lazy loading defers the download of background images until they are about to enter the viewport, improving initial page load performance and Core Web Vitals scores.

**Path:** Hyvä Themes > Page Builder > Images

- **Default:** `No`

Version Requirement

This setting requires Hyvä default theme version 1.3.10 or newer. On older theme versions, enabling this setting has no effect.

Enable this setting when your pages use Page Builder content blocks with large background images, especially below the fold. For above-the-fold hero sections, test carefully to ensure the lazy loading does not cause a visible layout shift.

## SVG Icon Caching in Hyvä Developer Settings

The **Enable SVG Icon Caching** setting caches rendered SVG icon output in the Magento cache backend (typically Redis). This reduces PHP processing time on pages that render many SVG icons.

**Path:** Hyvä Themes > Developer > Cache Options (SVG icons)

- **Default:** `No`
- **Trade-off:** Enabling SVG caching increases cache storage usage in your Redis or other cache backend. On stores with many unique SVG icons, this can add meaningful load to the cache infrastructure.
- **When to enable:** Consider enabling SVG icon caching on stores where profiling shows significant time spent in SVG rendering, or on pages that display many product cards with SVG-based icons.

## Bfcache Settings for Instant Back-Forward Navigation

The **Enable Bfcache** setting activates support for the browser's back-forward cache (bfcache) in Hyvä themes. Bfcache stores complete page snapshots in memory so that pressing the browser's back or forward button restores pages instantly instead of reloading them. This setting is mirrored from **Advanced > System > Full Page Cache**.

**Path:** Hyvä Themes > System > Cache Options (Bfcache)

- **Default:** `No`

Additional Server Configuration Required

Enabling bfcache in the Magento Admin is not enough on its own. You also need to modify your Varnish or Fastly VCL configuration to remove `no-store` from the `Cache-Control` header. Without this server-side change, browsers will not cache pages for back-forward navigation. See the full [Bfcache implementation guide](../performance/bfcache.html) for step-by-step instructions.

## Related Topics

- [The Alpine.js x-defer plugin](../working-with-alpinejs/alpine-plugins/x-defer.html) - Deferring component initialization at the template level
- [Speculation Rules](../performance/speculation-rules.html) - Detailed guide on prefetching and prerendering
- [Bfcache implementation guide](../performance/bfcache.html) - Server configuration for instant back-forward navigation
