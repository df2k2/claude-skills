<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/hyva-default-theme-csp-installation.html -->

# Installing Hyvä CSP Default Theme

To install the CSP-compatible version of Hyvä Theme, follow the regular [installation instructions](../../getting-started/index.html#installing-hyva-theme-with-composer) but replace the package `hyva-themes/magento2-default-theme` with `hyva-themes/magento2-default-theme-csp`.

```
composer require hyva-themes/magento2-default-theme-csp
```

Hyva/default-csp vs Hyva/default

The CSP-compatible version of the theme uses the theme-name `Hyva/default-csp`. When migrating a custom theme to be CSP compatible, the parent theme name needs to be updated accordingly in the `theme.xml` file

```
    <theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
        <title>My Theme</title>
        <parent>Hyva/default-csp</parent>
        <!--<parent>Hyva/default</parent>-->
    </theme>
```

Also update the content path in the child themes `tailwind.config.js` file to include `vendor/hyva-themes/magento2-default-theme-csp` instead of `vendor/hyva-themes/magento2-default-theme`.

## Installing the default and the default-csp theme side-by-side

The regular and the CSP-compatible version of the default-theme can be installed side-by-side.

```
composer require hyva-themes/magento2-default-theme
composer require hyva-themes/magento2-default-theme-csp
```

This is not required but can be useful while migrating a custom child theme to be strict CSP-compatible.
