<!-- source: https://docs.hyva.io/hyva-checkout/magewire/component-intro.html -->

# Anatomy of a Magewire Component

Magewire components are PHP classes that extend `\Magewirephp\Magewire\Component`. They're the building blocks of Hyvä Checkout's interactive UI - each component pairs a PHP class with a template to handle a specific piece of checkout functionality.

By convention, Magewire component classes live inside a Magento module within a `Magewire/` directory.

## Public Properties and Methods in Magewire Components

Magewire is aware of all **public properties** on a component. Public properties automatically sync between the server and the browser, so when a user interacts with the checkout UI, Magewire keeps everything in sync for you.

The browser can call every **public method** of a Magewire component. Keep a public method that only templates or PHP code call, especially one that returns data the customer mustn't see, away from the browser by listing it in the component's `$uncallables` property. This works the same on both release lines:

```
// Methods the browser can't call, e.g. wire:click="getOrderData" or $wire.call('getOrderData')
protected array $uncallables = ['getOrderData'];
```

## Magewire Component Lifecycle Hook Methods

Magewire component classes can implement hook methods that get called at specific points during the component lifecycle.

Two of the most commonly used hook methods are:

- **`mount()`** - Called once when the page is initially rendered. Use `mount()` to set up initial state based on constructor dependencies or request data.
- **`booted()`** - Called on the initial preceding page request and on all subsequent (wire) requests. Use `booted()` for setup logic that needs to run every time the component is active.

For the full list of available lifecycle hooks, check out the [Lifecycle Hook Methods](./lifecycle-hook-methods.html) page.

## Reserved Property Names in Magewire Components

Avoid Using Reserved Property Names

The base `Magewire\Component` class declares several properties that you must not redefine in your own Magewire components. Because names like `$id` and `$name` are so common, it's easy to accidentally create a conflicting property, and doing so will break your component.

**Use alternative names instead.** For example, use `$entityId` and `$productName` rather than `$id` or `$name`.

Some reserved properties are public and some are protected. In either case, do not use them for custom purposes in your Magewire components. Some serve as internal implementation details, while others are intended for specific framework purposes.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Magewire 3 keeps most component internals in private or `__`-prefixed properties, so fewer names are taken. Don't redeclare these properties in your Magewire components:

- `public $id` (deprecated, read the ID with `id()` or `getId()` instead)
- `protected $listeners`
- `protected $loader`
- `protected $errors`
- `protected $dispatchQueue`
- `protected $attributes`
- `protected $magewireViewModel`
- `protected $validator`, `protected $rules` and `protected $messages` (on `Component\Form`)

The base class no longer declares `$name`, but Magewire still leaves `id` and `name` out of `getPublicProperties()`, so avoid both names on Checkout 3.x too.

Magewire 3 also reserves method names such as `boot`, `mount`, `rendering`, `exception` and anything matching `hydrate*`, `dehydrate*`, `updating*` or `updated*`. See [Components](https://docs.magewirephp.nl/pages/essentials/components.html) and the [upgrade guide](https://docs.magewirephp.nl/pages/getting-started/upgrade.html) in the Magewire 3 docs.

At the time of writing, the following properties are reserved by Magewire 1:

- `public $id`
- `public $name`
- `protected $dispatchQueue`
- `protected $renderedChildren`
- `protected $request`
- `protected $response`
- `protected $eventQueue`
- `protected $errors`
- `protected $listeners`
- `protected $flashMessage`
- `protected $uncallables`
- `protected $queryString`
- `protected $redirect`
- `protected $skipRender`
- `protected $loader`
- `protected $validator`
- `protected $rules`
- `protected $messages`

## Related Topics

- **[Lifecycle Hook Methods](./lifecycle-hook-methods.html)** - Full reference for all Magewire component lifecycle hooks
- **[Magewire Component Templates](./component-templates.html)** - How to create and connect templates to Magewire components
- **[Magewire Component Interaction](./component-interaction.html)** - How Magewire components communicate with each other
