<!-- source: https://docs.hyva.io/hyva-themes/writing-code/working-with-view-models/rendering-images.html -->

# Rendering Responsive Images in Templates

The Hyvä Theme provides the `\Hyva\Theme\ViewModel\Media` view model for rendering responsive images using the HTML `<picture>` element. This view model generates semantic markup with `<source>` elements for different screen sizes and image formats, enabling art direction and format selection for optimal performance.

Using the Media view model consistently across your theme ensures that image rendering remains an extension point for third-party modules.

## Method Signature

The Media view model provides the `getResponsivePictureHtml()` method for generating responsive picture elements:

```
\Hyva\Theme\ViewModel\Media::getResponsivePictureHtml(
    array $images,
    array $imgAttributes = [],
    array $pictureAttributes = []
): string
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| `$images` | `array` | Array of image configurations, each with path, dimensions, and optional media query |
| `$imgAttributes` | `array` | HTML attributes for the `<img>` fallback element (alt, class, loading, etc.) |
| `$pictureAttributes` | `array` | HTML attributes for the `<picture>` wrapper element |

**Image configuration keys:**

| Key | Required | Description |
| --- | --- | --- |
| `path` | Yes | Relative path to the image in `pub/media/` |
| `width` | Yes | Image width in pixels |
| `height` | Yes | Image height in pixels |
| `media` | No | CSS media query for when this source applies (e.g., `(min-width: 768px)`) |
| `fallback` | No | Set to `true` to use this image as the `<img>` src for browsers without `<picture>` support |

## Rendering a Single Image

The following example demonstrates rendering a single product image using the Media view model. This is the simplest use case when you don't need different images for different screen sizes.

Template example: single image

```
<?php
/** @var \Hyva\Theme\ViewModel\Media $mediaViewModel */
$mediaViewModel = $viewModels->require(\Hyva\Theme\ViewModel\Media::class);

// Define the image configuration with path and dimensions
$imageConfig = [
    [
        'path' => 'catalog/product/w/b/wb01-blue-0.jpg',
        'width' => 400,
        'height' => 500
    ]
];

echo $mediaViewModel->getResponsivePictureHtml($imageConfig);
```

This generates a `<picture>` element containing the specified image with proper width and height attributes for layout stability.

## Rendering Responsive Images with Media Queries

For responsive designs requiring different images for desktop and mobile viewports, pass multiple image configurations with media query conditions.

Template example: responsive hero image

```
<?php
/** @var \Hyva\Theme\ViewModel\Media $mediaViewModel */
$mediaViewModel = $viewModels->require(\Hyva\Theme\ViewModel\Media::class);

// Desktop image: wide landscape format for large screens
$desktopImage = [
    'path' => 'wysiwyg/homepage-main-hero.jpg',
    'width' => 1920,
    'height' => 600,
    'media' => '(min-width: 768px)',
    'fallback' => true  // Use this image as fallback for browsers without <picture> support
];

// Mobile image: taller portrait format for small screens
$mobileImage = [
    'path' => 'wysiwyg/homepage-mobile-hero.jpg',
    'width' => 768,
    'height' => 800,
    'media' => '(max-width: 767px)'
];

// Attributes applied to the <img> fallback element
$imgAttributes = [
    'alt' => 'Summer Collection',
    'class' => 'w-full h-auto',
    'loading' => 'eager',        // Load immediately (above-the-fold content)
    'fetchpriority' => 'high'    // Prioritize this resource
];

echo $mediaViewModel->getResponsivePictureHtml(
    [$desktopImage, $mobileImage],
    $imgAttributes
);
```

The browser selects the appropriate `<source>` based on the media query conditions, loading only the image that matches the current viewport.

## Rendering Images from Media Gallery

The Magento Media Gallery stores uploaded images with asset IDs in the `media_gallery_asset` database table. To render these images using the Media view model, retrieve the image data using `\Magento\MediaGalleryUi\Model\GetDetailsByAssetId::execute()`.

The `GetDetailsByAssetId::execute($assetIds)` method accepts an array of asset IDs and returns image data in the exact structure required by `getResponsivePictureHtml()`.

Use a custom view model, not a .phtml template

The `GetDetailsByAssetId` class should be injected into a custom view model rather than instantiated directly in a template. This keeps business logic out of presentation files and allows for proper dependency injection.

Example custom view model for Media Gallery images

```
public function getMediaGalleryImagePictureHtml(int $assetId): string
{
    // Retrieve image data from Media Gallery by asset ID
    $images = $this->getAssetById->execute([$assetId]);

    // Returns HTML <picture> element with the gallery image
    return $this->mediaViewModel->getResponsivePictureHtml($images);
}
```

## Adding Picture Element Attributes

The third parameter allows you to add HTML attributes to the `<picture>` wrapper element. Use this for adding CSS classes or data attributes to the container.

Template example: styled picture container

```
$pictureAttributes = [
    'class' => 'hero-banner aspect-video',
    'data-testid' => 'homepage-hero'
];

echo $mediaViewModel->getResponsivePictureHtml(
    $imageConfig,
    $imgAttributes,
    $pictureAttributes
);
```

## Related Topics

- **[Working with View Models](index.html)** - Overview of the Hyvä view model system
- **[Core Web Vitals](../../performance/core-web-vitals.html)** - Image optimization for Core Web Vitals
