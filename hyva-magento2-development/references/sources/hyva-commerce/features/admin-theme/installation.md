<!-- source: https://docs.hyva.io/hyva-commerce/features/admin-theme/installation.html -->

# Installing Admin Theme

## Prerequisites

See [Hyvä Commerce Prerequisites](../../getting-started/index.html#hyva-commerce-prerequisites).

## Installation

Installation via Hyvä Commerce Metapackage Recommended

The below steps are for installing Image Editor only. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

### With a License Key

1. Require the `hyva-themes/commerce-theme-adminhtml` package

   ```
   composer require hyva-themes/commerce-theme-adminhtml
   ```
2. Run `bin/magento setup:upgrade`
3. Make sure to clean your browser cache

### For Agency and Technology Partners

If you have access to the Hyvä Commerce GitLab repositories as Gold/Platinum Agency Partner, or a Technology Partner, you can install Hyvä Commerce in development environments using SSH key authentication.

You can configure the git repositories in your root composer.json and use the repositories directly as git repo's beneath your vendor directory. You can check out tags and branches, make commits and push contributions.

This installation method is not suited for deployments, because GitLab requires SSH key authorization.

1. Ensure your public SSH key is added to your account on gitlab.hyva.io.
2. Set minimum-stability to `dev` in the Magento composer.json

   ```
   composer config minimum-stability dev
   ```
3. Add the Image Editor and base Hyvä Commerce module repositories to the Magento `composer.json`

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-admin-theme git git@gitlab.hyva.io:hyva-commerce/module-admin-theme.git
   composer config repositories.hyva-themes/commerce-theme-adminhtml git git@gitlab.hyva.io:hyva-commerce/theme-adminhtml.git
   ```
4. Require the `hyva-themes/commerce-theme-adminhtml` packages using the `dev-main` branch version:

   ```
   composer require --prefer-source 'hyva-themes/commerce-theme-adminhtml:dev-main'
   ```
5. Run `bin/magento setup:upgrade`
6. Make sure to clean your browser cache

## Additional Setup

No further steps are required. After installation, the Hyvä Commerce Admin Theme will be enabled by default, unless the Mage-OS M137 Admin Theme was previously installed and configuration saved manually for the active theme.

For more details on how to configure the theme, see our [configuration guide](configuration.html).
