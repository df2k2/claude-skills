<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/street-address-lines.html -->

# Validating and Styling Street Address Lines in Hyvä Checkout

The street field in Hyvä Checkout address forms renders between one and four input lines, depending on the Magento setting **Stores > Configuration > Customers > Customer Configuration > Name and Address Options > Number of Lines in a Street Address**. The first line is the street field itself and the other lines are its [relatives](related-form-elements.html). Their values are saved together as the street address.

Some address formats give each line its own meaning. In the Netherlands, for example, stores often use three lines for street, house number and house number addition. In that case, each line needs its own validation message, validation rules and styling.

The system configuration under **Stores > Configuration > Hyvä Checkout > General > Address Forms > Street Address Fields** already sets a label and the required state per line. Since Hyvä Checkout 1.3.10, each line also gets its own "required" message, such as "Street Address line two is a required field." This page shows how a form modifier can go further:

- show each line's validation messages directly below that line, and mark only the invalid line with the error class
- add validation rules and messages to a single line
- target a single line with CSS

The examples work the same on Hyvä Checkout 1.x and 3.x.

## Why Street Line Messages Appear Below the Whole Group

Hyvä's client side form validation places messages in the closest ancestor of the input that has the CSS classes `field field-reserved`. The same element receives the `field-error` class when the input is invalid.

Hyvä Checkout gives these classes to the wrapper `div` around each top level form field. Street lines 2 to 4 are rendered inside the street field's wrapper, and each line's own container only has the classes `field field-wrapper-inner`. The closest `field field-reserved` ancestor of every street input is therefore the wrapper of the whole street group:

```
<div class="field-wrapper field field-reserved field-street group group-street ...">
    <div class="field field-wrapper-inner ...">
        <input name="street[0]" ...>
    </div>
    <div class="field field-wrapper-inner ...">
        <input name="street[1]" ...>
    </div>
    <!-- Messages for every street line are added here -->
</div>
```

The fix is to add the `field-reserved` class to each line's container, which turns every line into its own message container.

## Showing Validation Messages Below Each Street Line

The street template builds the class attribute of each line's container from the `field-wrapper-inner` section of the field's element classes. The following form modifier adds two classes to that section on every street line:

- `field-reserved`, so validation messages and the `field-error` class go to the line's own container
- `street-line-N` (`street-line-1`, `street-line-2`, and so on), so CSS can target a specific line

Model/FormModifier/StreetLinesModifier.php

```
<?php

declare(strict_types=1);

namespace Hyva\Example\Model\FormModifier;

use Hyva\Checkout\Model\Form\AbstractEntityForm;
use Hyva\Checkout\Model\Form\EntityField\AbstractEntityField;
use Hyva\Checkout\Model\Form\EntityFormElementInterface;
use Hyva\Checkout\Model\Form\EntityFormInterface;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;

class StreetLinesModifier implements EntityFormModifierInterface
{
    public function apply(EntityFormInterface $form): EntityFormInterface
    {
        $form->registerModificationListener(
            'applyStreetLineContainers',
            'form:build',
            [$this, 'applyStreetLineContainers']
        );

        return $form;
    }

    public function applyStreetLineContainers(AbstractEntityForm $form): AbstractEntityForm
    {
        // modifyField() also runs the callback on every relative, so each street line gets the classes.
        return $form->modifyField('street', function (AbstractEntityField $line) {
            $classes = $line->getData(EntityFormElementInterface::CLASS_ELEMENT) ?? [];

            // Named keys keep the classes from being added twice if the form is built again.
            $classes['field-wrapper-inner']['street_line_container'] = 'field-reserved';
            $classes['field-wrapper-inner']['street_line_position'] = 'street-line-' . ($line->getPosition() + 1);

            $line->setData(EntityFormElementInterface::CLASS_ELEMENT, $classes);
        });
    }
}
```

`getPosition()` returns `0` for the first line and `1`, `2` and `3` for the following lines.

Register the modifier on both address forms:

etc/frontend/di.xml

```
<type name="Hyva\Checkout\Model\Form\EntityForm\EavAttributeShippingAddressForm">
    <arguments>
        <argument name="entityFormModifiers" xsi:type="array">
            <item name="hyva_example_street_lines" xsi:type="object" sortOrder="1000">
                Hyva\Example\Model\FormModifier\StreetLinesModifier
            </item>
        </argument>
    </arguments>
</type>
<type name="Hyva\Checkout\Model\Form\EntityForm\EavAttributeBillingAddressForm">
    <arguments>
        <argument name="entityFormModifiers" xsi:type="array">
            <item name="hyva_example_street_lines" xsi:type="object" sortOrder="1000">
                Hyva\Example\Model\FormModifier\StreetLinesModifier
            </item>
        </argument>
    </arguments>
</type>
```

With the modifier in place, each line renders like this:

```
<div class="field field-reserved street-line-2 field-wrapper-inner ...">
    <input name="street[1]" ...>
    <!-- Messages for this line only, shown when the line is invalid -->
</div>
```

Side effects to check in your theme

- The `field-reserved` class reserves space for one line of message text below its element. Each street line now reserves that space, so stacked street lines move further apart. The street group wrapper keeps its own reserved space as well.
- Messages returned by the server after the form is submitted are still rendered below the whole street group. This page only changes where the client side validation shows its messages.

## Adding Validation Rules to a Single Street Line

Every street line is a field of its own, so `setValidationRule()` and HTML attributes such as `data-msg-<rule>` work per line. Use `getPosition()` in the `modifyField()` callback to pick the line.

The following listener belongs in the same modifier class. It allows only digits on the second line (the house number in the Dutch example) and sets the messages that line shows:

```
public function apply(EntityFormInterface $form): EntityFormInterface
{
    // Register next to the applyStreetLineContainers listener from the previous example.
    $form->registerModificationListener(
        'applyHouseNumberRules',
        'form:build',
        [$this, 'applyHouseNumberRules']
    );

    return $form;
}

public function applyHouseNumberRules(AbstractEntityForm $form): AbstractEntityForm
{
    return $form->modifyField('street', function (AbstractEntityField $line) {
        if ($line->getPosition() !== 1) {
            return;
        }

        $line->setValidationRule('pattern', '[0-9]+');
        $line->setAttribute('data-msg-pattern', (string) __('Enter the house number using digits only.'));
        $line->setAttribute('data-msg-required', (string) __('Enter a house number.'));
    });
}
```

A rule only applies when the line exists. If Magento is configured for a single street line, the callback never sees a field at position `1` and the rule is skipped.

Use the system configuration for labels and required lines

Labels and the required state of each line are already configurable under **Stores > Configuration > Hyvä Checkout > General > Address Forms > Street Address Fields**. Set them there instead of in code, so store administrators can change them per store view.

Hyvä Checkout sets a default `data-msg-required` message on each line only when the attribute is missing, so a message you set in your modifier always takes precedence. To write a rule of your own instead of `pattern`, see [Form Validations](../form-api/form-validations.html#adding-custom-client-side-validation-rules).

Client side rules are not enforced by the server

A `pattern` rule only gives the customer fast feedback in the browser. If the format of a street line matters to your order processing, validate it on the server as well.

## Styling Individual Street Lines

The `street-line-N` and `field-error` classes from the modifier above are enough to style one line. The following CSS uses the **Two Column Grid** street layout to give the street name the full width, with the house number and the addition side by side below it, and highlights an invalid house number:

```
.street-two-column-grid .street-line-1 {
    grid-column: 1 / -1;
}

.street-line-2.field-error .form-input {
    border-color: #dc2626;
}
```

Add the CSS to your theme's Tailwind source files, which are compiled into the same `styles.css` as the Hyvä Checkout styles (see [Styling Hyvä Checkout](../styling/index.html)).

## Limitations of Street Line Customization

- **Street lines always render together and in order.** The lines are relatives of the street field, and their values are combined into the street address array when the address is saved. Placing another field between two street lines, or moving the house number line next to the postcode, is not possible without detaching the line, and a detached line is no longer saved as part of the street. If you need a field outside the street group, [add a custom address attribute](adding-custom-address-attributes.html) and handle its value separately.
- **Server side errors stay below the group.** See the note in [Showing Validation Messages Below Each Street Line](#showing-validation-messages-below-each-street-line).

## Related Topics

- **[Related Form Elements in Hyvä Checkout](related-form-elements.html)**: how ancestors and relatives work, and why the street value becomes an array
- **[Implementing EntityFormModifierInterface in Hyvä Checkout](entity-form-modifiers.html)**: how form modifiers are built and registered
- **[Form Rendering](../form-api/form-rendering.html#street-field-variants)**: the Two Column Grid and One Column Row street layouts
- **[Form Validations](../form-api/form-validations.html)**: setting client side validation rules and writing custom ones
