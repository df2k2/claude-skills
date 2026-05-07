<!-- source: https://docs.hyva.io/hyva-checkout/magewire/vanilla-js.html -->

# Interacting with Magewire Components Using Vanilla JavaScript

Third-party services often provide JavaScript SDKs for building integrations. In those situations, you'll want to access Magewire components directly from vanilla JavaScript - no Alpine.js required.

When a Magewire component is present on a page, a global `Magewire` variable is set on the `window` object. This `Magewire` variable is the main entry point for interacting with any Magewire component on the page.

## Waiting for Magewire to Load

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

If `Magewire.find('the-component-name')` triggers the following error, it means no Magewire component with that name exists on the current page.

```
Uncaught TypeError: Cannot read properties of undefined (reading '$wire')
```

The best way to check if a Magewire component exists before calling `Magewire.find()` is to look for an element with a matching `wire:id` attribute.

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

Calling a Magewire component method from JavaScript triggers a server request and returns a JavaScript Promise. The Promise resolves when the server request completes, but it does not resolve to a meaningful value - the PHP method's return value is not passed back to JavaScript.

Communicating Back to JavaScript

Since return values from PHP are not available in JavaScript, any data you need to send back must be communicated through Magewire component property updates. Update a public property in PHP, then read it with `get()` in JavaScript after the Promise resolves.
