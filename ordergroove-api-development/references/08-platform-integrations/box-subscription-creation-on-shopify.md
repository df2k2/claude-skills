# Box Subscription Creation on Shopify

Learn how to configure Ordergroove to create bundled subscriptions for multiple line-items in a Shopify checkout, including bundle creation, quantity overrides, and product swapping.

By default, Ordergroove will create a **separate subscription** for each line-item in a Shopify checkout that has been associated with a selling-plan.

If you would like Ordergroove to **bundle** multiple line-items in a checkout into a single bundled subscription, you can include a property at the line-item level that we will use to determine which line-items are meant to be grouped together.

The property you need to provide at the line-item level is:

`__og_parent_product_id`: the variant id of the "parent product" you would like the line items to be bundled beneath.

***

## Requirements

* The *parent product* does not need to be present in the cart as a line-item itself, **but it must be a real product variant that exists in your shopify store**. The subscription that is created in Ordergroove will reference this *parent product* at the top-level of the subscription for tracking and data-integrity purposes.
* You must still add the required selling-plan id to each line item you want included in the bundle.
* There should only be a single line-item in the cart for a given product variant that references a given `__og_parent_product_id`. You should not create carts that have multiple line items for the same product that reference the same `__og_parent_product_id`. For example, the following example of the cart structure **would not** be permitted:

```json
[{
  "variant": 12345,
  "__og_parent_product_id": 56789,
  "quantity": 1
},{
  "variant": 12345,
  "__og_parent_product_id": 56789,
  "quantity": 1
}]
```

This should instead be represented as:

```json
[{
  "variant": 12345,
  "__og_parent_product_id": 56789,
  "quantity": 2
}]
```

Here is an example of what the input for this attribute would look like on a product-form that is adding products to the customer's cart:

<Image align="center" src="https://files.readme.io/acd7623-image1.png" />

You can also consult shopify's [cart reference documentation](https://shopify.dev/docs/api/ajax/reference/cart) for information on how this property can be added via API.

Each line-item that has this `__og_parent_product_id` set to the same variant id will be bundled into a single subscription in Ordergroove's system after the customer checks out. For example, take a look at this shopify order:

<Image align="center" src="https://files.readme.io/7a58b1b-cat_food_CLEAN.png" />

Notice both the *Tuna Cat Food* and *Chicken Cat Food* product have the `__og_parent_product_id` set to the same variant id. This will cause Ordergroove to create a single subscription that encapsulates both products, and the product set on the subscription itself will be the product variant specified by the `__og_parent_product_id` attribute.

Alternatively, if you would like to create multiple different bundles during the same checkout experience, you should assign the to the `__og_parent_product_id` attribute the id of the parent product concatenated with the separator symbol ":" (quotes just to differentiate it from the rest of the text) and with a unique key that must be the same for all the products that are supposed to be under the same bundle.

For example, let's imagine that we have the parent product of id 1 and 4 products with ids from 2 to 5. In the case where we want 2 different bundles with products {2, 3} and {4, 5} in it respectively and both using the same parent product, the following needs to be configured:

* {2, 3}: `__og_parent_product_id = '1:bundle_1'`
* {4, 5}: `__og_parent_product_id = '1:bundle_2'`

***

## Overriding item quantity

By default, when we create a bundle subscription the amount of items in the cart for a bundle item will match the bundle subscription item created in Ordergroove. You can override the quantity of bundle items that will be created for the subscription by sending the `__og_subscription_bundle_item_quantity` on the properties of the item.

Here is an example of what the input for this property would look like on a product-form that is adding products to the customer's cart:

```html
<input type="hidden" name="properties[__og_subscription_bundle_item_quantity]" value="10">
```

Checking out with an item of quantity 3 but 10 as the overridden quantity in the property will create a bundle subscription on Ordergroove that will ship 10 items instead of the 3 initial ones sent on the checkout order.

***

## Cart checkout examples

### Single bundle

Checking out with these items with these line item properties on Shopify:

| Item         | Quantity | Properties in the item                                             |
| :----------- | :------- | :----------------------------------------------------------------- |
| Banana       | 10       | `name="properties[__og_parent_product_id]" value="{fruit_box_id}"` |
| Orange Juice | 1        | `name="properties[__og_parent_product_id]" value="{fruit_box_id}"` |
| Apple        | 5        | `name="properties[__og_parent_product_id]" value="{fruit_box_id}"` |

Will create this bundle in Ordergroove:

**Single Bundle**

| Subscription parent product | Item         | Quantity |
| :-------------------------- | :----------- | :------- |
| fruit\_box\_id              | Banana       | 10       |
| fruit\_box\_id              | Orange Juice | 1        |
| fruit\_box\_id              | Apple        | 5        |

### Multiple bundles

Checking out with this items with these line item properties on Shopify:

| Item         | Quantity | Properties in the item                                                     |
| :----------- | :------- | :------------------------------------------------------------------------- |
| Banana       | 10       | `name="properties[__og_parent_product_id]" value="{fruit_box_id:bundle1}"` |
| Orange Juice | 1        | `name="properties[__og_parent_product_id]" value="{fruit_box_id:bundle1}"` |
| Apple        | 5        | `name="properties[__og_parent_product_id]" value="{fruit_box_id:bundle1}"` |
| Strawberry   | 2        | `name="properties[__og_parent_product_id]" value="{fruit_box_id:bundle2}"` |
| Grape        | 3        | `name="properties[__og_parent_product_id]" value="{fruit_box_id:bundle2}"` |
| Watermelon   | 1        | `name="properties[__og_parent_product_id]" value="{fruit_box_id:bundle2}"` |

Will create these two bundles in Ordergroove:

**Bundle 1**

| Subscription parent product | Item         | Quantity |
| :-------------------------- | :----------- | :------- |
| fruit\_box\_id              | Banana       | 10       |
| fruit\_box\_id              | Orange Juice | 1        |
| fruit\_box\_id              | Apple        | 5        |

**Bundle 2**

| Subscription parent product | Item       | Quantity |
| :-------------------------- | :--------- | :------- |
| fruit\_box\_id              | Strawberry | 2        |
| fruit\_box\_id              | Grape      | 3        |
| fruit\_box\_id              | Watermelon | 1        |

***

## Overriding item quantity

Here is an example of how this override works. When we add these properties to each of them, we will have the quantity overridden for the subscription created in Ordergroove for every item that has both the `__og_parent_product_id` and `__og_subscription_bundle_item_quantity` properties set.

| Item         | Quantity | Properties in the item                                                                                                                              | Quantity of items on checkout order | Quantity for bundle item created in the subscription for future orders |
| :----------- | :------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------- | :--------------------------------------------------------------------- |
| Banana       | 10       | `name="properties[__og_subscription_bundle_item_quantity]" value="5"`<br />`name="properties[__og_parent_product_id]" value="{bundle_product_id}"`  | 10                                  | 5                                                                      |
| Orange Juice | 2        | `name="properties[__og_parent_product_id]" value="{bundle_product_id}"`                                                                             | 2                                   | 2                                                                      |
| Apple        | 5        | `name="properties[__og_subscription_bundle_item_quantity]" value="10"`<br />`name="properties[__og_parent_product_id]" value="{bundle_product_id}"` | 5                                   | 10                                                                     |

## Product Subscription Swap

The Component Product Swap allows a customer to checkout with one product, but subscribe to another. To do so, you will need to set the `__og_parent_product_id` and `__og_subscription_bundle_item_product_swap` properties. The `__og_subscription_bundle_item_product_swap` should be set to the product id of the product that you would like to use for the subscription. You cannot swap to a bundle type product. For example:

| Checkout Item | Properties in the item                                                                                                                                                 | Checkout Order Items | Future Subscription Items |
| :------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------- | :------------------------ |
| Banana        | `name="properties[__og_subscription_bundle_item_product_swap]" value="{orange_juice_id}"`<br />`name="properties[__og_parent_product_id]" value="{bundle_product_id}"` | Banana               | Orange Juice              |

## Adding Additional Bundle Items

The `__og_subscription_bundle_item_additions` attribute allows a customer to checkout with one product, but subscribe to multiple products. To do so, you will need to set the `__og_parent_product_id` and `__og_subscription_bundle_item_additions` properties. The `__og_subscription_bundle_item_additions` should be a **stringified** JSON blob consisting of an array of objects, with each object containing two key-value pairs - one for the new product and one for its quantity.

Input Format:

* `__og_parent_product_id`: Set this to the Parent Product ID.
* `__og_subscription_bundle_item_additions`: This should be a stringified JSON blob, where each object represents a new product to be added to the subscription bundle, along with it's quantity. Each object in the array should contain two key-value pairs, like this `{"product": "<product_id>", "quantity": <quantity>}`. Note that any additional products cannot be a bundle type.

For example:

| Checkout Item | Properties in the item                                                                                                                                                                                                                           | Checkout Order Items | Future Subscription Items                     |
| :------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------- | :-------------------------------------------- |
| Banana        | `name="properties[__og_subscription_bundle_item_additions]" value='[{"product":"{orange_juice_id}","quantity":1},{"product":"{exquisite_apple_id}","quantity":2}]'`<br />`name="properties[__og_parent_product_id]" value="{bundle_product_id}"` | Banana               | Banana<br />Orange Juice<br />Exquisite Apple |

## Using Multiple Attributes

Attributes can be combined for increased customization. Here are a few examples:

| Scenario                                                  | Checkout Item | Properties in the item                                                                                                                                                                                                                                                                                                                                                                                                           | Checkout Order Items & Quantity | Future Subscription Items & Quantity                           |
| :-------------------------------------------------------- | :------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------ | :------------------------------------------------------------- |
| **Quantity Override and Product Swap**                    | Banana        | `name="properties[__og_subscription_bundle_item_quantity]" value="5"`<br />`name="properties[__og_subscription_bundle_item_product_swap]" value="{orange_juice_id}"`<br />`name="properties[__og_parent_product_id]" value="{bundle_product_id}"`                                                                                                                                                                                | Banana - 1                      | Orange Juice - 5                                               |
| **Product Swap and Additional Items**                     | Banana        | `name="properties[__og_subscription_bundle_item_product_swap]" value="{orange_juice_id}"`<br />`name="properties[__og_subscription_bundle_item_additions]" value='[{"product": "{grape_juice_id}", "quantity": 1}, {"product": "{exquisite_apple_id}", "quantity": 2}]'`<br />`name="properties[__og_parent_product_id]" value="{bundle_product_id}"`                                                                            | Banana - 1                      | Orange Juice - 1<br />Grape Juice - 1<br />Exquisite Apple - 2 |
| **Quantity Override, Product Swap, and Additional Items** | Banana        | `name="properties[__og_subscription_bundle_item_quantity]" value="5"`<br />`name="properties[__og_subscription_bundle_item_product_swap]" value="{grape_juice_id}"`<br />`name="properties[__og_subscription_bundle_item_additions]" value='[{"product": "{orange_juice_id}", "quantity": 1}, {"product": "{exquisite_apple_id}", "quantity": 2}]'`<br />`name="properties[__og_parent_product_id]" value="{bundle_product_id}"` | Banana - 1                      | Grape Juice - 5<br />Orange Juice - 1<br />Exquisite Apple - 2 |