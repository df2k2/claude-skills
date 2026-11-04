<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/configuration.html -->

# Configuring the CMS Tailwind JIT Module

Skip this page if you use server-side compilation

This page applies to the **in-browser** compiler only. [Server-side compilation](server-side-compilation.html) ignores the `tailwind.browser-jit-config.js` / `tailwind.browser-jit.css` files described here and compiles against each theme's regular Tailwind configuration (`tailwind.config.js` for v3 themes, `tailwind-source.css` for v4 themes), so no separate config file is needed.

The CMS Tailwind JIT module compiles Tailwind CSS for CMS content in the browser, using whichever compiler version is selected under [PageBuilder Tailwind Compiler](installation.html#selecting-the-tailwind-compiler-version). Each version reads its own optional per-theme source file from your theme directory:

| Compiler version | Per-theme source file | Format |
| --- | --- | --- |
| Tailwind v3 (default) | `web/tailwind/tailwind.browser-jit-config.js` | JavaScript (CommonJS) |
| Tailwind v4 | `web/tailwind/tailwind.browser-jit.css` | CSS |

These files are optional. If the file for the active version is not present, the module compiles with Tailwind's default configuration. The default utility classes work without any per-theme source file.

Read only the section for your version

Configure the one version you selected — you do not need both. New projects should use [Tailwind v4](#tailwind-v4-configuration), which has the simpler, CSS-native setup. The [Tailwind v3](#tailwind-v3-configuration) section applies to projects still on the v3 compiler. Already running v3 and moving to v4? See [Migrating from Tailwind v3 to v4](#migrating-from-tailwind-v3-to-v4).

## Tailwind v3 Configuration

When the compiler version is set to **Tailwind v3 (in-browser)**, the module looks for a JavaScript configuration file at `web/tailwind/tailwind.browser-jit-config.js` within your theme directory. This file follows the same structure as `tailwind.config.js` but with significant restrictions due to the browser environment.

### Browser Context Limitations

The browser JIT config is evaluated in the browser, not in Node.js. This limits what can be included.

**Allowed in the browser JIT config:**

- The `module.exports.theme` configuration object
- Two specific imports:

  ```
  const { spacing } = require('tailwindcss/defaultTheme');
  const colors = require('tailwindcss/colors');
  ```

**Not allowed in the browser JIT config:**

- `require()` calls for custom plugins or external files
- `resolveConfig()` function calls
- Node.js filesystem operations
- Any code outside the `module.exports` object

### Example `tailwind.browser-jit-config.js`

A valid browser JIT configuration file that customizes the container and extends the color palette:

web/tailwind/tailwind.browser-jit-config.js

```
// Only these two imports are supported in the browser-based compiler
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
        // Custom color definitions - these must match your theme's color palette
        'my-gray': '#888877',
        primary: {
          lighter: colors.purple['300'],
          DEFAULT: colors.purple['800'],
          darker: colors.purple['900'],
        },
      }
    },
  }
}
```

Optional: keep this config in sync with `tailwind.config.js` automatically

To avoid duplicating theme extensions in both `tailwind.config.js` and `tailwind.browser-jit-config.js`, append this deep-merge snippet to the end of your `tailwind.config.js`. It merges the browser JIT config into the standard config so you only maintain customizations once.

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

### Overriding the JavaScript Configuration File Path

Pointing to a different config file location

By default the module looks for `web/tailwind/tailwind.browser-jit-config.js` in your theme directory. To use a different location, create a `etc/cms-tailwind-jit-theme-config.json` file in your theme:

app/design/frontend/My/Theme/etc/cms-tailwind-jit-theme-config.json

```
{
  "tailwindBrowserJitConfigPath": "../../../../../app/design/frontend/My/Theme/web/tailwind/tailwind.browser-jit-config.js"
}
```

This is uncommon. Omitting the file and relying on the default config path is sufficient for most projects.

**Path resolution rules:**

- Paths starting with `/` are treated as absolute filesystem paths
- All other paths are relative to the theme directory
- If the file does not exist or is unreadable, the module silently falls back to the default Tailwind configuration

## Tailwind v4 Configuration

When the compiler version is set to **Tailwind v4 (in-browser)**, Tailwind uses a CSS-native configuration approach - there is no `tailwind.config.js` to merge into. Instead of a JavaScript config, the module reads a single CSS source file at `web/tailwind/tailwind.browser-jit.css` within your theme directory. Its contents are passed to the in-browser compiler and may use any Tailwind v4 directive (`@theme`, `@layer`, `@utility`, etc.).

No `@import` / `@source` directives

The compiler runs in the browser and has no filesystem access, so `@import` and `@source` directives in the source CSS cannot be resolved. Inline the CSS you need directly in `tailwind.browser-jit.css`.

### CSS Custom Properties for CMS Styles

In Tailwind v4, custom values like colors, spacing, and typography scales are defined as CSS custom properties using the `@theme` directive in your theme's CSS. The CMS Tailwind JIT compiler runs in the browser against the live page, so those variables are already in scope - you can reference them directly in CMS content without any additional configuration.

For any CMS-specific styles, use the `tailwind.browser-jit.css` file and write against the same CSS custom properties your theme defines:

web/tailwind/tailwind.browser-jit.css

```
/* Reference theme CSS custom properties defined via @theme in your theme */
.cms-callout {
    border-left: 4px solid var(--color-primary);
    padding: var(--spacing-4);
    background: var(--color-primary-lighter);
}
```

For more details on CSS custom properties and how they work with Tailwind v4, see [CSS Variables and Tailwind CSS](../../working-with-tailwindcss/css-variables-plus-tailwindcss.html).

### Overriding the CSS File Path

Pointing to a different CSS file location

By default the module looks for `web/tailwind/tailwind.browser-jit.css` in your theme directory. You can point this to any CSS file in your theme - which is useful for sharing CSS with the CMS JIT compiler rather than maintaining a separate file.

To set the path, create a `etc/cms-tailwind-jit-theme-config.json` file in your theme:

app/design/frontend/My/Theme/etc/cms-tailwind-jit-theme-config.json

```
{
  "tailwindBrowserJitCssPath": "../../../../../app/design/frontend/My/Theme/web/tailwind/tailwind.browser-jit.css"
}
```

**Path resolution rules:**

- Paths starting with `/` are treated as absolute filesystem paths
- All other paths are relative to the theme directory
- If the file does not exist or is unreadable, the module silently continues without custom CSS

## Migrating from Tailwind v3 to v4

This procedure is only for existing projects moving from the v3 compiler to v4. New projects can skip it and configure v4 directly.

Tailwind v4 produces significantly smaller compiled CSS than v3, so less CSS is injected with each CMS entity. The smaller page size improves page load performance and benefits SEO, which makes migrating worthwhile for existing installations.

Switching an existing installation from the v3 compiler to v4 is a deliberate, opt-in step. Follow this procedure for the whole instance, since the compiler version is global.

### 1. Translate each theme's per-theme config to CSS

For every Hyvä theme that has a `web/tailwind/tailwind.browser-jit-config.js`, recreate its customizations in a new `web/tailwind/tailwind.browser-jit.css` file using Tailwind v4's CSS-native `@theme` directive. Values defined under `theme.extend` in the JavaScript config become CSS custom properties.

For example, this v3 config:

web/tailwind/tailwind.browser-jit-config.js

```
const colors = require('tailwindcss/colors');

module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          lighter: colors.purple['300'],
          DEFAULT: colors.purple['800'],
          darker: colors.purple['900'],
        },
      }
    }
  }
}
```

becomes this v4 source CSS:

web/tailwind/tailwind.browser-jit.css

```
@theme {
    --color-primary-lighter: #d8b4fe; /* purple-300 */
    --color-primary: #6b21a8;         /* purple-800 */
    --color-primary-darker: #581c87;  /* purple-900 */
}
```

A theme that only uses default Tailwind utility classes does not need a source file at all. For more details on the `@theme` directive and CSS custom properties, see [CSS Variables and Tailwind CSS](../../working-with-tailwindcss/css-variables-plus-tailwindcss.html).

### 2. Switch the compiler version setting

Set **PageBuilder Tailwind Compiler** to **Tailwind v4 (in-browser)** under `Stores → Configuration → Hyvä Themes → PageBuilder → CMS Tailwind Compilation`. When you save, the module emits an informational notice listing any Hyvä theme that is still missing a `tailwind.browser-jit.css` source file.

Alternatively, set it from the command line — convenient for setup scripts and deployment pipelines:

```
bin/magento config:set hyva_cms_tailwind_jit/general/compiler_version v4
```

To pin the value in `app/etc/config.php` so it can be committed to version control and is no longer editable in the admin, add `--lock-config`:

```
bin/magento config:set --lock-config hyva_cms_tailwind_jit/general/compiler_version v4
```

### 3. Flush the cache

Flush the cache so the changed `compiler_version` setting is picked up:

```
bin/magento cache:flush
```

Saving the setting in the admin invalidates the config cache automatically; when you change it from the command line with `config:set`, flush the cache explicitly.

### 4. Recompile existing CMS content (optional)

Existing stored CSS continues to render correctly after the switch - both the v3 and the v4 stored output flow through the same render-time pipeline, so already-saved CMS content keeps working without any action.

To regenerate that CSS with the v4 compiler, re-save the affected CMS blocks, CMS pages, products, and categories in the admin. Each save recompiles the content with the now-active v4 compiler. Any content edited after the switch is compiled with v4 automatically.

Switching back to v3

The same procedure works in reverse. Switch **PageBuilder Tailwind Compiler** back to **Tailwind v3 (in-browser)** and flush the cache. Stored CSS rows from either compiler render correctly regardless of the active version, so no recompile is required to switch back.
