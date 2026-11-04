<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/x-intersect.html -->

# The Alpine.js x-intersect plugin

Alpine version 3 contains a intersection plugin, that can be used to trigger JavaScript in a alpine component when an element scrolls into (or out of) the browser window.

Since release 1.1.10 Hyvä contains a backport of the x-intersect plugin to Alpine.js version 2.
This allows to write forward compatible code more easily, that will continue to work without changes when Hyvä is upgraded to use Alpine v3.

Please refer to the [Intersect plugin Alpine.js documentation](https://alpinejs.dev/plugins/intersect#installation) for more information.

```
<div x-data="{ shown: false }" x-intersect="shown = true">
    <div x-show="shown" x-transition>
        I'm in the viewport!
    </div>
</div>
```
