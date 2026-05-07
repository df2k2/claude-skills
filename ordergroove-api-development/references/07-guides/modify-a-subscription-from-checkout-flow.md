# Add a subscription to cart

## What are offers?

Each product is tied to a subscription offer which details the different subscription frequencies and discounts that may be applied amongst other things. Using our components it is possible to retrieve these offers and build your own customized subscription interface.

***

## Defining og-offer element

We provide a way to customize how offer information is displayed into the page.

The following code will present the default offer for the given product-id

```Text HTML
<og-offer product="your-product-id"></og-offer>
```

### Closing tags

Custom elements cannot be self-closing because HTML only allows a few elements to be self-closing. Always write a closing tag ().

Alternatively you can set the product id by using regular js.

```Text HTML
<og-offer id="my-dynamic-offer"></og-offer>
```

```Text JavaScript
document.querySelector('#my-dynamic-offer').setAttribute('product', 'your-product-id')
```

***

## Location

The location will allow the display of different offers in different locations. (i.e. PDP vs. Cart) The value location can be any string.

Note, development work will be required to add the location portion of the node. **(i.e. location="X")**

Recommended location naming conventions and pages **location="X"**

* PDP (Product Detail Page offer)
* Cart (Shopping Cart Offer)
* Order Review (Order Review Offer)
* Confirmation (Confirmation page offer)

***

## Main.js

The Ordergroove main.js will need to be tagged on all pages where an og-offer div lives. The main.js will be leveraged to load your offer content and styling. Note, the main.js should only be tagged once per page, and can be leveraged to load multiple offers onto a page.

The main.js structure will consist of two elements, the frontend static domain, and your Merchant ID. The below-listed static domain will need to be changed between your staging environments to pull in the respective content promoted from Ordergroove. If you need your Merchant ID, please [reach out to support](https://help.ordergroove.com/hc/en-us/requests/new).

Front-end Statatic Domains:\
Staging: [https://staging.static.ordergroove.com](https://staging.static.ordergroove.com)\
Production: [https://static.ordergroove.com](https://static.ordergroove.com)

```Text JavaScript
<script type="text/javascript" src="
<STATIC_DOMAIN>/<MERCHANT_ID>/main.js"></script>
```

***

## Writing custom offer content

\<og-offer> element provides 2 slots that can be populated with custom content.

* slot="standard-template"
* slot="iu-template"

### standard-template

By this slot you can place content once a standard offer is presented to user.

```Text HTML
<og-offer product="your-product-id">
  <div slot="standard-template">
    This content will appear once a valid offer exists.
  </div>
</og-offer>
```

At this point you can start creating you custom offer experience by using a ordergroove offers webcomponent.

***

## Offer Context

Most webcomponents such as og-optin-button or og-optin-status need to have a product attribute specified. However, it is possible to wrap these components into an og-offer component using its slots. If so, the components will use the product id of the parent og-offer component if their own product attribute is not specified.

```Text HTML
<!-- specify product using attributes -->
<og-optin-button product="my-product-id"></og-optin-button>
<og-optin-status product="my-product-id"></og-optin-status>

<!-- specify product using og-offer -->
<og-offer product="my-product-id">
  <og-optin-button></og-optin-button>
  <og-optin-status></og-optin-status>
</og-offer>
```

***

## CSS Properties and Scope

A feature of web components and the shadow DOM specification is that styles are scoped. This means that you can't modify most of the CSS rules of our components. Learn more about [shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM).

However, we have exposed some css properties through the use of CSS variables. Here is the exhaustive list and what they modify:

\--**og-global-font-family** Sets the font-family to be used in our components\
\--**og-global-font-size** Sets the font-size to be used in our components\
\--**og-global-font-color** Sets the color to be used in our components

\--**og-tooltip-font-family** Sets the font-family used in our tooltip component\
\--**og-tooltip-font-size** Sets the font-size in our tooltip component\
\--**og-tooltip-font-color** Sets the color in our tooltip component

\--**og-upsell-font-family** Sets the font-family for the upsell section of og-offer\
\--**og-upsell-font-size** Sets the font-size for the upsell section of og-offer\
\--**og-upsell-font-color** Sets the color for the upsell section of og-offer\
\--**og-upsell-background-color** Sets the background color of the og-upsell-button component

\--**og-modal-button-font-family** Set the font-family of the og-modal component's button\
\--**og-modal-button-font-size** Set the font-size of the og-modal component's button\
\--**og-modal-button-color** Set the color of the og-modal component's button\
\--**og-modal-button-background-color** Set the background-color of the og-modal component's button\
\--**og-modal-primary-button-color** Set the color of the og-modal component's primary button\
\--**og-modal-primary-button-background-color** Set the background-color of the og-modal component's primary button

Here is a sample variable declaration:

```Text CSS
* {
--og-global-font-family: Arial, Helvetica, sans-serif;
--og-global-font-size: 15px;
--og-global-font-color: #bd10e0;
--og-tooltip-font-family: Arial, Helvetica, sans-serif;
--og-tooltip-font-size: 13px;
--og-tooltip-font-color: #298266;
--og-upsell-font-family: Arial, Helvetica, sans-serif;
--og-upsell-font-size: 13px;
--og-upsell-font-color: #298266;
--og-upsell-background-color: #7cf8d1;
--og-modal-button-font-family: inherit;
--og-modal-button-font-size: 12px;
--og-modal-button-color: inherit;
--og-modal-button-background-color: #e6e6e6;
--og-modal-primary-button-color: inherit;
--og-modal-primary-button-background-color: #00449e;
}
```

Using Ordergroove, you can set these variables of the global scopes through our UI.

How Ordergroove sets the CSS variables:

```Text CSS
* {
--og-global-font-color: 12px;
...
}
```

You can get more specific by defining your own values which will take precedent over the global ones set by Ordergroove.

```
.my-section {
--og-global-font-color: 10px;
...
}
```