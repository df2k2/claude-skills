<!-- source: https://docs.hyva.io/hyva-checkout/examples/example-payment-integration-iframe.html -->

# Example PSP Integration: Iframe Payment Form

## Overview

Many Payment Service Provider (PSP) SDKs render an iframe to display their payment form inside Hyva Checkout.
On the Magento integration side, iframe-based PSP integration typically requires calling a method on the SDK, passing a CSS selector for the target element where the SDK will render the iframe containing the form fields.

This page walks through an imaginary but realistic example of a Magewire payment method template that loads a PSP SDK, initializes an iframe payment form, and passes the resulting payment token back to the Magewire component.

## Magewire Payment Method Template with PSP Iframe

The example template below demonstrates the full lifecycle of an iframe-based PSP payment integration in Hyva Checkout:

1. When the visitor selects the payment method, the template renders a container `div` for the iframe.
2. The PSP SDK library is loaded dynamically via a `script` tag.
3. After the SDK loads, `initPspForm()` configures the SDK with merchant credentials and mounts the iframe.
4. When the visitor completes the payment form, the SDK triggers a callback that passes the payment token to the Magewire component via `Magewire.find().setPaymentToken()`.

Magewire payment component template

```
<div>
    <!-- Magewire payment component template -->
    <!-- Rendered when the visitor selects this payment method -->

    <!-- wire:ignore prevents Magewire from overwriting SDK-rendered content -->
    <div id="#examplePspFormContainer" wire:ignore>
        <!-- The PSP iframe will be rendered here by the SDK -->
    </div>

    <script>
        // This script is only evaluated once, the first time it is rendered.
        (() => {

          // Initialize the PSP SDK and mount the iframe into the container
          async function initPspForm(SDK) {
            // Configure the SDK with merchant credentials and a payment callback
            const paymentMethod = await SDK.configure({
              merchantKey: '<?= $escaper->escapeJs($magewire->getMerchantKey()) ?>',
              callback: ({token}) => {
                // When the visitor completes the PSP form, pass the token to Magewire
                const component = '<?= $escaper->escapeJs($block->getNameInLayout()) ?>';
                Magewire.find(component).setPaymentToken(token);
              }
            });

            // Mount the iframe into the target container element
            const target = '#examplePspFormContainer';
            document.querySelector(target) && paymentMethod.mount(target);
          }

          // Load the SDK library file dynamically when needed
          if (! window.ExamplePaymentSdk) {
            // Inject the SDK script tag and initialize on load
            const script = document.createElement('script');
            script.src = '<?= $block->getViewFileUrl('Example_Psp::js/sdk.js') ?>';
            script.onload(() => initPspForm(ExamplePaymentSdk));
            document.head.append(script);
          } else {
            // SDK already loaded (e.g. visitor re-selected this method), initialize immediately
            initPspForm(ExamplePaymentSdk);
          }

        })()
    </script>
</div>
```

Adapt to your PSP

The code above is intended as a structural example only. You will need to adjust method names, configuration options, and callback signatures to match the API of your specific Payment Service Provider.

## Protecting SDK-Rendered DOM with `wire:ignore`

The `wire:ignore` attribute on the iframe container `div` is critical for iframe-based PSP integrations in Hyva Checkout. Without `wire:ignore`, any content the PSP SDK renders inside the container (including the iframe) will disappear after the first Magewire round-trip.

The following snippet shows how `wire:ignore` is applied to the container element:

Container with wire:ignore attribute

```
<div id="#examplePspFormContainer" wire:ignore>
    <!-- The PSP iframe will be rendered here by the SDK -->
</div>
```

When a subsequent Magewire request re-renders the payment method component template, the server returns an empty `<div id="#examplePspFormContainer" wire:ignore>` without the SDK-generated content. The `wire:ignore` attribute tells Magewire to skip updating that element, preserving the iframe and all its contents on the page.

Script tags are only evaluated during the initial preceding request

When `<script>` tags are rendered by Magewire component templates, the browser only evaluates them during the **initial preceding request**. If the same script appears in subsequent Magewire responses, the browser ignores it. This means changes to the JavaScript code will not take effect on re-render, but any **state** created during the initial preceding request (such as SDK instances and event listeners) **will persist**.
