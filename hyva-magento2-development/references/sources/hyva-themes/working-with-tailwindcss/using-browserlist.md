<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-browserlist.html -->

# Using Browserlist

## What is Browserlist?

Browserlist is a configuration tool widely used by popular JavaScript tools like Autoprefixer, Babel, ESLint, PostCSS, and Webpack.
It allows you to define which browsers your project needs to support.

**Why is it important for Hyvä?**

Hyvä versions 1.3.6 and newer integrate Browserlist to maintain browser compatibility based on the [supported browsers list](../faqs/supported-browsers.html).
This ensures your project works seamlessly with the targeted browsers while using the latest Tailwind CSS versions.

## Adding or Configuring Browserlist

The recommended approach is to manage Browserlist configuration within your project's `package.json` file.

By default, a Browserlist configuration will already be included in the `package.json` file for newly created Hyvä themes based on version 1.3.6 or later.

At the time of writing, the default Browserlist configuration you'll find in a Hyvä Theme `package.json` is:

```
{
    "browserslist": [
        "> 0.5% and not dead"
    ]
}
```

You can tune this configuration based on your specific browser support needs.
Refer to the official Browserlist documentation [Browserlist Docs](https://browsersl.ist/) for a detailed explanation of the available options.

## Using Browserlist with PostCSS Plugins with Tailwind v3

Hyvä 1.3.x and older

Tailwind v4 uses lightningcss instead of postcss, so this section no longer applies.

Hyvä utilizes the [postcss-preset-env](https://preset-env.cssdb.org/) plugin to ensure your CSS styles are compatible with older browsers.
This plugin effectively replaces Autoprefixer while incorporating its functionality internally.

### How postcss-preset-env Works

This plugin automatically converts modern CSS properties to their compatible counterparts for older browsers.
For instance, consider the following Tailwind CSS class:

```
.inset-4 {
  inset: 1rem;
}
```

After processing by `postcss-preset-env`, the CSS becomes:

```
.inset-4 {
  top: 1rem;
  right: 1rem;
  bottom: 1rem;
  left: 1rem;
}
```

This ensures consistent styling across browsers with varying levels of support for modern CSS features.

Tip

If you want to upgrade TailwindCSS and incorporate postcss-preset-env, then we recommend you checkout the docs on [how to upgrade TailwindCSS](../upgrading/updating-tailwindcss.html).
