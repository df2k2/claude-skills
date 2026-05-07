<!-- source: https://docs.hyva.io/hyva-checkout/magewire/lifecycle-hook-methods.html -->

# Magewire Lifecycle Hook Methods

Magewire components support several lifecycle hook methods that let you run custom logic at specific points during a component's lifecycle. If a hook method exists on your component class, Magewire calls it automatically at the right time - no extra wiring needed.

Each hook method has a specific name and signature. The sections below cover when each hook fires, how to use property-specific hooks, and the rules around hook method arguments.

## When Each Magewire Lifecycle Hook Method Is Called

The table below shows every available Magewire lifecycle hook method and when it runs. For a deeper look at the request phases, see [Magewire Component Lifecycle](component-lifecycle.html).

| Lifecycle hook method | Called during preceding requests? | Called during subsequent requests? | Component hydrated? | Properties updated? |
| --- | --- | --- | --- | --- |
| `boot($blockData, $request)` | yes | yes |  |  |
| `mount($blockData, $request)` | yes |  |  |  |
| `hydrate()` |  | yes | yes |  |
| `hydrateFoo($value)` |  | yes | yes |  |
| `booted()` | yes | yes | yes |  |
| `updating($value, $prop)` |  | yes | yes |  |
| `updatingFoo($value)` |  | yes | yes |  |
| `updated($value, $prop)` |  | yes | yes | yes |
| `updatedFoo($value)` |  | yes | yes | yes |
| `dehydrate()` | yes | yes | yes | yes |
| `dehydrateFoo($value, $response)` | yes | yes | yes | yes |

### Hook Methods Available During Preceding Requests

During the preceding (initial) request, Magewire calls these hook methods in order:

- `boot($blockData, $request)` - runs first, before hydration
- `mount($blockData, $request)` - runs only on the initial request
- `booted()` - runs after hydration is complete
- `dehydrate()` - runs when the component is being serialized for the response
- `dehydrateFoo($value, $response)` - runs per-property during dehydration

### Hook Methods Available During Subsequent Requests

During subsequent (Ajax) requests, Magewire calls these hook methods in order:

- `boot($blockData, $request)` - runs first, before hydration
- `hydrate()` - restores the component from its serialized state
- `hydrateFoo($value)` - runs per-property during hydration
- `booted()` - runs after hydration is complete
- `updating($value, $prop)` - runs before a property value changes
- `updatingFoo($value)` - runs before a specific property value changes
- `updated($value, $prop)` - runs after a property value changes
- `updatedFoo($value)` - runs after a specific property value changes
- `dehydrate()` - runs when the component is being serialized for the response
- `dehydrateFoo($value, $response)` - runs per-property during dehydration

Full Page Caching and Magewire Lifecycle Hooks

For components on cached pages, **no** lifecycle hook methods are called during the preceding request when the page is served from cache.

Hook methods only run during the preceding request when the page is not yet cached - that is, when the component renders for the first time.

Subsequent requests are different. They always bypass full-page cache because they are Ajax requests processed directly by Magento. All lifecycle hook methods run as expected during subsequent requests.

## Property-Specific Magewire Hook Methods

Each Magewire property that receives a new value during a subsequent request triggers property-specific hook methods. The `updating*()` method fires before the new value is set, and the `updated*()` method fires after. Magewire also supports property-specific `hydrate*()` and `dehydrate*()` hooks.

The `Foo` in method names like `updatingFoo` corresponds to the PascalCase version of the property name `$foo`.

Here is the full set of property-specific lifecycle hook methods for a property called `$foo`:

```
// Property-specific Magewire lifecycle hooks for $foo
public $foo;
public function hydrateFoo($value) {...}    // Runs during hydration for $foo
public function updatingFoo($value) {...}   // Runs before $foo is updated
public function updatedFoo($value) {...}    // Runs after $foo is updated
public function dehydrateFoo($value, $response) {...}  // Runs during dehydration for $foo
```

### Magewire Hook Methods with camelCase Properties

Property-specific hook methods work with camelCase properties too. The property name maps directly to the method suffix:

```
// camelCase property $fooBar maps to updatingFooBar
public $fooBar;
public function updatingFooBar($value) {...}
```

### Magewire Hook Methods with snake\_case Properties

Even snake\_case properties are supported (though they are not standard in Magento). The hook method suffix uses camelCase regardless of the property's naming convention:

```
// snake_case property $bar_baz maps to updatingBarBaz
public $bar_baz;
public function updatingBarBaz($value) {...}
```

You can also define callback methods targeting nested array properties. See [Working with Magewire Array Properties](array-properties.html) for details.

## Magewire Lifecycle Hook Method Arguments

Magewire lifecycle hook methods follow a few important rules around their arguments.

**Return the `$value` argument.** If a hook method receives a `$value` parameter, you must return it. This lets you transform or validate the value before Magewire uses it:

```
// Always return $value from hook methods that receive it
public function updatingFooBar($value)
{
    // Run your custom logic here

    return $value; // Required - Magewire needs the value back
}
```

**The `$blockData` argument** is the array returned by `$block->getData()`. Hook methods like `boot()` and `mount()` receive this so you can access the block's configuration data.

**The `$request` argument** is an instance of `\Magewirephp\Magewire\Model\RequestInterface`. Hook methods like `boot()` and `mount()` receive the current request object.

**The `$response` argument** is an instance of `\Magewirephp\Magewire\Model\ResponseInterface`. The `dehydrateFoo()` hook method receives this so you can modify the response during serialization.
