<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/features/import-export.html -->

# Editor Import & Export

**Import & Export** in the Hyvä CMS editor lets you export a single Hyvä CMS content item (for example a page, block, or custom content type) as Hyvä JSON and import it back. You use this to move content between environments, reuse structures, or duplicate content without re-entering it in the editor.

## How to access Import and Export in the Hyvä CMS editor

To use Import or Export, open the editor menu from the green Hyvä logo and choose the action you need.

1. **Open the editor menu** - Click the green Hyvä logo in the top-left of the Hyvä CMS editor.
2. **Choose Import or Export** - In the dropdown, select **Import** or **Export**.
3. **Export** - Opens the **Export Hyvä JSON** modal with the current page structure as JSON. Use **Copy to Clipboard** to copy the JSON.
4. **Import** - Lets you paste or upload Hyvä JSON to replace or merge the current content item.

[![Accessing Import and Export](../images/feature-editor-import-export.jpg)](../images/feature-editor-import-export.jpg)

The screenshot shows: (1) Hyvä logo to open the menu, (2) Import and Export in the menu, (3) Export Hyvä JSON modal with copy button.

Moving content between environments

Use Export to copy the Hyvä JSON, then paste it in the target environment's editor via Import. Handy for syncing pages or blocks from staging to production.

## Hyvä JSON export format

The exported JSON describes the page or content structure. You can edit this JSON (for example to tweak blocks or copy sections) and re-import it into the Hyvä CMS editor. The editor will replace or merge the content based on your Import choice.

## Related Topics

- **[Hyvä CMS APIs](../apis.html)** - REST and GraphQL APIs for programmatic access to CMS content (bulk or automated import/export).
