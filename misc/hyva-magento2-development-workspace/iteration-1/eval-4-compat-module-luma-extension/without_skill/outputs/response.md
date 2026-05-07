# Hyvä Compatibility Module for `Acme_Recommendations` (Luma-only Module)

## Scenario Summary

You have:

- **Magento 2** with two store views:
  - **Main store view**: Hyvä 1.4 default theme.
  - **B2B store view**: Luma theme.
- **`Acme_Recommendations`** third-party module:
  - Renders product recommendations.
  - Built for Luma: depends on `Magento_Ui` UI components (`uiComponent`, `uiClass`, `uiCollection`), Knockout.js (`ko`), and `jquery`.
  - Has Luma `.phtml` templates, KO `.html` templates, `requirejs-config.js`, `view.xml` for image config, etc.

**Goal**: Get recommendations rendering on the Hyvä storefront without breaking Luma.

The Hyvä way to handle this is a **dedicated compatibility module** that:

1. Disables the third-party module's frontend output **only on the Hyvä theme**.
2. Re-implements the same business functionality as native Hyvä (Tailwind + Alpine.js) templates.
3. Reuses the third-party module's PHP layer (Blocks, ViewModels, Models, APIs) where safe — this is the whole point of Hyvä's architecture.

I'll walk you through the full module: `HyvaCompat_AcmeRecommendations`.

---

## 1. Pre-flight: Inspect What You're Compatibilizing

Before you write any code, you must inventory the module. Run these to understand the surface area:

```bash
# Find every layout XML the module ships
find vendor/acme/module-recommendations/view/frontend/layout -type f

# Find every template
find vendor/acme/module-recommendations/view/frontend/templates -name "*.phtml"

# Find KO/UI artifacts
find vendor/acme/module-recommendations/view/frontend/web -type f

# Module declaration
cat vendor/acme/module-recommendations/etc/module.xml

# Default config and routes
cat vendor/acme/module-recommendations/etc/frontend/routes.xml 2>/dev/null
cat vendor/acme/module-recommendations/etc/config.xml 2>/dev/null
```

Make a checklist that looks like this. (Example — yours will differ.)

| Item | Path | What it does | Hyvä action |
|---|---|---|---|
| Layout: `default.xml` | `view/frontend/layout/default.xml` | Adds `acme.recommendations.sidebar` block to `sidebar.additional` | Remove on Hyvä, re-create with Hyvä template |
| Layout: `catalog_product_view.xml` | `view/frontend/layout/catalog_product_view.xml` | Adds `acme.recommendations.related` after `product.info` | Remove on Hyvä, re-create with Hyvä template |
| Layout: `checkout_cart_index.xml` | `view/frontend/layout/checkout_cart_index.xml` | Adds cart-page recs | Remove on Hyvä, re-create |
| Template: `recommendations.phtml` | `view/frontend/templates/recommendations.phtml` | Outputs `<div data-bind="...">` placeholder | Replace with Alpine template |
| Template: `item.phtml` | `view/frontend/templates/item.phtml` | KO `<!-- ko foreach --> ` partial | Replace with Alpine `<template x-for>` |
| KO HTML | `view/frontend/web/template/recommendations.html` | Renders cards | Re-create as Alpine template |
| `requirejs-config.js` | `view/frontend/requirejs-config.js` | Registers `acmeRecommendations` JS | **Do nothing** — Hyvä doesn't load RequireJS |
| `view.xml` | `etc/view.xml` | Image dimensions for `acme_recommendation_image` | Keep as-is (PHP-side config) |
| Block class | `Acme\Recommendations\Block\Recommendations` | Loads provider, returns items | **Reuse directly** if it returns DTOs/array, otherwise wrap in ViewModel |
| ViewModel | `Acme\Recommendations\ViewModel\Provider` | If present, reuse | **Reuse directly** |
| API | `Acme\Recommendations\Api\RecommendationProviderInterface` | Service contract | **Reuse directly** |

The general principle: **PHP backend = reuse; frontend (templates, JS) = rewrite for Hyvä**.

---

## 2. Module Skeleton

Create the module under `app/code/HyvaCompat/AcmeRecommendations/`. The `HyvaCompat` vendor namespace is a community convention used widely in Hyvä compatibility modules (see the `hyva-themes/magento2-*-hyva-compat` repos on GitLab).

### 2.1 `app/code/HyvaCompat/AcmeRecommendations/registration.php`

```php
<?php
declare(strict_types=1);

use Magento\Framework\Component\ComponentRegistrar;

ComponentRegistrar::register(
    ComponentRegistrar::MODULE,
    'HyvaCompat_AcmeRecommendations',
    __DIR__
);
```

### 2.2 `app/code/HyvaCompat/AcmeRecommendations/etc/module.xml`

Declare hard dependencies on both Hyvä and the upstream module so this module is automatically disabled if either is missing.

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="HyvaCompat_AcmeRecommendations">
        <sequence>
            <module name="Acme_Recommendations"/>
            <module name="Hyva_Theme"/>
            <module name="Hyva_CompatModuleFallback"/>
        </sequence>
    </module>
</config>
```

`Hyva_CompatModuleFallback` is shipped by Hyvä (`hyva-themes/magento2-compat-module-fallback`) and provides the mechanism for *graceful degradation*: when the user is on a Hyvä theme but no compat module exists for an installed Luma module, Hyvä strips the Luma layout updates, suppresses RequireJS errors, and shows a helpful message in dev mode. Sequencing after it makes sure your overrides win.

### 2.3 `app/code/HyvaCompat/AcmeRecommendations/composer.json`

If you ship this as a Composer package (recommended), use this skeleton.

```json
{
    "name": "hyvacompat/module-acme-recommendations",
    "description": "Hyvä compatibility module for Acme_Recommendations",
    "type": "magento2-module",
    "license": "MIT",
    "require": {
        "php": ">=8.1",
        "hyva-themes/magento2-default-theme": "^1.4",
        "acme/module-recommendations": "*"
    },
    "autoload": {
        "files": ["registration.php"],
        "psr-4": {
            "HyvaCompat\\AcmeRecommendations\\": ""
        }
    }
}
```

### 2.4 Enable & verify

```bash
bin/magento module:enable HyvaCompat_AcmeRecommendations
bin/magento setup:upgrade
bin/magento module:status | grep -i acme
```

You should see both `Acme_Recommendations` and `HyvaCompat_AcmeRecommendations` enabled. **Do not disable the upstream module** — Luma still needs it.

---

## 3. Scope Layout Changes to Hyvä Only

This is the trickiest part. You want Luma store views to render the original module untouched, and Hyvä store views to render your new templates. There are several ways Hyvä can scope layout changes to itself:

### 3.1 Option A (Preferred): Theme-scoped layout under `frontend/Hyva/default/`

Hyvä layout overrides go in a directory mirroring the **theme path**, not the area. The `frontend/` area is shared by all frontend themes; layout files under `view/frontend/layout/` apply everywhere unless you use `<update>` filtering.

The cleanest pattern is to put compat layout under a path Hyvä will only load when the active theme inherits from `Hyva/default`. Hyvä's parent theme detection is automatic — files under `view/frontend/layout/` apply globally, but files under `view/frontend/page_layout/` and `view/frontend/templates/` only resolve when a layout reference targets them.

**Use the `view/frontend/layout/` files with `<update handle="hyva_compat"/>` triggered by Hyvä's layout, OR scope by theme via `view/frontend/layout/`** — both are valid. The simplest and most widely used approach in the Hyvä ecosystem is:

**Single `view/frontend/layout/default.xml` file using `referenceBlock ... remove="true"` plus a `<container>` for Hyvä-only content that doesn't render under Luma because Hyvä re-renders everything.**

Wait — that breaks Luma. The correct approach is:

### 3.2 Option B (Recommended): Theme-scoped via theme inheritance

Put your layout/templates under `view/frontend/` of a module that itself only declares its layouts under handles loaded by Hyvä. Hyvä's `Hyva/default` theme automatically loads a `hyva_default` layout handle in addition to the standard ones. You can target that handle.

```xml
<!-- app/code/HyvaCompat/AcmeRecommendations/view/frontend/layout/hyva_default.xml -->
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <!-- Anything in here only loads on Hyvä themes -->
    </body>
</page>
```

However, the most reliable, widely-adopted technique used by the official `hyva-themes/magento2-*-hyva-compat` modules is **Option C**:

### 3.3 Option C (What the Hyvä community actually does): One module, two layout strategies

You write **one** compat module. Inside, you:

1. **Remove** the upstream module's blocks/containers using global layout removals — but only on handles or against blocks that won't exist on Luma anyway.
2. **Use the Hyvä-specific handle naming** (e.g., layout `default.xml` with `<update handle="hyva_default"/>` references) so the layout updates only fire when Hyvä is active.

The most foolproof scoping mechanism is **`Magento\Framework\View\Element\Template`'s template fallback**: under Hyvä, `vendor/hyva-themes/magento2-default-theme` doesn't inherit from `Magento/luma` — it inherits from `Magento/blank`, but its layouts strip almost all Magento UI Component infrastructure. This means **any block whose template references a Knockout component or `Magento_Ui/...` JS module will fail to render anything visible on Hyvä** even if you do nothing.

But "fail to render" is not "remove" — the block still executes PHP, possibly throws JS errors, and may add bloat. So we explicitly clean up.

### 3.4 The actual layout file you'll write

`app/code/HyvaCompat/AcmeRecommendations/view/frontend/layout/default.xml`

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <update handle="hyva_compat_acme_recommendations"/>
</page>
```

`<update handle="..."/>` always fires on every frontend page, including Luma. So we need to make sure the contents of that handle file **are inert on Luma**.

We do that by putting **only Hyvä-specific blocks** in the included handle. Hyvä-specific blocks have templates under `Hyva_Theme::...` or our own module path; on Luma, those templates fall back via theme inheritance — and because Luma doesn't inherit from Hyvä, Magento simply skips the block render with a `Could not find template` warning (or, with our module path, renders the Hyvä template — which is what we don't want).

So we need a stronger guard. We add a **layout XSD-valid `ifconfig`** check or a **Hyvä-only check via a custom layout argument**. The easiest, most robust mechanism is the one shipped by `Hyva_Theme`:

### 3.5 The robust mechanism: `Magento\Framework\View\Layout\Argument\Interpreter\Constant` + `Hyva\Theme\Model\IsHyvaActive`

Hyvä exposes a service you can call from a layout/block argument or from PHP. But for layout XML the cleanest approach is the well-known **layout-handle technique**: Hyvä adds the `hyva_default` handle to the layout request when the active theme is Hyvä. So we put our **additions** under `hyva_default.xml` and our **removals** under `default.xml` *only for blocks that the Hyvä theme isn't going to render anyway* (RequireJS-driven blocks).

Here's the clean split:

#### 3.5.1 `view/frontend/layout/default.xml` — runs everywhere, removes Luma blocks safely

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <!--
            These blocks are added by Acme_Recommendations and use Knockout
            templates. On Hyvä they would either fail or render broken markup.
            On Luma they are useful, so we DO NOT want to remove them globally.

            We rely on Hyva_CompatModuleFallback's layout filtering, which
            automatically strips any block whose template references
            'Magento_Ui/' or contains 'data-bind=' when Hyvä is active.
            See: hyva-themes/magento2-compat-module-fallback README.

            For belt-and-braces, we *also* explicitly remove them in the
            Hyvä-only layout handle below. That way we don't depend on the
            fallback module catching every case.
        -->
    </body>
</page>
```

#### 3.5.2 `view/frontend/layout/hyva_default.xml` — runs **only** on Hyvä, removes Luma blocks and adds Hyvä blocks

The `hyva_default` handle is automatically loaded by `Hyva\Theme\Model\LayoutProcessor` (look at `vendor/hyva-themes/magento2-theme-module/Model/LayoutProcessor.php` — it adds the `hyva_default` handle to the layout when the active theme inherits from `Hyva/default`). So anything in this file applies only on Hyvä.

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <!-- Remove the Luma KO blocks so they don't try to render on Hyvä -->
        <referenceBlock name="acme.recommendations.sidebar" remove="true"/>
        <referenceBlock name="acme.recommendations.related" remove="true"/>
        <referenceBlock name="acme.recommendations.cart" remove="true"/>
    </body>
</page>
```

#### 3.5.3 Page-specific Hyvä handles for re-adding the recs as Hyvä blocks

`view/frontend/layout/hyva_default_catalog_product_view.xml`

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="content">
            <block name="hyva.compat.acme.recommendations.related"
                   class="Magento\Catalog\Block\Product\AbstractProduct"
                   template="HyvaCompat_AcmeRecommendations::recommendations/related.phtml"
                   after="product.info">
                <arguments>
                    <argument name="view_model" xsi:type="object">
                        Acme\Recommendations\ViewModel\Provider
                    </argument>
                    <argument name="image_helper" xsi:type="object">
                        Hyva\Theme\ViewModel\Product\Image
                    </argument>
                    <argument name="placement" xsi:type="string">related</argument>
                </arguments>
            </block>
        </referenceContainer>
    </body>
</page>
```

`view/frontend/layout/hyva_default_checkout_cart_index.xml`

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="content">
            <block name="hyva.compat.acme.recommendations.cart"
                   class="Magento\Catalog\Block\Product\AbstractProduct"
                   template="HyvaCompat_AcmeRecommendations::recommendations/cart.phtml"
                   after="checkout.cart.form">
                <arguments>
                    <argument name="view_model" xsi:type="object">
                        Acme\Recommendations\ViewModel\Provider
                    </argument>
                    <argument name="placement" xsi:type="string">cart</argument>
                </arguments>
            </block>
        </referenceContainer>
    </body>
</page>
```

`view/frontend/layout/hyva_default.xml` — sidebar (homepage / CMS pages)

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <!-- removals from earlier still apply -->
        <referenceBlock name="acme.recommendations.sidebar" remove="true"/>
        <referenceBlock name="acme.recommendations.related" remove="true"/>
        <referenceBlock name="acme.recommendations.cart" remove="true"/>

        <referenceContainer name="sidebar.additional">
            <block name="hyva.compat.acme.recommendations.sidebar"
                   class="Magento\Catalog\Block\Product\AbstractProduct"
                   template="HyvaCompat_AcmeRecommendations::recommendations/sidebar.phtml">
                <arguments>
                    <argument name="view_model" xsi:type="object">
                        Acme\Recommendations\ViewModel\Provider
                    </argument>
                    <argument name="placement" xsi:type="string">sidebar</argument>
                </arguments>
            </block>
        </referenceContainer>
    </body>
</page>
```

> **Important**: If `Acme_Recommendations` doesn't ship a ViewModel and only has a Block, see Section 5 below on how to wrap its Block class to extract a clean DTO list.

---

## 4. Hyvä Templates (Tailwind + Alpine.js)

Hyvä uses **TailwindCSS** for utility-first styling and **Alpine.js** for declarative reactivity. There is **no Knockout, no RequireJS, no UI Components** on the storefront. Templates are pure PHP that emits HTML with `x-data`/`x-show`/`x-for` attributes.

Standard Hyvä reference patterns to follow:

- ViewModel must be retrieved via `$block->getData('view_model')` (Hyvä convention) or `$block->getViewModel()` if you add a getter.
- Output escaping: always use `$escaper->escapeHtml()`, `$escaper->escapeUrl()`, `$escaper->escapeHtmlAttr()`.
- Re-use the Hyvä **`product-card`** partial (`Hyva_Theme::product/list/card.phtml`) when rendering product tiles — your recommendations should look identical to other product cards on the site.
- Currency formatting goes through `$block->getViewModel('priceBox')` or the `Hyva\Theme\ViewModel\Currency` view model.

### 4.1 `view/frontend/templates/recommendations/related.phtml`

```php
<?php
declare(strict_types=1);

/** @var \Magento\Catalog\Block\Product\AbstractProduct $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */

use Acme\Recommendations\Api\Data\RecommendationInterface;

$viewModel  = $block->getData('view_model');
$placement  = (string) $block->getData('placement');
$heading    = __('You may also like');

try {
    $product = $block->getProduct();
} catch (\Throwable $e) {
    $product = null;
}

$items = $product
    ? $viewModel->getRecommendationsForProduct((int) $product->getId(), $placement)
    : $viewModel->getRecommendations($placement);

if (empty($items)) {
    return;
}

$cardRenderer = $viewModels->require(\Hyva\Theme\ViewModel\ProductListItem::class);
?>
<section
    x-data="hyvaCompatAcmeRecs()"
    x-init="init()"
    class="container mx-auto py-8"
    aria-labelledby="acme-recs-<?= $escaper->escapeHtmlAttr($placement) ?>-heading"
>
    <h2
        id="acme-recs-<?= $escaper->escapeHtmlAttr($placement) ?>-heading"
        class="text-2xl font-semibold mb-6"
    >
        <?= $escaper->escapeHtml($heading) ?>
    </h2>

    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <?php foreach ($items as $item): /** @var RecommendationInterface $item */ ?>
            <?php
                $itemProduct = $item->getProduct();
                if (!$itemProduct) {
                    continue;
                }
            ?>
            <article class="group flex flex-col rounded-lg border border-gray-200 bg-white p-4
                            hover:shadow-lg transition-shadow"
                     data-rec-id="<?= $escaper->escapeHtmlAttr((string) $item->getId()) ?>"
                     @click="trackClick('<?= $escaper->escapeJs((string) $item->getId()) ?>')">
                <a href="<?= $escaper->escapeUrl($itemProduct->getProductUrl()) ?>"
                   class="block aspect-square overflow-hidden rounded">
                    <img
                        src="<?= $escaper->escapeUrl(
                            $block->getImage($itemProduct, 'category_page_grid')->getImageUrl()
                        ) ?>"
                        alt="<?= $escaper->escapeHtmlAttr((string) $itemProduct->getName()) ?>"
                        loading="lazy"
                        class="w-full h-full object-cover group-hover:scale-105 transition-transform"
                    />
                </a>
                <div class="mt-3 flex flex-col gap-2">
                    <a href="<?= $escaper->escapeUrl($itemProduct->getProductUrl()) ?>"
                       class="text-sm font-medium text-gray-900 line-clamp-2 hover:underline">
                        <?= $escaper->escapeHtml((string) $itemProduct->getName()) ?>
                    </a>
                    <?= $block->getLayout()
                              ->createBlock(\Magento\Framework\Pricing\Render::class)
                              ->setData('price_render', 'product.price.render.default')
                              ->setData('price_type_code', 'final_price')
                              ->setData('product', $itemProduct)
                              ->toHtml() ?>
                    <button
                        type="button"
                        @click.prevent="addToCart($event, '<?= $escaper->escapeJs((string) $itemProduct->getSku()) ?>')"
                        class="mt-2 inline-flex items-center justify-center px-4 py-2
                               text-sm font-medium text-white bg-primary
                               rounded hover:bg-primary-darker focus:outline-none
                               focus:ring-2 focus:ring-primary-lighter">
                        <?= $escaper->escapeHtml(__('Add to Cart')) ?>
                    </button>
                </div>
            </article>
        <?php endforeach; ?>
    </div>
</section>

<script>
    function hyvaCompatAcmeRecs() {
        return {
            init() {
                window.dispatchEvent(new CustomEvent('acme-recs:rendered', {
                    detail: { placement: '<?= $escaper->escapeJs($placement) ?>' }
                }));
            },
            trackClick(id) {
                window.dispatchEvent(new CustomEvent('acme-recs:click', {
                    detail: { id, placement: '<?= $escaper->escapeJs($placement) ?>' }
                }));
            },
            async addToCart(ev, sku) {
                ev.preventDefault();
                const formKey = hyva.getFormKey();
                const url = BASE_URL + 'checkout/cart/add';
                const fd  = new FormData();
                fd.append('form_key', formKey);
                fd.append('sku', sku);
                fd.append('qty', '1');
                try {
                    const res = await fetch(url, {
                        method: 'POST',
                        body: fd,
                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                    });
                    if (res.ok) {
                        window.dispatchEvent(new CustomEvent('reload-customer-section-data'));
                        hyva.getBrowserStorage()
                            .setItem('mage-messages', JSON.stringify([
                                { type: 'success', text: '<?= $escaper->escapeJs(__('Added to cart')) ?>' }
                            ]));
                        window.dispatchEvent(new CustomEvent('reload-mage-messages'));
                    }
                } catch (e) {
                    console.error('Add to cart failed', e);
                }
            }
        };
    }
</script>
```

Some things to highlight in this template that are **Hyvä-idiomatic**:

- `hyva.getFormKey()` — Hyvä's helper, replaces Luma's `mage/url` + `Magento_Customer/js/customer-data` form-key handling.
- `hyva.getBrowserStorage()` — Hyvä's `localStorage` wrapper that mage-messages and minicart subscribe to.
- `BASE_URL` — Hyvä exposes this global in `Hyva_Theme::page/js/base-url.phtml`.
- `'reload-customer-section-data'` and `'reload-mage-messages'` — Hyvä's pub/sub event bus uses native `CustomEvent`s, not Magento's `customerData` / KO subscriptions.
- `<?= $block->getImage(...) ?>` — works on Hyvä, just as on Luma.
- We do **not** include any RequireJS, KO, or `data-bind` attribute. All reactivity is Alpine.

### 4.2 `view/frontend/templates/recommendations/cart.phtml` and `sidebar.phtml`

These follow the same pattern. Vary the heading, the grid breakpoints, and possibly the placement string passed to `$viewModel->getRecommendations()`. Keep all three templates short and consistent — duplication is fine here, it makes the templates self-contained and easy to debug.

### 4.3 Reusing Hyvä's `product-card` partial (cleaner alternative)

Instead of duplicating the card markup in your three templates, render Hyvä's stock product card and pass it the product:

```php
<?= $block->getLayout()->createBlock(
    \Magento\Catalog\Block\Product\ListProduct::class,
    'hyva.compat.recs.tile.' . $itemProduct->getId(),
    ['data' => ['product' => $itemProduct]]
)->setTemplate('Hyva_Theme::product/list/card.phtml')->toHtml(); ?>
```

This way you get the same hover, swatch, price, and add-to-cart behavior as the rest of the site. **Strongly recommended over hand-rolling card markup** — it future-proofs against Hyvä product-card upgrades.

---

## 5. PHP Layer: Reuse vs. Wrap

### 5.1 If `Acme\Recommendations\ViewModel\Provider` exists

Just inject it via the layout argument as shown above. Done.

### 5.2 If only a Block exists, wrap it

Create a thin ViewModel that talks to the upstream Block or the upstream Service.

`app/code/HyvaCompat/AcmeRecommendations/ViewModel/RecommendationsViewModel.php`

```php
<?php
declare(strict_types=1);

namespace HyvaCompat\AcmeRecommendations\ViewModel;

use Acme\Recommendations\Api\RecommendationProviderInterface;
use Acme\Recommendations\Api\Data\RecommendationInterface;
use Magento\Framework\View\Element\Block\ArgumentInterface;
use Psr\Log\LoggerInterface;

class RecommendationsViewModel implements ArgumentInterface
{
    public function __construct(
        private readonly RecommendationProviderInterface $provider,
        private readonly LoggerInterface $logger
    ) {}

    /**
     * @return RecommendationInterface[]
     */
    public function getRecommendations(string $placement, ?int $productId = null): array
    {
        try {
            return $productId
                ? $this->provider->getForProduct($productId, $placement)
                : $this->provider->getForContext($placement);
        } catch (\Throwable $e) {
            $this->logger->error('Acme recs failed: ' . $e->getMessage(), [
                'placement' => $placement,
                'product_id' => $productId,
                'exception' => $e
            ]);
            return [];
        }
    }
}
```

Then in your layout XML, swap the argument:

```xml
<argument name="view_model" xsi:type="object">
    HyvaCompat\AcmeRecommendations\ViewModel\RecommendationsViewModel
</argument>
```

The wrapping has two big benefits:

- **Catches exceptions** — if the upstream module throws, your storefront stays up and the recs section is silently empty rather than 500-ing.
- **Stable interface** — if the upstream module refactors its internals, you only adjust this one file.

---

## 6. Disabling the Original `requirejs-config.js` on Hyvä

You don't have to do anything. Hyvä doesn't include `requirejs.js` on the page; the upstream `requirejs-config.js` is parsed but never executed because `requirejs` is undefined. No errors will appear in the console because the file is just declarations, not invocations.

If you observe console errors from inline scripts in the upstream module's `.phtml` (rare), the cleanest fix is to **remove the offending block** in `hyva_default.xml` (Section 3.5.2) — which we already did.

---

## 7. JavaScript: Translating Knockout to Alpine

If `Acme_Recommendations` ships behavior that goes beyond rendering (e.g., a "load more" button, a carousel, server-side pagination, click tracking analytics), translate each behavior to Alpine.

### 7.1 Place shared JS in `view/frontend/web/js/`

`app/code/HyvaCompat/AcmeRecommendations/view/frontend/web/js/recommendations-tracker.js`

```javascript
// Plain ES module that Hyvä's Alpine setup can call.
// No RequireJS, no AMD wrapper.

window.acmeRecsTracker = {
    track(eventName, payload) {
        // forward to whatever analytics endpoint Acme_Recommendations expects
        const url = BASE_URL + 'acme/recommendations/track';
        const fd  = new FormData();
        fd.append('form_key', hyva.getFormKey());
        fd.append('event', eventName);
        fd.append('payload', JSON.stringify(payload || {}));
        return fetch(url, {
            method: 'POST',
            body: fd,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        });
    }
};

document.addEventListener('acme-recs:click', (e) => {
    window.acmeRecsTracker.track('click', e.detail);
});
document.addEventListener('acme-recs:rendered', (e) => {
    window.acmeRecsTracker.track('impression', e.detail);
});
```

### 7.2 Include via Hyvä's `script_tag` macro

`view/frontend/layout/hyva_default.xml` — add to the existing file:

```xml
<referenceContainer name="before.body.end">
    <block name="hyva.compat.acme.recommendations.tracker"
           template="HyvaCompat_AcmeRecommendations::js/tracker.phtml"/>
</referenceContainer>
```

`view/frontend/templates/js/tracker.phtml`

```php
<?php
/** @var \Magento\Framework\View\Element\Template $block */
?>
<script>
    <?= /** @noEscape */ $block->getViewFileUrl(
        'HyvaCompat_AcmeRecommendations::js/recommendations-tracker.js',
        ['_secure' => true]
    ) ?
        // Hyvä convention: prefer inline scripts. For larger files, reference asset.
        '' : '' ?>
</script>
<script type="module" src="<?= $block->escapeUrl(
    $block->getViewFileUrl('HyvaCompat_AcmeRecommendations::js/recommendations-tracker.js')
) ?>"></script>
```

(For a small file you can also just inline the JS directly into the `tracker.phtml` template — Hyvä often inlines.)

---

## 8. Don't Break Luma — The Verification Checklist

This is critical given the B2B store view runs Luma. Test in this exact order:

1. **Switch to the Luma B2B store view** (use the store switcher / change `___store=` URL parameter).
2. Visit the homepage — the original `acme.recommendations.sidebar` block should render with KO. **If it does not, you've leaked a Hyvä-only layout change into the global scope.** Re-check that all your `referenceBlock remove="true"` entries live in `hyva_default*.xml` files and **not** in `default.xml`.
3. Visit a product page — `acme.recommendations.related` should render with KO.
4. Visit cart — `acme.recommendations.cart` should render with KO.
5. Switch to the **Hyvä main store view**.
6. Visit homepage — should see your Hyvä Tailwind sidebar block, **no KO/RequireJS console errors**.
7. Visit a product page — Hyvä related recs.
8. Visit cart — Hyvä cart recs.
9. Open browser devtools → Console: should be clean. No `Cannot read property 'koBindingHandlers' of undefined`, no `requirejs is not defined`, no 404s for `Magento_Ui/...` resources.
10. Open Network tab → confirm no `requirejs.js`, no `mage/utils/wrapper.js`, no UI-component bundles loading on the Hyvä side.

If a Luma store view is **broken** by your module: the most common cause is a `<referenceBlock remove="true"/>` in a non-Hyvä-handle layout file. Audit `view/frontend/layout/*.xml`. Anything that touches Luma blocks must live in `hyva_default*.xml`.

---

## 9. Build, Cache, Deploy

```bash
bin/magento module:enable HyvaCompat_AcmeRecommendations
bin/magento setup:upgrade
bin/magento cache:flush

# In dev mode (no asset compilation needed for Hyvä):
# Just refresh the page.

# In production mode:
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f
bin/magento cache:flush
```

Hyvä compiles its Tailwind CSS at the theme level, not at module deploy time. If you've added a new utility class that wasn't already in Hyvä's safelist, you may need to recompile Tailwind in your Hyvä theme:

```bash
cd app/design/frontend/<Vendor>/<theme>/web/tailwind
npm install   # if you haven't already
npm run build-prod
```

Or, if you're working in a clean Hyvä install, simply use `npm run watch` during development.

---

## 10. Ship It as a Composer Package (Optional but Recommended)

If you maintain several stores or want to share this with the community:

```bash
cd app/code/HyvaCompat/AcmeRecommendations
git init
git add .
git commit -m "Initial Hyvä compat for Acme_Recommendations"
git remote add origin https://github.com/yourorg/hyva-compat-acme-recommendations.git
git push -u origin main
```

Then in your project root:

```bash
composer config repositories.hyva-compat-acme vcs https://github.com/yourorg/hyva-compat-acme-recommendations
composer require hyvacompat/module-acme-recommendations:dev-main
bin/magento setup:upgrade
```

---

## 11. Final File Tree

```
app/code/HyvaCompat/AcmeRecommendations/
├── composer.json
├── registration.php
├── etc/
│   └── module.xml
├── ViewModel/
│   └── RecommendationsViewModel.php          (only if you wrapped the upstream Block)
└── view/
    └── frontend/
        ├── layout/
        │   ├── default.xml                   (intentionally empty / comment-only)
        │   ├── hyva_default.xml              (removals + sidebar add)
        │   ├── hyva_default_catalog_product_view.xml
        │   └── hyva_default_checkout_cart_index.xml
        ├── templates/
        │   ├── recommendations/
        │   │   ├── related.phtml
        │   │   ├── cart.phtml
        │   │   └── sidebar.phtml
        │   └── js/
        │       └── tracker.phtml
        └── web/
            └── js/
                └── recommendations-tracker.js
```

---

## 12. Common Pitfalls and How to Avoid Them

| Pitfall | Symptom | Fix |
|---|---|---|
| Putting `<referenceBlock remove>` in `default.xml` | Luma store view also loses recs | Move into `hyva_default.xml` |
| Forgetting `<sequence>` of `Hyva_CompatModuleFallback` | Removals applied before fallback's defensive layer; double-render or fight | Add `<sequence>` in `etc/module.xml` |
| Calling `requirejs(['acme/foo'], ...)` from a Hyvä template | RequireJS undefined error | Re-implement the JS in plain ES + Alpine |
| Using `mage/url` or `Magento_Customer/js/customer-data` | Not loaded on Hyvä | Use `BASE_URL`, `hyva.getFormKey()`, custom events |
| Hardcoding image paths | Inconsistent with other Hyvä product cards | Use `$block->getImage($product, 'category_page_grid')` |
| Forgetting to escape | XSS or broken markup | Always use `$escaper->escape*()` |
| ViewModel returns null instead of `[]` | Foreach over null warning | Defensive default `?? []` in the template |
| Caching `full_page` cache after layout change | Old layout sticks | `bin/magento cache:flush` |
| Theme not actually inheriting from `Hyva/default` | `hyva_default` handle never fires, layout files ignored | Check `app/design/frontend/<Vendor>/<theme>/theme.xml` `<parent>Hyva/default</parent>` |

---

## 13. Quick "Did This Work?" Smoke Test

After deploying:

```bash
# On the Hyvä store view:
curl -s "https://your-hyva-store.example.com/" | grep -c 'acme-recs-sidebar-heading'
# Expect: 1 (or more)

curl -s "https://your-hyva-store.example.com/" | grep -c 'data-bind='
# Expect: 0  (no Knockout left from Acme_Recommendations)

curl -s "https://your-hyva-store.example.com/" | grep -c 'requirejs'
# Expect: 0 or whatever Hyvä's baseline was

# On the Luma B2B store view (replace with your URL/store code):
curl -s "https://your-luma-b2b.example.com/" | grep -c 'data-bind='
# Expect: > 0 (Knockout still works on Luma)
```

If all three checks pass, you're done. The Hyvä storefront has native Tailwind/Alpine recommendations, the Luma B2B view is untouched, and you have a single isolated module that you can update independently.

---

## 14. Next Steps (Optional Polish)

- Add **integration tests** under `Test/Integration/` that boot Hyvä and assert your blocks render.
- Add a **functional test** with `Hyva_Test` if you use it.
- Add a **`README.md`** to your module describing supported `Acme_Recommendations` versions.
- Add **localized strings** via `i18n/en_US.csv` for the headings.
- Add **store config-driven feature flags** if you want admins to toggle each placement on/off in `Stores → Configuration`.
- Consider contributing back to `hyva-themes/magento2-*-hyva-compat` if the original module is open-source — the Hyvä community maintains compat modules in a single, discoverable namespace.

That's the full playbook. The pattern is reusable for any Luma-only module: **inventory → disable on Hyvä → reuse PHP → rewrite frontend in Tailwind+Alpine → verify both themes**.
