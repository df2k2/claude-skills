# List

Returns a list of all merchant's product groups.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✖️ Storefront API Scope
</Callout>

## Response Body Definitions

| Name        | Type   | Description          | Example        |
| :---------- | :----- | :------------------- | :------------- |
| name        | string | Product Group's name | "summer\_sale" |
| group\_type | string | Group Type's name    | "incentive"    |

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
    "/product_groups/": {
      "get": {
        "summary": "List",
        "description": "Returns a list of all merchant's product groups.",
        "operationId": "product-groups-list",
        "parameters": [
          {
            "name": "name",
            "in": "query",
            "description": "Product Group's name",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "group_type",
            "in": "query",
            "description": "Group Type's name",
            "schema": {
              "type": "string",
              "enum": [
                "eligibility",
                "incentive",
                "sku_swap"
              ]
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
                    "value": "{\n    \"count\": 2,\n    \"next\": \"https://restapi.ordergroove.com/product_groups/?page=2\",\n    \"previous\": null,\n    \"results\": [\n      {\n        \"name\": \"subscription\",\n        \"group_type\": \"eligibility\"\n      },\n      {\n        \"name\": \"summer_sale\",\n        \"group_type\": \"incentive\"\n      },\n    ]\n}"
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