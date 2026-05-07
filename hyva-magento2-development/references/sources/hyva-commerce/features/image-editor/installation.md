<!-- source: https://docs.hyva.io/hyva-commerce/features/image-editor/installation.html -->

# Installing Image Editor

## Prerequisites

See [Hyvä Commerce Prerequisites](../../getting-started/index.html#hyva-commerce-prerequisites).

## Installation

Installation via Hyvä Commerce Metapackage Recommended

The below steps are for installing Image Editor only. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

### With a License Key

1. Require the `hyva-themes/commerce-module-image-editor` package

   ```
   composer require hyva-themes/commerce-module-image-editor
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
   composer config repositories.hyva-themes/commerce-module-image-editor git git@gitlab.hyva.io:hyva-commerce/module-image-editor.git
   ```
4. Require the `hyva-themes/commerce-module-image-editor` packages using the `dev-main` branch version:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-image-editor:dev-main'
   ```
5. Run `bin/magento setup:upgrade`
6. Make sure to clean your browser cache

## Additional Setup

### Enable 'New' Media Gallery

The Image Editor only supports editing images when using the 'New' Media Gallery. Enabling the 'New' Media Gallery can be [configured in the admin panel](https://experienceleague.adobe.com/en/docs/commerce-admin/content-design/wysiwyg/gallery/media-gallery#enable-the-new-media-gallery). This is also a requirement for [Hyvä CMS](../cms/index.html).

### Image Quality

High-quality images, especially in a lossless format such as `png`, can be a challenge for your website configuration setup. By default, Nginx will not allow files over 1 MB. We recommend bumping this up so you have enough margin. Be aware that image file size can increase after editing.

To increase the limit to 100 MB in `nginx.conf` file:

```
client_max_body_size 100M;
```

> The equivalent Apache setting is `LimitRequestBody`, but is set as 0 (unlimited) by default.

Limit to required routes only

This setting only affects the below admin routes. Consider limiting the above setting to these locations only in your [Nginx](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) or [Apache](https://httpd.apache.org/docs/2.4/mod/core.html#location) config:

- `/hyva_image_editor/image/save`
- `/hyva_image_editor/image/duplicate`

To increase the limit to 100 MB in `php.ini` file:

```
post_max_size=100M
upload_max_filesize=100M
```

Limit to admin scope

Where possible, e.g. if using a different `php.ini` file for admin requests, consider limiting the above changes to the admin area only (i.e. not the frontend)

### Further Configuration Options

Further options available are outlined on our [configuration page](configuration.html).
