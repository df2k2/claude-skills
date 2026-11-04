<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/modal-view-model-reference.html -->

# Modal ViewModel API Reference

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

Be sure to type hint the `$modalViewModel` so your IDE supports you with auto-completion for the available method names.

## Configuration

### Visibility & Overlay

| Method | Description |
| --- | --- |
| `overlayEnabled()` | Display a backdrop and disable scrolling while the modal is visible. This is the default. |
| `overlayDisabled()` | Do not show a backdrop and allow page scrolling while the modal is visible. |
| `initiallyHidden()` | Hide the modal until `show` is called. This is the default. |
| `initiallyVisible()` | Make the modal visible immediately when the page loads. |

### Close Behaviour

#### withCloseby(string $behaviour)

Available since Hyvä 1.5.0

Control how the dialog can be dismissed.

| Value | Description |
| --- | --- |
| `"any"` | ESC key or click outside the dialog closes it. This is the default. |
| `"closerequest"` | ESC key only. |
| `"none"` | The dialog does not close automatically. A close trigger must be provided inside the dialog. |

*Example:*

```
$modal->withCloseby('closerequest')
```

### Positioning

| Method | Description |
| --- | --- |
| `positionCenter()` | Center of the window. This is the default. |
| `positionTop()` | Center-top of the window. |
| `positionRight()` | Center-right of the window. |
| `positionBottom()` | Center-bottom of the window. |
| `positionLeft()` | Center-left of the window. |
| `positionTopLeft()` | Top-left corner of the window. |
| `positionTopRight()` | Top-right corner of the window. |
| `positionBottomRight()` | Bottom-right corner of the window. |
| `positionBottomLeft()` | Bottom-left corner of the window. |
| `positionNone()` | No automatic positioning. Use `addDialogClass` to position manually. Available since Hyvä 1.3.10. |

### Dialog Styling

#### withDialogClasses(string ...$classes)

Replace all CSS classes on the dialog element with the given ones.

The default dialog classes are:

```
['inline-block', 'bg-white', 'shadow-xl', 'rounded-lg', 'p-10']
```

#### addDialogClass(string $class, string ...$moreClasses)

Add CSS classes to the dialog element.

*Example:*

```
$modal->addDialogClass('backdrop:bg-black/50', 'pb-10')
```

#### removeDialogClass(string $class, string ...$moreClasses)

Remove CSS classes from the dialog element.

### Accessibility

| Method | Description |
| --- | --- |
| `withAriaLabel(string $label)` | Set the dialog label used by screen readers. Use this or `withAriaLabelledby`. |
| `withAriaLabelledby(string $elementId)` | Set the ID of an element whose text is used as the dialog label. Use this or `withAriaLabel`. |

### Content

#### withTemplate(string $template)

Set a `.phtml` template to render as the modal content.

*Example:*

```
$modal = $modalViewModel->createModal()->withTemplate('My_Module::my-dialog-content.phtml');
?>
<div x-data="hyvaModal">
    <button @click="<?= $escaper->escapeHtmlAttr($modal->getShowJs()) ?>" type="button" class="btn mt-40">
        <?= $escaper->escapeHtml(__('Show Modal')) ?>
    </button>
    <?= $modal->withAriaLabel('Example modal with content template') ?>
</div>
```

#### withBlockName(string $blockName)

Use a block already declared in layout XML as the modal content.

*Example:*

```
<?php $modal = $modalViewModel->createModal()->withBlockName('my-block') ?>
<div x-data="hyvaModal">
    <button @click="<?= $escaper->escapeHtmlAttr($modal->getShowJs()) ?>" type="button" class="btn mt-40">
        <?= $escaper->escapeHtml(__('Show Modal')) ?>
    </button>
    <?= $modal->withAriaLabel('Example modal with content from predeclared block') ?>
</div>
```

#### withContent(string $content)

Render an inline HTML string as the modal content.

*Example:*

```
<div x-data="hyvaModal">
    <button @click="show" type="button" class="btn mt-40"><?= $escaper->escapeHtml(__('Show')) ?></button>
<?= $modalViewModel->createModal()->withContent(<<<END_OF_CONTENT

<div id="the-label">{$escaper->escapeHtml(__('Inline Content Example'))}</div>
<div class="mt-20 flex justify-between gap-2">
    <button @click="hide" type="button" class="btn">
        {$escaper->escapeHtml(__('Cancel'))}
    </button>
    <button x-focus-first @click="doSomething" type="button" class="btn btn-primary">
        {$escaper->escapeHtml(__('Heck Yes!'))}
    </button>
</div>

END_OF_CONTENT
)->withAriaLabelledby('the-label') ?>
</div>
```

HEREDOC expressions incompatible with Magento built in HTML minification

The regular expression used by Magento to parse PHP while minifying output has a bug.
It expects the closing heredoc delimiter to be followed by a semicolon, even though it is not required by PHP, and in fact can't be used when the heredoc is used as an expression like in the example above.
We [recommend disabling minification](../../getting-started/index.html#disabling-built-in-minification-and-bundling-for-hyva), but if that is not an option, you need to use the heredoc as a statement instead, that is, assign the string to a variable.
The following code **breaks Magento minification** but is **valid PHP**:

```
$content = <<<HEREDOC
<div>My Content</div>
HEREDOC
$modalViewModel->createModal()->withContent($content);
```

The following code **works with Magento minification** but causes a syntax error to be raised, because it is **invalid PHP**:

```
$modalViewModel->createModal()->withContent(<<<HEREDOC
<div>My Content</div>
HEREDOC;
);
```

The following code **works with Magento minification** and is also **valid PHP**:

```
$content = <<<HEREDOC
<div>My Content</div>
HEREDOC;
$modalViewModel->createModal()->withContent($content);
```

#### getContentRenderer()

Available since Hyvä 1.1.9

Returns the Template block instance used to render the modal template, so you can pass data to it before rendering.

*Example:*

```
$modal = $modalViewModel->createModal()->withTemplate('My_Module::foo.phtml');
$modalBlock = $modal->getContentRenderer();
$modalBlock->assign('foo', $foo);
$modalBlock->setData('bar', $bar);
// then in foo.phtml $foo is automatically set and $block->getData('bar') will return $bar

?>
<?= /* Be sure to render $modal, not $modalBlock */ $modal ?>
```

### Alpine Internals

#### withDialogRefName(string $refName)

Set the Alpine.js `x-ref` name for the dialog element. The ref name is set automatically when using the PHP view model, so this method is rarely needed.

#### getDialogRefName()

Return the Alpine.js `x-ref` name for the dialog element. Useful when multiple modals share one Alpine component and you need to target a specific one.

*Example:*

```
<div x-on:private-content-loaded.window="show('<?= $customerModal->getDialogRefName() ?>', 'my-trigger')">
```

## Deprecated methods (since 1.5.0)

Deprecated since 1.5.0

The following methods are deprecated. They still work but log a deprecation warning. Use the alternatives listed below.

- **`withOverlayClasses(string ...$classes)`**: The overlay `div` wrapper has been replaced by the native `<dialog>` backdrop. Use `addDialogClass('backdrop:...')` to style the backdrop instead.
- **`addOverlayClass(string $class, string ...$moreClasses)`**: Use `addDialogClass('backdrop:...')` instead.
- **`removeOverlayClass(string $class, string ...$moreClasses)`**: Use `removeDialogClass('backdrop:...')` instead.
- **`withContainerTemplate(string $template)`**: The container `div` wrapper has been removed. Dialog positioning is now handled directly on the `<dialog>` element.
- **`withContainerClasses(string ...$classes)`**: The container `div` wrapper has been removed. Use `addDialogClass()` or the position methods instead.
- **`addContainerClass(string $class, string ...$moreClasses)`**: Use `addDialogClass()` instead.
- **`removeContainerClass(string $class, string ...$moreClasses)`**: Use `removeDialogClass()` instead.
