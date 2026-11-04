<!-- source: https://docs.hyva.io/welcome/technical-vision.html -->

# Technical Vision

All Hyvä products are built with the purpose to lower dependencies to 3rd party libraries. We try to keep the technology stack limited to as few as possible. That goes for the theme, the checkout, and everything in Hyvä Commerce.

## Core Principles

Every decision we make is weighed against these:

- **Reduced complexity**: fewer moving parts to learn, debug, and maintain over the lifetime of a project.
- **Improved performance**: less JavaScript and CSS on the page, so stores stay fast on the devices shoppers actually use.
- **Improved developer experience**: familiar Magento concepts, readable templates, and a short path from a change to seeing the result.
- **Improved development velocity**: less time spent fighting the framework leaves more budget for what the merchant actually asked for.
- **Reduced dependencies**: every library we add is one we have to keep updated, secure, and compatible with Magento.
- **Reduced learning curve**: Magento developers should be productive in Hyvä without learning a new frontend ecosystem first.

## Tooling

We leverage a lot of tools that come from the [Laravel](https://laravel.com/) ecosystem. Laravel is a great example of a PHP ecosystem that is innovating and thriving at an incredible pace.

In particular, we use [Tailwind CSS](https://tailwindcss.com) and [Alpine.js](https://alpinejs.dev) to build beautiful, fast, and flexible frontend themes for Magento.

While we're using a modern frontend stack, there's plenty left of the classic Magento frontend that will be familiar to anyone with experience in Magento 2's Luma and Blank themes. We're keeping everything we consider to be great (layout XML, blocks, view models, and phtml), and got rid of the parts we would gladly live without (Knockout, RequireJS, and jQuery).

The same thinking runs through the rest of the suite. [Hyvä Checkout](../hyva-checkout/index.html) renders on the server with Magewire, rather than moving the checkout into a separate JavaScript application.

## Leaning on the Browser

Browsers have caught up with a lot of what frontend libraries were invented for. Anything the platform already does well is something we don't have to ship, maintain, or teach:

- Modals and off canvas panels build on the native `<dialog>` element through the [x-htmldialog](../hyva-themes/working-with-alpinejs/alpine-plugins/x-htmldialog.html) plugin.
- Sliders and carousels build on CSS scroll snap through the [x-snap-slider](../hyva-themes/working-with-alpinejs/alpine-plugins/x-snap-slider.html) plugin.
- Instant navigation comes from [Speculation Rules](../hyva-themes/performance/speculation-rules.html) and the [back forward cache](../hyva-themes/performance/bfcache.html), not from a client side router.

## Purpose

Hyvä is not revolutionary. Hyvä is not built to become a hype. One could say that Hyvä is the version of Luma we wished Magento had built. Or the frontend that Luma potentially could have become.

It is an alternative to PWA, for those that choose not to venture into the JavaScript only web.

We are not against PWA. But we're also not *super passionate* about PWA. For us, it's not the silver bullet to *all e-commerce needs*. We love the e-commerce and PHP ecosystems and don't believe PWA should be the de facto standard for building online shops.

In our experience, PWA is not easy to implement. It requires a very high level of expertise, time and money to build a truly great online shop using the PWA solutions available on the market. This makes it less suitable for the bulk of merchants a typical agency works for.

We are trying to close that gap, so that Magento remains the best solution for merchants of all sizes and agencies can stick with Magento and leverage their expertise on the platform, using both Hyvä and PWA solutions where each best fits their clients' needs.

## Related Topics

- [What is Hyvä?](what-is-hyva.html): the products in the suite and how they fit together
- [Working with Tailwind CSS](../hyva-themes/working-with-tailwindcss/index.html): how styling works in a Hyvä theme
- [Working with Alpine.js](../hyva-themes/working-with-alpinejs/index.html): how Alpine replaces Knockout and RequireJS
- [Performance](../hyva-themes/performance/index.html): what makes a Hyvä storefront fast, and how to keep it that way
