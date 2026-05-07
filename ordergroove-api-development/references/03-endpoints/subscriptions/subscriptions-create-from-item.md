# Create From Item

Creates a subscription based on the properties of an item and order.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name                           | Type             | Description                                                                                                                                               | Example                                                |
| ------------------------------ | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| customer                       | string           | Customer ID                                                                                                                                               | `"00026001"`                                           |
| merchant                       | string           | Merchant ID                                                                                                                                               | `"ac4f7938383a11e89ecbbc764e1107f2"`                   |
| product                        | string           | Product ID                                                                                                                                                | `"0070000693"`                                         |
| payment                        | string           | Payment record ID                                                                                                                                         | `"070001bc02fd11e99542bc764e1043b0"`                   |
| shipping\_address              | string           | Shipping address record ID                                                                                                                                | `"66c25cd0564011e9abc5bc764e107990"`                   |
| offer                          | string           | Offer ID                                                                                                                                                  | `"a748aa648ac811e8af3bbc764e106cf4"`                   |
| subscription\_type             | string           | Subscription Type                                                                                                                                         | `"Replenish"`                                          |
| components                     | string           | Legacy Bundle components                                                                                                                                  | See Legacy Bundle Example below                        |
| components                     | array of objects | New Bundle components                                                                                                                                     | See New Bundle Example below                           |
| extra\_data                    | string           | Raw JSON string that should be JSON.parse() as key/value store for any extra information.                                                                 | `"{\"some\": \"extra\", \"fields\": \"here\"}"`        |
| public\_id                     | string           | Subscription ID                                                                                                                                           | `"f9cb2f93e1c845eb9de9eff46ddb3cbf"`                   |
| product\_attribute             | string           |                                                                                                                                                           | `"null"`                                               |
| quantity                       | integer          | Number of items                                                                                                                                           | `21`                                                   |
| price                          | string           | Price                                                                                                                                                     | `"12.99"`                                              |
| frequency\_days                | integer          | Order placement interval in days                                                                                                                          | `42`                                                   |
| reminder\_days                 | integer          | Days before order placement to email reminder (minimum of 5)                                                                                              | `42`                                                   |
| every                          | integer          | Number of periods                                                                                                                                         | `6`                                                    |
| every\_period                  | integer          | Type of period                                                                                                                                            | `3`                                                    |
| start\_date                    | string           | Date of subscription start, in format YYYY-MM-DD                                                                                                          | `"2019-07-21"`                                         |
| cancelled                      | string           | Date of subscription cancellation; null=not cancelled.                                                                                                    | `"null"`                                               |
| cancel\_reason                 | string           | Pipe-delimited cancel reason code and cancel reason details                                                                                               | `"4\|Overstocked"`                                     |
| cancel\_reason\_code           | string           | Cancel reason code                                                                                                                                        | `"4"`                                                  |
| currency\_code                 | string           | Three letter ISO currency code                                                                                                                            | `"USD"`                                                |
| ~~iteration~~                  | string           |                                                                                                                                                           | *Deprecated*                                           |
| ~~sequence~~                   | string           |                                                                                                                                                           | *Deprecated*                                           |
| session\_id                    | string           | Session ID, obtained from og\_session\_id cookie                                                                                                          | `"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"` |
| merchant\_order\_id            | string           | Order ID in your system                                                                                                                                   | `"301617"`                                             |
| ~~customer\_rep~~              | string           |                                                                                                                                                           | *Deprecated*                                           |
| ~~club~~                       | string           |                                                                                                                                                           | *Deprecated*                                           |
| created                        | string           | Date created                                                                                                                                              | `"2017-02-29 12:00:00"`                                |
| updated                        | string           | Date updated                                                                                                                                              | `"2017-02-29 12:00:00"`                                |
| live                           | boolean          | True=active subscription; False=inactive subscription                                                                                                     | `true`                                                 |
| prepaid\_subscription\_context | object           | [Prepaid information](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data) - Returned only if prepaid is enabled | See Prepaid Example below                              |

### Components Examples

**Legacy Bundle Example:**

```json
[{"product": "product_id_1"}]
```

**New Bundle Example:**

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

**New Bundle Components Type Definition:**

```
array of objects: {
  public_id: string
  quantity: integer
  product: string
}
```

### Prepaid Subscription Context Example

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
    "/subscriptions/create_from_item/": {
      "post": {
        "summary": "Create From Item",
        "description": "Creates a subscription based on the properties of an item and order.",
        "operationId": "subscriptions-create-from-item",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "item",
                  "every",
                  "every_period"
                ],
                "properties": {
                  "item": {
                    "type": "string",
                    "description": "Item ID"
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
                  "offer": {
                    "type": "string",
                    "description": "Offer ID"
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
                    "value": "{\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"product\": \"0070000693\",\n    \"payment\": \"070001bc02fd11e99542bc764e1043b0\",\n    \"shipping_address\": \"66c25cd0564011e9abc5bc764e107990\",\n    \"offer\": \"a748aa648ac811e8af3bbc764e106cf4\",\n    \"subscription_type\": \"replenishment\",\n    \"components\": [\n      {\n        \"product\": \"product_id_1\"\n      }\n    ],\n    \"extra_data\": {},\n    \"public_id\": \"607daa2accc811e88516bc764e106cf4\",\n    \"product_attribute\": null,\n    \"quantity\": 21,\n    \"price\": null,\n    \"frequency_days\": 180,\n    \"reminder_days\": 10,\n    \"every\": 6,\n    \"every_period\": 3,\n    \"start_date\": \"2018-12-27\",\n    \"cancelled\": null,\n    \"cancel_reason\": null,\n    \"cancel_reason_code\": null,\n    \"iteration\": null,\n    \"sequence\": null,\n    \"session_id\": \"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086\",\n    \"merchant_order_id\": \"2906548\",\n    \"customer_rep\": null,\n    \"club\": null,\n    \"created\": \"2018-10-10 15:09:21\",\n    \"updated\": \"2019-04-04 11:28:39\",\n    \"live\": true\n}\n"
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
                      "example": "0070000693"
                    },
                    "payment": {
                      "type": "string",
                      "example": "070001bc02fd11e99542bc764e1043b0"
                    },
                    "shipping_address": {
                      "type": "string",
                      "example": "66c25cd0564011e9abc5bc764e107990"
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
                        "properties": {
                          "product": {
                            "type": "string",
                            "example": "product_id_1"
                          }
                        }
                      }
                    },
                    "extra_data": {
                      "type": "object",
                      "properties": {}
                    },
                    "public_id": {
                      "type": "string",
                      "example": "607daa2accc811e88516bc764e106cf4"
                    },
                    "product_attribute": {},
                    "quantity": {
                      "type": "integer",
                      "example": 21,
                      "default": 0
                    },
                    "price": {},
                    "frequency_days": {
                      "type": "integer",
                      "example": 180,
                      "default": 0
                    },
                    "reminder_days": {
                      "type": "integer",
                      "example": 10,
                      "default": 0
                    },
                    "every": {
                      "type": "integer",
                      "example": 6,
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
                    "cancelled": {},
                    "cancel_reason": {},
                    "cancel_reason_code": {},
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
                      "example": "2018-10-10 15:09:21"
                    },
                    "updated": {
                      "type": "string",
                      "example": "2019-04-04 11:28:39"
                    },
                    "live": {
                      "type": "boolean",
                      "example": true,
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
                    "value": "{\n  \"[field_name]\": \"field_name error detail\"\n}\n"
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
                    "value": "{\n  \"detail\": \"Authentication Failed\"\n}\n"
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