<!-- Source: https://dashboard.gelato.com/docs/orders/v4/delete/
     Retrieved: 2026-05-30 (live, latest) -->

# Delete draft order

# Delete draft order

Use the Delete order API to delete draft orders. Note: only orders having orderType equal to `draft` can be deleted.

`DELETE https://order.gelatoapis.com/v4/orders/{{orderId}}`

#### Request example

```
$ curl -X DELETE \
   https://order.gelatoapis.com/v4/orders/37365096-6628-4538-a9c2-fbf9892deb85 \
   -H 'Content-Type: application/json' \
   -H 'X-API-KEY: {{apiKey}}' 
```

#### Request

| Parameter | Type | Description |
| --- | --- | --- |
| **orderId** _(required)_ | string | Gelato order ID |
