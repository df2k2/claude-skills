<!-- source: https://docs.hyva.io/hyva-themes/writing-code/form-validation/triggering-native-validation-messages-with-javascript.html -->

# Triggering native validation messages with JavaScript

If input constraints are declared on a field, it might display as invalid immediately.
This is not a good user experience. Usually an invalid state message is only displayed when a form is submitted or after
a user interacts with a form input.

One way to implement this is by adding the constraint attributes with JavaScript at the appropriate time.

## Applying constraints on submit

The example below checks validity when the form is submitted. Note one of the fields is not always rendered.

```
<script>
    function initMyForm() {
        return {
            validate(event) {
                // add required attribute
                this.$refs.amount.required = true;
                this.$refs.currency && (this.$refs.currency.required = true);

                // show native browser error message if any constraints are violated
                this.$refs.amount.form.reportValidity();

                // prevent submitting the form if any field is invalid
                if (!this.$refs.amount.form.checkValidity()) {
                    event.preventDefault();
                }
            }
        }
    }
</script>
<form x-data="initMyForm()" action="" method="post"
      @submit="validate($event)"
>
    <input type="number"
           name="amount"
           x-ref="amount"
           class="form-input p-2 invalid:ring-2 invalid:ring-red-500"
    >
    <?php if ($block->isCurrencyChooserEnabled()): ?>
    <select name="currency"
            x-ref="currency"
            class="form-select mb-4 invalid:ring-2 invalid:ring-red-500"
    >
        <?= $escaper->escapeHtml(__('Choose an Amount...')) ?>
        <?php /** @noEscape */ $block->getCurrencyChooserOptionsHtml(); ?>
        <?php endif; ?>
    </select>
</form>
```

## Applying constraints on user interaction

Note that in this example an empty value would still be considered as valid since the `required` attribute will not be
present in that case.

```
<input name="amount"
       x-ref="amount"
       :required="$refs.amount.value.length > 0"
       class="form-input p-2 invalid:ring-2 invalid:ring-red-500"
>
```

Alternatively event subscribers for `@input` or `@focus` can be used to toggle constraint attributes.

```
<input name="amount"
       @input="$event.target.min='3'"
       class="form-input p-2 invalid:ring-2 invalid:ring-red-500"
>
```

## Custom error messages

In case the native browser messages and constraints are not sufficient, an input field can be marked as invalid by
calling `setCustomValidity(msg)` on it. To mark a field as valid again, call `setCustomValidity('')` with an empty
string.

```
<script>
    function initMyForm() {
        return {
            validateField() {
                // some code calculating the value of m ...
                return m > 0
                    ? `You have to wait ${m} minutes before you can continue.`
                    : '';
            }
        }
    }

</script>
<input name="amount"
       @input="$event.target.setCustomValidity(validateField())"
       class="form-input p-2 invalid:ring-2 invalid:ring-red-500"
>
```
