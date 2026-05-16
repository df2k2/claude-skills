# EAV, Models, Repositories, and Service Contracts

Magento has two persistence patterns:

1. **Flat tables** — one row per entity. Most modules. Use `AbstractModel` + `ResourceModel` + `Collection` + a Repository.
2. **EAV (Entity-Attribute-Value)** — one row per *attribute value*. Used by Customer, Category, Product, and a few core entities where each entity has many user-configurable attributes. Use `AbstractEavModel` + EAV-aware ResourceModel + `Collection` + a Repository.

Service Contracts (`Api/` namespace interfaces + repositories) sit on top of both and are the **public-facing API**.

## The full layered architecture

```
┌────────────────────────────────────────────────────────────────┐
│  Controllers / Plugins / Observers / GraphQL / REST callers     │
│  ──── use only this layer ────                                  │
├────────────────────────────────────────────────────────────────┤
│  Api/   ProductRepositoryInterface                              │
│         ProductInterface (Data interface)                       │
│         SearchCriteriaBuilder                                   │
├────────────────────────────────────────────────────────────────┤
│  Model/ ProductRepository                                       │
│         Product (extends AbstractModel/AbstractEavModel)        │
├────────────────────────────────────────────────────────────────┤
│  Model/ResourceModel/ Product (extends AbstractDb)              │
│                       Product\Collection (extends AbstractCollection)│
├────────────────────────────────────────────────────────────────┤
│  Database tables                                                │
└────────────────────────────────────────────────────────────────┘
```

The golden rule: **inject `Api/` interfaces in business code**. Models, ResourceModels, and Collections are implementation details.

## Flat-table entity (the common case)

### 1. Define the table in `db_schema.xml`
(See `database-schema.md`.) Example: `acme_giftwrap_message` with `entity_id`, `order_id`, `message`, etc.

### 2. Data interface — `Api/Data/MessageInterface.php`
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Api\Data;

interface MessageInterface
{
    public const ENTITY_ID = 'entity_id';
    public const ORDER_ID = 'order_id';
    public const MESSAGE = 'message';
    public const IS_ACTIVE = 'is_active';

    public function getEntityId(): ?int;
    public function setEntityId(int $id): self;

    public function getOrderId(): int;
    public function setOrderId(int $orderId): self;

    public function getMessage(): ?string;
    public function setMessage(?string $message): self;

    public function getIsActive(): bool;
    public function setIsActive(bool $isActive): self;
}
```

`Api/Data/` interfaces represent the **shape** of the data exposed to the API layer. Magento auto-generates `MessageExtensionInterface` and `MessageSearchResultsInterface` from this (and from `extension_attributes.xml`).

### 3. Repository interface — `Api/MessageRepositoryInterface.php`
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Api;

use Magento\Framework\Api\SearchCriteriaInterface;
use Magento\Framework\Exception\NoSuchEntityException;
use Acme\GiftWrap\Api\Data\MessageInterface;
use Acme\GiftWrap\Api\Data\MessageSearchResultsInterface;

interface MessageRepositoryInterface
{
    /**
     * @throws \Magento\Framework\Exception\CouldNotSaveException
     */
    public function save(MessageInterface $message): MessageInterface;

    /**
     * @throws NoSuchEntityException
     */
    public function getById(int $id): MessageInterface;

    public function getList(SearchCriteriaInterface $searchCriteria): MessageSearchResultsInterface;

    /**
     * @throws \Magento\Framework\Exception\CouldNotDeleteException
     */
    public function delete(MessageInterface $message): bool;

    public function deleteById(int $id): bool;
}
```

This is the public contract. Auto-exposed via REST if listed in `webapi.xml`.

### 4. Model — `Model/Message.php`
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Model;

use Magento\Framework\Model\AbstractModel;
use Acme\GiftWrap\Api\Data\MessageInterface;

class Message extends AbstractModel implements MessageInterface
{
    protected function _construct(): void
    {
        $this->_init(\Acme\GiftWrap\Model\ResourceModel\Message::class);
    }

    public function getEntityId(): ?int
    {
        $id = $this->getData(self::ENTITY_ID);
        return $id !== null ? (int) $id : null;
    }
    public function setEntityId(int $id): self { return $this->setData(self::ENTITY_ID, $id); }

    public function getOrderId(): int { return (int) $this->getData(self::ORDER_ID); }
    public function setOrderId(int $orderId): self { return $this->setData(self::ORDER_ID, $orderId); }

    public function getMessage(): ?string { return $this->getData(self::MESSAGE); }
    public function setMessage(?string $message): self { return $this->setData(self::MESSAGE, $message); }

    public function getIsActive(): bool { return (bool) $this->getData(self::IS_ACTIVE); }
    public function setIsActive(bool $isActive): self { return $this->setData(self::IS_ACTIVE, $isActive); }
}
```

`AbstractModel` provides `getData($key)`, `setData($key, $value)`, magic `getFoo()`/`setFoo()`, and convenience: `getId()`, `setId()`, internal `_eventPrefix` for dispatching `<prefix>_save_before` etc.

To enable per-model events:
```php
protected $_eventPrefix = 'acme_giftwrap_message';
protected $_eventObject = 'message';   // becomes $observer->getEvent()->getMessage()
```

Then events `acme_giftwrap_message_save_before`, `_save_after`, `_save_commit_after`, `_load_after`, `_delete_before`, `_delete_after` fire automatically.

### 5. ResourceModel — `Model/ResourceModel/Message.php`
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Model\ResourceModel;

use Magento\Framework\Model\ResourceModel\Db\AbstractDb;

class Message extends AbstractDb
{
    protected function _construct(): void
    {
        $this->_init('acme_giftwrap_message', 'entity_id');
    }
}
```

`_init($table, $idField)` is everything for a flat-table model.

### 6. Collection — `Model/ResourceModel/Message/Collection.php`
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Model\ResourceModel\Message;

use Magento\Framework\Model\ResourceModel\Db\Collection\AbstractCollection;

class Collection extends AbstractCollection
{
    protected $_idFieldName = 'entity_id';

    protected function _construct(): void
    {
        $this->_init(
            \Acme\GiftWrap\Model\Message::class,
            \Acme\GiftWrap\Model\ResourceModel\Message::class
        );
    }
}
```

Inject the **CollectionFactory** to use it (`\Acme\GiftWrap\Model\ResourceModel\Message\CollectionFactory`, auto-generated).

### 7. Repository implementation — `Model/MessageRepository.php`
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Model;

use Acme\GiftWrap\Api\Data\MessageInterface;
use Acme\GiftWrap\Api\Data\MessageSearchResultsInterface;
use Acme\GiftWrap\Api\Data\MessageSearchResultsInterfaceFactory;
use Acme\GiftWrap\Api\MessageRepositoryInterface;
use Acme\GiftWrap\Model\ResourceModel\Message as MessageResource;
use Acme\GiftWrap\Model\ResourceModel\Message\CollectionFactory;
use Magento\Framework\Api\SearchCriteria\CollectionProcessorInterface;
use Magento\Framework\Api\SearchCriteriaInterface;
use Magento\Framework\Exception\CouldNotDeleteException;
use Magento\Framework\Exception\CouldNotSaveException;
use Magento\Framework\Exception\NoSuchEntityException;

class MessageRepository implements MessageRepositoryInterface
{
    public function __construct(
        private readonly MessageResource $resource,
        private readonly MessageFactory $messageFactory,
        private readonly CollectionFactory $collectionFactory,
        private readonly MessageSearchResultsInterfaceFactory $searchResultsFactory,
        private readonly CollectionProcessorInterface $collectionProcessor
    ) {}

    public function save(MessageInterface $message): MessageInterface
    {
        try {
            $this->resource->save($message);
        } catch (\Throwable $e) {
            throw new CouldNotSaveException(__('Could not save message: %1', $e->getMessage()), $e);
        }
        return $message;
    }

    public function getById(int $id): MessageInterface
    {
        $message = $this->messageFactory->create();
        $this->resource->load($message, $id);
        if (!$message->getEntityId()) {
            throw new NoSuchEntityException(__('Message %1 does not exist.', $id));
        }
        return $message;
    }

    public function getList(SearchCriteriaInterface $searchCriteria): MessageSearchResultsInterface
    {
        $collection = $this->collectionFactory->create();
        $this->collectionProcessor->process($searchCriteria, $collection);
        $results = $this->searchResultsFactory->create();
        $results->setItems($collection->getItems());
        $results->setSearchCriteria($searchCriteria);
        $results->setTotalCount($collection->getSize());
        return $results;
    }

    public function delete(MessageInterface $message): bool
    {
        try {
            $this->resource->delete($message);
        } catch (\Throwable $e) {
            throw new CouldNotDeleteException(__('Could not delete: %1', $e->getMessage()), $e);
        }
        return true;
    }

    public function deleteById(int $id): bool
    {
        return $this->delete($this->getById($id));
    }
}
```

### 8. Bind interface → class in `di.xml`
```xml
<config>
    <preference for="Acme\GiftWrap\Api\Data\MessageInterface"
                type="Acme\GiftWrap\Model\Message"/>
    <preference for="Acme\GiftWrap\Api\MessageRepositoryInterface"
                type="Acme\GiftWrap\Model\MessageRepository"/>
</config>
```

Magento auto-generates `MessageSearchResultsInterface` / `MessageSearchResultsInterfaceFactory` from your `MessageInterface` during `setup:di:compile`.

### 9. Use it from anywhere
```php
public function __construct(
    private readonly \Acme\GiftWrap\Api\MessageRepositoryInterface $messageRepository,
    private readonly \Magento\Framework\Api\SearchCriteriaBuilder $searchCriteriaBuilder
) {}

public function getRecent(): array
{
    $criteria = $this->searchCriteriaBuilder
        ->addFilter('is_active', 1)
        ->setPageSize(50)
        ->setSortOrders([
            $this->sortOrderBuilder
                ->setField('created_at')
                ->setDirection('DESC')
                ->create()
        ])
        ->create();

    return $this->messageRepository->getList($criteria)->getItems();
}
```

## SearchCriteria — the standardized filter/sort/paging API

`\Magento\Framework\Api\SearchCriteriaBuilder` is the way callers express "find me entities where X". Methods:

- `addFilter($field, $value, $conditionType = 'eq')` — adds a single filter (AND with others by default).
- `addFilters([$filter1, $filter2])` — adds a filter group (OR within the group). Build filters with `\Magento\Framework\Api\FilterBuilder`.
- `setPageSize(int)` / `setCurrentPage(int)`.
- `setSortOrders(SortOrder[])`.
- `create()` — returns a `SearchCriteriaInterface`.

Condition types: `eq`, `neq`, `gt`, `gteq`, `lt`, `lteq`, `like`, `nlike`, `in`, `nin`, `notnull`, `null`, `moreq`, `from`, `to`.

`CollectionProcessorInterface::process($criteria, $collection)` translates a SearchCriteria into collection filters/limits/sorts. The default processor uses `Magento\Framework\Api\SearchCriteria\CollectionProcessor\FilterProcessor`, `SortingProcessor`, `PaginationProcessor`.

To add a custom mapping (e.g., a virtual field `is_recent`), inject a custom CollectionProcessor:
```xml
<virtualType name="Acme\GiftWrap\Model\Api\SearchCriteria\MessageCollectionProcessor"
             type="Magento\Framework\Api\SearchCriteria\CollectionProcessor">
    <arguments>
        <argument name="processors" xsi:type="array">
            <item name="filters" xsi:type="object">Acme\GiftWrap\Model\Api\SearchCriteria\MessageCollectionFilterProcessor</item>
            <item name="sorting" xsi:type="object">Magento\Framework\Api\SearchCriteria\CollectionProcessor\SortingProcessor</item>
            <item name="pagination" xsi:type="object">Magento\Framework\Api\SearchCriteria\CollectionProcessor\PaginationProcessor</item>
        </argument>
    </arguments>
</virtualType>

<type name="Acme\GiftWrap\Model\MessageRepository">
    <arguments>
        <argument name="collectionProcessor" xsi:type="object">
            Acme\GiftWrap\Model\Api\SearchCriteria\MessageCollectionProcessor
        </argument>
    </arguments>
</type>
```

## EAV entities (Customer, Category, Product, …)

EAV stores attribute values in separate tables by data type:
- `<entity>_entity` — entity rows (one per product).
- `<entity>_entity_int`, `_varchar`, `_text`, `_decimal`, `_datetime` — value tables. One row per (entity, attribute, store, value).
- `eav_attribute` — attribute definitions (used by all EAV entities).
- `eav_entity_type` — entity type registry.
- `catalog_product_entity_*` (since 2.0+) — Catalog uses its own EAV tables, but the pattern is identical.

### Adding a custom attribute (Customer example)

Via a data patch (`Setup/Patch/Data/AddLoyaltyPointsAttribute.php`):
```php
namespace Acme\Loyalty\Setup\Patch\Data;

use Magento\Customer\Model\Customer;
use Magento\Customer\Setup\CustomerSetupFactory;
use Magento\Eav\Model\Entity\Attribute\SetFactory;
use Magento\Framework\Setup\ModuleDataSetupInterface;
use Magento\Framework\Setup\Patch\DataPatchInterface;

class AddLoyaltyPointsAttribute implements DataPatchInterface
{
    public function __construct(
        private readonly ModuleDataSetupInterface $moduleDataSetup,
        private readonly CustomerSetupFactory $customerSetupFactory,
        private readonly SetFactory $attributeSetFactory
    ) {}

    public static function getDependencies(): array { return []; }
    public function getAliases(): array { return []; }

    public function apply(): self
    {
        $this->moduleDataSetup->startSetup();
        $customerSetup = $this->customerSetupFactory->create(['setup' => $this->moduleDataSetup]);
        $customerSetup->addAttribute(
            Customer::ENTITY,
            'loyalty_points',
            [
                'type' => 'int',
                'label' => 'Loyalty Points',
                'input' => 'text',
                'required' => false,
                'sort_order' => 100,
                'visible' => true,
                'user_defined' => true,
                'position' => 100,
                'system' => false,
            ]
        );

        $attribute = $customerSetup
            ->getEavConfig()
            ->getAttribute(Customer::ENTITY, 'loyalty_points');

        // Expose on customer forms
        $attribute->setData('used_in_forms', ['adminhtml_customer']);
        $attribute->save();

        $this->moduleDataSetup->endSetup();
        return $this;
    }
}
```

`used_in_forms` matters — without it the attribute exists in DB but won't appear in any form. Common values: `adminhtml_customer`, `adminhtml_checkout`, `customer_account_create`, `customer_account_edit`.

### Reading EAV attributes
```php
public function __construct(
    private readonly \Magento\Customer\Api\CustomerRepositoryInterface $customerRepository
) {}

$customer = $this->customerRepository->getById($customerId);
$points = $customer->getCustomAttribute('loyalty_points')?->getValue();
```

`getCustomAttribute('code')` returns the AttributeValue or null. Standard fields (`firstname`, `lastname`, `email`) have dedicated getters.

### Catalog attributes — use the Product UI
For product attributes, do it via admin: **Stores → Attributes → Product**. Or via data patch using `\Magento\Catalog\Setup\CategorySetupFactory` / `EavSetupFactory`. Setting `is_global`, `is_required`, `frontend_input`, `source_model` etc. The patterns are the same as Customer.

### Common EAV attribute config keys
- `type` — `int`, `varchar`, `text`, `decimal`, `datetime`, `static` (column on the main entity table instead of EAV value table).
- `input` — `text`, `textarea`, `multiline`, `date`, `select`, `multiselect`, `boolean`, `image`, `file`, `gallery`.
- `frontend_input` — same as `input`.
- `backend_type` — same as `type` (one of these two will be required).
- `source` / `source_model` — for `select`/`multiselect`, FQCN of a class implementing `\Magento\Eav\Model\Entity\Attribute\Source\SourceInterface`.
- `backend` / `backend_model` — custom save/load logic (rare).
- `frontend` / `frontend_model` — custom display logic.
- `is_global` — `0` Store View, `1` Global, `2` Website (catalog only).
- `is_required`, `is_unique`, `is_searchable`, `is_filterable`, `is_visible_on_front`, `used_in_product_listing`, `is_html_allowed_on_front`.
- `default_value`.
- `visible`, `user_defined`, `system`.

## Extension attributes — non-EAV way to extend any Api entity

For ANY `Api/Data/*Interface`, you can add fields via `extension_attributes.xml` without touching the interface or the underlying entity's schema. Useful for adding fields exposed in REST/GraphQL responses.

```xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Api/etc/extension_attributes.xsd">
    <extension_attributes for="Magento\Catalog\Api\Data\ProductInterface">
        <attribute code="wholesale_price" type="float"/>
        <attribute code="badges" type="string[]"/>
    </extension_attributes>
</config>
```

Magento generates `ProductExtensionInterface` with `getWholesalePrice() / setWholesalePrice()`. To populate it:

```php
// After loading a product
$ext = $product->getExtensionAttributes() ?? $this->extensionFactory->create();
$ext->setWholesalePrice(123.45);
$product->setExtensionAttributes($ext);
```

You typically wire this up via:
- A plugin on `ProductRepository::get`/`getList` that populates the extension attribute after load.
- A plugin on `ProductRepository::save` that reads the extension attribute and persists it (to whatever table you use).

Extension attributes are **the right way** to add fields to Magento's existing entity APIs.

## Common gotchas

### `Product::load($id)` deprecation
Inject `Magento\Catalog\Api\ProductRepositoryInterface` and call `getById($id)`. Same for Category, Customer, Order. `load()` still works but bypasses several plugins and is officially discouraged since 2.2.

### Collections are MUTABLE — don't reuse
`$collection = $this->collectionFactory->create(); $collection->addFieldToFilter(...);` — the next caller of `collectionFactory->create()` gets a FRESH instance. But `$this->collection` stored on a service is shared across calls within the same request. Create a new collection per query.

### `addFieldToFilter` vs `addAttributeToFilter`
- `addFieldToFilter` works on flat tables (your custom modules).
- `addAttributeToFilter` works on EAV (Customer, Product, Category) — joins the value table automatically.

Don't mix them up — calling `addAttributeToFilter` on a flat collection silently does the wrong thing.

### `addAttributeToSelect('*')` is expensive
Joins every EAV value table. For a product collection with 200 attributes, that's a costly query. Select only the attributes you need: `addAttributeToSelect(['name', 'price'])`.

### Forgetting `getSize()` paging gotcha
`$collection->getSize()` runs the count query WITHOUT the limit applied. `$collection->count()` runs the full query and counts the rows. For paging, use `getSize()`.

### `n+1` queries from getting a single attribute in a loop
```php
foreach ($collection as $product) {
    $product->getAttributeFirstName();   // each call lazy-loads from a JOIN
}
```
Always pre-load the attributes you'll touch via `addAttributeToSelect`.

### Repository `save` doesn't dispatch the legacy `*_save_after` event
The repository internally calls the resource's `save`, which dispatches model events on the model. But if you bypass the repository (`$model->save()` directly), you miss the events around `model_save_*`. Always go through the repository.

### Custom collection processor not applied
You declared a virtual type and configured it — but Magento isn't using it. Did you set the `<argument name="collectionProcessor">` on the REPOSITORY, not just declare the virtual type? Did you `cache:clean config` and `setup:di:compile`?

### Extension attributes don't appear in REST
- `extension_attributes.xml` not in the right module sequence.
- Cache `config_webservice` not cleared.
- The data isn't being populated — extension attributes are populated by plugins/observers, not magically.

## Original sources

- `references/sources/commerce-php/development/components/service-contracts/` — service contracts.
- `references/sources/commerce-php/development/components/searching-with-repositories.md` — repository + SearchCriteria.
- `references/sources/commerce-php/development/components/attributes.md` — attribute system overview.
- `references/sources/commerce-php/development/components/add-attributes.md` — adding EAV attributes.
- `references/sources/devdocs-v2.4/extension-dev-guide/service-contracts/` — older detailed guide.
- `references/sources/devdocs-v2.4/extension-dev-guide/searching-with-repositories.md`
- `references/sources/devdocs-v2.4/extension-dev-guide/attributes.md`
