# Configuring Bundles

This guide will show you how to implement Bundle Subscriptions in your store, enabling customers to manage multiple items under a single subscription.

***

## Access

The New Bundles Suite is in Beta. To get access, please [contact Ordergroove Support](https://help.ordergroove.com/hc/en-us/requests/new).

***

## Setting Up Bundles

Once Ordergroove enables Bundles for you, there are three steps. We'll configure the products, update your subscription enrollment, and list the components.

<br />

### Configuring Products

Each bundle must have a *parent product* to indicate its subscription type. Parent products can be either static or dynamic. To configure them, follow these steps:

* Create the product in Shopify or use the [product bulk create endpoint](https://developer.ordergroove.com/reference/bulk-create). Ensure you set the correct price:
  * Static bundle: Price must be greater than zero.
  * Dynamic bundle: Price must be exactly zero.
* Change the `product_type` to the desired bundle type:`dynamic price bundle` or `static price bundle`. Use the [product bulk update endpoint](https://developer.ordergroove.com/reference/bulk-update) to make this change.

<br />

### Enrollment process

There are two ways to create a bundle subscription:

* **Shopify Store**: Follow [our detailed guide on creating box subscriptions](https://developer.ordergroove.com/docs/box-subscription-creation-on-shopify) directly on Shopify.
* **Other E-commerce Platforms**: For platforms outside of Shopify, create a bundle subscription using the [Purchase Post API](https://developer.ordergroove.com/reference/purchase-post-api). Specify the items in the subscription bundle by populating the `subscription_info.multi_item_bundle_components` array. Each item must include a *product ID* and the desired *quantity*.

<br />

### Changing bundles

To change and list bundle subscriptions, components, and items you can use our [set of APIs](https://developer.ordergroove.com/reference/bundle-components).

***

## Troubleshooting

If your bundle subscription is not getting created as expected, please contact your CSM or [Ordergroove Support](https://help.ordergroove.com/hc/en-us/requests/new).