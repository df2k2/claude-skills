<!-- source: https://docs.hyva.io/hyva-themes/writing-code/form-validation/javascript-form-validation.html -->

# JavaScript form validation

Hyvä mostly uses [built-in browser](html5-input-types.html) form validation. For many use cases that's enough, but in some cases JavaScript validation is required (for example, to display custom validation messages in a specific location).

The JS form validation library is available since Hyvä 1.1.14

## Getting started

### 1. Enable JS validation

Load the JS form validation on the pages your want to use it using layout XML by applying the layout handle `hyva_form_validation`.

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <update handle="hyva_form_validation"/>
</page>
```

### 2. Initialize the form validation Alpine.js component

If you only need the form validation on frontend logic, use `x-data="hyva.formValidation($el)"` to initialize the component.

```
<form x-data="hyva.formValidation($el)">
```

If additional logic is needed, merge the form validation component with your custom component properties:

```
<form x-data="{...initMyCustomComponent(), ...hyva.formValidation($el)}">
```

Usually you want to trigger the validation of the whole form using the Alpine.js `@submit` event with the `onSubmit` method.

```
<form x-data="hyva.formValidation($el)" @submit="onSubmit">
```

Alpine v2 and v3 compatibility

Since `$el` is only used on the root element with `x-data` of the component, it references the same as `$root` in Alpine.js v3.
If compatibility with Alpine.js v2 is required, then do not use `$el` on anything but a component root node.

Validation of individual fields can be triggered using the `@change` event with the `onChange` method.

```
<div class="field field-reserved">
    <input name="example" data-validate='{"required": true}' @change="onChange">
</div>
```

Form Submit Action

The default submit action is prevented to stop the form from submitting until all fields are correct.
For this purpose the `novalidate` attribute is added to the *FORM* element automatically.

The `field field-reserved` classes on the wrapper element are used to reserve some space below the input element so no layout shift occurs when an error message is displayed.

### 3. Define the validation rules

Validation rules can be added using `data-validate` or using HTML5 browser constraints API.

To add a custom validator, use this syntax:

```
<div class="field field-reserved">
    <input type="number" data-validate='{"min": 2, "required": true}'>
</div>
```

Important

Use regular JSON object notation (not plain JavaScript), because the content of the `data-validate` attribute is parsed with `JSON.parse()`.

You can also use some browser HTML5 constraint attributes (see below for a [list of supported native validation rules](#available-validators)):

```
<div class="field field-reserved">
    <input type="number" min="2" required>
</div>
```

#### Wrapper classes

Input elements should be wrapped by a container element with the CSS classes `field field-reserved`.
It is also possible to use custom class names instead of `class="field field-reserved"` (check out the *Advanced settings* section below).

If there is no container element with those classes, it will be generated automatically at the time an error messages is shown.

## Available validators

| Name | Usage examples | Note |
| --- | --- | --- |
| required | `required` or `data-validate='{"required": true}'` | Uses the browser constraint API validation |
| minlength | `minlength="2"` or `data-validate='{"minlength": 2}'` | Uses the browser constraint API on text input |
| maxlength | `maxlength="3"` or `data-validate='{"maxlength": 3}'` | Uses the browser constraint API on text input |
| pattern (since Hyvä 1.1.21 and 1.2.1) | `pattern="[0-9A-F]*"` or `data-validate='{"pattern": "[A-F]*"}'` | Uses the browser constraint API on text input |
| min | `min="2"` or `data-validate='{"min": 2}'` | Uses the browser constraint API on number inputs |
| max | `max="4"` or `data-validate='{"max": 3}'` | Uses the browser constraint API on number inputs |
| step | `step="1"` or `data-validate='{"step": 1}'` | Uses the browser constraint API on number inputs |
| email | `type="email"` or `data-validate='{"email": true}'` | Uses the Magento email validation regex |
| password | `data-validate='{"password": true}'` | Uses the Magento password validation regex |
| equalTo | `data-validate='{"equalTo": "password"}'` | Compares a field value with other field value |

Custom validators can be added using the method `hyva.formValidation.addRule` ([see below](#adding-new-validation-rules)).

---

## Examples of usage in templates

```
<div class="field field-reserved">
    <input name="first-name" data-validate='{"required": true}'>
</div>

<div class="field field-reserved">
    <input name="last-name" data-validate='{"maxlength": 20}' required>
</div>

<div class="field field-reserved">
    <input name="last-name"
           data-validate='{"maxlength": 20}'
           data-msg-maxlength='<?= /* @noEscape  */  __("Max length of this field is "%0"") ?>'
    >
</div>

<div class="field field-reserved">
    <input name="city" minlength="3" required>
</div>

<!-- Grouping several fields in one container -->
<div class="field field-reserved grid grid-cols-2">
    <div>
        <label for="name"><?= $escaper->escapeHtml(__('Your Name')) ?></label>
        <input id="name" name="name" type="text" required @blur="onChange">
    </div>
    <div>
        <label for="hotel"><?= $escaper->escapeHtml(__('Hotel Name')) ?></label>
        <input id="hotel" name="hotel" type="text"
               data-validate='{ "required": true, "minlength": 5 }'
               data-msg-required="<?= $escaper->escapeHtmlAttr('Enter a valid hotel name.') ?>">
    </div>
</div>
```

The `data-msg-VALIDATOR_NAME` attribute allows overriding the default validator message.
The `%0` placeholder will be replaced with the validation rule argument.

## Checkbox and radio input groups

To use the form validation library with radio and checkbox input groups, the `name` attribute of all fields in a group has to be identical.

Fields are tracked by the name. If any of a group of checkboxes or radios has a validation-related attribute, it will apply to the whole group.

In the following example, only one of the checkboxes has a `required` attribute, but selecting any checkbox of the group will satisfy the `required` validation rule.

```
<div class="field field-reserved">
    <span class="my-2"><?= $escaper->escapeHtml(__('The most powerful fusion of three consists of...')) ?></span>
    <div class="grid grid-cols-2 grid grid-cols-[2em,1fr]">
        <input type="checkbox" name="gems[]" id="steven" value="steven" required>
        <label for="steven"><?= $escaper->escapeHtml(__('Steven')) ?></label>
        <input type="checkbox" name="gems[]" id="garnet" value="garnet">
        <label for="garnet"><?= $escaper->escapeHtml(__('Garnet')) ?></label>
        <input type="checkbox" name="gems[]" id="perl" value="perl">
        <label for="perl"><?= $escaper->escapeHtml(__('Perl')) ?></label>
        <input type="checkbox" name="gems[]" id="amethyst" value="amethyst">
        <label for="amethyst"><?= $escaper->escapeHtml(__('Amethyst')) ?></label>
    </div>
</div>
```

### Combining rules from inputs in a group

Should distinct rules be declared on different inputs in a checkbox or radio group, the form validation library will combine them.
In the following example both the rules `required` and `custom` will be applied to all three radio buttons.

```
<input type="radio" name="example" value="a" data-validate='{"required": true}'>
<input type="radio" name="example" value="b" data-validate='{"custom": 123}'>
<input type="radio" name="example" value="c">
```

### Conflicting rules within a group

If two of the fields have conflicting rules, the latter will be used.
To illustrate, in the following example, the `required` is not active.

```
<input type="checkbox" name="example[]" value="a" data-validate='{"required": true}'>
<input type="checkbox" name="example[]" value="b" data-validate='{"required": false}'>
```

## Validating a single field during user interaction

Use the `onChange` callback with the `input` event to trigger field validation during user interaction.

```
<input @input="onChange" data-validate="...">
```

## Custom submit function

Custom form submission can be accomplished with `hyva.formValidation`:

```
<form x-data="{...hyva.formValidation($el), ...initMyForm()}"
      @submit="myFormSubmit"
>
```

```
function initMyForm() {
    return {
        myFormSubmit(event) {
            event.preventDefault();

            this.validate()
                .then(() => {
                    // all fields validated
                    event.target.submit()
                })
                .catch((invalid) => {
                    if (invalid.length > 0) {
                        invalid[0].focus();
                    }
                });
        }
    }
}
```

## Adding new validation rules

To add new validation rule, use the `hyva.formValidation.addRule` method and pass new validation function.
The first argument is the validator name and the second argument is the validator rule callback.

A validator rule callback is a function that will receive four arguments:

```
/**
 * Validator arguments
 * @param {string} value - input value
 * @param {*} options - additional options passed by data-validator='{"validatorName": {"option": 1}}'
 * @param {Object} field - Alpine.js object which contains element, validators and validation state // TODO MAKE CLEARER
 * @param {Object} context - The Alpine.js component instance
 */
hyva.formValidation.addRule('phone', function(value, options, field, context) {
    const phoneNumber = value.trim().replace(' ', '');
    if (phoneNumber.length !== 9) {
        // return message if validation fails;
        return '<?= $escaper->escapeJs(__("Enter correct phone number, like XXX XXX XXX")) ?>';
    } else {
        // return true if validation passed
        return true;
    }
});
```

Validation rule functions should return one of the following values:

- The boolean `true` if the rule is valid.
- Either a string message if the rule is invalid. The string should describe the failure in a helpful way, or
- An object `{type: 'html', content: 'html content'}` if the rule is invalid and the message content contains raw HTML (for example a link).
- A Promise that resolves to `true`, a message string or html message object when the validation completes.
  See below for more [information on asynchronous validation rules](#asynchronous-validation).

### Adding input type or attribute based validation rules

It is possible to add new input type based validation rules, like for example the default `email` rule, that is automatically applied to input elements with `type="email"`.
Rules can also be applied to fields automatically based on other HTML attributes.

```
// declare the rules
hyva.formValidation.addRule('url', fn ()...)
hyva.formValidation.addRule('validate-file-types', fn ()...)

// apply the rule to all `type="url"` inputs
hyva.formValidation.setInputTypeRuleName('url') // if no rule name is given, the type name is used as the rule name

// apply the rule to all inputs with an `accept="..."` attribute
hyva.formValidation.setInputAttributeRuleName('accept', 'validate-file-types')
```

If no rule name is given (the second argument), the attribute name or input type is used as the rule name.
In the example, the `url` type is mapped to a rule named `url` and the input attribute `accept` is mapped to the rule `validate-file-types`.

## Asynchronous validation

Sometimes validation of form values requires asynchronous actions, such as sending a query to a web API and waiting for the response.

This can be accomplished by returning a promise from the validation function.

The form submission is prevented by the onSubmit function until either all validation rules pass or the one of the fields has an invalid value.
For fields with async validators, error messages will be displayed as soon as all field rules have completed.

### Example async validator rule

```
hyva.formValidation.addRule('username', (value, options, field, context) => {
    return new Promise(resolve => {
        // show the user form validation is ongoing, maybe show a spinner
        field.element.disabled = true;

        fetch(this.url + '?form_key=' + hyva.getFormKey(), {
            method: 'post',
            body: JSON.stringify({username: value}),
            headers: {contentType: 'application/json'}
        })
            .then(response => response.json())
            .then(result => {
                if (result.ok) {
                    resolve(true);
                } else {
                    resolve(hyva.strf('The username "%0" is already taken.', value));
                }
            })
            .finally(() => {
                // indicate validation has finished, remove spinner if shown
                field.element.disabled = false;
            });
    });
});
```

---

## Advanced settings

### Initialization options

To customize the class names used by validator rules, passing an object with options as a second argument to `hyva.formValidation`.

```
<form x-data="hyva.formValidation($el, {fieldWrapperClassName: 'fld', messagesWrapperClassName: 'msg'})"></form>
```

Default values:

```
{
    "fieldWrapperClassName": "field field-reserved",
    "messagesWrapperClassName": "messages",
    "validClassName": "field-success",
    "invalidClassName": "field-error"
}
```

### Validation rules with a dependency on another field

Sometimes field validation is dependent on another field. For example purposes, let's create conditional validation for ZIP codes:

```
<div class="field field-reserved">
    <select name="country" required>
        <option selected hidden value="">Choose country</option>
        <option value="ch">Switzerland</option>
        <option value="fr">France</option>
        <option value="de">Germany</option>
        <option value="nl">The Netherlands</option>
    </select>
</div>
<div class="field field-reserved">
    <input type="text" name="zip" placeholder="Enter ZIP code" data-validate='{"zip": {}}'>
</div>
```

```
hyva.formValidation.addRule('zip', function(value, options, field, context) {
    const rules = {
        ch: ['^(CH-)?\\d{4}$', '<?= /* @noEscape */ __("Switzerland ZIPs must have exactly 4 digits: e.g. CH-1950 or 1950") ?>'],
        fr: ['^(F-)?\\d{5}$', '<?= /* @noEscape */ __("France ZIPs must have exactly 5 digits: e.g. F-75012 or 75012") ?>'],
        de: ['^(D-)?\\d{5}$', '<?= /* @noEscape */ __("Germany ZIPs must have exactly 5 digits: e.g. D-12345 or 12345") ?>'],
        nl: [
            '^(NL-)?\\d{4}\\s*([A-RT-Z][A-Z]|S[BCE-RT-Z])$',
            '<?= /* @noEscape */ __("Netherland ZIPs must have exactly 4 digits, followed by 2 letters except SA, SD and SS") ?>'
        ]
    };
    context.validateField(context.fields['country']);

    if (context.fields['country'].state.valid) {
        const country = context.fields['country'].element.value;
        const rule = new RegExp(rules[country][0], '');
        if (!rule.test(value)) {
            return rules[country][1];
        } else {
            return true;
        }
    } else {
        return '<?= $escaper->escapeJs(__("Select country first")) ?>'
    }
})
```

### Custom non-error messages

Sometimes it is necessary to display additional messages besides validation failures.
This can be accomplished using the `context.addMessage(field, messagesClass, messages)` method.

The `addMessage` method can take a single message string or an array of messages.

The following example shows the number of characters remaining.
If more characters are added, the validation fails.

```
<script>
hyva.formValidation.addRule('remaining', (value, options, field, context) => {
    // Remove old message if present
    context.removeMessages(field, 'remaining-msg')

    const remaining = parseInt(options) - value.length;
    if (remaining < 0) {
        // Fail validation
        return hyva.strf('%0 character(s) too many', Math.abs(remaining));
    }
    if (remaining > 0) {
        // Add message without failing validation
        const message = hyva.strf('<?= $escaper->escapeJs(__('%0 remaining')) ?>', remaining);
        context.addMessages(field, 'remaining-msg', message);
    }
    return true;
})
</script>
<form x-data="hyva.formValidation($el)">
<div class="field field-reserved">
    <label for="example">Example</label>
    <textarea id="example" name="example" data-validate='{"remaining": 10}' @input="onChange"></textarea>
</div>
</form>
```

#### Custom non-error messages with HTML

By calling `context.addHtmlMessages(field, messagesClass, htmlMessages)` it is possible to render messages containing HTML.
