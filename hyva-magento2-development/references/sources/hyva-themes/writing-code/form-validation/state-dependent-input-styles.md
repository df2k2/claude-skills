<!-- source: https://docs.hyva.io/hyva-themes/writing-code/form-validation/state-dependent-input-styles.html -->

# Styling inputs depending on state

There are a number of CSS pseudo-classes that are also exposed as Tailwind CSS variants to allow styling input fields depending on their state:

JIT Only

These variants are supported only by the Tailwind **JIT** compiler.
They will not work in a bundle produced by `npm run build-dev`.

- `invalid:`
- `valid:`
- `in-range:`
- `out-of-range:`
- `required:`
- `placeholder-shown:`
- `indeterminate:`

## Example

```
<select id="amount"
        name="amount"
        class="form-select invalid:ring-2 invalid:ring-red-500"
        form="my_form"
        required
>
    <option value="">
        <?= $escaper->escapeHtml(__('Choose an Amount...')) ?>
    </option>
</select>
```

If you do not want the invalid styles to be applied while the element is empty, [JavaScript](triggering-native-validation-messages-with-javascript.html) needs to be involved.
