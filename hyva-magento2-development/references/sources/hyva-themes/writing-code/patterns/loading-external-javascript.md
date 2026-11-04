<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/loading-external-javascript.html -->

# Loading External JavaScript

This page guides how to best load external JavaScript while keeping performance in mind.
This includes techniques such as deferring script loading, using facades, and handling Alpine components.

## Overview

Loading external JavaScript files is it usually has a negative impact on Google page ranking metrics, such as [PageSpeed Insights](https://pagespeed.web.dev/).

This is generally because script parsing blocks the main thread, which in turn blocks the rendering process, which slows down perceived page load.
For this reason, it is a good idea to defer loading external libraries until they are needed.

Depending on the library, it may be best to defer loading until one of the below events occurs:

1. The visitor interacts with the page (anywhere on the page)
2. The visitor interacts with the particular page part that utilizes the JS (for example, clicks on a video 'play' button or interacts with a form)
3. The visitor scrolls down to a certain page part (example given, where the script/library is used on the page)

### Example: programmatically loading a script

Before we look at techniques, let's revisit how scripts are traditionally loaded in Magento.
Most libraries vendors request an external script to be added to the `<head>`, such as:

Do not use this, it will lower the page rank metrics

```
<script type="text/javascript" src="https://www.example.com/render-blocking-script.js"/>
```

In essence, the basic idea of all the above approaches is to load the script programmatically when needed.
To achieve this, follow the outline below:

```
const script = document.createElement('script')
script.src = 'https://www.example.com/render-blocking-script.js';
script.type = 'text/javascript';
document.head.append(script);
```

Be sure to properly escape dynamically generated URL strings

This is a basic example. When working with programmatically generated Magento URLs, they should always be escaped using `$escaper->escapeUrl()` inside `.phtml` template files if they are used as an HTML attribute value, or `$escaper->escapeJs()` if they are used in a JavaScript string.

## Deferring scripts until a user interacts with the page

Many external scripts have nothing to do with the user interface (UI) or experience (UX), yet because they block the rendering of the page, they impact performance.
This affects the time it takes until the user can interact with the page and the perceived visual page load.

This applies to commonly used marketing and analytical tools, such as (but not limited to):

- Google Analytics (and alternative solutions)
- Google Tag Manager (and alternative solutions)
- Bing Universal Event Tracking
- Tracking Pixels (e.g. Meta/Facebook)
- Digital marketing/email campaign tracking scripts (e.g. Mailchimp)
- User monitoring scripts (e.g. HotJar)

Info

Live Chat solutions can also be included here, but as they generally impact the UI, there may be occasions where a facade is a better solution (see below).

Instead of loading the external scripts on page load, it is often better to defer these until the user interacts with the page.
This is essentially any touch, mouse, or keyboard interaction, which you can listen for using native JavaScript [event listeners](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener).
Another, unintended, benefit to this approach is it helps filter out bots from your analytics, given they don't make the same interactions as a human user.

### Example: deferring scripts until any user interaction with `init-external-scripts`

The `init-external-scripts` event is triggered when any of the standard interaction events (`touchstart`, `mouseover`, `wheel`, `scroll`, `keydown`) is fired. It also ensures it is only dispatched once.

```
// The below shows an example of loading Google Tag Manager
// However, you could load/run any external script you need here
window.addEventListener('init-external-scripts', () => {
  // Load Google Tag Manager (where `GTM-XXXXXX` is your container ID)
  (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-XXXXXX');
}, {once: true, passive: true});
```

Given many use cases for these scripts are analytical, on the order success page, the event is fired on page load, rather than waiting for interaction.
This is to ensure conversion data is always tracked (even though it's almost impossible not to interact with the page, including if you are closing the tab/window).

The `init-external-scripts` event is only available in Hyvä Themes versions 1.1.20 and 1.2.0 and above

For compatibility with earlier Hyvä versions, add the callback to any user interaction event directly:

```
(events => {
  const loadMyLibrary = () => {
    events.forEach(type => window.removeEventListener(type, loadMyLibrary))
    // Load the library programmatically here
  };
  events.forEach(type => window.addEventListener(type, loadMyLibrary, {once: true, passive: true}))
})(['touchstart', 'mouseover', 'wheel', 'scroll', 'keydown'])
```

Be aware that using `init-external-scripts` to load many external libraries can have a negative impact on the INP metric.
If a script is not always used on a page, it is better to only load the specific library when needed.

### Example: deferring scripts until a specific user interaction

The following example will load a script when a form input is focused.
Other user interactions won't trigger the library to load.

```
<form x-data="initMyForm">
    <input type="text" name="example">
    <!-- other fields -->
</form>

<script>
    function initMyForm()
    {
      const form = this.$root;
      // Function to load external script. Return promise to be able to take action when loaded
      function load() {
        return new Promise(resolve => {
            const script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = '<?= $escaper->escapeJs($block->getViewFileUrl('Example_Module::js/library.js')) ?>';
            script.async = true;
            script.onload = resolve;
            document.head.appendChild(script);
        })
      }

      return {
        init() {
          const inputs = Array.from(form.elements);

          const initExternalScript = () => {
            // Remove event listener from all fields, so it is loaded once only
            inputs.forEach(input => {
              input.removeEventListener('focus', initExternalScript)
            });

            // Load the external library and then call a method that does something with it
            load().then(() => this.doSomethingWithTheLibrary());
          };

          // Add onfocus event listener to every form element
          inputs.forEach(input => {
            input.addEventListener('focus', initExternalScript, {once: true, passive: true})
          })
        },
        doSomethingWithTheLibrary() {...}
      }
    }
    window.addEventListener('alpine:init', () => Alpine.data('initMyForm', initMyForm), {once: true})
</script>
```

The above code works well if a script is only needed when a visitor interacts with a specific part of the page.
If the script is needed every time a page is visited, using the Hyvä `init-external-scripts` event is more suitable as described above.

## Facade Approach

In some cases, external scripts may not only hamper performance on page load but also impact the UI/UX of the page and can't be loaded after user interaction, because then some elements on the page may be missing.
Loading and initializing the library later often causes harmful content [layout shifts](https://web.dev/cls/) (also known as CLS).

In these cases, it is best to load and run the external scripts on user interaction, either on the entire page (via the `init-external-scripts` event), or on a specific element as described above.
However, to avoid the CLS, a facade should be created. The facade is a snippet of HTML taking up the same amount of space on the page as the content created by the script would.
It is usually styled to look visually very similar to the real thing, so visitors don't even notice the difference.
As soon as the visitor interacts with the facade, the script is loaded, and it is swapped out with the 'real' version.

Examples of external resources that can benefit from a facade approach include:

- Live chat widgets
- Search providers
- Videos (e.g., YouTube, Vimeo)

### Example: live chat facade

Most live chat solutions have a button/icon/link that triggers opening the live chat.
This button is often rendered after the external script is loaded and initialized. This often causes layout shifts.

To defer the loading and running of the live chat script, recreate the button. The user can then see and interact with it, which will then trigger the loading of the external script.

```
<button data-role="init-live-chat"
        class="btn btn-primary /* add styles here to reserve space, recreate button display and avoid layout shifts */">
    <?= $escaper->escapeHtml(__('Click to chat!')) ?>
</button>

<script>
    const liveChatButton = document.querySelector('[data-role="init-live-chat"]');
    liveChatButton.addEventListener('click', () => {
        // Implement live chat
        // This may be a script include or embed code, depending on the vendor

        // Programmatically trigger 'click' of actual live chat button to open panel/window (but ensure live chat library has loaded first)
        liveChatButton.click();
    }, {once: true});
</script>
```

Info

The button class/ID/data-\* (or other attribute) and its placement within the DOM must match that of the live chat provider so it is replaced when the external script is initialized.
As shown in the example, it may be necessary to trigger the click of the real button programmatically, in order to stop the user needing to double-click/tap.

How to use example code

Be aware the above code is only an educational example.
It needs to be changed to suit your requirements.

### Browser Cache and multiple Tabs

The above examples do not take into account that scripts usually are cached by the browser's HTTP cache once they have been loaded.
To load scripts that already are cached automatically after the DOM content is loaded, a flag in local storage to trigger the script directly on page load can be set.
This can also be used to execute external scripts if multiple tabs of the site are open.
However, be aware that the HTTP request overhead is not the only thing impacting core web vitals.
If a script is large, the parsing and execution of cached scripts on page load can also have a severe impact.

If in doubt, avoid setting the flag to trigger direct execution, or take care the trigger flag will only be evaluated when `init-external-scripts` is dispatched.

### Videos

For videos, more details and recommended libraries for creating facades can be found in the [Chrome Developers](https://developer.chrome.com/docs/lighthouse/performance/third-party-facades/) docs.

For a Magento-specific, and Hyvä supported, implementation for YouTube, MageQuest has published a small open-source module adding support for use within Page Builder (or manually): [magequest/magento2-module-lite-youtube](https://github.com/MageQuest/magento2-module-lite-youtube).

## Loading external scripts on scroll

Lazy loading external scripts on scroll is useful for areas on the page that are 'below the fold' and aren't required unless the user actually scrolls down the page to them.

This is often useful for scripts related to embedded content, such as:

- Customer reviews/testimonials sections (e.g. carousels of customer reviews)
- Social media and user-generated content (UGC) feeds (e.g. Instagram feed carousel)
- Google Maps (and alternative solutions)

These types of embeds come at a high cost when executed on page load. There is a good chance a visitor will never scroll down to them before navigating elsewhere, causing a lot of unnecessary overhead.

To achieve this, the Alpine [x-intersect plugin](../../working-with-alpinejs/alpine-plugins/x-intersect.html) can be used.

To use vanilla JavaScript, the [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API) is great for determining when elements are scrolled into view.

## Alpine Components

To load an external JS library that provides an alpine component, the main obstacle is the calling of the initialization methods for `x-data` and `x-init` only when the external library has loaded.

In Alpine v2 this can be accomplished with the help of `Alpine.initializeComponent(target)`.
In Alpine v3, the corresponding code is `Alpine.initTree(target)`

### Example: loading an Alpine component from vanilla JS

Here is an example using the [Alpine Product 360](https://github.com/moveideas/alpine-product-360) library.

```
<script>
    function initExternalAlpineComponent() {
        const script = document.createElement('script');
        script.type = 'module';
        script.src = 'https://cdn.jsdelivr.net/gh/moveideas/alpine-product-360@1.1.1/dist/index.min.js';

        script.onload = () => {
            const target = document.getElementById('target');
            const url1 = 'https://picsum.photos/300/350?id=1',
                  url2 = 'https://picsum.photos/300/350?id=2';
            // because the library is a JavaScript module,
            // we need to call alpineCarousel.default()
            target.setAttribute('x-data', `alpineCarousel.default(['${url1}', '${url2}'], {infinite: true})`);
            target.setAttribute('x-init', 'start()');

            Alpine.initializeComponent
                ? Alpine.initializeComponent(target) // Alpine v2
                : Alpine.initTree(target); // Alpine v3
        };

        document.head.appendChild(script);
    }
</script>
<div>
    <h2>Lazy Initialization of an Alpine Component</h2>

    <button type="button" class="btn"
            onclick="initExternalAlpineComponent()">Load Alpine Component</button>
    <div id="target">
        <img
            :src="carousel.currentPath"
            @mouseup="handleMouseUp"
            @mousedown="handleMouseDown"
            @mousemove="handleMouseMove"
            @mouseleave="handleMouseLeave"
            draggable="false"
        >
    </div>
</div>
```

## Nested Alpine Component

Chances are the new library should be initialized as a nested component.
This can lead to issues because the Alpine.js markup for the nested component is not meant to be evaluated in the scope of the outer component.

The nested component DOM needs to be removed from evaluation until the new nested component is initialized and ready.

There are many ways to accomplish this, but one is to hide the nested component HTML from the parent scope until the nested component is loaded, by placing it in a `<script type="text/html">` element.
When the external library is loaded, the script tag `innerHTML` is then copied into the target component about to be initialized.

### Example: loading a nested Alpine component

Here is the same example as above, except that this time it is initialized as a nested component.

```
<script>
    function initialComponent() {
        return {
            initProduct360() {
                const script = document.createElement('script');
                script.type = 'module';

                script.addEventListener('load', () => {
                    const target = document.getElementById('target');
                    const url1 = 'https://picsum.photos/300/350?id=1',
                          url2 = 'https://picsum.photos/300/350?id=2';
                    // because the library is a JavaScript module,
                    // we need to call alpineCarousel.default()
                    target.setAttribute('x-data', `alpineCarousel.default(['${url1}', '${url2}'], {infinite: true})`);
                    target.setAttribute('x-init', 'start()');

                    // inject the nested component into the DOM
                    target.innerHTML = document.getElementById('target-content').innerHTML;

                    Alpine.initializeComponent
                      ? Alpine.initializeComponent(target) // Alpine v2
                      : Alpine.initTree(target); // Alpine v3
                });
                script.src = 'https://cdn.jsdelivr.net/gh/moveideas/alpine-product-360@1.1.1/dist/index.min.js';
                document.head.appendChild(script);
            }
        }
    }
</script>
<div x-data="initialComponent()">
    <h2>Lazy Initialization of a nested Alpine Component</h2>

    <button type="button" class="btn" @click="initProduct360()">Load Alpine Component</button>
    <div id="target"></div>
    <!-- hide the component from the browser -->
    <script type="text/html" id="target-content">
        <img
            :src="carousel.currentPath"
            @mouseup="handleMouseUp"
            @mousedown="handleMouseDown"
            @mousemove="handleMouseMove"
            @mouseleave="handleMouseLeave"
            draggable="false"
        >
    </script>
</div>
```
