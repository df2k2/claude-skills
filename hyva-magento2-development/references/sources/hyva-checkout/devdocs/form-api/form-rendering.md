<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-api/form-rendering.html -->

# Form Rendering

Form rendering in Hyvä Checkout is the system that turns form definitions into visible HTML on the frontend. It relies on three core building blocks: **renderers** (PHP classes that produce HTML), **PHTML templates** (the actual markup files), and **Layout XML** (the configuration that connects renderers to templates).

Forms can be powered by different drivers such as Magewire or Alpine.js. Each form element and field has its own dedicated template, and fields automatically fall back to the "text" renderer when no specific template is assigned.

The Hyvä Checkout rendering system separates presentation from logic. You can customize how forms look entirely through Layout XML and templates, without touching component code.

## Renderers

Renderers in Hyvä Checkout are PHP classes responsible for transforming form elements and fields into HTML output.

The checkout contains a wrapper component called **Main**, and all form-containing components live inside it. Forms consist of **elements** and **fields**, and only elements and fields that fall within the Main component get rendered.

### Element and Field Renderers

1.1.0
Elements and fields each have their own renderer class:

- **Element renderer**: `Hyva\Checkout\Model\Form\EntityFormElement\Renderer\Element`
- **Field renderer**: `Hyva\Checkout\Model\Form\EntityField\EntityFieldRenderer`

You can define custom renderers for individual elements or fields when you need specialized rendering logic.

### Using the Renderer in Templates

A renderer is available inside any PHTML template through the `getRenderer()` method. The renderer provides a `render()` method that expects the element instance. A convenient shortcut is `$element->render()`, which handles the rendering call for you.

This example renders all form elements in a loop:

```
<?php foreach ($form->getElements() as $element): ?>
    <?= /* @noEscape */ $element->render() ?>
<?php endforeach ?>
```

Beyond rendering the element or field itself, the renderer can also render **accessories** - helper templates that provide labels, tooltips, and other supporting markup.

## Layout XML

Important

Everything comes together under a Magento concept you should be familiar with: Layout XML. Understanding
how elements, fields, and accessories map to templates is key to working with Hyvä Checkout forms.

Layout XML in Hyvä Checkout controls form rendering by mapping elements and fields to their templates. Two layout handles are involved:

- **`hyva_checkout_components`** - the general checkout components handle
- **`hyva_checkout_form_elements`** - responsible for assigning templates to form elements

The `hyva_checkout_form_elements` handle provides two renderer blocks: `entity-form.field-renderers` and `entity-form.element-renderers`. The renderer searches these blocks for a matching child block `alias` based on the element or field being rendered.

### Elements

The element renderer searches for block aliases in `entity-form.element-renderers` to determine which template to use. The element renderer searches for these block aliases, in order of priority:

| Level | Alias |
| --- | --- |
| 2 | {form\_namespace}.{element\_id} |
| 1 | {element\_id} |

This example creates a "banner" element and binds it to a template. First, create the element in PHP:

```
$form->addElement($form->createElement('promotion-banner'));
```

Then bind the element to a specific template using Layout XML:

```
<!-- File: view/frontend/layout/hyva_checkout_form_elements.xml -->

<referenceBlock name="entity-form.element-renderers">
    <block name="form-element.promotion-banner"
           as="promotion-banner"
           template="My_Example::form/element/promotion-banner.phtml"
    />
</referenceBlock>
```

Block (element) aliases

The element renderer looks for two aliases: `{form_namespace}.{element_id}` and `{element_id}`.
Which alias you choose depends on how unique the element ID is.

For example, you might have a global component renderer used in multiple forms.
In one of those forms, the element behavior stays the same but the HTML needs to differ.
In that case, create a generic base template using `{element_id}`, and a form-specific
template using `{form_namespace}.{element_id}`.

### Fields

Field rendering in Hyvä Checkout uses a more extensive fallback mechanism than elements. The field renderer searches for block aliases in `entity-form.field-renderers`, working through these levels from most specific to least specific:

| Level | Alias |
| --- | --- |
| 7 | {form\_namespace}.{field\_id}.{input\_type} |
| 6 | {form\_namespace}.{field\_id} |
| 5 | {field\_id}.{input\_type} |
| 4 | {field\_id} |
| 3 | {form\_namespace}.{input\_type} |
| 2 | {input\_type} |
| 1 | text |

Thanks to this fallback, every field eventually defaults to a `text` type renderer, which always has a template assigned:

```
<block name="form-field.text" as="text" template="Hyva_Checkout::form/field/text.phtml"/>
```

Hyvä Checkout also ships with default templates for the most common input types: `select`, `checkbox`, `hidden`, and `password`.

### Accessories

Accessories in Hyvä Checkout are reusable helper templates that provide supporting markup like labels, tooltips, comments, and container wrappers. They can be shared across multiple elements or fields without being directly tied to any single component.

Element vs. Field Accessories

Accessories are specific to either elements or fields and cannot be interchanged. A label accessory
defined for fields cannot be used within an element, and vice versa.

Accessories use an `accessory.` alias prefix. For example, a "label" accessory is added as a child block to either `entity-form.element-renderers` or `entity-form.field-renderers` with the alias `accessory.label`.

This example defines accessories for both fields and elements:

```
<!-- File: view/frontend/layout/hyva_checkout_form_elements.xml -->

<referenceBlock name="entity-form.field-renderers">
    <!-- A form field label template. -->
    <block name="form-field.global.label"
           template="Hyva_Checkout::form/element/html/label.phtml"
           as="accessory.label"
    />
</referenceBlock>

<referenceBlock name="entity-form.element-renderers">
    <!-- A "before" accessory using a container template that lets a block act as a container. -->
    <block name="form-element.global.before"
           template="Hyva_Checkout::form/element/html/container.phtml"
           as="accessory.before"
    >
        <!-- Child blocks render automatically inside the container. -->
        <block name="element-script-block"
               template="My_Example::page/js/element-script.phtml"/>
    </block>
</referenceBlock>
```

Info

Accessory blocks automatically receive the element or field as the `element` data attribute. In some cases, a `parent` attribute is also available.

### Rendering Accessories in Templates

Accessories act as subordinates to the main element or field. As a best practice, always include `renderBefore()` and `renderAfter()` calls in your component templates. This gives other developers a way to insert additional blocks in a controlled manner without overriding the template.

This example shows how to render accessories within a field template:

```
<?= $element->getRenderer()->renderBefore($element) ?>
<?= $element->getRenderer()->renderLabel($element) ?>
<input <?= /* @noEscape */ $element->renderAttributes($escaper) ?> />
<?= $element->getRenderer()->renderComment($element) ?>
<?= $element->getRenderer()->renderAfter($element) ?>
```

Accessory-specific render methods

The render methods like `renderLabel()` and `renderComment()` are not magic methods. Only the
predefined accessories shipped out of the box have dedicated methods. For custom accessories,
use the `renderAccessory()` method (available since 1.1.11).

### Global Accessories Reference

Hyvä Checkout provides these global accessories out of the box:

| Accessory | Element | Field | Template | Method |
| --- | --- | --- | --- | --- |
| before | Yes | Yes | Hyva\_Checkout::form/element/html/container.phtml | renderBefore |
| after | Yes | Yes | Hyva\_Checkout::form/element/html/container.phtml | renderAfter |
| label | No | Yes | Hyva\_Checkout::form/element/html/label.phtml | renderLabel |
| comment | No | Yes | Hyva\_Checkout::form/element/html/comment.phtml | renderComment |
| tooltip | No | Yes | Hyva\_Checkout::form/field/html/tooltip.phtml | renderTooltip |

## Forms

Forms in Hyvä Checkout are PHTML files that receive a form object through a ViewModel or Magewire component. The form template iterates over its elements and renders each one using its assigned renderer.

This example shows a form powered by a Magewire component of type `Hyva\Checkout\Magewire\Component\AbstractForm`:

```
<block name="example.form"
       as="form"
       template="Hyva_Checkout::magewire/component/form.phtml"
>
    <arguments>
        <argument name="magewire" xsi:type="object">
            \My\Example\Magewire\Checkout\ExampleForm
        </argument>
    </arguments>
</block>
```

The corresponding form template renders the form element and iterates over all form elements:

```
<?php

/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Checkout\Magewire\Component\AbstractForm $magewire */

$form = $magewire->getPublicForm();
?>

<form <?= /* @noEscape */ $form->renderAttributes($escaper) ?>>
    <?php foreach ($form->getElements() as $element): ?>
        <?php if ($element->canRender()): ?>
            <?= /* @noEscape */ $element->render() ?>
        <?php endif ?>
    <?php endforeach ?>
</form>
```

Info

For Magewire-driven forms, you can also use the pre-built form template at `Hyva_Checkout::magewire/component/form.phtml`.

The form structure is intentionally minimal. This design lets you modify forms through form modifiers without needing to override the template.

## Advanced Rendering

Advanced rendering techniques in Hyvä Checkout let you make highly specific customizations without overriding templates. While the out-of-the-box element templates cover most needs, several built-in rendering patterns handle cases where you need fine-grained control.

### Targeted Accessories

Targeted accessories in Hyvä Checkout let you customize accessories for specific form elements without creating dedicated templates. For example, say you need to change the label of the "firstname" field in the shipping address form, but you don't want to assign a whole new template just for that field. Targeted accessories solve this by letting you pinpoint a specific form element and assign a child block aliased as `label`.

This example targets a specific field to customize its label accessory:

```
<!-- File: view/frontend/layout/hyva_checkout_form_elements.xml -->

<referenceBlock name="entity-form.field-renderers">

    <!-- Target field by alias {form-namespace}.{field-id}. -->
    <block name="specific-shipping-firstname" as="shipping.firstname">

        <!-- Assign a custom template just for the label. -->
        <block name="specific-shipping-firstname.label"
               as="label"
               template="My_Example::form/shipping/field/firstname-label.phtml"
        />
    </block>
</referenceBlock>
```

Info

Removing the label block lets the field automatically fall back to the `accessory.label` template.

The custom label template receives the element object automatically:

```
<?php
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Hyva\Checkout\Model\Form\EntityField\AbstractEntityField $element */
/** @var \Magento\Framework\Escaper $escaper */

// The element object is automatically passed to the block object.
$element = $block->getData('element');
?>

<span class="font-bold text-blue-700 italic">
    <?= $escaper->escapeHtml($element->getLabel()) ?>
</span>
```

Info

The example above shows a form field. Elements can also be targeted by referencing the `entity-form.element-renderers` block instead.

### Wrapping a Form Element

Wrapping form elements in Hyvä Checkout lets you add container markup around fields without duplicating template code. Imagine you have a "Save to address book" checkbox rendered with the native `Hyva_Checkout::form/field/checkbox.phtml` template, but you want to wrap it with `<div class="bg-gray-100">...</div>`. Copying the entire checkbox template just for a wrapper leads to duplicated code and inconsistencies across your checkboxes.

Instead, Hyvä Checkout lets you render the standard checkbox field inside your custom wrapper template.

This example wraps a checkbox field with a custom container:

```
<!-- File: view/frontend/layout/hyva_checkout_form_elements.xml -->

<referenceBlock name="entity-form.field-renderers">

    <!-- Target checkbox field by alias {form-namespace}.{field-id}.{input-type} -->
    <block name="save_address_book_shipping"
           as="shipping.save.checkbox"
           template="My_Example::form/shipping/field/save-address-book.phtml"
    />
</referenceBlock>
```

The wrapper template uses `renderWithTemplate()` to render the original checkbox inside a custom container:

```
<?php
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Hyva\Checkout\Model\Form\EntityField\AbstractEntityField $element */
/** @var \Magento\Framework\Escaper $escaper */

// The element object is automatically passed to the block object.
$element = $block->getData('element');
?>

<div class="bg-gray-100 px-6 py-4">
    <?= $element->getRenderer()->renderWithTemplate('Hyva_Checkout::form/field/checkbox.phtml', $element) ?>
</div>
```

Why use the `.checkbox` type in the alias?

Using `shipping.save.checkbox` as the alias prevents this custom template from accidentally
rendering a different input type. If a form modifier later changes the input type to a select
or button, the field falls back to its standard rendering instead. Without the `.checkbox`
suffix, a select element could end up rendered as a checkbox.

### Conditional Rendering

Conditional rendering in Hyvä Checkout lets form elements appear or disappear based on system configuration settings. You can control this by adding a standard `ifconfig` statement to your form element block.

This example shows or hides the street field based on a configuration value:

```
<!-- File: view/frontend/layout/hyva_checkout_form_elements.xml -->

<block name="form-field.street"
       as="street"
       template="Hyva_Checkout::form/field/street.phtml"
       ifconfig="hyva_themes_checkout/developer/address_form/use_street_renderer"
/>
```

If the config setting doesn't exist or returns `false`, the street field seamlessly falls back to the standard `text` field type.

### Street Field Variants

Street field variants in Hyvä Checkout provide flexible layouts for multi-line street addresses. By default, Magento supports 1-4 street fields to accommodate various address formats, since some addresses need more than a street name and house number. The number of visible street fields is controlled by a native Magento setting.

Hyvä Checkout (since version 1.1.1) takes this further by letting you customize the street field layout. In addition to the default vertical stacking, two extra layout options are available:

- **Two Column Grid** - street fields arranged in a two-column layout
- **One Column Row** - street fields displayed in a single row

You can find these options under **Hyvä Checkout system settings > Developer > Address Forms**.

To show validation messages below each street line, add rules to a single line, or style one line differently, see [Validating and Styling Street Address Lines](../form-customization/street-address-lines.html).
