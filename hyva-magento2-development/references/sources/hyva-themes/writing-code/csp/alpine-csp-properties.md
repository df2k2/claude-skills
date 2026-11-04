<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-properties.html -->

# Component properties in Alpine CSP

In regular Alpine, component properties are evaluated as JavaScript expressions but, in Alpine CSP, they are used as "lookup keys" on the component.

This means accessing value properties works like in regular Alpine, including nested properties.

Value and Function properties

For the following content, we will distinguish properties of Alpine components as **`value` properties** and **`function` properties**:

```
const instance = {
    valueProp: 'the value',
    functionProp() {
        return 'the function return value'
    }
}
```

Function properties are also called **methods**.

## Alpine CSP value properties

Dot-notation can be used to access nested properties, just like in regular Alpine:

```
<script>
    Alpine.data('initMyComponent', () => ({
        item: {
            is_visible: true
        }
    }))
</script>
<span x-data="initMyComponent" x-show="item.is_visible"></span>
```

## Value Transformation

If a value needs to be transformed to express the desired behavior, a method on the component has to be used.

For example, in regular Alpine, a value can be prefixed with `!` to negate it, or conditions can be combined with `||` or `&&` for compound conditions.

```
<span x-show="!item.deleted"></span>

<span x-text="item.title || item.value"></span>
```

In Alpine CSP this is not possible. Instead, a method has to be added to the Alpine component.

```
<span x-show="isItemNotDeleted"></span>

<span x-text="itemLabel"></span>
```

```
return {
    isNotItemDeleted() {
      return ! this.item.deleted;
    },
    itemLabel() {
      return this.item.title || this.item.value
    }
}
```

## Function arguments

With Alpine CSP it is not possible to call a method from an attribute while passing arguments.
For example, the following won't work, as it requires the attribute value to be evaluated as a JavaScript expression:

```
<input :value="calcValue('<?= $escaper->escapeJs($block->getConfig()) ?>')">
```

The workaround is to use [dataset attributes](https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Solve_HTML_problems/Use_data_attributes). The above example could be rewritten like this:

```
<input :value="calcValue"
       data-config="<?= $escaper->escapeHtmlAttr($block->getConfig()) ?>"
>
```

In the function, the value then can be accessed with `this.$el.dataset.config`.

Be sure to change the encoding from `escapeJs` to `escapeHtmlAttr` as appropriate, as they use a different encoding, and using the wrong escaping mechanism can prevent the code from working.

## Using `!` in method names

It is possible to declare methods with a `!` prefix to indicate negation of a value. This can be very convenient, especially while converting existing regular Alpine components to be CSP-compatible:

```
return {
    deleted: false,
    ['!deleted']() {
        return ! this.deleted;
    },
}
```

This is used in directives like this:

```
<template x-if="deleted">
    <div>The item is deleted</div>
</template>
<template x-if="!deleted">
    <div>The item is present</div>
</template>
```
