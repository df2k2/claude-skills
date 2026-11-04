<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/avoid-conflicting-state-between-alpine-components.html -->

# Avoid conflicting state between Alpine Components

In Hyvä, declaring functions in global scope is mainly used for initializing Alpine.js components.

### Avoid conflict prone names

When declaring global names, the first rule is to think of a name that is not likely to cause conflicts.

For example `init()` is not very good. In fact, `init()` is quite bad.
The name `myCompanyMyModuleThisComponentInit()` is a lot less likely to create conflicts.

### Initializing component state

Alpine.js initialization methods return objects.

The returned state is usually not shared, so it could be reused by multiple Alpine.js components, (for example if a selection of products being rendered on a page).

---

For example:

```
<script>
    function initMyComponent() {
        return {
            isVisible: true,
            toggleVisibility() {
                this.isVisible = ! this.isVisible;
            }
        };
    }
</script>

<h2 x-data="initMyComponent()">
    <button @click="toggleVisibility">A</button>
    <span x-show="isVisible">AAA</span>
</h2>
<h2 x-data="initMyComponent()">
    <button @click="toggleVisibility">B</button>
    <span x-show="isVisible">BBB</span>
</h2>
```

So far all is correct. Each of the two components has its own state object and can change its visibility independently of the other.

### Using a unique method name suffix

This becomes a bit more tricky when different data is used for each of the component instances, for example a product ID.

One way to avoid conflicts is to specify a unique method name suffix for each component:

```
<?php $uniqueId = uniqid(); ?>
<script>
    function initMyComponent_<?= $uniqueId ?>() {
        return {
            productId: <?= $product->getId() ?>,
            // more code
        };
    }
</script>
<div x-data="initMyComponent_<?= $uniqueId ?>()">
   more code
</div>
```

In this case the returned object contains the specific state for each component, because PHP is used to render it directly inside the return value.

Warning

Use unique components with caution as they inflate the DOM size through duplication. You should only use them when
absolutely necessary.

### Passing values to the initialization function

An alternative good approach is to pass the instance specific data as an argument to the initialization method:

```
<script>
    function initMyComponent(config) {
        return {
            productId: config.productId,
            // more code
        };
    }
</script>
<div x-data="initMyComponent({productId: <?= $product->getId() ?>})">
   more code
</div>
```

This allows the initialization function to be re-used with different values.

If there is a lot of shared code in the function, then it probably is better to choose the last approach, because the function only needs to be rendered once.

If the code mainly contains item specific values, then either approach is fine.
