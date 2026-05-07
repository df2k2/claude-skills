<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/rendering-cart-page-items.html -->

# Rendering GraphQL Cart Page Items

This page refers to the GraphQL Cart

Since release 1.1.15, Hyvä uses a cart page rendered by PHP by default.
This page is about rendering cart items in the GraphQL cart page.

Rendering cart page items for the PHP cart works very similar to how it is done in Luma, so we do not provide special documentation.
It’s different in the Hyvä GraphQL cart page.

PHP item renderers can not be used with the Hyvä GraphQL cart, because cart items are rendered client side using Alpine.js.

The data is fetched by GraphQL.

There are two general approaches to customizing how cart items are rendered.

## Customizing the Cart GraphQL query

If additional data needs to be fetched via GraphQL - for example, for a custom product type - the usual approach is to [customize the GraphQL queries](../writing-code/customizing-graphql.html) using Magento Event Observers and the GraphQL Query Editor.

## Customizing the Cart GraphQL response

Changing the GraphQL response is only possible within the limits of the GraphQL schema.

Changing a field object type can be a lot of work and is not recommended, as this quickly requires many overwrites everywhere a type is used.

The easiest way to supply additional information to the frontend is to add a custom field to the `CartItemInterface` schema in your modules `schema.graphqls` file and populate it with a custom resolver.
Alternatively, it might also be sufficient to configure a plugin to the core `Magento\QuoteGraphQl\Model\Resolver\CartItems` resolver and customize some existing return value, as long as it doesn’t change the declared type.

Any plugins to GraphQL resolvers should be declared in the `graphql` area, that is, in a `etc/graphql/di.xml` file.

## Rendering custom cart item options

In most cases the general rendering of cart item is sufficient.
However, sometimes custom cart item options need to be rendered.

This can be done by adding a child block to the `additional.cart.item.options` container.

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="additional.cart.item.options">
            <block name="my-custom-cart-item-options"
                   template="My_Custom::cart/item/custom-options.phtml"/>
        </referenceContainer>
    </body>
</page>
```

The block will be automatically rendered within section of the parent template iterating over the cart items.

The template for rendering custom cart item options will look something like this:

```
<template
    x-if="item.my_custom_options && Object.keys(item.my_custom_options).length > 0">
    <div>
        <template x-for="option in item.my_custom_options">
            <div class="sm:grid grid-cols-4 pb-2">
                <div class="text-sm font-semibold inline-block">
                    <span x-text="option.label"></span>:
                </div>
                <div class="text-sm col-span-3 inline-block">
                    <template x-if="option.code === 'my_special_price'">
                        <span class="text-gray-700" x-text="hyva.formatPrice(option.value)"></span>
                    </template>
                    <template x-if="option.code !== 'my_special_price'">
                        <span x-text="option.value"></span>
                    </template>
                </div>
            </div>
        </template>
    </div>
</template>
```

The `item` property represents the data returned by GraphQL for each quote item.

## Customizing cart item rendering beyond custom options

To make more far-reaching customizations, the template file `Magento_Checkout/templates/cart/items.phtml` needs to be overridden.

Tip

Please be aware that this is a big file and overriding it might make harder to merge future upgrades, so it might be better to stick with custom cart item options rendering - if that is possible.
