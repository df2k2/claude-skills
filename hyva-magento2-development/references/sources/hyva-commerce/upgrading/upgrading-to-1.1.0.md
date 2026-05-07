<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-1.1.0.html -->

# Upgrading to Hyvä Commerce 1.1.0

The 1.1.0 release of Hyvä Commerce introduces translation functionality for Hyvä CMS content, allowing a single page to have different values across locales.
Additionally, significant optimisation changes should speed up any actions that require a server update.

## Notable news

### Hyvä CMS

#### Translations

Want to share one page but have different text content across different store views? Well now you can! We've got some docs for this one, see the [Translations](../features/cms/features/translations.html) documentation.

#### Optimisations, optimisations, optimisations!

One of the biggest performance improvements in this release is how editor panels are loaded. Previously, all component edit panels were pre-loaded when the liveview editor initialized or when Magewire updated. Now, panels are built only when required.

**Benefits:**

- Significantly reduced LiveView Composer response payload
- Faster editor initialization
- Only the panels you actually use are rendered in the DOM
- Reduced memory usage for complex pages

The iframe preview also now skips unnecessary updates. When the editor is only saving state (not changing content), the preview update is skipped entirely. This prevents redundant iframe refreshes when the content will need to update again after saving to Magewire anyway.
Combined with less frequent `saveState` calls (now combined with content updates where possible), the editor feels more responsive.

#### New Components

- **Marquee**: Scrolling text/content component
- **Card**: Two style variants available
- **Embed**: Video embedding component
- **Category Field**: Select multiple category IDs (thanks for the initial work Antoni Tormo - Onestic!)

#### REST and GraphQL Endpoints

Hyvä CMS Pages and Blocks are now accessible via REST and GraphQL APIs, including:
- `rendered_html` field for server-rendered content
- `tailwind_css` field for JIT-compiled styles

#### Component Context Flags

New `context_flags` support allows restricting which components can be used as root components for specific entities. Pass `allowed_root_component_context_flags` when emitting the `init-content-properties` event.

#### Max Nesting Level

Components can now define a `max_nesting_level` to automatically hide children containers and related UI beyond a specified depth.

#### Script Injection Blocks

New layout blocks for injecting scripts in liveview preview mode:

- `after-body-start`: Early script injection
- `additional-scripts-preview`: Conditional script loading

#### Other Notable Changes

- **Pagebuilder Migration**: No longer experimental, does not require toggle in editor preferences
- **Product Slider**: Now uses Hyvä Default Theme Slider template for consistency
- **Link Handler**: Shows category path for better navigation
- **Container class**: Added to Tailwind safelist to reduce configuration issues
- **`componentPath=false`**: Support for explicit template usage via `setTemplate()`
- **symfony/http-foundation dependency**: Removed to avoid conflicts on new Magento installs. HTTP constants previously from this library are now defined directly in Livewire.php.
- Many bug fixes!

## Possible Breaking Changes

### Custom Field Type Validation

If your custom field types use Magewire to show validation errors in the editor, update them to the new pattern.

**Migration:** Read validation state from the block instead as the Magewire component is no longer in scope as the panels are now loaded on demand.

```
$hasError = $block->getData('hasError');
$errorMessage = (string) ($block->getData('errorMessage') ?? '');
```

Also remove the `use Hyva\CmsLiveviewEditor\Magewire\LiveviewComposer;` statement and the `@var LiveviewComposer $magewire` annotation from your custom field type template if they are only used for errors.

See [Creating custom component field types](../features/cms/creating-custom-component-fields-types.html#required-markup-patterns-for-custom-field-type-templates) documentation for more information.

### Wrapper Div Display Change

Previous to this release all components had a wrapper div in both preview and storefront. This is now removed from the storefront, and the wrapper div is only shown in the editor preview with the CSS rule `display: contents` (i.e. see `Hyva_CmsLiveviewEditor::elements/ROOT.phtml` template). This helps reduce the DOM complexity and improve performance.

If you had any customisations relying on these wrapper divs, for example CSS or JavaScript targeting these divs, or using them for child layout, you may need to make some updates to your customisations.

Or you can restore the previous behaviour by enabling legacy liveview-content wrapper divs in Store Configuration > Hyvä CMS > Advanced.

### Component Panel Forms

The component panels within the Hyvä CMS Editor which contains the forms for editing a component are now loaded on demand via separate HTTP requests rather than from the Magewire response. This is unlikely to affect most installs, as these panels are a core part of Hyvä CMS and were not intended to be customised. However, if you have made customisations to them, you may need to make some updates.

## Known Issues

- None so far
