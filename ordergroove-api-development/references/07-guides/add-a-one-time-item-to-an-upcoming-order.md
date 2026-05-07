# Instant Upsell through API

Instant Upsell (IU) allows customers to add additional items to their upcoming order, either as a one-time purchase or as an ongoing subscription while bypassing the onsite checkout flow entirely.

When using Ordegroove’s enrollment offers, IU will automatically render for logged-in subscribers for eligible products. You can also enable IU when hosting our own enrollment on-site, or leverage the API to incorporate IU into custom flows.

<Image align="center" width="400px" src="https://files.readme.io/72c2d12-image1.jpg" />

***

## Requirements

* Engineering resource on your team familiar with building custom experiences via API
* Ordergroove merchant ID, hash key and offer ID values. Please reach out to the [Ordergroove Support Team](https://help.ordergroove.com/hc/en-us/requests/new) if you do not have these already.

***

## 1. Retrieve Upcoming Orders for Customer

Using customer-level authentication, make a GET call to [https://restapi.ordergroove.com/orders?status=1](https://restapi.ordergroove.com/orders?status=1) to retrieve a customer’s future orders.

```Text Response
{
"count": 2,
"next": null,
"previous": null,
"results": [
{
"merchant": "a87c5d3c787b11ec9f630e0e56c94aa5",
"customer": "6419554042026",
"payment": "e3d5ed784fc911ed8478cebaac07b7e6",
"shipping_address": "ed91e5e84fc811eda19f2e7f57e06c98",
"public_id": "6789756e263d11eea3da0a20cdd8d0a2",
"sub_total": "77.94",
"tax_total": "0.00",
"shipping_total": "0.00",
"discount_total": "13.82",
"total": "77.94",
"created": "2023-07-19 09:06:06",
"updated": "2023-09-09 00:39:31",
"place": "2023-10-09 00:00:00",
"cancelled": null,
"tries": 0,
"generic_error_count": 0,
"status": 1,
"type": 1,
"order_merchant_id": null,
"rejected_message": null,
"extra_data": null,
"locked": false,
"oos_free_shipping": false
},
{
"merchant": "a87c5d3c787b11ec9f630e0e56c94aa5",
"customer": "6419554042026",
"payment": "393d84e6f11011ed9753ea90a0f1339a",
"shipping_address": "ed91e5e84fc811eda19f2e7f57e06c98",
"public_id": "554f0ede34e511eeba08c2f2e26389f5",
"sub_total": "44.82",
"tax_total": "0.00",
"shipping_total": "0.00",
"discount_total": "8.35",
"total": "44.82",
"created": "2023-08-07 00:43:27",
"updated": "2023-09-29 09:24:13",
"place": "2023-12-13 00:00:00",
"cancelled": null,
"tries": 0,
"generic_error_count": 0,
"status": 1,
"type": 1,
"order_merchant_id": null,
"rejected_message": null,
"extra_data": null,
"locked": false,
"oos_free_shipping": false
}
]
}
```

***

## 2. Create Item

### Method 1: Create a One-time Item

This method works for creating both one-time items and additional subscriptions, which will automatically inherit then payment and shipping address being used for the order to which it is added.

Make a POST to [https://restapi.ordergroove.com/items/iu/](https://restapi.ordergroove.com/items/iu/)

```Text Request
{
"order": "6789756e263d11eea3da0a20cdd8d0a2",
"offer": "6b3e0e7045a811ed92406e28f0c7c7df",
"product": "44931275391146",
"quantity": 1
}
```

```Text Response
{
"order": "6789756e263d11eea3da0a20cdd8d0a2",
"offer": "6b3e0e7045a811ed92406e28f0c7c7df",
"subscription": null,
"product": "44931275391146",
"quantity": 1,
"components": [],
"public_id": "af43b5b05ed511ee9edcceb803f32292",
"price": "4.00",
"extra_cost": "0.00",
"total_price": "3.80",
"one_time": true,
"frozen": false,
"first_placed": null,
"product_attribute": null,
"subscription_component": null
}
```

### Optional: Convert One-Time IU item to a Subscription

Make a POST to [https://restapi.ordergroove.com/subscriptions/create\_from\_item/](https://restapi.ordergroove.com/subscriptions/create_from_item/)

```Text Request
{
"item": "af43b5b05ed511ee9edcceb803f32292",
"every": 8,
"every_period": 2,
"offer": "6b3e0e7045a811ed92406e28f0c7c7df"
}
```

```Text Response
{
"customer": "6419554042026",
"merchant": "a87c5d3c787b11ec9f630e0e56c94aa5",
"product": "44931275391146",
"payment": "e3d5ed784fc911ed8478cebaac07b7e6",
"shipping_address": "ed91e5e84fc811eda19f2e7f57e06c98",
"offer": "6b3e0e7045a811ed92406e28f0c7c7df",
"subscription_type": null,
"raw_subscription_type": null,
"components": [],
"extra_data": {},
"public_id": "25e5a2dc5ed611ee9ee0de51b7f814f0",
"quantity": 1,
"price": null,
"frequency_days": 56,
"reminder_days": 10,
"every": 8,
"every_period": 2,
"start_date": "2023-09-29",
"cancelled": null,
"cancel_reason": null,
"iteration": null,
"sequence": null,
"session_id": "a87c5d3c787b11ec9f630e0e56c94aa5.666152.666152",
"merchant_order_id": null,
"created": "2023-09-29 09:40:34",
"updated": "2023-09-29 09:40:34",
"live": true,
"external_id": null,
"product_attribute": null,
"cancel_reason_code": null,
"customer_rep": null,
"club": null,
"prepaid_subscription_context": null
}
```

### Method 2: Create a Subscription in a Single Call

This method allows you to create additional subscriptions using a single API call, but requires an existing address and payment ID to be provided in the POST request.\
Make a POST to [https://restapi.ordergroove.com/subscriptions/iu/](https://restapi.ordergroove.com/subscriptions/iu/)

```Text Request
{
"merchant": "a87c5d3c787b11ec9f630e0e56c94aa5",
"customer": "6419554042026",
"session_id": "anystring",
"offer": "6b3e0e7045a811ed92406e28f0c7c7df",
"product": "44931275391146",
"order": "6789756e263d11eea3da0a20cdd8d0a2",
"payment": "393d84e6f11011ed9753ea90a0f1339a",
"shipping_address": "ed91e5e84fc811eda19f2e7f57e06c98",
"quantity": 1,
"every": 8,
"every_period": 2
}
```

```Text Response
{
"customer": "6419554042026",
"merchant": "a87c5d3c787b11ec9f630e0e56c94aa5",
"product": "44931275391146",
"payment": "e3d5ed784fc911ed8478cebaac07b7e6",
"shipping_address": "ed91e5e84fc811eda19f2e7f57e06c98",
"offer": "6b3e0e7045a811ed92406e28f0c7c7df",
"subscription_type": "replenishment",
"raw_subscription_type": "IU replenishment",
"components": [],
"extra_data": {},
"public_id": "7e86446e5ed611eea708eea9088ec581",
"quantity": 1,
"price": null,
"frequency_days": 56,
"reminder_days": 10,
"every": 8,
"every_period": 2,
"start_date": "2023-09-29",
"cancelled": null,
"cancel_reason": null,
"iteration": null,
"sequence": null,
"session_id": "anystring",
"merchant_order_id": "207107434",
"created": "2023-09-29 09:43:03",
"updated": "2023-09-29 09:43:03",
"live": true,
"external_id": null,
"product_attribute": null,
"cancel_reason_code": null,
"customer_rep": null,
"club": null,
"prepaid_subscription_context": null
}
```