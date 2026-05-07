<!-- source: https://docs.hyva.io/hyva-themes/compatibility-modules/technical-deep-dive.html -->

# Technical Deep-Dive

## Automatic Template Overrides

For Compatibility Modules only

This section describes the automatic template override functionality provided by the `hyva-themes/magento2-compat-module-fallback` extension.
This feature is intended for use in **Compatibility Modules** and does not apply to regular modules that are otherwise made Hyvä-compatible.

The compatibility module skeleton provided by the Hyvä team includes a dependency on `hyva-themes/magento2-compat-module-fallback`. This extension allows a module to be registered as a "compatibility module".

When a module is registered as such, its template directory is automatically injected into the design fallback path for the files from the original module. This allows overriding templates simply by creating a file with the same name in the compatibility module's `view/frontend/templates` directory, without needing extra layout XML.

### Example Scenario:

- **Original Module**: `Orig_Module`
- **Compatibility Module**: `Hyva_OrigModule`
- **Original Template**: `Orig_Module::example.phtml`

If the compatibility module contains a file at `view/frontend/templates/example.phtml`, this template will be used instead of the original one automatically.

### Overriding a Compatibility Template in a Theme

Templates from compatibility modules can be overridden in a theme. When doing so, the **original module name** must be used for the override path, because the automatic fallback mechanism does not change the template's declared module context.

- **Template Declaration**: `Mirasvit_Gdpr::cookie_bar.phtml`
- **Compat Module Template**: `Hyva/MirasvitGdpr/view/frontend/templates/cookie_bar.phtml`
- **Theme Override**: `app/design/frontend/Vendor/theme/Mirasvit_Gdpr/templates/cookie_bar.phtml`

### DI Configuration for Fallback

The initial DI configuration is included in the skeleton module. A module is registered by adding it to the `compatModules` argument of the `Hyva\CompatModuleFallback\Model\CompatModuleRegistry` type in `etc/frontend/di.xml`.

```
<type name="Hyva\CompatModuleFallback\Model\CompatModuleRegistry">
    <arguments>
        <argument name="compatModules" xsi:type="array">
            <item name="orig_module_map" xsi:type="array">
                <item name="original_module" xsi:type="string">Orig_Module</item>
                <item name="compat_module" xsi:type="string">Hyva_OrigModule</item>
            </item>
        </argument>
    </arguments>
</type>
```

### Price Renderer Templates

The automatic override does not work for price renderer templates. These must be overridden using layout XML.

## Tailwind Asset Merging for Compatibility Modules

Compatibility modules often need to add their own templates to a theme's Tailwind CSS content scan configuration or provide additional CSS rules. This process is handled by the `@hyva-themes/hyva-modules` npm package, which scans modules registered in `app/etc/hyva-themes.json`.

The way assets are merged depends on the files present in the module's `view/frontend/tailwind/` directory. There are two modes: a modern, unified approach and a legacy mode for backward compatibility.

### The Modern Approach (Recommended for Tailwind v4 Compatibility)

For full Tailwind v4 compatibility and a cleaner setup, the recommended approach is to provide a single `module.css` file in your module's `view/frontend/tailwind/` directory.

This file acts as the **single source of truth** for the module. When `module.css` is present, the build tool will **ignore** any `tailwind.config.js` or `tailwind-source.css` files in the same directory.

Your `module.css` file should contain:
1. `@source` directives to specify which files should be scanned for Tailwind classes.
2. `@import` statements for any additional CSS files within your module.

```
/* Example: view/frontend/tailwind/module.css */

/* 1. Add module templates to the content scan */
@source ../templates/**/*.phtml;
@source ../layout/**/*.xml;

/* 2. Import module-specific CSS files */
@import "./components/widget.css";
```

### The Legacy Fallback Method

If a `module.css` file is not found, the build tool reverts to a legacy mode to support older modules.
It will look for `tailwind.config.js` and `tailwind-source.css`.
The behavior then differs based on the theme's Tailwind version.

#### When used with a Tailwind v3 Theme:

- **`tailwind.config.js`:**
  The `purge.content` paths from this file are merged with the theme's configuration.
- **`tailwind-source.css`:**
  `@import` statements from this file are added to the theme's CSS build.

#### When used with a Tailwind v4 Theme:

- **`tailwind.config.js`:**
  If this file exists, the build tool adds a generic `@source` directive to scan all `.phtml` and `.xml` files within the module.
  It acts as a broad fallback and does not perform a deep merge of the config file.
- **`tailwind-source.css`:**
  `@import` statements from this file are added to the build.
  However, all paths inside this file **must be explicit relative paths**
  (e.g., `@import "./components/widget.css";`) to be compatible with the v4 compiler.
  For more details, refer to the [TailwindCSS Troubleshooting](../working-with-tailwindcss/troubleshooting.html#import-is-not-found-with-tailwind-v4).

While the legacy method provides backward compatibility, the modern approach using `module.css` is strongly recommended for all new development.

### Registering a module for inclusion in `hyva-themes.json`

The `app/etc/hyva-themes.json` file contains a list of all installed modules that should be scanned for tailwind configuration or tailwind CSS.

Compatibility modules that use automatic template overrides (via the `CompatModuleRegistry`) are registered automatically for tailwind compilation.

Tip

Refer to the dedicated documentation page about [registering a module for inclusion in the `hyva-themes.json`](../working-with-tailwindcss/registering-a-module-for-tailwind-compilation.html) file.

### Removing Modules from `hyva-themes.json`

Sometimes you may wish to omit a compatibility module from this file - to exclude their custom styles, for example.
There are a couple of ways to achieve this, depending on how the compatibility module has registered itself for
inclusion in the `hyva-themes.json` file.

#### Compatibility Module Registry

For compatibility modules that have registered themselves with the compatibility module registry, they can be removed
from the `hyva-themes.json` file by passing the module name to the `Hyva\CompatModuleFallback\Observer\HyvaThemeHyvaConfigGenerateBefore`
class's `exclusions` array in `di.xml`.

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <type name="Hyva\CompatModuleFallback\Observer\HyvaThemeHyvaConfigGenerateBefore">
        <arguments>
            <argument name="exclusions" xsi:type="array">
                <item name="Hyva_VendorModule" xsi:type="boolean">true</item>
            </argument>
        </arguments>
    </type>
</config>
```

#### Hyvä Config Registration Observer

For compatibility modules that have registered themselves using the Hyvä config registration observer, they can be
removed from the `hyva-themes.json` file by disabling that observer in `frontend/events.xml`.

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd">
    <event name="hyva_config_generate_before">
        <!--
        Replace {{OBSERVER_NAME_HERE}} with the name of the observer that performs the registration.
        Convention suggests this is simply the name or something like `My_Module_Register_Hyva_Config`,
        however we recommend double-checking this,
        to ensure you are using the correct name,
        as there is no guarantee this convention is adhered to.
        -->
        <observer name="{{OBSERVER_NAME_HERE}}" disabled="true"/>
    </event>
</config>
```

Some modules may use BOTH methods...

In those cases, both methods of removing them from the file are required.

Since release 1.1.3 of `hyva-themes/magento2-compat-module-fallback`

Before that version, excluding a module required disabling it completely.

## Supporting Both PHP and GraphQL Cart Pages

Since Hyvä 1.1.15, the default cart is a server-side rendered "PHP Cart". Previous versions used a client-side rendered "GraphQL Cart". To support both, the `hyva-themes/magento2-graphql-cart` extension can be installed, which allows switching between cart types in the configuration. Compatibility modules should ideally support both.

### Declaring Layout XML Depending on the Cart Type

The `hyva-themes/magento2-graphql-cart` extension provides two mechanisms for loading different layout XML based on the active cart type:

1. **Layout Handles:**

   - `hyva_checkout_cart_type_php.xml` (for the PHP Cart)
   - `hyva_checkout_cart_type_graphql.xml` (for the GraphQL Cart)
2. **`ifconfig` Attribute:** Use system configuration flags to conditionally render blocks.

   - `hyva_themes_cart/general/php_cart_enabled`
   - `hyva_themes_cart/general/graphql_cart_enabled`

   ```
   <block
       name="php-cart-checkout-button"
       template="My/Module::php-cart/my-checkout.phtml"
       ifconfig="hyva_themes_cart/general/php_cart_enabled"
   />
   ```

For most compatibility modules, it is enough to declare blocks for both cart types in `hyva_checkout_cart_index.xml` and attach them to the correct parent containers. Only the containers for the active cart type will be rendered. It is recommended to place PHP Cart-specific templates in a `php-cart/` subdirectory to avoid conflicts.
