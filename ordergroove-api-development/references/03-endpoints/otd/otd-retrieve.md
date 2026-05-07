# Retrieve

Returns a single order by its unique one time incentive identifier.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name           | Type   | Description                                | Example                          |
| :------------- | :----- | :----------------------------------------- | :------------------------------- |
| public\_id     | string | One-Time Incentive ID                      | 8637c3fe9b7011eaa2c1bc764e107990 |
| external\_code | string | External Code                              | awesome\_discount                |
| description    | string | Description                                | One-Time Incentive               |
| merchant       | string | Merchant ID                                | ac4f7938383a11e89ecbbc764e1107f2 |
| customer       | string | Customer ID                                | 00026001                         |
| order          | string | Order ID                                   | c4e05d04ccc411e8ada3bc764e101db1 |
| created        | string | Datetime of creation                       | 2020-05-21 09:36:57              |
| last\_updated  | string | Datetime of last update                    | 2020-05-21 09:36:57              |
| incentive      | object | Incentive object                           |                                  |
| applied\_at    | string | Datetime of when the incentive was applied | 2020-05-21 09:36:57              |

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
    "/one_time_incentives/{one_time_incentive_id}/": {
      "get": {
        "summary": "Retrieve",
        "description": "Returns a single order by its unique one time incentive identifier.",
        "operationId": "otd-retrieve",
        "parameters": [
          {
            "name": "one_time_incentive_id",
            "in": "path",
            "description": "Unique one-time incentive id",
            "schema": {
              "type": "string"
            },
            "required": true
          }
        ],
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n    \"public_id\": \"8637c3fe9b7011eaa2c1bc764e107990\",\n    \"external_code\": \"awesome_discount\",\n    \"description\": \"One-time Incentive\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"customer\": \"00026001\",\n    \"order\": \"c4e05d04ccc411e8ada3bc764e101db1\",\n    \"created\": \"2020-05-21 09:36:57\",\n    \"last_updated\": \"2020-05-21 09:36:57\",\n    \"incentive\": {\n        \"type\": \"Discount\",\n        \"public_id\": \"c34a8c03eae641d0ab7015bedec6fbd0\",\n        \"discount_type\": \"Discount Percent\",\n        \"target\": \"item\",\n        \"field\": \"total_price\",\n        \"name\": \"awesome discount\",\n        \"value\": \"10.00\"\n    },\n    \"applied_at\": \"2020-05-21 09:36:57\"\n}"
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
                    },
                    "applied_at": {
                      "type": "string",
                      "example": "2020-05-21 09:36:57"
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
                    "value": "{\"detail\": \"Not found\"}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "detail": {
                      "type": "string",
                      "example": "Not found"
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