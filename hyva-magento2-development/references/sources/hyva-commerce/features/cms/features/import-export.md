<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/features/import-export.html -->

# Editor Import & Export

Built something great on staging and need it on production? The Hyvä CMS Import/Export moves content between environments and copies content structures, so you never have to rebuild a page by hand.

It gives you two ways to move content:

- **ZIP transfer packages** for moving one or more content items along with their related data.
- **JSON import and export** for quickly copying the current content item's component structure.

Available since Hyvä CMS 1.2.0

The current transfer system, with ZIP packages, templates and snippets, and attribute and instance component transfers, was introduced in Hyvä CMS `1.2.0`, which shipped with Hyvä Commerce `1.3.0`. Earlier releases had a simpler import/export. The Import & Export dialog and JSON tab described on this page are available from Hyvä CMS `1.3.0`, which shipped with Hyvä Commerce `1.4.0`.

## Accessing the Import & Export Feature

Open the Hyvä CMS editor menu from the Hyvä logo in the top-left of the editor, then choose the import/export option.

[![Accessing Import and Export](../images/feature-editor-import-export.png)](../images/feature-editor-import-export.png)

## ZIP Export

Use ZIP export when moving Hyvä CMS content between environments, for example from staging to production.

Export can include:

- CMS pages
- CMS blocks
- Product attribute content
- Category attribute content
- Instance components
- Templates
- Snippets
- Media files referenced by the content
- Store-view translations
- Version history

The available content types are not fixed. Each type is provided by a handler, and third-party modules can register their own (see [For Developers](#for-developers) below). Templates and snippets, for example, are contributed by the `Hyva_CmsTemplate` module rather than the import/export module itself.

In the export tab, select a content type, search for entities, and add one or more items to the package. Switch content types to add other items; your existing selections stay in the package. The available types and actions depend on your admin permissions.

Only Hyvä CMS content is exportable

CMS pages and CMS blocks only appear in the export picker when they actually carry Hyvä CMS content. Pages and blocks that were never edited in the Liveview Editor are hidden from selection, and a direct export attempt is rejected server-side. This keeps non-Hyvä content out of transfer packages.

Export options include:

- **Images**: include referenced media files.
- **Translations**: include store-view translation CSV data.
- **History**: include version history.
- **Components**: include referenced instance components.

The ZIP contains a `manifest.json`, per-entity settings and content JSON, optional translation CSV files, and media files under an images directory.

## ZIP Import

Use ZIP import to restore or transfer a package created by the Import & Export feature. Drag a `.zip` file into the import tab, review its contents, select the items to import and choose the import behavior. If an item needs content that is missing from the destination, resolve the reported dependency before retrying.

The importer infers initial options from the uploaded package, including its manifest and available media, translation CSVs, history and instance components. Review these defaults before importing: they remain editable. Replacing the ZIP resets them from the replacement package, including supported older package layouts. A suggested option does not prove the destination has every required dependency.

Import options include:

- **Images**: import package media files.
- **Translations**: import translation data.
- **History**: import version history.
- **Components**: import instance component definitions.

Import behavior:

- **Replace**: overwrite matching content by identifier.
- **Import as new**: create a copy where the content type supports it.

CMS pages, CMS blocks, and instance components can be imported as new with generated copy identifiers. Product and category attribute content cannot be imported as new because the target product or category must already exist.

## Product and Category Attribute Transfers

Catalog attribute transfers are portable, but they do not create catalog entities.

- Product content is matched by SKU.
- Category content is matched by URL path.
- Attribute IDs are normalized to attribute codes.
- Product, category, CMS page, and CMS block links are normalized to portable identifiers where possible.

If a referenced entity cannot be found in the target environment, the import keeps the original value where possible and reports a warning.

## Transferring Instance Components

If content uses `instance/...` components, include components in the export. During import, Hyvä CMS imports instance components before importing the content that references them.

When importing as new, conflicting instance component identifiers can be remapped and matching component references inside imported content are updated.

## Transferring Media Files

The Import & Export feature can include referenced media files. During import, existing media files are not overwritten.

Supported media extensions include common image, video, document, and font formats such as `jpg`, `jpeg`, `png`, `gif`, `webp`, `svg`, `avif`, `ico`, `mp4`, `webm`, `mov`, `pdf`, `woff`, `woff2`, `ttf`, and `otf`.

## JSON Import and Export

Available since Hyvä CMS 1.3.0

The JSON tab is available from Hyvä CMS `1.3.0`.

The JSON tab is for the current content item only.

- **Export JSON** copies the current draft component structure or downloads it as a file.
- **Import JSON** accepts pasted JSON or an uploaded file, validates it, and replaces the current draft component structure.

Use JSON for quick copying, debugging, or moving a single structure manually. Use ZIP transfer when you need media, translations, history, related instance components, or multiple entities.

JSON import replaces the current draft

Importing JSON into the current editor item overwrites that item's draft component structure. Save or export the current draft first if you need a backup.

## For Developers

The Import/Export is handler-driven, so any module can make its own content type importable and exportable without touching the Import/Export module itself. See [Step 12: Register with Import/Export](../extending-for-other-content-types.html#step-12-optional-register-with-importexport) in Extending for Other Content Types. The handler extension point is available since Hyvä CMS `1.2.0`.

For custom transfer handlers, `MediaPathProviderInterface` includes media stored outside the component tree, such as an entity's featured image. Implementations of `ComponentNormalizerInterface`, registered in `ComponentNormalizerPool`, translate references inside components across content types, for example converting environment-specific IDs to portable identifiers and back. These interfaces and the pool live in `Hyva\CmsImportExport\Model\ContentType`; see the package's `src/cms-import-export/README.md` for the contracts. `ComponentNormalizerInterface`, `ComponentNormalizerPool` and `MediaPathProviderInterface` are available since Hyvä CMS `1.3.0`.
