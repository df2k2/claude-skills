<!-- source: https://docs.hyva.io/hyva-checkout/magewire/component-intro.html -->

# Anatomy of a Magewire Component

Magewire components are PHP classes that extend `\Magewirephp\Magewire\Component`. They're the building blocks of Hyvä Checkout's interactive UI - each component pairs a PHP class with a template to handle a specific piece of checkout functionality.

By convention, Magewire component classes live inside a Magento module within a `Magewire/` directory.

## Public Properties and Methods in Magewire Components

Magewire is aware of all **public properties** on a component. Public properties automatically sync between the server and the browser, so when a user interacts with the checkout UI, Magewire keeps everything in sync for you.

## Magewire Component Lifecycle Hook Methods

Magewire component classes can implement hook methods that get called at specific points during the component lifecycle.

Two of the most commonly used hook methods are:

- **`mount()`** - Called once when the page is initially rendered. Use `mount()` to set up initial state based on constructor dependencies or request data.
- **`booted()`** - Called on the initial preceding page request and on all subsequent (wire) requests. Use `booted()` for setup logic that needs to run every time the component is active.

For the full list of available lifecycle hooks, check out the [Lifecycle Hook Methods](lifecycle-hook-methods.html) page.

## Reserved Property Names in Magewire Components

Avoid Using Reserved Property Names

The base `Magewire\Component` class declares several properties that you must not redefine in your own Magewire components. Because names like `$id` and `$name` are so common, it's easy to accidentally create a conflicting property - and doing so will break your component.

**Use alternative names instead.** For example, use `$entityId` and `$productName` rather than `$id` or `$name`.

Some reserved properties are public and some are protected. In either case, do not use them for custom purposes in your Magewire components. Some serve as internal implementation details, while others are intended for specific framework purposes.

At the time of writing, the following properties are reserved by Magewire:

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

- **[Lifecycle Hook Methods](lifecycle-hook-methods.html)** - Full reference for all Magewire component lifecycle hooks
- **[Magewire Component Templates](component-templates.html)** - How to create and connect templates to Magewire components
- **[Magewire Component Interaction](component-interaction.html)** - How Magewire components communicate with each other
