# Manage Time-Window Rotating Product

This API allows you to take an existing standard product and configure it into a valid time-window rotating product or to manage an existing configuration.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Time-Window selection rule validations

There are **4 validation rules** for defining Time-Window selection rules:

1. You must define at least one selection rule (we wouldn’t have anything to choose otherwise)
2. One of the selection rules must have a starting date in the past (so that we don’t ever have an invalid state where we don’t know which product should be delivered)
3. No two selection rules can have the same starting date (otherwise we wouldn’t know which product to choose between them, but you can have multiple selection rules with the same product)
4. All starting dates must be in ISO8601 format with timezone. The timezone will be stored in UTC.

If validation fails no changes will be made to the product and no selection rules will be created, updated or deleted.

<br />

## How to manage a Time-Window based Rotation using this API

1. Choose an existing Standard or Rotating Product, if you don’t have one yet you will need to create one before you proceed with this configuration.
2. Decide which **selection rules** you want to add, update or delete:
   1. All the rule validation explained above apply here, meaning that if you don’t follow them your update won't happen;
   2. Your changes will be reflected in all order items that haven’t had their Order Reminder sent or gone through the Send Now flow;
   3. You can add a new selection rule;
   4. You can delete an existing selection rule;
   5. You can update an existing selection rule with a different product and or starting date;
3. Hit our API with your configuration, and your Time-Window based Rotating Product setup is complete!

<br />

## Response Body Definitions

| Name | Type             | Description                                                      | Example   |
| :--- | :--------------- | :--------------------------------------------------------------- | :-------- |
|      | array of objects | Array of object that reflect the current rotation configurations | see below |

<br />

```json
[
   {
      "public_id":"e1a61e620ed411ef8740767250df1ed7",
      "selection_rule_type":"TIME_WINDOW",
      "product_selection_list_elements":[
         {
            "public_id":"e1a626000ed411ef8740767250df1ed7",
            "product":"48398751432995",
            "starting_date":"2024-05-01T00:00:00Z"
         },
         {
            "public_id":"e1a62b140ed411ef8740767250df1ed7",
            "product":"48398752317731",
            "starting_date":"2024-06-01T00:00:00Z"
         },
         {
            "public_id":"e1a62fe20ed411ef8740767250df1ed7",
            "product":"48398760149283",
            "starting_date":"2024-07-01T00:00:00Z"
         }
      ],
      "configuration": {
            "reveal_moment": "ORDER_PLACEMENT",
            "pricing_policy": "BEST_PRICE"
        }
   }
]
```

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
    "/products/{product_id}/selection_rules/time_window/manage/": {
      "post": {
        "summary": "Manage Time-Window Rotating Product",
        "description": "This API allows you to take an existing standard product and configure it into a valid time-window rotating product or to manage an existing configuration.",
        "operationId": "manage-time-window-rotating-product",
        "parameters": [
          {
            "name": "product_id",
            "in": "path",
            "description": "Merchant product ID",
            "schema": {
              "type": "string"
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
                    "description": "Add new selection rules for your rotation",
                    "items": {
                      "properties": {
                        "product": {
                          "type": "string",
                          "description": "product external id"
                        },
                        "starting_date": {
                          "type": "string",
                          "description": "ISO8601 format, Timezone required",
                          "format": "date"
                        }
                      },
                      "type": "object"
                    }
                  },
                  "update": {
                    "type": "array",
                    "description": "Update existing selection rules",
                    "items": {
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "description": "public_id of the selection rule you are updating"
                        },
                        "product": {
                          "type": "string",
                          "description": "Product `external_id`",
                          "default": "optional"
                        },
                        "starting_date": {
                          "type": "string",
                          "description": "ISO8601 format, timezone required",
                          "default": "optional",
                          "format": "date"
                        }
                      },
                      "required": [
                        "public_id",
                        "product",
                        "starting_date"
                      ],
                      "type": "object"
                    }
                  },
                  "delete": {
                    "type": "array",
                    "description": "Delete existing selection rules with public ids to be deleted , ex: [\"85eae83c245111eeb185acde48001122\",\"b3928a0c3c4211eeac2bacde48001122\"]",
                    "items": {
                      "type": "string"
                    }
                  },
                  "configuration": {
                    "type": "object",
                    "description": "Configures the rotation product",
                    "properties": {
                      "reveal_moment": {
                        "type": "string",
                        "description": "Configures when the delivery product is revealed",
                        "default": "ORDER_REMINDER",
                        "enum": [
                          "ITEM_CREATE",
                          "ORDER_REMINDER",
                          "ORDER_PLACEMENT"
                        ]
                      },
                      "pricing_policy": {
                        "type": "string",
                        "description": "Configures how the price of the rotating subscription should be applied",
                        "default": "BEST_PRICE",
                        "enum": [
                          "ROTATING_PARENT_PRODUCT_PRICE",
                          "DELIVERY_PRODUCT_PRICE",
                          "BEST_PRICE"
                        ]
                      }
                    }
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
                    "value": "[\n   {\n      \"public_id\":\"e1a61e620ed411ef8740767250df1ed7\",\n      \"selection_rule_type\":\"TIME_WINDOW\",\n      \"product_selection_list_elements\":[\n         {\n            \"public_id\":\"e1a626000ed411ef8740767250df1ed7\",\n            \"product\":\"48398751432995\",\n            \"starting_date\":\"2024-05-01T00:00:00Z\"\n         },\n         {\n            \"public_id\":\"e1a62b140ed411ef8740767250df1ed7\",\n            \"product\":\"48398752317731\",\n            \"starting_date\":\"2024-06-01T00:00:00Z\"\n         },\n         {\n            \"public_id\":\"e1a62fe20ed411ef8740767250df1ed7\",\n            \"product\":\"48398760149283\",\n            \"starting_date\":\"2024-07-01T00:00:00Z\"\n         }\n      ],\n      \"configuration\": {\n            \"reveal_moment\": \"ORDER_PLACEMENT\",\n            \"pricing_policy\": \"BEST_PRICE\"\n        }\n   }\n]"
                  }
                },
                "schema": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "public_id": {
                        "type": "string",
                        "example": "e1a61e620ed411ef8740767250df1ed7"
                      },
                      "selection_rule_type": {
                        "type": "string",
                        "example": "TIME_WINDOW"
                      },
                      "product_selection_list_elements": {
                        "type": "array",
                        "items": {
                          "type": "object",
                          "properties": {
                            "public_id": {
                              "type": "string",
                              "example": "e1a626000ed411ef8740767250df1ed7"
                            },
                            "product": {
                              "type": "string",
                              "example": "48398751432995"
                            },
                            "starting_date": {
                              "type": "string",
                              "example": "2024-05-01T00:00:00Z"
                            }
                          }
                        }
                      },
                      "configuration": {
                        "type": "object",
                        "properties": {
                          "reveal_moment": {
                            "type": "string",
                            "example": "ORDER_PLACEMENT"
                          },
                          "pricing_policy": {
                            "type": "string",
                            "example": "BEST_PRICE"
                          }
                        }
                      }
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