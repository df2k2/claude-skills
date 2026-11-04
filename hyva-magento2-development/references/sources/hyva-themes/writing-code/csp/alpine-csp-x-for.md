<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-x-for.html -->

# Alpine CSP `x-for`

The syntax of the `x-for` directive as the pattern

```
x-for="[value] in [value-provider]"
```

or

```
x-for="([value], [index]) in [value-provider]"
```

With Alpine CSP, the same restrictions apply to the `value-provider` as for regular property access: the property can reference a value or a function.
If it is a function, no parentheses are written, and no arguments can be specified.

Bad Example

The following code will **not work**, because arguments are passed to the method:

```
<template x-for="(product, index) in getProducts(selected)" :key="index">
    <span :class="getItemClasses"
          @click="goToItem>
    </span>
</template>
```

However, the following code is okay. Please note the method `getProducts` is specified without parenthesis `()`.

```
    <template x-for="(product, index) in getProducts" :key="index">
            <span :class="getItemClasses"
                  @click="goToItem">
            </span>
    </template>
```

Using plain property names works, too.

```
    <template x-for="(product, index) in products" :key="index">
            <span :class="getItemClasses"
                  @click="goToItem">
            </span>
    </template>
```

The iteration value and index are available in any method called within the template:

```
goToItem() {
    return `${BASE_URL}/my/example/product/id/${this.product.id}`
}
```

## No Iterating over a range in `x-for`

Regular Alpine allows [iteration over a range](https://alpinejs.dev/directives/for#iterating-over-a-range) with the syntax `x-for="i in 10"`. With Alpine CSP this is not possible.
