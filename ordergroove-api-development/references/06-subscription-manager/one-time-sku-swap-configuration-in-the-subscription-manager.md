# One Time SKU Swap Configuration in the Subscription Manager

SKU Swap is an out-of-the-box feature that allows customers to change from one SKU to another without needing to cancel one product and resubscribe to another. This feature helps retention efforts by getting ahead of common subscription cancel symptoms we refer to as “flavor fatigue”, although it could be anything from flavor, to size, to scent, etc.

***

## What are the benefits of a one time swap?

In it’s current state, SKU Swap will swap out the subscription permanently to the new product chosen. In some cases, the customer may only want to swap out their next upcoming order, but not permanently swap to a new product. One use case where this is prominent is when an item is out of stock. Typically when this happens customers may want to swap to avoid waiting for the product to come back in stock, but not permanently swap out their subscription. Below are the instructions to add the ability in your subscription manager for customers to choose to swap permanently or one time only.

***

## Setting up One Time SKU Swap

There are only two main steps to set up One Time SKU Swap. We'll access the advanced editor, then modify the files within.

### 1. Accessing the subscriber manager advanced editor

We'll be using the advanced editor to modify the Subscription Manager. You can access it through your Ordergroove Admin:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to Subscriptions on the top toolbar, and select Subscription Manager.
3. Toggle Advanced on the top left.

> 🚧 Support
>
> Some aspects of this article require technical expertise with coding languages. This is self-serve and outside of the normal support policy.

### 2. Adding the code snippets

**File: locales/en-US.js**

Updating the message for the current sku-swap default button (Confirm). Create a new key for the New button.

```javascript
 "modal_change_product_save": "Change for all the Future Orders",
 "modal_change_product_change_one_time": "One Time Change",
```

**File: change-product.liquid**

Updating the SKU Swap experience

1. Add the current product to the SKU Swap model. This is typically removed since customers swap away from the current SKU. With a one time swap, the customer may change their mind and want to swap back to their current product. By adding this snippet, the existing product will show up in the swap experience as well.

```liquid
{% set customized_sku_options = 'add_items(alternative_ids, subscription.product)' | js %}
```

2. Replace the default list of products (alternative\_ids) with the customized options created in step 1.

```liquid
{% for alternative_id in customized_sku_options %}
```

3. Add a hidden input with the order\_id to use on the one time swap call.

```liquid
<input type="hidden" value="{{ order_item.public_id }}" name="order_item" />
```

4. Create the new button for the one-time change. This button will use the custom function named change\_product\_one\_time (in script.js code snippet below)

```liquid
<button class="og-button" name="change_product_one_time" type="button" @click={{ 'change_item_product' | js }}>
  {{ 'modal_change_product_change_one_time' | t }}
</button>
```

5. Add a call to the custom function within the regular SKU swap form. This ensures that a regular SKU also updates the product item for the current shipment

```liquid
@finally={{ 'change_item_product' | js }}
```

The top of the form code will look something like this

```liquid
<form
action="{{ 'change_product' | action }}" 
name="og_change_product"
@success={{ 'close_closest_modal' | js }}
@reset={{ 'close_closest_modal' | js }}
@finally={{ 'change_item_product' | js }}>
```

**File: script.js**

Add this fragment of code at the end of the script.js file.

```javascript
const change_item_product = async function( ev ) {
  const { customer, environment: { lego_url } } = og.smi.store.getState();
  const form = ev.target.closest('form');
  const formComponents = form.querySelectorAll('select,input,button,div');
  const subscription_id = form.querySelector('[name="subscription"]').value;
  const disclaimer = document.querySelector('#og-one-time-change-disclaimer-'+subscription_id);
  const order_item = form.querySelector('[name="order_item"]').value;
  const product = form.querySelector('[name="product"]:checked').value;
  const one_time_change_params = {
    product: product
  }

  if ( disclaimer ) {
    disclaimer.setAttribute('style', 'display: none');
  }
  formComponents.forEach( it => {
    it.toggleAttribute('disabled', true)
    it.setAttribute('style', 'opacity:0.6')
  })

  const response = await fetch(`${lego_url}/items/${order_item}/change_product/`, {
    method: 'PATCH',
    headers:{
        'Authorization': JSON.stringify(customer),
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    },
    body: JSON.stringify(one_time_change_params)
  })

  if (response.status === 200) {
      og.smi.api.request_subscriptions()
      og.smi.api.request_orders({ status: 1 })
      og.smi.api.request_orders_items({ status: 1 })
      .then(() = formComponents.forEach(it => {
        it.toggleAttribute('disabled', false)
        it.setAttribute("style", 'opacity: 1')
      }))
      .then(() => (disclaimer) ? disclaimer.setAttribute('style', 'display: block') : '')
      .then(() => displayCustomToast('Success! Your order item has been changed.'))
      .then(() => close_closest_modal(ev))
  }
}

function displayCustomToast (msg) {
  let customToast = document.createElement('li');
  let toastContainer =  smiElement.querySelector('.og-toasts');
  customToast.classList.add('og-toast', 'og-toast-success', 'og-show');
  customToast.innerHTML = msg;
  toastContainer.appendChild(customToast);
  toast_notification_animation();

  setTimeout(() = {
    toastContainer.removeChild(customToast);
  }, TOAST_NOTIFICATION_TIMEOUT);
}

const add_items = og.smi.memoize(function (a, b) {
  return [...a, b];
})
```

***

## Styling

**File: order-item.less**

This snippet will help you style the one-time change disclaimer. Included inside the .og-product class

```css
.og-one-time-change-disclaimer {
  font-size: .8em;
  font-style: italic;
  background-color: #FFFF0099;
  max-width: 80%;
}
```

**Class: .og-change-product-control**

To style the buttons, add this snippet inside the .og-change-product-control class

```css
.og-dialog-footer {
  justify-content: space-between;
}
```