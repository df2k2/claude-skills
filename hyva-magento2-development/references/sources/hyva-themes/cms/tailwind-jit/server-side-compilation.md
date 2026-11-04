<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/server-side-compilation.html -->

# Server-Side CMS Tailwind Compilation

By default, the CMS Tailwind JIT module compiles Tailwind CSS for CMS content [in the browser](index.html), inside an admin iframe. Three optional modules let you move that compilation to the server instead, where it runs against each theme's actual Tailwind toolchain:

Applies to native Magento CMS

These modules and this page cover native Magento CMS content edited with PageBuilder or the TinyMCE (WYSIWYG) editor — CMS pages, CMS blocks, and product and category descriptions. **Hyvä CMS** (the Liveview Editor) has its own compilation setup with a separate bridge and its own server-side option — see [Tailwind CSS Compilation](../../../hyva-commerce/features/cms/tailwind-compilation.html) in the Hyvä Commerce docs. The two share the single in-browser compiler version (v3 / v4) setting.

| Module | Role | Required |
| --- | --- | --- |
| `hyva-themes/magento2-cms-tailwind-compiler` | A Node.js daemon that compiles Tailwind CSS server-side for CMS HTML, returning only the delta CSS (utility classes not already in the theme's compiled `styles.css`), scoped to the entity. | Yes |
| `hyva-themes/magento2-cms-tailwind-jit-bridge` | Replaces the in-browser compiler iframe in the admin with calls to the compiler daemon. Adds the **Node Tailwind (server-side)** option to the compiler selector. | Yes |
| `hyva-themes/magento2-cms-tailwind-recompile` | Bulk-recompiles all stored CMS CSS via CLI or a cron-driven queue, without opening and saving each entity individually. | Optional |

The compiler is a dependency of the bridge, so the two are installed together — requiring the bridge pulls in the compiler automatically. The recompile module is optional; install it only if you need to recompile stored CMS CSS in bulk after a configuration or theme change.

The admin editing experience, per-theme CSS storage, frontend scoping, and PageBuilder integration all stay the same. Only the compilation backend changes.

## Why Compile Server-Side

Server-side compilation has several advantages over the in-browser compiler:

- **No separate configuration.** It uses each theme's regular Tailwind config (`tailwind.config.js` for v3 themes, `tailwind-source.css` for v4 themes) instead of a separate in-browser config file. There is no duplication to keep in sync.
- **Matches each theme's Tailwind version.** The daemon detects the Tailwind version per theme, so v3 and v4 themes can be used in parallel on the same instance.
- **Bulk recompilation.** Stored CMS styles can be recompiled in bulk after a config change, instead of re-opening and saving each entity individually.
- **Faster compilation** than the in-browser compiler.
- **Smaller CSS payload.** Only the delta CSS — utility classes not already present in the theme's compiled `styles.css` — is stored and injected, which reduces page size and benefits page load performance and SEO.

## Enabling Server-Side Compilation

1. Install and set up the compiler daemon and the bridge module — see [Setting Up the Compiler Daemon](server-side-setup.html).
2. Confirm the compiler version is set to **Node Tailwind (server-side)** under `Stores → Configuration → Hyvä Themes → PageBuilder → CMS Tailwind Compilation → PageBuilder Tailwind Compiler`.

Installing the bridge changes the default compiler

Without the bridge module, the compiler defaults to **Tailwind v3 (in-browser)**, so an instance that only uses `magento2-cms-tailwind-jit` is unaffected. Installing `magento2-cms-tailwind-jit-bridge` shifts the default to **Node Tailwind (server-side)**. You can still select any of the three options — Tailwind v3 (in-browser), Tailwind v4 (in-browser), or Node Tailwind (server-side) — from the dropdown.

The daemon must be running

In server-side mode, CMS content compilation in the admin depends on the compiler daemon being reachable. If the daemon is not running and on-demand start is not enabled, compilation in the editor fails. See [Daemon Management](server-side-setup.html#daemon-management) for the start options.

## Advanced

CSS scoping strategy (optional tuning)

The default works for most stores; change this only if you have a specific reason. When the compiler version is set to **Node Tailwind (server-side)**, an additional field appears:

`Stores → Configuration → Hyvä Themes → PageBuilder → CMS Tailwind Compilation → PageBuilder CSS Scoping Strategy`

| Option | Config value | Behavior |
| --- | --- | --- |
| Class prefixing (legacy) | `jit` (default) | Compiled CSS is stored unscoped; per-entity class-name prefixes (`hcms-{type}-{id}-`) are applied at frontend render time. This matches the in-browser compiler's storage format. |
| Entity scope selector | `compiler` | Compiled CSS is scoped at compile time with a per-entity ancestor selector (`.hcms-{type}-{id}`). No render-time prefixing; the entity content is wrapped in a matching container. |

The setting is stored at `hyva_cms_tailwind/bridge/scoping_strategy` and only applies in server-side mode. Stored CSS in either shape renders correctly, so the strategy can be changed and the content [recompiled](recompiling-cms-content.html) without breaking existing pages.
