<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/accessing-hyva-cms-editor.html -->

# Accessing Hyvä CMS

After [installing Hyvä CMS](installation.html), you open the Liveview Editor directly from the Magento admin. There is no separate Hyvä CMS menu to learn. You turn on Hyvä editing for the content you already work with (CMS pages, CMS blocks, and product or category attributes), then open the editor from that same screen.

## Opening the Editor for CMS Pages and Blocks

You can start a brand-new Hyvä CMS page or block, or switch an existing one over to the Hyvä editor.

**Create new content**

1. In the Magento admin, go to the page or block listing (`Content → Elements → Pages` or `Content → Elements → Blocks`).
2. Click **Add with Hyvä CMS**. The Liveview Editor opens on a new item.

**Convert existing content**

1. Open the CMS page or block you want to edit.
2. Set **Enable Hyvä Editor** to **Yes** and save.
3. Click **Edit with Hyvä CMS** to open the Liveview Editor.

[![Liveview Editor](./images/editor-screenshot.png)](./images/editor-screenshot.png)

## Opening the Editor for Product and Category Attributes

Available since Hyvä CMS 1.2.0

Product and category attribute editing is available from Hyvä CMS `1.2.0`, released with Hyvä Commerce `1.3.0`.

You can also edit compatible product and category attributes, such as descriptions, in Hyvä CMS.

1. Open a product or category edit form.
2. In the Hyvä CMS panel, turn on the attributes you want to edit with Hyvä CMS.
3. Save the entity, then open the editor for that attribute.

Compatible attributes are normally rich text or textarea-style fields, such as descriptions. The exact list is resolved by the installed compatibility rules. For the full merchant workflow, see [Product And Category Attributes](features/product-category-attributes.html).

## Finding Your Way Around the Editor

Inside the Liveview Editor, the **Hyvä menu** in the top-left opens the main workflows:

- Templates and snippets
- Import/Export
- Translations
- Editor preferences
- Page Builder migration
- Instance components, when the module and ACL permission are available

Common actions also have [keyboard shortcuts](features/keyboard-shortcuts.html), and each admin user can set their own [editor preferences and favourites](features/editor-preferences-and-user-settings.html).

## Understanding Content States

As you work, Hyvä CMS keeps each item in a clear state so you always know what is live:

- **Draft:** saved work that is not live.
- **Published:** content visible on the storefront.
- **Scheduled:** content prepared for a future publication release.
- **Enabled/Disabled:** whether Hyvä CMS output is active for that entity or attribute.

Disabling Hyvä CMS for a supported entity or attribute returns storefront output to the native Magento content for that item.
