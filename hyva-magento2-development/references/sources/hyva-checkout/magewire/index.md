<!-- source: https://docs.hyva.io/hyva-checkout/magewire/index.html -->

# Magewire in Hyvä Checkout

Magewire is a port of the popular [Laravel Livewire](https://livewire.laravel.com/) library to Magento. It lets you interact with PHP class properties and methods directly from the browser, with no custom JavaScript or PHP glue code needed. Magewire powers the interactive components in Hyvä Checkout.

This section teaches you just enough about Magewire to get started building and customizing Hyvä Checkout components. Which Magewire version you work with depends on your Hyvä Checkout release line, so start with the version overview below.

Magewire is installed as a dependency of Hyvä Checkout

You don't need to install Magewire separately. Composer pulls it in automatically when you install Hyvä Checkout.

See the [Hyvä Checkout installation instructions](../getting-started/index.html) for details.

## Which Magewire Version Hyvä Checkout Uses

Each Hyvä Checkout release line runs on its own Magewire major version:

| Hyvä Checkout release line | Magewire version | Livewire equivalent |
| --- | --- | --- |
| Checkout 3.x (`3.0.0` and later, plus the `3.0.0` and `1.4.0` betas) | Magewire 3 (`magewirephp/magewire ~3.7.2`) | Livewire 3 |
| Checkout 1.x (`1.3.x` and older, plus the `1.3.1000` betas) | Magewire 1 (`magewirephp/magewire ^1.13.3`) | Livewire 2 |

See [Hyvä Checkout Release Lines](../getting-started/release-lines.html) to find out which line your project uses.

How the Magewire Intro pages are organized

The pages in this section document Magewire 1 behavior in detail, because that is what most existing checkout integrations are written against. Wherever Magewire 3 behaves differently, the page shows the difference in a "Checkout 3.x (Magewire 3)" tab, usually with a link to the matching page of the official Magewire 3 documentation. For everything else about Magewire 3, use the [Magewire 3 documentation](https://docs.magewirephp.nl/).

### Magewire 1 Code on Checkout 3.x (the v1bc Module)

The v1bc module, which Checkout 3.x installs, keeps components, templates and JavaScript written for Magewire 1 working on Checkout 3.x checkout pages. See [The Magewire 1 Backward Compatibility Module (v1bc)](v1bc.html) for what it covers, and [Migrating Checkout Components From Magewire 1 to Magewire 3](migrating-to-magewire-3.html) for what a module supporting both release lines has to change.

## Declaring a Magewire Component in Magento Layout XML

Any Magento block can become a Magewire component by adding a block argument named `magewire` in layout XML. If you've worked with Magento PHP ViewModels before, this pattern will feel familiar. It's the same approach for injecting an object instance into a block.

The following layout XML example turns a block into a Magewire component by declaring the `magewire` argument with a PHP class reference:

```
<!-- Declaring a Magewire component in Magento layout XML -->
<block name="checkout.shipping-details" template="Hyva_Checkout::checkout/address-view/entity-details.phtml">
    <arguments>
        <!-- The argument name "magewire" is the key that activates the Magewire library -->
        <argument name="magewire" xsi:type="object">
            \Hyva\Checkout\Magewire\Checkout\AddressView\ShippingDetails
        </argument>
    </arguments>
</block>
```

The special argument name `magewire` is what tells the Magewire library to treat this block's view model as a Magewire component. This `magewire` view model is the PHP class that the front end can interact with. The `magewire` argument works the same way on both release lines. Magewire 3 also reads `magewire:mount:<name>` block arguments and passes them to the component's `mount()` method as named arguments.

To render values in the HTML page, the `.phtml` template calls view model methods as usual. The difference is that Magewire adds a special binding syntax that lets the browser call methods on the PHP view model via Ajax. Those method calls can update the view model's properties, and Magewire re-renders the template to update the page automatically.

## How Magewire Works Under the Hood

When Magento renders a block that has a `magewire` view model, the Magewire library adds a few extra HTML attributes to the block's output. The front-end Magewire JavaScript library uses these attributes to initialize a JavaScript object for each Magewire component on the page.

When a visitor interacts with a Magewire component (clicking a button, filling in a field), the JavaScript object sends an Ajax request back to the server. The server invokes the specified view model methods and properties, re-renders the block's template, and sends the updated HTML back to the browser.

### Magewire Request Lifecycle and Hooks

During this process, Magewire calls lifecycle hook methods on components (if they are defined). Magewire also provides ways to send messages between components and other useful utilities.

The Magewire library distinguishes between two types of requests:

- **Preceding request**: the initial HTTP request during which a Magewire component is rendered for the first time.
- **Subsequent request**: any follow-up request triggered by Magewire after a visitor interacts with a component on the page.

Both Magewire versions use these terms.

## Magewire 1 to Magewire 3 Cheat Sheet

The table below lists the Magewire differences you are most likely to hit in checkout code. Components in v1 mode on Checkout 3.x get the Magewire 1 behavior through Magewire's own compatibility layer and the v1bc module, so the 3.x column applies to components in v3 mode. Inside the checkout, those are the components that opt out of v1 mode with `#[HandleBackwardsCompatibility(enabled: false)]`.

| Topic | Checkout 1.x (Magewire 1) | Checkout 3.x (Magewire 3) |
| --- | --- | --- |
| Sending events from PHP | `$this->emit('name', ['key' => $value])`, `$this->emitTo('block.name', ...)` | `$this->dispatch('name', key: $value)`, chained with `->to('block.name')` or `->self()` |
| Listening to events | `protected $listeners = ['name' => 'method']` | `#[On('name')]` on the method (`$listeners` still works) |
| Listener arguments | One associative array | Named arguments, bound by payload key |
| Events from templates and JS | `$emit()`, `$emitTo()`, `Magewire.emit()`, `Magewire.emitTo()` | `$dispatch()`, `$dispatchTo()`, `Magewire.dispatch()`, `Magewire.dispatchTo()` |
| `Magewire.on()` callback | Positional arguments | One object: `({ method }) => ...` |
| Magento observer events | Every emit also dispatches `magewire_<event>` | Magewire 3 only dispatches a fixed set of `magewire_on_*` lifecycle events. While the v1bc module is enabled, it dispatches `magewire_<event>` for every component |
| `wire:model` | Syncs on every change | Deferred until the next request. Use `wire:model.live` to sync on change |
| `wire:model` modifiers | `.defer`, `.lazy`, `.debounce.500ms` | Plain `wire:model`, `.blur` (`.lazy` is an alias of `.change`), `.live.debounce.500ms` |
| `$wire.entangle('foo')` | Live | Deferred. Use `$wire.entangle('foo').live` |
| `$wire.foo = value` | Sends a request | Updates the browser state only. Use `$wire.$set('foo', value)` to send it |
| `updating()` and `updated()` arguments | `($value, $name)` | `($name, $value)` |
| Return value of `updating*()`, `updated*()` | Assigned to the property | Ignored. Assign `$this->foo` yourself |
| `boot()` on subsequent requests | Runs before the browser state is applied | Runs after the browser state is restored, so public properties set in `boot()` overwrite browser input |
| `boot()` and `mount()` arguments | `($blockData, $request)` | `boot()` takes none. `mount()` gets `magewire:mount:*` layout arguments by name |
| JavaScript lifecycle events | `magewire:available`, `magewire:load` | `magewire:init`, `magewire:initialized` |
| JavaScript hooks | `component.initialized`, `element.initialized`, `element.updating`, `element.updated`, `element.removed`, `message.sent`, `message.received`, `message.processed`, `message.failed` | `component.init`, `element.init`, `morph.updating`, `morph.updated`, `morphed`, `commit` (with `succeed`, `fail` and `respond`). Callbacks receive one object |
| Promise of a `$wire` method call | Resolves without a value | Resolves to the PHP method's return value |
| Magic `getFoo()` and `hasFoo()` | Available | Not available. Read the property directly |

## Code That Runs on Both Release Lines

An extension that supports Checkout 1.x and 3.x can keep its Magewire 1 code, because the v1bc module runs it on Checkout 3.x checkout pages. When you write new code for both lines, these forms behave the same on Magewire 1, on native Magewire 3 and in v1 mode:

| Task | Use |
| --- | --- |
| Bind a field | `wire:model.live` to sync on change, `wire:model.defer` to send the value with the next request. A plain `wire:model` is live on Magewire 1 and deferred on Magewire 3 |
| Change a value in a hook | Assign it in `updatedFoo($value)` and return it. Don't use the generic `updated()` and `updating()` hooks, whose arguments are swapped |
| Send an event between components | `emit('name', ['key' => $value])` with one associative array, and `$listeners`. See [Events Between PHP Components](migrating-to-magewire-3.html#events-between-php-components) |
| Get data back to JavaScript | Read a public property after the call. Only Magewire 3 resolves a `$wire` method call to the PHP return value |
| Read a property | `$magewire->foo`. Native Magewire 3 components have no magic `getFoo()` |

JavaScript differs more between the two versions. See [JavaScript: Lifecycle Events and Hooks](migrating-to-magewire-3.html#javascript-lifecycle-events-and-hooks).

## Related Topics

- **[Magewire 3 documentation](https://docs.magewirephp.nl/)**: the official Magewire 3 reference, with an [upgrade guide](https://docs.magewirephp.nl/pages/getting-started/upgrade.html), a [V3 vs V1 comparison](https://docs.magewirephp.nl/pages/getting-started/v3-vs-v1.html) and a page on [Hyvä Checkout backwards compatibility](https://docs.magewirephp.nl/pages/theming/hyva-checkout-bc.html)
- **[Livewire 3 documentation](https://livewire.laravel.com/docs/3.x/quickstart)**: the upstream reference for concepts Magewire 3 shares with Livewire 3
- **[Magewire 1 features documentation](https://github.com/magewirephp/magewire/blob/1.x/docs/Features.md)**: the Magewire 1 feature reference on GitHub
- **[Livewire 2 API reference](https://laravel-livewire.com/docs/2.x/reference)**: methods, properties and lifecycle hooks of the Livewire version Magewire 1 is based on
- **[Hyvä Checkout Release Lines](../getting-started/release-lines.html)**: which release line you're on and how the version tabs work
- **[Hyvä Checkout Installation](../getting-started/index.html)**: getting Hyvä Checkout (and Magewire) installed
