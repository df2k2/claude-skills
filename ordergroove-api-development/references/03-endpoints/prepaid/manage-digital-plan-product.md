# Manage Digital Plan Product

This API allows you to take an existing standard product and configure it into a valid digital plan product or to manage an existing configuration.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

<br />

## How to manage a digital plan product using this API

1. Choose an existing Standard or Plan Product, if you don’t have one yet you will need to create one before you proceed with this configuration.
2. Decide which **resource\_grants** you want to add, update or delete:
   1. resource\_grants determine how much of a given resource will be credited to a customer
   2. resources must already exist (please see: [https://developer.ordergroove.com/reference/resource-create](https://developer.ordergroove.com/reference/resource-create))
   3. currently only time\_amounts can be granted, and are configured in terms of **seconds**
   4. there must always be at least one valid resource\_grant for a digital plan product configuration
3. Hit our API with your configuration, and your digital plan product setup is complete!
   1. the product will be associated with the resource grants as defined
   2. the product will now be of type: **plan**

<br />

## Response Body Definitions

| Name | Type             | Description                                                      | Example   |
| :--- | :--------------- | :--------------------------------------------------------------- | :-------- |
|      | array of objects | Array of object that reflect the current rotation configurations | see below |

<br />

```json
[
   {
       "resource": "c84a13fc8e904e0f80e6377b15f0464a",
       "product": "53485191069987",
       "public_id": "c0de05637e6e4828b8dc60cf1dc7af6f",
       "time_amount": 2592000,
       "grace_period": 86400,
       "created": "2025-05-28 13:56:05",
       "last_updated": "2025-05-29 16:46:20"
   },
   {
       "resource": "DSHUIGsgshuigsg80e89gffgh977758",
       "product": "53485191069987",
       "public_id": "7o8gh87fsf7dh87dhd7d988006ajjklf",
       "time_amount": 2592000,
       "grace_period": null,   
       "created": "2025-05-28 13:56:05",
       "last_updated": "2025-06-09 20:12:43"
    }
]
```

> 📘 To get the all the resource grants from the digital plan product use [get product](https://developer.ordergroove.com/reference/products-retrieve) or  [list product](https://developer.ordergroove.com/reference/products-list) endpoints with `?include_product_resource_grants=true` as a query param

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
    "/products/{product_id}/resource_grants/manage/": {
      "post": {
        "summary": "Manage Digital Plan Product",
        "description": "This API allows you to take an existing standard product and configure it into a valid digital plan product or to manage an existing configuration.",
        "operationId": "manage-digital-plan-product",
        "parameters": [
          {
            "name": "product_id",
            "in": "path",
            "schema": {
              "type": "string",
              "default": "Merchant product id"
            },
            "required": true
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "create": {
                    "type": "array",
                    "description": "Add new resource grants for your digital plan product",
                    "items": {
                      "properties": {
                        "resource": {
                          "type": "string",
                          "description": "resource public_id"
                        },
                        "time_amount": {
                          "type": "integer",
                          "description": "number of seconds to be granted for said resource",
                          "default": 1,
                          "format": "int32"
                        },
                        "grace_period": {
                          "type": "integer",
                          "description": "time in seconds to grant as a grace period",
                          "format": "int32"
                        }
                      },
                      "type": "object"
                    }
                  },
                  "update": {
                    "type": "array",
                    "description": "Update existing resource grants for product",
                    "items": {
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "description": "resource grant public id to be updated"
                        },
                        "resource": {
                          "type": "string",
                          "description": "public id of resource to grant to",
                          "default": "public id of resource"
                        },
                        "time_amount": {
                          "type": "string",
                          "description": "time in seconds to grant for resource",
                          "default": "1"
                        },
                        "grace_period": {
                          "type": "integer",
                          "description": "time in seconds to grant as a grace period",
                          "format": "int32"
                        }
                      },
                      "type": "object"
                    }
                  },
                  "delete": {
                    "type": "array",
                    "description": "Delete existing resource grants with public ids to be deleted , ex: [\"85eae83c245111eeb185acde48001122\",\"b3928a0c3c4211eeac2bacde48001122\"]",
                    "items": {
                      "type": "string"
                    }
                  },
                  "identifier_time_amount": {
                    "type": "string",
                    "default": "product.every * product.every_period",
                    "description": "This is the time_amount for the identifier resource grant in seconds"
                  },
                  "identifier_grace_period": {
                    "type": "string",
                    "description": "This is the grace_period for the identifier resource grant in seconds"
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
                    "value": "{}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {}
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