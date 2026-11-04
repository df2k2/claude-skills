<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/running-js-only-on-mobile.html -->

# Running JavaScript only on mobile

Sometimes a component behavior needs to change depending on the view port size.
Usually part of a component should be shown on desktop window sizes and hidden on mobile devices.

This can sometimes be achieved using CSS only, but if the state is influenced by more than only the view port size, this can get tricky.
Additionally, when a component is only hidden with CSS, all DOM elements still count to the total DOM size by Google, even though they serve no purpose for the visitor.

Conditionally showing part of a component and hiding it from the DOM can can be achieved using Alpine's `<template>` syntax in combination with `matchMedia`.

```
<script>
    function initComponent() {
        return {
            isMobile: true,
            init() {
                const matchMedia = window.matchMedia('(max-width: 768px)');

                // set the initial value
                this.isMobile = matchMedia.matches;

                // trigger update value on changes
                if(typeof matchMedia.onchange !== 'object') {
                    // fallback for iOS 12/13, where addEventListener does not accept an event type parameter
                    matchMedia.addListener((event) => this.isMobile = event.matches);
                } else {
                    matchMedia.addEventListener(
                        "change",
                        (event) => this.isMobile = event.matches
                    )
                }
            }
        }
    }
</script>
<div x-data="initComponent()" x-init="init()">
    <template x-if="!isMobile">
        <div>None of the HTML within <code>&lt;template&gt;</code> is counted as DOM elements by Google or the browser.</div>
    </template>
</div>
```

For more information on `window.matchMedia`, please refer to the [mdn documentation](https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia), and to learn more the Alpine.js `<template>` directive, head over to the [Alpine templating docs](https://alpinejs.dev/essentials/templating#x-if).
