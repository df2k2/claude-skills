<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/product-detail-page-attributes.html -->

# Product Detail Page Attributes

Product Attributes are listed on the default Hyvä Product Detail Page at two places:

1. Below the short description in the `Magento_Catalog::product/view/product-info.phtml` template
2. In the "More Information" section towards the end of the page in the `Magento_Catalog::product/view/attributes.phtml` template.

## Below the Short Description

The attributes rendered below the short description are defined in Layout XML as arguments to the `product.info` block.

```
<block class="Magento\Catalog\Block\Product\View"
       name="product.info"
       template="Magento_Catalog::product/view/product-info.phtml">
    <arguments>
        <!-- Use `default` as the value for `call` unless you want a specific method to be used. -->
        <argument name="attributes" xsi:type="array">
            <item name="sku" xsi:type="array">
                <item name="call" xsi:type="string">getSku</item>
                <item name="code" xsi:type="string">sku</item>
                <item name="label" xsi:type="string">default</item>
                <item name="css_class" xsi:type="string">sku</item>
            </item>
            <item name="color" xsi:type="array">
                <item name="call" xsi:type="string">default</item>
                <item name="code" xsi:type="string">color</item>
                <item name="label" xsi:type="string">default</item>
                <item name="css_class" xsi:type="string">color</item>
            </item>
            ...
        </argument>
    </arguments>
</block>
```

Each attribute to render is declared as a sub-array in the `attributes` array argument.
There are four properties that need to be declared in the array:

| Property | Meaning |
| --- | --- |
| `call` | The string `default` or an alternative getter method name, for example `getSku`. If in doubt use `default`. |
| `code` | The attribute code, for example `material`. |
| `label` | The string `default` or an alternative attribute label, for example `Quality`. |
| `css_class` | This property is currently not used. |

To hide the list of attributes, the `product-info.phtml` template has to be overridden in a custom theme and the appropriate HTML has to be removed.

## In the More Information section

The attributes listed in the "More Information" section are defined by their EAV attribute properties.

All attributes of the current product with the "Is Visible On Frontend" set to "Yes" will be rendered.
To change their appearance or hide them, the attribute properties have to be edited in the Magento Admin (or the Database).

To hide the section, the block `product.attributes` has to be removed using Layout XML.

```
<page>
    <body>
        <referenceBlock name="product.attributes" remove="true"/>
    </body>
</page>
```
