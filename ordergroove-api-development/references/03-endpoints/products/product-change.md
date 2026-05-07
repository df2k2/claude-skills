# Product Change

Use this request to change the product that the order item is tied to.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name                    | Type      | Description                                                                                    | Example                               |                                    |
| :---------------------- | :-------- | :--------------------------------------------------------------------------------------------- | :------------------------------------ | ---------------------------------- |
| public\_id              | string    | Item ID                                                                                        | "f9cb2f93e1c845eb9de9eff46ddb3cbf"    |                                    |
| order                   | string    | Order ID                                                                                       | "9e78860ef49c4a86861ca11f638e5488"    |                                    |
| offer                   | string    | Offer ID                                                                                       | "4a10a0e1738f46bf9d81be56ea6d8d85"    |                                    |
| subscription            | string    | Subscription ID                                                                                | "565998a03d7a4647971aab47f8c487f9"    |                                    |
| product                 | string    | Product ID                                                                                     | "62900-W01"                           |                                    |
| ~~product\_attribute~~  | string    |                                                                                                | *Deprecated*                          |                                    |
| quantity                | integer   | Number of items                                                                                | 2                                     |                                    |
| price                   | string    | Item Price                                                                                     | "12.99"                               |                                    |
| extra\_cost             | string    |                                                                                                | "1.00"                                |                                    |
| total\_price            | string    | Total price of item in order                                                                   | "9.20"                                |                                    |
| one\_time               | boolean   | Indicates if item order was result of Impulse Upsell functionality                             | false                                 |                                    |
| order\_updated          | string    | The date and time the order this item belongs to was last updated. Format: YYYY-MM-DD HH:mm:ss | "2025-01-31 00:00:00"                 |                                    |
| components              | string    | Legacy Bundle Components                                                                       | "product\_id\_1,product\_id\_2"       |                                    |
| subscription\_component | string \\ | null                                                                                           | New Bundle Subscription  Component ID | "85eae83c245111eeb185acde48001122" |

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
    "/items/{item_id}/change_product/": {
      "patch": {
        "summary": "Product Change",
        "description": "Use this request to change the product that the order item is tied to.",
        "operationId": "product-change",
        "parameters": [
          {
            "name": "item_id",
            "in": "path",
            "description": "Public ID of the order item you want to change",
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
                  "product": {
                    "type": "string",
                    "description": "The product ID you want to change this order item to"
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
                    "value": "{\n  \"public_id\": \"f9cb2f93e1c845eb9de9eff46ddb3cbf\",\n  \"order\": \"9e78860ef49c4a86861ca11f638e5488\",\n  \"offer\": \"4a10a0e1738f46bf9d81be56ea6d8d85\",\n  \"subscription\": \"565998a03d7a4647971aab47f8c487f9\",\n  \"subscription_component\": \"85eae83c245111eeb185acde48001122\",\n  \"product\": \"62900-W01\",\n  \"product_attribute\": null,\n  \"quantity\": 2,\n  \"price\": \"12.99\",\n  \"extra_cost\": \"1.00\",\n  \"total_price\": \"9.20\",\n  \"one_time\": false,\n  \"order_updated\": \"2025-01-31 00:00:00\",\n  \"components\": [\n    \"product_id_1\",\n    \"product_id_2\"\n  ]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "public_id": {
                      "type": "string",
                      "example": "f9cb2f93e1c845eb9de9eff46ddb3cbf"
                    },
                    "order": {
                      "type": "string",
                      "example": "9e78860ef49c4a86861ca11f638e5488"
                    },
                    "offer": {
                      "type": "string",
                      "example": "4a10a0e1738f46bf9d81be56ea6d8d85"
                    },
                    "subscription": {
                      "type": "string",
                      "example": "565998a03d7a4647971aab47f8c487f9"
                    },
                    "subscription_component": {
                      "type": "string",
                      "example": "85eae83c245111eeb185acde48001122"
                    },
                    "product": {
                      "type": "string",
                      "example": "62900-W01"
                    },
                    "product_attribute": {},
                    "quantity": {
                      "type": "integer",
                      "example": 2,
                      "default": 0
                    },
                    "price": {
                      "type": "string",
                      "example": "12.99"
                    },
                    "extra_cost": {
                      "type": "string",
                      "example": "1.00"
                    },
                    "total_price": {
                      "type": "string",
                      "example": "9.20"
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
                    "components": {
                      "type": "array",
                      "items": {
                        "type": "string",
                        "example": "product_id_1"
                      }
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
          },
          "404": {
            "description": "404",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"detail\": \"Unable to find requested asset.\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "detail": {
                      "type": "string",
                      "example": "Unable to find requested asset."
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