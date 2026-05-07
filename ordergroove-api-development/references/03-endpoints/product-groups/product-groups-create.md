# Create

Creates a new product group.

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
    "/product_groups/create/": {
      "post": {
        "summary": "Create",
        "description": "Creates a new product group.",
        "operationId": "product-groups-create",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "name",
                  "group_type",
                  "merchant"
                ],
                "properties": {
                  "name": {
                    "type": "string",
                    "description": "Product Group's name"
                  },
                  "group_type": {
                    "type": "string",
                    "description": "Group Type's name",
                    "enum": [
                      "eligibility",
                      "incentive",
                      "sku_swap"
                    ]
                  },
                  "merchant": {
                    "type": "string",
                    "description": "Merchant ID"
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
                    "value": "{\n  \"name\": \"summer_sale\",\n  \"group_type\": \"incentive\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "name": {
                      "type": "string",
                      "example": "summer_sale"
                    },
                    "group_type": {
                      "type": "string",
                      "example": "incentive"
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
                    "value": "{\n  \"group_type\": [\"This field is required.\"]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "group_type": {
                      "type": "array",
                      "items": {
                        "type": "string",
                        "example": "This field is required."
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