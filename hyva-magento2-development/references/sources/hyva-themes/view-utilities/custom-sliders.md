<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/custom-sliders.html -->

# Custom Sliders

Same as with the [product slider](product-sliders.html) creating a slider is as easy as creating the following xml:

```
<page>
    <body>
        <referenceContainer name="content">
            <block name="my-slider" template="Hyva_Theme::elements/slider.phtml">
                <arguments>
                    <argument name="title" xsi:type="string">My Slider</argument>
                </arguments>
                <!-- Your Child blocks as slides -->
            </block>
        </referenceContainer>
    </body>
</page>
```

Onces created you only need to pass it child block that will be used as each slide.

## Configuration

| Option | Default Value | Type | Description |
| --- | --- | --- | --- |
| `slider_name` | *Layout block name* | String | Slider ID to make it unique, required for the skiplink |
| `title` |  | String | Slider Label and visual heading title, required for A11Y |
| `heading_tag` | h3 | String | Visual heading HTML Tag |
| `css_classes` | `my-8` | String | CSS classes used by the block |
| `heading_css_classes` | `text-2xl font-medium` | String | CSS classes used by the block heading |
| `column_count` | 1 | Number |  |
| `slider_css_classes` |  | String | CSS classes used slider (track) |
| `show_heading` | `true` | Boolean | Show the visual heading |
| `show_pager` | `true` | Boolean | Show the slider pager dots |

## Creating Custom Sliders in a Template

You can create custom sliders directly in your `.phtml` templates without using XML.
These sliders are powered by the [AlpineJS Snap Slider plugin](../working-with-alpinejs/alpine-plugins/x-snap-slider.html).

This is as simple as writing the HTML markup for a CSS-based slider and then initializing it with the AlpineJS plugin.
For detailed instructions and examples,
please refer to the documentation on the [AlpineJS Snap Slider plugin](../working-with-alpinejs/alpine-plugins/x-snap-slider.html).

## Before version 1.4

Deprecated

Everyting down here is for older versions of Hyvä before version 1.4 and is marked for deprecation.

Hyvä includes a generic slider template that can be used to render custom slider items with PHP.

The easiest way to render the slider is through the slider view model:

```
<?php declare(strict_types=1);

/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
/** @var \Hyva\Theme\ViewModel\Slider $sliderViewModel */

$sliderViewModel = $viewModels->require(\Hyva\Theme\ViewModel\Slider::class);
$itemsTemplate   = 'Example_Module::slider-item.phtml';
$items           = $block->getSomeItems(); // a collection or array of items to render

?>
<?=
 $sliderViewModel->getSliderForItems($itemsTemplate, $items)
                 ->setData('title', __('Some Items'))
                 ->toHtml()
?>
```

Setting the title for the slider with `setTitle($title)` or `setData('title', $title)` is optional.

The slider items template to render an individual item looks something like the following:

```
<?php declare(strict_types=1);

/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */

// The item to render is set on the block before the template is rendered:

/** @var \Magento\Catalog\Model\Product $item */
$item = $block->getData('item');

?>
<a href="<?= $escaper->escapeHtmlAttr($item->getUrl())?>"
   class="relative flex items-center bg-white"
   style="padding-top:100%"
   tabindex="-1">
       <span class="absolute top-0 left-0 flex flex-wrap content-center w-full h-full p-2
                    overflow-hidden align-center hover:shadow-sm">
       <img class="self-center w-full h-auto"
            src="<?= $escaper->escapeHtmlAttr($item->getImage()) ?>"
            alt="<?= $escaper->escapeHtmlAttr($item->getName()) ?>"
            loading="lazy"
        >
        </span>
</a>

<p class="flex items-center justify-center px-1 pt-3 text-primary">
    <a class="truncate" href="<?= $escaper->escapeHtmlAttr($item->getUrl()) ?>">
        <?= $escaper->escapeHtml($item->getName()) ?>
    </a>
</p>
```

### Specifying Slider CSS classes

#### `maybe_purged_tailwind_section_classes`

Available since 1.1.8

The CSS classes on the containing slider `<section>` DOM element can be specified by setting the `maybe_purged_tailwind_section_classes` property on the slider block.

For example:

```
<?= $slider->getSliderForItems('My_Module::my-item.phtml', $items)
           ->setData('maybe_purged_tailwind_section_classes', 'text-gray-700 body-font')
           ->toHtml() ?>
```

If no slider section classes are specified, the default `my-12 text-gray-700 body-font` are used.

#### `maybe_purged_tailwind_slide_item_classes` and `max_visible`

Available since 1.3.6

The CSS classes on the `<div>` element wrapping each item in the slider can be specified by setting the `maybe_purged_tailwind_slide_item_classes` property on the slider block.
This is useful to control how many slides are visible at different breakpoints, without overriding or creating a separate version of the `slider-php.phtml` template.
The slide item width related breakpoints specified for `maybe_purged_tailwind_slide_item_classes` must match the number of visible items on the largest breakpoint set via `max_visible`. The default `max_visible` is 4.

For example:

```
<?= $slider->getSliderForItems('My_Module::my-item.phtml', $items)
           ->setData('max_visible', 2)
           ->setData('maybe_purged_tailwind_slide_item_classes', 'py-1 md:w-1/2')
           ->toHtml() ?>
```

If no slider item classes are specified, the default `py-1 md:w-1/2 lg:w-1/3 xl:w-1/4` are used.

Maybe purged?

The property name includes **maybe\_purged** to indicate that if the classes are set in layout XML (instead of a .phtml template).
They may not be seen by Tailwind during the compilation, and thus might be missing from the production bundle, unless the XML files are also included in the content path in the Tailwind configuration.

Usually they will be set in a `.phtml` file like in the above example though, so likely this will be fine.

### Specifying a custom slider template

The default slider template is `Magento_Theme/templates/elements/slider-php.phtml`.

(The template is named `slider-php` because in future a generic slider that requests items through GraphQL and renders them client side might be added, too.)

To use a custom template, specify it as a third argument to the `getSliderForItems` method:

```
<?=
    $sliderViewModel
        ->getSliderForItems('My_Module::my-item.phtml', $items, 'My_Module::my-slider.phtml')
        ->toHtml()
?>
```

### Implementation details for the curious

The generic slider template doesn’t have to be used with the view model - it is also possible to configure it with layout XML and PHP.

That said, it is faster and easier to use the view model. Configuring the slider with layout XML should only be considered on old installations where the `Hyva_Theme` module doesn’t contain the slider view model yet and can’t be upgraded for some reason.

The slider expects a child block to with the alias `slider.item.template` to render the items.

The slider template iterates over all items, assigns the current item to the child block, and calls `toHtml()`.
