# Module Architecture & `etc/` Wiring

A map of the **Akeneo Connector for Magento 2** module source (`akeneo/module-magento2-connector-community`, namespace `Akeneo\Connector`, embedded at **v105.1.2**). This is a normal Magento 2 module — `registration.php` registers `Akeneo_Connector`, `composer.json` PSR-4-maps `Akeneo\Connector\` to the module root, and `etc/module.xml` (`setup_version="1.0.5"`) sequences it **after `Magento_Catalog`**. What makes it *this* module is where it puts an **import pipeline**: a job = an ordered list of **steps** (declared in `di.xml`) that a **JobExecutor** runs against Akeneo's Web API, staging data into temp tables and writing it into Magento's catalog EAV.

> This doc maps *what this module puts where and why*. It does **not** re-teach the generic Magento mechanics it rides on — declarative schema (`db_schema.xml`), `di.xml` preferences/virtualTypes, events/observers, ACL/menu/routes, `system.xml` field rendering, UI components, cron internals. For any of those, **see the `magento2-development` skill**. For the Akeneo API side (auth, `{locale,scope,data}` value shape), see the `akeneo-pim-api-development` skill.

For the step-by-step semantics of each job, see jobs-and-imports.md; for how to launch/schedule them, running-imports.md; for the admin config those steps read, configuration.md; for plugin/observer/event extension detail, customizing.md.

## Directory map

Every top-level directory under the module root and its role **in this module**:

| Dir | Role in this module |
| --- | --- |
| `Job/` | **The import pipelines.** One class per entity — `Category`, `Family`, `Attribute`, `Option`, `Product` — each extending the abstract `Job\Import` base (`implements Api\Data\ImportInterface`). A job holds no `run()` loop of its own; it is a bag of public **step methods** (`createTable`, `insertData`, `matchEntities`, `setValues`, `importMedia`, `refreshIndex`, …) that the executor calls in the order `di.xml` declares. `Job/Product.php` is the giant (~207k, ~28 steps); `Job/Import.php` is the small shared base. |
| `Executor/` | **Runs jobs.** `JobExecutor` (`implements Api\JobExecutorInterface`) is the engine: it loads a job row, instantiates its `job_class`, prepends `beforeImport` / appends `afterImport`, then walks the steps, dispatching events and writing status/messages to the log tables. Entry point `execute(string $code, ?OutputInterface)`. |
| `Helper/` | **Shared config + import utilities.** `Config.php` (~2k lines) is the single accessor for every `akeneo_connector/*` system-config value. `Authenticator.php` builds the Akeneo PHP client. `Store.php`/`Locales.php` resolve store-view↔channel↔locale mapping; `ProductModel.php`, `FamilyVariant.php`, `ProductFilters.php`, and the `*Filters.php` helpers build API query filters. **`Helper/Import/`** is the low-level engine: `Entities.php` (temp tables + code→id matching), plus `Product`, `Option`, `FamilyVariant` (extend `Entities`) and `Attribute` — the actual Akeneo-value→Magento-value/EAV plumbing lives here and in the `Job/*` classes. |
| `Converter/` | **Array→JSON controller-response helper**, *not* an Akeneo-value converter. Sole class `ArrayToJsonResponseConverter` wraps a `ResultJsonFactory` to turn a PHP array into a JSON result. (It is not referenced elsewhere in the v105.1.2 tree; Akeneo→Magento value conversion actually happens in `Job/*` and `Helper/Import/*`.) |
| `Model/` | **Entities, resource models, and option sources.** `Job.php`/`JobRepository.php` + `ResourceModel/Job(/Collection,/Grid\Collection)` are the **job queue** persisted in `akeneo_connector_job`. `Log.php`/`LogRepository.php` + `ResourceModel/Log` back the import-log tables. `Model/Source/*` are the **dropdown option-source classes** for `system.xml` (`Edition`, `Engine`, `Cache`, `Status`, and `Source/Filters/*` for channel/family/locale/completeness/update-mode pickers). `Backend/Json.php` is a serialized-config backend model; `Config/Version.php` reads the installed module version; `Processor/ProcessClassFactory.php` instantiates a job's `job_class` string via the ObjectManager. |
| `Api/` | **Service + data contracts** (`@api`). Service interfaces: `JobExecutorInterface`, `JobRepositoryInterface`, `LogRepositoryInterface`, `ProcessClassFactoryInterface`. Data interfaces under `Api/Data/`: `JobInterface` (holds the job **status constants** and field-name constants), `LogInterface`, `ImportInterface`, `AttributeTypeInterface`. These are PHP contracts only — **not** REST (see the webapi note below). |
| `Observer/` | **Event hooks.** Two observers react to the connector's own step events (`…StepStart/…StepFinish`); `SendJobReportEmailNotification` fires on `akeneo_connector_import_finish`; and `Observer/Deletion/{Category,Family,Attribute,Product}Observer` clean the `akeneo_connector_entities` mapping rows when a Magento entity is deleted, so re-import re-creates instead of orphaning. |
| `Cron/` | **Scheduled launcher.** `LaunchScheduledJob` (every minute) picks up all jobs with status `SCHEDULED` (ordered by `position`) and hands their codes to the executor; `CleanLogs` (2 AM) prunes old `akeneo_connector_import_log`/`…_log_step` rows. |
| `Console/` | **CLI.** `Command/AkeneoConnectorImportCommand` = `bin/magento akeneo_connector:import --code=<job>`; with no `--code` it prints the available codes (from the job repository). Registered in `di.xml`'s `CommandList`. |
| `Controller/` | **Admin actions** (area `adminhtml`, frontName `akeneo_connector`): `Job/{Index,MassReset,MassSchedule}` (the job grid + mass actions), `Log/{Index,MassDelete,View}`, and `Test/Index` (the "Test API credentials" button — calls the Akeneo channel API and flashes success/error). |
| `Ui/`, `Block/`, `ViewModel/`, `view/`, `i18n/` | **Admin grid & config UI.** `view/adminhtml/ui_component/akeneo_job_listing.xml` + `Ui/Component/JobListing/Column/{Status,ActionsColumn}` render the Jobs grid; `Block/Adminhtml/System/Config/Form/Field/*` render the config **mapping matrices** (Website, Attribute, Configurable, Tax, Metrics, Gallery/Image/File, Grouped, SwatchType, Type, Date); `Block/Adminhtml/System/Config/{Api\Test,DocumentationLink,ExportPdf}` render the custom config buttons; `ViewModel/Jobgrid/AutoReloadConfig` + `web/js/autoReload.js` auto-refresh the running grid; `i18n/*.csv` are de/en/fr translations. |
| `Logger/` | **Per-entity logging.** A Monolog channel + file handler per job (`Attribute/Category/Family/Option/Product`), wired in `di.xml`. Writes only when advanced logging is enabled in config. |
| `Setup/` | **Install/upgrade data.** `Setup/Patch/Data/CreateJobs` **seeds the five job rows**; other patches (`EncryptApiSecret`, `UpdateConfigurableAttributes`, `TransferFamiliesAndCategoriesToNewFormatPatch`, `UpdateJobLastSuccessExecutedDateToJson`) migrate config/data. Schema itself is declarative in `etc/db_schema.xml` (no `InstallSchema`). |
| `App/` | `App/ResourceConnection` extends the framework resource connection so the module can honor its **own storage-engine / InnoDB-strict-mode** config when creating the `tmp_*` staging tables (see configuration.md → Storage Engine). |
| `Test/` | Module's own PHP tests (not part of the runtime path). |

## The `etc/` wiring table

| File | What it configures **for this module** |
| --- | --- |
| `di.xml` | **The job step pipelines** — the ordered `steps` array injected into each `Job\{Category,Family,Attribute,Option,Product}` (see the step-pipeline reference below). Also: the one `preference` (`LogRepositoryInterface → Model\LogRepository`); the `virtualType` **`Model\ResourceModel\Job\Grid\Collection`** (mainTable `akeneo_connector_job`) that feeds the admin grid's `akeneo_job_listing_data_source`; registration of the CLI command in `CommandList`; the five per-entity **Logger** channels+handlers; and the CLI command's `JobExecutor\Proxy` injection. |
| `events.xml` | **Which events are observed** (7): the connector's own `akeneo_connector_import_step_start` / `…_step_finish` and `akeneo_connector_import_finish`; plus four Magento deletion events — `catalog_category_delete_after`, `eav_entity_attribute_set_delete_after`, `catalog_entity_attribute_delete_after`, `catalog_product_delete_after` → the `Observer\Deletion\*` cleaners. (The executor *dispatches* many more events than are observed here — see Extension points.) |
| `crontab.xml` + `cron_groups.xml` | The **`akeneo_connector` cron group**. Jobs: `akeneo_connector_launch_scheduled_job` (`*/1 * * * *`) and `akeneo_connector_clean_logs` (`0 2 * * *`). The group sets `use_separate_process=1`, `schedule_ahead_for=4`, `schedule_lifetime=2`, history cleanup windows. |
| `db_schema.xml` | The module's tables (declarative). `akeneo_connector_job` (the **job queue**), `akeneo_connector_entities` (**code→Magento-id mapping**), `akeneo_connector_family_attribute_relations`, `akeneo_connector_import_log`, `akeneo_connector_import_log_step`. It also **adds a unique index** to Magento's `eav_attribute_option_value` (`option_id, store_id`) to make option-value upserts idempotent. `db_schema_whitelist.json` lists the five connector tables. |
| `webapi.xml` | **Empty** — `<routes/>` with no children. **The module exposes no REST/SOAP endpoints.** (The `Api/*Interface` classes are internal `@api` PHP contracts, not web-API routes.) |
| `acl.xml` | Two ACL branches: `Akeneo_Connector::config_akeneo_connector` (guards the config **section**) and `Akeneo_Connector::akeneo_connector` under System, with children `…_job` (Jobs grid) and `…_log` (Logs). |
| `adminhtml/system.xml` | The whole **Stores → Configuration → Catalog → Akeneo Connector** section (`section id="akeneo_connector"`). Groups: `general`, `akeneo_api`, `products_filters`, `category`, `families`, `attribute`, `filter_attribute`, `product`, `grouped_products`, `index`, `cache`, `advanced`. Field-level detail lives in configuration.md. |
| `adminhtml/menu.xml` + `adminhtml/routes.xml` | Admin nav + routing. Router `admin` route `akeneo_connector` (frontName `akeneo_connector`). Menu: **System → Akeneo Connector → Jobs** (`akeneo_connector/job`) and **Logs** (`akeneo_connector/log`). |
| `config.xml` | Module **config defaults** (`<default><akeneo_connector>…`): demo API base URL/credentials, `pagination_size=100`, default product filters (completeness `=100`, status `1`), category defaults (`is_active`/`include_in_menu`/`is_anchor`), association mapping, cache-flush targets per job, advanced/clean-logs defaults. |
| `email_templates.xml` | Registers `akeneo_connector_report_email` → `view/frontend/email/job_report_email_notification.html`, sent by `Observer\SendJobReportEmailNotification`. |
| `module.xml` | Declares `Akeneo_Connector` and its **sequence after `Magento_Catalog`**. |

## The job step pipelines (from `di.xml`)

The executor prepends **`beforeImport`** and appends **`afterImport`** around each list. Every entry is a public method on the job class; a failure is reported by **method name**, which is how the admin grid / log tells you where an import died. Order matters — this is the contract.

**Category** (`Job\Category`, 15 steps):
`createTable → insertData → checkEntities → matchEntities → setStructure → setUrlKey → removeCategoriesByFilter → setPosition → createEntities → setValues → updateChildrenCount → setUrlRewrite → dropTable → refreshIndex → cleanCache`

**Family** (`Job\Family`, 10 steps):
`createTable → insertData → checkEntities → matchEntities → insertFamilies → insertFamiliesAttributeRelations → initGroup → dropTable → refreshIndex → cleanCache`

**Attribute** (`Job\Attribute`, 10 steps):
`createTable → insertData → checkEntities → matchEntities → matchType → matchFamily → addAttributes → dropTable → refreshIndex → cleanCache`

**Option** (`Job\Option`, 10 steps):
`createTable → insertData → mapOptions → checkEntities → matchEntities → insertOptions → insertValues → dropTable → refreshIndex → cleanCache`

**Product** (`Job\Product`, 28 steps, indexed `0–27`) — the canonical full pipeline:
`resetUuid → createTable → insertData → productModelImport → familyVariantImport → addRequiredData → createConfigurable → createEmptyAttributesColumns → createMetricsOptions → checkEntities → matchEntities → updateAttributeSetId → updateOption → createEntities → importFiles → setValues → linkConfigurable → linkSimple → setWebsites → setCategories → initStock → setRelated → setGrouped → setUrlRewrite → importMedia → dropTable → refreshIndex → cleanCache`

See jobs-and-imports.md for what each step does.

## Data flow: Akeneo → temp tables → EAV

The shared shape across every job (product shown; structure jobs are the same skeleton minus the product-specific steps):

1. **Authenticate & fetch.** `Helper\Authenticator` builds an `AkeneoPimClientInterface` (`AkeneoPimClientBuilder`) from the `akeneo_api` config; the `getFamiliesToImport()` / `Helper\*Filters` translate config into API filters. Steps page through the Akeneo Web API (`pagination_size`).
2. **Stage into a temp table.** `createTable`/`insertData` (via `Helper\Import\Entities`, prefix **`tmp`**) drop each Akeneo record — with its locale/scope-expanded columns — into a per-import `tmp_*` table. `Entities::ATTRIBUTE_TYPES_LENGTH` maps each Akeneo attribute type to a MySQL column length.
3. **Match Akeneo code → Magento entity id.** `checkEntities`/`matchEntities` reconcile the temp rows against the persistent **`akeneo_connector_entities`** table (`import`, `code`, `entity_id`) — allocating new Magento ids for new codes and reusing existing ones, so imports are upserts, not duplicates.
4. **Build catalog structure** (product: `createConfigurable`, `updateAttributeSetId`, `updateOption`; category: `setStructure`/`setPosition`).
5. **Write entities & EAV values.** `createEntities` then `setValues` write `catalog_*_entity` rows and their EAV attribute values (per store-view, from the channel/locale mapping).
6. **Media & files.** `importFiles` (file attributes) and `importMedia` (image gallery) pull binaries from Akeneo into Magento media.
7. **Relations & scope.** `linkConfigurable`/`linkSimple`, `setWebsites`, `setCategories`, `initStock`, `setRelated`, `setGrouped`.
8. **URL rewrites** (`setUrlRewrite`) → **reindex** (`refreshIndex`) → **cache flush** (`cleanCache`, targets from the `cache` config group). `dropTable` removes the `tmp_*` staging table.

Throughout, the executor writes progress to `akeneo_connector_import_log` / `…_log_step` and updates the job row's status/dates. **The `product` job runs the whole pipeline once per family** (`getFamiliesToImport()`), recording a per-family last-success timestamp as JSON in `akeneo_connector_job.last_success_executed_date`.

### The job queue & status model

`akeneo_connector_job` is the durable queue. Each row = one importable job: `code`, `job_class` (the `Job\*` FQCN the executor instantiates), `position` (launch order), `status`, and `last_executed_date` / `last_success_date` / `last_success_executed_date`. `Setup\Patch\Data\CreateJobs` seeds exactly five rows in order: **`category`(0) → `family`(1) → `attribute`(2) → `option`(3) → `product`(4)**. Status ints come from `Api\Data\JobInterface`: **`SUCCESS=1`, `ERROR=2`, `PROCESSING=3`, `SCHEDULED=4`, `PENDING=5`**. The admin grid, `Console` command, and `Cron\LaunchScheduledJob` all drive the same rows through the same executor.

## Web API surface

**None.** `etc/webapi.xml` is an empty `<routes/>` document, so the connector registers **no REST or SOAP endpoints** and no GraphQL. It is a one-way **import** module that *calls* the Akeneo Web API (outbound, via `akeneo/api-php-client`) and writes into Magento's database directly. The `Akeneo\Connector\Api\*` interfaces are internal service contracts (`@api` for plugin stability), not HTTP endpoints. All human/automation entry points are the **CLI command**, the **admin grid/controllers**, and **cron** — see running-imports.md.

## Key extension points (brief — detail in customizing.md)

- **DI.** Only one `preference` ships (`LogRepositoryInterface`); `JobExecutorInterface` / `JobRepositoryInterface` / `ProcessClassFactoryInterface` are consumed as concrete classes, so override them with your own `preference`. The most surgical customization is **editing the `steps` array** of a `Job\*` `<type>` in your own `di.xml` — insert, remove, or re-point a step method without touching the job class.
- **Events.** The executor dispatches a rich set the module itself does *not* all observe, so they are yours to hook: `akeneo_connector_import_start` / `…_finish` / `…_on_success` / `…_on_error` (each also emitted with a `_<jobcode>` suffix, e.g. `…_import_finish_product`), `akeneo_connector_import_step_start` / `…_step_finish` (also `_<jobcode>`), and `akeneo_connector_import_product_family` (per family). Plus the four Magento deletion events the connector already observes.
- **Plugins.** Standard Magento interception on `JobExecutor` step methods or any `Job\*` public step is the idiomatic way to alter value conversion or add post-processing.

For how to actually write these, see customizing.md. For the generic mechanics of preferences, virtualTypes, plugins, and observers, **see the `magento2-development` skill**.

## Original sources

- `references/sources/magento2-connector-source/etc/` — `di.xml` (step pipelines, preferences, virtualType, loggers, command), `events.xml`, `crontab.xml`, `cron_groups.xml`, `db_schema.xml`, `db_schema_whitelist.json`, `webapi.xml` (empty), `acl.xml`, `config.xml`, `module.xml`, `email_templates.xml`, `adminhtml/{system.xml,menu.xml,routes.xml}`.
- `references/sources/magento2-connector-source/Executor/JobExecutor.php`, `Job/Import.php`, `Job/{Category,Family,Attribute,Option,Product}.php`.
- `references/sources/magento2-connector-source/Helper/Import/Entities.php` (temp-table + code→id engine), `Helper/Authenticator.php`, `Helper/Config.php`.
- `references/sources/magento2-connector-source/Model/Processor/ProcessClassFactory.php`, `Model/Job.php`, `Api/Data/JobInterface.php` (status constants), `Setup/Patch/Data/CreateJobs.php` (seeded jobs).
- `references/sources/magento2-connector-source/Console/Command/AkeneoConnectorImportCommand.php`, `Cron/LaunchScheduledJob.php`, `Cron/CleanLogs.php`, `Controller/Adminhtml/Test/Index.php`, `Converter/ArrayToJsonResponseConverter.php`, `composer.json`, `registration.php`.
