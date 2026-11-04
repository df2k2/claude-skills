<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-property-mutation.html -->

# Property mutation in Alpine CSP

Mutations in Alpine attributes are common in regular Alpine:

```
<button type="button" @click="open = !open">Toggle</button>
```

This again is not possible in Alpine CSP. Instead, extract the mutation into a method:

```
<button type="button" @click="toggle">Toggle</button>
```

```
  toggle() {
    this.open = ! this.open;
  }
```

Tip

See [hyva.createBooleanObject](./alpine-csp-hyva-createbooleanobject.html) for a way to reduce this type of boilerplate code.

## Passing arguments

Passing arguments to methods called from Alpine attributes is impossible in Alpine CSP.
The alternative is using data attributes.

```
<button @click="selectItem" data-item-id="<?= (int) $item->getId() ?>">
    Select
</button>
```

```
  selectItem() {
    this.selected = this.$el.dataset.itemId;
  }
```

Alpine variables are available as properties of `this`, for example, `this.$event` can be used in any event callback.
The same is true for iteration variables declared with `x-for`.

```
<template x-for="item in items">
    <input @click.prevent="processClick"/>
</template>
```

```
processClick() {
    const value = this.$event.target.value;
    if (value === this.item.id) { // item is the x-for iteration variable
        // do something
    }
}
```
