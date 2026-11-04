<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-10.html -->

# Upgrading to 1.4.10

Hyvä Theme 1.4.10 is a targeted bugfix release for both the `Hyva_Theme` module and the Default Theme. No breaking changes, no new features. Just a handful of reliability fixes.

Safe Module Update

You can update the `Hyva_Theme` module to 1.4.9 without updating the Default Theme.

## Sample data tooling

The `hyva:sampledata:deploy` CLI command gets a couple of reliability fixes in 1.4.9. It now works correctly on Mage-OS installations, and no longer fails when it cannot verify whether a sample data package is available.

## Compiled DI cache

When the compiled DI cache is stale and `hyvaBaseThemes` compiles to `null`, the theme module would throw a fatal error. That's fixed in 1.4.9.

## Date formatting for day-first locales

`Date::getDateYMD()` was throwing a `TypeError` on locales that use day-first slash-separated date formats like `nl_BE` and `en_GB`. Date formatting now handles these correctly.

## Developer tooling

The `browser-sync.config.cjs` proxy rewrite rule was too broad. It replaced the origin string everywhere in the response body, including inside `var BASE_URL = '...'` assignments. This left `window.BASE_URL` as just `/`, breaking anything that relied on it for absolute request URLs. The rewrite now correctly skips that occurrence.

## Backward compatibility

This release is backward compatible.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#1410-2026-07-10)
- [Changelog Theme Module](changelog-theme-module.html#1410-2026-07-10)

## Tooling

Check the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
