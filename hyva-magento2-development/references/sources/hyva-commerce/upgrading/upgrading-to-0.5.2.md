<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-0.5.2.html -->

# Upgrading to Hyvä Commerce 0.5.2

This is a bug fix release for the Hyvä Admin Theme and base `Hyva_Commerce` module that addresses issues from the previous version.

## Notable news

### Base `Hyva_Commerce` module

The default value for the active admin theme (set in `etc/config.xml`) has now been removed to avoid an edge case error that occurs when this module and the Mage-OS theme are installed, but our admin theme is not. This is to maintain our promise that all Hyvä Commerce features can be installed separately, and not just via the main metapackage.

### Admin Theme

We've introduced a new `Hyva_AdminTheme` module that our admin theme now depends on that includes the default value for the active admin theme that was removed from the base `Hyva_Commerce` module (as noted above). This module will also be utilised for any admin theme specific configuration or code that may be required in the future.

## Changelogs

The changelog is available [here](changelog.html#052-2025-06-20).

## Known Issues

- None so far
