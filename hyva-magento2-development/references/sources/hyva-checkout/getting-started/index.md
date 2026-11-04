<!-- source: https://docs.hyva.io/hyva-checkout/getting-started/index.html -->

# Installation and Configuration for Hyvä Checkout

Hyvä Checkout is a stand-alone commercial product

A valid license is required.

## Hyvä Checkout Prerequisites

Hyvä Checkout has two release lines with slightly different requirements: Checkout 3.x (the current line, running on Magewire 3) and Checkout 1.x (the previous line, running on Magewire 1). See [Release Lines and Magewire Versions](release-lines.html).

These requirements apply to both release lines:

- A valid license for;
  - [Hyvä Checkout](https://www.hyva.io/hyva-checkout.html)
  - [Hyvä Commerce](https://www.hyva.io/hyva-commerce.html)
  - [Hyvä Enterprise](https://www.hyva.io/hyva-enterprise.html)
- **A Hyvä theme using Tailwind CSS 3 or 4**, with the Hyvä Theme module (`hyva-themes/magento2-theme-module`) `1.3.16` or newer

The Magento and PHP versions depend on the release line:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

- Magento Open Source/Adobe Commerce `2.4.6`, `2.4.7`, `2.4.8`, `2.4.9` or higher (always use the latest patch version)
- PHP `8.2`, `8.3`, `8.4`, `8.5`

Hyvä Enterprise projects need the releases of the Hyvä Enterprise checkout modules that support Checkout 3, for `hyva-themes/magento2-ee-hyva-enterprise-checkout` and, where used, `hyva-themes/magento2-ee-hyva-enterprise-checkout-b2b`. Earlier releases of these modules require Checkout 1.x. See [Release Lines and Magewire Versions](release-lines.html#running-a-store-on-checkout-3x).

PHP 8.1 support ends in 2027

From 2027 onwards, Hyvä products will be built with PHP `8.2` and newer code. Existing installations on PHP `8.1` won't break right away, but PHP `8.1` will no longer be supported from then. Plan your upgrade to PHP `8.2` or higher.

This also affects Magento versions that only run on PHP `8.1`: Magento `2.4.4` and `2.4.5` (including all their patch releases) will no longer be supported from 2027. Upgrade to Magento `2.4.6` or higher, always using the latest patch release (for example `2.4.6-p15`).

- Magento Open Source/Adobe Commerce `2.4.5`, `2.4.6`, `2.4.7`, `2.4.8`, `2.4.9` or higher (always use the latest patch version)
- PHP `8.1`, `8.2`, `8.3`, `8.4`, `8.5`

CSP Support in Hyvä Checkout Version 1.3.0

Hyvä Checkout version `1.3.0` introduced a requirement for the CSP Nonce Provider.
Because of this, the Magento 2 versions listed above are now mandatory. For details, see the [Hyvä Checkout CSP documentation](../devdocs/csp/index.html).

All Hyvä Checkout code from `1.3.0` onwards, including Checkout 3.x, is Alpine CSP-compliant.
If you can't update to these Magento versions, use Hyvä Checkout versions prior to `1.3.0`.


Install a Hyvä theme before Hyvä Checkout

Hyvä Checkout needs two Hyvä packages, but Composer only installs one of them for you:

- **The Hyvä Theme module** (`hyva-themes/magento2-theme-module`) provides the PHP code that Hyvä themes are built on, such as view models and helpers. Hyvä Checkout requires it, so Composer installs it automatically.
- **A Hyvä theme**, such as the Hyvä Default theme (`hyva-themes/magento2-default-theme`), provides the storefront templates and styles that the checkout renders in. Hyvä Checkout doesn't require a specific theme package, because you can use the Hyvä Default theme, the CSP variant or your own child theme. So Composer doesn't install one, and you need to install a Hyvä theme yourself.

Follow the [Hyvä Themes Getting Started guide](https://docs.hyva.io/hyva-themes/getting-started/index.html#getting-started) to install a Hyvä theme. The rest of your store doesn't have to use it: to keep Luma for all other pages and use a Hyvä theme only for the checkout, see [Does Hyvä Checkout Require a Hyvä Theme?](../faq/hyva-theme-requirement.html).

## Installing Hyvä Checkout with a License Key

1. Require the `hyva-themes/magento2-hyva-checkout` package for your release line:

   Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

   ```
   composer require 'hyva-themes/magento2-hyva-checkout:^3.0'
   ```

   Composer also installs Magewire 3 and the [v1bc module](../faq/what-is-v1bc.html), which keeps components and integrations written for Checkout 1.x working.

   ```
   composer require 'hyva-themes/magento2-hyva-checkout:^1.3'
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
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci --ignore-scripts
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
   ```

## Installing Hyvä Checkout as an Agency or Technology Partner

If you have access to the Hyvä Checkout GitLab repositories as a **Gold/Platinum** Agency Partner or a Technology Partner, you can install Hyvä Checkout in development environments using SSH key authentication.

You can configure the Git repositories in your root `composer.json` and use them directly as Git repos beneath your vendor directory. This lets you check out tags and branches, make commits, and push contributions.

Development Environments Only

This installation method is not suited for deployments, because GitLab requires SSH key authorization and project structure changes could break production deployments.

Installation Steps

1. Make sure your public SSH key is added to your account on `gitlab.hyva.io`.
2. Set minimum-stability to dev in the Magento `composer.json`:

   ```
   composer config minimum-stability dev
   ```
3. Add the Hyvä Checkout repository to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/hyva-checkout git git@gitlab.hyva.io:hyva-checkout/checkout.git
   ```
4. Require the `hyva-themes/magento2-hyva-checkout` package using the development branch of your release line:

   Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

   Checkout 3.x requires the [v1bc module](../magewire/v1bc.html), and each of the two packages requires a release version of the other, so add the v1bc repository too and give both branches a version alias:

   ```
   composer config repositories.hyva-themes/hyva-checkout-v1bc git git@gitlab.hyva.io:hyva-checkout/checkout-v1bc.git
   composer require --no-update 'hyva-themes/magento2-hyva-checkout:dev-3.0.x-main as 3.0.99' 'hyva-themes/magento2-hyva-checkout-v1bc:dev-main as 1.0.99'
   composer update --prefer-source --with-dependencies hyva-themes/magento2-hyva-checkout hyva-themes/magento2-hyva-checkout-v1bc
   ```

   ```
   composer require --prefer-source 'hyva-themes/magento2-hyva-checkout:dev-1.3.x-main'
   ```
5. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
6. Run Tailwind to generate storefront styles. Replace the path below with the path to your theme's `web/tailwind` folder:

   ```
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci --ignore-scripts
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
