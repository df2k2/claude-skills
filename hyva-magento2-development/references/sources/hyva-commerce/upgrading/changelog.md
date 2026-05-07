<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/changelog.html -->

# Changelog - Hyvä Commerce

This page contains the changelog for all [Hyvä Commerce](../index.html) features.

## [1.2.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/1.1.1...1.2.0) - 2026-03-16

The `1.2.0` release for Hyvä Commerce introduces the Admin Dashboard and Media Optimisation features.

### [1.0.0](https://gitlab.hyva.io/hyva-commerce/module-admin-dashboard/-/compare/0.1.0...1.0.0) - Admin Dashboard

#### Added

- Restructured Module Architecture
  - Replaced `Hyva_AdminDashboardBaseWidgets` and `Hyva_AdminDashboardCustomWidgets` with `Hyva_AdminDashboardWidgets`
    - Abstract widget types, Alpine components, and templates have been moved to the `Hyva_AdminDashboardFramework` module
- New Widget Types
  - `average_order_value` — Average order value with date intervals
  - `best_selling_products` — Table display with trailing action to reports
  - `launchpad` — Configurable launchpad/quick links
  - `most_viewed_products` — Table with report link
  - `new_customers` — Table with customer list link
  - `sales_figures` — Revenue/tax/shipping breakdown
  - `search_activity` — Search terms table
- Date Interval System
  - New `AbstractDateIntervalWidget` base class with subinterval support
  - Centralized `WidgetDateIntervals` source model in framework `di.xml`
  - 19 intervals from 15 minutes to 5 years (intervals > 1 year disabled by default)
  - Each interval has subinterval config with step modifier and date format
- Widget Caching
  - Per-widget configurable cache lifetimes via `<cache_lifetime>` in widget XML, default value of 86400 seconds
  - `AdminDashboard` cache class now handles save/load of widget display data
- Widget Auth Utility Class
  - Wraps the Magento admin auth model and `AuthorizationInterface` into a single injectable dependency
- New View Models
  - `Locale`
  - `SelectedStoreViews`
  - `TrailingAction`
  - `Chart`
  - `Widget/Content`
  - `Widget/Input/DynamicRows`
- New Controller Actions
  - `Controller/Adminhtml/WidgetInstance/Duplicate.php`
  - `Controller/Adminhtml/WidgetInstance/MassDelete.php`
- New Chart System Configuration Options
  - Light/dark theme toggle
  - Monochrome toggle
  - Custom colour palette
  - Fill types
- Widget Layouts
  - New widget layout handles to improve extensibility and ease customisation
- Widget/Dashboard Actions
  - Delete all dashboard widgets
  - Reload data for a specific widget instance
  - View the widget content in a full screen modal

#### Changed

- Replaced `Hyva_AdminDashboardBaseWidgets` and `Hyva_AdminDashboardCustomWidgets` with `Hyva_AdminDashboardWidgets`
- The `Widget` view model's `booleanAttributes` array is now configurable via `di.xml` instead of being a hardcoded class property
- Updated the GridStack library from version `12.2.1` to `12.3.3`
- Refactored custom widget implementations to improve database query performance

#### Removed

- `Hyva_AdminDashboardBaseWidgets` and `Hyva_AdminDashboardCustomWidgets` modules
- Global `description` display property

### [1.0.0](https://gitlab.hyva.io/hyva-commerce/module-admin-dashboard-google-crux-history-widget/-/compare/0.1.0...1.0.0) - Admin Dashboard Google CrUX History Widget

#### Added

- Ability to choose URL from a selected store view
- Option to display data from the origin or the specific URL only
- Ability to choose a date range from available intervals

#### Changed

- Many improvements to chart implementation and visual output
- Refactored to use the metrics outlined in `di.xml` to manage output and ordering of metrics in the charts

#### Removed

- `formatted_data` column from `hyva_admin_dashboard_google_crux_history` table and all usage in code

### [1.0.0](https://gitlab.hyva.io/hyva-commerce/module-media-optimization/-/compare/0.1.2...1.0.0) - Media Optimisation

#### Added

- Viewport breakpoints for resizing images

#### Changed

- Moved logs to a separate file
- Improved extraction and handling of `width` and `height` attributes from image tags
- Configuration refactored into dedicated classes per configuration area for improved maintainability
- Moved config interactions over to config classes and separated config xml files for better overview
- Use better defaults for compression on advanced formats

#### Fixed

- Fixed HTML attribute parsing to correctly handle attributes without quotation marks
- Prevented double escaping of image URLs during automatic replacement

### [1.0.2](https://gitlab.hyva.io/hyva-commerce/module-commerce/-/compare/1.0.1..1.0.2) - Commerce Module

#### Changed

- Loading AlpineJS in the admin panel now follows the same logic as the frontend.
- Alpine is now loaded using the `hyva_adminhtml_alpine` handle, but `hyva_adminhtml_alpine_csp` remains for backwards compatibility.

## [1.1.1](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/1.1.0...1.1.1) - 2026-02-16

The `1.1.1` release for Hyvä Commerce is primarily a bug fix release for Hyvä CMS.

### [1.1.1](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/1.1.0...1.1.1) - Hyvä CMS

### Added

- Add console commands to show information about CMS components and fields. These commands help document the components and fields available in Hyvä CMS at the project level, both core and custom, and are useful when creating new components and fields with AI assistants, skills, and other tooling.
  - **`hyva:cms:describe-components` CLI command** – Describes enabled CMS components with name, label, description, and category. Supports `--format=json` for full config output and an optional component name filter.
  - **`hyva:cms:list-fields` CLI command** – Lists Hyvä CMS field types (core and custom). Supports `--format=json` for full config output and an optional field name filter.
  - **`hyva:cms:list-disabled-components` CLI command** – Lists disabled CMS components.

### Fixed

- Fix component validation to allow disabled components to validate for backward compatibility with existing content.
- Fix undefined $hyvaCsp on Luma storefront
- Use Magento\_Backend::content for liveview editor ACL resource to resolve issues gitlab issue #20 with ACL configuration.
- Fix Firefox liveview preview error on initial about:blank load

## [1.1.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/1.0.2...1.1.0) - 2026-02-03

The `1.1.0` release for Hyvä Commerce introduces Hyvä CMS translations (with AI), REST and GraphQL endpoints for Hyvä CMS, new Hyvä CMS components, many improvements and various bug fixes for Hyvä CMS.

### [1.1.0](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/1.0.2...1.1.0) - Hyvä CMS

### Added

- REST and GraphQL endpoints for Hyvä CMS Page and Block.
- Hyvä CMS translations (with AI).
- Container class to TW safelist. This will reduce issue people experience when using the liveview editor and not having configured tailwind.browser-jit-config.js`.
- Add `context_flags` to the JSON schema for use in various contexts, e.g. restricting root components for specific entities.
- Restrict root components for entities which pass the `allowed_root_component_context_flags` property when emitting the `init-content-properties` event.
- Support `componentPath=false` for explicit template usage
  When componentPath is set to false, the Element block will now call the `parent::getTemplate()` method.
  This enables blocks to be created via `createBlock` with an explicit template set via `setTemplate()`,
  allowing components to render child components or sections of their markup with custom templates set in the component template.
  e.g. `<?= $block->getLayout()->createBlock(\Hyva\CmsLiveviewEditor\Block\Element::class,'',['data' => [...]])->setTemplate('Vendor_Module::elements/custom-template.phtml')->toHtml() ?>`
- Added layout blocks for injecting scripts in liveview preview mode:
  - Added `after-body-start` block for early script injection
  - Added `additional-scripts-preview` block for conditional script loading
  - Both blocks only render child HTML when in valid preview context
- Add support for `wbr` tag to richtext
- Add split view for preview mode.
- Restore last view used in the liveview editor by entity reference when loading the liveview editor.
- Add New Marquee Component
- Category Field to select multiple category IDs for a Hyva CMS Component. (thanks **Antoni Tormo - Onestic** for the contribution)
- Widget icon for component.
- Add New Card Component, with two styles
- Added new field type **Url**
- Add New Embed Component for Videos
- Added support for `max_nesting_level` configuration in component definitions. When configured, children containers and related UI elements beyond the specified nesting depth are automatically hidden via CSS rules.
- Added `include_child_category_products` attribute to product\_slider component (thanks **Alex Berger** for the contribution)
- Button to remove all categories and products from field values.
- Options to create new pages, blocks from the Hyvä CMS Editor Navigator.
- Added aria-label to visibility toggle button.

### Changed

- Updated README.md to link to the Hyvä Commerce CMS documentation to avoid repetition and for consistency.
- Text Class added to component now added in PHP via addField method instead of in JavaScript.
- saveState is used less frequently by combining the action with the content update.
- Skip preview update if we're only saving state.
- Sidebar styling improvements (add component button stays in place when scrolling + component tree gradient shadows)
- Give more space to the component list dialog on smaller screens.
- Pagebuilder migration now no longer experimental and does not require toggle in editor preferences.
- Update link-handler to show category path.
- Use Hyvä Default Theme Slider as the template for the Product Slider, to use the same style between Themes.
- Applied `display: contents` to Hyvä CMS liveview wrapper divs so they can be removed from the store-front while kept in the Editor preview without affecting layout on either, ensuring that the preview matches the actual store-front result. This results in less nesting and markup added to the store-front when using Hyvä CMS, with performance improvements from reduced DOM complexity.
  - **BREAKING-CHANGE: severity level low:**
    Frontend customisations that rely on the Hyvä CMS liveview wrapper divs (e.g., CSS or JavaScript targeting these divs, or using them for child layout) may break. Most users are unaffected. To restore the previous behaviour, enable legacy liveview-content wrapper divs in Store Configuration > Hyvä CMS > Advanced.
- Refactoring of repository classes:
  - Replace date() calls with DateTime dependency injection
  - Add PHPDoc blocks to resolve linting errors
  - Refactor delete methods with improved type annotations
  - Affects Block, Page, Scheduled repositories.
- Component edit panels are now loaded when required, rather than pre-loaded when the liveview editor is initialized or when Magewire updates. This significantly improves performance by reducing the LiveView Composer response payload and ensuring only the required panels are rendered in the DOM.
  - **BREAKING-CHANGE: severity level low:**
    Custom field type templates that read validation state from the Magewire component (e.g. `$magewire->errors[$uid][$fieldName]`) will no longer show validation errors in the editor panel. Field type templates are now always rendered by the panel block, so the Magewire component is not in scope when panels are loaded on demand. **Migration:** Read validation state from the block instead: `$hasError = $block->getData('hasError');` and `$errorMessage = (string) ($block->getData('errorMessage') ?? '');`. Remove the `use Hyva\CmsLiveviewEditor\Magewire\LiveviewComposer;` statement and the `@var LiveviewComposer $magewire` annotation from your custom field type template if they are only used for errors. See [Creating custom component field types](../features/cms/creating-custom-component-fields-types.html) for the current pattern.
- Open panel automatically when adding a new component when enabled in preferences (to work with updated panels)

### Fixed

- Prevent time\_scheduled column from auto-updating on record update.
  Depending on MySQL/MariaDB version, it may auto-apply ON UPDATE CURRENT\_TIMESTAMP to the first TIMESTAMP column even when on\_update="false" is set. Setting the column to its current value prevents this auto-update behaviour per MySQL documentation.
- Component visibility for nested components which use a parent's template.
- Corrected duplicate detection in CMS observers so Hyvä CMS content is copied when duplicating pages/blocks, i.e. "Save & Duplicate".
- Fixed default text and heading styles from effecting the other CMS blocks
- Accordion from not closing other items when opening one.
- Fix type error when accessing scheduling editor with Tailwind JIT disabled
- Fixed show\_if property to handle null values correctly.
- Fix JIT style sheets to load before closing head tag.
- Scheduling so it automatically saves the content before scheduling.
- Scheduling of CMS blocks bug where it was not possible to update a blocks is\_active setting when scheduling it for release.
- Overflow issue in widget field type when using long option values.
- Cut off tooltips in version history list and sidebar component list.
- Open dropdowns in component list after adding components.
- Fixed comment wrapping in field type boolean
- Fixed reverse option in Banner split variant
- Fixed searchable select field type to handle duplicate option values.
- HTML editor text position not matching preview position (thanks to **Nichita Blanari** for the help of testing and detailed reporting)
- Suppress known Alpine.js errors in preview mode.

### Removed

- Remove symfony/http-foundation dependency. To avoid errors from transitive dependency on new magento installs. The http-foundation was only used to check two HTTP constants for Livewire.php, to reduce the number of dependencies and avoid conflicts with other versions of the library, these two constants were added directly to the Livewire.php file.

### 1.0.0 - Hyvä CMS AI Translations

#### Added

- Added: ability to use AI for Hyvä CMS Translations

## [1.0.2](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/1.0.1...1.0.2) - 2025-11-11

The `1.0.2` release for Hyvä Commerce introduces scheduling functionality for Hyvä CMS content, allowing content to be scheduled for future publication, along with many improvements and various bug fixes for Hyvä CMS.

### [1.0.2](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/1.0.1...1.0.2) - Hyvä CMS

#### Added

- Integration tests for VersionHistoryManager
- Link to image component
- Add toggle for adding prose class by default
- Section for editor settings in stores configuration
- `blockListSize` parameter in `CmsBlocks` source model to protect against performance issues
- Navigator for CMS pages/blocks
- Editor preference for "Confirm Before Publishing" - opt-in confirmation modal when publishing changes
- Search in component selector
- Larger editing modal for richtext field
- Allow components to be excluded in children > config > excludes (see slider component)
- Conditional visibility rules for fields in the Liveview editor
- Added datetime field type
- Automatic strict CSP frame-ancestors header for multi-domain setups (configurable setting, enabled by default)
  - **Note:** Previously these CSP policies required manual configuration in `csp_whitelist.xml` and enabling strict CSP mode.
    This is no longer required and may be removed once the `hyva_cms/general/auto_csp_frame_policies` configuration is enabled.
  - **Note:** If you have built a custom integration [extending Hyvä CMS for another custom content type](../features/cms/extending-for-other-content-types.html), to support *Automatic CSP Frame Policies* on additional routes which include the Hyvä CMS preview,
    you must add the routes as an argument to `Hyva\CmsLiveviewEditor\Model\Security\IsValidAdminPreviewRequest` passed via dependency injection, i.e. `etc/adminhtml/di.xml`.
  - For more information, see the [documentation](https://docs.hyva.io/hyva-commerce/features/cms/extending-for-other-content-types.html#44-automatic-csp-frame-policies).

#### Changed

- Improved template override logic for components overridden in `hyva_cms/components.json` to prefer JSON defined template paths and falling back to the stored paths. Includes support for variant and legacy templates.
- Update Alpine Dialog to `v2.2.1`
- Bump `hyva-themes/magento2-cms-tailwind-jit` version dependency to `^1.2.4` to ensure Tailwind JIT iframe receives CSP frame-ancestors header when previewing version history by appending parent window `editor_view` hash parameters. Required for 'Automatic strict CSP frame-ancestors header for multi-domain setups' feature adding in this release.
- Better-looking sidebar (ellipsis / animate)
- Building CMS page URLs from identifier, avoiding an extra trailing slash
- Replaced `rakit/validation` with `magewirephp/validation`, a fork to support PHP 8.4
- Added support for Hyvä 1.4 and Tailwind 4
- Updated Hyvä theme detection to support `>=1.4.0` and older versions, supporting both service class check and legacy theme inheritance checks
- Editor preferences declared using XML
- Component selector built with AlpineJS instead of PHP
- Component selector bypassed if there's only 1 available component
- Optimised richtext file
- Refactored JavaScript template organization and moved to `page/js/utils` directory for better maintainability and reusability, specifically with admin dashboard widgets which require date formatting functionality.
- Enabled Page Builder migration tool by default for new installations. Can be disabled in the stores configuration or editor preferences.
- Added better Tailwind 4 support.
- Image sizes for components with fixed size images. Without this change, images are only scaled down by the browser, but loaded in full size. The image type (second param of getResponsiveImageData) isn't implemented yet and has no effect. Effected components: usp/card, usp/icon, usp/compact, testimonial/card, testimonial/simple.

#### Fixed

- Fixed USP icon image compression when text content is long.
- Fixed local time formatting for version history
- Broken CMS pages in link handler dropdown
- Link handler dropdown width being too small
- Prevent panel closure via Escape key while a modal is open.
- Add missing `>` entity decoding in JitCssProcessor to properly handle escaped greater-than symbols in Tailwind CSS classes
- Fixed infinite loop in Tailwind CSS prepending when previewing version history with Hyva CMS disabled and existing PageBuilder content
- JSON Schema validity check for version-history
- Stop deleting siblings children when child is cut from component sidebar
- Sync issues between component tree Magewire and Alpine (switch Alpine usage to vanilla JS)
- Missing semicolons from Alpine attribute field for colorpicker
- Optimised findComponentByUid to use utility which also caches
- Redirection to dashboard from Liveview editor when content does not exist
- Fix initial skip for CSP content updates to consider non-empty content
- Fix previewUrl for configured home page path so that `cms_index_index` layout handle is applied
- Fixed cache invalidation for CMS blocks in admin editor. Newly created or deleted CMS blocks now appear/disappear immediately in the editor CMS block's component dropdown without requiring manual cache refresh.
- Quill link overflow issue
- Overflow dialog overflow issue
- Fix drag-and-drop with object-based children. Handle children stored as objects in component search and convert to array when updating.

#### Removed

- Default values in the banner templates
- Shadow effect removed when clicking on component (only shown when dragging)

### [1.0.1](https://gitlab.hyva.io/hyva-commerce/module-commerce/-/compare/1.0.0..1.0.1) - Commerce Module

#### Added

- `is_admin_login_page` Layout XML argument to manage the selection and output of the default or login logos on an admin page, and set the login logo to be used on all pages that include the `admin_login` handle.

#### Changed

- Updated the (now deprecated) admin branding method (`\Hyva\Commerce\ViewModel\AdminBranding::isAdminLoginPage`) that checks whether to use the default admin logo or login admin logo to include a condition for 2FA pages, for backwards compatibility.
- Updated the `Hyva_Commerce::page/header.phtml` template to use the new `is_admin_login_page` layout handle argument instead of the deprecated admin branding method.

## [1.0.1](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/1.0.0...1.0.1) - 2025-08-26

The `1.0.1`release for Hyvä Commerce includes various features, bug fixes and improvements.

Please see the [release notes](upgrading-to-1.0.1.html) for more details.

### [1.0.1](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/1.0.0...1.0.1) - Hyvä CMS

#### Added

- Page Builder migration tool

### Changed

- Updated package.json with scoped name and correct main file so that it can be imported more easily
  when customizing the Liveview editor css from another module.
  Many thanks to Antoni Tormo (onestic) for the contribution!
- Updated design for version history.
- Header for image handler.
- Menu string/icon/position changes.

### Fixed

- Form key check for Liveview editor when using custom admin URL.
- Ensure unique block name for CMS page Liveview editor to prevent ID conflicts on some environments (likely due to installed modules).
- Fixed preview query for content AJAX endpoint on new content creation.
- Move CMS block and page plugin declaration from global `etc/di.xml` to `etc/frontend/di.xml` to prevent area code errors during setup:upgrade when B2B `AddAccessViolationPageAndAssignB2CCustomers` data patch is being applied.
- Fixed 404 redirection on invalid emptypreview & pagepreview requests.
- Fixed issue with theme selection on CMS page core settings.
- Corrected validation rules for CMS page core settings.
- Preserve existing links when reopening rich text editor.
- Fix missing class option in Banner.
- Deleted products/cms/categories will no longer give error on update.

### [1.0.1](https://gitlab.hyva.io/hyva-commerce/module-image-editor/-/compare/1.0.0..1.0.1) - Image Editor

#### Added

- Dispatch an event after the uploading (saving) of an edited image to allow for external, decoupled extensibility.

## [1.0.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.6.0...1.0.0) - 2025-07-11

`1.0.0` is the first General Availability release for Hyvä Commerce that includes various features, bug fixes and improvements.

Please see the [release notes](upgrading-to-1.0.0.html) for more details.

### [1.0.0](https://gitlab.hyva.io/hyva-commerce/theme-adminhtml/-/compare/0.1.1..1.0.0) - Admin Theme

#### Added

- SVG loader image to match the one used in Hyvä Theme
- Missing arrow icon files
- Improved responsiveness of styles at tablet size breakpoints
- Translation CSV file

#### Changed

- Directory restructure and CSS refactoring for better support of child/alternate theme variations
- Various color and layout CSS updates to improve extensibility

#### Fixed

- Styling fixes to improve output when using [RedChamps Clean Admin Menu](https://github.com/redchamps/clean-admin-menu)
- Margin issue when adding sub groups to menus with top-level items only
- Vendor icons visibility in system configuration
- Alignment of chevron icons

#### Removed

- A number of styling fixes that addressed issues in the child Mage-OS theme have been removed as they are included in the [Mage-OS M137 Admin Theme `1.2.0` release](https://github.com/mage-os-lab/theme-adminhtml-m137/releases/tag/1.2.0).

### [1.0.1](https://gitlab.hyva.io/hyva-commerce/module-admin-theme/-/compare/1.0.0..1.0.1) - Admin Theme Module

#### Fixed

- Update LICENSE file to latest version
- Add missing `module.xml` `<sequence/>` for `MageOS_ThemeAdminhtmlSwitcher`

### [1.0.0](https://gitlab.hyva.io/hyva-commerce/module-commerce/-/compare/0.1.3..1.0.0) - Commerce Module

#### Added

- Translation CSV file

#### Changed

- Simplified `system.xml` translatable strings for admin logo image upload fields

#### Removed

- TODO comment for missing logo variations that were added in the previous release
- `module.xml` `<sequence/>` for `MageOS_ThemeAdminhtmlSwitcher` (now in `Hyva_AdminTheme` module)

### [1.0.0](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/0.6.0...1.0.0) - Hyvä CMS

#### Added

- Image lazy loading field for 'Testimonial' and 'USP' components
- Translation CSV file
- Support for default LucideIcons included in magento2-theme-module:1.3.15 module
- Fallback system for icons (it will fallback to magento2-theme-module icons if not found in the module)
- Support for media optimisation (Hyvä Commerce)
- Lazy loading field added to Testimonials and USP components as missing and deemed important for performance
- Whitelist functionality for fields not mapped in `components.json` (e.g. `user_defined_name`)
- Heading tag selection for `Slider` component
- Improvements for CMS Blocks store switcher

#### Changed

- All image output (for 'Image', 'Banner', 'Testimonial' and 'USP' components) now uses the `\Hyva\Theme\ViewModel\Media::getResponsivePictureHtml()` method added in the [Hyvä Theme `1.3.15` release](../../hyva-themes/upgrading/upgrading-to-1-3-15.html)
  - This provides the base for future integration for the Hyvä Commerce Media Optimisation functionality, without requiring a hard dependency
  - `\Hyva\CmsLiveviewEditor\Block\Element::processImage()` method has been deprecated as part of this implementation as is no longer required
  - The previously deprecated 'CTA' and 'Banner (basic)' templates have not been updated and still use the above deprecated method
- Changed Link Button variant `none` to `as link` to be consistent with the Banner CTA styles
- Moved icons to the `Hyva_CmsLiveviewEditor::svg/lucide` directory.
- Refactoring and method additions made to the \Hyva\CmsLiveviewEditor\Block\Element class to provide support
- Slideouts now full height (page settings / components edit)
- Refactored store switching logic in liveview editor controllers to be more reliable. This was working previously but not on all environments.

#### Fixed

- Issue where 3rd party modules that inject incompatible scripts via default.xml layout handle (e.g., RequireJS) were breaking the liveview editor.
  e.g. [Mageplaza\_Core::js/help.js](https://github.com/mageplaza/module-core/blob/v1.5.13/view/adminhtml/layout/default.xml#L25)
- Filter page assets added to the head section in liveview editor.
- Add custom liveview-empty.xml page\_layout to prevent 3rd party modules adding assets to the body section.
  This is a **backward-compatibility breaking change**. If you have customized the Hyva CMS Editor admin page and added assets via the `liveview_editor_index.xml` layout handle,
  you must whitelist those assets in the PageConfigStructurePlugin's allowedAssets array via di.xml. See `liveview-editor/etc/adminhtml/di.xml`q for an example.
- The 'Link' field now uses URL rewrites for product and category links, resolving issues with 404s where URL suffixes or custom URL rewrites were added
- Removed translatable strings from the Height source model as numeric values and '0' value causes `bin/magento i18n:collect-phrases` to error
- Fix duplicate block ID error for CMS Block component (affected certain environments only)
- Issue of full Varnish cache flush when publishing CMS content by replacing direct fullPageCache->clean($tags) calls with clean\_cache\_by\_tags event dispatch,
  avoiding adminhtml\_cache\_refresh\_type trigger down the stack.
- Issue where the content state was not set correctly when a new page was created from the editor without any content added.
- Fix preview interactivity after restoring version history item.
- CTA component and old Banner template ignored as have been deprecated
- Type errors in `Element.php`
- Select All now selects top level items
- Text truncation in store switcher
- Fix handle missing form\_key in iframe version preview requests for TW JIT Content update

#### Removed

- Redundant cache handling logic from `Hyva\CmsMagento\Model\CoreSettings\Block` as it is handled in the repository save method.
- Removed duplicated icons stored in the `Hyva_CmsLiveviewEditor::svg/lucide` directory.

### [1.0.0](https://gitlab.hyva.io/hyva-commerce/module-image-editor/-/compare/0.1.0..1.0.0) - Image Editor

#### Added

- Notice to module configuration to denote the 'new' media gallery is a requirement

#### Changed

- Image editor background now uses a checkerboard effect to better support different background colors in admin themes
- Various CSS enhancements to better support inheritance of colors from the active admin theme

#### Fixed

- Images are now loaded into the image editor using the admin URL, resolving a CORS issue when admin URL differs to the storefront

#### Removed

- Translations from the CSV file that were not unique to this module

## [0.6.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.5.2...0.6.0) - 2025-06-26

`0.6.0` is a feature and compatibility release for Hyvä CMS that introduces significant improvements, performance optimizations. This release includes backward-compatibility breaking changes that require updates for custom content type extensions and custom components using children fields.
Please see the [release notes](upgrading-to-0.6.0.html) for more details.

### [0.6.0](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/0.5.0...0.6.0) - Hyvä CMS

#### Added

- Added Tailwind safelist to `tailwind.config.js` and updated JIT compiler to remove safelist classes from generated stylesheets.
  i.e. removes the `prose` class from the generated stylesheets as it include a lot of style rules which already exist in most themes.
- Support for PHP 8.4
  For more information, please refer to [merge request #182](https://gitlab.hyva.io/hyva-commerce/module-cms/-/merge_requests/182).
- A unique liveview\_preview key per version history item
  This is **backward-compatibility breaking change**.
  Projects that have extended Hyvä CMS for [custom content types](../features/cms/extending-for-other-content-types.html)
  must update their `Hyva\CmsLiveviewEditor\Api\ProviderInterface` implementations to be compatible with this version.
- A signout dialog which is shown when admin session ends, the session checks are by `session_lifetime` timeout or invalid request responses.
- Additional checks to the content generation controller for additional validation of the request.
- `renderBlockId` utility class in `Element.php`
- `"require_parent"` option in components to hide from full list, this can be show if a parent passes it in "accepts"
- Image dimensions to the image component.
- Added info message in settings slideout to clarify that saving content settings updates both the draft preview and the enabled storefront block/page.
- Cache for components list `hyva_cms`
  - Patch implemented to enable on production/default mode (disabled on developer)
  - Caches all collected components (components.json)
- Tooltip utility class to ensure tooltip starts from other side
- Re-added generate urls command
- Batching Url requests (UrlBatchProcessor)

#### Changed

- Formatting of changelog to match the Hyvä documentation, i.e. use `*` instead of `-` for bullet points.
- Moved component template variants from JSON to PHP source models for better plugin extension support.
- Updated components
  - Columns (text + bg color)
  - Html (classes + block id)
  - Slider (default block id + multiple instances)
  - Product slider (classes)
  - Testimonial (block id)
  - Cta (heading/paragraph colors + loading to advanced)
  - Cms block (remove bg color)
  - Banner (alignment, remove color, add heading/subtitle color, remove default typography)
  - Text (block id + classes)
  - Spacer (block id change + classes)
- Changed how children fields are declared in the components.json file.
  Children fields must now be declared at the root level of the component declaration instead of within the content section.
  This enforces the logical hierarchy and prevents UI issues.
  This is a **backward-compatibility breaking change**. Projects with custom components using children fields must update them to follow the new schema.
  See [upgrade documentation](upgrading-to-0.6.0.html) for migration assistance.
- Moved page/block settings tab to slideout (seperated from main)
- Updated UX (focus states for header buttons)
- Refactor preview url params to use `liveview_preview` instead of both `key` & `is_liveview_preview`
- Changed default value of ***heading*** component to `h2` from `h1`.
- Introduced a Call to Action (CTA) component as a variant of the banner
  - Includes both Split and Text layout options
- Added configurable text and content alignment options for banner elements.
- Enhanced banner functionality to support Button components, with a fallback to standard link behavior.
- Refactored JIT CSS classes.
  This is **backward-compatibility breaking change**.
  Projects that have extended Hyvä CMS for [custom content types](../features/cms/extending-for-other-content-types.html)
  and which support Tailwind JIT must update their implementations to use `Hyva\CmsLiveviewEditor\Model\Tailwind`.
- Uses native checkbox as switch/boolean toggle instead of a button
- Replaces JS accordion in Page/Block settings for Native HTML Details Accordion
- UX improvements, related to A11Y, including more consistency in button styles
- Component Panel close button icon, to avoid having two x icons close to each other
- Magento constants for filter values
- Move Url Models to `Model/Url` folder
- Refactored status indicator in the header to use different colours and to give more meaningful information.

#### Fixed

- Bug where draft content for blocks were being shown in page preview.
- Text change in header of widget handler
- The Liveview editor setting is no longer disabled when saving CMS Pages or Blocks when the `is_liveview_enabled` key is not present in the payload.
  This provides compatibility when using Adobe Commerce Content Staging to schedule updates for other block/page settings (i.e. excluding Hyvä CMS content)
  as well when pages/blocks are saved via other methods (e.g. custom code or via APIs).
- Issue where image dimensions were not being preserved when the same image was selected in the image handler.
- Double aria alert announcement fix
- Fix empty preview toggle component list button to be CSP compatible
- Children quick actions add button passes accepts correctly
- Overflow issue with tooltip on right side
- CORS issue for some multi-site setups by reverting to using admin domain for building ajax endpoint to generate content.
- Fix TW JIT issue where classes which included the characters `&` and `,` were not being applied properly to the generated CSS.
- Contrast A11Y issues with colors
- Fixed extra label in icons
- Link handler `selectbox`, by using interactive element
- Landmarks with proper tag and labels
- Tooltip label value, now uses the aria-label for visual users only, so it is not used double.
- Better indent `liveview.phtml` file
- Fix `z-index` to show header dropdowns while component slide-out is open
- Copy paste issue with children (component ordering issue)
- Link tooltip fix
- Added missing block id to spacer
- Url Params fix (force string)
- Bumped cms-tailwind-jit to resolve an issue preventing the TW JIT iframe from loading on the storefront for compiling version history CSS, especially in cross-domain Admin/Storefront or CSP-restricted setups.

#### Removed

- Legacy patching tool (legacy items will be handled automatically instead of a manual patch)
- Tabs in sidebar
- CTA component declaration
- Unrequired filter class usage

## [0.5.2](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.5.1...0.5.2) - 2025-06-20

`0.5.2` is a bug fix release for the Hyvä Admin Theme and base `Hyva_Commerce` module that addresses issues from the previous version. Please see the [release notes](upgrading-to-0.5.2.html) for more details.

### [0.1.3](https://gitlab.hyva.io/hyva-commerce/module-commerce/-/compare/0.1.2..0.1.3) - Commerce Module

#### Removed

- The default value to make the Hvyä Commerce Admin Theme the 'active admin theme' has been removed from `etc/config.xml`

### [0.1.1](https://gitlab.hyva.io/hyva-commerce/theme-adminhtml/-/compare/0.1.0..0.1.1) - Admin Theme

#### Changed

- The admin theme now depends on the `Hyva_AdminTheme` module and no longer depends on the `Hyva_Commerce` or `MageOS_ThemeAdminhtmlSwitcher` modules, as these are dependencies of the `Hyva_AdminTheme` module

### 1.0.0 - Admin Theme Module

#### Added

- The default value to make the Hvyä Commerce Admin Theme the 'active admin theme' has been added to `etc/config.xml`
- Dependency on the `Hyva_Commerce` and `MageOS_ThemeAdminhtmlSwitcher` modules

## [0.5.1](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.5.0...0.5.1) - 2025-06-17

`0.5.1` is a feature release for initial versions of Image Editor and Admin Theme. Please see the [release notes](upgrading-to-0.5.1.html) for more details.

### [0.1.2](https://gitlab.hyva.io/hyva-commerce/module-commerce/-/compare/0.1.1..0.1.2) - Commerce Module

#### Added

- Set Hyvä Commerce Admin Theme as default
- Hyvä Commerce default admin logos
- Ability to add custom login, menu and favicon admin logos

### 0.1.0 - Image Editor

#### Added

- Integration of [Filerobot Image Editor](https://github.com/scaleflex/filerobot-image-editor) into the Magento Media Gallery
- Ability to save duplicates and revert to original images
- Hyvä CMS support

### 0.1.0 - Admin Theme

#### Added

- Admin theme based on the [Mage-OS 137 Admin Theme](https://github.com/mage-os-lab/theme-adminhtml-m137)

## [0.5.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.4.0...0.5.0) - 2025-06-04

`0.5.0` is a bug fix release for Hyvä CMS that addresses issues from the previous version. Please see the [release notes](upgrading-to-0.5.0.html) for more details.

### [0.5.0](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/0.4.0...0.5.0) - Hyvä CMS

#### Added

- Nothing

#### Changed

- quill downgrade 2.0.3 to 2.0.2 to fix   issue in richtext component.
  REF: https://github.com/slab/quill/issues/4509
- Refactor store switcher into reusable component to be used in both toolbar and version history.

#### Fixed

- Undefined array key in usp variants
  Many thanks to **Klaas van der Weij (Sparkable)** for the contribution!
- CSS cascade conflict where JIT-generated classes, e.g. `cmsp1_flex`, overrode template Tailwind classes, e.g. `lg:grid`, breaking responsive layouts.
  This is a **backward-compatibility breaking change**. Projects that have extended Hyvä CMS for [custom content types](../features/cms/extending-for-other-content-types.html) must now call the TailwindCssJit::processContentWithStyles() method rather than TailwindCssJit::prependContentStyles().
  JIT styles are now injected in the head section before the main stylesheet to preserve proper CSS cascade order.
- HyvaCompatibleOptions now only excludes Hyva/reset theme from design options. The preview store view allows all themes which are based on a Hyva theme including Hyva/reset, unless `restrict_preview_to_hyva_themes` is disabled.
- JavaScript destructuring error in image handler when imageOptions is null

## [0.4.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.3.0...0.4.0) - 2025-05-29

`0.4.0` is a feature and maintenance release for Hyvä CMS which introduces Tailwind JIT compilation support, an much improved link field, several bug fixes and improvements. Please see the [release notes](upgrading-to-0.4.0.html) for more details.

### [0.4.0](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/0.3.0...0.4.0) - Hyvä CMS

#### Added

- Component visibility control to show components in editor but hide them on frontend
- Cut in the toolbar
- Cut components from the quick actions
- Copy components from the quick actions
- Add children direct from the quick actions
- New controllers to fetch values for the link handler
- New options in link handler
- Command to patch data for Hyva Liveview version upgrades
- Improvements to layout rendering
- Added "Edit - Hyvä CMS" option to the beginning of actions column in the CMS Pages and CMS Blocks grids.
- Image editor event to open/close the image handler sidebar
- Config option to restrict preview to Hyva themes only. As only Hyva themes are supported in the editor at the moment it is enabled by default.
  Until Luma themes are supported this setting can only be changed in config file rather than from the admin panel.
- Search as you type filter to the store switcher

#### Changed

- Switch Tailwind JIT compilation to use hyva-themes/magento2-cms-tailwind-jit for consistency across Hyvä products, class prefixing, custom config/CSS support,
  support for multiple themes, better scalability and portability.
  This is **backward-compatibility breaking change**. Projects that have extended Hyvä CMS for
  [custom content types](../features/cms/extending-for-other-content-types.html) must update their
  `Hyva\CmsLiveviewEditor\Api\ProviderInterface` implementations to be compatible with this version.
- Simplified liveview preview content loading on Magento admin forms using just a postMessage, AJAX call was redundant.
- Used consistent Page loaders and messages across the editor matching brand colour guidelines.
- Enhanced message system with dynamic status updates for improved user feedback. Maintained legacy events.
- Removed the custom breakpoint options from the spacer component and replaced them with tailwind default values.
- Replaced text color on the accordion component with seperate heading and content color settings on accordion items.
- Refactored USP to component to include text and background colors.
- Added text color options to the testimonial componenet.
- Updated UX for the link handler
- Updated component templates to use the new link handler
- Using controllers instead of GraphQL for handlers
- Minor UX updates to the image handler
- Add prose class to richtext component by default

#### Fixed

- Sharable Preview URLs which were over a day old.
- Duplicate layered nav filters when a Hyvä CMS block is used on the page
- Slider component layout bug using previous method for adding children
- Removed the custom breakpoint options from the spacer component and replaced them with tailwind default values.
- Replaced text color on the accordion component with separate heading and content color settings on accordion items.
- Refactored USP to component to include text and background colors.
- Added text color options to the testimonial component.
- Sorting on CMS Pages and CMS Blocks magento admin listing grids.
- Newly created content in the editor from returning to a new page or block form in the magento admin. Now it returns to the correct page or block form.
- Removed logic setting the return URL from the editor. It is now handled by the Hyva\_CmsMagento integration module so that it may now be set by other integration modules.
  Default return paths are set in the editor incase integration modules do not set them.
- Update edited image preview to use a cache busting parameter to force reload the image.
- Fixed issue where bullet lists were not converted to ul tags in the richtext component.

## [0.3.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.2.0...0.3.0) - 2025-05-06

`0.3.0` is a feature release for Hyvä CMS that introduces new components, enhanced validation capabilities, and CSP support, along with several bug fixes. Please see the [release notes](upgrading-to-0.3.0.html) for more details.

### [0.3.0](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/0.2.0...0.3.0) - Hyvä CMS

#### Added

- Widget component
- CSP support for frontend scripts used by component templates.
- CSP support for liveview editor script for live updates to work with a Hyvä CSP theme.
- Improvements to field validation.
- Option to use data-[validation rule] attribute to avoid browser API validation.
- Options to use data-[validation-message] attribute to set custom validation messages.
- Feature to allow preview editor to focus on non-input as well as input fields when editing content.
- Gitlab issue templates

#### Changed

- Stop closing modals when clicking the backdrop
- Move block\_id to advanced section in all components
- Added **none** option the the button component
- Synced Slider Basic styles with UI version
- Field types now require wrapping in a `#field-container-[uid]_[field name]` div for frontend validation.
  This is **backward-compatibility breaking change** for any custom field type templates which may have been added to your project.
  See the documentation for more information how to create a [custom field type template](../features/cms/creating-custom-component-fields-types.html#creating-the-custom-field-type-template).

#### Fixed

- Validation for cms\_block `preview_url_key` to allow .html suffix
- Preview url validation caused by category id conflict with Hyvä CMS entity id
- Removed random JS debugger statement
- Translate a string (All)
- Fix JSON in Alpine.js x-data attributes breaking during CMS directive processing
- Preview handling to support CSP-compliant themes
- Empty href in button component
- Fix to validate against the correct value array vs string for links, images, etc.
- Fix formatting & positioning of error messages to work better with frontend validation. Allows custom positioning of error messages.
- Fixed issue where duplicate element IDs could occur in ROOT.phtml by moving child block rendering logic to a ViewModel, ensuring compatibility regardless of block class.
- Specificity for Columns Component styles, allowing custom style override
- Fixed issue caused by typo in iframe message type check, causing invalid preview URL message to be shown

## [0.2.0](https://gitlab.hyva.io/hyva-commerce/metapackage-commerce/-/compare/0.1.0...0.2.0) - 2025-04-17

`0.2.0` is a maintenance release, mostly focused on bug fixes. Please see the [release notes](upgrading-to-0.2.0.html) for more details.

### [0.2.0](https://gitlab.hyva.io/hyva-commerce/module-cms/-/compare/0.1.0...0.2.0) - Hyvä CMS

#### Added

- CSP Support to snap slider plugin, to avoid any errors in the checkout & Hyvä CSP Default Theme

#### Changed

- Accordion component refactoring & renaming
  This is a **backward-compatibility breaking change**
  Please refer to the [0.2.0 upgrade notes](upgrading-to-0.2.0.html) for more information on how to upgrade
- Composer requirements to allow Symfony HTTP Foundation 7.0 for Magento 2.4.8 compatibility

#### Fixed

- Hyvä theme module dependency in composer.json
- Stray JavaScript debug statement
- Show correct status when new content is created i.e. save/draft
- Show warning when content is enabled but has no published version
- Incorrect warning: "Your changes are published, but the content is disabled" shown when new content is created and not yet published
- Regex validation for page settings on `url_key` to allow underscores
- PHP 8.3 issue where null values in regex validation triggered `preg_match()` deprecation exception in Magento 2.4.8
- Magewire compatibility with store codes in URLs

## 0.1.0 - 2025-04-11

`0.1.0` is the initial Early Access Release of Hyvä Commerce. Please see the [release notes](release-0.1.0.html) for more details.

### 0.1.0 - Hyvä CMS

#### Added

- All initial features of our new CMS solution
- See the [release notes](release-0.1.0.html) for more details

#### Changed

- Nothing changed

#### Removed

- Nothing removed

### [0.1.1](https://gitlab.hyva.io/hyva-commerce/module-commerce/-/compare/0.1.0..0.1.1) - Hyva\_Commerce

#### Added

- Ability to include Alpine.js within the Admin Panel (via Layout XML handle)
- Extension point for including Hyvä Commerce related messaging via section data (no messaging implemented at this time)
- Abstract Type Factory and Type Mismatch Exception classes (will be utilised as part of Admin Dashboard)

#### Changed

- Nothing changed

#### Removed

- Nothing removed
