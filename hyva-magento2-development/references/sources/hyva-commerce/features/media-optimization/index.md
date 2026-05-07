<!-- source: https://docs.hyva.io/hyva-commerce/features/media-optimization/index.html -->

# Media Optimisation

Media Optimisation provides developers and admin users control over image output on the storefront, including resizing, compression and conversion to modern formats such as WebP and AVIF. All with the aim of ensuring the images served to the browser are as small as possible, both in terms of dimensions and file size, to aid with storefront performance.

Media Optimisation currently offers 3 main features:

1. A [developer friendly API](features/developer-api.html) to allow you to resize and convert images within your block/template output
2. Default implementations that utilise the above API, such as within [Hyvä CMS](features/hyva-cms-integration.html) components
3. An observer that scans the output of all blocks on a page and [automatically replaces images](features/automatic-image-replacement.html) found in HTML or CSS with optimized versions

In addition, a [`bin/magento` CLI command](features/flushing-generated-images.html) is provided to allow removing generated images by path, and there are a large number of [configuration](configuration.html) options provided in the Magento admin panel that allow control over:

- The engine used to convert/resize images (GD/Imagick)
- Which formats to output (e.g. WebP/AVIF)
- The modes and formats used for automatic image replacement in HTML/CSS
- A wide range of quality and compression controls for each engine, for both resizing and conversion
- And many more...
