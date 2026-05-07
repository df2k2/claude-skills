<!-- source: https://docs.hyva.io/hyva-commerce/features/menu-builder/installation.html -->

# Installing Menu Builder

Currently available in beta

Menu Builder is currently available in beta, which means some of the features, specifications, and details provided herein are subject to change. We recommend checking back regularly for the most up-to-date information and viewing our [roadmap](https://www.hyva.io/roadmap) in regard to the general availability release.

## Prerequisites

See [Hyvä Commerce Prerequisites](../../getting-started/index.html#hyva-commerce-prerequisites).

## Installation

Separate Installation Required

During the beta phase of a new feature, new packages are not included in the main Hyvä Commerce metapackage and must be installed separately. The Hyvä Commerce [metapackage](../../getting-started/index.html) can also be installed, but is not required.

### With a License Key

1. Require the `hyva-themes/commerce-module-menu-builder` package

   ```
   composer require hyva-themes/commerce-module-menu-builder
   ```
2. Run `bin/magento setup:upgrade`
3. Make sure to clean your browser cache

### For Agency and Technology Partners

If you have access to the Hyvä Commerce GitLab repositories as Gold/Platinum Agency Partner, or a Technology Partner, you can install Hyvä Commerce in development environments using SSH key authentication.

You can configure the git repositories in your root `composer.json` and use the repositories directly as git repos beneath your vendor directory. You can check out tags and branches, make commits and push contributions.

This installation method is not suited for deployments, because GitLab requires SSH key authorization.

1. Ensure your public SSH key is added to your account on gitlab.hyva.io.
2. Set minimum-stability to `dev` in the Magento composer.json

   ```
   composer config minimum-stability dev
   ```
3. Add the Menu Builder and base Hyvä Commerce module repositories to the Magento `composer.json`

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-menu-builder git git@gitlab.hyva.io:hyva-commerce/module-menu-builder.git
   ```
4. Require the `hyva-themes/commerce-module-menu-builder` package

   ```
   composer require hyva-themes/commerce-module-menu-builder:dev-main
   ```
5. Run `bin/magento setup:upgrade`
6. Make sure to clean your browser cache

## Additional Setup

No further steps are required. For more details on how to configure Menu Builder settings, see the [configuration guide](configuration.html).
