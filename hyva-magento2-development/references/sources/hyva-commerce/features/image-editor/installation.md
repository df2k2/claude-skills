<!-- source: https://docs.hyva.io/hyva-commerce/features/image-editor/installation.html -->

# Installing Image Editor

This guide covers installing Image Editor with Composer, both with a license key and via the Hyvä Commerce GitLab repositories for agency and technology partners.

## Installation

For prerequisites, see [Hyvä Commerce Installation Page](../../getting-started/index.html#hyva-commerce-prerequisites).

Installation via Hyvä Commerce Metapackage Recommended

The below steps are for installing Image Editor only. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

1. Require the `hyva-themes/commerce-module-image-editor` package:

   ```
   composer require hyva-themes/commerce-module-image-editor
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
3. Add the Image Editor and base Hyvä Commerce module repositories to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-image-editor git git@gitlab.hyva.io:hyva-commerce/module-image-editor.git
   ```
4. Require the `hyva-themes/commerce-module-image-editor` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-image-editor:dev-main'
   ```
5. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
6. Clear your browser cache.

## Additional Setup

### Enable 'New' Media Gallery

The Image Editor only supports editing images when using the 'New' Media Gallery. Enabling the 'New' Media Gallery can be [configured in the admin panel](https://experienceleague.adobe.com/en/docs/commerce-admin/content-design/wysiwyg/gallery/media-gallery#enable-the-new-media-gallery). This is also a requirement for [Hyvä CMS](../cms/index.html).

### Further Configuration

Large edited images can exceed the default upload limits of your web server and PHP. If saving large images fails, see [Server Upload Limits](server-upload-limits.html).

For image quality and compression settings, see [Configuration](configuration.html).
