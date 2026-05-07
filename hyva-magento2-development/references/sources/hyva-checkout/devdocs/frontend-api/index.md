<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/index.html -->

# Hyva Checkout Frontend API Overview

The **Hyva Checkout Frontend API** (`window.hyvaCheckout`) is a JavaScript namespace that provides client-side functionality for checkout interactions in Hyva Checkout. The Frontend API complements server-side [Magewire](../../magewire/index.html) components by handling tasks that require browser-level execution - validation orchestration, navigation control, session storage, and order placement coordination.

## Frontend API Sub-namespaces

The `hyvaCheckout` object organizes its functionality into sub-namespaces. Each sub-namespace handles a specific domain of checkout operations.

| Sub-namespace | Purpose | Documentation |
| --- | --- | --- |
| `hyvaCheckout.api` | Controls initialization timing and callback execution order | [API Initialization](V1/api.html) |
| `hyvaCheckout.evaluation` | Processes backend evaluation results and registers frontend validators | [Frontend Evaluation](V1/evaluation.html) |
| `hyvaCheckout.payment` | Registers and manages JavaScript-driven payment methods | [Payment Methods](V1/payment.html) |
| `hyvaCheckout.storage` | Stores key-value pairs in browser session storage for Place Order Service | [Storage API](V1/storage.html) |
| `hyvaCheckout.validation` | Manages the validation stack executed before navigation or order placement | [Form Validations](../form-api/form-validations.html) |
| `hyvaCheckout.navigation` | Controls checkout step navigation and history management | - |
| `hyvaCheckout.messenger` | Displays messages, dialogs, and notifications to customers | - |
| `hyvaCheckout.main` | Orchestrates API initialization and checkout lifecycle | - |
| `hyvaCheckout.config` | Provides access to backend configuration passed during initialization | - |

For details on file structure, Layout XML organization, and extension patterns, see the [Architecture documentation](architecture.html).

## When to Use the Hyva Checkout Frontend API

The Frontend API serves as a toolkit for browser-level operations that Magewire components cannot handle alone on the server side. Use the Frontend API when you need to:

- **Register custom validators** that execute JavaScript logic before step navigation or order placement
- **Implement JavaScript-driven payment methods** that interact with PSP (Payment Service Provider) SDKs or handle client-side payment flows
- **Store data in browser session storage** that needs to travel to the Place Order Service on the backend
- **Execute code after specific sub-namespaces initialize** using the event-driven initialization system
- **Coordinate frontend actions with backend evaluation results** through the `hyvaCheckout.evaluation` sub-namespace

## How the Frontend API and Magewire Backend Work Together

Hyva Checkout uses a "backend-first" architecture where Magewire components handle most logic server-side. The Frontend API provides targeted client-side support for operations that require browser execution. The [Evaluation API](../evaluation-api/index.html) is a great example of this pattern in action.

## Evaluation API Integration - Step-by-Step Example

The Evaluation API demonstrates how backend PHP code drives frontend JavaScript behavior. A Magewire component implementing `EvaluationInterface` returns "evaluation results" that instruct the frontend to perform specific actions like validation.

### Step 1: Define Validation Requirements in the Backend

The Magewire component specifies what validation should occur and what happens on failure. The `evaluateCompletion()` method uses `EvaluationResultFactory` to construct these instructions.

Magewire Component with Evaluation Result

```
<?php
// A Magewire component implementing EvaluationInterface

class ExampleComponent extends \Magewirephp\Magewire\Component
    implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(
        \Hyva\Checkout\Model\Magewire\Component\EvaluationResultFactory $resultFactory
    ): \Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult
    {
        // createValidation() links this result to a frontend validator by name
        return $resultFactory->createValidation('validateExampleComponent')
            // withFailureResult() defines what happens when the validator returns false
            ->withFailureResult(
                $resultFactory->createErrorMessageEvent()
                    ->withCustomEvent('payment:method:error')
                    ->withMessage('Value should be 1234')
                    ->withVisibilityDuration(5000)
             );
    }
}
```

For complete documentation on evaluation result types and backend implementation, see the [Evaluation API documentation](../evaluation-api/index.html).

### Step 2: The Backend Sends Instructions to the Frontend as JSON

During page rendering or Ajax updates, the evaluation result is serialized to JSON and sent to the browser. The JSON payload contains the validator name, failure handling instructions, and execution parameters.

The following JSON shows what the serialized evaluation result from Step 1 looks like when it arrives in the browser:

Serialized evaluation result JSON payload

```
{
    "example-component-name": {
        "arguments": {
            "name": "validateExampleComponent",
            "detail": {
                "component": { "id": "example-component-name" }
            },
            "stack": { "position": 500 },
            "results": {
                "failure": {
                    "arguments": {
                        "event": "payment:method:error",
                        "detail": {
                            "component": { "id": "example-component-name" },
                            "message": {
                                "text": "Value should be 1234",
                                "type": "error",
                                "duration": 5000
                            }
                        }
                    },
                    "dispatch": true,
                    "result": false,
                    "type": "event"
                }
            }
        },
        "type": "validation"
    }
}
```

### Step 3: The Frontend Processes Instructions and Registers a Validator

The `hyvaCheckout.evaluation` sub-namespace processes incoming evaluation results. For validation-type results, the Frontend API looks for a registered validator callback matching the name specified in `createValidation()` and adds the validator to the validation stack.

Register the validator callback using `hyvaCheckout.evaluation.registerValidator()` inside a `checkout:init:evaluation` event listener:

Frontend Validator Registration

```
<!-- File: My_Example::page/js/hyva-checkout/api/v1/evaluation/validate-example-component.phtml -->

<script>
    // Wait for the evaluation sub-namespace to initialize
    window.addEventListener('checkout:init:evaluation', () => {
        // Register the validator - the name must match createValidation() in the backend
        hyvaCheckout.evaluation.registerValidator('validateExampleComponent', (element, component) => {
            const field = element.querySelector('#secret');

            if (field) {
                // Async validation: returns a Promise (simulating an API call)
                return new Promise((resolve, reject) => setTimeout(() => {
                    field.value === '1234' ? resolve(true) : reject();
                }, 2500));
            }

            // Return false when the field is not found
            return false;
        });
    });
</script>
```

### Step 4: Validators Execute on Navigation or Order Placement

When the customer clicks "Continue" or "Place Order," all registered validators execute automatically. If any validator returns `false` or rejects its Promise, navigation halts and the backend-defined failure result displays to the customer - in this example, the error message "Value should be 1234" appears for 5 seconds.

For more details on form validation patterns, see the [Form Validations documentation](../form-api/form-validations.html).
