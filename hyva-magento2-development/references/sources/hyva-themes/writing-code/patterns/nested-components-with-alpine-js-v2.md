<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/nested-components-with-alpine-js-v2.html -->

# Nested Components with Alpine.js v2

In Alpine v3 components can access the parent scope

In Alpine.js v3 nested components have [access to the parent scope](https://alpinejs.dev/directives/data#scope), but in v2 the outer scope is not accessible.

Sometimes Alpine.js components needs to be nested inside another component, where the inner component needs access to state of the outer component.

Most commonly this happens during iteration.

In the following are examples of different approaches working around this limitation.

All the examples iterate over some objects, and for each item a new Alpine.js component is rendered inside a `<template x-for="…">` loop.

Choose the most appropriate approach for the problem at hand.

## Storing shared state on a parent element data attribute

This approach uses the DOM to store the shared data. It probably is the simplest solution, and if it works for your use case, we suggest you follow this pattern.

```
<script>
    'use strict';
    function initDatasetExample() {
        return {
            items: [
                {sku: 'Item A', price: 10, isSalable: true},
                {sku: 'Item B', price: 7, isSalable: true},
                {sku: 'Item C', price: 5, isSalable: false},
            ]
        };
    }
</script>
<div x-data="initDatasetExample()">
    <h2>Nested Components with dataset</h2>
    <template x-for="item in items">
        <div :data-item="JSON.stringify(item)">
            <div x-data="{open: false, item: null}"
                 x-init="item = JSON.parse($el.parentElement.dataset.item)">
                <button type="button" class="btn" @click="open = !open" x-text="`Show ${item.sku}`"></button>
                <template x-if="open">
                    <table class="my-4">
                        <tr>
                            <th class="text-left">SKU</th>
                            <td x-text="item.sku"></td>
                        </tr>
                        <tr>
                            <th class="text-left">Price</th>
                            <td x-text="hyva.formatPrice(item.price)"></td>
                        </tr>
                        <tr>
                            <th class="text-left">Salable?</th>
                            <td x-text="item.isSalable ? 'In Stock' : 'Out of Stock'"></td>
                        </tr>
                    </table>
                </template>
            </div>
        </div>
    </template>
</div>
```

## Sharing state with events

This approach uses the single threaded nature of JavaScript for userland code to assign consecutive values to nested components.

You can tweak this solution to handle updates to the shared state within the parent component.

```
<script>
    'use strict';

    function initEventsExample() {
        return {
            items: [
                {sku: 'Item D', price: 10, isSalable: true},
                {sku: 'Item E', price: 7, isSalable: true},
                {sku: 'Item F', price: 5, isSalable: false},
            ]
        };
    }
</script>
<div x-data="initEventsExample()">
    <h2>Nested Components with events</h2>
    <div class="prose">This solution uses the single threaded nature of JavaScript to assign consecutive values</div>
    <template x-for="item in items">
        <div>
            <div x-data="{open: false, item: {}, receiveItem($event) {
                if (! this.item.sku) {
                    this.item = $event.detail.item;
                    $event.stopPropagation();
                }
            }}"
                 @next-item.window="receiveItem($event)">
                <button type="button" class="btn" @click="open = !open" x-text="`Show ${item.sku}`"></button>
                <template x-if="item && open">
                    <table class="my-4">
                        <tr>
                            <th class="text-left">SKU</th>
                            <td x-text="item.sku"></td>
                        </tr>
                        <tr>
                            <th class="text-left">Price</th>
                            <td x-text="hyva.formatPrice(item.price)"></td>
                        </tr>
                        <tr>
                            <th class="text-left">Salable?</th>
                            <td x-text="item.isSalable ? 'In Stock' : 'Out of Stock'"></td>
                        </tr>
                    </table>
                </template>
            </div>
            <div x-text="$dispatch('next-item', {item: item})"></div>
        </div>
    </template>
</div>
```

## Sharing state through a global variable

This solution uses a global state object and the array based ordering of items to access the right records.

It can also work well in cases where the shared state is modified and needs to still be accessible by both the parent and the child component.

```
<script>
    'use strict';
    function initGlobalExample() {
        if (! window.globalSharedStateExample) {
            window.globalSharedStateExample = {};
        }

        window.globalSharedStateExample.items = [
            {sku: 'Item G', price: 10, isSalable: true},
            {sku: 'Item H', price: 7, isSalable: true},
            {sku: 'Item I', price: 5, isSalable: false},
        ];
        return {
            items: window.globalSharedStateExample.items
        };
    }
</script>
<div x-data="initGlobalExample()">
    <h2>Nested Components with global state</h2>
    <template x-for="item in items">
        <div x-data="{open: false, item: {}}"
            <?php // previous siblings: <h2> and <template>. We subtract 2 to get array index for current item ?>
             x-init="item = window.globalSharedStateExample.items[Array.from($el.parentElement.children).indexOf($el) -2]">
            <button type="button" class="btn" @click="open = !open" x-text="`Show ${item.sku}`"></button>
            <template x-if="open">
                <table class="my-4">
                    <tr>
                        <th class="text-left">SKU</th>
                        <td x-text="item.sku"></td>
                    </tr>
                    <tr>
                        <th class="text-left">Price</th>
                        <td x-text="hyva.formatPrice(item.price)"></td>
                    </tr>
                    <tr>
                        <th class="text-left">Salable?</th>
                        <td x-text="item.isSalable ? 'In Stock' : 'Out of Stock'"></td>
                    </tr>
                </table>
            </template>
        </div>
    </template>
</div>
```

## Calling parent scope methods

This is simple with events.

```
<script>
    'use strict';

    function initMethodCallExample() {
        return {
            counter: 0,
            count() {
                this.counter++;
            },
            items: [
                {sku: 'Item J', price: 10, isSalable: true},
                {sku: 'Item K', price: 7, isSalable: true},
                {sku: 'Item L', price: 5, isSalable: false},
            ]
        };
    }
</script>
<div x-data="initMethodCallExample()" @count="count()">
    <h2>Calling parent component methods</h2>
    <div class="prose">This solution uses custom events to trigger parent component methods</div>
    <template x-for="item in items">
        <div>
            <table class="my-4">
                <tr>
                    <th class="text-left">SKU</th>
                    <td x-text="item.sku"></td>
                </tr>
                <tr>
                    <th class="text-left">Price</th>
                    <td x-text="hyva.formatPrice(item.price)"></td>
                </tr>
                <tr>
                    <th class="text-left">Salable?</th>
                    <td x-text="item.isSalable ? 'In Stock' : 'Out of Stock'"></td>
                </tr>
            </table>
        </div>
        <div x-data>
            <button type="button" @click="$dispatch('count')">Count from nested component</button>
        </div>
    </template>
</div>
```
