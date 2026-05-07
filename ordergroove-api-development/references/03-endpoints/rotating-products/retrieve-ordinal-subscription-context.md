# Retrieve Rotating Ordinal Subscription Context

Returns the Ordinal Subscription Context for the given subscription and product. This `ordinal` represents the number of recurring orders for the given product and subscription combination - see https://developer.ordergroove.com/docs/ordinal-based-rotating-products#example for an example.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

<br />

**Response Body Definitions**

| Name              | Type    | Description                                                                                                                                                                                                                         | Example                            |
| :---------------- | :------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------- |
| ordinal           | integer | Current Ordinal position for the given product in the given subscription.                                                                                                                                                           | 3                                  |
| rotating\_product | string  | Product ID                                                                                                                                                                                                                          | "48398751432995"                   |
| subscription      | string  | Subscription ID                                                                                                                                                                                                                     | "g65765d4932511ef8dcce65j0382kc89" |
| active            | boolean | **True** if the context is for an active subscription+product pairing, **False** if it is for a previous pairing (such as may be the case if the subscription started with Product A, but was eventually sku swapped to Product B). | true                               |

<br />

**Notes**

The Product ID provided in the parameter must be a Rotating Ordinal Product associated with the Subscription, either currently or in the past. The 'active' key in the response body will indicate whether or not the product is currently subscribed to. If the Product has never been associated with the Subscription then an error will be returned.

If the Subscription is for a Bundle Product where the components are Ordinal Rotating Products, the context for each component must be retrieved individually, otherwise an error will be returned.

See [https://developer.ordergroove.com/docs/ordinal-based-rotating-products](https://developer.ordergroove.com/docs/ordinal-based-rotating-products) for more information on Ordinal Rotating Products in general.

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
    "/subscriptions/{subscription_id}/rotation_ordinal/{product_id}": {
      "get": {
        "summary": "Retrieve Rotating Ordinal Subscription Context",
        "description": "Returns the Ordinal Subscription Context for the given subscription and product. This `ordinal` represents the number of recurring orders for the given product and subscription combination - see https://developer.ordergroove.com/docs/ordinal-based-rotating-products#example for an example.",
        "operationId": "retrieve-ordinal-subscription-context",
        "parameters": [
          {
            "name": "subscription_id",
            "in": "path",
            "description": "Subscription Public ID",
            "schema": {
              "type": "string"
            },
            "required": true
          },
          {
            "name": "product_id",
            "in": "path",
            "description": "Product ID",
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
                  "Active Subscription": {
                    "value": "{\n    \"ordinal\": 3,\n    \"rotating_product\": \"active_rotating_product\",\n    \"subscription\": \"g65765d4932511ef8dcce65j0382kc89\",\n    \"active\": true\n}"
                  },
                  "Inactive Subscription + Rotating Product": {
                    "value": "{\n    \"ordinal\": 5,\n    \"rotating_product\": \"inactivie-product\",\n    \"subscription\": \"g65765d4932511ef8dcce65j0382kc89\",\n    \"active\": false\n}"
                  }
                },
                "schema": {
                  "oneOf": [
                    {
                      "title": "Active Subscription",
                      "type": "object",
                      "properties": {
                        "ordinal": {
                          "type": "integer",
                          "example": 3,
                          "default": 0
                        },
                        "rotating_product": {
                          "type": "string",
                          "example": "active_rotating_product"
                        },
                        "subscription": {
                          "type": "string",
                          "example": "g65765d4932511ef8dcce65j0382kc89"
                        },
                        "active": {
                          "type": "boolean",
                          "example": true,
                          "default": true
                        }
                      }
                    },
                    {
                      "title": "Inactive Subscription + Rotating Product",
                      "type": "object",
                      "properties": {
                        "ordinal": {
                          "type": "integer",
                          "example": 5,
                          "default": 0
                        },
                        "rotating_product": {
                          "type": "string",
                          "example": "inactivie-product"
                        },
                        "subscription": {
                          "type": "string",
                          "example": "g65765d4932511ef8dcce65j0382kc89"
                        },
                        "active": {
                          "type": "boolean",
                          "example": false,
                          "default": true
                        }
                      }
                    }
                  ]
                }
              }
            }
          },
          "400": {
            "description": "400",
            "content": {
              "application/json": {
                "examples": {
                  "Bad Request - Non-Rotating Product": {
                    "value": "{\n\t\"Product is not of rotating type\"\n}"
                  },
                  "Bad Request - Called on Bundle Product": {
                    "value": "{\n\t\"Product is a multi-item bundle, the context must be retrieved for each component\"\n}"
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
                  "Not Found - Subscription + Product Pairing Invalid": {
                    "value": "{\n\t\"No context found\"\n}"
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