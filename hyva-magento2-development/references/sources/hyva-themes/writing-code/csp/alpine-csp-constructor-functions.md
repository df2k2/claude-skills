<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-constructor-functions.html -->

# Alpine CSP `x-data` constructors

In regular Alpine, the component state can be initialized inline like `x-data="{open: false}"`. This is not possible in Alpine CSP, because the attribute expressions can not be evaluated.
Non-CSP Hyvä also often uses JavaScript constructor functions declared in global scope, for example `x-data="initPriceBox"`.
In Alpine CSP this also is not possible without registering the function explicitly as a constructor function first.
The value of `x-data` has to refer to a function registered with `Alpine.data()`.

```
<div x-data="initMyComponent">
    ...
</div>
<script>
    Alpine.data('initMyComponent', () => ({
        open: false
    }))
</script>
```

Be aware that the `Alpine.data` method likely is not yet available at the time the script is parsed, so it is a good idea to call it in a `alpine:init` event subscriber:

```
window.addEventListener(
    'alpine:init',
    () => Alpine.data('initMyComponent', () => ({
        open: false
    })),
    {once: true}
)
```

Hyvä uses named functions declared in global scope, so they can be proxied or wrapped, as described in [Overriding JavaScript](../patterns/overriding-js.html).

```
function initMyComponent() {
    return {
        open: false
    }
}

window.addEventListener(
    'alpine:init',
    () => Alpine.data('initMyComponent', initMyComponent),
    {once: true}
);
```

## Merging objects

In Hyvä, Alpine components are often composed of different objects using `Object.assign`:

```
<form x-data="Object.assign(hyva.modal(), hyva.formValidation($el), {myValue: ''})">
```

Since JavaScript expressions are not allowed, the merging of the objects has to be moved into a constructor function.

```
function exampleCspComponent() {
  return Object.assign(
      hyva.modal.call(this),
      hyva.formValidation(this.$el),
      {
          myValue: ''
      }
  );
}
```

If one of the composed functions expects the Alpine object context, execute it with `call()` or `assign()`, as shown in the example above for `hyva.modal.call(this)`.
