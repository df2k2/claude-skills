<!-- source: https://docs.hyva.io/hyva-themes/compatibility-modules/from-luma-to-hyva/migrating-js-and-templates.html -->

# Migrating Luma JavaScript and Templates

This guide covers common patterns for converting Luma-based JavaScript and templates to modern, Alpine.js-based Hyvä components.

## From `data-mage-init` and `require()` to Inline Scripts

In contrast to Luma where scripts tend to be small external files loaded via `data-mage-init` or `require()`, most JavaScript in Hyvä is inlined within `.phtml` templates. This makes templates self-contained, reusable UI components and helps improve page speed.

### Process for Inlining Scripts

1. **Declare a new function** in a `<script>` tag within your `.phtml` template. To avoid global scope conflicts, give it a unique name.

   ```
   <script>
       function initMyComponent() {
           // ...
       }

       document.addEventListener('alpine:init', () => {
           Alpine.data('initMyComponent', initMyComponent)
       });
   </script>
   ```
2. **Copy the contents** of the original RequireJS module into this new function.
3. **Replace dependencies**. Most of the time, dependencies on libraries like jQuery can be removed and replaced with native JavaScript. Sometimes this may require inlining another external script.
4. **Call the new function**. The timing depends on the script's dependencies:

   - If the code depends on **customer section data**, call it as a `private-content-loaded` event subscriber.
   - If the code is in the page header and depends on the global `window.hyva` object, call it as a `DOMContentLoaded` event subscriber to ensure `hyva` is defined.
   - Otherwise, you can usually call the function inline right after its definition.

## From `x-magento-template` to Alpine.js `x-for`

Luma often uses `<script type="text/x-magento-template">` tags, processed by `mage/template` and `underscore.js`, to render arrays of data into the DOM. Since Hyvä does not use these libraries, these are replaced with Alpine.js templates, typically using the `x-for` directive.

### Rendering Array Items with Alpine.js

In Alpine.js, `x-for` is the primary tool for iterating over arrays and rendering DOM elements.

```
<ul class="bundle items">
    <template x-for="option in selectedOptions">
        <li class="mb-2" x-show="option.products.length">
            <span class="text-base font-semibold" x-html="option.label"></span>
            <template x-for="product in option.products">
                <div><span x-html="product.qty"></span> x <span x-html="product.name"></span></div>
            </template>
        </li>
    </template>
</ul>
```

To access the index of the current iteration, use the `(item, index)` syntax:

```
<template x-for="(product, index) in products" :key="index">
    <!-- ... -->
</template>
```

For more details, see the [Alpine.js `x-for` documentation](https://alpinejs.dev/directives/for).

## From jQuery `data()` to Native `dataset`

jQuery's `$(selector).data()` function is often used to read `data-*` attributes. It has unique behaviors, like caching values and auto-parsing JSON. When converting to vanilla JavaScript, these behaviors must be replicated manually if needed.

The native equivalent is the `element.dataset` property. The key difference is that `dataset` provides a live view of the attributes; if the attribute is removed from the DOM, the value is gone.

### Reading Data Attributes

Assume the following element: `<div id="my-id" data-example='{"name": "Alice"}'></div>`

**jQuery Way:**

```
// jQuery reads, parses, and caches the value.
$('#my-id').data('example');
```

**Native JavaScript / Alpine.js Way:**
If you need to cache the value (for example, before removing the attribute), you must do so manually. A common pattern is to store it on a custom property of the element itself.

```
const element = document.getElementById('my-id');

// Manually parse JSON and store it on a custom property
element.__example = JSON.parse(element.dataset.example);

// The value is now cached even if the attribute is removed
element.removeAttribute('data-example');
console.log(element.__example); // => {name: "Alice"}
```

## Native Equivalents for Underscore Functions

This is a small collection of native JavaScript equivalents for common Underscore.js utility functions.

| Underscore | Native JavaScript Equivalent |
| --- | --- |
| `_.isObject(x)` | `const isObject = x => x === Object(x);` |
| `_.isArray(x)` | `Array.isArray(x)` |
| `_.has(x, p)` | `const has = (x, p) => x === Object(x) && x.hasOwnProperty(p);` |
| `_.isEqual(x, y)` | `JSON.stringify(x) === JSON.stringify(y)` (for simple objects/arrays) |

## Native Equivalents for jQuery Functions

For most jQuery functions, a native JavaScript equivalent exists. Instead of maintaining a list here, we recommend the comprehensive guide at:

[**You Might Not Need jQuery**](http://youmightnotneedjquery.com/)
