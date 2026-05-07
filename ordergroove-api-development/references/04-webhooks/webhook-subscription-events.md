# Subscription Events

Subscription webhook event object structure and event types for OrderGroove API

## Subscription Event Object

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
        "mmmm4444nnnn3333pppp"
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
        "Subscription"
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
        "zzzz9999yyyy8888xxxx"
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
        data.object.product
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        The external product ID from the merchant's system
      </td>

      <td style={{ textAlign: "left" }}>
        "SKUabc"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.components
      </td>

      <td style={{ textAlign: "left" }}>
        array
      </td>

      <td style={{ textAlign: "left" }}>
        List of objects representing the bundle components/products
      </td>

      <td style={{ textAlign: "left" }}>
        \[<br />
          {`{`}<br />
            "product": "product\_1",<br />
            "public\_id": "public\_id\_1",<br />
            "quantity": null<br />
          {`},`}<br />
          {`{`}<br />
            "product": "product\_2",<br />
            "public\_id": "public\_id\_2",<br />
            "quantity": 2<br />
          {`}`}<br />
        ]
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

      <td style={{ textAlign: "left" }}>
        {`{"some": "extra", "fields": "here"}`}
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.prepaid\_subscription\_context
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        [Prepaid information](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data)<br />
        Returned only if prepaid is enabled
      </td>

      <td style={{ textAlign: "left" }}>
        {`{`}

        <br />

        "prepaid\_orders\_remaining": 0,<br />
        "prepaid\_orders\_per\_billing": 3,<br />
        "renewal\_behavior": "autorenew",<br />
        "last\_renewal\_revenue": 100.8,<br />
        "prepaid\_origin\_merchant\_order\_id": "#3082"<br />
        {`}`} | null
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.quantity
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Number of items
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.price
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Price of the subscription when leveraging price lock feature
      </td>

      <td style={{ textAlign: "left" }}>
        "12.99"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.frequency\_days
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Order placement interval in days
      </td>

      <td style={{ textAlign: "left" }}>
        30
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.reminder\_days
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Days before order placement to email reminder (minimum of 5)
      </td>

      <td style={{ textAlign: "left" }}>
        5
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.every
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Number of periods
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.every\_period
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Type of period enum<br />
        Options: 1, 2, 3
      </td>

      <td style={{ textAlign: "left" }}>
        3
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.every\_period\_display
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Readable version of period enum<br />
        Options: "Days", "Weeks", "Months"
      </td>

      <td style={{ textAlign: "left" }}>
        "Months"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.cancelled
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the subscription was cancelled, if no longer active.
      </td>

      <td style={{ textAlign: "left" }}>
        1301325188
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.cancel\_reason
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Pipe-delimited cancel reason code and cancel reason details
      </td>

      <td style={{ textAlign: "left" }}>
        "4|Overstocked"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.cancel\_reason\_code
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Code ID of the cancel reason
      </td>

      <td style={{ textAlign: "left" }}>
        4
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.session\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Session ID, obtained from og\_session\_id cookie
      </td>

      <td style={{ textAlign: "left" }}>
        "aaaa1111bbbb2222cccc.450125.1299622365"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.merchant\_order\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Order ID in your system, corresponding to the checkout that created the subscription.
      </td>

      <td style={{ textAlign: "left" }}>
        "12345678"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.live
      </td>

      <td style={{ textAlign: "left" }}>
        bool
      </td>

      <td style={{ textAlign: "left" }}>
        Dictates if the subscription is active or inactive. "Active" meaning that the customer wants to continue receiving the product at the frequency cadence; "Inactive' meaning they do not.
      </td>

      <td style={{ textAlign: "left" }}>
        true
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.external\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        External representation of the subscription in your system. In the case of Shopify integrations, this is the Shopify contract ID.
      </td>

      <td style={{ textAlign: "left" }}>
        "external-identifier"
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
        Unix timestamp when the subscription was created
      </td>

      <td style={{ textAlign: "left" }}>
        1300375961
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.start\_date
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Date the subscription started.<br />
        Format: "YYYY-MM-DD"
      </td>

      <td style={{ textAlign: "left" }}>
        "2021-03-25"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.offer
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Offer record ID
      </td>

      <td style={{ textAlign: "left" }}>
        "a748aa648ac811e8af3bbc764e106cf4"
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
        "070001bc02fd11e99542bc764e1043b0"
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
        data.object.updated
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the subscription was updated
      </td>

      <td style={{ textAlign: "left" }}>
        1300375961
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.one\_click\_token
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        1-Click action token<br /><br />
        Only passed on subscription.create, subscription.cancel, and subscription.refresh\_one\_click\_token events<br /><br />
        **NOTE**: One Click Tokens need to be enabled by Ordergroove. Please reach out for more information.
      </td>

      <td style={{ textAlign: "left" }}>
        "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJtZXJjaGFudCI6IjAxZm"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.context.source
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Dictates where the event came from. Regular checkout subscription will have the value "PurchasePOST", but if it got created during program import its value will be "XML IMPORT"
      </td>

      <td style={{ textAlign: "left" }}>
        "XML IMPORT"
      </td>
    </tr>
  </tbody>
</Table>

### Example data:

```json
{
  "id": "mmmm4444nnnn3333pppp",
  "type": "subscription.create",
  "created": 1622589211,
  "data": {
    "object": {
      "type": "subscription",
      "merchant": "aaaa1111bbbb2222cccc",
      "public_id": "zzzz9999yyyy8888xxxx",
      "customer": "m1234576",
      "product": "SKUabc",
      "components": [  
        {
          "product": "product_1",  
          "public_id": "public_id_1",  
          "quantity": null  
        },  
        {  
          "product": "product_2",  
          "public_id": "public_id_2",  
          "quantity": 2  
        }  
      ],
      "extra_data": {},
      "quantity": 1,
      "price": null,
      "frequency_days": 56,
      "reminder_days": 10,
      "every": 2,
      "every_period": 2,
      "every_period_display": "Weeks",
      "cancelled": 1301325188,
      "cancel_reason": "",
      "cancel_reason_code": null,
      "session_id": "aaaa1111bbbb2222cccc.450125.1299622365",
      "merchant_order_id": "12345678",
      "live": true,
      "external_id": null,
      "created": 1300375961,
      "start_date": "2021-03-25",
      "offer": "a748aa648ac811e8af3bbc764e106cf4",
      "payment": "070001bc02fd11e99542bc764e1043b0",
      "shipping_address": "66c25cd0564011e9abc5bc764e107990",
      "updated": 1300375961,
      "one_click_token": "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJtZXJjaGFudCI6IjAxZm",
      "prepaid_subscription_context": {  
        "prepaid_orders_remaining": 0,  
        "prepaid_orders_per_billing": 3,  
        "renewal_behavior": "autorenew",  
        "last_renewal_revenue": 100.8,  
        "prepaid_origin_merchant_order_id": "#3082"  
      }
    },
   "context":{
      "source":"PurchasePOST"
    }
  }
}
```

## Subscription Event Types

<HTMLBlock>
  {`
  <div>
    <ul>
      <li>
      	<h4>
        	<i>subscription.create</i>
      	</h4>
      </li>
      <div>
        Triggered whenever the customer creates a subscription. This event can only be triggered once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.cancel</i>
        </h4>
      </li>
      <div>
        Triggered whenever a subscription is cancelled. This event can be triggered more than once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.sku_swap</i>
        </h4>
      </li>
      <div>
        Triggered when the product associated with a subscription is changed. 
        This event can be triggered more than once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.change_live</i>
        </h4>
      </li>
      <div>
        Triggered when a cancelled subscription is reactivated. 
        This event can be triggered more than once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.change_frequency</i>
        </h4>
      </li>
      <div>
        Triggered when the subscription's delivery frequency is modified. 
        This event can be triggered more than once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.change_components</i>
        </h4>
      </li>
      <div>
        For subscriptions associated with bundles, this is triggered when
        a product is updated, added, or removed from the list of bundle components
        of the subscription.
        This event can be triggered more than once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.change_quantity</i>
        </h4>
      </li>
      <div>
        Triggered when the subscription's quantity is modified. 
        This event can be triggered more than once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.change_shipping_address</i>
        </h4>
      </li>
      <div>
        Triggered when a subscription's shipping address is set.
        This event can be triggered more than once for a subscription.
      </div>

      <li>
        <h4>
          <i>subscription.change_payment</i>
        </h4>
      </li>
      <div>
        Triggered when a subscription's payment is set.
        This event can be triggered more than once for a subscription.
      </div>
      
      <li>
        <h4>
          <i>subscription.refresh_one_click_token</i>
        </h4>
      </li>
      <div>
        Triggered when the previous 1-Click token is used.
      </div>
      
  <style></style>
  `}
</HTMLBlock>