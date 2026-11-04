<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/index.html -->

# Hyvä CMS

Hyvä CMS is a component-based content management system for [Hyvä Commerce](https://www.hyva.io/hyva-commerce.html). It gives merchants a live visual editor for Magento content while giving developers a structured component system, Magento templates, versioned content, APIs, and extension points.

[![Liveview Editor](./images/editor-screenshot.png)](./images/editor-screenshot.png)

## What Hyvä CMS Can Manage

Core Hyvä CMS supports:

- CMS pages
- CMS blocks
- Product attributes such as descriptions
- Category attributes such as descriptions
- Templates and snippets for reusable content structures

Developers can also add Hyvä CMS support to custom entities, for example blog modules or other project-specific content types.

## Installing Hyvä CMS

Hyvä CMS is part of Hyvä Commerce and installs through Composer. See [Installing Hyvä CMS](./installation.html) for the full setup, including the license-key and agency or technology partner paths. Once installed, [open the Liveview Editor](./accessing-hyva-cms-editor.html) from any supported CMS page, block, or product and category form.

Still deciding? The [Frequently Asked Questions](./faqs.html) cover how Hyvä CMS relates to Page Builder, scheduling, translations, and custom development.

## Key Features

- **[Live Preview](./editor.html#live-preview)**: edit content while seeing the storefront result in the Liveview Editor.
- **[Draft and Publish Workflow](./editor.html#editing-workflow)**: save drafts without changing live content, then publish when ready.
- **[Version History](./editor.html#version-history)**: review, restore, compare, pin, and name previous versions.
- **[Reusable Components](./working-with-components.html)**: build pages from prebuilt and project-specific content components.
- **[Rich Text and Variables](./features/rich-text-editor.html)**: write formatted copy and insert dynamic Magento variables and directives in rich text fields.
- **[Templates And Snippets](./features/templates-and-snippets.html)**: reuse complete layouts or smaller sections.
- **[Product And Category Attributes](./features/product-category-attributes.html)**: manage product and category descriptions with the same component editor.
- **[Translations](./features/translations.html)**: translate translatable fields per store view without duplicating the whole content structure.
- **[Content Scheduling](./features/content-scheduling.html)**: schedule Hyvä CMS content publication independently from Adobe Content Staging.
- **[Import/Export](./features/import-export.html)**: move pages, blocks, attributes, media, translations, history, and instance components between environments.
- **[Personalized Editing](./features/editor-preferences-and-user-settings.html)**: header arrangements, workspace views, per-user preferences and customizable keyboard shortcuts.
- **[REST And GraphQL APIs](./apis.html)**: integrate admin workflows through REST and fetch published page/block content through GraphQL.
- **[Additional Editor Features](./features/additional-editor-features.html)**: shareable draft previews, store view previews, conflict detection and other smaller editor tools, each with the Hyvä CMS version it arrived in.

The new [Media Gallery](features/media-gallery.html) is included with CMS `1.3.0`. You can disable its editor picker in configuration to use Magento's default picker.

## Optional Packages

The [Email & Newsletter Templates](../email-templates/index.html) module is generally available. [AI features (experimental)](../ai-worker/features.html) and [Form Builder](../form-builder/index.html) are also available as feature packages. Install and configure the integrations you need.

For a customized editor, see [CmsConnect integration and migration](cms-connect.html) and [Admin Styles](admin-styles.html).

For the upgrade from CMS `1.2.x` to `1.3.0`, see [Upgrading to Hyvä Commerce 1.4.0](../../upgrading/upgrading-to-1.4.0.html#hyva-cms).

## Who Uses Hyvä CMS

Merchants use Hyvä CMS to create and update content without editing Magento templates or CSS classes. Developers use it to define the reusable components, rendering templates, field types, and integration logic that keep the content output reliable.

The best projects treat Hyvä CMS as a design-system editor: merchants choose from clear, approved components, while developers control the HTML, styling, data access, and validation behind those components.
