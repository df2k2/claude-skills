<!-- source: https://docs.hyva.io/hyva-checkout/getting-started/index.html -->

# Installation and Configuration for Hyvä Checkout

Hyvä Checkout is a stand-alone commercial product

A valid license is required.

## Hyvä Checkout Prerequisites

- Magento Open Source/Adobe Commerce `2.4.5`, `2.4.6`, `2.4.7`, `2.4.8` or higher (always use the latest patch version)
- A valid license for [Hyvä Commerce](https://www.hyva.io/hyva-commerce.html) or [Hyvä Checkout](https://www.hyva.io/hyva-checkout.html)
- For licensees: A Private Packagist Key
- For partners: Access to Hyvä Gitlab
- PHP `8.1`, `8.2`, `8.3`, `8.4`
- **Hyvä Themes `1.3.12` or newer**

CSP Support in Hyvä Checkout Version 1.3.0

Hyvä Checkout version `1.3.0` introduced a requirement for the CSP Nonce Provider.
Because of this, the Magento 2 versions listed above are now mandatory. For details, see the [Hyvä Checkout CSP documentation](../devdocs/csp/index.html).

The `1.3.x` release line is the primary release for new features and improvements. All code written from this point on is Alpine CSP-compliant.
If you can't update to these Magento versions, use Hyvä Checkout versions prior to `1.3.0`.

Hyvä Themes 1.3.12 or Newer Required

Hyvä Theme and the Hyvä Theme CSP variant are not added as Composer requirements to Hyvä Checkout, but installing a Hyvä Theme is still required before you can install and use Hyvä Checkout. You can find the Hyvä Theme installation instructions in the [Hyvä Themes Getting Started guide](https://docs.hyva.io/hyva-themes/getting-started/index.html#getting-started).

## Installing Hyvä Checkout with a License Key

1. Require the `hyva-themes/magento2-hyva-checkout` package:

   ```
   composer require hyva-themes/magento2-hyva-checkout
   ```
2. Disable Magento HTML minification in
   *Advanced > Developer > Template Settings > Minify Html*, or run:

   ```
   bin/magento config:set dev/template/minify_html 0
   ```

   This is only required if HTML minification is currently turned on (it is off by default).

   HTML minification can be enabled since v1.1.6, even though we still recommend keeping it disabled.

   Experimental: On-the-fly minification

   The `hyva-themes/magento2-minification` module minifies HTML, JS, and CSS on the fly with better results than the native Magento minification, rather than during static content deployment. It is currently experimental but can be tested already. For more information, see the module readme.
3. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
4. Run Tailwind to generate storefront styles. Replace the path below with the path to your theme's `web/tailwind` folder:

   ```
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
   ```

## Installing Hyvä Checkout as an Agency or Technology Partner

If you have access to the Hyvä Checkout GitLab repositories as a **Gold/Platinum** Agency Partner or a Technology Partner, you can install Hyvä Checkout in development environments using SSH key authentication.

You can configure the Git repositories in your root `composer.json` and use them directly as Git repos beneath your vendor directory. This lets you check out tags and branches, make commits, and push contributions.

Development Environments Only

This installation method is not suited for deployments, because GitLab requires SSH key authorization and project structure changes could break production deployments.

1. Make sure your public SSH key is added to your account on `gitlab.hyva.io`.
2. Set minimum-stability to dev in the Magento `composer.json`:

   ```
   composer config minimum-stability dev
   ```
3. Add the Hyvä Checkout repository to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/hyva-checkout git git@gitlab.hyva.io:hyva-checkout/checkout.git
   ```
4. Require the `hyva-themes/magento2-hyva-checkout` package using the dev-main branch:

   ```
   composer require --prefer-source 'hyva-themes/magento2-hyva-checkout:dev-main'
   ```
5. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
6. Run Tailwind to generate storefront styles. Replace the path below with the path to your theme's `web/tailwind` folder:

   ```
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
   ```

## Hyvä Checkout Admin Configuration

The Hyvä Checkout admin configuration is found at
*Stores > Configuration > Hyvä Themes > Checkout*.

### Enabling Hyvä Checkout (Opt-in)

In the General section, the "Checkout" setting defaults to "Magento Luma (original)".
To use Hyvä Checkout, change the selection to "Hyvä Default" and save the configuration.

If you create custom checkouts based on Hyvä Checkout, they will also appear as options in this dropdown.

### Hyvä Checkout Mobile Configuration

If the **optional** "Mobile" checkout is enabled in the Hyvä Checkout system configuration, Hyvä Checkout uses it when a visitor's user agent matches a known mobile device.

This lets you present a different checkout experience optimized for mobile use.
For example, a multi-step checkout can provide a better customer experience on a phone, while a one-page checkout works better for desktop visitors.

The regular expression for matching mobile user agents can be customized in the
*"Hyvä Themes > Checkout > Developer"* section.

Flush the cache after changing any Hyvä Checkout configuration setting.
