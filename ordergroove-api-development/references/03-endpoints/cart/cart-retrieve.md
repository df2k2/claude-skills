# Retrieve

Returns all items in a user's cart, based on the user's session ID.

<Callout icon="🔐" theme="default">
  ### Authentication

  No authentication required for this endpoint.
</Callout>

## Response Body Definitions

| Name          | Type    | Description                   | Example                            |
| :------------ | :------ | :---------------------------- | :--------------------------------- |
| id            | string  | Merchant product ID           | "62900-W01"                        |
| offer\_id     | string  | Offer ID                      | "4a10a0e1738f46bf9d81be56ea6d8d85" |
| incentives    | object  | Incentives object             |                                    |
| attributes    | string  | Additional product attributes |                                    |
| coupon\_code  | string  | Coupon Code reference ID      |                                    |
| quantity      | integer | Number of items               | 2                                  |
| every         | integer | Number of periods             | 30                                 |
| every\_period | integer | Type of period                | 1                                  |

# OpenAPI definition

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "ordergroove-cart-management-api",
    "version": "2.10.0"
  },
  "servers": [
    {
      "url": "https://om.ordergroove.com"
    }
  ],
  "security": [
    {}
  ],
  "paths": {
    "/carts/{session_id}/": {
      "get": {
        "summary": "Retrieve",
        "description": "Returns all items in a user's cart, based on the user's session ID.",
        "operationId": "cart-retrieve",
        "parameters": [
          {
            "name": "session_id",
            "in": "path",
            "description": "Unique Session ID",
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
                    "value": "{\n  \"id\": \"62900-W01\",\n  \"offer_id\": \"4a10a0e1738f46bf9d81be56ea6d8d85\",\n  \"incentives\": {\n    \"initial\": [\n      \"83247a4134ac41f7adef1c0e0151e225\",\n      \"eedfcfbee1e34516978489f24ca5e187\"\n    ],\n    \"ongoing\": [\n      \"eedfcfbee1e34516978489f24ca5e187\"\n    ]\n  },\n  \"attributes\": null,\n  \"coupon_code\": null,\n  \"quantity\": 2,\n  \"every\": 30,\n  \"every_period\": 1\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "string",
                      "example": "62900-W01"
                    },
                    "offer_id": {
                      "type": "string",
                      "example": "4a10a0e1738f46bf9d81be56ea6d8d85"
                    },
                    "incentives": {
                      "type": "object",
                      "properties": {
                        "initial": {
                          "type": "array",
                          "items": {
                            "type": "string",
                            "example": "83247a4134ac41f7adef1c0e0151e225"
                          }
                        },
                        "ongoing": {
                          "type": "array",
                          "items": {
                            "type": "string",
                            "example": "eedfcfbee1e34516978489f24ca5e187"
                          }
                        }
                      }
                    },
                    "attributes": {},
                    "coupon_code": {},
                    "quantity": {
                      "type": "integer",
                      "example": 2,
                      "default": 0
                    },
                    "every": {
                      "type": "integer",
                      "example": 30,
                      "default": 0
                    },
                    "every_period": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
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
                    "value": "{\n  \"detail\": \"Unable to find requested asset.\"\n}"
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