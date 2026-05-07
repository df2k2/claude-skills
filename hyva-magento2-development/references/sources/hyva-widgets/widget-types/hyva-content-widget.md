<!-- source: https://docs.hyva.io/hyva-widgets/widget-types/hyva-content-widget.html -->

# Hyvä Content Widget

## Content

- Content/WYSIWYG editor - A WYSIWYG editor which allows visual editing content like H1, font sizes etc. It also allows using [TailwindUI components](https://tailwindui.com/) or free components like [tailwindcomponents.com](https://tailwindcomponents.com/). Hide the editor when pasting HTML, and show the editor to use WYSIWYG interface.
- Container - The container class width can be customized by overriding it in your themes `tailwind.config.js`. For more details how to configure tailwind please check [the Tailwind CSS documentation](https://tailwindcss.com/docs/configuration).

![](img/content_content.jpeg)

## Animations

- Content fade animations - The content animates when a visitor scrolls half of the element into view. It will disappear or animate out when the content leaves the view port. There are 10 options to select from. For more details on how this plugin works on the development side please visit the [Intersect plugin Alpine.js documentation](https://alpinejs.dev/plugins/intersect#installation).
- Content container background - Color picker to for the widget background color.

Note

Animations only work with Hyvä 1.1.10.
Earlier releases of Hyvä do not include the x-intersect plugin.

![](img/content_animations.jpeg)

## Spacing

- Hyvä content padding - Inside spacing on the top, left, bottom and right. More details can be found in the [Tailwind CSS Padding documentation](https://tailwindcss.com/docs/padding).
  Example: `pt-8 pb-8 pl-4 pr-4` or `py-6 px-8`.
- Hyvä content margin - Outside spacing on the top, left, bottom and right. More details can be found in the [Tailwind CSS Margin documentation](https://tailwindcss.com/docs/margin).
  Example: `mt-8 mb-8 mr-4 ml-4`.

![](img/content_spacing.jpeg)

## Text font color

Color picker to choose the text color. It only works when using the WYSIWYG interface instead of pasting raw HTML. The available colors can be changed in the HTML by using [Tailwind CSS color classes](https://tailwindcss.com/docs/customizing-colors).

![](img/content_color.jpeg)
