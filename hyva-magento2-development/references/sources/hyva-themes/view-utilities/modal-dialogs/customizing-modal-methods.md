<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/customizing-modal-methods.html -->

# Customizing Modal methods

Pre-1.5.0 only

The techniques on this page apply to the legacy modal system only. Since Hyvä 1.5.0 the modal is built on the native HTML `<dialog>` element and [`x-htmldialog`](../../working-with-alpinejs/alpine-plugins/x-htmldialog.html). There is no longer a shared `hyva.modal()` function to patch. To run custom logic on open or close, add your own Alpine.js event handlers directly on the `<dialog>` element or its parent `x-data` component.

You might want to trigger some custom logic when specific modal methods like `show` or `hide` are called.

This can be done for specific instances of a modal or for all instances.
The principle is always the same:

1. Get the original method and store it in a reference variable
2. Create a new function, that uses the reference to all the original function
3. Add the custom logic to the new function
4. Assign the new function in place of the original function

## Customizing a modal method for a specific instance

For example, to add custom logic to a modals `hide` method:

```
<div x-data="{...hyva.modal(), init() {
    const origHide = this.hide;
    this.hide = (value) => {
        // custom logic here
        return origHide.call(this, value);
    }
}}">
```

Here the `hide` method for the modal instance is wrapped in a custom function within the `init` method.

## Customizing a modal method for all instances

There are use-cases where *every* modal should trigger some custom code when one of its methods is called.
To make this work, two functions need to be wrapped:

1. The `hyva.modal()` function is wrapped to return a modified modal instance
2. The target modal instance method is wrapped to run the custom code

In the following example, the `hide` method is wrapped for all modal instances.
This code needs to be rendered on the page **after** the original `hyva.modal` code. This can be done using the `hyva_modal.xml` layout file:

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="before.body.end">
            <block name="my-hyva-modal-patch" template="My_Module::modal-patch.phtml" after="-"/>
        </referenceContainer>
    </body>
</page>
```

The `after="-"` attribute ensures it is rendered on the page after the original code.

Then, in the template, wrap the target method:

```
<script>
    (() => {
        const originalModal = window.hyva.modal;

        window.hyva.modal = function (options) {
            const instance = originalModal(options);
            const originalHide = instance.hide;
            instance.hide = function(value) {
                // custom code here
                return originalHide.call(this, value);
            }
            return instance;
        }
        window.hyva.modal.eventListeners = originalModal.eventListeners;
        window.hyva.modal.excludeSelectorsFromFocusTrap = originalModal.excludeSelectorsFromFocusTrap;
        window.hyva.modal.pop = originalModal.pop;
    })()
</script>
```

Note that references to any additional non-default properties are also set on the new `window.hyva.modal` wrapper function.

## Using a JavaScript Proxy to wrap modal methods

The above examples capture references to the original methods using explicit references like `const original = this.hide`.
This approach works well and is explicit about what is happening.

JavaScript provides a helper class called `Proxy` which makes this capturing implicit, and can lead to more concise code.
It may or may not be more understandable, depending on the familiarity of the reader with JavaScript.

One big benefit is that it automatically keeps references to non-default properties intact, like `eventListeners` and `pop` in the previous example.

The following example does the same as the above, except that a JavaScript Proxy is used to wrap the `hyva.modal` function, and another Proxy is used to wrap the `hide` method.

```
// wrap hyva.modal function in a Proxy
window.hyva.modal = new Proxy(window.hyva.modal, {

  // declare function interceptor on the proxy handler object
  apply(target, objContext, args) {

    // call original hyva.modal function
    const instance = target.apply(objContext, args);

    // wrap instance hide method in a Proxy
    instance.hide = new Proxy(instance.hide, {

      // declare function interceptor on the proxy handler object
      apply(target, objContext, args) {

        // custom code here

        // call original hide function
        return target.apply(objContext, args);
      }
    });
    return instance;
  }
});
```

There are two different `apply` in the above code

1. `target.apply(objContext, args)` calls the original function using [`Function.prototype.apply`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply).
2. `apply(target, objContext, args)` declares a [Proxy handler `apply` method](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/Proxy/apply) to intercept function calls on the original.

(I think this is a part of JavaScript where the naming could be better.)

For more information please refer to the [MDN Proxy documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy).
