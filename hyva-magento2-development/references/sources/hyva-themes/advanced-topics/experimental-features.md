<!-- source: https://docs.hyva.io/hyva-themes/advanced-topics/experimental-features.html -->

# Experimental features

Info

While these experimental browser APIs are easy to enable, technical knowledge is required to modify the code.
Please read the linked Resources & Articles for each experiment before asking questions in [Slack](https://www.hyva.io/slack).

Warning

Because of the reliance on experimental browser APIs,
the Hyvä implementations may change or be removed entirely in the future without notice.

*We currently have no new experimental features. If you have a good idea for one, feel free to share it with us so we can consider adding it to Hyvä.*

## Experiments in Hyvä 1.3.x

These experimental features were supported in Hyvä 1.3 and have been reclassified as stable features for Hyvä 1.4.

Speculation Rules

Speculation rules were added as an experimental feature in Hyvä 1.3.7 and are enabled by default in Hyvä 1.4 as a stable feature.

Please see the [Speculation Rules](../performance/speculation-rules.html) page for how to use it with Hyvä 1.4.0 and newer.

---

The Speculation Rules API empowers proactive resource loading for anticipated user journeys.

By prefetching or prerendering potential next pages,
you can significantly improve perceived load times and enhance the user experience.

**How to Enable**

Navigate to *Hyvä Themes > Experimental > Experimental Features* and enable "Enable Preloading Speculation Rules".

**Resources & Articles**

- Caniuse Support: [Caniuse Speculation Rules](https://caniuse.com/mdn-http_headers_speculation-rules)
- Developer Documentation: [Chrome Dev - Preload Pages](https://developer.chrome.com/docs/web-platform/prerender-pages)
- Blog Post: [Nitropack Blog - Speculation Rules API](https://nitropack.io/blog/post/speculation-rules-api)

View Transitions

View Transitions were added as an experimental feature in Hyvä 1.3.10 and are enabled by default in Hyvä 1.4 as a stable feature.

This is now part of the default theme as CSS and JS, so there are no settings for it anymore.

---

The View Transitions API v2 lets you implement smooth view transitions for same-origin, cross-document navigations.

This allows the creation of smooth transitions between views on your website to enhance the user experience.

For advanced control and perceived speed improvements with page animations, consider using the Speculation Rules API in conjunction with View Transitions API v2.

**How to Enable**

Navigate to *Hyvä Themes > Experimental > Experimental Features* and enable "Enable View Transitions".

**Resources & Articles**

- Caniuse Support: [Caniuse View Transition](https://caniuse.com/mdn-css_at-rules_view-transition)
- Developer Documentation: [Chrome Dev - View Transitions](https://developer.chrome.com/docs/web-platform/view-transitions/cross-document)
- Blog Post: [Chrome Blog - View Transitions](https://developer.chrome.com/blog/new-in-chrome-126#cross-document-transitions)
