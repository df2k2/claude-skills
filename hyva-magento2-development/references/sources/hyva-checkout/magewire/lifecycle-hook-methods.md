<!-- source: https://docs.hyva.io/hyva-checkout/magewire/lifecycle-hook-methods.html -->

# Magewire Lifecycle Hook Methods

Magewire components support several lifecycle hook methods that let you run custom logic at specific points during a component's lifecycle. If a hook method exists on your component class, Magewire calls it automatically at the right time - no extra wiring needed.

Each hook method has a specific name and signature. The sections below cover when each hook fires, how to use property-specific hooks, and the rules around hook method arguments.

## When Each Magewire Lifecycle Hook Method Is Called

The table below shows every available Magewire lifecycle hook method and when it runs. For a deeper look at the request phases, see [Magewire Component Lifecycle](component-lifecycle.html).

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

| Lifecycle hook method | Called during preceding requests? | Called during subsequent requests? | Component hydrated? | Properties updated? |
| --- | --- | --- | --- | --- |
| `boot()` | yes | yes | yes |  |
| `mount(...)` | yes |  |  |  |
| `hydrate()` |  | yes | yes |  |
| `hydrateFoo($value)` |  | yes | yes |  |
| `booted()` | yes | yes | yes |  |
| `updating($prop, $value)` |  | yes | yes |  |
| `updatingFoo($value)` |  | yes | yes |  |
| `updated($prop, $value)` |  | yes | yes | yes |
| `updatedFoo($value)` |  | yes | yes | yes |
| `rendering($view, $data)` | yes | yes | yes | yes |
| `dehydrate()` | yes | yes | yes | yes |
| `dehydrateFoo($value)` | yes | yes | yes | yes |

On subsequent requests, Magewire 3 restores the component's public properties before it calls `boot()`. Magewire 3 also adds `rendered($view, $html)` after rendering and `exception($e, $stopPropagation)` for exceptions thrown during the lifecycle. See [Lifecycle Hooks](https://docs.magewirephp.nl/pages/essentials/lifecycle-hooks.html) in the Magewire 3 docs.

| Lifecycle hook method | Called during preceding requests? | Called during subsequent requests? | Component hydrated? | Properties updated? |
| --- | --- | --- | --- | --- |
| `boot($blockData, $request)` | yes | yes |  |  |
| `mount($blockData, $request)` | yes |  |  |  |
| `hydrate()` |  | yes | yes |  |
| `hydrateFoo($value, $request)` |  | yes | yes |  |
| `booted()` | yes | yes | yes |  |
| `updating($value, $prop)` |  | yes | yes |  |
| `updatingFoo($value)` |  | yes | yes |  |
| `updated($value, $prop)` |  | yes | yes | yes |
| `updatedFoo($value)` |  | yes | yes | yes |
| `dehydrate()` | yes | yes | yes | yes |
| `dehydrateFoo($value, $response)` | yes | yes | yes | yes |

### Hook Methods Available During Preceding Requests

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

During the preceding (initial) request, Magewire 3 calls these hook methods in order:

- `boot()`: runs first
- `mount(...)`: runs only on the initial request, with the `magewire:mount:*` layout arguments
- `booted()`: runs after `mount()`
- `rendering($view, $data)`: runs before the template renders
- `dehydrate()`: runs when the component is being serialized for the response
- `dehydrateFoo($value)`: runs per-property during dehydration

During the preceding (initial) request, Magewire calls these hook methods in order:

- `boot($blockData, $request)`: runs first, before hydration
- `mount($blockData, $request)`: runs only on the initial request
- `booted()`: runs after hydration is complete
- `dehydrate()`: runs when the component is being serialized for the response
- `dehydrateFoo($value, $response)`: runs per-property during dehydration

### Hook Methods Available During Subsequent Requests

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

During subsequent (Ajax) requests, Magewire 3 first restores the public properties from the browser state and then calls these hook methods in order:

- `boot()`: runs first, after the properties are restored
- `hydrate()`: runs after the component state is restored
- `hydrateFoo($value)`: runs per-property during hydration
- `booted()`: runs after hydration is complete
- `updating($prop, $value)`: runs before a property value changes
- `updatingFoo($value)`: runs before a specific property value changes
- `updated($prop, $value)`: runs after a property value changes
- `updatedFoo($value)`: runs after a specific property value changes
- `rendering($view, $data)`: runs before the template renders, after the requested methods ran
- `dehydrate()`: runs when the component is being serialized for the response
- `dehydrateFoo($value)`: runs per-property during dehydration

During subsequent (Ajax) requests, Magewire calls these hook methods in order:

- `boot($blockData, $request)`: runs first, before hydration
- `hydrate()`: restores the component from its serialized state
- `hydrateFoo($value, $request)`: runs per-property during hydration
- `booted()`: runs after hydration is complete
- `updating($value, $prop)`: runs before a property value changes
- `updatingFoo($value)`: runs before a specific property value changes
- `updated($value, $prop)`: runs after a property value changes
- `updatedFoo($value)`: runs after a specific property value changes
- `dehydrate()`: runs when the component is being serialized for the response
- `dehydrateFoo($value, $response)`: runs per-property during dehydration

Full Page Caching and Magewire Lifecycle Hooks

For components on cached pages, **no** lifecycle hook methods are called during the preceding request when the page is served from cache.

Hook methods only run during the preceding request when the page is not yet cached - that is, when the component renders for the first time.

Subsequent requests are different. They always bypass full-page cache because they are Ajax requests processed directly by Magento. All lifecycle hook methods run as expected during subsequent requests.

## Property-Specific Magewire Hook Methods

Each Magewire property that receives a new value during a subsequent request triggers property-specific hook methods. The `updating*()` method fires before the new value is set, and the `updated*()` method fires after. Magewire also supports property-specific `hydrate*()` and `dehydrate*()` hooks.

The `Foo` in method names like `updatingFoo` corresponds to the PascalCase version of the property name `$foo`.

Here is the full set of property-specific lifecycle hook methods for a property called `$foo`:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

```
// Property-specific Magewire lifecycle hooks for $foo
public $foo;
public function hydrateFoo($value) {...}    // Runs during hydration for $foo
public function updatingFoo($value) {...}   // Runs before $foo is updated
public function updatedFoo($value) {...}    // Runs after $foo is updated
public function dehydrateFoo($value) {...} // Runs during dehydration for $foo
```

```
// Property-specific Magewire lifecycle hooks for $foo
public $foo;
public function hydrateFoo($value, $request) {...}  // Runs during hydration for $foo
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

One exception: Magewire 1 called the `hydrate*()` and `dehydrate*()` hooks of a snake\_case property with the property name as is (`hydrateBar_baz()`). On Checkout 3.x, also in v1 mode, Magewire calls the camelCase name (`hydrateBarBaz()`).

You can also define callback methods targeting nested array properties. See [Working with Magewire Array Properties](array-properties.html) for details.

## Magewire Lifecycle Hook Method Arguments

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Magewire 3 lifecycle hook methods follow these rules around their arguments:

**Don't rely on return values.** Magewire 3 ignores the return value of hook methods. To change a value, assign it to the property in `updatedFoo()`. Don't change a value in `updatingFoo()`, because Magewire 3 applies the browser value after that hook runs:

```
// Normalize the value after the update and assign it yourself
public function updatedFooBar($value): void
{
    $this->fooBar = trim($value);
}
```

**No `$blockData`, `$request` or `$response` arguments.** `boot()` takes no arguments, and `mount()` receives the `magewire:mount:*` layout arguments as named parameters. Read other block data with `$this->magewireBlock()->getData()`.

**Generic hooks take the property name first.** The signatures are `updating($prop, $value)` and `updated($prop, $value)`.

Components in v1 mode get the Magewire 1 return values and argument order through Magewire's compatibility layer and the v1bc module.

Magewire lifecycle hook methods follow a few important rules around their arguments.

**Return the `$value` argument from `updating*()` and `updated*()` hooks.** Magewire 1 assigns what these hooks return to the property, so return the value, transformed or validated as needed. The return value of `hydrate*()` and `dehydrate*()` hooks is ignored:

```
// Always return $value from hook methods that receive it
public function updatingFooBar($value)
{
    // Run your custom logic here

    return $value; // Required - Magewire needs the value back
}
```

**The `$blockData` argument** is the array returned by `$block->getData()`. Hook methods like `boot()` and `mount()` receive this so you can access the block's configuration data.

**The `$request` argument** is an instance of `\Magewirephp\Magewire\Model\RequestInterface`. Hook methods like `boot()`, `mount()` and `hydrateFoo()` receive the current request object.

**The `$response` argument** is an instance of `\Magewirephp\Magewire\Model\ResponseInterface`. The `dehydrateFoo()` hook method receives this so you can modify the response during serialization.
