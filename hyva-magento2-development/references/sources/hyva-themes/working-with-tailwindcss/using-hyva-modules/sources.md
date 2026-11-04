<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/sources.html -->

# Generating Tailwind v4 Source Directives with hyva-sources

TailwindCSS v4 Only

The `hyva-sources` command is only available in TailwindCSS v4 projects. It replaces the `mergeTailwindConfig` and `postcssImportHyvaModules` JS functions from earlier Hyvä versions.

The `hyva-sources` command generates a `generated/hyva-source.css` file in your Hyvä theme. This generated CSS file contains `@source` directives and `@import` statements that tell Tailwind v4 where to find class names and styles from Hyvä-compatible modules. Because Tailwind v4 uses CSS-first configuration instead of JavaScript, `hyva-sources` produces CSS rather than merging JS config files.

To generate the source file, run `hyva-sources` from your theme directory:

```
npx hyva-sources
```

## How the hyva-sources Command Works

The `hyva-sources` command reads `app/etc/hyva-themes.json` to identify which modules contain content that Tailwind should scan during compilation. For each registered module, `hyva-sources` generates `@source` directives that include the module's `phtml` and `xml` files automatically - as long as the module contains a `tailwind.config.js` file.

Modules in `app/etc/hyva-themes.json`

Compatiblity modules are automatically added in `hyva-themes.json`.
Other modules need to [register for inclusion](../registering-a-module-for-tailwind-compilation.html) with an event observer.

If a Hyvä-compatible module includes a `tailwind-source.css` file, `hyva-sources` also adds the appropriate `@import` statement to bring in that module's styles.

For more information on Tailwind v4's CSS-first configuration, refer to the [TailwindCSS v4 release blog post](https://tailwindcss.com/blog/tailwindcss-v4#css-first-configuration).

## Tailwind v4 Hyvä-Compatible Modules with module.css

When a module uses Tailwind v4 features, or when you need to control which source paths are included, the module should provide a `module.css` file in its `tailwind` directory. This `module.css` file handles both `@source` and `@import` directives for the module's CSS logic.

The `hyva-sources` command recognizes `module.css` and treats it as the single source of truth for that module, ignoring any legacy configuration files like `tailwind.config.js`.

Tip

If your module is not yet Hyvä-compatible, see the documentation on [how to make your module Hyvä-compatible](../../compatibility-modules/index.html).

While older import methods are still supported for backward compatibility, those legacy methods do not support all Tailwind v4 features. For full Tailwind v4 compatibility, adding a `module.css` file is the recommended approach.

## Including Extra Paths in hyva-sources

The `hyva-sources` command can include paths from anywhere in your Magento 2 project, including a parent theme. This is especially useful when a child theme needs Tailwind to scan the parent theme's templates for class names.

To add an include path, specify the path relative to your Magento 2 root in your `hyva.config.json` file. The `hyva-sources` command generates the correct relative path based on your theme's directory structure.

The following `hyva.config.json` example includes a parent theme as an additional source:

hyva.config.json

```
{
    "tailwind": {
        "include": [
            { "src": "vendor/hyva-themes/magento2-default-theme" }
        ]
    }
}
```

## Excluding Hyvä-Compatible Modules from hyva-sources

Module exclusion is configured in the `hyva.config.json` file. Previous Hyvä versions handled exclusions through the PostCSS configuration.

Info

For information on the older exclusion method, refer to the [Overriding Module CSS](../overriding-module-css.html) documentation.

The following `hyva.config.json` example excludes a specific module from the generated source file:

hyva.config.json

```
{
    "tailwind": {
        "exclude": [
            { "src": "vendor/hyva-themes/magento2-hyva-checkout/src" }
        ]
    }
}
```

### Keeping @source Scanning While Excluding CSS Imports

Sometimes you want Tailwind to scan a module's templates for class names but supply your own CSS instead of importing the module's styles. The `keepSource` flag in `hyva.config.json` handles exactly this scenario - the `@source` directive stays active for template scanning while the CSS `@import` is skipped.

The following `hyva.config.json` example excludes a module's CSS while keeping Tailwind source scanning active:

hyva.config.json

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

## Additional hyva-sources Options

The `hyva-sources` command supports additional configuration options in `hyva.config.json`:

`area`
:   Targets a specific theme area. Defaults to `view/frontend`. Set to `adminhtml` for admin themes.

`includeExternalModules`
:   Controls whether modules from `app/etc/hyva-themes.json` are auto-discovered. Enabled by default. Set to `false` to manage all sources manually via the `include` option.

For full details on all available `hyva-sources` options, see the [hyva-modules-tailwind-js README](https://github.com/hyva-themes/hyva-modules-tailwind-js#hyva-sources).

## Related Topics

- [Hyvä Modules Overview](index.html) - Introduction to the Hyvä module system for Tailwind
- [Overriding Module CSS](../overriding-module-css.html) - How to override styles from Hyvä-compatible modules
- [Tailwind Purging Settings](../tailwind-purging-settings.html) - Configuring which files Tailwind scans for class names
