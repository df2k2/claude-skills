# Plugins (Interception) in Magento 2

Plugins (also called "interceptors") let you hook **before**, **after**, or **around** a public method on a non-final class — without editing the class. They're declared in `di.xml`, implemented as a regular PHP class. They are Magento's primary tool for non-invasive customization.

## When to use a plugin vs. an observer vs. a preference

| Need | Tool |
| --- | --- |
| Modify the input/output of a specific public method (e.g. `productRepository->save()`) | **Plugin** |
| React to a discrete "this happened" event with no need to change behavior | **Observer** |
| Swap out an entire class implementation | **Preference** (rare) |
| Add a new field to an existing entity exposed via REST/GraphQL | **Extension attribute** + plugin/observer to persist |

Plugins are the most common answer.

## Plugin declaration in `di.xml`

```xml
<type name="Magento\Catalog\Api\ProductRepositoryInterface">
    <plugin name="acme_hello_track_product_save"
            type="Acme\Hello\Plugin\TrackProductSave"
            sortOrder="10"
            disabled="false"/>
</type>
```

- `<type name>` — the class or interface you want to intercept. **Prefer interfaces** (`Magento\Catalog\Api\ProductRepositoryInterface`) over concrete classes (`Magento\Catalog\Model\ProductRepository`); interfaces are the public contract and survive refactors.
- `<plugin name>` — a unique-per-target identifier. Use snake_case with your module prefix. Names must be unique within the same type, across all modules. Reusing a name in another module's `di.xml` overrides the original plugin's config — useful for disabling or re-prioritizing, dangerous if accidental.
- `<plugin type>` — your plugin class (FQCN).
- `sortOrder` — order among multiple plugins on the same target. Lower runs first for `before`/`around`. For `after`, lower runs first too (executes after the call). Default 10. Adjust if you need to chain.
- `disabled` — set `true` to turn off the plugin without deleting the XML. Useful for emergencies.

The plugin class itself is a plain PHP class — no interface or base class required. Magento finds plugin methods by **name**:

- `beforeMethodName(...)` — runs before the target method.
- `aroundMethodName(...)` — wraps the target method (you call `$proceed` to continue).
- `afterMethodName(...)` — runs after the target method.

You can have any combination on the same plugin class. Methods that don't follow the naming pattern are ignored.

## Before plugin

Runs **before** the target. Can modify arguments. Cannot prevent the target from running (use around for that).

```php
namespace Acme\Hello\Plugin;

use Magento\Catalog\Api\Data\ProductInterface;
use Magento\Catalog\Api\ProductRepositoryInterface;

class TrackProductSave
{
    public function beforeSave(
        ProductRepositoryInterface $subject,
        ProductInterface $product,
        $saveOptions = false
    ): array {
        // Modify product before save
        if (!$product->getSku()) {
            $product->setSku('AUTO-' . uniqid());
        }

        // Must return the arguments as an array, in order
        return [$product, $saveOptions];
    }
}
```

Rules:
- First parameter is the **subject** (the intercepted object) — passed in automatically by Magento.
- Remaining parameters mirror the target method's signature.
- Must return either:
  - `null` (or no return) — pass arguments through unchanged.
  - An **array** with the modified arguments **in order**, matching the target's positional signature.
- Magento merges the returned array back into the call. You CANNOT add or remove arguments — just replace values.

## After plugin

Runs **after** the target. Can modify the return value.

```php
class TrackProductSave
{
    public function afterSave(
        ProductRepositoryInterface $subject,
        ProductInterface $result,        // <- the original method's return value
        ProductInterface $product,        // <- the ORIGINAL arguments (for context)
        $saveOptions = false
    ): ProductInterface {
        // Log, modify, etc.
        if ($result->getSku()) {
            // ...
        }
        return $result;
    }
}
```

Rules:
- First param: subject. Second param: the return value of the target method.
- **Magento 2.2+: subsequent params get the ORIGINAL arguments** (after any before plugins have modified them). This is the modern signature.
- Must return a value of the same type as the target returned (or compatible). Returning `void` from an after plugin on a non-void method causes runtime errors.

If the target method returns `void`, the after plugin returns nothing:
```php
public function afterSomething($subject, $arg1): void { /* ... */ }
```

## Around plugin

Wraps the target. You receive a `\Closure $proceed` that, when called, runs the original method (and all the next-in-chain around plugins).

```php
class TrackProductSave
{
    public function aroundSave(
        ProductRepositoryInterface $subject,
        \Closure $proceed,
        ProductInterface $product,
        $saveOptions = false
    ): ProductInterface {
        // Pre-processing
        $start = microtime(true);

        try {
            $result = $proceed($product, $saveOptions);
        } finally {
            // Post-processing (always runs)
            $elapsed = microtime(true) - $start;
            $this->logger->info("Save took {$elapsed}s");
        }

        return $result;
    }
}
```

Rules:
- First param: subject. Second param: `\Closure $proceed`. Remaining: target's args.
- You decide whether/when to call `$proceed`. To "block" execution, just don't call it (return early with a default).
- Calling `$proceed` invokes the **next plugin in the chain** (or, if you're last, the original method).

**Around plugins are expensive** — they wrap every other plugin and the original in a closure. Each around plugin adds a stack frame. Use **before** or **after** if your need fits — most do.

## Choosing between before/after/around

- **Modify args** → `before`.
- **Modify return value** → `after`.
- **Suppress the call entirely** under some condition → `around`.
- **Wrap with try/finally, transactions, timing** → `around`.
- **Anything else** → `before` or `after`. Avoid `around`.

If you find yourself writing `aroundFoo` that just calls `$proceed(...$args)` and modifies the result, refactor to `afterFoo`. The codebase will thank you.

## Sort order

Multiple plugins on the same target run in `sortOrder` order. Lower sortOrder runs first.

For `before` plugins: order is FIFO — sortOrder 10 runs before sortOrder 20.
For `around` plugins: same — the lower sortOrder forms the outer wrapper.
For `after` plugins: same — the lower sortOrder runs first AFTER the target.

A plugin chain mixing types runs like:

```
beforeFoo(sortOrder 10) → beforeFoo(sortOrder 20)
   → aroundFoo(sortOrder 10) pre
      → aroundFoo(sortOrder 20) pre
         → original Foo()
      → aroundFoo(sortOrder 20) post
   → aroundFoo(sortOrder 10) post
→ afterFoo(sortOrder 10) → afterFoo(sortOrder 20)
```

If your plugin needs to run after another module's plugin, set sortOrder higher than theirs. Look up the other plugin's sortOrder before guessing.

## What you can and can't intercept

### Can intercept
- **Public** methods on **non-final** classes.
- Methods on interfaces (and Magento generates an interceptor for whichever concrete implements it via preference).

### Cannot intercept
- `private` or `protected` methods.
- `static` methods.
- `final` methods.
- Methods on `final` classes.
- `__construct` (constructor) — cannot be plugin'd.
- Magic methods (`__get`, `__set`, etc.).
- Virtual types' methods directly — plug into the underlying real type.
- Methods on classes inside `Magento\Framework\ObjectManager*` and a few other framework internals.

If you try, the plugin is silently ignored. `setup:di:compile` will sometimes emit a warning. Test that your plugin actually fires.

## How interception works under the hood

When you declare a plugin on `Magento\Catalog\Api\ProductRepositoryInterface`, Magento generates `Magento\Catalog\Api\ProductRepositoryInterface\Interceptor` (a concrete class implementing the interface) at compile time. It extends the real class — `Magento\Catalog\Model\ProductRepository` — overrides every public method with a version that walks the plugin chain, then calls `parent::`.

The DI container is then configured to instantiate the `Interceptor` class instead of the real class. Anywhere a `ProductRepositoryInterface` is injected, the Interceptor is delivered.

This is why:
- Plugins only work on classes resolved through the DI container. `new ProductRepository()` bypasses interception.
- `final` blocks generation — the Interceptor can't extend a final class or override a final method.
- Constructor can't be plugin'd — the Interceptor's constructor is generated to match and delegate.

## Performance and best practices

- **Use before/after over around** unless you need the wrap semantics.
- **Don't intercept hot-path methods** unnecessarily. Plugins on `Magento\Framework\App\ResourceConnection::getConnection` will fire on every query.
- **Don't do heavy work in plugins**. If you need to do DB I/O on every product save, queue a message instead and process async.
- **Don't intercept the same target from many modules independently** — the chain grows long and ordering becomes a nightmare. Combine plugins where possible.
- **Type-hint correctly**. Use the same types the target uses; PHP 8 strict types will throw at runtime if you mismatch.
- **Don't intercept what you can `<preference>`**. If you're replacing 90% of the behavior, just preference the class.
- **Be defensive in around plugins**: wrap `$proceed` in try/finally if you have state to clean up.

## Common errors

### "Plugin class does not exist" / "Cannot resolve …"
- File path / namespace mismatch.
- `setup:di:compile` not run after creating the plugin (in production mode).
- Typo in the class name in `di.xml`.

### Plugin not firing
- Wrong area (e.g. plugin in `etc/di.xml` but target is only used in adminhtml — fine, it should fire. But plugin in `etc/frontend/di.xml` won't fire on admin/API requests).
- Target is a `final` class or final method.
- Caller bypasses DI (`new Foo()` instead of `objectManager->create()`).
- Method is private/protected/static.
- A previous module's plugin with the same `name` overrode yours with `disabled="true"`.

### "Argument 1 passed to … must be an instance of … null given"
Your before plugin returned `null` instead of an array, or returned the wrong number of args.

### "Cannot redeclare class … Interceptor"
Stale `generated/code/`. Delete it (`rm -rf generated/code generated/metadata`) and re-run `setup:di:compile`.

### Plugin works in dev but not production
You forgot `setup:di:compile` on the production deploy.

## A real-world worked example

**Goal**: every time a product is saved with stock 0, send a Slack message.

`app/code/Acme/StockAlert/etc/di.xml`:
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <type name="Magento\CatalogInventory\Api\StockItemRepositoryInterface">
        <plugin name="acme_stockalert_zero_stock_alert"
                type="Acme\StockAlert\Plugin\AlertOnZeroStock"
                sortOrder="100"/>
    </type>
</config>
```

`app/code/Acme/StockAlert/Plugin/AlertOnZeroStock.php`:
```php
<?php
declare(strict_types=1);

namespace Acme\StockAlert\Plugin;

use Magento\CatalogInventory\Api\Data\StockItemInterface;
use Magento\CatalogInventory\Api\StockItemRepositoryInterface;
use Acme\StockAlert\Model\Slack;

class AlertOnZeroStock
{
    public function __construct(
        private readonly Slack $slack
    ) {}

    public function afterSave(
        StockItemRepositoryInterface $subject,
        StockItemInterface $result,
        StockItemInterface $stockItem
    ): StockItemInterface {
        if ((float) $result->getQty() <= 0 && $result->getIsInStock() === false) {
            // Don't block the save if Slack fails
            try {
                $this->slack->send(sprintf(
                    'Product %d is now out of stock.',
                    $result->getProductId()
                ));
            } catch (\Throwable $e) {
                // log and move on
            }
        }
        return $result;
    }
}
```

Then `bin/magento module:enable Acme_StockAlert && bin/magento setup:upgrade && bin/magento cache:flush`. In production add `setup:di:compile`.

## Original sources

- `references/sources/commerce-php/development/components/plugins.md` — official plugin guide.
- `references/sources/devdocs-v2.4/extension-dev-guide/plugins.md` — older but more examples.
- `references/sources/devdocs-v2.4/ext-best-practices/extension-coding/plugins-bp.md` — best practices.
- `references/sources/commerce-php/development/components/code-generation.md` — interceptor generation.
