<!-- source: https://docs.hyva.io/hyva-checkout/magewire/emit-messages.html -->

# Magewire Emit Messages - Publish/Subscribe Communication Between Components

Magewire emit messages provide a publish/subscribe (pub/sub) system for communication between Magewire components in Hyva Checkout. Components use [`$emit`](component-interaction.html#magewire-magic-actions-for-component-properties) to broadcast messages and `$listeners` to subscribe to messages. This pattern is similar to Magento's event/observer system and JavaScript event/subscriber patterns.

On Checkout 3.x, Magewire 3 calls emit messages *events*: components send them with `dispatch()` and subscribe with the `#[On]` attribute. The tabs on this page show both APIs. See [Events](https://docs.magewirephp.nl/pages/essentials/events.html) in the Magewire 3 docs for the full reference.

## Subscribing to Emit Messages with `$listeners`

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

A Magewire 3 component subscribes to an event with the `#[On]` attribute on a public method. When another component dispatches a matching event, Magewire invokes the method and binds the payload keys to the method's parameters by name.

The following example shows a Magewire 3 component that listens to `doSomething` events:

```
use Magewirephp\Magewire\Attributes\On;

class MyComponent extends \Magewirephp\Magewire\Component
{
    // Runs when any component dispatches 'doSomething'
    #[On('doSomething')]
    public function doSomething(int $id)
    {
        // $id is bound from the "id" key of the event payload
    }
}
```

The `protected $listeners` array still works on Magewire 3, and Hyvä Checkout's own components still use it. On a native Magewire 3 component, the listener method receives the payload as named arguments in both cases.

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

Not every public method can receive emit messages. Only methods listed in the `$listeners` array (or marked with `#[On]` on Magewire 3) are callable through the emit system. This protects component methods from being invoked unexpectedly.

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

On Magewire 3, you can get the same result by repeating the `#[On]` attribute on one method:

```
#[On('shipping_method_selected')]
#[On('coupon_code_applied')]
#[On('coupon_code_revoked')]
public function refreshSummary()
{
    // Runs for each of the three events
}
```

## Emitting Messages from PHP, HTML, and JavaScript

Magewire supports emitting messages from multiple contexts: PHP component classes, HTML templates using `wire:click` directives, and vanilla JavaScript. Each context uses a slightly different syntax but follows the same pattern.

### Emitting from a PHP Component with `$this->emit()`

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Inside a Magewire 3 component method, call `$this->dispatch()` with the payload as named arguments to broadcast an event to all listening components. Chain `->to()` to target a specific block by name, or `->self()` to only reach the component itself.

```
class MyOtherComponent extends \Magewirephp\Magewire\Component
{
    public function myAction()
    {
        // Broadcast to all listening components
        $this->dispatch('doSomething', id: 69);

        // Target a specific block by its layout name
        $this->dispatch('doSomething', id: 69)->to('some.block.name');
    }
}
```

The `emit()` and `emitTo()` methods still exist on Magewire 3 as deprecated wrappers around `dispatch()`. An associative array passed to `emit()` arrives as named arguments on native Magewire 3 listeners and as one array on listeners in v1 mode.

Events dispatched during the preceding request

On Magewire 3, an event you dispatch during the initial preceding request is sent along with the rendered component, and the browser dispatches it once the component starts. For components in v1 mode, the v1bc module keeps the Magewire 1 behavior and drops events emitted during the first render.

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

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Use the `$dispatch` and `$dispatchTo` magic actions inside `wire:click` directives to dispatch events directly from HTML templates.

```
<!-- Broadcast to all listening components -->
<button wire:click="$dispatch('doSomething', { result: result, foo: 'bar', confirmed: true })">Click me</button>

<!-- Target a specific block by its layout name -->
<button wire:click="$dispatchTo(
    'some.block.name',
    'doSomething',
    { result: result, foo: 'bar', confirmed: true }
)">Click me</button>
```

Use the `$emit` magic action inside `wire:click` directives to emit messages directly from HTML templates.

```
<!-- Broadcast to all listening components -->
<button wire:click="$emit('doSomething', { result: result, foo: 'bar', confirmed: true })">Click me</button>

<!-- Target a specific block by its layout name -->
<button wire:click="$emitTo(
    'some.block.name',
    'doSomething',
    { result: result, foo: 'bar', confirmed: true }
)">Click me</button>
```

### Emitting from Vanilla JavaScript with `Magewire.emit()`

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

The global `Magewire` JavaScript object provides `dispatch()` and `dispatchTo()` methods for dispatching events from vanilla JavaScript code.

```
// Broadcast to all listening components
Magewire.dispatch('doSomething', { value: payload })

// Target a specific block by its layout name
Magewire.dispatchTo('some.block.name', 'doSomething', { value: payload })
```

Hyvä Checkout's own address list uses `Magewire.dispatchTo()` this way to open the address form (`page/js/api/v1/alpinejs/address-view/address-list.phtml`).

The global `Magewire` JavaScript object provides `emit()` and `emitTo()` methods for emitting messages from vanilla JavaScript code.

```
// Broadcast to all listening components
Magewire.emit('doSomething', {value: payload})

// Target a specific block by its layout name
Magewire.emitTo('some.block.name', 'doSomething', {value: payload})
```

## Magento Event Interop for Emit Messages

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Magewire 3 does **not** dispatch a Magento event for each Magewire event. It only re-dispatches a fixed set of its own lifecycle events as Magento observer events named `magewire_on_<event>` (for example `magewire_on_mount` or `magewire_on_render`). See [Magento Observer Events](https://docs.magewirephp.nl/pages/advanced/architecture/observer-events.html) in the Magewire 3 docs.

When Magento observers need to react to your component, dispatch a Magento event yourself next to the Magewire event. Hyvä Checkout 3.x does exactly that in `ShippingDetails\AddressList`, where Checkout 1.x relied on the automatic `magewire_shipping_address_activated` event:

```
private function dispatchShippingAddressActivated(int|string|null $id): void
{
    // Tell listening Magewire components
    $this->dispatch('shipping_address_activated', id: $id);

    // Tell Magento observers
    $this->eventManager->dispatch('hyva_checkout_shipping_address_activated', ['id' => $id]);
}
```

Observers of `magewire_shipping_address_activated` keep running while the v1bc module is enabled. Move them to `hyva_checkout_shipping_address_activated` before you disable it.

`magewire_<name>` events while v1bc is enabled

While the v1bc module is enabled, every event a component emits or dispatches, including those of Hyvä Checkout's own components, also fires the Magento event `magewire_<name>`, with the payload plus a Magewire 1 `meta_data` object, so 1.x observers keep working. Without v1bc, none do. Use an explicit Magento event in new code.

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

The same applies to `dispatch()->to()` and `$dispatchTo()` on Magewire 3.

## Listening to Magewire Emit Messages in JavaScript

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

The global `Magewire` JavaScript object provides a `Magewire.on()` method for subscribing to Magewire events from JavaScript. On Magewire 3, the callback receives the event payload as **one object**, so read the named keys from it. Register the listener in a `magewire:init` event listener, so it is in place before the components start.

The following example listens for a `foo` event and logs the `bar` key from the event payload:

```
document.addEventListener('magewire:init', () => {
    Magewire.on('foo', ({ bar }) => {
        console.log(bar);
    });
}, { once: true });
```

Hyvä Checkout itself listens this way, for example `Magewire.on('payment_method_selected', event => ... event.method)` in `page/js/api/v1/init-payment.phtml`. Broadcast Magewire 3 events are also regular browser events that bubble up to `window`, so `window.addEventListener('foo', event => console.log(event.detail.bar))` works too. See [Events](https://docs.magewirephp.nl/pages/essentials/events.html#browser-listeners) in the Magewire 3 docs.

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
