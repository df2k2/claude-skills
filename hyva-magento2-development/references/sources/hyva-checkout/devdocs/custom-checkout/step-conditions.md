<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/custom-checkout/step-conditions.html -->

# Step conditions in Hyvä Checkout

Step conditions control the visibility of checkout steps and the inclusion of layout handles in Hyvä Checkout. You can show or hide steps based on customer state, quote properties, or custom business logic - giving you fine-grained control over the checkout flow.

When multiple conditions are applied to a single step, the step only appears if all conditions evaluate to true.

## Built-in step condition identifiers

Hyvä Checkout ships with these step condition identifiers out of the box:

- `is_always_allow` - Always evaluates to true
- `is_customer` - True if the customer is logged in
- `is_device` - True if the visitor is on a mobile device
- `is_guest` - True if the customer is a guest (not logged in)
- `is_physical` - True if the quote contains physical products
- `is_virtual` - True if the quote contains only virtual products

Each identifier is a readable alias mapped to a PHP class. You can use these identifiers directly in your `hyva_checkout.xml` configuration, or define your own.

## Using step conditions in XML

Step conditions appear in `hyva_checkout.xml` in two places: `<condition>` elements that control step visibility, and `<update>` elements that conditionally include layout handles.

The following example demonstrates both uses. The `<update>` element conditionally includes a layout handle, while the `<condition>` element controls whether the entire step appears:

```
<step name="example-step">
    <!-- Only include the example_handle.xml layout XML if the "is_physical" condition is true -->
    <update handle="example_handle" if="is_physical"/>

    <!-- Only show the "example-step" step if the "is_customer" condition is true -->
    <condition name="guest_login" if="is_customer"/>
</step>
```

The `if` attribute accepts either a **step condition identifier** (like `is_customer`) or a **fully qualified PHP class name**. Both approaches are covered in the sections below.

## Registering custom step condition identifiers

Step condition identifiers are mapped to their implementing PHP classes via `etc/frontend/di.xml` dependency injection configuration. These aliases make `hyva_checkout.xml` files easier to read and maintain.

The default identifiers are declared in `vendor/hyva-themes/magento2-hyva-checkout/src/etc/frontend/di.xml`:

```
<type name="Hyva\Checkout\Model\CustomConditionFactory">
    <arguments>
        <argument name="customConditionTypes" xsi:type="array">
            <item name="is_always_allow" xsi:type="string">Hyva\Checkout\Model\CustomCondition\IsAlwaysAllow</item>
            <item name="is_customer" xsi:type="string">Hyva\Checkout\Model\CustomCondition\IsCustomer</item>
            <item name="is_guest" xsi:type="string">Hyva\Checkout\Model\CustomCondition\IsGuest</item>
            <item name="is_physical" xsi:type="string">Hyva\Checkout\Model\CustomCondition\IsPhysical</item>
            <item name="is_virtual" xsi:type="string">Hyva\Checkout\Model\CustomCondition\IsVirtual</item>
            <item name="is_device" xsi:type="string">Hyva\Checkout\Model\CustomCondition\IsDevice</item>
        </argument>
    </arguments>
</type>
```

You can add custom identifiers to this array using your own module's `di.xml` file. That said, unless a condition will be reused frequently across multiple configurations, it's often simpler to use the class name directly.

## Using class names instead of identifiers

Instead of registering a condition identifier, you can use a fully qualified PHP class name directly in the `if` attribute. This is handy for one-off conditions that don't need a reusable alias.

```
<step name="example-step">
    <!-- Use a class name directly for layout handle inclusion -->
    <update handle="example_handle" if="My\Module\Model\Checkout\StepCondition\ExampleStepCondition"/>

    <!-- Use a class name directly for step visibility -->
    <condition name="show_if_valid" if="My\Module\Model\Checkout\StepCondition\ExampleStepCondition"/>
</step>
```

## Writing step condition classes

Every step condition class must implement the `Hyva\Checkout\Model\CustomConditionInterface` interface. This interface declares a single method - `public function validate(): bool` - which returns `true` when the condition is met and `false` otherwise.

### Using the method attribute for condition variations

For `<condition>` elements, an optional `method` attribute lets you call an alternative validation method instead of the default `validate`. This is useful when you want to group related condition variations within a single class to avoid code duplication.

The following example calls the `required` method on the `is_customer` condition class instead of the default `validate` method:

```
<condition name="show_login" if="is_customer" method="required"/>
```

If no `method` attribute is specified, the default `validate` method is called.

## Related Topics

- **[The hyva\_checkout.xml file](hyva-checkout-xml.html)** - Full reference for the checkout configuration XML where step conditions are used
- **[Checkout layout handles](layout-handles.html)** - How layout handles work with checkout steps and conditional updates
