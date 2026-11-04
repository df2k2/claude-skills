# Hyvä Documentation — Embedded Source Index

This directory contains the official Hyvä documentation as published at [docs.hyva.io](https://docs.hyva.io/), bundled with this skill so you can read the canonical source without external network access. Files are kept in their original directory structure under `references/sources/`.

When a reference file in `references/` cites a doc from this index, **read the original here first** if you need depth, version-specific details, or examples beyond what the curated reference provides. The curated reference files distill the most-used patterns; these source files are exhaustive.

## Snapshot

Refreshed 2026-11-04. 519 pages (~4.6 MB):

- **426 pages from docs.hyva.io**, captured with `scripts/hyva/fetch_links_to_md.py` from the link lists in `scripts/hyva/*.txt`. Each file starts with a `<!-- source: … -->` comment naming its URL. This refresh:
  - re-fetched the 282 pages already listed (175 had changed upstream);
  - added 153 pages from the docs sitemap for the theme, checkout, and UI library: Hyvä 1.4.6–1.5.3 upgrade notes, the Hyvä Checkout 3.x / Magewire 3 docs, and the CSP, patterns, form-validation, modal, Alpine-plugin, design-token, and CMS Tailwind JIT sub-pages;
  - dropped 9 URLs that are now redirect stubs. Their destinations are captured instead.
- **91 pages in `magento2-hyva-admin/`**, the `docs/` folder of the GitHub repo `hyva-themes/magento2-hyva-admin`, identical to commit `8c35d970f412` (2026-06-26, tag 1.1.28). Images are not vendored.
- **2 files in `hyva-coding-standard/`**, `README.md` and `SECURITY.md` from the GitHub repo `hyva-themes/hyva-coding-standard` at commit `4aa4848cac5e` (2026-06-08, tag 1.0.11). The README now documents running the standard through Docker (`bin/phpcs-docker`).

Not captured on purpose, but available on docs.hyva.io: the new Hyvä POS product, most Hyvä Commerce feature pages, and Hyvä Enterprise upgrade notes.

## Top-level layout

```
references/sources/
├── welcome/                       # What is Hyvä, technical vision, support (incl. Slack channels)
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
│   ├── cms/                       # CMS content styling; tailwind-jit/ = Tailwind classes in CMS content (CMS Tailwind JIT module)
│   ├── performance/               # Core Web Vitals, FPC, ESI, view-model cache tags, bfcache
│   ├── advanced-topics/           # Email styling, base layout resets, npm packages
│   ├── upgrading/                 # Version migrations (Tailwind v3→v4, Alpine v2→v3, etc.)
│   ├── faqs/                      # ~30+ FAQ entries: captcha, CSP, troubleshooting, etc.
│   ├── ai/                        # AI tooling docs
│   ├── certification/             # Hyvä developer certification
│   └── view-utilities/            # modal-dialogs/, hyva-svg-icon-modules/, sliders, loading indicator
├── hyva-checkout/                 # Hyvä Checkout (Magewire-based): 3.x on Magewire 3, 1.x on Magewire 1
│   ├── getting-started/           # release-lines.md: Checkout 3.x vs 1.x
│   ├── features/
│   ├── magewire/                  # Magewire docs, Magewire 1→3 cheat sheet, migrating-to-magewire-3.md, v1bc.md
│   ├── devdocs/
│   │   ├── custom-checkout/       # checkout XML, custom components
│   │   ├── form-api/, form-customization/, evaluation-api/, place-order-service-api/, payments/
│   │   └── frontend-api/          # hyvaCheckout JS API ("V1" = JS API version, ships on both lines)
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
└── magento2-hyva-admin/           # Hyva_Admin module docs (admin grids/forms via XML), from GitHub hyva-themes/magento2-hyva-admin
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
| Form validation (browser-native + Alpine) | `hyva-themes/writing-code/form-validation/javascript-form-validation.md`, `html5-input-types.md`, `triggering-native-validation-messages-with-javascript.md` (`index.md` is only a table of contents) |
| Luma → Hyvä code patterns (component communication, overriding JS, running code once private data loads, aborting fetches) | `hyva-themes/writing-code/patterns/` |
| GraphQL on Hyvä | `hyva-themes/writing-code/customizing-graphql.md` |
| Tailwind v4 setup | `hyva-themes/working-with-tailwindcss/index.md`, `supported-versions.md`, `generating-css.md` |
| `hyva.config.json` & design tokens | `hyva-themes/working-with-tailwindcss/design-tokens/` (`formats.md`, `simple-tokens.md`, `figma.md`, `google-stitch.md`, `claude-design.md`, `faq.md`), `using-hyva-modules/` (`sources.md`, `tokens.md`, `init.md`, `fallback.md`, `forms.md`, `prose.md`) |
| Fonts (Font API, `npx hyva-fonts`, 1.5.3+) | `hyva-themes/working-with-tailwindcss/using-hyva-modules/fonts.md` |
| Tailwind v3→v4 migration | `hyva-themes/working-with-tailwindcss/updating-to-tailwind-4.md`, `hyva-themes/upgrading/upgrade-helper.md` (`updating-to-tailwind-3.md` is the older v2→v3 guide) |
| Tailwind classes in CMS content | `hyva-themes/cms/tailwind-jit/` (client-side and server-side compilation) |
| Dynamic Tailwind class issues | `hyva-themes/working-with-tailwindcss/dynamic-tailwind-classes.md`, `tailwind-purging-settings.md` |
| Alpine v3 in Hyvä | `hyva-themes/working-with-alpinejs/index.md` |
| Alpine plugins | `hyva-themes/working-with-alpinejs/alpine-plugins/` — `x-htmldialog.md`, `x-html-safe.md`, `x-defer.md`, `x-intersect.md`, `x-ignore.md`, `x-snap-slider.md`, `custom.md` |
| Modals / dialogs (`hyva.modal`, native `<dialog>` since 1.5) | `hyva-themes/view-utilities/modal-dialogs/` — `index.md`, `confirmation-dialogs.md`, `modals-without-php.md`, `opening-a-modal-from-anywhere.md`, `nested-dialogs.md`, `keyboard-focus.md`, `legacy-modal-install.md`, `modal-view-model-reference.md` |
| SVG icons / images via view models | `hyva-themes/writing-code/working-with-view-models/svgicons.md`, `custom-svgicon-view-models.md`, `rendering-images.md`, `hyva-themes/view-utilities/hyva-svg-icon-modules/` |
| CSP-strict Alpine | `hyva-themes/writing-code/csp/` — `alpine-csp.md` (start here), `alpine-csp-properties.md`, `alpine-csp-property-mutation.md`, `alpine-csp-x-model.md`, `alpine-csp-x-for.md`, `alpine-csp-hyva-createbooleanobject.md`, `alpine-csp-html-safe.md`, `alpine-csp-constructor-functions.md`, `alpine-csp-example-component.md` |
| CSP policy, nonces, allowlist, migration tool | `hyva-themes/writing-code/csp/nonce-and-sha-hashes.md`, `content-security-policy-allowlist.md`, `csp-magento-configuration.md`, `csp-and-block-caching.md`, `csp-compatibility.md`, `migration-tool.md`, `hyva-default-theme-csp-installation.md`, `csp-in-context-payment-buttons.md` |
| Compatibility modules | `hyva-themes/compatibility-modules/index.md`, `getting-started.md`, `technical-deep-dive.md` |
| Migrating Luma JS / templates | `hyva-themes/compatibility-modules/from-luma-to-hyva/migrating-js-and-templates.md` |
| Performance / Core Web Vitals | `hyva-themes/performance/core-web-vitals.md`, `hyva-performance-tips.md`, `block-html-full-page-caching.md`, `view-model-cache-tags.md`, `bfcache.md`, `speculation-rules.md` |
| Upgrading Hyvä versions | `hyva-themes/upgrading/index.md` and the `upgrading-to-1-X-Y.md` files: final patch of each old minor (1-1-26, 1-2-9, 1-3-22) plus every 1.4.x and 1.5.x patch. There is no 1-5-0 page; **1.5.1 is the first 1.5 release** and `upgrading-to-1-5-1.md` is the 1.4 → 1.5 guide |
| Deploying (Adobe Commerce Cloud node daemons, Capistrano) | `hyva-themes/building-your-theme/adobe-commerce-cloud-deployment.md`, `adobe-cloud-node-daemons.md`, `capistrano-deployment.md` |
| Default theme changelog | `hyva-themes/upgrading/changelog-default-theme.md` |
| Theme module changelog | `hyva-themes/upgrading/changelog-theme-module.md` |
| Security changelog | `hyva-themes/upgrading/security-changelog.md` |
| FAQ / common gotchas | `hyva-themes/faqs/` (one file per topic) |
| Hyvä Checkout overview | `hyva-checkout/index.md`, `getting-started/index.md` |
| Which Checkout line (3.x vs 1.x) and Magewire version | `hyva-checkout/getting-started/release-lines.md`, `hyva-checkout/faq/what-is-v1bc.md` |
| Magewire (the framework Hyvä Checkout is built on) | `hyva-checkout/magewire/index.md` (includes the Magewire 1 → 3 cheat sheet) |
| Moving checkout code to Magewire 3 / v1bc | `hyva-checkout/magewire/migrating-to-magewire-3.md`, `hyva-checkout/magewire/v1bc.md`, `hyva-checkout/upgrading/upgrading-to-3.0.0.md` |
| Checkout changelogs | `hyva-checkout/upgrading/changelog.md` (3.x), `changelog-1.x.md` (1.x) |
| Checkout forms (fields, attributes, modifiers, address lines) | `hyva-checkout/devdocs/form-api/`, `hyva-checkout/devdocs/form-customization/` |
| Checkout JavaScript API (`hyvaCheckout.*`) | `hyva-checkout/devdocs/frontend-api/` (`architecture.md`, `events.md`, `backport.md`, `V1/api.md`, `V1/evaluation.md`, `V1/payment.md`, `V1/storage.md`) |
| Checkout payment integration API | `hyva-checkout/devdocs/payments/payment-introduction.md`, `payment-integration-api.md`, `hyva-checkout/devdocs/place-order-service-api/` |
| Hyvä Checkout XML structure | `hyva-checkout/devdocs/custom-checkout/hyva-checkout-xml.md` |
| Adding a payment method to Hyvä Checkout | `hyva-checkout/examples/js-payment-method.md`, `hyva-checkout/integrations/available-payment-methods.md` |
| Hyvä CMS / Commerce / Enterprise / Admin / UI Library | top-level dirs of the same name |

## How to use this from within the skill

The curated `references/<topic>.md` files synthesize the patterns most needed for actual coding tasks — read those first. If they don't fully answer a question, drop into `references/sources/` for the original. Search by `Grep` rather than reading top-down — the source tree is large.

Example queries that work well via Grep on the `sources/` tree:

- "When did Hyvä add `hyva.alpineInitialized`?" → `Grep` for `alpineInitialized` in `references/sources/`
- "Is there a built-in Hyvä helper for X?" → `Grep` X in `references/sources/hyva-themes/writing-code/`
- "What is the upgrade path from 1.3.10 to 1.4.0?" → look in `references/sources/hyva-themes/upgrading/upgrading-to-1-*-*.md`
- "What breaks going from 1.4.x to 1.5.x?" → `references/sources/hyva-themes/upgrading/upgrading-to-1-5-1.md` (swatches, modal), then `-1-5-2.md`, `-1-5-3.md`
- "Does this checkout code run on Checkout 3?" → `Grep` the symbol in `references/sources/hyva-checkout/magewire/` and check the "Checkout 3.x (Magewire 3)" vs "Checkout 1.x (Magewire 1)" tab text
- "Does FAQ cover this?" → `Grep` in `references/sources/hyva-themes/faqs/`
