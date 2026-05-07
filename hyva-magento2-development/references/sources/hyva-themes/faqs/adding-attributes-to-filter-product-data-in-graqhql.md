<!-- source: https://docs.hyva.io/hyva-themes/faqs/adding-attributes-to-filter-product-data-in-graqhql.html -->

# Adding attributes to filter product data in GraphQL

## Fixing ‘Field X is not defined’ errors

If you run into errors such as:

`"Field "sku" is not defined by type ProductAttributeFilterInput.`

That means the attribute is not enabled for filtering. This can be changed by either:

- Setting the **Use in Layered Navigation** field of the attribute to **Filterable (with results)** or **Filterable (no results)**.
  This field allows the attribute to be used as a filter and returns layered navigation and aggregation data. If this field is set to **No**, then the attribute will not return layered navigation and aggregation data.
- Setting the **Use in Search** and **Visible in Advanced Search** fields to **Yes**.
  These fields allow Magento to index the attribute’s contents, making the data available for quick and advanced searches. Setting both these fields also allows the attribute to be used in the filter navigation. These fields do not configure the presence or absence of layered navigation and aggregation data. If you set only one of these fields to **Yes**, the attribute cannot be used as a filter, unless you also set the **Use in Layered Navigation** field to a value other than **No**.

Source: [developer.adobe.com/commerce/webapi/graphql/usage/custom-filters/](https://developer.adobe.com/commerce/webapi/graphql/usage/custom-filters/)
