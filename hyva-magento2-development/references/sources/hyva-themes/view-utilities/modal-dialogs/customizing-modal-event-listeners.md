<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/customizing-modal-event-listeners.html -->

# Customizing Modal Event Listeners

Pre-1.5.0 only

The techniques on this page apply to the legacy modal system only. Since Hyvä 1.5.0 the modal is built on the native HTML `<dialog>` element. Click-outside and ESC key handling are managed by the browser natively and are no longer exposed as JavaScript event listeners.
To customize close behaviour on a 1.5.0 modal, use the `withCloseby()` method on the PHP view model or the [`x-htmldialog`](../../working-with-alpinejs/alpine-plugins/x-htmldialog.html) Alpine directive directly. For more advanced control, write your own event listeners on the `<dialog>` element.

It is possible to customize `click` and `keydown` event listener callbacks for modals.

Available since 1.1.13

In older releases of *`Hyva_Theme`* the callbacks were not exposed globally and could not be customized without overriding the `page/js/modal.phtml` Hyva\_Theme template.
If you are using an older version, be sure to upgrade the theme module.

At the time of writing, the two callbacks are globally available as

- `window.hyva.modal.eventListeners.click`
- `window.hyva.modal.eventListeners.keydown`

For example, to remove the modal click-away event listener, the following code can be used:

```
document.removeEventListener('click', window.hyva.modal.eventListeners.click)
```

One common use case is to create modals with a backdrop overlay, but prohibit closing the modal by clicking outside or hitting the ESC key.

## Wrapping the event listeners

This example wraps the `keydown` event in a way that it could also be further extended by other code:

```
(function () {
    // store reference to the original event subscriber function
    const originalListener = window.hyva.modal.eventListeners.keydown;
    // remove the original event subscriber
    document.removeEventListener('keydown', originalListener);
    // declare the new event subscriber function on the global window.hyva.modal.eventListeners object
    window.hyva.modal.eventListeners.keydown = event => {
        console.log('my wrapper', event);
        originalListener(event); // call original listener if needed
    };
    // Activate the new event listener
    document.addEventListener('keydown', window.hyva.modal.eventListeners.keydown);
})()
```

## Accessing the current modal

Available since Hyvä 1.2.4 and 1.1.24

The method `window.hyva.modal.peek()` returns the current active modal instance, or `false` if there is none.

The returned object has several properties:

```
{
  name: 'the dialog name',
  instance: {the Alpine component object},
  focusTarget: DOM element to receive focus after hiding the dialog (or null),
  time: timestamp when the modal was shown,
};
```

The `name` and the `instance` can be useful in some circumstances.
The `time` and the `focusTarget` properties are for internal state management only.
