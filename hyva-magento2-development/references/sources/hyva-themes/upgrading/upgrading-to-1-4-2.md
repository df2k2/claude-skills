<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-2.html -->

# Upgrading to 1.4.2

Release 1.4.2 is mostly a bugfix release.

Even if not updating the Default Theme to 1.4.2, it is safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

## Notable news

- Fixed Speculation rules to take account for store codes in URL
- Fixed Product List Page item so that the gallery correctly updates for each item
- Fixed the gallery fullscreen

### Improved documentation and debugging

We added debug helpers to make it clear if you need to adjust something,
for more info see [the Hyvä Themes Tailwind Utilities changelog](https://github.com/hyva-themes/hyva-modules-tailwind-js/releases/tag/1.2.4).

We also added comments to the `hyva.config.json` to make it more clear what this file is used for and how to use it.

### Added source URLs for easier debugging

Source URLs make it easier to debug JavaScript as if it were JavaScript files.

### Added new CSS Component input-group

This CSS component makes it easier to bundle form fields together (e.g. a search field).

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#142-2025-12-10)
- [Changelog Theme Module](changelog-theme-module.html#142-2025-12-10)
- [Changelog Default CSP Theme](changelog-default-theme.html#142-csp-2025-12-10)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
