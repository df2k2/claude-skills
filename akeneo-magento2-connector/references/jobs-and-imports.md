# Jobs and Imports

An import in the Akeneo Connector is a **Job**, and a Job is an **ordered pipeline of steps**. Each step is one PHP method on the Job class; the connector runs them in sequence, staging Akeneo data into a temporary table, matching Akeneo codes to Magento entity IDs, writing EAV values, importing media, setting URL rewrites, and reindexing. There are exactly **five** Jobs — `category`, `family`, `attribute`, `option`, `product` — and they must run in that order.

This reference covers *what each Job does*: its purpose, prerequisites, and the exact ordered step list from `etc/di.xml`. The **run mechanics** (how the JobExecutor drives the loop, status transitions, the admin grid, cron, logs) live in `running-imports.md`; the *configuration* that controls filters, mapping, media, and website/price scope lives in `configuration.md`; the module wiring lives in `architecture.md`.

## The Job model

Every Job extends the abstract base `Akeneo\Connector\Job\Import` (`Job/Import.php`, `extends DataObject implements ImportInterface`). The base provides the identity and status surface; the concrete Job (`Job\Category`, `Job\Family`, `Job\Attribute`, `Job\Option`, `Job\Product`) provides the step *methods*.

| Base member (`Job/Import.php`) | Role |
| --- | --- |
| `$code`, `getCode()` | The job code (`category` … `product`) — this is the `--code=` value. |
| `$name`, `getName()` | Human label (`Category` …). |
| `$status`, `setStatus()`/`getStatus()` | Per-step boolean success flag the executor reads after each method. |
| `beforeImport()` / `afterImport()` | Auto-prepended/appended pseudo-steps (see below). `beforeImport` bails early if the Akeneo API client is `false` (bad credentials). |
| `setJobExecutor($executor)` | Injects the running `JobExecutor` and the Akeneo API client into the Job. |
| `logImportedEntities()`, `checkLabelPerLocales()` | Shared helpers used inside steps. |

### Steps are declared in di.xml, not in PHP

A Job does **not** hard-code its step order. The ordered list is injected as constructor `data` in `etc/di.xml` under `<argument name="data"><item name="steps">`. Each numbered `<item>` carries a `method` (the PHP method to call on the Job) and a `comment` (the label shown in the console/grid):

```xml
<item name="1" xsi:type="array">
    <item name="method" xsi:type="string">createTable</item>
    <item name="comment" xsi:type="string">Create temporary table</item>
</item>
```

At run time `JobExecutor::initSteps()` reads that array and wraps it with two implicit steps — `beforeImport` ("Start import") at the front and `afterImport` ("Import complete") at the end — then the executor walks the list from step 0, calling `$jobClass->{$method}()` for each. So the real executed sequence for any Job is:

```
beforeImport → [ di.xml steps, in order ] → afterImport
```

To change or extend a Job's pipeline you edit its `<type name="Akeneo\Connector\Job\*">` `steps` array in a di.xml override (or add a plugin around a step) — see `customizing.md`. The executor also fires `akeneo_connector_import_step_start`/`_finish` events (and per-code variants) around every step, which is the supported extension seam.

### Status, state, and the `akeneo_connector_job` table

Each Job has a persistent row in the `akeneo_connector_job` table (seeded by the `CreateJobs` data patch, `Setup/Patch/Data/CreateJobs.php`). Columns (`etc/db_schema.xml`): `entity_id`, `code`, `status`, `scheduled_at`, `last_executed_date`, `last_success_date`, `job_class`, `name`, `position`, `last_success_executed_date`.

The `status` column takes one of five integer states (`Api/Data/JobInterface.php`; label source `Model/Source/Status.php`):

| Const | Value | Meaning |
| --- | --- | --- |
| `JOB_SUCCESS` | 1 | Last run finished cleanly. |
| `JOB_ERROR` | 2 | Last run died on a step. |
| `JOB_PROCESSING` | 3 | Currently running (guards against a second concurrent run). |
| `JOB_SCHEDULED` | 4 | Queued to be picked up by cron. |
| `JOB_PENDING` | 5 | Never run / idle (initial seeded state). |

`last_success_executed_date` is the delta cursor for "since last successful import" (a plain datetime for most jobs; a **per-family JSON map** for the product job — see *Delta / incremental imports*). How these transitions happen (`beforeRun` → per-step loop → `afterRun`) is detailed in `running-imports.md`.

## The exact job codes (`--code=`)

The `bin/magento akeneo_connector:import --code=<job>` command accepts exactly these five codes. They are seeded, in this order, by `Setup/Patch/Data/CreateJobs.php` (`JOBS_CODES`), each mapped to its Job class and given an ascending `position`:

| `--code=` | Job class | `position` | Import class |
| --- | --- | --- | --- |
| `category` | `Akeneo\Connector\Job\Category` | 0 | `Job/Category.php` |
| `family` | `Akeneo\Connector\Job\Family` | 1 | `Job/Family.php` |
| `attribute` | `Akeneo\Connector\Job\Attribute` | 2 | `Job/Attribute.php` |
| `option` | `Akeneo\Connector\Job\Option` | 3 | `Job/Option.php` |
| `product` | `Akeneo\Connector\Job\Product` | 4 | `Job/Product.php` |

Running the command with **no** `--code` prints exactly this list under "Available codes:" — the command builds it by iterating `JobRepository::getList()` (the `akeneo_connector_job` rows) and printing each `getCode()` (`Console/Command/AkeneoConnectorImportCommand.php::usage()`).

> **There is no separate `product_model`, `family_variant`, or `website` code.** Those are *not* jobs:
> - **`product_model`** and **`family_variant`** are handled *inside* the `product` job (steps 3 and 4 below). Internally they are only temp-table suffixes (`tmp_akeneo_connector_entities_product_model`, `..._family_variant`) and a helper constant (`Helper\FamilyVariant::CODE_JOB = 'family_variant'`, `Helper/FamilyVariant.php`) — never `--code` values.
> - **Website assignment** is `product` job step 18 (`setWebsites`), not a job.
>
> So the complete set of `--code` values is: **`category`, `family`, `attribute`, `option`, `product`** — nothing else.

### Passing multiple codes

`--code` accepts a **comma-separated** list to chain jobs in one invocation (`--code=category,family,attribute,option,product`). Order in the string does **not** matter: `JobExecutor::execute()` splits on `,`, then `sortJobs()` reorders the codes by the seeded `position` ascending before running them (`Executor/JobExecutor.php`). So the connector always executes structure-before-products regardless of how you type it.

## Shared step primitives

Most Jobs are built from the same temp-table lifecycle. Recognizing these makes every step list below readable:

| Step method | What it does |
| --- | --- |
| `createTable` | Sample one record from the Akeneo API and build the job's temp table `tmp_akeneo_connector_entities_<code>` (`Helper\Import\Entities::createTmpTableFromApi`; prefix `tmp` + `akeneo_connector_entities` + suffix). |
| `insertData` | Page through the Akeneo API (applying the configured filters) and bulk-insert rows into the temp table. |
| `checkEntities` | Detect which staged codes already exist in Magento (new vs. update). |
| `matchEntities` | Map each Akeneo `code` to a Magento `entity_id` via the persistent relation table `akeneo_connector_entities` (columns `import`, `code`, `entity_id`; `etc/db_schema.xml`), reserving IDs for new entities. |
| `setValues` | Write staged column values into the Magento EAV value tables (scoped per store where applicable). |
| `setUrlRewrite` | Generate URL rewrites. |
| `dropTable` | Drop the temp table. |
| `refreshIndex` | Reindex affected Magento indexers. |
| `cleanCache` | Flush the relevant Magento cache types. |

## Import order (and why)

```
category → family → attribute → option → product
```

Structure must exist before the data that references it:

- **Family before attribute/option/product** — an Akeneo *family* becomes a Magento **attribute set**. Attributes are assigned to sets, and every product is created into its family's attribute set (`product` step 11 `updateAttributeSetId`). No family ⇒ no attribute set ⇒ failed/incomplete products.
- **Attribute before option** — options belong to a select/multiselect *attribute*; the option job maps and inserts option values against attributes that must already exist.
- **Attribute + option before product** — products carry attribute *values*, including select-option values that must already be present to resolve.
- **Category first** — categories are independent; running them first lets products be assigned to an existing tree (`product` step 19 `setCategories`).

Running `product` before its family/attributes/options exist yields missing attribute sets, unmapped option values, and partial imports. The connector's seeded `position` order encodes exactly this, and `sortJobs()` enforces it for chained runs.

---

## Category job (`--code=category`)

**Purpose:** import the Akeneo category tree into Magento categories (structure, labels/attribute values, URL keys, positions, child counts, URL rewrites).
**Prerequisites:** none — run first.

Ordered steps (`etc/di.xml`, `Job\Category`):

`createTable` → `insertData` → `checkEntities` → `matchEntities` → `setStructure` → `setUrlKey` → `removeCategoriesByFilter` → `setPosition` → `createEntities` → `setValues` → `updateChildrenCount` → `setUrlRewrite` → `dropTable` → `refreshIndex` → `cleanCache`

| # | Method | Gloss |
| --- | --- | --- |
| 1 | `createTable` | Create temporary table |
| 2 | `insertData` | Fill temporary table (paged category API pull) |
| 3 | `checkEntities` | Check already-imported entities |
| 4 | `matchEntities` | Match Akeneo code with Magento/Adobe Commerce ID |
| 5 | `setStructure` | Build the category tree structure (parent paths) |
| 6 | `setUrlKey` | Compute category URL keys |
| 7 | `removeCategoriesByFilter` | Drop categories excluded by the configured category filter |
| 8 | `setPosition` | Set sibling positions |
| 9 | `createEntities` | Create and update category entities |
| 10 | `setValues` | Set attribute values (names/labels per store) |
| 11 | `updateChildrenCount` | Recompute child-category counts |
| 12 | `setUrlRewrite` | Generate category URL rewrites |
| 13 | `dropTable` | Drop temporary table |
| 14 | `refreshIndex` | Refresh index |
| 15 | `cleanCache` | Clean cache |

## Family job (`--code=family`)

**Purpose:** import Akeneo *families* as Magento **attribute sets**, wire the family→attribute relations, and initialize each set from the default skeleton.
**Prerequisites:** none required, but run before `attribute`, `option`, and `product` (they depend on the attribute sets this creates). Uses the `Helper\Store` helper (di.xml `class` arg).

Ordered steps (`etc/di.xml`, `Job\Family`):

`createTable` → `insertData` → `checkEntities` → `matchEntities` → `insertFamilies` → `insertFamiliesAttributeRelations` → `initGroup` → `dropTable` → `refreshIndex` → `cleanCache`

| # | Method | Gloss |
| --- | --- | --- |
| 1 | `createTable` | Create temporary table |
| 2 | `insertData` | Fill temporary table (family API pull) |
| 3 | `checkEntities` | Check already-imported entities |
| 4 | `matchEntities` | Match code with Magento/Adobe Commerce ID |
| 5 | `insertFamilies` | Create or update families (= attribute sets) |
| 6 | `insertFamiliesAttributeRelations` | Create/update family↔attribute relations (`akeneo_connector_family_attribute_relations`) |
| 7 | `initGroup` | Initialize families from the default attribute-set skeleton |
| 8 | `dropTable` | Drop temporary table |
| 9 | `refreshIndex` | Refresh index |
| 10 | `cleanCache` | Clean cache |

## Attribute job (`--code=attribute`)

**Purpose:** import Akeneo attributes as Magento EAV attributes — mapping Akeneo attribute *type* to a Magento input/backend type — and assign them to the right attribute sets/families.
**Prerequisites:** `family` (attributes are assigned to families/attribute sets).

Ordered steps (`etc/di.xml`, `Job\Attribute`):

`createTable` → `insertData` → `checkEntities` → `matchEntities` → `matchType` → `matchFamily` → `addAttributes` → `dropTable` → `refreshIndex` → `cleanCache`

| # | Method | Gloss |
| --- | --- | --- |
| 1 | `createTable` | Create temporary table |
| 2 | `insertData` | Fill temporary table (attribute API pull) |
| 3 | `checkEntities` | Check already-imported entities |
| 4 | `matchEntities` | Match code with Magento/Adobe Commerce ID |
| 5 | `matchType` | Map Akeneo attribute type → Magento input/backend/frontend type |
| 6 | `matchFamily` | Resolve which families/attribute sets each attribute belongs to |
| 7 | `addAttributes` | Add or update the EAV attributes and their set assignments |
| 8 | `dropTable` | Drop temporary table |
| 9 | `refreshIndex` | Refresh index |
| 10 | `cleanCache` | Clean cache |

## Option job (`--code=option`)

**Purpose:** import the options of Akeneo simple-/multi-select attributes as Magento attribute options, plus their per-store labels (values).
**Prerequisites:** `attribute` (options belong to select attributes that must already exist).

Ordered steps (`etc/di.xml`, `Job\Option`):

`createTable` → `insertData` → `mapOptions` → `checkEntities` → `matchEntities` → `insertOptions` → `insertValues` → `dropTable` → `refreshIndex` → `cleanCache`

| # | Method | Gloss |
| --- | --- | --- |
| 1 | `createTable` | Create temporary table |
| 2 | `insertData` | Fill temporary table (option API pull) |
| 3 | `mapOptions` | Map select/multiselect options from the connector configuration |
| 4 | `checkEntities` | Check already-imported entities |
| 5 | `matchEntities` | Match code with Magento/Adobe Commerce ID |
| 6 | `insertOptions` | Insert the `eav_attribute_option` rows |
| 7 | `insertValues` | Insert the per-store option labels (values) |
| 8 | `dropTable` | Drop temporary table |
| 9 | `refreshIndex` | Refresh index |
| 10 | `cleanCache` | Clean cache |

## Product job (`--code=product`)

**Purpose:** import products — simples, configurables (from product models + family variants), and grouped products — with attribute values, media, associations, categories, stock, websites, and URL rewrites.
**Prerequisites:** `category`, `family`, `attribute`, `option` — all four. This is the heaviest job (`Job/Product.php`, ~5,000 lines).

**Runs once per family.** For the product code, `JobExecutor::execute()` first calls `getFamiliesToImport()` and then loops the whole step pipeline **once for each family** (`Executor/JobExecutor.php`; `Job/Product.php::getFamiliesToImport()`). Standard filter mode reads the configured families list (`getFamiliesFilter`); advanced/serenity modes enumerate families from the API and honor IN/NOT IN family filters. In Serenity/Growth/7.x/≥5.0 editions, mapped *grouped* families are pushed to the end of the run. Each family's success timestamp is recorded separately in the per-family `last_success_executed_date` JSON.

Ordered steps (`etc/di.xml`, `Job\Product` — note it starts at index **0**):

| # | Method | Gloss |
| --- | --- | --- |
| 0 | `resetUuid` | Reset product UUID when the PIM instance URL changed since last import |
| 1 | `createTable` | Create temporary table |
| 2 | `insertData` | Fill temporary table (paged product API pull, per family + filters) |
| 3 | `productModelImport` | Import product **models** into `tmp_..._product_model` (→ configurable parents) |
| 4 | `familyVariantImport` | Import **family variants**; compute variant `_axis` and write it onto the product-model table |
| 5 | `addRequiredData` | Add `_type_id` (`simple`, or `grouped` for grouped families), `_options_container`, `_tax_class_id`, etc. |
| 6 | `createConfigurable` | Build configurable parents from product models (adds `_children`, `_axis`) |
| 7 | `createEmptyAttributesColumns` | Ensure every expected attribute column exists on the temp table |
| 8 | `createMetricsOptions` | Create options for variant metric attributes |
| 9 | `checkEntities` | Check already-imported entities |
| 10 | `matchEntities` | Match code with Magento/Adobe Commerce ID |
| 11 | `updateAttributeSetId` | Match family code → Magento attribute-set ID |
| 12 | `updateOption` | Resolve option column values to Magento option IDs |
| 13 | `createEntities` | Create or update product entities |
| 14 | `importFiles` | Import non-image **file** attributes |
| 15 | `setValues` | Set attribute values (scoped per store view) |
| 16 | `linkConfigurable` | Link configurable parents to children; write `catalog_product_super_attribute`(+label)/`catalog_product_super_link` |
| 17 | `linkSimple` | Link simple products to their configurable parents |
| 18 | `setWebsites` | Assign products to Magento **websites** |
| 19 | `setCategories` | Assign products to categories |
| 20 | `initStock` | Initialize stock items |
| 21 | `setRelated` | Set related / up-sell / cross-sell links |
| 22 | `setGrouped` | Set grouped-product child relations |
| 23 | `setUrlRewrite` | Generate product URL rewrites |
| 24 | `importMedia` | Import **image** attributes into the product media gallery |
| 25 | `dropTable` | Drop temporary table |
| 26 | `refreshIndex` | Refresh index |
| 27 | `cleanCache` | Clean cache |

### Product models & family variants → configurable products

The connector maps Akeneo's variant model onto Magento's configurable model:

- An Akeneo **product model** becomes a Magento **configurable** parent; its variant **products** become the configurable's **simple** children.
- **`productModelImport` (step 3)** stages product models in a *separate* temp table (`Helper/ProductModel.php` → `tmp_akeneo_connector_entities_product_model`) and adds the model's columns to the product temp table.
- **`familyVariantImport` (step 4)** pulls the family's variants (`Helper/FamilyVariant.php`, temp table `tmp_..._family_variant`, up to **5** axes — `MAX_AXIS_NUMBER = 5`), builds the `_axis` value (the variant-axis attribute IDs), and writes it back onto the product-model table (`updateAxis` + `updateProductModel`).
- **`createConfigurable` (step 6)** promotes each product-model row to a configurable, grouping its simples via the `parent`/`groups` column. If no product model was imported for the family, this step is a no-op and the products stay simple.
- **`linkConfigurable` (step 16)** writes the super-attribute records (the selectable axes, `catalog_product_super_attribute` + label) and the parent→child links (`catalog_product_super_link`, `catalog_product_relation`). **`linkSimple` (step 17)** attaches simples to their parents.

**Simple vs. configurable vs. grouped:** `addRequiredData` (step 5) defaults `_type_id` to `simple`; product-models elevated by steps 6/16/17 become `configurable`; families flagged *grouped* (Serenity/Growth/7.x/≥5.0 with mapped grouped families, `isFamilyGrouped`) get `_type_id = grouped` and are wired by `setGrouped` (step 22) — for grouped families the product-model/configurable steps (3, 4, 6, 16, 17) short-circuit.

### Media / images

`importMedia` (step 24) is gated by config: it no-ops unless "media import" is enabled (`isMediaImportEnabled`) and at least one gallery image attribute is configured (`getMediaImportGalleryColumns`). When enabled it reads the configured Akeneo image attributes, downloads the binaries from the Akeneo API, and attaches them to the Magento product media gallery (per store where configured). Non-image **file** attributes are handled separately by `importFiles` (step 14). Which Akeneo attributes are treated as gallery images vs. files is set in `configuration.md`.

### Associations

- **Configurable ↔ simple:** `linkConfigurable` (16) + `linkSimple` (17).
- **Related / up-sell / cross-sell:** `setRelated` (21).
- **Grouped children:** `setGrouped` (22).

### Price & website scoping

- **Websites:** `setWebsites` (18) reads a configured "website attribute" (`getWebsiteAttribute`) whose value lists the target website codes per product; products with no/invalid website value are warned and skipped for that assignment. See `configuration.md` for the website attribute and default-website mapping.
- **Scoped values (incl. price):** `setValues` (15) writes attribute values against the store views mapped to each Akeneo channel/locale. Price is written through the same channel/store mapping; whether a price value lands at global vs. website/store scope follows Magento's catalog price scope setting plus your channel→store-view mapping (`configuration.md`). The connector itself does not set price scope — it writes values into whatever scopes the mapping resolves to.

## Delta / incremental imports

Every Job pulls from the Akeneo API through a **filter**. Full vs. incremental behavior is a matter of configuration, not separate jobs. For products the filter is assembled in `Helper/ProductFilters.php`; the category/family/attribute/option jobs have analogous filter helpers (`Helper/CategoryFilters.php`, `FamilyFilters.php`, `AttributeFilters.php`).

**Filter mode** (`Model/Source/Filters/Mode.php`):
- `standard` — the connector builds the Akeneo search from discrete settings: completeness, status (enabled), updated-date, family, and optional attribute-code filters (via `SearchBuilder`).
- `advanced` — you supply a raw Akeneo JSON search filter (`getAdvancedFilters`), to which the job still appends the current family and the updated-date filter.

**Updated-date filter — the delta cursor** (`Model/Source/Filters/Update.php`, applied by `ProductFilters::getUpdatedFilter()`):

| Mode | Constant value | Behavior |
| --- | --- | --- |
| Lower than | `<` | Only entities updated before a fixed date. |
| Greater than | `>` | Only entities updated after a fixed date. |
| Between | `BETWEEN` | Entities updated within a date range. |
| Since last X days | `SINCE LAST N DAYS` | Rolling window of the last N days. |
| Since last X hours | `SINCE LAST N HOURS` | Rolling window of the last N hours. |
| Since last successful import | `LAST_IMPORT` | **True incremental.** Uses the job's `last_success_executed_date` as a `> ` cutoff. For the **product** job this cursor is a **per-family JSON map** keyed by family code (`getLastImportDateFilter` → `Api/Data/JobInterface::DEFAULT_PRODUCT_JOB_FAMILY_CODE` fallback), so each family advances its own watermark. |

With no updated filter (empty/no condition) the job is a **full** import of everything matching the other filters.

**Other product filters:**
- **Completeness** (`Model/Source/Filters/Completeness.php`) — `no_condition`, or `<`,`<=`,`>`,`>=`,`=`,`!=`, plus the "…on all locales" variants; scoped to the admin default channel. When product status is derived from completeness, the API call also sets `with_completenesses=true`.
- **Status** — `enabled = true/false` (import only enabled/disabled products), or no condition.
- **Attribute filter by code** — restrict which attributes are pulled per product.
- **Family** — standard mode limits to the configured families list; advanced mode honors IN/NOT IN family operators. Because the product job iterates per family, families are imported independently and can carry independent "since last import" watermarks.

**Requirement:** at least one website/channel must be mapped, or `getFilters()` returns an error (`No website/channel mapped`) and the import cannot proceed. Channel/locale→store mapping and every filter setting are configured in `configuration.md`.

## Original sources

- `Job/Import.php` — abstract base Job (`getCode`/`getName`/`getStatus`/`setStatus`, `beforeImport`/`afterImport`, `setJobExecutor`).
- `Job/Category.php`, `Job/Family.php`, `Job/Attribute.php`, `Job/Option.php`, `Job/Product.php` — the five Job step-method implementations (`Product.php`: `getFamiliesToImport`, `productModelImport`, `familyVariantImport`, `createConfigurable`, `linkConfigurable`, `linkSimple`, `setWebsites`, `importMedia`, …).
- `etc/di.xml` — the ordered `steps` array (method + comment) for each `Akeneo\Connector\Job\*` type; command registration.
- `Executor/JobExecutor.php` — `initSteps` (beforeImport/afterImport wrapping), `sortJobs` (position ordering of comma-separated codes), per-family product loop, status transitions.
- `Console/Command/AkeneoConnectorImportCommand.php` — the `akeneo_connector:import --code=` option and the "Available codes" listing.
- `Setup/Patch/Data/CreateJobs.php` — `JOBS_CODES` (the five codes, classes, and positions) seeded into `akeneo_connector_job`.
- `Api/Data/JobInterface.php` — `JOB_SUCCESS/ERROR/PROCESSING/SCHEDULED/PENDING` constants and column names; `Model/Source/Status.php` — status labels.
- `etc/db_schema.xml` — `akeneo_connector_job` and `akeneo_connector_entities` (code→entity_id relation) tables.
- `Helper/Import/Entities.php` — temp-table naming (`tmp_akeneo_connector_entities_<code>`), `matchEntity`, `createTmpTableFromApi`, `insertDataFromApi`.
- `Helper/ProductModel.php`, `Helper/FamilyVariant.php` — product-model / family-variant staging (`MAX_AXIS_NUMBER = 5`, `CODE_JOB = 'family_variant'`).
- `Helper/ProductFilters.php` and `Model/Source/Filters/{Mode,Update,Completeness}.php` — filter modes and the delta/incremental cursor.
