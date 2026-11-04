<!-- source: https://docs.hyva.io/hyva-commerce/features/admin-theme/configuration.html -->

# Admin Theme Configuration

The Admin Theme has two configuration areas: choosing which admin theme is active, and customising the logos shown across the admin panel.

## Setting the Active Admin Theme

This configuration option allows you to choose which admin theme is active, without requiring code changes or deployment.

Ensure all themes static contents are generated

In production mode, ensure that the static content generation for all admin themes are included in your deployment process. If you wish to generate static files for a single admin theme, it is recommended to [lock the configuration values](https://experienceleague.adobe.com/en/docs/commerce-operations/configuration-guide/cli/configuration-management/set-configuration-values) for this field so admin users cannot change them.

![Active Admin Theme Config](./images/hc-admin-active-theme-config.jpg)

Set the active theme in the Magento admin under `Stores → Settings → Configuration → Advanced → Admin → Admin Design → Active Admin Theme`, then save the configuration.

## Admin Branding (Logos)

Available without installing the admin theme

Note that setting custom logos is available when using any Hyvä Commerce functionality, even when the admin theme is not enabled, or installed.

These configuration options allow you to customise the logos used across the admin panel. This includes the following logos:

- The logo used on the admin login screen
- The logo used on above the menu on all admin panel pages
- The logo used for the favicon when in the admin panel

There are 3 main options for choosing which logos to use:

1. Use the logos of the currently active admin theme, e.g. when using the Hyvä Commerce Admin Theme, this will use the Hyvä Commerce logo
2. Use the default Magento Open Source, or Adobe Commerce logo, regardless of the active admin theme
3. Use custom logos, providing separate uploads for the login, menu, and favicon logos. If a field is left without a custom logo, it falls back to the active admin theme's logo

### Changing the admin logos

[![Active Admin Branding Config](./images/hc-admin-active-branding-config.jpg)](./images/hc-admin-active-branding-config.jpg)

In the Magento admin under `Stores → Settings → Configuration → Advanced → Admin → Admin Branding → Active Admin Branding`, choose **Current Admin Theme**, **Default Magento / Adobe Commerce**, or **Custom**. If **Custom** is selected, upload the logos for the login, menu, and favicon fields. Save the configuration when done.
