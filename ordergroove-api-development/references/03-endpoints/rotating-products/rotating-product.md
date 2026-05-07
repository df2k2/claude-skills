# Time-Window Rotating Product

## What Time-Window based Rotating Products Do

Time-Window based Rotating Products allow your customers to subscribe to a pre-determined series of products. They'll receive the series of products in your set order, starting on the initial subscription date, and continuing down the series each time an order is sent for placement.

## How Time-Window based Rotating Products Work

Time-Window based Rotation depends on creating a list of **selection rules** (products associated with a starting date).

Each selection rule has a product, starting date, and public id. Starting dates are inclusive.

There are no explicitly defined ending dates for any single **selection rule** — ending dates for a rule are determined by the nearest upcoming starting date of the other selection rules. The implicit ending date is **exclusive** since it is also the starting date of a different selection rule.

![](https://files.readme.io/a3c609a-Screenshot_2024-05-22_at_11.44.27_AM.png)

In the image above shipped **from date** is *inclusive\_of that date, while the **to date** is \_exclusive*.

There are **4 validation rules** for defining Time-Window selection rules:

1. You must define at least one selection rule (we wouldn’t have anything to choose otherwise)
2. One of the selection rules must have a starting date in the past (so that we don’t ever have an invalid state where we don’t know which product should be delivered)
3. No two selection rules can have the same starting date (otherwise we wouldn’t know which product to choose between them, but you can have multiple selection rules with the same product)
4. All starting dates must be in ISO8601 format with timezone. The timezone will be stored in UTC.

If validation fails no changes will be made to the product and no selection rules will be created, updated or deleted.

**Product Selection**

The product sent out for fulfillment during [Order Placement](https://developer.ordergroove.com/docs/recurring-order-placement) will be based on the order’s place date of the item at Order Reminder time for normal flows.

For [Send Now](https://developer.ordergroove.com/reference/orders-send-now) flows we will use the current date (at the time at which Send Now is triggered) to figure out which product to send out for fulfillment during Order Placement.

If the Order Reminder occurred before Send Now, the product will still be based on what was chosen during Order Reminder time.

\*\*Timezones: When defining selection rules, timezones are required, this assures we take them into account properly when choosing the proper selection rule in both of these flows.

**Pricing**

Three different pricing strategies are available for Rotating Subscriptions:

1. **Best Price (default):** The price of the Rotating Parent Product and the Delivery Product will be compared. The lower price will be used.
2. **Rotating Parent Product Price:** The price of the Rotating Parent Product will always be used.
3. **Delivery Product Price:** The price of the Delivery Product will always be used.

**Bundles + Rotating Products**\
You can add rotating products to bundles just like any other regular products and they’ll work fine right out of the box! Everything that applies to regular products applies to rotating ones for creating and editing bundles.\
See [https://developer.ordergroove.com/docs/bundle-subscriptions](https://developer.ordergroove.com/docs/bundle-subscriptions) for more details.

**Prepaid + Rotating Products**\
You can sell your rotating products as prepaid just the way you would any other regular product. The rotating product's price will be utilized to determine the renewal price.\
See [https://developer.ordergroove.com/docs/how-to-manage-prepaid-renewal-behaviors](https://developer.ordergroove.com/docs/how-to-manage-prepaid-renewal-behaviors) for more details.

**How to view your Rotating Product Configuration**\
You can view your configuration by simply querying for the product you used in our regular **[Product List](https://dash.readme.com/project/og-restrpc/v2.10.0/refs/products-list)** and **[Products Retrieve](https://dash.readme.com/project/og-restrpc/v2.10.0/refs/products-retrieve)** APIs and check for the new **product selection rules** property:

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

### Caveats

We do not currently support any special logic for determining the initial checkout item’s rotating product. We are currently working on adding support for seamless initial checkout fulfillment but for the time being recommend simply sending out a default initial checkout product for this rotating product SKU.