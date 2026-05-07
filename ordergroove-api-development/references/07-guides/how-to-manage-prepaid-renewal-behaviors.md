# How to Manage Prepaid Renewal Behaviors

Each prepaid subscription has a renewal behavior that will control what will happen when all prepaid orders are placed. Those are:

* **autorenew**: Renew and bill the customer a full prepaid cycle after all orders are placed. The renewal happens when the first order of the next cycle is placed.
* **cancel**: When all orders are placed the subscription is cancelled. Customers can reactivate it to start a new prepaid cycle
* **downgrade**: Turns the prepaid subscription to a normal subscription when all orders are placed. The next order placed for the subscription will have the price of a single shipment.

All subscriptions will be created using the default renewal behavior, which is `autorenew`. The default renewal behavior can be changed if you want your customers to have their prepaid subscriptions canceled or downgraded to normal subscriptions at the end of their cycles. In case you want to change the default renewal behavior of your store please contact us at [support@ordergroove.com](mailto:support@ordergroove.com).

You can also create specific subscriptions with a custom renewal behavior

## How to Create Subscription with Custom Prepaid Renewal Behavior

### Shopify

To specify which custom renewal behavior you want when checking out with a prepaid item, a property needs to be added to the line item. This property's name is: `__og_prepaid_subscription_renewal_behavior` and the value can be any of the [valid renewal behaviors](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data).

You can add this line item property following [Shopify Cart API](https://shopify.dev/docs/api/ajax/reference/cart) or by adding this value to the product form on the product page.

This is an example of how an input can be used to set the custom renewal behavior:

```html
<input type="hidden" name="properties[__og_prepaid_subscription_renewal_behavior]" value="cancel">
```

### Other platforms

When creating the subscription through the [Purchase Post API](https://developer.ordergroove.com/reference/purchase-post-api) the renewal behavior can be controlled in `products[].subscription_info.renewal_behavior` field.

#### Adding the Custom Field

To control the renewal behavior for prepaid subscriptions at the opt-in step, you’ll need to add a hidden input field to your **product form** (the form that adds items to the cart).

1. Open the relevant product template or section file where the `<form>` element for adding products to the cart is located (e.g., `product-form.liquid`).
2. Inside the `<form>`, add the following hidden input field:
   ```html
   <input type="hidden" name="properties[__og_prepaid_subscription_renewal_behavior]" value="cancel">
   ```
3. Save and publish the change.

This field will be submitted along with the product when a user adds it to the cart.

You can test this behavior manually without editing the theme code permanently by:

1. Editing the HTML through the developer tools.
2. Adding the product to the cart.
3. Checking the [https://yourstore.com/cart.json]()

#### How It Works

By default, prepaid subscriptions **auto-renew** when the prepaid cycle ends. Adding this custom field gives you control over that renewal behavior. You can set the `value` attribute to: `autorenew` **(default)**, `cancel`, or `downgrade`. Take a look at the definitions up top for more information.