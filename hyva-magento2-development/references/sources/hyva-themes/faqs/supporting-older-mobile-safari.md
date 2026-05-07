<!-- source: https://docs.hyva.io/hyva-themes/faqs/supporting-older-mobile-safari.html -->

# Supporting older versions of Safari on iOS

Archived

This page is kept for reference for stores that cannot upgrade.
It covers Hyvä versions older than 1.4 running Tailwind v3 or earlier, and the lower Safari versions those releases support.

The officially supported minimum is Safari 16. See the [supported browsers overview](supported-browsers.html) for the full table.

Tailwind CSS v4 (Hyvä 1.4+) requires at least Safari 15.4. Supporting Safari older than 15.4 requires staying on a Tailwind v3 release of Hyvä.

## Minimum requirements by version

| Hyvä version | Tailwind | Minimum Safari |
| --- | --- | --- |
| 1.4+ | v4 | 15.4 |
| 1.3.x | v3 | 14.5 |
| 1.1.x | v2 | 12.2 |

## Extending support on Tailwind v3

If you are on Hyvä 1.3.x and need to support Safari below 14.5, the following steps can help.

### postcss-preset-env

Since Hyvä 1.3.6, [postcss-preset-env](https://preset-env.cssdb.org/) is included in the build. This PostCSS plugin automatically converts modern CSS to older equivalents based on your [browserlist](../working-with-tailwindcss/using-browserlist.html) configuration, reducing the amount of manual work needed.

Note that some properties, such as the `gap` property on flexbox, still require manual adjustment as described below.

### CSS changes

Hyvä uses the `gap` property on flexbox in many templates, using Tailwind classes such as `gap-x-2`, `gap-x-4`, `gap-y-0`, `gap-y-1`, `gap-y-2`, and `gap-y-16`. Flexbox `gap` is only supported from Safari 14.5.

```
class="flex gap-x-2"
```

Replace each `gap-*` class used with `flex` with the `space` equivalent, for example `space-x-2` and `space-y-2`.

```
class="flex space-x-2"
```

The `space-*` classes use the CSS `margin` property, which is supported by all Safari on iOS versions. Check the layout after each change and be prepared to make additional corrections.

### JavaScript polyfills

#### queueMicrotask

Adding a polyfill for `queueMicrotask` will extend support to Safari on iOS 12.0.

```
<script>
if (typeof window.queueMicrotask !== 'function') {
    window.queueMicrotask = function(callback) {
        Promise.resolve()
            .then(callback)
            .catch(e => setTimeout(() => {
                throw e;
            }));
    };
}
</script>
```

#### Array flat and flatMap

Adding a polyfill for `Array.prototype.flat` and `Array.prototype.flatMap` extends support to even older versions.

```
<script>
if (!Array.prototype.flat) {
    Object.defineProperty(Array.prototype, 'flat', {
        configurable: true,
        value: function flat () {
            var depth = isNaN(arguments[0]) ? 1 : Number(arguments[0]);

            return depth ? Array.prototype.reduce.call(this, function (acc, cur) {
                if (Array.isArray(cur)) {
                    acc.push.apply(acc, flat.call(cur, depth - 1));
                } else {
                    acc.push(cur);
                }

                return acc;
            }, []) : Array.prototype.slice.call(this);
        },
        writable: true
    });
}
if (!Array.prototype.flatMap) {
    Object.defineProperty(Array.prototype, 'flatMap', {
        configurable: true,
        value: function flatMap (callback) {
            return Array.prototype.map.apply(this, arguments).flat();
        },
        writable: true
    });
}
</script>
```

### Adding polyfills to the page head

Add polyfill scripts directly in the page `<head>` by declaring a child block for `head.additional`.

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
>
    <body>
        <referenceContainer name="head.additional">
            <block name="head.alpinejs.polyfills"
                   template="Magento_Theme::page/js/alpinejs-polyfills.phtml"/>
        </referenceContainer>
    </body>
</page>
```

## Tailwind v2 and Hyvä 1.1.x

For Safari versions below 12.2, the only option is to build on Hyvä 1.1.x, which used Alpine.js and Tailwind v2. The latest release in that series is 1.1.25.

No Support

Hyvä 1.1.x releases are no longer supported. New features are developed only for the latest releases based on Alpine v3 and Tailwind v4. Building on an older release can still be a reasonable choice if the existing feature set is sufficient.

Native Alpine.js 3.12.3 vs the Hyvä Bundle

The native version of Alpine.js 3.12.3 only supports Safari on iOS 13.4 (released 2020-03-24) due to the use of the nullish coalescing operator `??`. Hyvä 1.2.6 bundles a patched version which supports Safari on iOS 12.2.


---

*The polyfill implementations on this page were copied from [jonathantneal/array-flat-polyfill](https://github.com/jonathantneal/array-flat-polyfill), released under the CC0 1.0 Universal (CC0 1.0) Public Domain Dedication license.*
