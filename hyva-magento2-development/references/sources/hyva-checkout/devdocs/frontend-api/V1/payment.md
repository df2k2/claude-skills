<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/V1/payment.html -->

# Payment Method Registration API for Hyvä Checkout

**Since:** 1.0.0

The `hyvaCheckout.payment` sub-namespace provides methods for registering and managing JavaScript-driven payment methods in Hyvä Checkout. Payment methods can be implemented in two ways: server-side using a **Place Order Service** (recommended), or client-side using this Frontend Payment API.

Version Compatibility

The Payment API was significantly improved in version `1.3.6`. Payment methods using this enhanced API require Hyvä Checkout `1.3.5` or higher. Consider your target audience's upgrade path when choosing implementation approaches.

Stay Current

Upgrading to the latest version gives you improved stability, performance, and security. Not all merchants can upgrade immediately, so plan your implementation accordingly.

## Examples

- [JS-driven Payment Method](../../../examples/js-payment-method.html)

## registerMethod

`hyvaCheckout.payment.registerMethod` registers a JavaScript-driven payment method with the Hyvä Checkout system. Since version `1.3.6`, registered methods are automatically activated when selected - no manual activation required.

**Since:** 1.3.6

**Parameters:**

- `options` (object) - Configuration object for the payment method
  - `code` (string, required) - Unique identifier matching the Magento payment method code
  - `method` (object, required) - Payment method implementation with optional override methods

**Returns:**

- `object` - The registered payment method object

### Payment Method Override Functions

All methods in the `method` object are optional. Each override receives relevant context and can return Promises for async operations. The available overrides let you control initialization, validation, order placement, error handling, and post-order redirect behavior.

The following example shows all available override methods with inline comments explaining each method's purpose and when it runs.

Complete payment method registration with all available overrides

Payment Method Registration with All Available Methods

```
<script>
    (() => {
        hyvaCheckout.payment.registerMethod({
            // Payment method code must match Magento's payment method code exactly
            code: 'my_payment_method',

            method: {
                /**
                 * Runs when the payment method is initialized or re-activated.
                 * Called when: method is selected, user navigates to the payment step,
                 * or (Checkout 3.x) a refresh of the method list switches the selection to this method.
                 * Use for: SDK initialization, iframe loading, event listener setup.
                 */
                initialize: async function() {
                    console.log('Initializing payment method:', this.code);
                },

                /**
                 * Runs when the payment method is deactivated or cleaned up.
                 * Called when: switching to another payment method or checkout step.
                 * Use for: removing event listeners, clearing intervals, resetting state.
                 */
                uninitialize: async function() {
                    console.log('Cleaning up payment method:', this.code);
                },

                /**
                 * Validates the payment method before step progression.
                 * Registered automatically via hyvaCheckout.validation.
                 * NOTE: Does NOT run before placeOrder unless payment is on the final step.
                 * For pre-order validation, perform checks inside placeOrder instead.
                 */
                validate: async function() {
                    // Return false to prevent step progression
                    // Alert the customer using hyvaCheckout.messenger API on failure
                    return true;
                },

                /**
                 * Primary order placement handler.
                 * The fallback parameter contains the default server-side Place Order Service.
                 * Options: use fallback entirely, implement custom logic, or combine both.
                 */
                placeOrder: async function({ fallback }) {
                    console.log('Custom pre-order logic completed.');
                    // Call fallback() to use default Magewire-driven order placement. Await it, so a
                    // failure reaches handleException().
                    await fallback();
                },

                /**
                 * Determines if order placement should proceed.
                 * Return false to hold the order: placeOrder() isn't called.
                 * If canRedirect() returns true, the customer is sent to getRedirectUrl().
                 * Otherwise, on Checkout 3.x, the order counts as not placed and the
                 * Place Order button is enabled again. Checkout 1.x reports it as placed.
                 */
                canPlaceOrder: async function() {
                    return true;
                },

                /**
                 * Handles exceptions during order placement.
                 * Either handle the exception entirely (managing UX yourself),
                 * or call fallback({ exception }) to use default error handling.
                 */
                handleException: async function({ exception, fallback }) {
                    console.error('Order placement failed:', exception);
                    // Default error handling. On Checkout 3.x it shows "Something went wrong
                    // while placing the order. Please try again." in the payment messenger,
                    // unless the server already reported the refusal.
                    await fallback({ exception });
                },

                /**
                 * Determines if redirect should occur after order placement.
                 * Normally returns true. Return false only when quote hasn't
                 * converted to an order yet (rare edge case).
                 * WARNING: Returning false is not recommended as checkout components
                 * rely on the quote which becomes unavailable after order placement.
                 */
                canRedirect: async function() {
                    return true;
                },

                /**
                 * Returns the post-order redirect URL.
                 * Return: internal path (e.g., '/checkout/success') or
                 * full URL (e.g., 'https://payment-gateway.com/complete?order=123').
                 * The fallback parameter provides the default success page URL.
                 */
                getRedirectUrl: async function({ fallback }) {
                    return fallback();
                }
            }
        });
    })();
</script>
```

### placeOrderButton

Checkout 3.x only

`placeOrderButton()` is available on Hyvä Checkout 3.x (Magewire 3). The method object on Checkout 1.x has no such override.

`placeOrderButton()` returns the settings of the Place Order button for your payment method. The object currently holds one key, `label`. When you don't override it, the default returns the label "Place Order".

The following snippet shows the override inside the `method` object passed to `registerMethod()`.

Overriding placeOrderButton() (Checkout 3.x)

```
method: {
    // ... other overrides ...

    placeOrderButton: async function() {
        return {
            label: 'Pay with My Payment Method'
        };
    }
}
```

## getActive

`hyvaCheckout.payment.getActive` returns the currently active payment method object that handles order placement, or `null` if no method is active.

The active method follows the method saved on the quote. On Checkout 3.x, a method activated only in the browser, without saving it to the quote, is switched back to the quote's method on the next refresh of the payment method list.

**Returns:**

- `object` - The active payment method object
- `null` - If no payment method is currently active

## hasActive

`hyvaCheckout.payment.hasActive` checks whether a payment method is currently active in Hyvä Checkout.

**Returns:**

- `boolean` - `true` if a payment method is active, `false` otherwise

Checkout 1.x: hasActive() returns false

On Checkout 1.x (1.3.15 and older), `hasActive()` checks the method code against an array index, so it returns `false` even while a registered method is active. Use `hyvaCheckout.payment.getActive() !== null` instead. Checkout 3.x fixes this, and `hasActive()` works as described.

## Placing the Order With hyvaCheckout.order.place

`hyvaCheckout.order.place()` places the order, as the Place Order button does. It runs the pending navigation tasks and validations, then hands the order to the active payment method (`canPlaceOrder()`, `placeOrder()`, `canRedirect()`, `getRedirectUrl()`).

**Returns:**

- `Promise` - Resolves with `{result: true}` when the order was placed, and with `false` when a validation failed, the payment method held the order without redirecting (Checkout 3.x), or placing failed

On Checkout 3.x, a call made while an order is being placed returns that placement instead of starting another one. A wallet or smart button that places the order itself should run `hyvaCheckout.validation.validate()` first, so the customer answers a Place Order reCAPTCHA before the payment flow opens.

## getDefaultMethod

`hyvaCheckout.payment.getDefaultMethod` returns the default order placement handler. This is the same handler provided as the `fallback` parameter inside `placeOrder`. The default handler executes the core Place Order Service logic via Magewire on the server.

**Since:** 1.3.6

**Returns:**

- `object` - The default method defined in `hyvaCheckout.config` at path `payment.method_default`

## getByCode

`hyvaCheckout.payment.getByCode` retrieves a registered payment method by its Magento payment method code.

**Parameters:**

- `code` (string, required) - The payment method code to search for

**Returns:**

- `object` - The registered payment method object if found
- `null` - If no method is registered for the given code

## Deprecated Methods

The following methods were deprecated in version 1.3.6 and should not be used in new implementations.

### ~~activate~~

**Deprecated:** Since 1.3.6

**Reason:** `registerMethod` now handles activation automatically. The Hyvä Checkout system selects the appropriate registered method during order placement, eliminating potential conflicts from manual activation.

Since version 1.3.7, check `__viaHcPaymentActivate = true` on the method object to identify legacy JavaScript payment methods that still use this deprecated approach.

### ~~isVisibleInStep~~

**Deprecated:** Since 1.3.6

**Reason:** Hyvä Checkout's flexible architecture allows payment methods across multiple steps, making DOM visibility unreliable. Payment implementations should be data-driven rather than dependent on DOM element states.

**Security note:** Payment methods operate differently and require different data protection approaches. Hyvä Checkout intentionally does not prescribe how or where sensitive data should be stored - that decision belongs to the developer. This implementation variety inherently enhances security by avoiding predictable patterns.

### ~~placeOrderViaJs~~

**Deprecated:** Since 1.3.6

**Reason:** Since version 1.3.6, all orders are placed via JavaScript. The active registered method handles placement (falling back to the default if needed), eliminating the need to distinguish between JS-driven and server-driven methods.

### ~~isWireComponent~~

**Deprecated:** Since 1.3.6

**Reason:** While Magewire is the primary engine behind Hyvä Checkout, the API no longer prescribes specific implementation technologies. Developers choose their own approach, with the option to fall back on default Magewire-driven implementation. The underlying technology is abstracted, allowing future architectural evolution without breaking existing integrations.
