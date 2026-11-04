<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/entity-form-modifiers.html -->

# Implementing EntityFormModifierInterface in Hyvä Checkout

The `EntityFormModifierInterface` is the primary extension point for customizing Hyvä Checkout address forms. Form modifiers let you add, remove, and manipulate form fields in shipping and billing address forms - all without conflicting with other modules. Whether you need to change field labels, add validation rules, or restructure form layout, implementing `EntityFormModifierInterface` is where most Hyvä Checkout form customizations begin.

The `EntityFormModifierInterface` uses a callback-based approach. You register modification listeners that execute at specific points in the form lifecycle, giving you fine-grained control over when and how your customizations apply.

## EntityFormModifierInterface Structure

The `EntityFormModifierInterface` lives in the `Hyva\Checkout\Model\Form` namespace and defines a single method - `apply` - that registers your customization callbacks with the form instance.

```
<?php
namespace Hyva\Checkout\Model\Form;

interface EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface;
}
```

The `apply` method receives an `EntityFormInterface` instance and returns it after registering your modification callbacks. Hyvä Checkout calls `apply` during form initialization, giving your modifier the opportunity to hook into form lifecycle events before the form renders.

## Registering Modification Callbacks with registerModificationListener

Form modifiers register callbacks as "modification listeners" using the `registerModificationListener` method. Each call to `registerModificationListener` requires three arguments:

1. **Identifier string** - A unique identifier for your callback, used to reference or remove the listener later
2. **Hook name** - The form lifecycle event when the callback should execute (for example, `form:build`)
3. **Callback** - Any PHP [callable](https://www.php.net/manual/en/language.types.callable.php) that implements your customization logic

### Basic EntityFormModifierInterface Implementation Example

The following example shows a complete `EntityFormModifierInterface` implementation. The modifier registers a callback that executes during the `form:build` lifecycle event using `registerModificationListener`.

```
<?php

namespace Hyva\Example\Model\FormModifier;

use Hyva\Checkout\Model\Form\EntityFormInterface;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;

class ExampleBillingAddressModifier implements EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface
    {
        // Register a callback for the form:build event
        $form->registerModificationListener(
            'myCallbackIdentifier',        // unique identifier for this callback
            'form:build',                  // the form lifecycle hook name
            [$this, 'applyMyModification'] // the callback method
        );

        return $form;
    }

    public function applyMyModification(EntityFormInterface $form)
    {
        // Your customization logic executes here when the form:build event fires
        // Example: modify field properties, add/remove fields, etc.
    }
}
```

The `registerModificationListener` method adds your callback to the form's internal event system. When the specified hook event fires, Hyvä Checkout invokes your callback with arguments appropriate to that hook type.

### Helper Methods for Field Modifications

The `modifyField()` and `modifyElement()` helper methods (since 1.1.21) and `modifySpecificFields()` and `modifySpecificElements()` (since 1.1.27) automatically check for field existence before applying your modifications, eliminating boilerplate code and preventing errors when fields are absent. `modifyFields()` and `modifyElements()` take only the callback and apply it to every field or element of the form.

Recommended Approach for Field Modifications

Use `modifyField()`, `modifySpecificFields()`, `modifyElement()`, or `modifySpecificElements()` instead of manually checking field existence. These methods handle existence checks internally.

The following example shows `modifyField` and `modifySpecificFields` used inside a modification callback to safely update field properties.

```
public function applyMyModification(EntityFormInterface $form)
{
    // modifyField applies the callback only if the field exists
    $form->modifyField('telephone', function ($telephoneField) {
        $telephoneField->setLabel('Phone Number');
    });

    // modifySpecificFields applies the same callback to the named fields that exist
    $form->modifySpecificFields(['firstname', 'lastname'], function ($field) {
        $field->setValidationRule('maxlength', 40);
    });
}
```

Using `modifyField` and `modifySpecificFields` keeps your modifier code clean and prevents the repetitive null-check boilerplate that would otherwise be needed for every field operation.

## Registering a Form Modifier with Dependency Injection

Form modifiers are registered through Magento's dependency injection system in `etc/frontend/di.xml`. The DI configuration specifies which address form - shipping or billing - receives the modifier.

The following `di.xml` example registers a modifier for the billing address form using the `EavAttributeBillingAddressForm` type.

etc/frontend/di.xml

```
<type name="Hyva\Checkout\Model\Form\EntityForm\EavAttributeBillingAddressForm">
    <arguments>
        <argument name="entityFormModifiers" xsi:type="array">
            <!-- Register your modifier with a unique item name and sortOrder -->
            <item name="hyva_example" xsi:type="object" sortOrder="1000">
                Hyva\Example\Model\FormModifier\ExampleBillingAddressModifier
            </item>
        </argument>
    </arguments>
</type>
```

To register a modifier for the shipping address form instead, replace `EavAttributeBillingAddressForm` with `EavAttributeShippingAddressForm` as the type name.

When Hyvä Checkout initializes the address form, it calls the `apply` method on every registered modifier in `sortOrder` sequence, allowing each modifier's callbacks to register with the form's event system

### Understanding sortOrder Priority for Form Modifiers

The `sortOrder` attribute in the DI configuration controls the execution order when multiple form modifiers are registered. Modifiers execute in ascending `sortOrder` - lower values execute first, higher values execute last.

The following XML snippet shows two modifiers with different `sortOrder` values to illustrate execution priority.

```
<!-- Executes first due to lower sortOrder -->
<item name="early_modifier" xsi:type="object" sortOrder="500">
    Vendor\Module\Model\EarlyModifier
</item>
<!-- Executes last, can override changes from earlier modifiers -->
<item name="late_modifier" xsi:type="object" sortOrder="1500">
    Vendor\Module\Model\LateModifier
</item>
```

Execution order matters when multiple modifiers manipulate the same field properties. A modifier with a higher `sortOrder` value executes later and can override changes made by earlier modifiers, giving it effective priority.

Default sortOrder Recommendation

Use `sortOrder="1000"` as your default value. Hyvä Checkout core modifiers use `sortOrder` values in the 0-999 range, so 1000 ensures your customizations execute after core modifications.

Every item in the `entityFormModifiers` array should include a `sortOrder` attribute for reliable ordering. Magento's DI configuration requires explicit sortOrder values to guarantee consistent array ordering.

### Resolving Form Modifier Conflicts

When two form modifiers conflict - for example, both setting the same field property to different values - assign a higher `sortOrder` to the modifier that should take precedence.

The following DI configuration demonstrates overriding a third-party modifier by registering your own modifier with a higher `sortOrder`.

```
<!-- Original modifier from third-party module -->
<item name="thirdparty_modifier" xsi:type="object" sortOrder="1000">
    Vendor\Module\Model\FormModifier
</item>

<!-- Your modifier overrides third-party changes with higher sortOrder -->
<item name="your_override_modifier" xsi:type="object" sortOrder="1100">
    YourVendor\YourModule\Model\OverrideModifier
</item>
```

The modifier with `sortOrder="1100"` executes after the one with `sortOrder="1000"`, so any property changes made by the earlier modifier get overridden by the later one.

## Available Form Modification Hooks

Different hook names trigger callbacks at different points in the form lifecycle. The hook name you pass to `registerModificationListener` determines when your callback executes and what arguments the callback receives.

See the [Form Modification Hooks reference](../form-api/form-modification-hooks.html) for a complete table of available hooks, their timing, and callback signatures.

Choosing hooks on Checkout 3.x

On Checkout 3.x, the address form hooks of Checkout 1.x (such as `form:shipping:updated` or `form:field:updated`) still fire, but as deprecated legacy hooks. For new modifiers, prefer the `form:*:magewire` hooks: `form:construct:magewire` to add fields up front, `form:loaded:magewire` to derive values or options from the loaded data, and `form:updated:data:<field>:magewire` to react to a field change. Listeners that type-hint `MagewireAddressFormInterface` don't run for the Checkout 3.x address forms. See [Choosing a Hook on Checkout 3.x](../form-api/form-modification-hooks.html#choosing-a-hook-on-checkout-3x) and [Listener Type Hints on Checkout 3.x](../form-api/form-modification-hooks.html#listener-type-hints-on-checkout-3x).

## Related Topics

- **[EntityFormInterface Methods](entity-form-interfaces.html)** - Full reference for the form instance methods available inside your modifier callbacks
- **[Field Attributes](field-attributes.html)** - How to read and set field properties like labels, validation rules, and visibility
- **[Setting Field Values](setting-field-values.html)** - Techniques for programmatically setting default or dynamic field values
- **[Form Modification Hooks](../form-api/form-modification-hooks.html)** - Complete list of lifecycle hooks and their callback signatures
