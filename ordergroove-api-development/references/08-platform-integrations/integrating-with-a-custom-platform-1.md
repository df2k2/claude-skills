# Custom Platform and Headless Subscription Implementation

Learn how to implement Ordergroove subscriptions in headless environments by reading customer selections and managing cart state throughout the purchase journey.

# Custom Platform and Headless Subscription Implementation

When using Ordergroove's offers in a headless environment, you'll need to read the subscription selections the customer is making throughout their purchase journey and set those selections within the cart the customer will be completing checkout through.

## Requirements

Follow the [standard tagging instructions](https://developer.ordergroove.com/docs/offer-tagging) for your e-commerce site as outlined in the [integration guide](https://help.ordergroove.com/hc/en-us/categories/4406847471507-Installing-Ordergroove). Be sure to tag your cart platform as well.

## Examples

When a customer opts in to a subscription on a page and they then add that item to the cart, you can read the frequency and subscription opt in state by using the following javascript.

```javascript
const getFrequency = ({ form }) => {
  const ogOffer = form.querySelector("og-offer");
  if (!ogOffer) {
    return null;
  }
  const subscribed = ogOffer.getAttribute("subscribed");
  if (subscribed === null) {
    return null;
  }

  return ogOffer.getAttribute("frequency");
};
```

When you write the items from your headless page to where your cart is hosted, you'll want to be sure to create a local storage object called `OG_STATE` on your cart page. Make sure to make updates to this object any time a customer makes changes between the headless platform and the cart platform.

## OG STATE Object

### Object Structure

```json
{
  "sessionId": "(session id)",
  "optedin": [
    {
       "id": "(product variant id)",
       "frequency": "(every)_(every_period)"
    },
    {
       "id": "(product variant id)",
       "frequency": "(every)_(every_period)"
    }
  ],
  "productOffer": {
    "(product variant id)": ["(offer id)"],
    "(product variant id)": ["(offer id)"]
  }
}
```

### Sample with Data

```json
{
  "sessionId": "15fc1b98803211ea8a5abc764e10b970.12345.1596647632",
  "optedin": [
    {
      "id": "17300125089851",
      "frequency": "1_3"
    }
  ],
  "productOffer": {
    "17307510177851": [
      "160f5f5a803211eaaef3bc764e10b970"
    ]
  }
}
```

## Frequency Mapping

* **Frequency Every**: ex: 1, 2, 3, etc
* **Frequency Period**: ex: 1 = days, 2 = weeks, 3 = months

## Purchase POST (with Subscription Verification)

The Purchase POST will include an additional field ("processed") to mark the subscription as pending verification. This will hold the subscription in a pending state until you have the final notification that it is complete. The API should be used when the field "processed" is included in the subscription creation POST with a value of 'false'.

A value of 'true' in this field indicates that the subscription should be created right away, and should also be used for non-subscription checkouts.

A value of 'false' indicates that the verification is pending and the subscription will not be created until the subscription has been verified. To verify a subscription–and thereby allow its creation–the "processed" field must be set to 'true' through the use of this API.

The Purchase POST requires the use of the Content-type and Authorization headers.

```json
{
  "merchant_id": "<MERCHANT_ID>",
  "session_id": "<SESSION_ID>",
  "processed": true,
  "merchant_order_id": "abc23124123",
  "user": {
    "user_id": "7654321",
    "first_name": "Jane",
    "last_name": "Rouse",
    "email": "jane.rouse@ordergroove.com",
    "shipping_address": {
      "first_name": "Jane",
      "last_name": "Rouse",
      "company_name": "OrderGroove",
      "address": "75 Broad Street",
      "address2": "23rd Floor",
      "city": "New York",
      "state_province_code": "NY",
      "zip_postal_code": "10004",
      "phone": "555-555-5555",
      "fax": "",
      "country_code": "US"
    }
  },
  "payment": {
    "token_id": "7654321",
    "cc_exp_date": "<AES_ENCRYPTED_CC_EXP_DATE>",
    "cc_type": "1"
  },
  "products": [
    {
      "product": "123456789",
      "sku": "123456789",
      "purchase_info": {
        "quantity": 2,
        "price": "2.00",
        "discounted_price": "1.90",
        "total": "3.80"
      }
    }
  ]
}
```

### Subscription Verification

This API should be used when the field "processed" is included in the subscription creation POST with a value of false. A value of true in this field indicates that the subscription should be created right away, or that there were no subscription items in the customer's cart.

A value of false indicates that the verification is pending and the subscription will not be created until the subscription has been verified. To verify a subscription–and thereby allow its creation–the "processed" field must be set to true through the use of this API.

**Destination**

* Staging: [https://staging.sc.ordergroove.com/subscription/verify](https://staging.sc.ordergroove.com/subscription/verify)
* Production: [https://sc.ordergroove.com/subscription/verify](https://sc.ordergroove.com/subscription/verify)

**Request Type**
GET or POST

**Request Structure (HMAC)**

```
<DOMAIN>/subscription/verify/<ACTION>?merchant_id=<MERCHANT_ID>&order_id=<MERCHANT_ORDER_ID>&ts=<TIMESTAMP>&sig=<ORDER_ID_SIGNATURE>
```

* **domain** - which environment you are sending the request to
* **action** - the action to take on the CloudSubscription. Must be one of the following values:
  * **process** - create the subscription
  * **decline** - do not create the subscription
* **order\_id** - the merchant\_order\_id sent in the original subscription creation request
* **ts** - timestamp
* **sig** - Merchant generated signature for the combination of order\_id and ts, URL encoded

**Possible HTTP Responses**

Response Code 200:

* SUCCESS
* `<Merchant> subscription request with merchant_order_id <merchant order id> does not exist`
* `<Merchant> subscription request with merchant_order_id <merchant order id> has already been transmitted` - This subscription request was already sent to our servers
* `Invalid Merchant` - The merchant id provided does not exist

Response Code 400:

* `order id is required` - a merchant order id was not passed in
* `Authentication failed`
* `Invalid Merchant <MERCHANT_ID>`
* `Merchant ID must be string`
* `Invalid action` - an action other than the ones described above was supplied (not process/decline)

## Order Verification

If you also need more time to receive order notification and a final status when OG submits future orders via API, then you can implement Order Verification as described below.

This API should be used in conjunction with the 010 error response code that is returned during order placement. The 010 error response code indicates the order has been created and is currently processing. While you verify the order, OrderGroove will hold the order in the processing state. Once the order has been processed via this API, the order will enter a final status in the OG system and notification will be sent to the customer if set up under the requirements of the integration.

Your initial response when we place an order via API should look like the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<order>
    <code>SUCCESS</code>
    <responseCode>010</responseCode>
    <orderId>1224</orderId>
</order>
```

**Destination**

* Staging: [https://staging.v2.ordergroove.com/order/verify](https://staging.v2.ordergroove.com/order/verify)
* Production: [https://api.ordergroove.com/order/verify](https://api.ordergroove.com/order/verify)

**Request Type**
POST

**Request Variables**

* **merchant\_id** - string - public ID of the merchant
* **orders** - Array of JSON objects
  * **order\_id** - string - the order ID that was originally provided to OrderGroove at order placement
  * **status** - string - updated status of the order
    * **000** — success
    * **010** — created and processing
    * **020** — invalid, order not created
    * **030** — canceled
    * **100** — invalid credit card type
    * **110** — invalid credit card number
    * **120** — invalid credit card expiration date
    * **130** — invalid billing address
    * **140** — payment declined
    * **999** — order processing issue – retry later
  * **message** - string - optional message supporting/describing the provided status

**Example Request**

```json
{
  "merchant_id": "<merchant_id>",
  "orders": [
    {
      "order_id": "123",
      "status": "000",
      "message": "success"
    },
    {
      "order_id": "345",
      "status": "140",
      "message": "Payment declined"
    }
  ]
}
```

**Response**

The response will be a JSON object consisting of:

* **status** - string - defines the overall result status of the request
  * **000** - complete success
  * **001** - partial success
  * **002** - fatal error
* **orders** - Array of JSON objects
  * **order\_id** - string - the order ID that was originally provided to OrderGroove at order placement
  * **result** - string - "success"/"error"
  * **message** - string - optional message supporting/describing the provided result status

**Example Response**

```json
{
  "status": "000",
  "orders": [
    {
      "order_id": "123",
      "result": "success"
    },
    {
      "order_id": "345",
      "result": "error",
      "message": "Order does not exist"
    }
  ]
}
```

In the event of a "002" (fatal error) response, there will be no "orders" key, but instead an "error\_object" key that will consist of another JSON object, giving more details about the system failure. This error will be emailed to OrderGroove administrators at the time it occurs, so that they can begin assessing the source of the system error.

**Error Messages**

The following are the list of possible messages to be seen when an "error" result is provided in the response:

* "Order does not exist"
* "Unknown status code provided"
* "Order not in 'Processing' status"