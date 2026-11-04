<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/x-ignore.html -->

# The Alpine.js x-ignore plugin

The [`x-ignore` directive](https://alpinejs.dev/directives/ignore) is available natively in Alpine v3.

Since release 1.3.7 the `hyva-themes/magento2-theme-module` includes a backport to Alpine v2. It is automatically included in themes based on Alpine v2.

If present, Alpine will not initialize components within a DOM tree under an element with `x-ignore`.
Hyvä uses it in conjunction with the [`x-defer` directive](./x-defer.html).

```
<div x-data="{ label: 'This will not be evaluated' }">
    <div x-ignore>
        <span x-text="label"></span>
    </div>
</div>
```
