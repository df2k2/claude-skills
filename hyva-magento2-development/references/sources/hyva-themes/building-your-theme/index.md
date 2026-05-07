<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/index.html -->

# Building a Hyvä Child Theme

A **Hyvä child theme** inherits all templates, layouts, and styles from the parent Hyvä Default Theme while letting you customize specific components for your store. Child themes are the recommended approach for Hyvä customization because they preserve upgrade compatibility and keep your changes separate from vendor code.

This guide covers creating a Hyvä child theme directory in `app/design/frontend/`, configuring Tailwind CSS to scan parent theme sources, and generating the production stylesheet.

## Creating the Hyvä Child Theme Directory

To create a Hyvä child theme, follow the [official Magento theme creation guide](https://developer.adobe.com/commerce/frontend-core/guide/themes/create-storefront) and set up a new theme directory at `app/design/frontend/Vendor/ThemeName/`.

In the child theme's `theme.xml` file, set the parent to `Hyva/default` for the standard Hyvä theme, or `Hyva/default-csp` for the Content Security Policy compliant version.

Theme Preview Image

The Hyvä Default Theme includes `preview.png` rather than `preview.jpg`. Reference this filename in your child theme's `theme.xml`.

## Copying the Tailwind Build Configuration to the Child Theme

Hyvä child themes require a complete copy of the Tailwind build configuration from the parent theme. This copy includes `package.json`, Tailwind configuration files, and source CSS files - everything needed to generate the child theme's stylesheet.

Copy the entire `web` directory from the Hyvä Default Theme into the child theme:

```
# Create the child theme web directory
mkdir -p app/design/frontend/Vendor/ThemeName/web

# Copy all Tailwind build files from the parent Hyvä Default Theme
cp -r vendor/hyva-themes/magento2-default-theme/web/* app/design/frontend/Vendor/ThemeName/web/
```

## Configuring the Parent Theme Path for Tailwind CSS

Tailwind CSS must scan the parent Hyvä theme's templates so that all CSS classes from the parent are included in the production build. Configure the parent theme path in the child theme's `web/tailwind/hyva.config.json` file.

Add a `tailwind.include` array with a `src` entry pointing to the parent Hyvä Default Theme in the vendor directory:

web/tailwind/hyva.config.json

```
{
    "tailwind": {
        "include": [
            { "src": "vendor/hyva-themes/magento2-default-theme" }
        ]
    }
}
```

If the child theme is based on `hyva-themes/magento2-default-theme-csp`, adjust the `src` path to include the `-csp` suffix:

web/tailwind/hyva.config.json

```
{
    "tailwind": {
        "include": [
            { "src": "vendor/hyva-themes/magento2-default-theme-csp" }
        ]
    }
}
```

Hyvä 1.3.x and Tailwind v3

Tailwind 3 used a `tailwind.config.js` file instead of the current `hyva.config.json` and `tailwind-source.css`.
Tailwind v3 was used in Hyvä themes release 1.2.x and 1.3.x.

The path to the parent theme needed to be enabled in the config:

```
```js
module.exports = {
  ...
  // Examples for excluding patterns from purge
  content: [
    // this theme's phtml and layout XML files
    '../../**/*.phtml',
    '../../*/layout/*.xml',
    '../../*/page_layout/override/base/*.xml',
    // parent theme in Vendor (if this is a child-theme)
    //'../../../../../../../vendor/hyva-themes/magento2-default-theme/**/*.phtml',
    //'../../../../../../../vendor/hyva-themes/magento2-default-theme/*/layout/*.xml',
    //'../../../../../../../vendor/hyva-themes/magento2-default-theme/*/page_layout/override/base/*.xml',
    // app/code phtml files (if need tailwind classes from app/code modules)
    //'../../../../../../../app/code/**/*.phtml',
  ]
}
...
```
```


Hyvä 1.1.x and Tailwind v2

Older Hyvä versions 1.1.x use Tailwind v2. In the configuration for that version, the path to the `content` section is slightly different.
If the child theme is based on an older 1.1.x version of Hyvä and has not been upgraded to Tailwind v3, use the Tailwind v2 structure where `content` is nested inside a `purge` parent object:

```
```js
module.exports = {
  ...
  // keep the original settings from tailwind.config.js
  // only add the path below to the purge > content settings
  ...
  purge: {
    content: [
      // this theme's phtml and layout XML files
      '../../**/*.phtml',
      '../../*/layout/*.xml',
      // parent theme in Vendor
      '../../../../../../../vendor/hyva-themes/magento2-default-theme/**/*.phtml',
      ...
    ]
  }
}
...
```
```

## Customizing Templates and Layouts in a Hyvä Child Theme

Hyvä child themes use the same extension mechanisms as standard Magento themes. Override `.phtml` template files by placing them at the same relative path within the child theme directory. Extend layout XML files using Magento's standard layout XML merging behavior.

Any Tailwind CSS utility classes used in the child theme's custom templates will be automatically included in the stylesheet when the CSS is regenerated.

## Generating the Hyvä Production Stylesheet

After making changes to the Hyvä child theme, regenerate the `styles.css` file to include any new Tailwind CSS classes. Run the Tailwind build command from the child theme's `web/tailwind` directory:

```
npm run build
```

This command scans all `.phtml` templates and layout XML files - both in the child theme and in the parent Hyvä Default Theme - and generates a single optimized `styles.css` file.

### Related Topics

- [Working with Tailwind CSS in Hyvä](../working-with-tailwindcss/index.html) - full guide to Tailwind CSS configuration
- [Generating the styles.css file](../working-with-tailwindcss/generating-css.html) - detailed build options and troubleshooting
- [Tailwind CSS content configuration](../working-with-tailwindcss/tailwind-purging-settings.html) - controlling which files Tailwind scans
