<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/product-detail-page-section-cards.html -->

# Product Detail Page Section Cards

The Hyvä default theme Product Detail Page (PDP) uses sections in place of the Luma “additional information” tabs. Sections are rendered as cards.

Layout XML that renders a new tab in Luma, will add a new section in Hyvä.

## Adding a section card

In a `catalog_product_view.xml` layout file, add the XML

```
<referenceBlock name="product.info.details">
    <block name="my.section"
           template="Magento_Catalog::product/view/my-section.phtml"
           group="detailed_info">
        <arguments>
            <argument name="title" xsi:type="string" translate="true">More Information</argument>
            <argument name="sort_order" xsi:type="number">-10</argument>
        </arguments>
    </block>
</referenceBlock>
```

The `group="detailed_info"` attribute on the block is required. Blocks without it are not automatically rendered as sections (just like tabs in Luma).

The `title` and the `sort_order` arguments to the block are optional.

Sections are sorted in ascending order.

## Customizing the title rendering

By default the section title is rendered using the template

`Magento_Catalog::product/view/sections/default-section-title.phtml`.

A custom title template can be specified by adding a `title_template` block argument:

```
<block name="description"
       template="Magento_Catalog::product/view/sections/description.phtml"
       group="detailed_info">
    <arguments>
        <argument name="title_template" xsi:type="string">Magento_Catalog::product/view/sections/description-section-title.phtml</argument>
    </arguments>
</block>
```
