<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/place-order-service-api/abstraction-layer.html -->

# Place Order Service Abstraction Layer

The Hyvä Checkout place order service abstraction layer handles the heavy lifting of order placement so you can focus on customization. When building a custom place order service, always extend this abstraction layer rather than implementing the interface from scratch.

The abstraction layer provides default implementations for each method. You can override only the methods that need custom behavior for your payment method or workflow.

## API Methods

### placeOrder - Submit the Quote as an Order

The `placeOrder` method receives the active Magento quote and is responsible for converting it into a placed order. It must return the reserved order ID as an integer when `canPlaceOrder()` returns `true`.

The default implementation delegates to Magento's cart management service:

```
public function placeOrder(\Magento\Quote\Model\Quote $quote): int
{
    // Delegates to Magento's CartManagement to convert the quote to an order
    // and returns the numeric order ID
    return (int) $this->cartManagement->placeOrder($quote->getId(), $quote->getPayment());
}
```

**Returns:** `int` - the reserved order ID

### canPlaceOrder - Control Whether Order Placement Proceeds

The `canPlaceOrder` method determines whether the place order flow should run or whether the quote should remain as-is. Return `false` when an external payment gateway will create the order via the Magento API after payment is confirmed - for example, when the gateway calls back with the quote ID after the customer completes payment on an external page.

**Returns:** `bool`

### handleException - Manage Order Placement Errors

The `handleException` method is called when any exception occurs during the order placement process. By default, the abstraction layer rethrows the exception so the place order service processor can catch it, log it as an error, and dispatch the message to the frontend via the Main component as an [error message evaluation result](../evaluation-api/evaluation-result-types.html#errormessage).

Localization support

When the rethrown exception is an instance of `\Magento\Framework\Exception\LocalizedException`, Hyvä Checkout automatically handles localization of the error message.

The default implementation rethrows the exception unchanged:

```
public function handleException(\Exception $exception, \Magewirephp\Magewire\Component $component, \Magento\Quote\Model\Quote $quote): void
{
    throw $exception;
}
```

Override it to control what the customer sees. Don't wrap an arbitrary exception's message in a `LocalizedException`: gateway and system errors can carry technical details that shouldn't reach the customer. Rethrow a `LocalizedException` as it is, and replace anything else with a message of your own:

```
public function handleException(\Exception $exception, \Magewirephp\Magewire\Component $component, \Magento\Quote\Model\Quote $quote): void
{
    if ($exception instanceof \Magento\Framework\Exception\LocalizedException) {
        throw $exception;
    }

    throw new \Magento\Framework\Exception\LocalizedException(
        __('We could not place your order. Please try again or choose another payment method.'),
        $exception
    );
}
```

**Returns:** `void`

### canRedirect - Control Post-Order Redirection

The `canRedirect` method controls whether the customer should be redirected after the order process completes. Return `true` to enable redirection; the target URL is provided by `getRedirectUrl()`.

**Returns:** `bool`

### getRedirectUrl - Provide the Post-Order Redirect Target

The `getRedirectUrl` method returns the URL the customer should be sent to after order placement, provided `canRedirect()` returns `true`. The URL can be a Magento route path or an absolute URL (for example, an external payment gateway URL). The Hyvä Checkout frontend handles the redirection automatically.

**Returns:** `string`

### evaluateCompletion - Return Frontend Instructions After Order Placement

Available since Hyvä Checkout 1.1.13

The `evaluateCompletion` method returns an `EvaluationResult` that tells the Hyvä Checkout frontend what to do after the order is placed. By default, the abstraction layer returns a [success](../evaluation-api/evaluation-result-types.html#success) result. The place order service processor automatically appends a [redirect](../evaluation-api/evaluation-result-types.html#redirect) result if `canRedirect()` is `true` and no redirect result is already present in the batch.

The following example shows a customized `evaluateCompletion` that adds an error message when no order ID is available:

```
public function evaluateCompletion(\Hyva\Checkout\Model\Magewire\Component\EvaluationResultFactory $resultFactory, ?int $orderId = null): \Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult
{
    // Start with a success result as the base of the batch
    $batch = $resultFactory->createBatch([$resultFactory->createSuccess()]);

    // If no order ID is available, push an error message into the batch
    if ($orderId === null) {
        $batch->push($resultFactory->createErrorMessage('No order ID known...'));
    }

    return $batch;
}
```

**Returns:** `\Hyva\Checkout\Model\Magewire\Component\Evaluation\EvaluationResult`

See [Evaluation Result Types](../evaluation-api/evaluation-result-types.html) for the full list of available result types and their behavior.

### getData - Access Browser Session Storage Data

Available since Hyvä Checkout 1.1.13

The `getData` method returns data that was passed to the `Main` component from the browser session storage. Set this data on the frontend using `hyvaCheckout.storage.setValue()`. This data is provided exclusively to the place order service for handling and is not stored anywhere else in Hyvä Checkout.

**Returns:** `\Hyva\Checkout\Model\Magewire\Payment\AbstractOrderData`

## Related Topics

- **[Place Order Service API Overview](index.html)** - How to create and register a custom place order service
- **[Evaluation Result Types](../evaluation-api/evaluation-result-types.html)** - All available evaluation results for controlling frontend behavior after order placement
