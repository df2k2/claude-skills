<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/hyva-svg-icon-modules/index.html -->

# Hyvä SVG Icons

Hyvä Themes come with a customized version of [Lucide Icons](https://lucide.dev/) out of the box.
Our version uses a default stroke width of 1.5, instead of the standard 2, for a slightly finer appearance.

For legacy themes, we also include [HeroIcons v1](https://v1.heroicons.com/).
However, this icon pack is being phased out and will not be updated to [HeroIcons v2](https://heroicons.com/).

All icons are managed through the [SvgIcons module](../../writing-code/working-with-view-models/svgicons.html),
which you can also use to add your own custom SVG icons.

## Using Icons

You can render icons in two primary ways: directly in `.phtml` templates or within CMS content.

### In PHTML Templates

To use icons in your template files, you'll need to instantiate the `LucideIcons` ViewModel.

```
<?php

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Theme\ViewModel\LucideIcons;

/** @var ViewModelRegistry $viewModels */

/** @var LucideIcons $lucideIcons */
$lucideIcons = $viewModels->require(LucideIcons::class);
```

Then, you can render an icon in your `.phtml` file. The method name is the camel-cased icon name, suffixed with `Html`.

For example, to render the `scale` icon with specific classes, dimensions, and accessibility attributes,
you would use the `scaleHtml` method like so:

```
<?= $lucideIcons->scaleHtml('text-gray-500', 24, 24, ['aria-hidden' => 'true']) ?>
```

All icon methods share the same signature: `(string $classnames = '', ?int $width = 24, ?int $height = 24, array $attributes = [])`.
This allows you to pass CSS classes, dimensions, and other HTML attributes.
For accessibility, it is good practice to include `aria-hidden="true"` if the icon is purely decorative.

### In CMS Content

Hyvä provides a convenient `icon` directive to render SVG icons within CMS blocks, pages, and other filtered content.

```
{{icon "lucide/shopping-cart" width=24 height=24}}
```

If you have custom icons placed in your theme's `web/svg/` directory (for example, `web/svg/my-icon.svg`),
you can render them using their filename:

```
{{icon "my-icon"}}
```

This directive is processed by the `Hyva\Theme\Model\Template\IconProcessor`.

Tip

If you need to allow users to paste raw SVG code directly into the WYSIWYG editor,
consider installing the [Hyvä WysiwygSvg](https://github.com/hyva-themes/magento2-wysiwyg-svg) module.
It serves a different purpose than the SvgIcon view model.

## Extending Your Icon Library

You can easily add more icons to your project, whether they are custom-made or from pre-built packages.

### Adding Your Own Icons

Beyond using pre-built icon packs,
you have the flexibility to expand and customize Hyvä's icon system by adding your own SVG icons
or even overriding the default icon set.

This allows for a truly unique and branded storefront.

You can:
- **Add new, theme-specific icons**:
Simply place your `.svg` files in your theme's `web/svg` directory.
- **Override default icons**:
Replace any default Lucide icon by placing an SVG file with the same name in the `web/svg/lucide/` directory of your theme.

For a complete walkthrough on how to implement this,
please follow our detailed guide on [using custom SVG icons in your theme](custom.html).

### Additional Hyvä Icon Packs

We offer official modules for other popular icon sets:

- [Hyvä Heroicons v2](heroicons.html)
- [Hyvä Payment Icons](payment-icons.html)

### Third-Party Icon Packs

The Hyvä community has created and shared a variety of icon packs. Here are some popular options:

- General Icon Packs

  - [Bootstrap Icons](https://github.com/Siteation/magento2-hyva-icons-bootstrap) by Siteation
  - [Boxicons 3](https://github.com/aimanecouissi/magento2-module-hyva-boxicons) by Aimane Couissi
  - [FeatherIcons](https://github.com/Siteation/magento2-hyva-icons-feather) by Siteation
  - [FontAwesome 6](https://github.com/JaJuMa-GmbH/awesome-hyva) by JaJuMa
  - [LucideIcons](https://github.com/Siteation/magento2-hyva-icons-lucide) by Siteation
  - [Phosphor Hyvä](https://github.com/JaJuMa-GmbH/phosphor-hyva) by JaJuMa
- Country Icons

  - [Flags Icons](https://github.com/Siteation/magento2-hyva-icons-flags) by Siteation
  - [Hyvä Flags](https://github.com/JaJuMa-GmbH/hyva-flags) by JaJuMa
- Payment Icons

  - [Payment Icons](https://github.com/Siteation/magento2-hyva-icons-payment) by Siteation

Have you created your own icon pack? We encourage you to share it with the community!

You can discover more community-built icon packs on [GitHub under the #hyva-icons topic](https://github.com/topics/hyva-icons).
