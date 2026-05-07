<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/luma-theme-fallback.html -->

# Gradual Migration with the Luma Theme Fallback

## Installation

This feature is provided by the module `hyva-themes/magento2-theme-fallback`. Add it as a dependency to your project using Composer:

```
composer require hyva-themes/magento2-theme-fallback
bin/magento setup:upgrade
```

## Migrating to Hyvä page by page

When adopting Hyvä, you do not have to migrate your entire store at once. The Luma theme fallback module lets you configure specific routes to use a Luma-based theme instead of Hyvä, so you can bring pages across gradually while the rest of your store runs on Hyvä.

On pages using the fallback, the Hyvä theme is not active. Tailwind CSS and Alpine.js are not loaded. Instead, RequireJS and all standard Luma theme dependencies are loaded by the browser.

**Any styling for those pages must be built using standard Magento approaches, not Hyvä's.**

## Checkout as a common use case

The most common reason to use the Luma theme fallback is the checkout. If your project uses a Luma-based checkout (such as the default Magento checkout or a third-party checkout that depends on Luma), you can keep it running on the Luma theme while the rest of the store runs on Hyvä.

Luma Checkout documentation

For documentation on using the [Luma Checkout](../../hyva-checkout/faq/luma-checkout-faq.html) with Hyvä, [see the Luma Checkout FAQ](../../hyva-checkout/faq/luma-checkout-faq.html).

History

Before the `Hyva_ThemeFallback` module existed, the `Hyva_LumaCheckout` module provided the fallback mechanism for the checkout only.

The `Hyva_ThemeFallback` module was created to allow reusing the theme fallback on arbitrary routes.

## Configuration

Configure the following settings in the Magento admin panel:

1. `HYVA THEMES->Fallback theme->General Settings->Enable`
   The configuration path is `hyva_theme_fallback/general/enable`
2. `HYVA THEMES->Fallback theme->General Settings->Theme full path`
   The configuration path is `hyva_theme_fallback/general/theme_full_path`
   The default is `frontend/Magento/luma`
3. `HYVA THEMES->Fallback theme->General Settings->The list of URL's parts`
   The configuration path is `hyva_theme_fallback/general/list_part_of_url`
   To use the Luma checkout, configure these paths:
   `checkout/index`, `paypal/express/review` and `paypal/express/saveShippingMethod`
   These paths are supplied as the default configuration by the `Hyva_LumaCheckout` module.

## How does it work?

The module adds a before-plugin to all frontend controllers. The plugin checks if a configured value matches either the current `route/controller/action` or the SEO-friendly URL path, and if so, applies the fallback theme.

The theme fallback is applied when:

1. The current `route/controller/action` request path matches the configured URL pattern.

   - *Example*: the configured URL is `customer/account`.
     *Result*: the fallback is applied to all requests such as `customer/account/*`.
   - *Example*: the configured URL is `customer/account/login`.
     *Result*: the fallback is applied only to the login page.
2. A part of the current request path matches the configuration.

   - *Example*: the configured value is `demo-product.html`.
     *Result*: the fallback is applied to all pages with `demo-product.html` in the path.
