---
name: hyva-magento2-development
description: "Build, customize, and debug Hyvä themes for Magento 2 — covering Hyvä 1.4.x with Tailwind CSS v4 and Alpine.js v3. Use this skill whenever the user works on a Hyvä Magento store and asks to write a phtml template, Alpine component, layout XML override, view model, child theme, compatibility module for a Luma extension, Hyvä Checkout (Magewire) code, or any storefront customization. Trigger on mentions of Hyvä, Hyva, @private-content-loaded, x-data, $viewModels, hyva.config.json, tailwind-source.css, hyva-themes/magento2-* packages, Hyva\\Theme PHP classes, hyva_* layout handles, hyva JS helpers (hyva.postForm, hyva.getFormKey, hyva.formatPrice), section data, CSP-compatible Alpine, or Tailwind v3→v4 migration. Trigger even when the user only says this Magento store uses Hyvä — Hyvä replaces Knockout, RequireJS, LESS, UI components, and jQuery so generic Magento 2 frontend advice will mislead them."
---

# Hyvä Themes Development for Magento 2

Hyvä is a frontend stack for Magento 2 that **replaces** Luma's Knockout/RequireJS/LESS/UI-components pile with Tailwind CSS + Alpine.js + native browser APIs. It still uses Magento's PHP layer (layout XML, blocks, view models, phtml), but the JavaScript and CSS world looks completely different. Generic Magento 2 frontend advice will lead the user astray — most of what Luma developers know about `$.ajax`, `<script type="text/x-magento-init">`, `data-mage-init`, `Magento_Ui/js/grid/columns/...`, RequireJS shims, `mixins.js`, etc. simply does not apply.

This skill keeps the latest Hyvä conventions (1.4.x with Tailwind v4 and Alpine v3) front-of-mind while you work.

## Versions this skill targets

- **Hyvä Theme**: 1.4.x (Default Theme + theme-module)
- **Tailwind CSS**: v4 (CSS-first config via `@theme`, `hyva.config.json` + `tailwind-source.css`)
- **Alpine.js**: v3 (with optional CSP-safe build for PCI-DSS compliance)
- **Magento**: 2.4.4-p9 / 2.4.5-p8 / 2.4.6-p7 / 2.4.7-p1 or higher
- **PHP**: 8.1+ (7.4 dropped in 2026)
- **Node.js**: 20+ (for Hyvä 1.4.x build)

If the user is on an older Hyvä release, ask which version. The big breakpoints:
- 1.0.x / 1.1.x → Tailwind v2, Alpine v2
- 1.2.x / 1.3.x → Tailwind v3, Alpine v3
- 1.4.x → Tailwind v4, Alpine v3, no reset-theme parent

## When to consult this skill vs. when to just answer

Always consult it when the work touches a Hyvä theme. The JS/CSS conventions are different enough that even small tasks (adding a button, styling a price) need Hyvä-specific patterns. If you're unsure whether the store is Hyvä, look for these signals:

- `app/design/frontend/*/theme.xml` references `Hyva/default` or `Hyva/default-csp` as parent
- `web/tailwind/` directory with `hyva.config.json` and `tailwind-source.css`
- `composer.json` has `hyva-themes/magento2-*` packages
- Templates use `$viewModels->require(...)` instead of `$block->...`
- `*.phtml` contains `x-data`, `@click`, `:class`, `x-show` (Alpine syntax)
- Layout XML uses `hyva_default`, `hyva_catalog_product_view`, etc.

## Confirm before assuming

Before writing code, confirm a few things if not already obvious:

1. **Hyvä version** (1.4.x assumed; older needs different patterns)
2. **CSP mode or not?** Strict CSP changes how Alpine components are written (`x-data="myComponent"` instead of `x-data="{ open: false }"`). Hyvä Checkout, payment pages, and Hyvä's CSP build all require this.
3. **Are they working in a child theme or the default theme?** Customizations belong in a child theme.
4. **Is the work for a custom theme, a module, or a compatibility module for an existing Luma extension?**

Don't pepper them with all four if the request is clear — only confirm what's actually ambiguous.

## How to find what you need

This skill ships with two layers of documentation:

1. **Curated references** in `references/*.md` — synthesized, opinionated guides for the patterns you'll hit most. Read these first.
2. **Embedded source docs** in `references/sources/` — the full official Hyvä documentation (every page from docs.hyva.io, ~375 markdown files). Drop into these when the curated reference isn't enough, or when you need version-specific detail / canonical wording. See `references/sources/INDEX.md` for a topic-to-file map.

Each curated reference file ends with an "Original sources" pointer to the relevant embedded files. Use `Grep` to search across `references/sources/` for keywords, function names, or version notes — the tree is large enough that top-down reading wastes time.

The curated references cover the topics deeply. Read the one(s) that match the task before writing code — they have the current syntax, edge cases, and gotchas. Each is self-contained with examples.

| Task | Reference |
| --- | --- |
| Install Hyvä, set up a child theme, theme.xml, parent path config | `references/theme-setup.md` |
| Write a `.phtml` template, use `$viewModels`, layout XML, blocks, `hyva_*` handles, `$block`, `$escaper` | `references/templates-and-blocks.md` |
| Write an Alpine.js component (standard, non-CSP) — `x-data`, `x-show`, `x-for`, `@click`, init, lifecycle | `references/alpine-components.md` |
| CSP-safe Alpine — registered components, `Alpine.data()`, `hyva.createBooleanObject`, `x-model` alternatives | `references/alpine-csp.md` |
| Tailwind v4 in Hyvä — `hyva.config.json`, `tailwind-source.css`, `@theme`, design tokens, component CSS, building | `references/tailwind-v4.md` |
| Hyvä JS events — `private-content-loaded`, `reload-customer-section-data`, `toggle-cart`, `update-gallery`, etc. | `references/javascript-events.md` |
| `window.hyva` helpers — `hyva.postForm`, `hyva.getFormKey`, `hyva.formatPrice`, `hyva.str`, `hyva.replaceDomElement`, `hyva.activateScripts`, `hyva.alpineInitialized` | `references/window-hyva-helpers.md` |
| Section data — receiving customer/cart in Alpine, default values, force reload | `references/section-data.md` |
| Make a Luma module work with Hyvä — compatibility module structure, hyva-themes.json registration | `references/compatibility-modules.md` |
| Customize Hyvä Checkout — Magewire components, `hyva-checkout.xml`, payment integrations | `references/hyva-checkout.md` |
| Upgrade Hyvä versions, migrate Tailwind v3→v4 / Alpine v2→v3 | `references/upgrading.md` |
| Performance — view model cache tags, FPC, ESI, deferred rendering, CWV | `references/performance.md` |
| Common gotchas — captcha, minification, GraphQL modules, theme inheritance, missing styles | `references/common-pitfalls.md` |

## Patterns that bite Luma developers

These are mistakes a Luma-experienced developer will make on Hyvä unless steered. Watch for them and steer.

### Don't reach for jQuery, RequireJS, or Knockout
Hyvä has none of them. Use `window.fetch` (not `$.ajax`), Alpine.js (not Knockout's `data-bind`), and inline `<script>` tags or theme module JS (not `requirejs-config.js` or `text!*` plugins). If you see `define([...])` in Hyvä code, that's a smell.

### Don't use UI components or `<script type="text/x-magento-init">`
Hyvä's `default.xml` strips most of Magento's UI-component plumbing. The minicart, product gallery, swatches, etc. are all reimplemented as Alpine components. If a tutorial says "extend the Magento_Catalog/js/product/view/provider component," that path doesn't exist here.

### Don't put customizations in `Hyva/default`
The default theme is a vendor package. Always work in a child theme at `app/design/frontend/Vendor/ThemeName/` with parent `Hyva/default`. See `references/theme-setup.md`.

### Don't forget Tailwind purging
Tailwind only includes classes it can statically find in scanned files. Classes built from variables (`'bg-' + color`) get purged. See `references/tailwind-v4.md` for safelist patterns. **Always rebuild CSS** (`npm run build`) after adding new classes, or run `npm run watch` during dev.

### Don't fetch view models with XML when you don't need to
The view model registry makes XML declarations unnecessary in 99% of cases:
```php
$currentProduct = $viewModels->require(\Hyva\Theme\ViewModel\CurrentProduct::class);
```
This works in any phtml. No `<arguments><argument name="view_model">…</argument></arguments>` needed.

### Don't write `data-mage-init` or trigger Magento JS events that don't exist
Hyvä events have different names. The cart isn't refreshed by `customer-data.invalidate(['cart'])` — it's `window.dispatchEvent(new Event('reload-customer-section-data'))`. See `references/javascript-events.md`.

### Don't use `addslashes` to embed PHP into JS
Use `$escaper->escapeJs(...)` for inline JS, `$escaper->escapeHtmlAttr(...)` for attribute values, and `json_encode(...)` for structured data passed to Alpine `x-data`. Inline `<script>` blocks need `$escaper->escapeJs()` or you get XSS.

### Don't disable CSP without a reason
If the user is implementing PCI-DSS compliant payment pages or using `Hyva/default-csp`, follow `references/alpine-csp.md` strictly. Inline `x-data="{ open: false }"` won't work — you need `x-data="myComponent"` and `Alpine.data('myComponent', () => ({...}))` registered.

## Default working style

When the user gives a task:

1. **Read the relevant reference file(s) first.** Hyvä syntax has changed across versions — don't go from memory.
2. **Confirm the version and CSP mode if ambiguous.** Especially for Alpine code.
3. **Write Hyvä-style code.** Tailwind utilities, Alpine for behavior, `$viewModels` for data, native `fetch` for Ajax, `private-content-loaded` for customer state.
4. **Use the child theme path.** Templates go in `app/design/frontend/Vendor/ThemeName/Magento_X/templates/...` (matching the path inside the parent), not `vendor/hyva-themes/...`.
5. **Tell the user the build step.** New Tailwind classes need `npm run build` or `npm run watch` from `web/tailwind/`. New PHP code needs `bin/magento cache:flush` (and `setup:upgrade` if it's a new module). Production needs `setup:static-content:deploy`.
6. **Sanity check escaping.** Hyvä templates always have `$escaper`, `$block`, `$viewModels` in scope. Use them.

## A small example: pattern to follow

User: "Add a 'My Quick Notes' field to the customer account page that saves locally."

Bad answer (Luma-think):
> Use Knockout to bind to localStorage and a UI component for the input...

Good answer (Hyvä):

`app/design/frontend/Acme/default/Magento_Customer/templates/account/quick-notes.phtml`:
```php
<?php
/** @var \Magento\Framework\Escaper $escaper */
?>
<div
    x-data="{
        notes: localStorage.getItem('quick-notes') || '',
        save() { localStorage.setItem('quick-notes', this.notes); }
    }"
    class="card p-4 my-4"
>
    <h3 class="text-lg font-semibold mb-2"><?= $escaper->escapeHtml(__('Quick notes')) ?></h3>
    <textarea
        x-model="notes"
        @change="save()"
        rows="4"
        class="form-textarea w-full"
        placeholder="<?= $escaper->escapeHtmlAttr(__('Notes saved on this device only')) ?>"
    ></textarea>
</div>
```

Then add it to the layout:

`app/design/frontend/Acme/default/Magento_Customer/layout/customer_account_index.xml`:
```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="customer_account_dashboard_top">
            <block name="customer.dashboard.notes"
                   template="Magento_Customer::account/quick-notes.phtml"/>
        </referenceContainer>
    </body>
</page>
```

Then: `bin/magento cache:flush` and from the child theme's `web/tailwind/`, run `npm run build`.

If the store uses CSP, this `x-data="{ … }"` won't work — see `references/alpine-csp.md` for the registered-component variant.
