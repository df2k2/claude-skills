<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/communication-between-alpine-components.html -->

# Communication between Alpine Components

In Hyvä, data is often sent from one component to another with events.

## Dispatching events between Alpine.js components

You can easily dispatch events from one component to another in Alpine.js

Here’s a simple event called `name-changed` that is being dispatched when you click one of the links.

```
<div x-data>
    <button @click.prevent="$dispatch('name-changed', { name: 'John Doe' })">John Doe</button>
    <button @click.prevent="$dispatch('name-changed', { name: 'Jane Doe' })">Jane Doe</button>
</div>
```

This dispatches native browser events that you can listen to in multiple ways.

An Alpine component listens to an event as follows:

```
<script>
    function initComponent() {
        return {
             name: "unknown",
             handleNameChange(event) {
                 this.name = event.detail.name
             }
        }
    }
</script>

<div x-data="initComponent()" @name-changed.window="handleNameChange(event)">
    <span x-text="`Name is: ${name}`"></span>
</div>
```

Alternatively, if you have multiple events for one component, you could use `x-bind` (or `x-spread` for Alpine.js v2) to move them to the component initialization method:

```
<script>
    function initComponent() {
        return {
            name: "unknown",
            handleNameChange(event) {
                this.name = event.detail.name
            },
            eventListeners: {
                ['@keydown.window.escape'](){
                    console.log('escape key was hit');
                },
                ['@name-changed.window'](event){
                    this.handleNameChange(event);
                }
            }
        }
    }
</script>

<div x-data="initComponent()" x-bind="eventListeners">
    <span x-text="`Name is: ${name}`"></span>
</div>
```

With native JavaScript, you could listen for the event like this:

```
window.addEventListener('name-changed', function(event) {
    console.log('name changed to:', event.detail.name);
});
```

This is also an excellent way to debug events in your browser console.

The same way you can test triggering the event from the browser console:

```
window.dispatchEvent(new CustomEvent('name-changed', {detail: { name: 'Test Event' }}));
```

Tip

Try it for yourself, triggering the following event from the browser console will open the cart on any Hyvä page (with items in your cart).

```
window.dispatchEvent(new Event('toggle-cart'));
```
