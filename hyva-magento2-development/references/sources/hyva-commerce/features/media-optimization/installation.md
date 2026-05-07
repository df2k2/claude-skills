<!-- source: https://docs.hyva.io/hyva-commerce/features/media-optimization/installation.html -->

# Installing Media Optimisation

## Prerequisites

See [Hyvä Commerce Prerequisites](../../getting-started/index.html#hyva-commerce-prerequisites).

Image Library Required

As with default Magento, Media Optimisation supports both the GD and Imagick image libraries, and at least one is required to be installed to utilise the functionality. Following installation, a [system check](configuration.html#system-check) tool is available in the configuration section of the Magento Admin panel that provides detailed diagnosis on the currently installed versions, and any limitations they may have.

## Installation

### With a License Key

1. Require the `hyva-themes/commerce-module-media-optimization` package

   ```
   composer require hyva-themes/commerce-module-media-optimization
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
3. Add the Media Optimisation and base Hyvä Commerce module repositories to the Magento `composer.json`

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-media-optimization git git@gitlab.hyva.io:hyva-commerce/module-media-optimization.git
   ```
4. Require the `hyva-themes/commerce-module-media-optimization` package

   ```
   composer require hyva-themes/commerce-module-media-optimization:dev-main
   ```
5. Run `bin/magento setup:upgrade`
6. Make sure to clean your browser cache

## Additional Setup

No further steps are required. For more details on how to configure Media Optimisation settings, see the [configuration guide](configuration.html).
