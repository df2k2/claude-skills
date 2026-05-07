<!-- source: https://docs.hyva.io/hyva-themes/writing-code/customizing-graphql.html -->

# Customizing GraphQL

The Hyvä default theme uses GraphQL queries occasionally, for example on the cart page.

The queries and mutations are built either in the templates or in view models like `\Hyva\Theme\ViewModel\Cart\GraphQlQueriesWithVariables`.

Often customizations require adding new fields to the requested data, or changing or adding GraphQL arguments.

Instead of overriding the template or plugging into the view model methods, GraphQL queries can be changed using Magento event observers.

This is made possible by the [hyva-themes/magento2-graphql-view-model](https://github.com/hyva-themes/magento2-graphql-view-model/blob/main/README.md).

## How it works

The module is currently only used in Hyvä, but it can potentially be used in any Magento theme.

The view model is freely available as open source on GitHub.

### How queries are made “editable”

In the `.phtml` templates, queries and mutations are wrapped in the `GraphqlViewModel::query()` method.

Here is a simplified query for example’s sake:

```
<?php $gqlViewModel = $viewModels->require(\Hyva\GraphqlViewModel\ViewModel\GraphqlViewModel::class); ?>

<?= $gqlViewModel->query("product_list_query", "
products(filter: {} pageSize: 20) {
  items {
    {$type}_products {
        sku
        id
        small_image {
          url
        }
    }
  }
}", ['type' => $type])
?>
```

The `GraphqlViewModel::query()` method takes three arguments.

- The first argument `$queryIdentifier` is the event name suffix.
- The second argument `$query` is the query or mutation as a string.
- The third argument `$eventParams` is optional and - if specified - will be merged into the Magento event arguments.

The event prefix is `hyva_graphql_render_before_`.

In the above example. the full event name for the query is `hyva_graphql_render_before_product_list_query`.

### How to edit queries and mutations

To manipulate a query in an event observer, the `\Hyva\GraphqlViewModel\Model\GraphqlQueryEditor` can be used.

The editor has two methods:

- `addFieldIn(string $query, array $path, string $field)`
- `addArgumentIn(string $query, array $path, string $key, $value)`

The method signatures are similar:

- The first argument is the query or mutation to edit.
- The second argument is the path into the request or argument object hierarchy
- The third argument is the field to add
- For `addArgumentIn`, the fourth argument is the value of the argument field.

They both return the changed GraphQL query string.

### Example

Another Example

An additional example can be found in the FAQ topic [Customizable options on configurable cart items](../faqs/customizable-options-on-configurable-cart-items.html).

```
public function execute(Observer $event)
{
    $gqlEditor = new GraphqlQueryEditor(); // or use dependency injection

    // Get the query or mutation from the event
    $queryString = $event->getData('gql_container')->getData('query');

    // Get additional data if available or required.
    // The link type in this example is only available for product sliders
    $linkType  = $event->getData('type');

    // The path into the query
    $path  = ['products', 'items', ($linkType ? "{$linkType}_products" : 'products'), 'small_image'];

    // Add a field to the requested result object
    $queryString = $gqlEditor->addFieldIn($queryString, $path, 'url_webp');

    // Set updated query back on container
    $event->getData('gql_container')->setData('query', $queryString);
}
```

The result of the method call

```
$gqlEditor->addFieldIn(
    $queryString,
    ['products', 'items', 'products', 'small_image'],
    'label url_webp'
)
```

is that in the query the fields at the specified path are set, in addition to any already existing fields.

Note that above **two** fields are being set within the `small_image` object, so after that call at least the following fields will exist on the result:

```
products {
  items {
    products {
      small_image {
        label
        url_webp
      }
    }
  }
}
```

Both the `addFieldIn` and the `addArgumentIn` methods are idempotent, so if the specified values already exist in the query string they are not changed.

The `addArgumentIn` method can be used to add new arguments to queries or mutations, or to overwrite values of existing arguments.

For more examples including inline fragments please have a look at the test cases in `\Hyva\GraphqlViewModel\Model\GraphqlQueryEditorTest` .
