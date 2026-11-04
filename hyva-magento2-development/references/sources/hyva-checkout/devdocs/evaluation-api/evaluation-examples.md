<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/evaluation-api/evaluation-examples.html -->

# Hyvä Checkout Evaluation examples

The Hyvä Checkout Evaluation API enables custom validation, frontend execution, and payment integration across Magewire components and Place Order Services. This page walks through practical implementation patterns for common use cases.

## Credit card authorization

Validate payment method fields before allowing checkout navigation or order placement. When the customer clicks the primary navigation button, a loading indicator appears while validation runs. If validation fails, an error message shows within the component. If it passes, the customer moves to the next step.

### Create the Magewire payment component

This Magewire component implements `EvaluationInterface` to validate a credit card field on forward navigation.

Magewire/Checkout/Payment/Method/Cc.php

```
<?php

use Magewirephp\Magewire\Component;
use Hyva\Checkout\Model\Magewire\Component\EvaluationInterface;
use Hyva\Checkout\Model\Magewire\Component\EvaluationResultFactory;
use Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult;

class Cc extends Component implements EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        /*
         * Direct the frontend to execute "validateMyCustomCcComponent" and
         * trigger an error message event in case of failure.
         */
        return $resultFactory->createValidation('validateMyCustomCcComponent')
            ->withFailureResult(
                $resultFactory->createErrorMessageEvent()
                    ->withCustomEvent('payment:method:error')
                    ->withMessage('Invalid credit card details provided. Please try again.')
                    ->withVisibilityDuration(5000)
             );
    }
}
```

### Inject the payment component into checkout

Register the payment method component using the `hyva_checkout_components.xml` layout handle. The checkout framework automatically finds a block matching the payment method `alias` and renders its template.

For complete payment method integration instructions, see the [Payment Integration API documentation](../payments/payment-integration-api.html).

view/frontend/layout/hyva\_checkout\_components.xml

```
<!-- Register the credit card payment method component -->
<referenceBlock name="hyva.checkout.components">
    <block
        name="checkout.payment.method.cc"
        as="cc"
        template="My_Example::checkout/payment/method/cc.phtml"
    >
        <arguments>
            <argument name="magewire" xsi:type="object">
                \My\Example\Magewire\Checkout\Payment\Method\Cc
            </argument>
        </arguments>
    </block>
</referenceBlock>
```

### Register the frontend validator

Register a frontend validator callback that runs when the customer attempts to navigate forward. You can place this script directly in the component's PHTML template, but injecting it into the `hyva.checkout.api-v1.after` or `hyva.checkout.init-evaluation.after` containers improves maintainability.

Frontend validator registration

```
<script>
    /*
     * Wait for the evaluation API to initialize, then register
     * a validator named "validateMyCustomCcComponent".
     */
    window.addEventListener('checkout:init:evaluation', event => {
        hyvaCheckout.evaluation.registerValidator('validateMyCustomCcComponent', (element, component) => {
            return Math.random() < 0.5 // Randomly return true of false.
        })
    })
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

## Marketing opt-in with Navigation Task

This example uses an Executable result with a Navigation Task to register customers for marketing communications after they successfully navigate to the next checkout step. Because the registration is optional, it uses an [Executable result](./evaluation-result-types.html#executable) combined with a [Navigation Task result](./evaluation-result-types.html#navigationtask) rather than a [Validation result](./evaluation-result-types.html#validation).

The Navigation Task fires the registration logic after the customer proceeds, so it never blocks navigation for optional functionality.

### Create the marketing Magewire component

This Magewire component tracks whether the customer agreed to receive marketing communications and implements `EvaluationInterface` to create the Navigation Task.

The `withParam()` method forwards data from the Magewire component to the frontend executable callback.

Magewire/MarketingCheckbox.php

```
<?php

declare(strict_types=1);

namespace Vendor\Module\Magewire;

use Magewirephp\Magewire\Component;
use Hyva\Checkout\Model\Magewire\Component\EvaluationInterface;
use Hyva\Checkout\Model\Magewire\Component\EvaluationResultFactory;
use Hyva\Checkout\Model\Magewire\Component\EvaluationResultInterface;

class MarketingCheckbox extends Component implements EvaluationInterface
{
    // Tracks whether the customer opted in to marketing emails
    public bool $shouldRegister = false;

    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResultInterface
    {
        // Create an executable that runs "marketingRegistrationExecutable" on the frontend
        $executable = $resultFactory
            ->createExecutable('marketingRegistrationExecutable')
            ->withParam('shouldRegister', $this->shouldRegister);

        // Wrap the executable in a Navigation Task that fires after navigation
        return $resultFactory
            ->createNavigationTask('marketingRegistrationTask', $executable)
            ->executeAfter();
    }
}
```

### Add the checkbox block to checkout layout

Use the [`hyva_checkout_components.xml`](../custom-checkout/layout-handles.html#declaring-reusable-components-with-hyva_checkout_components) layout handle to add the marketing checkbox component to the checkout. This example appends it to the summary block.

view/frontend/layout/hyva\_checkout\_components.xml

```
<?xml version="1.0"?>
<page
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
>
    <body>
        <referenceContainer name="hyva.checkout.api-v1.after">
            <referenceContainer name="checkout.quote-summary.section">
                <block
                    name="marketing.checkbox.component"
                    template="Vendor_Module::checkbox.phtml"
                    after="-"
                >
                    <arguments>
                        <argument name="magewire" xsi:type="object">
                            Vendor\Module\Magewire\MarketingCheckbox
                        </argument>
                    </arguments>
                </block>
            </referenceContainer>
        </referenceContainer>
    </body>
</page>
```

### Create the checkbox template

This PHTML template renders the marketing opt-in checkbox with two-way data binding to the Magewire component's `shouldRegister` property via `wire:model.live`.

view/frontend/templates/checkbox.phtml

```
<?php

declare(strict_types=1);

use Magento\Framework\Escaper;
use Magento\Framework\View\Element\Template;
use Vendor\Module\Magewire\MarketingCheckbox;

/** @var Escaper $escaper */
/** @var Template $block */
/** @var MarketingCheckbox $magewire */
?>

<label>
    <input
        type="checkbox"
        name="checkbox_component"
        wire:model.live="shouldRegister"
    >
    <span><?= $escaper->escapeHtml(__(
        'Would you like to receive marketing emails from us? %1',
        $magewire->shouldRegister ? 'Yes' : 'No'
    )); ?></span>
</label>
```

`wire:model.live` syncs the checkbox on every change, so `withParam('shouldRegister', ...)` always carries the current state when the navigation task runs. It works the same on both release lines: Magewire 1 ignores the `.live` modifier and syncs a plain `wire:model` on every change anyway, while on Magewire 3 a plain `wire:model` is deferred.

### Add the Navigation Task block to checkout

Use the `hyva_checkout_index_index.xml` layout handle to inject the block containing the navigation task JavaScript callback.

view/frontend/layout/hyva\_checkout\_index\_index.xml

```
<?xml version="1.0"?>
<page
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
>
    <body>
        <referenceContainer name="hyva.checkout.api-v1.after">
            <block
                name="marketing.checkbox.navigation.task"
                template="Vendor_Module::js/checkbox.phtml"
            />
        </referenceContainer>
    </body>
</page>
```

### Register the Navigation Task executable callback

Register the executable callback using `hyvaCheckout.evaluation.registerExecutable()` inside a `checkout:init:evaluation` event listener. The callback name must match the name passed to `createExecutable()` in the Magewire component's `evaluateCompletion()` method.

The callback receives a `result` parameter containing any data forwarded by the Magewire component via `withParam()`.

view/frontend/templates/js/checkbox.phtml

```
<?php
declare(strict_types=1);

use Magento\Framework\Escaper;
use Magento\Framework\View\Element\Template;

/** @var Escaper $escaper */
/** @var Template $block */
?>

<script>
    // Register the marketing executable after the evaluation API initializes
    window.addEventListener('checkout:init:evaluation', event => {
        hyvaCheckout.evaluation.registerExecutable(
            'marketingRegistrationExecutable',
            (result, element, component) => {
                // Check if the customer opted in via the Magewire-forwarded param
                if (result.arguments.params.shouldRegister) {
                    // marketing registration logic
                }
            }
        );
    });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

### Navigation Task execution behavior

The [Navigation Task](./evaluation-result-types.html#navigationtask) callback does **not** execute when the checkout initializes. It **does** execute every time the customer navigates to or from the step containing the `MarketingCheckbox` component.

Avoid duplicate API calls

For a production marketing integration, add a mechanism to flag when the API call has succeeded so the task doesn't fire duplicate requests on repeated navigation.
