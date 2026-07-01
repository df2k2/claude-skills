# Embedded Source — Topic Index (akeneo-magento2-connector)

The **complete map** of this skill: curated references, plus where each concern lives in the
vendored module source (`magento2-connector-source/`, pinned **v105.1.2**).

## How the skill is structured

```
akeneo-magento2-connector/
├── SKILL.md                              ← entry point; direction, compatibility, command, cron, jobs
├── scripts/akeneo-magento2/
│   └── fetch_docs.sh                     ← re-vendor the module at a tag (CONNECTOR_TAG, HTTPS_PROXY aware)
├── references/                           ← curated guides (read first)
│   ├── getting-started.md
│   ├── configuration.md
│   ├── jobs-and-imports.md
│   ├── running-imports.md
│   ├── architecture.md
│   ├── customizing.md
│   ├── troubleshooting.md
│   ├── upgrade-and-versions.md
│   └── sources/
│       ├── INDEX.md                      ← (this file)
│       └── magento2-connector-source/    ← the full akeneo/module-magento2-connector-community @ v105.1.2
```

## Topic → curated reference

| Topic / task | Curated reference |
| --- | --- |
| What it is, install, compatibility, first import | `references/getting-started.md` |
| Admin config: credentials + website/attribute/family/channel/locale/currency mapping, filters, images | `references/configuration.md` |
| The Job pipeline + steps; category/family/attribute/option/product; job codes; import order | `references/jobs-and-imports.md` |
| Running imports: `akeneo_connector:import`, admin grid, cron, JobExecutor, logs, `akeneo_connector_job` | `references/running-imports.md` |
| Module map + `etc/` wiring; what maps to which Magento concept | `references/architecture.md` |
| Extending: connector events, di preferences, custom converters/mapping, plugins | `references/customizing.md` |
| Troubleshooting: auth, memory/timeout, mapping, images, partial imports, cron, reindex | `references/troubleshooting.md` |
| Version/compatibility matrix, CHANGELOG, upgrade steps | `references/upgrade-and-versions.md` |

## Topic → where it lives in the source

| Concern | Source location |
| --- | --- |
| Import jobs (the pipelines) | `magento2-connector-source/Job/{Import,Category,Family,Attribute,Option,Product}.php` |
| Job step order (per job) | `magento2-connector-source/etc/di.xml` (`<type name="Akeneo\Connector\Job\*">` step lists) |
| Job runner / scheduler | `magento2-connector-source/Executor/` (JobExecutor) |
| CLI command | `magento2-connector-source/Console/Command/AkeneoConnectorImportCommand.php` (`akeneo_connector:import --code=`) |
| Cron (launch scheduled + clean logs) | `magento2-connector-source/Cron/`, `etc/crontab.xml`, `etc/cron_groups.xml` (group `akeneo_connector`) |
| Job queue/history table | `magento2-connector-source/etc/db_schema.xml` (`akeneo_connector_job`), `Model/ResourceModel/Job*`, `Model/Source/Status.php` |
| Admin config fields | `magento2-connector-source/etc/adminhtml/system.xml` (Stores → Config → Catalog → Akeneo Connector) |
| Config defaults / getters | `magento2-connector-source/etc/config.xml`, `Helper/Config.php` |
| Akeneo→Magento value conversion (the real ETL) | `magento2-connector-source/Job/*` + `Helper/Import/*` (`Entities` + Product/Option/FamilyVariant subclasses) — **not** `Converter/`, which is just `ArrayToJsonResponseConverter` |
| Shared import helpers | `magento2-connector-source/Helper/` (Import/Entities, ProductModel, FamilyVariant, ProductFilters) |
| Event hooks observed | `magento2-connector-source/etc/events.xml`, `Observer/` |
| Connector events fired (extension seams) | grep `Job/` + `Executor/` for `->dispatch('akeneo_connector_` |
| Admin grid & UI | `magento2-connector-source/Ui/`, `Block/`, `ViewModel/`, `view/`, `Controller/Adminhtml/` |
| Admin ACL / menu / routes | `magento2-connector-source/etc/acl.xml`, `etc/adminhtml/{menu,routes}.xml` |
| Module REST API | **none** — `etc/webapi.xml` is empty (`<routes/>`); `Api/*Interface` are internal PHP `@api` service/data contracts (e.g. `JobInterface` status constants SUCCESS=1/ERROR=2/PROCESSING=3/SCHEDULED=4/PENDING=5), not HTTP routes |
| Install/upgrade schema & data | `magento2-connector-source/Setup/`, `etc/db_schema.xml` |
| Dependencies (incl. `akeneo/api-php-client`) | `magento2-connector-source/composer.json` |
| Version history | `magento2-connector-source/CHANGELOG.md` |

## Key facts (verified from source)

- **Package:** `akeneo/module-magento2-connector-community` · **module:** `Akeneo_Connector` · **namespace:** `Akeneo\Connector` · **embedded tag:** `v105.1.2`.
- **Direction:** Akeneo PIM → Magento (pull/import only). CE-level data; EE reference entities & Asset-Manager assets are **not** imported.
- **Command:** `bin/magento akeneo_connector:import --code=<job>` (comma-separate to chain; no `--code` prints available codes).
- **Cron group:** `akeneo_connector` — `LaunchScheduledJob` every minute, `CleanLogs` at 2 AM; `use_separate_process=1`.
- **Dependency:** `akeneo/api-php-client 11.4.0` — the same client documented in the `akeneo-pim-api-development` skill.
- **License:** OSL-3.0 / AFL-3.0 (Agence Dn'D, successor to PIMGento 2).

## Search patterns

```bash
S=references/sources/magento2-connector-source
# The ordered steps of the product import
grep -n -A40 'name="Akeneo\\Connector\\Job\\Product"' $S/etc/di.xml
# The exact --code values (each job's code)
grep -rn "getCode\|setCode\|->code" $S/Job $S/Setup
# Connector events you can observe
grep -rn "dispatch('akeneo_connector_" $S
# Admin config field paths
grep -n "<field id=" $S/etc/adminhtml/system.xml
```

## Authoritative-source priority

1. The live module in the target Magento install (behavior + logs).
2. The embedded source at `magento2-connector-source/`.
3. The connector `CHANGELOG.md` / README.
4. The curated references in this skill.
5. The Akeneo help-center connector docs / blog posts.

## Refresh

`bash scripts/akeneo-magento2/fetch_docs.sh` (defaults to `v105.1.2`; `CONNECTOR_TAG=latest` or `=vX.Y.Z`; `HTTPS_PROXY=…` if proxied). The vendored tag is recorded in `magento2-connector-source/.source-tag`.
