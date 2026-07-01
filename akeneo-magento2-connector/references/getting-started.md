# Getting Started

The Akeneo Connector for Magento 2 / Adobe Commerce is the module `akeneo/module-magento2-connector-community` (namespace `Akeneo\Connector`, built by **Agence Dn'D**, the successor to *PIMGento 2*). It **imports catalog data and structure from an Akeneo PIM into a Magento Open Source / Adobe Commerce store** over the Akeneo Web API.

**Direction is one-way and pull-based: Akeneo → Magento.** The module runs *inside* Magento, calls the Akeneo API (via `akeneo/api-php-client`), and writes into Magento's catalog. There is no Magento → Akeneo push; Magento-side edits to imported attributes are overwritten on the next import. (The README describes this from Akeneo's side as "export to Magento" — same data flow.)

This page covers what it is, compatibility, install, and a first-import quick path. For admin config see `configuration.md`; for the job pipeline see `jobs-and-imports.md`; for how to run/schedule imports see `running-imports.md`.

## What it imports

The connector imports these entities (README "Features"), and the `setup:upgrade` data patch seeds one job per code:

| Job code | Imports |
| --- | --- |
| `category` | Categories (category tree) |
| `family` | Families → Magento attribute sets |
| `attribute` | Attributes → EAV attributes |
| `option` | Attribute options (select / multiselect values, swatches) |
| `product` | Products **+ Product Models + Family Variants** (configurables), with media/images |

Product Models and Family Variants no longer have their own jobs — since connector 101.0.0 they are folded into the **`product`** job, which runs family-by-family. Product media, website/store-view mapping, related/associations, and prices are handled within the product flow via configuration (see `configuration.md`).

> **Community connector, CE-level data.** This module targets Akeneo PIM **Community Edition** data. Akeneo **Enterprise/Serenity-only** entities — **reference entities** and **Asset Manager assets** — are **NOT** imported. (Classic PAM/attribute-style assets and file/image attributes are handled; the EE Asset Manager is not.) For the Akeneo API side of things, use the **`akeneo-pim-api-development`** skill.

## Compatibility (from the module README)

| Magento / Adobe Commerce | PHP | Connector line | Status |
| --- | --- | --- | --- |
| ≥ 2.3.7 && < 2.4.4 | ≥ 7.4 | **103.x** | EOL |
| ≥ 2.4.4 && < 2.4.7 | ≥ 8.0 | **104.x** | Bug fixes only |
| ≥ 2.4.7 | ≥ 8.2 | **105.x** | **Current** — embedded here at **v105.1.2** |

Match the connector line to your Magento **and** PHP. Installing the wrong line is a common setup failure. See `upgrade-and-versions.md` for the full matrix and the `psr/http-message` caveat.

> **Gotcha — trust the README matrix, not `composer.json`.** The 105.1.2 `composer.json` declares loose constraints (`"php": ">=8.0"`, `"magento/framework": ">=102.0.0"`), so Composer may *let* you install 105.x on PHP 8.0 or older Magento. The **supported** combination is the README matrix above (105.x → Magento ≥ 2.4.7 / PHP ≥ 8.2).

## Requirements

- **Akeneo PIM ≥ 3.2** (Community & Enterprise — but EE-specific features are not imported).
- **Magento Open Source or Adobe Commerce ≥ 2.3.7** (per your connector line above).
- **Database encoding must be UTF-8.**
- The Akeneo API dependencies: `akeneo/api-php-client` (pinned **11.4.0** in this line), `symfony/http-client` (`^5|^6|^7`), and PSR-18/17 factories (`http-interop/http-factory-guzzle`, `nyholm/psr7`).
- Working **Magento cron** — the async import system (schedule → run) depends on it. See `running-imports.md`.

## Install via Composer

The module is a standard `magento2-module` (package `akeneo/module-magento2-connector-community`, module name `Akeneo_Connector`). Install with Composer:

```bash
composer require akeneo/module-magento2-connector-community
bin/magento module:enable Akeneo_Connector
bin/magento setup:upgrade
bin/magento cache:flush
```

In **production mode** also compile DI and redeploy static content:

```bash
bin/magento setup:di:compile
bin/magento setup:static-content:deploy
```

Notes:
- `setup:upgrade` runs the module's setup data patches, which **seed the five job rows** (`category, family, attribute, option, product`) into the `akeneo_connector_job` table — that is what populates the admin *System → Akeneo Connector → Jobs* grid. (See `Setup/Patch/Data/CreateJobs.php`.)
- To pin a specific line, constrain the require, e.g. `composer require "akeneo/module-magento2-connector-community:~104.0"` for the 104.x line.
- `di:compile` / `static-content:deploy` / mode switching are generic Magento mechanics — see the **`magento2-development`** skill for details.

**Marketplace availability.** The connector is also published on the [Akeneo Marketplace](https://marketplace.akeneo.com/extension/akeneo-connector-magento-2-community-edition) and the [Magento Marketplace](https://marketplace.magento.com/akeneo-module-magento2-connector-community.html); both resolve to the same Composer package.

## First import — quick path

Once installed:

1. **Create an Akeneo Connection** in the PIM (client_id/secret + API user/password). This lives on the Akeneo side — see the **`akeneo-pim-api-development`** skill's authentication reference.
2. **Configure credentials + mapping** in Magento under *Stores → Configuration → Catalog → Akeneo Connector*: API URL/credentials, then website/store-view, attribute, family, channel/locale/currency mapping, product filters, and image settings. Most "nothing imported / wrong values" problems are misconfiguration here. See `configuration.md`.
3. **Import in order — structure before data:**

   ```bash
   bin/magento akeneo_connector:import --code=category
   bin/magento akeneo_connector:import --code=family
   bin/magento akeneo_connector:import --code=attribute
   bin/magento akeneo_connector:import --code=option
   bin/magento akeneo_connector:import --code=product
   ```

   Or chain them in one call (comma-separated, executed in the order given):

   ```bash
   bin/magento akeneo_connector:import --code=category,family,attribute,option,product
   ```

   Run the command with **no** `--code` to print the available job codes. You can also schedule/run jobs from the admin *Jobs* grid, or let the `akeneo_connector` cron group run them. See `running-imports.md` and `jobs-and-imports.md`.

   > **Order matters.** Running `product` before its families/attributes/options exist yields incomplete or failed mappings. Always: **category → family → attribute → option → product**.

4. **Reindex and flush cache** so imported products become visible:

   ```bash
   bin/magento indexer:reindex
   bin/magento cache:flush
   ```

   (The connector can also reindex/flush per job via configuration — see `configuration.md`.)

5. **Verify** in the admin *Jobs* grid and the `akeneo_connector_job` table; check that products are assigned to a website and reindexed. See `running-imports.md` and `troubleshooting.md`.

## The `akeneo/api-php-client` dependency

The connector talks to Akeneo through the **official Akeneo PHP API client** (`akeneo/api-php-client`, pinned to `11.4.0` in this line). Connector **API/auth** errors are almost always Akeneo-**Connection** credential or reachability problems, not connector bugs — configure and debug the Connection using the **`akeneo-pim-api-development`** skill (auth flows, endpoint shapes, the `{locale, scope, data}` value shape). This connector skill covers the module; the Akeneo API itself is out of scope here.

## Original sources

- `references/sources/magento2-connector-source/README.md` — compatibility matrix, features, requirements, marketplace links, about Agence Dn'D.
- `references/sources/magento2-connector-source/composer.json` — package name, version (105.1.2), license (OSL-3.0 / AFL-3.0), dependency versions.
- `references/sources/magento2-connector-source/registration.php` + `etc/module.xml` — module name `Akeneo_Connector`, setup_version 1.0.5, sequence after `Magento_Catalog`.
- `references/sources/magento2-connector-source/Console/Command/AkeneoConnectorImportCommand.php` — `akeneo_connector:import --code=…` behavior (comma-separated codes; no `--code` prints available codes).
- `references/sources/magento2-connector-source/Setup/Patch/Data/CreateJobs.php` — the seeded job codes and their order (`category, family, attribute, option, product`).
- Official docs: https://help.akeneo.com/magento2-connector/v100/ · Install guide: https://help.akeneo.com/magento2-connector/v100/articles/download-connector.html
