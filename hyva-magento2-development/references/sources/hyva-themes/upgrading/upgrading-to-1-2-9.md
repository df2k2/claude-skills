<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-2-9.html -->

# Upgrading to 1.2.9

Release 1.2.9 includes bug fixes and improvements.

When updating the Hyvä Theme to version 1.2.9, please note to always update the `hyva-themes/magento2-theme-module` to the latest version as well.

Even if not updating the Default Theme to 1.2.9, it should always be safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

## Backward incompatible changes

There are no backward compatibility breaking changes in release 1.2.9.

## Manual changes

A bug was fixed that was introduced in release 1.2.8.
By moving tailwind classes from `web/tailwind/components/customer.css` into the layout XML container `htmlClass` attribute in `Magento_Customer/layout/customer_account_login.xml`, the layout was no longer schema compliant.
The class `md:grid-cols-2` is not valid according to the layout XML schema in the core Magento framework `View/Layout/etc/elements.xsd`.
This release fixes the issue by reverting that change made in 1.2.8.
To resolve the issue in existing themes, the layout schema can be patched, as described in [Styling Layout Containers](../building-your-theme/styling-layout-containers.html#patching-the-magento-xml-schema-to-allow-tailwind-classes), or the change to the layout XML file needs to be reverted, as it was in this release 1.2.9.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#129-2023-12-21)
- [Changelog Theme Module](changelog-theme-module.html#129-2023-12-21)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information how to upgrade.

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
