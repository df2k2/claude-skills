<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/creating-custom-component-fields-types.html -->

# Creating Custom Component Fields Types

Advanced Developer Topic

Creating custom field types in Hyvä CMS is an advanced topic that should only be attempted by experienced developers. Be prepared to debug cases specific to your custom field type implementation.

Hyvä CMS custom field types allow developers to define custom input fields for CMS components. These custom field types control how content editors collect data in the Hyvä CMS editor interface, which is then used to render content on the frontend. This guide demonstrates how to create a custom field type within your Magento module, enabling you to build sophisticated and tailored content components for Hyvä CMS.

Custom field types are useful when the built-in Hyvä CMS field types (text, textarea, select, etc.) don't meet your specific requirements. For example, you might create a custom field type for a date range selector or an integration with an external API.

## Registering Custom Field Types in Dependency Injection

The first step in creating a custom field type for Hyvä CMS is to register the field type in your module's `di.xml` configuration. This registration maps a custom field type name to the template file that renders the field in the Hyvä CMS editor interface.

Add the following configuration to your module's `etc/adminhtml/di.xml` file:

```
<type name="Hyva\CmsLiveviewEditor\Model\CustomField">
    <arguments>
        <argument name="customTypes" xsi:type="array">
            <item name="foobar" xsi:type="string">YourVendor_YourModule::field-types/foobar.phtml</item>
        </argument>
    </arguments>
</type>
```

In this configuration, `foobar` is the custom field type name that you'll reference in your component configuration. The template path `YourVendor_YourModule::field-types/foobar.phtml` points to the template file that will render this custom field type in the editor.

## Adding Custom Field Types to Component Configuration

After registering your custom field type, add it to a component's configuration in the `components.json` file. This defines which fields in your component should use the custom field type.

```
"your_component": {
  "label": "Your Component",
  "content": {
    "foobar_field": {
      "type": "custom_type",
      "custom_type": "foobar",
      "label": "Foo Bar Field",
      "attributes": {
        "pattern": ".*(foo|bar|Foo|Bar).*"
      }
    }
  }
}
```

The `type` must be set to `custom_type` to tell Hyvä CMS to look for a custom field type. The `custom_type` value references the name you registered in the DI configuration (`foobar` in this example). The `attributes` object allows you to pass HTML5 validation attributes that Hyvä CMS will use for field validation.

## Creating the Custom Field Type Template

The custom field type template defines the HTML markup and Alpine.js behavior for your field in the Hyvä CMS editor interface. Create this template at the path you specified in the DI configuration (e.g., `view/adminhtml/templates/field-types/foobar.phtml`).

view/adminhtml/templates/field-types/foobar.phtml

```
<?php

declare(strict_types=1);

use Magento\Backend\Block\Template;
use Magento\Framework\Escaper;
use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\CmsLiveviewEditor\ViewModel\Adminhtml\FieldTypes;

/** @var Template $block */
/** @var Escaper $escaper */
/** @var ViewModelRegistry $viewModels */

/** @var FieldTypes $fieldTypes - Provides helper methods for custom field types */
$fieldTypes = $viewModels->require(FieldTypes::class);

// Component and field identifiers passed by Hyvä CMS editor
$uid = (string) $block->getData('uid');
$fieldName = (string) $block->getData('name');
$fieldValue = (string) $block->getData('value');

// Options from component configuration (same format as select field)
$options = (array) $block->getData('options');

// HTML attributes from component configuration (e.g., validation patterns)
$attributes = (array) $block->getData('attributes') ?? [];
$filteredAttributes = $fieldTypes->getDefinedFieldAttributes($attributes);

// Validation state from block (field type templates are not rendered with Magewire in scope)
$hasError = $block->getData('hasError');
$errorMessage = (string) ($block->getData('errorMessage') ?? '');

?>
<div class="field-container" id="field-container-<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>" <?= $hasError ? 'data-error' : '' ?>>
    <div class="radio-group flex gap-4">
        <?php foreach ($options as $option): ?>
            <label class="inline-flex items-center">
                <input type="radio"
                    name="<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>"
                    value="<?= $escaper->escapeHtmlAttr($option['value']) ?>"
                    <?= $option['value'] === $fieldValue ? 'checked' : '' ?>
                    @change="
                        updateWireField(
                            '<?= $escaper->escapeHtmlAttr($uid) ?>',
                            '<?= $escaper->escapeHtmlAttr($fieldName) ?>',
                            $event.target.value
                        )
                    "
                    class="form-radio <?= $hasError ? 'error field-error' : '' ?>"
                    <?php foreach ($filteredAttributes as $attr => $attrValue): ?>
                        <?= $escaper->escapeHtmlAttr($attr) ?>="<?= $escaper->escapeHtmlAttr($attrValue) ?>"
                    <?php endforeach; ?>>
                <span class="ml-2"><?= $escaper->escapeHtml($option['label']) ?></span>
            </label>
        <?php endforeach; ?>
    </div>
    <ul id="validation-messages-<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>" class="validation-messages list-none">
        <?php if ($hasError): ?>
            <li class="error-message text-red-600 text-sm mt-1">
                    <?= $escaper->escapeHtml($errorMessage) ?>
            </li>
        <?php endif; ?>
    </ul>
</div>
```

This template demonstrates a radio button group custom field type. The template receives component and field data from the Hyvä CMS editor through the `$block` variable. The `updateWireField` Alpine.js method (provided by Hyvä CMS) updates both the preview and server state immediately when a radio button is selected, ensuring server-side validation runs on every change.

## Required Markup Patterns for Custom Field Type Templates

Custom field type templates in Hyvä CMS must follow specific markup patterns to ensure proper integration with the editor's validation, preview updates, and error handling. The following sections describe each required element.

### Field Container Element

The root element of your custom field type template must be a `div` with the class `field-container` and a specific ID format:

```
<div class="field-container" id="field-container-<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>" <?= $hasError ? 'data-error' : '' ?>>
```

The ID must follow the pattern `field-container-{uid}_{fieldName}` where `{uid}` is the component's unique identifier and `{fieldName}` is the field's name from the component configuration. This ID format is required for Hyvä CMS validation to locate and highlight the field.

The `data-error` attribute must be conditionally added when `$hasError` is true. This attribute is required for validation error styling to work correctly in the Hyvä CMS editor.

Validation state from block data

Field type templates are always rendered by the panel block:

```
$hasError = $block->getData('hasError');
$errorMessage = (string) ($block->getData('errorMessage') ?? '');
```

This ensures validation errors display correctly in the editor panels.

**If you are upgrading from an older implementation:** Earlier versions exposed the Magewire component in the template scope when panels were rendered inline, so some custom field types used `$magewire->errors[$uid][$fieldName]` for validation state. Component edit panels are now loaded on demand via separate HTTP requests, so the Magewire component is no longer in scope when field type templates are rendered. Replace any use of `$magewire->errors` with the block data approach above, and remove the `use Hyva\CmsLiveviewEditor\Magewire\LiveviewComposer;` statement and the `@var LiveviewComposer $magewire` annotation from your template if they were only used for validation.

### Input Field Name Attribute

All input elements in your custom field type template must have a `name` attribute following this pattern:

```
name="<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>"
```

The name must be `{uid}_{fieldName}` for two critical functions in Hyvä CMS: frontend validation and the editor's ability to focus on your field when users click the field's value in the editor preview.

### Validation Messages Container

Include an element with the ID `validation-messages-{uid}_{fieldName}` to display validation error messages:

```
<ul id="validation-messages-<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>" class="validation-messages list-none">
```

This container is required for Hyvä CMS to inject validation error messages. If you need to place validation messages in a different location in your template, you can add a `data-validation-messages-selector` attribute to the field container element that points to your custom validation messages container using a CSS selector.

### Field Value Update Methods

Hyvä CMS provides two Alpine.js methods for updating field values in custom field types:

- **`updateWireField(uid, fieldName, value)`** *(recommended default)*: Updates both the preview and the server state through Magewire immediately. This method ensures server-side validation runs on every change and keeps the component state synchronized. Use this method unless you have a specific performance reason to avoid it.
- **`updateField(uid, fieldName, value)`** *(specialized use)*: Updates the preview directly via AJAX, bypassing Magewire. The field value is read from local state until the user saves the component. Use this method only when implementing debounced inputs or other scenarios where you need to minimize server requests for performance reasons.

Alpine Component Integration Limitation

If you add custom Alpine.js components to your field template, you cannot set field values through `updateField` or `updateWireField` from within your Alpine component. Keep input fields outside your Alpine component and update them with vanilla JavaScript from within your component.

### Field Attributes and HTML5 Validation

The `$filteredAttributes` variable in the template example provides access to field attributes passed from the component configuration. The `getDefinedFieldAttributes()` method filters the component configuration attributes to only include predefined field attributes while excluding attributes like `class` and `comment`. This filtered set includes validation attributes (such as `pattern`, `required`, `minlength`, `maxlength`), validation message attributes, and UI-related attributes.

Hyvä CMS automatically validates custom field types against HTML5 validation attributes when they are present. Apply the filtered attributes to your input elements to enable this validation.

For more information about available field attributes and how validation works, see the [Field Attributes and Validation](creating-components.html#adding-html5-validation-and-field-attributes) section in the component creation guide.

## Dynamically Setting Custom Field Type Values

After creating your custom field type template, you have complete control over how the field value is set and updated. Custom field type templates have access to Magento's full backend environment, allowing you to:

- Use Magento ViewModels and Blocks to fetch data
- Make REST or GraphQL API calls to Magento or external systems
- Connect to external services and APIs
- Implement custom business logic for field values
- Integrate with third-party JavaScript libraries

The field value is set through either the `updateField` or `updateWireField` method as described in the previous section. If you add custom Alpine.js components to your field template, keep input fields outside of your Alpine component and update them with vanilla JavaScript.

## Field Handlers for Complex UI Interactions

Field Handlers in Hyvä CMS are specialized Alpine.js-powered components that provide enhanced UI controls for complex data selection and input scenarios. Field Handlers can provide inline enhanced controls (like searchable dropdowns with keyboard navigation) or modal-based interfaces (like product selection with image grids). Field Handlers extend beyond native HTML form controls to enable sophisticated user interactions that better fit specific use cases.

### When to Use Field Handlers

Field Handlers are appropriate when the built-in Hyvä CMS field types and basic custom field types don't provide sufficient UI complexity for your data selection needs:

- **Visual selection interfaces**: Product selection requiring image grids, galleries, or visual previews
- **Multi-criteria selection**: Link configuration requiring tabs, conditional fields, or multiple related inputs
- **Searchable data with filters**: Large datasets requiring search, filtering, and pagination
- **Drag-and-drop ordering**: Selection interfaces requiring sortable lists with visual reordering
- **Complex validation workflows**: Multi-step data entry requiring validation at each stage

### Field Handler Architecture

Field Handlers in Hyvä CMS can be implemented using different architectural patterns depending on your UI requirements:

**Pattern 1: Inline Enhanced Control** (e.g., Searchable Select)
- The field template includes the enhanced UI directly (searchable dropdown, keyboard navigation, filtering)
- No separate handler modal template is needed
- All interaction happens within the field template using Alpine.js

**Pattern 2: Modal-Based Selection** (e.g., Product Handler, Link Handler)
- **Field Template**: Displays current selection summary and provides a trigger button to open the modal
- **Handler Template**: An Alpine.js-powered `<dialog>` element providing the full selection interface
- The field template dispatches events to open the handler modal
- The handler modal dispatches events back to update the field value

Choose the pattern that best fits your use case. Inline enhanced controls work well for simpler interactions, while modal-based selection is better for complex workflows with multiple steps or large datasets.

Modal Handler Communication Pattern

Modal-based handlers use the Alpine.js event system for communication. The field template dispatches a custom window event (e.g., `toggle-product-select`) with initialization data. The handler listens for this event, opens the modal, and dispatches an `editor-change` event when the user saves their selection.

### Creating a Field Handler

Creating a Field Handler involves creating a custom field template and optionally a separate handler modal template if your use case requires modal-based selection.

Handler Modal Template is Optional

Not all Field Handlers require a separate modal template. Inline enhanced controls (like the searchable select handler) implement all functionality directly in the field template. You only need a separate handler modal template when implementing modal-based selection workflows.

#### Step 1: Create the Field Template

For modal-based Field Handlers, the field template provides a trigger button and hidden input field that delegates the selection UI to a modal dialog. This example demonstrates the modal-based pattern:

view/adminhtml/templates/field-types/product-selector.phtml

```
<?php
declare(strict_types=1);

use Magento\Backend\Block\Template;
use Magento\Framework\Escaper;
use Hyva\CmsLiveviewEditor\Magewire\LiveviewComposer;

/** @var Template $block */
/** @var Escaper $escaper */
/** @var LiveviewComposer $magewire */

$uid = (string) $block->getData('uid');
$fieldName = (string) $block->getData('name');
$fieldValue = (string) $block->getData('value');

// Validation markup (see "Required Markup Patterns" section)
$hasError = isset($magewire->errors[$uid][$fieldName]);
?>
<div class="field-container" id="field-container-<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>" <?= $hasError ? 'data-error' : '' ?>>
    <!-- Hidden input stores the field value -->
    <input type="hidden"
        id="<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>"
        name="<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>"
        value="<?= $escaper->escapeHtmlAttr($fieldValue) ?>"
        @change="
            updateWireField(
                '<?= $escaper->escapeHtmlAttr($uid) ?>',
                '<?= $escaper->escapeHtmlAttr($fieldName) ?>',
                $event.target.value
            )
        "
        class="<?= $hasError ? 'error field-error' : '' ?>"
    >

    <!-- Trigger button dispatches event to open handler -->
    <button type="button"
        class="btn btn-primary"
        @click="$dispatch('toggle-product-select', {
            isOpen: true,
            uid: '<?= $escaper->escapeJs($uid) ?>',
            fieldName: '<?= $escaper->escapeJs($fieldName) ?>',
            fieldValue: $el.previousElementSibling.value
        })"
    >
        Select Products
    </button>

    <!-- Validation messages container -->
    <ul id="validation-messages-<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>" class="validation-messages list-none">
        <!-- Error messages appear here -->
    </ul>
</div>
```

This field template uses a hidden input to store the field value and a button that dispatches the `toggle-product-select` event to open the handler modal. The event passes the component UID, field name, and current field value as initialization data. The validation markup follows the same patterns described earlier in the "Required Markup Patterns" section.

Inline Enhanced Controls

For inline enhanced controls (like searchable select), implement the enhanced UI directly in the field template using Alpine.js. You don't need a separate handler modal template—all functionality lives in the field template itself.

#### Step 2: Create the Handler Modal Template (Optional)

For modal-based Field Handlers, create a separate handler modal template. This template is rendered once on the page (outside the component editor) and responds to events from any field using this handler:

view/adminhtml/templates/handlers/product-selector-handler.phtml

```
<?php
declare(strict_types=1);

use Magento\Backend\Block\Template;
use Magento\Framework\Escaper;

/** @var Template $block */
/** @var Escaper $escaper */
?>
<dialog class="max-w-screen-xl w-screen bg-white shadow-xl rounded-lg flex flex-col"
    x-data="initProductSelectHandler()"
    x-htmldialog="open = false"
    closeby="any"
    x-show="open"
    x-transition
    @toggle-product-select.window="initializeModal($event.detail)"
>
    <!-- Header, search, and selection UI implementation -->
    <div class="flex-1 overflow-y-auto p-6">
        <!-- Your selection interface: product grid, search, filters, etc. -->
    </div>

    <!-- Footer: Action buttons -->
    <div class="p-4 flex gap-4">
        <button type="button" class="btn" @click="open = false">
            <?= $escaper->escapeHtml(__('Cancel')) ?>
        </button>
        <button type="button" class="btn btn-primary" @click="saveProducts">
            <?= $escaper->escapeHtml(__('Save')) ?>
        </button>
    </div>
</dialog>

<script>
function initProductSelectHandler() {
    return {
        open: false,
        uid: null,
        fieldName: null,
        activeProducts: [],

        // Initialize modal when field template dispatches event
        initializeModal({ isOpen, uid, fieldName, fieldValue } = {}) {
            this.uid = uid;
            this.fieldName = fieldName;

            // Parse current field value
            try {
                this.activeProducts = JSON.parse(fieldValue || '[]');
            } catch (e) {
                this.activeProducts = [];
            }

            // Open the modal
            this.open = isOpen;

            // Implement your initialization logic:
            // - Load data from APIs
            // - Reset search/filter state
            // - Render selected items
        },

        // Save selection and dispatch editor-change event
        saveProducts() {
            this.$dispatch('editor-change', {
                name: this.uid,
                field: this.fieldName,
                value: this.activeProducts,
                saveState: true
            });

            this.open = false;
        }
    }
}
</script>
```

The handler modal uses the `x-htmldialog` Alpine.js plugin to manage modal open/close state. The two critical methods are:

- **`initializeModal`**: Receives data from the field template event, parses the current field value, and opens the modal
- **`saveProducts`**: Dispatches the `editor-change` event with the selected data, which updates the field value and triggers Magewire synchronization

The rest of the Alpine.js component implements your specific selection logic—search, filtering, data fetching, and UI interaction patterns.

#### Step 3: Register the Field Template and Handler Modal

Register the field template in your module's `etc/adminhtml/di.xml`:

etc/adminhtml/di.xml

```
<!-- Register the field type (same as basic custom field types) -->
<type name="Hyva\CmsLiveviewEditor\Model\CustomField">
    <arguments>
        <argument name="customTypes" xsi:type="array">
            <item name="product_selector" xsi:type="string">
                YourVendor_YourModule::field-types/product-selector.phtml
            </item>
        </argument>
    </arguments>
</type>
```

The field template registration uses the same `Hyva\CmsLiveviewEditor\Model\CustomField` DI type as basic custom field types (described earlier in this guide).

Register your field handler in your module's layout XML at `view/adminhtml/layout/liveview_editor_index.xml`:

view/adminhtml/layout/liveview\_editor\_index.xml

```
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="content">
            <block name="product_selector_handler"
                   template="YourVendor_YourModule::handlers/product-selector-handler.phtml"/>
        </referenceContainer>
    </body>
</page>
```

This layout XML ensures the handler modal is rendered once on the Hyvä CMS editor page and available to all components using this field type. For inline enhanced controls, you only need the field template registration—no layout XML is required.

Then add the field to your component configuration in `components.json`:

```
"your_component": {
  "label": "Your Component",
  "content": {
    "products": {
      "type": "custom_type",
      "custom_type": "product_selector",
      "label": "Select Products"
    }
  }
}
```

The component configuration references the field type name (`product_selector`) registered in DI. The handler modal is available globally on the editor page through the layout XML registration.

### Field Handler Data Exchange

Field Handlers exchange data with the field template through a specific event protocol that ensures proper synchronization with the Hyvä CMS editor state.

#### Initialization Event Structure

The field template dispatches an initialization event with this structure:

```
$dispatch('toggle-handler-name', {
    isOpen: true,              // Boolean: open the modal
    uid: 'component_123',      // String: component unique ID
    fieldName: 'products',     // String: field name from component config
    fieldValue: '[]',          // String: current field value (JSON-encoded)
    maxSelected: 25            // Any additional config parameters
})
```

The handler modal listens for this event with `@toggle-handler-name.window` and receives the detail object in the `initializeModal` method. Always parse `fieldValue` with error handling as it may contain invalid JSON if the field is empty or corrupted.

#### Save Event Structure

The handler modal dispatches a save event with this structure:

```
$dispatch('editor-change', {
    name: this.uid,                    // String: component UID (not fieldName!)
    field: this.fieldName,             // String: field name
    value: this.selectedProducts,      // Any: new field value (will be JSON-encoded)
    saveState: true                    // Boolean: true triggers Magewire sync
})
```

The `editor-change` event is a global Hyvä CMS event that updates the hidden input field, triggers Magewire synchronization (if `saveState: true`), and updates the preview. The `value` property can be any JSON-serializable data structure—Hyvä CMS will automatically encode it when storing.

Event Name vs Field Name

The `editor-change` event uses `name` for the component UID and `field` for the field name. This differs from the initialization event structure. Using `fieldName` instead of `field` in the save event will cause the update to fail silently.

### Built-In Field Handler Reference

Hyvä CMS includes several built-in Field Handlers that serve as implementation examples and are available for use in custom components.

| Handler | Architecture | Use Case | Key Features | Location |
| --- | --- | --- | --- | --- |
| **Product Handler** | Modal-based | Product selection with images | Image grid, search, active/available split, sorting | `product-handler.phtml` |
| **Link Handler** | Modal-based | Multi-type link configuration | Tabs for link types, conditional fields, validation, advanced options | `link-handler.phtml` |
| **Searchable Select** | Inline enhanced | Enhanced dropdown selection | Inline dropdown, keyboard navigation, client-side filtering | `searchable-select-handler.phtml` |

All built-in handlers are located in `Hyva_CmsLiveviewEditor::page/js/` in the Hyvä CMS Liveview Editor module. Examine these implementations for patterns, UI components, and best practices when building custom Field Handlers.

Starting Point for Custom Handlers

Copy a built-in handler that most closely matches your use case as a starting point. The product handler demonstrates the modal-based pattern with visual selection, the link handler shows multi-step workflows with conditional fields, and the searchable select demonstrates inline enhanced controls. These patterns provide a foundation, but you can implement Field Handlers in whatever way best serves your specific requirements.

## Related Topics

- **[Creating Components](creating-components.html)** - Learn how to create custom components that use your custom field types and Field Handlers
- **[Field Attributes and Validation](creating-components.html#adding-html5-validation-and-field-attributes)** - Detailed information about field validation in Hyvä CMS
- **[Component Configuration Schema](component-declaration-schema.html)** - Reference for configuring custom field types in `components.json`
