<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-api/form-validations.html -->

# Form Validations in Hyvä Checkout

Form validation in Hyvä Checkout supports both client-side JavaScript validation for immediate user feedback and server-side Magewire validation for security. Use client-side validation to give visitors fast feedback, and server-side validation to ensure data integrity. Both approaches work together for comprehensive form validation.

On Checkout 3.x, the server checks required fields too: `submit()` of every Form API form (`AbstractForm`) refuses to save an empty required field the customer can see. The automatic save on update requests doesn't check them, so it can still store an empty field. Override `requiresOnSubmit(EntityFieldInterface $field)` in your form component to opt a field out.

## Client-Side Validation with the Hyvä Validation Library

Do not rely exclusively on client-side validation!

It is trivial to bypass browser-based form validation for experienced web developers. In-browser validation should
be used only to give visitors fast feedback. Always use server-side validation as the primary way to check user input.

Client-side validation in Hyvä Checkout uses the Hyvä [validation library](../../magewire/magewire-js-form-validation.html) to provide immediate feedback before form submission. You can also use server-side [Magewire-based validation](../../magewire/form-components.html) instead of (or alongside) client-side rules.

To set JavaScript validation rules on a field, use the `setValidationRule()` method. This method accepts a rule name and an optional parameter to configure the validation behavior.

```
// Results in: data-validate='{"maxlength": 10}'
$myField->setValidationRule('maxlength', 10);

// Results in: data-validate='{"required": true, "maxlength": 10}'
$myField->setValidationRule('required');
```

## Adding Custom Client-Side Validation Rules

Custom validation rules let you go beyond the built-in rules and implement specialized field validation. Adding a custom rule takes three steps: set the rule on the field, register a template to load the rule's JavaScript, and declare the rule logic in that template.

### Step 1: Set the Custom Rule on the Field

You can specify validation rules at various points - inside a form modifier, during form construction in the `populate()` method, or anywhere you have access to the field object. Apply the custom rule name using `setValidationRule()`.

This example assigns a custom rule called `example` to a field:

```
$myField->setValidationRule('example');
```

### Step 2: Register a PHTML Template for the Rule

Each custom validation rule should live in its own dedicated PHTML file for maintainability. Register the PHTML file inside a layout container so it renders automatically on the checkout page. Add the block to your `hyva_checkout_index_index.xml` layout file.

This layout XML registers the template containing the custom validation rule:

```
<referenceContainer name="before.body.end">
    <block name="my-js-validation-rule"
           template="My_Example::my-validation-rule.phtml"
    />
</referenceContainer>
```

### Step 3: Declare the Validation Rule Logic in JavaScript

The actual validation logic goes in the PHTML template you registered in Step 2. The rule must be written in JavaScript and registered with the Hyvä [Advanced Form Validation](../../../hyva-themes/writing-code/form-validation/javascript-form-validation.html) library using `hyva.formValidation.addRule()`.

The `addRule()` method accepts two arguments: the rule name (matching what you set in Step 1) and a callback function. The callback receives four parameters:

`value`
:   The current field value being validated.

`options`
:   The validation options passed when the rule was set (e.g., the `10` in `setValidationRule('maxlength', 10)`).

`field`
:   The field object, including `field.element` which is the DOM element.

`context`
:   The form context containing all fields, useful for cross-field validation.

The callback should return `true` if validation passes, or an error message string if it fails.

This example shows a custom validation rule that requires prime numbers for German addresses:

```
<script>
    (() => {
        // Guard: ensure the Hyva form validation library is loaded
        if (hyva && hyva.formValidation) {
            // Helper function to check if a number is prime
            const isPrime = n => {
                // Numbers less than or equal to 1 are not prime
                if (n <= 1) return false;

                // Check for divisibility from 2 up to the square root of n
                for (let i = 2; i < Math.sqrt(n); i++) {
                    if (n % i === 0) return false;
                }

                return true;
            };

            // Register the 'example' rule with hyva.formValidation.addRule()
            // Rule name must match the name passed to setValidationRule() in PHP
            hyva.formValidation.addRule('example', (value, options, field, context) => {
                const el = field.element;

                // Only validate when:
                // - options is truthy (rule is enabled)
                // - the field has a non-empty value
                // - a country_id field exists in the form context
                if (options && el.value.length && context.fields.country_id) {
                    const country = context.fields.country_id.element.value;

                    // Apply the prime number check only for German (DE) addresses
                    if (country === 'DE' && !isPrime(parseInt(el.value))) {
                        // Return a translated error message on failure
                        return '<?= $escaper->escapeJs(__('Please enter a prime number.')) ?>';
                    }
                }

                // Return true when validation passes (no error)
                return true;
            });
        }
    })()
</script>
```

## Related Topics

- **[Form Construction](form-construction.html)** - How to build forms and define fields using the Form API
- **[Form Modification Hooks](form-modification-hooks.html)** - Customize existing forms through lifecycle hooks without modifying the original form class
- **[Advanced Form Validation in Magewire](../../magewire/magewire-js-form-validation.html)** - Using the Hyvä validation library with Magewire components
- **[JavaScript Form Validation](../../../hyva-themes/writing-code/form-validation/javascript-form-validation.html)** - The Hyvä Advanced Form Validation library reference
