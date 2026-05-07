# Hyvä Compatibility Modules

## When to read this

You need to make a Luma-only Magento extension work with a Hyvä storefront. This is the most common form of Hyvä-specific module work.

## What's a compatibility module?

A separate Magento module that re-implements the **frontend parts** of a Luma extension for Hyvä. It pulls in the original module as a dependency (so the backend logic stays intact) and supplies:

- `hyva_*` layout XML overrides
- New `.phtml` templates without UI components / Knockout / RequireJS
- New JS (Alpine.js components) replacing any RequireJS-based JS
- Tailwind classes replacing LESS / inline styles
- Optionally: registration in `hyva-themes.json` so Hyvä knows the module is supported

## Naming convention

`<vendor>/magento2-hyva-compat-<original-module>`. Common vendors publish under `hyva-themes/magento2-hyva-compat-*`.

## Anatomy

```
app/code/Acme/HyvaCompatThirdParty/
├── composer.json
├── etc/
│   ├── module.xml
│   └── frontend/
│       ├── di.xml                  (optional — frontend-only DI)
│       └── sections.xml            (if customer section data changes)
├── registration.php
├── view/frontend/
│   ├── layout/
│   │   ├── hyva_default.xml        (overrides applied only on Hyvä storefronts)
│   │   └── hyva_thirdparty_view.xml
│   ├── templates/
│   │   └── thirdparty/
│   │       └── widget.phtml        (new Hyvä-style template)
│   ├── web/
│   │   └── js/                     (optional — but inline scripts in phtml are preferred)
│   └── requirejs-config.js          (USUALLY NOT — see below)
└── README.md
```

### `composer.json`

```json
{
    "name": "acme/magento2-hyva-compat-thirdparty",
    "description": "Hyvä compatibility for ThirdParty_Module",
    "type": "magento2-module",
    "require": {
        "php": ">=8.1",
        "thirdparty/module-something": "*",
        "hyva-themes/magento2-theme-module": "^1.3"
    },
    "autoload": {
        "files": ["registration.php"],
        "psr-4": { "Acme\\HyvaCompatThirdParty\\": "" }
    },
    "extra": {
        "hyva-themes": {
            "compat-module-for": ["ThirdParty_Module"]
        }
    }
}
```

The `extra.hyva-themes.compat-module-for` is what lets Hyvä's tooling identify your module as a compat. List every original module name your compat replaces UI for.

### `etc/module.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="Acme_HyvaCompatThirdParty">
        <sequence>
            <module name="ThirdParty_Module"/>
            <module name="Hyva_Theme"/>
        </sequence>
    </module>
</config>
```

### Layout overrides only on Hyvä storefronts

Use `hyva_*` handles. The corresponding non-Hyvä handle stays as the original module's layout (so Luma store views work normally).

`view/frontend/layout/hyva_thirdparty_widget_view.xml`:
```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceBlock name="thirdparty.widget">
            <action method="setTemplate">
                <argument name="template" xsi:type="string">Acme_HyvaCompatThirdParty::thirdparty/widget.phtml</argument>
            </action>
        </referenceBlock>
    </body>
</page>
```

This swaps just the template. The block class, view models, and PHP wiring are unchanged.

### A new Hyvä-style template

`view/frontend/templates/thirdparty/widget.phtml`:
```php
<?php
/** @var \ThirdParty\Module\Block\Widget $block */
/** @var \Magento\Framework\Escaper $escaper */

$widgetData = $block->getWidgetData();
?>
<div x-data="initThirdpartyWidget()" class="card p-4 my-4">
    <h3 class="text-lg font-semibold mb-2">
        <?= $escaper->escapeHtml(__('Recently viewed')) ?>
    </h3>
    <ul class="space-y-2">
        <template x-for="item in items" :key="item.id">
            <li class="flex items-center gap-2">
                <img :src="item.image" :alt="item.name" class="w-12 h-12 object-cover">
                <a :href="item.url" class="hover:underline" x-text="item.name"></a>
                <span class="ml-auto" x-text="hyva.formatPrice(item.price)"></span>
            </li>
        </template>
    </ul>
</div>

<script>
    function initThirdpartyWidget() {
        return {
            items: <?= /* @noEscape */ json_encode($widgetData, JSON_THROW_ON_ERROR) ?>,
        };
    }
</script>
```

## When to NOT use a compat module

If the original extension already has Hyvä support (look for `view/frontend/layout/hyva_*.xml` files in its source), you don't need a compat. Many vendors now ship Hyvä support directly.

Check the [Compatibility Module Tracker](https://gitlab.hyva.io/hyva-public/module-tracker/-/boards) to see if a compat already exists for the extension.

## Removing UI components from a layout

If the original extension declares a UI component (`<uiComponent name="..."/>`) you need to replace, the cleanest approach is to remove the block and add your own:

```xml
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceBlock name="thirdparty.uicomponent" remove="true"/>
        <referenceContainer name="content">
            <block name="thirdparty.hyva.widget"
                   template="Acme_HyvaCompatThirdParty::thirdparty/widget.phtml"/>
        </referenceContainer>
    </body>
</page>
```

## Removing RequireJS modules

Hyvä strips most RequireJS infrastructure. If the original module had a `requirejs-config.js` that mapped `Vendor_Module/js/foo` → some path, that file is loaded but the script never gets a chance to run because there's no `data-mage-init`.

Don't try to make RequireJS work. Re-implement the JS as Alpine.js inline or as a theme module JS file. If the original JS was server-rendered into `<script type="text/x-magento-init">`, replace it with a simple inline `<script>` or Alpine `x-data`.

## Section data providers

If the original extension provided customer section data, it usually still works — Hyvä uses Magento's section data subsystem under the hood. But check:

1. The section is listed in `etc/frontend/sections.xml` for the relevant action.
2. The section provider class implements `\Magento\Customer\CustomerData\SectionSourceInterface`.
3. Your Hyvä template reads it from `event.detail.data['<section-name>']`.

If the extension also tries to **render** a section using Knockout templates, that part needs reimplementing in Alpine. See `section-data.md`.

## Registering the compat module with Hyvä

Two ways:

**1. Composer extra (preferred)** — add to `composer.json`:
```json
"extra": {
    "hyva-themes": {
        "compat-module-for": ["ThirdParty_Module"]
    }
}
```

**2. `hyva-themes.json` (legacy)** — if your module is installed without Composer (`app/code/`), you can list it manually in `app/etc/hyva-themes.json`. The Composer-based mechanism is preferred for any new module.

The end result is that `hyva-themes/magento2-theme-module` knows your module exists and is Hyvä-compatible. This mainly affects the diagnostic command:
```bash
bin/magento hyva:check
```

## Testing the compat module

1. Install on a Magento with Hyvä Default Theme active.
2. Visit the page where the original extension's frontend is shown.
3. Verify the new template renders, with no console errors.
4. Verify network requests succeed and section data updates correctly.
5. Test in a Luma store view (if you have one) — the original module should still work there because your overrides are scoped to `hyva_*` handles.

## Tailwind class scanning

If your compat module's templates use Tailwind classes that aren't already in the parent theme, the build needs to scan them. Add to the **child theme's** `web/tailwind/hyva.config.json`:

```json
{
  "tailwind": {
    "include": [
      { "src": "vendor/hyva-themes/magento2-default-theme" },
      { "src": "vendor/acme/magento2-hyva-compat-thirdparty" }
    ]
  }
}
```

Or, if installed in `app/code/`:
```json
{ "src": "app/code/Acme/HyvaCompatThirdParty" }
```

Then rebuild: `npm run build`.

## A typical compat module checklist

- [ ] `composer.json` with `extra.hyva-themes.compat-module-for` populated
- [ ] `etc/module.xml` with `sequence` for the original module + `Hyva_Theme`
- [ ] `view/frontend/layout/hyva_*.xml` — overrides scoped to Hyvä handles only
- [ ] Templates rewritten in Hyvä style (Alpine + Tailwind, no Knockout, no RequireJS, no UI components)
- [ ] Inline `<script>` blocks instead of `<script type="text/x-magento-init">`
- [ ] Tested on both Hyvä and Luma store views
- [ ] README documenting which module versions are supported

## Original sources

- `references/sources/hyva-themes/compatibility-modules/index.md` — overview
- `references/sources/hyva-themes/compatibility-modules/getting-started.md` — step-by-step compat module guide
- `references/sources/hyva-themes/compatibility-modules/technical-deep-dive.md` — registration mechanism, `hyva-themes.json`, fallback module
- `references/sources/hyva-themes/compatibility-modules/development-guidelines.md` — code conventions for compat modules
- `references/sources/hyva-themes/compatibility-modules/from-luma-to-hyva/migrating-js-and-templates.md` — JS/template migration patterns
- `references/sources/hyva-themes/writing-code/layout-and-templates/the-hyva_-layout-handles.md` — the `hyva_*` handle mechanism
- The [Compatibility Module Tracker](https://gitlab.hyva.io/hyva-public/module-tracker/-/boards) (external) — check before writing your own
