<!-- source: https://docs.hyva.io/hyva-checkout/magewire/alpine-js.html -->

# Interacting with Magewire Components Using Alpine.js

Livewire and Alpine.js were both created by Caleb Porzio, so they play together beautifully. Magewire (the Magento port of Livewire) brings that same tight integration to Hyvä Checkout, giving you a convenient bridge between server-side PHP components and client-side Alpine.js behavior.

## Accessing the Magewire Component with `$wire` in Alpine.js

A `$wire` property is automatically available on any Alpine.js component that lives inside a Magewire component. The `$wire` object represents the Magewire component itself, and you can use it to read and write PHP component properties, call component methods, and entangle Alpine state with server-side state.

## Reading Magewire Properties from Alpine.js

You can read Magewire component properties from Alpine.js using the `$wire.get()` method. Pass the property name as a string argument.

```
<!-- Read the Magewire property "foo" and log its value -->
<button @click="console.log($wire.get('foo'))">What is foo?</button>
```

## Writing Magewire Properties from Alpine.js

You can set any Magewire component property from Alpine.js using either direct assignment on `$wire` or the `$wire.set()` method. Both approaches trigger a server roundtrip to sync the value.

```
// Direct assignment - sets "foo" to "bar" on the Magewire component
$wire.foo = 'bar';

// Equivalent using the set() method
$wire.set('foo', 'bar');
```

## Linking Magewire and Alpine.js Properties with Entanglement

Magewire supports linking an Alpine.js component property to a Magewire component property so they stay in sync automatically. Whenever one side updates the value, the other side reflects the change. This feature is called **entanglement**, and you enable it with the `$wire.entangle()` method.

You call `$wire.entangle()` individually for each property you want to link. The method accepts the Magewire property name as a string argument.

### Magewire Entanglement PHP Component

Here is a simple Magewire component with a single property `$foo` that will be entangled with Alpine.js state.

```
class Example extends \Magewirephp\Magewire\Component
{
    public $foo = 0;
}
```

### Magewire Entanglement Template

The following template shows three different ways to update the entangled `foo` value - through Alpine.js directly, through the `$wire` magic property, and through a Magewire `wire:click` directive.

```
<div x-data="{ foo: $wire.entangle('foo') }">
    <!-- Update "foo" from Alpine.js - client updates instantly, server syncs after -->
    <button type="button" class="btn" @click="foo = foo + 1">Inc +1</button>

    <!-- Update "foo" via $wire - triggers a Magewire server roundtrip -->
    <button type="button" class="btn" @click="$wire.foo = foo + 2">Inc +2</button>

    <!-- Update "foo" via Magewire wire:click directive -->
    <button type="button" class="btn" wire:click="$set('foo', 0)">Reset</button>

    <div>Client side rendered: <span x-text="foo"></span></div>
    <div>Server side rendered: <?= /** @noEscape */ $magewire->foo ?></div>
</div>
```

When you click the **Inc +1** button, the client-side rendered value updates instantly through Alpine.js, and the server-side rendered value follows once the Magewire Ajax request completes.

The **Inc +2** and **Reset** buttons both use Magewire to mutate the property, so both values on screen update at the same time once the Magewire Ajax roundtrip finishes.

When to use entanglement in Hyvä Checkout

Entanglement is especially useful in Hyvä Checkout when you need Alpine.js to react instantly to user input while still persisting state on the server - for example, toggling a shipping option or updating a quantity field.

## Calling Magewire Component Methods from Alpine.js

You can call Magewire component methods from Alpine.js in two ways: call the method directly on `$wire`, or pass the method name as a string to `$wire.call()`.

```
<div x-data @click.window="$wire.track(Date.now())">

    <div>...other content...</div>

    <!-- Call the "interaction" method, passing the element's data-id attribute -->
    <div @touchstart="$wire.call('interaction', $event.target.dataset.id)" data-id="foo">
        ...even more content...
    </div>
</div>
```

Avoid high-frequency method calls

The `@click.window` example above is intentionally extreme - don't do this in practice. Each `$wire` method call triggers a server roundtrip, so binding to high-frequency events like window clicks will flood the server with requests.

Magewire method calls return a Promise without a meaningful value

All method calls on a Magewire component return a Promise that resolves when the server roundtrip completes. However, the Promise does not resolve to a meaningful value - the return value of the PHP method is not passed back. Use Magewire properties or entanglement to get data back to Alpine.js after a method call.
