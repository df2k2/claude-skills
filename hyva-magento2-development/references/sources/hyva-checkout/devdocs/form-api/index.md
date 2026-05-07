<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-api/index.html -->

# Hyva Checkout Form API

The Hyva Checkout Form API provides a structured approach to building interactive, customizable forms in the checkout. It brings together form elements - fields, buttons, and other components - into a single phtml file while keeping full customization options intact.

With the Form API, form structure is defined in PHP classes, rendering is controlled through Layout XML, and presentation is handled in templates. This separation of concerns means third-party modules can modify forms through dedicated extension points like modifiers and factories, without touching the main phtml templates.

## When to Use the Hyva Checkout Form API

The Hyva Checkout Form API is the right choice when you need a form that third parties can easily extend or modify. If you are planning to create a form that will need changes later, building on the Form API's abstraction layer is the most sensible approach.

If you only need fixed fields or minimal modifications, a regular phtml template with some fields and buttons (optionally using Magewire) is perfectly fine.

Address Forms Built with the Form API

All address forms in Hyva Checkout are built using the Form API abstraction, so developers can fully customize the forms without needing access to the core. In the future, components like the order comment and coupon code forms will be migrated to the Form API as well.

## Shipping Address Form - A Practical Example

The Hyva Checkout shipping address form shows the practical value of the Form API. The shipping address form is relatively straightforward at first glance: it includes fields that reflect all required quote address attributes provided by Magento.

From a user's perspective, the shipping address form seems simple. But complexity stacks up fast when you consider things like:

- Fields that display based on system configuration or attribute settings
- A region dropdown that only appears for specific countries
- Third-party extensions that hide certain address fields and replace them with a single auto-complete field linked to an address lookup API

Customization requirements come up quickly. Thanks to the Form API, you can make these modifications cleanly without overwriting templates. This prevents conflicts where multiple extensions need different changes to the same form element.

## Building a Magewire-Driven Form with the Form API

This section walks through a complete Hyva Checkout form implementation using Magewire as the form driver. A Magewire-driven form requires several components working together: a Layout XML block, a Magewire component class, a Form class, and a Save Service class.

Advanced Magewire Form Examples

For a more advanced example, check out the [Magewire Driven Forms](magewire-driven-forms.html) guide.

### Layout XML Block for a Magewire-Driven Form

The Layout XML block defines where and how the form renders on the page. Hyva Checkout provides a default form template specifically designed for Magewire-driven forms. Wrapping the form with a parent block is a good practice - it lets you add blocks in front of or behind the form later.

This Layout XML configures a Magewire-driven form block with its parent wrapper:

```
<!-- Parent wrapper block for the form -->
<block name="magewire-driven-form"
       template="Hyva_Example::checkout/magewire-driven-form.phtml"
>
    <!-- Inner form block using the Hyva Checkout Magewire form template -->
    <block name="magewire-driven-form.form"
           as="form"
           template="Hyva_Checkout::magewire/component/form.phtml"
    >
        <arguments>
            <!-- Bind the Magewire component class to this block -->
            <argument name="magewire" xsi:type="object">
                \Hyva\Example\Magewire\Checkout\MagewireDrivenForm
            </argument>
        </arguments>
    </block>
</block>
```

### Magewire Component Class for Form Interaction

The Magewire component class handles form interaction and submission logic. Since Magewire drives the form, the component extends `\Hyva\Checkout\Magewire\Component\AbstractForm`.

This example shows the minimal Magewire component class required to power a form:

```
<?php

// Extend AbstractForm to get built-in form handling and validation
class MagewireDriven extends \Hyva\Checkout\Magewire\Component\AbstractForm
{
    public function __construct(
        \Rakit\Validation\Validator $validator,
        // Inject your custom form class (see next section)
        \Hyva\Example\Model\Form\MagewireDrivenForm $form,
        \Psr\Log\LoggerInterface $logger,
        \Hyva\Checkout\Model\Magewire\Component\Evaluation\Batch $evaluationResultBatch
    ) {
        parent::__construct($validator, $form, $logger, $evaluationResultBatch);
    }
}
```

### Form Class for Defining Form Structure

The Form class defines the form structure, including fields, elements, and attributes. The Magewire component requires a form object that extends `Hyva\Checkout\Model\Form\AbstractEntityForm`.

This example shows a complete form class with field construction and a submit button:

```
<?php

class MagewireDrivenForm extends \Hyva\Checkout\Model\Form\AbstractEntityForm
{
    // Unique form namespace constant (required).
    // Used for renderer lookups - choose a descriptive, unique name.
    public const FORM_NAMESPACE = 'my_form';

    public function __construct(
        Hyva\Checkout\Model\Form\EntityFormFieldFactory $entityFormFieldFactory,
        Magento\Framework\View\LayoutInterface $layout,
        Psr\Log\LoggerInterface $logger,
        // Custom save service that handles form data persistence
        Hyva\Example\Model\Form\SaveService\MagewireDrivenFormSaveService $formSaveService,
        Magento\Framework\Serialize\Serializer\Json $jsonSerializer,
        // Optional: modifiers and factories for extensibility
        array $entityFormModifiers = [],
        array $factories = []
    ) {
        parent::__construct(
            $entityFormFieldFactory, $layout, $logger,
            $formSaveService, $jsonSerializer,
            $entityFormModifiers, $factories
        );
    }

    /**
     * Populate the form with fields and elements.
     * Called during form initialization to build the default form structure.
     */
    public function populate(): EntityFormInterface
    {
        // Add a text input field for the firstname
        $this->addField(
            $this->createField('firstname', 'text', [
                'data' => [
                    'label' => 'Firstname'
                ]
            ])
        );

        // Add a submit button element
        $this->addElement(
            $this->createElement('submit', [
                'data' => [
                    'label' => 'Save'
                ]
            ])
        );

        // Set the form submission to use Magewire's "submit" method
        $this->setAttribute('wire:submit.prevent="submit"');

        return $this;
    }

    /**
     * Get the form title for display purposes.
     */
    public function getTitle(): string
    {
        return 'My form';
    }
}
```

The Form class has three key requirements:

1. **`FORM_NAMESPACE` constant** - Must be unique for each form. This namespace is publicly used during rendering, so pick a descriptive name.
2. **`$formSaveService`** - A custom class that handles persisting the form field values (see next section).
3. **`populate()` method** - Builds the default form elements (fields, buttons, attributes). The `getTitle()` method returns the form's display title.

Choosing a Form Namespace

The `FORM_NAMESPACE` describes the form's purpose and is used when the form is rendered. Choose a name that clearly communicates what the form does.

### Save Service Class for Data Persistence

The Save Service handles persisting data when the user submits the form. Where the data gets stored is entirely up to you - it could go to a database, session, external API, or anywhere else.

This example shows a minimal Save Service implementation:

```
<?php

// Extend AbstractEntityFormSaveService for built-in form handling
class MagewireDrivenFormSaveService extends \Hyva\Checkout\Model\Form\AbstractEntityFormSaveService
{
    /**
     * Save the form data to the appropriate destination.
     * Receives the populated form with all submitted field values.
     */
    public function save(
        Hyva\Checkout\Model\Form\EntityFormInterface $form
    ): Hyva\Checkout\Model\Form\EntityFormInterface {
        // Implement your save logic here.
        // For example: persist to database, store in session, or call an external API.
        return $form;
    }
}
```

EntityFormInterface Deprecation

The `\Hyva\Checkout\Model\Form\EntityFormInterface` will be marked as deprecated but can still be used. For new forms, use `\Hyva\Checkout\Model\Form\AbstractEntityForm` instead.

### Form Modifier Class for Optional Customization

Form modifiers in Hyva Checkout let you customize existing forms through lifecycle hooks without modifying the original form class. All essential fields should be created in the `populate()` method. Modifiers are best suited for optional fields or conditional logic.

A good example is a login component: the password field should only appear when the user enters an email address that belongs to an existing customer. After syncing with Magento, a modifier hooks in, checks the email field value, and conditionally displays the password field.

This example shows a form modifier that adds a password field:

```
<?php

class WithLastnameModifier implements \Hyva\Checkout\Model\Form\EntityFormModifierInterface
{
    /**
     * Register modification listeners on the form.
     * Listeners execute at specific lifecycle points (hooks).
     */
    public function apply(
        \Hyva\Checkout\Model\Form\EntityFormInterface $form
    ): \Hyva\Checkout\Model\Form\EntityFormInterface {
        // Register a callback for the 'form:init' lifecycle hook
        $form->registerModificationListener(
            'someUniqueNameDescribingTheModifierPurpose', // Unique listener name
            'form:init',                                  // Lifecycle hook to listen for
            fn ($form) => $this->includeAuthentication($form)
        );
    }

    /**
     * Add a password field to the form for authentication.
     * Called by the 'form:init' modification listener.
     */
    private function includeAuthentication(
        \Hyva\Checkout\Model\Form\EntityFormInterface $form
    ) {
        // Create and add a password field to the form
        $form->addField(
            $form->createField(
                'password',
                'password',
                [
                    'label' => 'Password'
                ]
            )
        );
    }
}
```

Modifiers Are Not Form Constructors

Modifiers are meant to hook into specific lifecycle moments and make adjustments. A form should work correctly without any modifiers applied. Think of modifiers as optional enhancements, not required building blocks.
