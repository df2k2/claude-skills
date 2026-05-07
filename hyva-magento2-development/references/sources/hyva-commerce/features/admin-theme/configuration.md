<!-- source: https://docs.hyva.io/hyva-commerce/features/admin-theme/configuration.html -->

# Admin Theme Configuration

## Active Theme

This configuration option allows you to choose which admin theme is active, without requiring code changes or deployment.

Ensure all themes static contents are generated

In production mode, ensure that the static content generation for all admin themes are included in your deployment process. If you wish only generate static files for a single admin theme, it is recommended to [lock the configuration values](https://experienceleague.adobe.com/en/docs/commerce-operations/configuration-guide/cli/configuration-management/set-configuration-values) for this field so admin users cannot change them.

### Setting the active admin theme

[![Active Admin Theme Config](images/hc-admin-active-theme-config.png)](images/hc-admin-active-theme-config.png)

To change the active admin theme:

1. Navigate to 'Stores > Settings > Configuration' from the main menu in the admin panel
2. Select 'Advanced > Admin' from the left hand configuration menu
3. Under 'Admin Design', use the 'Active Admin Theme' field to select the theme you wish to make active.
4. Save the configuration

## Admin Branding (Logos)

Available without installing the admin theme

Note that setting custom logos is available when using any Hyvä Commerce functionality, even when the admin theme is not enabled, or installed.

These configuration options allow you to customise the logos used across the admin panel. This includes the following logos:

- The logo used on the admin login screen
- The logo used on above the menu on all admin panel pages
- The logo used for the favicon when in the admin panel

There are 3 mains options for choosing which logos to use:

1. Use the logos of the currently active admin theme, e.g. when using the Hyvä Commerce Admin Theme, this will use the Hyvä Commerce logo
2. Use the default Magento Open Source, or Adobe Commerce logo, regardless of the active admin theme
3. Use custom logos - this provides 3 upload files for the areas mentioned above: login, menu and favicon logos. If any of the fields do not have a custom logo uploaded, then it will fallback to the current active admin themes logo

### Changing the admin logos

[![Active Admin Theme Config](images/hc-admin-active-branding-config.png)](images/hc-admin-active-branding-config.png)

To change the logos used in the admin panel:

1. Navigate to 'Stores > Settings > Configuration' from the main menu in the admin panel
2. Select 'Advanced > Admin' from the left hand configuration menu
3. Under 'Admin Branding', use the 'Active Admin Branding' field to select the logos you want to choose: 'Current Admin Theme', ' Default Magento / Adobe Commerce', or 'Custom'
4. If 'Custom' is selected, upload the logos you wish to use to the login, menu and favicon
5. Save the configuration
