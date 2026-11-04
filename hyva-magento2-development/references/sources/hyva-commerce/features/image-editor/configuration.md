<!-- source: https://docs.hyva.io/hyva-commerce/features/image-editor/configuration.html -->

# Configuring Image Editor

Image Editor has one configuration option: the image quality applied when saving edited images in the admin. This page explains what it does and how to change it.

## Image Quality

You can set how much Image Editor compresses images when saving. Higher quality produces larger files: without compression, an edited image can be up to five times the size of the original. This setting only affects images saved through the Image Editor in the admin.

Applies only to JPEG images

The image quality setting affects `jpg` and `jpeg` files only. Lossless formats such as `png` are saved without this compression.

For storefront image optimization, use Media Optimization

This setting exists to keep the admin media library at a sensible size. Optimizing images for the storefront is handled by the separate Media Optimization module.

### Changing the Image Quality

[![Image quality configuration](./images/image-editor-quality-config.jpg)](./images/image-editor-quality-config.jpg)

To change the image quality used in the admin panel:

1. Go to `Stores → Settings → Configuration` in the admin panel.
2. Select `Hyvä Commerce → Image Editor` from the left-hand configuration menu.
3. Under **General**, set the **Image Quality** field to a percentage between 10 and 100.
4. Save the configuration.
