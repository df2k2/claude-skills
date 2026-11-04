<!-- source: https://docs.hyva.io/hyva-commerce/features/media-optimization/features/developer-api.html -->

# Media Optimization Developer API

The Media Optimization Developer API lets you output optimized, responsive `<picture>` elements from your own blocks and templates. Use the view model below for all custom implementations to ensure compatibility whether or not Hyvä Commerce and the Media Optimization module are installed.

## Requesting Picture Output

Use `\Hyva\Theme\ViewModel\Media::getResponsivePictureHtml()` from the `Hyva_Theme` module:

```
/**
 * @param array<string, array{
 *     path: string,
 *     type?: string,
 *     width?: int,
 *     height?: int,
 *     media?: string,
 *     fallback?: bool,
 * }> $images
 *
 * @param array<string, string> $imgAttributes Suggested attributes: alt, loading (lazy|eager),
 *                                              fetchpriority (auto|high|low), class, id, style,
 *                                              decoding (sync|async|auto), sizes, srcset
 * @param array<string, string> $pictureAttributes Suggested attributes: class, id, style,
 *                                                 data-* attributes
 */
public function getResponsivePictureHtml(
    array $images,
    array $imgAttributes = [],
    array $pictureAttributes = []
): string {
    return $this->mediaHtmlProvider->getPictureHtml($images, $imgAttributes, $pictureAttributes);
}
```

This method calls `getPictureHtml()` declared in the `Hyva\Theme\Model\Media\MediaHtmlProviderInterface` interface.

## Basic Usage Example

A minimal example for displaying a product image in your template:

```
<?php
/** @var \Hyva\Theme\ViewModel\Media $mediaViewModel */
$mediaViewModel = $viewModels->require(\Hyva\Theme\ViewModel\Media::class);

$imageConfig = [
    [
        'path' => 'catalog/product/w/b/wb01-blue-0.jpg',
        'width' => 400,
        'height' => 500
    ]
];

echo $mediaViewModel->getResponsivePictureHtml($imageConfig);
```

This generates a complete picture element with optimized sources for different formats, automatically handling retina displays when enabled.

## Responsive Images Example

For responsive designs with different images for desktop and mobile:

```
<?php
/** @var \Hyva\Theme\ViewModel\Media $mediaViewModel */
$mediaViewModel = $viewModels->require(\Hyva\Theme\ViewModel\Media::class);

$desktopImage = [
    'path' => 'wysiwyg/homepage-main-hero.jpg',
    'width' => 1920,
    'height' => 600,
    'media' => '(min-width: 768px)',
    'fallback' => true  // Use this image as a fallback if the <picture> tag is not supported by the browser
];

$mobileImage = [
    'path' => 'wysiwyg/homepage-mobile-hero.jpg',
    'width' => 768,
    'height' => 800,
    'media' => '(max-width: 767px)'
];

$imgAttributes = [
    'alt' => 'Summer Collection',
    'class' => 'w-full h-auto',
    'loading' => 'eager',
    'fetchpriority' => 'high'
];

echo $mediaViewModel->getResponsivePictureHtml(
    [$desktopImage, $mobileImage],
    $imgAttributes
);
```

## Interfaces and Implementations

`\Hyva\Theme\Model\Media\MediaHtmlProviderInterface` declares the `getPictureHtml()` method used by the view model.

The default implementation in the `Hyva_Theme` module, `\Hyva\Theme\ViewModel\Media::getPictureHtml()`, outputs a `<picture>` tag from the provided image `src` and data, but does not resize or convert imagery.

When the Media Optimization module is installed, the base provider is replaced with `\Hyva\MediaOptimization\Model\Media\MediaHtmlProvider::getPictureHtml()`, which adds resizing and conversion, and different image sizes per viewport. It respects your Media Optimization configuration; if optimization is disabled, it gracefully falls back to standard image tags.
