<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/x-htmldialog.html -->

# The Alpine.js x-htmldialog plugin

Available since Hyvä 1.4

The Hyvä HTML Dialog is an AlpineJS plugin that enhances the native HTML `<dialog>` element, making it easier to create accessible and interactive modals, pop-ups, and off-canvas panels.

It integrates seamlessly with Alpine's `x-show` directive to manage the dialog's visibility and state.

## Usage

To utilize the `x-htmldialog` plugin, add the directive to an HTML `<dialog>` element that is also controlled by `x-show`.

```
<div x-data="{ open: false }">
    <button @click="open = !open">Open</button>
    <dialog x-show="open" x-htmldialog="open = false">
        <!-- Dialog content goes here -->
    </dialog>
</div>
```

When the `x-htmldialog` directive is present on an `x-show` element:

- It prevents `x-show` from directly toggling the display style.
- Instead, it uses the native `el.showModal()` function to display the dialog.
- The optional value provided to `x-htmldialog` (e.g., `"open = false"`) is executed
  when the dialog is closed by pressing the Escape key or clicking outside the dialog (the backdrop).

### Modifiers

The `x-htmldialog` directive supports modifiers to further customize its behavior.

#### `noscroll`

The `noscroll` modifier prevents scrolling on the background page while the dialog is open.

```
<div x-data="{ open: false }">
    <button @click="open = !open">Open</button>
    <dialog x-show="open" x-htmldialog.noscroll="open = false">..</dialog>
</div>
```

`noscroll` is not really needed with Hyvä Default Theme v1.4, this uses CSS for this scroll-lock

CSS from the Default Theme v1.4:

```
:where(:root:has(dialog[open]:modal)) {
    overflow: hidden;
}
```

#### `closeby`

The `closeby` option gives you fine-grained control over how the dialog can be dismissed. The plugin polyfills this behavior for browsers that do not yet support it natively.

You can set this option in two ways:

**1. As an attribute on the `<dialog>` element:**

```
<dialog closeby="any" ...>
```

**2. As a modifier on the `x-htmldialog` directive:**

```
<dialog x-htmldialog.closeby.any ...>
```

##### Available Options

- **`any`**: The dialog can be closed by any user action, such as pressing the `ESC` key or clicking on the backdrop.
- **`closerequest`**: (Default) The dialog can be dismissed via the `ESC` key or a "close request" (e.g., a form submission with `method="dialog"`). It will not close when the backdrop is clicked.
- **`none`**: The user cannot close the dialog. It must be closed programmatically.

---

> *These docs can also be found on the [fylgja.dev](https://fylgja.dev/library/extensions/alpinejs-dialog/).*
