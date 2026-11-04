<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/setting-field-values.html -->

# Setting Field Values Programmatically in Hyva Checkout

Hyva Checkout lets you programmatically set or clear form field values using form modifiers. Which hooks can change values depends on the release line, so pick the hook that matches your version.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Change field values in a `form:*:magewire` hook

On Checkout 3.x, value changes made in a `form:*:magewire` hook sync to the form component's data property, so the customer sees them. Use `form:loaded:magewire` to set values from the loaded data (including on the initial page load), `form:updated:data:<field>:magewire` to react to a field change, and `form:submitting:magewire` to adjust values right before saving.

Only `form:*:updated` Hooks Can Change Field Values

Setting field values only works inside `form:billing:updated` or `form:shipping:updated` hooks. Value changes made in other hooks such as `form:build` are silently ignored. Always register your value-changing callbacks on the correct `form:*:updated` event.

This page covers the `setValue()` and `empty()` methods on `EntityFieldInterface`, the timing constraints you need to respect, and practical examples of conditional field clearing and multi-field calculations.

## setValue and empty Methods on EntityFieldInterface

The `EntityFieldInterface` provides two methods for programmatic field value manipulation in Hyva Checkout forms:

- **`setValue($value)`** - Sets the field to a specific value
- **`empty()`** - Clears the field value entirely

Both methods must be called inside a hook that can change values (a `form:*:magewire` hook on Checkout 3.x, a `form:*:updated` hook on Checkout 1.x). Calling them outside that context will not update the actual field value displayed to the customer.

## Choosing Between form:billing:updated and form:shipping:updated

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, the address forms keep re-emitting `form:billing:updated` and `form:shipping:updated` as deprecated legacy hooks, and value changes made there still reach the form. For new code, use the `form:*:magewire` hooks, which have no address type in their name. Register the modifier on the address form you want to change instead (`EavAttributeBillingAddressForm` or `EavAttributeShippingAddressForm`, see [Entity Form Modifiers](entity-form-modifiers.html#registering-a-form-modifier-with-dependency-injection)):

- **`form:loaded:magewire`**: fires once per request after the field values are loaded, before they sync to the frontend. Use it to set initial values or values derived from other fields.
- **`form:updated:data:<field>:magewire`**: fires when a specific field has changed, for example `form:updated:data:country_id:magewire`.
- **`form:updated:data:magewire`**: fires when any form field has changed.
- **`form:submitting:magewire`**: fires on form submission, before validation and saving.

If you need to modify fields on both forms, register the modifier on both forms.

Hyva Checkout fires separate update hooks depending on which address form was submitted. Pick the hook that matches the form whose fields you want to modify:

- **`form:billing:updated`**: Fires after the billing address form is submitted. Use this hook to set or clear billing address fields.
- **`form:shipping:updated`**: Fires after the shipping address form is submitted. Use this hook to set or clear shipping address fields.

Register your callback on the correct hook for the address type you are modifying. If you need to modify fields on both forms, register separate listeners for each hook.

## Complete Example - Clearing a Field Value Conditionally

This example shows a form modifier that clears a custom billing field when a country-specific feature is unavailable. The modifier registers a callback with `registerModificationListener()`. Register it on the billing address form in `di.xml`.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, the modifier listens on `form:loaded:magewire` and `form:updated:data:country_id:magewire`:

```
<?php

namespace Hyva\Example\Model\FormModifier;

use Hyva\Checkout\Model\Form\EntityFormInterface;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;

class ConditionalFieldValueModifier implements EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface
    {
        // Apply on every request once the loaded values are in the form
        $form->registerModificationListener(
            'empty-value-if-field-disabled-on-load',
            'form:loaded:magewire',
            [$this, 'emptyMyField']
        );

        // Apply again when the customer changes the country
        $form->registerModificationListener(
            'empty-value-if-field-disabled',
            'form:updated:data:country_id:magewire',
            [$this, 'emptyMyField']
        );

        return $form;
    }

    public function emptyMyField(EntityFormInterface $form, ...$rest)
    {
        // Get the current country value from the form data
        $country = $form->getField('country_id')->getValue();

        // Clear fields if the feature is not available for this country
        if (!$this->isExampleAvailable($country)) {
            // Clear the custom field using empty()
            $form->getField('my_field')->empty();

            // Set another field to a fallback value using setValue()
            $form->getField('other_field')->setValue('nope');
        }
    }

    private function isExampleAvailable(string $country): bool
    {
        // Business logic to determine feature availability by country
        return in_array($country, ['US', 'CA', 'GB']);
    }
}
```

The `apply()` method registers `emptyMyField` on both hooks. On every request, and again when the customer changes the country, the callback reads the selected `country_id`, checks availability, and either clears `my_field` with `empty()` or sets `other_field` to a fallback value with `setValue()`.

On Checkout 1.x, the modifier listens on `form:billing:updated`:

```
<?php

namespace Hyva\Example\Model\FormModifier;

use Hyva\Checkout\Model\Form\EntityFormInterface;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;

class ConditionalFieldValueModifier implements EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface
    {
        // Register callback for the billing address updated event
        $form->registerModificationListener(
            'empty-value-if-field-disabled',
            'form:billing:updated',
            [$this, 'emptyMyField']
        );

        return $form;
    }

    public function emptyMyField(EntityFormInterface $form)
    {
        // Get the current country value from the submitted form data
        $country = $form->getField('country_id')->getValue();

        // Clear fields if the feature is not available for this country
        if (!$this->isExampleAvailable($country)) {
            // Clear the custom field using empty()
            $form->getField('my_field')->empty();

            // Set another field to a fallback value using setValue()
            $form->getField('other_field')->setValue('nope');
        }
    }

    private function isExampleAvailable(string $country): bool
    {
        // Business logic to determine feature availability by country
        return in_array($country, ['US', 'CA', 'GB']);
    }
}
```

The `apply()` method registers `emptyMyField` as a listener on the `form:billing:updated` hook. When billing address data is submitted, the callback reads the selected `country_id`, checks availability, and either clears `my_field` with `empty()` or sets `other_field` to a fallback value with `setValue()`.

## Why Value Changes Need the Right Hook

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, the `form:*:magewire` hooks run inside the form component and sync every value change to the component's data property. The data property is what the frontend shows and what the form saves, so changes made in these hooks persist.

The `form:*:updated` hooks execute after user input has been received and validated during form processing. At that point in the lifecycle, field values reflect the user's submitted data, the form state is stable, and programmatic changes will persist through the rest of the submission process.

Hooks like `form:build` run during initial form construction, before any user input is available. That is why value changes made in `form:build` have no effect: the form overwrites them with user-submitted data later in the lifecycle.

## Setting Field Values on Initial Page Load

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, `form:loaded:magewire` fires on every request, including the initial page load, after the field values are loaded and before they sync to the frontend. Use it to set initial field values.

Because the hook also fires on every later request, only fill a field that is still empty, or you overwrite what the customer entered:

```
$form->registerModificationListener(
    'setMyFieldDefault',
    'form:loaded:magewire',
    function (AbstractEntityForm $form, ...$rest) {
        $form->modifyField('my_field', function (EntityFieldInterface $field) {
            // Only fill an empty field, so the customer's input is kept.
            if (! $field->hasValue()) {
                $field->setValue('my default');
            }
        });
    }
);
```

The `form:*:updated` hooks do not fire during the initial checkout page load (the "preceding request" in Magewire terminology). These hooks only fire in response to actual value submissions.

No Form Modifier Hook for Initial Field Values

You cannot reliably set field values during the initial checkout page render using Hyva Checkout form modification hooks. The `form:*:updated` hooks only execute after form submission, not on initial load.

If you need to set specific field values before the customer interacts with the checkout form, use Magento-level mechanisms instead:

- **Magento plugins**: Intercept address loading methods to modify data before it reaches the Hyva Checkout form
- **Event observers**: Listen to Magento address-related events to modify values at the data layer
- **Customer data providers**: Customize the data source that feeds the form's initial values

These Magento-level approaches modify data before the Hyva Checkout form is constructed, so the form renders with your desired initial values already in place.

## Example - Setting a Calculated Value from Multiple Fields

This example shows how to read multiple field values and set a computed result in a custom field. The callback reads country, region, and postcode, then calculates a shipping zone.

```
public function updateCalculatedField(EntityFormInterface $form)
{
    // Read multiple field values from the submitted form data
    $country = $form->getField('country_id')->getValue();
    $region = $form->getField('region_id')->getValue();
    $postcode = $form->getField('postcode')->getValue();

    // Calculate the shipping zone based on the full location
    $zone = $this->calculateShippingZone($country, $region, $postcode);

    // Set the calculated zone, with a guard in case the field is absent
    if ($zoneField = $form->getField('shipping_zone')) {
        $zoneField->setValue($zone);
    }
}
```

Register the callback on `form:billing:updated` or `form:shipping:updated` on Checkout 1.x. On Checkout 3.x, register it on `form:updated:data:magewire` (or on `form:updated:data:<field>:magewire` for each field it reads) and add a trailing `...$rest` parameter, because `form:updated:data:magewire` passes `value` and `path` as named arguments.

The existence check (`if ($zoneField = $form->getField('shipping_zone'))`) prevents errors when the custom `shipping_zone` field is not present on the form. This is a good defensive practice whenever you target fields that might not exist in every checkout configuration.

## Related Topics

- **[Entity Form Modifiers](entity-form-modifiers.html)** - How to create and register form modifiers in Hyva Checkout
- **[Entity Form Interfaces](entity-form-interfaces.html)** - Full API reference for EntityFormInterface and EntityFieldInterface
- **[Interdependent Fields](interdependent-fields.html)** - Handling fields that depend on each other's values
- **[Field Attributes](field-attributes.html)** - Customizing field visibility, validation, and other attributes
