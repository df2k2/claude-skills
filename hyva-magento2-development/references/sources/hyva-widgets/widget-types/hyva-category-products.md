<!-- source: https://docs.hyva.io/hyva-widgets/widget-types/hyva-category-products.html -->

# Hyvä Category Products

## Content Options

- Widget title.
- Content/WYSIWYG editor - A WYSIWYG editor allowing visual editing of content like H1, font size etc. It enables the use of [TailwindUI components](https://tailwindui.com/) or free components [tailwindcomponents.com](https://tailwindcomponents.com/). Hide the editor when pasting HTML code, and show editor again to use the WYSIWYG interface.
- Container - Container class to apply to the widget content. The theme container size is used. If different contaner size is needed, override the container definition in your themes [tailwind.config.js](https://tailwindcss.com/docs/configuration).
- Category container background - Color picker to chose the widget background color.
- Hyvä content padding - Inside spacing for the category content. Native tailwind padding classes are used. Please refer to the [Tailwind CSS padding documentation](https://tailwindcss.com/docs/padding) for details.

![](img/category_content.png)

## Category Product List Options

- Category select - Dropdown with all the store categories with their name and ID. The selected categorys products are displayed on the store front.
- Number of Products to display.

![](img/category_list.png)

## Animations Options

Content fade animations - The assigned content is animates when the visitor scrolls half of the element into the view port. It will disappear or animate out when content leaves the content area. There are 10 options available for a user to select from. For more details on how this plugin works on the development side please visit the [Intersect plugin Alpine.js documentation](https://alpinejs.dev/plugins/intersect#installation).

Note

Animations only work with Hyvä 1.1.10.
Earlier releases of Hyvä do not include the x-intersect plugin.

![](img/category_animations.png)

## Widget type

Display type - Select box with three options which will switch between Hyvä Slider, Splide.js Slider or Grid type of view.

![](img/category_widget_type.png)

## Spacing

- Hyva content padding - Inside spacing on top, left, bottom, right. More details can be found [here](https://tailwindcss.com/docs/padding). E.g. "pt-8 pb-8 pl-4 pr-4" or "py-6 px-8". Multiple entries allowed according to tailwind standards.
- Hyva content margin - Spacing on top, left, bottom, right. More details can be found [here](https://tailwindcss.com/docs/margin). E.g. "mt-8 mb-8 mr-4 ml-4". Multiple entries allowed according to tailwind standards.

![](img/category_spacing.jpg)
