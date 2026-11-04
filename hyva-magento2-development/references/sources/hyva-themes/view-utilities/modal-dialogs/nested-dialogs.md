<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/nested-dialogs.html -->

# Nested dialogs

Modals can be displayed from within another dialog.
The only requirement is that each dialog has a unique Alpine.js `x-ref` name.
The naming is taken care of automatically when using the PHP Modal view model.

**Example**

```
<?php

$nestedDialog = $modalViewModel->createModal()
                    ->withTemplate('My_Module::nested-dialog.phtml');

$outerDialog = $modalViewModel->createModal()->withContent(<<<OUTER_MODAL_CONTENT
    <div id="outer-label">{$escaper->escapeHtml(__('Outer Model'))}</div>

    <!-- NOTE 1: here the nested dialog is rendered -->
    {$nestedDialog}

    <div class="mt-20 flex justify-between gap-2">
        <button type="button" class="btn" @click="hide">{$escaper->escapeHtml(__('Cancel'))}</button>
        <!-- NOTE 2: The ref name of the inner dialog is handled automatically -->
        <button
            type="button"
            class="btn btn-primary"
            @click="{$nestedDialog->getShowJs()}"
            x-focus-first
        >{$escaper->escapeHtml(__('More Info'))}</button>
    </div>
OUTER_MODAL_CONTENT
)->withAriaLabelledby('outer-label');

?>
<div x-data="hyvaModal">
    <button @click="<?= $outerDialog->getShowJs() ?>" type="button" class="btn mt-40">
        <?= $escaper->escapeHtml(__('Outer View Model')) ?>
    </button>
    <?= $outerDialog ?>
</div>
```
