# Update

Updates an existing one-time incentive.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name           | Type   | Description             | Example                          |
| :------------- | :----- | :---------------------- | :------------------------------- |
| public\_id     | string | One-Time Incentive ID   | 8637c3fe9b7011eaa2c1bc764e107990 |
| external\_code | string | External Code           | awesome\_discount                |
| description    | string | Description             | One-Time Incentive               |
| merchant       | string | Merchant ID             | ac4f7938383a11e89ecbbc764e1107f2 |
| customer       | string | Customer ID             | 00026001                         |
| order          | string | Order ID                | c4e05d04ccc411e8ada3bc764e101db1 |
| created        | string | Datetime of creation    | 2020-05-21 09:36:57              |
| last\_updated  | string | Datetime of last update | 2020-05-21 09:36:57              |
| incentive      | object | Incentive object        |                                  |

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
    "/one_time_incentives/{one_time_incentive_id}/update/": {
      "patch": {
        "summary": "Update",
        "description": "Updates an existing one-time incentive.",
        "operationId": "otd-update",
        "parameters": [
          {
            "name": "one_time_incentive_id",
            "in": "path",
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
                  "external_code": {
                    "type": "string",
                    "description": "External Code"
                  },
                  "description": {
                    "type": "string",
                    "description": "Description"
                  },
                  "order": {
                    "type": "string",
                    "description": "Order ID"
                  },
                  "item": {
                    "type": "string",
                    "description": "Item ID"
                  },
                  "incentive": {
                    "properties": {
                      "discount_type": {
                        "type": "string",
                        "description": "For discount incentives. Choose 'Discount Percent' for a percent off discount or 'Discount Amount' for a flat dollar off discount."
                      },
                      "target": {
                        "type": "string",
                        "description": "If you're applying a order target discount you can choose from 'subtotal' or 'shipping_total' for all item target discounts send 'total_price'"
                      },
                      "name": {
                        "type": "string",
                        "description": "Anything to help identify this incentive"
                      },
                      "value": {
                        "type": "string",
                        "description": "For discount incentives. The value of the discount eg 5 for $5off or 10 for 10%off"
                      },
                      "product": {
                        "type": "string",
                        "description": "For gift incentives. External product id for the gift product."
                      }
                    },
                    "required": [],
                    "type": "object",
                    "description": "Incentive Object"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "201",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n    \"public_id\": \"8637c3fe9b7011eaa2c1bc764e107990\",\n    \"external_code\": \"awesome_discount\",\n    \"description\": \"One-time Incentive\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"customer\": \"00026001\",\n    \"order\": \"c4e05d04ccc411e8ada3bc764e101db1\",\n    \"created\": \"2020-05-21 09:36:57\",\n    \"last_updated\": \"2020-05-21 09:36:57\",\n    \"incentive\": {\n        \"type\": \"Discount\",\n        \"public_id\": \"c34a8c03eae641d0ab7015bedec6fbd0\",\n        \"discount_type\": \"Discount Percent\",\n        \"target\": \"item\",\n        \"field\": \"total_price\",\n        \"name\": \"awesome discount\",\n        \"value\": \"10.00\"\n    }\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "public_id": {
                      "type": "string",
                      "example": "8637c3fe9b7011eaa2c1bc764e107990"
                    },
                    "external_code": {
                      "type": "string",
                      "example": "awesome_discount"
                    },
                    "description": {
                      "type": "string",
                      "example": "One-time Incentive"
                    },
                    "merchant": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2"
                    },
                    "customer": {
                      "type": "string",
                      "example": "00026001"
                    },
                    "order": {
                      "type": "string",
                      "example": "c4e05d04ccc411e8ada3bc764e101db1"
                    },
                    "created": {
                      "type": "string",
                      "example": "2020-05-21 09:36:57"
                    },
                    "last_updated": {
                      "type": "string",
                      "example": "2020-05-21 09:36:57"
                    },
                    "incentive": {
                      "type": "object",
                      "properties": {
                        "type": {
                          "type": "string",
                          "example": "Discount"
                        },
                        "public_id": {
                          "type": "string",
                          "example": "c34a8c03eae641d0ab7015bedec6fbd0"
                        },
                        "discount_type": {
                          "type": "string",
                          "example": "Discount Percent"
                        },
                        "target": {
                          "type": "string",
                          "example": "item"
                        },
                        "field": {
                          "type": "string",
                          "example": "total_price"
                        },
                        "name": {
                          "type": "string",
                          "example": "awesome discount"
                        },
                        "value": {
                          "type": "string",
                          "example": "10.00"
                        }
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