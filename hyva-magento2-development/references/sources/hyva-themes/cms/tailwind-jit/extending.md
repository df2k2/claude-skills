<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/extending.html -->

# Extending the CMS Tailwind JIT Module to Custom Content Types

For module developers

This page is only needed if you build a module with its own admin-managed HTML content type. Skip it if you only use the built-in CMS blocks, pages, and catalog descriptions.

The CMS Tailwind JIT module is designed to be extensible. You can reuse the embedded JIT compiler for custom HTML content types beyond the built-in CMS blocks, pages, and catalog descriptions.

Works with server-side compilation automatically

A custom entity that follows the integration described on this page — the `tailwind_jit` layout handle plus `window.tailwindCSS.process()` — needs **no changes** to support [server-side compilation](server-side-compilation.html). When the bridge module is installed and the compiler is set to **Node Tailwind (server-side)**, it transparently reroutes these calls to the compiler daemon. The same code works in both in-browser and server-side modes.

You only need the daemon's own compiler API ([Extending Server-Side Compilation to Custom Content Types](server-side-extending.html)) for a standalone integration that does not go through the `tailwind_jit` handle. Either way, register the entity for [bulk recompilation](recompiling-cms-content.html#extending-to-custom-entities) separately.

## Integration Steps

To integrate the CMS Tailwind JIT compiler with a custom content type:

1. **Initialize the JIT on the admin page** - Add the JIT compiler to your custom content edit page in the admin panel.
2. **Observe content changes** - Set up JavaScript observers to detect when content is modified and pass the HTML to the JIT compiler.
3. **Store compiled CSS temporarily** - Capture the compiled CSS output in a form field so it submits along with the content.
4. **Create a database table** - Define a table to persist the compiled CSS, indexed by entity ID and store view.
5. **Save compiled CSS on entity save** - Use an observer or plugin to intercept the entity save and persist the compiled CSS to your custom table.
6. **Prefix classes in HTML output** - When rendering content on the frontend, pass the HTML through `\Hyva\CmsTailwindJit\Model\PrefixJitClasses::prefixJitClassesInHtml` to add the per-entity prefix.
7. **Prefix and render CSS** - Pass the compiled CSS through `\Hyva\CmsTailwindJit\Model\PrefixJitClasses::prefixJitClassesInCss` and inject it in a `<style>` tag before the content.

For a complete implementation example of steps 6 and 7, refer to `\Hyva\CmsTailwindJit\ViewModel\CategoryTailwindCss::getStyles`. It demonstrates both rendering paths: already-scoped CSS (from the Tailwind v4 in-browser compiler or the compiler daemon) is detected via `\Hyva\CmsTailwindJit\Model\ScopedCssDetector` and inlined as-is, while legacy unscoped CSS is rewritten with the unified `hcms-{type}-{id}-` prefix at render time.

## Loading the JIT Compiler on Admin Pages

To enable the Tailwind JIT compiler on your custom admin content edit page, include the `tailwind_jit` layout handle in your adminhtml layout XML:

view/adminhtml/layout/my\_custom\_entity\_edit.xml

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <!-- Load the CMS Tailwind JIT compiler iframe and JavaScript -->
    <update handle="tailwind_jit"/>
    <!-- Your other layout configuration -->
</page>
```

The `tailwind_jit` layout handle loads the embedded compiler in an invisible `<iframe id="tailwindcss-jit">` element.

## JavaScript API for Compiling HTML to CSS

The embedded JIT compiler exposes a JavaScript API. The same API surface works identically whether the v3 or the v4 compiler is active, so custom-entity extensions do not need to change when the compiler version is switched.

Pass your HTML content to the compiler and receive compiled CSS asynchronously:

```
// Compile HTML content to CSS using the browser-based Tailwind JIT compiler
// Returns a Promise that resolves with the compiled CSS string
window.tailwindCSS.process(htmlContent, customConfig, customCss)
  .then((css) => {
      // Store the compiled CSS in a hidden form field
      // so it submits with the content save request
      console.log('Compiled CSS:', css);
  });
```

**Parameters:**

- `htmlContent` (required) - String containing the HTML to scan for Tailwind classes
- `customConfig` (optional) - The theme's source config, typically obtained via `window.tailwindCSS.configForTheme(theme)` or `configForStore(storeId)`. This is JavaScript config on v3 and CSS source on v4; extension callers forward it to `process()` either way.
- `customCss` (optional) - Additional CSS appended after `customConfig`. On v4 both arguments are concatenated and treated as CSS; the split is retained for API compatibility with v3 callers.

The promise resolves with unscoped utility CSS. Scope it to your content with `\Hyva\CmsTailwindJit\Model\PrefixJitClasses` at render time, as described in the integration steps above.

## Retrieving Theme-Specific Tailwind Configurations

For multi-store installations with different Hyvä themes, compile CSS separately for each theme. The embedded JIT compiler provides JavaScript methods to retrieve theme-specific configurations.

Get a Tailwind configuration by store ID:

```
// Returns the custom Tailwind config for the theme assigned to this store
const config = window.tailwindCSS.configForStore(storeId);
```

Get a Tailwind configuration by theme identifier:

```
// Theme identifier matches the path in the theme's registration.php
// Examples: "frontend/Hyva/default", "frontend/Vendor/ThemeName"
const config = window.tailwindCSS.configForTheme('frontend/Hyva/default');
```

## Mapping Store IDs to Hyvä Theme Identifiers

Get all stores that use Hyvä themes:

```
// Returns an object mapping store IDs to theme identifiers
// Only includes stores that use Hyvä-based themes
// Example: { "1": "frontend/Hyva/default", "2": "frontend/Hyva/custom" }
window.tailwindCSS.tailwindThemes()
```

Limit the result to specific store IDs:

```
// Useful when your entity is only assigned to certain stores
window.tailwindCSS.tailwindThemes([1, 2, 5])
```

## Mapping Website IDs to Store IDs

For entities associated to websites rather than stores (for example, products), map website IDs to store IDs before determining which themes apply.

Get all store IDs:

```
// Returns an array of all store IDs in the Magento installation
window.tailwindCSS.storeIdsForWebsites()
```

Get store IDs for specific websites:

```
// Returns store IDs belonging to the specified website IDs
window.tailwindCSS.storeIdsForWebsites([1, 2])
```

## Building the Embedded JIT Compiler from Source

Only for module developers

These build instructions are for developers who need to modify the embedded Tailwind JIT compiler itself. Standard installations do not require building from source.

The module ships two separate compiler bundles, each with its own build directory and toolchain. Build only the version you are modifying.

### Tailwind v3 compiler

The v3 compiler is based on the [tailwindcss-jit-cdn](https://github.com/beyondcode/tailwindcss-jit-cdn) project and is built with Vue CLI using yarn. The source is in `src/view/base/tailwind-jit-v3`:

```
# Navigate to the v3 compiler source directory
cd src/view/base/tailwind-jit-v3

# Install dependencies
yarn install --ignore-scripts

# Build the compiler to src/view/base/web/js/jit/v3
yarn build
```

During active development, use the watch command for automatic rebuilds:

```
yarn watch
```

### Tailwind v4 compiler

The v4 compiler uses [`@tailwindcss/browser`](https://www.npmjs.com/package/@tailwindcss/browser) and is built with Vite using npm. The source is in `src/view/base/tailwind-jit-v4`:

```
# Navigate to the v4 compiler source directory
cd src/view/base/tailwind-jit-v4

# Install dependencies
npm install --ignore-scripts

# Build the compiler bundle
npm run build
```

For development with watch mode:

```
npm run dev
```
