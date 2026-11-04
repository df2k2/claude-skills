<!-- source: https://docs.hyva.io/hyva-commerce/features/admin-dashboard/installation.html -->

# Installing the Admin Dashboard

This guide covers installing the Hyvä Commerce Admin Dashboard module with Composer, both with a license key and via the Hyvä Commerce GitLab repositories for agency and technology partners. Once installed, the dashboard replaces the default Magento admin dashboard with configurable widgets.

## Installation

For prerequisites, see [Hyvä Commerce Installation Page](../../getting-started/index.html#hyva-commerce-prerequisites).

Installation via Hyvä Commerce Metapackage Recommended

The below steps are for installing Admin Dashboard only. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

1. Require the `hyva-themes/commerce-module-admin-dashboard` package:

   ```
   composer require hyva-themes/commerce-module-admin-dashboard
   ```
2. (Optional) Require the `hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget` package:

   ```
   composer require hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget
   ```
3. (Optional) Require the `hyva-themes/commerce-module-admin-dashboard-cms-widgets` package:

   ```
   composer require hyva-themes/commerce-module-admin-dashboard-cms-widgets
   ```
4. (Optional) Require the `hyva-themes/commerce-theme-adminhtml` package:

   ```
   composer require hyva-themes/commerce-theme-adminhtml
   ```
5. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```

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
3. Add the Admin Dashboard and base Hyvä Commerce module repositories to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-admin-dashboard-api git git@gitlab.hyva.io:hyva-themes/commerce-module-admin-dashboard-api.git
   composer config repositories.hyva-themes/commerce-module-admin-dashboard git git@gitlab.hyva.io:hyva-commerce/module-admin-dashboard.git
   ```
4. (Optional) Add the Admin Dashboard CrUX Widget, CMS Widgets, and Admin Theme repositories to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget git git@gitlab.hyva.io:hyva-commerce/module-admin-dashboard-google-crux-history-widget.git
   composer config repositories.hyva-themes/commerce-module-admin-dashboard-cms-widgets git git@gitlab.hyva.io:hyva-commerce/module-admin-dashboard-cms-widgets.git
   composer config repositories.hyva-themes/commerce-module-admin-theme git git@gitlab.hyva.io:hyva-commerce/module-admin-theme.git
   composer config repositories.hyva-themes/commerce-theme-adminhtml git git@gitlab.hyva.io:hyva-commerce/theme-adminhtml.git
   ```
5. Require the `hyva-themes/commerce-module-admin-dashboard` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-admin-dashboard:dev-main'
   ```
6. (Optional) Require the `hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget:dev-main'
   ```
7. (Optional) Require the `hyva-themes/commerce-module-admin-dashboard-cms-widgets` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-admin-dashboard-cms-widgets:dev-main'
   ```
8. (Optional) Require the `hyva-themes/commerce-theme-adminhtml` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-theme-adminhtml:dev-main'
   ```
9. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```

### Contract Package

`hyva-themes/commerce-module-admin-dashboard-api` is the stable widget contract package. It is installed transitively as a dependency of the dashboard module and does not need to be required explicitly. Custom widget modules should depend on it directly so they compile without the dashboard runtime; see the [Dashboard API](./devdocs/dashboard-api.html) reference.

### Admin Theme Recommended

While the default Magento/Adobe/Mage-OS admin themes are supported, we recommend installing the Hyvä Admin Theme for the best visual experience when using the Admin Dashboard.

## Additional Setup

No further steps are required. For more details on how to configure Admin Dashboard settings, see the [configuration guide](./system-configuration.html).
