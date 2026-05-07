# Order Events

## Order Event Object

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th style={{ textAlign: "left" }}>
        Name
      </th>

      <th style={{ textAlign: "left" }}>
        Type
      </th>

      <th style={{ textAlign: "left" }}>
        Description
      </th>

      <th style={{ textAlign: "left" }}>
        Example
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td style={{ textAlign: "left" }}>
        id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Identifier of the event
      </td>

      <td style={{ textAlign: "left" }}>
        “mmmm4444nnnn3333pppp”
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        type
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        The type of event that occurred
      </td>

      <td style={{ textAlign: "left" }}>
        See below for full list of event types
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        created
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Time since epoch when the event occurred
      </td>

      <td style={{ textAlign: "left" }}>
        1622589211
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Type
      </td>

      <td style={{ textAlign: "left" }}>
        See JSON below
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.type
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Resource type of event
      </td>

      <td style={{ textAlign: "left" }}>
        "Order"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.merchant
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Identifier of merchant
      </td>

      <td style={{ textAlign: "left" }}>
        "aaaa1111bbbb2222cccc"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Public ID of resource. Should be used to retrieve additional resource object data via OG API if necessary.
      </td>

      <td style={{ textAlign: "left" }}>
        "zzzz9999yyyy8888xxxx
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.customer
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        The merchant\_user\_id AKA the id from merchant system - not our internal public ID
      </td>

      <td style={{ textAlign: "left" }}>
        "h183738"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.payment
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Payment record ID
      </td>

      <td style={{ textAlign: "left" }}>
        "a748aa648ac811e8af3bbc764e106cf4"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.shipping\_address
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Shipping address record ID
      </td>

      <td style={{ textAlign: "left" }}>
        "66c25cd0564011e9abc5bc764e107990"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.sub\_total
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Subtotal of items in order
      </td>

      <td style={{ textAlign: "left" }}>
        "20.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.tax\_total
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Tax applied to order
      </td>

      <td style={{ textAlign: "left" }}>
        "5.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.shipping\_total
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Shipping cost applied to order
      </td>

      <td style={{ textAlign: "left" }}>
        "0.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.discount\_total
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Discount applied to order
      </td>

      <td style={{ textAlign: "left" }}>
        "0.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.total
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Total price of order
      </td>

      <td style={{ textAlign: "left" }}>
        "25.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.created
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the order was created
      </td>

      <td style={{ textAlign: "left" }}>
        1300375961
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.place
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Date for order placement

        Format: "YYYY-MM-DD"
      </td>

      <td style={{ textAlign: "left" }}>
        "2021-05-01"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.cancelled
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the order was cancelled
      </td>

      <td style={{ textAlign: "left" }}>
        1300375961
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.tries
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Number of attempts to place the order
      </td>

      <td style={{ textAlign: "left" }}>
        0
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.generic\_error\_count
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Number of times your system returned a generic error response when we attempted to place the order ("999")
      </td>

      <td style={{ textAlign: "left" }}>
        0
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.status
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Status enum
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.status\_display
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Readable version of status enum
      </td>

      <td style={{ textAlign: "left" }}>
        "Unsent"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.order\_merchant\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Order ID in your system after we have placed an order in your system and you respond that it was processed successfully.
      </td>

      <td style={{ textAlign: "left" }}>
        "ABC123"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.rejected\_message
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Message your system provides when you respond with "REJECT" to an order we attempt to place.

        Format/structure depends on what your responses. We store the string of what you provide.
      </td>

      <td style={{ textAlign: "left" }}>
        "Expiration Date is in the past"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.extra\_data
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Key/value store for any extra information
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.one\_click\_token
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        1-Click action token

        Only passed on order.reminder and order.refresh\_one\_click\_token events

        * *NOTE*\*: One Click Tokens need to be enabled by Ordergroove. Please reach out for more information.
      </td>

      <td style={{ textAlign: "left" }}>
        "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJtZXJjaGFudCI6IjAxZm"
      </td>
    </tr>
  </tbody>
</Table>

* Example data:

```json
{
  "id": "mmmm4444nnnn3333pppp",
  "type": "order.success",
  "created": 1622589211,
  "data": {
    "object": {
      "type": "order",
      "merchant": "aaaa1111bbbb2222cccc",
      "public_id": "zzzz9999yyyy8888xxxx",
      "customer": "m1234576",
      "payment": "a748aa648ac811e8af3bbc764e106cf4",
      "shipping_address": "66c25cd0564011e9abc5bc764e107990",
      "discount_total": "0.00",
      "shipping_total": "0.00",
      "sub_total": "0.00",
      "tax_total": "0.00",
      "total": "0.00",
      "extra_data": {},
      "generic_error_count": 0,
      "order_merchant_id": null,
      "place": "2021-04-06",
      "rejected_message": null,
      "status": 1,
      "status_display": "Unsent",
      "tries": 0,
      "cancelled": null,
      "created": 1301093861,
      "one_click_token": "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJtZXJjaGFudCI6IjAxZm"
    }
  }
}
```

## Order Event Types

* #### *order.change\_shipping\_address*
  Triggered when an order's shipping address is set. This event can be triggered more than once for an order.
* #### order.create
  Triggered when a new order is created. This event fires when the first product line item is added to the order, marking the creation of the order record.
* #### *order.change\_payment*
  Triggered when an order's payment is set. This event can be triggered more than once for an order.
* #### *order.change\_next\_order\_date*
  Triggered when an order's desired placement date is modified. This event can be triggered more than once for an order.
* #### *order.skip\_order*
  Triggered when an order is cancelled, meaning the order will not be placed. This event will only occur once for an order.
* #### *order.send\_now*
  Triggered when an order's placement date was moved up to today. The order will be placed as soon as possible.
* #### *order.cancel*
  Triggered when the placement response (response code "030") for an order indicates it should be cancelled and no longer attempted. This event will only occur once for an order.
* #### *order.success*
  Triggered when the placement response for an order indicates it was processed successfully and GMV was realized. This event will only occur once for an order.
* #### *order.delete*
  Triggered when an order is deleted. The webhook payload should be used solely to mark orders in your system as deleted. Fields like total, sub\_total, and tax\_total represent a snapshot from when the order was deleted. They do not reflect the "current reality" of the order (e.g., totals as “0”) since deleted orders no longer include their items.
* #### *order.generic\_error*
  Triggered when the placement response for an order indicates an unknown error occurred (response code "999") and should be retried. This event can be triggered more than once for an order.
* #### *order.reject*
  Triggered when the placement response for an order indicates the order was rejected, no GMV was realized, and the order should not be retried. This event will only occur once for an order.
* #### *order.reminder*
  Triggered when a reminder notification is sent to a customer for an upcoming order that will be placed (usually within the next few days). This event can be triggered more than once for an order, but generally occurs only once.
* #### *order.retryable\_placement\_failure*
  Triggered when the placement response for an order indicates it should be processed through our configurable retry flow. This event can be triggered more than once for an order and will only occur if your program is configured to use this feature.
* #### *order.refresh\_one\_click\_token*
  Triggered when the previous 1-Click token is used.

<br />