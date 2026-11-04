<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/hyva-svg-icon-modules/heroicons.html -->

# Hyvä HeroIcons v2

By default, Hyvä provides HeroIcons v1. You don't need to do anything additional to use this version—simply use the provided ViewModels or the CMS `{{icon}}` directive.

In addition to v1, we also offer HeroIcons v2, the latest version at the time of writing. This version is explained below.

## Installation

Install the package via:

```
composer require hyva-themes/magento2-heroicons2
bin/magento setup:upgrade
```

*This icon pack requires a Hyvä theme license to use.*

## How to Use

Usage example:

```
<?php

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Heroicons2\ViewModel\Heroicons2Outline;

/** @var ViewModelRegistry $viewModels */

/** @var Heroicons2Outline $heroicons */
$heroicons = $viewModels->require(Heroicons2Outline::class);
```

You can use the icons in your `.phtml` files, similar to the way you use HeroIcons v1:

```
<?= $heroicons->shoppingCartHtml('', 24, 24, ["aria-label" => "Go to Cart Page"]) ?>
```

### Using SVG Icons in CMS Content

Icons can also be rendered in CMS content using the `{{icon}}` directive.

To find the path of the SVG file, navigate to `view/frontend/web/svg` and remove the `.svg` extension.

For example, the file path `view/frontend/web/svg/heroicons2/24/outline/shopping-cart.svg` can be used as `heroicons2/24/outline/shopping-cart`.

Usage example in CMS pages:

```
{{icon "heroicons2/24/outline/shopping-cart" classes="inline-block" width=24 height=24 title="Go to Cart Page"}}
```

### Extension and Customization

For more details on using and customizing SvgIcons in Hyvä Themes, refer to the official Hyvä documentation: [SvgIcons in Hyvä Themes](../../writing-code/working-with-view-models/svgicons.html).

## Available Icons

HeroIcons provides a comprehensive list of available icons and their versions. For more information, visit the official HeroIcons documentation: [HeroIcons](https://heroicons.com/).
