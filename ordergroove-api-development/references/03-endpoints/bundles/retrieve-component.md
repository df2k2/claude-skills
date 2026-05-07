# Retrieve Component

Retrieve information about a specific component by public_id

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
    "/subscriptions/components/{component_public_id}/": {
      "get": {
        "summary": "Retrieve Component",
        "description": "Retrieve information about a specific component by public_id",
        "operationId": "retrieve-component",
        "parameters": [
          {
            "name": "component_public_id",
            "in": "path",
            "description": "Unique component ID",
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
                    "value": "{\n  \"public_id\": \"79d2dc76245111eeb185acde48001122\",\n  \"quantity\": 1,\n  \"product\": \"0070067690\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "public_id": {
                      "type": "string",
                      "example": "79d2dc76245111eeb185acde48001122"
                    },
                    "quantity": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "product": {
                      "type": "string",
                      "example": "0070067690"
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