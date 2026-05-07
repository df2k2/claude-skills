<!-- source: https://docs.hyva.io/hyva-checkout/magewire/emit-messages.html -->

# Magewire Emit Messages - Publish/Subscribe Communication Between Components

Magewire emit messages provide a publish/subscribe (pub/sub) system for communication between Magewire components in Hyva Checkout. Components use [`$emit`](component-interaction.html#magewire-magic-actions-for-component-properties) to broadcast messages and `$listeners` to subscribe to messages. This pattern is similar to Magento's event/observer system and JavaScript event/subscriber patterns.

## Subscribing to Emit Messages with `$listeners`

A Magewire component subscribes to emit messages by declaring a `protected $listeners` array. Each entry in the `$listeners` array maps a message name to a public method on the component. When another component emits a matching message, Magewire automatically invokes the listener method and passes along any arguments.

The following example shows a Magewire component that listens to `doSomething` emit messages:

```
class MyComponent extends \Magewirephp\Magewire\Component
{
    // Register 'doSomething' as a listener - the method name matches the message name
    protected $listeners = ['doSomething'];

    public function doSomething($value)
    {
        // This method runs when any component emits 'doSomething'
    }
}
```

Info

Not every public method can receive emit messages. Only methods listed in the `$listeners` array are callable through the emit system. This protects component methods from being invoked unexpectedly.

### Mapping Emit Message Names to Different Method Names

When the emitted message name does not work well as a PHP method name, the `$listeners` property supports an associative array format. The array keys are the emitted message names and the values are the method names to call on the component.

This example maps three different emit messages to the same `refresh` method:

```
    protected $listeners = [
        'shipping_method_selected' => 'refresh',
        'coupon_code_applied' => 'refresh',
        'coupon_code_revoked' => 'refresh'
    ];
```

## Emitting Messages from PHP, HTML, and JavaScript

Magewire supports emitting messages from multiple contexts: PHP component classes, HTML templates using `wire:click` directives, and vanilla JavaScript. Each context uses a slightly different syntax but follows the same pattern.

### Emitting from a PHP Component with `$this->emit()`

Inside a Magewire component method, call `$this->emit()` to broadcast a message to all listening components. Use `$this->emitTo()` to target a specific block by name.

```
class MyOtherComponent extends \Magewirephp\Magewire\Component
{
    public function myAction()
    {
        $payload = ['id' => 69];

        // Broadcast to all listening components
        $this->emit('doSomething', $payload);

        // Target a specific block by its layout name
        $this->emitTo('some.block.name', 'doSomething', $payload);
    }
}
```

The `emit()` method only works during subsequent requests

During the initial preceding request, calling `$this->emit()` or `$this->emitTo()` has no effect. Emit messages only work during subsequent requests.

### Emitting from HTML Templates with `wire:click`

Use the `$emit` magic action inside `wire:click` directives to emit messages directly from HTML templates.

```
<!-- Broadcast to all listening components -->
<button wire:click="$emit('doSomething', {result: result, foo: 'bar', confirmed: true})">Click me</button>

<!-- Target a specific block by its layout name -->
<button wire:click="$emitTo(
    'some.block.name',
    'doSomething',
    {result: result, foo: 'bar', confirmed: true}
)">Click me</button>
```

### Emitting from Vanilla JavaScript with `Magewire.emit()`

The global `Magewire` JavaScript object provides `emit()` and `emitTo()` methods for emitting messages from vanilla JavaScript code.

```
// Broadcast to all listening components
Magewire.emit('doSomething', {value: payload})

// Target a specific block by its layout name
Magewire.emitTo('some.block.name', 'doSomething', {value: payload})
```

## Magento Event Interop for Emit Messages

Every Magewire emit message is automatically dispatched as a native Magento event. The Magento event name is the emit message name prefixed with `magewire_`. This interoperability allows standard Magento event observers to react to Magewire emit messages.

For example, the following emit message in JavaScript:

```
$emit('doSomething', {result: 42, confirmed: true})
```

Magewire automatically dispatches the equivalent Magento event:

```
$eventManager->dispatch('magewire_doSomething', ['result' => 42, 'confirmed' => true])
```

Livewire-style emit payloads vs. Magewire-style

Livewire passes emit parameters as individual positional values, while Magewire uses an associative array. Both syntaxes work in Magewire, but the associative array format is strongly recommended because positional parameters do not map cleanly to Magento event data.

Compare the two styles in PHP:

```
// Recommended Magewire syntax (associative array):
$this->emit('doSomething', ['result' => $result, 'is_confirmed' => $isConfirmed]);

// Livewire syntax (positional parameters - discouraged):
$this->emit('doSomething', $result, $isConfirmed);
```

The same distinction applies in HTML templates:

```
<!-- Recommended Magewire syntax -->
<button wire:click="$emit('doSomething', {result, isConfirmed: true})">Magewire syntax</button>

<!-- Livewire syntax (discouraged) -->
<button wire:click="$emit('doSomething', result, true)">Livewire syntax</button>
```

A note on coupling with `emitTo`

The `$emit()` method follows the event/observer pattern where the publisher is fully decoupled from any subscribers. However, `$emitTo()` targets a specific block by name, creating a direct dependency between the emitting component and the target block.

Using `emitTo` is more like calling a method on a specific object instance (e.g. `$object->doSomething()`). This coupling is fine in moderation, but overusing `emitTo` can lead to more brittle code. Prefer broadcasting with `$emit()` when possible.

## Listening to Magewire Emit Messages in JavaScript

The global `Magewire` JavaScript object provides a `Magewire.on()` method for subscribing to emit messages from JavaScript. This is useful for triggering frontend behavior in response to Magewire component actions. This functionality follows the [Livewire v2 event listener syntax](https://laravel-livewire.com/docs/2.x/events#in-js).

The following example listens for a `foo` emit message and logs the `bar` property from the event payload:

```
Magewire.on(
    'foo',
    event => {
        console.log(event.bar);
    }
);
```
