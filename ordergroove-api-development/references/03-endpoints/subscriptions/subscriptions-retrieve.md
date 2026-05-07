# Retrieve

Returns information about a single subscription by its unique identifier.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope

  Note: Application API Scope with Bulk Operations permission is required to list subscriptions for more than one customer.
</Callout>

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
    "/subscriptions/{subscription_id}/": {
      "get": {
        "summary": "Retrieve",
        "description": "Returns information about a single subscription by its unique identifier.",
        "operationId": "subscriptions-retrieve",
        "parameters": [
          {
            "name": "subscription_id",
            "in": "path",
            "description": "unique subscription ID",
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
                    "value": "{\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"product\": \"0070067689\",\n    \"payment\": \"443ddf72094711e9a5afbc764e1043b0\",\n    \"shipping_address\": \"394aee16d61611e88b4abc764e1043b0\",\n    \"offer\": \"a748aa648ac811e8af3bbc764e106cf4\",\n    \"subscription_type\": \"replenishment\",\n    \"components\": [],\n    \"extra_data\": {},\n    \"public_id\": \"0ff0f88accc511e8b6c0bc764e106cf4\",\n    \"product_attribute\": null,\n    \"quantity\": 4,\n    \"price\": null,\n    \"frequency_days\": 120,\n    \"reminder_days\": 10,\n    \"every\": 4,\n    \"every_period\": 3,\n    \"start_date\": \"2018-12-27\",\n    \"cancelled\": null,\n    \"cancel_reason\": null,\n    \"cancel_reason_code\": null,\n    \"iteration\": null,\n    \"sequence\": null,\n    \"session_id\": \"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086\",\n    \"merchant_order_id\": \"2906548\",\n    \"customer_rep\": null,\n    \"club\": null,\n    \"created\": \"2018-10-10 14:45:38\",\n    \"updated\": \"2019-01-17 12:09:23\",\n    \"live\": true\n}\n"
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
                      "example": "2018-10-10 14:45:38"
                    },
                    "updated": {
                      "type": "string",
                      "example": "2019-01-17 12:09:23"
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
                    "value": "{\n \t \"detail\": \"Unable to find requested asset.\"\n}\n"
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