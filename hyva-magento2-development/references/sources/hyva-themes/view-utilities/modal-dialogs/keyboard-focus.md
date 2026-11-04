<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/keyboard-focus.html -->

# Keyboard focus and accessibility

Since 1.5.0, the modal system is built on the native HTML `<dialog>` element. Focus trapping, Escape key handling, and focus restoration are handled by the browser natively.

## Focus when opening a dialog

When a modal opens, the browser moves focus into the dialog automatically. To specify which element receives focus first, add the `x-focus-first` attribute:

```
<?= $modalViewModel->createModal()->withContent(<<<END_OF_CONTENT
<div class="mt-20 flex justify-between gap-2">
    <button type="button" class="btn" @click="hide">
        {$escaper->escapeHtml(__('Cancel'))}
    </button>
    <button
        type="button"
        class="btn btn-primary"
        @click="alert('beep')"
        x-focus-first
    >
        {$escaper->escapeHtml(__('I agree'))}
    </button>
</div>
END_OF_CONTENT
) ?>
```

## Focus when closing a dialog

When the modal closes, the browser restores focus to the element that triggered it. This also works correctly with nested dialogs.

## Focus trapping

While the dialog is open, Tab and Shift-Tab navigation is contained within the dialog. Elements outside the dialog cannot receive focus. This is handled natively by the browser's `<dialog>` implementation.
