<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/index.html -->

# Using the Hyvä Modules npm Package

The `@hyva-themes/hyva-modules` npm package extends TailwindCSS with tools that automate style management across your Hyvä theme and any installed third-party modules. Think of it as the glue that brings everything together - module styles, CSS variables, and design tokens - so you don't have to wire them up manually.

The Hyvä Modules package provides three core capabilities:

- **Source and config merging** - Automatically discovers and merges styles from [Hyvä-compatible modules](../registering-a-module-for-tailwind-compilation.html) into your theme build
- **CSS variable helpers** - Provides `twProps` and `twVar` functions for using CSS custom properties in Tailwind v2/v3 configurations
- **Design token integration** - Converts exported design tokens (from tools like Figma) into TailwindCSS-compatible CSS

## Compatibility Module Support in Tailwind v4

The `npx hyva-sources` command is the Tailwind v4 replacement for the older `mergeTailwindConfig` and `postcssImportHyvaModules` functions from Hyvä 1.3.x. Running `npx hyva-sources` generates a `generated/hyva-source.css` file that imports all styles from your Hyvä-compatible modules using Tailwind v4 syntax.

The `hyva-sources` command reads the same `app/etc/hyva-themes.json` file used by the older functions. You control which modules are included or excluded through `hyva.config.json`.

The `hyva-sources` command is more flexible than the older approach. Beyond Hyvä-compatible modules, you can include extra paths - for example, a parent theme - without adding them manually.

Here is an example `hyva.config.json` showing include and exclude options:

hyva.config.json

```
{
    "tailwind": {
        "include": [
            { "src": "app/code/Acme/hyva-module" },
            { "src": "vendor/hyva-themes/magento2-default-theme" }
        ],
        "exclude": [
            { "src": "vendor/hyva-themes/magento2-hyva-checkout/src" }
        ]
    }
}
```

For full details on configuration options and usage, see the [dedicated `hyva-sources` documentation](sources.html).

## Compatibility Module Support in Tailwind v3

Tailwind v2 and v3 projects use two complementary functions: `mergeTailwindConfig` for JavaScript config merging and `postcssImportHyvaModules` for CSS import merging.

### Merging Tailwind Configurations with `mergeTailwindConfig`

The `mergeTailwindConfig` function merges Tailwind configurations from Hyvä-compatible modules into your theme. Import `mergeTailwindConfig` in your `tailwind.config.js` and wrap the exported config object:

tailwind.config.js

```
const { mergeTailwindConfig } = require('@hyva-themes/hyva-modules');

module.exports = mergeTailwindConfig({
    // Your theme's Tailwind config here...
});
```

### Merging CSS Imports with `postcssImportHyvaModules`

The `postcssImportHyvaModules` function handles the CSS side of module merging. Import `postcssImportHyvaModules` in your `postcss.config.js` and add it to the plugins list.

Plugin Order Matters

The `postcssImportHyvaModules` plugin must be placed **before** `postcss-import` and `tailwindcss/nesting` in your PostCSS plugin list.

postcss.config.js

```
const { postcssImportHyvaModules } = require('@hyva-themes/hyva-modules');

module.exports = {
    plugins: [
        postcssImportHyvaModules,
        require('postcss-import'),
        // ...other PostCSS plugins
    ],
};
```

For a deeper look at how these functions work under the hood, see the [compatibility modules technical deep dive](../../compatibility-modules/technical-deep-dive.html#tailwind-asset-merging-for-compatibility-modules) or the [@hyva-themes/hyva-modules GitHub repository](https://github.com/hyva-themes/hyva-modules-tailwind-js).

## CSS Variables in Hyvä Tailwind Themes

With Tailwind v4, CSS custom properties (variables) work out of the box - no extra setup needed.

For Tailwind v2 and v3, the Hyvä Modules package provides the `twProps` and `twVar` helper functions. These let you define and reference CSS variables directly in your `tailwind.config.js`. See [how to use `twProps` and `twVar` in your Tailwind config](../css-variables-plus-tailwindcss.html#using-the-twprops-and-twvar-functions) for a complete walkthrough.

Broader Browser Support

If you need wider browser compatibility for CSS variables, check the [first method on the CSS variables page](../css-variables-plus-tailwindcss.html) - it covers an alternative approach.

## Design Token Integration with `hyva-tokens`

What are Design Tokens?

If you are unfamiliar with design tokens, read [What are Design Tokens?](../design-tokens/faq.html) first for a quick introduction.

Hyvä provides a way to integrate design tokens directly into your TailwindCSS build. The workflow is straightforward:

1. Export your tokens from your design system. If you use [Token Studio](https://tokens.studio/) for [Figma](https://www.figma.com/), refer to its docs for export instructions.
2. Place the exported token file in your theme directory.
3. Run `npx hyva-tokens` to generate a CSS file you can import into your theme.

For step-by-step instructions and advanced options, see the [dedicated `hyva-tokens` documentation](tokens.html).

## Related Topics

- [`hyva-sources` command reference](sources.html) - Full documentation for the Tailwind v4 source generation command
- [`hyva-tokens` command reference](tokens.html) - Full documentation for the design token conversion command
- [Registering a Module for Tailwind Compilation](../registering-a-module-for-tailwind-compilation.html) - How to make a third-party module Hyvä-compatible
- [CSS Variables and TailwindCSS](../css-variables-plus-tailwindcss.html) - All methods for using CSS variables with Tailwind in Hyvä
