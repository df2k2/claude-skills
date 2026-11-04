<!-- source: https://docs.hyva.io/hyva-commerce/features/media-optimization/installation.html -->

# Installing Media Optimization

This guide covers installing Media Optimization with Composer, both with a license key and via the Hyvä Commerce GitLab repositories for agency and technology partners.

## Installation

For prerequisites, see [Hyvä Commerce Installation Page](../../getting-started/index.html#hyva-commerce-prerequisites).

Installation via Hyvä Commerce Metapackage Recommended

The below steps are for installing Media Optimization only. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

1. Make sure at least one supported image library is installed. Like default Magento, Media Optimization works with both GD and Imagick, and requires at least one to be present.
2. Require the `hyva-themes/commerce-module-media-optimization` package:

   ```
   composer require hyva-themes/commerce-module-media-optimization
   ```
3. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
4. Clear your browser cache.
5. In the Magento admin, open the [System Check](configuration.html#system-check) tool to confirm the installed image libraries and any limitations they may have.

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
3. Add the Media Optimization and base Hyvä Commerce module repositories to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-media-optimization git git@gitlab.hyva.io:hyva-commerce/module-media-optimization.git
   ```
4. Require the `hyva-themes/commerce-module-media-optimization` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-media-optimization:dev-main'
   ```
5. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
6. Clear your browser cache.

## Additional Setup

No further setup steps are required. To tune image formats, engines, and replacement behavior, see [Configuration](configuration.html).
