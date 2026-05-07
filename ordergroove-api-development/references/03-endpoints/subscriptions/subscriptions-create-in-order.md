# Create in Order

Creates a subscription with its first shipment in an existing order (dictated by the 'order' field in the request). This will be tracked by OrderGroove as an 'Impulse Upsell' order.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name                           | Type             | Description                                                                                                                                               | Example                                                 |
| ------------------------------ | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| customer                       | string           | Customer ID                                                                                                                                               | `"00026001"`                                            |
| merchant                       | string           | Merchant ID                                                                                                                                               | `"ac4f7938383a11e89ecbbc764e1107f2"`                    |
| product                        | string           | Product ID                                                                                                                                                | `"0070000693"`                                          |
| payment                        | string           | Payment record ID                                                                                                                                         | `"070001bc02fd11e99542bc764e1043b0"`                    |
| shipping\_address              | string           | Shipping address record ID                                                                                                                                | `"66c25cd0564011e9abc5bc764e107990"`                    |
| offer                          | string           | Offer ID                                                                                                                                                  | `"a748aa648ac811e8af3bbc764e106cf4"`                    |
| subscription\_type             | string           | Subscription Type                                                                                                                                         | `"Replenish"`                                           |
| components                     | string           | Legacy Bundle components                                                                                                                                  | See [Legacy Bundle Example](#legacy-bundle-example)     |
| components                     | array of objects | New Bundle components - See structure below                                                                                                               | See [New Bundle Example](#new-bundle-example)           |
| extra\_data                    | string           | Raw JSON string that should be JSON.parse() as key/value store for any extra information.                                                                 | `"{\"some\": \"extra\", \"fields\": \"here\"}"`         |
| public\_id                     | string           | Subscription ID                                                                                                                                           | `"f9cb2f93e1c845eb9de9eff46ddb3cbf"`                    |
| product\_attribute             | string           |                                                                                                                                                           | `null`                                                  |
| quantity                       | integer          | Number of items                                                                                                                                           | `21`                                                    |
| price                          | string           | Price                                                                                                                                                     | `"12.99"`                                               |
| frequency\_days                | integer          | Order placement interval in days                                                                                                                          | `42`                                                    |
| reminder\_days                 | integer          | Days before order placement to email reminder (minimum of 5)                                                                                              | `42`                                                    |
| every                          | integer          | Number of periods                                                                                                                                         | `6`                                                     |
| every\_period                  | integer          | Type of period                                                                                                                                            | `3`                                                     |
| start\_date                    | string           | Date of subscription start, in format YYYY-MM-DD                                                                                                          | `"2019-07-21"`                                          |
| cancelled                      | string           | Date of subscription cancellation; null=not cancelled.                                                                                                    | `null`                                                  |
| cancel\_reason                 | string           | Pipe-delimited cancel reason code and cancel reason details                                                                                               | `"4\|Overstocked"`                                      |
| cancel\_reason\_code           | string           | Cancel reason code                                                                                                                                        | `"4"`                                                   |
| currency\_code                 | string           | Three letter ISO currency code                                                                                                                            | `"USD"`                                                 |
| ~~iteration~~                  | string           |                                                                                                                                                           | *Deprecated*                                            |
| ~~sequence~~                   | string           |                                                                                                                                                           | *Deprecated*                                            |
| session\_id                    | string           | Session ID, obtained from og\_session\_id cookie                                                                                                          | `"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"`  |
| merchant\_order\_id            | string           | Order ID in your system                                                                                                                                   | `"301617"`                                              |
| ~~customer\_rep~~              | string           |                                                                                                                                                           | *Deprecated*                                            |
| ~~club~~                       | string           |                                                                                                                                                           | *Deprecated*                                            |
| created                        | string           | Date created                                                                                                                                              | `"2017-02-29 12:00:00"`                                 |
| updated                        | string           | Date updated                                                                                                                                              | `"2017-02-29 12:00:00"`                                 |
| live                           | boolean          | True=active subscription; False=inactive subscription                                                                                                     | `true`                                                  |
| prepaid\_subscription\_context | object           | [Prepaid information](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data) - Returned only if prepaid is enabled | See [Prepaid Context Example](#prepaid-context-example) |

### Legacy Bundle Example

```json
[{"product": "product_id_1"}]
```

### New Bundle Example

New Bundle components structure: Each component object contains `public_id` (string), `quantity` (integer), and `product` (string).

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

### Prepaid Context Example

```json
{
  "prepaid_orders_remaining": 0,
  "prepaid_orders_per_billing": 3,
  "renewal_behavior": "autorenew",
  "last_renewal_revenue": 100.8,
  "prepaid_origin_merchant_order_id": "#3082"
}
```

Or empty object: `{}`

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
    "/subscriptions/iu/": {
      "post": {
        "summary": "Create in Order",
        "description": "Creates a subscription with its first shipment in an existing order (dictated by the 'order' field in the request). This will be tracked by OrderGroove as an 'Impulse Upsell' order.",
        "operationId": "subscriptions-create-in-order",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "merchant",
                  "customer",
                  "product",
                  "offer",
                  "order",
                  "session_id",
                  "payment",
                  "shipping_address",
                  "quantity",
                  "every",
                  "every_period"
                ],
                "properties": {
                  "merchant": {
                    "type": "string",
                    "description": "Merchant ID"
                  },
                  "customer": {
                    "type": "string",
                    "description": "Customer ID"
                  },
                  "product": {
                    "type": "string",
                    "description": "Product ID"
                  },
                  "price": {
                    "type": "string",
                    "description": "Price of subscription. To be used with Price Lock."
                  },
                  "offer": {
                    "type": "string",
                    "description": "Offer ID"
                  },
                  "order": {
                    "type": "string",
                    "description": "Order ID"
                  },
                  "session_id": {
                    "type": "string",
                    "description": "Session ID, obtained from og_session_id cookie"
                  },
                  "payment": {
                    "type": "string",
                    "description": "Payment record ID"
                  },
                  "shipping_address": {
                    "type": "string",
                    "description": "Shipping address record ID"
                  },
                  "quantity": {
                    "type": "integer",
                    "description": "Number of items",
                    "format": "int32"
                  },
                  "every": {
                    "type": "integer",
                    "description": "Number of periods",
                    "format": "int32"
                  },
                  "every_period": {
                    "type": "integer",
                    "description": "Type of period",
                    "format": "int32"
                  },
                  "extra_data": {
                    "type": "string",
                    "description": "{\"cat_name\": \"Charlie\"}",
                    "format": "json"
                  },
                  "components": {
                    "type": "array",
                    "description": "Multi Item Bundle components:  [{\"product\":\"public_id_abc\", \"quantity\": 2}], Legacy Bundle components: [{\"product\":\"public_id_abc\"}]",
                    "items": {
                      "properties": {
                        "product": {
                          "type": "string",
                          "description": "The id of the product that is being added to the bundle"
                        },
                        "quantity": {
                          "type": "integer",
                          "description": "The quantity of the product being added",
                          "default": 1,
                          "format": "int32"
                        }
                      },
                      "required": [
                        "product",
                        "quantity"
                      ],
                      "type": "object"
                    }
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
                    "value": "{\n  \"public_id\": \"f9cb2f93e1c845eb9de9eff46ddb3cbf\",\n  \"product_attribute\": null,\n  \"price\": \"12.99\",\n  \"frequency_days\": 42,\n  \"reminder_days\": 42,\n  \"start_date\": \"2017-02-29 12:00:00\",\n  \"cancelled\": null,\n  \"cancel_reason_code\": \"4|\",\n  \"cancel_reason\": \"4|Overstocked\",\n  \"merchant_order_id\": \"301617\",\n  \"subscription_type\": \"Replenish\",\n  \"components\": [\n    {\n      \"product\": \"product_id_1\"\n    }\n  ],\n  \"created\": \"2017-02-29 12:00:00\",\n  \"updated\": \"2017-02-29 12:00:00\",\n  \"extra_data\": \"{\\\"some\\\": \\\"extra\\\", \\\"fields\\\": \\\"here\\\"}\",\n  \"live\": \"True\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "public_id": {
                      "type": "string",
                      "example": "f9cb2f93e1c845eb9de9eff46ddb3cbf"
                    },
                    "product_attribute": {},
                    "price": {
                      "type": "string",
                      "example": "12.99"
                    },
                    "frequency_days": {
                      "type": "integer",
                      "example": 42,
                      "default": 0
                    },
                    "reminder_days": {
                      "type": "integer",
                      "example": 42,
                      "default": 0
                    },
                    "start_date": {
                      "type": "string",
                      "example": "2017-02-29 12:00:00"
                    },
                    "cancelled": {},
                    "cancel_reason_code": {
                      "type": "string",
                      "example": "4|"
                    },
                    "cancel_reason": {
                      "type": "string",
                      "example": "4|Overstocked"
                    },
                    "merchant_order_id": {
                      "type": "string",
                      "example": "301617"
                    },
                    "subscription_type": {
                      "type": "string",
                      "example": "Replenish"
                    },
                    "components": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "product": {
                            "type": "string",
                            "example": "product_id_1"
                          }
                        }
                      }
                    },
                    "created": {
                      "type": "string",
                      "example": "2017-02-29 12:00:00"
                    },
                    "updated": {
                      "type": "string",
                      "example": "2017-02-29 12:00:00"
                    },
                    "extra_data": {
                      "type": "string",
                      "example": "{\"some\": \"extra\", \"fields\": \"here\"}"
                    },
                    "live": {
                      "type": "string",
                      "example": "True"
                    }
                  }
                }
              }
            }
          },
          "400": {
            "description": "400",
            "content": {
              "text/plain": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"[field_name]\": \"field_name error detail\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "[field_name]": {
                      "type": "string",
                      "example": "field_name error detail"
                    }
                  }
                }
              }
            }
          },
          "403": {
            "description": "403",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"detail\": \"Authentication Failed\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "detail": {
                      "type": "string",
                      "example": "Authentication Failed"
                    }
                  }
                }
              }
            }
          }
        },
        "deprecated": false
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