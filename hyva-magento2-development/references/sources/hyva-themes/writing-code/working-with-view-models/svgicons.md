<!-- source: https://docs.hyva.io/hyva-themes/writing-code/working-with-view-models/svgicons.html -->

# SvgIcons View Model

The `SvgIcons` view model is our basis for any Icon pack in Hyvä and can be extend by your own Icon Pack if desired.

This can be done by adding your own Module or using the `SvgIcons` view model to load icons directly from your Theme.

## Using the `SvgIcons` view model

```
<?php

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Theme\ViewModel\SvgIcons;

/** @var ViewModelRegistry $viewModels */

/** @var SvgIcons $hyvaicons */
$hyvaicons = $viewModels->require(SvgIcons::class);
```

Then render the icons like this:

```
<?= $hyvaicons->renderHtml('rainbow-unicorn', 32, 32) ?>
```

The method name is the camel cased icon name, followed by `Html`.

All methods take the following arguments:

```
string $classnames = '', ?int $width = 24, ?int $height = 24, array $attributes = []
```

All parameters are optional, and change the `class` , `width` and `height` attributes of the SVG element, or add additional HTML `attributes`.

While it's not recommended to remove the SVG width and a height attribute,
you can do so by passing `null` as the second and third argument.

```
<?= $hyvaicons->renderHtml('rainbow-unicorn', null, null) ?>
```

## Icon pack options

With Hyvä and from 3de party options we offer a wide range of Icon Pack options.

For more info on what is aviable see the [Hyvä Icons Docs](../../view-utilities/hyva-svg-icon-modules/index.html).

## Using a custom SVG icon set in your theme

This is the simplest method to extend any icon pack and use your own icons.

For a full guide on how to do this you can follow the [guide in the Custom Icons Docs](../../view-utilities/hyva-svg-icon-modules/custom.html).

## Accessibility

If you use an icon for decorative purposes, hide it from assistive technologies (ATs), using `aria-hidden="true"`.

Otherwise, if both of these conditions are true:

- there is no `role="img"` attribute
- there is no `aria-hidden="true"` attribute

the `\Hyva\Theme\ViewModel\SvgIcons` will add a `<title>Icon Name</title>` node inside the `<svg>` tag before the `<path>` to ensure AT can provide the visitor with some information about the icon.

A11y related processing of SVG Icon attributes was released in Hyvä 1.3.0
