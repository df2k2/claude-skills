# Manage Ordinal Rotating Product

This API allows you to take an existing standard product and configure it into a valid ordinal rotating product or to manage an existing configuration.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Ordinal Selection Rule Validations

There are **3 base validation rules** for defining Ordinal Selection Rules:

1. You must define at least one selection rule with a `starting_ordinal` of 0. This represents the delivery product associated with the checkout order.
2. `starting_ordinal`s must be in the set of natural numbers, meaning they must be non-negative integers.
3. The `starting_ordinal` must be unique amongst all of the Selection Rules associated with the Rotating Product Subscription.

> ℹ️ When using `cyclical_starting_ordinal`, its value must be between 0 and the largest `starting_ordinal` from  the selection rules defined in the list. This parameter is optional and only relevant if `cyclical_rotation_enabled` is set to `true`.

If validation fails no changes will be made to the product and no Selection Rules will be created, updated or deleted.

<br />

## How to setup Ordinal Based Rotation using this API

1. Choose an existing Standard or Rotating Product, if you don’t have one yet you will need to create one before you proceed with this configuration.
2. Decide which **selection rules** you want to add, update or delete:
   1. All the rule validation explained above apply here, meaning that if you don’t follow them your update won't happen;
   2. Your changes will be reflected in all order items that haven’t had their Order Reminder sent or gone through the Send Now flow;
   3. You can add a new selection rule;
   4. You can delete an existing selection rule;
   5. You can update an existing selection rule with a different product and or starting date;
3. (Optional) If you're enabling cyclical rotation, you may also configure `cyclical_starting_ordinal`. This defines which `starting_ordinal` the rotation should restart from. It must be defined between 0 and the largest selection rule’s `starting_ordinal`.
4. Hit the API with the configuration, and the Ordinal Rotating Product setup is complete.

<br />

## Response Body Definitions

| Name | Type             | Description                                                       | Example   |
| :--- | :--------------- | :---------------------------------------------------------------- | :-------- |
|      | array of objects | Array of objects that reflect the current rotation configurations | see below |

```json
[
   {
      "public_id":"e1a61e620ed411ef8740767250df1ed7",
      "selection_rule_type":"ORDINAL",
      "product_selection_list_elements":[
         {
            "public_id":"e1a626000ed411ef8740767250df1ed7",
            "product":"48398751432995",
            "starting_ordinal":"0"
         },
         {
            "public_id":"e1a62b140ed411ef8740767250df1ed7",
            "product":"48398752317731",
            "starting_ordinal":"1"
         },
         {
            "public_id":"e1a62fe20ed411ef8740767250df1ed7",
            "product":"48398760149283",
            "starting_ordinal":"4"
         }
      ],
      "configuration": {
            "reveal_moment": "ORDER_PLACEMENT",
            "cyclical_rotation_enabled": true,
            "cyclical_starting_ordinal": 1,
            "pricing_policy": "BEST_PRICE"
        }
   }
]
```

<br />

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
    "/products/{product_id}/selection_rules/ordinal/manage/": {
      "post": {
        "summary": "Manage Ordinal Rotating Product",
        "description": "This API allows you to take an existing standard product and configure it into a valid ordinal rotating product or to manage an existing configuration.",
        "operationId": "manage-ordinal-rotating-product",
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
                          "description": "product `external_id`"
                        },
                        "starting_ordinal": {
                          "type": "integer",
                          "format": "int32"
                        }
                      },
                      "required": [
                        "product",
                        "starting_ordinal"
                      ],
                      "type": "object"
                    }
                  },
                  "update": {
                    "type": "array",
                    "description": "Update existing selection rules",
                    "items": {
                      "properties": {
                        "product": {
                          "type": "string",
                          "description": "Product `external_id`"
                        },
                        "starting_ordinal": {
                          "type": "integer",
                          "format": "int32"
                        },
                        "public_id": {
                          "type": "string",
                          "description": "`public_id` of the selection rule you are updating"
                        }
                      },
                      "required": [
                        "product",
                        "starting_ordinal",
                        "public_id"
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
                      },
                      "cyclical_rotation_enabled": {
                        "type": "boolean",
                        "description": "Loops through the rotation list. When the ordinal for the last selection element is reached, the first product on the rotation is sent again in the next order"
                      },
                      "cyclical_starting_ordinal": {
                        "type": "integer",
                        "description": "Sets the starting ordinal when cyclical_rotation_enabled is enabled and after a rotation is completed",
                        "default": 0,
                        "format": "int32"
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
                    "value": "[\n   {\n      \"public_id\":\"e1a61e620ed411ef8740767250df1ed7\",\n      \"selection_rule_type\":\"ORDINAL\",\n      \"product_selection_list_elements\":[\n         {\n            \"public_id\":\"e1a626000ed411ef8740767250df1ed7\",\n            \"product\":\"48398751432995\",\n            \"starting_ordinal\":\"0\"\n         },\n         {\n            \"public_id\":\"e1a62b140ed411ef8740767250df1ed7\",\n            \"product\":\"48398752317731\",\n            \"starting_ordinal\":\"1\"\n         },\n         {\n            \"public_id\":\"e1a62fe20ed411ef8740767250df1ed7\",\n            \"product\":\"48398760149283\",\n            \"starting_ordinal\":\"4\"\n         }\n      ],\n      \"configuration\": {\n            \"reveal_moment\": \"ORDER_PLACEMENT\",\n            \"cyclical_rotation_enabled\": false,\n            \"pricing_policy\": \"BEST_PRICE\"\n        }\n   }\n]"
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
                        "example": "ORDINAL"
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
                            "starting_ordinal": {
                              "type": "string",
                              "example": "0"
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
                          "cyclical_rotation_enabled": {
                            "type": "boolean",
                            "example": false,
                            "default": true
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