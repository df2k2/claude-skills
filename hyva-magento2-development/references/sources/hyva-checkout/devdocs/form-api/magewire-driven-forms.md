<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-api/magewire-driven-forms.html -->

# Magewire-Driven Forms in Hyva Checkout

Magewire-driven forms bring server-side form handling, real-time validation, and dynamic behavior to Hyva Checkout. They combine the power of PHP-based logic with reactive frontend updates - forms sync data via Ajax requests as users interact with fields, giving you full control over data persistence and validation.

You have complete freedom in how you manage your forms. Magewire is one approach - you could also go with a more frontend-centric approach using Alpine.js. Each method has its own strengths, and the right choice depends on your use case.

## When to Use Magewire-Driven Forms

Magewire-driven forms in Hyva Checkout are a great fit when you want a server-centric development model with built-in reactivity. Magewire gives both backend and frontend developers a way to create dynamic forms that run via the server through Ajax requests. This means you can sync data directly to the server, either on field completion or full form submission.

Magewire comes packed with features to handle a wide range of requirements. The default shipping and billing forms in Hyva Checkout are powered by Magewire out of the box, so you get a solid reference implementation to build on.

## Example: Building a Guest Details Component

This example walks through a Guest Details component implementation using the Hyva Checkout Form API with Magewire. The `AbstractForm` Magewire component provides extensibility when constructing your form object. This component acts as a robust abstraction, turning your form into a dynamic entity that you can augment with modifiers. It ships with numerous modification hooks, and you can add custom hooks to meet specific requirements.

For broader details on constructing forms, check out the [Form API overview](index.html).

Let's walk through a minimized version of the core Guest Details component.

### Step 1: Constructing the Form Component

The Magewire component class handles real-time updates and customer existence checking. This GuestDetails form component checks whether a customer account already exists when an email address is entered.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, the component reads the form with `$this->form()` (`getForm()` still works but is deprecated) and opts out of the Magewire 1 compatibility layer with the `#[HandleBackwardsCompatibility(enabled: false)]` attribute, as the core component does. See [The Magewire 1 Backward Compatibility Module](../../magewire/v1bc.html). The component looks like this:

```
<?php

use Magewirephp\Magewire\Features\SupportMagewireBackwardsCompatibility\HandleBackwardsCompatibility;
use function Magewirephp\Magewire\store;

// Run as a native Magewire 3 component, without the v1 compatibility layer.
#[HandleBackwardsCompatibility(enabled: false)]
// Extend AbstractForm to get Hyva Checkout Form API integration
class GuestDetails extends \Hyva\Checkout\Magewire\Component\AbstractForm
{
    // Public property to track whether the entered email belongs to an existing customer.
    // Magewire automatically syncs public properties to the frontend.
    public bool $customerExists = false;

    /**
     * Boot method runs on every request.
     * On the first render, checks if the email field already has a value
     * (e.g., from a previous session) and determines customer existence.
     */
    public function boot(): void
    {
        parent::boot();

        // Retrieve the email field from the GuestDetails form object
        $email = $this->form()->getField(GuestDetailsForm::FIELD_EMAIL);

        // Skip the check on update requests, updatedDataEmailAddress() handles those.
        $updating = store($this)->get('magewire:update', false);

        if (! $updating && $email && $email->hasValue()) {
            $this->handleCustomerExistence($email->getValue());
        }
    }

    /**
     * Magewire magic property hook for $this->data['email_address'].
     * Automatically called whenever the email_address field value changes
     * via wire:model binding on the frontend.
     *
     * @param string $value - The new email address value
     * @return string - The validated email value
     */
    public function updatedDataEmailAddress($value)
    {
        // Check if the email belongs to an existing customer account
        $this->handleCustomerExistence($value);

        // Submit and save the email value using the Form API Save Service
        $this->submit([GuestDetailsForm::FIELD_EMAIL => $value]);

        return $value;
    }

    /**
     * Toggle the customerExists property based on email validation.
     * Uses the Magento AccountManagement API to check if the email is already registered.
     *
     * @param string $email - The email address to check
     */
    private function handleCustomerExistence(string $email): void
    {
        $exists = filter_var($email, FILTER_VALIDATE_EMAIL);

        if ($exists) {
            try {
                // isEmailAvailable returns true if NOT registered, so we negate it
                $exists = ! $this->accountManagement->isEmailAvailable($email);
            } catch (LocalizedException $exception) {
                $this->logger->critical(sprintf(
                    'Something went wrong while checking the availability of the email address %s',
                    $email
                ));

                $exists = false;
            }
        }

        $this->customerExists = $exists;
    }
}
```

On Checkout 1.x, the component reads the form with `$this->getForm()`:

```
<?php

// Extend AbstractForm to get Hyva Checkout Form API integration
class GuestDetails extends \Hyva\Checkout\Magewire\Component\AbstractForm
{
    // Public property to track whether the entered email belongs to an existing customer.
    // Magewire automatically syncs public properties to the frontend.
    public bool $customerExists = false;

    /**
     * Boot method runs during Magewire component initialization.
     * Checks if the email field already has a value (e.g., from a previous session)
     * and determines customer existence on page load.
     */
    public function boot(): void
    {
        parent::boot();

        // Retrieve the email field from the GuestDetails form object
        $email = $this->getForm()->getField(GuestDetailsForm::FIELD_EMAIL);

        if ($email && $email->hasValue()) {
            $this->handleCustomerExistence($email->getValue());
        }
    }

    /**
     * Magewire magic property hook for $this->data['email_address'].
     * Automatically called whenever the email_address field value changes
     * via wire:model binding on the frontend.
     *
     * @param string $value - The new email address value
     * @return string - The validated email value
     */
    public function updatedDataEmailAddress($value)
    {
        // Check if the email belongs to an existing customer account
        $this->handleCustomerExistence($value);

        // Submit and save the email value using the Form API Save Service
        $this->submit([GuestDetailsForm::FIELD_EMAIL => $value]);

        return $value;
    }

    /**
     * Toggle the customerExists property based on email validation.
     * Uses the Magento AccountManagement API to check if the email is already registered.
     *
     * @param string $email - The email address to check
     */
    private function handleCustomerExistence(string $email): void
    {
        if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
            try {
                // isEmailAvailable returns true if NOT registered, so we negate it
                $this->customerExists = !$this->accountManagement->isEmailAvailable($email);
            } catch (LocalizedException $exception) {
                $this->logger->critical(sprintf(
                    'Something went wrong while checking the availability of the email address %s',
                    $email
                ));
            }
        }
    }
}
```

### Step 2: Apply Modifications (Optional)

Form modifiers for Magewire-driven forms can hook into various lifecycle events to customize behavior. You can extend the base form on triggers including `form:init`, `form:build:magewire`, and the post-submit hook (`form:trigger:submit:magewire` on Checkout 3.x, `form:execute:submit:magewire` on Checkout 1.x). On Checkout 3.x, `form:execute:submit:magewire` still fires as a deprecated alias. See [Form Modification Hooks](form-modification-hooks.html#magewire-component-hooks).

For readability, the hook callback method bodies are omitted in this example. Here is what each hook handles:

**The `form:init` hook:**

1. Sets the `autocomplete` attribute to `off` on the email field.
2. Adds an advanced form validation rule `email` set to `true`.
3. Creates and adds a password field along with a comment.
4. Creates and adds a submit button element with a custom "Submit" label.

**The `form:build:magewire` hook:**

1. Uses the extended Alpine.js component `initMagewireFormForGuestDetails($el, $wire)` via a `x-data` attribute on the form.
2. Sets a `wire:loading.attr` attribute as `disabled` on each field.
3. Hides both the submit element and password field when the customer email address is non-existent.
4. Makes each field compatible with the Magewire component by setting a `wire:model.defer` attribute as `data.{field_id}`. On Checkout 3.x, plain `wire:model` is already deferred, so the `.defer` modifier changes nothing there.
5. Binds a new `submit` value onto the Magewire `$loader` property, displaying "Trying to authenticate" when the button is clicked.

The following modifier class registers multiple hooks for the Guest Details form. Only the post-submit hook name differs between the release lines:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

```
<?php

// Implements EntityFormModifierInterface to hook into the Form API lifecycle
class WithAuthenticationModifier implements \Hyva\Checkout\Model\Form\EntityFormModifierInterface
{
    public function __construct(
        // Inject system configuration to check if guest login is enabled
        private readonly \Hyva\Checkout\Model\ConfigData\HyvaThemes\SystemConfigGuestDetails $systemConfigGuestDetails
    ) {
        //
    }

    /**
     * Apply modifications to the Guest Details form.
     * Registers lifecycle hooks only if the login feature is enabled in admin config.
     *
     * @param \Hyva\Checkout\Model\Form\EntityFormInterface $form
     * @return \Hyva\Checkout\Model\Form\EntityFormInterface
     */
    public function apply(\Hyva\Checkout\Model\Form\EntityFormInterface $form): \Hyva\Checkout\Model\Form\EntityFormInterface
    {
        // Skip registration if authentication feature is disabled in system config
        if (!$this->systemConfigGuestDetails->enableLogin()) {
            return $form;
        }

        // Hook: form:init - Add authentication fields (password, submit button)
        // during the initial form construction phase
        $form->registerModificationListener(
            'includeAuthentication',
            'form:init',
            fn ($form) => $this->includeAuthentication($form)
        );

        // Hook: form:build:magewire - Configure Magewire-specific attributes
        // (wire:model.defer, wire:loading.attr, x-data bindings)
        $form->registerModificationListener(
            'handleMagewireAuthenticationForm',
            'form:build:magewire',
            fn (\Hyva\Checkout\Model\Form\AbstractEntityForm $form, \Hyva\Checkout\Magewire\Checkout\GuestDetails $component)
                => $this->handleMagewireAuthenticationForm($form)
        );

        // Hook: form:build:magewire - Control field visibility based on
        // whether the entered email belongs to an existing customer
        $form->registerModificationListener(
            'handleMagewireAuthenticationVisibility',
            'form:build:magewire',
            fn (\Hyva\Checkout\Model\Form\AbstractEntityForm $form, \Hyva\Checkout\Magewire\Checkout\GuestDetails $component)
                => $this->handleMagewireAuthenticationVisibility($form, $component)
        );

        // Hook: form:trigger:submit:magewire - Handle the actual authentication
        // logic when the form is submitted (login attempt, error handling)
        $form->registerModificationListener(
            'handleAuthenticationSubmitAction',
            'form:trigger:submit:magewire',
            fn (\Hyva\Checkout\Model\Form\AbstractEntityForm $form, \Hyva\Checkout\Magewire\Checkout\GuestDetails $component, $result, $data, $exception)
                => $this->handleAuthenticationSubmitAction($form, $component, $result, $data, $exception)
        );

        return $form;
    }
}
```

```
<?php

// Implements EntityFormModifierInterface to hook into the Form API lifecycle
class WithAuthenticationModifier implements \Hyva\Checkout\Model\Form\EntityFormModifierInterface
{
    public function __construct(
        // Inject system configuration to check if guest login is enabled
        private readonly \Hyva\Checkout\Model\ConfigData\HyvaThemes\SystemConfigGuestDetails $systemConfigGuestDetails
    ) {
        //
    }

    /**
     * Apply modifications to the Guest Details form.
     * Registers lifecycle hooks only if the login feature is enabled in admin config.
     *
     * @param \Hyva\Checkout\Model\Form\EntityFormInterface $form
     * @return \Hyva\Checkout\Model\Form\EntityFormInterface
     */
    public function apply(\Hyva\Checkout\Model\Form\EntityFormInterface $form): \Hyva\Checkout\Model\Form\EntityFormInterface
    {
        // Skip registration if authentication feature is disabled in system config
        if (!$this->systemConfigGuestDetails->enableLogin()) {
            return $form;
        }

        // Hook: form:init - Add authentication fields (password, submit button)
        // during the initial form construction phase
        $form->registerModificationListener(
            'includeAuthentication',
            'form:init',
            fn ($form) => $this->includeAuthentication($form)
        );

        // Hook: form:build:magewire - Configure Magewire-specific attributes
        // (wire:model.defer, wire:loading.attr, x-data bindings)
        $form->registerModificationListener(
            'handleMagewireAuthenticationForm',
            'form:build:magewire',
            fn (\Hyva\Checkout\Model\Form\AbstractEntityForm $form, \Hyva\Checkout\Magewire\Checkout\GuestDetails $component)
                => $this->handleMagewireAuthenticationForm($form)
        );

        // Hook: form:build:magewire - Control field visibility based on
        // whether the entered email belongs to an existing customer
        $form->registerModificationListener(
            'handleMagewireAuthenticationVisibility',
            'form:build:magewire',
            fn (\Hyva\Checkout\Model\Form\AbstractEntityForm $form, \Hyva\Checkout\Magewire\Checkout\GuestDetails $component)
                => $this->handleMagewireAuthenticationVisibility($form, $component)
        );

        // Hook: form:execute:submit:magewire - Handle the actual authentication
        // logic when the form is submitted (login attempt, error handling)
        $form->registerModificationListener(
            'handleAuthenticationSubmitAction',
            'form:execute:submit:magewire',
            fn (\Hyva\Checkout\Model\Form\AbstractEntityForm $form, \Hyva\Checkout\Magewire\Checkout\GuestDetails $component, $result, $data, $exception)
                => $this->handleAuthenticationSubmitAction($form, $component, $result, $data, $exception)
        );

        return $form;
    }
}
```

For the full callback method implementations, refer to `\Hyva\Checkout\Model\Form\EntityFormModifier\GuestDetailsForm\WithAuthenticationModifier`.

### Step 3: Assign the Modifier to the Form

Form modifiers are assigned to specific forms through dependency injection configuration. This `di.xml` entry assigns the authentication modifier to the Guest Details form:

```
<!-- File: etc/frontend/di.xml -->

<!-- Register the WithAuthenticationModifier for the GuestDetailsForm.
     The 'entityFormModifiers' argument accepts an array of modifier classes
     that are applied in the order they are defined. -->
<type name="Hyva\Checkout\Model\Form\EntityForm\GuestDetailsForm">
    <arguments>
        <argument name="entityFormModifiers" xsi:type="array">
            <item name="with_authentication_feature" xsi:type="object">Hyva\Checkout\Model\Form\EntityFormModifier\GuestDetailsForm\WithAuthenticationModifier</item>
        </argument>
    </arguments>
</type>
```

### Step 4: Register the Component in Checkout Layout

The Magewire component must be registered in the checkout layout to appear on the page. This layout XML block registers the Guest Details component and links it to the Magewire-driven form template:

```
<!-- File: view/frontend/layout/hyva_checkout_components.xml -->

<!-- Register the Guest Details block inside the checkout components container.
     The 'magewire' argument transforms this into a Magewire-driven form
     by connecting the block to the GuestDetails Magewire component class. -->
<referenceBlock name="hyva.checkout.components">
    <container name="checkout.guest-details.section">
        <block name="checkout.guest-details"
               template="Hyva_Checkout::magewire/component/form.phtml"
        >
            <arguments>
                <argument name="magewire" xsi:type="object">
                    \Hyva\Checkout\Magewire\Checkout\GuestDetails
                </argument>
            </arguments>
        </block>
    </container>
</referenceBlock>
```

### Step 5: Inject the Component into the Checkout Shipping Step

Layout moves position the form component within the checkout flow. This layout XML places the Guest Details section into the shipping step:

```
<!-- File: view/frontend/layout/hyva_checkout_default_shipping.xml -->

<!-- Move the guest-details section into the main column of the shipping step.
     The before="-" attribute places it at the top of the column. -->
<body>
    <move element="checkout.guest-details.section"
          destination="column.main"
          before="-"/>
</body>
```

## Auto-Saving Magewire Form Data

Checkout 1.x only

Auto-saving as described in this section applies to Hyvä Checkout 1.x (Magewire 1). Checkout 3.x doesn't auto-save while the customer types. An `AbstractForm` component saves its form on `dehydrate()` of every request that updates it, as long as its `$autosave` property is on (the default), and the address forms also save on step navigation. Only the country field of the address forms syncs right away, so shipping methods and totals can refresh.

The `wire:auto-save` directive, the "Auto Save" column of the address form fields and the autosave timeout setting are removed on Checkout 3.x, `EntityFieldInterface::isAutoSave()` is deprecated and returns `false`, and the deprecated `AbstractForm::canAutoSave()` tells whether `dehydrate()` saves the form. The [v1bc module](../../magewire/v1bc.html) restores the directive and the settings for checkouts that still depend on them. The navigation button validation task described in the next section exists on both release lines.

Available since version 1.1.27

Auto-saving in Hyva Checkout Magewire-driven forms gives you controlled data persistence without continuous synchronization. Before version 1.1.27, auto-saving was fully automated - form data was always synced with the server, which other components like the price summary could depend on.

While that approach guaranteed all data was available at all times, in practice only a small subset of data is actually needed for checkout to function. So we adjusted the concept to give developers more control over which data gets stored.

Moving away from forms that auto-save everything brings real benefits:

1. **Greater control** over when and where data is stored.
2. **Better user experience** - no more unexpected behaviors while filling in forms.
3. **Frontend validation first** - JavaScript validation can run before any Ajax requests are made.

### How Auto-Save Works with Navigation Buttons

Auto-saving in Hyva Checkout uses navigation buttons and the Evaluation API for controlled form persistence. Hyva Checkout relies heavily on navigation buttons to guide users through checkout - either advancing to the next step or completing the order, depending on configuration. These navigation buttons serve as the anchor point for binding auto-save functionality.

From a framework perspective, the Evaluation API integrates with these buttons to trigger asynchronous functionality as needed. This enables Evaluation Navigation Tasks (dynamically injected via PHP code) to run when a button is clicked. These tasks run before any other actions and can optionally fail when, for instance, form validation doesn't pass.

Forms built using `Hyva\Checkout\Magewire\Component\AbstractForm` or the deprecated `Hyva\Checkout\Magewire\Checkout\AddressView\AbstractMagewireAddressForm` automatically include a validation task. The checkout runs it before the primary action, such as moving to the next step.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, `AbstractForm::build()` injects the task with the `submit` save action. When the customer clicks a navigation button, the `magewire-form` validator validates the form fields. If the form has changes that weren't sent to the server yet, it calls the save action on the component, and a `false` result holds the step. The following code shows how the validation is injected into the evaluation batch:

```
<?php

// Check if a 'submit' evaluation result already exists in the batch.
// If it does, skip injection to avoid duplicates.
$evaluationBatch->misses(
    fn (EvaluationResult $result) => $result->hasAlias('submit'),
    function (EvaluationResultBatch $batch) {
        // No 'submit' result found: inject the default form validation task.
        // This task saves the form when navigation buttons are clicked.
        $batch->push(
            $batch->factory()
                  ->createValidation('magewire-form')   // Create a validation of type 'magewire-form'
                  ->withDetails([
                      'saveAction' => 'submit'          // Component method that saves the form
                  ])
                  ->withAlias('submit')                 // Alias as 'submit' to prevent duplicate injection
                  ->withStackPosition(100)              // Position 100 controls execution order in the batch
        );
    }
);
```

The checkout checks for pending auto-save actions and executes them before the primary action. The following code shows how auto-save validation is injected into the evaluation batch:

```
<?php

// Check if a 'submit' evaluation result already exists in the batch.
// If it does, skip injection to avoid duplicates.
$evaluationBatch->misses(
    fn (EvaluationResult $result) => $result->hasAlias('submit'),
    function (EvaluationResultBatch $batch) {
        // No 'submit' result found - inject the default auto-save validation task.
        // This task triggers Magewire form auto-saving when navigation buttons are clicked.
        $batch->push(
            $batch->getFactory()
                  ->createValidation('magewire-form')   // Create a validation of type 'magewire-form'
                  ->withDetails([
                      'saveAction' => 'autosave'        // Flag this as an auto-save action
                  ])
                  ->withAlias('submit')                 // Alias as 'submit' to prevent duplicate injection
                  ->withStackPosition(100)              // Position 100 controls execution order in the batch
        );
    }
);
```

Developers can inject their own validations with the `submit` alias, which takes precedence and skips the default auto-save injection.

For more details about the Evaluation API, check out the [Evaluation API documentation](../evaluation-api/index.html).

### The `wire:auto-save` Directive

Checkout 1.x only

This section applies to Hyvä Checkout 1.x (Magewire 1). Checkout 3.x removed the `wire:auto-save` directive. On Checkout 3.x, the v1bc module provides it for Magewire 1 components, and on Hyvä Checkout's own forms for `wire:auto-save.self` fields. For native Magewire 3 code, bind values that other components need right away with `wire:model.live` (or `wire:model.blur` for text fields) instead.

The `wire:auto-save` directive in Hyva Checkout marks form fields for automatic saving when navigation buttons are clicked. Since more responsibility is now in the developer's hands, a way to flag specific fields for auto-saving is essential. The `wire:auto-save` directive does exactly that - you apply it to an input field within a Magewire component alongside the `wire:model.defer` directive.

These two directives complement each other: `wire:model.defer` binds the field's data to the Magewire component, while `wire:auto-save` signals that the field's data doesn't need continuous server syncing. Instead, the data is automatically saved when the user clicks one of the primary navigation buttons.

The following examples show different `wire:auto-save` configurations:

```
<form id="shipping">
    <!-- Basic auto-save: marks this input for the form's auto-save navigation task -->
    <input type="text" wire:model.defer="firstname" wire:auto-save/>

    <!-- Explicit form ID: links this input to a specific form by ID for auto-saving -->
    <input type="text" wire:model.defer="firstname" wire:auto-save="shipping"/>

    <!-- Self-saving with default delay: auto-saves after 1.5 seconds of inactivity -->
    <input type="text" wire:model.defer="firstname" wire:auto-save.self/>

    <!-- Self-saving with custom delay: auto-saves after 3 seconds of inactivity -->
    <input type="text" wire:model.defer="firstname" wire:auto-save.self.3000ms/>
</form>
```

The `wire:auto-save` directive requires a corresponding `wire:model.defer` directive. If `wire:model.defer` is missing, a console error will be thrown.

### Admin-Configurable Auto-Save

Checkout 1.x only

This section applies to Hyvä Checkout 1.x (Magewire 1). Checkout 3.x removed the "Auto Save" column of the address form fields. The v1bc module adds it back at its Checkout 1.x location for checkouts that still depend on it.

Available since version 1.1.29

Starting from version 1.1.29, administrators can configure auto-save behavior for individual form fields without code changes. The Shipping and Billing Address Forms in the admin area now include an "Auto Save" checkbox for each field. When enabled, the field automatically saves upon user input. This lets administrators selectively enable auto-saving for specific fields, giving greater flexibility over the checkout process.

#### How to Enable Auto-Save in the Admin Panel

1. In the admin panel, go to **Stores > Configuration > Hyva Themes > Checkout > Components > Shipping Address Form/Billing Address Form**.
2. Locate the **Auto Save** checkbox for the desired field and toggle it on.
3. Save the configuration.
4. The field will now automatically save on the frontend when the user provides input.

If the Auto Save checkbox is unchecked and the field still auto-saves, a form modifier may be overriding this behavior.

## Related Topics

- **[Form API Overview](index.html)** - Learn about the Hyva Checkout Form API architecture and when to use it
- **[Form Modification Hooks](form-modification-hooks.html)** - Deep dive into the available hooks for customizing forms
- **[Form Construction](form-construction.html)** - How to build form objects from scratch
- **[Form Validations](form-validations.html)** - Setting up client-side and server-side validation rules
- **[Evaluation API](../evaluation-api/index.html)** - How navigation tasks and auto-save integrate with the checkout flow
