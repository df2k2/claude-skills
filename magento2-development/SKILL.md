---
name: magento2-development
description: "Build, customize, and debug Adobe Commerce / Magento Open Source 2.4.x — PHP backend (modules, plugins, observers, DI), database (declarative schema, EAV, repositories), frontend (layout XML, themes, RequireJS, Knockout UI components, LESS), Web APIs (REST, SOAP, GraphQL), admin area, CLI/cron/queues, caching/indexing, and Adobe Commerce-only features (B2B, Page Builder, Target Rule, Staging, MSI). Use this skill whenever the user works on a Magento 2 / Adobe Commerce store and asks to write or debug a custom module, di.xml, plugin (around/before/after), event observer, layout XML, .phtml, view model, system.xml config, declarative db_schema.xml, data/schema patch, EAV attribute, repository/collection, service contract interface, webapi.xml endpoint, GraphQL schema/resolver, admin route/menu/ACL, UI component (admin grid/form/listing), RequireJS config / mixin, Knockout component, LESS theme override, custom CLI command, cron job, message-queue consumer, or any back-office or storefront customization. Trigger on mentions of Magento, Magento 2, Adobe Commerce, Magento Commerce, M2, MEQP/MFTF, app/code, vendor/magento, bin/magento, di.xml, etc/module.xml, events.xml, plugins, ObjectManager (rare), interception, virtual types, preferences, factories, proxies, layout handles, catalog_product_view, Magento_Ui, ui_component, uiComponent, mixins.js, x-magento-init, requirejs-config.js, knockout, $.mage, jQuery widget, KO bindings, declarative schema, db_schema.xml, data patch, schema patch, EAV, eav_attribute, ResourceModel, Collection, AbstractModel, repository interface, service contract, SearchCriteria, GraphQL resolver, webapi.xml, REST integration token, OAuth, admin token, integration, system config, scope, store view, system.xml, acl.xml, menu.xml, FPC, Varnish, ESI, indexer, mview, message queue, rabbitmq, async-bulk, MSI/Inventory, Page Builder content type, Adobe Commerce B2B / company / requisition / shared catalog, Target Rule, Staging, Reward Points, customer segment. Trigger even when the user just says \"a Magento store\" — Magento has its own deep conventions that differ sharply from Laravel/Symfony/Shopify/WooCommerce; generic PHP/MVC advice will mislead them. NOTE: if the store also runs Hyvä, prefer the `hyva-magento2-development` skill for storefront work — Hyvä replaces most of Magento's frontend stack."
---

# Adobe Commerce / Magento 2 Development

Magento 2 (and its commercial twin, Adobe Commerce) is a PHP eCommerce framework built on top of a custom Magento-flavored Symfony-style architecture. It is **not** a generic Laravel/Symfony app, **not** Drupal, and **not** WordPress — it has its own module layout, configuration system, dependency-injection container, plugin (interception) framework, EAV-driven catalog, layout/theme system, and Web API stack. Most "this is how PHP does X" answers will be wrong here. Read the relevant reference file before writing code.

This skill ships with two layers of documentation:

1. **Curated references** in `references/*.md` — synthesized, opinionated guides for the patterns you'll hit most. Read these first.
2. **Embedded source docs** in `references/sources/` — the full official Adobe Commerce docs (`commerce-php`, `commerce-webapi`, `commerce-frontend-core`) plus the archived `magento/devdocs` v2.4 tree, totaling ~2,700 markdown files. Use `Grep` to search them when the curated reference isn't enough.

Each curated reference file ends with an "Original sources" pointer to the embedded files. The full source tree is large enough that top-down reading wastes time — search with Grep.

## Versions this skill targets

- **Magento Open Source / Adobe Commerce**: 2.4.6-p10, 2.4.7-p5, 2.4.8-p1, 2.4.9 (current line in 2026). The 2.4.4 / 2.4.5 lines are EOL.
- **PHP**: 8.1, 8.2, 8.3. PHP 8.4 supported from 2.4.8+. PHP 7.4 is gone.
- **MariaDB / MySQL**: MariaDB 10.6 / MySQL 8.0 / 8.4. MySQL 5.7 dropped.
- **Elasticsearch / OpenSearch**: OpenSearch 2.x (2.4.7+) or Elasticsearch 8.x (2.4.6 only). Elasticsearch 7 is EOL.
- **Composer**: 2.7+ (Magento dropped Composer 1 long ago).
- **Node.js**: 18+ for static deploy / Grunt (only relevant if compiling LESS locally).
- **Redis**: 7.2+ for cache/session.
- **RabbitMQ**: 3.13+ when message queues are configured (required in Adobe Commerce on Cloud).

If the user is on an older version (2.4.4, 2.4.5, 2.3.x), ask before proceeding. Big breakpoints:
- 2.3 → 2.4: declarative schema mandatory, jQuery 1.x → 3.x, Elasticsearch required.
- 2.4.4 → 2.4.5: PHP 7.4 dropped, AdminAdobeIms (admin SSO) added.
- 2.4.6 → 2.4.7: PHP 8.3 supported, OpenSearch default, Redis 7 required.
- 2.4.7 → 2.4.8: PHP 8.4 added, security/composer dependency churn.

## When to consult this skill vs. when to just answer

Always consult it when the work touches a Magento 2 store. Signals that you're in a Magento 2 codebase:

- `app/etc/env.php`, `bin/magento`, `composer.json` requires `magento/product-community-edition` (Open Source) or `magento/product-enterprise-edition` (Adobe Commerce).
- `app/code/Vendor/Module/` or `vendor/magento/module-*` package layout.
- Files: `etc/module.xml`, `etc/di.xml`, `etc/events.xml`, `etc/webapi.xml`, `etc/adminhtml/menu.xml`, `etc/db_schema.xml`, `etc/frontend/routes.xml`.
- Templates in `view/frontend/templates/*.phtml`, layout in `view/*/layout/*.xml`, themes in `app/design/frontend/Vendor/Theme/`.
- PHP classes use Magento-style `Magento\Framework\App\…`, `Magento\Framework\View\Element\Template`, `Magento\Catalog\Api\Data\ProductInterface`.

**If the store also uses Hyvä** (look for `app/design/frontend/*/theme.xml` with parent `Hyva/default`, `web/tailwind/hyva.config.json`, or `composer.json` requiring `hyva-themes/magento2-*`), defer storefront work to the **`hyva-magento2-development`** skill. Hyvä replaces Knockout/RequireJS/LESS/UI components on the frontend; classic Magento frontend advice will mislead them. The backend (PHP, modules, DI, GraphQL, admin) is identical, so this skill still applies for non-storefront work.

## Confirm before assuming

Before writing code, confirm a few things if not already obvious:

1. **Magento version and edition** — Open Source vs. Adobe Commerce vs. Adobe Commerce on Cloud (ECE-Tools). Commerce-only modules (B2B, PageBuilder for catalog, Target Rule, Customer Segment, Staging, Reward Points) won't exist on Open Source.
2. **Is this in `app/code/` or a Composer module under `vendor/`?** Custom modules belong in `app/code/Vendor/Module/`. Never edit `vendor/magento/*` directly.
3. **Frontend stack** — Luma (default), a custom child theme of Luma, Hyvä, or a PWA Studio/headless build. Hyvä → use the `hyva-magento2-development` skill. PWA → ask before assuming.
4. **Deploy mode** — `developer`, `default`, or `production`. Code generation and DI compilation only run in `default`/`production`. Many edits "do nothing" in production until `setup:di:compile` + `setup:static-content:deploy` + `cache:flush`.
5. **Are they running on Adobe Commerce on Cloud?** That layers ECE-Tools, magento-cloud CLI, and read-only deploy paths on top.

## How to find what you need

The curated references below cover the patterns deeply. Read the one(s) that match the task before writing code — they have current syntax, edge cases, and gotchas. Each is self-contained with examples.

| Task | Reference |
| --- | --- |
| Create a new module, `module.xml`, `registration.php`, dependencies, area code, sequence | `references/module-anatomy.md` |
| Dependency injection — `di.xml`, type config, virtual types, preferences, arguments, factories, proxies | `references/dependency-injection.md` |
| Plugins (interception) — `before`/`after`/`around`, sort order, what you can and cannot intercept | `references/plugins-and-interception.md` |
| Events and observers — `events.xml`, dispatching, observer classes, areas, gotchas | `references/events-and-observers.md` |
| Layout XML, blocks, containers, `.phtml` templates, view models, layout handles, `<update handle>`, `<referenceBlock>` | `references/layout-blocks-templates.md` |
| Themes — inheritance, fallback, `theme.xml`, `registration.php`, static content deploy, theme override | `references/themes-and-fallback.md` |
| Frontend JavaScript — RequireJS config, `mixins.js`, `x-magento-init`, `data-mage-init`, jQuery widgets, KO UI components | `references/frontend-js-and-ui.md` |
| Declarative schema (`db_schema.xml`), schema patches, data patches, `whitelist.json`, foreign keys, indexes | `references/database-schema.md` |
| EAV — entity types, attributes, repositories, models, collections, ResourceModel, service contracts, SearchCriteria | `references/eav-models-repositories.md` |
| REST / SOAP / GraphQL — `webapi.xml`, service contracts, GraphQL `schema.graphqls`, resolvers, ACL, authentication, integrations | `references/rest-graphql-webapi.md` |
| Admin area — routing, `menu.xml`, `acl.xml`, `system.xml` configuration, admin UI components (grids, forms, listings) | `references/admin-area.md` |
| Custom CLI commands, cron jobs (`crontab.xml`), message queues, async/bulk API | `references/cli-cron-queues.md` |
| Caching (FPC, cache types, cache tags, ESI), indexers (`indexer.xml`, mview), performance | `references/caching-indexing-performance.md` |
| Operations — composer, modes, `setup:upgrade`, `setup:di:compile`, `setup:static-content:deploy`, `cache:flush`, deploy flow | `references/operations-workflow.md` |
| Adobe Commerce vs. Open Source — Commerce-only modules and where they live | `references/adobe-commerce-vs-open-source.md` |
| Common pitfalls — area code mismatches, plugin sort order, DI compile failures, n+1 collections, cache tag misses | `references/common-pitfalls.md` |

`references/sources/INDEX.md` is the topic-to-file map for the embedded official docs. The four trees are:

- `commerce-php/` — Adobe's PHP development guide (modules, DI, plugins, schema, events, indexers, CLI, framework).
- `commerce-webapi/` — REST, SOAP, GraphQL reference and tutorials, plus OpenAPI YAML schemas in `commerce-webapi-openapi/`.
- `commerce-frontend-core/` — themes, layouts, templates, JavaScript, UI components, Page Builder.
- `devdocs-v2.4/` — the archived `magento/devdocs` v2.4 tree. Larger and older but still authoritative for many niches not yet migrated to the AdobeDocs repos (extension dev guide, MFTF, contributing, installation, B2B, MSI, payments-integrations, performance).

## Critical things to know up-front

These come up over and over. Internalize them.

### 1. Three deploy modes change everything
- `developer` — full error reporting, no static content caching, automatic code generation. Use this for dev.
- `default` — partial caching, code generation happens. The "in between" mode.
- `production` — static content must be pre-deployed (`setup:static-content:deploy`), `pub/static/_cache/` is locked, DI must be compiled (`setup:di:compile`). Edits to layout XML, di.xml, or templates need a redeploy to take effect.

`bin/magento deploy:mode:show` and `bin/magento deploy:mode:set developer` switch them. Many "my change isn't appearing" issues trace back to being in production mode.

### 2. The pre-deploy commands, in order
After most code changes, you'll need some subset of:

```
composer install --no-dev               # if composer.json changed
bin/magento maintenance:enable          # on production
bin/magento module:enable Vendor_Module # if it's a brand-new module
bin/magento setup:upgrade               # always after enabling/updating modules
bin/magento setup:db-declaration:generate-whitelist --module-name=Vendor_Module   # if you edited db_schema.xml
bin/magento setup:di:compile            # required in default/production after DI changes
bin/magento setup:static-content:deploy -f en_US   # required in production after view/* changes
bin/magento cache:flush
bin/magento maintenance:disable
```

In `developer` mode you can usually skip `setup:di:compile` and `setup:static-content:deploy`. See `references/operations-workflow.md`.

### 3. Areas: frontend, adminhtml, webapi_rest, webapi_soap, graphql, crontab, base
Magento applies configuration per "area". The same file lives in different folders to bind to a different area:
- `etc/frontend/di.xml` — only for storefront requests
- `etc/adminhtml/di.xml` — only for admin
- `etc/webapi_rest/di.xml` — only for REST calls
- `etc/graphql/di.xml` — only for GraphQL calls
- `etc/di.xml` (no subfolder) — every area (the "global" area)

Same for `routes.xml`, `events.xml`, `acl.xml`. **Putting a route in `etc/di.xml` instead of `etc/frontend/routes.xml` is a top-3 newbie bug.**

### 4. Object Manager is for tests and entry points, not for runtime code
`ObjectManager::getInstance()->get(...)` exists, but using it in your own classes is a code smell. Inject dependencies through the constructor and let the DI container resolve them. The only legitimate runtime uses: `ObjectManager` factories that need a runtime class name (and even then, use `\Magento\Framework\ObjectManagerInterface` via constructor injection if you must).

### 5. Don't edit `vendor/magento/*` or `app/code/Magento/*`
Magento's own modules live in `vendor/magento/module-*` (or `app/code/Magento/*` if you composer-required them differently). Both will be wiped on update. To change Magento's behavior, create your own module and use:
- A **plugin** (`<type><plugin/></type>` in di.xml) to intercept a public method.
- An **observer** (`<event><observer/></event>` in events.xml) to react to a dispatched event.
- A **preference** in `di.xml` to swap a class entirely (last resort — fragile across upgrades).
- A **layout XML update** to change frontend/admin output.
- A **template override** by mirroring the path in your theme.

See `references/plugins-and-interception.md` and `references/events-and-observers.md` to choose between them.

### 6. Service contracts (`Api/` namespace) are the public API
Magento's `Api/` interfaces (e.g., `\Magento\Catalog\Api\ProductRepositoryInterface`, `\Magento\Catalog\Api\Data\ProductInterface`) are the stable contract. Always inject the interface, never the concrete class. `Api/` interfaces also auto-expose via REST/SOAP when listed in `webapi.xml`. Models, ResourceModels, and Collections in `Model/` are implementation details — use the repository.

### 7. Cache types — clearing the right one matters
`bin/magento cache:flush` is the sledgehammer (clears EVERYTHING including OPcache + var/cache + Redis). `bin/magento cache:clean [type]` is targeted. Common types:
- `config` — `app/etc/config.php`, `env.php`, `di.xml` merges. Almost every code change needs this.
- `layout` — layout XML merge cache. Needed after editing `*.xml` under `view/*/layout/`.
- `block_html` — block HTML output cache.
- `full_page` — FPC. Needed if you change anything cacheable on the storefront.
- `config_webservice` — `webapi.xml` is cached here. Don't forget after adding endpoints.
- `translate` — i18n CSV. Needed after `app/i18n/` changes.
- `eav` — attribute metadata.
- `compiled_config` — DI compilation output.

In developer mode you can disable specific cache types with `bin/magento cache:disable layout block_html full_page` to iterate faster.

### 8. Adobe Commerce ≠ Magento Open Source
Commerce-only modules: `Magento_Banner`, `Magento_CustomerSegment`, `Magento_TargetRule`, `Magento_VisualMerchandiser`, `Magento_Reward`, `Magento_GiftRegistry`, `Magento_AdvancedCheckout`, `Magento_Staging`, `Magento_Logging`, `Magento_LoginAsCustomer*` (some), B2B (`Magento_Company`, `Magento_NegotiableQuote`, `Magento_RequisitionList`, `Magento_SharedCatalog`, `Magento_PurchaseOrder`), and Page Builder (`Magento_PageBuilder` is Open Source as of 2.4.3, but the **Page Builder content types** are not all OS — banners, dynamic blocks are Commerce). If the user references one of these, confirm they're on Adobe Commerce. See `references/adobe-commerce-vs-open-source.md`.

### 9. Frontend stacks vary wildly
- **Luma** — the default theme: jQuery, RequireJS, Knockout, UI components, LESS.
- **Blank** — Luma's parent, same stack.
- **Hyvä** — Tailwind + Alpine, replaces most of the above. Use the `hyva-magento2-development` skill.
- **PWA Studio** — React, GraphQL-only. Different skill territory.
- **Custom child of Luma** — most stores. Treat as Luma + overrides.

If you don't know which, `Grep` for `theme.xml` parent and `composer.json` for `hyva-themes/*` packages.

### 10. Database has two schema systems
Modern: **declarative schema** (`etc/db_schema.xml` + `db_schema_whitelist.json`). Magento diffs the XML against the DB and applies changes on `setup:upgrade`.
Legacy: `Setup/InstallSchema.php` and `Setup/UpgradeSchema.php` — deprecated since 2.3, still works for ancient modules.
**Data** (not structure) changes use **data patches** (`Setup/Patch/Data/*.php` implementing `DataPatchInterface`). Structural one-offs that don't fit declarative use **schema patches** (`Setup/Patch/Schema/*.php`). See `references/database-schema.md`.

## Patterns that bite developers coming from other PHP frameworks

### Don't use `$this->_db`, `$this->_conn`, or raw PDO in business code
Magento has a Resource Connection abstraction. Use `\Magento\Framework\App\ResourceConnection` if you must run raw SQL, but prefer ResourceModel + Collection + Repository. Models are not Eloquent; they have `_construct()`, `setData()`, `getData()`, `save()` (deprecated direct, prefer repository).

### Don't store state on Block instances
Blocks are constructed once per layout render and cached. State that varies per request belongs on the request, session, or registry, not as a property of the Block. Better: use a **View Model** (`Magento\Framework\View\Element\Block\ArgumentInterface`) injected via layout XML so logic is testable.

### Don't add public methods without thinking about plugins
Any public, non-final method on a non-final class can be intercepted by anyone's plugin. If your class is internal, mark methods `final` or the class `final` to prevent accidental interception (and the ~5% perf cost). Conversely, **plugins can only intercept public methods on non-final classes** — they cannot intercept private/protected, static, magic, constructor, or final methods. See `references/plugins-and-interception.md`.

### Don't return `\Magento\Framework\DataObject` from public APIs
For service contracts, return `\Magento\Vendor\Module\Api\Data\FooInterface`. Magento auto-generates a `FooExtensionInterface` (via `setup:di:compile`) for `extension_attributes.xml`-declared extras. Returning a DataObject loses the type contract and breaks the auto-REST/SOAP exposure.

### Don't forget the area code for CLI scripts
`\Magento\Framework\App\State::setAreaCode(\Magento\Framework\App\Area::AREA_FRONTEND)` is required before Magento can resolve area-scoped config in many scripts. Custom CLI commands often set this in their `execute()` method. Without it: cryptic "Area code is not set" errors.

### Don't trust `\Magento\Catalog\Model\Product::load($id)` for production code
`load()` is deprecated for public use. Inject `ProductRepositoryInterface` and call `getById($id)`. Same goes for Category, Order, Customer, etc. The deprecation has been there since 2.2 but the methods still work — just don't add new uses.

### Don't store secrets in `app/etc/config.php`
`config.php` is committed. `env.php` (which contains DB password, encryption key) is NOT committed. Sensitive system config values go in `env.php` via `bin/magento config:sensitive:set`. See `references/operations-workflow.md`.

### Don't bypass `\Magento\Framework\Escaper` in templates
Every `.phtml` has `$escaper` (or `$block->escapeHtml(...)` on Luma). XSS is the most common Magento marketplace rejection. Use `escapeHtml`, `escapeHtmlAttr`, `escapeJs`, `escapeCss`, `escapeUrl` based on context.

## Default working style

When the user gives a task:

1. **Read the relevant reference file(s) first.** Magento syntax is precise — `<plugin name="foo" type="\Vendor\Module\Plugin\BarPlugin" sortOrder="10" disabled="false"/>` has five attributes that all matter.
2. **Confirm version, edition, frontend stack, and deploy mode if ambiguous.** Especially mode (developer/production), because it changes the workflow.
3. **Write Magento-style code.** Constructor DI, service contracts, declarative schema, layout XML for UI, events/plugins instead of editing core.
4. **Use `app/code/Vendor/Module/`** for custom code, not `vendor/`. Composer modules go in `vendor/` but are installed via `composer require`.
5. **Tell the user the post-edit commands.** Almost every change needs `bin/magento cache:flush` at minimum. New modules need `module:enable` + `setup:upgrade`. Schema changes need `setup:upgrade`. DI changes need `setup:di:compile` in production. Layout/template changes need `cache:clean layout block_html full_page`. Static content changes need `setup:static-content:deploy` in production.
6. **Sanity-check escaping in templates and JS-from-PHP.** `$escaper->escapeHtml`, `escapeJs`, `escapeUrl`. JSON encoding for data passed to JS.
7. **Prefer the repository/service contract over the model.** `productRepository->getById($id)` not `Product::load($id)`.

## A small example: pattern to follow

User: "Add a custom 'gift_wrap_message' field to the cart that saves to the order."

Bad answer (Drupal/Laravel-think):
> Just add a column to `sales_order` and a form field…

Good answer (Magento):

1. **Declare the column via declarative schema** in your module:

`app/code/Acme/GiftWrap/etc/db_schema.xml`:
```xml
<?xml version="1.0"?>
<schema xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Setup/Declaration/Schema/etc/schema.xsd">
    <table name="quote" resource="checkout">
        <column xsi:type="varchar" name="gift_wrap_message" length="255" nullable="true" comment="Gift wrap message"/>
    </table>
    <table name="sales_order" resource="sales">
        <column xsi:type="varchar" name="gift_wrap_message" length="255" nullable="true" comment="Gift wrap message"/>
    </table>
</schema>
```

2. **Expose it via extension attributes** so REST/GraphQL pick it up:

`app/code/Acme/GiftWrap/etc/extension_attributes.xml`:
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Api/etc/extension_attributes.xsd">
    <extension_attributes for="Magento\Quote\Api\Data\CartInterface">
        <attribute code="gift_wrap_message" type="string"/>
    </extension_attributes>
    <extension_attributes for="Magento\Sales\Api\Data\OrderInterface">
        <attribute code="gift_wrap_message" type="string"/>
    </extension_attributes>
</config>
```

3. **Persist the quote field to the order** via an observer on `sales_model_service_quote_submit_before`:

`app/code/Acme/GiftWrap/etc/events.xml`:
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd">
    <event name="sales_model_service_quote_submit_before">
        <observer name="acme_giftwrap_copy_message" instance="Acme\GiftWrap\Observer\CopyQuoteMessageToOrder"/>
    </event>
</config>
```

```php
namespace Acme\GiftWrap\Observer;

use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;

class CopyQuoteMessageToOrder implements ObserverInterface
{
    public function execute(Observer $observer): void
    {
        $quote = $observer->getEvent()->getQuote();
        $order = $observer->getEvent()->getOrder();
        $order->setData('gift_wrap_message', $quote->getData('gift_wrap_message'));
    }
}
```

4. **Then**:
```
bin/magento module:enable Acme_GiftWrap
bin/magento setup:upgrade
bin/magento setup:db-declaration:generate-whitelist --module-name=Acme_GiftWrap
bin/magento setup:di:compile     # production/default
bin/magento cache:flush
```

5. **If they need a storefront input**, that goes in a `.phtml` under `view/frontend/templates/checkout/`, registered via `view/frontend/layout/checkout_index_index.xml` with a Knockout UI component, plus a quote API extension plugin to persist `gift_wrap_message` from the GraphQL/REST payload. See `references/layout-blocks-templates.md` and `references/rest-graphql-webapi.md`.

This pattern — db_schema, extension_attributes, observer/plugin to wire it up, a UI component for input — is the Magento way. Don't shortcut it by writing SQL directly or stuffing logic into a template.
