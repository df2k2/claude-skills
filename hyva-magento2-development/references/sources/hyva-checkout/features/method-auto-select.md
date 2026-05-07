<!-- source: https://docs.hyva.io/hyva-checkout/features/method-auto-select.html -->

# Hyvä Checkout Method Auto-Select

Hyvä Checkout's method auto-select feature automatically pre-selects the first available shipping or payment method during checkout. This saves your customers a click and speeds up the checkout flow.

Experimental Feature

Method auto-select is currently flagged as experimental. The behavior may change in future releases.

## Admin Configuration for Method Auto-Select

You can configure method auto-select in the Magento admin under `Stores -> Settings -> Configuration -> Hyvä Themes -> Checkout`. Both payment and shipping auto-selection live under the `Developer -> Experimental` path.

### Auto-Select First Available Payment Method

**Path:** `Developer -> Experimental`

**Default Value:** `No`

When you enable this option, Hyvä Checkout automatically pre-selects the first available payment method when the customer reaches the payment step. Payment method availability is evaluated when the customer initializes the checkout for the first time within their current [checkout session](../glossary.html#checkout-session).

Once a customer picks a different payment method, the auto-select feature won't override that choice. If the customer navigates away and returns, the previously selected payment method stays in place. The same applies when available payment methods change dynamically during the checkout journey - auto-select will **not** update the selection, even if the first method in the list has changed. The one exception: if only a single payment method is available, Hyvä Checkout will auto-select it regardless.

### Auto-Select First Available Shipping Method

**Path:** `Developer -> Experimental`

**Default Value:** `No`

When you enable this option, Hyvä Checkout automatically pre-selects the first available shipping method when the customer reaches the shipping step. Shipping method availability is evaluated when the customer initializes the checkout for the first time within their current [checkout session](../glossary.html#checkout-session).

Just like payment auto-select, once a customer picks a different shipping method, auto-select won't override that choice. If the customer navigates away and returns, the previously selected shipping method stays in place. When available shipping methods change dynamically during the checkout journey, auto-select will **not** update the selection, even if the first method in the list has changed.

## Implementation Details for Method Auto-Select

### Checkout Initialization and Auto-Select Timing

The Hyvä Checkout initialization only runs once per [checkout session](../glossary.html#checkout-session). This is handled by the `Hyva\Checkout\Controller\Index\Index::initCheckout()` method. Because initialization runs only once, method auto-select evaluates available methods at that single point in time rather than on every page load.

### Where Auto-Select Logic Lives

The generic method auto-selection logic is handled by the `Hyva\Checkout\Observer\Frontend\HyvaCheckoutHyvaCheckoutInitAfter` observer. This observer runs during checkout initialization and selects the first available shipping and payment methods.

The dynamic single-method auto-selection for payment methods lives in the `Hyva\Checkout\Magewire\Checkout\Payment\MethodList` component's `boot()` method. This separate piece of logic auto-selects a payment method when it's the only one available, which is especially useful for the [Zero Subtotal Checkout](zero-subtotal-checkout.html) feature. If a similar use case comes up for shipping methods, this dynamic auto-selection may be expanded to cover those as well.

## Related Topics

- **[Zero Subtotal Checkout](zero-subtotal-checkout.html)** - Works hand-in-hand with payment method auto-select when only one payment option is available
- **[Checkout Glossary](../glossary.html)** - Definitions of key terms like checkout session
