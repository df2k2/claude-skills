# Customizing / Extending the Connector

The connector-specific extension seams: the events it **fires** for you to observe, the DI **preferences / virtualTypes** that let you swap a Job/Helper, the **step-pipeline** you can re-order in `di.xml`, **plugins** on Job step methods and the `JobExecutor`, and the **attribute type/mapping** hooks. Everything here is grounded in the vendored source at `references/sources/magento2-connector-source/`.

> **Generic Magento mechanics live elsewhere.** How a `<preference>`, `<plugin>`, virtualType, or `ObserverInterface` works in general is the **`magento2-development`** skill's job. This doc shows *which* connector class/event to target and *when it fires* — not a plugin/observer tutorial. Put your customization in your own module (add `<sequence><module name="Akeneo_Connector"/></sequence>` to its `module.xml` so your `di.xml`/`events.xml` load after the connector's).

---

## (a) Connector events you can observe

These are the real `akeneo_connector_*` events the module **dispatches** (grepped from the source). Import-lifecycle events come from `Executor/JobExecutor.php`; attribute-mapping events come from `Helper/Import/Attribute.php`. Every lifecycle event also fires a **per-job variant** with the job code appended (`_category`, `_family`, `_attribute`, `_option`, `_product`) — e.g. `akeneo_connector_import_finish_product`.

| Event name | Fires when | Payload (`$observer->getEvent()->…`) | Source |
| --- | --- | --- | --- |
| `akeneo_connector_import_start` | Once, before a job's steps run (`beforeRun()`) | `getImport()` = **Job class** (`Job\Import`), `getExecutor()` = `JobExecutor` | `JobExecutor::beforeRun()` |
| `akeneo_connector_import_start_<code>` | Same, per job code | `getExecutor()` | `JobExecutor::beforeRun()` |
| `akeneo_connector_import_step_start` | Before **each step** method runs | `getImport()` = **`JobExecutor`** ⚠ (not the Job class) | `JobExecutor::executeStep()` |
| `akeneo_connector_import_step_start_<code>` | Same, per job code | `getImport()` = `JobExecutor` | `JobExecutor::executeStep()` |
| `akeneo_connector_import_step_finish` | After **each step** method runs | `getImport()` = `JobExecutor` | `JobExecutor::executeStep()` |
| `akeneo_connector_import_step_finish_<code>` | Same, per job code | `getImport()` = `JobExecutor` | `JobExecutor::executeStep()` |
| `akeneo_connector_import_product_family` | Once **per family**, before the product job runs for that family | `getExecutor()` = `JobExecutor`, `getFamily()` = family code string | `JobExecutor::execute()` (product only) |
| `akeneo_connector_import_on_error` | When a job ends in error | `getExecutor()`, `getError()` = message | `JobExecutor::afterRun()` |
| `akeneo_connector_import_on_error_<code>` | Same, per job code | `getExecutor()`, `getError()` | `JobExecutor::afterRun()` |
| `akeneo_connector_import_on_success` | When a job completes with no error | `getExecutor()` | `JobExecutor::afterRun()` |
| `akeneo_connector_import_on_success_<code>` | Same, per job code | `getExecutor()` | `JobExecutor::afterRun()` |
| `akeneo_connector_import_finish` | Once, after a job's steps finish (success **or** error) | `getImport()` = Job class, `getExecutor()` | `JobExecutor::afterRun()` |
| `akeneo_connector_import_finish_<code>` | Same, per job code | `getExecutor()` | `JobExecutor::afterRun()` |
| `akeneo_connector_attribute_get_configuration_add_before` | Building the PIM-type → Magento attribute-definition map | `getResponse()` = `DataObject`; mutate `getTypes()`/`setTypes()` | `Helper\Import\Attribute::getConfiguration()` |
| `akeneo_connector_attribute_get_available_types_add_after` | Building the list of selectable Magento attribute types | `getResponse()`; mutate `getTypes()` | `Helper\Import\Attribute::getAvailableTypes()` |
| `akeneo_connector_attribute_get_available_swatch_types_add_after` | Building the swatch-type list | `getResponse()`; mutate `getSwatchTypes()` | `Helper\Import\Attribute::getAvailableSwatchTypes()` |
| `akeneo_connector_attribute_get_specific_columns_add_after` | Building the temp-table columns per attribute type | `getResponse()`; mutate `getColumns()` | `Helper\Import\Attribute::getSpecificColumns()` |

**⚠ Payload gotcha (grounded in the source):** in `import_start` / `import_finish` the `import` key is the **Job class** and the executor is under `executor`; in `import_step_start` / `import_step_finish` the `import` key is the **`JobExecutor`** itself (see `Observer/AkeneoConnectorImportStepStartObserver.php`, which does `$executor = $observer->getEvent()->getImport()`). Read the right key for the event you bind.

There are also two **model CRUD event prefixes** (standard Magento model events, from `_eventPrefix`): `akeneo_connector_job_*` (`Model/Job.php`) and `akeneo_connector_import_log_*` (`Model/Log.php`) — e.g. `akeneo_connector_job_save_after`.

**Example — run something after every successful product import** (`etc/events.xml` in your module):

```xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd">
    <event name="akeneo_connector_import_finish_product">
        <observer name="vendor_post_product_import"
                  instance="Vendor\Module\Observer\AfterProductImport"/>
    </event>
</config>
```

```php
namespace Vendor\Module\Observer;

use Akeneo\Connector\Executor\JobExecutor;
use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;

class AfterProductImport implements ObserverInterface
{
    public function execute(Observer $observer)
    {
        /** @var JobExecutor $executor */
        $executor = $observer->getEvent()->getExecutor();
        $status   = $executor->getCurrentJob()->getStatus();   // JobInterface::JOB_SUCCESS = 1
        $family   = $executor->getCurrentJobClass()->getFamily();
        // e.g. push a downstream index / warm a cache / notify a channel
        return $this;
    }
}
```

The connector already ships observers of this kind — see `Observer/SendJobReportEmailNotification.php` (bound to `akeneo_connector_import_finish`, sends the job-report email) as a working template.

---

## (b) DI preferences / virtualTypes to swap a Job or Helper

Job classes are instantiated **through the ObjectManager** (`Model/Processor/ProcessClassFactory::create()` → `objectManager->create($job->getJobClass())`), so a plain `<preference>` is honored and your subclass is used everywhere. Same for the config/import Helpers.

**Example — replace the Product job or the Config helper** (`etc/di.xml`):

```xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <preference for="Akeneo\Connector\Job\Product"    type="Vendor\Module\Job\Product"/>
    <preference for="Akeneo\Connector\Helper\Config"  type="Vendor\Module\Helper\Config"/>
</config>
```

```php
namespace Vendor\Module\Job;

class Product extends \Akeneo\Connector\Job\Product
{
    public function setValues(): void
    {
        parent::setValues();
        // extra column massaging on the tmp table after standard value-setting
    }
}
```

Swappable targets that matter: the Job classes (`Akeneo\Connector\Job\{Category,Family,Attribute,Option,Product}`, base `Job\Import`), the import Helpers (`Helper\Import\{Entities,Product,Attribute,Option,FamilyVariant}`), the filter Helpers (`Helper\{ProductFilters,CategoryFilters,FamilyFilters,AttributeFilters}`), `Helper\Store`, `Helper\Authenticator`, and the `Executor\JobExecutor`. The one existing `<preference>` in the module (`Api\LogRepositoryInterface` → `Model\LogRepository`, in `etc/di.xml`) is your syntax reference. See `architecture.md` for what each class owns before you override it — prefer a **plugin** (below) over a full preference when you only touch one method.

### Altering the step pipeline (the biggest structural seam)

Each job's ordered steps are **plain `di.xml` data**, not code — the `<type name="Akeneo\Connector\Job\Product"><argument name="data"><item name="steps">` array (see `etc/di.xml`; `JobExecutor::initSteps()` wraps it with `beforeImport`/`afterImport`). Redeclare that `<type>` in your module's `di.xml` to **remove, re-order, or insert** a step. Each `<item>` is `{method, comment}`, and `method` must be a **public method on the Job class** — so *adding* a step means pairing this edit with a preference/subclass (b) that defines that public method.

```xml
<type name="Akeneo\Connector\Job\Product">
    <arguments>
        <argument name="data" xsi:type="array">
            <argument name="steps" xsi:type="array">
                <!-- redeclare only the numbered items you want to change/add;
                     e.g. add a custom step after setValues (15) -->
                <item name="28" xsi:type="array">
                    <item name="method" xsi:type="string">applyVendorRules</item>
                    <item name="comment" xsi:type="string">Apply vendor post-processing</item>
                </item>
            </argument>
        </argument>
    </arguments>
</type>
```

The full per-job step lists are in `jobs-and-imports.md` and `architecture.md`.

---

## (c) "Converter" for custom attribute value transformation — the reality

There is **no attribute-value `Converter` seam** in this module. The only class under `Converter/` is `ArrayToJsonResponseConverter` — a controller/Web-API helper that wraps an array in a JSON result (`convert(array $data): ResultJson`); it has nothing to do with catalog values. Do **not** invent a converter here.

Attribute **value transformation** actually happens inside the Product job's value-setting steps and their helpers. Hook it one of these grounded ways:

| Want to change… | Seam |
| --- | --- |
| How a raw PIM value lands in a Magento attribute | **Plugin** `after`/`around` on `Job\Product::setValues()`, `::updateOption()`, `::createEntities()` (see (d)) |
| Which Magento attribute a PIM code writes to | Admin **attribute mapping** (`akeneo_connector/product/attribute_mapping`) — no code; see `configuration.md` |
| The Magento *type/definition* a PIM attribute type maps to | The **attribute events** in (e) |
| Media/file value handling | Plugin on `Job\Product::importMedia()` / `::importFiles()`, or the media config in `configuration.md` |

**Example — normalize a value after the standard pass** (an `after` plugin, not a converter):

```xml
<type name="Akeneo\Connector\Job\Product">
    <plugin name="vendor_normalize_values" type="Vendor\Module\Plugin\NormalizeValues"/>
</type>
```

```php
namespace Vendor\Module\Plugin;

use Akeneo\Connector\Job\Product;

class NormalizeValues
{
    public function afterSetValues(Product $subject, $result)
    {
        // $subject->getFamily(), the tmp table, and helpers are available here;
        // run an UPDATE on the tmp product table to reshape a column, etc.
        return $result;
    }
}
```

---

## (d) Plugins around Job step methods or the JobExecutor

The step methods on the Job classes are **public** (`insertData`, `addRequiredData`, `createConfigurable`, `updateOption`, `createEntities`, `importFiles`, `setValues`, `importMedia`, …) and the Job is built via the ObjectManager, so `before`/`after`/`around` **plugins fire on them** — the surgical alternative to a full preference. This is the recommended way to inject behavior into one step without owning the whole (multi-thousand-line) `Job\Product`.

```xml
<!-- around a specific step of a specific job -->
<type name="Akeneo\Connector\Job\Product">
    <plugin name="vendor_wrap_import_media" type="Vendor\Module\Plugin\WrapImportMedia"/>
</type>

<!-- or wrap the executor itself: runs for EVERY job -->
<type name="Akeneo\Connector\Executor\JobExecutor">
    <plugin name="vendor_after_execute" type="Vendor\Module\Plugin\AfterExecute"/>
</type>
```

```php
namespace Vendor\Module\Plugin;

use Akeneo\Connector\Executor\JobExecutor;

class AfterExecute
{
    // JobExecutor::execute(string $code, ?OutputInterface $output = null): bool
    public function afterExecute(JobExecutor $subject, bool $result, string $code)
    {
        // one place to hook the end of ANY import (cli / grid / cron)
        return $result;
    }
}
```

Useful `JobExecutor` methods to target: `execute()` (whole run), `executeStep()` (each step), `beforeRun()` / `afterRun()` (per-run bookends), `setJobStatus()`. Note the command injects the executor as `JobExecutor\Proxy` (`etc/di.xml`) — plugins still apply to the underlying class. For step-level work you can also plugin the concrete Job class methods listed above; get the current step/method via `$executor->getStep()` / `getMethod()`.

---

## (e) Custom attribute / mapping handling

Two layers, both real:

1. **No-code, per-attribute mapping** — admin config maps an Akeneo attribute code to a Magento attribute code and drives type handling: `akeneo_connector/product/attribute_mapping`, `…/product/product_mapping_attribute`, `…/product/configurable_attributes`, `…/attribute/types`, `…/attribute/types_swatch`. Covered in `configuration.md`.

2. **Code, via the attribute events** — to teach the connector a **new attribute type** or change how a PIM type maps to a Magento definition, observe the events from (a). `getAvailableTypes` controls the selectable Magento types; `getConfiguration` controls the concrete `backend_type` / `frontend_input` / `backend_model` / `source_model` a PIM input type resolves to; `getSpecificColumns` controls the tmp-table columns.

**Example — register a custom Magento attribute type and its column mapping:**

```xml
<event name="akeneo_connector_attribute_get_available_types_add_after">
    <observer name="vendor_add_attr_type" instance="Vendor\Module\Observer\AddAttributeType"/>
</event>
<event name="akeneo_connector_attribute_get_configuration_add_before">
    <observer name="vendor_map_attr_type" instance="Vendor\Module\Observer\MapAttributeType"/>
</event>
```

```php
namespace Vendor\Module\Observer;

use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;

class AddAttributeType implements ObserverInterface
{
    public function execute(Observer $observer)
    {
        $response = $observer->getEvent()->getResponse();   // DataObject
        $types = $response->getTypes();
        $types['color_picker'] = 'color_picker';            // add a selectable Magento type
        $response->setTypes($types);
        return $this;
    }
}

class MapAttributeType implements ObserverInterface
{
    public function execute(Observer $observer)
    {
        $response = $observer->getEvent()->getResponse();
        $types = $response->getTypes();
        $types['pim_catalog_my_type'] = [                   // PIM input type -> Magento definition
            'backend_type'   => 'varchar',
            'frontend_input' => 'text',
            'backend_model'  => null,
            'source_model'   => null,
            'frontend_model' => null,
        ];
        $response->setTypes($types);
        return $this;
    }
}
```

The default type table these events mutate is `Helper\Import\Attribute::getConfiguration()`/`getAvailableTypes()` — read it to see the exact array shape before you extend it. The Attribute job's `matchType` step (see `jobs-and-imports.md`) is what consumes the result.

---

## Core Magento events the connector already observes

For reference (from `etc/events.xml`) — you rarely need to touch these, but they show the module's own hook points. The **deletion** observers keep the `akeneo_connector_entities` mapping table in sync when a Magento entity is deleted:

| Magento event | Observer | Purpose |
| --- | --- | --- |
| `catalog_category_delete_after` | `Observer\Deletion\CategoryObserver` | Drop category from mapping |
| `eav_entity_attribute_set_delete_after` | `Observer\Deletion\FamilyObserver` | Drop family (attribute set) from mapping |
| `catalog_entity_attribute_delete_after` | `Observer\Deletion\AttributeObserver` | Drop attribute from mapping |
| `catalog_product_delete_after` | `Observer\Deletion\ProductObserver` | Drop product from mapping |
| `akeneo_connector_import_step_start` | `Observer\AkeneoConnectorImportStepStartObserver` | Write the step-start log row |
| `akeneo_connector_import_step_finish` | `Observer\AkeneoConnectorImportStepFinishObserver` | Write the step-finish log row |
| `akeneo_connector_import_finish` | `Observer\SendJobReportEmailNotification` | Send the job-report email |

---

## Original sources

- `references/sources/magento2-connector-source/Executor/JobExecutor.php` — all `akeneo_connector_import_*` dispatches; `execute()`/`run()`/`executeStep()`/`beforeRun()`/`afterRun()`.
- `references/sources/magento2-connector-source/Helper/Import/Attribute.php` — the four `akeneo_connector_attribute_*` dispatches + default type tables.
- `references/sources/magento2-connector-source/etc/events.xml` — observed core + connector events.
- `references/sources/magento2-connector-source/etc/di.xml` — the `<preference>`, virtualType, and per-job `steps` arrays.
- `references/sources/magento2-connector-source/Converter/ArrayToJsonResponseConverter.php` — the only `Converter/` (JSON response, not value transform).
- `references/sources/magento2-connector-source/Model/Processor/ProcessClassFactory.php` — jobs built via ObjectManager (why preferences/plugins apply).
- `references/sources/magento2-connector-source/Observer/` — working observer templates (`SendJobReportEmailNotification`, `AkeneoConnectorImportStepStartObserver`, `Deletion/*`).
- `references/sources/magento2-connector-source/Helper/Config.php` — mapping/attribute config paths.
- Sibling refs: `architecture.md`, `jobs-and-imports.md`, `configuration.md`, `running-imports.md`.
- Generic plugin/observer/preference mechanics: the **`magento2-development`** skill.
</content>
</invoke>
