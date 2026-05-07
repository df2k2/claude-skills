<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/index.html -->

# Modal Dialog Overview

The Hyvä Theme module makes using modal dialogs efficient by utilizing Alpine.js, Tailwind CSS and PHP View Models.

Available since 1.1.6

Modals are available since version 1.1.6 of *`Hyva_Theme`*. If you are using an older version, be sure to upgrade the theme module.
New features have been added to the dialog library over time. This documentation will always note the version a feature was released.
If you use the modal library in modules, be sure to record your theme version dependency accordingly in the module `composer.json` file.

The modals can be used with or without the view model `Hyva\Theme\ViewModel\Modal`.

Since the PHP view model makes creating modal dialogs more convenient, we assume it will be the default.

For more information how to use the modals without the PHP view model, please refer to [this page](modals-without-php.html) of this section.

## TL;DR

Here is a 10-minute video recording of a short demo how to use the modal.
Please be aware that the video does not use strict CSP compliant examples.

Look below for example code.

Here is an example to get you started right now:

```
<?php

/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
/** @var \Hyva\Theme\ViewModel\Modal $modalViewModel */
$modalViewModel = $viewModels->require(\Hyva\Theme\ViewModel\Modal::class);

?>
<div x-data="hyvaModal">
    <button @click="show" type="button" class="btn mt-40" aria-haspopup="dialog">
        <?= $escaper->escapeHtml(__('Show')) ?>
    </button>
<?= $modalViewModel->createModal()->withContent(<<<END_OF_CONTENT

<div id="the-label">{$escaper->escapeHtml(__('My Dialog'))}</div>
<div class="mt-20 flex justify-between gap-2">
    <button @click="hide" type="button" class="btn">
        {$escaper->escapeHtml(__('Cancel'))}
    </button>
    <button x-focus-first @click="alert('beep')" type="button" class="btn btn-primary">
        {$escaper->escapeHtml(__('I agree'))}
    </button>
</div>

END_OF_CONTENT
)->positionBottom()
 ->withAriaLabelledby('the-label')
 ->addDialogClass('border', 'border-10', 'border-blue-800')
?>
</div>
```

Modals in Extensions

In themes it is okay to use `@click="show"` without arguments, if there is only a single modal on the page.
But if there is more than one modal on a page, or if the modal is part of a Magento extension, a unique modal name needs to be passed to `show()`.
See [Showing modal dialogs](#showing-modal-dialogs) below for details.

Heredocs in templates break HTML minification

At the time of writing, the Magento2 HTML minification is not able to process Heredocs like the one used in the example above.
We generally recommend turning off HTML minification, as the benefits it provides are negligible, and it tends to cause more problems than it worth.
For reference, please see [issue 32153](https://github.com/magento/magento2/issues/32153) in the Magento 2 GitHub repository.

If you still would like to use modals with inline content, you can use regular double-quoted PHP strings, too.

## How to use

### Include the modal logic

In order to use the modals, the JavaScript needs to be loaded in the page.
This is done by including the layout XML handle `hyva_modal`.

```
<page>
    <update handle="hyva_modal"/>
</page>
```

### Merge hyva.modal() with your code

Hyvä modal dialogs use Alpine.js.

If you only are interested in a modal and do not require any custom code, you can use `hyva.modal()` directly as your Alpine.js view model.

```
<div x-data="hyva.modal()">

</div>
```

If you also want to use custom state or logic, you will need to merge it with the modal Alpine.js view model using the object spread operator or `Object.assign()`.

```
<div x-data="Object.assign({}, hyva.modal(), {counter: 0})">

</div>
```

Or, if you extracted the Alpine.js view model properties into a function:

```
<div x-data="Object.assign({}, hyva.modal(), myViewModelFunction())">

</div>
```

The object returned by `hyva.modal()` has four properties.

**Be sure not to overwrite them with your custom code.**

- `show()`
  The function to show the modal dialog.
- `hide()`
  The function to hide the modal dialog.
- `overlay()`
  The Alpine.js properties for the overlay DOM element.
  If you use the PHP view model you don't need to know more.
- `isDialogOpen` The state property storing if the modal is visible (`true`) or hidden (`false`).
  The property name actually might be different, depending on the dialog name.
  However, it will always be called `is` + dialog name + `Open`.

### How to use the PHP Modal view model

Instantiate the PHP view model like any other in your .phtml template:

```
/** @var \Hyva\Theme\ViewModel\Modal $modalViewModel */
$modalViewModel = $viewModels->require(\Hyva\Theme\ViewModel\Modal::class);
```

To create a modal instance, call `createModal` on the PHP view model. More about how to configure the modal further below:

```
$modal = $modalViewModel->createModal()
```

Don’t forget to echo out the modal once you configured it.

For example:

```
<?= /** @noEscape */ $modal->withContent('Foo') ?>
```

The easiest way to render the modal is when the contents are nested inside the node containing the `x-data="hyva.modal()"` attribute.

```
<div x-data="hyva.modal()">
    <?= $modalViewModel->createModal()->withContent('<h1>Test</h1>') ?>
    <button @click="show" type="button" class="btn mt-40" aria-haspopup="dialog">
        <?= $escaper->escapeHtml(__('Show Modal')) ?>
    </button>
</div>
```

Otherwise, you will have to call the `show()` method with the dialog ref-name (see [`getDialogRefName`](modal-view-model-reference.html#getdialogrefname) and [`withDialogRefName`](modal-view-model-reference.html#withdialogrefnamestring-refname)).

### Showing modal dialogs

Showing the modal usually requires some user interaction, most commonly a click.
If you use the PHP Modal view model, you can have the modal instance generate the required code with the `getShowJs` method.

```
<button @click="<?= $escaper->escapeHtmlAttr($modal->getShowJs()) ?>"
        type="button" class="btn mt-40" aria-haspopup="dialog">
    <?= $escaper->escapeHtml(__('Show Modal')) ?>
</button>
```

Under the hood

The `getShowJs()` method returns the JavaScript code `show('dialog', $event)`.
The first argument is the automatically generated name for the modal instance.
Generating the name makes it easier, since each dialog on the page needs a unique name.

The `$event` argument is used to determine the element that was used to trigger the action so it can be focused
after the modal is closed. This is important for accessibility and keyboard navigation.

If you don't use the PHP view model, you can call the `show` method in an event handler directly without any arguments:

```
<button @click="show" type="button" class="btn mt-40" aria-haspopup="dialog"><?= $escaper->escapeHtml(__('Show Modal')) ?></button>
```

However, if multiple modals within one Alpine.js view model are used, the modal name needs to be passed as the first argument.

```
<button @click="show('modal2', $event)" type="button" class="btn mt-40" aria-haspopup="dialog"><?= $escaper->escapeHtml(__('Show Modal')) ?></button>
```

**Since extensions can not rely on only a single modal being present on a page, always specify a unique modal name or use the `getShowJs` PHP method.**

If you use the PHP Modal view model method `getShowJs`, generating a unique name and passing it as the argument is taken care of automatically.

#### Specifying the element to focus when the modal is closed

Available since Hyvä 1.2.9 and 1.3.5

The modal library attempts to handle this accessibility feature automatically, but due to the dynamic and flexible nature of JavaScript, it is not possible in some instances.

A DOM element selector string or a DOM element can be passed as a second argument to the `show()` JS method, or as the single argument to the `getShowJs` PHP method.

In JavaScript:

```
<button @click="show('modal2', '#dom-selector')"
        type="button"
        class="btn mt-40"
        aria-haspopup="dialog"><?= $escaper->escapeHtml(__('Show Modal')) ?></button>
```

In PHP:

```
<button @click="<?= $escaper->escapeHtmlAttr($modal->getShowJs('#dom-selector')) ?>"
        type="button" class="btn mt-40" aria-haspopup="dialog">
    <?= $escaper->escapeHtml(__('Show Modal')) ?>
</button>
```

### Hiding modal dialogs

#### with JavaScript

To hide the most recent modal dialog call the `hide` method of the Alpine.js view model.

```
<button @click="hide" type="button" class="btn mt-40"><?= $escaper->escapeHtml(__('Cancel')) ?></button>
```

If multiple modals are visible, modals will be hidden in the reverse order they were displayed.

Imagine them as a stack of dialogs where `hide` pops the top modal off the stack.

The top modal can be hidden from outside the Alpine.js view model that contains the dialog with the global function
`window.hyva.modal.pop()`. This can be handy in event observers or other callback methods.

#### with the escape key

Pressing the Escape key automatically hides the last modal.

Be sure to include at least one `hide` trigger besides the Escape key for mobile users.

#### by click-away

For modals with a backdrop, clicking outside the dialog will automatically hide the modal.
Be sure to include at least one `hide` trigger besides for mobile users where the dialog might take up all the available screen.

## Configuring a modal

The PHP Modal view model uses a fluent interface to configure the dialog.

```
/** @var \Hyva\Theme\ViewModel\Modal $modalViewModel */
$modal = $modalViewModel->createModal()
    ->withTemplate('My_Module::dialog-content.phtml')
    ->overlayDisabled()
    ->positionBottom()
    ->addDialogClass('pb-10')
    ->initiallyVisible();
```

Be sure to type hint the `$modalViewModel` so your IDE support you with auto-completion for the available method names.

Please refer to the [Modal API Reference](modal-view-model-reference.html) for more information.
