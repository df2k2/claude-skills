<!-- source: https://docs.hyva.io/hyva-commerce/features/image-editor/configuration.html -->

# Image Editor Configuration

## Image quality

Media Optimisation module will handle image optimisation for the frontend.

This configuration option was added to provide a sensible way of managing media library size that is only used in the admin area.

Applies only to `jpg|jpeg` files

You can specify whether you want to reduce image quality when saving.
The basic tradeoff is that higher resolution in generated images leads to larger file sizes. Without compression, you may experience image files up to 5 times the size of the original.

### Changing the image quality

[![Image quality](images/image-editor-quality-config.png)](images/image-editor-quality-config.png)

To change the image quality used in the admin panel:

1. Navigate to 'Stores > Settings > Configuration' from the main menu in the admin panel
2. Select 'Hyvä Themes > Image Editor' from the left hand configuration menu
3. Under 'General', set the percentage value (between 10-100) you wish to use for the 'Image Quality' field
4. Save the configuration
