# Group Check

Returns a boolean value in the response body to indicate if a single product belongs to a group.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name                | Type    | Description                                                   | Example |
| :------------------ | :------ | :------------------------------------------------------------ | :------ |
| product\_has\_group | boolean | Boolean response: does product belong to the specified group? | True    |

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
    "/products/{product_id}/{group_type}/{group_name}": {
      "get": {
        "summary": "Group Check",
        "description": "Returns a boolean value in the response body to indicate if a single product belongs to a group.",
        "operationId": "products-group-check",
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
            "name": "group_type",
            "in": "path",
            "description": "Group type slug",
            "schema": {
              "type": "string"
            },
            "required": true
          },
          {
            "name": "group_name",
            "in": "path",
            "description": "Group name",
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
                    "value": "{\n  \"product_has_group\": true\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "product_has_group": {
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