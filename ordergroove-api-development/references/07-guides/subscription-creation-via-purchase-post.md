# Subscription Creation via Purchase POST

When any user completes checkout, Ordergroove needs to be notified about this event. You will send a secure HTTP POST that will provide Ordergroove with the necessary information to create one or more subscriptions on our servers. Ordergroove will be expecting a purchase POST regardless of whether or not the customer is checking out with a subscription item. If there is a subscription item, Ordergroove will create a new subscription and allow the customer to begin managing the subscription. If there is no subscription item, Ordergroove will log the OG cart session as a non-subscription checkout and clear the cart session.

> ❗️ Note
>
> Ordergroove requires that each checkout from your store results in a purchase post to Ordergroove, whether the post contains a subscription or not. Critical analytics data for subscription conversion and program efficacy use this data to provide a complete picture of your subscription program's performance. Please be sure to test and confirm that any/all checkouts are sending purchase posts to Ordergroove when proceeding with this step.

***

## Request Structure

Destination

Staging: [https://staging.sc.ordergroove.com/subscription/create](https://staging.sc.ordergroove.com/subscription/create)\
Production: [https://sc.ordergroove.com/subscription/create](https://sc.ordergroove.com/subscription/create)

API Keys

Staging: [https://rc3.stg.ordergroove.com/keys/](https://rc3.stg.ordergroove.com/keys/)\
Production: [https://rc3.ordergroove.com/keys/](https://rc3.ordergroove.com/keys/)

* All fields in the request are required for Ordergoove's subscription creation validation unless noted as optional
* If you choose not to send cc\_exp\_date and card type (which are optional fields), then you may forego taking advantage of our credit card expiring soon email notifications to the subscriber
* Any requests made to the Ordergroove servers from your application should be accompanied with a 5-second timeout. In the event that Ordergroove is unavailable, your application should be able to continue to run seamlessly.
* Each string in the body of the POST must be URL encoded. Please do NOT URL encode the entire POST and please do not URL encode the authorization headers.

```text Header
x-api-key:<REPLACE_ME_WITH_API_KEY>
```

```Text Example Header
x-api-key:5DVCQ2fCQkCkpP1AYyWAdB2G9QjgRVJ428UcHksCuD55owwBiaqLQWctzGAQssfpsp42w7VYFaXrhY5TtxCUQu2
```

```Text Request
create_request={
  "merchant_id": "<MERCHANT_PUBLIC_ID>",
  "og_cart_tracking": false,
  "merchant_order_id": "abc123",
  "user": {
    "user_id": "<MERCHANT_USER_ID>",
    "first_name": "Nicholas",
    "last_name": "Bundy",
    "email": "nicholas.bundy@ordergroove.com",
    "phone_number": "555-555-5555",
      "shipping_address": {
      "first_name": "Nicholas",
      "last_name": "Bundy",
      "company_name": "Ordergroove", // Optional
      "address": "75 Broad Street",
      "address2": "23rd Floor", // Optional
      "city": "New York",
      "state_province_code": "NY",
      "zip_postal_code": "10004",
      "phone": "555-555-5555",
      "fax": "", // Optional
      "country_code": "US" // Must be two characters maximum
    },
    "billing_address": { // Optional - OG can store billing address fields if needed
    "first_name": "Nicholas",
    "last_name": "Bundy",
    "company_name": "Ordergroove", // Optional
    "address": "75 Broad Street",
    "address2": "23rd Floor", // Optional
    "city": "New York",
    "state_province_code": "NY",
    "zip_postal_code": "10004",
    "phone": "555-555-5555",
    "fax": "", // Optional
    "country_code": "US" // Must be two characters maximum
    }
  },
  "payment": { // cc_exp_date, and cc_type are optional
  "token_id": "7654321",
  "cc_exp_date": "<AES_ENCRYPTED_CC_EXP_DATE>", // Must be two digits for the month, a slash, and four-digits for year, e.g. 01/2019 | AES encrypted, then URL encoded | Value should always be 12/2099 for PayPal
  "cc_type": "1" // The credit card type is 1 = Visa, 2 = MasterCard, 3 = American Express, 4 = Discover
  },
  "products": [
    {
    "product": "123456789",
    "sku": "123456789",
    "subscription_info": { 
      "quantity":2,
      "tracking_override": { 
        "offer": "903ecf3e5efc12e49d61bc764e106cf6",
        "every": 4,
        "every_period": 2,
      }
    },
    "purchase_info": {
      "quantity": "2",
      "price": "2.00", // price per unit 
      "discounted_price": "1.90", // price per unit after discount
      "total": "3.80" // discounted_price * quantity
     }
    }
  ]
}
```

> 📘 Note
>
> For the "products" array in this POST, if you are using Ordergroove's javascript injected offers, then you can call OG.getOptins(); which will return everything you need to place within that array. If you are hosting your own enrollment experience, you will need to create the products array as shown in the example above.

***

## Additional Purchase POST Objects

**subscription\_info**

* first\_order\_place\_date - If necessary, this allows you to define when the first recurring order will be set for this subscription
* extra\_data - Can be used for any information that you want stored on the subscription level and then passed back at the time of order placement.
* components - Sets components within a legacy bundle subscription
* multi\_item\_bundle\_components - Creates a New Bundle Subscription. Multiple bundle items will be created linked to this subscription. **The subscription product should be a bundle product\_type while the products in the array needs to be standard products**
* subscription\_type - If set to 'prepaid' can create a prepaid subscription. You will also need to provide `prepaid_orders_per_billing` field to define how many orders were paid for. For example:

```json
"products": {
    "subscription_info": {
      "subscription_type": "prepaid",
      "prepaid_orders_per_billing": 1,
      "renewal_behavior": "autorenew",
      "price": "12",
      "quantity": 1
    },
    "product": "123",
    "sku": "123"
  }
```

**tracking\_override**

* product - Allows you to define a different product that you want the subscription to be created for (use case is buy x subscribe to y)

**Example**

This example highlights all of the additional objects above and where they live within the products array of the Purchase POST

```json
[
...
  {
    "product": "10365",
    "subscription_info": {
      "components": [
        "B987654",
        "B987654",
        "C000000",
        "C000000"
      ],
      "first_order_place_date": "2022-05-01"
      "extra_data":{
        "pet_name": "Rover",
        "breed": "Great Pyranese"
      }, 
    },
  "multi_item_bundle_components": [
          {
            "product": "41049345949751",
            "quantity": 2
          },
          {
            "product": 40969287073847,
            "quantity": 2
          },
          {
            "product": 40967805337655,
            "quantity": 2
          }
        ],
    "tracking_override": {
      "every": 2,
      "every_period": 3,
      "offer": "cfec81b6be4b11ebb3580ef6d8743325",
      "product": "10000"
    }
  }
...
]
```

> 👍 Additional Information
>
> Take a look at the [Purchase POST API Endpoint](https://developer.ordergroove.com/reference/purchase-post-api) for more information about request body parameters.

***

## Purchase POST Responses

If a successful connection is made, the request will always result in a secure HTTP response object with code 200/201/206 and a JSON payload

**Success - Request Received**

```json
{"result": "Subscription request received", "subs_req_id": "59f215d4b3ade33e68c8ae9b"}
```

**Error Responses**

Given the amount of data being provided and the order in which the contents of the payload are validated and created, there will be instances where a 207, 400, 401, or 409 status will be returned, but the customer, shipping, and payment Ordergroove IDs will be provided as they were created, even though there may have been an issue with some or all products provided in the request.

* 207 – Request contained multiple subscriptions and some were successfully created while others were not.
* 400 – Invalid request. No subscriptions were created. Provides details about what specifically was missing or invalid in the request.
* 401/403 – Authentication failed.
* 409 – Conflict: A request with the given merchant\_order\_id was already received and processed.

If there are any errors, they will be found in the errors object of the response.

Some examples:

```json
{"error": "Invalid Merchant MERCHANT_PUBLIC_ID"}
{"error": "Merchant ID must be a string"}
{"error_message": "Merchant order id cannot be null"}
{"error_message": "Missing payment data to create record"}
{"error_message": "The credit card encryption is not valid"}
{"error_message": "Expiration date is not valid, received: "}
{"error_message": "Paymetric tokenization error"}
```

**Error Logging and Retry Logic**

It is recommended that you have email notifications tied to the 400, 401, 403 and 409 error responses. If an issue with the POST can be identified and corrected within 24 hours, it should be resent to Ordergroove. If multiple POSTs are returning the same response, it likely points to a larger issue with the integration that should be investigated. Any retries of 409 responses will need to have the merchant\_order\_id field modified.

In the event that you receive a 500 level error, it is recommended that you re-send the POST 3 times within the next 10 minutes. If there is still no successful connection, you should retry the POST again after 24 hours. After 24 hours, no more retries should be attempted as the contents of the customer's cart are no longer reliable.