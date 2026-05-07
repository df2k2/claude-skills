<!-- source: https://docs.hyva.io/hyva-themes/getting-started/index.html -->

# Getting Started with Hyvä Theme

This guide walks you through installing the Hyvä Theme on a Magento 2 store. It covers system requirements, composer installation, theme activation, and essential post-install configuration.

## Hyvä Theme System Requirements

Before installing the Hyvä Theme, make sure your environment meets these minimum requirements:

- Magento `2.4.4-p9`, `2.4.5-p8`, `2.4.6-p7`, `2.4.7-p1` or higher
- A Hyvä packagist.com key (free - see [Installation](#installing-hyva-theme-with-composer) below)
- PHP `8.1`, `8.2`, `8.3` or `8.4`

Node.js and Tailwind CSS Requirements

The Hyvä Theme uses Tailwind CSS, which requires Node.js >= 20.0.0 on development instances to run the Tailwind compiler.
We recommend building the Tailwind CSS bundle on a development or staging instance, not on production.

Full Magento system requirements are available in the [Magento devdocs](https://experienceleague.adobe.com/en/docs/commerce-operations/installation-guide/system-requirements).

Hyvä no longer supports PHP 7.4

As of 2026, Hyvä requires PHP `8.1` or higher. If you're still on PHP `7.4`, upgrade before installing or updating the Hyvä Theme.

CSP support requires Magento 2.4.4 or higher

Hyvä release 1.3.11 introduced a requirement for the CSP Nonce Provider, which is only available since Magento 2.4.4.
Older Magento 2 versions are no longer supported.
If you cannot update to one of the supported Magento versions, use a Hyvä version prior to 1.3.11.

## Installing Hyvä Theme with Composer

The Hyvä Theme is distributed through a private Packagist repository. You need a free Hyvä packagist.com key to install the Hyvä Theme packages.

Get your key by registering an account at [hyva.io](https://hyva.io) and creating one from your account dashboard.

After creating your key, configure your Magento project's Composer authentication and repository:

```
# Add your Hyvä packagist key to your project's auth.json
# Replace yourLicenseAuthentificationKey with your actual key
composer config --auth http-basic.hyva-themes.repo.packagist.com token yourLicenseAuthentificationKey

# Add the Hyvä private Packagist repository
# Replace yourProjectName with your project name
composer config repositories.private-packagist composer https://hyva-themes.repo.packagist.com/yourProjectName/
```

Once authentication is configured, install the Hyvä default theme and all its dependencies:

```
composer require hyva-themes/magento2-default-theme
```

Then run the Magento setup upgrade to register the new modules:

```
bin/magento setup:upgrade
```

## Activating the Hyvä Theme in Magento Admin

After installation, activate the Hyvä Theme by navigating to `Content > Design > Configuration` in the Magento admin panel and selecting the `hyva/default` theme.

Always set a theme on the Website level

Setting `hyva/default` only on a store view while keeping the Website and Store set to `-- No Theme --` will cause storefront issues.
If you set the Hyvä Theme at a Store or Store View level, also set a theme on the Website level.
It does not matter which theme you set on the Website - it could be Luma, Hyvä, or any other theme - as long as one is set.

## Verifying the Hyvä Theme Installation by Deploy Mode

How you verify the Hyvä Theme installation depends on your Magento deploy mode:

- In `developer` mode, you should see the Hyvä Theme on the frontend right away. A `bin/magento cache:flush` might be needed.
- In `production` mode, run `bin/magento setup:static-content:deploy` before the theme will appear.
- In `default` mode, you must manually enable each new module with `bin/magento module:enable`. That said, never run a Magento store in `default` mode.

## Disabling the Default Magento Captcha

Hyvä does not support the legacy Magento captcha implementation, which is enabled by default in Magento. You need to disable it for forms to work correctly.

What about ReCaptcha?

Hyvä supports three Google ReCaptcha versions provided by Magento:
**ReCaptcha V3 invisible, V2 invisible, and V2 "I'm not a robot"**.
Use one of these instead of the legacy captcha.

Disable the default Magento captcha with this command:

```
bin/magento config:set customer/captcha/enable 0
```

## Disabling Built-in Minification and Bundling for Hyvä

Magento's built-in minification and bundling of HTML, CSS, and JS do not benefit Hyvä sites. These settings can actually cause overhead and unwanted side effects. We recommend turning them off for any store view running the Hyvä Theme.

```
bin/magento config:set dev/template/minify_html 0
bin/magento config:set dev/js/merge_files 0
bin/magento config:set dev/js/enable_js_bundling 0
bin/magento config:set dev/js/minify_files 0
bin/magento config:set dev/js/move_script_to_bottom 0
bin/magento config:set dev/css/merge_css_files 0
bin/magento config:set dev/css/minify_files 0
```

Keep minification enabled for Luma store views

If your Magento installation also runs Luma-based themes on other store views, keep these settings enabled for those store views.
See the FAQ on [setup:static-content:deploy fails minifying CSS](../faqs/static-content-deploy-fails-with-css-error.html) if you encounter CSS-related issues.

Experimental: On-the-fly JS minification and merging

The `hyva-themes/magento2-minification` module minifies HTML, JS, and CSS on the fly with better results than the native Magento minification, rather than during static content deployment. It is currently experimental but can be tested already. For more information, see the module readme.

## Enabling Required GraphQL Modules for Hyvä

Hyvä uses parts of the Magento GraphQL API, so certain GraphQL modules must be enabled. By default, all Magento GraphQL modules are enabled on a fresh install, but stores that previously used the Luma theme often have unused GraphQL modules disabled.

The following Magento GraphQL modules are required by the Hyvä Theme:

| Module | Composer Package |
| --- | --- |
| Magento\_BundleGraphQl | magento/module-bundle-graph-ql |
| Magento\_CatalogCustomerGraphQl | magento/module-catalog-customer-graph-ql |
| Magento\_CatalogGraphQl | magento/module-catalog-graph-ql |
| Magento\_CatalogRuleGraphQl | magento/module-catalog-rule-graph-ql |
| Magento\_CatalogUrlRewriteGraphQl | magento/module-catalog-url-rewrite-graph-ql |
| Magento\_ConfigurableProductGraphQl | magento/module-configurable-product-graph-ql |
| Magento\_CustomerGraphQl | magento/module-customer-graph-ql |
| Magento\_DirectoryGraphQl | magento/module-directory-graph-ql |
| Magento\_DownloadableGraphQl | magento/module-downloadable-graph-ql |
| Magento\_EavGraphQl | magento/module-eav-graph-ql |
| Magento\_GraphQl | magento/module-graph-ql |
| Magento\_GroupedProductGraphQl | magento/module-grouped-product-graph-ql |
| Magento\_QuoteGraphQl | magento/module-quote-graph-ql |
| Magento\_GraphQlCache | magento/module-graph-ql-cache |
| Magento\_RelatedProductGraphQl | magento/module-related-product-graph-ql |
| Magento\_ReviewGraphQl | magento/module-review-graph-ql |
| Magento\_SalesGraphQl | magento/module-sales-graph-ql |
| Magento\_StoreGraphQl | magento/module-store-graph-ql |
| Magento\_SwatchesGraphQl | magento/module-swatches-graph-ql |
| Magento\_UrlRewriteGraphQl | magento/module-url-rewrite-graph-ql |
| Magento\_WishlistGraphQl | magento/module-wishlist-graph-ql |

Are all GraphQL modules required?

Not always. Which GraphQL modules are required depends on which Hyvä features your store uses. For example, if Recently Viewed Products are not enabled, the `Magento_CatalogGraphQl` module is not required.

How to check which GraphQL modules are enabled

Run the following command to check the status of all Hyvä-related GraphQL modules:

```
bin/magento module:status Magento_BundleGraphQl Magento_CatalogCustomerGraphQl Magento_CatalogGraphQl Magento_CatalogRuleGraphQl Magento_CatalogUrlRewriteGraphQl Magento_ConfigurableProductGraphQl Magento_CustomerGraphQl Magento_DirectoryGraphQl Magento_DownloadableGraphQl Magento_EavGraphQl Magento_GraphQl Magento_GroupedProductGraphQl Magento_QuoteGraphQl Magento_GraphQlCache Magento_RelatedProductGraphQl Magento_ReviewGraphQl Magento_SalesGraphQl Magento_StoreGraphQl Magento_SwatchesGraphQl Magento_UrlRewriteGraphQl Magento_WishlistGraphQl
```

Each module should show `Module is enabled` in the output.

## Installing Hyvä from GitLab for Contributors and Technology Partners

Technology and contributing partners have direct access to Hyvä source repositories at [gitlab.hyva.io](https://gitlab.hyva.io). This section covers installing the Hyvä Theme directly from GitLab instead of Packagist.

GitLab repositories can be configured in your Magento project's `composer.json` as Composer repositories. This allows checking out tags and branches, and pushing contributions back to [gitlab.hyva.io](https://gitlab.hyva.io).

SSH key setup for GitLab access

Ensure your SSH key is set in your Hyvä GitLab account, as well as on [github.com](https://github.com). If you use Docker, verify that your SSH key is available inside the container running Composer.

To configure and install the Hyvä Theme directly from GitLab, run these Composer commands:

```
# Configure GitLab repositories for all Hyvä packages
composer config repositories.hyva-themes/magento2-theme-module git git@gitlab.hyva.io:hyva-themes/magento2-theme-module.git
composer config repositories.hyva-themes/magento2-base-layout-reset git git@gitlab.hyva.io:hyva-themes/magento2-base-layout-reset.git
composer config repositories.hyva-themes/magento2-email-module git git@gitlab.hyva.io:hyva-themes/magento2-email-module.git
composer config repositories.hyva-themes/magento2-default-theme git git@gitlab.hyva.io:hyva-themes/magento2-default-theme.git
composer config repositories.hyva-themes/magento2-order-cancellation-webapi git git@gitlab.hyva.io:hyva-themes/magento2-order-cancellation-webapi.git
composer config repositories.hyva-themes/magento2-compat-module-fallback git git@gitlab.hyva.io:hyva-themes/magento2-compat-module-fallback.git
composer config repositories.hyva-themes/magento2-mollie-theme-bundle git git@gitlab.hyva.io:hyva-themes/hyva-compat/magento2-mollie-theme-bundle.git

# Install with --prefer-source so you can push contributions back
composer require hyva-themes/magento2-default-theme --prefer-source
```

After installation, run `bin/magento setup:upgrade`, then follow the same [theme activation](#activating-the-hyva-theme-in-magento-admin) and [post-install configuration](#disabling-the-default-magento-captcha) steps described above.

Do not use SSH-key authentication in CI/CD pipelines

GitLab availability is not guaranteed. Always use packagist.com for build pipelines and production deployments.

## Related Topics

- [Building your Hyvä Child Theme](../building-your-theme/index.html) - Create and customize your own theme based on the Hyvä default theme
- [Hyvä Theme FAQs](../faqs/static-content-deploy-fails-with-css-error.html) - Common issues and troubleshooting
