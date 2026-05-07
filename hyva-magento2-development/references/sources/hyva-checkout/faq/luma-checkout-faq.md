<!-- source: https://docs.hyva.io/hyva-checkout/faq/luma-checkout-faq.html -->

# Luma Checkout with Hyva Themes

## Using Luma-Based Checkouts Alongside Hyva Themes

Hyva Themes can work with Luma-based checkout solutions through the **Theme Fallback for Hyva Themes** module. This FAQ covers installing the Luma checkout fallback module, configuring the fallback theme, and choosing a compatible Luma-based checkout. While Hyva Checkout is the recommended checkout solution, some merchants need to keep a Luma-based checkout during migration or for compatibility reasons.

## Installing the Hyva Luma-Checkout Module from Packagist

Install the `hyva-themes/magento2-luma-checkout` module with Composer:

```
composer require hyva-themes/magento2-luma-checkout
```

## Installing the Hyva Luma-Checkout Module for Contributors and Technology Partners

Warning

Do not use this installation method for production environments.

Info

You need access to [gitlab.hyva.io](https://gitlab.hyva.io) and must add your SSH key to your GitLab account before proceeding.

Configure the GitLab repositories as Composer package repos, then install the `magento2-luma-checkout` module:

```
composer config repositories.hyva-themes/magento2-luma-checkout git git@gitlab.hyva.io:hyva-themes/magento2-luma-checkout.git
composer config repositories.hyva-themes/magento2-theme-fallback git git@gitlab.hyva.io:hyva-themes/magento2-theme-fallback.git

composer require hyva-themes/magento2-luma-checkout --prefer-source
```

## Setting Up the Luma Checkout Fallback

After installing the module, run `setup:upgrade` from the Magento project root:

```
bin/magento setup:upgrade
```

The Luma fallback checkout is enabled by default after installation.

Toggle the fallback and adjust additional settings in the Magento admin panel under:

`HYVA THEMES -> Theme Fallback -> General Settings`

To force-enable the Luma fallback via the command line, run the following `config:set` command:

```
bin/magento config:set hyva_theme_fallback/general/enable 1 --lock-config
```

Tip

In developer mode, the Luma fallback checkout should be visible on the frontend immediately. A cache flush may be required. In production mode, run `bin/magento setup:static-content:deploy` before the fallback takes effect.

## Choosing a Luma-Based Checkout Module

Several checkout modules built on the Magento Luma or Blank theme work with Hyva Themes through the theme fallback module. Compatible Luma-based checkouts include:

- `Magento_Checkout` (the default Magento checkout)
- OneStepCheckout
- `Amasty_Checkout`
- `Danslo_CleanCheckout` / `Rubic_CleanCheckout`
- `Mageplaza_Osc`

This list is not exhaustive. Any checkout built for the Luma or Blank theme can work with the Hyva theme fallback module.

## How the Theme Fallback Module Works

The Hyva theme fallback module deactivates the Hyva frontend theme for configured Magento routes or request paths and activates a traditional Magento theme instead. A route consists of `module/controller/action` (for example `catalog/product/view` would match all product pages), while a request path is a URL path (for example `women/tops/some-product.html` would match only that specific page). Both can be used to trigger the fallback. When a customer visits a fallback route or request path, Magento loads the standard Luma CSS and JavaScript (RequireJS, Knockout, jQuery) instead of Tailwind CSS and Alpine.js.

The `magento2-luma-checkout` convenience module has a Composer dependency on `magento2-theme-fallback` and automatically provides the required configuration so the Luma checkout works out of the box, without manually configuring the `magento2-theme-fallback` module.

## Configuring a Custom Fallback Theme

By default, the theme fallback module uses `frontend/Magento/luma` as the fallback theme. To use a different fallback theme, update the theme name in the store configuration.

Warning

The fallback theme must be a traditional Magento Blank or Luma-based theme. Luma-based checkouts require RequireJS, Knockout, jQuery, and Luma styles, so setting a Hyva theme as the fallback theme will not work.

Using a Luma-based checkout requires additional styling work to match the look and feel of the Hyva storefront theme.

Find more details in the [Luma Theme Fallback](../../hyva-themes/building-your-theme/luma-theme-fallback.html) documentation.

## Recommendation: Use Hyva Checkout for the Best Experience

While Luma-based checkouts work with Hyva Themes through the theme fallback module, [Hyva Checkout](../../index.html) delivers the best performance, compatibility, and user experience. Hyva Checkout is purpose-built for Hyva Themes and provides a modern, fast checkout without the overhead of loading the Luma frontend stack.
