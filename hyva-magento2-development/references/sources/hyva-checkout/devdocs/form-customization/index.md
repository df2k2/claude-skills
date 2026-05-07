<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/index.html -->

# Hyvä Checkout Form Customization

Hyvä Checkout ships with a dedicated form customization API for modifying shipping and billing address forms. You can add, remove, or modify form fields while keeping everything compatible with other customizations and future Hyvä Checkout updates.

## What Are Hyvä Checkout Entity Forms?

The term "Entity Form" in Hyvä Checkout refers to a custom PHP abstraction for collecting structured data - not the HTML `<form>` element itself. An entity form represents the complete set of fields, validation rules, and display logic needed to collect entity data like a shipping or billing address.

Hyvä Checkout uses entity forms to handle address collection during checkout. The entity form abstraction provides methods to manipulate fields programmatically before rendering them as HTML in the Magewire component.

## When to Use Hyvä Checkout Form Customization

Use the Hyvä Checkout form customization API when you need to:

- Add custom fields to shipping or billing address forms (for example, delivery instructions or gate codes)
- Remove fields that are not relevant for your store (for example, company name for B2C stores)
- Modify field properties like labels, validation rules, or visibility
- Conditionally show or hide fields based on other field values (for example, hide certain fields for specific countries)
- Change the order or grouping of address form fields

The form customization API makes sure your changes integrate properly with other modules and stay compatible across Hyvä Checkout updates.

## Why Entity Forms Instead of a Plain Magewire Component?

Magento entities like customers and addresses support dynamic attributes through the EAV (Entity-Attribute-Value) system. The number of attributes, their types, and their validation constraints vary across different Magento installations.

Rendering an address form means iterating over attributes, determining the right input type for each, applying validation constraints, and generating the corresponding HTML elements. Different stores have different address requirements based on their configuration and installed extensions.

A plain Magewire component can not accommodate this variability without extensive conditional logic. The Hyvä Checkout entity form abstraction solves this by providing:

- **Dynamic attribute handling** - Automatically renders all configured address attributes
- **Type-aware rendering** - Selects appropriate input types based on attribute configuration
- **Validation integration** - Applies Magento validation rules to fields
- **Customization hooks** - Allows modifications without editing core files
- **Conflict prevention** - Merges customizations from multiple modules

When to use a regular Magewire component

If you are building a form that does not depend on Magento EAV attributes (for example, a static contact form or survey), a regular Magewire component is the simpler choice. Entity forms are specifically designed for EAV-backed data collection.

## How the Hyvä Checkout Form Customization System Works

The Hyvä Checkout form system operates through several coordinated components:

1. **Form Builders** - Core classes that construct forms from Magento's EAV attribute configuration
2. **Form Modifiers** - Your customization code that registers callbacks for form lifecycle events
3. **Modification Hooks** - Named events during form processing where your callbacks execute
4. **Renderers** - Components that convert form elements into HTML markup

Your customizations primarily use form modifiers to register callbacks. These callbacks execute at specific points in the form lifecycle, so you can manipulate the form structure before rendering.

## Hyvä Checkout Form Customization Building Blocks

Hyvä Checkout provides several PHP interfaces that work together to power form customization. Here is a quick overview of each:

**EntityFormInterface**
: Represents the complete form instance. This is the top-level object you interact with when customizing a form.

**EntityFormModifierInterface**
: Your entry point for registering customizations. Implement this interface in your module to hook into the form lifecycle.

**EntityFieldInterface**
: Represents an individual input field. Use this interface to read or change field properties like labels, validation rules, and default values.

**EntityFormElementInterface**
: Represents any form component, including fields, labels, separators, and other elements. This is the base interface that EntityFieldInterface extends.

For detailed method signatures and usage examples, see the [Entity Form Interfaces](entity-form-interfaces.html) reference.

## Related Topics

- **[Entity Form Interfaces](entity-form-interfaces.html)** - Full reference for EntityFormInterface, EntityFieldInterface, and related interfaces
- **[Entity Form Modifiers](entity-form-modifiers.html)** - How to register and implement form modifier classes
- **[Field Attributes](field-attributes.html)** - Available attributes you can set on form fields
- **[Setting Field Values](setting-field-values.html)** - How to set and override field values programmatically
- **[Interdependent Fields](interdependent-fields.html)** - Working with fields that depend on each other's values
- **[Form API Overview](../form-api/index.html)** - Lower-level form construction, rendering, and validation details
