<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/visual-feedback-to-user-actions.html -->

# Visual feedback to user actions

It is good to give visual clues how to accomplish tasks when a user interacts with a page.

This example will show a common way to do this with both jQuery and Knockout.js in Luma, and then how that could be done with Alpine.js.

The example task is to add opacity to an image when a checkbox is checked.

This is the HTML:

```
<input type="checkbox" id="<?= $escapedId ?>" value="1">
<img src="<?= $field->getMediaUrl() ?>">
```

## With jQuery

With jQuery, a require.js module would be loaded with `data-mage-init` or `x-magento-init`, and some code like the following would take care of adding the `opacity-40` class to the image:

```
$(selector).change(() => $(this).next('img').toggleClass('opacity-40'));
```

## With Knockout

Using Knockout, a view model scope would be assigned using `x-magento-init` and `Magento_Ui/js/core/app`.

The view model would have an observable property, maybe called `isSelected`. This property would be referenced from the DOM as something like this:

```
<input type="checkbox" id="<?= $escapedId ?>" value="1"
       data-bind="checked: isChecked">
<img src="<?= $field->getMediaUrl() ?>
     data-bind="css: {'opacity-40': isSelected}">
```

## With Alpine.js

In Hyvä, the task is done with Alpine.js. The biggest difference is that no external JavaScript file is loaded.

```
<div x-data="{ isSelected: true }">
    <input type="checkbox" id="<?= $escapedId ?>" value="1" x-model="isSelected">
    <img src="<?= $field->getMediaUrl() ?>" :class="{ 'opacity-40': isSelected}">
</div>
```

Or, alternatively, with more "vanilla" JavaScript:

```
<?php
// generate a unique JS property name (has to start with a character)
$refId = $escaper->escapeHtmlAttr('i' . md5($escapedId)); ?>

<input type="checkbox" id="<?= $escapedId ?>" value="1"
       x-on:change="$refs.<?= $refId ?>.classList.toggle('opacity-40')">
<img src="<?= $field->getMediaUrl() ?>"
     x-ref="<?= $refId ?>">
```

Thanks to Alpine.js [*references*](https://alpinejs.dev/directives/ref) feature, next to no JavaScript is needed to achieve simple changes like this one.
