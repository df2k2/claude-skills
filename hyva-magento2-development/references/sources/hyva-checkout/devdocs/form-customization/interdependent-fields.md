<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/interdependent-fields.html -->

# Hyva Checkout Interdependent Form Fields - Conditional Field Visibility

Hyva Checkout form modifiers can show, hide, add, or remove form fields dynamically based on the values of other fields. Interdependent fields enable conditional form logic - for example, hiding the region selector for countries without regions, or displaying extra fields only when specific options are selected.

The key concepts for building interdependent fields in Hyva Checkout are:

- **`registerModificationListener()`** - registers a callback that runs during a specific form lifecycle hook
- **The hook that runs your callback**: `form:loaded:magewire` plus `form:updated:data:<field>:magewire` on Checkout 3.x, `form:build` on Checkout 1.x. Each of them runs when the field values are known, so your callback can inspect them and modify the form
- **`createField()` and `removeField()`** - add or remove fields from the form at runtime
- **`assignRelative()`** - positions a new field next to an existing field in the form layout

All interdependent field logic lives inside a class that implements `EntityFormModifierInterface`.

## Removing a Hyva Checkout Form Field Based on Another Field's Value

The most common interdependent field scenario involves removing a field when another field contains a specific value. The form modifier registers a listener, then checks field values inside the callback to decide whether to remove the field.

This example removes a custom field when the selected country is Germany:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

```
<?php

namespace Hyva\Example\Model\FormModifier;

use Hyva\Checkout\Model\Form\EntityFormInterface;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;

class ConditionalFieldRemovalModifier implements EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface
    {
        // Run on every request, once the loaded values are in the form
        $form->registerModificationListener(
            'init-my-form-field-on-load',
            'form:loaded:magewire',
            [$this, 'initMyFormField']
        );

        // Run again when the customer changes the country
        $form->registerModificationListener(
            'init-my-form-field-on-country-update',
            'form:updated:data:country_id:magewire',
            [$this, 'initMyFormField']
        );

        return $form;
    }

    public function initMyFormField(EntityFormInterface $form, ...$rest)
    {
        // Read the current country value from the form
        $country = $form->getField('country_id')->getValue();
        $myField = $form->getField('my_field');

        if ($country === 'DE' && $myField) {
            // Remove the custom field when the country is Germany (DE)
            $form->removeField($myField);
        } elseif ($country !== 'DE' && ! $myField) {
            // Add it back when the customer switches away from Germany
            $myField = $form->createField('my_field', 'text');
            $myField->addData(['label' => 'Additional Information']);

            $form->addField($myField);
            $form->getField('country_id')->assignRelative($myField);
        }
    }
}
```

The `apply()` method registers the `initMyFormField()` callback on two hooks. `form:loaded:magewire` runs on every request with the values the request starts with, and `form:updated:data:country_id:magewire` runs again after the customer changed the country. Because the callback can run twice in one request, it handles both directions: it removes `my_field` for Germany and adds it back for any other country. This is the same pattern the core region modifier uses (see [Choosing a Hook on Checkout 3.x](../form-api/form-modification-hooks.html#choosing-a-hook-on-checkout-3x)).

```
<?php

namespace Hyva\Example\Model\FormModifier;

use Hyva\Checkout\Model\Form\EntityFormInterface;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;

class ConditionalFieldRemovalModifier implements EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface
    {
        // Register a callback for the form:build lifecycle hook
        $form->registerModificationListener(
            'init-my-form-field',
            'form:build',
            [$this, 'initMyFormField']
        );

        return $form;
    }

    public function initMyFormField(EntityFormInterface $form)
    {
        // Read the current country value from the form
        $country = $form->getField('country_id')->getValue();
        $myField = $form->getField('my_field');

        // Remove the custom field when the country is Germany (DE)
        if ($country === 'DE' && $myField) {
            $form->removeField($myField);
        }
    }
}
```

The `apply()` method registers a modification listener named `init-my-form-field` on the `form:build` hook. When the form builds, the `initMyFormField()` callback reads the `country_id` value and conditionally removes `my_field`. The existence check (`&& $myField`) prevents errors when the field is not present in the form.

## Adding a Hyva Checkout Form Field Conditionally

Form modifiers can add fields dynamically when specific conditions are met. The `createField()` method instantiates a new field with a given identifier and input type. The `addData()` method sets field properties like the label. The `assignRelative()` method positions the new field next to an existing field so the form layout stays logical.

The following callbacks contain only the condition and the field to add. Register them as shown in the first example. On Checkout 3.x, also remove the field when the condition no longer holds, as the first example does, because the callback runs before and after a value change.

This example adds a text field for all countries except Germany:

```
public function initMyFormField(EntityFormInterface $form)
{
    $country = $form->getField('country_id')->getValue();

    // Only add the field for non-DE countries
    if ($country !== 'DE') {
        // Create a new text input field with the identifier 'my_field'
        $myField = $form->createField('my_field', 'text');
        $myField->addData(['label' => 'Additional Information']);

        // Add the field to the form and position it after the country field
        $form->addField($myField);
        $form->getField('country_id')->assignRelative($myField);
    }
}
```

Data Persistence for Dynamically Added Fields

Dynamically added fields do not automatically persist their values to the address entity. You must implement custom persistence logic for any fields added at runtime that need to save their values.

## Creating a Dynamic Select Field in Hyva Checkout

Select fields with predefined options can also be added conditionally using `createField()` with the `select` type. The `options` array inside `addData()` defines the available choices - array keys become option values, and array values become the displayed text.

This example creates a required delivery preference select field for US customers:

```
public function initMyFormField(EntityFormInterface $form)
{
    $country = $form->getField('country_id')->getValue();

    if ($country === 'US') {
        // Create a select field with predefined delivery options
        $mySelect = $form->createField('my_select', 'select');
        $mySelect->addData([
            'label' => 'Delivery Preference',
            'is_required' => true, // Makes the field mandatory
            'options' => [
                '' => 'Please Choose',
                '0' => 'Standard Delivery',
                '1' => 'Priority Delivery'
            ]
        ]);

        $form->addField($mySelect);
        $form->getField('country_id')->assignRelative($mySelect);
    }
}
```

Setting `is_required` to `true` in the `addData()` options array makes the select field mandatory. The empty-string key (`''`) serves as the placeholder option.

## Combining Multiple Field Values for Conditional Logic

More complex interdependent field scenarios can combine multiple field values to determine whether a field should appear. Each field value is read with `getField()->getValue()`, and standard PHP conditionals control the logic.

This example adds a "London Zone" field only when the country is GB and the postcode starts with "SW":

```
public function initMyFormField(EntityFormInterface $form)
{
    $country = $form->getField('country_id')->getValue();
    $postcode = $form->getField('postcode')->getValue();

    // Show the London zone field only for UK postcodes starting with SW
    if ($country === 'GB' && $postcode && str_starts_with($postcode, 'SW')) {
        $specialField = $form->createField('london_zone', 'text');
        $specialField->addData(['label' => 'London Zone']);

        $form->addField($specialField);
        $form->getField('postcode')->assignRelative($specialField);
    }
}
```

By checking both the `country_id` and `postcode` field values, the modifier ensures the London Zone field only appears for the relevant subset of addresses.

## Related Topics

- **[Entity Form Modifiers](entity-form-modifiers.html)** - How to create and register form modifiers in Hyva Checkout
- **[Entity Form Interfaces](entity-form-interfaces.html)** - Full API reference for EntityFormInterface and EntityFormModifierInterface
- **[Setting Field Values](setting-field-values.html)** - How to set default values and modify field values programmatically
- **[Field Attributes](field-attributes.html)** - Configuring field properties like labels, validation, and visibility
