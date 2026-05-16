# Source docs — topic-to-file index

This is the topic map for the embedded official Adobe Commerce / Magento 2 documentation. The `sources/` tree contains 2,692 markdown files (~28 MB), too many for top-down reading. Use this file plus `Grep` to find what you need.

Four trees are embedded:

| Tree | What | Files |
| --- | --- | --- |
| `commerce-php/` | Adobe's modern PHP development guide. Authoritative for 2.4.4+. | 832 |
| `commerce-webapi/` | REST, SOAP, GraphQL reference + tutorials. | 503 |
| `commerce-webapi-openapi/` | OpenAPI 3 YAML schemas (admin/customer/guest) for 2.4.6-2.4.9. | 13 |
| `commerce-frontend-core/` | Themes, layouts, templates, JS, UI components, Page Builder. | 262 |
| `devdocs-v2.4/` | Archived `magento/devdocs` v2.4 tree. Larger and older but covers niches the AdobeDocs repos haven't migrated yet. | 1,095 |

The AdobeDocs repos are the current source of truth; devdocs is the older archive. If both have a page on a topic, prefer the AdobeDocs one but fall back to devdocs for depth.

## Search recipes

```bash
# All references to "plugin" in commerce-php
grep -rln "plugin" magento2-development/references/sources/commerce-php

# A specific Magento class name across all source trees
grep -rln "Magento\\\\Catalog\\\\Api\\\\ProductRepositoryInterface" magento2-development/references/sources

# Topic across both newest and older docs
grep -rln "declarative schema" magento2-development/references/sources/{commerce-php,devdocs-v2.4}

# Find which file documents a specific event
grep -rln "sales_order_save_commit_after" magento2-development/references/sources

# OpenAPI: find a REST endpoint
grep -n "/V1/products/{sku}" magento2-development/references/sources/commerce-webapi-openapi/admin-schema-2.4.9.yaml
```

## Topic map

### Modules — anatomy, registration, dependencies
- `commerce-php/development/build/composer-integration.md` — Composer setup for modules
- `commerce-php/development/build/module-development.md` — module dev overview
- `commerce-php/module-reference/` — every Magento core module documented
- `devdocs-v2.4/extension-dev-guide/build.md` — older module-build guide
- `devdocs-v2.4/extension-dev-guide/prepare/lifecycle.md` — module lifecycle

### Dependency injection, plugins, observers
- `commerce-php/development/components/dependency-injection.md` — DI guide
- `commerce-php/development/components/object-manager/` — Object Manager design
- `commerce-php/development/components/factories.md` — factories
- `commerce-php/development/components/proxies.md` — proxies
- `commerce-php/development/components/plugins.md` — plugin docs
- `commerce-php/development/components/events-and-observers/` — events and observers
- `commerce-php/development/components/code-generation.md` — generated code (Interceptors, Factories, Proxies)
- `devdocs-v2.4/extension-dev-guide/depend-inj.md` — older DI
- `devdocs-v2.4/extension-dev-guide/plugins.md` — older plugins
- `devdocs-v2.4/extension-dev-guide/events-and-observers.md` — older events

### Service contracts, repositories, EAV, attributes
- `commerce-php/development/components/service-contracts/` — service contract design
- `commerce-php/development/components/searching-with-repositories.md` — SearchCriteria
- `commerce-php/development/components/attributes.md` — attribute system
- `commerce-php/development/components/add-attributes.md` — adding EAV attributes
- `commerce-php/development/components/api-concepts.md` — service contract concepts
- `devdocs-v2.4/extension-dev-guide/service-contracts/` — older detailed guide
- `devdocs-v2.4/extension-dev-guide/searching-with-repositories.md` — older
- `devdocs-v2.4/extension-dev-guide/attributes.md` — older

### Database — declarative schema, data patches
- `commerce-php/development/components/declarative-schema/` — declarative schema
  - `db-schema.md` — `db_schema.xml` reference
  - `data-patches.md` — data patches
  - `schema-patches.md` — schema patches
  - `whitelist.md` — whitelist mechanism
- `devdocs-v2.4/extension-dev-guide/declarative-schema/` — older
- `devdocs-v2.4/extension-dev-guide/declarative-schema/dynamic-data.md` — data patches in detail
- `devdocs-v2.4/extension-dev-guide/build/` — setup script lifecycle

### Layout, blocks, templates, themes
- `commerce-frontend-core/guide/themes/` — theme architecture
  - `theme-structure.md`
  - `theme-inherit.md` — theme fallback / inheritance
  - `theme-apply.md` — applying a theme
- `commerce-frontend-core/guide/layouts/` — layout XML
- `commerce-frontend-core/guide/templates/` — .phtml templates
- `commerce-php/development/components/view-models.md` — view models
- `commerce-frontend-core/guide/css/` — CSS / LESS
- `commerce-frontend-core/guide/responsive-design/` — responsive
- `devdocs-v2.4/frontend-dev-guide/layouts/` — older layout XML guide (more examples)
- `devdocs-v2.4/frontend-dev-guide/themes/` — older themes
- `devdocs-v2.4/frontend-dev-guide/templates/template-walkthrough.md` — template walkthrough

### Frontend JavaScript, RequireJS, mixins, UI components, Knockout
- `commerce-frontend-core/javascript/` — JS dev guide
- `commerce-frontend-core/javascript/js_mixins.md` — mixin pattern
- `commerce-frontend-core/javascript/custom_js.md` — custom JS
- `commerce-frontend-core/ui-components/` — UI component reference (admin grids/forms/listings)
- `commerce-frontend-core/guide/validations/` — JS validation
- `commerce-frontend-core/page-builder/` — Page Builder content types
- `devdocs-v2.4/javascript-dev-guide/` — older JS guide
- `devdocs-v2.4/ui_comp_guide/` — older UI components reference (deep)

### REST / SOAP / GraphQL Web APIs
- `commerce-webapi/get-started/` — overview, authentication
- `commerce-webapi/rest/` — REST guide
  - `rest/authentication/` — auth tokens
  - `rest/use-rest/` — using REST
  - `rest/tutorials/` — examples
  - `rest/reference/` — generated reference
- `commerce-webapi/graphql/` — GraphQL guide
  - `graphql/develop/` — building schemas/resolvers
  - `graphql/usage/` — using GraphQL
  - `graphql/queries/` — query catalog
  - `graphql/mutations/` — mutation catalog
- `commerce-webapi/reference/` — overall reference
- `commerce-webapi-openapi/admin-schema-2.4.6.yaml` (and -2.4.7, -2.4.8, -2.4.9) — OpenAPI 3 admin schema per version
- `commerce-webapi-openapi/customer-schema-2.4.*.yaml` — customer-scoped endpoints
- `commerce-webapi-openapi/guest-schema-2.4.*.yaml` — guest endpoints
- `commerce-webapi-openapi/accs-schema.yaml` — Adobe Commerce Cloud Services
- `commerce-php/development/components/web-api/` — webapi.xml architecture
- `devdocs-v2.4/graphql/` — older but extensive GraphQL guide
- `devdocs-v2.4/rest/` — older REST guide
- `devdocs-v2.4/soap/` — SOAP guide

### Admin area — controllers, menu, ACL, system config, UI grids/forms
- `commerce-php/development/components/add-admin-grid.md` — admin grid walkthrough
- `commerce-php/development/components/routing.md` — routing internals
- `commerce-frontend-core/ui-components/` — UI components
- `devdocs-v2.4/ui_comp_guide/` — UI component reference (extensive)
- `devdocs-v2.4/config-guide/` — `system.xml`, env.php, config.php deep dive
- `devdocs-v2.4/extension-dev-guide/` — module guides covering ACL, menus

### CLI commands, cron, message queues
- `commerce-php/development/cli-commands/` — CLI command reference
- `commerce-php/development/components/message-queues/` — message queue architecture
- `commerce-php/development/components/async-operations.md` — async/bulk REST
- `commerce-php/development/components/code-generation.md` — code generation
- `devdocs-v2.4/extension-dev-guide/cron/` — cron docs
- `devdocs-v2.4/extension-dev-guide/message-queues/` — older queue docs
- `devdocs-v2.4/extension-dev-guide/cli-cmds/` — older CLI guide

### Caching, indexing, performance
- `commerce-php/development/cache/` — cache types
- `commerce-php/development/components/indexing/` — indexer architecture
- `commerce-frontend-core/guide/caching.md` — frontend caching
- `commerce-frontend-core/guide/best-practices.md` — frontend perf
- `devdocs-v2.4/extension-dev-guide/cache/` — older cache docs
- `devdocs-v2.4/extension-dev-guide/indexing/` — older indexer docs
- `devdocs-v2.4/performance-best-practices/` — server-level perf guide (essential reading)
- `commerce-php/best-practices/` — overall best practices

### Operations, deploy, modes, env.php
- `commerce-php/development/build/` — build process
- `commerce-php/development/configuration/` — env.php, config.php, importers
- `commerce-php/development/configuration/sensitive-environment-settings.md` — sensitive config
- `devdocs-v2.4/config-guide/` — config guide
- `devdocs-v2.4/comp-mgr/` — Component Manager (deprecated web UI)
- `devdocs-v2.4/install-gde/` — installation guide
- `devdocs-v2.4/release-notes/` — release notes per version

### Security
- `commerce-php/development/security/` — security guide for developers
- `devdocs-v2.4/security/` — security guide (legacy)
- `commerce-php/best-practices/security/` — security best practices

### Adobe Commerce-only features
- `commerce-php/module-reference/` — lists ALL modules including Commerce ones
- `devdocs-v2.4/b2b/` — B2B development guide
- `devdocs-v2.4/inventory/` — MSI (multi-source inventory)
- `devdocs-v2.4/extension-dev-guide/staging/` — Staging (Commerce)

### Coding standards, testing
- `commerce-php/coding-standards/` — current coding standards
- `commerce-php/best-practices/` — best practices
- `devdocs-v2.4/coding-standards/` — older
- `devdocs-v2.4/ext-best-practices/` — older best practices
- `devdocs-v2.4/test/` — testing guide (PHPUnit, MFTF)
- `devdocs-v2.4/mrg/` — Magento Functional Testing Framework

### Tutorials and worked examples
- `commerce-php/tutorials/` — official tutorials
- `commerce-webapi/rest/tutorials/` — REST tutorials
- `devdocs-v2.4/howdoi/` — how-do-I cookbook

### Specific modules
- `commerce-php/module-reference/<module-name>.md` — overview per module
- `devdocs-v2.4/reference/` — module reference

### Payments
- `commerce-php/development/payments-integrations/` — payment integration dev guide
- `devdocs-v2.4/payments-integrations/` — older payment guide

## When the curated reference isn't enough

Each curated `references/*.md` file ends with an "Original sources" section pointing to the most relevant `sources/*` files. Start there. If you need more:

1. Search the topic across all four trees: `grep -rln "topic" magento2-development/references/sources`
2. Read the AdobeDocs hit first (more current).
3. If the AdobeDocs entry is sparse, read the devdocs-v2.4 entry — it's usually deeper.
4. For exact REST endpoint shape: check `commerce-webapi-openapi/admin-schema-2.4.9.yaml`.
5. For exact GraphQL type shape: search `commerce-webapi/graphql/` for the type name.

## Refreshing the sources

The sources are pinned to whichever commit Adobe Docs and `magento/devdocs` had when this skill was last built. To refresh:

```bash
bash scripts/magento2/fetch_docs.sh
```

See that script for the clone-and-filter logic. It re-clones the four GitHub repos and rewrites `references/sources/` with the latest content.
