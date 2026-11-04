<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/entity-form-interfaces.html -->

# EntityForm Interface Reference for Hyvä Checkout

Hyvä Checkout uses a set of PHP interfaces to build and customize shipping and billing address forms in the checkout process. These interfaces - `EntityFormInterface`, `EntityFieldInterface`, `EntityFormElementInterface`, `EntityFormModifierInterface`, `RendererInterface`, and `EntityFormSaveServiceInterface` - are the building blocks you'll work with when adding, removing, or modifying checkout address form fields.

Most customizations don't require you to implement these interfaces from scratch. Instead, you'll interact with existing instances through [form modifiers](entity-form-modifiers.html). This reference helps you understand what each interface does and when you'd reach for it.

## EntityFormInterface - The Hyvä Checkout Form Container

`\Hyva\Checkout\Model\Form\EntityFormInterface`

The `EntityFormInterface` represents the complete form for collecting entity data like a shipping or billing address. Think of it as the top-level container that holds all form fields, elements, and configuration for one address form.

Hyvä Checkout ships with two concrete implementations of `EntityFormInterface`:

`EavAttributeShippingAddressForm`
:   Handles shipping address collection during checkout. This form builds its fields from Magento's EAV address attributes configured for the shipping address.

`EavAttributeBillingAddressForm`
:   Handles billing address collection during checkout. This form builds its fields from Magento's EAV address attributes configured for the billing address.

You typically access `EntityFormInterface` instances inside your form modifier callbacks, where Hyvä Checkout passes the form as a parameter. From there, you can call methods to add fields, remove fields, or rearrange the form structure.

You won't need custom form implementations

Creating a custom `EntityFormInterface` implementation is technically possible, but it's rarely necessary. The standard `EavAttributeShippingAddressForm` and `EavAttributeBillingAddressForm` cover virtually all checkout scenarios. Stick with [form modifiers](entity-form-modifiers.html) for your customizations.

## EntityFormElementInterface - Non-Input Form Components

`\Hyva\Checkout\Model\Form\EntityFormElementInterface`

The `EntityFormElementInterface` represents any component that can appear inside a Hyvä Checkout form. This is the base interface for all form components, including input fields, informational text, images, separators, and structural containers.

Form elements support hierarchical organization, so you can group related elements together for rendering. This parent-child structure helps maintain visual organization in checkout address forms - for example, grouping street address lines under a common container.

Use `EntityFormElementInterface` when you need to add non-input components to the form. If you want to display a help message below the address fields, show an icon next to a field group, or insert a visual separator between sections, `EntityFormElementInterface` is the right interface.

Note

`EntityFieldInterface` (described below) extends `EntityFormElementInterface`. Every input field is also a form element, but not every form element is an input field. When you work with the form's element collection, you may encounter both fields and non-field elements.

## EntityFieldInterface - Hyvä Checkout Address Form Input Fields

`\Hyva\Checkout\Model\Form\EntityFieldInterface`

The `EntityFieldInterface` represents input elements in Hyvä Checkout address forms - the fields where customers type their name, street address, city, and other data. `EntityFieldInterface` extends `EntityFormElementInterface`, inheriting all element capabilities while adding input-specific functionality like validation, value persistence, and data binding.

This is the interface you'll interact with most often when customizing checkout forms. Common operations with `EntityFieldInterface` include:

- Reading or changing a field's label, placeholder, or CSS classes
- Setting validation rules (required, max length, pattern matching)
- Getting or setting the field's current value
- Controlling field visibility and sort order

For a complete list of properties you can set on fields, see [Field Attributes](field-attributes.html). To learn how to set field values programmatically, see [Setting Field Values](setting-field-values.html).

## EntityFormModifierInterface - The Customization Entry Point

`\Hyva\Checkout\Model\Form\EntityFormModifierInterface`

The `EntityFormModifierInterface` is where most Hyvä Checkout form customizations begin. By implementing this interface, you register callbacks that execute at specific points during the form lifecycle - letting you add fields, remove fields, change properties, or rearrange the form structure.

The modifier pattern is what makes Hyvä Checkout's form system extensible. Multiple modules can each register their own form modifiers, and Hyvä Checkout merges all modifications without conflicts. Your modifier doesn't need to know about other modules' customizations.

Here's what a basic form modifier looks like:

```
<?php

declare(strict_types=1);

namespace Vendor\Module\Model;

use Hyva\Checkout\Model\Form\EntityFormInterface;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;

// Implement EntityFormModifierInterface to hook into Hyva Checkout's form lifecycle
class CustomAddressModifier implements EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface
    {
        // Add, remove, or modify fields on the form
        $form->registerModificationListener(
            'myModificationIdentifier',
            'form:build',
            [$this, 'modifyForm']
        );

        return $form;
    }

    public function modifyForm(EntityFormInterface $form): void
    {
        // Your customization logic goes here
    }
}
```

For detailed implementation guidance, including how to register your modifier with Hyvä Checkout and the full list of available lifecycle hooks, see [Implementing EntityFormModifierInterface](entity-form-modifiers.html).

## RendererInterface - Form Element Display Customization

`\Hyva\Checkout\Model\Form\EntityFormElement\RendererInterface`

The `RendererInterface` controls how Hyvä Checkout form elements are converted to HTML output. Each form element type has a renderer that determines its markup, CSS classes, and overall HTML structure.

Hyvä Checkout includes default renderer implementations that handle standard rendering for all built-in field types (text inputs, selects, checkboxes, and so on). These defaults work well for most stores without modification.

Configure rather than reimplement

You rarely need to create a custom `RendererInterface` implementation. The default renderer accepts customization through configuration - you can change CSS classes, templates, and wrapper markup without writing a new renderer class. Only reach for a custom renderer when you need fundamentally different HTML output that configuration alone can't achieve.

## EntityFormSaveServiceInterface - Address Data Persistence

`\Hyva\Checkout\Model\Form\EntityFormSaveServiceInterface`

The `EntityFormSaveServiceInterface` handles persisting validated form data to Magento entities. Every `EntityFormInterface` implementation needs a matching save service that knows how to store the collected data.

Hyvä Checkout includes save services for both shipping and billing addresses out of the box. These save services receive validated form data from the checkout process and store it to the appropriate Magento address entities.

Note

You only need to implement `EntityFormSaveServiceInterface` if you create a custom `EntityFormInterface` implementation, which is a rare scenario. For standard address form customizations (adding fields, changing validation, modifying layout), the built-in save services handle persistence automatically.

## Related Topics

- **[Form Customization Overview](index.html)** - Introduction to the Hyvä Checkout form customization system
- **[Implementing Form Modifiers](entity-form-modifiers.html)** - Step-by-step guide to implementing `EntityFormModifierInterface`
- **[Field Attributes](field-attributes.html)** - Complete list of properties you can set on `EntityFieldInterface` instances
- **[Setting Field Values](setting-field-values.html)** - How to programmatically set and override field values
- **[Interdependent Fields](interdependent-fields.html)** - Working with fields that depend on each other's values
