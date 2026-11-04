<!-- source: https://docs.hyva.io/hyva-ui-library/product-gallery.html -->

# Product Gallery - Hyvä UI

Gallery A is built for Hyvä Theme 1.5

**Gallery A - Fashion** is built on the Hyvä Theme 1.5 PHP rendering approach, leaving behind
JavaScript-driven layouts in favor of a CSS grid and the native slider of the Hyvä Default Theme.
Galleries B, C and D are still built on Hyvä Theme 1.4 and will be updated to the same
approach in a future Hyvä UI release.

The **Hyvä UI Product Galleries** extend or completely replace the default Hyvä Theme gallery,
adding customization options that you configure through `etc/view.xml`.

These galleries are built to improve user experience (UX) and fix accessibility (A11Y) issues.
Along the way, they also change how some gallery features behave compared to the Magento 2 Luma
Fotorama gallery you may already know, so expect a few differences if you are migrating.

## Gallery Versions

Hyvä UI ships several Product Gallery versions, so you can pick the one that fits your needs:

- **A - Fashion:**
  Built on the native slider gallery of the Hyvä Default Theme 1.5. It shows the images as a
  swipeable slider on mobile and as an image grid on desktop. You choose how shoppers view an image
  up close: a lightbox, an in-place magnifier, or nothing at all. Requires Hyvä Default Theme 1.5 or higher.
- **B - Fancy:**
  A complete rebuild of the default Hyvä Theme gallery with thumbnails. It adds extensive customization
  through `etc/view.xml`. You can enable or disable the fullscreen dialog and switch on the magnifier.
- **C - Grid:**
  Built for image-heavy stores. This version lays out a grid of images and videos so users see
  multiple media elements at once, which is the main difference from version B.
- **D - Splide:**
  Similar to version B but without thumbnails. It uses [SplideJS](https://splidejs.com/) for smooth transitions and a minimalist design.

Versions B, C and D require Hyvä Default Theme 1.3.15 or higher.

Gallery A replaces Gallery A - Basic

Hyvä UI 2.9.0 replaced **Gallery A - Basic** with **Gallery A - Fashion**. The new version
uses its own set of options, so the `navdir`, `navarrows`, `navoverflow` and `autoplay` options
no longer apply to Gallery A.

## Gallery Options

The Hyvä UI Product Gallery is configured through a `<var name="gallery">` block in your theme's
`etc/view.xml`. Gallery A has its own set of options, while Galleries B, C and D share a common set.
Always check the `README.md` that ships with your gallery to confirm which options apply.

Check version compatibility first

Before using any of these options, verify that your Hyvä UI Library version supports them.
Features are sometimes introduced in later releases, so keep your library up to date and
consult the Hyvä UI Gallery or the release notes to confirm support for your specific version.

### Gallery A Options

app/design/frontend/{Vendor}/{theme}/etc/view.xml

```
<var name="gallery">
    <var name="loop">1</var> <!-- Enable infinite loop (1/0) -->
    <var name="caption">0</var> <!-- Show image caption (1/0) -->
    <var name="nav">end</var> <!-- Nav arrow position (end/start/center/none) -->
    <var name="zoom">lightbox</var> <!-- Zoom style (lightbox/magnifier/none) -->
</var>
```

The `zoom` option sets what happens when a shopper interacts with an image:

- `lightbox` opens the image in a fullscreen dialog, with arrows and arrow key navigation between all images.
- `magnifier` zooms the image in place on mouse hover, following the cursor, and loads the large image in the background.
- `none` keeps the images static.

With `magnifier` and `none`, videos still open in the dialog when clicked, so they remain playable.
Navigation inside the dialog is only available with `lightbox`.

### Gallery B, C and D Options

The options below cover every setting available across Galleries B, C and D.
Not every version supports every option.

app/design/frontend/{Vendor}/{theme}/etc/view.xml

```
<var name="gallery">
    <var name="loop">false</var> <!-- Gallery navigation loop (true/false) -->
    <var name="caption">false</var> <!-- Display alt text as image title (true/false) -->
    <var name="allowfullscreen">true</var> <!-- Turn on/off fullscreen (true/false) -->
    <var name="navdir">horizontal</var> <!-- Direction of the thumbnails (horizontal/vertical) -->
    <var name="navarrows">false</var> <!-- Turn on/off the thumbnail arrows (true/false) -->

    <!-- Contains Hyvä-only options -->
    <var name="nav">thumbs</var> <!-- Gallery navigation style (false/thumbs/dots/counter) -->
    <var name="arrows">false</var> <!-- Turn on/off the gallery arrows (start/end/true/false) -->

    <!-- Hyvä-only options -->
    <var name="fullscreenicon">false</var> <!-- Turn on/off icon for allowfullscreen (true/false) -->
    <var name="navoverflow">false</var> <!-- Turn on/off overflow style (true/false) -->
    <var name="autoplay">false</var> <!-- Turn on/off autoplay for videos (true/false) -->

    <var name="magnifier">
        <var name="enable">false</var> <!-- Turn on/off magnifier (true/false) -->
        <var name="zoom">80</var> <!-- Magnifier zoom level (integer) -->
        <var name="fullscreen">true</var> <!-- Turn on/off magnifier when viewing fullscreen (true/false) -->
        <var name="trigger">click</var> <!-- How to show the magnifier (hover/click) -->
    </var>
</var>
```

The sections below highlight the options that behave differently from what you might expect,
along with the trade-offs to keep in mind.

### Gallery Magnifier

The gallery magnifier zooms into a product image. In Gallery A, set `<var name="zoom">magnifier</var>`
to zoom in place on mouse hover. The zoom level is set by the `--gallery-zoom` CSS variable
(default `3`) on the gallery `section` element. In Galleries B and C, the magnifier works on hover
or click and is controlled by the `<var name="magnifier">` block.

People often expect it to work similarly to the Luma theme version,
but the Hyvä UI implementation makes some deliberate choices.

The magnifier only works on non-touch devices. On touch-enabled devices, it's recommended to use the native pinch-to-zoom gesture, which gives users a better experience.

**Why isn't the magnifier available on mobile?**

1. **Performance:** Supporting touch-based magnification needs extra JavaScript to avoid clashing
   with native touch interactions like swiping. That adds complexity and page load weight for little gain.
2. **Conflict prevention:** Custom zoom gestures can interfere with native touch gestures such as swiping,
   which leads to a frustrating experience.

### Autoplay for Videos

The `autoplay` option plays every video in the gallery, not just the first one. When enabled, autoplay
skips the video preview and plays the active video automatically.

Autoplay is not available in Gallery C, since that version displays all items at the same time.
Gallery A has no `autoplay` option. Videos play when opened in the dialog, and whether they loop follows
the Magento setting **Stores > Configuration > Catalog > Catalog > Product Video > Auto restart video**.

Autoplay affects performance

Video data loads as soon as a video becomes the active gallery item. Enabling `autoplay` can slow
down your page, especially when the first gallery item is a video, because that data loads on page load.

### Gallery Captions

The `caption` option displays the image's alt text as a title in the gallery. In Gallery A, the
caption shows the image label, or the video title for videos. Turn it on when you want
users to see descriptive labels alongside each image.

Add meaningful alt text to your product images before enabling captions. A caption will not display
when the alt text is missing or identical to the product name.

### Gallery Navigation Dots

Navigation dots are a compact alternative to thumbnails and are exclusive to Gallery D (Splide).
Set them with `<var name="nav">dots</var>` in `etc/view.xml`.

Dots are hidden automatically on touch-based devices to improve accessibility, because the default
touch target for dots is too small to tap reliably.

If you want to keep dots on touch devices, you can change how
[SplideJS](https://splidejs.com/) renders them. For more on Gallery D options,
see the `README.md` that ships with the gallery.

## Related Topics

- **[Product Images and Gallery](../hyva-themes/building-your-theme/product-images-and-gallery.html)** - Configure the default Hyvä Theme gallery before reaching for the Hyvä UI versions.
- **[What is the Hyvä UI Library?](what-is-the-hyva-ui-library.html)** - Overview of the Hyvä UI Library and the components it provides, including galleries and menus.
