<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/V1/api.html -->

# Hyva Checkout API Initialization and Execution Order Control

**Since:** 1.3.3

The `hyvaCheckout.api` sub-namespace in the Hyva Checkout Frontend API provides methods for controlling the timing and execution order of JavaScript code during checkout initialization. These methods ensure that custom code - such as validators, payment handlers, and event listeners - runs only after the Hyva Checkout Frontend API is fully initialized, preventing race conditions and undefined reference errors.

The `hyvaCheckout.api` namespace exposes two key methods: `hyvaCheckout.api.after` for standard callback registration, and `hyvaCheckout.api.priority` for core-level early execution.

## Registering Callbacks After API Initialization with `hyvaCheckout.api.after`

The `hyvaCheckout.api.after` method registers a callback to execute once the Hyva Checkout Frontend API has fully initialized. If the Hyva Checkout Frontend API is already initialized when `hyvaCheckout.api.after` is called, the callback executes immediately. The `hyvaCheckout.api.after` method is essential when registering custom validators, payment handlers, or any code that depends on `hyvaCheckout` sub-namespaces being available.

Use the `checkout:init:after` window event when you simply want to execute code independently of any result and with the certainty that everything belonging to the Hyva Checkout Frontend API has run. See the [Frontend API Events](../events.html) page for details.

### Parameters for `hyvaCheckout.api.after`

`hyvaCheckout.api.after` accepts the following parameters:

- `callback` (callable, required) - The callback function that executes as soon as the Hyva Checkout Frontend API is initialized.
- `options` (object, optional)
  - `stackPosition` (int, optional) - Controls execution order; lower `stackPosition` values run first. Default `stackPosition` is `500`.

### Return Value of `hyvaCheckout.api.after`

`hyvaCheckout.api.after` returns a `Promise<void>` that resolves after the callback has executed. This Promise allows chaining additional logic after the callback completes.

### Example: Registering a Custom Validator with `hyvaCheckout.api.after`

The following example demonstrates registering a custom checkout validator using `hyvaCheckout.api.after`. The `stackPosition` option is set to `400` so the validator runs before callbacks using the default `stackPosition` of `500`.

Custom validator registration with stackPosition control

Registering a validator with hyvaCheckout.api.after

```
<script>
    (() => {
        // Set stackPosition to 400 so this callback runs before
        // callbacks with the default stackPosition of 500
        const options = {
            stackPosition: 400
        };

        const callback = () => {
            // Register a custom async validator using the
            // hyvaCheckout.validation.register method
            hyvaCheckout.validation.register(
                'sensible-validation-name',
                async () => {
                    // Simulate an async API call with a 2-second delay
                    await new Promise(resolve => setTimeout(resolve, 2000));

                    // Simulate a random validation result (true or false)
                    const valid = Math.random() < 0.5;

                    // When validation fails, the developer must handle the
                    // error - for example, display a message using the
                    // hyvaCheckout.messenger API
                    if (valid === false) {
                        console.log(
                            'Validation failed - implement error handling here.'
                        );
                    }

                    // Validators must return true (valid) or false (invalid)
                    return valid;
                }
            );
        };

        // Wait for Hyva Checkout Frontend API initialization,
        // then register the validator
        hyvaCheckout.api.after(callback, options)
            .then(() => console.log('Validator registration complete.'));
    })();
</script>
```

## Priority Callback Registration with `hyvaCheckout.api.priority`

**Since:** 1.3.4

The `hyvaCheckout.api.priority` method is reserved for core contributions only. It is documented here for awareness and understanding of the Hyva Checkout execution order system.

The `hyvaCheckout.api.priority` method allows core systems to execute callbacks before standard registered callbacks. The `hyvaCheckout.api.priority` method wraps `hyvaCheckout.api.after` with a fixed `stackPosition` of `20`, ensuring priority callbacks run before those registered via `hyvaCheckout.api.after` (which default to `stackPosition: 500`).

Priority `stackPosition` values below `20` are reserved for Hyva Checkout core and should not be used in custom implementations.

### Example: Priority Callback Execution Order

The following example shows how `hyvaCheckout.api.priority` callbacks execute before standard `hyvaCheckout.api.after` callbacks.

hyvaCheckout.api.priority callback execution order

Priority method usage (core only)

```
<script>
    (() => {
        // Reserved for core contributions only -
        // executes before hyvaCheckout.api.after callbacks
        hyvaCheckout.api.priority(
            () => console.log('Runs before hyvaCheckout.api.after callbacks')
        ).then(() => console.log('Priority callback execution complete.'));
    })();
</script>
```

## Related Topics

- **[Hyva Checkout Frontend API Events](../events.html)** - Window events dispatched during checkout initialization, including `checkout:init:after`
- **[Hyva Checkout Frontend API Overview](../index.html)** - Overview of all `hyvaCheckout` sub-namespaces
- **[Hyva Checkout Evaluation API](evaluation.html)** - Methods for evaluating checkout state and validation results
- **[Hyva Checkout Payment API](payment.html)** - Methods for registering and managing payment handlers
