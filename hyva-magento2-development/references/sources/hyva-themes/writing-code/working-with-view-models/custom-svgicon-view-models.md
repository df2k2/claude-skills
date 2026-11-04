<!-- source: https://docs.hyva.io/hyva-themes/writing-code/working-with-view-models/custom-svgicon-view-models.html -->

# Creating a custom SVG Icon View Model

There are many beautiful and creative SVG icon sets available, and you might want to create a custom SVG icon view model to be able to easily use them within your Hyvä themes.

Custom SVG icon view models are usually created within a custom module so they can be installed in any Magento instance with a Hyvä theme.

Check for existing icon packs

Before creating your own, you might want to check if a package for your desired icon set already exists.
The community has contributed several [third-party icon packs](../../view-utilities/hyva-svg-icon-modules/index.html#third-party-icon-packs).
These can also serve as a great reference for creating your own.

## The SVG icon files

Copy the SVG icon files into your modules directory `view/frontend/web/svg`.
The file names should all be lower case and consist only of the characters a-z, numbers and hyphens, and end with the file name extension `.svg`.

Examples for valid icon files

- `view/frontend/web/svg/my-special-icon.svg`
- `view/frontend/web/svg/arrow-2.svg`

If there are different icon-sets for the SVG icon package, for example *light* and *dark*, or *solid* and *outline*, they can be placed in appropriately named subdirectories:

```
view/frontend/web/svg/outline/
view/frontend/web/svg/solid/
```

## Create the PHP View Model Class

Create a view model with a fitting name in your module and extend the base class `\Hyva\Theme\ViewModel\SvgIcons`.

```
<?php

declare(strict_types=1);

namespace My\Module\ViewModel;

use Hyva\Theme\ViewModel\SvgIcons;

class ExampleIcons extends SvgIcons
{

}
```

Warning

The `SvgIcons` class is only suitable to be used as a base class for SVG icon view models outside the `magento2-hyva-theme` module since Hyvä release 1.1.12.
Remember to add `'hyva-themes/magento2-theme-module': '>=1.1.12'` as a dependency to your modules `composer.json`.

## Configure the `iconPathPrefix`

This is best done with in `etc/di.xml`:

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <type name="My\Module\ViewModel\ExampleIcons">
        <arguments>
            <argument name="iconPathPrefix" xsi:type="string">My_Module::svg/solid</argument>
        </arguments>
    </type>
</config>
```

Use the primary scope etc/di.xml to set the iconPathPrefix, not the frontend scope.

If the iconPathPrefix is set in the `etc/frontend/di.xml` scope, the preview of PageBuilder CMS content with SVG icons will be broken.

The `iconPathPrefix` will be prepended to any icon names that will be rendered by this class.

```
$myIcons = $viewModels->require(\My\Module\ViewModel\ExampleIcons::class);
echo $myIcons->renderHtml('bubble-bath');
// -> My_Module::svg/solid/bubble-bath.svg
```

## Providing IDE auto-completion

To provide auto-completion for PHPStorm or other IDEs, add `@method` phpdoc annotations for every icon in your icon set.

```
/**
 * @method string bubbleBathHtml(string $classnames = '', ?int $width = 24, ?int $height = 24, array $attributes = [])
 * @method string hotShowerHtml(string $classnames = '', ?int $width = 24, ?int $height = 24, array $attributes = [])
 * @method string oldSinkHtml(string $classnames = '', ?int $width = 24, ?int $height = 24, array $attributes = [])
 * @method string newSinkHtml(string $classnames = '', ?int $width = 24, ?int $height = 24, array $attributes = [])
 */
class ExampleIcons extends SvgIcons
{

}
```

Generating the method signatures

The annotations for the Heroicon view models included in the Hyva\_Theme module are generated using a bash script (Gitlab Access Needed).
Be sure to adjust the path to match your themes directory containing the SVG icons.

## Making your icons available in CMS content

SVG icons can be included in CMS content using the `{{icon "..."}}` syntax.

Custom icon sets can be made available by providing a `pathPrefixMapping` for your modules folder in `etc/frontend/di.xml`.

```
<type name="Hyva\Theme\ViewModel\SvgIcons">
    <arguments>
        <argument name="pathPrefixMapping" xsi:type="array">
            <item name="example" xsi:type="string">My_Module::svg</item>
        </argument>
    </arguments>
</type>
```

Once this is in place, your modules icons can be included in CMS content using

```
{{icon "example/hot-shower" classes="w-6 h-6" width=12 height=12}}
```

The first part of the icon path is mapped to the specified `pathPrefix`, so the resulting SVG asset path in this example is `My_Module::svg/hot-shower.svg`.

Info

The phpdoc block of the `\Hyva\Theme\ViewModel\SvgIcons` class contains a lot more information on implementation details and further ways to customize the functionality, even though in practice you probably will not need any of them.
