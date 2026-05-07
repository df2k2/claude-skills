# Real Time Stock Update

Ordergroove's API can change the stock status of a product in real-time. This can help you manage inventory by sending out an API call when a product, or products, hit a low threshold, or when they go completely out of stock.

> 📘 Platform
>
> This article is specifically for stores on eCommerce platforms outside of Shopify who want live stock updates. If you are on Shopify, please [reach out to Ordergroove Support](https://help.ordergroove.com/hc/en-us/requests/new) and we'll enable it for you.

***

## Example Use Case

The real time stock update can help you get ahead of inventory issues. Let's say you have 100 units left and 200 are set to renew in the morning during the daily order placement task.

Using the API, you can send an automated call to Ordergroove when the stock of a product runs out so the overflow orders naturally move into Ordergroove's out of stock flow, instead of failing due to no inventory.

***

## PATCH Update Endpoint

[https://restapi.ordergroove.com/products-batch/update/](https://restapi.ordergroove.com/products-batch/update/)

### Headers

This endpoint requires [user-level authentication](https://developer.ordergroove.com/reference/api-user-scope). You need a specific hash key to generate it along with a merchant level id that will be used in the sig\_field value. Please reach out to [help@ordergroove.com](mailto:help@ordergroove.com) to get these credentials if you don’t have them.

```Text Headers
headers = {
'authorization': '{"public_id": "<MERCHANT_PUBLIC_ID>", "ts": <SECONDS_SINCE_EPOCH>, "sig_field": "<MERCHANT_LEVEL_ID>", "sig": "<HMAC_SIGNATURE>"}',
'og-authorization': True,
'content-type': 'application/json'
}
```

***

## Example Request Body

Here is an example of what you could send in the body of the PATCH request to update. You can also include multiple products in the same request.

```Text Request
'[
  {
    "product_id": "(external product id)",
    "live": false
  }
]'
```

### Example Response

Ordergroove will attempt an update for each product sent in the request, and respond with a mapping of each product along with the result of the update.

```Text Response
[
{"results": [{"status": 200, "product_id": "166603786142092350"}]}
{"results": [{"status": 404, "product_id": "notfound"}]}
{"results": [{"status": 400, "product_id": "166603786142092351"}]}
]
```