# List Cancellation Reasons

Provides an overview of all recorded reasons for cancellation per application.  Authentication must be made via API User Scope.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✖️ Storefront API Scope
</Callout>

## Response Body Definitions

| Name           | Type    | Description        | Example |
| :------------- | :------ | :----------------- | :------ |
| cancel\_reason | integer | Cancel reason code | 1       |
| application    | string  | Application        | "msi"   |

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
    "/merchant/cancel_reason/": {
      "get": {
        "summary": "List Cancellation Reasons",
        "description": "Provides an overview of all recorded reasons for cancellation per application.  Authentication must be made via API User Scope.",
        "operationId": "list-cancellation-reasons",
        "parameters": [
          {
            "name": "application",
            "in": "query",
            "description": "Name of the application to filter",
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
                    "value": "{\n\t\"cancel_reason\": 12,\n  \"application\": \"msi\"\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "cancel_reason": {
                      "type": "integer",
                      "example": 12,
                      "default": 0
                    },
                    "application": {
                      "type": "string",
                      "example": "msi"
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