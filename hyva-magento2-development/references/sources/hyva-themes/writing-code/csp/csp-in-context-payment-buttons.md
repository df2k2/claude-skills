<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/csp-in-context-payment-buttons.html -->

# In-Context Payment Buttons

For merchants only disabling the `unsafe-eval` and `unsafe-inline` `script-src` Content-Security-Policies on Checkout pages, becoming PCI-DSS compliant can be a challenge, if they use in-context payment buttons on catalog or cart pages.

To facilitate PCI-DSS compliance, Hyvä offers the `hyva-themes/magento2-csp-in-context-payment` extension.

It serves In-Context-Payment-Buttons in the Mini-cart and the Cart with strict CSP enabled.

This is done by rendering the in-context buttons in an iframe. The iframe source is served from a route using strict CSP (that is, without `unsafe-eval` and `unsafe-inline` for `script-src`).

The `hyva-themes/magento2-csp-in-context-payment` module provides a base for in-context payment buttons to be served in a PCI-DSS 4.0-compliant way. Out-of-the-box, only support for PayPal Express is included.
Other payment providers can use the implementation of the PayPal Express buttons as an example to add support to their in-context payment buttons.

Info

The `magento2-csp-in-context-payment` module should not be used if the full site is served using strict CSP.

## Installation

The module should only be installed explicitly if the PayPal Express In-Context Payment Buttons are enabled.
If a different payment provider is used, this module will be installed automatically as a dependency.

1. Install via composer

   ```
   composer require hyva-themes/magento2-csp-in-context-payment
   ```
2. Enable module

   ```
   bin/magento setup:upgrade
   ```

## Supporting in-context payments

The module is designed to be used by other payment service providers to be extended by their own csp-in-context-payment extensions.

The following steps describe the process of rendering other payment provider in-context-payment buttons in an iframe.

### 1. Add the composer dependency

First, add a dependency on `hyva-themes/magento2-csp-in-context-payment` to your modules `composer.json`.

### 2. Choose in-context action codes

Then, decide on a `code` identifying your in-context payment actions.
For the example PayPal implementation, the code `paypal_cart` is used for the in-context buttons on the cart page and the mini-cart, and `paypal_pdp` for the in-context buttons on the product detail page.

### 3. Declare in-iframe templates

Create layout XML files in `view/frontend/layout/` called `payincontext_button_display_[your code].xml`.
Declare a block to render the template displaying your in-context payment actions inside the iframe rendered by the `magento2-csp-in-context-payment`.

For example, here is the layout XML found in `payincontext_button_display_paypal_cart.xml` to render the PayPal cart in-context buttons.

```
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="main">
            <block class="Magento\Paypal\Block\Express\InContext\Minicart\SmartButton"
                   name="incontext-paypal-button"
                   template="Hyva_CspInContextPayment::paypal/in-context/shortcut/in-iframe-button.phtml"
                   cacheable="false"/>
        </referenceContainer>
    </body>
</page>
```

Mini-Cart Buttons

For PayPal Express, the templates for the mini-cart in-context buttons are not specified in layout XML, but rather using `etc/frontend/di.xml`.
If this is also the case for your mini-cart in-context payment buttons, the template replacement can be done via a plugin before the button gets added to the ShortcutButtons container.
For an example of this please refer to `Hyva\CspInContextPayment\Plugin\ShortcutButtonsPlugin`.

Full Page Cache

Remember to add an `cacheable="false"` attribute only if the template contains server-side rendered customer-specific information.
If the template only uses section data, then the `cacheable` attribute should not be specified (since it defaults to `true`).

### 4. Adjust your buttons templates to work in the iframe

For the cart page and mini-cart buttons, probably very few adjustments are necessary since the section data with the cart data is available on the page the iframe.

For in-context buttons on the product detail page, things are different. Usually, the product form must be submitted when the in-context button is clicked.
Because the button is in an iframe, it's not as straightforward to do so, compared with when the button is rendered on the same page as the form.

To facilitate submitting the product from within the iframe, the `magento2-csp-in-context-payment` module provides utility JS functions (see [Product Detail Page Form API](#product-detail-page-form-api) below).

In a nutshell, `hyva.submitProductForm()` can be used to trigger the form submission via Ajax. The function returns a promise that resolves when the add-to-cart process is complete and the section data in the iframe is updated.

The method `hyva.getCurrentCart()` returns current cart data from the section data, ready to be submitted to the payment service provider.

For example, this is how the functions are used by the PayPal PDP in-context button:

```
onClick(data, actions) {
    return hyva.submitProductForm();
},
createOrder() {
    const cart = hyva.getCurrentCart();
    const params = 'quote_id=' + cart.cartId +
        '&customer_id=' + (config.customerId || '') +
        '&form_key=' + hyva.getFormKey() +
        '&button=' + config.button;

    return window.fetch(config.getTokenUrl, {
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
        },
        body: params,
        method: 'POST',
        mode: 'cors',
        credentials: 'include'
    })
        .then(result => result.json())
        .then(data => data.token)
        .catch(console.error);
},
```

## Product Detail Page Form API

In-Context-Payment Buttons on the PDP usually require the product to be added to the cart as the first step when the button is clicked.
Because the button is rendered in an iframe, it is not as straight forward compared to if it is rendered on the same page.
For this reason, this module provides an API to handle this:

### `hyva.submitProductForm();`

Returns a promise that resolves when the product form is submitted and the section data has been reloaded.
If the form can't be submitted (for example because of missing required options), the promise is rejected.

### `hyva.submitProductForm.reset()`

Allow resetting the form submission process in case the payment process was canceled.
It then can be restarted with `hyva.submitProductForm()` again.

### `hyva.getCurrentCart()`

Returns the current cart from the section data.

### `hyva.onProductFormIsValid(callback)`

Register a callback function that is called every time the product form is changed. The callback is called with a boolean indicating if the form validates or not.

Example:

```
hyva.onProductFormIsValid((isValid) => {
    isValid ? actions.enable() : actions.disable();
});
```

### `hyva.dispatchTopWindowMessages()`

Dispatch messages to the top window context, as if calling `window.dispatchMessages` there.
