<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-5.html -->

# Upgrading to 1.4.5

Hyvä Theme 1.4.5 is a focused bugfix release, resolving issues reported by the community.
It addresses problems in the gallery, Page Builder, wishlist, modal dialogs, and private content loading.

Safe Module Updates

Even if you aren't ready to update the Default Theme to 1.4.5 just yet,
it's completely safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

Please refer to the changelogs for details about the bugfixes.

## Notable news

### Accessibility & UI Fixes

- **Page Builder Tabs ARIA Compliance**:
  The Page Builder tabs widget now correctly follows the ARIA tabs pattern,
  improving keyboard navigation and screen reader support.
- **Modal Dialog Height on Mobile**:
  Modal dialogs were using `vh` units for their max-height, which caused them to overlap the browser UI on mobile devices.
  This is now fixed by using `svh` (small viewport height) instead.

### Gallery Fix

- **Gallery Preload imageHelper**:
  Resolves a regression where the gallery preload broke due to a missing `imageHelper`.
  This restores the LCP improvement introduced in 1.4.4.

### Wishlist Fix

- **Related Products for Configurable Products**:
  Fixes a bug where related products were not displayed correctly for configurable products added to the wishlist.

### Stability & Compatibility

- **Private Content Error Handling**:
  Network errors during private content fetching are now handled gracefully instead of causing unhandled promise rejections.
- **DeploymentConfig\Writer Plugin Replaced**:
  The `DeploymentConfig\Writer` plugin has been replaced with a `Recurring.php` setup script and a `Status` plugin,
  fix automatic generation of `app/etc/hyva-themes.json` on Magento 2.4.7 during `setup:install` and `setup:upgrade`.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#145-2026-03-16)
- [Changelog Theme Module](changelog-theme-module.html#145-2026-03-16)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
