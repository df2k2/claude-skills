<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/events.html -->

# Hyvä Checkout Frontend API Events

The Hyvä Checkout Frontend API dispatches JavaScript events at key points during the checkout lifecycle. You can hook into these events to run custom code after initialization, during step navigation, when shipping or payment methods are selected, or when session storage changes.

All Hyvä Checkout events are dispatched on the `window` object using the standard browser `CustomEvent` API.

## Listening for Hyvä Checkout Events

CSP authorization required on checkout pages

Hyvä Checkout enforces strict CSP on all checkout pages. Any `<script>` block containing event listeners must include `<?php $hyvaCsp->registerInlineScript() ?>` immediately after the closing `</script>` tag. See [CSP Script Authorization](../csp/csp-script-validation.html) for details.

To listen for a Hyvä Checkout event, use `window.addEventListener()` with the event name. Event data is available through the `event.detail` property.

Basic Hyvä Checkout event listener pattern

```
window.addEventListener('checkout:event:name', (event) => {
    // Access event data via event.detail
    console.log(event.detail);
});
```

## Checkout API Initialization Events

The Hyvä Checkout API initializes in stages. Each sub-namespace (`storage`, `evaluation`, `payment`, `validation`, `navigation`, `messenger`, `main`, and `config`) becomes available at a different time. Initialization events let you run code the moment a specific part of the API is ready.

### `checkout:init:*` - Sub-namespace Initialization

Listen for a specific Hyvä Checkout sub-namespace to finish initializing by replacing `*` with the namespace name. Available namespaces: `storage`, `evaluation`, `payment`, `validation`, `navigation`, `messenger`, `main`, and `config`.

This is useful when your integration depends on a single namespace and doesn't need to wait for the full API.

Wait for the storage sub-namespace to initialize

```
window.addEventListener('checkout:init:storage', () => {
    // The hyvaCheckout.storage namespace is now available
    console.log('Storage initialized');
});
```

### `checkout:init:after` - All Sub-namespaces Initialized

The `checkout:init:after` event fires when all Hyvä Checkout API sub-namespaces are ready. This is the most common initialization event for general integrations - if you're not sure which event to use, start here.

### `checkout:init:done` - Final Initialization Complete

The `checkout:init:done` event fires after all `checkout:init:after` handlers have finished executing. Use `checkout:init:done` only in rare scenarios where your code must run after every other initialization callback has completed.

## Checkout Session Storage Events

Hyvä Checkout session storage events fire when data in the checkout session storage changes. Use these events to react to data updates made by other checkout components.

### `checkout:storage:changed` - Storage Value Modified

The `checkout:storage:changed` event fires whenever any value in the Hyvä Checkout session storage is added, updated, or removed. Use this event to synchronize your UI state with storage changes made by other checkout components.

## Checkout Validation Events

Hyvä Checkout validation events provide visibility into the validation system's registration and execution lifecycle.

### `checkout:validation:register` - Validator Registered

The `checkout:validation:register` event fires when a validation callback is registered with the validation stack. This event is primarily useful for debugging or for tracking which validators are currently active.

After a validation run, Hyvä Checkout dispatches `checkout:validation:success`, `checkout:validation:failure` or `checkout:validation:exception`. Their `event.detail` holds the validated `step`, and on Checkout 3.x also the step's `route`, which can differ from its name.

## Checkout Step Navigation Events

Hyvä Checkout navigation events fire during checkout step transitions. Use these events to run code when customers move between checkout steps or when a step finishes loading.

### `checkout:step:loaded` - Step Content Rendered

The `checkout:step:loaded` event fires when a Hyvä Checkout step has finished loading and is visible to the customer. The event payload distinguishes between the initial page load (`preceding`) and dynamic navigation (`subsequent`).

| Payload Property | Type | Description |
| --- | --- | --- |
| `event.detail.route` | string | The step identifier (e.g., `shipping`, `payment`) |
| `event.detail.subsequent` | boolean | `true` for navigation, `false` for initial page load |

The following example shows how to detect whether a step was loaded on initial page render or through customer navigation.

Track how a checkout step was loaded

```
window.addEventListener('checkout:step:loaded', (event) => {
    // Distinguish between initial page load and navigation
    const loadType = event.detail.subsequent ? 'navigation' : 'initial';
    console.log(`Step "${event.detail.route}" loaded via ${loadType}`);
});
```

### `checkout:navigation:success` - Step Navigation Completed

The `checkout:navigation:success` event fires after a customer successfully navigates to the next or previous step. Unlike `checkout:step:loaded`, this event does **not** fire for the initial step shown on page load - it only fires for explicit navigation actions.

## Checkout Shipping Method Events

Hyvä Checkout shipping events fire when customers interact with shipping method options. Use these events to trigger shipping-related integrations or update UI elements based on the selected shipping method.

### `checkout:shipping:method-activate` - Shipping Method Selected

The `checkout:shipping:method-activate` event fires when a customer selects a shipping method or when the shipping step renders with a pre-selected method. The event payload contains the shipping method code.

| Payload Property | Type | Description |
| --- | --- | --- |
| `event.detail.method` | string | The selected shipping method code |

The following example shows how to react when a shipping method is selected in Hyvä Checkout.

React to shipping method selection in Hyvä Checkout

```
window.addEventListener('checkout:shipping:method-activate', (event) => {
    console.log(`Selected shipping method: ${event.detail.method}`);
    // Trigger delivery date picker, update totals display, etc.
});
```

## Checkout Payment Method Events

Hyvä Checkout payment events fire during payment method interactions. Use these events to coordinate PSP SDK initialization, track method selection, or respond to payment component state changes.

### `checkout:payment:method-activate` - Payment Method Selected

The `checkout:payment:method-activate` event fires when a customer selects a payment method, when the payment step renders with a pre-selected method, or, on Checkout 3.x, when the payment method list refreshes and the quote holds another method. The event payload contains the payment method code.

| Payload Property | Type | Description |
| --- | --- | --- |
| `event.detail.method` | string | The selected payment method code |

The following example shows how to initialize a PSP SDK when a specific payment method is selected.

Initialize PSP SDK on payment method selection

```
window.addEventListener('checkout:payment:method-activate', (event) => {
    if (event.detail.method === 'my_psp_method') {
        // Initialize the PSP SDK when this method is selected
        initializeMyPspSdk();
    }
});
```

### `payment:method:registered` - Payment Method Available

The `payment:method:registered` event fires when a JavaScript-driven payment method is registered with the Hyvä Checkout Frontend API. Use this event to verify that payment integrations have loaded correctly.

### `payment:method:success` - Payment Component Ready

The `payment:method:success` event fires when the payment component has rendered successfully without backend errors. This confirms the payment step is ready for customer interaction - a method is selected and no validation errors are present.

## Checkout Evaluation Events

Hyvä Checkout evaluation events provide insight into the [Evaluation API](../evaluation-api/index.html) processing cycle. These events are primarily useful for debugging or advanced integration scenarios.

### `checkout:evaluation-process:after` - Evaluation Results Processed

The `checkout:evaluation-process:after` event fires after all evaluation results from the backend have been processed by the frontend. In most cases, you won't need this event - use specific validation or navigation events instead. However, if you need to know when a particular evaluation result has finished processing, `checkout:evaluation-process:after` provides that visibility.

## Checkout Utility Events

Hyvä Checkout utility events provide general-purpose functionality that any component can trigger or observe.

### `clear-messages` - Clear Flash Messages

Dispatch the `clear-messages` event to clear all flash messages currently displayed on the Hyvä Checkout page. Components displaying custom messages can also listen for this event to clear their own message displays.

Clear and listen for Hyvä Checkout flash messages

```
// Dispatch to clear all messages
window.dispatchEvent(new Event('clear-messages'));

// Listen to clear custom component messages
window.addEventListener('clear-messages', () => {
    myComponent.clearCustomMessages();
});
```

## Related Topics

- **[Frontend API Overview](index.html)** - Architecture and general usage of the Hyvä Checkout Frontend API
- **[Frontend API Architecture](architecture.html)** - How the Frontend API sub-namespaces are structured
- **[Evaluation API](../evaluation-api/index.html)** - Backend evaluation processing that triggers evaluation events
- **[Payment Integration](../payments/payment-integration-api.html)** - Building payment integrations that use payment events
- **[Shipping Integration API](../shipping/shipping-integration-api.html)** - Building shipping integrations that use shipping events
- **[Magento Events in Hyvä Checkout](../miscellaneous/magento-events.html)** - Server-side Magento events available in Hyvä Checkout
