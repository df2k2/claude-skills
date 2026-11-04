<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-api/form-construction.html -->

# Form Construction in Hyvä Checkout

The Hyvä Checkout Form API lets you build interactive checkout forms from reusable components: fields, buttons, elements, and accessories. Each form is made up of multiple parts that you can customize or extend through dedicated classes, factories, and modifiers. This means third-party modules can modify forms without touching templates.

Form elements are layout blocks with phtml templates bound to a form element object. Accessories are injectable templates that render alongside elements. The construction system uses save services to persist data, modifiers to customize behavior, and factories to dynamically create form components.

## Save Services

**Class:** `\Hyva\Checkout\Model\Form\AbstractEntityFormSaveService`

Save Services handle the final step of form submission - they take validated form data and write it to a specific destination such as a database, session, or external API. Every Hyvä Checkout form must include a Save Service that implements the persistence logic.

## Modifiers

**Interface:** `\Hyva\Checkout\Model\Form\EntityFormModifierInterface`

Form modifiers in Hyvä Checkout let you customize form behavior based on specific hooks triggered during initialization and submit handling. Modifiers give you a structured way to inject custom logic without editing core form classes.

Modifiers require a single `apply()` method where you register modification callbacks using `registerModificationListener()`. You can remove existing modifiers with `unregisterModificationListener()`. Hooks are dispatched using `dispatchModificationHook()` to trigger registered callbacks at specific lifecycle points.

## Elements

**Class:** `\Hyva\Checkout\Model\Form\AbstractEntityFormElement`

Form elements in Hyvä Checkout are layout blocks with templates that automatically bind to element objects. Elements provide the visual components of a form - things like buttons, links, and promotional banners. Elements can't hold values themselves, so use fields for data capture.

The element object can be a basic class provided with Hyvä Checkout or a custom injected object. Elements provide structure and interactivity but delegate data storage to fields.

Elements don't inherently know how to be rendered. We've developed a specific rendering mechanism that you control via regular Layout XML. Check out the [rendering](form-rendering.html) page for full details on all the possibilities.

### Clickable (Abstract Base)

**Class:** `\Hyva\Checkout\Model\Form\EntityFormElement\Clickable`

The Clickable element is an abstraction layer for HTML elements that respond to click events. A clickable element doesn't have to be a `<button>` - it can be any interactive element that users can click. Clickable elements serve as the foundation for buttons and other interactive form components in Hyvä Checkout.

### Button

**Class:** `\Hyva\Checkout\Model\Form\EntityFormElement\Button`

The Button element extends the Clickable abstraction and renders as an HTML `<button>` element by default. Buttons can function as regular buttons or serve as base classes for specialized buttons like submit buttons.

This example creates a button element using the Hyvä Checkout Form API:

```
<?php

// Create a button element with a custom label
$form->createElement(Hyva\Checkout\Model\Form\EntityFormElement\Button::class, [
    'data' => [
        'label' => 'Open modal'
    ]
])
```

### Submit

**Class:** `\Hyva\Checkout\Model\Form\EntityFormElement\Submit`

The Submit button is a specialized version of a regular button element. Submit buttons in Hyvä Checkout come with additional specifications: a default "Submit" label, a different element type, and a unique `layoutAlias` to enable specific template assignment.

This example creates a submit button with a custom label:

```
<?php

// Create a submit button element for form submission
$form->createElement(Hyva\Checkout\Model\Form\EntityFormElement\Submit::class, [
    'data' => [
        'label' => 'Submit form'
    ]
])
```

### URL

**Class:** `\Hyva\Checkout\Model\Form\EntityFormElement\Url`

The URL element has its own `layoutAlias` (the `url` alias) enabling specific template application. URL elements in Hyvä Checkout can contain a value accessed through the `src` attribute, which you set using `setValue(string $url)`.

This example creates a URL element that renders as a link:

```
<?php

// Create a URL element with destination and label
$form->createElement(Hyva\Checkout\Model\Form\EntityFormElement\Url::class, [
    'data' => [
        'url' => 'https://hyva.io',
        'label' => 'Hyvä Themes'
    ]
])
```

## Fields

**Class:** `\Hyva\Checkout\Model\Form\EntityField\AbstractEntityField`

Fields in Hyvä Checkout are extensions of elements specifically designed to hold values. Fields are more elaborate than basic elements and include capabilities for validation, data binding, and value storage. Use fields when you need to collect user input.

By default, fields automatically fall back to the text template if no specific template is defined. You can fully customize each field by assigning its own template via regular Layout XML. Check out the [rendering](form-rendering.html) page for full details.

### Input

**Class:** `\Hyva\Checkout\Model\Form\EntityField\AbstractEntityField`

The input field element is a child of the abstraction layer and works best for cases where a customer needs to fill in a regular text value. Input fields in Hyvä Checkout can serve multiple purposes - form modifiers can adjust the input type to `email`, `tel`, or other HTML5 input types as needed. Input fields are the most flexible field type for text-based data capture in Hyvä Checkout forms.

## Factories

Form factories in Hyvä Checkout let you dynamically create form elements and fields. You create form elements or fields by calling methods like `$form->createField()` or `$form->createElement()`. These methods use designated factories to generate and provide the appropriate objects.

By default, when using `Hyva\Checkout\Model\Form\AbstractEntityForm`, fields are generated using `Hyva\Checkout\Model\Form\EntityFormFieldFactory`, and elements are created through `Hyva\Checkout\Model\Form\EntityFormFactory`. These factories are injected into the constructor via their predetermined names `fields` and `elements`.

### Injecting a Custom Factory

You can inject custom factories into your form object for specialized requirements. Access them through `$form->getFactoryFor('my_custom_factory')`. While the default field and element factories cover most scenarios, custom factories give you full flexibility.

This example injects a global custom factory into the Hyvä Checkout Form API via `di.xml`:

```
<!-- Inject global custom factory via di.xml -->
<type name="Hyva\Checkout\Model\Form\AbstractEntityForm">
    <arguments>
        <argument name="factories" xsi:type="array">
            <item name="my_example_factory" sortOrder="30" xsi:type="object">My\Example\Model\Form\EntityFormFactory\MyExampleFactory</item>
        </argument>
    </arguments>
</type>
```

Once the custom factory is registered, access it through the form object:

```
$form->getFactoryFor('my_example')->create(...$args);
```

### Elements Factory

The elements factory in Hyvä Checkout generates form element objects based on provided mappings. To tell the `create()` method what to produce, specify a `$name` such as `"button"` or `"promotional_banner"`.

Define element mappings within `etc/frontend/di.xml` to associate element names with their implementation classes:

```
<!-- Map a custom element name to its implementation class -->
<type name="Hyva\Checkout\Model\Form\EntityFormFactory">
    <arguments>
        <argument name="elements" xsi:type="array">
            <item name="promotional_banner" xsi:type="string">My\Example\Model\Form\EntityFormElement\PromotionalBanner</item>
        </argument>
    </arguments>
</type>
```

After mapping the element, create it through the form object:

```
$form->createElement('promotional_banner', $arguments ?? []);
```

#### Direct Object Assignment for Elements

Mapping elements via `di.xml` is better for reusability across multiple forms. However, you can also pass the object class directly, like `$form->createElement(PromotionalBanner::class)`.

Direct object assignment in Hyvä Checkout requires additional options - the default element renderer will search for either a layout alias or the ID data value. Here are two approaches:

**Approach 1: By layout alias**

Define a `getLayoutAlias()` method that returns an identifier useful for referencing the element:

```
<?php

namespace My\Example\Model\HyvaCheckout\Form\EntityFormElement;

// Custom element with a layout alias for renderer lookup
class PromotionalBanner extends \Hyva\Checkout\Model\Form\AbstractEntityFormElement
{
    public function getLayoutAlias()
    {
        // The renderer searches for "{form_namespace}.promotional_banner" or "promotional_banner"
        return 'promotional_banner';
    }
}
```

**Approach 2: By element ID**

Pass an ID in the element data that the renderer can use for template matching:

```
<?php

// The renderer searches for "{form_namespace}.{element_id}" or "{element_id}"
$form->addElement(
    $form->createElement(My\Example\Model\HyvaCheckout\Form\EntityFormElement\PromotionalBanner::class, [
        'data' => [
            'id' => 'promotional_banner'
        ]
    ])
);
```

More details about element rendering can be found on the [form rendering](form-rendering.html) page.

### Fields Factory

The field factory in Hyvä Checkout constructs field objects using a fallback mechanism to determine the right implementation class. While the core concept stays the same as the elements factory, the field factory has slight differences in the parameters required for the `create()` method and how field objects are mapped.

The resolution process for finding the right field object mirrors the method used to find the correct render template, as detailed in the [field rendering documentation](form-rendering.html#fields). The fallback mechanism checks for increasingly specific matches first, then falls back to more general ones. This means you can inject a different object for a specific form while keeping the global default for all other forms.

#### Field Factory Fallback Order

The field factory searches for a matching field implementation in this order (most specific first):

| Level | Alias |
| --- | --- |
| 6 | {form\_namespace}.{field\_name}.{input\_type} |
| 5 | {form\_namespace}.{field\_name} |
| 4 | {field\_name}.{input\_type} |
| 3 | {field\_name} |
| 2 | {form\_namespace}.{input\_type} |
| 1 | {input\_type} |

Why don't elements have a fallback mechanism?

Elements can have an infinite range of distinctive name options and don't need a specific type. Fields, on the other hand, are tied to a predetermined range of HTML input types. So the ability to swap objects without changing all instances is only needed for fields.

#### Defining Field Mappings in di.xml

Define field mappings within `etc/frontend/di.xml` to associate field names with their implementation classes:

```
<!-- Map custom field names to implementation classes -->
<type name="Hyva\Checkout\Model\Form\EntityFormFactory">
    <arguments>
        <argument name="elements" xsi:type="array">
            <!-- Global field mapping: matches any form with a "delivery_date" field -->
            <item name="delivery_date" xsi:type="string">My\Example\Model\Form\EntityFormField\DeliveryDate</item>
            <!-- Form-specific mapping: only matches the "example_form" form -->
            <item name="example_form.delivery_date" xsi:type="string">My\Example\Model\Form\EntityFormField\ExampleForm\DeliveryDate</item>
        </argument>
    </arguments>
</type>
```

Create the field through the form object with the field name and input type:

```
$form->createField('delivery_date', 'date', $arguments ?? []);
```

### Built-in System Elements

Hyvä Checkout includes several fields and elements out of the box, some specifically designed to handle EAV attributes. These system elements provide common form components for address forms and customer data capture.

| Name | Factory | Abstraction | HTML Element | Input Type | EAV |
| --- | --- | --- | --- | --- | --- |
| submit | Element | Button | Button | N/A | No |
| id | Field | AbstractEntityField | Input | Hidden | No |
| save | Field | AbstractEntityField | Input | Checkbox | No |
| telephone | Field | EavAttributeField | Input | Tel | Yes |
| street | Field | EavAttributeField | Input | Text | Yes |
| region | Field | EavAttributeField | Input, Select | Text, Select | Yes |
| country\_id | Field | EavAttributeField | Select | Select | Yes |
| postcode | Field | EavAttributeField | Input | Text | Yes |
| prefix | Field | EavAttributeField | Select | N/A | Yes |
| gender | Field | EavAttributeField | Select | N/A | Yes |

We're exploring the option of renaming the EAV attributes for addresses to include an `eav_` prefix in their names, particularly where the current names are too general. We aim to accomplish this without any backward incompatible changes, most likely by introducing a dedicated EAV field factory.

## Related Topics

- **[Form Rendering](form-rendering.html)** - How Hyvä Checkout renders form elements and fields using Layout XML templates
- **[Form Modification Hooks](form-modification-hooks.html)** - Available lifecycle hooks for customizing form behavior with modifiers
- **[Form Validations](form-validations.html)** - Adding validation rules to form fields
- **[Magewire-Driven Forms](magewire-driven-forms.html)** - Building complete forms powered by Magewire
