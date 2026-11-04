<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/index.html -->

# How to Upgrade Hyvä Checkout

Upgrading Hyvä Checkout is straightforward. This page walks you through the general upgrade process and the composer commands you need.

Check Version-Specific Upgrade Notes

Before upgrading, always check the version-specific upgrade notes in this documentation. Backward incompatible changes, if any, will be listed there.

## Hyvä Checkout Upgrade Process

Follow these steps to upgrade Hyvä Checkout to a new version:

1. **Review the version-specific upgrade notes** in this documentation. Any backward incompatible changes will be listed there.
2. **Check the changelog** for the new Hyvä Checkout version to understand what changed: the [Checkout 3.x Changelog](changelog.html) or the [Checkout 1.x Changelog](changelog-1.x.html).
3. **Upgrade the `hyva-themes/magento2-hyva-checkout` module** using composer (see the commands below).
4. **Apply required changes** from the upgrade notes to any files you customized in your theme.

## Hyvä Checkout Frontend API Compatibility

The `hyva-themes/magento2-hyva-checkout-frontend-api` package bridges JavaScript API differences between Hyvä Checkout versions. Payment method integrations that rely on the latest Frontend (Payment) JavaScript API may need this standalone package when running an older version of Hyvä Checkout.

Whether this package is required depends on your specific setup. The package exists so payment module developers can target the latest JavaScript API without worrying about differences between Hyvä Checkout versions or missing functionality in older installations.

As a general rule:

- **Older Hyvä Checkout version** - Keep the `hyva-themes/magento2-hyva-checkout-frontend-api` package installed and up to date.
- **Latest Hyvä Checkout version** - The frontend API compatibility package is no longer required.

## Hyvä Checkout Upgrade Composer Commands

To update the `hyva-themes/magento2-hyva-checkout` package along with its Magewire dependency to the latest version, run the following composer command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout
```

To update Hyvä Checkout to a specific version, use the following command, replacing `x.y.z` with the desired version number:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:x.y.z
```

Moving from Checkout 1.x to 3.x

`composer update` keeps a Checkout 1.x store on 1.x, because the version constraint in `composer.json` doesn't allow 3.x. To move to Checkout 3.x, replace the constraint with `composer require`, as described in [Upgrading to 3.0.0](upgrading-to-3.0.0.html).
