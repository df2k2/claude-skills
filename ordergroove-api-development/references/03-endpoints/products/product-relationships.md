# Relationships

Returns a list of the relationships the specified product is part of

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name               | Type   | Description       | Example            |
| :----------------- | :----- | :---------------- | :----------------- |
| relationship\_type | string | Relationship Type | swap\_on\_purchase |
| from\_product      | string | From Product Id   | 62900-W01          |
| to\_product        | string | To Product Id     | 78530-X05          |

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
    "/products/{product_id}/relationships/": {
      "get": {
        "summary": "Relationships",
        "description": "Returns a list of the relationships the specified product is part of",
        "operationId": "product-relationships",
        "parameters": [
          {
            "name": "product_id",
            "in": "path",
            "description": "Product ID",
            "schema": {
              "type": "string"
            },
            "required": true
          },
          {
            "name": "type",
            "in": "query",
            "description": "Relationship type",
            "schema": {
              "type": "string"
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
                    "value": "[\n    {\n        \"relationship_type\": \"swap_on_purchase\",\n        \"from_product\": \"62900-W01\",\n        \"to_product\": \"78530-X05\"\n    }\n]\n"
                  }
                },
                "schema": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "relationship_type": {
                        "type": "string",
                        "example": "swap_on_purchase"
                      },
                      "from_product": {
                        "type": "string",
                        "example": "62900-W01"
                      },
                      "to_product": {
                        "type": "string",
                        "example": "78530-X05"
                      }
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