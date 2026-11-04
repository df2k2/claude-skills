<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/V1/evaluation.html -->

# Frontend Evaluation API for Hyvä Checkout

**Since:** 1.1.0

The `hyvaCheckout.evaluation` sub-namespace provides methods for registering frontend validators that integrate with the Hyvä Checkout backend Evaluation API. Magewire components define validation rules on the server, while the `hyvaCheckout.evaluation` API executes JavaScript validation logic on the client - creating a unified validation system across the entire checkout flow.

## How Frontend Evaluation Works in Hyvä Checkout

The frontend evaluation system connects backend validation rules to client-side JavaScript execution. A Magewire component implements `EvaluationInterface` and returns a validation result type. The Hyvä Checkout Frontend API then looks for a matching registered validator by name. The backend component defines *what* validation should occur and *what happens* on failure. The frontend validator defines *how* the validation executes using JavaScript.

For a complete overview of the Evaluation system including backend implementation, result types, and practical examples, see the dedicated [backend Evaluation API documentation](../../evaluation-api/index.html).

## registerValidator

`hyvaCheckout.evaluation.registerValidator` registers a named JavaScript validator function that pairs with a backend `Validation` result type. When the backend component returns a validation result matching the registered name, the Frontend API executes the corresponding JavaScript callback.

**Since:** 1.3.5

**Parameters:**

- `name` (string): A unique validator name that must match the name used in the backend `createValidation()` call.
- `callback` (function): The validator callback function. It must return `true` (valid) or `false` (invalid), or a Promise that resolves to one of them. The arguments depend on the backend result:
  - With a failure result set through `withFailureResult()` (as in the example below), the callback receives `(element, component, result)`. The `result` argument is passed since Checkout 3.0.0.
  - Without a failure result, the callback receives `(component, element, result)`.

**Returns:**

- `Promise` - Resolves when the validator is successfully registered.

### Backend Magewire Component with EvaluationInterface

The following PHP code shows a Magewire component that defines a validation result type named `my-unique-validator`. When validation fails, the backend specifies the failure behavior (console log and warning dialog). A validation holds a single failure result, so the example wraps both actions in a batch.

Backend: Magewire component with EvaluationInterface

Magewire Component Implementing EvaluationInterface

```
<?php

namespace Vendor\Module\Magewire;

use Magewirephp\Magewire\Component;
use Hyva\Checkout\Model\Magewire\Component\EvaluationInterface;
use Hyva\Checkout\Model\Magewire\Component\EvaluationResultFactory;
use Hyva\Checkout\Model\Magewire\Component\EvaluationResultInterface;

class MyComponent extends Component implements EvaluationInterface
{
    /**
     * Define validation result that triggers frontend validator registration lookup.
     * The 'my-unique-validator' name must match the frontend registerValidator() name.
     */
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResultInterface
    {
        return $resultFactory->createValidation('my-unique-validator')
            // Optional: Define what happens when the frontend validator returns false.
            // withFailureResult() keeps only the last result it receives, so combine
            // several actions in a batch.
            ->withFailureResult(
                $resultFactory->createBatch([
                    $resultFactory->createConsoleLog('My unique validator failed... please try again.'),
                    $resultFactory->createMessageDialog('Validation Failure')
                        ->withMessage('My unique validator failed... please try again.')
                        ->asWarning()
                ])
            );
    }
}
```

### Frontend JavaScript Validator Registration

The following JavaScript registers a frontend validator that pairs with the backend `EvaluationInterface` component above. The validator name `my-unique-validator` must exactly match the name passed to `createValidation()` in the Magewire PHP component.

Frontend: Registering the JavaScript validator callback

JavaScript Validator Registration

```
<script>
    (() => {
        // Wait for Frontend API initialization before registering
        hyvaCheckout.api.after(() => {
            // Register validator with name matching backend createValidation() call
            hyvaCheckout.evaluation.registerValidator(
                'my-unique-validator',
                async (element, component, result) => {
                    // Implement custom validation logic here
                    // element: The DOM element associated with the component
                    // component: The Magewire component instance
                    // result: The validation result (passed since Checkout 3.0.0)
                    // The backend sets a failure result, so the callback receives (element, component, result).
                    // Without a failure result, it receives (component, element, result) instead.

                    // Return true for valid, false for invalid
                    // On false, the backend-defined withFailureResult() actions execute
                    return true;
                }
            ).then(() => console.log('my-unique-validator registered successfully.'));
        });
    })();
</script>
```

## Processor Teardown and registerCleanup

A custom evaluation processor (registered with `hyvaCheckout.evaluation.registerProcessor()`, see [Custom evaluation results](../../evaluation-api/evaluation-result-types.html#custom)) often sets something up, for example a validation or an event listener. How you remove it again when the backend sends a new result depends on the release line.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, a processor can return a teardown function. Hyvä Checkout stores it per component and runs it before it processes the component's next result, also when that result is unchanged, and when the component is removed. Return nothing when there is nothing to clean up.

A teardown that removes a validation passes the step it registered the validation on as the third argument of `hyvaCheckout.validation.remove(name, group, step)`. A teardown can run after a step change, and without the `step` argument `remove()` looks in the current step.

For cleanup that must wait for the component's next Magewire request, use `hyvaCheckout.evaluation.registerCleanup(result, callback)`. It registers a Magewire `commit` hook for the result's own component. The callback receives the Magewire 3 commit payload (`{ component, commit, respond, succeed, fail }`), so it can decide when to act, for example with `succeed(() => ...)`. Calling `registerCleanup()` again for a result with the same hash replaces the previous hook instead of adding another one. The teardown of a run also removes the `registerCleanup()` hooks of that run.

The following example registers a processor for a custom result type `my-result`. It adds a validation, removes it after a successful request when the result failed, and returns a teardown that removes the validation from the step it was registered on.

Processor with teardown and registerCleanup (Checkout 3.x)

```
<script>
    window.addEventListener('checkout:init:evaluation', () => {
        hyvaCheckout.evaluation.registerProcessor('my-result', (component, el, result) => {
            hyvaCheckout.validation.register(result.hash, () => result.result, el, result.group);

            // Runs on the next commit of this component.
            hyvaCheckout.evaluation.registerCleanup(result, ({ succeed }) => {
                succeed(() => {
                    if (result.result === false) {
                        hyvaCheckout.validation.remove(result.hash);
                    }
                });
            });

            // The step the validation is registered on: a teardown can run after a step change.
            const step = hyvaCheckout.navigation.getCurrent()?.name;

            // Teardown: runs before the component's next result is processed, and when the component is removed.
            return () => hyvaCheckout.validation.remove(result.hash, result.group, step);
        });
    });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Checkout 1.x has no `registerCleanup()` method and ignores the return value of a processor. Hyvä Checkout's own processors on 1.x clean up with a Magewire 1 `message.received` hook that checks the component ID.

The following example shows the same processor written for Checkout 1.x.

Processor with a message.received cleanup hook (Checkout 1.x)

```
<script>
    window.addEventListener('checkout:init:evaluation', () => {
        hyvaCheckout.evaluation.registerProcessor('my-result', (component, el, result) => {
            hyvaCheckout.validation.register(result.hash, () => result.result, el, result.group);

            Magewire.hook('message.received', (message, messageComponent) => {
                if (messageComponent.id === result.id && result.result === false) {
                    hyvaCheckout.validation.remove(result.hash);
                }
            });
        });
    });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

## Running a Deferrable With evaluation.run

`hyvaCheckout.evaluation.run(name, args = {}, el = null)` runs a deferrable, an evaluation result the backend sent to the browser for later use, such as the `technical.malfunction.dialog` that Hyvä Checkout's Main component provides. The `args` object overrides the deferrable's arguments, unless the backend built the deferrable with `disableArgumentOverwrites()`. `run()` returns a Promise.

**Since:** 1.3.6

On Checkout 3.x, the `args` overrides apply to this run only. The Promise resolves once the result is processed, and rejects with an error naming the deferrable when processing fails. On Checkout 1.x, the overrides stay in place for later runs of the same deferrable.

The following snippet shows the technical malfunction dialog with a text of its own, as Hyvä Checkout does when it can't save configuration changes.

Running a deferrable with argument overrides

```
hyvaCheckout.evaluation.run('technical.malfunction.dialog', {
    text: 'Unable to save configuration changes. Please refresh the page and try again.'
});
```
