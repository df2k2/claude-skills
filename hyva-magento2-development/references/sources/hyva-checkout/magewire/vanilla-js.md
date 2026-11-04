<!-- source: https://docs.hyva.io/hyva-checkout/magewire/vanilla-js.html -->

# Interacting with Magewire Components Using Vanilla JavaScript

Third-party services often provide JavaScript SDKs for building integrations. In those situations, you'll want to access Magewire components directly from vanilla JavaScript - no Alpine.js required.

When a Magewire component is present on a page, a global `Magewire` variable is set on the `window` object. This `Magewire` variable is the main entry point for interacting with any Magewire component on the page.

CSP authorization required on checkout pages

Hyvä Checkout enforces strict CSP on all checkout pages. Any `<script>` block containing the code shown on this page requires `<?php $hyvaCsp->registerInlineScript() ?>` immediately after the closing `</script>` tag. See [CSP Script Authorization](../devdocs/csp/csp-script-validation.html) for details.

## Waiting for Magewire to Load

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Hyvä Checkout 3.x dispatches two Magewire lifecycle events on `document`:

- `magewire:init` fires once `window.Magewire` exists, before the components start. Register hooks, `Magewire.on()` listeners and directives here.
- `magewire:initialized` fires after the components on the page have started. Use it for code that needs the components already on the page, for example `Magewire.find()`.

The following example registers a hook for one component and reads a component after start:

```
// Register hooks before the components start
document.addEventListener('magewire:init', () => {
  Magewire.hook('component.init', ({ component }) => {
    if (component.name !== 'the.layout.block.name') {
      return;
    }
    // Per component setup goes here
  });

  Magewire.hook('commit', ({ component, succeed }) => {
    succeed(({ snapshot, effects }) => {
      // Runs after the server answered a component update
    });
  });
}, { once: true });

// Work with the components that are already on the page
document.addEventListener('magewire:initialized', () => {
  // Your custom code using Magewire.find() goes here
}, { once: true });
```

A `component.init` hook also covers components that render later, for example after a checkout step change, so prefer it over `magewire:initialized` plus `Magewire.find()`. Magewire 3 hook callbacks receive one object, and the Magewire 1 hooks (`component.initialized`, `element.*`, `message.*`) don't exist. Hyvä Checkout's own `page/js/api/v1/init-payment.phtml` and `init-shipping.phtml` templates follow this pattern.

Don't use `magewire:load` in new code

Checkout 3.x only dispatches `magewire:load` and `magewire:available` while the v1bc module is enabled. Code that waits for them never runs once v1bc is disabled. See the Magewire 3 [JavaScript documentation](https://docs.magewirephp.nl/pages/advanced/javascript/index.html) and [Component Hooks](https://docs.magewirephp.nl/pages/advanced/architecture/component-hooks.html).

To make sure the `Magewire` property is available before your code runs, wrap any code that uses `window.Magewire` inside a `magewire:load` event listener.

```
// Wait for Magewire to be fully initialized before using window.Magewire
document.addEventListener('magewire:load', () => {
  // Your custom code using window.Magewire goes here
})
```

Always Wait for Initialization

Code that references `Magewire` outside of a `magewire:load` listener may fail because the global variable is not yet defined. Always use the event listener to be safe.

## Finding a Magewire Component by Name

The `Magewire.find()` method gives you access to the JavaScript representation of a Magewire component. Pass the layout block name as a string argument.

```
// Find a Magewire component by its layout block name
Magewire.find('the.layout.block.name');
```

### Handling Missing Magewire Components

When no Magewire component with the given name is on the current page, `Magewire.find()` or the next call on its result fails with a `TypeError` such as `Cannot read properties of undefined`.

The best way to check if a Magewire component exists before calling `Magewire.find()` is to look for an element with a matching `wire:id` attribute.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

```
// Ensure the components on the page have started
document.addEventListener('magewire:initialized', () => {

  // Check if the component is present on the page before accessing it
  if (document.querySelectorAll('[wire\\:id=my-example]').length) {

    // Fetch the Magewire component instance
    const myComponent = Magewire.find('my-example');

    // Do something with the component
  }
}, { once: true })
```

```
// Ensure Magewire is initialized
document.addEventListener('magewire:load', () => {

  // Check if the component is present on the page before accessing it
  if (document.querySelectorAll('[wire\\:id=my-example]').length) {

    // Fetch the Magewire component instance
    const myComponent = Magewire.find('my-example');

    // Do something with the component
  }
})
```

## Reading Magewire Component Properties

To access the current value of a Magewire component property from vanilla JavaScript, use the `get()` method on the component instance returned by `Magewire.find()`.

```
// Read the property named "config" from a Magewire component
Magewire.find('the.layout.block.name').get('config')
```

No Ajax Request

Reading a property value with `get()` does not trigger an Ajax request. The value is read from the local JavaScript state of the Magewire component.

On Magewire 3, `get()` is an alias of `$get()`. Hyvä Checkout's own code reads properties with `component.$wire.$get('method')` inside a `component.init` hook.

## Writing Magewire Component Properties

Updating a Magewire component property from vanilla JavaScript is done with the `set()` method. Pass the property name and the new value as arguments.

```
// Set the property "foo" to the value "bar"
Magewire.find('the.layout.block.name').set('foo', 'bar')
```

The `set()` method is equivalent to using the `$set('foo', 'bar')` magic action inside an Alpine.js context.

Ajax Synchronization

Setting a property value triggers an Ajax request to synchronize the new value with the backend. The Magewire component re-renders automatically if needed.

## Calling PHP Methods from Vanilla JavaScript

There are two ways to call PHP methods on a Magewire component using vanilla JavaScript. You can either call the method directly on the component instance, or pass the method name as a string to the `call()` method.

```
// Both expressions call the PHP method "navigateToStep" with the argument "payment"

// Option 1: Using call() with the method name as a string
Magewire.find('hyva-checkout-main').call('navigateToStep', 'payment')

// Option 2: Calling the method directly on the component instance
Magewire.find('hyva-checkout-main').navigateToStep('payment')
```

Both approaches automatically invoke the corresponding PHP method with the same name on the Magewire server-side component.

### Calling a Payment Method from Vanilla JavaScript

Here's a practical example. The following JavaScript call to `setPaymentToken` sends token data from a third-party payment SDK to the Magewire backend component.

```
// Check if the payment component is present on the page
if (document.querySelectorAll('[wire\\:id=checkout.payment.psp_method_xyz]').length) {

    // Call setPaymentToken on the Magewire payment component
    Magewire.find('checkout.payment.psp_method_xyz').setPaymentToken({token: myToken})
}
```

The JavaScript call above triggers the `setPaymentToken` method on the corresponding Magewire PHP component.

```
class PspMethodXyz extends Component
{
    /**
     * Receives the payment token from the frontend JavaScript SDK
     * and stores it in the quote payment additional data.
     */
    public function setPaymentToken(array $data) {
        $paymentInfo = json_serialize(['token' => $data['myToken']]);
        $this->checkoutSession->getQuote()->getPayment()->setAdditionalData($paymentInfo);
    }
}
```

## Returning Values from Magewire to JavaScript

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Calling a Magewire component method from JavaScript triggers a server request and returns a JavaScript Promise. On Magewire 3, the Promise resolves to the PHP method's return value once the server request completes.

The following example reads the return value of a PHP method:

```
// Resolves to whatever the PHP method returns
const result = await Magewire.find('checkout.payment.psp_method_xyz').setPaymentToken({token: myToken});
```

Keep returned data JSON serializable and free of secrets, because it is sent to the browser as is. Code that must also run on Checkout 1.x can't rely on the return value and should use a public property instead.

Calling a Magewire component method from JavaScript triggers a server request and returns a JavaScript Promise. The Promise resolves when the server request completes, but it does not resolve to a meaningful value. The PHP method's return value is not passed back to JavaScript.

Communicating Back to JavaScript

Since return values from PHP are not available in JavaScript, any data you need to send back must be communicated through Magewire component property updates. Update a public property in PHP, then read it with `get()` in JavaScript after the Promise resolves.
