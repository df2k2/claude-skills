# Events and Payloads

By default, the payloads being sent in the Ordergroove’s outgoing webhooks include the minimal information about the event that is being delivered. In general, the included information are identifiers/pointers of entities, customers, addresses, orders, etc, that need to be used as parameters in later calls to Ordergroove APIs if more information is needed about them.

If a customer needs more information readily available in the webhooks payloads they receive (in order to avoid further calls to OG APIs to get this data, for example), it is possible for them to enrich these payloads by adding extra context about certain entities involved in the event being delivered (customers, addresses, etc.). This can be easily done through the webhooks interface in RC3.

***

## Webhooks default payload

By default, when a new webhook route is created, and no further configuration is set, outgoing webhooks payloads are going to have the following structure:

```Text Webhook
{
  "id": <EVENT IDENTIFIER>,
  "type": <EVENT TYPE>,
  "created": <EVENT CREATION TIMESTAMP>,
  "data": {
    "object": <EVENT TYPE SPECIFIC PAYLOAD>
  },
  "context": <PLACEHOLDER FOR EXTRA DATA USED FOR CERTAIN EVENTS>,
  "snapshot": {}
}
```

Even though all webhooks payloads will comply with the general structure described above, their content is going to depend on the event type being delivered. Below, we describe the six possible webhook payload types a recipient can get depending on the event type being transmitted.

* subscriber.\* events: [https://developer.ordergroove.com/reference/webhooks-subscriber-events](https://developer.ordergroove.com/reference/webhooks-subscriber-events)
* subscription.\* events: [https://developer.ordergroove.com/reference/webhook-subscription-events](https://developer.ordergroove.com/reference/webhook-subscription-events)
* order.\* events: [https://developer.ordergroove.com/reference/webhooks-order-events](https://developer.ordergroove.com/reference/webhooks-order-events)
* item.\* events: [https://developer.ordergroove.com/reference/webhooks-item-events](https://developer.ordergroove.com/reference/webhooks-item-events)
* entitlement.\* events: [https://developer.ordergroove.com/reference/webhooks-entitlement-events](https://developer.ordergroove.com/reference/webhooks-entitlement-events)
* workflow.\* events: [https://developer.ordergroove.com/reference/webhooks-workflow-events](https://developer.ordergroove.com/reference/webhooks-workflow-events)

As it can be seen in the six different payload types described above, references to entities such as orders, products or addresses are limited to public ids. With the available information in such payloads, the user would need to use Ordergroove [REST APIs](https://developer.ordergroove.com/reference/introduction) to get extra details about the involved entities passing the public ids as parameters.

<br />

## Context

Within the webhooks payload,  the`context` field includes details about the actor who triggered the event, specifying the actor type and a unique identifier. Possible actor type values include customer, user, apikey, og-system-account, og-system-process.

```Text Context
"actor": {
            "type": "customer"/"apikey"/"user"/"og-system-account"/"og-system-process",
            "customer": {
                "merchant_user_id": <MERCHANT_USER_ID>
            }
            "api_key": {
                "public_id": <USER_PUBLIC_ID>,
                "name": <API_KEY_NAME>
            },
            "user": {
                "public_id": <USER_PUBLIC_ID>
            }
```

<br />

***

## Extending webhooks payload

If the provided default information is not enough to satisfy a specific use case, a customer can configure the corresponding webhook in order to extend outgoing payloads with extra context. This can be achieved through the Ordergroove Merchant Admin by following these steps:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to **Developers > Webhooks** on the top toolbar.
3. **Click on the 3** dots next to the webhook route whose configuration needs to be changed and click on **Edit**.

<Image align="center" alt="webhook list UI" src="https://files.readme.io/d6584e9-image3.png" />

4. Go to the bottom of the page and click on **Advanced settings**. A chart is going to be displayed allowing to extend webhooks’ payloads.

<Image align="center" alt="Webhook Config UI" src="https://files.readme.io/12b37f4-image1.png" />

5. Select the entities for which more information is needed for a given event type. As an example, if the checkbox in Subscription row and Payments column is selected, extra information is going to be sent for payments involved in events of type subscription (e.g., `subscription.cancelled`, `subscription.created`, etc.). More information about the effects on performing this action is described below.

> ❗️ Warning
>
> There is an extra network, storage and computational cost for each piece of additional data we add to the payloads; this is on the Ordergroove side, as well as the receiving side of the webhook payload. Be mindful of the additional data that is requested and make sure of only adding what is necessary.

<Image align="center" alt="Webhook Config UI" src="https://files.readme.io/4adc6df-image2.png" />

6. Click on the **Save** button at the bottom of the page in order to confirm the desired changes. Saved configuration is going to impact on the payloads of the new webhooks being created. Webhooks currently in transit while doing these changes (just created or being retried) will still use the old configuration.

***

## Webhooks extended payload format

When the new configuration impacts on ongoing webhooks, their payloads structure is going to change from the one described in the section above to the following one:

```Text Payload
{
  "id": <EVENT IDENTIFIER>,
  "type": <EVENT TYPE>,
  "created": <EVENT CREATION TIMESTAMP>,
  "data": {
    "object": <EVENT TYPE SPECIFIC PAYLOAD>
  },
  "context": <PLACEHOLDER FOR EXTRA DATA USED FOR CERTAIN EVENTS>,
  "snapshot": {
    "customer": {
    },
    "orders": [
      {...},
    ],
    "items": [
      {...},
    ],
    "addresses": [
      {...},
    ],
    "payments": [
      {...},
    ],
    "subscriptions": [
      {...},
    ],
    "products": [
      {...},
    ]
  }
}
```

Depending on the event type being delivered and the current configuration, the snapshot field will include some, all or none of the fields described above. The entities added to the snapshot field are limited to the ones involved in the event being delivered.

***

## Information sent

Given an event type, if an entity is configured to be added to the payload, the following information is sent:

### Customer

Information displayed in customer field is the same as the one in the [response body of Rest API customer retrieve endpoint](https://developer.ordergroove.com/reference/customers-retrieve#response-body-definitions).

### Orders

Each of the elements in the array will display extended information about the orders involved in the event. The returned fields for each element of the array are the same as the ones in response body of [Rest API order retrieve endpoint](https://developer.ordergroove.com/reference/orders-retrieve#response-body-definitions).

### Items

Each of the elements in the array will display extended information about the orders’ items involved in the event. The returned fields for each element of the array are the same as the ones in response body of Rest[ API item retrieve endpoint](https://developer.ordergroove.com/reference/items-retrieve#response-body-definitions).

### Addresses

Each of the elements in the array will display extended information about the billing and shipping addresses involved in the event. The returned fields for each element of the array are the same as the ones in response body of [Rest API address retrieve endpoint](https://developer.ordergroove.com/reference/addresses-retrieve#response-body-definitions).

### Payments

Each of the elements in the array will display extended information about the payments involved in the event. The returned fields for each element of the array are the same as the ones in response body of [Rest API payment retrieve endpoint](https://developer.ordergroove.com/reference/payments-retrieve#response-body-definitions).

### Subscriptions

Each of the elements in the array will display extended information about the subscriptions involved in the event. The returned fields for each element of the array are the same as the ones in response body of [Rest API subscription retrieve endpoint](https://developer.ordergroove.com/reference/subscriptions-retrieve#response-body-definitions).

### Products

Each of the elements in the array will display extended information about the products involved in the event. The returned fields for each element of the array are the same as the ones in [response body of Rest API product retrieve endpoint](https://developer.ordergroove.com/reference/products-retrieve#response-body-definitions).

### Snapshot example

Below there is an example of how the `snapshot` field would look like with all the entities populated (as per February 2024):

```
"snapshot": {
  "customer": {
    "merchant": "aaaa1111bbbb2222cccc",
    "merchant_user_id": "m1234576",
    "session_id": "aaaa1111bbbb2222cccc.440804.258456",
    "user_token_id": "",
    "first_name": "John",
    "last_name": "Smith",
    "email": "test@email.com",
    "phone_number": "+15555555555",
    "phone_type": null,
    "live": true,
    "created": "2022-12-20 14:00:55",
    "last_updated": "2022-12-20 14:00:56",
    "last_login": null,
    "extra_data": null,
    "locale": 1
    },
  "orders": [
      {
      "merchant": "aaaa1111bbbb2222cccc",
      "customer": "m1234576",
      "payment": "25e4d2761d294dd48efd96fdf668a2d9",
      "shipping_address": "03197d2512904301aaed774a256e71c8",
      "public_id": "f9cb2f93e1c845eb9de9eff46ddb3cbf",
      "sub_total": "2700.00",
      "tax_total": "0.00",
      "shipping_total": "14.00",
      "discount_total": "300.00",
      "total": "2714.00",
      "created": "2023-08-17 00:58:56",
      "updated": "2024-01-21 10:54:54",
      "place": "2024-04-13 00:00:00",
      "cancelled": "2024-01-21 10:54:54",
      "tries": 0,
      "generic_error_count": 0,
      "status": 4,
      "type": 1,
      "order_merchant_id": null,
      "rejected_message": null,
      "extra_data": null,
      "locked": false,
      "oos_free_shipping": false,
      "currency_code": "USD"
      }
  ],
  "items": [
      {
      "order": "f9cb2f93e1c845eb9de9eff46ddb3cbf",
      "offer": null,
      "subscription": "565998a03d7a4647971aab47f8c487f9",
      "product": "12345",
      "quantity": 60,
      "components": [],
      "public_id": "f9cb2f93e1c845eb9de9eff46ddb3c11",
      "price": "50.00",
      "extra_cost": "0.00",
      "total_price": "2700.00",
      "one_time": false,
      "frozen": false,
      "first_placed": null,
      "product_attribute": null
      }
  ],
  "addresses": [
      {
      "customer": "m1234576",
      "public_id": "03197d2512904301aaed774a256e71c8",
      "label": null,
      "first_name": "John",
      "last_name": "Smith",
      "company_name": "Ordergroove",
      "address": "123 Test Street",
      "address2": "3rd Floor",
      "city": "New York",
      "state_province_code": "NY",
      "zip_postal_code": "10004",
      "phone": "555-555-5555",
      "fax": null,
      "country_code": "US",
      "live": true,
      "created": "2022-12-20 14:00:55",
      "token_id": null,
      "store_public_id": null
      }
  ],
  "payments": [
      {
      "customer": "m1234576",
      "billing_address": "03197d2512904301aaed774a256e71c8",
      "cc_number_ending": null,
      "payment_method": "credit card",
      "public_id": "25e4d2761d294dd48efd96fdf668a2d9",
      "label": null,
      "token_id": "1234",
      "cc_holder": null,
      "cc_type": 1,
      "cc_exp_date": "12/2099",
      "live": true,
      "created": "2022-12-20 14:00:55",
      "last_updated": "2022-12-20 14:00:55"
      }
  ],
  "subscriptions": [
      {
      "customer": "m1234576",
      "merchant": "aaaa1111bbbb2222cccc",
      "product": "12345",
      "payment": "25e4d2761d294dd48efd96fdf668a2d9",
      "shipping_address": "03197d2512904301aaed774a256e71c8",
      "offer": "43af8cc6410c11eb9afe36931c4b8111",
      "subscription_type": "replenishment",
      "raw_subscription_type": "replenishment",
      "components": [],
      "extra_data": {},
      "public_id": "565998a03d7a4647971aab47f8c487f9",
      "quantity": 60,
      "price": null,
      "frequency_days": 240,
      "reminder_days": 10,
      "every": 240,
      "every_period": 1,
      "start_date": "2022-12-20",
      "cancelled": null,
      "cancel_reason": null,
      "iteration": null,
      "sequence": null,
      "session_id": "aaaa1111bbbb2222cccc.440804.258456",
      "merchant_order_id": "order90575",
      "created": "2022-12-20 14:00:55",
      "updated": "2022-12-20 14:00:55",
      "live": true,
      "external_id": null,
      "product_attribute": null,
      "cancel_reason_code": null,
      "customer_rep": null,
      "club": null,
      "prepaid_subscription_context": null,
      "currency_code": "USD"
      }
  ],
  "products": [
      {
      "merchant": "aaaa1111bbbb2222cccc",
      "groups": [
        {"group_type": "eligibility", "name": "subscription"}
      ],
      "name": "Test Product",
      "price": "50.00",
      "image_url": "https://sample.image.com/12345/",
      "detail_url": "https://sample.detail.com/12345/",
      "external_product_id": "12345",
      "sku": "12345",
      "autoship_enabled": true,
      "premier_enabled": 0,
      "created": "2020-12-31 23:28:48",
      "last_update": "2023-03-31 08:06:23",
      "live": true,
      "discontinued": false,
      "extra_data": null,
      "product_type": "standard",
      "autoship_by_default": false,
      "every": null,
      "every_period": null,
      "incentive_group": null
      }
  ]
}
```