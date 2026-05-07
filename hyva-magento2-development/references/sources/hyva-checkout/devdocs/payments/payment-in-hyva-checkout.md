<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/payments/payment-in-hyva-checkout.html -->

# Payments in Hyvä Checkout

Hyvä Checkout provides a payment integration framework for implementing any payment scenario - from simple redirect methods to complex PSP SDK integrations. A Hyvä Checkout payment integration handles the frontend user interaction and complements an existing Magento Payment Method that manages backend payment processing.

Think of it this way: your Hyvä Checkout payment integration owns the customer-facing experience, while the Magento Payment Method handles everything behind the scenes.

## Key Differences Between Luma and Hyvä Checkout Payments

Understanding how payment responsibilities differ between Luma and Hyvä Checkout is essential for building integrations. The table below highlights the most important architectural changes.

| Aspect | Luma Checkout | Hyvä Checkout |
| --- | --- | --- |
| **Order placement** | Payment method places the order | [Place Order Service](../place-order-service-api/index.html) places the order |
| **Payment step position** | Must be the final step | Can be positioned on any step |
| **Data collection timing** | Collected immediately before order | Collected whenever payment step is visited |
| **Implementation approach** | JavaScript-heavy (Knockout.js) | Server-side preferred (Magewire) |

The biggest shift is that Hyvä Checkout separates order placement from payment method selection. In Luma, the payment method itself triggers order placement. In Hyvä Checkout, the [Place Order Service](../place-order-service-api/index.html) handles order placement independently.

Payment Method Position Flexibility

Because Hyvä Checkout separates order placement from payment method selection, merchants can configure additional steps after payment (e.g., order review, gift options). Payment integrations should not assume they are on the final checkout step.

## What a Hyvä Checkout Payment Integration Does

A Hyvä Checkout payment integration is responsible for four things:

- **Displaying payment UI** - Rendering forms, buttons, or PSP-provided iframes when the customer selects the payment method
- **Gathering payment data** - Collecting tokens, authorization codes, or other data required by the PSP
- **Communicating completion status** - Returning `Evaluation\Success` when ready to proceed, or `Evaluation\Blocking` when waiting for customer action
- **Storing data for order placement** - Passing payment tokens to the underlying Magento Payment Method via `additional_data`

The actual payment capture happens via the Magento Payment Method. This is the same backend processing layer used in Luma, which means existing payment gateway code can often be reused.

## Choosing a Payment Implementation Approach

Hyvä Checkout supports three approaches for building payment integrations. Choose based on your PSP's requirements and your preference as a developer.

### PHP-Driven Payments with Magewire

The Magewire approach uses server-side PHP components for payment logic. The payment template renders the UI, and the Magewire component handles state management and PSP communication through server roundtrips.

**Best for:** Payment methods with server-side token generation, redirect flows, or minimal JavaScript requirements. If your PSP provides a PHP SDK, Magewire is the natural choice.

### JavaScript-Driven Payments with the Frontend API

The JavaScript approach uses the [Frontend Payment API](../frontend-api/V1/payment.html) for payment methods that require client-side SDK integration. You register a payment method handler that manages initialization, validation, and data collection entirely in the browser.

**Best for:** PSP SDKs that must run in the browser (like Stripe.js or Braintree's hosted fields), client-side tokenization, or complex JavaScript payment flows.

Frontend Payment API Changes in 1.3.6

Version 1.3.6 introduced a rewritten Frontend Payment API with an improved developer experience. Payment methods using the new API require Hyvä Checkout 1.3.5 or higher. See the [Frontend Payment API documentation](../frontend-api/V1/payment.html) for details.

### Hybrid Payment Approach (Magewire + JavaScript)

The hybrid approach combines Magewire components with Frontend API methods. Use Magewire for server communication and state management, and JavaScript for browser-specific tasks like SDK initialization or iframe rendering.

**Best for:** Complex integrations requiring both server-side logic and client-side SDK interaction. For example, a payment method that creates a server-side session token via Magewire, then uses that token to initialize a PSP's JavaScript SDK in the browser.

## Automatic Payment Method Selection in Hyvä Checkout

When a customer selects a payment method in Hyvä Checkout, the method code is automatically stored on the quote. You don't need to write any code to handle the selection event - the checkout manages this automatically.

Your payment integration's only job is to gather additional data (tokens, authorization codes, etc.) and signal when that data collection is complete by returning the appropriate `Evaluation` result.

## Reusing Existing Magento Payment Methods with Hyvä Checkout

If a Magento Payment Method already exists for your PSP (for example, from a Luma integration), the backend PHP code for token validation, payment capture, and order processing can typically be reused as-is. Only the frontend interaction layer needs to be built for Hyvä Checkout.

The Hyvä Checkout payment component gathers customer-facing data and passes it to the existing Magento Payment Method through `additional_data` on the payment object. The Magento Payment Method then handles the actual payment processing through its standard `PaymentMethodInterface` and gateway command infrastructure.

Start with Existing Code

Before building a new Hyvä Checkout payment integration from scratch, check whether a Magento Payment Method module already exists for your PSP. If it does, you only need to build the Hyvä Checkout frontend component - all backend payment processing stays the same.

## Related Topics

- **[Payment Integrations Intro](payment-introduction.html)** - Background on payment types, PCI-DSS compliance, and how PSP integrations work in Magento
- **[Payment Integration API](payment-integration-api.html)** - How to register payment methods in layout XML, configure display properties, and implement the `EvaluationInterface`
- **[Frontend Payment API](../frontend-api/V1/payment.html)** - JavaScript API reference for building client-side payment integrations
- **[Place Order Service](../place-order-service-api/index.html)** - How order placement works independently from payment method selection
