# Configure Webhooks via API

Ordergroove can send webhook events to an endpoint or endpoints of your choosing. In order to set up which webhook events you want triggered to which endpoint, you'll need to:

1. Configure each target endpoint that you want event to be sent to
2. Configure which events you want sent to the target endpoint

> 🚧 Legacy Method
>
> We recommend setting up webhooks directly in the Ordergroove merchant dashboard under Developers > [Webhooks](https://rc3.ordergroove.com/webhooks/). If you need to set up webhooks via API, please contact your Customer Success Manager or technical resource at Ordergroove.

***

## Authentication

We recommend you set up webhooks directly in the [Ordergroove merchant dashboard](https://rc3.ordergroove.com/), under *Developers > Webhooks*. If you need to set webhooks up via API, please contact your Customer Success Manager or technical resource at Ordergroove to discuss Authentication options.

***

## Creating a Target Endpoint

> 📘 Platform - Shopify
>
> For merchants on Shopify, please make sure you create a new Target Endpoint and do not update or use an existing endpoint that is configured for Shopify Event Notifications.

**Destination**

Staging: [https://staging.webhooks.ordergroove.com/webhook\_targets/](https://staging.webhooks.ordergroove.com/webhook_targets/)\
Production: [https://webhooks.ordergroove.com/webhook\_targets/](https://webhooks.ordergroove.com/webhook_targets/)

```Text Request Body Example
{
    "merchant": "abc12345",
    "target_url": "https://www.mywebhooktargeturl.com/receive/",
    "enabled": true
}
```

```Text Success Response
{
"id": "5f15ef298dc15df9bc6eda35"
"merchant": "abc12345",
"target_url": "https://www.mywebhooktargeturl.com/receive/",
"enabled": true,
"created": 1595273001,
"updated": 1597260663
}
```

For more information on all Targets that exist, how to update Targets, or how to get Target metrics check out our [Webhook Targets REST endpoint documentation](https://og-restrpc.readme.io/reference/webhook-targets-list) for additional details.

***

## Defining Events to send to Webhook Target

Once you've created a Webhook Target, you can define which events you want to be sent to that endpoint. The ID returned in the response of the Target Creation step is what will be used in this API request for the target\_id in the path param.

Destination:

Staging: [https://staging.webhooks.ordergroove.com/webhook\_targets/\*\*\_\{target\_id}\_\*\*/filters](https://staging.webhooks.ordergroove.com/webhook_targets/**_\{target_id}_**/filters)\
Production: [https://webhooks.ordergroove.com/webhook\_targets/\_\*\*\{target\_id}\*\*\_/filters](https://webhooks.ordergroove.com/webhook_targets/_**\{target_id}**_/filters)

Example Request Body:

*To define multiple events, use a pipe separator as shown*

```Text Example Request Body
{"pattern":"subscription.*|order.*"}
```

**Subscriber Event Filters**

* subscriber.create
* subscriber.cancel
* subscriber.\* (for all events)

**Subscription Event Filters**

* subscription.create  (this event is not triggered when creation is from your Ordergroove Admin)
* subscription.cancel
* subscription.sku\_swap
* subscription.reactivate
* subscription.change\_frequency
* subscription.change\_components
* subscription.change\_quantity
* subscription.change\_shipping\_address
* subscription.change\_payment
* subscription.change\_live
* subscription.\* (for all events)

**Order Event Filters**

* order.change\_shipping\_address
* order.change\_payment
* order.change\_billing
* order.change\_next\_order\_date (this event is not triggered when creation is from your Ordergroove Admin)
* order.skip\_order
* order.send\_now
* order.cancel
* order.success
* order.generic\_error
* order.reject
* order.reminder
* order.retryable\_placement\_failure
* order.\* (for all events)

**Order Item Event Filters**

* item.create
* item.change\_quantity
* item.remove
* item.item\_subscribe
* item.update\_price
* item.successfully\_placed
* item.\* (for all events)

***

## Receiving Event Notifications

### Payload Verification

Requests will be signed using the HMAC-SHA256 algorithm with a symmetric key we store and share with you at the time of configuration.

A webhook event will be delivered with the request header “OrderGroove-Signature” which will contain

* a timestamp of transmission
* a hex-encoded representation of a signature generated with HMAC-SHA256

```Text Example Signature
OrderGroove-Signature: ts=1592570791,sig=5257a869e7ecebeda32affa62cdca3fa51cad7e77a0e56ff536d0ce8e108d8bd
```

It is strongly encouraged to verify the authenticity of events. A python example below shows how one might go about using the JSON values provided in the header to verify the signature provided in the header.

```python
ts = "1592570791"
payload = u''
sig_key = "shared symmetric key"
sig_input = "{ts}.{payload}".format(ts=ts, payload=payload)

hash_obj = hmac.new(key=bytes(sig_key, 'ascii'), msg=bytes(sig_input, 'utf-8'), digestmod=hashlib.sha256)
generated_sig = hash_obj.hexdigest() # “5257a869e7....”
return generated_signature == header_signature
```

As shown above, by the sig\_input variable, the signature is driven by

* the timestamp provided in the request header
* a period (.)
* the payload of the webhook event

**Signing Key Retrieval**

Signing keys are considered sensitive data and should only be retrieved when absolutely necessary.

Staging: [https://staging.webhooks.ordergroove.com/webhook\_targets/](https://staging.webhooks.ordergroove.com/webhook_targets/)\<target\_id>/signing\_key\
Production: [https://webhooks.ordergroove.com/webhook\_targets/](https://webhooks.ordergroove.com/webhook_targets/)\<target\_id>/signing\_key

```Text Response Sample
{
  "signing_key": "5f15ef298dc15df9bc6eda35"
}
```

**Signing Key Rotation**

Like passwords, keys should be rotated on a regular basis. While we do not dictate this cadence (yet), you may rotate keys for a particular target on demand. Once this process is activated, events will be delivered with one signature for each active key.

Patch Request Destination:

Staging: [https://staging.webhooks.ordergroove.com/webhook\_targets/](https://staging.webhooks.ordergroove.com/webhook_targets/)\<target\_id>/signing\_key/rotate\
Production: [https://webhooks.ordergroove.com/webhook\_targets/](https://webhooks.ordergroove.com/webhook_targets/)\<target\_id>/signing\_key

```Text Response Sample
{
  "signing_key": "5f15ef298dc15df9bc6eda35",
  "expiring_signing_key": "GBBYToAvYGBBYToAvYGBBYToAvY",
  "signing_key_expiry": 1597260663
}
```

The signing\_key\_expiry field will tell you when the expiring\_signing\_key will be discarded and no longer used. Consecutive requests to this endpoint will generate a new value in the signing\_key, but the timer for the signing\_key\_expiry will not update. You will have 24 hours from the first time this endpoint is hit to make sure your applications are using the new key, whichever it may be. Any subsequent requests sent to the "Signing Key Retrieval" endpoint will only respond with the new key.

**Key Rotation**

If the rotation of a signing key occurred, there will be two sig fields present, providing one signature for each key.

```Text Example Signiture
sig=5257a869e7ecebeda32affa62cdca3fa51cad7e77a0e56ff536d0ce8e108d8bd,sig=da32affa62cdca35257a869e7e56ff536d0ce8e108d8bdcebefa51cad7e77a0e
```

**Retries and Automatic URL disabling**

Retries: If a target does not return a 2xx HTTP response status, the delivery of the event will be retried for no more than 3 days using an exponential back-off for each subsequent retry attempt. After 3 days, the delivery will be marked as a failure. The first retry will be delayed for 60 seconds and will be subsequently doubled.

URL Disabling: After 3 days, if a target does not provide a 2xx HTTP response status, the URL will automatically be disabled. Any success will reset the disable logic. Re-enabling a disabled URL will also reset the disable logic.

***

## Subscriber Events Response

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="background-color: #039de7; color: #fff; font-weight: bold;">
        <th style="width: 25%;">Name</th>
        <th style="width: 9%;">Type</th>
        <th style="width: 30.4285%;">Description</th>
        <th style="width: 35.5714%;">Example</th>
      </tr>
      <tr>
        <td style="width: 25%;">id</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Identifier of the event</td>
        <td style="width: 35.5714%;">“mmmm4444nnnn3333pppp”</td>
      </tr>
      <tr>
        <td style="width: 25%;">type</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">The type of event that occurred</td>
        <td style="width: 35.5714%;">See below for full list of event types</td>
      </tr>
      <tr>
        <td style="width: 25%;">created</td>
        <td style="width: 9%;">int</td>
        <td style="width: 30.4285%;">Time since epoch when the event occurred</td>
        <td style="width: 35.5714%;">1622589211</td>
      </tr>
      <tr>
        <td style="width: 25%;">data</td>
        <td style="width: 9%;">json</td>
        <td style="width: 30.4285%;">Type</td>
        <td style="width: 35.5714%;">see below json bock</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.type</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Resource type of event</td>
        <td style="width: 35.5714%;">"Subscription"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.merchant</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Identifier of merchant</td>
        <td style="width: 35.5714%;">"aaaa1111bbbb2222cccc"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.merchant_user_id</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">ID of consumer from merchant system.</td>
        <td style="width: 35.5714%;">"dddjjjjkk3343"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.subscription</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">
          ID of corresponding subscription that triggered the subscriber event
        </td>
        <td style="width: 35.5714%;">
          "<span>ssss3333llll2222bbbb"</span>
        </td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.session_id</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Session ID obtained from og_session_id cookie if present</td>
        <td style="width: 35.5714%;">
          "<span>aaaa1111bbbb2222cccc.450125.1299622365"</span>
        </td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.first_name</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Customer first name</td>
        <td style="width: 35.5714%;">"John"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.last_name</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Customer last name</td>
        <td style="width: 35.5714%;">"Smith"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.email</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Customer email</td>
        <td style="width: 35.5714%;">"john.smith@email.com"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.phone_number</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">Customer phone number</td>
        <td style="width: 35.5714%;">"555-555-5555"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.phone_type</td>
        <td style="width: 9%;">int</td>
        <td style="width: 30.4285%;">Phone type enum</td>
        <td style="width: 35.5714%;">2</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.phone_type_display</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">
          <p>Readable version of phone type enum</p>
          <p>Options:&nbsp;</p>
          <p>"invalid",</p>
          <p>"landline",</p>
          <p>"mobile",</p>
          <p>"voip"</p>
        </td>
        <td style="width: 35.5714%;">"mobile"</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.live</td>
        <td style="width: 9%;">bool</td>
        <td style="width: 30.4285%;">
          <p>
            Customer status. "True" if they have any subscription active,
            false if no subscriptions are active
          </p>
        </td>
        <td style="width: 35.5714%;">true</td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.created</td>
        <td style="width: 9%;">int</td>
        <td style="width: 30.4285%;">
          <p>Unix timestamp when the customer was created</p>
        </td>
        <td style="width: 35.5714%;">
          <span>1298407706</span>
        </td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.last_updated</td>
        <td style="width: 9%;">int</td>
        <td style="width: 30.4285%;">
          <p>Unix timestamp when the customer was last updated</p>
        </td>
        <td style="width: 35.5714%;">
          <span>1301323663</span>
        </td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.extra_data</td>
        <td style="width: 9%;">object</td>
        <td style="width: 30.4285%;">
          <p>
            Key/value store for any extra information about the customer
          </p>
        </td>
        <td style="width: 35.5714%;">
          <span>{"some":"extra","fields":"here"}</span>
        </td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.locale</td>
        <td style="width: 9%;">int</td>
        <td style="width: 30.4285%;">
          <p>Locale enum</p>
          <p>Options 1-46</p>
        </td>
        <td style="width: 35.5714%;">
          <span>1</span>
        </td>
      </tr>
      <tr>
        <td style="width: 25%;">data.object.locale_display</td>
        <td style="width: 9%;">str</td>
        <td style="width: 30.4285%;">
          <p>Readable version of locale enum</p>
        </td>
        <td style="width: 35.5714%;">"en-us"</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

```Text Example Data
{
  "id": "mmmm4444nnnn3333pppp",
  "type": "subscriber.create",
  "created": 1622589211,
  "data": {
    "object": {
      "type": "subscriber",
      "merchant": "aaaa1111bbbb2222cccc",
      "merchant_user_id": "dddjjjjkk3343",
      "subscription": "ssss3333llll2222bbbb",
      "session_id": "aaaa1111bbbb2222cccc.450125.1299622365",
      "first_name": "John",
      "last_name": "Smith",
      "email": "john.smith@email.com",
      "phone_number": "555-555-5555",
      "phone_type": 2,
      "phone_type_display": "mobile",
      "live": true,
      "created": 1298407706,
      "last_updated": 1301323663,
      "extra_data": {},
      "locale": 1,
      "locale_display": "en-us",
    }
  }
}
```

***

## Subscription Events Response

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="background-color: #039de7; color: #fff; font-weight: bold;">
        <th style="width: 23.2857%;">Name</th>
        <th style="width: 7.85714%;">Type</th>
        <th style="width: 36.1429%;">Description</th>
        <th style="width: 32.7143%;">Example</th>
      </tr>
      <tr>
        <td style="text-align: left;">id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Identifier of the event</td>
        <td style="text-align: left;">“mmmm4444nnnn3333pppp”</td>
      </tr>
      <tr>
        <td style="text-align: left;">type</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">The type of event that occurred</td>
        <td style="text-align: left;">See below for full list of event types</td>
      </tr>
      <tr>
        <td style="text-align: left;">created</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Time since epoch when the event occurred</td>
        <td style="text-align: left;">1622589211</td>
      </tr>
      <tr>
        <td style="text-align: left;">data</td>
        <td style="text-align: left;">object</td>
        <td style="text-align: left;">Type</td>
        <td style="text-align: left;">See JSON below</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.type</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Resource type of event</td>
        <td style="text-align: left;">"Subscription"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.merchant</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Identifier of merchant</td>
        <td style="text-align: left;">"aaaa1111bbbb2222cccc"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.public_id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Public ID of resource. Should be used to retrieve additional resource
          object data via OG API if necessary.
        </td>
        <td style="text-align: left;">"zzzz9999yyyy8888xxxx</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.customer</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          The merchant_user_id AKA the id from merchant system - not our internal
          public ID
        </td>
        <td style="text-align: left;">"h183738"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.product</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">The external product ID from the merchant's system</td>
        <td style="text-align: left;">"SKUabc"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.components</td>
        <td style="text-align: left;">array</td>
        <td style="text-align: left;">List of objects representing the bundle components/products</td>
        <td style="text-align: left;">
          [<br>
          &ensp;{<br>
           &emsp;"product": "product_1",<br>
           &emsp;"public_id": "d4f6d3e4fdd311eebebd06c0a416f30c",<br>
           &emsp;"quantity": 1<br>
          &ensp;}<br>
          ]
        </td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.prepaid_subscription_context</td>
        <td style="text-align: left;">object</td>
        <td style="text-align: left;">Prepaid information returned only if prepaid is enabled</td>
        <td style="text-align: left;">{  
          "prepaid_orders_remaining": 0,  
          "prepaid_orders_per_billing": 3,  
          "renewal_behavior": "autorenew",  
          "last_renewal_revenue": 100.8,  
          "prepaid_origin_merchant_order_id": "#3082"  
          } | null</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.extra_data</td>
        <td style="text-align: left;">object</td>
        <td style="text-align: left;">Key/value store for any extra information</td>
        <td style="text-align: left;">{"some": "extra", "fields": "here"}</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.quantity</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Number of items</td>
        <td style="text-align: left;">1</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.price</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Price of the subscription when leveraging price lock feature
        </td>
        <td style="text-align: left;">"12.99"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.frequency_days</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Order placement interval in days</td>
        <td style="text-align: left;">30</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.reminder_days</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">
          Days before order placement to email reminder (minimum of 5)
        </td>
        <td style="text-align: left;">5</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.every</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Number of periods</td>
        <td style="text-align: left;">1</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.every_period</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">
          Type of period enum<br>
          <br>
          Options: 1, 2, 3
        </td>
        <td style="text-align: left;">3</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.every_period_display</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Readable version of period enum<br>
          <br>
          Options: "Days", "Weeks", "Months"
        </td>
        <td style="text-align: left;">"Months"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.cancelled</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">
          Unix timestamp of when the subscription was cancelled, if no longer
          active.
        </td>
        <td style="text-align: left;">1301325188</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.cancel_reason</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Pipe-delimited cancel reason code and cancel reason details</td>
        <td style="text-align: left;">"4|Overstocked"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.cancel_reason_code</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Code ID of the cancel reason</td>
        <td style="text-align: left;">4</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.session_id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Session ID, obtained from og_session_id cookie</td>
        <td style="text-align: left;">"aaaa1111bbbb2222cccc.450125.1299622365"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.merchant_order_id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Order ID in your system, corresponding to the checkout that created
          the subscription.
        </td>
        <td style="text-align: left;">"12345678"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.live</td>
        <td style="text-align: left;">bool</td>
        <td style="text-align: left;">
          Dictates if the subscription is active or inactive. "Active" meaning
          that the customer wants to continue receiving the product at the
          frequency cadence; "Inactive' meaning they do not.
        </td>
        <td style="text-align: left;">true</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.external_id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          External representation of the subscription in your system. In the
          case of Shopify integrations, this is the Shopify contract ID.
        </td>
        <td style="text-align: left;">"external-identifier"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.created</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Unix timestamp when the subscription was created</td>
        <td style="text-align: left;">1300375961</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.start_date</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Date the subscription started.<br>
          <br>
          Format: "YYYY-MM-DD"
        </td>
        <td style="text-align: left;">"2021-03-25"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.offer</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Offer record ID</td>
        <td style="text-align: left;">"a748aa648ac811e8af3bbc764e106cf4"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.payment</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Payment record ID</td>
        <td style="text-align: left;">"070001bc02fd11e99542bc764e1043b0"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.shipping_address</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Shipping address record ID</td>
        <td style="text-align: left;">"66c25cd0564011e9abc5bc764e107990"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.updated</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Unix timestamp when the subscription was updated</td>
        <td style="text-align: left;">1300375961</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

```Text Example Data
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
        {"product": "product_1"}, 
        {"product": "product_2"}
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
    }
  }
}
```

***

## Order Events Responses

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="background-color: #039de7; color: #fff; font-weight: bold;">
        <th style="width: 23.2857%;">Name</th>
        <th style="width: 7.71429%;">Type</th>
        <th style="width: 36.2857%;">Description</th>
        <th style="width: 32.7143%;">Example</th>
      </tr>
      <tr>
        <td style="text-align: left;">id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Identifier of the event</td>
        <td style="text-align: left;">“mmmm4444nnnn3333pppp”</td>
      </tr>
      <tr>
        <td style="text-align: left;">type</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">The type of event that occurred</td>
        <td style="text-align: left;">See below for full list of event types</td>
      </tr>
      <tr>
        <td style="text-align: left;">created</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Time since epoch when the event occurred</td>
        <td style="text-align: left;">1622589211</td>
      </tr>
      <tr>
        <td style="text-align: left;">data</td>
        <td style="text-align: left;">object</td>
        <td style="text-align: left;">Type</td>
        <td style="text-align: left;">See JSON below</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.type</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Resource type of event</td>
        <td style="text-align: left;">"Order"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.merchant</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Identifier of merchant</td>
        <td style="text-align: left;">"aaaa1111bbbb2222cccc"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.public_id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Public ID of resource. Should be used to retrieve additional resource
          object data via OG API if necessary.
        </td>
        <td style="text-align: left;">"zzzz9999yyyy8888xxxx</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.customer</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          The merchant_user_id AKA the id from merchant system - not our internal
          public ID
        </td>
        <td style="text-align: left;">"h183738"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.payment</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Payment record ID</td>
        <td style="text-align: left;">"a748aa648ac811e8af3bbc764e106cf4"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.shipping_address</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Shipping address record ID</td>
        <td style="text-align: left;">"66c25cd0564011e9abc5bc764e107990"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.sub_total</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Subtotal of items in order</td>
        <td style="text-align: left;">"20.00"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.tax_total</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Tax applied to order</td>
        <td style="text-align: left;">"5.00"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.shipping_total</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Shipping cost applied to order</td>
        <td style="text-align: left;">"0.00"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.discount_total</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Discount applied to order</td>
        <td style="text-align: left;">"0.00"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.total</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Total price of order</td>
        <td style="text-align: left;">"25.00"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.created</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Unix timestamp when the order was created</td>
        <td style="text-align: left;">1300375961</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.place</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Date for order placement<br>
          <br>
          Format: "YYYY-MM-DD"
        </td>
        <td style="text-align: left;">"2021-05-01"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.cancelled</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Unix timestamp when the order was cancelled</td>
        <td style="text-align: left;">1300375961</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.tries</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Number of attempts to place the order</td>
        <td style="text-align: left;">0</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.generic_error_count</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">
          Number of times your system returned a generic error response when
          we attempted to place the order ("999")
        </td>
        <td style="text-align: left;">0</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.status</td>
        <td style="text-align: left;">int</td>
        <td style="text-align: left;">Status enum</td>
        <td style="text-align: left;">1</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.status_display</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">Readable version of status enum</td>
        <td style="text-align: left;">"Unsent"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.order_merchant_id</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Order ID in your system after we have placed an order in your system
          and you respond that it was processed successfully.
        </td>
        <td style="text-align: left;">"ABC123"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.rejected_message</td>
        <td style="text-align: left;">str</td>
        <td style="text-align: left;">
          Message your system provides when you respond with "REJECT" to an
          order we attempt to place.<br>
          <br>
          Format/structure depends on what your responses. We store the string
          of what you provide.
        </td>
        <td style="text-align: left;">"Expiration Date is in the past"</td>
      </tr>
      <tr>
        <td style="text-align: left;">data.object.extra_data</td>
        <td style="text-align: left;">object</td>
        <td style="text-align: left;">Key/value store for any extra information</td>
        <td style="text-align: left;">&nbsp;</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

```Text Example Data
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
      "created": 1301093861
    }
  }
}
```

***

## Item Events Responses

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="background-color: #039de7; color: #fff; font-weight: bold;">
        <th style="width: 23.2857%;">Name</th>
        <th style="width: 8.71429%;">Type</th>
        <th style="width: 25.2857%;">Description</th>
        <th style="width: 42.7143%;">Example</th>
      </tr>
      <tr>
        <td style="width: 23.2857%;">id</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">Identifier of the event</td>
        <td style="width: 42.7143%;">“mmmm4444nnnn3333pppp”</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">type</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">The type of event that occurred</td>
        <td style="width: 42.7143%;">See below for full list of event types</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">created</td>
        <td style="width: 8.71429%;">int</td>
        <td style="width: 25.2857%;">Time since epoch when the event occurred</td>
        <td style="width: 42.7143%;">1622589211</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data</td>
        <td style="width: 8.71429%;">json</td>
        <td style="width: 25.2857%;">Type</td>
        <td style="width: 42.7143%;">see below json bock</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data.object.type</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">Resource type of event</td>
        <td style="width: 42.7143%;">"Subscription"</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data.object.merchant</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">Identifier of merchant</td>
        <td style="width: 42.7143%;">"aaaa1111bbbb2222cccc"</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data.object.public_id</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">
          Public ID of resource. Should be used to retrieve additional resource
          object data via OG API if necessary.
        </td>
        <td style="width: 42.7143%;">"zzzz9999yyyy8888xxxx</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data.customer</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">
          The merchant_user_id AKA the id from merchant system - not our internal
          public ID
        </td>
        <td style="width: 42.7143%;">"h183738"</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data.product</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">The external product ID from the merchant's system</td>
        <td style="width: 42.7143%;">"SKUabc"</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data.order</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">
          The public ID from Ordergroove's system of the order in which this
          item exists.
        </td>
        <td style="width: 42.7143%;">"1234e74444dd115555d8bc7cccc043b0"</td>
      </tr>
      <tr>
        <td style="width: 23.2857%;">data.subscription</td>
        <td style="width: 8.71429%;">str</td>
        <td style="width: 25.2857%;">
          If item is part of a subscription this will contain the public ID
          of that subscription in Ordergroove's system
        </td>
        <td style="width: 42.7143%;">"bc7cccc043b01234e74444155"</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

```Text Example Data
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
            "subscription": "bc7cccc043b01234e74444155"
        }
    }
}
```