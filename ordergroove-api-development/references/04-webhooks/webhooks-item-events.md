# Item Events

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

***

## Response Body Definitions

| Name                           | Type             | Description                                                                                                                                               | Example                                                |
| ------------------------------ | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| customer                       | string           | Customer ID                                                                                                                                               | `"00026001"`                                           |
| merchant                       | string           | Merchant ID                                                                                                                                               | `"ac4f7938383a11e89ecbbc764e1107f2"`                   |
| product                        | string           | Product ID                                                                                                                                                | `"0070000693"`                                         |
| payment                        | string           | Payment record ID                                                                                                                                         | `"070001bc02fd11e99542bc764e1043b0"`                   |
| shipping\_address              | string           | Shipping address record ID                                                                                                                                | `"66c25cd0564011e9abc5bc764e107990"`                   |
| offer                          | string           | Offer ID                                                                                                                                                  | `"a748aa648ac811e8af3bbc764e106cf4"`                   |
| subscription\_type             | string           | Subscription Type                                                                                                                                         | `"Replenish"`                                          |
| components                     | string           | Legacy Bundle components                                                                                                                                  | `"product_id_1,product_id_2"`                          |
| components                     | array of objects | New Bundle components                                                                                                                                     | See example below                                      |
| extra\_data                    | string           | Raw JSON string that should be JSON.parse() as key/value store for any extra information                                                                  | See example below                                      |
| public\_id                     | string           | Subscription ID                                                                                                                                           | `"f9cb2f93e1c845eb9de9eff46ddb3cbf"`                   |
| product\_attribute             | string           |                                                                                                                                                           | `"null"`                                               |
| quantity                       | integer          | Number of items                                                                                                                                           | `21`                                                   |
| price                          | string           | Price                                                                                                                                                     | `"12.99"`                                              |
| frequency\_days                | integer          | Order placement interval in days                                                                                                                          | `42`                                                   |
| reminder\_days                 | integer          | Days before order placement to email reminder (minimum of 5)                                                                                              | `42`                                                   |
| every                          | integer          | Number of periods                                                                                                                                         | `6`                                                    |
| every\_period                  | integer          | Type of period                                                                                                                                            | `3`                                                    |
| start\_date                    | string           | Date of subscription start, in format YYYY-MM-DD                                                                                                          | `"2019-07-21"`                                         |
| cancelled                      | string           | Date of subscription cancellation; null=not cancelled                                                                                                     | `"null"`                                               |
| cancel\_reason                 | string           | Pipe-delimited cancel reason code and cancel reason details                                                                                               | `"4\|Overstocked"`                                     |
| cancel\_reason\_code           | string           | Cancel reason code                                                                                                                                        | `"4"`                                                  |
| ~~iteration~~                  | string           |                                                                                                                                                           | *Deprecated*                                           |
| ~~sequence~~                   | string           |                                                                                                                                                           | *Deprecated*                                           |
| session\_id                    | string           | Session ID, obtained from og\_session\_id cookie                                                                                                          | `"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"` |
| merchant\_order\_id            | string           | Order ID in your system                                                                                                                                   | `"301617"`                                             |
| ~~customer\_rep~~              | string           |                                                                                                                                                           | *Deprecated*                                           |
| ~~club~~                       | string           |                                                                                                                                                           | *Deprecated*                                           |
| created                        | string           | Date created                                                                                                                                              | `"2017-02-29 12:00:00"`                                |
| updated                        | string           | Date updated                                                                                                                                              | `"2017-02-29 12:00:00"`                                |
| live                           | boolean          | True=active subscription; False=inactive subscription                                                                                                     | `true`                                                 |
| prepaid\_subscription\_context | object           | [Prepaid information](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data) - Returned only if prepaid is enabled | See example below                                      |

***

## Example Data

```json
{
  "id": "mmmm4444nnnn3333pppp",
  "type": "item.create",
  "created": 1622589211,
  "data": {
    "object": {
      "type": "item",
      "merchant": "aaaa1111bbbb2222cccc",
      "public_id": "zzzz9999yyyy8888xxxx",
      "customer": "m1234576",
      "product": "SKUabc",
      "order": "1234e74444dd115555d8bc7cccc043b0",
      "subscription": "bc7cccc043b01234e74444155",
      "offer": "a748aa648ac811e8af3bbc764e106cf4",
      "quantity": 1,
      "price": "20.00",
      "total_price": "20.00",
      "first_placed": null,
      "components": [
        {"product": "product_1"},
        {"product": "product_2"}
      ]
    }
  }
}
```

### Components Array Example (New Bundle)

```json
[
  {
    "public_id": "79d2dc76245111eeb185acde48001122",
    "quantity": 1,
    "product": "0070067690"
  },
  {
    "public_id": "7eeaa504245111eeb185acde48001122",
    "quantity": 3,
    "product": "0070067691"
  }
]
```

**Component Object Structure:**

* `public_id`: string
* `quantity`: integer
* `product`: string

### Extra Data Example

```json
{
  "some": "extra",
  "fields": "here"
}
```

### Prepaid Subscription Context Example

```json
{
  "prepaid_orders_remaining": 0,
  "prepaid_orders_per_billing": 3,
  "renewal_behavior": "autorenew",
  "last_renewal_revenue": 100.8,
  "prepaid_origin_merchant_order_id": "#3082"
}
```

Or empty object: `{}`

## Item Event Types

### `item.create`

Triggered when an item is created. This event will only occur once for an item, but can occur many times for the associated subscription.

### `item.change_order`

Triggered when a product line item is reassigned from one order (or box) to another. This usually happens when an order contains multiple line items and the shipping date for one item is modified, resulting in the item being moved to a new order with the desired shipping date.

### `item.change_quantity`

Triggered when the quantity of an item is modified. This event can be triggered more than once for an item.

### `item.remove`

Triggered when the item is removed from an order. When this happens, it is deleted from the order. If the item was associated with an active subscription, a corresponding `item.create` event will be generated. This event will only occur once for an item, but can occur many times for the associated subscription.

### `item.item_subscribe`

Triggered when a subscription is created from an item that originally was a "one-time" item - an item in an order that customer had not subscribed to. This event will only occur once for an item.

### `item.update_price`

Triggered when the price of an item is updated. This event can be triggered more than once for an item.

**NOTE:** This event can only be triggered when the [update item price API endpoint](https://og-restrpc.readme.io/reference/items-change-price) is used.

### `item.successfully_placed`

Triggered when the associated order's placement response indicates it was processed successfully and GMV was realized. This event will only occur once for an item, but can occur many times for the associated subscription.

Related: [order.success event](https://og-restrpc.readme.io/docs/order-events#order-event-types)

### `item.out_of_stock`

Triggered when an item is detected as not having enough inventory to be fulfilled. The Ordergroove application moves the item to be attempted for processing the next day. The payload provides the order the item was moved to.

**NOTE:** This retry mechanism occurs a limited number of times. At the end of the retry cycle the item is deleted. This event is not triggered at the end of the retry cycle.

<br />