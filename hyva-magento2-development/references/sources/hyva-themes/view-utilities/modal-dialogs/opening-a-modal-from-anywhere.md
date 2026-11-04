<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/opening-a-modal-from-anywhere.html -->

# Opening a modal from outside the Alpine component

## Using a custom event with `x-htmldialog`

The recommended approach for triggering a dialog from outside its Alpine component is to dispatch a custom event and listen for it on the `x-data` element:

```
<div x-data="{ open: false }" @open-my-dialog.window="open = true">
    <dialog x-show="open" x-htmldialog="open = false" class="rounded-lg shadow-xl p-10 backdrop:bg-black/50">
        <p>Content</p>
        <button @click="open = false" type="button" class="btn">Close</button>
    </dialog>
</div>
```

Dispatch the event from anywhere on the page:

```
window.dispatchEvent(new CustomEvent('open-my-dialog'));
```

Or from within another Alpine component:

```
<button @click="$dispatch('open-my-dialog')" type="button" aria-haspopup="dialog">Open</button>
```

## Using the `hyva-modal-show` event

When using the PHP Modal view model, modals can also be opened by dispatching the `hyva-modal-show` event with the dialog ref name:

From within an Alpine component:

```
<button
  type="button"
  @click="$dispatch('hyva-modal-show', {dialog: 'my-modal'})"
>Open</button>
```

From anywhere with vanilla JS:

```
window.dispatchEvent(
    new CustomEvent('hyva-modal-show', {detail: {dialog: 'my-modal'}})
)
```

### Specifying the element to focus when the modal is closed

Pre-1.5.0 only

This option applies to the legacy modal system only. Since Hyvä 1.5.0 the modal is built on the native HTML `<dialog>` element, and the browser automatically restores focus to the element that triggered the dialog when it closes.

To keep the store accessible, specify which element should receive focus when the modal closes using `focusAfterHide`:

```
window.dispatchEvent(
    new CustomEvent('hyva-modal-show', {detail: {dialog: 'my-modal', focusAfterHide: '#some-selector'}})
)
```
