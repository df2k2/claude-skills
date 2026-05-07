<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-v2-and-v3-compatible-code.html -->

# Writing Alpine v2 and v3 compatible code

Especially for extension developers, the question is which Alpine.js version to support.

It actually is not hard to write Alpine components that work with both version 2 and version 3.
This page give some insight what to watch out for in order to be able to keep your extensions compatible with any version of Hyvä.

## `x-spread` and `x-bind`

Alpine.js v2 uses `x-spread` while v3 uses `x-bind`.
To support both versions of Alpine.js, simply add both attributes.

Here is an example from a component using a Hyvä modal:

```
<div
    class="fixed inset-0 z-30 flex items-center justify-center text-left"
    x-spread="overlay()"
    x-bind="overlay()"
    x-cloak
>
    ... the other modal code here ...
</div>
```

## Using `$el`

In Alpine v2, the property `$el` always referred to the component root DOM element.
In Alpine v3, the property `$el` refers to the DOM element the currently evaluated binding is on.

In order to write components that are compatible with both v2 and v3, only use `$el` on the base element of the component.
If you need to reference another element, add a `x-ref` or use `querySelector()` to fetch the element using vanilla JS.

```
<div x-data="{ result: 0 }">
    <button
        x-ref="btn"
        data-value="6"
        @click="result += parseInt($refs.btn.dataset.value)"
    >...<button>
</div>
```

## Using `$root`

In Alpine v2 `$root` is not available. Either don't use it at all (recommended), or alias it to `$root` in an init method so it is also available in Alpine v2:

```
<div
    x-data="{
        init(root) {
            if (!this.$root) this.$root = root;
        }
    }"
    x-init="init($el)"
>
    ...
</div>
```

## Using `x-init`

In Alpine.js v2, initialization functions always needed to be called explicitly with `x-init`.
In Alpine.js v3, a method called `init` is called automatically.

To enable Alpine.js v2 compatibility , do not rely on the implicit evocation of `init`, and instead always explicitly use `x-init="init"`.

## `@click.away` or `@click.outside`

The Alpine v2 modifier `click.away` was renamed to `click.outside` in version 3.
To support both versions of Alpine in your component, simply use both modifiers:

```
<div @click.away.outside="open = false">
    ...
</div>
```

## Using Alpine plugins

With Alpine.js v3, many plugins are provided out of the box, and it is very common to write custom plugins, since the API was improved a lot over version 2.

However, the easiest way to write cross version compatible components is to not use any plugins at all, unless the plugin in question is available for both versions of Alpine.
One example for such a plugin is the `intersect` plugin, that comes natively with Alpine v3, and a backport for Alpine v2 is provided as part of Hyvä, so `x-intersect="..."` can be safely used regardless of the Alpine version.

If you want to rely on any other plugin, then it mostly likely will require backporting it to version 2 yourself, and ensuring the right version is loaded (see below).

## Rendering templates depending on the Alpine version

The theme file `etc/hyva-libraries.json` specifies which version of a library to load.
The versions listed in that file can be read with the view model method `\Hyva\Theme\ViewModel\ThemeLibrariesConfig::getVersionIdFor`.
Both the Alpine.js and the intersect plugin version to load into a theme are determined in this way:

```
<?php

/** @var Template $block */
/** @var ViewModelRegistry $viewModels */

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Theme\ViewModel\ThemeLibrariesConfig;
use Magento\Framework\View\Element\Template;

$themeLibrary = $viewModels->require(ThemeLibrariesConfig::class);
$version = $themeLibrary->getVersionIdFor('intersect-plugin')
    ?: $themeLibrary->getVersionIdFor('alpine')
    ?: '2';

?>
<?= /** @noEscape */ $block->fetchView($block->getTemplateFile("Hyva_Theme::page/js/plugins/v${version}/intersect.phtml")) ?>
```

The above code first checks if a specific version for the `intersect-plugin` is listed in the file.
If not, it checks if an Alpine.js version is specified.
If nothing is specified - as would be the case if there is no `etc/hyva-libraries.json` file - it defaults to version `2`.
Then the version is used to build the fully qualified path to the template file to render.

The same pattern can be applied to render custom JavaScript code depending on the Alpine version of a theme.

## Warning if the Alpine version is too old

If you choose to only support one version of Alpine.js, please indicate so clearly at the top of the module README and in the module documentation.
But if a Magento instance has more than one store view with different themes, each theme might be using a different Alpine version.

To declare a dependency on a minimum Alpine version, a module can use layout XML to add a child to the `require-alpine-v3` block.

```
<body>
    <referenceBlock name="require-alpine-v3">
        <block name="My_Module"/>
    </referenceBlock>
</body>
```

If this module then is used with a theme that has a lower Alpine version, a warning is logged to the browser console:

```
The current Alpine.js version is 2.8.2, but version >= 3 is required by the following extensions:
[
    'My_Module'
]
```

The name of the child block should match the module name, since it will be listed in the error message.

This approach is only to declare a minimum version

There is no generic way to specify a dependency on a lower Alpine version (for example version 2) and show a warning if a higher Alpine version is present.
