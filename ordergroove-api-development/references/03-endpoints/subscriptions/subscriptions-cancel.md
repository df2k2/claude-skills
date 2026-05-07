# Cancel

Cancels a subscription and any subsequent shipments.

# Cancel Subscription

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope (including with trust\_level: recognized)
</Callout>

**Attempting to call these on a prepaid subscription will result in a 400 error.**

## Response Body Definitions

| Name                           | Type             | Description                                                                                                                                              | Example                                                |
| ------------------------------ | ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| customer                       | string           | Customer ID                                                                                                                                              | `"00026001"`                                           |
| merchant                       | string           | Merchant ID                                                                                                                                              | `"ac4f7938383a11e89ecbbc764e1107f2"`                   |
| product                        | string           | Product ID                                                                                                                                               | `"0070000693"`                                         |
| payment                        | string           | Payment record ID                                                                                                                                        | `"070001bc02fd11e99542bc764e1043b0"`                   |
| shipping\_address              | string           | Shipping address record ID                                                                                                                               | `"66c25cd0564011e9abc5bc764e107990"`                   |
| offer                          | string           | Offer ID                                                                                                                                                 | `"a748aa648ac811e8af3bbc764e106cf4"`                   |
| subscription\_type             | string           | Subscription Type                                                                                                                                        | `"Replenish"`                                          |
| components                     | string           | Legacy Bundle components                                                                                                                                 | `"product_id_1,product_id_2"`                          |
| components                     | array of objects | New Bundle components                                                                                                                                    | See example below                                      |
| extra\_data                    | string           | Raw JSON string that should be JSON.parse() as key/value store for any extra information.                                                                | `{"some": "extra", "fields": "here"}`                  |
| public\_id                     | string           | Subscription ID                                                                                                                                          | `"f9cb2f93e1c845eb9de9eff46ddb3cbf"`                   |
| product\_attribute             | string           | Product attribute                                                                                                                                        | `null`                                                 |
| quantity                       | integer          | Number of items                                                                                                                                          | `21`                                                   |
| price                          | string           | Price                                                                                                                                                    | `"12.99"`                                              |
| frequency\_days                | integer          | Order placement interval in days                                                                                                                         | `42`                                                   |
| reminder\_days                 | integer          | Days before order placement to email reminder (minimum of 5)                                                                                             | `42`                                                   |
| every                          | integer          | Number of periods                                                                                                                                        | `6`                                                    |
| every\_period                  | integer          | Type of period                                                                                                                                           | `3`                                                    |
| start\_date                    | string           | Date of subscription start, in format YYYY-MM-DD                                                                                                         | `"2019-07-21"`                                         |
| cancelled                      | string           | Date of subscription cancellation; null=not cancelled.                                                                                                   | `null`                                                 |
| cancel\_reason                 | string           | Pipe-delimited cancel reason code and cancel reason details                                                                                              | `"4\|Overstocked"`                                     |
| cancel\_reason\_code           | string           | Cancel reason code                                                                                                                                       | `"4"`                                                  |
| ~~iteration~~                  | string           | *Deprecated*                                                                                                                                             | *Deprecated*                                           |
| ~~sequence~~                   | string           | *Deprecated*                                                                                                                                             | *Deprecated*                                           |
| session\_id                    | string           | Session ID, obtained from og\_session\_id cookie                                                                                                         | `"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"` |
| merchant\_order\_id            | string           | Order ID in your system                                                                                                                                  | `"301617"`                                             |
| ~~customer\_rep~~              | string           | *Deprecated*                                                                                                                                             | *Deprecated*                                           |
| ~~club~~                       | string           | *Deprecated*                                                                                                                                             | *Deprecated*                                           |
| created                        | string           | Date created                                                                                                                                             | `"2017-02-29 12:00:00"`                                |
| updated                        | string           | Date updated                                                                                                                                             | `"2017-02-29 12:00:00"`                                |
| live                           | boolean          | True=active subscription; False=inactive subscription                                                                                                    | `true`                                                 |
| prepaid\_subscription\_context | object           | [Prepaid information](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data). Returned only if prepaid is enabled | See example below                                      |

## New Bundle Components Example

```json
[  
  {  
    "public_id": "79d2dc76245111eeb185acde48001122",  
    "quantity": 1,  
    "product": "0070067690"  
  },  
  {  
    "public_id": "7eeaa504245111eeb185acde48001122",  
    "quantity": 3,  
    "product": "0070067691"  
  }  
]
```

## Prepaid Subscription Context Example

```json
{
  "prepaid_orders_remaining": 0,
  "prepaid_orders_per_billing": 3,
  "renewal_behavior": "autorenew",
  "last_renewal_revenue": 100.8,
  "prepaid_origin_merchant_order_id": "#3082"
}
```

Or empty object if prepaid is not enabled:

```json
{}
```

## Usage

This endpoint cancels a subscription and prevents any future shipments from being processed. Once cancelled, the subscription status will be updated and the `cancelled` field will contain the cancellation timestamp.

### Important Notes

* This operation cannot be performed on prepaid subscriptions
* Cancelled subscriptions can potentially be reactivated using the reactivate endpoint
* The cancellation reason can be provided to track why subscriptions are being cancelled

# OpenAPI definition

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "ordergroove-restrpc",
    "version": "2.10.0"
  },
  "servers": [
    {
      "url": "https://restapi.ordergroove.com"
    }
  ],
  "components": {
    "securitySchemes": {
      "x-api-key": {
        "type": "apiKey",
        "in": "header",
        "name": "x-api-key"
      }
    }
  },
  "security": [
    {},
    {
      "x-api-key": []
    }
  ],
  "paths": {
    "/subscriptions/{subscription_id}/cancel/": {
      "patch": {
        "summary": "Cancel",
        "description": "Cancels a subscription and any subsequent shipments.",
        "operationId": "subscriptions-cancel",
        "parameters": [
          {
            "name": "subscription_id",
            "in": "path",
            "description": "Unique Subscription ID",
            "schema": {
              "type": "string"
            },
            "required": true
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "cancel_reason": {
                    "type": "string",
                    "description": "Pipe-delimited cancel reason code and cancel reason details"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"product\": \"0070067689\",\n    \"payment\": \"443ddf72094711e9a5afbc764e1043b0\",\n    \"shipping_address\": \"394aee16d61611e88b4abc764e1043b0\",\n    \"offer\": \"a748aa648ac811e8af3bbc764e106cf4\",\n    \"subscription_type\": \"replenishment\",\n    \"components\": [],\n    \"extra_data\": {},\n    \"public_id\": \"0ff0f88accc511e8b6c0bc764e106cf4\",\n    \"product_attribute\": null,\n    \"quantity\": 4,\n    \"price\": null,\n    \"frequency_days\": 120,\n    \"reminder_days\": 10,\n    \"every\": 4,\n    \"every_period\": 3,\n    \"start_date\": \"2018-12-27\",\n    \"cancelled\": \"2019-04-02 13:54:12\",\n    \"cancel_reason\": \"4|Overstocked\",\n    \"cancel_reason_code\": 4,\n    \"iteration\": null,\n    \"sequence\": null,\n    \"session_id\": \"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086\",\n    \"merchant_order_id\": \"2906548\",\n    \"customer_rep\": null,\n    \"club\": null,\n    \"created\": \"2018-10-10 14:45:38\",\n    \"updated\": \"2019-04-02 13:54:12\",\n    \"live\": false\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "customer": {
                      "type": "string",
                      "example": "00026001"
                    },
                    "merchant": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2"
                    },
                    "product": {
                      "type": "string",
                      "example": "0070067689"
                    },
                    "payment": {
                      "type": "string",
                      "example": "443ddf72094711e9a5afbc764e1043b0"
                    },
                    "shipping_address": {
                      "type": "string",
                      "example": "394aee16d61611e88b4abc764e1043b0"
                    },
                    "offer": {
                      "type": "string",
                      "example": "a748aa648ac811e8af3bbc764e106cf4"
                    },
                    "subscription_type": {
                      "type": "string",
                      "example": "replenishment"
                    },
                    "components": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {}
                      }
                    },
                    "extra_data": {
                      "type": "object",
                      "properties": {}
                    },
                    "public_id": {
                      "type": "string",
                      "example": "0ff0f88accc511e8b6c0bc764e106cf4"
                    },
                    "product_attribute": {},
                    "quantity": {
                      "type": "integer",
                      "example": 4,
                      "default": 0
                    },
                    "price": {},
                    "frequency_days": {
                      "type": "integer",
                      "example": 120,
                      "default": 0
                    },
                    "reminder_days": {
                      "type": "integer",
                      "example": 10,
                      "default": 0
                    },
                    "every": {
                      "type": "integer",
                      "example": 4,
                      "default": 0
                    },
                    "every_period": {
                      "type": "integer",
                      "example": 3,
                      "default": 0
                    },
                    "start_date": {
                      "type": "string",
                      "example": "2018-12-27"
                    },
                    "cancelled": {
                      "type": "string",
                      "example": "2019-04-02 13:54:12"
                    },
                    "cancel_reason": {
                      "type": "string",
                      "example": "4|Overstocked"
                    },
                    "cancel_reason_code": {
                      "type": "integer",
                      "example": 4,
                      "default": 0
                    },
                    "iteration": {},
                    "sequence": {},
                    "session_id": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"
                    },
                    "merchant_order_id": {
                      "type": "string",
                      "example": "2906548"
                    },
                    "customer_rep": {},
                    "club": {},
                    "created": {
                      "type": "string",
                      "example": "2018-10-10 14:45:38"
                    },
                    "updated": {
                      "type": "string",
                      "example": "2019-04-02 13:54:12"
                    },
                    "live": {
                      "type": "boolean",
                      "example": false,
                      "default": true
                    }
                  }
                }
              }
            }
          },
          "400": {
            "description": "400",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {}
                }
              }
            }
          },
          "423": {
            "description": "423",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{'details': 'Resource is currently in use. Please try again shortly.'}"
                  }
                }
              }
            }
          }
        },
        "deprecated": false,
        "x-readme": {
          "code-samples": [
            {
              "language": "http",
              "code": "https://staging.restapi.ordergroove.com/subscriptions/E3e9ac44a24f15e485b0bc764e107cf3/cancel/",
              "name": "Staging"
            },
            {
              "language": "http",
              "code": "https://restapi.ordergroove.com/subscriptions/E3e9ac44a24f15e485b0bc764e107cf3/cancel/",
              "name": "Production"
            }
          ],
          "samples-languages": [
            "http"
          ]
        }
      }
    }
  },
  "x-readme": {
    "headers": [],
    "explorer-enabled": true,
    "proxy-enabled": true
  },
  "x-readme-fauxas": true
}
```