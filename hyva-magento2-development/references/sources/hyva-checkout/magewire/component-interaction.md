<!-- source: https://docs.hyva.io/hyva-checkout/magewire/component-interaction.html -->

# Magewire Component Interaction with wire: Bindings and Magic Actions

## Magewire wire: Bindings for PHP Component Interaction

Magewire provides a special attribute syntax to declare *magic bindings* that connect your HTML elements directly to PHP component methods. These bindings are declared as HTML element attributes that start with the keyword `wire:`.

Here's a quick look at what a binding looks like:

```
<!-- Clicking this button calls the PHP method on the Magewire component -->
<button wire:click="...">Click me!</button>
```

If you're familiar with Alpine.js, you might recognize the similarity to `x-on:click="..."`. However, there's one important difference: `wire:*` bindings don't call JavaScript functions. Instead, they trigger an *interaction with the PHP `$magewire` component*.

### Common Magewire wire: Binding Types

Here are the most common Magewire bindings you'll use:

- `wire:click="foo"` - Listens for a `click` event and calls the `foo` method on the Magewire component.
- `wire:foo="bar"` - Listens for a browser event called `foo` and calls the `bar` method on the Magewire component. You can listen for any browser DOM event, not just those fired by Magewire.
- `wire:model="foo"` - Assuming `$foo` is a public property on the component class, every time an input element with this directive is updated, the Magewire property value is synchronized.
- `wire:model.lazy="foo"` - Lazily syncs the input with its corresponding Magewire component property at rest.
- `wire:init="foo"` - Calls the `foo` method on the Magewire component immediately after it renders on the page.

A [full list of all Livewire template directives](https://laravel-livewire.com/docs/2.x/reference#template-directives) is available in the Livewire documentation.

### Magewire wire:click Binding Syntax Example

With the `wire:click` binding, the PHP method `registerClick` on the Magewire component is executed when the visitor clicks the button:

```
<!-- Calls registerClick() on the PHP Magewire component on click -->
<button wire:click="registerClick">Click me!</button>
```

## Magewire Magic Actions for Component Properties

Magewire provides a number of magic JavaScript functions that let you interact with component properties directly from your templates. These are not PHP variables - think of them as JavaScript functions that trigger Ajax calls to update the Magewire component on the server.

### Updating a Property with $set()

The `$set()` magic action updates a single property on a Magewire component. Pass the property name and the new value as arguments:

```
<!-- Sets the 'foo' property on the Magewire component to 'bar' -->
<button wire:click="$set('foo', 'bar')">Set foo</button>
```

### Toggling a Boolean Property with $toggle()

The `$toggle()` magic action works like `$set()`, except it only takes the name of a boolean property and flips its value:

```
<!-- Toggles the boolean 'prop' property on the Magewire component -->
<button wire:click="$toggle('prop')">Toggle Property prop</button>
```

### Refreshing a Component with $refresh()

The `$refresh()` magic action requests and renders a fresh version of the Magewire component from the server:

```
<!-- Forces a server-side re-render of the Magewire component -->
<button wire:click="$refresh()">Click me</button>
```

### Broadcasting Events with $emit()

The `$emit()` magic action broadcasts a message to all Magewire components that have subscribed to it. Check out [Subscribing to emit messages](emit-messages.html) for more details.

```
<!-- Emits 'eventName' to all subscribed Magewire components with data -->
<button wire:click="$emit('eventName', {foo: 123, bar: true})">Click me</button>
```

### Sending Events to a Specific Component with $emitTo()

The `$emitTo()` magic action sends a message to a specific Magewire component by its layout block name. See [Subscribing to emit messages](emit-messages.html) for more on how `$emit` and `$emitTo` work.

```
<!-- Emits 'eventName' only to the 'layout.block.name' Magewire component -->
<button wire:click="$emitTo('layout.block.name', 'eventName', {foo: 123, bar: true})">Click me</button>
```

## Updating Magewire Component Properties from PHP and Templates

There are multiple ways to update a Magewire component property depending on the context. Let's walk through the options using a component with a `$isSubscribed` property.

Here's the example Magewire component class:

```
class ExampleComponent extends Component
{
    // Public properties are accessible from wire: bindings
    public $isSubscribed = false;

    ...
}
```

### Updating a Magewire Property from a Template with $set()

If a property update happens as the main effect of user interaction, the magic `$set()` action is the most common approach:

```
<!-- Updates $isSubscribed to true on the Magewire component -->
<button wire:click="$set('isSubscribed', true)">Subscribe</button>
```

### Updating a Magewire Property from PHP Code

If the update happens inside PHP code, simply assign the new property value directly:

```
// Inside a Magewire component method (the usual case)
$this->isSubscribed = true;

// Outside a component method, using a component reference
$magewireComponent->isSubscribed = false;
```

Magewire components do NOT provide magic setter methods (only magic getters and has methods).

Use direct property assignment instead: `$this->foo = 123`.
