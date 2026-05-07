<!-- source: https://docs.hyva.io/hyva-ui-library/product-gallery.html -->

# Product Gallery - Hyvä UI

The **Hyvä UI Product Galleries** extend or completely replace the default Hyvä gallery,
offering enhanced customization options through `etc/view.xml`.

These galleries are designed to improve user experience (UX) and address accessibility (A11Y) issues,
while modifying the behavior of certain gallery features you may know from the Magento 2 Luma Fotorama version.

## Gallery Versions

Hyvä UI provides multiple gallery versions to suit different needs:

- **A - Basis:**
  This version adds vertical thumbnails while retaining the core functionality of the default Hyvä gallery.
- **B - Fancy:**
  A complete rebuild of the default Hyvä gallery, visually similar to version A,
  but offering extensive customization options via `etc/view.xml`.
  You can enable or disable the fullscreen dialog and activate the magnifier.
- **C - Grid:**
  Designed for image-heavy stores, this version displays a grid of images and videos.
  It differs from version B in its layout and focuses on showcasing multiple media elements at once.
- **D - Splide:**
  Similar to version B but without thumbnails,
  this gallery utilizes SplideJS for smooth transitions and a minimalistic design.

## Gallery Options

Warning

Before using any of the following options,
verify their compatibility with your Hyvä UI Library version.
Features are sometimes introduced in later releases,
so ensure your library is up-to-date. Consult the Hyvä UI Gallery or release notes to confirm support for your specific version.

Below is a full list of gallery options available across the different versions,
but please make sure to read the `README.md` file for the supported options:

```
<var name="gallery">
    <var name="loop">false</var> <!-- Gallery navigation loop (true/false) -->
    <var name="caption">false</var> <!-- Display alt text as image title (true/false) -->
    <var name="allowfullscreen">true</var> <!-- Turn on/off fullscreen (true/false) -->
    <var name="navdir">horizontal</var> <!-- Direction of the thumbnails (horizontal/vertical) -->
    <var name="navarrows">false</var> <!-- Turn on/off the thumbnail arrows (true/false) -->

    <!-- Contains Hyva Only options -->
    <var name="nav">thumbs</var> <!-- Gallery navigation style (false/thumbs/dots/counter) -->
    <var name="arrows">false</var> <!-- Turn on/off the gallery arrows (start/end/true/false) -->

    <!-- Hyva Only options -->
    <var name="fullscreenicon">false</var> <!-- Turn on/off icon for allowfullscreen (true/false) -->
    <var name="navoverflow">false</var> <!-- Turn on/off overflow style (true/false) -->
    <var name="autoplay">false</var> <!-- Turn on/off autoplay for videos (true/false) -->

    <var name="magnifier">
        <var name="enable">false</var> <!-- Turn on/off magnifier (true/false) -->
        <var name="zoom">80</var> <!-- magnifier zoom level (integer) -->
        <var name="fullscreen">true</var> <!-- Turn on/off magnifier when viewing fullscreen (true/false) -->
        <var name="trigger">click</var> <!-- How to show the magnifier (hover/click) -->
    </var>
</var>
```

Below, we highlight key features and considerations for certain gallery options:

### Gallery Magnifier

The magnifier feature is often expected to function similarly to the Luma theme version,
but there are key differences in the Hyvä UI implementation.

The magnifier only works on non-touch devices.
On touch-enabled devices,
it's recommended to use the native pinch-to-zoom feature, as it provides a better user experience.

**Why isn’t it available on mobile?**

1. **Performance:** Supporting touch-based magnification requires additional JavaScript to prevent conflicts
   with native touch interactions (such as swiping), which adds unnecessary complexity and page load weight.
2. **Conflict Prevention:** Implementing custom zoom gestures could interfere with native touch gestures like swiping,
   leading to a frustrating user experience.

### Autoplay for Videos

The autoplay option works across all videos in the gallery, not just the first one.

Note that autoplay is not available in Gallery C since this version displays all items simultaneously.

When enabled, autoplay skips the video preview and automatically plays the active video.

Be cautious: enabling this can impact performance,
as the video data will be loaded as soon as it becomes the active gallery item.
This can affect page load times, especially if the first gallery item is a video.

### Gallery Captions

Enabling captions displays the image’s alt text as a title in the gallery.

Be sure to add meaningful alt text,
as captions will not display if the alt text is missing or identical to the product name.

### Gallery Navigation Dots

This option, exclusive to Gallery D (Splide).

Dots are automatically hidden on touch-based devices to enhance accessibility,
as the default touch size for Dots is too small.

If you prefer to keep dots for touch devices,
you may need to modify how [SplideJS](https://splidejs.com/) renders them.

For more information on Gallery D options, please refer to the `README.md` file.
