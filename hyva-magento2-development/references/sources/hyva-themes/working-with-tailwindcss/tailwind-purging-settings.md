<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/tailwind-purging-settings.html -->

# Tailwind Content settings

A typical stylesheet for a Hyvä Theme is about 100kb (that’s ~17kb over the wire due to HTTP compression). This is because Tailwind only compiles the CSS actually used within a theme.

Because Tailwind needs to know which classes are used, we need to point the build script to the files that contain Tailwind classes. Typically, that would be `.phtml` and `.xml` files.

If you have files with Tailwind CSS classes in `app/code` modules, `vendor/` modules or a parent theme, these directories have to be included in your tailwind configuration, too.

There are two ways to configure the content paths: automatically (recommended) or manually.

## Automatic Configuration (Recommended)

Since release 1.1.15 of the `hyva-themes/magento2-theme-module`, the file `app/etc/hyva-themes.json` is used to automatically include relevant modules in the content paths configuration.

This file is generated and updated automatically whenever a module is enabled or disabled. If you need to generate it manually, you can run:

```
bin/magento hyva:config:generate
```

This command creates a config file that is used to inform Tailwind about all the files it needs to scan for CSS classes. How this information is used depends on your Tailwind CSS version.

Tailwind v4Tailwind v3

The `hyva:config:generate` command creates a config file which is being used by `hyva-sources`.

This command generates a `hyva-source.css` file inside your theme's `web/tailwind/generated` directory, which is then imported into your main `tailwind-source.css`.

Your theme's `web/tailwind/tailwind-source.css` should look like this:

```
@import "@hyva-themes/hyva-modules/css";
@import "tailwindcss" source(none);
@source "../../**/*.phtml";
@source "../../**/*.xml";

/* Custom styles */
@import "./base";
@import "./components";
@import "./theme";
@import "./utilities";

/* Import generated styles for Hyvä Compatible Modules and Design Tokens */
@import "./generated/hyva-source.css";
@import "./generated/hyva-tokens.css";
```

The `@import "./generated/hyva-source.css";` line is what automatically includes all registered Hyvä modules.

The `hyva:config:generate` command creates a config file which is being used by `mergeTailwindConfig` and `postcssImportHyvaModules`.

These helpers, used in your `tailwind.config.js` and `postcss.config.js`, read the `app/etc/hyva-themes.json` file and merge the configured paths into your Tailwind `content` array.

This means you don't need to manually add paths for Hyvä compatibility modules.

[For more information see the @hyva-themes/hyva-modules docs](using-hyva-modules/index.html)

## Manual Configuration

If you prefer not to use the automatic configuration, or if you have files in paths that are not covered by it, you can add paths manually to your Tailwind configuration.

Tailwind v4Tailwind v3

In your theme's `web/tailwind/tailwind-source.css`, you can add more `@source` rules to include other paths.

```
@source "../../**/*.phtml";

/* My Module templates */
@source "../../../../../../code/acme/my-module/**/*.phtml";
```

You can add paths directly to the `content` array in your theme's `tailwind.config.js`.

```
module.exports = mergeTailwindConfig({
  //...
  content: [
    '../../**/*.phtml',

    // My Module templates
    '../../../../../../code/acme/my-module/**/*.phtml',
  ]
});
```

Language: Tailwind *Content* vs. *Purge* settings

Sometimes the Tailwind content paths configuration is referred to as the "purge settings".
This expression goes back to Tailwind v2 and earlier, where the script generated all possible styles and then "purged" all that weren't actually used in files within the specified content path.

Using "purge" hasn't been the correct expression for many years, but old habits die hard.
