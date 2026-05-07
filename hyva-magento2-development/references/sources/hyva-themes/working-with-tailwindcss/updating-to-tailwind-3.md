<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/updating-to-tailwind-3.html -->

# Updating to Tailwind CSS v3

Info

This guide outlines how to update TailwindCSS in Hyvä projects, focusing on versions after v1.1.
If you're using Hyvä with TailwindCSS v2, refer to the [update steps for release 1.2.0](../upgrading/upgrading-to-1-2-0.html) first.

## Understanding Updates

Before updating, review the TailwindCSS changelog to understand the changes introduced in the new version.

## Prerequisites

- **Node.js:** Ensure you have Node.js version 16 or higher installed (check with `node -v`).

## How to update

1. **Install the update:** Run `npm install tailwindcss@1.3` in your theme's directory.
   You can replace `@1.3` with a specific version for more control.
2. **Upgrade PostCSS (Optional):** If you're not already using `postcss-preset-env`, follow these steps:
   - **Uninstall Autoprefixer:** Run `npm uninstall autoprefixer`.
   - **Install postcss-preset-env:** Run `npm install postcss-preset-env`.
   - **Update `postcss.config.js`:**
     - Remove `require('autoprefixer'),`
     - Add `require('postcss-preset-env'),` after `require('tailwindcss'),`
   - **Add Browserlist config:** In your `package.json`, add the following:

     ```
     "browserslist": [
         "last 3 version",
         "> 0.5%",
         "not dead",
         "not op_mini all"
     ]
     ```

     For more information, refer to the [using browserlist docs](using-browserlist.html).
3. **Update Optional Plugins (Optional):**
   You can update optional plugins like `@tailwindcss/forms` and `@tailwindcss/typography` similarly:

   ```
   npm install @tailwindcss/forms@latest
   npm install @tailwindcss/typography@latest
   ```

   **Important:** While these plugins are less likely to introduce new CSS properties, reviewing their changelogs before updating is still recommended.

## Updating the Configuration

This section explains situations where updating the configuration might be necessary.

### Adding `tailwind.config.js` merging

If you want to enable `tailwind.config.js` merging, please checkout the dedicated documentation on [Module tailwind.config.js merging](../compatibility-modules/technical-deep-dive.html#tailwind-asset-merging-for-compatibility-modules) (Note: This feature was introduced in Hyvä 1.1.14).

### Update the config with the Default Theme version

When upgrading to a new Hyvä version, the upgrade documentation might highlight specific changes needed in your `tailwind.config.js`.

These changes could involve adding, replacing, or removing configuration entries.

Look for sections titled **New tailwind.config.js entry** within the upgrade documentation
(as seen in the [1.3.0 upgrading to](../upgrading/upgrading-to-1-3-0.html#new-tailwindconfigjs-entry)).
