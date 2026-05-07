<!-- source: https://docs.hyva.io/hyva-themes/compatibility-modules/core-magento-compat-modules.html -->

# Core Magento Compatibility Modules

When writing compatibility modules for Magento distributions like Adobe Commerce or B2B, you will find all layout XML declarations from the original modules are removed by the Hyvä reset theme.

For example the Magento\_Banner `default.xml` layout XML blocks are removed with:

```
<referenceContainer name="content">
    <!--
        <block
            name="banner.data"
            class="Magento\Banner\Block\Ajax\Data"
            template="Magento_Banner::js/banner.phtml"
        />
    -->
</referenceContainer>
```

The reason is that Hyvä is not based on Luma, but is a brand-new theme developed from scratch.
The comments are there as a reference to what is *normally* there. An effort is made to keep all containers and extension points available.

In a situation like the above, the solution is to create a `hyva_default.xml` layout file in the compatibility module, and add the required blocks again.
