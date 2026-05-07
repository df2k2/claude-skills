# Displaying Store Opening Hours in the Hyvä Footer (Hyvä 1.4)

This guide shows the idiomatic, **Hyvä-way** of pulling
`general/store_information/hours` from store config and rendering it in the
footer of your Hyvä 1.4 child theme.

We use a **ViewModel** (the Magento-recommended pattern Hyvä endorses) so the
logic stays out of the template, is unit-testable, and is reusable in any
`.phtml` (footer, contact page, header, CMS block via `argument` directives,
etc.).

We then plug the ViewModel into the existing Hyvä footer using a small
`layout XML` override + a copy of the footer template.

---

## 1. High-level approach

There are three things you need to do:

1. **Create a Magento module** (or extend an existing one in your project) that
   contains the ViewModel class. ViewModels are PHP classes — they live in a
   module, not in a theme.
2. **Wire the ViewModel into the footer block** via a `default.xml` layout
   update inside your **child theme**.
3. **Override `Magento_Theme::html/footer.phtml`** in your child theme so the
   markup can read the ViewModel and render the hours alongside (or instead of)
   the existing copyright line.

Hyvä’s footer is rendered by the `Magento\Theme\Block\Html\Footer` block via
the `Magento_Theme::html/footer.phtml` template, so this is the touch-point we
use.

> Why a ViewModel and not a helper, plugin or a template-only approach?
> Magento 2.2+ deprecated injecting helpers/blocks into templates. ViewModels
> are the supported way to expose backend data to a template. Hyvä follows
> this convention everywhere (look at any `*ViewModel.php` shipped with
> `Hyva_Theme` / `Hyva_DefaultModule`).

---

## 2. File overview

You will end up with the following files. The exact vendor / module name is up
to you — replace `Acme` / `StoreInfo` with your own naming.

```
app/code/Acme/StoreInfo/
├── etc/
│   └── module.xml
├── registration.php
└── ViewModel/
    └── StoreHours.php

app/design/frontend/<Vendor>/<child-theme>/
├── Magento_Theme/
│   ├── layout/
│   │   └── default.xml
│   └── templates/
│       └── html/
│           └── footer.phtml
└── (existing theme.xml, registration.php, etc.)
```

---

## 3. Create the module that hosts the ViewModel

ViewModels must live in a module, not a theme. If you already have a
project-specific module (e.g. `Acme_Theme`), put the ViewModel there and skip
to step 3.4.

### 3.1 `app/code/Acme/StoreInfo/registration.php`

```php
<?php
declare(strict_types=1);

use Magento\Framework\Component\ComponentRegistrar;

ComponentRegistrar::register(
    ComponentRegistrar::MODULE,
    'Acme_StoreInfo',
    __DIR__
);
```

### 3.2 `app/code/Acme/StoreInfo/etc/module.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="Acme_StoreInfo">
        <sequence>
            <module name="Magento_Store"/>
            <module name="Magento_Theme"/>
        </sequence>
    </module>
</config>
```

### 3.3 The ViewModel: `app/code/Acme/StoreInfo/ViewModel/StoreHours.php`

```php
<?php
declare(strict_types=1);

namespace Acme\StoreInfo\ViewModel;

use Magento\Framework\App\Config\ScopeConfigInterface;
use Magento\Framework\View\Element\Block\ArgumentInterface;
use Magento\Store\Model\ScopeInterface;

/**
 * Exposes the `general/store_information/hours` store-config value to
 * Hyvä templates. Used by the footer (and any other template that wants
 * to render store opening hours).
 */
class StoreHours implements ArgumentInterface
{
    /**
     * Store configuration path for opening hours.
     */
    public const XML_PATH_STORE_HOURS = 'general/store_information/hours';

    public function __construct(
        private readonly ScopeConfigInterface $scopeConfig
    ) {
    }

    /**
     * Returns the raw configured value (may contain newlines).
     */
    public function getHours(): string
    {
        $value = $this->scopeConfig->getValue(
            self::XML_PATH_STORE_HOURS,
            ScopeInterface::SCOPE_STORE
        );

        return is_string($value) ? trim($value) : '';
    }

    /**
     * Convenience: true if the admin has actually configured hours.
     */
    public function hasHours(): bool
    {
        return $this->getHours() !== '';
    }

    /**
     * Returns the configured hours as a list of trimmed lines, ready
     * for templating. Empty lines are skipped.
     *
     * @return string[]
     */
    public function getHoursLines(): array
    {
        $raw = $this->getHours();
        if ($raw === '') {
            return [];
        }

        // The admin field is a textarea — split on any line ending.
        $lines = preg_split('/\r\n|\r|\n/', $raw) ?: [];

        $clean = [];
        foreach ($lines as $line) {
            $line = trim($line);
            if ($line !== '') {
                $clean[] = $line;
            }
        }

        return $clean;
    }
}
```

Notes:

* `ArgumentInterface` is the marker interface Magento uses to identify a class
  as a ViewModel. Without it the template `argument` won’t resolve.
* PHP 8 constructor property promotion is fine for Magento 2.4.4+ (Hyvä 1.4
  baseline). On older PHP, expand it to a normal constructor.
* All escaping is left to the template — that’s the Hyvä convention.
* The class is **stateless** and **store-aware** (`SCOPE_STORE`), so it works
  out-of-the-box on multi-store installs.

After adding the module run:

```bash
bin/magento module:enable Acme_StoreInfo
bin/magento setup:upgrade
bin/magento cache:flush
```

---

## 4. Wire the ViewModel into the footer block (in your child theme)

Hyvä’s footer block is `footer` (alias `copyright`) defined in
`vendor/magento/module-theme/view/frontend/layout/default.xml`. Add an
`argument` of type `object` so the existing `Magento\Theme\Block\Html\Footer`
block exposes our ViewModel to the template.

### `app/design/frontend/<Vendor>/<child-theme>/Magento_Theme/layout/default.xml`

If you already have a `default.xml` in your child theme, just merge the
`<referenceBlock>` block in. Otherwise create the file:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      layout="1column"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceBlock name="footer">
            <arguments>
                <argument name="store_hours_view_model" xsi:type="object">
                    Acme\StoreInfo\ViewModel\StoreHours
                </argument>
            </arguments>
        </referenceBlock>
    </body>
</page>
```

That’s all the wiring you need. Any template that renders the `footer` block
can now do `$block->getStoreHoursViewModel()` to get the instance.

> Hyvä-specific tip: Hyvä uses the standard Magento_Theme footer block, so
> this layout XML works identically to vanilla Luma. If your child theme
> already extends `Hyva/default`, no further parent configuration is needed —
> Hyvä’s `default.xml` will be merged with yours.

---

## 5. Render the hours in the footer template

Copy Hyvä’s footer template into your child theme so you can edit it without
touching `vendor/`:

**Source** (read-only reference):
`vendor/hyva-themes/magento2-default-theme/Magento_Theme/templates/html/footer.phtml`

**Destination** (your child theme, edit this file):
`app/design/frontend/<Vendor>/<child-theme>/Magento_Theme/templates/html/footer.phtml`

Add the following snippet inside the existing footer markup. The exact spot
depends on your design — most teams drop it above the copyright line or in a
dedicated footer column.

```php
<?php
/**
 * @var \Magento\Theme\Block\Html\Footer            $block
 * @var \Magento\Framework\Escaper                  $escaper
 * @var \Hyva\Theme\Model\ViewModelRegistry         $viewModels
 */

/** @var \Acme\StoreInfo\ViewModel\StoreHours $storeHours */
$storeHours = $block->getStoreHoursViewModel();
?>

<?php if ($storeHours && $storeHours->hasHours()): ?>
    <section class="store-hours mb-4 text-sm"
             aria-labelledby="footer-store-hours-heading">
        <h3 id="footer-store-hours-heading"
            class="font-semibold mb-2 uppercase tracking-wide">
            <?= $escaper->escapeHtml(__('Opening Hours')) ?>
        </h3>
        <ul class="space-y-1">
            <?php foreach ($storeHours->getHoursLines() as $line): ?>
                <li><?= $escaper->escapeHtml($line) ?></li>
            <?php endforeach; ?>
        </ul>
    </section>
<?php endif; ?>
```

Why this template is Hyvä-idiomatic:

* It uses the `$escaper` object, which is the **mandatory** way to escape in
  Hyvä (no `$block->escapeHtml()` — that pulls in the deprecated `Mage_Core`
  helper chain).
* It uses **Tailwind utility classes** (`mb-4`, `text-sm`, `space-y-1`,
  `uppercase`, `tracking-wide`, etc.). Adjust to your design tokens.
* No JavaScript, no Knockout, no `x-data` — opening hours are static config,
  so we keep it server-rendered. (If you want a collapsible widget, wrap
  the `<section>` in an Alpine.js `x-data` scope; the data still comes from
  the ViewModel.)
* Conditional rendering via `hasHours()` so the section disappears cleanly
  when the admin hasn’t configured a value — no empty `<ul>` left behind.

---

## 6. Configure the value in the admin

The ViewModel reads `general/store_information/hours`, which corresponds to:

> **Stores → Configuration → General → General → Store Information → Hours of Operation**

It’s a textarea, so editors can put one day per line:

```
Mon – Fri: 09:00 – 18:00
Sat: 10:00 – 16:00
Sun: Closed
```

The `getHoursLines()` method splits on any line ending and trims empty rows,
so the markup stays predictable regardless of how editors enter the value.

---

## 7. Reuse the ViewModel elsewhere

Because it’s a real ViewModel, you can drop it into any other template
without duplicating the config-read logic.

### 7.1 In a layout-driven block (anywhere on the site)

```xml
<referenceBlock name="contact.form">
    <arguments>
        <argument name="store_hours_view_model" xsi:type="object">
            Acme\StoreInfo\ViewModel\StoreHours
        </argument>
    </arguments>
</referenceBlock>
```

Then in the template:

```php
$storeHours = $block->getStoreHoursViewModel();
```

### 7.2 In a CMS block / page (Hyvä Magewire / Alpine widget pattern)

If you build a custom widget, request the ViewModel through Hyvä’s
`ViewModelRegistry`:

```php
<?php
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
$storeHours = $viewModels->require(\Acme\StoreInfo\ViewModel\StoreHours::class);
?>
```

This is the Hyvä-recommended way to pull a ViewModel inside a template that
isn’t directly tied to a block argument (e.g. a `\Magento\Cms\Block\Block`
inside a CMS page). It guarantees the same singleton instance regardless of
where you render it.

---

## 8. Deploy / verify

```bash
bin/magento module:enable Acme_StoreInfo
bin/magento setup:upgrade
bin/magento setup:di:compile      # required if you’re in production mode
bin/magento cache:flush
```

Then load any storefront page — you should see the **Opening Hours** block in
the footer when the admin field is populated, and nothing at all when it’s
empty.

---

## 9. Optional improvements

These are out of scope for the basic task but worth knowing:

* **Schema.org markup**: Wrap the list in a
  `<div itemscope itemtype="https://schema.org/LocalBusiness">` and emit
  `openingHours` meta tags for SEO. The ViewModel is the right place to
  parse the textarea into structured day/time pairs.
* **Per-day collapsing widget**: Wrap the `<section>` in an Alpine.js
  `x-data="{ open: false }"` scope to make it collapsible on mobile.
* **Holiday overrides**: Add a second store-config field (e.g.
  `general/store_information/hours_notice`) and expose it via a second
  method on the same ViewModel.
* **Caching**: Reads from `ScopeConfigInterface` are already cached by
  Magento’s config cache, so no extra caching layer is needed.

---

## 10. Recap — the four touch-points

| # | File | Purpose |
|---|---|---|
| 1 | `app/code/Acme/StoreInfo/registration.php` + `etc/module.xml` | Register the module that hosts the ViewModel. |
| 2 | `app/code/Acme/StoreInfo/ViewModel/StoreHours.php` | Reusable ViewModel that reads `general/store_information/hours`. |
| 3 | `app/design/frontend/<Vendor>/<child-theme>/Magento_Theme/layout/default.xml` | Inject the ViewModel into the footer block. |
| 4 | `app/design/frontend/<Vendor>/<child-theme>/Magento_Theme/templates/html/footer.phtml` | Render the hours using `$escaper` and Tailwind classes. |

That’s the canonical Hyvä 1.4 way: backend logic in a ViewModel, template
escaping via `$escaper`, presentation via Tailwind utilities, and zero
business logic in the `.phtml`.
