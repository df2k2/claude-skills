---
name: akeneo-magento2-connector
description: "Install, configure, run, customize, and debug the official Akeneo Connector for Magento 2 / Adobe Commerce — the open-source PHP module akeneo/module-magento2-connector-community (composer package akeneo/module-magento2-connector-community, namespace Akeneo\\Connector, originally PIMGento2 by Agence Dn'D) that imports catalog data and structure FROM Akeneo PIM INTO a Magento Open Source / Adobe Commerce store via the Akeneo Web API. Use this skill whenever the user is working on the Akeneo→Magento import: installing/upgrading the connector, wiring API credentials to their Akeneo PIM, mapping websites/stores/store-views, attributes, families, channels, locales, currencies, tax classes, and configurable products; running or scheduling imports of categories, families, attributes, attribute options, product models, family variants, and products; using the bin/magento akeneo_connector:import command (--code=<job>), the admin Akeneo Connector grid, or the cron group akeneo_connector; understanding the Job step pipeline (Akeneo\\Connector\\Job\\{Category,Family,Attribute,Option,Product} and the Import base class, run by the JobExecutor and tracked in the akeneo_connector_job table); extending the connector with plugins/observers/converters; or debugging import failures — API connection/auth errors, memory/timeout on large catalogs, attribute-type or mapping mismatches, missing images/assets, partial imports, cron not launching scheduled jobs, or post-import reindex problems. Trigger on mentions of Akeneo connector, Akeneo Magento connector, akeneo/module-magento2-connector-community, Akeneo\\Connector, akeneo_connector:import, akeneo_connector_job, PIMGento, PIMGento2, Agence Dn'D connector, importing Akeneo products into Magento, Akeneo Connector admin config, connector Job/Executor/Converter, LaunchScheduledJob, or connecting Akeneo PIM to Adobe Commerce. This skill covers the CONNECTOR MODULE; for building integrations against the Akeneo Web API itself (REST/GraphQL/webhooks/Apps/PHP client) use the akeneo-pim-api-development skill, and for generic Magento 2 module mechanics (di.xml, plugins, layout, EAV, indexing) use the magento2-development skill. The full module source is embedded under references/sources/magento2-connector-source/ (pinned at v105.1.2) — treat it as the source of truth."
---

# Akeneo Connector for Magento 2 / Adobe Commerce

The **Akeneo Connector for Magento 2** (`akeneo/module-magento2-connector-community`, namespace `Akeneo\Connector`) is a Magento Open Source / Adobe Commerce **module** that **imports catalog data and structure from an Akeneo PIM into the Magento store** over the Akeneo Web API. It was built by **Agence Dn'D** (the successor to *PIMGento 2*) and is maintained with Akeneo. This skill is the developer guide to installing, configuring, running, extending, and debugging it.

**Direction is one-way and pull-based: Akeneo → Magento.** The module runs *inside* Magento, calls the Akeneo API (via `akeneo/api-php-client`), and writes products/attributes/categories into Magento's catalog. It does not push from Magento to Akeneo.

The skill has two layers:

1. **Curated references** in `references/*.md` — install, configure, jobs/imports, running, architecture, customizing, troubleshooting, versions. Read these first.
2. **The full module source** in `references/sources/magento2-connector-source/` (pinned at **v105.1.2**) — the **source of truth**. When a curated doc and the source disagree, trust the source (and the live module).

> This skill is **connector-specific**. It deliberately does **not** re-teach generic Magento 2 mechanics (di.xml, plugins, observers, EAV, layout, indexing, cron internals) — for those, use the **`magento2-development`** skill. For the Akeneo API side (auth, endpoints, the `{locale,scope,data}` value shape), use the **`akeneo-pim-api-development`** skill.

## What it imports

Categories · Families · Attributes · Attribute options · **Product models** · **Family variants** · Products (with media/images, and — via configuration — website/store-view mapping, related/associations, and prices).

> **Community connector, CE-level data.** The module targets **Akeneo PIM Community Edition** data. Akeneo **Enterprise/Serenity-only** entities — **reference entities** and **Asset Manager assets** — are **not** imported by this community connector. (Assets in the classic PAM/attribute sense are handled; the EE Asset Manager is not.)

## Compatibility (from the module README)

| Magento / Adobe Commerce | PHP | Connector line | Status |
| --- | --- | --- | --- |
| ≥ 2.3.7 && < 2.4.4 | ≥ 7.4 | **103.x** | EOL |
| ≥ 2.4.4 && < 2.4.7 | ≥ 8.0 | **104.x** | Bug fixes only |
| ≥ 2.4.7 | ≥ 8.2 | **105.x** | **Current** (embedded: v105.1.2) |

- **Akeneo PIM ≥ 3.2** (CE & EE — EE-specific features not imported). DB charset **UTF-8**.
- **Key dependency:** `akeneo/api-php-client` (v11.4.0 in this line) + `symfony/http-client` + PSR-18/17 (`nyholm/psr7`). `psr/http-message ≥ 2.0`; if that clashes with your stack, pin connector **104.x**.
- Docs versioning is confusing: the help-center path is `help.akeneo.com/magento2-connector/v100/` but the git tags are `103/104/105.x`. The `v100` is the doc-site slug, not the module version.

## How the connector fits together (mental model)

```
  Akeneo PIM  ──(Akeneo Web API, akeneo/api-php-client)──►  Akeneo Connector (Magento module)  ──►  Magento catalog
  {pim}/api/rest/v1/*                                       Akeneo\Connector\*                       (EAV: catalog_product,
   Connection auth (client_id/secret + user/pass)             │                                        catalog_category, eav_attribute…)
                                                              ▼
   ┌───────────────────────── one import job = an ordered STEP pipeline ─────────────────────────┐
   │ Akeneo\Connector\Job\{Category, Family, Attribute, Option, Product}  (base: Job\Import)      │
   │   steps (di.xml, ordered): createTable → insertData → "match code with Magento id" →         │
   │   set values → importMedia/importFiles → setUrlRewrite → reindex → cleanCache …              │
   │ run by:  Akeneo\Connector\Executor\JobExecutor        tracked in table: akeneo_connector_job │
   └─────────────────────────────────────────────────────────────────────────────────────────────┘
   run via:  bin/magento akeneo_connector:import --code=<job>   |   Admin grid   |   cron group "akeneo_connector"
   configure via:  Stores → Configuration → Catalog → Akeneo Connector  (etc/adminhtml/system.xml)
```

Each **Job** stages Akeneo data into a temp table, matches Akeneo codes to Magento entity IDs, writes EAV values, imports media, sets URL rewrites, and reindexes — as a sequence of **steps** declared in `etc/di.xml`. The **JobExecutor** runs the steps; progress/status lands in the `akeneo_connector_job` table (shown in the admin grid).

## When to consult this skill vs. just answer

Trigger on:

- Installing/upgrading `akeneo/module-magento2-connector-community`; composer or compatibility questions.
- Configuring the connector (credentials, website/attribute/family/channel mapping, filters, images).
- Running imports (`akeneo_connector:import`, admin grid, cron) or a specific job (category/family/attribute/option/product).
- The Job/Step/Executor pipeline, or the `akeneo_connector_job` table.
- Extending the connector (plugins around jobs, custom converters/attribute mapping, connector events).
- Import failures: API auth/connection, memory/timeout, attribute-type mismatch, missing images, partial imports, cron, reindex.

Defer / redirect:

- Pure Akeneo API questions (auth flows, endpoint shapes) → **`akeneo-pim-api-development`**.
- Generic Magento mechanics (writing a plugin, EAV internals, indexing, layout) → **`magento2-development`**.

## How to find what you need

| Task | Reference |
| --- | --- |
| What it is, install via composer, compatibility, first import | `references/getting-started.md` |
| Admin configuration: credentials, website/store & attribute/family/channel/locale/currency mapping, product filters, images | `references/configuration.md` |
| The Job pipeline + steps; category/family/attribute/option/product (+ product model/family variant) jobs; job codes | `references/jobs-and-imports.md` |
| Running imports: `akeneo_connector:import --code=…`, admin grid, cron group, JobExecutor, logs, `akeneo_connector_job` | `references/running-imports.md` |
| Module architecture + `etc/` wiring (di/events/crontab/db_schema/webapi/acl/system.xml); what maps to which Magento concept | `references/architecture.md` |
| Extending: plugins/observers around jobs, custom converters/mapping, connector events | `references/customizing.md` |
| Troubleshooting: auth, memory/timeout, mapping, images, partial imports, cron, reindex | `references/troubleshooting.md` |
| Version/compatibility matrix, CHANGELOG highlights, upgrade steps | `references/upgrade-and-versions.md` |
| Where each concern lives in the source | `references/sources/INDEX.md` |

## Critical things to know up-front

### 1. It imports; it doesn't sync back
Data flows **Akeneo → Magento** only. There is no Magento → Akeneo push. Magento-side edits to imported attributes get overwritten on the next import.

### 2. Import order matters
Structure before data: **Category → Family → Attribute → Option → Product** (product models & family variants are handled within the product/family flow). Running Product before its Families/Attributes/Options exist yields incomplete or failed mappings. See `references/jobs-and-imports.md`.

### 3. Run it three ways
`bin/magento akeneo_connector:import --code=<job>` (comma-separate codes to chain; run with **no** `--code` to print the available codes), the **admin grid**, or **cron** (group `akeneo_connector`; `LaunchScheduledJob` runs every minute, `CleanLogs` at 2 AM). See `references/running-imports.md`.

### 4. Configuration lives in Stores → Configuration → Catalog → Akeneo Connector
Credentials + all the mapping (website/store-view, attribute, family, channel/locale/currency, filters, images) are admin config (`etc/adminhtml/system.xml`). Most "nothing imported" or "wrong values" issues are misconfiguration here, not code. See `references/configuration.md`.

### 5. A job is a step pipeline, not a monolith
Each `Job\*` runs ordered **steps** declared in `etc/di.xml`. A failure reports the step it died on. To debug, read the step list for that job and the `akeneo_connector_job` row. `Job\Product` is the largest (thousands of lines). See `references/architecture.md`.

### 6. EE entities aren't imported
Reference entities and EE Asset-Manager assets are out of scope for this community connector. Don't expect them in Magento.

### 7. It depends on `akeneo/api-php-client`
The connector talks to Akeneo through the same official PHP client documented in the `akeneo-pim-api-development` skill. Connector **API/auth** errors are usually Akeneo-Connection credential problems — debug them there.

### 8. Match connector line to Magento + PHP
105.x → Magento ≥ 2.4.7 / PHP ≥ 8.2. Installing the wrong line for your Magento/PHP is a common setup failure. See the table above and `references/upgrade-and-versions.md`.

## Workflow for "set up the connector"

1. **Install** the right line for your Magento/PHP: `composer require akeneo/module-magento2-connector-community`, then `bin/magento module:enable Akeneo_Connector && bin/magento setup:upgrade`. (`references/getting-started.md`)
2. **Create an Akeneo Connection** (client_id/secret + API user) in the PIM — see the `akeneo-pim-api-development` skill's `authentication.md`.
3. **Configure** credentials + mapping under *Stores → Configuration → Catalog → Akeneo Connector*. (`references/configuration.md`)
4. **Import in order**: category → family → attribute → option → product. (`references/jobs-and-imports.md`)
5. **Verify** in the admin grid and via reindex; check `akeneo_connector_job`. (`references/running-imports.md`)
6. **Schedule** recurring imports via cron once a manual run is clean.

## Workflow for "debug a failing import"

1. **Which job/step failed?** Read the `akeneo_connector_job` row / admin grid and the step list for that job. (`references/architecture.md`)
2. **API/auth error?** Akeneo Connection credentials or reachability → verify with the `akeneo-pim-api-development` skill.
3. **Memory / timeout on a big catalog?** PHP memory_limit / max_execution_time, batching, product filters. (`references/troubleshooting.md`)
4. **Wrong/empty values?** Attribute or channel/locale mapping, attribute-type mismatch. (`references/configuration.md`, `references/troubleshooting.md`)
5. **Missing images?** Image/media import config and Akeneo media file access. (`references/troubleshooting.md`)
6. **Cron not running?** `akeneo_connector` cron group + Magento cron. (`references/running-imports.md`)
7. **Products imported but not visible?** Reindex + cache; website/store-view assignment. (`references/troubleshooting.md`)

## Embedded source-of-truth & refresh

The full module is embedded at `references/sources/magento2-connector-source/` (pinned **v105.1.2**): `Api Block Console Controller Converter Cron Executor Helper Job Logger Model Observer Setup Ui ViewModel etc i18n view` + `composer.json` + `README.md` + `CHANGELOG.md`.

**Refresh:** `bash scripts/akeneo-magento2/fetch_docs.sh` (defaults to `v105.1.2`; `CONNECTOR_TAG=latest` for the newest tag, or `CONNECTOR_TAG=vX.Y.Z`). Add `HTTPS_PROXY=…` if your egress is proxied.

## Source-of-truth hierarchy

1. The live module in the target Magento install (actual behavior + logs).
2. The embedded module source at `references/sources/magento2-connector-source/`.
3. The connector `CHANGELOG.md` and README.
4. The curated references in this skill.
5. The Akeneo help-center connector docs / blog posts.
