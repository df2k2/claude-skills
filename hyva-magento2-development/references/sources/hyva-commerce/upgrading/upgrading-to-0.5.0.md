<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-0.5.0.html -->

# Upgrading to Hyvä Commerce 0.5.0

This is primarily a bug fix release for Hyvä CMS that addresses issues from the previous version.

## Notable news

### Hyvä CMS

#### Backward incompatible changes

Only affects custom field types

This change only impacts projects that have added [custom integrations with Hyvä CMS](../features/cms/extending-for-other-content-types.html).

In your integration module for Hyvä CMS, you must now use the `TailwindCssJit::processContentWithStyles()` method rather than `TailwindCssJit::prependContentStyles()`.

## Changelogs

The changelog is available [here](changelog.html#050-2025-06-04).

## Known Issues

See bugfixes in the [0.6.0 release](upgrading-to-0.6.0.html).
