<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/generating-css.html -->

# Generating CSS with Tailwind in Hyvä Themes

Hyvä themes use Tailwind CSS to generate optimized stylesheets. Rather than shipping a massive pre-built CSS file, Tailwind scans your templates for utility classes and builds a lean `styles.css` containing only what you actually use. This page covers installing dependencies, building CSS for production, and running a watch process during development.

## Installing npm Dependencies for Tailwind CSS

Before generating CSS, you need to install the required Node.js packages. Navigate to the `web/tailwind` directory inside your Hyvä theme and run `npm ci`:

```
cd path/to/project/app/design/frontend/Acme/default/web/tailwind
npm ci
```

The `npm ci` command performs a clean install based on the `package-lock.json` file, ensuring consistent dependency versions across environments.

Minimum Node.js version requirements per Hyvä version

For best results, use the current Node.js LTS version or later.
Different Hyvä releases have different minimum Node.js requirements:

- Hyvä 1.4.0 and newer: Node.js 20
- Hyvä 1.3.6: Node.js 16
- Hyvä 1.2.0: Node.js 14
- Hyvä 1.1.0: Node.js 12.13

## Building Tailwind CSS for Production

When you are ready to deploy, generate an optimized, minified stylesheet by running `npm run build`:

```
npm run build
```

The `npm run build` command compiles Tailwind CSS with production optimizations. The resulting `styles.css` file is written to the `web/css/` directory of your Hyvä theme. Run this command after making template changes and before deploying to production.

## Building Tailwind CSS During Development with Watch Mode

During development, use the watch process to automatically regenerate `styles.css` whenever you save a file. Start watch mode with `npm run watch`:

```
npm run watch
```

The watch process continuously monitors your templates for Tailwind CSS classes referenced in the purge configuration. Any changes are automatically compiled into the `styles.css` file, so you can see updates immediately after refreshing the browser.

Running npm commands without changing directories

You can run `npm` commands from any directory by passing the `--prefix` argument with the path to your theme's `web/tailwind` folder:

```
npm --prefix path/to/project/app/design/frontend/Acme/default/web/tailwind ci
npm --prefix path/to/project/app/design/frontend/Acme/default/web/tailwind run build
```

## Using npm start as a Watch Alias

Available since Hyvä 1.4.0

The `npm start` command is a convenient alias for `npm run watch`. If you prefer a shorter command, you can use `npm start` instead:

```
npm start
```

## Live Reloading with browser-sync

For automatic browser reloading during development, Hyvä supports `browser-sync`. Start `browser-sync` by providing your Magento development URL as the proxy:

```
npm run browser-sync -- --proxy http://your-magento.test
```

Note

Replace `http://your-magento.test` with your actual Magento development URL.

For setup details and advanced configuration, see the dedicated [Using browser-sync](using-browser-sync.html) page or the official [browser-sync documentation](https://browsersync.io/docs).

## Deprecated and Removed npm Commands

The following npm commands have been removed from Hyvä and should no longer be used:

`npm run build-prod` (removed in Hyvä 1.4.0)
: This command was identical to `npm run build` but included a success message. Use `npm run build` instead.

`npm run build-dev` (deprecated in Hyvä 1.2.0, removed in Hyvä 1.4.0)
: This command generated a development CSS build without watch functionality. It existed before Tailwind's JIT mode made watch builds fast enough for development. Use `npm run watch` instead.

## Related Topics

- [Tailwind CSS Purging Settings](tailwind-purging-settings.html) - Configure which files Tailwind scans for CSS classes
- [Hyvä Theme CSS Files](hyva-theme-css-files.html) - Understand the CSS file structure in Hyvä themes
- [Using browser-sync](using-browser-sync.html) - Set up live reloading for faster development
- [Dynamic Tailwind Classes](dynamic-tailwind-classes.html) - Handle dynamically generated Tailwind class names
