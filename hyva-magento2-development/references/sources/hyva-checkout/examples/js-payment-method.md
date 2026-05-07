<!-- source: https://docs.hyva.io/hyva-checkout/examples/js-payment-method.html -->

# JS-driven Payment Method

Hyvä Checkout supports JavaScript-driven payment methods registered via the frontend Payment API. This page shows practical examples for building a JS-driven payment method, from a minimal registration to advanced patterns like validation, redirects, and Magewire integration.

Requires Hyvä Checkout 1.3.5 or higher

The `hyvaCheckout.payment.registerMethod` API shown on this page was significantly improved in version `1.3.5`. Using it means developers need to upgrade their entire checkout to at least `1.3.5`. If you're targeting earlier versions, use the `activate` method as an alternative. We always recommend upgrading to the latest version for improvements in stability, performance, and security.

For full API reference details, see the [Payment API documentation](../devdocs/frontend-api/V1/payment.html).

This page assumes you've already created a payment method named `hyva` using the official Magento developer documentation.

## Minimal JS Payment Method Registration

The simplest Hyvä Checkout JS payment method requires just one JavaScript file that registers the method with the frontend API. A renderer template is optional and only needed when you want to display UI elements like a form.

### Register a Renderer Template (Optional)

To render custom UI for your payment method, register a block in the `checkout.payment.methods` container. The `as="{method_code}"` alias maps your block to the correct payment method.

Example\_Module::view/frontend/layout/hyva\_checkout\_components.xml

```
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
>
    <body>
        <referenceBlock name="checkout.payment.methods">
            <block name="checkout.payment.method.hyva"
                   as="hyva"
                   template="Example_Module::hyva-checkout/payment/method/hyva.phtml"
            >
                <arguments>
                    <!-- Optional: attach a Magewire component to the renderer block -->
                    <argument name="magewire" xsi:type="object">
                        Example\Module\Magewire\Payment\Method\Hyva
                    </argument>
                </arguments>
            </block>
        </referenceBlock>
    </body>
</page>
```

Keep the renderer template as minimal as possible and keep JavaScript in a separate file:

Example\_Module::hyva-checkout/payment/method/hyva.phtml

```
<div>
    Hyvä Payment Method.
</div>
```

### Register the Payment Method with JavaScript

To register the payment method on the frontend, add a custom block with a JavaScript template to the `hyva.checkout.api-v1.payment-methods` container.

Example\_Module::view/frontend/layout/hyva\_checkout\_index\_index.xml

```
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
>
    <body>
        <referenceContainer name="hyva.checkout.api-v1.payment-methods">
            <block name="hyva.checkout.alpinejs.payment-method-hyva"
                   template="Example_Module::hyva/checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml"
            />
        </referenceContainer>
    </body>
</page>
```

Use `hyvaCheckout.api.after()` to register a callback that runs once the Hyvä Checkout frontend API is fully initialized. This is best practice for all custom code that relies on `hyvaCheckout` subsections, not just payment methods.

Example\_Module::hyva/checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml

```
<script>
    (() => {
        // Wait for the Hyvä Checkout frontend API to fully initialize before registering.
        hyvaCheckout.api.after(() => {
            hyvaCheckout.payment.registerMethod({
                code: 'hyva', // Must match the payment method code in Magento

                method: {
                    // Called when the customer selects this payment method.
                    initialize: async function () {
                        console.log('Hyvä Payment: method initialized.');
                    },
                    // Called when the customer switches away from this payment method.
                    uninitialize: async function () {
                        console.log('Hyvä Payment: method un-initialized.');
                    },
                    // Called when the customer clicks Place Order. Use fallback() to proceed with default order placement.
                    placeOrder: async function({ fallback }) {
                        fallback();
                    },
                    // Called before order placement. Must return a Promise that resolves to true (pass) or false (block).
                    validate: async function() {
                        console.log('Hyvä Payment: validation simulation started.');

                        return new Promise(resolve => setTimeout(() => {
                            console.log('Hyvä Payment: validation simulation stopped.');

                            resolve(true)
                        }, 2000));
                    }
                }
            });
        });
    })();
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

That's all you need for the basics

A single JavaScript file that calls `hyvaCheckout.payment.registerMethod` is all you need. Add a renderer block only when your payment method requires UI elements like a form.

## Advanced Payment Method Patterns

The following examples extend the basic registration shown above. Each pattern can be combined with others as your payment method requires.

### Frontend Payment Method Validation

The `validate` method runs before the checkout system attempts order placement. Use it to implement custom validation logic - it must return a `Promise` that resolves to `true` (allow) or `false` (block).

This example simulates a frontend validation flow: first a confirmation dialog, then a password prompt. Any failed step shows a feedback dialog and resolves `false` to stop order placement.

Example - validate with confirmation and password prompt

```
<script>
    (() => {
        hyvaCheckout.api.after(() => {
            hyvaCheckout.payment.registerMethod({
                code: 'hyva',

                method: {
                    validate: async function() {
                        console.log('Hyvä Payment: validation simulation started.');

                        return new Promise(resolve => {
                            // Step 1: ask customer to confirm intent before proceeding.
                            const confirmed = confirm('Do you want to proceed with this payment? Click OK to continue or Cancel to abort.');

                            if (! confirmed) {
                                // Show a dialog and resolve false to stop order placement.
                                hyvaCheckout.message.dialog('Please confirm to proceed.');
                                resolve(false);
                                return;
                            }

                            // Step 2: prompt for a password (demo uses '123' as the correct value).
                            const password = prompt('Please enter your password to confirm the payment:');

                            if (password === null) {
                                hyvaCheckout.message.dialog('Please fill in the password.');
                                resolve(false);
                                return;
                            }

                            if (password.trim() === '') {
                                hyvaCheckout.message.dialog('Password can not be empty.');
                                resolve(false);
                                return;
                            }

                            if (password === '123') {
                                console.log('Hyvä Payment: validation simulation stopped - success.');
                                resolve(true);
                            } else {
                                // Wrong password - show feedback and block order placement.
                                hyvaCheckout.message.dialog('Wrong password, please use "123".');
                                console.log('Hyvä Payment: validation simulation stopped - failed.');
                                resolve(false);
                            }
                        });
                    }
                }
            });
        });
    })();
</script>
```

The example uses native browser `confirm` and `prompt` dialogs for simplicity, but you can use any approach as long as it returns a `Promise<boolean>`.

### Error Handling in placeOrder

As an alternative to `validate`, you can implement error handling directly in the `placeOrder` method. Throwing a `new Error()` from `placeOrder` is automatically caught and passed to the method's `handleException` function, which gives you one consistent place to handle all errors from a payment method.

This example shows password validation inside `placeOrder`, with `handleException` displaying the error as a dialog:

Example\_Module::hyva-checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml

```
<script>
    (() => {
        hyvaCheckout.api.after(() => {
            hyvaCheckout.payment.registerMethod({
                code: 'hyva',

                method: {
                    // placeOrder can throw an Error - it will be caught and routed to handleException.
                    placeOrder: async function({ fallback }) {
                        const password = prompt('Please enter your password to confirm the payment:');

                        if (password !== '123') {
                            throw new Error('Wrong password, please use "123".');
                        }

                        await fallback();
                    },
                    // handleException receives the thrown error and decides how to display it.
                    handleException: async function({ exception, fallback }) {
                        hyvaCheckout.message.dialog(exception);

                        await fallback({ exception: exception });
                    }
                }
            });
        });
    })();
</script>
```

### Advanced Exception Handling with Error Codes

For payment methods that call external APIs, use typed errors with a `code` property to route different failure scenarios to different handlers. This gives customers precise feedback depending on what went wrong.

This example simulates an async API call that fails, then checks the error code in `handleException` to decide how to respond:

Example\_Module::hyva-checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml

```
<script>
    (() => {
        // Reusable handler for order placement failures - shows a non-cancelable dialog.
        const handlePlaceOrderException = function({ exception }) {
            hyvaCheckout.message.dialog(exception.message, 'Something went wrong while placing the order', 'error', () => {
                console.log('A callback executed when the customer pressed the OK button.')
            }, {
                // Require the customer to press confirm before they can continue.
                cancelable: false
            });
        };

        hyvaCheckout.payment.registerMethod({
            code: 'hyva',

            method: {
                // Simulate an async failure from a payment endpoint.
                placeOrder: async function() {
                    await new Promise((resolve, reject) => setTimeout(() => {
                        const error = new Error('Could not reach the custom payment place order endpoint.');
                        error.code = 'PLACE_ORDER'; // Attach a code so handleException can route it.

                        reject(error);
                    }, 1000));
                },
                // Route exceptions by code - use fallback for unrecognized errors.
                handleException: async function({ exception, fallback }) {
                    if (exception.code === 'PLACE_ORDER') {
                        handlePlaceOrderException({ exception });
                        return;
                    }

                    // Always pass the exception when calling fallback.
                    fallback({ exception });
                }
            }
        });
    })();
</script>
```

### Multiple Payment Methods with a Single Handler

When you have several payment methods that share the same behavior with only minor variations, use `forEach` to register each code with the same method object. This avoids duplicating the same handler code for every method.

Example\_Module::hyva-checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml

```
<script>
    (() => {
        // Register multiple payment method codes that share the same handler logic.
        ['hyva', 'checkmo'].forEach(code => {
            hyvaCheckout.payment.registerMethod({
                code: code,

                method: {
                    initialize: function() {
                        console.log(`Method "${this.code}" initialized`);
                    },
                    uninitialize: function() {
                        console.log(`Method "${this.code}" uninitialized`);
                    }
                }
            });
        });
    })();
</script>
```

### Redirect to a Payment Service Provider after Order Placement

A common pattern for external payment providers is to redirect the customer after order placement - either to complete payment on an external site or to an order success page.

Use `canRedirect` together with `getRedirectUrl` to implement this. `canRedirect` tells the order processing system that a custom redirect is needed; `getRedirectUrl` returns the destination URL. The URL can be fully qualified or a relative path like `onepage/success`.

Example\_Module::hyva-checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml

```
<script>
    (() => {
        hyvaCheckout.payment.registerMethod({
            code: 'hyva',

            method: {
                // Signal to the checkout that this method uses a custom redirect URL.
                canRedirect: function() {
                    return true;
                },
                // Fetch the redirect URL from the PSP - called automatically when canRedirect returns true.
                getRedirectUrl: async function({ fallback }) {
                    const response = await fetch('https://api.mollie.com/v1/token/generate');

                    if (response.ok) {
                        const result = await response.json();
                        const url = new URL('https://api.mollie.com/v1/order/pay/redirect');

                        url.searchParams.set('token', result.token);
                        return url.toString();
                    }

                    throw new Error('Something went wrong while trying to handle your order.');
                }
            }
        });
    })();
</script>
```

### Using Magewire with a JS Payment Method

Because the payment method renderer block is a standard layout block aliased with the payment method code, you can attach a Magewire component to it using the `magewire` block argument. This transforms the renderer into a Magewire component and makes the `$wire` object available on the JavaScript side.

There are two ways to access the Magewire component from your payment method JavaScript.

#### Option A: Access $wire via an Alpine Component

When your renderer template uses `x-data` with an Alpine component bound to the root element, the `$wire` object is automatically available inside that component's scope. This is the cleanest approach when you're already using Alpine.

Renderer template:

Example\_Module::hyva-checkout/payment/method/hyva.phtml

```
<div x-data="hyvaCheckoutJsOnlyPaymentMethod">
    My JavaScript driven payment method.
</div>
```

JavaScript file that registers the Alpine component and the payment method:

Example\_Module::hyva-checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml

```
<script>
    hyvaCheckoutJsOnlyPaymentMethod = function() {
        return {
            // Alpine's init() runs automatically when the component mounts.
            init() {
                const magewireComponent = this.$wire;

                // Build your method object - equivalent to other examples on this page.
                const method = {...};

                // Guard against multiple registrations - registerMethod throws if the code is already registered.
                if (! hyvaCheckout.payment.getByCode('hyva_js_only')) {
                    hyvaCheckout.payment.registerMethod({
                        code: 'hyva_js_only', method
                    });
                }
            }
        }
    }

    window.addEventListener('alpine:init', () => {
        Alpine.data('hyvaCheckoutJsOnlyPaymentMethod', hyvaCheckoutJsOnlyPaymentMethod);
    }, { once: true });
</script>
```

#### Option B: Access Magewire via the Window Object

If you don't need Alpine, you can access the Magewire component directly via the `Magewire.find()` method on the window object. The argument to `.find()` is the block name in layout, which is the same value returned by `$block->getNameInLayout()`.

Example\_Module::hyva-checkout/page/js/api/v1/alpinejs/payment/method/hyva.phtml

```
<script>
    (() => {
        // Magewire.find() looks up a component by its layout block name.
        // Using a function defers the lookup until the component is needed.
        const jsOnlyWireComponent = function() {
            return Magewire.find('hyva.checkout.alpinejs.payment-method-hyva');
        };

        hyvaCheckout.payment.registerMethod({
            code: 'hyva',

            method: {
                // Use jsOnlyWireComponent() anywhere in the method object to access $wire.
            }
        });
    })();
</script>
```

## Related Topics

- **[Payment API Reference](../devdocs/frontend-api/V1/payment.html)** - Full API documentation for `hyvaCheckout.payment`, including all available method hooks and their signatures
