<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/x-snap-slider.html -->

# The Alpine.js x-snap-slider plugin

Available since Hyvä 1.4

The Hyvä Snap Slider is an Alpine.js plugin that lets you build accessible, CSS-driven sliders and carousels. It enhances your existing CSS scroll-snap implementations with interactive navigation, pagination, and accessibility features.

This component prioritizes accessibility by automatically managing the `inert` attribute for off-screen slides and adding appropriate ARIA labels.

**Core principle:** The Snap Slider follows a progressive enhancement approach. CSS handles the visual presentation; JavaScript adds interactivity and accessibility on top.

## Usage

To initialize a `snap-slider`, your HTML structure needs a container element with the `x-data` directive and a direct child element with the `[data-track]` attribute.

```
<section x-data x-snap-slider>
    <div data-track>
        <!-- Slides go here -->
    </div>
</section>
```

The interactive behavior is managed by the CSS styles you apply to the elements within the `[data-track]` container.

## Modifiers

The `x-snap-slider` directive accepts modifiers to customize its default behavior. Multiple modifiers can be combined.

```
<div x-data x-snap-slider.auto-pager.loop>
    ...
</div>
```

#### `.auto-pager`

Automatically generates a set of pagination markers after the `[data-track]` element. To control where the pager is inserted, add an empty `[data-pager]` container anywhere inside the slider element.

```
<section x-data x-snap-slider.auto-pager>
    <div data-track>
        <!-- Slides go here -->
    </div>
    <div data-pager></div>
</section>
```

Consider setting a `min-height` on `[data-pager]` to prevent layout shifts as the pager renders.

Style the auto-generated pager using the default CSS classes `.snap-pager` and `.snap-marker`, or supply your own with `data-pager-class` and `data-marker-class` on the `x-snap-slider` element.

#### `.group-pager`

Groups pagination markers when more than one slide is visible at a time, showing one marker per visible group instead of one per slide.

#### `.loop`

Available since Hyvä 1.4.7

Enables looping. Navigation wraps from the last slide back to the first, and next/previous buttons are never disabled.

#### `.force-pager`

Available since Hyvä 1.5.2

Keeps the pager visible even when all slides fit in the viewport and the slider has no overflow. Useful when you always want the pager present regardless of content count.

## Configuration options

| Data Attribute | Description | Default |
| --- | --- | --- |
| `data-track` | **Required.** Identifies the container for the slider's slides. |  |
| `data-next` | Designates a button to navigate to the next slide. |  |
| `data-prev` | Designates a button to navigate to the previous slide. |  |
| `data-pager` | Designates the container for pagination markers. |  |
| `data-loop` | Enables looping (alternative to the `.loop` modifier). | `false` |
| `data-force-pager` | Keeps the pager visible when there is no overflow (alternative to `.force-pager`). | `false` |
| `data-pager-class` | Sets custom CSS classes for the auto-generated pager container. | `snap-pager` |
| `data-marker-class` | Sets custom CSS classes for the auto-generated pager markers. | `snap-marker` |
| `data-slide-label-sepparator` | Customizes the separator in the `aria-label` for slides (e.g., "1 of 12"). | `of` |

### Custom pager implementation

When building a custom pager, each slide within `[data-track]` must have a unique `id`. Pager markers link to their slide using either:

- **Anchor links:** Set the `href` to the slide's ID prefixed with `#`.
- **Buttons:** Use a `<button>` with `data-target-id` set to the slide's ID.

## How to, Demo and Examples

For more information on how to build CSS sliders with the Snap Slider, check out the UI docs: [How to build CSS sliders](../../../hyva-ui-library/faqs/how-to-build-css-sliders.html).

Watch the video introduction to the Snap Slider for a visual demonstration.

## Autoplay

The Snap Slider follows the CSS scroll-snap specification and **does not support autoplay functionality**. This is an intentional design decision.

### Why no autoplay?

From an accessibility (a11y) standpoint, auto-advancing sliders present several challenges:

- Users with motor impairments may need more time to interact with slider controls
- Screen reader users can lose their place when content changes unexpectedly
- Users with cognitive disabilities may find auto-advancing content disorienting
- Auto-advancing can interfere with users who are reading or processing the content

For these reasons, the Snap Slider prioritizes user control over automatic transitions.

### Alternatives for autoplay requirements

If your use case genuinely requires autoplay functionality, Hyvä offers these alternatives through the Hyvä UI library:

1. **Marquee Slider (Hyvä UI)** - Recommended for non-interactive, decorative content where continuous motion makes sense from a UX and a11y standpoint (e.g., scrolling brand logos or testimonials)
2. **SplideJS (Hyvä UI Plugins)** - A traditional JavaScript-based slider that supports autoplay. Use this only when autoplay is a firm requirement, as it trades some accessibility benefits for additional features

Recommendation

Before implementing autoplay, consider whether your content truly benefits from it. In most cases, user-controlled navigation provides a better experience for all visitors.
