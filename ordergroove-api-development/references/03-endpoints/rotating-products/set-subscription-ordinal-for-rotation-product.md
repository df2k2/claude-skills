# Set Subscription Ordinal for Rotating Product

Control where the customer's rotating subscription is on the rotation cycle

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

**The rotation product is required**. This is because we support sku swapping from one rotation product to another in the subscription. When swapping to another rotation product that has no past orders, the ordinal is kept on the old rotation product. The new rotation product will start at the initial delivery product from that rotation (ordinal=0)

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
    "/subscriptions/{subscription_id}/rotation_ordinal/update/": {
      "patch": {
        "summary": "Set Subscription Ordinal for Rotating Product",
        "description": "Control where the customer's rotating subscription is on the rotation cycle",
        "operationId": "set-subscription-ordinal-for-rotation-product",
        "parameters": [
          {
            "name": "subscription_id",
            "in": "path",
            "description": "Subscription Public ID",
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
                  "rotating_product"
                ],
                "properties": {
                  "rotating_product": {
                    "type": "string",
                    "description": "External Product ID"
                  },
                  "ordinal": {
                    "type": "integer",
                    "description": "Positive integer that tracks where the subscription is on the rotating subscription cycle",
                    "format": "int32"
                  }
                }
              },
              "examples": {
                "Request Example": {
                  "value": {
                    "rotating_product": "48398725906723",
                    "ordinal": 3
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
                    "value": "{\n    \"ordinal\": 3,\n    \"rotation_product\": \"48398725906723\",\n    \"subscription\": \"f3d45e96871a11efaaddce3115cc9708\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "ordinal": {
                      "type": "integer",
                      "example": 3,
                      "default": 0
                    },
                    "rotation_product": {
                      "type": "string",
                      "example": "48398725906723"
                    },
                    "subscription": {
                      "type": "string",
                      "example": "f3d45e96871a11efaaddce3115cc9708"
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
                  "Subscription not found": {
                    "value": "\"Subscription not found\""
                  },
                  "Product not found": {
                    "value": "\"Product not found\""
                  }
                },
                "schema": {
                  "oneOf": [
                    {
                      "title": "Subscription not found",
                      "type": "string",
                      "example": "Subscription not found"
                    },
                    {
                      "title": "Product not found",
                      "type": "string",
                      "example": "Product not found"
                    }
                  ]
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