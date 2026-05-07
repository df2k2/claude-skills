# Offer Tagging

Offer Tagging is how developers place Ordergroove subscription offers on a merchant's storefront. You add `<og-offer>` HTML elements to product detail pages, carts, and anywhere else you want offers to appear. Paired with Ordergroove's `main.js` script, those tags render the enrollment UI that lets shoppers turn a one-time purchase into a subscription — all managed from the Ordergroove Admin tool.

***

## Defining the Offer Element

The following code will present the default offer for the given product id.

```html
<og-offer product="your-product-id"></og-offer>
```

> 🚧 Closing Tags
>
> Custom elements cannot be self-closing because HTML only allows a few elements to be self-closing. Always write a closing tag ().

Alternatively you can set the product id by using regular js.

HTML

```html
<og-offer id="my-dynamic-offer"></og-offer>
```

JS

```javascript
document.querySelector('#my-dynamic-offer').setAttribute('product','your-product-id')
```

***

## Location

The location will allow the display of different offers in different locations. (i.e. PDP vs. Cart) The value location can be any string.

Note, development work will be required to add the location portion of the node. **(i.e. location="X")**

Recommended location naming conventions and pages **location="X"**

* PDP (Product Detail Page)
* Cart (Shopping Cart Page)
* OR (Order Review Page)

Example:

```html
<og-offer product="your-product-id" location="X"></og-offer>
```

***

## Buy x Subscribe y

If you want to define a product that Ordergroove should create for a subscription that differs from the product tagged as the product within the HTML element, you can define the alternative product directly in the offer.

Example:

```html
<og-offer product="x" product-to-subscribe="y"></og-offer>
```

***

## Product Components

If you would like to offer subscriptions for a bundle product that can have product components defined for the bundle, you can tag those components directly in the offer as they are added by the customer. Bundle components do not have a quantity attribute, so if a customer wishes to receive more than one of a single component product, it needs to be passed multiple times within the og-offer components tag.

Example:

```html
<og-offer product="bundle_product_id" product-components="["39458782806076","39458782806076","39406418165820"]"></og-offer>
```

***

## First Order Place Date

If you would like to define when the customer's first recurring order will place, you can do that directly in the offer.

Example:

```html
<og-offer product="your-product-id" first-order-place-date="2022-09-04"></og-offer>
```

***

## Main.js

The Ordergroove main.js will need to be tagged on all pages where an og-offer div lives. The main.js will be leveraged to load your offer content and styling. Note, the main.js should only be tagged once per page, and can be leveraged to load multiple offers onto a page. The main.js structure will consist of two elements, the frontend static domain, and your Merchant ID. The below-listed static domain will need to be changed between your staging environments to pull in the respective content promoted from Ordergroove. If you do need to request your Merchant ID, please open a Zendesk [ticket](https://help.ordergroove.com/).

Front-end Static Domains:\
Staging: [https://staging.static.ordergroove.com](https://staging.static.ordergroove.com)\
Production: [https://static.ordergroove.com](https://static.ordergroove.com)

```javascript
<script type="text/javascript" src="<STATIC_DOMAIN>/<MERCHANT_ID>/main.js"></script>
```

***

## Additional Resources

Take a look at [How to configure and style your subscription enrollment](https://help.ordergroove.com/hc/en-us/articles/360026386794-How-To-Configure-and-Style-Your-Subscription-Enrollment) in the Knowledge Center for additional help styling and customizing your offers.

***

## Frequently Asked Questions

### Why isn't my `<og-offer>` rendering on the page?

The most common cause is a missing or misconfigured `main.js` script. Ordergroove's `main.js` must be loaded on every page where an `<og-offer>` element appears, and the script URL must include the correct static domain (`https://static.ordergroove.com` for production, `https://staging.static.ordergroove.com` for staging) and your Merchant ID. Also confirm the element has a proper closing tag — `<og-offer>` cannot be self-closed because HTML only permits self-closing on a handful of native elements.

### Can I use the same offer tag on the PDP and the cart?

You can reuse the same `<og-offer>` element, but you should add a `location` attribute (e.g., `location="PDP"` or `location="Cart"`) so Ordergroove can render different offer presentations in each place. The `location` value accepts any string, with `PDP`, `Cart`, and `OR` (Order Review) being the recommended conventions. Note that custom location handling requires development work to wire into your storefront.

### How do I set the product ID dynamically with JavaScript instead of hardcoding it?

Render the element without a `product` attribute, give it an `id`, then set the attribute at runtime: `document.querySelector('#my-offer').setAttribute('product', 'your-product-id')`. This is useful for SPAs, quickview modals, or any page where the product context isn't known at HTML render time. Make sure Ordergroove's `main.js` has loaded before you set the attribute so the element can hydrate properly.

### What's the difference between `product` and `product-to-subscribe`?

The `product` attribute is the SKU the customer is currently viewing or adding to cart, while `product-to-subscribe` tells Ordergroove to create the subscription against a different SKU. This "Buy X, Subscribe Y" pattern is common when the one-time purchase and the recurring SKU are configured separately — for example, a trial-size product on the PDP that converts into a full-size subscription. If both products are the same, you only need the `product` attribute.

### How do I tag a bundle subscription with multiple components?

Use the `product-components` attribute and pass a JSON-style array of product IDs, like `product-components='["39458782806076","39458782806076","39406418165820"]'`. Bundle components don't support a quantity attribute, so if a customer wants two of the same component, you must include that product ID twice in the array. This lets Ordergroove track exactly which child products are part of the bundle subscription as the customer builds it.

### Can I control when the customer's first recurring order ships?

Yes — add the `first-order-place-date` attribute to the `<og-offer>` element with an ISO date string, for example `first-order-place-date="2022-09-04"`. This overrides Ordergroove's default first-order scheduling and is helpful for prelaunch programs, delayed-shipment offers, or aligning a customer's first order with a specific billing cycle.

### Do I need a separate `main.js` for each offer on a page?

No. The `main.js` script should only be tagged once per page regardless of how many `<og-offer>` elements you place — a single script load discovers and renders every offer element in the DOM. Loading it multiple times can cause duplicate rendering and unexpected behavior.