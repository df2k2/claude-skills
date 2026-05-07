<!-- source: https://docs.hyva.io/hyva-themes/faqs/supported-browsers.html -->

# What are supported browsers?

We at Hyvä strive to support as many browsers versions as we can,
but our supported versions depend on the tools we use to build Hyvä: TailwindCSS and AlpineJS.

For native TailwindCSS, supported browsers are relatively new, with the introduction of CSS Properties such as `inset`. To be able to support older browsers we added [browserlist](https://browsersl.ist/) and [postcss-preset-env](https://preset-env.cssdb.org/) to keep supporting older browsers.

As for AlpineJS, the oldest browsers we support are based on the Javascript features used in AlpineJS.

## Supported Browsers

At the time of writing, Hyvä supports the following browsers.

| Browser | Desktop | Android | iOS [1](#fn:ios) |
| --- | --- | --- | --- |
| Chrome | 103 | 103 |  |
| Edge | 103 | 103 |  |
| Safari | 16 [2](#fn:s) |  | 16 [2](#fn:s) |
| Firefox | 102 | 102 |  |
| Opera | 103 | 103 |  |
| Android Browser/WebView |  | 103 |  |
| Samsung Internet |  | 18 (Chromium 99) |  |

How are supported browsers determined?

The versions in the table reflect the browsers released in June 2022, based on the combination of Javascript and CSS features used in Hyvä.

## Unsupported Browsers

- **Internet Explorer (IE):** Officially [retired by Microsoft on June 15, 2022](https://blogs.windows.com/windowsexperience/2022/06/15/internet-explorer-11-has-retired-and-is-officially-out-of-support-what-you-need-to-know/).
  Magento also [dropped support for IE years ago with 2.4.0](https://experienceleague.adobe.com/en/docs/commerce-operations/release/notes/magento-open-source/2-4-0#:~:text=The%20Internet%20Explorer%2011.x%20browser%20is%20no%20longer%20supported).
  Continuing to support comes with a significant cost, which is why we decided against it a long time ago.
- **Opera Mini:** is primarily used on feature phones and is based on Opera 12.1 via Opera server. It is used mostly as a dedicated client for specific websites.

## Extending Browser Support

We have a dedicated page on [supporting older iOS Safari versions](supporting-older-mobile-safari.html), which is also useful for extending the support for older versions of other browsers.

With Hyvä 1.3.6 we have added [postcss-preset-env](https://preset-env.cssdb.org/), you can use this postcss plugin to keep using modern CSS and convert this to older CSS,
to configure the supported browsers [see the docs on browserlist](../working-with-tailwindcss/using-browserlist.html).

But do note things like flex gap need manual adjustment as explained in the [supporting older iOSdSafari versions]

---

1. Chrome, Firefox, and more are available on iOS but use the same rendering engine as Safari,
   this can change with [iOS 17.4](https://developer.apple.com/support/alternative-browser-engines/) [↩](#fnref:ios "Jump back to footnote 1 in the text")
2. Tailwind supports Safari 16 and up but has backward compatibility with Safari 15.4, this will drop some dynamic options like color manipulation through the browser but the experience for the users of this older version, will not be broken. [↩](#fnref:s "Jump back to footnote 2 in the text")[↩](#fnref2:s "Jump back to footnote 2 in the text")
