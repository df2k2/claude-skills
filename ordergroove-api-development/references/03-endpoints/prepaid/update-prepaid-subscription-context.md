# Update Prepaid Subscription

This endpoint will allow you to modify the number of orders remaining, the number of orders per billing, and the renewal behavior for a prepaid subscription at any time during the lifecycle of the prepaid subscription

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✖️ Storefront API Scope
</Callout>

## Side-effects

After the modification if the prepaid subscription is in a state where its renewal\_behavior is “cancel” and the number of orders\_remaining is 0 it will be transitioned to a canceled state where the subscription is not live anymore.

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
    "/subscriptions/{subscription_id}/update_prepaid_context/": {
      "patch": {
        "summary": "Update Prepaid Subscription",
        "description": "This endpoint will allow you to modify the number of orders remaining, the number of orders per billing, and the renewal behavior for a prepaid subscription at any time during the lifecycle of the prepaid subscription",
        "operationId": "update-prepaid-subscription-context",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "orders_per_billing": {
                    "type": "integer",
                    "description": "A number greater than 1",
                    "format": "int32"
                  },
                  "orders_remaining": {
                    "type": "integer",
                    "description": "A number greater than or equal to 0",
                    "format": "int32"
                  },
                  "renewal_behavior": {
                    "type": "string",
                    "default": "autorenew",
                    "enum": [
                      "autorenew",
                      "cancel",
                      "downgrade"
                    ]
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
                    "value": "{\n    \"customer\": \"{customer_id}\",\n    \"merchant\": \"{merchant_id\",\n    \"product\": \"{product_id}\",\n    \"payment\": \"{payment_id}\",\n    \"shipping_address\": \"{shipping_address_id}\",\n    \"offer\": \"{offer_id}\",\n    \"subscription_type\": \"replenishment\",\n    \"raw_subscription_type\": \"replenishment\",\n    \"components\": [],\n    \"extra_data\": {\n        \"shopify_contract_id\": \"gid://shopify/SubscriptionContract/{shopify_contract_id}\"\n    },\n    \"public_id\": \"{public_id}\",\n    \"quantity\": 1,\n    \"price\": null,\n    \"frequency_days\": 30,\n    \"reminder_days\": 4,\n    \"every\": 1,\n    \"every_period\": 3,\n    \"start_date\": \"2023-05-30\",\n    \"cancelled\": null,\n    \"cancel_reason\": null,\n    \"iteration\": null,\n    \"sequence\": null,\n    \"session_id\": \"{session_id}\",\n    \"merchant_order_id\": \"#1144\",\n    \"created\": \"2023-05-30 13:20:41\",\n    \"updated\": \"2023-10-03 10:22:11\",\n    \"live\": true,\n    \"external_id\": \"{external_id\",\n    \"product_attribute\": null,\n    \"cancel_reason_code\": null,\n    \"customer_rep\": null,\n    \"club\": null,\n    \"queued_actions\": [],\n    \"prepaid_subscription_context\": {\n        \"prepaid_orders_remaining\": 4,\n        \"prepaid_orders_per_billing\": 6,\n        \"renewal_behavior\": \"autorenew\"\n    }\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "customer": {
                      "type": "string",
                      "example": "{customer_id}"
                    },
                    "merchant": {
                      "type": "string",
                      "example": "{merchant_id"
                    },
                    "product": {
                      "type": "string",
                      "example": "{product_id}"
                    },
                    "payment": {
                      "type": "string",
                      "example": "{payment_id}"
                    },
                    "shipping_address": {
                      "type": "string",
                      "example": "{shipping_address_id}"
                    },
                    "offer": {
                      "type": "string",
                      "example": "{offer_id}"
                    },
                    "subscription_type": {
                      "type": "string",
                      "example": "replenishment"
                    },
                    "raw_subscription_type": {
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
                      "properties": {
                        "shopify_contract_id": {
                          "type": "string",
                          "example": "gid://shopify/SubscriptionContract/{shopify_contract_id}"
                        }
                      }
                    },
                    "public_id": {
                      "type": "string",
                      "example": "{public_id}"
                    },
                    "quantity": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "price": {},
                    "frequency_days": {
                      "type": "integer",
                      "example": 30,
                      "default": 0
                    },
                    "reminder_days": {
                      "type": "integer",
                      "example": 4,
                      "default": 0
                    },
                    "every": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "every_period": {
                      "type": "integer",
                      "example": 3,
                      "default": 0
                    },
                    "start_date": {
                      "type": "string",
                      "example": "2023-05-30"
                    },
                    "cancelled": {},
                    "cancel_reason": {},
                    "iteration": {},
                    "sequence": {},
                    "session_id": {
                      "type": "string",
                      "example": "{session_id}"
                    },
                    "merchant_order_id": {
                      "type": "string",
                      "example": "#1144"
                    },
                    "created": {
                      "type": "string",
                      "example": "2023-05-30 13:20:41"
                    },
                    "updated": {
                      "type": "string",
                      "example": "2023-10-03 10:22:11"
                    },
                    "live": {
                      "type": "boolean",
                      "example": true,
                      "default": true
                    },
                    "external_id": {
                      "type": "string",
                      "example": "{external_id"
                    },
                    "product_attribute": {},
                    "cancel_reason_code": {},
                    "customer_rep": {},
                    "club": {},
                    "queued_actions": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {}
                      }
                    },
                    "prepaid_subscription_context": {
                      "type": "object",
                      "properties": {
                        "prepaid_orders_remaining": {
                          "type": "integer",
                          "example": 4,
                          "default": 0
                        },
                        "prepaid_orders_per_billing": {
                          "type": "integer",
                          "example": 6,
                          "default": 0
                        },
                        "renewal_behavior": {
                          "type": "string",
                          "example": "autorenew"
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
                    "value": "{}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {}
                }
              }
            }
          }
        },
        "deprecated": false,
        "parameters": [
          {
            "in": "path",
            "name": "subscription_id",
            "schema": {
              "type": "string"
            },
            "required": true,
            "description": "Unique subscription ID"
          }
        ]
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