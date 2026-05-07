<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/accessing-hyva-cms-editor.html -->

# Accessing Hyvä CMS

Once installed, the Hyvä CMS Liveview Editor can be accessed in two ways:

- **From listings:** Go to the Magento Admin CMS page or Block listing and click the "Add with Hyvä CMS" button.
- **From existing content:** Open a Magento CMS Page or Block Form, toggle "Enable Hyvä Editor" to "Yes", and click the "Edit with Hyvä CMS" button.

[![Liveview Editor](images/editor-screenshot.png)](images/editor-screenshot.png)

## Module Architecture

Hyvä CMS is composed of four main modules:

- **`components-base`** - Core UI components and base functionality
- **`liveview-editor`** - The visual editor interface and preview system
- **`magento-cms`** - Integration with Magento CMS Pages and Blocks
- **`hyva-cms-magewire`** - Magewire integration for reactive components

## Content States

Hyvä CMS manages content through different states:

- **Draft** - Content being worked on but not published
- **Published** - Live content visible on the frontend
- **Enabled/Disabled** - Controls whether content is active

Info

New content types will be supported in future releases such as categories description, product description, etc.
