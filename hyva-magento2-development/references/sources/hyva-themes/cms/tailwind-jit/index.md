<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/index.html -->

# CMS Tailwind JIT Module

The CMS Tailwind JIT module (`Hyva_CmsTailwindJit`) enables Tailwind CSS classes to work in CMS-managed content. Tailwind's standard build only includes classes found in your theme's template files at compile time. Classes added by content editors in CMS blocks, pages, or product descriptions are never scanned at build time and end up missing from the compiled `styles.css`.

The module solves this by running a browser-based Tailwind compiler whenever content is saved in the Magento admin. The compiled CSS is stored in the database and injected inline immediately before the content when it renders on the storefront. This happens entirely at save time, so there is no performance impact on storefront page loads.

Supports both Tailwind v3 and v4

A single module ships both the Tailwind v3 and the Tailwind v4 in-browser compiler. Which one the admin uses is selected with a global system configuration setting. Updating to this module from the Tailwind v3 only version is a backward-compatible upgrade: the default compiler is Tailwind v3, so existing installations require no changes.

Switching the setting to Tailwind v4 is **not** backward compatible — any custom per-theme styles must be migrated to the Tailwind v4 CSS format, and CMS entities must be re-saved so their CSS is recompiled. Existing v3 styles do, however, continue to render correctly on the frontend even after switching to v4. See [Selecting the Tailwind Compiler Version](installation.html#selecting-the-tailwind-compiler-version) and [Migrating from Tailwind v3 to v4](configuration.html#migrating-from-tailwind-v3-to-v4).

## What is in this section

Most projects only need the first two pages — install the module and, if a theme customizes Tailwind, add a per-theme config.

**Getting started**

- [Installation](installation.html): install the module and select the Tailwind compiler version.
- [Configuration](configuration.html): per-theme Tailwind configuration, for both Tailwind v3 and v4.

**Advanced (in-browser)**

- [Custom Content Types](extending.html): add JIT compilation support to your own content types.
- [Using with Alpine.js](alpine-js.html): an edge case when Tailwind classes contain single quotes inside `:class` bindings.

**Server-side compilation (optional)**

An alternative backend that compiles on the server instead of in the browser. It uses each theme's regular Tailwind configuration (no separate in-browser config to maintain) and supports store views on different Tailwind versions in parallel. See the [Server-Side Compilation overview](server-side-compilation.html) for the full picture.

## Supported Content Types

The CMS Tailwind JIT module compiles and injects Tailwind styles for the following content types:

- **CMS Blocks** - Reusable content blocks used throughout the site
- **CMS Pages** - Full standalone pages managed in the Magento admin
- **Product Descriptions** - Both full description and short description fields
- **Category Descriptions** - Category landing page content

The module integrates with multiple Magento content editors:

- Hyvä CMS
- Magento PageBuilder
- The classic TinyMCE editor

In PageBuilder, the content preview feature works for both CMS Block widgets and HTML Code content types.

## Under the Hood

You don't need these details to use the module — they are here for troubleshooting and for developers integrating their own content types.

Where compiled CSS is stored

The module stores compiled CSS in dedicated database tables, mapped to the entity ID and store view, so no on-the-fly compilation is needed during frontend requests.

| Content Type | Database Table |
| --- | --- |
| CMS Blocks | `hyva_cms_block_tailwindcss` |
| CMS Pages | `hyva_cms_page_tailwindcss` |
| Product Descriptions | `hyva_catalog_product_tailwindcss` |
| Category Descriptions | `hyva_catalog_category_tailwindcss` |

Stored CSS rows render correctly across compiler-version switches. Both the Tailwind v3 and the Tailwind v4 output flow through the same render-time pipeline, so rows compiled under one version continue to render after switching to the other.


How CSS is scoped to each entity

To prevent CMS styles from leaking into the rest of the page, the compiled CSS is isolated per entity at render time. The class names in both the compiled CSS and the entity content are rewritten with a per-entity prefix in the form `hcms-{type}-{id}-` — for example `.bg-red-300` becomes `.hcms-page-42-bg-red-300`. This keeps the styles scoped without needing a wrapper element.

**Legacy prefix changed when Tailwind v4 support was added.** The Tailwind v3 only versions of the module used the prefixes `cmsp{id}-` and `cmsb{id}-`. The module now uses the unified `hcms-{type}-{id}-` prefix on the legacy fallback path as well. Theme CSS that hand-targets the old `cmsp{id}-*` / `cmsb{id}-*` class names will no longer match after updating the module. If you rely on the old prefix form, recompile the stored CSS by re-saving the affected CMS content.
