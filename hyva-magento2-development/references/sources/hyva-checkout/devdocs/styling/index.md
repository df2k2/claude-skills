<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/styling/index.html -->

# Styling Hyvä Checkout

Hyvä Checkout uses Tailwind CSS for all its styling, and those classes get compiled into the same `styles.css` file as the rest of your theme. There's nothing extra to set up - it just works out of the box.

## Excluding Hyvä Checkout Default CSS Styles

The `magento2-hyva-checkout` module ships with its own default styles in `src/view/frontend/tailwind/tailwind-source.css`. These styles cover the baseline look of the checkout, but you might want to replace them entirely with your own.

The steps to exclude these styles depend on whether your theme uses Tailwind CSS v3 or v4.

Tailwind CSS v4Tailwind CSS v3

In Tailwind v4 projects, module exclusion is handled in the `hyva.config.json` file in your theme's `web/tailwind` directory. Add the Hyvä Checkout module to the `exclude` list:

web/tailwind/hyva.config.json

```
{
    "tailwind": {
        "exclude": [
            { "src": "vendor/hyva-themes/magento2-hyva-checkout/src" }
        ]
    }
}
```

After updating `hyva.config.json`, regenerate the sources file by running `npx hyva-sources` from your theme's `web/tailwind` directory.

If you still want Tailwind to scan the Hyvä Checkout templates for class names (so utility classes used in the checkout markup are included in the build) but skip importing the module's CSS, use the `keepSource` flag:

web/tailwind/hyva.config.json

```
{
    "tailwind": {
        "exclude": [
            {
                "src": "vendor/hyva-themes/magento2-hyva-checkout/src",
                "keepSource": true
            }
        ]
    }
}
```

For more details on `hyva-sources` and the `hyva.config.json` options, see the [hyva-sources documentation](../../../hyva-themes/working-with-tailwindcss/using-hyva-modules/sources.html).

In Tailwind v3 projects, add an `excludeDirs` option to the `postcssImportHyvaModules` plugin in your theme's `web/tailwind/postcss.config.js` file.

Available since @hyva-themes/hyva-modules 1.0.7

The `excludeDirs` option requires version 1.0.7 or later of the `@hyva-themes/hyva-modules` [library](https://github.com/hyva-themes/hyva-modules-tailwind-js).
To check your currently installed version, change into your theme's `web/tailwind` directory and run `npm list @hyva-themes/hyva-modules`.

The following `postcss.config.js` example shows how to exclude the Hyvä Checkout default styles while keeping the rest of the PostCSS pipeline intact.

web/tailwind/postcss.config.js

```
const { postcssImportHyvaModules } = require("@hyva-themes/hyva-modules");

module.exports = {
    plugins: [
        postcssImportHyvaModules({
            // Exclude the default Hyvä Checkout CSS so you can provide your own
            excludeDirs: ["vendor/hyva-themes/magento2-hyva-checkout/src"],
        }),
        require("postcss-import"),
        require("tailwindcss/nesting"),
        require("tailwindcss"),
        require("autoprefixer"),
    ],
};
```

Once the default styles are excluded, you can write your own Tailwind-based checkout styles in your theme's CSS source files. The checkout markup uses standard Tailwind utility classes, so you have full control over the look and feel.

Upgrading @hyva-themes/hyva-modules

To update the library to a newer version, change into your theme's `web/tailwind` directory.
To upgrade to 1.0.7 specifically, run `npm upgrade @hyva-themes/hyva-modules@1.0.7`.
To upgrade to the latest version, run `npm upgrade @hyva-themes/hyva-modules`.
