<!-- source: https://docs.hyva.io/hyva-ui-library/ui-plugins.html -->

# Hyvä UI Plugins

What are Hyvä UI plugins?

In short, Hyvä UI Plugins are our solution for creating reusable Alpine.js or Vanilla JavaScript plugins that work seamlessly with Hyvä UI Components.

We offer a variety of smaller solutions that can be paired with Hyvä UI Components.

For example, the Sticky Header plugin works with any header option, including the default theme's header.

These plugins allow us to experiment with new and exciting features that we might later merge back into the theme.

## Where can I find the UI Plugins?

Hyvä UI Plugins are located alongside the components they enhance.

Instead of looking in the `components` folder, look for the `plugins` folder.

```
./hyva-ui
├── assets
├── components
├── i18n
└── plugins
    └── <PLUGIN>
        ├── src
        └── README.md
```

## Alpine.js vs Vanilla JavaScript Plugins

If a plugin's name is prefixed with `alpine`, it's designed to be used with Alpine.js.

Each plugin's `README.md` file explains how to use it. Related documentation for third-party Alpine.js plugins can also be found in our documentation under [working-with-alpinejs/alpine-plugins](../hyva-themes/working-with-alpinejs/alpine-plugins/index.html).

Vanilla JavaScript plugins do not have this prefix and can be used as-is, meaning they are not bound to a specific version of Hyvä.
