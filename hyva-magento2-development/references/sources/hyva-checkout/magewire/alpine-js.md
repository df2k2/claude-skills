<!-- source: https://docs.hyva.io/hyva-checkout/magewire/alpine-js.html -->

# Interacting with Magewire Components Using Alpine.js

Livewire and Alpine.js were both created by Caleb Porzio, so they play together beautifully. Magewire (the Magento port of Livewire) brings that same tight integration to Hyvä Checkout, giving you a convenient bridge between server-side PHP components and client-side Alpine.js behavior.

## Accessing the Magewire Component with `$wire` in Alpine.js

A `$wire` property is automatically available on any Alpine.js component that lives inside a Magewire component. The `$wire` object represents the Magewire component itself, and you can use it to read and write PHP component properties, call component methods, and entangle Alpine state with server-side state.

Hyvä Checkout uses the Alpine.js CSP build, which does not allow inline expressions in `x-data` or event attributes. All component logic must live in named methods registered with `Alpine.data()`, and `$wire` is accessed inside those methods as `this.$wire`.

## Reading Magewire Properties from Alpine.js

Read a Magewire component property from Alpine.js using `this.$wire.get()` inside a component method. The following example reads the `label` property from the Magewire component and logs it when a button is clicked.

Magewire/Example.php

```
class Example extends \Magewirephp\Magewire\Component
{
    public string $label = 'Hello from Magewire';
}
```

Component registration script

```
<?php
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
?>
<script>
    function exampleReadProperty() {
        return {
            logLabel() {
                // Read a Magewire property by name - no Ajax request triggered
                console.log(this.$wire.get('label'));
            }
        }
    }

    window.addEventListener('alpine:init', () => {
        Alpine.data('exampleReadProperty', exampleReadProperty);
    }, { once: true });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Component template

```
<div x-data="exampleReadProperty">
    <button type="button" @click="logLabel">What is label?</button>
</div>
```

## Writing Magewire Properties from Alpine.js

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Set a Magewire component property from Alpine.js using either direct assignment on `this.$wire` or the `this.$wire.set()` method. On Magewire 3 they behave differently:

- **Direct assignment** (`this.$wire.foo = 'x'`) only updates the browser state. Magewire sends the new value with the component's next request.
- **`this.$wire.set()`** (an alias of `$set()`) updates the value and triggers a server roundtrip right away. Pass `false` as the third argument to defer it.

For components in v1 mode, the v1bc module makes direct assignment sync right away, as on Magewire 1, and the third argument of `set()` and `$set()` keeps its Magewire 1 meaning, `defer`: `false` or no third argument sends right away, `true` defers. This also applies to a native Magewire 3 component inside the checkout that doesn't opt out of v1 mode.

Set a Magewire component property from Alpine.js using either direct assignment on `this.$wire` or the `this.$wire.set()` method. Both approaches trigger a server roundtrip to sync the value with the backend.

Magewire/Example.php

```
class Example extends \Magewirephp\Magewire\Component
{
    public string $foo = 'original';
}
```

Component registration script

```
<?php
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
?>
<script>
    function exampleWriteProperty() {
        return {
            setFooDirect() {
                // Direct assignment on this.$wire
                this.$wire.foo = 'updated directly';
            },
            setFooMethod() {
                // The set() method
                this.$wire.set('foo', 'updated via set()');
            }
        }
    }

    window.addEventListener('alpine:init', () => {
        Alpine.data('exampleWriteProperty', exampleWriteProperty);
    }, { once: true });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Component template

```
<div x-data="exampleWriteProperty">
    <button type="button" @click="setFooDirect">Set via direct assignment</button>
    <button type="button" @click="setFooMethod">Set via set() method</button>
    <div>Server side rendered: <?= $magewire->foo ?></div>
</div>
```

## Linking Magewire and Alpine.js Properties with Entanglement

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Magewire supports linking an Alpine.js component property to a Magewire component property. This feature is called **entanglement**, and you enable it with the `$wire.entangle()` method.

You call `$wire.entangle()` individually for each property you want to link. The method accepts the Magewire property name as a string argument.

On Magewire 3, entanglement is **deferred** by default: server changes reach Alpine.js after every request, but an Alpine.js change is only sent with the component's next request. Chain `.live` (`this.$wire.entangle('foo').live`) to send every Alpine.js change to the server right away, like Magewire 1 did. For components in v1 mode, the v1bc module keeps the Magewire 1 behavior, so a plain `entangle()` stays live there. Decide per property which one you need: Hyvä Checkout's own coupon code component uses a deferred `this.$wire.entangle('couponApplied')`, for example. See [Upgrade](https://docs.magewirephp.nl/pages/getting-started/upgrade.html) in the Magewire 3 docs.

Magewire supports linking an Alpine.js component property to a Magewire component property so they stay in sync automatically. Whenever one side updates the value, the other side reflects the change. This feature is called **entanglement**, and you enable it with the `$wire.entangle()` method.

You call `$wire.entangle()` individually for each property you want to link. The method accepts the Magewire property name as a string argument.

### Magewire Entanglement PHP Component

Here is a simple Magewire component with a single property `$foo` that will be entangled with Alpine.js state.

Magewire/Example.php

```
class Example extends \Magewirephp\Magewire\Component
{
    public int $foo = 0;
}
```

### Magewire Entanglement Template

The following template shows three different ways to update the entangled `foo` value - through Alpine.js directly, through the `$wire` magic property, and through a Magewire `wire:click` directive.

The Alpine CSP build does not allow inline mutations in event attributes (like `@click="foo = foo + 1"`). State changes must be extracted into named methods on the component object.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Component registration script

```
<?php
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
?>
<script>
    function exampleEntangle() {
        return {
            // .live sends every Alpine.js change to the server right away
            foo: this.$wire.entangle('foo').live,
            // Alpine CSP requires mutations to be methods, not inline attribute expressions
            incByOne() {
                this.foo = this.foo + 1;
            },
            incByTwo() {
                // $set() triggers a server roundtrip
                this.$wire.$set('foo', this.foo + 2);
            }
        }
    }

    window.addEventListener('alpine:init', () => {
        Alpine.data('exampleEntangle', exampleEntangle);
    }, { once: true });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Component registration script

```
<?php
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
?>
<script>
    function exampleEntangle() {
        return {
            foo: this.$wire.entangle('foo'),
            // Alpine CSP requires mutations to be methods, not inline attribute expressions
            incByOne() {
                this.foo = this.foo + 1;
            },
            incByTwo() {
                this.$wire.foo = this.foo + 2;
            }
        }
    }

    window.addEventListener('alpine:init', () => {
        Alpine.data('exampleEntangle', exampleEntangle);
    }, { once: true });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

The template references the registered component by name and calls the named methods instead of writing inline expressions:

Component template

```
<div x-data="exampleEntangle">
    <!-- Update "foo" from Alpine.js - client updates instantly, server syncs after -->
    <button type="button" class="btn" @click="incByOne">Inc +1</button>

    <!-- Update "foo" via $wire - triggers a Magewire server roundtrip -->
    <button type="button" class="btn" @click="incByTwo">Inc +2</button>

    <!-- Update "foo" via Magewire wire:click directive -->
    <button type="button" class="btn" wire:click="$set('foo', 0)">Reset</button>

    <div>Client side rendered: <span x-text="foo"></span></div>
    <div>Server side rendered: <?= $magewire->foo ?></div>
</div>
```

When you click the **Inc +1** button, the client-side rendered value updates instantly through Alpine.js, and the server-side rendered value follows once the Magewire Ajax request completes.

The **Inc +2** and **Reset** buttons both use Magewire to mutate the property, so both values on screen update at the same time once the Magewire Ajax roundtrip finishes.

When to use entanglement in Hyvä Checkout

Entanglement is especially useful in Hyvä Checkout when you need Alpine.js to react instantly to user input while still persisting state on the server - for example, toggling a shipping option or updating a quantity field.

Move the script block to the initial page load

If the component above lives inside a Magewire template, the `<script>` block should be extracted into a separate layout block loaded during the initial page render. Scripts inside Magewire component templates are only evaluated once on the initial page load and cannot receive a nonce on subsequent Magewire updates. See [Move Scripts to Page Load](../devdocs/csp/csp-move-scripts-page-load.html) for the full pattern.

## Calling Magewire Component Methods from Alpine.js

Call Magewire component methods from Alpine.js directly on `this.$wire`, or pass the method name as a string to `this.$wire.call()`. Both trigger a server roundtrip to run the PHP method.

Because the Alpine CSP build does not allow inline expressions or method arguments in event attributes, `$wire` calls must be wrapped in named methods on the component. Use `this.$wire` to access the Magewire component and `this.$event` to access the event object inside those methods.

Magewire/Example.php

```
class Example extends \Magewirephp\Magewire\Component
{
    public function track(int $timestamp): void
    {
        // handle tracking
    }

    public function interaction(string $id): void
    {
        // handle interaction
    }
}
```

Component registration script

```
<?php
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
?>
<script>
    function exampleWireCalls() {
        return {
            trackClick() {
                // Access $wire via this.$wire inside component methods
                this.$wire.track(Date.now());
            },
            interaction() {
                // Access the event via this.$event inside event handler methods
                this.$wire.call('interaction', this.$event.target.dataset.id);
            }
        }
    }

    window.addEventListener('alpine:init', () => {
        Alpine.data('exampleWireCalls', exampleWireCalls);
    }, { once: true });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Component template

```
<div x-data="exampleWireCalls" @click.window="trackClick">

    <div>...other content...</div>

    <!-- Call the "interaction" method, passing the element's data-id attribute -->
    <div @touchstart="interaction" data-id="foo">
        ...even more content...
    </div>
</div>
```

Avoid high-frequency method calls

The `@click.window` example above is intentionally extreme - don't do this in practice. Each `$wire` method call triggers a server roundtrip, so binding to high-frequency events like window clicks will flood the server with requests.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Magewire method calls return a Promise with the PHP return value

All method calls on a Magewire component return a Promise that resolves when the server roundtrip completes. On Magewire 3, the Promise resolves to the return value of the PHP method, for example `const result = await this.$wire.call('interaction', id);`. Code that must also run on Checkout 1.x should use Magewire properties or entanglement instead.

Magewire method calls return a Promise without a meaningful value

All method calls on a Magewire component return a Promise that resolves when the server roundtrip completes. However, the Promise does not resolve to a meaningful value. The return value of the PHP method is not passed back. Use Magewire properties or entanglement to get data back to Alpine.js after a method call.
