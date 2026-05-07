<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-1-26.html -->

# Upgrading to 1.1.26

1.1.26 contains a workaround for a Mobile Safari issue and some backports of features added in 1.3.2 and 1.3.3.

When updating the Hyvä Theme to version 1.1.26, please note to always update the `hyva-themes/magento2-theme-module` to the latest version as well.

Even if not updating the Default Theme to 1.1.26, it should always be safe to update `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

## Backward incompatible changes

There are no backward incompatible changes in release 1.1.26.

## Noteworthy changes

### Updated reset-theme to 1.1.5

This `hyva-themes/magento2-reset-theme` version constraint is raised to `>=1.1.5`.
If the reset-theme is a dependency in your root composer.json file, be sure to include it in the update.

### Composable header customer-account menu

Note: This change was released in 1.3.2 of the main branch.

Previously, it was not possible to add links to the `Magento_Customer/templates/header/customer-menu.phtml` template without overriding the template.
In the past, this has often led to conflicting template overrides from third-party extensions.

Existing `customer-menu.phtml` based on previous Hyvä Themes releases will continue to work without changes.
However, they will not render menu links added with Layout XML, so you might want to consider migrating existing customized
`customer-menu.phtml` to use the new template.

Links can be added by declaring children blocks in the layout XML of either the `header.customer.logged.in.links` or `header.customer.logged.out.links` block.

For example:

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

For more information on how to add links, headings and delimiters to the customer header menu, please refer to the [documentation](../view-utilities/customer-header-menu-links.html).

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#1126-2023-11-17)
- [Changelog Theme Module](changelog-theme-module.html#1126-2023-11-17)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
