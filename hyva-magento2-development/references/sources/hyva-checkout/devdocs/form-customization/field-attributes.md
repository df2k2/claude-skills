<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/field-attributes.html -->

# Managing Form Field HTML Attributes in Hyva Checkout

Hyva Checkout lets you add, remove, and read HTML attributes on form fields using the `setAttribute()`, `removeAttribute()`, and `getAttributes()` methods. You can use these methods to attach custom data attributes, Alpine.js directives, or Magewire bindings to any checkout form field.

Setting and removing field attributes can be done in any of the Hyva Checkout form modifier hooks.

## Setting and Removing Field Attributes

To add or remove an HTML attribute on a Hyva Checkout form field, use `setAttribute()` and `removeAttribute()` on the field instance.

```
// Add a custom data attribute to the field
$field->setAttribute('data-attribute-address', 'true');

// Remove the attribute when it's no longer needed
$field->removeAttribute('data-attribute-address');
```

## Adding Alpine.js and Magewire Attributes to Checkout Fields

The `setAttribute()` method also works for Alpine.js event bindings, dynamic class bindings, and Magewire directives. This makes it easy to wire up reactive behavior on Hyva Checkout form fields.

```
// Alpine.js event binding
$field->setAttribute('@input', 'onChange');

// Alpine.js dynamic class binding
$field->setAttribute(':class', '{"border-red-500": isValid}');

// Magewire loading state class
$field->setAttribute('wire:loading.class', 'loading');
```

## Reading the Current Value of a Field Attribute

To check the current value of an attribute on a Hyva Checkout form field, use the `getAttributes()` method. This method returns an associative array of all currently assigned attributes.

```
$currentValue = $field->getAttributes()['data-example'] ?? '';
```

`getAttributes()[$code]` vs `getAttribute($code)`

To read an attribute value, always use `$field->getAttributes()[$code]`. Do not use `getAttribute($code)` for this purpose.

The `getAttribute($code)` method serves a different role: it retrieves the EAV attribute model instance for form fields that represent EAV attributes. Using it to read HTML attributes will not return what you expect.

## Related Topics

- **[Setting Field Values Programmatically in Hyva Checkout](setting-field-values.html)** - Set form field values from PHP code
- **[Implementing EntityFormModifierInterface in Hyva Checkout](entity-form-modifiers.html)** - Create form modifiers where you can use `setAttribute()` and other field methods
- **[Hyva Checkout Interdependent Form Fields](interdependent-fields.html)** - Build conditional field visibility based on other field values
