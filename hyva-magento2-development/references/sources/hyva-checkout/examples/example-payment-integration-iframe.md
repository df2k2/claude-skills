<!-- source: https://docs.hyva.io/hyva-checkout/examples/example-payment-integration-iframe.html -->

# Example PSP Integration: Iframe Payment Form

Many Payment Service Provider (PSP) SDKs render an iframe to display their payment form inside Hyvä Checkout. On the Magento integration side, iframe-based PSP integration typically requires calling a method on the SDK and passing a CSS selector for the target element where the SDK renders the iframe containing the payment form fields.

This page walks through an imaginary but realistic example of a Magewire payment method template that loads a PSP SDK, initializes an iframe payment form, and passes the resulting payment token back to the Magewire component.

## How the Integration Works

The full lifecycle of an iframe-based PSP payment integration in Hyvä Checkout follows these steps:

1. The PSP SDK script is loaded as part of the initial page render via layout XML.
2. When the customer selects the payment method, a container `div` for the iframe is rendered.
3. An Alpine component initializes the SDK and mounts the iframe into the container.
4. When the customer completes the payment form, the SDK callback passes the payment token to the Magewire component via `Magewire.find().setPaymentToken()`.

## Loading the PSP SDK via Layout XML

Hyvä Checkout enforces strict CSP on all checkout pages. This means scripts injected at runtime (for example, via `document.createElement('script')`) will be blocked because dynamically injected scripts cannot receive a nonce. The PSP SDK script must be loaded as part of the initial page render instead.

Add a dedicated block for the SDK script to the `hyva.checkout.api-v1.after` container in the `hyva_checkout_index_index` layout handle. This container renders with the initial checkout page on both release lines. (The Magewire 1 `magewire.plugin.scripts` container of older examples only renders on Checkout 3.x while the [v1bc module](../magewire/v1bc.html) is enabled.)

view/frontend/layout/hyva\_checkout\_index\_index.xml

```
<body>
    <referenceContainer name="hyva.checkout.api-v1.after">
        <!-- Load the PSP SDK with the checkout page as part of the initial render -->
        <block name="checkout.payment.psp.sdk-loader"
               template="Example_Psp::checkout/payment/psp-sdk-loader.phtml"
        />
    </referenceContainer>
</body>
```

The SDK loader template registers the external SDK script source and registers the Alpine initialization component used by the payment method template. The `$hyvaCsp->registerInlineScript()` call authorizes the inline script with a nonce so strict CSP allows it to execute.

Example\_Psp::checkout/payment/psp-sdk-loader.phtml

```
<?php
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
?>
<script src="<?= $block->getViewFileUrl('Example_Psp::js/sdk.js') ?>"></script>
<script>
    // Register the Alpine component that initializes the PSP iframe.
    // Using Alpine.data() is required for strict CSP compatibility on checkout pages.
    function initExamplePspPayment() {
        return {
            init() {
                // Mount the PSP iframe into the container element when the component initializes.
                // The component name in layout is used to find the Magewire instance.
                const componentName = this.$el.dataset.componentName;

                window.ExamplePaymentSdk.configure({
                    merchantKey: this.$el.dataset.merchantKey,
                    callback: ({ token }) => {
                        // Pass the payment token to the Magewire component when the form is complete.
                        Magewire.find(componentName).setPaymentToken(token);
                    }
                }).then(paymentMethod => {
                    paymentMethod.mount('#examplePspFormContainer');
                });
            }
        }
    }

    window.addEventListener('alpine:init', () => {
        Alpine.data('initExamplePspPayment', initExamplePspPayment);
    }, { once: true });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Why load the SDK in a separate block?

Hyvä Checkout uses Magewire to dynamically update component templates. Scripts inside a Magewire component template are only evaluated during the initial page render - subsequent Magewire updates will not re-evaluate them. Loading the SDK and the Alpine component registration in a separate layout block ensures both are available regardless of when the payment method template renders. See [Move Scripts to Page Load](../devdocs/csp/csp-move-scripts-page-load.html) for more on this pattern.

## Magewire Payment Method Template

The Magewire payment method template renders when the customer selects the payment method. It provides the iframe container and initializes the Alpine component using the data attributes to pass configuration to the SDK loader script.

Example\_Psp::checkout/payment/method/example-psp.phtml

```
<?php
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Example\Psp\Magewire\Payment\Method\ExamplePsp $magewire */
?>
<div
    x-data="initExamplePspPayment"
    data-merchant-key="<?= $escaper->escapeHtmlAttr($magewire->getMerchantKey()) ?>"
    data-component-name="<?= $escaper->escapeHtmlAttr($block->getNameInLayout()) ?>"
>
    <!-- wire:ignore prevents Magewire from overwriting SDK-rendered content on re-render -->
    <div id="examplePspFormContainer" wire:ignore>
        <!-- The PSP iframe renders here -->
    </div>
</div>
```

## Protecting SDK-Rendered DOM with `wire:ignore`

The `wire:ignore` attribute on the iframe container `div` is critical for iframe-based PSP integrations in Hyvä Checkout. Without `wire:ignore`, any content the PSP SDK renders inside the container - including the iframe itself - will disappear after the first Magewire round-trip.

When a subsequent Magewire request re-renders the payment method component template, the server returns an empty container element. The `wire:ignore` attribute tells Magewire to skip updating that element, preserving the iframe and all its contents.

## Related Topics

- **[Move Scripts to Page Load](../devdocs/csp/csp-move-scripts-page-load.html)** - How to extract inline scripts from Magewire component templates for CSP compliance
- **[CSP Script Authorization](../devdocs/csp/csp-script-validation.html)** - How nonce-based script authorization works in Hyvä Checkout
- **[Payment Integration API](../devdocs/payments/payment-integration-api.html)** - How to register payment methods in layout XML and implement `EvaluationInterface`
- **[JS-driven Payment Method](js-payment-method.html)** - Building JavaScript-driven payment integrations using the Frontend Payment API
