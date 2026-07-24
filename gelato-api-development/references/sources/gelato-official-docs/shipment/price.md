<!-- Source: https://dashboard.gelato.com/docs/shipment/price/
     Retrieved: 2026-07-24 (live, latest) -->

# Price

Use this endpoint to get shipment prices for selected products and quantities.

`POST https://shipment.gelatoapis.com/v1/prices:search`

#### Request example

```
$ curl -X POST "https://shipment.gelatoapis.com/v1/prices:search" \
    -H 'X-API-KEY: {{apiKey}}' \
    -H 'Content-Type: application/json' \
    -d '{
            "currency" : "USD",
            "country" : "US",
            "isBusiness" : true,
            "isPrivate" : true,
            "hasTracking" : true,
            "products" : [
                {
                    "productUid" : "cards_pf_bx_pt_110-lb-cover-uncoated_cl_4-4_hor",
                    "quantities" : [1]
                },
                {
                    "productUid" : "posters_pf_a3_pt_100-lb-text-uncoated_cl_4-0_hor",
                    "quantities" : [1,5]
                }
            ]
        }'
```

#### Response example

```
{
    "prices": [
        {
            "productUid": "cards_pf_bx_pt_110-lb-cover-uncoated_cl_4-4_hor",
            "quantities": [
                {
                    "quantity": 1,
                    "pageCount": null,
                    "methods": [
                        {
                            "shipmentMethodUid": "fed_ex_smart_post",
                            "type": "normal",
                            "minPrice": 6.2699999999999996,
                            "avgPrice": 6.2699999999999996,
                            "minDays": 3,
                            "maxDays": 14,
                            "hasFlatRate": false
                        },
                        {
                            "shipmentMethodUid": "fed_ex_standard_overnight",
                            "type": "express",
                            "minPrice": 16.48,
                            "avgPrice": 16.48,
                            "minDays": 2,
                            "maxDays": 2,
                            "hasFlatRate": false
                        }
                    ]
                }
            ]
        },
        {
            "productUid": "posters_pf_a3_pt_100-lb-text-uncoated_cl_4-0_hor",
            "quantities": [
                {
                    "quantity": 1,
                    "pageCount": null,
                    "methods": [
                        {
                            "shipmentMethodUid": "fed_ex_smart_post",
                            "type": "normal",
                            "minPrice": 6.3970000000000002,
                            "avgPrice": 6.3970000000000002,
                            "minDays": 8,
                            "maxDays": 14,
                            "hasFlatRate": true
                        },
                        {
                            "shipmentMethodUid": "fed_ex_standard_overnight",
                            "type": "express",
                            "minPrice": 16.48,
                            "avgPrice": 16.48,
                            "minDays": 2,
                            "maxDays": 2,
                            "hasFlatRate": false
                        }
                    ]
                },
                {
                    "quantity": 5,
                    "pageCount": null,
                    "methods": [
                        {
                            "shipmentMethodUid": "fed_ex_smart_post",
                            "type": "normal",
                            "minPrice": 8.2929999999999993,
                            "avgPrice": 8.2929999999999993,
                            "minDays": 8,
                            "maxDays": 14,
                            "hasFlatRate": true
                        },
                        {
                            "shipmentMethodUid": "fed_ex_standard_overnight",
                            "type": "express",
                            "minPrice": 16.48,
                            "avgPrice": 16.48,
                            "minDays": 2,
                            "maxDays": 2,
                            "hasFlatRate": false
                        }
                    ]
                }
            ]
        }
    ]
}
```

#### Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| **country** _(required)_ | string | Two-character [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code that identifies the country or region. |
| **currency** _(required)_ | string | The currency that the prices should be displayed in. The currency is defined by the Currency ISO code as per [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217). |
| **isBusiness** _(optional)_ | bool | Filter shipment methods on their suitability for shipping to business addresses. |
| **isPrivate** _(optional)_ | bool | Filter shipment methods on their suitability for shipping to residential addresses. |
| **hasTracking** _(optional)_ | bool | Filter shipment methods on tracking, i.e will you receive a tracking code and URL when the order is shipped with the shipment method. |
| **products** _(required)_ | ProductObject[] | List of products. |

`ProductObject`

| Parameter | Type | Description |
| --- | --- | --- |
| **productUid** _(required)_ | string | Unique product identifier [product uid](https://dashboard.gelato.com/docs/get-started/#product-uid). |
| **pageCount** _(optional)_ | integer | The page count for multi-page products. This parameter is only needed for multi-page products (products with more than 4 pages). All pages in the product, including front and back cover are included in the count. For example for a Wire-o Notebook there are 112 inner pages (56 leaves) and 1 front and 1 back cover, total 114 pages. The `pageCount` is 114. [Read more](https://apigelato.zendesk.com/hc/en-us/articles/360010280579-Multipage-formats) |
| **quantities** _(required)_ | integer[] | The product quantities array. Define how many copies of product should be printed. _The minimum value is 1_ |

#### Response Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| **prices** _(required)_ | PriceObject[] | Array of price objects. |

`PriceObject`

| Parameter | Type | Description |
| --- | --- | --- |
| **productUid** _(required)_ | string | Product Uid. |
| **quantities** _(required)_ | QuantityObject[] | Array of Quantity objects. |

`QuantityObject`

| Parameter | Type | Description |
| --- | --- | --- |
| **quantity** _(required)_ | integer | Quantity of the product |
| **pageCount** _(required)_ | integer | Page count for multi-page products. |
| **methods** _(required)_ | MethodObject[] | Array of Method objects. |

`MethodObject`

| Parameter | Type | Description |
| --- | --- | --- |
| **shipmentMethodUid** _(required)_ | string | Method Uid. |
| **type** _(required)_ | string | Shipping service type. Can be: normal, express or pallet. |
| **minPrice** _(required)_ | float | The cheapest shipping price in the country for the shipment method. The price is displayed in the currency that the currency parameter was set to. |
| **avgPrice** _(required)_ | float | The average shipping price in the country for the shipment method. The price is displayed in the currency that the currency parameter was set to. |
| **minDays** _(required)_ | integer | The estimated minimum days to produce and deliver the product. Gives the estimate in total number of days including weekends and holidays. Example: `minDays` estimate is 3 days and it is given on a Friday. It means that the earliest delivery is on Monday (3 days later). |
| **maxDays** _(required)_ | integer | The estimated maximum days to produce and deliver the product. Gives the estimate in total number of days including weekends and holidays. Example: `maxDays` estimate is 8 days and it is given on a Thursday. It means that the earliest delivery is on the next Friday (8 days later). |
| **hasFlatRate** _(required)_ | bool | True if the price is flat-rated (i.e. regional pricing). False if it is dynamic pricing. |
