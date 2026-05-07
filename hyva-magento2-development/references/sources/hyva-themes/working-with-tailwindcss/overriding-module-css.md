<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/overriding-module-css.html -->

# Overriding CSS from Modules

This feature, part of the `@hyva-themes/hyva-modules` package for Tailwind v3 and built into `hyva-sources` for Tailwind v4, simplifies CSS management for Hyvä themes in Magento 2.

It automatically merges CSS from Hyvä-compatible modules into your theme, eliminating manual imports.

To override or completely remove the default CSS of a specific module, you can exclude it from being processed. The method depends on your Tailwind CSS version.

## Tailwind v4

For projects using Tailwind v4, module exclusion is configured in the `hyva.config.json` file in your theme's root directory.

Use the `tailwind.exclude` array to list the modules you want to exclude.

For example, to exclude the CSS from the `magento2-hyva-checkout` module:

```
{
    "tailwind": {
        "exclude": [
            { "src": "vendor/hyva-themes/magento2-hyva-checkout/src" }
        ]
    }
}
```

This configuration is used by the `hyva-sources` command. For more details, see the [documentation on the hyva-sources command](using-hyva-modules/sources.html).

## Tailwind v3 (Hyvä 1.3.x and earlier)

For projects using Tailwind v3, use the `excludeDirs` option within the `postcssImportHyvaModules` configuration in your `web/tailwind/postcss.config.js` file.

For example, to exclude the CSS from the `magento2-hyva-checkout` module:

```
const { postcssImportHyvaModules } = require("@hyva-themes/hyva-modules");

module.exports = {
  plugins: [
    postcssImportHyvaModules({
      excludeDirs: ["vendor/hyva-themes/magento2-hyva-checkout/src"],
    }),
    require("postcss-import"),
    require("tailwindcss/nesting"),
    require("tailwindcss"),
    require("autoprefixer"),
  ],
};
```

For more detailed information and advanced usage of the `excludeDirs` option,
please refer to the documentation on [Excluding Module Tailwind Source Files from Merging](../compatibility-modules/technical-deep-dive.html#tailwind-asset-merging-for-compatibility-modules).
