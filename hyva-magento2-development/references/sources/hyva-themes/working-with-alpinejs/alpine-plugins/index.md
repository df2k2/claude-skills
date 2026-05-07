<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/index.html -->

# Alpine.js Plugins

With Alpine v3, many plugins are provided out of the box, and it is very common to write custom plugins.

The API has improved significantly over version 2, and with Hyvä, we provide a few plugins out of the box, with more being available through Hyvä UI.

Tip

To create a custom Alpine plugin for Hyvä, please refer to the [guide on adding custom plugins](custom.html).

## Plugins

Several alpine plugins providing custom directives are included with Hyvä out-of-the-box.

### `x-intersect`

Alpine's Intersect plugin simplifies viewport intersection observation,
providing an easy way to trigger actions when elements come into view.

We provide this plugin by default in the Hyvä Theme Module starting from version 1.10.0.

For more information, see the [`x-intersect` docs](x-intersect.html).

### `x-ignore`

Alpine's ignore directive allows you to exclude specific parts of your HTML from Alpine's processing.

We provide Alpine v2 support in the Hyvä Theme Module starting from version 3.7.0 as a plugin.
This directive is normally part of Alpine v3.0.0.

For more information, see the [`x-ignore` docs](x-ignore.html).

### `x-defer`

The `x-defer` directive, a custom Hyvä Alpine plugin, allows you to postpone the initialization of Alpine components.

This optimization technique can improve initial page load performance by deferring the execution of non-critical JavaScript code.

For more information, see the [`x-defer` docs](x-defer.html).

### `x-snap-slider`

The `x-snap-slider` directive, a custom Hyvä Alpine plugin, allows you to build CSS-driven sliders with enhanced JavaScript functionality.

This enables you to create lightweight sliders powered by CSS, with JavaScript progressively enhancing the user experience.

For more information, see the [`x-snap-slider` docs](x-snap-slider.html).

### `x-htmldialog`

Alpine's HTML Dialog plugin, used with the `x-show` directive, enables the use of the native HTML dialog element.
Allowing you to build Modals and Offcanvas elements with ease.

For more information, see the [`x-htmldialog` docs](x-htmldialog.html) or see the [docs on fylgja.dev](https://fylgja.dev/library/extensions/alpinejs-dialog/).

### `x-collapse`

This Plugin is offered in Hyvä UI

Compatibility Note for Hyvä 1.4+

As of Hyvä 1.4, this functionality is handled by native CSS and the HTML `details` element.
If you are using the `x-collapse` plugin with Hyvä 1.4 or newer,
you must set the `interpolate-size` property on the element to `numeric-only` so the opening animation works correctly.

```
[x-collapse] {
  interpolate-size: numeric-only;
}
```

Alpine's Collapse plugin, used with the `x-show` directive, provides smooth animations for expanding and collapsing elements.

For more information, see the [`x-collapse` docs on alpine.js](https://alpinejs.dev/plugins/collapse).

## Official Plugins

Alpine provides more plugins that you can add yourself.

You should add these plugins in the same way we have done with our own implementations,
by adding the plugin JavaScript code as an inline script in a PHTML file and include them on the pages they are needed using layout XML.

The plugin must be registered in a subscriber to the `alpine:init` event:

```
<script>
    (() => {
        function src_default(Alpine) {
            Alpine.directive(...);
        }

        document.addEventListener('alpine:init', () => {
            window.Alpine.plugin(src_default);
        });
    })();
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

You can find examples in the Hyva\_Theme module in `view/base/templates/page/js/plugins/v3/`.

## Third-Party Plugins

In addition to this, there are also many third-party plugins that enhance your Alpine experience.

For all available options, see this [GitHub tag page on alpinejs-plugins](https://github.com/topics/alpinejs-plugin).
