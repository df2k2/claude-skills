# Dependency Injection in Magento 2

Magento 2's DI container is the heart of the framework. Almost every customization either configures the DI graph (`di.xml`) or extends it (constructor injection, factories). Understanding it is non-negotiable.

## The `di.xml` file

Lives in `etc/di.xml` (global), `etc/frontend/di.xml`, `etc/adminhtml/di.xml`, `etc/webapi_rest/di.xml`, `etc/webapi_soap/di.xml`, `etc/graphql/di.xml`, or `etc/crontab/di.xml` depending on which area the configuration should apply in. Files in subfolders **only apply in that area**.

A `di.xml` can contain four kinds of declarations:

1. **`<preference for="" type=""/>`** — bind an interface to a concrete class, or replace one concrete class with another (rare).
2. **`<type name="">`** — configure constructor arguments for a class, register plugins, override default values.
3. **`<virtualType name="" type="">`** — create a named "alias" of a class with different constructor arguments. No PHP file required.
4. **`<plugin name="" type=""/>`** — interception (before/after/around). Covered in `plugins-and-interception.md`.

## Preferences — bind interface to implementation

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <preference for="Magento\Catalog\Api\ProductRepositoryInterface"
                type="Magento\Catalog\Model\ProductRepository"/>
</config>
```

Now whenever `ProductRepositoryInterface` is constructor-injected anywhere, the container instantiates `ProductRepository`. The 99% use case: **bind an interface to its implementation**, exactly once, in the module that defines the interface.

**Don't use preferences to override Magento's classes.** It's tempting:
```xml
<!-- BAD: brittle, breaks on Magento upgrades -->
<preference for="Magento\Catalog\Model\Product"
            type="Acme\Hello\Model\Product"/>
```
Problems:
- Only one preference can win — the LAST one (by sequence) takes effect. If another module also overrides, you fight.
- You become responsible for matching Magento's constructor signature on every upgrade.
- You inherit ALL of Magento's tests' assumptions about the class.

Prefer **plugins** for adding to behavior, **observers** for reacting to events. Use preferences only as a last resort when nothing else works.

## Type configuration — arguments to constructors

`<type>` configures the constructor arguments Magento passes when instantiating a class. The class doesn't need to be one you wrote — you can configure Magento's classes too.

```xml
<type name="Magento\Framework\View\Element\UiComponent\DataProvider\CollectionFactory">
    <arguments>
        <argument name="collections" xsi:type="array">
            <item name="acme_hello_listing_data_source" xsi:type="string">
                Acme\Hello\Model\ResourceModel\Hello\Grid\Collection
            </item>
        </argument>
    </arguments>
</type>
```

This is how the admin UI grid system knows which collection to use for a grid named `acme_hello_listing_data_source`. The `<argument name="collections">` adds an entry to the `$collections` array passed to `CollectionFactory::__construct`. Magento **merges array arguments across modules**, so multiple modules can add to `collections` without conflict.

### Argument types

```xml
<argument name="myString" xsi:type="string">hello world</argument>
<argument name="myInt" xsi:type="number">42</argument>
<argument name="myBool" xsi:type="boolean">true</argument>
<argument name="myNull" xsi:type="null"/>
<argument name="myConst" xsi:type="const">Magento\Catalog\Model\Product::ENTITY</argument>

<!-- Inject another type by class name -->
<argument name="logger" xsi:type="object">Psr\Log\LoggerInterface</argument>

<!-- Inject a virtual type or a shared instance -->
<argument name="cache" xsi:type="object" shared="false">Magento\Framework\App\Cache\Type\Block</argument>

<!-- Array (merge-able across modules) -->
<argument name="handlers" xsi:type="array">
    <item name="email" xsi:type="object">Acme\Hello\Handler\Email</item>
    <item name="sms" xsi:type="object">Acme\Hello\Handler\Sms</item>
</argument>

<!-- Read from system config (Stores → Configuration) -->
<argument name="enabled" xsi:type="init_parameter">Acme\Hello\Config::XML_PATH_ENABLED</argument>
```

`shared="false"` forces a new instance every time it's requested. Default is `true` (singleton in the object manager).

### Constructor argument resolution rules

When Magento instantiates a class:
1. It reads the class's constructor signature.
2. For each parameter, it checks `<type name="ThisClass">` `<arguments>` for a matching `<argument name="">`.
3. If none, it uses the parameter's type hint to look up a `<preference>` or instantiate directly.
4. If there's a default value (`= null`, `= []`), it's used when no other source exists.

**Parameter names matter.** The `<argument name="logger">` matches a constructor parameter named `$logger`. If you rename the parameter, the binding silently breaks.

## Virtual types — copy with different args

A virtual type creates a named "stamp" of an existing class with overridden constructor arguments. No PHP file. Useful when you want the SAME class wired up multiple different ways.

```xml
<virtualType name="Acme\Hello\Logger" type="Monolog\Logger">
    <arguments>
        <argument name="name" xsi:type="string">acme_hello</argument>
        <argument name="handlers" xsi:type="array">
            <item name="system" xsi:type="object">Acme\Hello\Logger\Handler</item>
        </argument>
    </arguments>
</virtualType>

<type name="Acme\Hello\Service\Importer">
    <arguments>
        <argument name="logger" xsi:type="object">Acme\Hello\Logger</argument>
    </arguments>
</type>
```

Now `Acme\Hello\Service\Importer` gets a `Monolog\Logger` instance with `name="acme_hello"` instead of the default. The virtual type "logger" is not a class — you can't `new Acme\Hello\Logger()`; only the DI container can resolve it.

Virtual types are heavily used in core for:
- Per-module loggers (each module gets its own log file).
- Per-area cache configurations.
- Admin grid collections.
- Customized factories.

## Factories — `<Class>Factory`

For classes that need to be instantiated **with runtime data** (not configuration), inject a `Factory`:

```php
namespace Acme\Hello\Model;

class Service
{
    public function __construct(
        private \Acme\Hello\Model\HelloFactory $helloFactory
    ) {}

    public function makeOne(string $name): Hello
    {
        return $this->helloFactory->create(['name' => $name]);
    }
}
```

**You don't write the Factory class.** Magento auto-generates `Acme\Hello\Model\HelloFactory` from `Acme\Hello\Model\Hello` during `setup:di:compile`. In developer mode, generation happens on-demand into `generated/code/`. The generated factory has a `create(array $data = []): Hello` method that calls the constructor with `$data` merged into args.

Rule: if the class name ends in `Factory` and the class doesn't physically exist on disk, Magento will try to generate it. The "target" class must exist (and not be an interface). For interfaces, you typically inject the repository instead and call `->getById()` or `->get()`.

## Proxies — defer construction

A Proxy is a generated lightweight stand-in that defers actual class instantiation until a method is called on it. Useful for breaking constructor cycles or for heavyweight dependencies you might not use:

```xml
<type name="Acme\Hello\Model\Slow">
    <arguments>
        <argument name="heavyService" xsi:type="object">Magento\Reports\Model\Service\Proxy</argument>
    </arguments>
</type>
```

Or for a class you write:
```xml
<type name="Acme\Hello\Model\Slow">
    <arguments>
        <argument name="data" xsi:type="object">Acme\Hello\Model\Data\Proxy</argument>
    </arguments>
</type>
```

Magento generates `Acme\Hello\Model\Data\Proxy` during compilation. The proxy class has the same public interface but lazily instantiates the real object on first call.

**When to use proxies**:
- Constructor of class A injects B, and B's constructor (directly or transitively) injects A → circular dependency. Inject B's proxy into A.
- Heavy dependency only used in 5% of requests — proxy avoids the construction cost.

**When NOT to use proxies**:
- "Defensive" proxying everywhere — it adds runtime overhead and obscures real dependencies.

## Plugins — interception

Covered in detail in `plugins-and-interception.md`. The declaration lives in `di.xml`:

```xml
<type name="Magento\Catalog\Api\ProductRepositoryInterface">
    <plugin name="acme_hello_track_product_load"
            type="Acme\Hello\Plugin\TrackProductLoad"
            sortOrder="10"
            disabled="false"/>
</type>
```

## Argument inheritance and merging

Magento merges `di.xml` files in this order:
1. Framework defaults
2. Module di.xml (one per module, per area)
3. Module di.xml in the more specific area (e.g. `etc/frontend/di.xml`)
4. `app/etc/di.xml` (project-level, rarely used)

Within `<arguments>`:
- Scalar arguments (string, int) — **last write wins**.
- Array arguments — **merged by item name**. To override a single item, declare the array with only that item.
- To remove an inherited item: `<item name="x" xsi:type="array"><item name="disabled" xsi:type="boolean">true</item></item>` is a common pattern but not universal. Some core arrays support `disabled` flags; some don't. Check the consumer code.

Module load order (controlled by `module.xml` `<sequence>`) determines who wins.

## Compilation modes

```
bin/magento setup:di:compile
```

Reads all `di.xml` files, resolves all `<preference>`, `<virtualType>`, `<type>`, and `<plugin>` declarations, and writes generated code to `generated/code/` (Factories, Proxies, Interceptors) and a flat cached config to `generated/metadata/`.

- **`developer` mode** — Magento auto-generates Factories/Proxies/Interceptors on-demand. `setup:di:compile` is optional. Slower request-time first hit per class.
- **`default`/`production` modes** — `setup:di:compile` is REQUIRED. Without it, Magento can't generate runtime classes and many requests will fatal-error with "class not found".

Compilation is slow (5–30+ minutes on big stores). Run it during deploy, not on every dev change.

## Common DI patterns

### Constructor injection — the standard

```php
namespace Acme\Hello\Model;

use Magento\Catalog\Api\ProductRepositoryInterface;
use Magento\Framework\Api\SearchCriteriaBuilder;
use Psr\Log\LoggerInterface;

class Service
{
    public function __construct(
        private readonly ProductRepositoryInterface $productRepository,
        private readonly SearchCriteriaBuilder $searchCriteriaBuilder,
        private readonly LoggerInterface $logger
    ) {}
}
```

Inject **interfaces**, not concrete classes. Use the `Api/` namespace classes when available. Use PHP 8 constructor promotion for new code (`private readonly`).

### Inject a config value

```xml
<type name="Acme\Hello\Model\Service">
    <arguments>
        <argument name="apiUrl" xsi:type="init_parameter">Acme\Hello\Model\Service::CONFIG_API_URL</argument>
    </arguments>
</type>
```

Then in PHP:
```php
class Service
{
    public const CONFIG_API_URL = 'acme_hello/general/api_url';

    public function __construct(
        private readonly ScopeConfigInterface $scopeConfig,
        private readonly string $apiUrl = ''
    ) {}
}
```

For runtime values that read system config, prefer injecting `\Magento\Framework\App\Config\ScopeConfigInterface` and calling `$this->scopeConfig->getValue(self::XML_PATH)` over the static `init_parameter`. The XML approach is for fixed compile-time values.

### Inject Magento factories for AbstractModel subclasses

```php
public function __construct(
    private readonly \Acme\Hello\Model\HelloFactory $helloFactory
) {}

public function create(array $data): Hello
{
    return $this->helloFactory->create(['data' => $data]);
}
```

### Inject a Collection Factory

```php
public function __construct(
    private readonly \Acme\Hello\Model\ResourceModel\Hello\CollectionFactory $collectionFactory
) {}

public function getAll(): \Acme\Hello\Model\ResourceModel\Hello\Collection
{
    return $this->collectionFactory->create();
}
```

CollectionFactory creates a new collection (a fluent query builder) each time.

### Replace a class entirely (preference) — only when needed

```xml
<preference for="Magento\Catalog\Model\Product\Url" type="Acme\Hello\Model\Product\Url"/>
```

Your replacement should `extends` the original (or implement the interface) so other code still works. **Run all integration tests** after a preference change.

## Edge cases and gotchas

### Cannot inject into final classes by plugin

A `final` class cannot be intercepted. If you NEED to add behavior, you must use a preference (and inherit) — assuming the class isn't internal-marked.

### Cannot intercept private/protected, static, magic, constructor, or final methods

Plugins only work on public, non-final, non-static, non-magic methods. Constructor cannot be plugin'd. See `plugins-and-interception.md`.

### `shared="false"` doesn't auto-extend transitively

If a class shared=false but its dependencies are shared=true, you get one instance of the parent, sharing the SAME children. To force a fresh tree, every level must be shared=false.

### Cyclic dependencies — use proxies

A → B → A (transitively) at construction time will deadlock at object manager init or throw. Inject a Proxy on one of the legs (the one that's not used at construction).

### `<virtualType>` cannot extend another virtual type cleanly

Magento sort of supports it but it's fragile. Prefer making virtual types of real classes.

### Class generation flapping in dev mode

If `generated/code/Acme/Hello/Model/HelloFactory.php` doesn't exist and you're in production mode, Magento can't run. Either flip to developer mode or run `setup:di:compile`. Don't `rm -rf generated/` in production then leave it.

### Code merge happens at `setup:di:compile`, not on file save

Edit `di.xml` while in production mode and nothing changes until you compile. Adobe Commerce on Cloud does this automatically on deploy.

## Original sources

- `references/sources/commerce-php/development/components/dependency-injection.md` — official DI guide.
- `references/sources/commerce-php/development/components/object-manager/` — Object Manager design.
- `references/sources/commerce-php/development/components/factories.md` — factories.
- `references/sources/commerce-php/development/components/proxies.md` — proxies.
- `references/sources/commerce-php/development/components/code-generation.md` — generated code, compilation.
- `references/sources/devdocs-v2.4/extension-dev-guide/depend-inj.md`
- `references/sources/devdocs-v2.4/extension-dev-guide/object-manager.md`
- `references/sources/devdocs-v2.4/extension-dev-guide/factories.md`
- `references/sources/devdocs-v2.4/extension-dev-guide/proxies.md`
