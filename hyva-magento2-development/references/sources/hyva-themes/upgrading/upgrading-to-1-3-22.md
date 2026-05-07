<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-3-22.html -->

# Upgrading to 1.3.22

Hyvä Theme 1.3.22 is a focused bugfix release for the 1.3.x series.
It backports fixes from the 1.4.x releases for users who are not yet ready to upgrade to 1.4.

If you're making the case for upgrading: this release is low-risk and fixes real issues that affect shoppers and developers alike.
There are no breaking changes.

Safe Module Updates

Even if you aren't ready to update the Default Theme to 1.3.22 just yet,
it's completely safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

Please refer to the changelogs for details about the bugfixes.

## Notable news

### Frontend Fix

- **Fix Intermittent Luma Blocks on Hyvä Frontend**:
  Resolves an issue where Luma-styled blocks intermittently appeared on the Hyvä frontend.

### Price Display Fix

- **Fix Missing Space in Excl. Tax Price**:
  Resolves a formatting issue where the space before the excl. tax price label was missing.

### Developer Experience

- **Theme Module Version Displayed in Footer**:
  The Theme Module version is now shown in the footer alongside the Magento version.
  This makes it easier to confirm which version is active during development and support.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#1322-2026-03-16)
- [Changelog Theme Module](changelog-theme-module.html#1322-2026-03-16)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
