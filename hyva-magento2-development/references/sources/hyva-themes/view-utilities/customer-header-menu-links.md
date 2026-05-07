<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/customer-header-menu-links.html -->

# Customer Header Menu

Since release 1.3.2, the customer header menu has been composed via Layout XML.

Compatibility with older versions of Hyvä

At the time of writing, the composable customer header menu is only available in the 1.3 Hyvä releases.

We will be making releases for Hyvä 1.2 and 1.1 with the new menu structure shortly, too, so extension vendors can
offer compatibility with older versions of Hyvä while customizing the customer header menu with layout XML.

## Overview

Each link is a child block of either the `header.customer.logged.in.links` block or the `header.customer.logged.out.links` block.

Items are rendered in the menu depending on the logged-in state of the visitor.
Menu items are sorted in ascending order (larger numbers go towards the end of the menu).

There are three types of menu items: Links, Delimiters, and Headings.

The default template `Hyva_Theme::sortable-item/link.phtml` renders a link in the menu.
Two alternative templates allow rendering delimiters and headings in the menu:

- `Hyva_Theme::sortable-item/delimiter.phtml`
- `Hyva_Theme::sortable-item/heading.phtml`

### Adding Menu Links

To add a link, add a child block to the appropriate header, with a block class `Hyva\Theme\Block\SortableItemInterface` in a `default.xml` layout file in your Hyvä theme, or a `hyva_default.xml` layout file if you are working in a module.
For most cases, the default implementation will be sufficient.

```
<referenceBlock name="header.customer.logged.in.links">
    <block name="customer.header.orders.link"
           class="Hyva\Theme\Block\SortableItemInterface">
        <arguments>
            <argument name="label" xsi:type="string" translate="true">My Orders</argument>
            <argument name="path" xsi:type="string">sales/order/history</argument>
            <argument name="sort_order" xsi:type="number">30</argument>
        </arguments>
    </block>
</referenceBlock>
```

### Adding Menu Delimiters

Specify a child block with the `Hyva_Theme::sortable-item/delimiter.phtml` template:

```
<referenceBlock name="header.customer.logged.in.links">
    <block name="my-custom-delimiter"
           class="Hyva\Theme\Block\SortableItemInterface"
           template="Hyva_Theme::sortable-item/delimiter.phtml"
    >
        <arguments>
            <argument name="sort_order" xsi:type="number">50</argument>
        </arguments>
    </block>
</referenceBlock>
```

### Adding Menu Headings

Specify a child block with the `Hyva_Theme::sortable-item/heading.phtml` template:

```
<referenceBlock name="header.customer.logged.in.links">
    <block name="my-custom-header"
           class="Hyva\Theme\Block\SortableItemInterface"
           template="Hyva_Theme::sortable-item/heading.phtml"
    >
        <arguments>
            <argument name="label" xsi:type="string" translate="true">Action Items</argument>
            <argument name="sort_order" xsi:type="number">55</argument>
        </arguments>
    </block>
</referenceBlock>
```
