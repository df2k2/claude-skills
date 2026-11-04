<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-7.html -->

# Upgrading to 1.4.7

Hyvä Theme 1.4.7 is a focused bugfix and maintenance release.

It brings security hardening for the Node.js build toolchain, accessibility and UI improvements, and a set of stability fixes reported by the community.

Safe Module Updates

Even if you aren't ready to update the Default Theme to 1.4.7 just yet,
it's completely safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

## Notable news

### Security & Build

- **Minimal age for npm dependencies**:
  npm dependencies now require a minimum package age before they are accepted, reducing exposure to zero-day supply chain attacks in the build toolchain.
- **Restored `build-prod` script**:
  The `build-prod` alias is back in `package.json` as a wrapper for `build`, keeping CI and deployment pipelines that rely on it working without changes.

### Performance

- **Jarallax video script loads conditionally**:
  The `jarallax-video` script now only loads on pages that actually contain video background elements, cutting unnecessary JavaScript on all other pages.

### Accessibility & UI

- **Contact form restructured**:
  The contact form template now uses a better HTML structure with correct ARIA semantics.
- **Layered navigation skip link uses design token colors**:
  The skip-to-product-list link previously had hardcoded color values. These are now replaced with design-token-aware classes.

### Snap-slider plugin updates

The snap-slider Alpine plugin receives several notable improvements:

- `loop` modifier support via `data-loop` or `x-snap-slider.loop`
- Index-based navigation logic with `scrollend`/`scroll` fallback
- Slides with `display:none` are excluded from navigation
- Keyboard navigation handles `ArrowDown`/`ArrowUp` as aliases
- Pager receives `inert` when there is no overflow

### `x-htmldialog` plugin update

The `x-htmldialog` Alpine plugin now supports a `modeless` argument, rendering the dialog as a non-blocking popup and allowing interaction with the rest of the page while the dialog is open.

### Canonical URL toggle for review pagination

You can now enable or disable the canonical URL on product review pagination pages via configuration.

## Bug fixes

- **Form keys refreshed after bfcache restore**:
  Form keys are now refreshed correctly when a page is restored from the browser's back/forward cache.
- **reCAPTCHA v2 popup visible when authentication popup is open**:
  The reCAPTCHA challenge popup is no longer hidden behind the authentication popup.

## Backward compatibility

This release is backward compatible.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#147-2026-06-30)
- [Changelog Theme Module](changelog-theme-module.html#147-2026-06-30)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
