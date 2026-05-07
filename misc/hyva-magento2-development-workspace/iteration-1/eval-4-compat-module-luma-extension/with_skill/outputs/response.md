# Building a Hyvä compatibility module for `Acme_Recommendations`

This is the textbook scenario for a **Hyvä compatibility (compat) module**. You don't fork or replace `Acme_Recommendations` — you ship a separate module that:

1. Depends on the original `Acme_Recommendations` for all backend logic (controllers, models, GraphQL resolvers, DB schema, ACL, observers, plugins, REST endpoints).
2. Replaces the **frontend layer** — the Knockout/UI-component templates and RequireJS JS — with Hyvä-style equivalents (Alpine.js + Tailwind + native `fetch`).
3. Scopes those overrides to `hyva_*` layout handles so the Luma B2B store view is **completely untouched** — Magento's theme fallback + the hyva-only handles guarantee that.

The mental model: one set of PHP runs everywhere, two sets of frontend assets live side by side, Magento picks the right one per store view. Luma keeps its Knockout. Hyvä gets Alpine. Nothing leaks across.

Below is a complete walkthrough. I assume Hyvä 1.4.x with Tailwind v4 / Alpine v3 (the versions this skill targets). If you're on an older Hyvä release tell me and I'll flag the differences (mainly Tailwind config syntax and a few directives).

---

## 0. Before you write a single line, check three things

Five minutes here saves a day of compat-module work that turns out to be unnecessary.

**a. Does a community compat already exist?** Hyvä maintains a public tracker at `https://gitlab.hyva.io/hyva-public/module-tracker`. If `Acme_Recommendations` already has a compat (community or vendor-supplied), use that and stop. Many Luma extensions also now ship Hyvä support directly inside their main composer package — look in the vendor module's source for `view/frontend/layout/hyva_*.xml`. If those files exist, no compat module is needed at all.

**b. What does the original module actually expose on the frontend?** Map the surface area before writing anything:

```bash
# In your Magento root:
ls -1 vendor/acme/module-recommendations/view/frontend/layout/    # XML handles
ls -1 vendor/acme/module-recommendations/view/frontend/templates/ # phtml files
ls -1 vendor/acme/module-recommendations/view/frontend/web/       # JS / Knockout / requirejs-config
grep -rl "x-magento-init\|data-bind\|uiComponent" vendor/acme/module-recommendations/view/frontend/
```

Write down for each handle: which block name, which template, which JS component initializes it, what it renders, what user actions are possible, and what server endpoints those actions hit. That list is your acceptance criteria for the compat module.

**c. Confirm the install path of the third-party module.** Anywhere `vendor/acme/...` appears below assumes Composer install. If the vendor delivered a zip you dropped in `app/code/Acme/Recommendations/`, replace `vendor/acme/module-recommendations` with `app/code/Acme/Recommendations` everywhere.

---

## 1. Module skeleton

Create the compat as a separate Magento module. Naming convention is `<vendor>/magento2-hyva-compat-<original>`. I'll use `YourCompany_HyvaCompatAcmeRecommendations` for the PHP namespace.

```
app/code/YourCompany/HyvaCompatAcmeRecommendations/
├── composer.json
├── registration.php
├── README.md
├── etc/
│   ├── module.xml
│   └── frontend/
│       ├── di.xml          (only if you need a section-data default)
│       └── sections.xml    (only if you need to register an Ajax action)
└── view/frontend/
    ├── layout/
    │   ├── hyva_default.xml
    │   ├── hyva_catalog_product_view.xml
    │   └── hyva_<other handles you need>.xml
    └── templates/
        └── recommendations/
            └── widget.phtml   (one per template you replace)
```

Note: **no `requirejs-config.js`** and **no `view/frontend/web/js/`** for Knockout components. Hyvä strips most of the RequireJS/UI-component plumbing in `default.xml`, so attempting to "translate" the existing `Acme_Recommendations/js/...` files into a Hyvä RequireJS setup is wasted work — the framework that would consume them isn't there. Re-implement behavior as Alpine, inline.

### `composer.json`

```json
{
    "name": "yourcompany/magento2-hyva-compat-acme-recommendations",
    "description": "Hyvä compatibility for Acme_Recommendations",
    "type": "magento2-module",
    "license": "proprietary",
    "require": {
        "php": ">=8.1",
        "acme/module-recommendations": "*",
        "hyva-themes/magento2-theme-module": "^1.3"
    },
    "autoload": {
        "files": ["registration.php"],
        "psr-4": {
            "YourCompany\\HyvaCompatAcmeRecommendations\\": ""
        }
    },
    "extra": {
        "hyva-themes": {
            "compat-module-for": ["Acme_Recommendations"]
        }
    }
}
```

The `extra.hyva-themes.compat-module-for` block is the modern way to register your module with Hyvä's tooling — `bin/magento hyva:check` will report `Acme_Recommendations` as supported once you install this. (The legacy alternative is editing `app/etc/hyva-themes.json` by hand; only fall back to that if your module isn't installed via Composer.)

Pin `acme/module-recommendations` to the actual constraint that's in your project root `composer.json` (e.g. `"^2.0"`) once you know the module versions you support and have tested against — `*` is fine while developing.

### `registration.php`

```php
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::MODULE,
    'YourCompany_HyvaCompatAcmeRecommendations',
    __DIR__
);
```

### `etc/module.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="YourCompany_HyvaCompatAcmeRecommendations">
        <sequence>
            <module name="Acme_Recommendations"/>
            <module name="Hyva_Theme"/>
        </sequence>
    </module>
</config>
```

The `sequence` matters: your layout XML must be merged **after** `Acme_Recommendations`'s, otherwise your `setTemplate` actions and `referenceBlock` overrides may not see the blocks they're trying to modify. `Hyva_Theme` should also precede yours so its `hyva_*` handles are processed.

---

## 2. The two surgical strategies for replacing the frontend

Pick one of these per block, depending on what the original module declares.

### Strategy A — Original block uses a normal `.phtml`: just swap the template

Most third-party modules render their Knockout markup from a server-side `.phtml` that emits a `<script type="text/x-magento-init">` JSON config alongside a `<div data-bind="...">` skeleton. The block class itself is fine; only the template needs replacing.

`view/frontend/layout/hyva_<original_handle>.xml`:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceBlock name="acme.recommendations.widget">
            <action method="setTemplate">
                <argument name="template" xsi:type="string">YourCompany_HyvaCompatAcmeRecommendations::recommendations/widget.phtml</argument>
            </action>
        </referenceBlock>
    </body>
</page>
```

What's load-bearing about the file name `hyva_<handle>.xml`: Hyvä's frontend dispatches an extra layout handle prefixed with `hyva_` for every standard handle (`default` → `hyva_default`, `catalog_product_view` → `hyva_catalog_product_view`, etc.). These handles are **only applied when the active theme inherits from `Hyva/default`**. Your Luma B2B store view never hits them, so its `acme.recommendations.widget` block keeps its original Knockout template.

You need to find the actual handle the original module declares its block under. Check `vendor/acme/module-recommendations/view/frontend/layout/`. If the original declares its block in `default.xml`, your override goes in `hyva_default.xml`. If `catalog_product_view.xml`, yours is `hyva_catalog_product_view.xml`. Match each one.

### Strategy B — Original declares a `<uiComponent>`: remove and replace

If the original layout has `<uiComponent name="acme_recommendations.widget"/>` or wires up the block via `<argument name="component" xsi:type="string">Acme_Recommendations/js/widget</argument>`, the cleanest fix is to remove the block entirely and add a Hyvä-native one in its place:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceBlock name="acme.recommendations.widget" remove="true"/>
        <referenceContainer name="content">
            <block name="acme.recommendations.widget.hyva"
                   template="YourCompany_HyvaCompatAcmeRecommendations::recommendations/widget.phtml"
                   after="-"/>
        </referenceContainer>
    </body>
</page>
```

If the data the original UI component fetched lived on a block class that's still useful (e.g. the block exposes `getRecommendedProducts()`), declare your replacement block to use the same class:

```xml
<block class="Acme\Recommendations\Block\Widget"
       name="acme.recommendations.widget.hyva"
       template="YourCompany_HyvaCompatAcmeRecommendations::recommendations/widget.phtml"
       after="-"/>
```

That way your phtml gets `$block->getRecommendedProducts()` exactly like the Luma template did.

If the data was only available via the UI component's data provider and there's no block-level method, you have two reasonable options: (a) write a tiny view model in the compat module that calls the data provider directly, or (b) call the same controller endpoint client-side via `fetch` from your Alpine component. Pick whichever has less moving parts — usually (a) for one-shot page-load data, (b) for actions triggered after page load.

---

## 3. The Hyvä-style template

Here's a representative widget. Adapt the data-fetching half to whatever shape `Acme_Recommendations` actually exposes.

`view/frontend/templates/recommendations/widget.phtml`:

```php
<?php
declare(strict_types=1);

/** @var \Acme\Recommendations\Block\Widget $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */

// Pull whatever the original block exposes server-side.
// If the data only comes from an Ajax endpoint, leave $items empty
// and fetch it from x-init in the Alpine component below.
$items = [];
foreach ($block->getRecommendedProducts() as $product) {
    $items[] = [
        'id'    => (int) $product->getId(),
        'name'  => (string) $product->getName(),
        'sku'   => (string) $product->getSku(),
        'url'   => (string) $product->getProductUrl(),
        'image' => (string) $block->getImageUrl($product),
        'price' => (float) $product->getFinalPrice(),
    ];
}

if (empty($items)) {
    return;
}
?>
<div
    x-data="initAcmeRecommendations()"
    x-cloak
    class="acme-recommendations my-8"
    data-component="acme-recommendations"
>
    <h2 class="text-2xl font-semibold mb-4">
        <?= $escaper->escapeHtml(__('Recommended for you')) ?>
    </h2>

    <ul class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <template x-for="item in items" :key="item.id">
            <li class="card p-3 flex flex-col">
                <a :href="item.url" class="block">
                    <img
                        :src="item.image"
                        :alt="item.name"
                        loading="lazy"
                        class="w-full aspect-square object-cover mb-2"
                    >
                    <span class="font-medium line-clamp-2" x-text="item.name"></span>
                </a>
                <span class="mt-2 text-lg" x-text="hyva.formatPrice(item.price)"></span>

                <button
                    type="button"
                    class="btn btn-primary mt-3"
                    :disabled="adding === item.id"
                    @click="addToCart(item)"
                >
                    <span x-show="adding !== item.id"><?= $escaper->escapeHtml(__('Add to cart')) ?></span>
                    <span x-show="adding === item.id"><?= $escaper->escapeHtml(__('Adding…')) ?></span>
                </button>
            </li>
        </template>
    </ul>
</div>

<script>
    function initAcmeRecommendations() {
        return {
            items: <?= /* @noEscape */ json_encode($items, JSON_THROW_ON_ERROR) ?>,
            adding: null,

            async addToCart(item) {
                this.adding = item.id;
                try {
                    const response = await fetch('<?= $escaper->escapeJs($block->getUrl('checkout/cart/add')) ?>', {
                        method: 'POST',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest',
                            'Accept': 'application/json'
                        },
                        body: new URLSearchParams({
                            form_key: hyva.getFormKey(),
                            product:  item.id,
                            qty:      '1'
                        })
                    });
                    if (!response.ok) {
                        throw new Error('Cart add failed: ' + response.status);
                    }
                    window.dispatchEvent(new Event('reload-customer-section-data'));
                    typeof window.dispatchMessages === 'function' && window.dispatchMessages([
                        { type: 'success', text: hyva.str('"%1" was added to your cart.', item.name) }
                    ], 5000);
                } catch (e) {
                    console.error(e);
                    typeof window.dispatchMessages === 'function' && window.dispatchMessages([
                        { type: 'error', text: '<?= $escaper->escapeJs(__('Could not add to cart.')) ?>' }
                    ], 5000);
                } finally {
                    this.adding = null;
                }
            }
        };
    }
</script>
```

Key points worth pausing on:

- **`/** @var */` annotations** at the top give editors type info and make the contract explicit. Standard Hyvä-template scope is `$block`, `$escaper`, `$viewModels` — all three are always available.
- **`x-data="initAcmeRecommendations()"`** delegates to a function rather than embedding a long state object inline. Keeps the markup readable and the component testable. Note: this is the standard (non-CSP) pattern; if your store uses `Hyva/default-csp` (PCI-DSS payment pages or similar), this won't run — see the CSP note further down.
- **`<?= /* @noEscape */ json_encode($items, JSON_THROW_ON_ERROR) ?>`** — for structured data going into a `<script>` tag, `json_encode` produces safe JS literal output, no escaping needed. Use `JSON_THROW_ON_ERROR` so encoding bugs blow up loudly instead of silently writing `false`. The `/* @noEscape */` annotation suppresses Magento's static analyser warning.
- **`$escaper->escapeJs(...)`** for any string interpolated *inside* JS string literals (the URL, the error message). For raw text in HTML it'd be `escapeHtml`, for attribute values `escapeHtmlAttr`.
- **`hyva.getFormKey()`** instead of reading a Knockout-supplied form key. This is the Hyvä helper — generates a key if needed, returns the existing one otherwise.
- **`hyva.formatPrice(item.price)`** instead of `Magento.Price.format(...)`. Currency-aware, locale-aware, included in `window.hyva`.
- **`window.dispatchEvent(new Event('reload-customer-section-data'))`** is how you tell Hyvä to refresh customer/cart state after a successful POST. There is no `customerData.invalidate(['cart'])` here — that's Luma. The event triggers a single fetch to `/customer/section/load`, repopulates `localStorage`, and dispatches `private-content-loaded` so the mini-cart counter updates.
- **`window.dispatchMessages([...], 5000)`** is the Hyvä toast. Types: `success`, `notice`, `warning`, `error`. The defensive `typeof === 'function'` check is cheap insurance — heavily customized themes occasionally omit the dispatcher.
- **`x-cloak`** prevents the un-Alpine-styled markup from flashing before hydration. Hyvä's default CSS has the `[x-cloak] { display: none !important; }` rule.

If `Acme_Recommendations` ships customer-specific data (e.g. recommendations based on the logged-in customer), let the original block render the data **server-side** as it does today — Magento handles cache scoping. If the original module fetches per-customer data via Ajax to a section-data endpoint, you can listen for it instead:

```html
<div
    x-data="{ recommendations: [] }"
    @private-content-loaded.window="recommendations = $event.detail.data['acme-recommendations'] || []"
>
    <template x-for="item in recommendations" :key="item.id"> … </template>
</div>
```

This requires the original module to have registered its data as a customer section in `etc/frontend/sections.xml`. Most Knockout-based recommendation modules do exactly this — the same data flows through unchanged in Hyvä, you just receive it via the `private-content-loaded` event instead of via Knockout's `customerData.get('acme-recommendations')`.

---

## 4. Hooking into the right pages

For each handle the original module touches, create a corresponding `hyva_*.xml`. Common cases:

- **Sitewide widget (header / footer / homepage block):** `view/frontend/layout/hyva_default.xml`
- **Product page widget:** `view/frontend/layout/hyva_catalog_product_view.xml`
- **Cart page widget:** `view/frontend/layout/hyva_checkout_cart_index.xml`
- **CMS page widget:** `view/frontend/layout/hyva_cms_index_index.xml`
- **Category page widget:** `view/frontend/layout/hyva_catalog_category_view.xml`

If the module exposes a widget that customers can drop in via the admin Widgets UI (so the placement isn't hard-coded), the widget's render template is governed by the widget's own `widget.xml`. In that case override the **template path** the widget uses by setting it on the widget-rendering block, or replace the widget XML entirely. Walk me through which page the widget appears on if you hit this — the answer depends on the widget definition.

---

## 5. Tailwind class scanning

Tailwind v4 in Hyvä works by **scanning** template source files for class names. Classes that exist only in your compat module won't be in the parent theme's compiled CSS, and any unknown classes will be purged. You need to add your module to the child theme's Tailwind include list.

In your **child theme's** `web/tailwind/hyva.config.json`:

```json
{
    "tailwind": {
        "include": [
            { "src": "vendor/hyva-themes/magento2-default-theme" },
            { "src": "app/code/YourCompany/HyvaCompatAcmeRecommendations" }
        ]
    }
}
```

If your compat is installed via Composer instead of `app/code`:

```json
{ "src": "vendor/yourcompany/magento2-hyva-compat-acme-recommendations" }
```

Then rebuild Tailwind:

```bash
cd app/design/frontend/<Vendor>/<ChildTheme>/web/tailwind
npm run build       # or `npm run watch` during development
```

Forgetting this step is the #1 reason "the template renders but looks unstyled" after a compat module installation. Any class you write in the new phtml that wasn't already in the parent theme will be silently absent from `styles.css` until the build runs against the new path.

If a class is generated dynamically at runtime (`'bg-' + state.color`), Tailwind's static scan can't see it. Either avoid dynamic class names, or add them to the safelist via the `hyva.config.json`'s safelist option (see `references/tailwind-v4.md` if you hit that case).

---

## 6. Multi-store-view: making sure Luma stays untouched

Your setup has Hyvä on the main store view and Luma on a B2B store view. The compat module is automatically Hyvä-only because:

1. Every layout override sits in a `hyva_*` handle. Magento only dispatches those handles when the active theme inherits from `Hyva/default` — your B2B Luma store view never triggers them.
2. Your override templates only become referenced through those handles. Luma's `acme.recommendations.widget` keeps its `setTemplate` history pointing at `Acme_Recommendations::widget.phtml`.
3. You haven't registered anything via `<reference name="root" template="..."/>` or any other mechanism that runs on every theme.

That said, do these two sanity checks on the B2B side after you install the compat:

- **Verify no theme.xml of the B2B Luma child theme accidentally inherits `Hyva/default`** (would activate the `hyva_*` handles). It should inherit from `Magento/luma` or `Magento/blank`.
- **Verify the website-level theme is set explicitly.** Hyvä strongly recommends the website-level theme be configured (not "-- No Theme --"); same applies in mixed setups. Set Hyvä on the website level if your main store view dominates, and the B2B store view explicitly overrides to its Luma child.

Test cycle on both store views:

1. Switch to the Hyvä store view → visit pages where `Acme_Recommendations` renders → verify the new template renders, no console errors, "Add to cart" updates mini-cart.
2. Switch to the Luma B2B store view → same pages → verify the original Knockout-driven widget still renders exactly as before.
3. With browser DevTools open, on the Hyvä side, confirm there are **no** `RequireJS`, `mage/utils`, or `text!`-prefixed network requests originating from `Acme_Recommendations` files — if there are, the original `requirejs-config.js` is still wiring in something. That's a smell; check for stray inline `<script type="text/x-magento-init">` blocks in your compat template (don't write any) or for layout XML that's still pulling in a UI component.

---

## 7. CSP note

If your Hyvä install runs the CSP build (`Hyva/default-csp` parent — used for PCI-DSS-compliant payment pages and increasingly for whole-site CSP), the inline `<script>` and `x-data="initAcmeRecommendations()"` pattern shown above won't run as-is. CSP-strict mode requires:

- Components registered via `Alpine.data('initAcmeRecommendations', () => ({ ... }))` on the `alpine:init` event.
- All `x-data` directives reference registered names with no inline expressions (`x-data="initAcmeRecommendations"`, no parens).
- Inline scripts emit a CSP nonce via `Hyva\Theme\ViewModel\HyvaCsp`.

Adapt the template by moving the `initAcmeRecommendations` definition into either a theme JS file or a nonce'd `<script>` registered through the CSP view model. The full pattern is in `references/alpine-csp.md` if you go this route. For the standard (non-CSP) `Hyva/default` parent, what's shown above runs as-is.

How to tell which you're on: check the **child theme's** `theme.xml` at `app/design/frontend/<Vendor>/<ChildTheme>/theme.xml` — if `<parent>` is `Hyva/default-csp`, you're on the CSP build.

---

## 8. Install + verify

```bash
# 1. Register the compat module
bin/magento module:enable YourCompany_HyvaCompatAcmeRecommendations
bin/magento setup:upgrade
bin/magento setup:di:compile          # only needed in production mode

# 2. Build Tailwind in the child theme
npm --prefix app/design/frontend/<Vendor>/<ChildTheme>/web/tailwind ci
npm --prefix app/design/frontend/<Vendor>/<ChildTheme>/web/tailwind run build

# 3. Cache flush
bin/magento cache:flush

# 4. (Production only) static content
bin/magento setup:static-content:deploy -f
```

Then verify with Hyvä's diagnostic command:

```bash
bin/magento hyva:check
```

If the `extra.hyva-themes.compat-module-for` block in your `composer.json` is set up correctly, you'll see `Acme_Recommendations` listed as supported.

---

## 9. Final checklist

- [ ] `composer.json` with `extra.hyva-themes.compat-module-for: ["Acme_Recommendations"]`
- [ ] `etc/module.xml` with `sequence` for `Acme_Recommendations` and `Hyva_Theme`
- [ ] One `hyva_<handle>.xml` per original handle that needs a Hyvä-style template
- [ ] Templates use Alpine + Tailwind, no Knockout `data-bind`, no `<script type="text/x-magento-init">`, no `x-magento-template`, no `data-mage-init`
- [ ] `hyva.getFormKey()` in any POST body
- [ ] `window.dispatchEvent(new Event('reload-customer-section-data'))` after any state-changing POST
- [ ] Use `hyva.formatPrice`, `hyva.str`, `hyva.postForm`, `window.dispatchMessages` rather than Luma equivalents
- [ ] All view-model lookups via `$viewModels->require(...)` — no XML `<argument xsi:type="object">` plumbing needed
- [ ] Child theme's `web/tailwind/hyva.config.json` includes the compat module's path
- [ ] `npm run build` rerun after every template change that introduces new Tailwind classes
- [ ] Tested on **both** Hyvä and Luma B2B store views — Luma must look and behave identically to before
- [ ] No Hyvä console errors, no RequireJS/Knockout requests, mini-cart and section data update correctly
- [ ] README in the compat module documenting the supported `Acme_Recommendations` version range

If any specific step is murky for the actual `Acme_Recommendations` module (which handles it touches, what Ajax endpoints it hits, whether it uses section data, whether it's a UI component or a plain Knockout `.phtml`), share `vendor/acme/module-recommendations/view/frontend/layout/` and one of its templates and I'll show the exact override.
