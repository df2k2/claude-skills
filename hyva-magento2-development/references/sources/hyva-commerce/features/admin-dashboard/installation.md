<!-- source: https://docs.hyva.io/hyva-commerce/features/admin-dashboard/installation.html -->

# Installing Admin Dashboard

## Prerequisites

See [Hyvä Commerce Prerequisites](../../getting-started/index.html#hyva-commerce-prerequisites).

## Installation

### With a License Key

1. Require the `hyva-themes/commerce-module-admin-dashboard` package

   ```
   composer require hyva-themes/commerce-module-admin-dashboard
   ```
2. (optional) Require the `hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget` package

   ```
   composer require hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget
   ```
3. (optional)\* Require the `hyva-themes/commerce-theme-adminhtml` package

   ```
   composer require hyva-themes/commerce-theme-adminhtml
   ```
4. Run `bin/magento setup:upgrade`

\*Admin Theme

While the default Magento/Adobe/Mage-OS admin themes are supported, we recommend installing the Hyvä Admin Theme for
the best visual experience when using the Admin Dashboard.

### For Agency and Technology Partners

If you have access to the Hyvä Commerce GitLab repositories as Gold/Platinum Agency Partner, or a Technology Partner,
you can install Hyvä Commerce in development environments using SSH key authentication.

You can configure the git repositories in your root composer.json and use the repositories directly as git repo's
beneath your vendor directory. You can check out tags and branches, make commits and push contributions.

This installation method is not suited for deployments, because GitLab requires SSH key authorization.

1. Ensure your public SSH key is added to your account on gitlab.hyva.io.
2. Set minimum-stability to `dev` in the Magento composer.json

   ```
   composer config minimum-stability dev
   ```
3. Add the Admin Dashboard and base Hyvä Commerce module repositories to the Magento `composer.json`

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-admin-dashboard git git@gitlab.hyva.io:hyva-commerce/module-admin-dashboard.git
   ```
4. (optional) Add the Admin Dashboard CrUX Widget and Admin Theme repositories to the Magento `composer.json`

   ```
   composer config repositories.hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget git git@gitlab.hyva.io:hyva-commerce/module-admin-dashboard-google-crux-history-widget.git
   composer config repositories.hyva-themes/commerce-module-admin-theme git git@gitlab.hyva.io:hyva-commerce/module-admin-theme.git
   composer config repositories.hyva-themes/commerce-theme-adminhtml git git@gitlab.hyva.io:hyva-commerce/theme-adminhtml.git
   ```
5. Require the `hyva-themes/commerce-module-admin-dashboard` package

   ```
   composer require hyva-themes/commerce-module-admin-dashboard:dev-main
   ```
6. (optional) Require the `hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget` package

   ```
   composer require hyva-themes/commerce-module-admin-dashboard-google-crux-history-widget:dev-main
   ```
7. (optional) Require the `hyva-themes/commerce-theme-adminhtml` package

   ```
   composer require hyva-themes/commerce-theme-adminhtml:dev-main
   ```
8. Run `bin/magento setup:upgrade`

## Additional Setup

No further steps are required. For more details on how to configure Admin Dashboard settings, see the
[configuration guide](user-guides/system-configuration.html).
