<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/product-images-and-gallery.html -->

# Product Images and Gallery

Product image sizes and gallery behaviour in Hyvä are both configured through the `etc/view.xml` file in your theme. If your theme does not yet have one, copy it from `vendor/hyva-themes/magento2-default-theme/etc/view.xml`.

## Image sizes

Image sizes are defined inside the `<media><images module="Magento_Catalog">` section. Each entry maps an image type to a width and height used both for image generation and for the `width` and `height` HTML attributes.

For example, to change the product images on the listing page:

```
<view xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/view.xsd">
    <media>
        <images module="Magento_Catalog">
            <image id="category_page_grid" type="small_image">
                <width>360</width>
                <height>360</height>
            </image>
            <image id="category_page_list" type="small_image">
                <width>360</width>
                <height>360</height>
            </image>
            <!-- Other sizes -->
        </images>
    </media>
    <!-- Other options -->
</view>
```

## Gallery options

The Hyvä Default Theme product gallery is managed through its `phtml` template. Luma Fotorama `etc/view.xml` settings are not applicable. The gallery does support a limited set of behavioural options.

### `gallery_switch_strategy`

Defines how images are loaded when a product option (such as a colour swatch) is selected.

```
<vars module="Magento_ConfigurableProduct">
    <var name="gallery_switch_strategy">append</var> <!-- 'append' or 'replace' -->
</vars>
```

- **append**: Adds new images to the existing gallery.
- **replace**: Replaces the current images with the newly selected images.

### Video options

From Hyvä Default Theme 1.3.6, all video-related options except **Autostart base video** are supported. Configure them under `Stores → Configuration → Catalog → Catalog → Product Video`.

## Hyvä UI Galleries

For more extensive customisation without modifying `phtml` files, [Hyvä UI Galleries](../../hyva-ui-library/product-gallery.html) offer additional configuration options, including `navdir` for thumbnail navigation direction and several options exclusive to the Hyvä UI gallery system.

## Resources

- [Adobe Commerce: view.xml configuration](https://developer.adobe.com/commerce/frontend-core/guide/themes/configure)
- [Mage-OS: view.xml reference](https://devdocs.mage-os.org/docs/main/view_xml)
