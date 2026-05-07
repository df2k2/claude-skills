<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/evaluation-api/index.html -->

# Hyvä Checkout Evaluation API

Magewire knowledge required

You should have a basic understanding of Magewire before diving into the Evaluation API. A lot of its functionality is inspired by Magewire's state handling, transitioning between backend and frontend operations.

The Hyvä Checkout Evaluation API lets you send evaluation state from the backend to the frontend. You define frontend instructions and behaviors in backend code - things like validation requirements, error messages, or JavaScript execution tasks. The Evaluation API bridges backend logic with frontend interactions, so Magento plugins can modify behavior and everything stays maintainable.

## Why Use the Evaluation API?

The Evaluation API gives you an extensible way to pass instructions to the frontend, both on initial checkout load and during subsequent Magewire update requests. Because the Evaluation API is driven by the backend, you get access to all the Magento goodies (like Plugins) to change behavior whenever you need to.

## Evaluation API Example Scenario

This example demonstrates a Magewire component with a numeric counter and increment/decrement buttons. The component evaluates whether the counter meets requirements before allowing the customer to proceed with checkout navigation.

### Backend Component Implementation

The Magewire component implements the `EvaluationInterface` to evaluate the counter value. When the value is greater than zero, the component returns a Success result. Otherwise, it returns an Error Message that displays when the customer tries to navigate forward.

ExampleScenario.php - Component with counter validation

```
<?php

class ExampleScenario extends \Magewirephp\Magewire\Component implements \Hyva\Checkout\Model\Magewire\Component\EvaluationInterface
{
    public int $count = 0;

    public function increment()
    {
        $this->count++;
    }

    public function decrements()
    {
        $this->count--;
    }

    // Evaluated on page load and after triggering the increment or decrement actions.
    public function evaluateCompletion(EvaluationResultFactory $resultFactory): EvaluationResult
    {
        if ($this->count > 0) {
            // Mark the component as completed - this is the final status when everything works correctly.
            return $resultFactory->createSuccess();
        }

        // This triggers a Magento flash message when the customer tries to navigate forward or place an order.
        return $resultFactory->createErrorMessage()
            ->withMessage('Count value must be greater than zero.')
            ->withVisibilityDuration(5000)
            ->asWarning();

        // Dispatches a custom window event when the customer tries to navigate forward or place an order.
        return $resultFactory->createEvent()
            ->withCustomEvent('count-failure')
    }
}
```

### Frontend Template for the Counter Component

The template provides increment and decrement buttons that trigger Magewire actions to update the counter value.

Template with increment/decrement controls

```
<input type="number" wire:model="count"/>

<button type="button" wire:click="increment">Increment</button>
<button type="button" wire:click="decrement">Decrement</button>
```

### How the Evaluation API Processes Results

The Evaluation API is server-driven. It processes results either on page render or when triggered by Magewire updates (method calls or value syncing).

1. The customer sees a value of `0` and clicks the "increment" button.
2. The Magewire action is sent to the server, incrementing the count.
3. After the Magewire update lifecycle completes, the Evaluation API automatically re-evaluates the evaluation state.
4. Since the count is now greater than zero, the evaluation returns a Success result.
5. The Evaluation API updates the component's evaluation state, removing restrictions and marking the component as completed.

If the customer tries to navigate forward while the count is still `0`, the error message displays automatically. By default, error messages are bound to the Validation API, so they display when the customer presses the primary navigation button.

Dispatching evaluation results immediately

Some evaluation result types have a dispatch capability. You can chain the `dispatch()` method to prevent the result from being bound to a button-click trigger. This makes the message display right away when the Ajax response comes back from the server.

## Evaluation Result Type Requirements

Hyvä Checkout ships with several evaluation result types out of the box. You can find these types in `Hyva\Checkout\Model\Magewire\Component\Evaluation`. New result types have been added across different versions, so the available types may differ depending on which version you have installed.

### Backend Evaluation Result Type Class

When you implement a component with the `EvaluationInterface`, you need to include an `evaluateCompletion()` method in the component. This method automatically receives the `$resultFactory` as an argument, making it easy to generate the result you need.

The following example shows the structure of the Event result type. It demonstrates how to use capabilities (reusable traits) and define custom methods.

Event.php - Example result type implementation

```
<?php

class Event extends \Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult
{
    // Inject the required (reusable) capabilities.
    use \Hyva\Checkout\Model\Magewire\Component\Evaluation\Concern\DetailsCapabilities;
    use \Hyva\Checkout\Model\Magewire\Component\Evaluation\Concern\DispatchCapabilities;

    public const TYPE = 'event';

    private string $event = 'evaluation:event:default';

    public function getArguments(\Magewirephp\Magewire\Component $component): array
    {
        return [
            'event' => $this->event,
            'detail' => $this->getDetails($component)
        ];
    }

    // Let developers execute custom events.
    public function withCustomEvent(string $event): self
    {
        $this->event = $event;

        // Always return $this to allow method chaining.
        return $this;
    }
}
```

### Evaluation Result Type Capabilities

Capabilities are reusable traits that you can mix into different result types depending on your requirements. Each result type can have its own set of capabilities. When you use a capability, you need to define the relevant arguments in the `getArguments()` result array.

This example shows how to use the `StackingCapabilities` trait to add stack positioning to a custom result type.

CustomResultType.php - Using capabilities

```
<?php

class CustomResultType extends \Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult
{
    // Injects a 'withStackPosition' method.
    use \Hyva\Checkout\Model\Magewire\Component\Evaluation\Concern\StackingCapabilities;

    public function getArguments(Component $component): array
    {
        return [
            'stack' => [
                'position' => $this->stackPosition // $stackPosition returns 500 by default.
            ]
        ];
    }
}
```

You can find all available capabilities in `Hyva\Checkout\Model\Magewire\Component\Evaluation\Concern`.

### Frontend Evaluation Result Processor

Each evaluation result type needs its own frontend processor. A processor is a callback that runs automatically during page rendering or when the Magewire component is updated.

The following example shows the Event processor implementation. It demonstrates how to handle dispatch behavior and bind results to the Validation API.

Before 1.1.12 use `hyvaCheckout.evaluation.processors['event'] = () => {}`

Event processor - Frontend implementation

```
hyvaCheckout.evaluation.registerProcessor('event', (component, el, result) => {
    if (result.dispatch || false) {
        window.dispatchEvent(new CustomEvent(result.arguments.event, {detail: result.arguments.detail}))

        return result.result;
    }

    // Bind to the Validation API so it triggers on primary button click.
    hyvaCheckout.validation.register(
        result.hash,
        () => window.dispatchEvent(new CustomEvent(result.arguments.event, {detail: result.arguments.detail})),
        el,
        result.id
    )

    return result.result;
})
```

The callback result argument

The `result` argument has a fixed set of variables evaluated by the Hyvä Checkout Evaluation Hydrator.

- **arguments** `array`: Type arguments, which can vary per result type.
- **dispatch** `bool`: Whether to dispatch immediately or not.
- **result** `bool`: Positive or negative type result.
- **type** `string`: Result type name.
- **id** `string`: The Magewire component ID.
- **hash** `string`: SHA1 hash of the result array values.

For more details, check `\Hyva\Checkout\Model\Magewire\Component\Hydrator\Evaluation`.
