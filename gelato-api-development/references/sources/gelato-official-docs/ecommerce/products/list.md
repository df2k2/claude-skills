<!-- Source: https://dashboard.gelato.com/docs/ecommerce/products/list/
     Retrieved: 2026-05-30 (live, latest) -->

# List products

# List products

Use the Product List API to retrieves a list of products

`GET https://ecommerce.gelatoapis.com/v1/stores/{{storeId}}/products`

#### Request example

```
$ curl -X GET \
   https://ecommerce.gelatoapis.com/v1/stores/{{storeId}}/products \
   -H 'Content-Type: application/json' \
   -H 'X-API-KEY: {{apiKey}}' \
   -d '{
        "order": "desc",
        "orderBy": "createdAt",
        "offset": 0,
        "limit": 100 
    }'
```

#### Response example

#### Request

| Parameter | Type | Description |
| --- | --- | --- |
| **order** _(optional)_ | string | Sorting by orderBy field. Could be `desc` or `asc`. By default - `desc`. |
| **orderBy** _(optional)_ | string | Sorting field. Could be `createdAt` or `updatedAt`. By default - `createdAt`. |
| **offset** _(optional)_ | integer | Offset for pagination (default: 0). |
| **limit** _(optional)_ | integer | Limit for pagination (default: 100, maximum: 100). |

#### Response

| Parameter | Type | Description |
| --- | --- | --- |
| **products** | ProductObject\[\] | List of products. |

`ProductObject` Response has the same structure as on [Product Get API](https://dashboard.gelato.com/docs/ecommerce/products/get/)
