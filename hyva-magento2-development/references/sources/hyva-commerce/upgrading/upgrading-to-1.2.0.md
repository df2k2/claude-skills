<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-1.2.0.html -->

# Upgrading to Hyvä Commerce 1.2.0

The `1.2.0` release for Hyvä Commerce introduces the GA (General Availability) versions of the Admin Dashboard and Media Optimisation features

## Notable news

Admin Dashboard `1.0.0` revitalizes the Magento admin panel's dashboard. It contains our initial batch of widgets. Dashboards are user specific, allowing admin users to display the data relevant to them, with the ability to configure options, resize and reorder every widget instance. See our [Admin Dashboard Widgets](../features/admin-dashboard/devdocs/widget-types/available-types.html) page for more details.

Media Optimisation `1.0.0` adds the ability to automatically replace images across the storefront, along with a developer API. Images can be resized to admin configurable sizes, and converted to WebP and AVIF formats. It includes support for animated GIFs (as WebP), the GD and Imagick image libraries, logging, along with a huge range of admin configuration, as well as a system check tool to ensure your server meets the minimum requirements.

### Admin Dashboard

There are a number of backwards-incompatible changes for the admin dashboard module(s). Below are a list of affected
components, how they have been changed, and the steps required to update any customizations or widget implementations.

#### Widget Type Interface

**Class:** `Hyva\AdminDashboardFramework\Model\WidgetType\WidgetTypeInterface`

##### Added

- `getTitle(?WidgetInstanceInterface $widgetInstance)` function originally only declared in the `AbstractWidgetType` class
- `getProperties(string $propertyType)` function to replace separate `getConfigurableProperties` and `getDisplayProperties` functions
- `getPropertyByName(string $propertyType, string $propertyName)` function to replace separate `getConfigurablePropertyByName` and `getDisplayPropertyByName` functions
- `getTrailingAction(?WidgetInstanceInterface $widgetInstance)` function to provide trailing action configuration array
- Constants to reference new configuration keys
  - [`cache_lifetime`](../features/admin-dashboard/devdocs/widget-types/xml.html#cache_lifetime)
  - [`full_screen`](../features/admin-dashboard/devdocs/widget-types/xml.html#full_screen)
  - [`trailing_action`](../features/admin-dashboard/devdocs/widget-types/xml.html#trailing_action)
- Constant to reference the default widget category name

##### Changed

- `getDisplayData()` parameter is no longer nullable, a `WidgetInstanceInterface` object is now required

##### Removed

- `getConfigurablePropertyByName()` and `getDisplayPropertyByName()` functions
  - These are replaced by the aforementioned generic `getPropertyByName()` function

##### Updating

Any class implementing `WidgetTypeInterface` directly must:

- Add `getTitle(?WidgetInstanceInterface $widgetInstance): Phrase`
- Add `getProperties(string $propertyType): array`
- Add `getPropertyByName(string $propertyType, string $propertyName): ?array`
- Add `getTrailingAction(?WidgetInstanceInterface $widgetInstance): array`
- Change `getDisplayData()` parameter from nullable to non-nullable
- Remove `getConfigurablePropertyByName()` and `getDisplayPropertyByName()`

#### Abstract Widget Type

**Class:** `Hyva\AdminDashboardFramework\Model\WidgetType\AbstractWidgetType`

##### Added

- Added new `?WidgetInstanceInterface $widgetInstance` parameter to the `getTitle()` function
- Default implementation for the `getProperties()` function which returns the input properties by key
- Default implementation for the `getPropertyByName()` function which returns the input property of a given type and name
- Default implementation for the `getTrailingAction()` function which returns an array of link data for the trailing action feature

##### Changed

- Updated the constructor to replace the `Magento\Backend\Model\Auth` and `Magento\Framework\AuthorizationInterface` dependencies with `Hyva\AdminDashboardFramework\Model\WidgetAuth`
  - Also replaced uses of the former dependencies in the `isAllowed()` function with calls to the relevant functions in the `WidgetAuth` class
- The `getDisplayData()` function is now abstract, rather than returning `null`

##### Removed

- Default/global `description` display property
- `getConfigurablePropertyByName()` function
- `getDisplayPropertyByName()` function

##### Updating

Classes extending `AbstractWidgetType` must:

- Update the constructor to pass `WidgetAuth` and `WidgetConfig` (in that order) to `parent::__construct()`
- Replace any `$this->adminAuth` with `$this->widgetAuth->getAdminAuthModel()`
- Replace any `$this->requestAuth` with `$this->widgetAuth->getRequestAuth()`
- Implement `getDisplayData(WidgetInstanceInterface $widgetInstance)` if not already
- If relying on the previously default `description` display property, add it to the widget type's `getDisplayProperties()` override

#### Widget Instance Interface

**Class:** `Hyva\AdminDashboardFramework\Model\WidgetInstance\WidgetInstanceInterface`

##### Added

- `getPropertyValues(string $propertyType)` function to replace separate `getConfigurablePropertyValues` and `getDisplayPropertyValues` functions
- `getPropertyValue(string $propertyType, string $propertyName)` function to replace separate `getConfigurablePropertyValue` and `getDisplayPropertyValue` functions

##### Changed

- Nothing changed

##### Removed

- `getConfigurablePropertyValues()` and `getDisplayPropertyValues()` functions
  - These are replaced by the aforementioned generic `getPropertyValues()` function
- `getConfigurablePropertyValue()` and `getDisplayPropertyValue()` functions
  - These are replaced by the aforementioned generic `getPropertyValue()` function

##### Updating

Any class implementing `WidgetInstanceInterface` directly must:

- Replace all calls to `getConfigurablePropertyValue('foo')` with `getPropertyValue(WidgetTypeInterface::KEY_CONFIGURABLE_PROPERTIES, 'foo')`
- Replace all calls to `getDisplayPropertyValue('foo')` with `getPropertyValue(WidgetTypeInterface::KEY_DISPLAY_PROPERTIES, 'foo')`

#### Widget Instance Model

**Class:** `Hyva\AdminDashboardFramework\Model\WidgetInstance\WidgetInstance`

##### Added

- New constructor argument `Hyva\AdminDashboardFramework\Model\Cache\Type\AdminDashboard $adminDashboardCache`
- Implementation for the `getPropertyValues()` function which returns the input property values by key
- Implementation for the `getPropertyValue()` function which returns the input property value of a given type and name

##### Changed

- `getDisplayData()` function now takes a boolean `$loadFromCache` argument, which defaults to `true` and determines whether to serve the display data from the `hyva_admin_dashboard` cache

##### Removed

- `getConfigurablePropertyValues()` function
- `getDisplayPropertyValues()` function
- `getConfigurablePropertyValue()` function
- `getDisplayPropertyValue()` function

##### Updating

If you have overridden or decorated `WidgetInstance`, inject `AdminDashboardCache` and update the `getDisplayData()`
signature to make the parameter non-nullable.

#### Base Widget Classes

**Classes:**
- `Hyva\AdminDashboardBaseWidgets\Model\Widget\BarChart`
- `Hyva\AdminDashboardBaseWidgets\Model\Widget\LineChart`
- `Hyva\AdminDashboardBaseWidgets\Model\Widget\Number`
- `Hyva\AdminDashboardBaseWidgets\Model\Widget\PieChart`

##### Added

- Nothing added

##### Changed

- Defined each of the aforementioned classes as abstract

##### Removed

- Nothing removed

##### Updating

Update any of your references to the base classes mentioned above to add the `Abstract` prefix to their class names.

#### Widget Configuration

##### Added

- `cache_lifetime` XML configuration option
- `full_screen` XML configuration option
- `trailing_action` XML configuration option
- Added new `$defaultCacheLifetime` constructor argument to `Hyva\AdminDashboardFramework\Model\Config\Widget\Converter`
- Added new `$categoryNames` constructor argument to `Hyva\AdminDashboardFramework\Model\Config\Widget\Converter`

##### Changed

- Configuration file renamed from `dashboard_widget.xml` to `hyva_dashboard_widget.xml`
- Fixed a bug that disallowed underscores in `<template>` values
- Require widget categories to be defined via `di.xml`

##### Removed

- Nothing removed

##### Updating

Rename any custom widget XML files from `dashboard_widget.xml` to `hyva_dashboard_widget.xml` and update their XSD
references.

#### Widget Display Types

##### Added

- New `table` display type

##### Changed

- Updated `checklist` widget configuration to use the `template` display type
- Updated `links` widget configuration to use the `template` display type
- Updated `text` widget configuration to use the `template` display type

##### Removed

- Dedicated `checklist` display type
- Dedicated `links` display type
- Dedicated `text` display type

##### Updating

If you created custom widgets using the `checklist`, `links`, or `text` display types, change them to use the `template`
display type instead and add an explicit `<template>` element to use the corresponding `Hyva_AdminDashboardBaseWidgets`
template file.

#### System Configuration

##### Added

- New section for toast message configuration
- New section for chart theme configuration

##### Changed

- Changed `hyva_admin_dashboard/general/widget_dashboard_position` to `hyva_admin_dashboard/general/dashboard_position`
- Updated default value for `hyva_admin_dashboard/general/keep_default` from `1` to `0`
- Updated default value for `hyva_admin_dashboard/general/dashboard_position` from `before` to `after`
- Updated default value for `hyva_admin_dashboard/developer/batching/max_batch_size` from `8` to `4`
- Updated default value for `hyva_admin_dashboard/developer/batching/max_concurrent_requests` from `1` to `3`

##### Removed

- Nothing removed

##### Updating

If you reference the admin dashboard configuration paths in your own code, update `widget_dashboard_position` to
`dashboard_position`.

### Hyvä Media Optimisation

#### Viewport Breakpoints

Media Optimisation's auto replace now supports configuring responsive image sizes based on viewport width, ensuring smaller screens receive appropriately sized images rather than full-resolution versions. This way images have a far better chance of being the right size for the viewport. Especially mobile pages will benefit from not loading images larger than the screen size.

Breakpoints are configured in Stores > Configuration > Hyvä Commerce > Media Optimisation > Viewport Breakpoints. Each row defines a minimum viewport width, an optional maximum viewport width, and the generated image width to serve for that range. Images are never generated larger than the original source.

Viewport Breakpoints are applied when using the [Developer API](../features/media-optimization/features/developer-api.html) or [Automatic Image Replacement](../features/media-optimization/features/automatic-image-replacement.html) in picture mode. They are not applied in simple replacement mode. For more information, see the [Viewport Breakpoints configuration documentation](../features/media-optimization/configuration.html#viewport-breakpoints).

#### Debug Logging

Because images are loaded on every page load a small error can result in logs filling up quickly. Because of this we moved the logs to a separate log file.

## Changelogs

The changelog is available [here](changelog.html#120-2026-03-16).

## Known Issues

- None so far
