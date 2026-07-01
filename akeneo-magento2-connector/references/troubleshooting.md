# Troubleshooting

The "why did my import fail / do the wrong thing?" catalog, mapped **symptom → cause → fix**, grounded in the vendored source (`references/sources/magento2-connector-source/`). Most problems are **configuration**, not code — the config lives under *Stores → Configuration → Catalog → Akeneo Connector* (`etc/adminhtml/system.xml`), and the paths below are the constants in `Helper/Config.php`.

## Diagnose first (which job / step failed?)

1. **The `akeneo_connector_job` table / admin grid** — status per job code: `1=SUCCESS 2=ERROR 3=PROCESSING 4=SCHEDULED 5=PENDING` (`Api/Data/JobInterface.php`). The grid shows the last run and its step.
2. **The step it died on** — a job is an ordered **step pipeline** (`etc/di.xml`); the failure names the step method. See `architecture.md` / `jobs-and-imports.md` for each job's step list.
3. **Logs** — enable *Advanced → Advanced Log* (`akeneo_connector/advanced/advanced_log`) to get per-entity files (`akeneoConnectorProductLogger`, etc.) under `var/log/`. Also `var/log/` Magento exception/system logs.
4. **Run from CLI** for full output: `bin/magento akeneo_connector:import --code=<job>` (see `running-imports.md`).

---

## 1. API connection / authentication failures

Credentials are the Akeneo **Connection** (client_id/secret + API user/password). The connector talks to Akeneo through `akeneo/api-php-client`; for the Connection/token side, use the **`akeneo-pim-api-development`** skill.

| Symptom | Cause | Fix |
| --- | --- | --- |
| `API credentials are missing. Please configure the connector and retry.` | `checkAkeneoApiCredentials()` found one of the five values empty | Set **all** of `akeneo_api/{base_url, client_id, client_secret, username, password}` — the check fails if *any* is blank (`JobExecutor::execute()` → `Helper\Config`). |
| Connection error / no client, every job | Base URL wrong/unreachable, TLS, or firewall to the PIM | Verify `akeneo_api/base_url` (scheme + host, no trailing `/api/...`); curl the PIM from the Magento host. `Authenticator::getAkeneoApiClient()` returns false → `getApiConnectionError()`. |
| `401`/`invalid credentials` from the API | Bad client_id/secret or API user/password; Connection revoked in PIM | Regenerate the Connection in Akeneo; re-enter secret (write-only field). Debug token flow with **`akeneo-pim-api-development`**. |
| `403` / missing data for a user | API user lacks role/permissions in Akeneo | Grant the Connection's user the needed catalog permissions in the PIM. |
| Works from your laptop, fails from Magento server | Egress/proxy/DNS on the server only | Set `HTTPS_PROXY`/allow egress from the Magento host to the PIM; check DNS. |
| Intermittent timeouts mid-import | PIM slow / network flaky at large pages | Lower `akeneo_api/pagination_size`; retry; check PIM load. |

---

## 2. "Nothing imported" / empty grid

| Symptom | Cause | Fix |
| --- | --- | --- |
| Admin grid has **no job rows** | Module not fully installed | `bin/magento module:enable Akeneo_Connector && bin/magento setup:upgrade` (seeds `akeneo_connector_job`). See `getting-started.md`. |
| Product job: `No family to import` | No family passes the filter | Product import iterates **families** (`getFamiliesToImport()`); set `products_filters/families` / `included_families` so at least one is included. |
| Product/category import returns 0 rows | **Filters too strict** | Loosen `products_filters/*`: `completeness_type`/`completeness_value`/`completeness_locales`, `status`, `updated_*`, `advanced_filter`. Test with filters cleared first. |
| Everything empty or wrong-locale | **Wrong channel** | `akeneo_api/admin_channel` must be a scope that actually has data/locales; a wrong channel yields empty or mismatched values. See `configuration.md`. |
| Products import but categories/attributes missing | **Wrong import order** | Structure before data: Category → Family → Attribute → Option → Product. Running Product first leaves mappings empty. See `jobs-and-imports.md`. |
| Job status stuck `PROCESSING`, won't rerun | Previous run crashed | See **§9 (locked jobs)**. |
| Only *some* products import | Delta filter (`updated`/`updated_since_last_hours`) excludes unchanged items | Expected for differential imports; switch filter mode to full to reimport all. |

---

## 3. Memory exhaustion / `max_execution_time` on big catalogs

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Allowed memory size exhausted` | Large catalog + high page size | Raise CLI PHP `memory_limit` (e.g. `php -d memory_limit=4G bin/magento akeneo_connector:import --code=product`); tune `akeneo_api/pagination_size` (**default 10**, `PAGINATION_SIZE_DEFAULT_VALUE`). |
| `Maximum execution time exceeded` in admin | Admin/web request timeout on a long job | **Run from CLI**, not the admin grid — CLI has no web time limit. Or schedule via cron. |
| Import crawls / thousands of API calls | Page size too **small** | Raise `pagination_size` (fewer, bigger pages) — balance against memory. |
| One giant family blows memory | All variants of a family load together | Product import already runs **once per family** (memory freed between families). Narrow to that family via `products_filters/families`, or shrink it with completeness/updated filters. |
| Cron worker OOMs and kills siblings | Shared process | Keep cron group `akeneo_connector` `use_separate_process=1` (default, `etc/cron_groups.xml`) so each job runs in its own PHP process. |
| Slow + huge logs | Advanced log on for a big run | Disable `advanced/advanced_log` during bulk imports. |
| Want to bound scope | Chaining all codes at once | Run one code at a time (`--code=product`), and use `updated_*` delta filters for recurring runs. |

---

## 4. Attribute-type mismatch / wrong or empty values

| Symptom | Cause | Fix |
| --- | --- | --- |
| Attribute imported as the wrong Magento type | PIM type → Magento type mapping wrong | Fix the type mapping in *Attribute* config (`attribute/types`, `attribute/types_swatch`); the Attribute job's `matchType` step consumes it. For a new/custom type, use the attribute events in `customizing.md`. |
| Values land on the wrong / no attribute | **Attribute mapping** wrong or missing | Set `product/attribute_mapping` (Akeneo code → Magento code); also `product/product_mapping_attribute`. See `configuration.md`. |
| Attribute value **empty** in Magento | Value only exists for another locale/channel in Akeneo | Fix channel (`akeneo_api/admin_channel`) + store-view **locale mapping** (`Helper\Store`); the `{scope,locale}` with no PIM data imports empty. |
| Select/multiselect values blank | **Options imported after products**, or option code mismatch | Import **Option** before **Product**; check `attribute/option_code_as_admin_label`. |
| Multiselect picks extra options | Similar option codes collide (known bug, fixed) | Ensure connector ≥ the CHANGELOG fix ("multiselect attribute options assignation… similar code"); see `upgrade-and-versions.md`. |
| Metric value = `0` or fails on uppercase code | Metric handling edge cases (fixed in CHANGELOG) | Upgrade; verify metric attribute config; empty metric now imports empty, not `0`, on current line. |
| Price attribute import error | Price/tax type mismatch | Map price attributes to Magento `price`/`tax` type; set `product/tax_class`. |

---

## 5. Missing images / media

Media is downloaded **through the Akeneo API**; the Product job handles it in `importFiles` (step 14) and `importMedia` (step 24).

| Symptom | Cause | Fix |
| --- | --- | --- |
| No images at all | Media import disabled | Enable `product/media_enabled`; list image attribute codes in `product/media_images` and/or `product/media_gallery`. |
| Specific image attribute skipped | Attribute code not in the media config | Add it to `product/media_images` / `product/media_gallery`. |
| File attributes (PDF, etc.) not imported | File import disabled | Enable `product/file_enabled` and set `product/file_attribute`. |
| Images 403/404 on download | API user can't read the media, or media host unreachable from Magento | Grant media access to the Connection user; ensure the Magento host can reach the PIM's media endpoint (**`akeneo-pim-api-development`** for the media API). |
| Image filenames changed / de-duplicated | Magento ≥ 2.3.3 caps image names at 90 chars (CHANGELOG) | Expected — names are normalized/renamed on import. |
| Images import but don't show | `pub/media` perms / disk full, or gallery not reindexed | Fix `pub/media` permissions and disk; reindex + flush cache (**§6**). |

See `configuration.md` (Images section).

---

## 6. Products imported but not visible on the storefront

The Product job ends with `setWebsites` (18), `refreshIndex` (26), `cleanCache` (27) — but reindex/cache steps only run if enabled in config.

| Symptom | Cause | Fix |
| --- | --- | --- |
| Product exists in admin, not on storefront | **Not reindexed** | The `refreshIndex` step runs only if `index/index_product` is on; otherwise `bin/magento indexer:reindex`. |
| Still stale after reindex | **Cache** not cleared | `cleanCache` runs only if `cache/cache_type_product` is on; otherwise `bin/magento cache:flush`. |
| Product on no website | Website not assigned | Set `akeneo_api/website_mapping`; for per-website simples, `product/enable_simple_products_per_website`; `setWebsites` step assigns them. |
| Product **disabled** | Status mapping | Check `product/activation`, `product_status_mode`, `attribute_code_for_simple_product_statuses`, `default_configurable_product_status`. |
| Product not visible (visibility) | Visibility mapping | `product/visibility_enabled`, `default_visibility`, `visibility_simple`, `visibility_configurable`. |
| Not in any category / store view | Category or store-view scope | Verify category import + assignment and store-view/locale mapping. See `configuration.md`. |

---

## 7. Configurable products wrong

Configurables come from Akeneo **product models + family variants**: Product job steps `productModelImport` (3), `familyVariantImport` (4), `createConfigurable` (6), `linkConfigurable` (16), `linkSimple` (17).

| Symptom | Cause | Fix |
| --- | --- | --- |
| Variants stay separate simples | Product model / family variant not imported | Ensure the product **model** and **family variant** exist; run Family before Product. |
| Configurable created but no children linked | **Axis (configurable) attributes** misconfigured | Set `product/configurable_attributes` to the real variant axes; they must match the Akeneo family variant. |
| Wrong / missing variation options | Axis attribute's options not imported | Import **Attribute** + **Option** before **Product** so the axis options exist. |
| Configurable has wrong attribute set | Family mapping off | Check family import + `updateAttributeSetId` (step 11); reimport Family. |
| Axis attribute values empty on children | Attribute not scoped/mapped for the channel | Fix attribute + channel/locale mapping (**§4**). |

See `jobs-and-imports.md` (product model / family variant flow).

---

## 8. Cron not launching scheduled jobs

Cron group `akeneo_connector` (`etc/crontab.xml`): `LaunchScheduledJob` **every minute**, `CleanLogs` **at 02:00**.

| Symptom | Cause | Fix |
| --- | --- | --- |
| Scheduled jobs never run | **Magento cron not running** | Install the system crontab (`bin/magento cron:install`) or run `bin/magento cron:run --group=akeneo_connector`; confirm the `cron_schedule` table gets `akeneo_connector_*` rows. |
| Job set but not picked up | Not in `SCHEDULED` status | `LaunchScheduledJob` only runs jobs with status **`JOB_SCHEDULED` (4)** — use the grid's **Schedule** action (`MassSchedule`). Manual `--code` runs don't need scheduling. |
| Cron errors: PHP binary not found | `use_separate_process=1` can't spawn PHP | Configure the cron PHP path, or set `use_separate_process=0` in the `akeneo_connector` cron group. |
| `CleanLogs` never prunes | Cleanup disabled | Enable `advanced/enable_clean_logs` (+ `advanced/clean_logs` retention). |
| Runs late / batched oddly | Cron group timing | Tune `cron_groups.xml` (`schedule_ahead_for`, `schedule_lifetime`); ensure the OS cron fires frequently. See `running-imports.md`. |

---

## 9. Duplicate / locked jobs (a job already running)

`checkStatusConditions()` (`JobExecutor`) refuses to start a job that is already `PROCESSING` or `SCHEDULED`.

| Symptom | Cause | Fix |
| --- | --- | --- |
| `The job %1 is already running` | Status stuck at `PROCESSING` (3) after a crash/kill | **Reset** it: grid **Reset** action (`MassReset` → `resetStatus()`), or SQL `UPDATE akeneo_connector_job SET status = 1 WHERE code = '<job>';` then rerun. |
| `The job %1 is already scheduled` | Status is `SCHEDULED` (4), waiting for cron | Wait for the cron pickup, or Reset and run manually. |
| Two runs collide (cron + CLI) | Overlapping triggers | Harmless — the second is refused, not corrupted. Stagger cron vs. manual runs. |
| Whole product job flips to `ERROR` | One **family** failed mid-run | Product runs per family; find the failing family in the logs, fix its data/mapping, rerun `--code=product`. |
| Job "hangs" forever in `PROCESSING` | Process died without updating status | Same as row 1 — reset the `akeneo_connector_job` row. |

---

## When you still can't tell

1. Re-read the failing **step** in the source (`Job/<Job>.php`) — the step name from the grid maps to a public method.
2. Turn on `advanced/advanced_log` and re-run from CLI; read the per-entity log in `var/log/`.
3. Confirm the **Akeneo side** (data actually present for that channel/locale/family, Connection permissions) with the **`akeneo-pim-api-development`** skill.
4. Confirm **generic Magento** behavior (indexing, cache, EAV) with the **`magento2-development`** skill.
5. Check the connector `CHANGELOG.md` — many value/media/URL edge cases are already-fixed bugs; you may just need to upgrade (`upgrade-and-versions.md`).

---

## Original sources

- `references/sources/magento2-connector-source/Helper/Config.php` — every `akeneo_connector/*` config path referenced above.
- `references/sources/magento2-connector-source/Executor/JobExecutor.php` — `checkAkeneoApiCredentials()`/`execute()` guard, `checkStatusConditions()` (locked jobs), per-family product loop.
- `references/sources/magento2-connector-source/Api/Data/JobInterface.php` — job status constants (`JOB_SUCCESS/ERROR/PROCESSING/SCHEDULED/PENDING`).
- `references/sources/magento2-connector-source/etc/di.xml` — per-job step pipelines (step names referenced in §5–§7).
- `references/sources/magento2-connector-source/etc/crontab.xml` & `etc/cron_groups.xml` — cron group, schedules, `use_separate_process`.
- `references/sources/magento2-connector-source/Cron/LaunchScheduledJob.php` — only `SCHEDULED` jobs are launched.
- `references/sources/magento2-connector-source/Controller/Adminhtml/Job/{MassReset,MassSchedule}.php` — grid reset/schedule actions.
- `references/sources/magento2-connector-source/etc/db_schema.xml` — `akeneo_connector_job` columns.
- `references/sources/magento2-connector-source/README.md` & `CHANGELOG.md` — requirements + already-fixed edge cases.
- Sibling refs: `getting-started.md`, `configuration.md`, `jobs-and-imports.md`, `running-imports.md`, `architecture.md`, `upgrade-and-versions.md`.
- Akeneo Connection / API side → **`akeneo-pim-api-development`**; generic Magento (indexing, cache, EAV) → **`magento2-development`**.
</content>
</invoke>
