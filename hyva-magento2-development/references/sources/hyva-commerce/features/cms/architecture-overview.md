<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/architecture-overview.html -->

# Hyvä CMS Architecture and Technical Overview

Hyvä CMS is a component-based content system for Magento. Content is stored as structured JSON, rendered through Magento templates, and edited through the Liveview Editor.

This architecture gives merchants a visual editing workflow while developers keep control over component fields, rendering, data access, validation, and theme integration.

## Module Overview

Hyvä CMS is split into modules with clear responsibilities.

| Module | Responsibility |
| --- | --- |
| `liveview-editor` | Core editor UI, preview system, component discovery, version history, translations, Tailwind JIT integration, preview security, editor preferences, and component CLI tools. |
| `liveview-connect` | CmsConnect supplies approved server actions and fragment rendering for the browser-owned editor document. |
| `magewire-compat` | Temporary compatibility classes and entry points for integrations with the previous internal Magewire fork. |
| `admin-styles` | Shared design tokens, package styles and an optional combined build. See [Admin Styles](admin-styles.html). |
| `magento-cms` | Integration with Magento CMS pages and CMS blocks, including storage tables, rendering plugins, REST APIs, GraphQL queries, version history, and Tailwind CSS storage. |
| `magento-attributes` | Integration with product and category EAV attributes such as descriptions. It resolves compatible attributes, stores attribute content, and replaces frontend attribute output when Hyvä CMS is enabled. |
| `components-base` | Built-in component declarations and templates such as rows, columns, headings, images, banners, cards, accordions, CMS blocks, widgets, and product sliders. |
| `scheduling` | Scheduled publication for supported Hyvä CMS content providers. |
| `template` | Templates, snippets, preview thumbnails, default templates, and template/snippet editor providers. |
| `cms-import-export` | ZIP Import/Export, JSON Import/Export, media handling, translations, history, and instance component transfer. |
| `instance-components` | Admin-created database-backed components. |

## Supported Content Types

Core modules support:

- CMS pages
- CMS blocks
- Product attributes
- Category attributes
- Templates
- Snippets

Hyvä Commerce companion packages can add further content types through the same provider contracts, storage model, and Liveview Editor. For example, [Menu Builder](../menu-builder/index.html) adds navigation menus.

Custom modules can add more content types by implementing the Hyvä CMS provider contracts and editor integration. See [Extending for Other Content Types](extending-for-other-content-types.html).

## Component Discovery

Code-defined components are declared in `etc/hyva_cms/components.json` files inside Magento modules. The component collector scans installed modules, validates declarations against the JSON schema, processes includes and option sources, and builds a unified registry.

The registry contains the component label, category, template path, fields, child-component rules, descriptions, context flags, and variant settings. In production mode, component data is cached in the `hyva_cms` cache. Developer mode keeps iteration faster by avoiding stale component cache behavior.

Database-backed [instance components](features/instance-components.html) are collected separately by `InstanceComponentCollector` and merged into the same provider registry with the `instance/` prefix, stored in the `hyva_cms_instance_component` table. They are an additional source, not a replacement for module-defined components: they don't support child components, may use `content`, `design`, and `advanced` sections like normal declarations, and the `hyva_cms` cache is cleaned after saving.

## Content Storage

Hyvä CMS stores content as JSON component trees. A content item usually has separate draft and published content, plus version history and Tailwind CSS data.

CMS pages and blocks use dedicated Hyvä CMS tables that reference Magento's native `cms_page` and `cms_block` records. Product and category attribute content uses dedicated attribute liveview tables and stores enabled attributes plus base and store-specific content.

Version history is stored separately so merchants can restore or compare earlier versions without changing the current draft or published state.

## Rendering

When Hyvä CMS is enabled for a supported item, frontend rendering loads the published Hyvä CMS JSON and renders each component using Magento's template system.

The root renderer walks the component tree and delegates each component to its declared PHTML template. Component templates receive `Hyva\CmsLiveviewEditor\Block\Element`, so they can use helper methods for editor attributes, images, links, child rendering, classes, block IDs, and rich text output.

In preview mode, Hyvä CMS injects the editor integration attributes (such as `data-liveview-element` and the root `getEditorAttrs()` values) into each component's first element automatically, and strips them from public storefront output. Templates can opt out with `$block->setData('auto_attributes', false)`.

From Hyvä CMS `1.1.0`, the Liveview wrapper elements render with `display: contents` in the editor preview and are left out of the storefront markup. To restore the legacy wrapper divs on the storefront, enable **Enable Legacy Liveview-Content Wrapper Divs** under `Stores → Configuration → Hyvä Commerce → Hyvä CMS → Advanced` (config path `hyva_cms/advanced/legacy_liveview_wrapper`).

For product and category attributes, frontend plugins replace the native attribute HTML with rendered Hyvä CMS content when content is enabled and published.

## Liveview Editor

See [Liveview Editor](editor.html) for the interface. The browser owns the unsaved content tree and CmsConnect provides approved server actions. Local editing uses the editor command bus; Magento validates and persists the complete document and supplies trusted lookups and PHP-rendered previews. See [Moving from Magewire to CmsConnect](cms-connect.html) for the boundaries and compatibility guidance.

The preview iframe loads a storefront URL. Editor updates are pushed into the preview so merchants can see the result without full page reloads. Preview URLs use security tokens that allow draft preview sharing without publishing the content. The editor and preview communicate through a structured `postMessage` layer, the [Liveview Bridge](liveview-bridge.html).

Editor features include:

- Navigator and a tabs bar for recent content
- Responsive preview modes and split view
- Context editing directly in the preview
- Rich text editing with TipTap, including Magento variables and directives
- Monaco-powered HTML editing
- Version history, plus session-level undo and redo
- Translations
- Templates and snippets
- Import/Export
- Scheduling
- Per-user editor preferences, favourite components, and keyboard shortcuts
- Instance components

## Tailwind CSS Generation

Hyvä CMS generates Tailwind CSS for content so that classes used in components produce styles without a full theme rebuild. Generated CSS is scoped to each entity with a wrapper selector in the form `.hcms-{type}-{id}` (for example `.hcms-page-42`), which keeps content styles from leaking into the rest of the page. CSS is stored per entity, theme, and edition (draft, published, or scheduled).

Compilation can run in one of two ways, selected in store configuration:

- **In-browser** Just-In-Time compilation, which compiles styles in the editor. This is the default.
- **Server-side** compilation through a Node-based Tailwind compiler.

Both paths produce the same scoped output and support Tailwind v3 and v4. The strategy toggle is provided by the `hyva-themes/commerce-module-cms-tailwind-jit-bridge` package. For configuration, the server-side recommendation for new projects, and backward-compatibility details, see [Tailwind CSS Compilation](tailwind-compilation.html).

Projects should still prefer component templates and design-system options over asking merchants to enter Tailwind classes manually.

## Scheduling

See [Content Scheduling](features/content-scheduling.html) for the merchant workflow and configuration. Architecturally, the scheduling module stores releases and scheduled items separately from drafts and published content. Cron publishes due releases by asking the registered schedule provider for each content type to apply content, Tailwind CSS, version history, and any content-type-specific settings.

Hyvä CMS scheduling is separate from Adobe Commerce Content Staging.

The scheduling module is available from Hyvä CMS `1.0.2`.

## Templates, Snippets, and Instance Components

Templates and snippets are stored as Hyvä CMS content providers. Templates act as full starting layouts. Snippets store selected components that can be inserted into other content. See [Templates And Snippets](features/templates-and-snippets.html) for the merchant workflow. Templates, snippets and instance components are available from Hyvä CMS `1.2.0`.

Instance components are database-backed component definitions. They can define fields and a lightweight HTML template through the admin UI. They are merged into the normal component registry and can be exported with content that uses them. See [Instance Components](features/instance-components.html) for the merchant workflow.

## APIs

REST APIs expose admin CRUD operations for CMS pages, blocks, version history, Tailwind CSS records, catalog attribute content, scheduling entities, templates, and snippets. GraphQL exposes published CMS page and CMS block content for frontend use. The REST and GraphQL APIs are available from Hyvä CMS `1.1.0`.

See [Hyvä CMS APIs](apis.html).

## Developer Extension Points

Developers can extend Hyvä CMS by:

- Creating code-defined components.
- Overriding base component templates or declarations.
- Adding custom field types.
- Registering option sources for component fields.
- Adding support for custom content types.
- Adding schedule providers for custom content types.
- Adding custom instance-template field renderers.
- [Allowing custom head assets](adding-assets-to-liveview-editor.html) (CSS or JavaScript) in the Liveview Editor.
- Integrating with REST APIs or GraphQL.
