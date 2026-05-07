# Hyvä Documentation — Embedded Source Index

This directory contains the official Hyvä documentation as published at [docs.hyva.io](https://docs.hyva.io/), bundled with this skill so you can read the canonical source without external network access. Files are kept in their original directory structure under `references/sources/`.

When a reference file in `references/` cites a doc from this index, **read the original here first** if you need depth, version-specific details, or examples beyond what the curated reference provides. The curated reference files distill the most-used patterns; these source files are exhaustive.

## Top-level layout

```
references/sources/
├── welcome/                       # What is Hyvä, technical vision, support, slack channels
├── hyva-themes/                   # The Hyvä Default Theme — everything frontend
│   ├── getting-started/
│   ├── building-your-theme/       # Child themes, fonts, localization, Luma fallback, accessibility
│   ├── writing-code/              # Templates, view models, JS events, fetch, CSP, form validation
│   │   ├── csp/                   # CSP-strict Alpine, CSP nonce providers
│   │   ├── form-validation/
│   │   ├── layout-and-templates/
│   │   ├── patterns/
│   │   └── working-with-view-models/
│   ├── working-with-tailwindcss/  # Tailwind v4 in Hyvä, design tokens, hyva.config.json
│   │   ├── design-tokens/
│   │   └── using-hyva-modules/    # hyva-sources / hyva-tokens commands
│   ├── working-with-alpinejs/     # Alpine v3 in Hyvä
│   │   └── alpine-plugins/
│   ├── compatibility-modules/     # Making Luma extensions work with Hyvä
│   ├── cms/                       # CMS pages with Tailwind classes
│   ├── performance/               # Core Web Vitals, FPC, ESI, view-model cache tags, bfcache
│   ├── advanced-topics/           # Email styling, base layout resets, npm packages
│   ├── upgrading/                 # Version migrations (Tailwind v3→v4, Alpine v2→v3, etc.)
│   ├── faqs/                      # ~30+ FAQ entries: captcha, CSP, troubleshooting, etc.
│   ├── ai/                        # AI tooling docs
│   ├── certification/             # Hyvä developer certification
│   └── view-utilities/
├── hyva-checkout/                 # Hyvä Checkout (Magewire-based)
│   ├── getting-started/
│   ├── features/
│   ├── magewire/                  # Magewire framework docs (Livewire-style PHP components)
│   ├── devdocs/
│   │   └── custom-checkout/       # checkout XML, custom components
│   ├── examples/                  # JS payment method example
│   ├── integrations/              # Available payment methods
│   ├── faq/
│   └── upgrading/
├── hyva-commerce/                 # Hyvä Commerce (admin dashboard, image editor, menu builder, CMS)
├── hyva-enterprise/               # Hyvä Enterprise edition (EDS, switcher component)
├── hyva-admin/                    # Hyvä Admin (alternative admin UI)
├── hyva-ui-library/               # Hyvä UI Library (component library shared across products)
├── hyva-widgets/                  # Hyvä Widgets product
├── hyva-coding-standard/          # PHPCS coding standard rules for Hyvä code
└── magento2-hyva-admin/           # Magento2 Hyva Admin (older project)
```

## Quick lookup — when you need the canonical source

| If you're working on… | Start with |
| --- | --- |
| Installing or activating Hyvä | `welcome/what-is-hyva.md`, `hyva-themes/getting-started/index.md` |
| Creating a child theme | `hyva-themes/building-your-theme/index.md` |
| Writing a `.phtml` template / view model | `hyva-themes/writing-code/working-with-view-models/index.md` |
| `hyva_*` layout handles | `hyva-themes/writing-code/layout-and-templates/the-hyva_-layout-handles.md` |
| `window.hyva` helpers | `hyva-themes/writing-code/the-window-hyva-object.md` |
| Hyvä JS events | `hyva-themes/writing-code/hyva-javascript-events.md` |
| `private-content-loaded` / section data | `hyva-themes/writing-code/working-with-sectiondata.md` |
| `fetch()` patterns in Hyvä | `hyva-themes/writing-code/using-fetch.md` |
| Form validation (browser-native + Alpine) | `hyva-themes/writing-code/form-validation/index.md` |
| GraphQL on Hyvä | `hyva-themes/writing-code/customizing-graphql.md` |
| Tailwind v4 setup | `hyva-themes/working-with-tailwindcss/index.md`, `supported-versions.md`, `generating-css.md` |
| `hyva.config.json` & design tokens | `hyva-themes/working-with-tailwindcss/design-tokens/index.md`, `using-hyva-modules/` |
| Tailwind v3→v4 migration | `hyva-themes/working-with-tailwindcss/updating-to-tailwind-3.md`, `hyva-themes/upgrading/upgrade-helper.md` |
| Dynamic Tailwind class issues | `hyva-themes/working-with-tailwindcss/dynamic-tailwind-classes.md`, `tailwind-purging-settings.md` |
| Alpine v3 in Hyvä | `hyva-themes/working-with-alpinejs/index.md` |
| Alpine plugins | `hyva-themes/working-with-alpinejs/alpine-plugins/` |
| CSP-strict Alpine | `hyva-themes/writing-code/csp/index.md` (and the canonical at `hyva-themes/writing-code/csp/...` — currently consolidated as one index) |
| Compatibility modules | `hyva-themes/compatibility-modules/index.md`, `getting-started.md`, `technical-deep-dive.md` |
| Migrating Luma JS / templates | `hyva-themes/compatibility-modules/from-luma-to-hyva/migrating-js-and-templates.md` |
| Performance / Core Web Vitals | `hyva-themes/performance/core-web-vitals.md`, `hyva-performance-tips.md`, `block-html-full-page-caching.md`, `view-model-cache-tags.md`, `bfcache.md`, `speculation-rules.md` |
| Upgrading Hyvä versions | `hyva-themes/upgrading/index.md` and the `upgrading-to-1-X-Y.md` files |
| Default theme changelog | `hyva-themes/upgrading/changelog-default-theme.md` |
| Theme module changelog | `hyva-themes/upgrading/changelog-theme-module.md` |
| Security changelog | `hyva-themes/upgrading/security-changelog.md` |
| FAQ / common gotchas | `hyva-themes/faqs/` (one file per topic) |
| Hyvä Checkout overview | `hyva-checkout/index.md`, `getting-started/index.md` |
| Magewire (the framework Hyvä Checkout is built on) | `hyva-checkout/magewire/index.md` |
| Hyvä Checkout XML structure | `hyva-checkout/devdocs/custom-checkout/hyva-checkout-xml.md` |
| Adding a payment method to Hyvä Checkout | `hyva-checkout/examples/js-payment-method.md`, `hyva-checkout/integrations/available-payment-methods.md` |
| Hyvä CMS / Commerce / Enterprise / Admin / UI Library | top-level dirs of the same name |

## How to use this from within the skill

The curated `references/<topic>.md` files synthesize the patterns most needed for actual coding tasks — read those first. If they don't fully answer a question, drop into `references/sources/` for the original. Search by `Grep` rather than reading top-down — the source tree is large.

Example queries that work well via Grep on the `sources/` tree:

- "When did Hyvä add `hyva.alpineInitialized`?" → `Grep` for `alpineInitialized` in `references/sources/`
- "Is there a built-in Hyvä helper for X?" → `Grep` X in `references/sources/hyva-themes/writing-code/`
- "What is the upgrade path from 1.3.10 to 1.4.0?" → look in `references/sources/hyva-themes/upgrading/upgrading-to-1-*-*.md`
- "Does FAQ cover this?" → `Grep` in `references/sources/hyva-themes/faqs/`
