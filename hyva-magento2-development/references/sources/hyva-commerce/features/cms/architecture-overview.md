<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/architecture-overview.html -->

# Hyvä CMS Architecture and Technical Overview

This document provides a technical overview of Hyvä CMS architecture, explaining how the system works from both user and developer perspectives.

## Introduction to Hyvä CMS

Hyvä CMS is a component-based content management system built for Magento that provides a live preview editing experience. Hyvä CMS stores content as structured JSON data representing a tree of components. Each component is declared in a `components.json` file defining its editable fields and a template file rendering its HTML output.

The Hyvä CMS system enables merchants to build content visually using a component-based editor while maintaining full control over the rendered HTML through Magento template files. This approach combines the ease of visual editing with the flexibility of custom templates.

## System Architecture Overview

Hyvä CMS consists of multiple modules that work together to provide the complete content management solution. Each module handles a specific aspect of the CMS functionality, from content editing to frontend rendering.

**liveview-editor**: The liveview-editor module provides the Liveview Editor interface, preview system, component discovery, content storage handling, version history, and more. This module contains the core editing experience that merchants interact with in the Magento admin panel.

**hyva-cms-magewire**: The hyva-cms-magewire module is a forked version of [Magewire v1.11.1](https://github.com/magewirephp/magewire/tree/1.11.1) customized for Hyvä CMS and admin panel use. This module provides reactive PHP components with property persistence and dynamic rendering capabilities for the editor interface. The Magewire framework enables the real-time updates that make the Liveview Editor responsive.

**magento-cms**: The magento-cms module serves as the integration layer connecting Hyvä CMS with Magento's native CMS Page and CMS Block entities. This module uses plugins to intercept content retrieval methods and replace Magento's default content with Hyvä CMS rendered content. The magento-cms module ensures seamless integration with existing Magento CMS functionality.

**components-base**: The components-base module provides pre-built components including text, headings, grids, groups, images, buttons, cards, banners, sliders, accordions, and other base components. These components can and often should be overridden or disabled in your project module to align with your project's design system and brand guidelines. The components-base module serves as a starting point that developers customize for their specific needs.

**scheduling**: The scheduling module provides a content scheduling system allowing merchants to schedule content publication and unpublishing at specific times. This module manages the timing of content state changes, enabling merchants to prepare content in advance and schedule it to go live automatically.

## How Hyvä CMS Works

### User Perspective: Content Editing Workflow

Merchants enable Hyvä CMS on CMS Pages and CMS Blocks through the Magento admin panel. Once enabled, merchants can open the Liveview Editor to build content using components. The Liveview Editor provides a live preview that updates in real-time as changes are made, allowing merchants to see exactly how their content will appear on the frontend.

Available Content Types

CMS Pages and Blocks are currently supported. Catalog and product attributes support is coming soon. Third-party content types like blogs may also support Hyvä CMS, depending on the vendor.

Content is managed in two states: draft (work in progress) and published (live on the frontend). Merchants can save drafts, preview them via shareable URLs, and publish when ready. The Hyvä CMS system maintains version history automatically, allowing merchants to review and revert to previous versions if needed.

### Technical Architecture: Component Discovery and Registration

The Hyvä CMS component discovery system scans all Magento modules for component declarations. Components are declared in JSON files (`etc/hyva_cms/components.json`) within Magento modules. The `Component\Collector` class scans all modules, validates declarations against a JSON schema, processes includes and source model options, and builds a unified component registry. The component registry is cached in Magento's production mode for performance, ensuring fast component lookup during rendering.

Each component declaration must include a unique identifier and editable fields definition. The template path is optional in the component declaration; if not specified, Hyvä CMS defaults to a standard template path within the module's directory structure. The Component\Collector validates that all required fields are present and correct during component discovery. During rendering, if a component template is not found, Hyvä CMS displays an error message in the editor preview with a hint to help developers identify and fix the missing template.

### Technical Architecture: Content Storage

Hyvä CMS stores content as structured JSON data in dedicated database tables. Each content group contains a tree of components, with user-entered field values stored within each component's JSON structure. The JSON structure preserves the hierarchical relationship between components, allowing nested layouts and component groups.

Version history is stored in separate database tables. Each time content is saved, Hyvä CMS creates a new version record in the version history table. This version history system enables merchants to review changes over time and revert to earlier versions when needed.

### Technical Architecture: Frontend Rendering

When Hyvä CMS is enabled for a CMS Page or CMS Block entity, plugins intercept Magento's content retrieval methods (`getContent()` for pages and blocks). The plugins check if Hyvä CMS is enabled for the entity, load the published content JSON from the database, and render it using the component system.

The `ROOT.phtml` template serves as the entry point for Hyvä CMS rendering. The ROOT template iterates through the component tree stored in the JSON data and renders each component using its declared template path. Component templates follow Magento's standard template system and can use ViewModels, block methods, and all Magento template features. This approach ensures that Hyvä CMS components have full access to Magento's rendering capabilities while maintaining the structured content model.

### Technical Architecture: Liveview Editor

The Liveview Editor uses the forked Magewire framework for reactive state management. The `LiveviewComposer` Magewire component class manages the content tree, handles saves, and coordinates preview updates. When merchants make changes in the editor, the LiveviewComposer class syncs component properties and triggers preview updates.

The LiveviewComposer class maintains the component tree structure in memory as merchants edit. Each component's editable fields are bound to Magewire properties, enabling two-way data binding between the editor interface and the component data. When merchants save changes, the LiveviewComposer serializes the component tree to JSON and persists it to the database.

### Technical Architecture: Preview System

The Liveview Editor displays preview content in an iframe that loads a frontend URL. When merchants make changes in the editor, the parent window makes AJAX requests to fetch updated content, then sends that content to the iframe via postMessage for real-time updates. This architecture enables the live preview experience without requiring full page reloads.

Preview URLs can also be opened in new tabs and shared with colleagues. These preview URLs include security tokens that are valid for one week, allowing merchants to share draft content for review. Preview rendering uses the same component templates as the frontend, ensuring accuracy between preview and live content. Preview requests bypass cache to show draft content, ensuring merchants always see their latest changes.

## Extension Points

Hyvä CMS is designed to be extensible, providing multiple extension points for developers to customize and extend the system. Developers can create custom components, override base components, define custom field types, and add support for additional content types beyond CMS Pages and Blocks.

The component system allows developers to declare new components in their own modules, following the same JSON declaration format used by the components-base module. Developers can also override existing component templates to customize rendering, or disable base components entirely if they don't fit the project's needs.

Custom field types enable developers to create specialized input controls for component editing. These custom field types integrate with the Liveview Editor interface, providing merchants with appropriate editing controls for complex data types.

Adding support for additional content types requires implementing the Hyvä CMS integration layer for the target entity. This typically involves creating plugins that intercept content retrieval methods and implementing the necessary database schema to store Hyvä CMS content for the new entity type.

## Related Topics

- **[Creating Components](creating-components.html)** - Learn how to build custom components for your Hyvä CMS implementation
- **[Overriding Existing Components](overriding-existing-components.html)** - Customize base components to match your design system
- **[Component Declaration Schema](component-declaration-schema.html)** - Reference documentation for component field definitions and structure
- **[Creating Custom Field Types](creating-custom-component-fields-types.html)** - Build specialized input controls for component editing
- **[Extending for Other Content Types](extending-for-other-content-types.html)** - Add Hyvä CMS support to custom Magento entities
