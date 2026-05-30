<!-- Source: https://dashboard.gelato.com/docs/orders/v4/cancel/
     Retrieved: 2026-05-30 (live, latest) -->

# Cancel order

# Cancel order

Use the Cancel order API to stop the production and shipment process. Note: if the order has moved to status `printed` or `shipped` the order can't be canceled, please review the [Order get](https://dashboard.gelato.com/docs/orders/v4/cancel/#order-get) flowchart.

`POST https://order.gelatoapis.com/v4/orders/{{orderId}}:cancel`

#### Request example

```
$ curl -X POST \
   https://order.gelatoapis.com/v4/orders/37365096-6628-4538-a9c2-fbf9892deb85:cancel \
   -H 'Content-Type: application/json' \
   -H 'X-API-KEY: {{apiKey}}' 
```

#### Request

| Parameter | Type | Description |
| --- | --- | --- |
| **orderId** _(required)_ | string | Gelato order id. |

#### Response Statuses

| HTTP Status Code | Description |
| --- | --- |
| 200 | The order is canceled. |
| 409 | The order cannot be canceled, because at least one of the items is in 'printed' status. |
| 404 | Order not found. |

* * *
