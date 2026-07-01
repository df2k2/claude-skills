# Configuration

All connector configuration lives in **one admin section**: *Stores → Configuration → Catalog → Akeneo Connector*. It is defined by `etc/adminhtml/system.xml` (section id `akeneo_connector`, `tab=catalog`) and read through the getter constants in `Helper/Config.php`. Defaults ship in `etc/config.xml`.

This file enumerates every group and the load-bearing fields, grounded in that source. For **how config is applied during import** see `jobs-and-imports.md`; for **empty dropdowns / wrong values / missing images** see `troubleshooting.md`; for **creating the Akeneo Connection (client_id/secret + API user) in the PIM** see the `akeneo-pim-api-development` skill; for **generic Magento config mechanics** (scopes, `config.php`, `bin/magento config:set`, ACL) see the `magento2-development` skill.

## Scope, storage, and how to read a path

- The **section is Default-scope only**: `showInDefault="1" showInWebsite="0" showInStore="0"` on `<section>`. You edit everything at *Default Config*. (Per-website/store variation happens through the **Website Mapping** field and each store view's own Magento Locale/Currency, not through config scope — see [Mapping](#mapping-website--store-view--akeneo).)
- **Config paths** are `akeneo_connector/<group_id>/<field_id>`. Every path below is the actual `Helper/Config.php` constant target — e.g. `Config::AKENEO_API_BASE_URL = 'akeneo_connector/akeneo_api/base_url'`.
- **Secrets** (`password`, `client_secret`) are `type="obscure"` with `Magento\Config\Model\Config\Backend\Encrypted` — stored encrypted, decrypted by `getAkeneoApiPassword()` / `getAkeneoApiClientSecret()`.
- **Grid fields** (Website Mapping, Attribute Mapping, Metrics, Tax, Configurable, Grouped, types, images, files…) are `AbstractFieldArray` blocks persisted with `ArraySerialized` (a JSON blob). Column ids listed below are the JSON keys.
- ACL for the section: `Akeneo_Connector::config_akeneo_connector`.
- **Live-populated dropdowns.** Channel, Family, Category, Attribute, Metric, and Grouped-family option lists are fetched **from Akeneo over the API using the credentials below**. If credentials are missing/wrong, these multiselects come back **empty** — that is the #1 "nothing to select" symptom (see `troubleshooting.md`).

---

## Group: General (`general`)

Informational only.

| Field (label) | Config path / model | Purpose |
| --- | --- | --- |
| Extension Version | backend `Model\Config\Version` | Shows installed connector version. |
| Documentation link | block `…\DocumentationLink` | Link to the Akeneo help-center connector docs. |
| Export Akeneo Connector configuration | block `…\ExportPdf` | Button: dumps the whole connector config to a PDF (support/audit). |

---

## Group: Akeneo API Configuration (`akeneo_api`) — credentials + connection

The Akeneo **Connection** half of the credentials (client_id / client_secret) and the **API user** (username / password) are created in the PIM under *Connectivity → Connections*; see `akeneo-pim-api-development`. Here you paste them.

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Akeneo base URL | `akeneo_connector/akeneo_api/base_url` | Root URL of the PIM, e.g. `https://my-pim.cloud.akeneo.com/`. |
| Akeneo username | `akeneo_connector/akeneo_api/username` | API user login (needs list permissions). `no-whitespace`. |
| Akeneo password | `akeneo_connector/akeneo_api/password` | API user password. Encrypted (obscure). |
| Akeneo API client ID | `akeneo_connector/akeneo_api/client_id` | Connection client id. `no-whitespace`. |
| Akeneo API client secret | `akeneo_connector/akeneo_api/client_secret` | Connection secret. Encrypted (obscure). |
| **Test API credentials** | button → `akeneo_connector/test` | See [Testing the connection](#testing-the-connection). |
| Akeneo Edition | `akeneo_connector/akeneo_api/edition` | Source `Model\Source\Edition`. Gates edition-only features/groups. Options: `three` (3.2), `less_four_point_zero_point_sixty_two` (4.0.0–4.0.62, **default**), `greater_or_four_point_zero_point_sixty_two` (≥4.0.62), `greater_or_five` (≥5.0), `serenity`, `growth`, `seven` (7.0). |
| Pagination size | `akeneo_connector/akeneo_api/pagination_size` | Akeneo API page size, 1–100 (default **100** from config.xml; `getPaginationSize()` falls back to 10 if blank). Lower it to reduce memory/timeout on big catalogs. |
| Admin Website Channel | `akeneo_connector/akeneo_api/admin_channel` | Source `Model\Source\Filters\Channel` (live). The Akeneo channel used for Magento's **admin website (id 0)** default scope. **Required in practice** — `getWebsiteMapping()` throws "No channel found for Admin website channel configuration." if empty. |
| Website Mapping | `akeneo_connector/akeneo_api/website_mapping` | Grid, columns `website` + `channel`. Maps each Magento website to an Akeneo channel. `required-entry`. See [Mapping](#mapping-website--store-view--akeneo). |
| Storage Engine | `akeneo_connector/akeneo_api/storage_engine` | Source `Model\Source\Engine`: `myisam` (**default**) or `innodb`. Engine for the connector's temp tables. MyISAM scales to very wide attribute sets; InnoDB is "recommended" but can fail on large/wide catalogs. |
| Disable InnoDB Strict Mode | `akeneo_connector/akeneo_api/disable_innodb_strict_mode` | Yes/No. Only shown/effective when `storage_engine=innodb`; disables InnoDB strict mode on the connector's MySQL session to survive many-attribute imports. |

### Edition matters beyond the label

The `edition` value gates whole groups and fields via `<depends>` on `akeneo_connector/akeneo_api/edition`:

- **Filter Families** and **Filter Attributes** groups → only `greater_or_four_point_zero_point_sixty_two, greater_or_five, serenity, growth, seven`.
- **Grouped products** group → only `greater_or_five, serenity, growth, seven`.
- **Akeneo attribute code for SKU** + several product-status/visibility features → only `serenity, growth, seven` (in these editions SKU behaves like a normal attribute; leaving the SKU code blank faults and stops the Product flow).

### Testing the connection

The **Test API credentials** button (`akeneo_api/api_test`, block `Block\Adminhtml\System\Config\Api\Test`) is **disabled until all five of base_url/username/password/client_id/client_secret are set**. It links to controller `Controller\Adminhtml\Test\Index` (`akeneo_connector/test`), which builds the API client via `Helper\Authenticator` and calls `getChannelApi()->all()`:

- Success → flash "**The connection is working fine**".
- Auth/reachability failure → the API exception message (or "Akeneo API connection error").

Because the channel call is the same thing that populates the live dropdowns, a green Test also means Channel/Family/etc. selectors will populate. From the CLI you can equivalently list job codes with `bin/magento akeneo_connector:import` (no `--code`) once creds work — see `running-imports.md`.

---

## Global / product filters

### Group: Filter Products (`products_filters`)

Controls **which products** the Product job pulls. `mode` switches between a guided **Standard** filter and a raw **Advanced** JSON query.

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Mode | `akeneo_connector/products_filters/mode` | `standard` (**default**) or `advanced` (`Model\Source\Filters\Mode`). Standard shows the guided fields below; Advanced shows the two JSON fields. |
| Product Completeness type | `…/completeness_type` | Operator for the completeness filter (`Model\Source\Filters\Completeness`): `no_condition`, `<`, `<=`, `>`, `>=`, `=` (**default**), `!=`, and the four `… ON ALL LOCALES` variants. |
| Product Locales | `…/completeness_locales` | Multiselect of Akeneo locales the completeness applies to (`Model\Source\Filters\Locales`, live). `required-entry` when a real operator is chosen. |
| Product Completeness value | `…/completeness_value` | 0–100 (**default 100**). |
| Product Model Completeness type | `…/model_completeness_type` | Same operators for **product models** (`Model\Source\Filters\ModelCompleteness`; default `no_condition`). |
| Product Model Locales | `…/model_completeness_locales` | Locales for the model completeness filter. |
| Status | `…/status` | `Model\Source\Filters\Status`: `no_condition`, `1`=Enabled (**default**), `0`=Disabled. Filters on the Akeneo `enabled` flag. |
| Updated mode | `…/updated_mode` | `Model\Source\Filters\Update`: *(no condition)*, `<`, `>`, `BETWEEN`, `SINCE LAST N DAYS` (**default**), `SINCE LAST N HOURS`, `LAST_IMPORT` (since last successful import). Reveals the matching date/number field below. |
| Updated before / after | `…/updated_lower` / `…/updated_greater` | Date bounds for `<` / `>` modes. |
| Updated after / before (between) | `…/updated_between_after` / `…/updated_between_before` | Date bounds for `BETWEEN`. |
| Updated | `…/updated` | N days for "SINCE LAST N DAYS". |
| Updated Since Last Hours | `…/updated_since_last_hours` | N hours for "SINCE LAST N HOURS". |
| Families to import | `…/included_families` | Multiselect of Akeneo families (`Model\Source\Filters\Family`, live). Empty = all. `can_be_empty`. |
| Advanced Product Filter | `…/advanced_filter` | JSON query (backend `Model\Backend\Json` validates JSON). Shown when `mode=advanced`. |
| Advanced Product Model Filter | `…/model_advanced_filter` | JSON query for product models (search/scope/locales), shown when `mode=advanced`. |

> Standard-mode fields (`completeness_*`, `status`, `included_families`) are **hidden and ignored** when `mode=advanced`; the JSON fields are hidden when `mode=standard`.

### Group: Filter Families (`families`) — edition-gated

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Updated mode | `akeneo_connector/families/updated_mode` | `Model\Source\Filters\FamilyUpdate` — limit the Family job to families changed since a date. |
| Updated after | `akeneo_connector/families/updated_greater` | Date bound for the `>` mode. |

### Group: Filter Attributes (`filter_attribute`) — edition-gated

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Updated mode | `akeneo_connector/filter_attribute/updated_mode` | `Model\Source\Filters\AttributeUpdate` — limit the Attribute job by change date. |
| Updated after | `…/updated_greater` | Date bound for `>`. |
| Filter by attribute code | `…/filter_attribute_code_mode` | Yes/No (**default No**). When Yes, restrict to a chosen code list. |
| Attribute codes to import | `…/filter_attribute_code` | Multiselect of Akeneo attributes (`Model\Source\Filters\Attribute`, live). Empty = import **all** attributes. `can_be_empty`. |

---

## Mapping (website / store-view / attribute / category)

### Mapping: website / store-view ↔ Akeneo channel + locale + currency

There is **only one explicit mapping field — website → channel** (`website_mapping`, plus the admin default in `admin_channel`). Locale and currency are **derived, not configured here**:

- `Helper\Config::getWebsiteMapping()` prepends the admin-website→`admin_channel` pair, then merges the `website_mapping` grid rows (`{channel, website}`). It throws if a row is missing `channel`/`website` ("The website mapping is misconfigured…").
- `Helper\Store::getStores()` then expands each mapped website into its **store views** and, per store view, takes:
  - `lang` = that store view's **Magento Locale** (*Stores → Configuration → General → Locale Options → Locale*, `general/locale/code`) → used as the **Akeneo locale**.
  - `currency` = the **website base currency** (`Website::getBaseCurrencyCode()`) → used as the **Akeneo currency** for price collections.
  - `channel_code` = the mapped Akeneo channel.

Scopable/localizable Akeneo values are matched to Magento store views by combinations of `{lang, channel_code, currency}`. **Consequences:**

- **To map a store view to an Akeneo locale, set that store view's Magento Locale to the Akeneo locale code** (e.g. `fr_FR`). No connector field does this.
- **Currency** must be an Akeneo channel currency; set it via Magento's currency config (base currency per website). There is **no connector currency field** — defer currency setup to `magento2-development`.
- The chosen channel's locales/currencies must cover every mapped store view's locale/currency, or those values import empty.

### Group: Category (`category`) + category mapping/filtering

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Activate new categories | `akeneo_connector/category/is_active` | Yes/No (**default Yes**) — new categories imported active. |
| Include new categories in menu | `…/include_in_menu` | Yes/No (**default Yes**). |
| Set new categories in anchor mode | `…/is_anchor` | Yes/No (**default Yes**). |
| Categories to import | `…/included_categories` | Multiselect of Akeneo category trees (`Model\Source\Filters\Category`, live). Empty = all. `can_be_empty`; standard mode only. |
| Does Akeneo data override category content staging | `…/override_content_staging` | **Adobe Commerce only.** Yes = overwrite all scheduled category versions; No = only the base version. |

(Getter `getCategoriesExcludedFilter()` reads `akeneo_connector/category/categories`, an exclude list with no visible field in this version — the visible control is the **include** list above.)

### Group: Attributes (`attribute`) + attribute-type mapping

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Additional types | `akeneo_connector/attribute/types` | Grid `pim_type` → `magento_type`. **Attribute-type mapping**: force a specific Akeneo attribute (by its Akeneo *type*) to a chosen Magento input. Selectable Magento types (`Helper\Import\Attribute::getAvailableTypes`): `text, textarea, date, boolean, multiselect, select, price, tax`. |
| Swatch types mapping | `…/types_swatch` | Grid `pim_type` → `magento_type` for **visual/text swatch** attributes (`getAvailableSwatchTypes`). |
| Set attribute option code as Admin label | `…/option_code_as_admin_label` | Yes/No (**default No**). Yes = use the Akeneo option **code** as the Magento option admin label; No = use the admin-locale label. |

**Built-in default type map** (before any override, from `Helper\Import\Attribute`): `pim_catalog_identifier|text|metric|number → text`, `pim_catalog_metric_select|simpleselect → select`, `pim_catalog_boolean → boolean`, `pim_catalog_multiselect → multiselect`, `pim_catalog_price_collection → price`. Use **Additional types** only to override these.

### Attribute mapping (Akeneo attribute → Magento attribute) — in the Products group

Field **Attribute Mapping** `akeneo_connector/product/attribute_mapping` (grid `akeneo_attribute` → `magento_attribute`; values lowercased by `getAttributeMapping()`). This is where you wire the **special Magento attributes**:

- **`name`, `url_key`, description, meta_*** → map from the corresponding Akeneo attribute. If a row maps `magento_attribute=url_key`, `isUrlKeyMapped()` returns true and URL keys come from Akeneo (otherwise Magento generates them).
- **`price` / `special_price` / `cost`** → **not auto-mapped**; you must add explicit rows (per the field's own comment) — or map price via **Metrics**/price-collection handling.
- **`status`, `visibility`, `tax_class`** have **dedicated fields** (below) — prefer those over an attribute_mapping row.

Other Magento product-side concerns configured in the **Products** group: SKU source, product type, status, visibility, tax, configurable/product-model handling, metrics, associations, media, files, URL rewrites — see the next section.

---

## Group: Products (`product`) — the biggest group

### Identity, type, status, visibility

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Akeneo attribute code for SKU | `akeneo_connector/product/akeneo_attribute_code_for_sku` | Serenity/Growth/7.0 only. Akeneo attribute that supplies the Magento SKU (default `sku`). Blank → faults & stops the Product flow. |
| Website Attribute | `…/website_attribute` | Code of an Akeneo select/multiselect attribute that assigns products to Magento websites. Blank = ignore. |
| Akeneo Attribute Code for Product Type Mapping | `…/product_mapping_attribute` | Akeneo select attribute choosing the Magento **product type**. Blank → non-model products become **simple**; value `virtual` → virtual product. |
| Product Status Mode | `…/product_status_mode` | `Model\Source\StatusMode`: `default_product_status` (**default**), `status_based_on_completeness_level` (Growth/Serenity/7.0 only), `attribute_product_mapping`. Selects which status fields below apply. |
| Akeneo Attribute code for Simple product statuses | `…/attribute_code_for_simple_product_statuses` | Yes/No Akeneo attribute driving **simple** product status. Shown when mode = attribute mapping. Global/scopable only. |
| Akeneo Attribute code for Configurable product statuses | `…/attribute_code_for_configurable_product_statuses` | Same for **configurable** products. |
| Enable Simple Products per website if completeness ≥ | `…/enable_simple_products_per_website` | 0–100. Shown when mode = completeness level (Serenity/Growth/7.0). |
| Default Configurable Products Status | `…/default_configurable_product_status` | `Model\Source\Activation` (`1`=Enabled, `2`=Disabled; default `2`). Completeness-level mode. |
| Default Product Status | `…/activation` | `Model\Source\Activation` (default `2`=Disabled). Status for **new** products when mode = default. Updates don't change status unless disabled in Akeneo. |
| Enable Visibility Mapping From Akeneo Attribute | `…/visibility_enabled` | Yes/No (**default No**). Turns on the three visibility fields. |
| Default product visibility | `…/default_visibility` | `Magento\Catalog\Model\Product\Visibility` (default `1`). |
| Akeneo Attribute Code For Simple Product Visibility | `…/visibility_simple` | Akeneo attribute → simple product visibility. |
| Akeneo Attribute Code For Configurable Product Visibility | `…/visibility_configurable` | Akeneo attribute → configurable product visibility. |

### Mapping, metrics, tax, configurable/product-model

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Attribute Mapping | `akeneo_connector/product/attribute_mapping` | Grid `akeneo_attribute`→`magento_attribute` (see [Attribute mapping](#attribute-mapping-akeneo-attribute--magento-attribute--in-the-products-group)). |
| Metric Attributes | `…/metrics` | Grid columns `akeneo_metrics` (live metric list), `is_variant` (used as variant), `is_concat` (concat the unit onto the value). Controls how Akeneo **metric** attributes import. |
| Default Tax Class | `…/tax_class` | Grid `website` → `tax_class` (`getProductTaxClasses()` resolves per store). Sets default product tax class per website. |
| Configurable | `…/configurable_attributes` | Grid `attribute` / `type` / `value` for **product-model → configurable** handling. `type` ∈ `mapping` (map a model attr to a Magento attr), `simple`=First Variation value, `query`=SQL Statement, `value`=Default value. |

### Associations (related / upsell / cross-sell)

| Field (label) | Config path | Default | Purpose |
| --- | --- | --- | --- |
| Akeneo association code for Related products | `akeneo_connector/product/association_related` | `SUBSTITUTION` | Akeneo association code → Magento Related. Quantified associations not allowed. |
| Akeneo association code for Upsell products | `…/association_upsell` | `UPSELL` | → Magento Up-sell. |
| Akeneo association code for Cross-sell products | `…/association_crossell` | `X_SELL` | → Magento Cross-sell. |

(`getAssociationTypes()` maps each code to `<code>-products` and `<code>-product_models`; each field is `canRestore` to its default.)

### Images / media / files

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Import Image Attributes | `akeneo_connector/product/media_enabled` | Yes/No master switch for image import (`isMediaImportEnabled()`). |
| Akeneo Images Attributes | `…/media_gallery` | Grid `attribute` (Akeneo image attr) + `type` (`all`/`parent`/`child`). All listed attrs feed the product **media gallery**. `getMediaImportGalleryColumns()`. |
| Product Images Mapping | `…/media_images` | Grid `attribute` (Magento `media_image` role, e.g. base/small/thumbnail) → `column` (Akeneo image attr). Assigns image **roles**. `getMediaImportImagesColumns()`. |
| Import File Attributes | `…/file_enabled` | Yes/No. Downloads Akeneo **file** attributes into `pub/media/akeneo_connector/media_files`. |
| Akeneo File Attributes | `…/file_attribute` | Grid `file_attribute` — list of Akeneo `pim_catalog_file` attributes to download; the saved path lands in the matching Magento text attribute. |

### Content staging + URL rewrites

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Does Akeneo data override content staging | `akeneo_connector/product/akeneo_master` | **Adobe Commerce only.** Yes = overwrite all scheduled product versions; No = base version only (`isAkeneoMaster()`). |
| Regenerate url rewrites | `…/url_generation_enabled` | Yes/No (**default Yes**). Rebuild product URL rewrites after import (`isUrlGenerationEnabled()`). See URL-key note under Attribute mapping. |

---

## Group: Grouped products (`grouped_products`) — edition-gated (≥5.0)

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Grouped product families and quantity association mapping | `akeneo_connector/grouped_products/families_mapping` | Grid `akeneo_grouped_family_code` (live family list) → `akeneo_quantity_association`. Maps each Akeneo grouped family to its **quantified association** to build Magento grouped products. Map **only quantified associations**. `getGroupedFamiliesToImport()` / `getGroupedAssociationsToImport()`. |

---

## Post-import: Index & Cache

### Group: Index (`index`)

Multiselects of Magento indexers (`Model\Source\Index`, live from the indexer list) to **reindex after** each job. All `can_be_empty`.

| Field | Config path |
| --- | --- |
| Reindex after Category import | `akeneo_connector/index/index_category` |
| Reindex after Family import | `…/index_family` |
| Reindex after Attribute import | `…/index_attribute` |
| Reindex after Option import | `…/index_option` |
| Reindex after Product import | `…/index_product` |

### Group: Cache (`cache`)

Multiselects of Magento cache types (`Model\Source\Cache`, live) to **flush after** each job. Default for all five: `block_html,full_page`.

| Field | Config path |
| --- | --- |
| Flush cache after Category import | `akeneo_connector/cache/cache_type_category` |
| Flush cache after Family import | `…/cache_type_family` |
| Flush cache after Attribute import | `…/cache_type_attribute` |
| Flush cache after Option import | `…/cache_type_option` |
| Flush cache after Product import | `…/cache_type_product` |

---

## Group: Advanced (`advanced`)

| Field (label) | Config path | Purpose |
| --- | --- | --- |
| Enable Advanced Logging | `akeneo_connector/advanced/advanced_log` | Yes/No (**default No**). Verbose logs to `var/log/akeneo_connector`; **keeps temp tables** after import (slower — for debugging). |
| Enable Job Logs Cleaning | `…/enable_clean_logs` | Yes/No (**default Yes**). Auto-purge old job logs (cron `CleanLogs`, 2 AM). |
| Clear job logs after X days | `…/clean_logs` | Retention days (**default 30**). Shown when cleaning enabled. |
| Enable Job Report By Email | `…/email_job_report_enabled` | Yes/No. Email a report after jobs (template `akeneo_connector_report_email`; from = `trans_email/ident_general`). |
| Job Report Recipient Emails | `…/email_job_report_recipient` | Comma-separated recipients. `no-whitespace`. |
| Enable Job grid auto reload | `…/enable_job_grid_auto_reload` | Yes/No (**default Yes**). Admin Jobs grid refreshes every 5 s. |

---

## Smallest working config (checklist)

Enough to run a first Category→…→Product import (see `getting-started.md` for install and `jobs-and-imports.md` for run order):

1. **Edition** (`akeneo_api/edition`) — match your PIM (e.g. `seven` for 7.0 / `serenity` / `growth`). This unlocks the right fields.
2. **Credentials** (`akeneo_api/base_url`, `username`, `password`, `client_id`, `client_secret`) — from your Akeneo Connection + API user.
3. Click **Test API credentials** → must say "The connection is working fine". (If the channel/family dropdowns are empty, creds are wrong.)
4. **Admin Website Channel** (`akeneo_api/admin_channel`) — pick your Akeneo channel (required; otherwise mapping throws).
5. **Website Mapping** (`akeneo_api/website_mapping`) — at least map your main website → that channel. Ensure each store view's Magento **Locale** matches an Akeneo locale, and each website's base **currency** is one of the channel's currencies.
6. **Filter Products** (`products_filters/mode=standard`) — sane completeness (`=`/`100`) + at least one **Product Locale**, or set `completeness_type=no_condition` to import everything while testing.
7. For **Serenity/Growth/7.0**: set **Akeneo attribute code for SKU** (`product/akeneo_attribute_code_for_sku`, usually `sku`) or the Product flow stops.
8. Optionally set **Default Product Status** (`product/activation`) to Enabled if you want products live immediately (ships Disabled).
9. Leave Index/Cache at defaults; keep **pagination_size=100** unless you hit memory/timeouts (then lower it — see `troubleshooting.md`).

Everything else (attribute/type mapping, metrics, tax, configurable, associations, images/files, visibility, grouped products) is **additive** — configure per catalog need.

## Notes / clarifications

- **Locale/currency have no dedicated mapping fields** — they are inferred from each Magento store view's Locale and each website's base currency (confirmed in `Helper\Store::getStores()`). This is easy to miss; treat store-view **Locale** as the locale-mapping control.
- The `category/categories` and `products_filters/families` **exclude** getters exist in `Helper\Config.php` but have no visible field in this version's `system.xml`; the exposed controls are the **include** multiselects (`included_categories`, `included_families`).
- The **Filter Families** group's `updated_greater` field carries a `<depends>` on a non-existent local `mode` field (a copy artifact); in practice its visibility follows `updated_mode`.

## Original sources

- `references/sources/magento2-connector-source/etc/adminhtml/system.xml` — the full admin config tree (all groups/fields/labels/depends).
- `references/sources/magento2-connector-source/etc/config.xml` — default values.
- `references/sources/magento2-connector-source/Helper/Config.php` — every config path constant + getter (the authoritative path list).
- `references/sources/magento2-connector-source/Helper/Store.php` — website→channel expansion and locale/currency derivation.
- `references/sources/magento2-connector-source/Model/Source/*` and `Model/Source/Filters/*` — dropdown option sources (Edition, Engine, Mode, Completeness, Update, Status, StatusMode, Activation, Index, Cache, Channel, Family, Category, Attribute, Metrics…).
- `references/sources/magento2-connector-source/Block/Adminhtml/System/Config/Form/Field/*` — grid column ids (Website, Attribute, Metrics, Tax, Configurable, Grouped, Type, SwatchType, Image, Gallery, File).
- `references/sources/magento2-connector-source/Block/Adminhtml/System/Config/Api/Test.php` + `Controller/Adminhtml/Test/Index.php` — the Test-connection button behavior.
- `references/sources/magento2-connector-source/Helper/Import/Attribute.php` — built-in Akeneo→Magento type map and available target types.
- `references/sources/magento2-connector-source/etc/{acl,menu,routes,crontab,cron_groups,email_templates}.xml` — section ACL, admin menu/route, cron.
