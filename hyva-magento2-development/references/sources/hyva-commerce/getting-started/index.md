<!-- source: https://docs.hyva.io/hyva-commerce/getting-started/index.html -->

# Installation and Configuration of Hyvä Commerce

## Hyvä Commerce Install Options

There are two main ways to install and use Hyvä Commerce:

1. Install all available features via the **Hyvä Commerce metapackage**
2. Install just the individual modules, themes, or other packages you need

Metapackage Recommendation

We recommend the metapackage approach. It gives you all the best features, many of which work even better together. We also define and test the specific versions included in each release against one another, so you get a more reliable experience. You can still disable unused features at module or configuration level.

## Hyvä Commerce Prerequisites

- A [Hyvä Commerce license](https://www.hyva.io/hyva-commerce.html) (Private Packagist key) or a GitLab account with Hyvä Commerce Agency (Platinum/Gold) or Technology Partner access
- [Hyvä Default Theme](../../hyva-themes/getting-started/index.html) 1.3.0 or later (or a cloned/child theme based on 1.3.0 or later)
- [Hyvä Theme Module](../../hyva-themes/upgrading/upgrading-to-1-3-15.html) 1.3.15 or later
- Magento Open Source or Adobe Commerce 2.4.4 or later (both Cloud and On-Premise are supported)
- PHP 8.1 or later

Hyvä Checkout

[Hyvä Checkout](../../hyva-checkout/getting-started/index.html) is not a required prerequisite, but if your project uses Hyvä Checkout, install it alongside Hyvä Theme before installing Hyvä Commerce.

Adobe Commerce Feature Support

A [Hyvä Enterprise license](https://www.hyva.io/hyva-enterprise.md) is still required for Adobe Commerce, B2B, and additional services feature compatibility.

Mage-OS Compatibility

Installing Hyvä Commerce on [Mage-OS](https://mage-os.org/) should work just as well as Magento Open Source, but we don't include Mage-OS in our internal testing at this time. If you find any issues specifically related to running Hyvä Commerce on Mage-OS, let us know on the `#hyva-commerce` [Slack](https://www.hyva.io/slack) channel.

## Installing Hyvä Commerce with a License Key

Metapackage vs. Individual Features

The instructions below install all features via the Hyvä Commerce metapackage. To install individual features instead, see the relevant feature's installation page under the Features section.

1. Require the `hyva-themes/commerce` package:

   ```
   composer require hyva-themes/commerce
   ```
2. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
3. Run Tailwind to generate storefront styles. Replace the path below with the path to your theme's `web/tailwind` folder:

```
bin/magento hyva:config:generate
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
```

## Installing Hyvä Commerce as an Agency or Technology Partner

If you have access to the Hyvä Commerce GitLab repositories as a Gold/Platinum Agency Partner or a Technology Partner, you can install Hyvä Commerce in development environments using SSH key authentication.

You can configure the Git repositories in your root `composer.json` and use them directly as Git repos beneath your vendor directory. This lets you check out tags and branches, make commits, and push contributions.

Development Environments Only

This installation method is not suited for deployments, because GitLab requires SSH key authorization and project changes can break production deployments.

1. Make sure your public SSH key is added to your account on `gitlab.hyva.io`.
2. Set minimum-stability to `dev` in the Magento `composer.json`:

```
composer config minimum-stability dev
```

1. Add the Hyvä Commerce repositories to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/commerce git git@gitlab.hyva.io:hyva-commerce/metapackage-commerce.git
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-admin-theme git git@gitlab.hyva.io:hyva-commerce/module-admin-theme.git
   composer config repositories.hyva-themes/theme-adminhtml git git@gitlab.hyva.io:hyva-commerce/theme-adminhtml.git

   composer config repositories.hyva-themes/commerce-module-admin-dashboard git git@gitlab.hyva.io:hyva-commerce/module-admin-dashboard.git
   composer config repositories.hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget git git@gitlab.hyva.io:hyva-commerce/module-admin-dashboard-google-crux-history-widget.git

   composer config repositories.hyva-themes/commerce-module-cms git git@gitlab.hyva.io:hyva-commerce/module-cms.git
   composer config repositories.hyva-themes/commerce-module-cms-ai-translations git git@gitlab.hyva.io:hyva-commerce/module-cms-ai-translations.git
   composer config repositories.hyva-themes/magento2-cms-tailwind-jit git git@gitlab.hyva.io:hyva-themes/magento2-cms-tailwind-jit.git

   composer config repositories.hyva-themes/commerce-module-image-editor git git@gitlab.hyva.io:hyva-commerce/module-image-editor.git
   composer config repositories.hyva-themes/commerce-module-media-optimization git git@gitlab.hyva.io:hyva-commerce/module-media-optimization.git

   composer config repositories.hyva-themes/magento2-ai-providers git git@gitlab.hyva.io:hyva-themes/ai/metapackage-ai-providers.git
   composer config repositories.hyva-themes/magento2-module-ai git git@gitlab.hyva.io:hyva-themes/ai/module-ai.git
   composer config repositories.hyva-themes/magento2-module-ai-deep-l git git@gitlab.hyva.io:hyva-themes/ai/module-ai-deep-l.git
   composer config repositories.hyva-themes/magento2-module-ai-gemini git git@gitlab.hyva.io:hyva-themes/ai/module-ai-gemini.git
   composer config repositories.hyva-themes/magento2-module-ai-open-ai git git@gitlab.hyva.io:hyva-themes/ai/module-ai-open-ai.git
   ```
2. Require the `hyva-themes/commerce` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce:dev-main'
   ```
3. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
4. Run Tailwind to generate storefront styles. Replace the path below with the path to your theme's `web/tailwind` folder:

```
bin/magento hyva:config:generate
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
```

## Additional Setup for Hyvä Commerce

- Make sure the ['New' Media Gallery is enabled in configuration](https://experienceleague.adobe.com/en/docs/commerce-admin/content-design/wysiwyg/gallery/media-gallery#enable-the-new-media-gallery). Both [Hyvä CMS](../features/cms/index.html) and [Image Editor](../features/image-editor/index.html) require it for handling image selection and editing.
- For stores with multiple domains or a custom admin domain, see the [Hyvä CMS multi-store domain setup instructions](../features/cms/installation.html#multi-store-domain-custom-admin-domain-setup).

For more detailed and optional configuration steps, see each feature's installation page:

- [Admin Theme installation](../features/admin-theme/installation.html#additional-setup)
- [Hyvä CMS installation](../features/cms/installation.html#additional-setup)
- [Image Editor installation](../features/image-editor/installation.html#additional-setup)
