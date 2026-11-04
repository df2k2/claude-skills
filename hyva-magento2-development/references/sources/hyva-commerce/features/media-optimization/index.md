<!-- source: https://docs.hyva.io/hyva-commerce/features/media-optimization/index.html -->

# Media Optimization

Media Optimization gives developers and admins control over image output on the storefront, including resizing, compression, and conversion to modern formats such as WebP and AVIF. The goal is to serve images that are as small as possible, in both dimensions and file size, to improve storefront performance.

Available with Hyvä Commerce 1.2.0

Media Optimization is generally available since `1.0.0`, which shipped with Hyvä Commerce `1.2.0`. It was first released as `0.1.0` on 9 September 2025. See [Installation](installation.html) for setup.

## What Media Optimization Does

Media Optimization offers three main capabilities:

1. A [developer-friendly API](features/developer-api.html) to resize and convert images in your own block and template output.
2. Default implementations that use that API, such as in [Hyvä CMS](features/hyva-cms-integration.html) components.
3. An observer that scans all block output on a page and [automatically replaces images](features/automatic-image-replacement.html) in HTML or CSS with optimized versions.

A [`bin/magento` CLI command](features/flushing-generated-images.html) removes generated images by path, and a wide range of [configuration](configuration.html) options in the Magento admin control the engine, output formats, replacement modes, and quality settings.

## Installing Media Optimization

Ready to get started? Follow [Installing Media Optimization](installation.html) to add it to your Magento store.

## More Information

- [Configuration](configuration.html): system check, image and replacement settings, viewport breakpoints, and engine settings.
- [Automatic Image Replacement](features/automatic-image-replacement.html): replace images across HTML and CSS automatically.
- [Image Processing Engines](features/engines.html): GD and Imagick, format support, and performance tuning.
- [Hyvä CMS Integration](features/hyva-cms-integration.html): which built-in Hyvä CMS component images are optimized.
- [Flushing Generated Images](features/flushing-generated-images.html): the CLI command for removing generated images.
- [Developer API](features/developer-api.html): output optimized responsive `<picture>` elements from your templates.
