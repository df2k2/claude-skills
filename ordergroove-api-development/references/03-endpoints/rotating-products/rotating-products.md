# Retrieve Rotating Delivery Product

Returns what product will be revealed at a given order placement date or a given ordinal integer in the series

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

This endpoint will by default return the first product in the rotation at that time. This is usually the product the customer will be checking out with to generate the rotating subscription.

Default for each rotating rule type:

* **Time-Window**: The default date will be the current date at request time
* **Ordinal**: The default ordinal will be 0, always the first product in the list

> 📘 To get the all the rules from the rotating product use [get product](https://developer.ordergroove.com/reference/products-retrieve) or  [list product](https://developer.ordergroove.com/reference/products-list) endpoints with `?include_product_selection_rules=true` as a query param

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
    "/products/{product_id}/rotating_delivery_product/": {
      "get": {
        "summary": "Retrieve Rotating Delivery Product",
        "description": "Returns what product will be revealed at a given order placement date or a given ordinal integer in the series",
        "operationId": "rotating-products",
        "parameters": [
          {
            "name": "product_id",
            "in": "path",
            "description": "Merchant product ID",
            "schema": {
              "type": "string"
            },
            "required": true
          },
          {
            "name": "date",
            "in": "query",
            "description": "Date of order placement (ISO8601 format, Timezone required)",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "ordinal",
            "in": "query",
            "description": "Delivery \"position\" for the product in the ordinal planned sequence",
            "schema": {
              "type": "integer",
              "format": "int32"
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
                    "value": "{\n    \"merchant\": \"{merchant_id}\",\n    \"groups\": [\n        {\n            \"name\": \"subscription\",\n            \"group_type\": \"eligibility\"\n        }\n    ],\n    \"name\": \"Medium Roast Coffee Bag\",\n    \"price\": \"10.00\",\n    \"image_url\": \"(image_url}\",\n    \"detail_url\": \"(detail_url}\",\n    \"external_product_id\": \"48398751432995\",\n    \"sku\": \"48398751432995\",\n    \"autoship_enabled\": true,\n    \"premier_enabled\": 0,\n    \"created\": \"2024-05-09 15:20:09\",\n    \"last_update\": \"2024-05-13 08:56:36\",\n    \"live\": true,\n    \"discontinued\": false,\n    \"extra_data\": null,\n    \"product_type\": \"standard\",\n    \"autoship_by_default\": true,\n    \"every\": null,\n    \"every_period\": null,\n    \"offer_profile\": null,\n    \"incentive_group\": null\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "merchant": {
                      "type": "string",
                      "example": "{merchant_id}"
                    },
                    "groups": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "name": {
                            "type": "string",
                            "example": "subscription"
                          },
                          "group_type": {
                            "type": "string",
                            "example": "eligibility"
                          }
                        }
                      }
                    },
                    "name": {
                      "type": "string",
                      "example": "Medium Roast Coffee Bag"
                    },
                    "price": {
                      "type": "string",
                      "example": "10.00"
                    },
                    "image_url": {
                      "type": "string",
                      "example": "(image_url}"
                    },
                    "detail_url": {
                      "type": "string",
                      "example": "(detail_url}"
                    },
                    "external_product_id": {
                      "type": "string",
                      "example": "48398751432995"
                    },
                    "sku": {
                      "type": "string",
                      "example": "48398751432995"
                    },
                    "autoship_enabled": {
                      "type": "boolean",
                      "example": true,
                      "default": true
                    },
                    "premier_enabled": {
                      "type": "integer",
                      "example": 0,
                      "default": 0
                    },
                    "created": {
                      "type": "string",
                      "example": "2024-05-09 15:20:09"
                    },
                    "last_update": {
                      "type": "string",
                      "example": "2024-05-13 08:56:36"
                    },
                    "live": {
                      "type": "boolean",
                      "example": true,
                      "default": true
                    },
                    "discontinued": {
                      "type": "boolean",
                      "example": false,
                      "default": true
                    },
                    "extra_data": {},
                    "product_type": {
                      "type": "string",
                      "example": "standard"
                    },
                    "autoship_by_default": {
                      "type": "boolean",
                      "example": true,
                      "default": true
                    },
                    "every": {},
                    "every_period": {},
                    "offer_profile": {},
                    "incentive_group": {}
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
                  "Rotating product": {
                    "value": "{ \n \"detail\": \"Product needs to be of rotating type\"\n}"
                  },
                  "Invalid Ordinal": {
                    "value": "{ \n \"detail\": \"Ordinal must be a valid integer greater or equal to zero\"\n}"
                  },
                  "Invalid Date": {
                    "value": "{ \n \"detail\": \"Invalid date, it must have the following format yyyy-MM-ddTHH:mm:ssZ\"\n}"
                  },
                  "No timezone offset": {
                    "value": "{ \n \"detail\": \"No timezone offset provided for date\"\n}"
                  }
                },
                "schema": {
                  "oneOf": [
                    {
                      "title": "Rotating product",
                      "type": "object",
                      "properties": {
                        "detail": {
                          "type": "string",
                          "example": "Product needs to be of rotating type"
                        }
                      }
                    },
                    {
                      "title": "Invalid Ordinal",
                      "type": "object",
                      "properties": {
                        "detail": {
                          "type": "string",
                          "example": "Ordinal must be a valid integer greater or equal to zero"
                        }
                      }
                    },
                    {
                      "title": "Invalid Date",
                      "type": "object",
                      "properties": {
                        "detail": {
                          "type": "string",
                          "example": "Invalid date, it must have the following format yyyy-MM-ddTHH:mm:ssZ"
                        }
                      }
                    },
                    {
                      "title": "No timezone offset",
                      "type": "object",
                      "properties": {
                        "detail": {
                          "type": "string",
                          "example": "No timezone offset provided for date"
                        }
                      }
                    }
                  ]
                }
              }
            }
          },
          "403": {
            "description": "403",
            "content": {
              "text/plain": {
                "examples": {
                  "Result": {
                    "value": ""
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
                    "value": ""
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