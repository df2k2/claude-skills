# Purchase POST Status

This endpoint can be used to check the status of a Purchase POST request.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

# OpenAPI definition

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "ordergroove-payment-api",
    "version": "2.10.0"
  },
  "servers": [
    {
      "url": "https://sc.ordergroove.com"
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
    "/subscription/{Subscription Request ID}/response": {
      "get": {
        "summary": "Purchase POST Status",
        "description": "This endpoint can be used to check the status of a Purchase POST request.",
        "operationId": "purchase-post-status",
        "parameters": [
          {
            "name": "Subscription Request ID",
            "in": "path",
            "description": "The ID returned after a Purchase POST request",
            "schema": {
              "type": "string",
              "default": "subs_req_id"
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
                    "value": "{\n  \"customer\": \"88324090493223\",\n  \"payment\": \"e7a11678911711ghjf8326d09352e44d\",\n  \"errors\": {\n  },\n  \"shipping_address\": \"e79b1ce691171fhdja8326d09352e44d\",\n  \"subscriptions\": [\n    {\n      \"41176948148744\": \"e7b0710e911711ederhs326d09352e44d\"\n    }\n  ]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "customer": {
                      "type": "string",
                      "example": "88324090493223"
                    },
                    "payment": {
                      "type": "string",
                      "example": "e7a11678911711ghjf8326d09352e44d"
                    },
                    "errors": {
                      "type": "object",
                      "properties": {}
                    },
                    "shipping_address": {
                      "type": "string",
                      "example": "e79b1ce691171fhdja8326d09352e44d"
                    },
                    "subscriptions": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "41176948148744": {
                            "type": "string",
                            "example": "e7b0710e911711ederhs326d09352e44d"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          "202": {
            "description": "202",
            "content": {
              "text/plain": {
                "examples": {
                  "Result": {
                    "value": "'Response is pending. Please try again soon.'"
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