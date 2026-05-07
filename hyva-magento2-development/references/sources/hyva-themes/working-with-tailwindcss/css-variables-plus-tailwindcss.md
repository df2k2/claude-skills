<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/css-variables-plus-tailwindcss.html -->

# CSS Variables + TailwindCSS

TailwindCSS is a fantastic tool for quickly building attractive frontends without writing extensive custom CSS.
However, customizing it can be challenging, as most styles are embedded directly in the HTML, rather than in a separate CSS file.

So, how can we make customization easier?

The answer is **CSS variables** (also known as CSS custom properties).

CSS variables give you control over styles, and when combined with TailwindCSS, they are a powerful approach to theming while making maintenance easier.

## Using CSS Variables in Your Code

When working with TailwindCSS, it’s a good practice to use **vanilla CSS** for custom properties (CSS variables).

This ensures flexibility, especially when you need to reuse the same values across multiple components or themes.
By using CSS variables, you can make your theme more dynamic and maintainable.

### From `theme()` to CSS Variables

In projects moving from Tailwind v3 to v4, it’s recommended to define styles using CSS variables directly, rather than relying on Tailwind’s `theme()` function. Here’s an example of how you can transition:

```
.btn {
  background-color: var(--color-primary);
  /*
     Instead of using Tailwind’s v3 method:
     background-color: theme('colors.primary.DEFAULT');
  */
}
```

This approach allows managing styles efficiently when working on larger projects requiring theme customization. The Tailwind configuration doesn't need to be changed every time a color needs to be adjusted, and the design is consistent across components by sharing the same CSS variables.

### Using CSS Variables with Tailwind Utilities

If your utility classes are configured to use CSS variables (see below), you can use them without any additional setup. For example, a button styled with the `bg-primary` class will automatically inherit the `--color-primary` variable if it's defined in your Tailwind configuration.

However, what happens when the required CSS variable isn’t included in the utility classes? TailwindCSS provides a solution: **arbitrary value utilities**.

### Tailwind Arbitrary Values and CSS Variables

Arbitrary values allow you to directly reference CSS variables in your utility classes. Here’s an example of how to use an arbitrary value for the `text-color` utility with a custom CSS variable:

```
<div class="text-[var(--alt-color)]">
  Custom Text Color
</div>
```

In this case, `--alt-color` can be any CSS variable you’ve defined elsewhere.

You can learn more about arbitrary values in the [TailwindCSS documentation](https://tailwindcss.com/docs/adding-custom-styles#using-arbitrary-values).

Caution with Arbitrary Values

Be careful not to overuse arbitrary values. While they offer a lot of flexibility, they can also increase the size of your CSS file quickly.
It’s usually better to define your variables in the configuration and use them globally.

### Setting CSS Variables with PHP

A practical use case for combining CSS variables with TailwindCSS is when you need to pass dynamic values from PHP into your styles.

Since TailwindCSS doesn’t directly support dynamic values from the server side at request time, you can use a CSS variable in combination with PHP to dynamically calculate and assign values.
Here’s an example of how a gallery component might adjust based on thumbnail sizes:

```
<div id="gallery" ...>
  <div
    class="grid grid-rows-[auto_var(--thumbs-size)]"
    style="--thumbs-size: <?= $smallWidth ?>px;"
  >
    <!-- Gallery Content -->
  </div>
</div>
```

In this example, the grid row size is dynamically set using the `--thumbs-size` CSS variable, which receives its value from the server-side `$smallWidth` PHP variable. This approach allows you to bridge server-side logic and front-end styling.

## Configuring Tailwind for CSS Variables

How you configure Tailwind to recognize your CSS variables depends on the version you are using.

### Tailwind v4 (Hyvä 1.4.0 and newer)

Tailwind v4 is built around CSS variables, so they are used by default with no special configuration needed. The main color variables are declared in a theme's `tailwind-source.css` using the `@theme` directive, and can be customized to refer to other variables:

```
@theme {
    --color-bg: var(--color-primary-lighter);
    --color-fg: var(--color-primary-darker);
    --color-fg-secondary: var(--color-primary);
    --color-surface: var(--color-white);
}
```

For more information on `@theme` see the tailwind Docs: https://tailwindcss.com/docs/functions-and-directives#theme-directive

### Tailwind v3 (Hyvä 1.3.x and earlier)

In the Tailwind v3 `tailwind.config.js` file, CSS variables can be used, too, but a little care has to be taken to preserve the full capabilities of TailwindCSS, like opacity modifiers.

Helper for Tailwind v3

#### Using the `twProps` and `twVar` Functions

As of version 1.0.10 of the [@hyva-themes/hyva-modules](https://github.com/hyva-themes/hyva-modules-tailwind-js) package, you can use two helper functions,
`twProps` and `twVar`, to define CSS variables in your Tailwind config.

These functions rely on the CSS `color-mix` function, which is now supported in all modern browsers and was chosen by TailwindCSS as the way forward.

Please refer to [caniuse.com/wf-color-mix](https://caniuse.com/wf-color-mix) for more details.

To get started, import `twProps` and/or `twVar` from `@hyva-themes/hyva-modules` in your `tailwind.config.js`.

The `twProps` function can be used to declare CSS variables for all Tailwind Tokens inside of it:

```
const { twProps, mergeTailwindConfig } = require('@hyva-themes/hyva-modules');
const colors = require("tailwindcss/colors");

module.exports = mergeTailwindConfig({
    theme: {
        extend: {
            colors: twProps({
                primary: {
                    lighter: colors.blue["600"],
                    DEFAULT: colors.blue["700"],
                    darker: colors.blue["800"],
                },
            })
        }
    }
})
```

The `twProps` function converts all static values within it into CSS variables. The original value from your config is used as the fallback value for the CSS `var()` function in the generated output.

For example, `colors: twProps({ primary: { DEFAULT: colors.blue["700"] }})` will result in CSS using `var(--color-primary, #1d4ed8)`. This allows the theme to work immediately while still allowing the variable `--color-primary` to be redefined elsewhere.

The `twVar` function works the same way but for single values. A key benefit of both helpers is that they correctly handle Tailwind's opacity modifiers regardless of which color syntax is used.

```
// Example with twVar for a single value
lighter: twVar('primary-lighter', colors.blue["600"]),
```

For a complete guide on using these helpers, please refer to the `tailwind.config.js` example in the original document version or refer to the [technical documentation on the GitHub page](https://github.com/hyva-themes/hyva-modules-tailwind-js?tab=readme-ov-file#twvar-and-twprops).
