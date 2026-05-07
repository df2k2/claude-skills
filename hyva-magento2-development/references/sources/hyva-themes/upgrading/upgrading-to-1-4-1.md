<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-1.html -->

# Upgrading to 1.4.1

Release 1.4.1 is a bugfix maintenance release.

Even if not updating the Default Theme to 1.4.1, it is safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

Please refer to the changelogs for details about the bugfixes.

## Backward incompatible changes

The Recently Viewed Products slider has been migrated to the CSS SnapSlider. If a customized `Magento_Catalog::product/widget/viewed/list.phtml` template references the old JavaScript, that may break after the update.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#141-2025-11-17)
- [Changelog Theme Module](changelog-theme-module.html#141-2025-11-17)
- [Changelog Default CSP Theme](changelog-default-theme.html#141-csp-2025-11-17)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
