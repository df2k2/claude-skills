<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/confirmation-dialogs.html -->

# Confirmation Dialogs

The Hyvä confirmation dialogs are built on top of the modal dialogs. All methods from the [Modal ViewModel API Reference](modal-view-model-reference.html) are available in addition to the confirmation-specific ones below.

Available since Hyvä 1.1.13

To create a confirmation dialog instance, use the `confirm` method on the modal view model:

```
use Hyva\Theme\ViewModel\Modal;

/** @var Modal $modalViewModel */
$confirmation = $modalViewModel->confirm(__('Are you sure?'));
```

The default confirmation template is `Hyva_Theme::modal/confirmation.phtml`.

## Configuration

### Content

#### withTitle(string $title)

Set the dialog title. This is the same as passing it directly to `confirm('the title')`. The title is escaped during rendering.

#### withDetails(string $details)

Add detail text rendered between the title and the buttons. The value is not escaped and may contain HTML.

*Example:*

```
$confirmation->withDetails('<em>This action cannot be undone.</em>');
```

`withContent()` vs. `withDetails()`

Confirmation dialogs also inherit `withContent()` from the base modal. If `withContent()` is set, the default template is bypassed entirely and no title or buttons are rendered. Use `withDetails()` to add body text while keeping the standard confirmation layout.

### Button Labels

| Method | Description |
| --- | --- |
| `withOKLabel(string $label)` | Override the confirm button label. Default: `OK`. |
| `withCancelLabel(string $label)` | Override the cancel button label. Default: `Cancel`. |

*Example:*

```
$confirmation->withOKLabel(__('Yes, delete'))->withCancelLabel(__('No, keep it'));
```

### Template

#### withTemplate(string $template)

Override the default confirmation template for this specific dialog.

*Example:*

```
$confirmation->withTemplate('Hyva_Theme::modal/custom-confirmation.phtml');
```

## Triggering actions

The `show()` method on the PHP view model returns a JavaScript promise that resolves when the user makes a choice. Chain `.then()` to handle the result: `true` means confirmed, `false` means cancelled.

*Example:*

```
<button
    type="button"
    class="btn"
    @click="<?= $escaper->escapeHtmlAttr($confirmation->getShowJs()) ?>.then(result => result && doSomething())"
>
    <?= $escaper->escapeHtml(__('Delete')) ?>
</button>
<?= $confirmation ?>
```

## Dialogs with more than two choices

Pass a distinct value to `hide()` from each button in a custom template to build a dialog with more than two outcomes. The `show()` promise resolves to whatever value is passed to `hide()`.

*Example:*

```
<button @click="hide('a')" type="button" class="btn">
    <?= $escaper->escapeHtml(__('Option A')) ?>
</button>
<button @click="hide('b')" type="button" class="btn">
    <?= $escaper->escapeHtml(__('Option B')) ?>
</button>
<button @click="hide('c')" type="button" class="btn btn-primary">
    <?= $escaper->escapeHtml(__('Option C')) ?>
</button>
```

## Alpine.js (without PHP)

Using `x-htmldialog`, a confirmation dialog can be built with a small Alpine component that exposes a promise-based `confirm()` method, matching the feel of the PHP view model approach:

```
<script>
document.addEventListener('alpine:init', () => {
    Alpine.data('confirmDialog', () => ({
        open: false,
        resolve: null,
        show() {
            this.confirm().then(result => {
                // handle result here
                console.log(result);
            });
        },
        confirm() {
            return new Promise(resolve => {
                this.resolve = resolve;
                this.open = true;
            });
        },
        ok() {
            this.open = false;
            this.resolve(true);
        },
        cancel() {
            this.open = false;
            this.resolve(false);
        }
    }));
});
</script>

<div x-data="confirmDialog">
    <button type="button" class="btn" @click="show">Show</button>

    <dialog
        x-show="open"
        x-htmldialog.closeby.none
        aria-labelledby="the-label"
    >
        <div id="the-label">Are you sure?</div>
        <div>Think before you click...</div>
        <div class="mt-6 flex justify-between gap-2">
            <button @click="cancel" type="button" class="btn">Cancel</button>
            <button @click="ok" type="button" class="btn btn-primary">OK</button>
        </div>
    </dialog>
</div>
```

By default this example uses `x-htmldialog.closeby.none` to force an explicit choice. If you want ESC or a backdrop click to count as a cancel, replace it with `x-htmldialog="cancel"` and the promise will still always resolve.

## Examples

### Confirmation dialog with only details

```
$confirmation = $modalViewModel->confirm()
    ->withDetails($escaper->escapeHtml(__('Are you sure?')));
```

### Confirmation dialog with title and details

```
$confirmation = $modalViewModel->confirm(__('Are you sure?'))
    ->withDetails('<em>Think before clicking.</em>');
```

### Confirmation dialog with custom button labels

```
$confirmation = $modalViewModel->confirm(__('How deep does the rabbit hole go?'))
    ->withOKLabel(__('Red pill'))
    ->withCancelLabel(__('Blue pill'));
```
