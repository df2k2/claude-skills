# Create

Creates a new free trial configuration for a product

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name               | Type    | Description                         | Example                            |
| :----------------- | :------ | :---------------------------------- | :--------------------------------- |
| public\_id         | string  | Free trial ID                       | "f9cb2f93e1c845eb9de9eff46ddb3cbf" |
| duration\_in\_days | integer | Number of days the free trial lasts | 15                                 |
| created            | string  | Date of free trial creation         | "2018-10-10 14:43:32"              |
| last\_updated      | string  | Date of last free trial update      | "2018-10-10 14:43:32"              |

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
    "/products/{product_id}/free_trials/create/": {
      "post": {
        "summary": "Create",
        "description": "Creates a new free trial configuration for a product",
        "operationId": "free-trials-create",
        "parameters": [
          {
            "name": "product_id",
            "in": "path",
            "description": "Merchant product ID",
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
                "required": [
                  "duration_in_days"
                ],
                "properties": {
                  "duration_in_days": {
                    "type": "integer",
                    "description": "Number of days the free trial will last",
                    "format": "int32"
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
                    "value": "{\"public_id\": \"da33bef203a34a958dbdf259837ea882\",\n \"duration_in_days\": 9,\n \"created\": \"2025-09-19 15:21:49\",\n \"last_updated\": \"2025-09-19 15:21:49\"}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "public_id": {
                      "type": "string",
                      "example": "da33bef203a34a958dbdf259837ea882"
                    },
                    "duration_in_days": {
                      "type": "integer",
                      "example": 9,
                      "default": 0
                    },
                    "created": {
                      "type": "string",
                      "example": "2025-09-19 15:21:49"
                    },
                    "last_updated": {
                      "type": "string",
                      "example": "2025-09-19 15:21:49"
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
                    "value": "{\"detail\": \"Free trial configuration already exists for this product.\"}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "detail": {
                      "type": "string",
                      "example": "Free trial configuration already exists for this product."
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
                    "value": "{\"detail\": \"Authentication Failed\"}"
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
                    "value": "{\"detail\": \"Free trial configuration already exists for this product.\"}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "detail": {
                      "type": "string",
                      "example": "Free trial configuration already exists for this product."
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