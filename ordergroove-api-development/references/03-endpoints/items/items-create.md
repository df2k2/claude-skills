# Create

This endpoint locates an existing order using the specified place date, shipping, payment and customer parameters, adding an additional item to that order.  If no order exists with these parameters, it will create a new order and add an item for that order.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

**Attempting to call these on a prepaid subscription will result in a 400 error.**

## Response Body Definitions

| Name                    | Type      | Description                                                                                    | Example                               |                                    |
| :---------------------- | :-------- | :--------------------------------------------------------------------------------------------- | :------------------------------------ | ---------------------------------- |
| offer                   | string    | Offer ID                                                                                       | "4a10a0e1738f46bf9d81be56ea6d8d85"    |                                    |
| order                   | string    | Order ID                                                                                       | "9e78860ef49c4a86861ca11f638e5488"    |                                    |
| subscription            | string    | Subscription ID                                                                                | "565998a03d7a4647971aab47f8c487f9"    |                                    |
| product                 | string    | Product ID                                                                                     | "62900-W01"                           |                                    |
| components              | string    | Legacy Bundle components                                                                       | "product\_id\_1,product\_id\_2"       |                                    |
| subscription\_component | string \\ | null                                                                                           | New Bundle Subscription  Component ID | "85eae83c245111eeb185acde48001122" |
| quantity                | integer   | Number of items                                                                                | 2                                     |                                    |
| public\_id              | string    | Item ID                                                                                        | "f9cb2f93e1c845eb9de9eff46ddb3cbf"    |                                    |
| ~~product\_attribute~~  | string    |                                                                                                | *Deprecated*                          |                                    |
| price                   | string    | Item price                                                                                     | "12.99"                               |                                    |
| extra\_cost             | string    |                                                                                                | "1.00"                                |                                    |
| total\_price            | string    | Total price of item in order                                                                   | "9.20"                                |                                    |
| one\_time               | boolean   | Indicates if item order was result of Impulse Upsell functionality                             | false                                 |                                    |
| order\_updated          | string    | The date and time the order this item belongs to was last updated. Format: YYYY-MM-DD HH:mm:ss | "2025-01-31 00:00:00"                 |                                    |
| frozen                  | boolean   |                                                                                                | false                                 |                                    |
| first\_placed           |           |                                                                                                |                                       |                                    |

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
    "/items/create/": {
      "post": {
        "summary": "Create",
        "description": "This endpoint locates an existing order using the specified place date, shipping, payment and customer parameters, adding an additional item to that order.  If no order exists with these parameters, it will create a new order and add an item for that order.",
        "operationId": "items-create",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "merchant_id",
                  "customer_id",
                  "shipping_id",
                  "payment_id",
                  "offer_id",
                  "product_id",
                  "place_date",
                  "quantity"
                ],
                "properties": {
                  "merchant_id": {
                    "type": "string",
                    "description": "Merchant ID"
                  },
                  "customer_id": {
                    "type": "string",
                    "description": "Customer ID"
                  },
                  "shipping_id": {
                    "type": "string",
                    "description": "Shipping address record ID"
                  },
                  "payment_id": {
                    "type": "string",
                    "description": "Payment record ID"
                  },
                  "offer_id": {
                    "type": "string",
                    "description": "Offer ID"
                  },
                  "product_id": {
                    "type": "string",
                    "description": "Product ID"
                  },
                  "place_date": {
                    "type": "string",
                    "description": "Date for order placement, should be in MM/DD/YYYY format"
                  },
                  "quantity": {
                    "type": "integer",
                    "description": "Number of items",
                    "format": "int32"
                  },
                  "contexts": {
                    "type": "object",
                    "description": "Items contexts as key:value",
                    "properties": {}
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
                    "value": "{\n    \"order\": \"45c27952cd9211e8855abc764e106cf4\",\n    \"offer\": null,\n    \"subscription\": \"6199282ccd8f11e88267bc764e106cf4\",\n    \"product\": \"0070067698\",\n    \"components\": [],\n    \"subscription_component\": \"85eae83c245111eeb185acde48001122\",\n    \"quantity\": 1,\n    \"public_id\": \"45c39ceccd9211e8855abc764e106cf4\",\n    \"product_attribute\": null,\n    \"price\": \"79.99\",\n    \"extra_cost\": \"0.00\",\n    \"total_price\": \"35.99\",\n    \"one_time\": false,\n    \"order_updated\": \"2025-01-31 00:00:00\",\n    \"frozen\": false,\n    \"first_placed\": null\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "order": {
                      "type": "string",
                      "example": "45c27952cd9211e8855abc764e106cf4"
                    },
                    "offer": {},
                    "subscription": {
                      "type": "string",
                      "example": "6199282ccd8f11e88267bc764e106cf4"
                    },
                    "product": {
                      "type": "string",
                      "example": "0070067698"
                    },
                    "components": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {}
                      }
                    },
                    "subscription_component": {
                      "type": "string",
                      "example": "85eae83c245111eeb185acde48001122"
                    },
                    "quantity": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "public_id": {
                      "type": "string",
                      "example": "45c39ceccd9211e8855abc764e106cf4"
                    },
                    "product_attribute": {},
                    "price": {
                      "type": "string",
                      "example": "79.99"
                    },
                    "extra_cost": {
                      "type": "string",
                      "example": "0.00"
                    },
                    "total_price": {
                      "type": "string",
                      "example": "35.99"
                    },
                    "one_time": {
                      "type": "boolean",
                      "example": false,
                      "default": true
                    },
                    "order_updated": {
                      "type": "string",
                      "example": "2025-01-31 00:00:00"
                    },
                    "frozen": {
                      "type": "boolean",
                      "example": false,
                      "default": true
                    },
                    "first_placed": {}
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