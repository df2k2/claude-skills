# Templates, Blocks, View Models, and Layout XML in Hyvä

## When to read this

You're writing or overriding a `.phtml` file, declaring a block, working with view models, manipulating layout XML, or trying to output product/customer/store data into a template.

## What's the same as Luma

Hyvä keeps Magento's PHP layer mostly intact:

- Layout XML files (`*.xml` in `Vendor/Theme/Magento_Module/layout/`)
- Block classes (PHP, often `Magento\Framework\View\Element\Template`)
- `.phtml` template files
- Magento's theme fallback (file in child theme overrides parent)
- The `$block` and `$escaper` variables in templates
- ACL, plugins, observers, DI all work normally

## What's different

Hyvä injects an additional variable into every template: `$viewModels` (an instance of `Hyva\Theme\Model\ViewModelRegistry`). Use it to fetch any view model without declaring it in XML:

```php
<?php

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Theme\ViewModel\CurrentProduct;

/** @var ViewModelRegistry $viewModels */
/** @var CurrentProduct $currentProduct */
$currentProduct = $viewModels->require(CurrentProduct::class);

$product = $currentProduct->get();
?>
<h1><?= $escaper->escapeHtml($product->getName()) ?></h1>
```

This is the **preferred** way. Don't add `<arguments><argument name="view_model" xsi:type="object">...</argument></arguments>` blocks just to inject a view model. Drop the class name into `$viewModels->require(...)` and you're done.

## The standard variables in any Hyvä phtml

```php
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
```

Add a `/** @var */` annotation at the top of every template — it gives editors type-checking and makes the contract obvious.

## View models are first-class

A view model is any class implementing `\Magento\Framework\View\Element\Block\ArgumentInterface`. Put them in `app/code/Acme/Module/ViewModel/Foo.php`:

```php
<?php
declare(strict_types=1);

namespace Acme\Module\ViewModel;

use Magento\Framework\View\Element\Block\ArgumentInterface;

class Foo implements ArgumentInterface
{
    public function __construct(
        private readonly \Magento\Customer\Model\Session $customerSession
    ) {}

    public function getCustomerName(): string
    {
        return $this->customerSession->getCustomer()->getName() ?? '';
    }
}
```

Then in any template:
```php
<?php
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
$foo = $viewModels->require(\Acme\Module\ViewModel\Foo::class);
?>
<div>Hello, <?= $escaper->escapeHtml($foo->getCustomerName()) ?></div>
```

### View models with cache tags

If a view model returns data tied to specific entities, implement `\Magento\Framework\DataObject\IdentityInterface` so the cache tags are added to the FPC `X-Magento-Tags` header:

```php
class CurrentProduct implements ArgumentInterface, \Magento\Framework\DataObject\IdentityInterface
{
    public function getIdentities(): array
    {
        return $this->product
            ? [\Magento\Catalog\Model\Product::CACHE_TAG . '_' . $this->product->getId()]
            : [];
    }
}
```

### View models in ESI-cached blocks

If a block has `ttl="..."` in layout XML (so Varnish caches it as ESI), pass `$block` as the second argument so cache tags go to the ESI record, not the FPC:

```php
$currentProduct = $viewModels->require(CurrentProduct::class, $block);
```

Only do this for view models in ESI-cached blocks — passing `$block` everywhere just-in-case is wrong.

## Layout XML in Hyvä

### `hyva_*` layout handles

For every standard handle Magento applies (e.g. `default`, `cms_index_index`, `customer_logged_out`), Hyvä applies an extra prefixed handle (`hyva_default`, `hyva_cms_index_index`, `hyva_customer_logged_out`) **after** the original. Use these prefixed handles for Hyvä-specific overrides — that way a module that ships both Luma and Hyvä support won't break Luma store views.

```
app/design/frontend/Acme/default/Magento_Catalog/layout/hyva_catalog_product_view.xml
```

Inside, normal layout XML — but applied only on Hyvä storefronts:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="product.info.main">
            <block name="custom.usp"
                   template="Acme_Module::product/usp.phtml"
                   before="-"/>
        </referenceContainer>
    </body>
</page>
```

### Detecting Hyvä in PHP

Inject `Hyva\Theme\Service\CurrentTheme` and call `isHyva()`:

```php
public function __construct(
    private readonly \Hyva\Theme\Service\CurrentTheme $currentTheme
) {}

public function execute()
{
    if ($this->currentTheme->isHyva()) {
        // …
    }
}
```

## Useful built-in view models

These ship with Hyvä and cover most common needs:

- `Hyva\Theme\ViewModel\CurrentProduct` — current PDP product
- `Hyva\Theme\ViewModel\CurrentCategory` — current category page
- `Hyva\Theme\ViewModel\CurrentCustomer` — logged-in customer
- `Hyva\Theme\ViewModel\Customer` — customer URL helpers, etc.
- `Hyva\Theme\ViewModel\Store` — store config, base URLs, locale
- `Hyva\Theme\ViewModel\StoreConfig` — typed access to store configuration
- `Hyva\Theme\ViewModel\Svg` — inline SVG icons (`$svg->renderHtml('icon-name', $width, $height)`)
- `Hyva\Theme\ViewModel\Heroicons` — Heroicons-set helpers
- `Hyva\Theme\ViewModel\HyvaCsp` — generate CSP nonces / track inline scripts (CSP-aware themes only)
- `Hyva\Theme\ViewModel\CustomerSectionData` — default section values

Find more by searching `vendor/hyva-themes/magento2-theme-module/src/ViewModel/`.

## Inline SVG icons

```php
<?php
/** @var \Hyva\Theme\ViewModel\Heroicons $heroicons */
$heroicons = $viewModels->require(\Hyva\Theme\ViewModel\Heroicons::class);
?>
<?= $heroicons->shoppingBagHtml('w-6 h-6', 24, 24) ?>
```

The first argument is CSS classes added to the SVG; second/third are width/height in pixels.

## Escaping

Always escape, always. Choose the right helper:

| Context | Helper |
| --- | --- |
| Text inside HTML (`<div>X</div>`) | `$escaper->escapeHtml($value)` |
| HTML attribute (`title="X"`) | `$escaper->escapeHtmlAttr($value)` |
| Inside a JS string literal in inline `<script>` | `$escaper->escapeJs($value)` |
| Inside a URL component | `$escaper->escapeUrl($value)` |
| Inside a CSS context | `$escaper->escapeCss($value)` |
| Inside an `x-data` JSON blob | `$escaper->escapeHtmlAttr(json_encode($data, JSON_THROW_ON_ERROR))` |

For passing structured PHP data into Alpine:

```php
<?php
$config = [
    'productId' => (int) $product->getId(),
    'imageUrl'  => $imageUrl,
];
?>
<div x-data='<?= $escaper->escapeHtmlAttr(json_encode($config, JSON_THROW_ON_ERROR)) ?>'>
    …
</div>
```

Note the **single quotes** around `x-data` so the JSON's double quotes don't conflict, and the `JSON_THROW_ON_ERROR` to fail loud.

## Translation

Translate strings with `__()` as in stock Magento:

```php
<?= $escaper->escapeHtml(__('Add to cart')) ?>
```

In JS, use `hyva.str` (mirrors PHP's `__` placeholder syntax):
```js
hyva.str('Welcome %1', customer.firstName)  // → "Welcome Jane"
```

## Block class vs. view model: when to use which

- **View models** for read-only data exposed to templates. Reusable across blocks. Almost always the right choice.
- **Block classes** when you need to override `_toHtml`, control rendering programmatically, manipulate child blocks, or hook into the layout instantiation lifecycle.

In practice, you can build most of Hyvä with view models. Stick to view models unless you have a clear reason to subclass `Template`.

## Referencing parent theme blocks

When overriding a template, mirror the path inside the child theme. To override `vendor/hyva-themes/magento2-default-theme/Magento_Catalog/templates/product/list.phtml`, place your override at:
```
app/design/frontend/Acme/default/Magento_Catalog/templates/product/list.phtml
```

Magento's theme fallback automatically picks the child file.

To **extend** rather than fully override, you can include the parent's template inside your override using `$block->fetchView('Magento_Catalog::product/list.phtml')` — but it's usually cleaner to copy and modify.

## A complete miniature example

`app/code/Acme/Module/ViewModel/StoreHours.php`:
```php
<?php
declare(strict_types=1);

namespace Acme\Module\ViewModel;

use Magento\Framework\View\Element\Block\ArgumentInterface;
use Magento\Store\Model\ScopeInterface;
use Magento\Framework\App\Config\ScopeConfigInterface;

class StoreHours implements ArgumentInterface
{
    public function __construct(
        private readonly ScopeConfigInterface $scopeConfig
    ) {}

    public function getHours(): string
    {
        return (string) $this->scopeConfig->getValue(
            'general/store_information/hours',
            ScopeInterface::SCOPE_STORE
        );
    }
}
```

`app/design/frontend/Acme/default/Magento_Theme/templates/html/store-hours.phtml`:
```php
<?php
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */

$hours = $viewModels->require(\Acme\Module\ViewModel\StoreHours::class)->getHours();
if (!$hours) {
    return;
}
?>
<div class="text-sm text-gray-600 my-2">
    <strong><?= $escaper->escapeHtml(__('Store hours:')) ?></strong>
    <span><?= $escaper->escapeHtml($hours) ?></span>
</div>
```

`app/design/frontend/Acme/default/Magento_Theme/layout/hyva_default.xml`:
```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="footer">
            <block name="store.hours"
                   template="Magento_Theme::html/store-hours.phtml"/>
        </referenceContainer>
    </body>
</page>
```

After this: `bin/magento cache:flush`, and `npm run build` from `web/tailwind/` if you added new utility classes.

## Original sources

- `references/sources/hyva-themes/writing-code/working-with-view-models/index.md` — the canonical view models doc
- `references/sources/hyva-themes/writing-code/layout-and-templates/the-hyva_-layout-handles.md` — `hyva_*` layout handles
- `references/sources/hyva-themes/writing-code/layout-and-templates/referencing-parent-theme-blocks.md` — referencing parent theme blocks
- `references/sources/hyva-themes/performance/view-model-cache-tags.md` — view model cache tags in depth (FPC, ESI)
- `references/sources/hyva-themes/writing-code/customizing-graphql.md` — GraphQL extension on Hyvä
- `references/sources/hyva-themes/faqs/javascript-files-and-compilers.md` — how Hyvä handles JS/CSS file processing
- The full source of Hyvä's view models is in `vendor/hyva-themes/magento2-theme-module/src/ViewModel/` — search there for class names like `Heroicons`, `Svg`, `StoreConfig`
