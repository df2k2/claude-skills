<!-- source: https://docs.hyva.io/hyva-ui-library/changelog.html -->

# Changelog - Hyvä UI

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.7.1...main)

## [2.7.1](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.7.0...2.7.1) - 2026-03-23

### Changed

- Updated all component READMEs: `## Requirements` section is now placed before `## Usage`
- Added Hyvä Default Theme minimum version as plain text to the Requirements section of all component READMEs
- Removed Hyvä, Tailwind and AlpineJS version badges from all component READMEs; version info is now in the Requirements section as text
- Updated `x-htmldialog` and `x-snap-slider` requirements to clarify these are part of the **Hyvä Default Theme** module since version 1.4, not standalone plugins, and that version 1.4 can be used alongside an older Hyvä Default Theme's
- Fixed missing `translate="true"` attribute on `title`, `subtitle` and `label` XML arguments in **Banner A/B/C**
- Fixed `alt` attribute incorrectly using `escapeUrl` instead of `escapeHtmlAttr` in **Banner A/B**
- Fixed `getClasses()` replaced with `getCssClasses()` in **Banner C**
- Fixed simplified `$bannerContentClasses` assignment in **Banner C** (removed unnecessary `implode/array_filter` wrapper)
- Reworked `open_in_new` link logic in **Banner A/B/C** to use PHP `if` blocks instead of inline echo ternaries
- Updated **Category Filter B** to be compatible with version 2.7 of the Hyvä Smile Elasticsuite compatibility module,
  many thanks to Rik Willems (Actiview) for their contribution!

## [2.7.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.6.1...2.7.0) - 2025-12-18

### Added

- New Component **Card**
- New Component **Loader C**
- New badge for `Included with Hyvä CMS`
- Proper Escaping to **Gallery B**,
  many thanks to Irina Smidt (CustomGento) for their contribution!

### Changed

- Renamed badges with `CMS only` and `CMS Support` to `Wysiwyg Only` and `Wysiwyg Support` to avoid confusion with Hyvä CMS,
  for more info [see our docs on what this badge means](https://docs.hyva.io/hyva-ui-library/faqs/wysiwyg-components.html).
- Fixed Compatibility with Hyvä 1.4 and Tailwind 4 for some modules.
- Fixed incorrect csp functions with the **Breadcrumbs A**,
  many thanks to Justin van Elst (Publicus) for their contribution!
- Improved stability for the **Category Filter**, this now works with BrowserSync.
- Reworked the Swatches to a single CSS file, this now work as version for a planned upgrade and requires no template overrides.

### Removed

- Components for **CTA**, all version have been merged into the **Banner** Component that is now also Part of Hyvä CMS
- Plugin **Snap Slider**, now part of Hyvä 1.4 Theme Module
- Plugin **Html Dialog**, now part of Hyvä 1.4 Theme Module

## [2.6.1](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.6.0...2.6.1) - 2025-08-29

### Added

- Added a new plugin to provide experimental support for Tailwind v4.
  For usage instructions, please refer to the plugin's documentation
  and the new docs for our [NPM package](https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/index.html).
- Added a new plugin to provide an example for using design tokens in Tailwind v3

### Changed

- **Product Card A**: Refactored the image template into two separate files for default and CSP Theme
- Fixed **Gallery B**: Corrected the initial state display when the starting image is not the first in the gallery
- Fixed **Footer B**: Resolved an issue with the toggle state on mobile devices
- Fixed **Menu D**: Adjusted the minimum height for first-level menu items
- Fixed CSP violations in **Menu C/D**, **Cart A/B**, **Message A/B**, and **Pagination A**

## [2.6.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.5.0...2.6.0) - 2025-04-24

### Added

- **Slider C** Product
- New **Plugin** Snap Slider, for building CSS-driven sliders
- New **Plugin** Html Dialog, for building Modals and Offcanvas elements using the native HTML `<dialog>` element

### Changed

- Updated all UI code to be CSP compliant
- Moved Plugin code to its own new `plugins` directory and updated the documentation to reflect this new location

## [2.5.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.4.1...2.5.0) - 2025-01-10

### Added

- **Breadcrumbs A**
- **Button A**
- **Mobile Menu A/B**
- **Pagination A**
- **Search Form A** with SmileElasticsuite support
- Config options to display icons in **Header A/B/C**
- Wishlist icon to **Header A/B/C**
- Support for static blocks in **Menu C/D** same as **Menu B**
- XML menu support to **Menu A**, same as seen with the Mobile Menus

### Changed

- Removed any inline button styles with the btn variant classes from **Button A**
- Rebuilt logic for Search Form position switch, between mobile and desktop, by using just CSS and without any Javascript
- Fixed **Ajax ATC** from opening the Minicart/Ajax Modal after Clearing Cart without a refresh,
  many thanks to Vikram Kumar for their contribution!
- Fixed Error handeling in **Ajax ATC** for redirects
- Fixed file uploads with the **Ajax ATC**
- Fixed Closing tag in **Sticky ATC A**

### Removed

- Search Form from **Header A/B/C** to its own UI component

## [2.4.1](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.4.0...2.4.1) - 2024-09-10

### Added

- **Sticky ATC (Add To Cart) A**
- **Scroll To Top B**
- **Sticky Header A**
- `checkHeaderSize` helper to **Header A/B/C** to improve sticky support options

### Changed

- Mobile menu to use the modern scroll lock in**Header A/B/C** to support sticky support
- Fixed Invalid qty value not showing the error message in **Minicart A/B**
- Fixed Searchbox Autocomplete from effecting the layout in **Header C**
- Fixed Searchbox from losing focus when opening the virtual keyboard on mobile devices in **Header C**
- Fixed Video interaction in **Gallery B**
- Fixed Undefined method for PHPstan in **Ajax ATC A**,
  many thanks to Tjitse Efdé (Vendic) for their contribution!
- Fixed Untranslated SVG's in **Popup A/B** and **Product-Data B**,
  many thanks to Lars de Weert (Made by Mouses) for their contribution!

## [2.4.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.3.0...2.4.0) - 2024-07-03

### Added

- **Order Confirmation A**
- **Error Pages A/B**
- i18n boilerplate for UI translations
- badges in the README for UI Components with CMS functionalities for a clearer overview

### Changed

- Updated `x-collapse` for **Accordion.A** and **Product-Data.B**
- Fixed **Gallery B** magnifier toggle button still being visible on mobile
- Fixed Missing `itemprop=image` in **Gallery B/C/D**

## [2.3.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.2.1...2.3.0) - 2024-04-26

### Added

- **Gallery B/C** magnifier support
- **Scroll To Top A**
- **Menu D** a variation on **Menu C** with the Shop Menu toggle button from **Header B**

### Changed

- **Banner A/B/C/D** use grid stacking to make the banners easier to use in flex, grid and position layouts
- **Gallery C** option for nav renamed from `number` to `counter` to add consistency between gallery options
- Add config options to the **Menu C** for the nesting dept and CTA top link option
- **Menu B** the CMS block position has been rebuild with the Design differences update and now only includes one position with a different name
- Fixed**Ajax ATC A** loader being used on buttons that are not the submit button
- Fixed**Gallery B** show thumbs when the image count is one
- Fixed**Gallery C** fullscreen close button contrast when on the dialog content
- FixedDesign differences for **Header A/B/C** and **Menu A/B/C**
- Fixed A11Y color issues for **Header C**

### Removed

- Shop Menu toggle button from **Header B**, to allow multiple menus to work with **Header B**

## [2.2.1](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.2.0...2.2.1) - 2024-03-29

### Added

- Option to configure the form selectors for the **Ajax ATC A**
- Option to load the first image eager for the **Slider A/C**
- PayPal Express In Context support added to the **MiniCart A/B**

### Changed

- **Ajax ATC A** now works with infinite scroll pages that includes forms,
  many thanks to Christoph Hendreich (In Session) for their contribution!
- Fixed No active tab in **Product-Data B**, if the description is empty
- Fixed **Ajax ATC A** show cart drawer/modal, if there is an error after submitting the form
- Fixed **Ajax ATC A** Modal now closes when opening the authentication popup
- Fixed **MiniCart A and B** toggle event if `event.detail` is empty
- Fixed Review schema type for author in **Product-Review A/B**,
  many thanks to Ravinder (Redchamps) for their contribution!

## [2.2.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.1.0...2.2.0) - 2024-02-23

### Added

- **Accordion A**: added custom icon support
- **Ajax ATC A**
- Carousel to Usps in **Footer C** for mobile view
- **Gallery A/B/D** video preview image support when autoplay is off
- **Loader A**
- **Loader B**
- **MiniCart A and B**
- **Slider C** with SplideJS

### Changed

- **Banner D**: use php foreach loop to make modifications easier
- **Categories A/B**: now use the CSS Slider layout for mobile with an option to keep the grid layout
- **Categories A/B/C**: use php foreach loop to make modifications easier
- **Categories B**: use opacity in svg color for easier color modification
- **Footer B** now uses customer menu with the same xml logic as used for the header
- **Footer B** split the layout back to each Magento 2 module (same as default theme), to make it easier to customize
- **Footer B** The mobile only collapse has been added as its own block same as with the accordion collapse
- **Footer B** use the foreach of each column again from the default theme so other items can still be added
- **Footer C** now extend on **Footer B**
- **Gallery A/B/C/D** Add config support for enabling/disabling the autoplay for the videos
- Optimize svg sizes for **Categories B**, **Slider B** and **Footer A/C**
- Fixed **Category-filter A/B** CLS issues
- Fixed **Gallery C** (Mobile view) now stops the video from playing if not in view
- Fixed **Menu B**: deprecated method for CMS blocks
- Fixed **Header A/B/C**: the mobile version now shows the customer, search and language options
- Fixed **Header A/B/C**: overflow issues
- Fixed A11Y color issues for **Notification A/B** and **Popup A/B**
- Fixed Design differences for **Slider A**, **Footer A/B/C**, **Notification A/B**, **Popup A/B**
- Fixed Missing php translation option for **Banner A/B/C/D**, **Categories A/B** and **Slider B**

### Removed

- **Categories C** has been rebuild as **Slider C**
- Swatches from usage step in readme for **Category-filter B** and **Product-Card A**

## [2.1.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.0.2...2.1.0) - 2023-12-01

### Added

- **Accordion A**
- **Category-filter A**
- **Category-filter B** for Smile ElasticSuite
- **Gallery A**
- **Gallery B**
- **Gallery C**
- **Gallery D** with SplideJS
- **Product-Data A**
- **Product-Data B**
- **Product-Data C**
- **Product-Review A**
- **Product-Review B**
- **Swatches A**

### Changed

- **Header C**: Fix incorrect padding size
- **Header C**: Remove redundant layout tag in default.xml
- **Assets**: Renamed assets to prevent UTF-8 issues with ä in hyvä
- **Product-Card A**: removed Swatches from component, now replaced by the new **Swatches A** Component

### Removed

- Nothing Removed

## [2.0.2](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.0.1...2.0.2) - 2023-11-15

### Added

- Nothing added

### Changed

- **General**: Update components to Hyva Theme version 1.3.3
- **General**: Replace incorrect boolean value with string value for aria-hidden attributes on icons
- **Header A/B/C**: Update customer-menu.phtml files to 1.3.2 version of default theme
- **Header A**: Fix z-index issues for the header notification
- **Header B/C**: Remove redundant hidden classes
- **Header B**: Move compare icon to the left to prevent empty spaces
- **Header C**: Fix missing comma

### Removed

- Nothing removed

## [2.0.1](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.0.1...2.0.0) - 2023-10-09

### Added

- **General**: Add CHANGELOG.md

### Changed

- **General**: Update components to Hyva Theme version 1.3.2
- **General**: Fix wrong link in the main README.md
- **General**: Update License information
- **General**: Fix Varnish caching of menu blocks
- **Menu B**: Remove legacy topmenu file
- **Menu C**: Fix height of 3rd navigation level in menu C
- **Product-card A**: Move script tag inside product container
- **Product-card A**: Fix image scaling
- **Product-card A**: Add focus styling to swatches
- **Slider A/B**: Improve accessibility of slider components

### Removed

- **Menu B**: Removed legacy topmenu file for Hyvä Theme V1.x

## [2.0.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/compare/2.0.0...1.0.0) - 2023-07-16

### Added

- Nothing added

### Changed

- All components are updated to make them compatible with the latest version of the
  Hyvä Theme (1.2.x), Tailwind CSS 3 and Alpine.js 3

### Removed

- Nothing removed

## [1.0.0](https://gitlab.hyva.io/hyva-themes/ui/hyva-ui/-/tags/1.0.0) - 2023-07-16

### Added

- Initial release added

### Changed

- Nothing changed

### Removed

- Nothing removed
