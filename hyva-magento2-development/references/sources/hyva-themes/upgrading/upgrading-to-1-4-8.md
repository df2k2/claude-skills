<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-8.html -->

# Upgrading to 1.4.8

Hyvä Theme 1.4.8 is a maintenance release for the `Hyva_Theme` module only. There is no corresponding Default Theme release.

Safe Module Update

It is safe to update the `Hyva_Theme` module to 1.4.8 without updating the Default Theme.

## Bug fixes

- **Guard against null `$hyvaBaseThemes` during multi-worker SCD**:
  Prevents a fatal error that could occur when running static content deployment with multiple workers in parallel.
- **Removed hard dependency on `Magento\SampleData\Model\Dependency` from `hyva:sampledata:deploy`**:
  The CLI command no longer fails on installations where the Magento sample data module is not present.

## Backward compatibility

This release is backward compatible.

## Changelogs

- [Changelog Theme Module](changelog-theme-module.html#148-2026-07-01)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
