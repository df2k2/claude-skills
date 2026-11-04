<!-- source: https://docs.hyva.io/hyva-themes/faqs/supported-browsers.html -->

# What are supported browsers?

We at Hyvä strive to support as many browsers versions as we can,
but our supported versions depend on the tools we use to build Hyvä: TailwindCSS and AlpineJS.

As for AlpineJS, the oldest browsers we support are based on the Javascript features used in AlpineJS.

## Supported Browsers

At the time of writing, Hyvä supports the following browsers.

| Browser | Desktop | Android | iOS [1](#fn:ios) |
| --- | --- | --- | --- |
| Chrome | 111 | 111 |  |
| Edge | 111 | 111 |  |
| Safari | 16 [2](#fn:s) |  | 16 [2](#fn:s) |
| Firefox | 102 | 102 |  |
| Opera | 111 | 111 |  |
| Android Browser/WebView |  | 111 |  |
| Samsung Internet |  | 22 (Chromium 111) |  |

How are supported browsers determined?

The versions in the table reflect the browsers released in June 2022, based on the combination of Javascript and CSS features used in Hyvä.

## Unsupported Browsers

- **Opera Mini:** is primarily used on feature phones and is based on Opera 12.1 via Opera server. It is used mostly as a dedicated client for specific websites.

## Extending Browser Support

We have a dedicated page on [supporting older iOS Safari versions](./supporting-older-mobile-safari.html), which is also useful for extending the support for older versions of other browsers.

From Hyvä 1.4, Tailwind CSS v4 handles CSS processing through its bundled lightningcss, which targets a minimum of iOS Safari 15.4. This covers most modern browsers without additional configuration.

If your project requires support for older browsers, you can configure [postcss-preset-env](https://preset-env.cssdb.org/) or a custom lightningcss build with a [browserlist](../working-with-tailwindcss/using-browserlist.html) target to extend that coverage. Note that some CSS features, such as flex gap, still require manual adjustments as described on the [supporting older iOS Safari versions](./supporting-older-mobile-safari.html) page.

---

1. Chrome, Firefox, and more are available on iOS but use the same rendering engine as Safari,
   this can change with [iOS 17.4](https://developer.apple.com/support/alternative-browser-engines/) [↩](#fnref:ios "Jump back to footnote 1 in the text")
2. Tailwind supports Safari 16 and up but has backward compatibility with Safari 15.4, this will drop some dynamic options like color manipulation through the browser but the experience for the users of this older version, will not be broken. [↩](#fnref:s "Jump back to footnote 2 in the text")[↩](#fnref2:s "Jump back to footnote 2 in the text")
