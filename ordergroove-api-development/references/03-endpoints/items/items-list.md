# List

Returns a list of all the order items for an individual user.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope

  Note: Application API Scope with Bulk Operations permission is required to list items for more than one customer.
</Callout>

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
    "/items/": {
      "get": {
        "summary": "List",
        "description": "Returns a list of all the order items for an individual user.",
        "operationId": "items-list",
        "parameters": [
          {
            "name": "order",
            "in": "query",
            "description": "Order ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "offer",
            "in": "query",
            "description": "Offer ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "subscription",
            "in": "query",
            "description": "Subscription ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "one_time",
            "in": "query",
            "description": "Indicates if item was the result of Impulse Upsell functionality",
            "schema": {
              "type": "boolean"
            }
          },
          {
            "name": "status",
            "in": "query",
            "description": "Order status code",
            "schema": {
              "type": "integer",
              "format": "int32"
            }
          },
          {
            "name": "place",
            "in": "query",
            "description": "Order's place date exact match (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "place_start",
            "in": "query",
            "description": "Order's place date later or equal than parameter (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "place_end",
            "in": "query",
            "description": "Order's place date sooner or equal than parameter (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "product",
            "in": "query",
            "description": "Product's external_product_id - filter items by the proper product currently associated with them.",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "omit_price_calculation",
            "in": "query",
            "description": "If True, Ordergroove will omit the `price`, `total_cost`, and `extra_cost` fields from the Response Body. This can significantly improve performance in some scenarios.",
            "schema": {
              "type": "boolean",
              "default": false
            }
          },
          {
            "name": "order_updated_start",
            "in": "query",
            "description": "items whose order.updated field is greater than or equal to the given datetime (YYYY-MM-DDTHH:MM:SS)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "order_updated_end",
            "in": "query",
            "description": "items whose order.updated field is less than or equal to the given datetime (YYYY-MM-DDTHH:MM:SS)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "\"results\": [\n        {\n            \"order\": \"c4e05d04ccc411e8ada3bc764e101db1\",\n            \"offer\": \"a748aa648ac811e8af3bbc764e106cf4\",\n            \"subscription\": null,\n            \"product\": \"0070000693\",\n            \"components\": [],\n            \"quantity\": 1,\n            \"public_id\": \"58072de4ccc811e88516bc764e106cf4\",\n            \"product_attribute\": null,\n            \"price\": \"26.99\",\n            \"extra_cost\": \"0.00\",\n            \"total_price\": \"13.22\",\n            \"one_time\": true,\n            \"order_updated\": \"2025-01-31 00:00:00\",\n            \"frozen\": false,\n            \"first_placed\": null,\n        }\n    ]\n"
                  },
                  "Omit Pricing": {
                    "value": "\"results\": [\n        {\n            \"order\": \"c4e05d04ccc411e8ada3bc764e101db1\",\n            \"offer\": \"a748aa648ac811e8af3bbc764e106cf4\",\n            \"subscription\": null,\n            \"product\": \"0070000693\",\n            \"components\": [],\n            \"quantity\": 1,\n            \"public_id\": \"58072de4ccc811e88516bc764e106cf4\",\n            \"product_attribute\": null,\n            \"one_time\": true,\n            \"frozen\": false,\n            \"first_placed\": null\n        }\n    ]"
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
          },
          "404": {
            "description": "404",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"detail\": \"Unable to find requested asset.\"\n}\n"
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