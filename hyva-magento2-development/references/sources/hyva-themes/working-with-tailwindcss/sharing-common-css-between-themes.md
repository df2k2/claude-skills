<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/sharing-common-css-between-themes.html -->

# Sharing Common CSS Between Themes

This approach is ideal for managing multiple child themes with slight variations across different websites.
It promotes code reusability and simplifies maintenance.

In Magento 2's traditional Luma theme, CSS inheritance via LessCSS was automatic, but this is not the case with Hyvä and TailwindCSS.

In Hyvä, files such as Tailwind configurations and CSS do not inherit automatically from a parent theme if they are missing in a child theme.

This means that, unlike the Luma theme, where LessCSS files were inherited by default,
you will need to explicitly import settings and styles from the parent theme to the child theme.

## Sourcing Files From a Parent Theme

Before importing CSS or configurations, you must ensure Tailwind CSS scans the files from your parent theme for utility classes.
If you don't, any styles used in the parent theme's `.phtml` or `.xml` files will not be included in your generated CSS.

- **For Tailwind v3**, you need to add the file paths of the parent theme to the `content` array in your `tailwind.config.js`.
- **For Tailwind v4**, this is best managed using the `hyva-sources` command and configuring the include paths in your `hyva.config.json` file.

Note

For detailed instructions on setting up the content configuration for a child theme, please refer to the [guide on setting up a child theme with Hyvä](../building-your-theme/index.html#creating-the-hyva-child-theme-directory).

## Importing Parent Theme Styles

Once your content sourcing is configured, you can import assets from the parent theme. This avoids duplicating files and configurations.

### Importing Shared CSS Files

To share styles, you can `@import` specific CSS files from a parent theme into your child theme's `tailwind-source.css`.

This works for any CSS file you need to reuse.
However, avoid importing the whole `tailwind-source.css` file from the parent, as this could lead to redundant `tailwindcss` imports. Instead, import only specific styles or files that should be shared.

For example:

```
/* Import from Hyvä default theme */
@import "../../../../../../../vendor/hyva-themes/magento2-default-theme/web/tailwind/base";
@import "../../../../../../../vendor/hyva-themes/magento2-default-theme/web/tailwind/components";
@import "../../../../../../../vendor/hyva-themes/magento2-default-theme/web/tailwind/theme";
@import "../../../../../../../vendor/hyva-themes/magento2-default-theme/web/tailwind/utilities";

/* Import from another custom theme in the same folder */
@import "../../../acme-theme/web/tailwind/your-parent-theme-styles.css";
```

### Tailwind v3: Importing a Parent Theme `tailwind.config.js`

There are two methods to import the Tailwind configuration of a parent theme:

Include the Parent Theme as a Preset

The **`presets`** method allows you to inherit the parent theme’s entire configuration and then override any part of it. This is the simplest way to extend a parent theme.

For more details, check the [Tailwind Presets Documentation](https://v3.tailwindcss.com/docs/presets).

```
const { mergeTailwindConfig } = require("@hyva-themes/hyva-modules");
const parentTheme = require("../../../../../../../vendor/hyva-themes/magento2-default-theme/web/tailwind/tailwind.config.js");

/** @type {import('tailwindcss').Config} */
module.exports = mergeTailwindConfig({
    presets: [parentTheme],  // Import the parent theme config
    content: [
        // Don't forget to configure the content for your child theme
        // and include the parent theme's content paths here.
    ],
    theme: {
        extend: {
            // Your overrides go here
        }
    }
});
```


Require parts of the Parent Theme config

For more granular control, you can selectively `require` the parent theme’s configuration and merge only the parts you need.

This method gives you the flexibility to inherit only specific parts, for example, the screen breakpoints:

```
const { mergeTailwindConfig } = require("@hyva-themes/hyva-modules");
const parentTheme = require("../../../../../../../vendor/hyva-themes/magento2-default-theme/web/tailwind/tailwind.config.js");

/** @type {import('tailwindcss').Config} */
module.exports = mergeTailwindConfig({
    theme: {
        extend: {
            screens: {
                ...parentTheme.theme.extend.screens,  // Import parent breakpoints
                "3xl": "2200px",  // Add a custom breakpoint
            },
        },
    },
});
```

## Sharing Styles using CSS Variables

Another powerful technique for creating theme variations is using CSS Variables (custom properties).

With this method, a parent theme can define the theme structure using variables for colors, fonts, or spacing. A child theme can then simply provide new values for these variables to create a completely different look and feel without touching the underlying CSS or configuration.

This is the recommended approach for theming and creating variations like a "dark mode".

Learn more about CSS Variables

For a complete guide on how to use CSS Variables with Tailwind CSS in your Hyvä theme, please refer to the [CSS Variables + TailwindCSS documentation](css-variables-plus-tailwindcss.html).

### Defining CSS Variable Values

The CSS variables used in your Tailwind configuration need to be declared so the browser knows what values they represent.

There are several options for where to declare your variables:

- **In global CSS:** Add variables to the `:root` selector in a CSS file that is imported in your theme's `tailwind-source.css`.
- **In the Magento Theme Configuration:** Define variables in the Magento Admin under `Design Configuration → <STORE> → HTML Head → Scripts and Style Sheets`.
- **In `.phtml` templates:** Render variables in a `<style>` block, which is useful for dynamic values from Magento's configuration.

```
<style>
    :root {
        --color-primary: 160 100% 54%;
        --color-primary-darker: <?= $brandColor ?>; /* Dynamic value from Magento */
    }
</style>
```
