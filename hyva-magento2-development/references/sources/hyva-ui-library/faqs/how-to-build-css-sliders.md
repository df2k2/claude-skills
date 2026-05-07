<!-- source: https://docs.hyva.io/hyva-ui-library/faqs/how-to-build-css-sliders.html -->

# Building CSS Sliders

CSS sliders offer a performant and progressive way to build carousels without relying heavily on JavaScript.

By utilizing CSS Scroll Snap Points, we can create smooth, snap-to-item scrolling experiences.

This document will guide you through the basics of building an accessible CSS slider and then briefly introduce how the Snap Slider Alpine.js plugin can further enhance it with features like navigation buttons.

For a comprehensive guide on the Snap Slider plugin itself, please refer to the [plugins docs](../../hyva-themes/working-with-alpinejs/alpine-plugins/x-snap-slider.html).

## Core CSS Slider Structure (Tailwind CSS Example)

The foundation of a CSS slider involves a container with `overflow-x-auto` and `snap-x`, and child elements with `snap-start`:

```
<div class="flex snap-x scroll-smooth overflow-x-auto">
    <div class="w-96 snap-start shrink-0">Slide 1</div>
    <div class="w-96 snap-start shrink-0">Slide 2</div>
    <div class="w-96 snap-start shrink-0">Slide 3</div>
</div>
```

## Ensuring Accessibility

For an accessible CSS slider, it's crucial to also include the following:
1. **Semantic Wrapping:** Use a `<section>` element to define the slider as a distinct content region. Add a descriptive `aria-label` and `aria-roledescription="carousel"`.
2. **Slide Roles:** Assign appropriate `role` attributes to the slide containers (e.g., `role="group"` for general content or `role="tabpanel"` when used with a pager).
3. **Keyboard Navigation:** Include `tabindex="0"` on the scrolling container if the slides themselves don't contain interactive elements.

```
<section aria-label="Lorum Ipsum" aria-roledescription="carousel">
    <div class="flex snap-x scroll-smooth overflow-x-auto" tabindex="0">
        <div role="group" class="w-96 snap-start shrink-0">Slide 1</div>
        <div role="group" class="w-96 snap-start shrink-0">Slide 2</div>
        <div role="group" class="w-96 snap-start shrink-0">Slide 3</div>
    </div>
</section>
```

## Enhancing with Navigation Buttons using Snap Slider

The Snap Slider Alpine.js plugin simplifies the addition of *previous* and *next* navigation to your CSS slider. To use it:

1. Integrate the Snap Slider plugin and initialize it on the `<section>` element using `x-data` and `x-snap-slider`.
2. Mark the scrolling container with the `data-track` attribute.
3. Include `<button>` elements with the `data-prev` and `data-next` attributes to enable navigation. Ensure these buttons have appropriate `aria-label` for accessibility.

```
<section
    x-data
    x-snap-slider
    aria-label="Lorum Ipsum"
    aria-roledescription="carousel"
>
    <div class="flex gap-2 justify-between items-center mb-2">
        <h3 class="text-lg font-medium">Explore Lorum Ipsum</h3>
        <div class="flex gap-2">
            <button class="btn" aria-label="Previous Image" data-prev hidden>Previous</button>
            <button class="btn" aria-label="Next Image" data-next hidden>Next</button>
        </div>
    </div>
    <div
        data-track
        class="flex snap-x scroll-smooth overflow-x-auto"
        aria-live="polite"
        tabindex="0"
    >
        <div role="group" class="w-96 snap-start shrink-0">Image 1</div>
        <div role="group" class="w-96 snap-start shrink-0">Image 2</div>
        <div role="group" class="w-96 snap-start shrink-0">Image 3</div>
    </div>
</section>
```

The Snap Slider plugin will automatically handle the functionality of these buttons.

For information on adding pager dots and other features, please consult the Snap Slider [plugins docs](../../hyva-themes/working-with-alpinejs/alpine-plugins/x-snap-slider.html).
