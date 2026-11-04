<!-- source: https://docs.hyva.io/hyva-commerce/features/menu-builder/installation.html -->

# Installing Menu Builder

Menu Builder is generally available since `1.0.0` with Hyvä Commerce `1.3.0` and requires Hyvä CMS `1.2.0`. Menu Builder `1.1.0` ships with Hyvä Commerce `1.4.0` and requires Hyvä CMS `1.3.0`.

This guide covers installing Menu Builder with Composer, both with a license key and via the Hyvä Commerce GitLab repositories for agency and technology partners.

## Installation

For prerequisites, see [Hyvä Commerce Installation Page](../../getting-started/index.html#hyva-commerce-prerequisites).

Menu Builder needs a matching Hyvä CMS version:

| Menu Builder | Hyvä CMS |
| --- | --- |
| `1.0.x` | `1.2.0` or later |
| `1.1.0` | `1.3.0` or later |

Installation via Hyvä Commerce Metapackage Recommended

The below steps are for installing Menu Builder only. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

1. Require the `hyva-themes/commerce-module-menu-builder` package:

   ```
   composer require hyva-themes/commerce-module-menu-builder
   ```
2. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
3. Clear your browser cache.

### For Agency and Technology Partners

If you have access to the Hyvä Commerce GitLab repositories as a Gold/Platinum Agency Partner or a Technology Partner, you can install Hyvä Commerce in development environments using SSH key authentication.

You can configure the Git repositories in your root `composer.json` and use them directly as Git repos beneath your vendor directory. This lets you check out tags and branches, make commits, and push contributions.

Development Environments Only

This installation method is not suited for deployments, because GitLab requires SSH key authorization and project changes can break production deployments.

Installation Steps

1. Make sure your public SSH key is added to your account on `gitlab.hyva.io`.
2. Set minimum-stability to `dev` in the Magento `composer.json`:

   ```
   composer config minimum-stability dev
   ```
3. Add the Menu Builder and base Hyvä Commerce module repositories to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-menu-builder git git@gitlab.hyva.io:hyva-commerce/module-menu-builder.git
   ```
4. Require the `hyva-themes/commerce-module-menu-builder` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-menu-builder:dev-main'
   ```
5. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
6. Clear your browser cache.

## Additional Setup

No further setup steps are required. To learn how to create and render menus, see [Creating Menus](creating-menus.html).
