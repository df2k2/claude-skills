<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/index.html -->

# Modal Dialogs

Since Hyvä 1.5.0, modal dialogs are built on the native HTML `<dialog>` element, powered by the [`x-htmldialog`](../../working-with-alpinejs/alpine-plugins/x-htmldialog.html) Alpine plugin. The browser now handles focus trapping, Escape key handling, and backdrop click natively.

There are two ways to create a modal dialog:

- **`x-htmldialog` directly** (recommended): Write a `<dialog>` element with the `x-htmldialog` directive. Works anywhere Alpine.js is available, including CMS content.
- **PHP view model**: The `Hyva\Theme\ViewModel\Modal` class generates the markup from PHP. Useful when you need to configure the dialog server-side from a `.phtml` template.

## Alpine.js (x-htmldialog)

The recommended way to create a modal is to use the `x-htmldialog` directive directly on a native `<dialog>` element:

```
<div x-data="{ open: false }">
    <button @click="open = true" type="button" class="btn">Open</button>
    <dialog x-show="open" x-htmldialog="open = false">
        <p>Dialog content here.</p>
        <button @click="open = false" type="button" class="btn">Close</button>
    </dialog>
</div>
```

For full usage details, modifiers, and options, refer to the [`x-htmldialog` plugin documentation](../../working-with-alpinejs/alpine-plugins/x-htmldialog.html).

## PHP View Model

### Setup

Include the `hyva_modal` layout handle to load the required JavaScript on the page:

```
<page>
    <update handle="hyva_modal"/>
</page>
```

Instantiate the view model in your `.phtml` template:

```
<?php
use Hyva\Theme\ViewModel\Modal;

/** @var Modal $modalViewModel */
$modalViewModel = $viewModels->require(Modal::class);
```

### Quick start

```
<?php
use Hyva\Theme\ViewModel\Modal;

/** @var \Magento\Framework\Escaper $escaper */
/** @var Modal $modalViewModel */
$modal = $modalViewModel->createModal()
    ->withAriaLabel('My Dialog')
    ->positionBottom();
?>
<div x-data="hyvaModal">
    <button
        type="button"
        class="btn"
        @click="<?= $escaper->escapeHtmlAttr($modal->getShowJs()) ?>"
    >
        <?= $escaper->escapeHtml(__('Open')) ?>
    </button>
    <?= $modal->withContent(<<<END_OF_CONTENT
        <p class="text-lg font-medium">{$escaper->escapeHtml(__('My Dialog'))}</p>
        <div class="mt-6 flex justify-end gap-2">
            <button @click="hide" type="button" class="btn">
                {$escaper->escapeHtml(__('Cancel'))}
            </button>
            <button type="button" class="btn btn-primary">
                {$escaper->escapeHtml(__('Confirm'))}
            </button>
        </div>
    END_OF_CONTENT) ?>
</div>
```

Heredocs in templates break HTML minification

Magento's built-in HTML minification cannot process heredoc expressions.
We recommend [disabling minification](../../getting-started/index.html#disabling-built-in-minification-and-bundling-for-hyva). If that is not an option, assign the heredoc to a variable first.

### Showing a modal

Use `getShowJs()` on the modal instance to generate the correct click handler. This ensures each modal gets a unique name and that the triggering element receives focus back when the dialog closes.

```
<button
    type="button"
    class="btn"
    @click="<?= $escaper->escapeHtmlAttr($modal->getShowJs()) ?>"
>
    <?= $escaper->escapeHtml(__('Open')) ?>
</button>
```

Modals in extensions

Always use `getShowJs()` in extensions rather than `@click="show"` without arguments. Extensions cannot assume only one modal is present on the page.

### Closing a modal

The browser closes the dialog automatically when the user presses the Escape key or clicks the backdrop. Use the `withCloseby()` method to change this behaviour (see [API reference](modal-view-model-reference.html#withclosebystring-behaviour)).

To close the modal from a button inside the dialog, call `hide`:

```
<button type="button" class="btn" @click="hide" >
    <?= $escaper->escapeHtml(__('Close')) ?>
</button>
```

### Configuring a modal

The view model uses a fluent interface. Chain methods to configure positioning, content, styling, and accessibility:

```
<?php

$modal = $modalViewModel->createModal()
    ->withTemplate('My_Module::dialog-content.phtml')
    ->positionBottom()
    ->overlayDisabled()
    ->addDialogClass('pb-10')
    ->withAriaLabel('My dialog');
```

For the full list of available methods, refer to the [Modal ViewModel API Reference](modal-view-model-reference.html).

## Legacy Modal System (pre-1.5.0)

The modal system was rebuilt in Hyvä 1.5.0. Projects that cannot migrate immediately can install a compatibility module to restore the old `hyva.modal()` behaviour. See [Legacy Modal System](legacy-modal-install.html) for installation instructions.
