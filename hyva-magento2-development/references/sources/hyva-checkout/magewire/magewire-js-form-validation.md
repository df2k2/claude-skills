<!-- source: https://docs.hyva.io/hyva-checkout/magewire/magewire-js-form-validation.html -->

# Advanced Form Validation in Magewire

Hyvä Checkout includes a JavaScript [form validation library](../../hyva-themes/writing-code/form-validation/javascript-form-validation.html) that works with Magewire form components. Validation failure messages are automatically displayed next to input elements in an accessible manner.

A `magewire` validation rule is automatically added in Hyvä Checkout, so you can wire up server-side validation with the client-side form validation library.

## Initializing Form Validation on the Form Element

The Hyvä form validation needs to be initialized on the `<form>` element as described in the [form validation documentation](../../hyva-themes/writing-code/form-validation/javascript-form-validation.html#2-initialize-the-form-validation-alpinejs-component).

You also need to add a `novalidate` attribute directly in the template.

The following snippet shows how to set up the form element for Magewire form validation:

```
<form x-data="hyva.formValidation($el)" novalidate>
```

Why is the `novalidate` attribute needed?

The Hyvä form validation library adds the `novalidate` attribute automatically when the Alpine component initializes. However, when Magewire re-renders the form element during subsequent requests, Magewire removes the `novalidate` attribute if it is not also present in the template.

Without `novalidate` in the template, the form validation works correctly on the first submission, but after Magewire re-renders the form, the browser applies native HTML5 validation instead of delegating to the JavaScript validation library.

## Adding the Magewire Validation Rule to Input Elements

To connect an input element to Magewire server-side validation, you need three data attributes: `data-validate`, `data-magewire-is-valid`, and (when invalid) `data-msg-magewire`.

### Setting the `data-validate` attribute

Add `"magewire": true` to the validation rules JSON in the `data-validate` attribute on the input element:

```
data-validate='{"magewire": true}'
```

### Setting the `data-magewire-is-valid` attribute

The `data-magewire-is-valid` attribute tells the validation library whether the Magewire component considers the field valid or invalid:

```
data-magewire-is-valid="<?= (int) !$magewire->hasError('myInput') ?>"
```

Valid state must be an integer: 1 or 0

The `data-magewire-is-valid` attribute must be set to `1` (valid) or `0` (invalid) as an integer. Using boolean `true`/`false` or other truthy/falsy values **will not work**.

### Setting the `data-msg-magewire` validation message attribute

When the Magewire component reports a field as invalid, specify the error message using the `data-msg-magewire` attribute:

```
<?php if ($magewire->hasError('myInput')): ?>
   data-msg-magewire="<?= $escaper->escapeHtmlAttr($magewire->getError('myInput')) ?>"
<?php endif; ?>
```

### Complete Magewire-validated input element example

The following example shows a complete input element with all three Magewire validation data attributes together:

```
<!-- Complete input with Magewire validation attributes -->
<input id="my-input"
       type="text"
       name="my-input"
       wire:model.defer="myInput"
       data-validate='{"magewire": true}'
       data-magewire-is-valid="<?= (int) !$magewire->hasError('myInput') ?>"
   <?php if ($magewire->hasError('myInput')): ?>
       data-msg-magewire="<?= $escaper->escapeHtmlAttr($magewire->getError('myInput')) ?>"
   <?php endif; ?>
>
```

## Triggering Magewire Form Validation

Magewire form validation is automatically triggered after Magewire updates an element during subsequent requests.

To trigger validation on the frontend without a Magewire server roundtrip, call the Alpine `validate()` method to validate all fields, or use `@change="onChange"` on individual form elements.

## Submitting a Magewire Form with JavaScript Validation

Using `wire:submit.prevent="submitForm"` on a form conflicts with the Hyvä JavaScript form validation. To work around the conflict, call `validate()` first and then invoke the Magewire form component method only if validation passes.

The following button triggers validation and submits the Magewire form on success:

```
<!-- Validate first, then call the Magewire submitForm method -->
<button type="button" class="btn btn-primary"
        @click="validate().then(() => $wire.submitForm()).catch(() => {})">
    <?= $escaper->escapeHtml(__('Save')) ?>
</button>
```

Why does `wire:submit.prevent` conflict with form validation?

The Magewire `wire:submit.prevent=""` action adds a `readonly` attribute to all form elements before the subsequent request is made. This happens before the Alpine form validation is processed. Because the `readonly` attribute prevents form elements from being validated, the form gets submitted without any frontend validation.

By using a button with `@click` and calling `validate()` manually, you keep full control over the validation flow before Magewire sends the request.
