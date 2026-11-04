<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/hyva-svg-icon-modules/custom.html -->

# Using Custom Icons in Your Theme

It’s possible to add your own custom icons to your theme,
as well as override the default icons that are included with Hyvä.

## Adding Theme-Specific Icons

To add a custom, theme-specific icon set, create a `web/svg` directory inside your theme's root folder.

For example, for a theme located at `app/design/frontend/Acme/Theme`,
the full path for your custom icons would be `app/design/frontend/Acme/Theme/web/svg`.

Place your custom SVG icon files in this directory. For example, `rainbow-unicorn.svg`.

### Rendering Icons

To render a custom icon, first,
instantiate the `Hyva\Theme\ViewModel\SvgIcons` view model in your `.phtml` template:

```
<?php

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Theme\ViewModel\SvgIcons;

/** @var ViewModelRegistry $viewModels */
$hyvaicons = $viewModels->require(SvgIcons::class);
```

Then, you can render an icon using one of two methods:

#### With `renderHtml()`

Pass the icon's filename (without the `.svg` extension) to the `renderHtml()` method.

```
<?= $hyvaicons->renderHtml('rainbow-unicorn') ?>
```

#### With a Magic Method

A more convenient way is to call a method named after the icon file.

Convert the `kebab-case` filename to a `camelCase` method name and append `Html`.

For example, `rainbow-unicorn.svg` becomes `rainbowUnicornHtml()`:

```
<?= $hyvaicons->rainbowUnicornHtml() ?>
```

## Overriding Default Icons

The default icons included in Hyvä (from the Lucide icon set) can be overridden using Magento's standard theme fallback mechanism.

To override a default icon, place a file with the same name in the corresponding path within your theme.

For the default Lucide icons, the path is: `Hyva_Theme/web/svg/lucideicons/`.

For example, to override the default `arrow-left.svg` icon,
you would place your custom version at `Hyva_Theme/web/svg/lucideicons/arrow-left.svg`.

Hyvä will automatically pick up your version of the icon.
