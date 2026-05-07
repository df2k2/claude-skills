<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/changelog-beta.html -->

# Beta Changelog - Hyvä Commerce

This page contains the changelog for [Hyvä Commerce](../index.html) features that are currently in Beta.

## Hyvä CMS `1.2.0-beta1` - 2026-02-27

The `1.2.0-beta1` release for Hyvä CMS introduces support for Attribute and Tailwind v4 support for Hyvä CMS.

### Added

- Tailwind V4 support
- Attribute support (products, categories)

### Fixed

- Liveview editor: added `liveview_clean` layout fallback so non-allowed assets (e.g. require.js) are still removed when plugins on `Page\Config\Structure` are not applied (e.g. Magento patch ACSD-66153 bypasses DI). Many thanks to Tatiana Velichko (Monsoon Consulting) and Mykyta Denysenkov (Monsoon Consulting) for the contribution!
- Cast page identifier to string when getting page URL. Many thanks to Kieran Monaghan for the contribution!
- Fixed column style calculation and direction in Grid / Columns Component.
  **Note:** This corrects a logic error where styles were applied in reverse. Existing implementations should be reviewed to ensure correct display.
- Apply CSS classes from Advanced tab on menu\_list\_item
- Image handler grid

## Menu Builder `0.1.0` - 2026-02-18

The `0.1.0` release for Menu Builder is the initial release.

### Added

- Menu entity management via **Content > Elements > Menus** in the Magento admin
- Four built-in menu components: Mega Menu Columns, Mega Menu Drilldown, Mobile Menu, and Footer Columns
- Link picker supporting categories, products, CMS pages, Magento pages, and custom URLs
- Rich content support via the Menu Content component (images, banners, promotional blocks, and any Hyvä CMS component)
- Menu item highlighting (text color, background color, font weight)
- Category import — bulk-import categories from the catalog as menu items
- Dynamic category tree components that automatically sync with catalog structure
- Menu locking in CMS editor preview for easier iterative editing
- Multiple rendering methods: Design Configuration (header/footer), Hyvä CMS Editor, Magento Widgets, widget shortcodes, layout XML, and phtml templates
- Leverages Hyvä CMS Developer API for creating custom menu components using `context_flags` and the Hyvä CMS component system

## Admin Dashboard `0.1.0` - 2025-09-09

The `0.1.0` release for Admin Dashboard is the initial release.

### Added

- Widget Framework
- Base Widget Display Types: Text, Links, Number, Bar Chart, Line Cart, Pie Chart
- Base Widgets: Text, Links, Checkbox
- Custom Widgets: Orders By Country, Order Volume, Recent Orders, Sales Funnel Activity
- Ability to hide/show default dashboard content
- Configuration for batch loading settings

## Admin Dashboard CrUX History Widget - `0.1.0` - 2025-09-09

The `0.1.0` release for Admin Dashboard CrUX History Widget is the initial release.

### Added

- Google CruX History Widget implementation
- Data retention
- Configuration for Google API Key

## Media Optimisation - `0.1.2` - 2025-12-22

The `0.1.2` release for Media Optimisation provides small fixes, better settings and more debug capabilities.

### Added

- WebP lossless default settings
- Fooman PDF compatibility
- Environment check CLI command

## Media Optimisation - `0.1.1` - 2025-12-11

The `0.1.1` release for Media Optimisation is a small release that makes it compatible with Hyva Theme 1.4.

### Added

- Hyva Theme 1.4 compatibility

## Media Optimisation - `0.1.0` - 2025-09-09

The `0.1.0` release for Media Optimisation is the initial release.

### Added

- Developer API
- Automatic Image Replacement (HTML/CSS)
- Supported output formats: WebP, AVIF
- Supported input formats: JPG, JPEG, PNG, GIF, BMP, TIFF
- Supported libraries: GD, Imagick
- Retina (HiDPI) support
- Platform Compatibility Check tool
- Debug Logging
- CLI for flushing images by path
- In-depth general and engine specific configuration for resizing and conversion
