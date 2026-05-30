<!-- Source: https://dashboard.gelato.com/docs/orders/v4/search/
     Retrieved: 2026-05-30 (live, latest) -->

# Search orders

# Search orders

Use the Search API to retrieves a list of orders

`POST https://order.gelatoapis.com/v4/orders:search`

#### Request example

```
$ curl -X POST \
   https://order.gelatoapis.com/v4/orders:search \
   -H 'Content-Type: application/json' \
   -H 'X-API-KEY: {{apiKey}}' \
   -d '{
        "orderTypes": [
            "draft",
            "order"
        ],
        "countries": [
            "US",
            "DE",
            "CA"
        ]
    }'
```

#### Response example

```
{
  "orders": [
    {
      "channel": "shopify",
      "connectedOrderIds": [],
      "country": "US",
      "createdAt": "2024-04-04T20:59:55+00:00",
      "currency": "USD",
      "customerReferenceId": "{{myCustomerId}}",
      "financialStatus": "paid",
      "firstName": "Paul",
      "fulfillmentStatus": "shipped",
      "id": "c85ea826-5259-4866-998c-7c56129d575c",
      "itemsCount": 3,
      "lastName": "Smith",
      "orderReferenceId": "{{myOrderId}}",
      "orderType": "draft",
      "orderedAt": "2024-01-15T12:32:03+00:00",
      "storeId": "a6bf6ec0-28cb-43a5-92b0-2550f007aac5",
      "totalInclVat": "49.12",
      "updatedAt": "2024-01-15T12:32:03+00:00"      
    },
    {
      "channel": null,
      "connectedOrderIds": [],
      "country": "DE",
      "createdAt": "2024-02-04T20:59:55+00:00",
      "currency": "EUR",
      "customerReferenceId": "{{myCustomerId2}}",
      "financialStatus": "draft",
      "firstName": "Paul",
      "fulfillmentStatus": "draft",
      "id": "e575556f-1daa-46dd-a4cc-84bcfc0a4f36",
      "itemsCount": 1,
      "lastName": "Smith",
      "orderReferenceId": "{{myOrderId2}}",
      "orderType": "draft",
      "orderedAt": null,
      "storeId": null,
      "totalInclVat": "0.00",
      "updatedAt": "2024-02-05T12:32:03+00:00"
    }
  ]
}
```

#### Request

| Parameter | Type | Description |
| --- | --- | --- |
| **channels** _(optional)_ | string\[\] | List of order channels. |
| **countries** _(optional)_ | string\[\] | List of order countries (based on shipping address). |
| **currencies** _(optional)_ | string\[\] | List of order currencies. |
| **endDate** _(optional)_ | string\[\] | Show orders ordered at or created at before date (format: 2014-04-25T16:15:47-04:00). Date and time in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format. |
| **financialStatuses** _(optional)_ | string\[\] | List of order financial statuses. |
| **fulfillmentStatuses** _(optional)_ | string\[\] | List of order fulfillment statuses. |
| **ids** _(optional)_ | string\[\] | List of Gelato order ids. |
| **limit** _(optional)_ | int | The maximum number of results to show on a page. (default: 50, maximum: 100) |
| **offset** _(optional)_ | int | Offset of search request (default = 0). |
| **orderReferenceId** _(optional)_ | string | Reference to your internal order id. |
| **orderReferenceIds** _(optional)_ | string\[\] | List of references to your internal order ids. |
| **orderTypes** _(optional)_ | string\[\] | List of order types. It can be `order` or `draft`. Draft orders can be edited from the dashboard and they don't go into production until you decide to convert draft into a regular order via UI or programmatically via [Order Patch API](https://dashboard.gelato.com/docs/orders/v4/search/#patch). |
| **search** _(optional)_ | string | Search string. Show orders contain value from search in fields - `shippingAddress.firstName`, `shippingAddress.lastName` or `orderReferenceId`. |
| **startDate** _(optional)_ | string\[\] | Show orders ordered at or created at after date (format: 2014-04-25T16:15:47-04:00). Date and time in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format. |
| **storeIds** _(optional)_ | string\[\] | List of E-commerce store IDs identifying which store the order was placed in. |

### Response

| Parameter | Type | Description |
| --- | --- | --- |
| **orders** _(required)_ | OrderObject | List of Orders matching to the search parameters |

`OrderObject`

| Parameter | Type | Description |
| --- | --- | --- |
| **channel** _(required)_ | string | The order channel. Can be: ui, api, shopify and etsy. |
| **connectedOrderIds** _(optional)_ | string\[\] | List of connected order IDs. Used when an order needs to be produced in multiple locations for example. [Read more here](https://dashboard.gelato.com/docs/orders/order_details/) |
| **country** _(optional)_ | string | The two-character [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code that identifies the country or region. |
| **createdAt** _(required)_ | string | Date and time in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format when order was created. |
| **currency** _(optional)_ | string | The order currency. |
| **financialStatus** _(required)_ | string | The order current financial status. Can be: draft, pending, invoiced, to\_be\_invoiced, paid, canceled, partially\_refunded, refunded and refused. |
| **firstName** _(optional)_ | string | The first name of the order recipient. |
| **fulfillmentStatus** _(required)_ | string | The order current fulfillment status. Can be: created, passed, failed, canceled, printed, shipped, draft, pending\_approval, not\_connected, on\_hold. |
| **id** _(required)_ | string | Gelato order id. |
| **itemsCount** _(optional)_ | int | The number of items in the order. |
| **lastName** _(optional)_ | string | The last name of the order recipient. |
| **orderReferenceId** _(required)_ | string | Reference to your internal order id. |
| **orderType** _(required)_ | string | Type of the order. It can be `order` or `draft`. Draft orders can be edited from the dashboard and they don't go into production until you decide to convert draft into a regular order via UI or programmatically via [Order Patch API](https://dashboard.gelato.com/docs/orders/v4/search/#patch). |
| **orderedAt** _(optional)_ | string | Date and time in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format when order was placed. |
| **storeId** _(optional)_ | string | E-commerce store ID identifying which store the order was placed in. |
| **totalInclVat** _(optional)_ | string | The total amount of the order including VAT. |
| **updatedAt** _(required)_ | string | Date and time in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format when order was updated. |

* * *
