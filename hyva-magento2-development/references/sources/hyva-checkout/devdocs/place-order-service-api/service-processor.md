<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/place-order-service-api/service-processor.html -->

# Place Order Service Processor in Hyva Checkout

The **Place Order Service Processor** in Hyva Checkout handles place order requests by matching a payment method code to the corresponding Place Order Service. The Service Processor orchestrates the full lifecycle of order placement, including execution, redirection, and exception handling.

Info

If no matching Place Order Service is found for a payment method code, the processor falls back to the default service provided by `PlaceOrderServiceProvider` at `\Hyva\Checkout\Model\Magewire\Payment\PlaceOrderServiceProvider`.

## Order Placement Happy Flow

When a customer clicks the Place Order button, the Place Order Service Processor executes the following high-level happy flow:

1. A request is made to `\Hyva\Checkout\Magewire\Main::placeOrder()`.
2. Since version 1.1.13, the `placeOrder()` method accepts Hyva Checkout session data, which is automatically passed through to the Place Order Service as `Hyva\Checkout\Model\Magewire\Payment\AbstractOrderData`.
3. The processor checks the Place Order Service `canPlaceOrder()` method, converts the session data, and runs the Place Order Service `placeOrder()` method, catching any exceptions that are thrown.
4. On success, the processor pushes an `order:place:success` window event into the Evaluation batch, which is dispatched on the frontend immediately.
5. If the Place Order Service permits a redirect, the processor adds a Redirect evaluation result to the Evaluation Batch containing the URL from the Place Order Service `getRedirectUrl()` method.

Warning

Since 1.1.13, `\Hyva\Checkout\Model\Magewire\Payment\PlaceOrderServiceProvider` has been marked as `@internal`. This object should only be used by the Main checkout component.

## Registering a Place Order Service for a Payment Method

To bind a specific Place Order Service to a payment method code, register the service in your module's dependency injection configuration. The `name` attribute of the `<item>` must match the payment method code.

etc/frontend/di.xml

```
<type name="Hyva\Checkout\Model\Magewire\Payment\PlaceOrderServiceProvider">
    <arguments>
        <argument name="placeOrderServiceList" xsi:type="array">
            <!-- The item name must match the payment method code -->
            <item name="foo" xsi:type="object">
                My\Example\Model\Payment\PlaceOrderService\FooPlaceOrderService
            </item>
        </argument>
    </arguments>
</type>
```

Info

For more details, refer to [Place Order Service API - Example scenario](index.html#example-3ds-authentication-after-order-placement).

## Exception Handling in the Service Processor

When the Place Order Service throws an exception, the Service Processor automatically dispatches two window events: `order:place:error` and `order:place:{payment_method_code}:error`. By default, no built-in frontend components listen for these events.

### Default Error Message Behavior

If the `handleException()` method of the Place Order Service re-throws the exception, the processor sets a default message: "Something went wrong while processing your order. Please try again."

To customize this message, throw an exception of type `\Magento\Framework\Exception\LocalizedException` from the `handleException()` method. The exception message is always logged, and an error message Evaluation result is added to the batch for automatic display on the frontend.

Info

For more details, refer to [Abstract Layer - Handle Exception](abstraction-layer.html#handleexception-manage-order-placement-errors).

### Exception Handling Example Scenario

Imagine you have bound a custom Place Order Service to a payment method with the code `foo`. The `placeOrder()` method throws an exception because an API call to an external service returns a 403 response. In this scenario, the quote has not yet been converted into an order, so you need to catch the error on the frontend within the payment method template.

## Displaying Errors with the Messenger Component

The **Messenger component** (`Hyva_Checkout::page/messenger.phtml`) provides a standardized way to display error and warning messages in Hyva Checkout. The Messenger component automatically listens for error events and displays messages in a unified style, without requiring custom business logic or styling.

You need to inject the Messenger component manually via layout XML, since the platform cannot determine where you want the messages to appear.

The following layout XML adds the Messenger component inside a payment method block with an `event_prefix` of `order:place`:

Layout XML for Messenger component

```
<block name="checkout.shipping.method.foo" as="foo_foo">
    <!-- The Messenger component listens for {event_prefix}:error events -->
    <block name="component-messenger-guest-details"
           template="Hyva_Checkout::page/messenger.phtml"
    >
        <arguments>
            <argument name="event_prefix" xsi:type="string">
                order:place
            </argument>
        </arguments>
    </block>
</block>
```

The `event_prefix` argument makes the Messenger component automatically listen for any `{event_prefix}:error` events. The Service Processor dispatches these events automatically when an exception occurs during order placement.

### Customizing the Error Message via handleException

To show a more specific error message, override the `handleException()` method in your custom Place Order Service. Throwing a `LocalizedException` lets you control the exact message displayed to the customer.

Custom handleException in Place Order Service

```
<?php

public function handleException(
    \Exception $exception,
    \Magewirephp\Magewire\Component $component,
    \Magento\Quote\Model\Quote $quote
): void {
    // Check for a specific exception type to provide a targeted message
    if ($exception instanceof \My\Example\Exceptions\AuthenticationFailureException) {
        throw new \Magento\Framework\Exception\LocalizedException(
            __('Unable to authenticate to the payment gateway. Please try again.')
        );
    }

    // Fall back to default behavior for all other exceptions
    parent::handleException($exception, $component, $quote);
}
```

### Dispatching a Custom Event with Additional Data

For more flexibility, you can push a custom event onto the Evaluation Result Batch with additional details. This approach lets the frontend handle the error with richer context beyond a simple message.

The following example dispatches a `my:custom:event` window event with the exception code and gateway name, in addition to the localized error message:

Custom event with details in handleException

```
<?php

public function handleException(
    \Exception $exception,
    \Magewirephp\Magewire\Component $component,
    \Magento\Quote\Model\Quote $quote
): void {
    if ($exception instanceof \My\Example\Exceptions\AuthenticationFailureException) {
        // Push a custom event with details onto the Evaluation Result Batch
        $component->getEvaluationResultBatch()
            ->push($component->getEvaluationResultBatch()->getFactory()
                ->createEvent('my:custom:event')
                ->withDetails([
                    'code' => $exception->getCode(),
                    'gateway' => $exception->getGateway()
                ])
            );

        // Also throw a localized message for the Messenger component
        throw new \Magento\Framework\Exception\LocalizedException(
            __('Unable to authenticate to the payment gateway. Please try again.')
        );
    }

    parent::handleException($exception, $component, $quote);
}
```

The `my:custom:event` event is dispatched onto the `window` with the custom details you provided.

## Listening for Custom Events on the Frontend

While the Messenger component is the recommended approach for displaying error and warning messages, you can also build fully custom solutions by listening for events directly.

This approach gives you complete control over how errors are presented, which can help guide customers toward resolving the issue themselves.

Custom event listener in a payment method template

```
<script>
    // Listen for the custom event dispatched by the Service Processor
    window.addEventListener('my:custom:event', event => {
        // Access event.detail for the custom data (code, gateway, etc.)
    })
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

## Using Evaluation Results for Advanced Error Handling

The Evaluation API is flexible enough to handle a wide range of scenarios. You can inject custom results or use the built-in result types, which are continually improved and expanded.

In a Place Order Service, you add Evaluation results to the pre-created batch on the `$component`. The batch object provides a `getFactory()` method for creating result objects.

The following example creates an `Executable` evaluation result inside `handleException()`:

Creating an Evaluation result in handleException

```
<?php

public function handleException(
    \Exception $exception,
    \Magewirephp\Magewire\Component $component,
    \Magento\Quote\Model\Quote $quote
): void {
    // Get the factory from the Evaluation Result Batch
    $factory = $component->getEvaluationResultBatch()->getFactory();
    // Create the required result (e.g., an Executable)
    $executable = $factory->createExecutable('foo_exception');
    // Push the result onto the batch stack
    $component->getEvaluationResultBatch()->push($executable);

    ...
}
```

Info

For more details, refer to [Evaluation API - Evaluation result types](../evaluation-api/evaluation-result-types.html).
