<!-- source: https://docs.hyva.io/hyva-themes/writing-code/working-with-view-models/index.html -->

# Working with View Models

We like Magento view models a lot! In comparison to custom block classes, they are more reusable and composable. You can add an arbitrary number of view models to any template block via layout XML.

But after introducing a bunch of useful view models in Hyvä we got tired of all that seemingly unnecessary XML and thought of a simpler solution:

## The View Model Registry

In a Hyvä theme, in every template, a variable `$viewModels` is automatically available, introduced by `hyva-themes/magento2-theme-module`, similar to the existing `$block` and `$escaper` variables. You can use it to fetch any view model (i.e. any class that implements `ArgumentInterface`).

### Example:

```
<?php

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Theme\ViewModel\CurrentProduct;

/** @var ViewModelRegistry $viewModels */
/** @var CurrentProduct $currentProduct */
$currentProduct = $viewModels->require(CurrentProduct::class);
```

It is no longer needed to declare view models in XML!

You can read more about the usage of ViewModels versus Blocks here: [Firegento - Better Blocks: Magento 2 PHP View Models](https://firegento.com/blog/2017/12/07/better-blocks-magento-2-php-view-models/).

## View Model Cache Tags

View models are often used to provide data to be rendered in a template.

In case you need the cache tags from some entities to be included in the HTTP response for the FPC cache record, you can implement the `Magento\Framework\DataObject\IdentityInterface` and return the required cache tags.
They will be included in the HTTP response `X-Magento-Tags` header automatically.

For more information have a look at the [in depth documentation](../../performance/view-model-cache-tags.html).

## View Model cache tags in ESI cached blocks

If a block has a `ttl="..."` attribute in layout XML, it will be cached by Varnish and included as an ESI section.
If the view model also implements the `IdentityInterface` to provide cache tags to the full page cache, this leads to the situation where the cache tags are added to both the full page cache record and also the ESI cache record.

However, the desired behavior is that the cache tags are only added to the ESI cache record.

To allow the view model registry to detect if the view model is rendered in a template that as part of an ESI section, the `$block` variable needs to be passed to the `$viewModelRegistry->require()` method as a second argument.

```
$currentProduct = $viewModels->require(CurrentProduct::class, $block);
```

Only pass `$block` when required

The `$block` argument only needs to be specified for view models with cache tags that are used in templates rendered in an ESI section.

In the default Hyvä theme, this is only true for the top menu block templates `Magento_Theme/templates/html/header/menu/desktop.phtml` and `Magento_Theme/templates/html/header/menu/mobile.phtml`.

Do not specify the `$block` argument everywhere just in case.
