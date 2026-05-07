<!-- source: https://docs.hyva.io/hyva-themes/writing-code/rendering-javascript-once.html -->

# Rendering JS once when it is needed on a page

Since Hyvä 1.3.6

Hyvä generally tries to keep things that change at the same time in the same file, that is, by default, we place JavaScript in the same file with the HTML that uses it.

However, when the HTML is rendered multiple times, for example, items in a product list, this can lead to the duplication of JavaScript in the page source.
In such situations, it can make sense to split the JavaScript into a separate template and render it only once.

Since release 1.3.6 Hyvä allows rendering a JavaScript dependency in a block or template in the before-body-end container through the `Hyva\Theme\ViewModel\PageJsDependencyRegistry` view model.

## Rendering dependent JS via layout XML

It is possible to declare JavaScript dependencies in Layout XML.
A new special block data property named `hyva_js_block_dependencies` can be declared as a block argument to specify block names that should be rendered automatically in case that block is rendered.

For example

```
<block class="Magento\Catalog\Block\Product\AbstractProduct" name="product_list_item"
       template="Magento_Catalog::product/list/item.phtml">
    <arguments>
        <argument name="hyva_js_block_dependencies" xsi:type="array">
            <item name="category.products.list.js.wishlist" xsi:type="boolean">true</item>
        </argument>
    </arguments>
</block>
```

The item key is the JS block dependency name.
The item value has to be an integer or a boolean or a non-empty string.
If the item is set to false, null, or an empty string, the dependency will not be rendered.
This is to allow customizations to be overridden in themes if needed.

Also, it is possible to declare template dependencies using the special block data property `hyva_js_template_dependencies` in the same way.

## Rendering a block with a JS dependency

Alternatively, JavaScript dependencies for a block can be declared in with PHP inside a template.

Beware of the `block_html` cache

If the template block or a parent block is cached in the `block_html`, the JS dependency will not be rendered if the template is served from the cache.
For this reason, it is more reliable to use Layout XML to declare JS dependencies.

To render a block with a JS template on a page only if the current template is rendered, use the `$pageJsRegistry->setBlockNameDependency()` method.

For example:

```
$pageJsRegistry = $viewModels->require(\Hyva\Theme\ViewModel\BlockJsDependencies::class);
$pageJsRegistry->setBlockNameDependency($block, 'category.products.list.js.wishlist');
```

If a block with the name `category.products.list.js.wishlist` is declared, it will then be rendered in the `before.body.end` container.

## Rendering a template with a JS dependency

It's also possible to specify a template directly using the `setBlockTemplateDependency` method:

For example:

```
$pageJsRegistry = $viewModels->require(\Hyva\Theme\ViewModel\BlockJsDependencies::class);
$pageJsRegistry->setBlockTemplateDependency($block, 'Magento_Catalog::product/list/js/wishlist.phtml');
```

This has the same issues in regard to the `block_html` cache as declaring a JS dependency using the `setBlockNameDependency()`;
