# Refreshing data in the Subscription Manager

This guide is for developers crafting custom experiences modifying customers’ subscriptions and orders. If you update a customers’ subscription or order information, you will want to update the Subscription Manager display as well to reflect the updates.

***

## Requirements

This guide is intended for developers who already grasp the basics of the Subscription Manager advanced development and are crafting custom order and subscription changes. If your customizations do not include custom Javascript requests to Ordergroove’s APIs, you do not need this article.

***

## Refreshing Data

### Understanding Ordergroove’s Updates

The Redux state holds all of the objects that the subscription manager (SM) uses in the templates. You can read more about how to see the current Redux state in [this guide](https://developer.ordergroove.com/docs/debugging-with-redux).

When an action is dispatched to update a customer’s information or order, Ordergroove’s SM backend updates the state with custom operations based on the minimum necessary changes to state. For example, if a customer updates their address, we update the state directly instead of re-requesting all of the addresses from our backend. This results in a more responsive customer experience.

For other actions, such as skipping an order, complex calculations take place on Ordergroove’s backend to optimize the customer’s subscription experience, such as merging multiple subscriptions into one order. In cases like this, we request all of the orders and order items from Ordergroove’s backend to fully refresh the Subscription Manager.

### Understanding the changes you need

Depending on your custom experience, different parts of the state will need to refresh. You can tell what data needs to refresh by comparing the Redux state to what you expect needs to be shown. For example, if you sent a request to update the quantity of a customer’s order item, you would expect to see an updated quantity in order\_item.

### Refreshing state

Once you’ve identified your state refreshes, you can trigger the appropriate actions in Ordergroove.

#### Refreshing Order and Order Item information

In most cases, your custom experience will change something about your customer’s order (place date, address, etc) or order\_items (quantity, product, etc). The safest thing to do in this case is to refresh all orders and order items. You can do this by calling `window.og.smi.api.refresh_page_state` in `script.js` once you receive a success code from Ordergroove’s backend for your API request. This method will re-request all initial SM data, including orders and items, and update the page state. If orders or items have been removed since the page was last loaded, calling this function will remove those items from the state.

#### Refreshing Subscriptions and Product

There are fewer cases where you will need to update the subscription or product information, but if you do, you can call `window.og.smi.api.request_subscriptions` or `window.og.smi.api.request_product` following [this guide](https://developer.ordergroove.com/docs/call-rest-apis-from-within-subscription-manager#request_orders).

#### Refreshing Customer Information

There is not currently an externally-accessible API available for updating customer information in the Redux State of the Subscription Manager. If you would like to see this feature in the future, please contact us and let us know. In the meantime, triggering a full page refresh will always fully update the Subscription Manager.

***

## Additional Assistance

Please let us know if you need any more information or want to make a feature request. We are always looking for ways to improve the custom development experience.