<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/evaluation-api/evaluation-result-types.html -->

# Hyvä Checkout Evaluation Result Types

Hyvä Checkout provides evaluation result types for messaging, validation, and JavaScript execution during checkout navigation. Each result type serves a different purpose - from displaying error messages to injecting executable code into the navigation process. You can also create your own custom evaluation result types when the built-in ones don't cover your needs.

## Batch

Available since Hyvä Checkout 1.1.13

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Batch`
- **Frontend processor:** `batch`
- **Capabilities:** N/A

The Batch result type lets you bundle multiple evaluation results together into a single return value. All results in a Batch are processed on the frontend. There's no restriction on the number or types of results a Batch can carry - it works like an array with methods to traverse, push, or merge results. Each result in a Batch is processed on its own, so one failing result doesn't stop the others.

On Checkout 3.x, the browser treats a Batch as failed when one of its results fails, so the component keeps its error message when it re-renders. In a Batch, `MessageDialog` and `Custom` results count as failed unless you set `withTrueResult()`. `asSuccess()` only changes their style.

Using a Batch is a good practice because it allows other modules (via Magento plugins) to inject additional results into your evaluation.

The following component returns a Batch containing a warning message and a custom JavaScript window event. It also shows how to conditionally push additional results - in this case, clearing the Batch and adding a redirect if no other component already owns a Redirect result.

Example batch with multiple result types

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Create a batch with a warning message and a custom window event.
        $batch = $resultFactory->createBatch(
            [
                $resultFactory->createErrorMessage()
                    ->withMessage('Something went wrong.')
                    ->asWarning(),
                $resultFactory->createEvent()
                    ->withCustomEvent('my-batch-event')
                    ->dispatch()
            ]
        );

        // Push additional results conditionally.
        // Here we check if any other component already has a Redirect result.
        if (false === $component->getEvaluationResultBatch()->owns(fn ($value) => $value instanceof Redirect)) {
            $batch->clear()->push($resultFactory->createRedirect('https://hyva.io/hyva-checkout.html')
                ->withNotificationDialog()
                ->withNotificationMessage('You\'re being redirected to the Hyva Checkout product page.')
                ->withTimeout(2500)
            );
        }

        return $batch;
    }
}
```

Quick access to the result factory from within a Batch

You don't need to pass the `$resultFactory` around manually. Every Batch has a `getFactory()` method that gives you access to the factory for creating additional result types.

```
$batch->push(
    $batch->getFactory()
        ->createErrorMessage()
        ->withMessage('Something went wrong.')
)
```

## Blocking

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Blocking`
- **Frontend processor:** `error_message` (the same as [ErrorMessage](#errormessage))
- **Extends:** `ErrorMessage`

Deprecated

`Blocking` and `createBlocking()` are deprecated. Return an [ErrorMessage](#errormessage), an `ErrorEventMessage` or `ErrorEvent` ([Event](#event)), or a MessageDialog result instead.

The Blocking result type no longer disables the navigation buttons. It extends `ErrorMessage` and is processed as one: navigation stops and the customer sees an error message. The message is the cause passed to `createBlocking()`, or "Something needs your attention before you can proceed with checkout." when no cause is given.

The following component returns a Blocking result based on a condition. When the condition is `true`, navigation stops with the cause as the message. Otherwise, a Success result allows the customer to proceed.

Example blocking result implementation

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Return Blocking when the condition is true, Success otherwise.
        return true ? $resultFactory->createBlocking() : $resultFactory->createSuccess();
    }
}
```

## Custom

Available since Hyvä Checkout 1.1.13

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Custom`
- **Frontend processor:** N/A
- **Capabilities:** Details, Blocking, Dispatch

The Custom result type is your go-to when you need a result that's handled entirely by your own frontend processor. It comes with all built-in capabilities (dispatching, blocking, and details) out of the box.

The backend creates a Custom result with a type name and passes data through the `withDetails()` method. The frontend processor then picks up that data.

Backend: Creating a custom result with details

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Create a custom result with type "foo" and pass alert text as detail data.
        return $resultFactory->createCustom('foo')
            ->withDetails(['alert' => 'Something went wrong.']);
    }
}
```

Register the matching frontend processor after the Evaluation API is initialized. The processor receives the custom details from the backend via `result.arguments.details`.

Frontend: Registering the custom processor

```
<script>
    // Wait for the evaluation API to be fully initialized.
    window.addEventListener('checkout:init:evaluation', () => {
        // Register evaluation processor "foo" to handle our custom result type.
        hyvaCheckout.evaluation.registerProcessor('foo', (component, el, result) => {
            alert(result.arguments.details.alert);

            return result.result;
        });
    });
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Registering custom evaluation processors via layout XML

Add a `.phtml` file to the DOM via layout XML. The recommended approach is to inject your `.phtml` via layout handle `hyva_checkout_index_index` with a container preference of `hyva.checkout.init-evaluation.after`.

Each API has its own `after` container, so custom code is always injected after its parent API is ready.

For details, refer to `view/frontend/layout/hyva_checkout_index_index.xml`.

## ErrorMessage

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\ErrorMessage`
- **Frontend processor:** `message`
- **Capabilities:** Blocking, Messaging, Dispatch

The ErrorMessage result type displays feedback to customers, either when they attempt to navigate or immediately via `dispatch()`. Despite the name "ErrorMessage", you can change the visual style to show success, warning, or informational messages using methods like `asCustomType()` and `asWarning()`.

The following component demonstrates the ErrorMessage customization options: dispatching immediately instead of waiting for navigation, overriding the message type to display as a success message, and setting a custom visibility duration.

Error message with customization options

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public bool $dispatch = false;
    public bool $successful = true;
    public ?int $duration = null;

    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        $message = $resultFactory->createErrorMessage('Something went wrong');

        // Dispatch immediately instead of binding to a navigation button click.
        if ($this->dispatch) {
            $message->dispatch();
        }
        // Override the message type to display as a success message.
        if ($this->successful) {
            $message->asCustomType('success');
        }
        // Set how long (in milliseconds) the message stays visible.
        if ($this->duration) {
            $message->withVisibilityDuration($this->duration);
        }

        return $message;
    }
}
```

## Event

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Event`
- **Frontend processor:** `event`
- **Extended by:** `ErrorEvent` (itself extended by `ErrorEventMessage`), `Success`
- **Capabilities:** Details, Dispatch

The Event result type is the base event class in the Hyvä Checkout Evaluation API. It dispatches custom JavaScript window events from the backend. The specialized subtypes `ErrorEventMessage`, `ErrorEvent`, and `Success` all build on Event, adding specific behaviors for error messaging, error handling, and completion marking respectively.

The following component shows three ways to create and dispatch events using the Event family of result types: a basic custom window event, an error message event with custom messaging, and an error event that binds to the Validation API.

Event result type variations

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Basic Event: dispatches a custom window event.
        // Catch it with window.addEventListener('my-custom-event', event => {})
        return $resultFactory->createEvent()
            ->withCustomEvent('my-custom-event')
            ->dispatch();

        // ErrorEventMessage: dispatches a window event with message markup (message text and type).
        return $resultFactory->createErrorMessageEvent()
            ->withCustomEvent('my-error-event')
            ->withMessage('Something went wrong')
            ->dispatch();

        // ErrorEvent: dispatches a window event with a false result,
        // bound to the Validation API by default.
        return $resultFactory->createErrorEvent()
            ->withCustomEvent('my-custom-event');
    }
}
```

## Executable

Available since Hyvä Checkout 1.1.13

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Executable`
- **Frontend processor:** `executable`
- **Capabilities:** Dispatch

The Executable result type runs specific JavaScript code on the frontend, driven by parameters set in the backend. Think of it as a named function call where you define the arguments server-side and register the implementation client-side. You can use an Executable on its own (dispatched immediately) or attach it to a NavigationTask so it runs when the customer navigates.

The following backend component creates an Executable named `custom-modal` with parameters. It demonstrates two usage patterns: dispatching the Executable immediately or wrapping it in a NavigationTask so it only fires when the customer navigates forward.

Backend: Creating executable with parameters

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Create an executable named "custom-modal" with button parameters.
        $executable = $resultFactory->createExecutable('custom-modal')
            ->withParams(['buttons' => ['confirm', 'cancel']]);

        // Option 1: Dispatch the executable immediately.
        return $executable->withParam('title' => 'My Modal');

        // Option 2: Attach the executable to a navigation task,
        // so it only triggers when the customer clicks the navigation button.
        return $resultFactory->createNavigationTask('foo', $executable)
    }
}
```

Register the Executable callback on the frontend after the Evaluation API is initialized. Executables support both synchronous and asynchronous callbacks. The following example registers an async Executable that opens a modal after a 5-second delay.

Frontend: Registering an asynchronous executable

```
<script>
    // Wait for the evaluation API to be fully initialized.
    window.addEventListener('checkout:init:evaluation', () => {
        // Register the "custom-modal" executable with an async callback.
        hyvaCheckout.evaluation.registerExecutable('custom-modal', async (result, el, component) => {
            return new Promise(resolve => setTimeout(() => {
                fetch('https://api.example.extension/random').then(result => {
                    // Custom logic to open a modal goes here.
                })

                resolve()
            }, 5000))
        })
    })
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

## NavigationTask

Available since Hyvä Checkout 1.1.13

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\NavigationTask`
- **Frontend processor:** `navigation_task`
- **Capabilities:** Dispatch, Stacking

The NavigationTask result type delays JavaScript-driven actions until the customer clicks the navigation button to advance to the next step or place an order. Tasks stay pending until that button click, then execute sequentially based on their assigned stack position (default: `500`).

This is useful for things like saving form data that no other component depends on. Instead of auto-saving, you let the navigation mechanism handle data retention when the customer moves forward.

A NavigationTask can wrap any evaluation result type. If the wrapped result is dispatchable, the NavigationTask handles it automatically. You can also tell the task to execute *after* the next step loads or the order completes, using `executeAfter()`.

The following component creates a success-type flash message that displays after the customer proceeds to the next step or places the order. It wraps an ErrorMessage (styled as a success message) inside a NavigationTask with `executeAfter()`.

Navigation task executing after navigation

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Create an ErrorMessage styled as a success-type flash message.
        $task = $resultFactory->createErrorMessage()
            ->withMessage('Welcome to the next step.')
            ->asCustomType('success');

        // Wrap it in a NavigationTask that executes after the customer navigates.
        // "fooCustomNavigationTask" is the task identifier on the frontend.
        return $resultFactory->createNavigationTask('fooCustomNavigationTask', $task)->executeAfter();
    }
}
```

The result appears as a success-type flash message at the top of the screen, either after the customer proceeds to the second page or after placing the order (before any redirection). You can combine this pattern with other result types - for example, displaying a modal through an async Executable while navigation waits for it to resolve. Since the Redirect result sits late in the task stack, other tasks get to execute first.

## Notification

Checkout 3.x only

The Notification result type exists on Hyvä Checkout 3.x (Magewire 3), from 3.0.0-beta1 and the 1.4.0-beta3 release on. Checkout 1.x doesn't have it. To show a message on Checkout 1.x, use an [ErrorMessage](#errormessage) result with `dispatch()`.

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Notification`
- **Factory method:** `createNotification(Phrase $message)`
- **Frontend processor:** `notification`
- **Capabilities:** Messaging, Duration

The Notification result type shows a message through the Magewire 3 notifier (`window.MagewireAddons.notifier`). Use it when you already assemble an evaluation result batch, for example inside a form modifier, so your notifications go through the Evaluation API like the rest of your results. If the notifier isn't available on the page, the processor does nothing.

Notifications are informational by default. Chain `asSuccess()`, `asWarning()` or `asError()` to change the style, `withMessageTitle()` to add a title, and `withDuration()` to set how long the notification stays visible in milliseconds. Without a duration, the notifier derives one from the message length.

The following snippet pushes a success notification and a warning notification with a fixed duration onto a form component's evaluation batch, as the core guest login modifier does:

```
// Confirm a successful sign in.
$component->getEvaluationResultBatch()->push(
    $this->evaluationResultFactory
        ->createNotification(__('Login succeeded, welcome back'))
        ->asSuccess()
);

// Warn about a failed sign in for three seconds.
$component->getEvaluationResultBatch()->push(
    $this->evaluationResultFactory
        ->createNotification(__('Couldn\'t sign you in.'))
        ->withDuration(3000)
        ->asWarning()
);
```

## ProgressOverlay

Checkout 3.x only

The ProgressOverlay result type exists on Hyvä Checkout 3.x (Magewire 3), from 3.0.0-beta1 and the 1.4.0-beta3 release on. Checkout 1.x doesn't have it.

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\ProgressOverlay`
- **Factory method:** `createProgressOverlay(?Phrase $title = null)`
- **Frontend processor:** `progress_overlay`
- **Capabilities:** Messaging (title only: set it with `withMessageTitle()`. `withMessage()` and `withDataDrivenMessage()` are deprecated and have no effect.)

The ProgressOverlay result type shows a full-screen overlay with a loading spinner and a title that the customer can't close. Use it to block interaction while a blocking action completes, typically right before a redirect. The result is purely visual: it always evaluates to `true`, so it never blocks navigation on its own.

While the overlay is open, it holds the keyboard focus and makes `#hyva-checkout-main` inert. It gives the focus back when it closes.

A ProgressOverlay result does nothing until you choose an action:

- **`open()`**: shows the overlay, or refreshes it when an overlay with the same alias is open.
- **`target(string $alias)`**: updates the title of an open overlay with that alias. It does nothing when no matching overlay is open, so a late update never reopens it.
- **`close()`**: hides the overlay. Combine it with `withAlias()` or `target()` to close only the overlay with that alias.
- **`closeAfter(int $milliseconds)`**: closes the overlay automatically after the delay.

The following snippet opens an overlay while a customer signs in, and closes it again after one second when the sign in fails:

```
// Show the overlay and tag it with an alias.
$component->getEvaluationResultBatch()->push(
    $this->evaluationResultFactory
        ->createProgressOverlay(__('Attempting to sign you in'))
        ->withAlias('guest-login')
        ->open()
);

// On failure, address the same overlay and close it after one second.
$component->getEvaluationResultBatch()->push(
    $this->evaluationResultFactory
        ->createProgressOverlay()
        ->target('guest-login')
        ->closeAfter(1000)
);
```

The frontend processor translates the action into one of three window events, which you can also dispatch from your own JavaScript: `checkout:progress-overlay:show`, `checkout:progress-overlay:update` and `checkout:progress-overlay:hide`. The `show` event accepts an `until` promise in its `detail`, and the overlay closes itself when that promise settles:

```
window.dispatchEvent(new CustomEvent('checkout:progress-overlay:show', {
    detail: { alias: 'my-process', title: 'Please wait', until: myPromise }
}));
```

## Redirect

Available since Hyvä Checkout 1.1.13

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Redirect`
- **Frontend processor:** `redirect`
- **Capabilities:** Dispatch, Stacking

The Redirect result type sends customers to a different URL, making it especially useful for payment integrations that redirect to external payment gateways before or after order placement. The Redirect includes a built-in modal that can show as a notification dialog, or you can present a confirmation dialog with cancel and confirm buttons.

System administrators can enforce confirmation dialogs for all redirects through the redirect system settings, even if developers don't attach them in their code.

The following component creates a Redirect wrapped in a NavigationTask. The redirect fires after the customer proceeds to the next step or places the order.

Redirect result with navigation task

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Create a redirect to the target URL.
        $task = $resultFactory->createRedirect('https://hyva.io/hyva-checkout.html');

        // Wrap it in a NavigationTask that executes after the customer navigates.
        return $resultFactory->createNavigationTask('foo', $task)->executeAfter();
    }
}
```

### Custom Redirect Template for Place Order Services

Available since Hyvä Checkout 1.3.4

Since Hyvä Checkout 1.3.4, you can define a custom frontend template for the Redirect result. This lets you customize what customers see during the redirect phase after placing an order - for example, a branded loading screen or custom messaging.

The following Place Order Service creates a `PlaceOrderRedirect` with a custom template. The `PlaceOrderRedirect` class extends `Redirect`, so it stays fully compatible with the existing frontend processor and behaviors expected by the `PlaceOrderProcessor`.

Place Order Service with custom redirect template

```
<?php

class MyCustomPlaceOrderService extends \Hyva\Checkout\Model\Magewire\Payment\AbstractPlaceOrderService
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory, ?int $orderId = null): EvaluationResultInterface
    {
        // Use PlaceOrderRedirect (extends Redirect) with a custom template.
        return $resultFactory
            ->create(PlaceOrderRedirect::class, ['url' => 'https://hyva.io/hyva-checkout.html'])
            ->withRedirectTemplate('Hyva_Checkout::redirect-to-hyva.phtml');
    }
}
```

The template you pass via `withRedirectTemplate(string $template)` can contain any custom HTML and styling.

view/frontend/templates/redirect-to-hyva.phtml

```
<div>
    Hello from the Hyva checkout docs!
</div>
```

## Success

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Success`
- **Frontend processor:** `event`
- **Capabilities:** Details, Dispatch

The Success result type extends Event and is the standard way to mark a component as completed. When you return a Success result, two things happen: a success event dispatches for the component on the frontend, and the result evaluates to `true`, indicating the component is done.

You could technically return `true` from any custom result type to achieve the same completion status, but using Success keeps things consistent and gives you the event dispatch for free.

The following component returns Success when its `$success` property is `true`. Otherwise, it returns an informational ErrorMessage dispatched immediately to tell the customer what they need to do.

Success result with conditional completion

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public bool $success = true;

    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        if ($this->success) {
            // Mark the component as completed.
            return $resultFactory->createSuccess();
        }

        // Display an informational message immediately.
        return $resultFactory->createErrorMessage()
            ->withMessage('Please mark this component as completed.')
            ->asInformally()
            ->dispatch()
    }
}
```

## Validation

Available since Hyvä Checkout 1.1.13

- **Class:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\Validation`
- **Frontend processor:** `validation`
- **Capabilities:** Stacking, Details

The Validation result type integrates with the frontend Validation API, letting you inject custom validation logic that runs when the customer clicks a primary navigation button. Validation executes after all NavigationTasks have been fulfilled.

A Validation result works similarly to a NavigationTask, but the registered frontend callback acts as a validator (returning `true`/`false` or a Promise). You can attach a failure result - like an ErrorMessage - using the `withFailureResult()` method, so error handling happens automatically when validation fails.

The following backend component creates a Validation result that references one of three frontend validators (chosen randomly). If the selected validator fails, the attached ErrorMessage displays automatically.

Backend: Validation with failure result

```
<?php

class Foo extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        // Randomly pick one of the three registered frontend validators.
        $validator = ['a', 'b', 'c'][random_int(0, 2)];

        // Create the Validation result with an ErrorMessage as the failure result.
        return $resultFactory->createValidation($validator)
            ->withFailureResult($resultFactory->createErrorMessage()
                ->withMessage(sprintf('Validator "%s" failed.'))
                ->dispatch()
            );
    }
}
```

Register the matching validators on the frontend after the Evaluation API is initialized. Validators can be synchronous or asynchronous. The following example registers three validators with different behaviors: one that fails immediately, one that resolves successfully after a delay, and one that rejects after a delay.

Frontend: Registering validators with different behaviors

```
<script>
    window.addEventListener('checkout:init:evaluation', () => {
        // Validator "a": fails validation immediately by throwing an error.
        hyvaCheckout.evaluation.registerValidator('a', (element, component) => {
            throw new Error('Foo')
        })

        // Validator "b": resolves successfully after 2.5 seconds.
        hyvaCheckout.evaluation.registerValidator('b', async (element, component) => {
            return new Promise(resolve => setTimeout(() => resolve(true), 2500))
        })

        // Validator "c": rejects and fails validation after 2.5 seconds.
        hyvaCheckout.evaluation.registerValidator('c', async (element, component) => {
            return new Promise((resolve, reject) => setTimeout(() => reject(), 2500))
        })
    })
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Registering custom validators via layout XML

Add a `.phtml` file to the DOM via layout XML. The recommended approach is to inject your `.phtml` via layout handle `hyva_checkout_index_index` with a container preference of `hyva.checkout.init-evaluation.after`.

Each API has its own `after` container, so custom code is always injected after its parent API is ready.

For details, refer to `view/frontend/layout/hyva_checkout_index_index.xml`.

## EvaluationResult (Abstract Base Class)

Available since Hyvä Checkout 1.1.13

Before version 1.1.13, every evaluation result type had to implement `Hyva\Checkout\Model\Magewire\Component\EvaluationResultInterface`.

Starting from version 1.1.13, that interface is deprecated. Use `\Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult` instead.

Every built-in evaluation result type extends the `EvaluationResult` abstract class. When building custom result types, extend this class to make sure all the required contracts are fulfilled.

The following example shows the minimal structure for a custom evaluation result type. You need to define a `TYPE` constant (or override `getType()`) and implement the `getArguments()` method.

Custom evaluation result type structure

```
<?php

namespace My\Module\Model\Magewire\Component\Evaluation;

class Foo extends \Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult
{
    // Define the type name used to match this result with its frontend processor.
    public const TYPE = 'foo';

    // Return the arguments that get passed to the frontend processor.
    public function getArguments(Component $component): array
    {
        return [];
    }

    // Alternative: override getType() instead of using a TYPE constant.
    public function getType(): string
    {
        return 'foo';
    }
}
```
