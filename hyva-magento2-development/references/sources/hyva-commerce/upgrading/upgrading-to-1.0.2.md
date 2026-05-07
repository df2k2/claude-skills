<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-1.0.2.html -->

# Upgrading to Hyvä Commerce 1.0.2

The `1.0.2` release for Hyvä Commerce introduces scheduling functionality for Hyvä CMS content, allowing content to be scheduled for future publication, along with many improvements and various bug fixes for Hyvä CMS.

## Notable news

### Hyvä CMS

#### Scheduling

Hyvä CMS now has support for scheduling content for publication at a later date, including the ability to schedule multiple pages and blocks in the same release wit shareable previews, and the ability to edit scheduled content! 📆

⚠️ **Important:** Projects which have [extended Hyvä CMS for custom content types](../features/cms/extending-for-other-content-types.html)
should update their implementations to support the new scheduling functionality. The following changes are required:

- URL Parameter Handling: Custom content type providers must now handle the `scheduled_item` URL parameter to render scheduled content when present. See `Hyva\CmsMagento\Plugin\Model\Page` for implementation reference.
- Layout Handle Update: Custom field templates should now use the `liveview_editor.xml` layout handle instead of `liveview_editor_index.xml`.
- Provider Interface Updates: It is recommended to include `the scheduledItemId` parameter in the `Hyva\CmsLiveviewEditor\Api\ProviderInterface::getStoreContentData()` method implementation to support scheduling.
- Scheduling Interface Implementation: Custom content type providers must implement `Hyva\CmsScheduling\Api\ScheduleProviderInterface` to enable scheduling capabilities for their content types.

#### Multi-domain Improvements

Multi-store/domain setups are now auto-configured, Hyvä CMS no longer needs manual CSP settings to be applied.
For more information, see the [documentation](../features/cms/installation.html#multi-store-domain-custom-admin-domain-setup).

#### Editor UI Improvements

Multiple editor UI enhancements, including the ability to switch between pages and blocks via the newly added sidebar, a larger editing modal for richtext fields etc.

### Hyvä Commerce

#### Deprecation: Admin Branding Login Page Login Method

The `\Hyva\Commerce\ViewModel\AdminBranding::isAdminLoginPage` method is now deprecated in favor of a Layout XML argument (and handle) based approach for determining which admin logo to display (default or login), which resolves an issue where 2FA pages displayed the wrong logo.

## Changelogs

The changelog is available [here](changelog.html#102-2025-11-11).

## Known Issues

- None so far
