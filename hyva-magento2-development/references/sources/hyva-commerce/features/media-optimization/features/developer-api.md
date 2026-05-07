<!-- source: https://docs.hyva.io/hyva-commerce/features/media-optimization/features/developer-api.html -->

# Media Optimisation Developer API

## Requesting Picture Output

The below view model class and method in the `Hyva_Theme` module should be used for all custom implementations to ensure compatibility, regardless of whether Hyvä Commerce and the Media Optimisation module are installed, or not.

`\Hyva\Theme\ViewModel\Media::getResponsivePictureHtml()`

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

This method calls the `getPictureHtml()` method declared in the `Hyva\Theme\Model\Media\MediaHtmlProviderInterface` interface.

## Basic Usage Example

Here's a minimal example for displaying a product image in your template:

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
    'fallback' => true  // Use this image as a fallback in case the <picture> tag is not supporte by the browser
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

## Interface

`\Hyva\Theme\Model\Media\MediaHtmlProviderInterface`

Declares the `getPictureHtml()` method used within the view model implementation.

## Base Provider Class Implementation

The default implementation in the `Hyva_Theme` module outputs a `<picture>` tag from the provided image `src` and additional data, but does not resize or convert imagery.

`\Hyva\Theme\ViewModel\Media::getPictureHtml()`

## Media Optimisation Implementation

When the Media Optimisation module is installed, the base provider class is replaced with the below class, which adds resizing and conversion support, as well as different image sizes per viewport.

`\Hyva\MediaOptimization\Model\Media\MediaHtmlProvider::getPictureHtml()`

The module respects your Media Optimisation configuration settings. If optimisation is disabled, it gracefully falls back to standard image tags.
