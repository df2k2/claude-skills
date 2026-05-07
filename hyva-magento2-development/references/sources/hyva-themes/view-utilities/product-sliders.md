<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/product-sliders.html -->

# Product Sliders

As of Hyvä release 1.1.9, product sliders are rendered on the server-side (SSR). This approach avoids potential layout shifts and performance issues associated with the previous client-side rendered sliders. SSR sliders also support features like swatches and "Add to Cart" functionality directly within the slider.

Backward Compatibility

The old GraphQL-based client-side slider template (`Magento_Theme/templates/elements/slider.phtml`) is deprecated but remains available for backward compatibility.

Page Builder

The SSR product sliders described here are different from the sliders provided by Adobe Commerce Page Builder.

## How to Use

To use a product slider, you need to add the `hyva_product_slider` layout handle to your page. Then, declare a block with the `Magento_Catalog::product/slider/product-slider.phtml` template and configure it using the arguments below.

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <update handle="hyva_product_slider" />
    <body>
        <referenceContainer name="content">
            <block name="my-slider" template="Magento_Catalog::product/slider/product-slider.phtml">
                <arguments>
                    <argument name="title" xsi:type="string" translate="true">My Awesome Slider</argument>
                    <argument name="category_ids" xsi:type="string">25</argument>
                    <argument name="page_size" xsi:type="number">8</argument>
                </arguments>
            </block>
        </referenceContainer>
    </body>
</page>
```

## Configuration

The slider block can be configured with the following arguments:

### Slider Display Options

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | String |  | **Required.** The accessible label and visual heading for the slider. |
| `heading_tag` | String | `h3` | The HTML tag for the visual heading. |
| `show_heading` | Boolean | `true` | Whether to display the visual heading. |
| `heading_css_classes` | String | `text-2xl font-medium` | CSS classes for the heading element. |
| `css_classes` | String | `my-8` | CSS classes for the main block container. |
| `slider_css_classes` | String |  | CSS classes for the slider track element. |
| `column_count` | Number | `4` | The number of slides to show at the largest breakpoint. |
| `show_pager` | Boolean | `true` | Whether to show the pager dots below the slider. |
| `slider_name` | String | *Block Name* | A unique ID for the slider, used for the skiplink. |

### Product Content Options

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `hide_rating_summary` | Boolean | `false` | Hides the star rating summary for products. |
| `hide_details` | Boolean | `false` | Hides product details like swatches. |

### Product Selection & Filtering

#### `type`

(Type: `string`, Default: `none`)

Displays products based on their relation to the current context.
- `related`: Shows products related to the main product on a product detail page.
- `upsell`: Shows upsell products on a product detail page.
- `crosssell`: Shows cross-sell products for items currently in the cart. Can be used on any page.

*Example:*

```
<argument name="type" xsi:type="string">crosssell</argument>
```

#### `category_ids`

(Type: `string`, Default: `none`)

A comma-separated list of category IDs. Products from these categories will be displayed.

*Example:*

```
<argument name="category_ids" xsi:type="string">25,26</argument>
```

#### `include_child_category_products`

(Type: `boolean`, Default: `false`, *Available since 1.1.18*)

When `category_ids` is set to a single anchor category, setting this to `true` will include products from all its child categories. This argument has no effect if multiple categories are specified or if the category is not an anchor category.

*Example:*

```
<argument name="include_child_category_products" xsi:type="boolean">true</argument>
```

#### `product_skus`

(Type: `string`, Default: `none`, *Available since 1.1.10*)

A comma-separated list of product SKUs to display in the slider. SKUs containing commas are not supported.

*Example:*

```
<argument name="product_skus" xsi:type="string">MH01,MH02,MH03</argument>
```

#### `price_from` / `price_to`

(Type: `string`, Default: `none`)

Filters products to show only those within the specified price range.

*Example:*

```
<argument name="price_from" xsi:type="string">20</argument>
<argument name="price_to" xsi:type="string">100</argument>
```

#### `additional_filters`

(Type: `array`, Default: `none`)

Applies custom filter criteria to the product collection, using the `SearchCriteria` filter syntax. The default `conditionType` is `eq`.

Possible `conditionType` values:
- `eq`, `neq`
- `like`
- `in`, `nin`
- `notnull`, `null`
- `from`, `to`
- `gt`, `lt`, `gteq`, `lteq`, `moreq`
- `finset`
- `regexp`

*Example (filtering by color attribute):*

```
<argument name="additional_filters" xsi:type="array">
    <item name="color-filter" xsi:type="array">
        <item name="field" xsi:type="string">color</item>
        <item name="value" xsi:type="array">
            <item name="blue" xsi:type="string">24</item>
            <item name="red" xsi:type="string">28</item>
        </item>
        <item name="conditionType" xsi:type="string">in</item>
    </item>
</argument>
```

#### `page_size`

(Type: `number`, Default: `8`)

The maximum number of products to display in the slider.

Limitation for `crosssell` sliders

The `page_size` argument does not work for `crosssell` sliders. To change the number of cross-sell items, you must customize the `maxCrosssellItemCount` constructor argument of `\Hyva\Theme\ViewModel\ProductList` via `di.xml`.

*Example:*

```
<argument name="page_size" xsi:type="number">12</argument>
```

### Product Sorting

#### `sort_attribute`

(Type: `string`, Default: `position`)

The product attribute to sort the slider items by.

*Example:*

```
<argument name="sort_attribute" xsi:type="string">created_at</argument>
```

#### `sort_direction`

(Type: `string`, Default: `ASC`)

The direction for sorting. Can be `ASC` (ascending) or `DESC` (descending).

*Example:*

```
<argument name="sort_direction" xsi:type="string">DESC</argument>
```

## Full Example

Here is a complete example of a slider showing red, yellow, and orange products from categories 5 and 6, with a price between 30 and 100, sorted by price.

*Note: Attribute option and category IDs may be different on your Magento instance.*

```
<block name="redish-products-slider" template="Magento_Catalog::product/slider/product-slider.phtml">
    <arguments>
        <argument name="title" xsi:type="string" translate="true">Our favorites in Red</argument>
        <argument name="category_ids" xsi:type="string">5,6</argument>
        <argument name="additional_filters" xsi:type="array">
            <item name="color-filter" xsi:type="array">
                <item name="field" xsi:type="string">color</item>
                <item name="value" xsi:type="array">
                    <item name="orange" xsi:type="string">56</item>
                    <item name="red" xsi:type="string">58</item>
                    <item name="yellow" xsi:type="string">60</item>
                </item>
                <item name="conditionType" xsi:type="string">in</item>
            </item>
        </argument>
        <argument name="price_from" xsi:type="string">30</argument>
        <argument name="price_to" xsi:type="string">100</argument>
        <argument name="sort_attribute" xsi:type="string">price</argument>
        <argument name="sort_direction" xsi:type="string">DESC</argument>
        <argument name="hide_rating_summary" xsi:type="boolean">true</argument>
        <argument name="hide_details" xsi:type="boolean">true</argument>
    </arguments>
</block>
```

## Legacy Configuration (pre-1.4.0)

The following arguments were used in versions of Hyvä prior to 1.4.0. They are now deprecated and should not be used in modern Hyvä themes.

- **`item_template`**: This option has been removed. Product item rendering is now consistently handled by `Magento_Catalog/templates/product/list/item.phtml`.
- **`container_template`**: This option has been removed.
- **`max_visible`**: This option has been renamed to `column_count`.
- **`maybe_purged_tailwind_slide_item_classes`**: This option has been renamed to `css_classes`, which applies classes to the main slider block. The number of visible items is now controlled by `column_count`.
