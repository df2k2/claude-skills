# Rotating Subscriptions

Rotating Subscriptions allow your customers to subscribe to a curated, pre-planned, series of products. Ordergroove offers two different options to tailor your subscription plans:

* **Time Window:** The customer will receive a product that is determined based on when the order is shipped. Read the [Time-Window documentation](https://developer.ordergroove.com/docs/time-window-based-rotating-products) for more information.
* **Ordinal:** The customer will receive a product that is determined by where that order falls within a predefined list of order delivery products. Read the [Ordinal documentation](https://developer.ordergroove.com/docs/ordinal-based-rotating-products) for more information

***

## How Rotating Subscriptions Work

**Selection Mechanism**

Each type of Rotating Subscription program offers a unique way to determine what delivery product a customer should get with their order, allowing you to choose what works best for your business.

By configuring *Selection Rules* you can build out a Rotating Subscription program for your customers. Please refer to the documentation for more details on how each type of program works, and how to setup Rotating Products and Selection Rules.

**Pricing**

Three different pricing strategies are available for Rotating Subscriptions:

1. **Best Price (default):** The price of the Rotating Parent Product and the Delivery Product will be compared. The lower price will be used.
2. **Rotating Parent Product Price:** The price of the Rotating Parent Product will always be used.
3. **Delivery Product Price:** The price of the Delivery Product will always be used.

Pricing can be configured via the appropriate "management" endpoint. For example, see [https://developer.ordergroove.com/reference/manage-time-window-rotating-product](https://developer.ordergroove.com/reference/manage-time-window-rotating-product) for the Time Window management endpoint documentation.

**Bundles + Rotating Products**\
You can add rotating products to bundles just like any other regular products and they’ll work fine right out of the box! Everything that applies to regular products applies to rotating ones for creating and editing bundles.\
[\<https://developer.ordergroove.com/docs/bundle-subscriptions>](https://developer.ordergroove.com/docs/bundle-subscriptions)

**Prepaid + Rotating Products**\
You can sell your rotating products as prepaid just the way you would any other regular product. [https://developer.ordergroove.com/docs/how-to-manage-prepaid-renewal-behaviors](https://developer.ordergroove.com/docs/how-to-manage-prepaid-renewal-behaviors)

**Caveats**

We do not currently support any special logic for determining the initial checkout item’s rotating product. We are currently working on adding support for seamless initial checkout fulfillment but for the time being recommend simply sending out a default initial checkout product for this rotating product SKU.

**How to create a new Rotating Product**

1. Choose or create a regular product to set up as rotating product.\
   The product’s name, description, and image should reflect the fact that it is a rotating product.\
   Use the external product id of the product you have chosen or created
2. Define the selection rules for your rotation
   1. Follow the validation rules described in the program type's documentation.
3. Hit our API with your configuration, and your Rotating Product setup is complete!
   1. Time Window: [https://developer.ordergroove.com/reference/manage-time-window-rotating-product](https://developer.ordergroove.com/reference/manage-time-window-rotating-product)
   2. Ordinal: [https://developer.ordergroove.com/reference/manage-ordinal-rotating-product](https://developer.ordergroove.com/reference/manage-ordinal-rotating-product)

**How to view your Rotating Product Configuration**

You can view your configuration by simply querying for the product you used in our regular **[Product List](https://developer.ordergroove.com/reference/products-list)** and **[Products Retrieve](https://developer.ordergroove.com/reference/products-retrieve)** APIs and check for the new **product selection rules** property. Here's an example for a Rotating Product that uses Time-Window for it's selection criteria:

```json
"product_selection_rules": [
        {
            "public_id": "e1a61e620ed411ef8740767250df1ed7",
            "selection_rule_type": "TIME_WINDOW",
            "product_selection_list_elements": [
                {
                    "public_id": "e1a626000ed411ef8740767250df1ed7",
                    "product": "48398751432995",
                    "starting_date": "2024-05-01T00:00:00Z"
                },
                {
                    "public_id": "e1a62b140ed411ef8740767250df1ed7",
                    "product": "48398752317731",
                    "starting_date": "2024-06-01T00:00:00Z"
                },
                {
                    "public_id": "e1a62fe20ed411ef8740767250df1ed7",
                    "product": "48398760149283",
                    "starting_date": "2024-07-01T00:00:00Z"
                }
            ],
            "configuration": {
                "reveal_moment": "ORDER_PLACEMENT",
                "pricing_policy": "BEST_PRICE"
            }
        }
    ]
```

**How to update an existing Rotating Product**

1. Choose an existing Rotating Product, if you don’t have one yet you have to create one before you can update one.
2. Decide which **selection rules** you want to add, delete, or update one of the selection rules in your rotation
   1. All the same rules apply. If you don’t follow them your update won’t pass validation.
   2. Your changes will be reflected in all items that haven’t had their Order Reminder sent or gone through the Send Now flow.
   3. You can add a new selection rule.
   4. You can delete an existing selection rule.
   5. You can update an existing selection rule with a different product and or starting date.
3. Hit the appropriate management API for your rotation type with your configuration, and your Rotating Product setup is complete!
   1. Time Window: [https://developer.ordergroove.com/reference/manage-time-window-rotating-product](https://developer.ordergroove.com/reference/manage-time-window-rotating-product)
   2. Ordinal: [https://developer.ordergroove.com/reference/manage-ordinal-rotating-product](https://developer.ordergroove.com/reference/manage-ordinal-rotating-product)