<!-- source: https://docs.hyva.io/hyva-widgets/widget-types/hyva-multi-field-widget.html -->

# Hyvä Multi Field Widget

## Content Fields

1. Widget title - Text field. Will output as heading on top of the widget.
2. Multi-field data - Text area field. Will output below the Widget title and will display as a explanatory section.
3. Display type - Select box with three options to switch between Hyvä Slider, Splide.js Slider or Grid type view.
4. Steps - Reusable elements that contain multiple fields.
   - Image - Image uploader to select the reusable step image.
   - Title - Title text field of the reusable step.
   - Description - Text area field for reusable step description.
   - Button text - Text string that will create a button for redirects etc.
   - Button url - Text field for an internal or external url where a click on the banner button will lead. E.g. "/products" for an internal link, or a full url "<https://hyva.io>" for an external link.
   - Action - Admin button that will delete the current step. After removing a step, be sure to click "Save" the page, so the change is applied.

![](img/multifield_content.png)

## Animations

- Multi field fade animations - The assigned content is animated when a visitor scrolls half the element into view. It will animate out when user leaves the content area. There are 10 options available for a user to select from. For more details on how this plugin works on the development side please visit the [Intersect plugin Apline.js documentatzion](https://alpinejs.dev/plugins/intersect#installation).

Note

Animations only work with Hyvä 1.1.10.
Earlier releases of Hyvä do not include the x-intersect plugin.

![](img/multifield_animations.jpg)

## Spacing

- Hyvä multifield padding - Inside spacing on top, left, bottom, right.
  The value maps directly to Tailwind CSS padding classes. More details can be found in the [Tailwind CSS Padding documentation](https://tailwindcss.com/docs/padding).
  Example: `pt-8 pb-8 pl-4 pr-4` or `py-6 px-8`. Multiple entries are allowed.
- Hyvä multifield margin - Outside spacing on top, left, bottom, right.
  The value maps directly to Tailwind CSS margin classes. More details can be found [in the Tailwind CSS Margin documentation](https://tailwindcss.com/docs/margin).
  Example: `mt-8 mb-8 mr-4 ml-4`. Multiple entries allowed.

![](img/multifield_spacing.jpg)
