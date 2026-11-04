<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/updating-to-tailwind-4.html -->

# Updating to Tailwind CSS v4

Since Hyvä 1.4.0

Technically it is possible to upgrade older versions of Hyvä to TailwindCSS v4, too, but since release 1.4.0 Hyvä supports it out of the box.

## Introduction

Tailwind CSS v4 is a complete rewrite of the framework, featuring a new high-performance engine called Oxide that is significantly faster than its predecessor.

This new version moves away from being a PostCSS plugin to a standalone tool. It also shifts configuration from a JavaScript file (`tailwind.config.js`) to a CSS-first approach using the `@theme` directive.

## Prerequisites

- **Node.js:** Version 20 or higher is recommended.
- **Browser Support:** Tailwind v4 uses modern CSS features and requires modern browsers (e.g., Safari 16.4+, Chrome 111+, Firefox 128+). If you need to support older browsers, we recommend staying on Tailwind v3.

## Hyvä Upgrade Steps

### Copy the updated `web/tailwind` folder

We recommend to upgrade by copying the files from the new Hyvä Default Theme's `web/tailwind` folder.
Be sure to make a backup first for reference.

### Alternative: apply the changes manually

Alternatively, you can perform the upgrade manually. The following steps will guide you through the process:

#### 1. Update Dependencies

1. Navigate to your theme's `web/tailwind` folder.
2. Remove the PostCSS Node packages from your project:

   ```
   npm uninstall postcss postcss-import postcss-preset-env --ignore-scripts
   ```
3. Delete the `postcss.config.js` file.
4. Remove the old Tailwind CSS plugins:

   ```
   npm uninstall @tailwindcss/forms @tailwindcss/typography --ignore-scripts
   ```

   These are being replaced by our own solution in the `@hyva-themes/hyva-modules` package.
5. Update the `@hyva-themes/hyva-modules` package to the latest version:

   ```
   npm install @hyva-themes/hyva-modules@latest --ignore-scripts
   ```
6. Update Tailwind CSS:

   ```
   npm install tailwindcss@latest --ignore-scripts
   ```
7. Add the Tailwind CSS CLI:

   ```
   npm install @tailwindcss/cli@latest --ignore-scripts
   ```
8. Update the `scripts` in your `package.json` file with the following:

   ```
   "scripts": {
       "start": "npm run watch",
       "generate": "npx hyva-sources && npx hyva-tokens",
       "prewatch": "npm run generate",
       "watch": "npx tailwindcss -i tailwind-source.css -o ../css/styles.css --watch",
       "browser-sync": "npx browser-sync start --config ./browser-sync.config.js",
       "prebuild": "npm run generate",
       "build": "npx tailwindcss -i tailwind-source.css -o ../css/styles.css --minify"
   },
   ```

#### 2. Update CSS Entrypoint

In your main CSS file (`web/tailwind/tailwind-source.css`), replace the old `@import` statements with the new ones.

tailwind-source.css for Tailwind 4

```
/**
 * Welcome to your Hyvä Theme!
 *
 * If you're new to TailwindCSS, get started with the official documentation:
 * https://tailwindcss.com/
 *
 * For Hyvä-specific topics like CSS merging from modules or using design tokens,
 * refer to the Hyvä Themes documentation:
 * https://docs.hyva.io/hyva-themes/working-with-tailwindcss/index.html
 */

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

@theme {
    --color-bg: var(--color-slate-50);
    --color-fg: var(--color-slate-950);
    --color-fg-secondary: var(--color-slate-600);
    --color-surface: var(--color-white);
}
```

Warning

With Tailwind v4, it is important to be specific with CSS import paths. The `./` prefix is now required. You can exclude `index.css` if it is present in the import folder.

Before proceeding, create a backup of your current styles. You can do this by creating a `backup` folder in your theme's `web/tailwind` directory and copying your styles there.

Next, copy all folders from the Hyvä Default Theme's `web/tailwind` directory into your theme's `web/tailwind` directory, except for the `node_modules` folder.

#### 3. Migrate Configuration to CSS

Tailwind v4 moves configuration from `tailwind.config.js` into your CSS file using the `@theme` directive.

We have added a new config file that lets you keep using a similar syntax for your colors and spacing through the design tokens config.

What are Design Tokens?

To learn more about Design Tokens,
refer to our [FAQ for Design Tokens](./design-tokens/faq.html).

First, create the new `hyva.config.json` file.
In the `web/tailwind` folder, run the following command:

```
npx hyva-init
```

The Hyvä Default Theme uses a **primary color**,
so you need to add those colors to the `hyva.config.json` file.

Here are the default values from the config file:

```
{
  "tailwind": {
    "include": [],
    "exclude": []
  },
  "tokens": {
    "values": {
      "color": {
        "primary": {
          "lighter": "oklch(52% 0.2 265)",
          "DEFAULT": "oklch(46% 0.2 265)",
          "darker": "oklch(28% 0.2 265)"
        },
        "secondary": {
          "lighter": "oklch(72% 0.2 150)",
          "DEFAULT": "oklch(53% 0.15 150)",
          "darker": "oklch(39% 0.1 153)"
        },
        "on": {
          "primary": "#fff",
          "secondary": "#fff"
        }
      },
      "form": {
        "radius": "var(--radius-lg)",
        "stroke": "var(--color-slate-400)",
        "active-color": "var(--color-primary)"
      }
    }
  }
}
```

After creating the `hyva.config.json` file,
you can now restore your custom styles from the `backup` folder.
