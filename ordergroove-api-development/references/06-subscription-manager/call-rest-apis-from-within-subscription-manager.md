# Calling Ordergroove’s REST APIs from within Subscription Manager

There may be times when you want to go beyond the standard functionality of the Subscription Manager and use the advanced editor to make calls to Ordergroove’s suite of [REST APIs](https://developer.ordergroove.com/reference/introduction).

This article outlines a few options for how to call these APIs by leveraging [Storefront Auth](https://developer.ordergroove.com/reference/authentication#storefront-api-scope) within the Subscription Manager. Please note that any APIs requiring Application API scope can only be accessed server-to-server and will require a separate backend application.

***

## Option 1 - Retrieve the Authorization Headers Directly

You can retrieve the authorization headers directly using JavaScript. There are two ways to add the required JavaScript code:

1. Add the JavaScript to your `script.js` file (editable via RC3).
2. Add the JavaScript to your own script that executes on your page.

**Note:** The variables change slightly depending on whether you are making the call from a page with `main.js` tagged or `msi.js` tagged.

### For page tagged with `main.js` and customer is logged in

To retrieve the authorization headers, use the following code snippet:

```javascript
const getAuthorizationHeader = () => {
    const { public_id, sig_field, ts, sig } = og.store.getState().auth;
    return JSON.stringify({
        public_id,
        sig_field,
        ts,
        sig
    });
};

fetch('https://restapi.ordergroove.com/<resource>', {
    headers: {
        'Content-Type': 'application/json',
        'Authorization': getAuthorizationHeader()
    }
});

 
```

### For page tagged with`msi.js` and customer is logged in

If you are making the call from a page with `msi.js` tagged, use the following code snippet:

```javascript
const getAuthorizationHeader = () => {
    const { public_id, sig_field, ts, sig } = og.smi.store.getState().customer;
    return JSON.stringify({
        public_id,
        sig_field,
        ts,
        sig
    });
};

fetch('https://restapi.ordergroove.com/<resource>', {
    headers: {
        'Content-Type': 'application/json',
        'Authorization': getAuthorizationHeader()
    }
});

 
```

### Summary

By using the appropriate JavaScript code based on whether `main.js` or `msi.js` is tagged, you can easily retrieve the authorization headers required for making API calls to the OrderGroove REST API.

***

## Option 2 - Leverage the existing API calls via window\.og.smi

A subset of the REST APIs are already called from Ordergroove’s JavaScript and you can use window\.og.smi to make the same calls as needed.

### refresh\_page\_state

Performs an asynchronous request to re-retrieve the initial page data (including, but not limited to, orders, items, subscriptions, and addresses) and updates the state with the result. If orders or items have been removed since the page was last loaded, calling this function will remove those items from the state.

#### Parameters

* None

#### Returns

* `Promise<void>`

***

### request\_orders

Performs an asynchronous request to fetch orders and update the state with the result

#### Parameters

* `options` (Object): Describing filter and ordering.
  * `status` (OrderStatus\[]): The status of the orders to fetch.
  * `ordering` (string): How results should be sorted. Defaults to `place`.

#### Returns

* `Promise<Results<Order>>`

***

### request\_orders\_items

Performs an asynchronous request to fetch order items and update the state with the result. If you want deleted order items to be removed from the page state, call `refresh_page_state` instead.

#### Parameters

* `options` (Object): Describes order status filter.
  * `status` (OrderStatus\[]): The status of the order items to fetch (optional).

#### Returns

* `Promise<Results<OrderItem>>`

***

### request\_subscriptions

Performs an asynchronous request to fetch subscriptions and update the state with the result

#### Parameters

* `options` (Object): Object describing filter and ordering.
  * `live` (boolean): Filter for live subscriptions (optional).

#### Returns

* `Promise<Results<Subscription>>`

***

### request\_product

Performs an asynchronous request to fetch a product and update the state with the result

#### Parameters

* `external_product_id` (string): Product identifier (external\_product\_id).

#### Returns

* `Promise<Product>`

***

### request\_delete\_item

Performs an asynchronous request to remove an item from an order

#### Parameters

* `item_id` (string): Item identifier (item\_id).

#### Returns

* `Promise<Product>`

***

### request\_skip\_order

Performs an asynchronous request to skip an order

#### Parameters

* `order_id` (string): Item identifier (order\_id).

#### Returns

* `Promise<Product>`