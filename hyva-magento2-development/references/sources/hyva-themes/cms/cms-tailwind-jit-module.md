<!-- source: https://docs.hyva.io/hyva-themes/cms/cms-tailwind-jit-module.html -->

# CMS Tailwind JIT Module for Hyvä Themes

The **CMS Tailwind JIT module** (`Hyva_CmsTailwindJit`) enables Tailwind CSS classes to work automatically in CMS-managed content within Hyvä Themes. This module solves the problem of Tailwind utility classes missing from the compiled CSS when they are only used in CMS content and not in theme templates.

## Why are Tailwind Classes used only in CMS content missing from the styles.css?

Standard Tailwind CSS compilation only includes classes that appear in template files configured in the themes content settings.
When content editors use Tailwind classes in CMS blocks, pages, or product descriptions, those classes are typically not included during compilation because Tailwind cannot scan database-stored content.

The CMS Tailwind JIT module addresses this limitation by compiling Tailwind styles on-demand for CMS content. When an admin user saves CMS content, the module runs a browser-based Tailwind compiler that generates CSS specifically for the classes used in that content. The compiled CSS is stored in the database and injected inline when the content renders on the storefront.

## Supported Content Types

The CMS Tailwind JIT module provides automatic Tailwind CSS compilation and admin preview support for the following content types:

- **CMS Blocks** - Reusable content blocks used throughout the site
- **CMS Pages** - Full standalone pages managed in Magento admin
- **Product Descriptions** - Both full description and short description fields
- **Category Descriptions** - Category landing page content

The CMS Tailwind JIT module integrates with multiple Magento content editors:

- Hyvä CMS
- Magento PageBuilder
- The classic TinyMCE editor

In PageBuilder, the content preview feature works for both CMS Block widgets and HTML Code content types.

## Installing the CMS Tailwind JIT Module

The CMS Tailwind JIT module is automatically installed as a dependency when using Hyvä CMS.
When using only Hyvä Theme with PageBuilder, it has to be installed explicitly.

### Installing from Packagist.com

Install the CMS Tailwind JIT module from Packagist.com using Composer:

```
composer require hyva-themes/magento2-cms-tailwind-jit
```

After installation, enable the `Hyva_CmsTailwindJit` module and apply database schema changes:

```
bin/magento setup:upgrade
```

### Installing for Development and Contributions

GitLab access is available only to tech partners

Direct access to the GitLab repository requires Hyvä tech partner status.

Install the CMS Tailwind JIT module from GitLab for development purposes:

```
# Add the GitLab repository to Composer
composer config repositories.hyva-themes/magento2-cms-tailwind-jit git git@gitlab.hyva.io:hyva-themes/magento2-cms-tailwind-jit.git

# Install the module with source files for development
composer require hyva-themes/magento2-cms-tailwind-jit:dev-main --prefer-source
```

Enable the `Hyva_CmsTailwindJit` module and apply database schema changes:

```
bin/magento setup:upgrade
```

### Configuring Instances Without PageBuilder

Required when PageBuilder modules are disabled

If your Magento instance has PageBuilder modules disabled, you must disable a JavaScript mixin in the CMS Tailwind JIT module to prevent admin errors.

When PageBuilder is disabled, the CMS Tailwind JIT module's PageBuilder integration mixin must be turned off. Create a RequireJS configuration file in your custom module to disable the mixin:

app/code/My/Module/view/adminhtml/requirejs-config.js

```
var config = {
    config: {
        mixins: {
            // Disable the PageBuilder form mixin when PageBuilder is not installed
            // This prevents JavaScript errors in the admin panel
            'Magento_Ui/js/form/form': {
                'Hyva_CmsTailwindJit/js/form/pagebuilder-form-submit-mixin': false
            }
        }
    }
};
```

Add `Hyva_CmsTailwindJit` as a dependency in your custom module's `etc/module.xml` file to ensure proper loading order:

app/code/My/Module/etc/module.xml

```
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="My_Module">
        <sequence>
            <!-- Load after CMS Tailwind JIT module to override its mixin -->
            <module name="Hyva_CmsTailwindJit"/>
        </sequence>
    </module>
</config>
```

After creating these files, flush the Magento cache. If running in production mode, also deploy static content:

```
bin/magento cache:flush
bin/magento setup:static-content:deploy
```

## Using Tailwind Classes with Single Quotes in Alpine.js

When Tailwind utility classes contain single quotes (such as content strings in `after:` or `before:` pseudo-elements) and you use them inside Alpine.js `:class` bindings, the quotes must be escaped because they appear within a JavaScript string context.

### Escaping Single Quotes in Alpine.js Class Bindings

This example shows the correct syntax for using Tailwind classes containing single quotes `'`. The example uses the `after:content-[]` class with escaped quotes inside an Alpine.js `:class` binding:

```
<div :class="{'after:content-[\'bar\']': activeTab === 0}"></div>
```

### Workaround for Tailwind JIT Quote-Escaping Bug

A bug in the Tailwind JIT compiler causes escaped quotes in dynamic class bindings to be included literally in the generated CSS, breaking the styles. To work around this issue in the CMS Tailwind JIT module, add an HTML comment containing the unquoted version of the class name immediately before the element:

```
<!-- after:content-['bar'] -->
<div :class="{'after:content-[\'bar\']': activeTab === 0}"></div>
```

The CMS Tailwind JIT compiler processes both the commented unquoted version and the escaped version in the binding, generating CSS for both variations. The browser applies the correct unquoted version, making the styling work as expected.

## How the CMS Tailwind JIT Module Compiles Styles

The CMS Tailwind JIT module uses a browser-based Tailwind compiler to generate styles at the time CMS content is saved, rather than during frontend page rendering. This approach eliminates any performance impact on storefront page loads.

### Compilation Process in Magento Admin

When a content editor saves a CMS block, CMS page, category description, or product description in the Magento admin panel, the CMS Tailwind JIT module automatically processes the HTML content. The module passes the content to an embedded Tailwind JIT compiler that runs directly in the browser. The Tailwind compiler scans the HTML for utility classes and generates the corresponding CSS rules.

The compilation happens separately for each store view that meets both conditions: the store uses a Hyvä-based theme AND the store is assigned to the CMS entity being saved. This per-store compilation ensures that multi-store installations with different Tailwind configurations generate appropriate styles for each storefront.

### Database Storage of Compiled CSS

The CMS Tailwind JIT module stores compiled CSS in dedicated database tables when the admin user saves content:

| Content Type | Database Table |
| --- | --- |
| CMS Blocks | `hyva_cms_block_tailwindcss` |
| CMS Pages | `hyva_cms_page_tailwindcss` |
| Product Descriptions | `hyva_catalog_product_tailwindcss` |
| Category Descriptions | `hyva_catalog_category_tailwindcss` |

Each table stores the pre-compiled CSS mapped to the entity ID and store view, eliminating the need for on-the-fly compilation during frontend requests.

### Frontend Rendering of CMS Content with Tailwind Styles

When Hyvä Themes renders a CMS entity on the storefront, the CMS Tailwind JIT module retrieves the pre-compiled CSS from the appropriate database table. The compiled styles are injected inline within a `<style>` tag immediately before the CMS content. This inline injection ensures that the Tailwind classes used in the content display correctly without requiring those classes to exist in the main theme stylesheet.

## Customizing Tailwind Configuration for CMS Content

The CMS Tailwind JIT module supports custom Tailwind configurations to match your theme's design system. However, because the Tailwind compiler runs in the browser rather than Node.js, configuration options are limited compared to standard Tailwind builds.

### Default Configuration File Location

By default, the CMS Tailwind JIT module looks for a custom configuration file at `web/tailwind/tailwind.browser-jit-config.js` within your theme directory. This file is optional—if not present, the module uses Tailwind's default configuration.

### Overriding the Configuration File Path

To specify a different location for the browser JIT configuration file, create a theme configuration file that points to your custom config:

app/design/frontend/My/Theme/etc/cms-tailwind-jit-theme-config.json

```
{
  "tailwindBrowserJitConfigPath": "../../../../../app/design/frontend/My/theme/web/tailwind/tailwind.browser-jit-config.js"
}
```

This is very uncommon! Usually omitting the `cms-tailwind-jit-theme-config.json` and using the default config path is sufficient.

**Path resolution rules for the CMS Tailwind JIT module:**

- Paths starting with `/` are treated as absolute filesystem paths
- All other paths are treated as relative to the theme directory
- If the specified file doesn't exist or is unreadable, the module silently falls back to default Tailwind configuration

### Browser Context Limitations for Tailwind Configuration

The CMS Tailwind JIT module evaluates configuration in the browser, not in Node.js. This imposes significant restrictions on what can be included in the configuration file:

**Allowed in browser JIT config:**

- `module.exports.theme` configuration object
- Two specific imports:

  ```
    const { spacing } = require('tailwindcss/defaultTheme');
    const colors = require('tailwindcss/colors');
  ```

**Not allowed in browser JIT config:**

- `require()` calls for custom plugins or external files
- `resolveConfig()` function calls
- Node.js filesystem operations
- Any code outside the `module.exports` object

To add support for additional plugins, you would need to create a custom build of the CMS Tailwind JIT module itself.

### Example Browser JIT Configuration File

This example shows a valid `tailwind.browser-jit-config.js` file that customizes container settings and extends the color palette:

web/tailwind/tailwind.browser-jit-config.js

```
// Only these two imports are supported in browser context
// Other require() calls will fail in the browser-based compiler
const { spacing } = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');

module.exports = {
  theme: {
    // Override default container behavior for CMS content
    container: {
      center: true,
      padding: spacing["6"]
    },
    extend: {
        colors: {
            // Custom color definitions available in CMS content
            // These must match your theme's color palette
            'my-gray': '#888877',
            primary: {
                lighter: colors.purple['300'],
                "DEFAULT": colors.purple['800'],
                darker: colors.purple['900'],
            },
        }
    },
  }
}
```

### Merging Browser JIT Config with Standard Tailwind Config

To avoid duplicating theme extensions in both `tailwind.config.js` (for Node.js builds) and `tailwind.browser-jit-config.js` (for CMS content), you can merge the browser config into your standard config.

Add this deep merge snippet to the end of your `tailwind.config.js` file:

web/tailwind/tailwind.config.js

```
// Deep merge the browser JIT config into the standard config
// This keeps both configs in sync automatically
if (require('fs').existsSync('./tailwind.browser-jit-config.js')) {

    // Helper function to check if a value is a plain object
    function isObject(item) {
        return (item && typeof item === 'object' && !Array.isArray(item));
    }

    // Recursively merge source objects into target object
    // Arrays are replaced entirely, objects are merged recursively
    function mergeDeep(target, ...sources) {
        if (!sources.length) return target;
        const source = sources.shift();

        if (isObject(target) && isObject(source)) {
            for (const key in source) {
                if (isObject(source[key])) {
                    if (!target[key]) Object.assign(target, { [key]: {} });
                    mergeDeep(target[key], source[key]);
                } else {
                    Object.assign(target, { [key]: source[key] });
                }
            }
        }

        return mergeDeep(target, ...sources);
    }

    // Merge browser-jit-config into this config
    mergeDeep(module.exports, require('./tailwind.browser-jit-config.js'));
}
```

This merge strategy ensures that any theme customizations defined in `tailwind.browser-jit-config.js` are automatically included in your standard Tailwind build, maintaining consistency between CMS content styles and template styles.

## Adding Custom CSS for CMS Content

The CMS Tailwind JIT module ignores the standard `tailwind-source.css` file used for theme compilation. To add custom CSS that applies specifically to CMS content, create a separate file for browser-based JIT compilation.

### Creating a Custom CSS File for CMS Content

Create a `web/tailwind/tailwind.browser-jit.css` file in your theme. The contents of this file will be passed to the browser-based Tailwind JIT compiler and included in the compiled styles for CMS content.

You can use this file for custom `@layer` directives, CSS variables, or any other CSS that should be available in CMS content.

### Overriding the Custom CSS File Path

To specify a different location for the custom CSS file, create a theme configuration file:

app/design/frontend/My/Theme/etc/cms-tailwind-jit-theme-config.json

```
{
  "tailwindBrowserJitCssPath": "../../../../../app/design/frontend/My/theme/web/tailwind/tailwind.browser-jit.css"
}
```

**Path resolution rules for the CMS Tailwind JIT module:**

- Paths starting with `/` are treated as absolute filesystem paths
- All other paths are treated as relative to the theme directory
- If the specified file doesn't exist or is unreadable, the module silently continues without custom CSS

## Building the Embedded JIT Compiler from Source

Only for module developers

These build instructions are intended for developers who need to modify the embedded Tailwind JIT compiler itself. Standard installations of the CMS Tailwind JIT module do not require building from source. These instructions are documented primarily for maintainability when new versions of the Tailwind JIT compiler are released.

### Build Process for the Embedded Compiler

The embedded Tailwind JIT compiler bundled with the CMS Tailwind JIT module is based on the [tailwind-jit-cdn](https://github.com/beyondcode/tailwindcss-jit-cdn) project. The source code for the embedded compiler is located in the `src/view/adminhtml/tailwind-jit` directory of the module.

To build the embedded JIT compiler, navigate to the compiler source directory and run the build commands:

```
# Navigate to the compiler source directory
cd src/view/adminhtml/tailwind-jit

# Install dependencies using Yarn
yarn install

# Build the compiler to output JavaScript bundle
yarn build
```

The build process compiles the Tailwind JIT source to `src/view/adminhtml/web/js`, where Magento can load it in the admin panel.

During active development, use the watch command for automatic rebuilds:

```
yarn watch
```

## Extending the CMS Tailwind JIT Module to Other Content Types

The CMS Tailwind JIT module is designed to be extensible. You can reuse the embedded JIT compiler for custom HTML content types beyond the built-in CMS blocks, pages, and catalog descriptions.

### Integration Steps for Custom Content Types

To integrate the CMS Tailwind JIT compiler with a custom content type, follow these steps:

1. **Initialize the JIT on the admin page** - Add the JIT compiler to your custom content edit page in the admin panel
2. **Observe content changes** - Set up JavaScript observers to detect when content is modified and pass the HTML to the JIT compiler
3. **Store compiled CSS temporarily** - Capture the compiled CSS output in a form field so it submits along with the content
4. **Create a database table** - Define a table to persist the compiled CSS, indexed by entity ID and store view
5. **Save compiled CSS on entity save** - Use an observer or plugin to intercept the entity save operation and persist the compiled CSS to your custom table
6. **Prefix classes in HTML output** - When rendering the content on the frontend, pass the HTML through `\Hyva\CmsTailwindJit\Model\PrefixJitClasses::prefixJitClassesInHtml` to add unique prefixes
7. **Prefix and render CSS** - Pass the compiled CSS through `\Hyva\CmsTailwindJit\Model\PrefixJitClasses::prefixJitClassesInCss` and inject it in a `<style>` tag before the content

For a complete implementation example of steps 6 and 7 (frontend rendering with class prefixing), refer to the category description implementation in `\Hyva\CmsTailwindJit\ViewModel\CategoryTailwindCss::prefixCategoryCmsTailwindCssJitClasses`.

### Loading the JIT Compiler on Admin Pages

To enable the Tailwind JIT compiler on your custom admin content edit page, include the `tailwind_jit` layout handle in your adminhtml layout XML file:

view/adminhtml/layout/my\_custom\_entity\_edit.xml

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <!-- Load the CMS Tailwind JIT compiler iframe and JavaScript -->
    <update handle="tailwind_jit"/>
    <!-- Your other layout configuration -->
</page>
```

The `tailwind_jit` layout handle loads the embedded Tailwind JIT compiler in an invisible iframe. The compiler has no visible UI components—if you inspect the page source, you'll find an `<iframe id="tailwindcss-jit">` element that hosts the compilation environment.

### JavaScript API for Compiling HTML to CSS

The embedded JIT compiler exposes a JavaScript API for processing HTML content. Pass your HTML content to the compiler and receive compiled CSS asynchronously:

```
// Compile HTML content to CSS using the browser-based Tailwind JIT compiler
// Returns a Promise that resolves with the compiled CSS string
window.tailwindCSS.process(htmlContent, customConfig, customStyles)
  .then((css) => {
      // Store the compiled CSS in a hidden form field
      // so it submits with the content save request
      console.log('Compiled CSS:', css);
  });
```

**Parameters for `window.tailwindCSS.process()`:**

- `htmlContent` (required) - String containing the HTML to scan for Tailwind classes
- `customConfig` (optional) - Custom Tailwind configuration object for a specific theme
- `customStyles` (optional) - Additional CSS to include verbatim in the output

To support per-theme configurations in multi-store installations, retrieve the appropriate custom config using the methods described below. Custom styles passed as the third argument are included unchanged in the compiled output, allowing you to inject theme-specific CSS rules.

### Retrieving Theme-Specific Tailwind Configurations

For multi-store installations where different stores use different Hyvä themes with distinct Tailwind configurations, you need to compile CSS separately for each theme. The embedded JIT compiler provides JavaScript methods to retrieve theme-specific configurations.

**Get Tailwind configuration by store ID:**

```
// Returns the custom Tailwind config for the theme assigned to this store
// Use when your content entity is associated with specific stores
const config = window.tailwindCSS.configForStore(storeId);
```

**Get Tailwind configuration by theme identifier:**

```
// Returns the custom Tailwind config for a specific theme path
// Theme identifier matches the path in the theme's registration.php
// Examples: "frontend/Hyva/default", "frontend/Vendor/ThemeName"
const config = window.tailwindCSS.configForTheme('frontend/Hyva/default');
```

Your integration code is responsible for iterating over the relevant stores or themes and calling `window.tailwindCSS.process()` with each configuration to generate CSS for all applicable store views.

### Mapping Store IDs to Hyvä Theme Identifiers

To compile styles for different themes, you need to know which stores have Hyvä themes. The CMS Tailwind JIT module provides JavaScript methods to retrieve this mapping.

**Get all stores with Hyvä themes:**

```
// Returns an object mapping store IDs to theme identifiers
// Only includes stores that use Hyvä-based themes
// Example: { "1": "frontend/Hyva/default", "2": "frontend/Hyva/custom" }
window.tailwindCSS.tailwindThemes()
```

**Get Hyvä themes for specific stores:**

```
// Limit the map to specific store IDs
// Useful when your entity is only assigned to certain stores
window.tailwindCSS.tailwindThemes([1, 2, 5])
```

The returned map only contains stores that have Hyvä-based themes. Stores using Luma or other themes are excluded.

### Mapping Website IDs to Store IDs

If an entity is associated to websites instead of stores (for example, products), you need to map website IDs to store IDs before determining which Tailwind themes apply.

**Get all store IDs:**

```
// Returns an array of all store IDs in the Magento installation
window.tailwindCSS.storeIdsForWebsites()
```

**Get store IDs for specific websites:**

```
// Returns store IDs belonging to the specified website IDs
// Use this for products and other website-scoped entities
window.tailwindCSS.storeIdsForWebsites([1, 2])
```

## Related Topics

- **[Using Tailwind Classes in CMS Content](using-tailwind-classes-in-cms-content.html)** - Practical guide for content editors on which Tailwind classes work in CMS content and how to use them effectively
