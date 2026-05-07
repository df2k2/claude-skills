# Alpine.js Components in Hyvä (Standard, Non-CSP)

## When to read this

You're writing Alpine.js v3 components for a Hyvä storefront that's **not** running strict CSP. (For CSP-strict themes — `Hyva/default-csp` or any payment page — read `alpine-csp.md` instead.)

## What Alpine replaces

In Luma:
```html
<div data-bind="visible: isOpen, click: toggle">…</div>
<script type="text/x-magento-init">{"*":{"Vendor_Module/js/component":{"foo":"bar"}}}</script>
```

In Hyvä:
```html
<div x-data="{ isOpen: false }" x-show="isOpen" @click="isOpen = !isOpen">…</div>
```

That's it. No RequireJS, no Knockout, no UI components, no `text!*` plugin.

## Where to put Alpine code

Inline in `.phtml` is the **default** and **idiomatic** choice. You can put initialization logic in a separate JS file if it's reused, but most components live next to the markup they control.

```php
<?php /** @var \Magento\Framework\Escaper $escaper */ ?>

<div x-data="initFaq()" class="faq">
    <template x-for="(item, index) in items" :key="index">
        <div class="border-b py-4">
            <button
                type="button"
                @click="toggle(index)"
                class="w-full text-left flex justify-between"
                :aria-expanded="open === index"
            >
                <span x-text="item.q"></span>
                <span x-text="open === index ? '−' : '+'"></span>
            </button>
            <div x-show="open === index" x-collapse class="mt-2 text-gray-700" x-text="item.a"></div>
        </div>
    </template>
</div>

<script>
    function initFaq() {
        return {
            open: null,
            items: <?= /* @noEscape */ json_encode($block->getFaqItems(), JSON_THROW_ON_ERROR) ?>,
            toggle(i) { this.open = this.open === i ? null : i; },
        };
    }
</script>
```

A few things to notice:
- `x-data="initFaq()"` calls a global function rather than embedding state inline. This keeps complex components readable.
- The PHP-supplied `items` is JSON-encoded and dropped in *unescaped* (`/* @noEscape */` annotation). `json_encode` already produces safe JS.
- For string fields you control via PHP, use `$escaper->escapeJs(...)` inside a JS string literal:
  ```js
  const greeting = '<?= $escaper->escapeJs($block->getGreeting()) ?>';
  ```

## When to use inline `x-data="{ … }"` vs. an init function

Inline state object — fine for trivial toggles:
```html
<div x-data="{ open: false }">
    <button @click="open = !open">Toggle</button>
    <div x-show="open">…</div>
</div>
```

Init function — preferred when:
- You have multiple methods
- You read PHP-supplied data
- You listen to events
- You want to test the component logic separately

```html
<div x-data="initSearch()" @keydown.escape.window="close()">…</div>
<script>
function initSearch() {
    return {
        query: '',
        results: [],
        async search() {
            const r = await fetch('/api/search?q=' + encodeURIComponent(this.query));
            this.results = await r.json();
        },
        close() { this.query = ''; this.results = []; }
    };
}
</script>
```

## Common directives

| Directive | What it does |
| --- | --- |
| `x-data="…"` | Define component scope (state + methods) |
| `x-show="cond"` | Toggle `display: none` |
| `x-if="cond"` (in `<template>`) | Conditionally render the children |
| `x-for="item in items"` (in `<template>`) | Loop |
| `x-text="expr"` | Set `textContent` |
| `x-html="expr"` | Set `innerHTML` (avoid for user content) |
| `x-model="state.field"` | Two-way bind to an input |
| `x-bind:attr="expr"` or `:attr="expr"` | Set an attribute |
| `x-on:event="expr"` or `@event="expr"` | Listen to a DOM event |
| `x-init="…"` | Run when component initializes |
| `x-effect="…"` | Run when reactive deps change |
| `x-ref="name"` | Reference DOM via `$refs.name` |
| `x-collapse` (Alpine plugin, ships with Hyvä) | Animate height |
| `x-cloak` | Hide element until Alpine initializes (style with `[x-cloak]{display:none}` in CSS) |
| `x-transition` | Apply enter/leave animations |

## Event modifiers

```html
<button @click.prevent="submit()">…</button>
<input @keydown.enter="search()">
<div @click.outside="close()">…</div>
<div @custom-event.window="handle($event.detail)">…</div>
<div @click.once="trackOnce()">…</div>
<div @click.stop="…">…</div>
<input @input.debounce.300ms="search()">
```

`.window` is essential for listening to global Hyvä events (see `javascript-events.md`).

## Listening to Hyvä events

```html
<!-- Receive customer data -->
<div x-data="{ customer: false }"
     @private-content-loaded.window="customer = $event.detail.data.customer">
    <template x-if="customer">
        <span>Hi <span x-text="customer.firstname"></span></span>
    </template>
</div>

<!-- Open the mini-cart -->
<button @click="$dispatch('toggle-cart')">View cart</button>

<!-- Force section data reload -->
<button @click="$dispatch('reload-customer-section-data')">Refresh</button>
```

Alpine's `$dispatch` dispatches a `CustomEvent` from the current element. Use `.window` modifiers when you need to dispatch to or listen on the window.

## Lifecycle: when is Alpine ready?

`window.addEventListener('alpine:init', …)` — fired before any `x-data` is processed. Use to register custom directives, magic properties, or `Alpine.data` definitions (CSP-only requirement, but allowed everywhere).

`window.addEventListener('alpine:initialized', …)` — fired after all components on the page have initialized.

For broader compatibility (works the same in Alpine v2 and v3), Hyvä provides:
```js
hyva.alpineInitialized(() => {
    // runs once after Alpine is initialized
});
```

This is preferable over `DOMContentLoaded` for component setup, especially on cached pages in mobile Safari where Alpine might initialize after `DOMContentLoaded`.

## Using `$el`, `$refs`, `$root`, `$watch`

```html
<div x-data="{ count: 0 }">
    <button x-ref="btn" @click="count++">+</button>
    <span x-text="count"></span>
    <button @click="$refs.btn.focus()">Focus the button</button>

    <!-- Watch a property -->
    <div x-init="$watch('count', value => console.log('count is', value))"></div>

    <!-- $el is the current element, $root is the x-data root -->
</div>
```

## Persisted state

Alpine ships a Persist plugin in Hyvä. To keep state across page loads:

```html
<div x-data="{ acceptedNewsletter: $persist(false) }">
    <input type="checkbox" x-model="acceptedNewsletter">
</div>
```

Stored in `localStorage` by default. Pass an alias if you want to share across components: `$persist(false).as('newsletter-opted-in')`.

## Toast/message dispatching

Hyvä's message component listens for `dispatchMessages`:

```js
window.dispatchMessages([
    { type: 'success', text: 'Saved!' },
    { type: 'warning', text: 'Stock low' }
], 5000); // ms
```

Types: `success`, `notice`, `warning`, `error`. The `5000` is the auto-dismiss timeout. Use `0` or omit for no auto-dismiss.

## Patterns to avoid

### Don't use `eval`-y inline expressions for non-trivial logic
Long expressions inside `x-show` or `@click` are hard to read and impossible to debug. Move logic into an init function.

### Don't fetch data on `x-init` without a guard
`x-init` runs once — but it runs synchronously during component setup. If your init does an expensive `fetch`, the page paints before data arrives. Use a loading state:

```html
<div x-data="{ items: null }" x-init="fetch('/api').then(r => r.json()).then(d => items = d)">
    <div x-show="items === null">Loading…</div>
    <template x-if="items">
        <ul>
            <template x-for="i in items" :key="i.id">
                <li x-text="i.name"></li>
            </template>
        </ul>
    </template>
</div>
```

### Don't break Alpine reactivity by replacing arrays/objects in-place
Alpine wraps state in a Proxy. Mutating sub-properties is fine; reassigning the whole field is fine. But pushing into an array reference held outside Alpine doesn't trigger updates — always mutate via `this.items.push(...)` inside an Alpine method.

### Don't forget `x-cloak`
Without it, you'll see flash-of-unstyled-content while Alpine initializes. Hyvä already includes `[x-cloak] { display: none !important; }` in its base CSS, but you have to add the attribute:

```html
<div x-data="{ open: false }" x-show="open" x-cloak>…</div>
```

### Don't dispatch events at the wrong scope
`$dispatch('foo')` dispatches from the current element — listeners need to be ancestors or use `.window`. To dispatch globally:
```js
window.dispatchEvent(new CustomEvent('foo', { detail: payload }));
```

## Plugins available in Hyvä

The Hyvä Default Theme includes Alpine plugins:
- `@alpinejs/intersect` — `x-intersect` (lazy-load, fire on scroll-into-view)
- `@alpinejs/persist` — `$persist` (localStorage state)
- `@alpinejs/focus` — `x-trap`, `$focus` (focus management for modals)
- `@alpinejs/collapse` — `x-collapse` (animated height)
- `@alpinejs/morph` — DOM morphing (used by some integrations)

Add custom plugins via the theme's `requirejs`-free loading: register an additional script in your layout XML. Alpine plugins must be loaded **before** Alpine itself initializes — set them up on `alpine:init`.

## Debugging

- The Alpine.js DevTools browser extension (alpinejs.pro) is the best way to inspect component state.
- Alpine logs its errors to the console with the offending element. Check the console first.
- `console.log` works fine inside any Alpine expression: `@click="console.log($event); doThing()"`.
- For state, drop a `<pre x-text="JSON.stringify($data, null, 2)"></pre>` inside the component — temporary but very effective.

## Original sources

- `references/sources/hyva-themes/working-with-alpinejs/index.md` — overview & official version map
- `references/sources/hyva-themes/working-with-alpinejs/editor-setup.md` — IDE intellisense setup
- `references/sources/hyva-themes/working-with-alpinejs/alpine-v2-and-v3-compatible-code.md` — writing code that works on both v2 and v3 (legacy)
- `references/sources/hyva-themes/working-with-alpinejs/alpine-plugins/` — bundled Alpine plugins (intersect, persist, focus, collapse, morph)
- `references/sources/hyva-themes/writing-code/rendering-javascript-once.md` — gotcha pattern for ensuring JS runs once
- `references/sources/hyva-themes/writing-code/window-dispatchmessages.md` — `window.dispatchMessages` reference
- For the upstream Alpine docs: [alpinejs.dev](https://alpinejs.dev) (v3) — the bundled cheat sheets aren't a substitute for the official Alpine reference
