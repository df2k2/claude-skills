<!-- source: https://docs.hyva.io/hyva-themes/faqs/customizable-options-on-configurable-cart-items.html -->

# Customizable options on configurable cart items in the GraphQL cart

Archived

This page is kept for reference for stores still using the GraphQL cart.
Since Hyvä 1.1.15, the PHP cart is the default.
The Magento core bug described here was fixed in Magento 2.4.5-p8 and does not affect supported Magento versions.

In Magento releases < 2.4.5-p8 a [bug in the core Magento](https://github.com/magento/magento2/issues/31180) GraphQL schema, customizable options are not available on configurable products in the cart.

Link to the issue in the Hyvä Gitlab (Gitlab Access Needed):

[gitlab.hyva.io/hyva-themes/magento2-theme-module/-/issues/34](https://gitlab.hyva.io/hyva-themes/magento2-theme-module/-/issues/34)

This patch is not required since Magento release 2.4.5-p8.

## How fix the problem in Magento < 2.4.5-p8:

In case you can't upgrade for some reason, you need to patch the core.

### Patching the schema

First you need to patch the bug in the core.

Managing core patches

There are a lot of tooling around maintaining patches for the Magento core.
We can recommend [github.com/elgentos/magento2-composer-quality-patches](https://github.com/elgentos/magento2-composer-quality-patches) which in turn uses [github.com/vaimo/composer-patches](https://github.com/vaimo/composer-patches)

In the file `vendor/magento/module-configurable-product-graph-ql/etc/schema.graphqls` the line 65 needs an additional `!` after the `[SelectedCustomizableOption]`:

Original (wrong):

```
customizable_options: [SelectedCustomizableOption] @resolver(class: "Magento\\QuoteGraphQl\\Model\\Resolver\\CustomizableOptions")
```

New (fixed):

```
customizable_options: [SelectedCustomizableOption]! @resolver(class: "Magento\\QuoteGraphQl\\Model\\Resolver\\CustomizableOptions")
```

### Extending the GraphQL query

Next the `customizable_options` need to be added to the GraphQL cart query.
This can be done either by rewriting the class `\Hyva\Theme\ViewModel\Cart\GraphQlQueriesWithVariables`, or with an event observer.

Tip

We recommend using the event observer approach as it is less prone to conflicts with other customizations.

This documentation has a dedicated page [customizing GraphQL queries and mutations](../writing-code/customizing-graphql.html) with more information.

**Example using the event observer approach**

This example assumes a custom module called `Hyva_MagentoCoreFixes` exists.

#### Configure an event observer

Add a file `app/code/Hyva/MagentoCoreFixes/etc/frontend/events.xml`

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd">
    <event name="hyva_graphql_render_before_cart_query">
        <observer name="magento_core_fix" instance="Hyva\MagentoCoreFixes\Observer\ConfigCustomizableProductsInCartQuery"/>
    </event>
</config>
```

#### Add the observer class

Create the observer class `app/code/Hyva/MagentoCoreFixes/Observer/ConfigCustomizableProductsInCartQuery.php`

```
<?php declare(strict_types=1);

namespace Hyva\MagentoCoreFixes\Observer;

use Hyva\GraphqlViewModel\Model\GraphqlQueryEditor;
use Magento\Framework\Event\Observer as Event;
use Magento\Framework\Event\ObserverInterface;

class ConfigCustomizableProductsInCartQuery implements ObserverInterface
{
    /**
     * @var GraphqlQueryEditor
     */
    private $graphqlQueryEditor;

    public function __construct(GraphqlQueryEditor $graphqlQueryEditor)
    {
        $this->graphqlQueryEditor = $graphqlQueryEditor;
    }

    public function execute(Event $event)
    {
        $queryString = $event->getData('gql_container')->getData('query');

        $queryString = $this->graphqlQueryEditor->addFieldIn(
            $queryString,
            ['cart', 'items', '... on ConfigurableCartItem', 'customizable_options'],
            'label'
        );

        $queryString = $this->graphqlQueryEditor->addFieldIn(
            $queryString,
            ['cart', 'items', '... on ConfigurableCartItem', 'customizable_options', 'values'],
            'label value'
        );

        $queryString = $this->graphqlQueryEditor->addFieldIn(
            $queryString,
            ['cart', 'items', '... on ConfigurableCartItem', 'customizable_options', 'values', 'price'],
            'value type'
        );

        $event->getData('gql_container')->setData('query', $queryString);
    }
}
```

Now add an event observers for the event `hyva_graphql_render_before_customer_cart_query` using `customerCart` instead of `cart` in the path arrays.

The first one is used for guest carts, the second one for logged in customers.

With the patch and the observers in place, the customizable options will also be available on configurable products.
