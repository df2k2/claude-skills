<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/place-order-service-api/index.html -->

# Place Order Service API for Hyvä Checkout

The Place Order Service (POS) API controls how orders are placed in Hyvä Checkout. In Luma checkout, each payment method handles order placement on its own, but Hyvä Checkout centralizes that responsibility. This gives you the flexibility to position payment methods anywhere in the checkout flow while keeping order placement behavior consistent.

## What Is a Place Order Service in Hyvä Checkout?

A Place Order Service is a PHP class that controls the order placement workflow for a specific payment method in Hyvä Checkout. Each payment method can have its own custom Place Order Service, or it can fall back to the default implementation at `\Hyva\Checkout\Model\Magewire\Payment\DefaultPlaceOrderService`.

The Place Order Service handles:

- **Order creation** - Converting the quote to an order
- **Redirect control** - Determining where customers go after order placement
- **Post-order actions** - Running frontend JavaScript through the Evaluation API (for example, 3DS authentication modals)
- **Exception handling** - Managing errors during the order placement process

## When to Create a Custom Place Order Service

The default Place Order Service works fine for simple payment methods that don't need post-payment actions. Create a custom Place Order Service when you need to:

- **Prevent automatic redirect** after order placement to show additional UI (for example, 3DS authentication)
- **Execute frontend JavaScript** after the order is created using Evaluation results
- **Control the redirect destination** based on payment-specific logic
- **Handle payment-method-specific exceptions** with custom error messages

Evaluation API Integration

Since version `1.1.13`, the Place Order Service integrates with the [Evaluation API](../evaluation-api/index.html), allowing backend PHP code to trigger frontend JavaScript actions before or after order placement.

## How the Place Order Flow Works in Hyvä Checkout

The order placement flow in Hyvä Checkout follows these steps:

1. **Customer clicks "Place Order"** - The `\Hyva\Checkout\Magewire\Main` component receives the request.
2. **POS Processor retrieves the service** - The processor queries `PlaceOrderServiceProvider` for a Place Order Service matching the quote's payment method.
3. **Fallback to default if needed** - If no custom Place Order Service exists, `DefaultPlaceOrderService` handles the order.
4. **Order is placed** - The Place Order Service creates the order and assigns the order ID.
5. **Evaluation results execute** - Any post-order Evaluation results (redirects, validations, modals) run on the frontend.
6. **Customer is redirected** - Based on the `canRedirect()` and `getRedirectUrl()` return values.

Let Hyvä Checkout Handle Order Placement

Do not convert quotes to orders inside payment method components or PSP callbacks. Hyvä Checkout's flexible step ordering means payment methods may not be on the final step. If a quote converts to an order mid-checkout, subsequent steps can't access required quote data.

Always use the Place Order Service for order creation.

## Creating a Custom Place Order Service

### Example: 3DS Authentication After Order Placement

This example walks through a payment method that requires 3DS authentication after order placement. Here's the workflow:

1. The order is placed successfully.
2. A modal displays for 3DS authentication.
3. The customer completes authentication.
4. The customer is redirected to the success page.

What is 3DS Authentication?

3D Secure (3DS) is a security protocol for online card payments. After submitting payment details, the cardholder's bank verifies their identity through a password, SMS code, or biometric check. Successful authentication allows the transaction to proceed; failure declines it. 3DS reduces fraud and often shifts liability from merchants to issuing banks.

### Step 1: Create the Custom Place Order Service Class

Extend `AbstractPlaceOrderService` to implement only the methods you need to customize. The abstract class provides default implementations for all other methods.

Custom Place Order Service for 3DS Payment Method

```
<?php
// File: My/Example/Model/Payment/PlaceOrderService/FooPlaceOrderService.php

namespace My\Example\Model\Payment\PlaceOrderService;

use Hyva\Checkout\Model\Magewire\Payment\AbstractPlaceOrderService;
use Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResultInterface;
use Hyva\Checkout\Model\Magewire\Component\EvaluationResultFactory;

class FooPlaceOrderService extends AbstractPlaceOrderService
{
    /**
     * Prevent automatic redirect after order placement.
     * The 3DS modal must display before redirecting.
     */
    public function canRedirect(): bool
    {
        return false;
    }

    /**
     * Define post-order evaluation results.
     * Called after the order is successfully placed.
     *
     * @param EvaluationResultFactory $resultFactory Factory for creating evaluation results
     * @param int|null $orderId The placed order ID, or null if order placement failed
     */
    public function evaluateCompletion(
        EvaluationResultFactory $resultFactory,
        ?int $orderId = null
    ): EvaluationResultInterface {
        // Always prepare the redirect to success page
        $redirect = $resultFactory->createRedirect('checkout/onepage/success');

        // If no order was created, just redirect (handles edge cases)
        if ($orderId === null) {
            return $redirect;
        }

        // Create a validation that triggers the 3DS modal on the frontend
        // The validator name 'foo-authentication' must match the registered frontend validator
        $validate = $resultFactory->createValidation('foo-authentication');
        // If authentication fails, still redirect to success (order is already placed)
        $validate->withFailureResult($redirect);

        // Create a navigation task that executes the redirect after validation completes
        $navigationTask = $resultFactory->createNavigationTask('foo-redirect', $redirect);
        // executeAfter() required before version 1.1.18
        $navigationTask->executeAfter(true);

        // Return a batch that executes validation first, then redirect
        return $resultFactory->createBatch()
            ->push($validate)
            ->push($navigationTask);
    }
}
```

### Step 2: Register the Place Order Service in DI Configuration

Map the custom Place Order Service to the payment method code in `di.xml`. The item name must match the payment method code exactly.

DI Configuration for Place Order Service

```
<!-- File: etc/frontend/di.xml -->

<type name="Hyva\Checkout\Model\Magewire\Payment\PlaceOrderServiceProvider">
    <arguments>
        <argument name="placeOrderServiceList" xsi:type="array">
            <!-- Item name must match the payment method code -->
            <item name="foo" xsi:type="object">
                My\Example\Model\Payment\PlaceOrderService\FooPlaceOrderService
            </item>
        </argument>
    </arguments>
</type>
```

### Step 3: Create the 3DS Authentication Modal Template

The modal must be placed outside the Main component because payment methods may not be visible when the customer clicks "Place Order". Use the `hyva.checkout.init-validation.after` container to ensure proper DOM placement.

Layout XML for Authentication Modal

```
<!-- File: view/frontend/layout/hyva_checkout_index_index.xml -->

<referenceContainer name="hyva.checkout.init-validation.after">
    <block name="modals.three-ds.authentication"
           template="My_Example::modals/three-ds/authentication.phtml"
    />
</referenceContainer>
```

Modal Placement Outside the Main Component

Do not place modal HTML inside the payment method template. Payment methods may be on a different step than the "Place Order" button. Always place modals in a container outside the Main component.

The modal template uses a [Hyvä modal](../../../hyva-themes/view-utilities/modal-dialogs/index.html) component. The example below is CSP-compliant, using method references instead of inline expressions.

3DS Authentication Modal Template (CSP Compliant)

```
<!-- File: view/frontend/templates/modals/three-ds/authentication.phtml -->

<div>
    <div x-data="initFooAuthentication">
        <div x-cloak
             x-bind="overlay"
             class="fixed inset-0 flex items-center justify-center text-left bg-black bg-opacity-50">
            <div x-ref="dialog"
                 role="dialog"
                 aria-labelledby="foo_three-ds_authentication_dialog-label"
                 class="inline-block max-w-2xl mx-4 max-h-screen overflow-auto bg-white shadow-xl rounded-lg p-6 text-gray-700">

                <div class="w-full font-medium text-gray-700 not-required">
                    <label for="authentication_code">Authentication Code</label>
                    <div class="flex items-center gap-4">
                        <!-- x-model is NOT CSP compliant; use x-bind:value + x-on:input instead -->
                        <input type="text"
                               x-bind:value="code"
                               x-on:input="updateCode"
                               id="authentication_code"
                               class="form-input"/>
                    </div>
                </div>

                <div class="flex gap-y-2 md:gap-x-2 mt-6 w-full">
                    <!-- x-on:click with method reference is CSP-safe -->
                    <button type="button" class="btn btn-primary" x-on:click="ok">
                        Confirm Payment
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
```

### Step 4: Register the Frontend Validator for 3DS Authentication

The frontend validator connects the backend evaluation result to the modal UI. The validator name must match the `createValidation()` name from the Place Order Service. The Alpine component must be CSP-compliant.

Frontend Validator and Alpine Component (CSP Compliant)

```
<!-- Add to the same template file or a separate phtml -->

<?php
/** @var \Hyva\Theme\Model\HyvaCsp $hyvaCsp */
?>

<script>
    /**
     * Alpine CSP-compatible component for 3DS authentication modal.
     * Uses method references instead of inline expressions.
     */
    function initFooAuthentication() {
        return Object.assign(
            { code: null },
            hyva.modal(),
            {
                /**
                 * CSP-safe replacement for x-model.
                 * Called via x-on:input="updateCode" on the input element.
                 */
                updateCode(event) {
                    this.code = event.target.value;
                },

                /**
                 * Initialize event listeners for modal display.
                 * Called via x-init="initialize()" (CSP-safe method reference).
                 */
                init() {
                    window.addEventListener('foo:authenticate:show', event => {
                        this.show().then(result => {
                            this.$dispatch('foo:authenticate:confirm', {
                                result: result && this.code === '1234'
                            });
                        });
                    });
                }
            }
        );
    }
    window.addEventListener(
        'alpine:init',
        () => Alpine.data('initFooAuthentication', initFooAuthentication),
        {once: true}
    )

    // Wait for the Evaluation sub-namespace to initialize
    window.addEventListener('checkout:init:evaluation', () => {
        // Register validator matching the backend createValidation('foo-authentication') name
        hyvaCheckout.evaluation.registerValidator('foo-authentication', element => {
            return new Promise((resolve, reject) => {
                // Dispatch event to show the authentication modal
                window.dispatchEvent(new Event('foo:authenticate:show'));

                // Wait for the modal to dispatch confirmation result
                window.addEventListener('foo:authenticate:confirm', event => {
                    event.detail.result ? resolve() : reject();
                });
            });
        });
    });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

The complete flow ties together like this: the order is placed, then `evaluateCompletion()` returns a validation + redirect batch. The frontend executes the validation, the modal shows, the customer authenticates, the validator resolves, and finally the navigation task executes the redirect.

## Related Topics

- **[Evaluation API](../evaluation-api/index.html)** - Learn how to trigger frontend JavaScript actions from backend PHP code during order placement
- **[Hyvä Modal Dialogs](../../../hyva-themes/view-utilities/modal-dialogs/index.html)** - Reference for building modals used in authentication flows
