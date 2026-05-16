# Module Anatomy

A Magento 2 module is a self-contained PHP package that adds or modifies features. Every module needs **two** files at minimum: `registration.php` and `etc/module.xml`. Everything else is optional and added as needed.

## Where modules live

| Path | When |
| --- | --- |
| `app/code/Vendor/Module/` | Custom modules you write. Most projects. |
| `vendor/vendor/magento2-module-foo/` | Third-party modules installed via Composer. |
| `vendor/magento/module-*` | Magento's own modules. Never edit. |
| `app/code/Magento/*` | Magento modules installed via the `metapackage-community` flavor. Rare. Never edit. |

**Custom code always goes in `app/code/Vendor/Module/`** (or its own Composer package under `vendor/`). `Vendor` is your namespace prefix — pick something stable and lowercase-folder/PascalCase-namespace consistent.

## Minimum module skeleton

```
app/code/Acme/Hello/
├── etc/
│   └── module.xml
├── registration.php
└── composer.json   ← optional but recommended for Composer-installable modules
```

### `registration.php`
Tells Magento the module exists. Identical for every module except the name:

```php
<?php
declare(strict_types=1);

use Magento\Framework\Component\ComponentRegistrar;

ComponentRegistrar::register(
    ComponentRegistrar::MODULE,
    'Acme_Hello',
    __DIR__
);
```

The `Acme_Hello` name MUST match what's in `module.xml`. It also MUST match the folder structure (`app/code/Acme/Hello/`).

### `etc/module.xml`
Declares the module and its dependencies:

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="Acme_Hello" setup_version="1.0.0">
        <sequence>
            <module name="Magento_Catalog"/>
            <module name="Magento_Sales"/>
        </sequence>
    </module>
</config>
```

- `setup_version` is **legacy** (used by old `Setup/Upgrade*.php` scripts). Magento 2.3+ moved to declarative schema and data patches that don't use this. Many people omit it. Keep it if you're maintaining a module with legacy setup scripts.
- `<sequence>` — load order dependency. List modules whose code, config, or DB tables your module relies on. Sequence affects:
  - **Config merge order** — your `di.xml` is merged AFTER the listed modules', so your overrides win.
  - **Plugin/observer execution order** — your plugins run after the dependency's plugins.
  - **Setup order** — your `setup:upgrade` patches run after the dependency's.
  - **Layout XML merge order** — your layout updates apply after.

If you reference `Magento_Catalog`'s classes/tables, you need it in `<sequence>`. Composer dependencies in `composer.json` are separate (they ensure the code is present); `<sequence>` is for Magento's internal load order.

### `composer.json` (optional but standard)
Lets the module be installed via `composer require` and lets Composer resolve dependencies:

```json
{
    "name": "acme/module-hello",
    "description": "Adds gift-wrap to checkout",
    "type": "magento2-module",
    "license": "proprietary",
    "version": "1.0.0",
    "require": {
        "php": "~8.1.0||~8.2.0||~8.3.0",
        "magento/framework": "*",
        "magento/module-catalog": "*",
        "magento/module-sales": "*"
    },
    "autoload": {
        "files": ["registration.php"],
        "psr-4": {
            "Acme\\Hello\\": ""
        }
    }
}
```

- `type: magento2-module` activates the Magento Composer Installer plugin.
- `autoload.files: ["registration.php"]` is REQUIRED so Composer runs the registration.
- The PSR-4 map maps namespace `Acme\Hello\` to the module's root.
- Use `"version": "*"` for Magento packages — pinning to a version makes the module fail when the merchant upgrades Magento.

## The full directory map

Not all of these exist in every module. Add them as needed.

```
app/code/Acme/Hello/
├── etc/
│   ├── module.xml                    ← declared above
│   ├── di.xml                        ← global DI (see dependency-injection.md)
│   ├── events.xml                    ← global event observers
│   ├── crontab.xml                   ← cron jobs
│   ├── communication.xml             ← message-queue topics
│   ├── queue.xml                     ← queue definitions (Adobe Commerce)
│   ├── queue_topology.xml
│   ├── queue_publisher.xml
│   ├── queue_consumer.xml
│   ├── extension_attributes.xml      ← extend API interfaces
│   ├── acl.xml                       ← admin permissions
│   ├── indexer.xml                   ← custom indexer
│   ├── mview.xml                     ← partial reindex triggers
│   ├── cache.xml                     ← register a custom cache type
│   ├── view.xml                      ← media gallery / image config
│   ├── config.xml                    ← system config defaults
│   ├── catalog_attributes.xml        ← attribute groups
│   ├── widget.xml                    ← widgets
│   ├── email_templates.xml           ← email templates
│   ├── search_request.xml            ← Elasticsearch query
│   ├── frontend/
│   │   ├── di.xml                    ← frontend-only DI overrides
│   │   ├── events.xml
│   │   ├── routes.xml                ← frontend URL routing
│   │   ├── sections.xml              ← invalidate customer section
│   │   └── page_types.xml            ← FPC page-type cache
│   ├── adminhtml/
│   │   ├── di.xml
│   │   ├── events.xml
│   │   ├── routes.xml                ← admin URL routing
│   │   ├── menu.xml                  ← admin menu items
│   │   ├── system.xml                ← Stores → Configuration tree
│   │   └── acl.xml                   ← admin ACL (sometimes lives here too)
│   ├── webapi_rest/di.xml            ← REST-only DI overrides
│   ├── webapi_soap/di.xml
│   ├── graphql/di.xml                ← GraphQL-only DI overrides
│   ├── crontab/di.xml
│   ├── webapi.xml                    ← REST/SOAP endpoint declarations
│   ├── schema.graphqls               ← GraphQL schema extension
│   ├── product_types.xml             ← register a product type
│   ├── db_schema.xml                 ← declarative schema
│   └── db_schema_whitelist.json      ← schema columns Magento may drop
├── Api/                              ← service contract interfaces
│   ├── Data/
│   │   └── HelloInterface.php
│   └── HelloRepositoryInterface.php
├── Block/                            ← frontend / adminhtml Block classes
├── Console/Command/                  ← custom bin/magento commands
├── Controller/
│   ├── Adminhtml/                    ← admin controllers
│   └── Index/                        ← frontend controllers
├── Cron/                             ← cron handler classes
├── CustomerData/                     ← customer-section providers
├── Helper/                           ← helper classes (use sparingly — legacy)
├── Model/
│   ├── Hello.php                     ← AbstractModel
│   ├── HelloRepository.php           ← repository impl
│   ├── Config/                       ← config sources, system.xml backend models
│   ├── ResourceModel/
│   │   ├── Hello.php
│   │   └── Hello/
│   │       └── Collection.php
│   └── Source/                       ← option-array sources for system.xml / EAV
├── Observer/                         ← event observer classes
├── Plugin/                           ← interception plugin classes
├── Setup/
│   ├── Patch/
│   │   ├── Data/                     ← data patches (DataPatchInterface)
│   │   └── Schema/                   ← schema patches (SchemaPatchInterface)
│   └── (legacy: InstallSchema.php, UpgradeData.php)
├── Test/
│   ├── Unit/                         ← PHPUnit unit tests
│   ├── Integration/                  ← Magento integration tests
│   ├── Api/                          ← REST/SOAP/GraphQL API tests
│   └── Mftf/                         ← Magento Functional Testing Framework
├── Ui/                               ← admin UI component classes (DataProviders, columns)
├── ViewModel/                        ← view models for templates
├── view/
│   ├── frontend/
│   │   ├── layout/                   ← layout XML (handle.xml)
│   │   ├── templates/                ← .phtml templates
│   │   ├── web/
│   │   │   ├── css/                  ← LESS / CSS source
│   │   │   ├── js/                   ← JS modules (RequireJS)
│   │   │   ├── images/
│   │   │   └── template/             ← Knockout HTML templates
│   │   ├── requirejs-config.js       ← module's requirejs config
│   │   └── ui_component/             ← frontend UI components (rare)
│   ├── adminhtml/
│   │   ├── layout/
│   │   ├── templates/
│   │   ├── web/
│   │   └── ui_component/             ← admin grids/forms/listings
│   └── base/                         ← shared between frontend and adminhtml
├── i18n/                             ← translation CSVs (en_US.csv, etc.)
├── composer.json
├── registration.php
└── README.md
```

## Naming conventions

- **Module name**: `Vendor_Module` (PascalCase, underscore separator) — `Acme_Hello`, `Magento_Catalog`.
- **Composer name**: `vendor/module-foo` (kebab, prefixed `module-`) — `acme/module-hello`.
- **PHP namespace**: `Vendor\Module` (PascalCase, backslashes) — `Acme\Hello\Model\Foo`.
- **Folder structure**: `app/code/Vendor/Module/` mirrors the PSR-4 namespace.
- **Tables**: prefix with the module's vendor or feature name to avoid collisions: `acme_giftwrap_message`, not `messages`.
- **Events**: `vendor_module_action_subject` (snake_case) — `acme_giftwrap_save_before`.
- **DI virtual types / preferences**: append `Virtual` or use a descriptive suffix.

## Enabling, disabling, and removing a module

```
bin/magento module:enable Acme_Hello
bin/magento module:disable Acme_Hello
bin/magento module:status                 # list all modules
bin/magento module:status Acme_Hello      # status of one
bin/magento module:uninstall Acme_Hello   # for Composer-installed only; also runs composer remove
```

`module:enable` writes the module's name into `app/etc/config.php` under `modules`. Brand-new modules are **disabled by default** when first added to `app/code/` — they don't auto-activate. After enabling, run `setup:upgrade`.

If `module:enable` fails with "Cannot enable Acme_Hello, depends on Magento_Sales (disabled)" — enable the dependency first (or pass `--all`).

## Module dependency rules

- Use `<sequence>` in `module.xml` for **load order** (Magento internal).
- Use `composer.json require` for **package presence** (Composer-level).
- A "soft" dependency (your module works without it, but adds features if present) — list it in `<sequence>` but mark it as optional in composer (or omit from composer). Wrap usage in `\Magento\Framework\Module\Manager::isEnabled('Magento_Foo')` checks.
- Circular dependencies are not allowed. If you need to react to another module, prefer events over direct calls.

## Multiple ways to load classes — pick the modern one

- `\Magento\Catalog\Model\ProductFactory::create()` — preferred for instantiating new model objects with state.
- `\Magento\Catalog\Api\ProductRepositoryInterface::getById($id)` — preferred for loading existing entities.
- `ObjectManager::getInstance()->get(...)` — **avoid in business code**. Use constructor injection. Only acceptable in tests, entry-point bootstraps, and a few `static` legacy spots.
- `\Magento\Catalog\Model\Product::load($id)` — deprecated. Use the repository.

## Module deployment checklist

After creating or changing a module:

```
# (in app/code or composer-installed)
bin/magento module:enable Acme_Hello       # if first install
bin/magento setup:upgrade                  # always
bin/magento setup:db-declaration:generate-whitelist --module-name=Acme_Hello  # if db_schema.xml changed
bin/magento setup:di:compile               # if di.xml/plugins changed and in default/production mode
bin/magento setup:static-content:deploy -f # if view/* changed and in production
bin/magento cache:flush                    # always after structural changes
```

In `developer` mode, `setup:di:compile` and `setup:static-content:deploy` can usually be skipped. In `production`, both are mandatory and `cache:flush` won't pick up DI changes without `setup:di:compile` first.

## Common gotchas

- **Module disabled by default after copying into `app/code/`** — run `bin/magento module:enable Vendor_Module`. The module exists but won't load until enabled.
- **Forgot `<sequence>` for a dependency you reference** — config merges in wrong order, your plugin runs before the parent module's plugin, or worse, your patch runs before the table exists.
- **`registration.php` not autoloaded** — the `composer.json` must include `"autoload": {"files": ["registration.php"]}` AND Composer's autoload must be regenerated (`composer dump-autoload`). Modules in `app/code/` are picked up by Magento's component scanner without this.
- **Wrong folder case** — Linux is case-sensitive. `Acme/hello/` ≠ `Acme/Hello/`. Always match the namespace casing exactly.
- **Composer name mismatch** — `composer.json` says `acme/module-hello`, the Composer install puts it at `vendor/acme/module-hello/`, but `module.xml` says `Acme_Hello`. The latter is what Magento uses internally — keep both consistent.

## Original sources

- `references/sources/commerce-php/development/build/composer-integration.md` — Composer setup.
- `references/sources/commerce-php/development/build/module-development.md` (and surrounding files) — module overview.
- `references/sources/commerce-php/module-reference/` — every Magento core module documented.
- `references/sources/devdocs-v2.4/extension-dev-guide/build.md` — extension dev guide.
- `references/sources/devdocs-v2.4/extension-dev-guide/prepare/lifecycle.md` — module lifecycle.
- `references/sources/devdocs-v2.4/extension-dev-guide/build/composer-integration.md` — same topic, older copy.
