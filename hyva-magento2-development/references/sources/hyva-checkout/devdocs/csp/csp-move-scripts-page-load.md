<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/csp/csp-move-scripts-page-load.html -->

# Move Scripts to the Initially Loaded Page Content

Hyvä Checkout uses Magewire to dynamically load and update components, but strict Content Security Policy (CSP) prevents script evaluation after initial page load. All `<script>` tags must exist in the page source when first rendered to receive proper nonce authorization. Inline scripts within Magewire component templates must be extracted into separate files and loaded during the initial page render, not during dynamic component updates.

Multistep checkout behavior

For multistep checkouts, even though only one step displays at a time, all scripts used across any step must load with the initial page. Dynamic step transitions update only DOM structure, not the authorized script set.

## Understanding the CSP Script Constraint

Content Security Policy requires all inline scripts to be present in the initial page source for nonce authorization. When Magewire dynamically loads a component, any scripts within that component arrive too late in the page lifecycle to receive proper nonce protection. This means inline scripts must be separated from component templates and included during the initial checkout page load, even if the component itself loads dynamically later.

The separation follows three distinct steps: extract the inline script into a separate template file, include that template in the initial page load using layout XML, and update the component template to use Alpine.js initialization instead of inline script code.

## Example: Refactoring the Payment Method List Component

This example demonstrates extracting an inline script from a Magewire component template. The payment method list component originally included inline script for activating the selected payment method. This script must be extracted and loaded with the initial page to work under strict CSP.

### Step 1: Extract the Script into a Separate File

The original inline script is copied into a new file `method-list-activate.phtml` and refactored to work as an Alpine.js constructor function. The script registers itself with `Alpine.data()` and receives data through HTML dataset attributes instead of PHP template variables.

The key changes in this step are:

- Wrap the script logic in a function that registers with `Alpine.data()`
- Use `this.$el.dataset` to access data passed from the HTML element
- Register the inline script with `$hyvaCsp->registerInlineScript()` for nonce authorization

`Hyva_Checkout::checkout/payment/method-list-activate.phtml`

```
/** @var Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
?>
<script>
    "use strict";

    function hyvaCheckoutPaymentMethodListActivate() {
        const method = this.$el.dataset.method;

        window.addEventListener('checkout:step:loaded', () => {
            if (method && document.getElementById('payment-method-list')) {
                window.dispatchEvent(
                    new CustomEvent(
                        'checkout:payment:method-activate',
                        {detail: {method: method}}
                    )
                )
            }
        }, { once: true })

        return {}
    }
    window.addEventListener(
        'alpine:init',
        () => Alpine.data('hyvaCheckoutPaymentMethodListActivate', hyvaCheckoutPaymentMethodListActivate),
        {once: true}
    )
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

### Step 2: Include the Script in the Initial Checkout Page Load

The extracted script must be available in all steps of the checkout, so it has to load with the checkout page itself. Declare the block in the `hyva_checkout_index_index` layout handle and add it to the `hyva.checkout.api-v1.after` container. Hyvä Checkout registers its own Alpine components in this container, which renders once with the checkout page on both release lines.

The following layout XML adds the extracted script block to the container:

view/frontend/layout/hyva\_checkout\_index\_index.xml

```
<!-- ... -->
<body>
    <!-- ... -->
    <!-- this container loads with the checkout page, after the Frontend API -->
    <referenceContainer name="hyva.checkout.api-v1.after">
        <!-- add the script -->
        <block name="hyva-checkout.checkout.payment.method-list-activate"
               template="Hyva_Checkout::checkout/payment/method-list-activate.phtml"
        />
    </referenceContainer>
    <!-- ... -->
</body>
```

Scripts in the `magewire.plugin.scripts` container

Older examples add such scripts to the Magewire 1 `magewire.plugin.scripts` container in the `hyva_checkout` layout handle. On Checkout 3.x, that container only renders on checkout pages while the [v1bc module](../../magewire/v1bc.html) is enabled, so use `hyva.checkout.api-v1.after` for new code.

### Step 3: Use Alpine to Trigger the Code

The final step is activating the Alpine component on the payment method list element. The original inline script is removed, and the element is initialized with the Alpine component using `x-data`. Data is passed to the script using HTML data attributes.

Note the changes to the escaper method: `escapeJs()` becomes `escapeHtmlAttr()` because the method code is now passed through an HTML attribute instead of inline JavaScript.

`Hyva_Checkout::checkout/payment/method-list.phtml`

```
?>
<div id="payment-methods">
    <?php if ($methods): ?>
        <?php /** script moved to Hyva_Checkout::checkout/payment/method-list-activate.phtml */ ?>
        <ol id="payment-method-list"
            x-data="hyvaCheckoutPaymentMethodListActivate"
            data-method="<?= $escaper->escapeHtmlAttr($magewire->method) ?>"
            class="space-y-4">
<?php
```

### Original Combined Component and Script

For comparison, this excerpt shows the original component template before refactoring. The inline script was directly embedded in the component template, which works without CSP but violates strict CSP policies.

`Hyva_Checkout::checkout/payment/method-list.phtml` (before refactoring)

```
?>
<div id="payment-methods">
    <?php if ($methods): ?>
        <script>
            window.addEventListener('checkout:step:loaded', () => {
                if ('<?= $escaper->escapeJs($magewire->method) ?>' && document.getElementById('payment-method-list')) {
                    window.dispatchEvent(new CustomEvent('checkout:payment:method-activate', { detail: { method: '<?= $escaper->escapeJs($magewire->method) ?>'} }))
                }
            }, { once: true })
        </script>

        <ol id="payment-method-list" class="space-y-4">
<?php
```
