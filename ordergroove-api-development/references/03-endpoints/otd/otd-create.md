# Create

Creates a one-time discount and attaches it to a specific item, order, or shipping rate for an individual customer.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name           | Type   | Description             | Example                          |
| :------------- | :----- | :---------------------- | :------------------------------- |
| public\_id     | string | One-Time Incentive ID   | 8637c3fe9b7011eaa2c1bc764e107990 |
| external\_code | string | External Code           | awesome\_discount                |
| description    | string | Description             | One-Time Incentive               |
| merchant       | string | Merchant ID             | ac4f7938383a11e89ecbbc764e1107f2 |
| customer       | string | Customer ID             | 00026001                         |
| order          | string | Order ID                | c4e05d04ccc411e8ada3bc764e101db1 |
| created        | string | Datetime of creation    | 2020-05-21 09:36:57              |
| last\_updated  | string | Datetime of last update | 2020-05-21 09:36:57              |
| incentive      | object | Incentive object        |                                  |

## Body Parameters

### Targeting

Use either the `order` or `item` body parameter and different `incentive.target` values based on the scope of the discount you want to provide.

#### Item-Level Discount for an Individual Item

Use `"item": <Item Public ID>` body parameter to provide the item public ID\
Use `"target": “item”` within the incentive parameter

#### Item-Level Discount for All Items in the Order

Use `"order": <Order Public ID>` body parameter to provide the order public ID\
Use `“target”: “item”` within the incentive parameter

#### Order-level discount

Use `"order": <Order Public ID>”` body parameter to provide the order public ID\
Use `“target”: “order”` within the incentive parameter

#### Shipping-Level Discount

Use `"order": <Order Public ID>”` body parameter to provide the order public ID\
Use `“target”: “shipping_total”` within the incentive parameter

**Notes for gift type incentives**: The support for gift incentives in one-time incentives are only limited to item-level scope so, be sure to use `"item": <Item Public ID>` in the body parameter and `"target": “item”`inside the incentive parameter

<br />

### Discount Limits

A "discount limit" can be specified using the `limit_value` and `limit_policy` parameters.

#### Limit Policy

The `fixed` policy indicates that the `limit_value` parameter value should be interpreted as a hard-coded dollar value limit for the discount. This limit will apply to the specified  `incentive.target`. For example, if `incentive.target=item`, then the limit will apply to each individual item - meaning the total discount applied could be greater than the limit value, but the individual discount for each item will not be greater than the limit.

#### Limit Value

The `limit_value` must be an integer, the exact meaning of the provided input will be determined based on the specified `limit_policy`.

<br />

For an explanation of the business logic, visit [Advanced One-Time Discounts](https://ordergroove.zendesk.com/hc/en-us/articles/16145919606803-Advanced-One-Time-Discounts) in Knowledge Center.

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
    "/one_time_incentives/create/": {
      "post": {
        "summary": "Create",
        "description": "Creates a one-time discount and attaches it to a specific item, order, or shipping rate for an individual customer.",
        "operationId": "otd-create",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "merchant",
                  "customer"
                ],
                "properties": {
                  "merchant": {
                    "type": "string",
                    "description": "Merchant ID"
                  },
                  "customer": {
                    "type": "string",
                    "description": "Customer ID"
                  },
                  "description": {
                    "type": "string",
                    "description": "Description"
                  },
                  "expires": {
                    "type": "string",
                    "description": "Date by which Order Must Place to Apply discount",
                    "format": "date"
                  },
                  "item": {
                    "type": "string",
                    "description": "Send Item ID to apply a One Time Incentive to a specific item. This field and `order` are mutually exclusive, but one is required."
                  },
                  "order": {
                    "type": "string",
                    "description": "Send Order ID to apply a One Time Incentive to a specific order. This field and `item` are mutually exclusive, but one is required."
                  },
                  "stacking_type": {
                    "type": "string",
                    "description": "Choose 'base' or 'additional' for a standard discount or an additive one (defaults to 'base')",
                    "default": "base"
                  },
                  "external_code": {
                    "type": "string",
                    "description": "External Code"
                  },
                  "incentive": {
                    "properties": {
                      "name": {
                        "type": "string",
                        "description": "Anything to help identify this incentive"
                      },
                      "discount_type": {
                        "type": "string",
                        "description": "Choose 'Discount Percent' for a percent off discount or 'Discount Amount' for a flat dollar off discount."
                      },
                      "value": {
                        "type": "string",
                        "description": "The value of the discount eg 5 for $5 off or 10 for 10% off"
                      },
                      "field": {
                        "type": "string",
                        "description": "If using `target: \"item\"`, field should be 'total_price'. If using `target: \"order\"`, field should be 'sub_total' or 'shipping_total'."
                      },
                      "type": {
                        "type": "string",
                        "description": "Must send 'Discount'"
                      },
                      "target": {
                        "type": "string",
                        "description": "If an Order ID (`order: <Order ID>`) was provided the `target` can be 'item' or 'order'. If an Item ID ((`item: <Item ID>`) was provided `target` must be 'item'."
                      },
                      "limit_policy": {
                        "type": "string",
                        "description": "Specifies the type of limit policy. Currently only `fixed` is supported. This policy indicates that the `limit_value` should be interpreted as a hard-coded dollar amount limit per incentive target. `limit_policy` and `limit_value` must be supplied together, or both left out."
                      },
                      "limit_value": {
                        "type": "number",
                        "description": "Used to configure the discount limit. The exact behaviour depends on the defined `limit_policy`. `limit_policy` and `limit_value` must be supplied together, or both left out."
                      }
                    },
                    "required": [
                      "name",
                      "discount_type",
                      "value",
                      "field",
                      "type",
                      "target"
                    ],
                    "type": "object",
                    "description": "Incentive Object"
                  }
                }
              },
              "examples": {
                "One Time Individual Item Discount": {
                  "value": {
                    "merchant": "ac4f7938383a11e89ecbbc764e1107f2",
                    "customer": "00026001",
                    "description": "One-Time Item Discount",
                    "expires": "2024-05-21 00:00:00",
                    "item": "a6f7305aed3511eebfaf6a353c182723",
                    "stacking_type": "additional",
                    "external_code": "one_time_item_discount",
                    "incentive": {
                      "name": "One-Time Item Discount",
                      "discount_type": "Discount Percent",
                      "value": "75.00",
                      "field": "total_price",
                      "type": "Discount",
                      "target": "item"
                    }
                  }
                },
                "One Time Order Total Discount": {
                  "value": {
                    "merchant": "ac4f7938383a11e89ecbbc764e1107f2",
                    "customer": "00026001",
                    "description": "One-Time Order Total Discount",
                    "expires": "2024-05-21 00:00:00",
                    "order": "a4f656f6ed4511eebfaf6a353c182723",
                    "stacking_type": "base",
                    "external_code": "one_time_order_total_discount",
                    "incentive": {
                      "name": "One-Time Order Total Discount",
                      "discount_type": "Discount Amount",
                      "value": "25.00",
                      "field": "sub_total",
                      "type": "Discount",
                      "target": "order"
                    }
                  }
                },
                "One Time Order Shipping Discount": {
                  "value": {
                    "merchant": "ac4f7938383a11e89ecbbc764e1107f2",
                    "customer": "00026001",
                    "description": "One-Time Order Shipping Discount",
                    "expires": "2024-05-21 00:00:00",
                    "order": "a4f656f6ed4511eebfaf6a353c182723",
                    "stacking_type": "base",
                    "external_code": "one_time_order_shipping_discount",
                    "incentive": {
                      "name": "One Time Order Shipping Discount",
                      "discount_type": "Discount Amount",
                      "value": "4.50",
                      "field": "shipping_total",
                      "type": "Discount",
                      "target": "order"
                    }
                  }
                },
                "One Time Order Total Discount (With Threshold)": {
                  "value": {
                    "merchant": "ac4f7938383a11e89ecbbc764e1107f2",
                    "customer": "00026001",
                    "description": "One-Time Order Discount With Threshold",
                    "expires": "2024-05-21 00:00:00",
                    "order": "a4f656f6ed4511eebfaf6a353c182723",
                    "stacking_type": "additional",
                    "external_code": "one_time_order_discount_with_threshold",
                    "incentive": {
                      "name": "One-Time Order Discount With Threshold",
                      "discount_type": "Discount Percent",
                      "value": "75.00",
                      "field": "sub_total",
                      "type": "Discount",
                      "target": "order",
                      "threshold_field": "sub_total",
                      "threshold_value": "20.00"
                    }
                  }
                },
                "One Time All Order Items Discount": {
                  "value": {
                    "merchant": "ac4f7938383a11e89ecbbc764e1107f2",
                    "customer": "00026001",
                    "description": "One-Time All Order Items Discount",
                    "expires": "2024-05-21 00:00:00",
                    "order": "a4f656f6ed4511eebfaf6a353c182723",
                    "stacking_type": "additional",
                    "external_code": "one_time_all_order_items_discount",
                    "incentive": {
                      "name": "One-Time All Order Items Discount",
                      "discount_type": "Discount Percent",
                      "value": "75.00",
                      "field": "total_price",
                      "type": "Discount",
                      "target": "item"
                    }
                  }
                },
                "One Time Gift": {
                  "summary": "One Time Gift",
                  "value": {
                    "merchant": "ac4f7938383a11e89ecbbc764e1107f2",
                    "customer": "00026001",
                    "description": "One-Time gift",
                    "expires": "2024-05-21 00:00:00",
                    "item": "a6f7305aed3511eebfaf6a353c182723",
                    "stacking_type": "additional",
                    "external_code": "one_time_gift_incentive",
                    "incentive": {
                      "name": "One-Time All Order Items Discount",
                      "product": "43929919127725",
                      "type": "Gift",
                      "target": "item"
                    }
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
                  "One Time Item Discount": {
                    "value": "{\n    \"public_id\": \"8637c3fe9b7011eaa2c1bc764e107990\",\n    \"external_code\": \"one_time_item_discount\",\n    \"description\": \"One-Time Item Incentive\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"customer\": \"00026001\",\n    \"item\": \"a6f7305aed3511eebfaf6a353c182723\",\n    \"created\": \"2020-05-21 09:36:57\",\n    \"last_updated\": \"2020-05-21 09:36:57\",\n    \"order\": null,\n    \"incentive\": {\n        \"type\": \"Discount\",\n        \"public_id\": \"c34a8c03eae641d0ab7015bedec6fbd0\",\n        \"discount_type\": \"Discount Percent\",\n        \"target\": \"item\",\n        \"field\": \"total_price\",\n        \"name\": \"One Time Item Discount\",\n        \"value\": \"75.00\",\n        \"threshold_field\": null,\n        \"threshold_value\": null\n    }\n}"
                  },
                  "One Time Order Total Discount": {
                    "value": "{\n    \"public_id\": \"52df97b4f0fa11eeafd33e19316267db\",\n    \"external_code\": \"one_time_order_total_discount\",\n    \"description\": \"One-Time Order Total Discount\",\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"order\": \"a4f656f6ed4511eebfaf6a353c182723\",\n    \"incentive\": {\n        \"name\": \"One Time Order Total Discount\",\n        \"public_id\": \"a8cf39af36e14bdabb1a397360883096\",\n        \"type\": \"Discount\",\n        \"field\": \"sub_total\",\n        \"discount_type\": \"Discount Amount\",\n        \"value\": \"25.00\",\n        \"threshold_field\": null,\n        \"threshold_value\": null,\n        \"target\": \"order\"\n    },\n    \"created\": \"2024-04-02 09:07:21\",\n    \"last_updated\": \"2024-04-02 09:07:21\",\n    \"expires\": \"2024-05-21 00:00:00\",\n    \"stacking_type\": \"base\",\n    \"item\": null\n}"
                  },
                  "One Time Order Shipping Discount": {
                    "value": "{\n    \"public_id\": \"0af4c838f0fc21eebef47a8c9392aaf4\",\n    \"external_code\": \"one_time_order_shipping_discount\",\n    \"description\": \"One-Time Order Shipping Discount\",\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"order\": \"a4f656f6ed4511eebfaf6a353c182723\",\n    \"incentive\": {\n        \"name\": \"One Time Order Shipping Discount\",\n        \"public_id\": \"f3b7b52a06b842ae9e47f92d168a92e1\",\n        \"type\": \"Discount\",\n        \"field\": \"shipping_total\",\n        \"discount_type\": \"Discount Amount\",\n        \"value\": \"4.50\",\n        \"threshold_field\": null,\n        \"threshold_value\": null,\n        \"target\": \"order\"\n    },\n    \"created\": \"2024-04-02 09:19:40\",\n    \"last_updated\": \"2024-04-02 09:19:40\",\n    \"expires\": \"2024-05-21 00:00:00\",\n    \"stacking_type\": \"base\",\n    \"item\": null\n}"
                  },
                  "One Time Order Total Discount (With Threshold)": {
                    "value": "{\n    \"public_id\": \"37148f0af0fd11ee951baeb47e6cdae4\",\n    \"external_code\": \"one_time_order_discount_with_threshold\",\n    \"description\": \"One-Time Order Discount With Threshold\",\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"order\": \"a4f656f6ed4511eebfaf6a353c182723\",\n    \"incentive\": {\n        \"name\": \"One-Time Order Discount With Threshold\",\n        \"public_id\": \"8047168c9ab04bfcb463ce9636464a73\",\n        \"type\": \"Discount\",\n        \"field\": \"sub_total\",\n        \"discount_type\": \"Discount Percent\",\n        \"value\": \"75.00\",\n        \"threshold_field\": \"sub_total\",\n        \"threshold_value\": \"20.00\",\n        \"target\": \"order\"\n    },\n    \"created\": \"2024-04-02 09:28:03\",\n    \"last_updated\": \"2024-04-02 09:28:03\",\n    \"expires\": \"2024-05-21 00:00:00\",\n    \"stacking_type\": \"additional\",\n    \"item\": null\n}"
                  },
                  "One Time All Order Items Discount": {
                    "value": "{\n    \"public_id\": \"e6d8feb0f10811eeb1c54af3e03516f1\",\n    \"external_code\": \"one_time_all_order_items_discount\",\n    \"description\": \"One-Time All Order Items Discount\",\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"order\": \"a4f656f6ed4511eebfaf6a353c182723\",\n    \"incentive\": {\n        \"name\": \"One-Time All Order Items Discount\",\n        \"public_id\": \"d7163fc5629b4e109b2c96d0f952393f\",\n        \"type\": \"Discount\",\n        \"field\": \"total_price\",\n        \"discount_type\": \"Discount Percent\",\n        \"value\": \"75.00\",\n        \"threshold_field\": null,\n        \"threshold_value\": null,\n        \"target\": \"item\"\n    },\n    \"created\": \"2024-04-02 10:51:43\",\n    \"last_updated\": \"2024-04-02 10:51:43\",\n    \"expires\": \"2024-05-21 00:00:00\",\n    \"stacking_type\": \"additional\",\n    \"item\": null\n}"
                  },
                  "One Time Gift": {
                    "summary": "One Time Gift",
                    "value": {
                      "public_id": "8637c3fe9b7011eaa2c1bc764e107990",
                      "external_code": "one_time_gift_incentive",
                      "description": "One-Time gift",
                      "merchant": "ac4f7938383a11e89ecbbc764e1107f2",
                      "customer": "00026001",
                      "item": "a6f7305aed3511eebfaf6a353c182723",
                      "created": "2020-05-21 09:36:57",
                      "last_updated": "2020-05-21 09:36:57",
                      "order": null,
                      "incentive": {
                        "type": "Gift",
                        "public_id": "c34a8c03eae641d0ab7015bedec6fbd0",
                        "product": "43929919127725",
                        "target": "item"
                      }
                    }
                  }
                },
                "schema": {
                  "oneOf": [
                    {
                      "title": "One Time Item Discount",
                      "type": "object",
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "example": "8637c3fe9b7011eaa2c1bc764e107990"
                        },
                        "external_code": {
                          "type": "string",
                          "example": "one_time_item_discount"
                        },
                        "description": {
                          "type": "string",
                          "example": "One-Time Item Incentive"
                        },
                        "merchant": {
                          "type": "string",
                          "example": "ac4f7938383a11e89ecbbc764e1107f2"
                        },
                        "customer": {
                          "type": "string",
                          "example": "00026001"
                        },
                        "item": {
                          "type": "string",
                          "example": "a6f7305aed3511eebfaf6a353c182723"
                        },
                        "created": {
                          "type": "string",
                          "example": "2020-05-21 09:36:57"
                        },
                        "last_updated": {
                          "type": "string",
                          "example": "2020-05-21 09:36:57"
                        },
                        "order": {},
                        "incentive": {
                          "type": "object",
                          "properties": {
                            "type": {
                              "type": "string",
                              "example": "Discount"
                            },
                            "public_id": {
                              "type": "string",
                              "example": "c34a8c03eae641d0ab7015bedec6fbd0"
                            },
                            "discount_type": {
                              "type": "string",
                              "example": "Discount Percent"
                            },
                            "target": {
                              "type": "string",
                              "example": "item"
                            },
                            "field": {
                              "type": "string",
                              "example": "total_price"
                            },
                            "name": {
                              "type": "string",
                              "example": "One Time Item Discount"
                            },
                            "value": {
                              "type": "string",
                              "example": "75.00"
                            },
                            "threshold_field": {},
                            "threshold_value": {}
                          }
                        }
                      }
                    },
                    {
                      "title": "One Time Order Total Discount",
                      "type": "object",
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "example": "52df97b4f0fa11eeafd33e19316267db"
                        },
                        "external_code": {
                          "type": "string",
                          "example": "one_time_order_total_discount"
                        },
                        "description": {
                          "type": "string",
                          "example": "One-Time Order Total Discount"
                        },
                        "customer": {
                          "type": "string",
                          "example": "00026001"
                        },
                        "merchant": {
                          "type": "string",
                          "example": "ac4f7938383a11e89ecbbc764e1107f2"
                        },
                        "order": {
                          "type": "string",
                          "example": "a4f656f6ed4511eebfaf6a353c182723"
                        },
                        "incentive": {
                          "type": "object",
                          "properties": {
                            "name": {
                              "type": "string",
                              "example": "One Time Order Total Discount"
                            },
                            "public_id": {
                              "type": "string",
                              "example": "a8cf39af36e14bdabb1a397360883096"
                            },
                            "type": {
                              "type": "string",
                              "example": "Discount"
                            },
                            "field": {
                              "type": "string",
                              "example": "sub_total"
                            },
                            "discount_type": {
                              "type": "string",
                              "example": "Discount Amount"
                            },
                            "value": {
                              "type": "string",
                              "example": "25.00"
                            },
                            "threshold_field": {},
                            "threshold_value": {},
                            "target": {
                              "type": "string",
                              "example": "order"
                            }
                          }
                        },
                        "created": {
                          "type": "string",
                          "example": "2024-04-02 09:07:21"
                        },
                        "last_updated": {
                          "type": "string",
                          "example": "2024-04-02 09:07:21"
                        },
                        "expires": {
                          "type": "string",
                          "example": "2024-05-21 00:00:00"
                        },
                        "stacking_type": {
                          "type": "string",
                          "example": "base"
                        },
                        "item": {}
                      }
                    },
                    {
                      "title": "One Time Order Shipping Discount",
                      "type": "object",
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "example": "0af4c838f0fc21eebef47a8c9392aaf4"
                        },
                        "external_code": {
                          "type": "string",
                          "example": "one_time_order_shipping_discount"
                        },
                        "description": {
                          "type": "string",
                          "example": "One-Time Order Shipping Discount"
                        },
                        "customer": {
                          "type": "string",
                          "example": "00026001"
                        },
                        "merchant": {
                          "type": "string",
                          "example": "ac4f7938383a11e89ecbbc764e1107f2"
                        },
                        "order": {
                          "type": "string",
                          "example": "a4f656f6ed4511eebfaf6a353c182723"
                        },
                        "incentive": {
                          "type": "object",
                          "properties": {
                            "name": {
                              "type": "string",
                              "example": "One Time Order Shipping Discount"
                            },
                            "public_id": {
                              "type": "string",
                              "example": "f3b7b52a06b842ae9e47f92d168a92e1"
                            },
                            "type": {
                              "type": "string",
                              "example": "Discount"
                            },
                            "field": {
                              "type": "string",
                              "example": "shipping_total"
                            },
                            "discount_type": {
                              "type": "string",
                              "example": "Discount Amount"
                            },
                            "value": {
                              "type": "string",
                              "example": "4.50"
                            },
                            "threshold_field": {},
                            "threshold_value": {},
                            "target": {
                              "type": "string",
                              "example": "order"
                            }
                          }
                        },
                        "created": {
                          "type": "string",
                          "example": "2024-04-02 09:19:40"
                        },
                        "last_updated": {
                          "type": "string",
                          "example": "2024-04-02 09:19:40"
                        },
                        "expires": {
                          "type": "string",
                          "example": "2024-05-21 00:00:00"
                        },
                        "stacking_type": {
                          "type": "string",
                          "example": "base"
                        },
                        "item": {}
                      }
                    },
                    {
                      "title": "One Time Order Total Discount (With Threshold)",
                      "type": "object",
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "example": "37148f0af0fd11ee951baeb47e6cdae4"
                        },
                        "external_code": {
                          "type": "string",
                          "example": "one_time_order_discount_with_threshold"
                        },
                        "description": {
                          "type": "string",
                          "example": "One-Time Order Discount With Threshold"
                        },
                        "customer": {
                          "type": "string",
                          "example": "00026001"
                        },
                        "merchant": {
                          "type": "string",
                          "example": "ac4f7938383a11e89ecbbc764e1107f2"
                        },
                        "order": {
                          "type": "string",
                          "example": "a4f656f6ed4511eebfaf6a353c182723"
                        },
                        "incentive": {
                          "type": "object",
                          "properties": {
                            "name": {
                              "type": "string",
                              "example": "One-Time Order Discount With Threshold"
                            },
                            "public_id": {
                              "type": "string",
                              "example": "8047168c9ab04bfcb463ce9636464a73"
                            },
                            "type": {
                              "type": "string",
                              "example": "Discount"
                            },
                            "field": {
                              "type": "string",
                              "example": "sub_total"
                            },
                            "discount_type": {
                              "type": "string",
                              "example": "Discount Percent"
                            },
                            "value": {
                              "type": "string",
                              "example": "75.00"
                            },
                            "threshold_field": {
                              "type": "string",
                              "example": "sub_total"
                            },
                            "threshold_value": {
                              "type": "string",
                              "example": "20.00"
                            },
                            "target": {
                              "type": "string",
                              "example": "order"
                            }
                          }
                        },
                        "created": {
                          "type": "string",
                          "example": "2024-04-02 09:28:03"
                        },
                        "last_updated": {
                          "type": "string",
                          "example": "2024-04-02 09:28:03"
                        },
                        "expires": {
                          "type": "string",
                          "example": "2024-05-21 00:00:00"
                        },
                        "stacking_type": {
                          "type": "string",
                          "example": "additional"
                        },
                        "item": {}
                      }
                    },
                    {
                      "title": "One Time All Order Items Discount",
                      "type": "object",
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "example": "e6d8feb0f10811eeb1c54af3e03516f1"
                        },
                        "external_code": {
                          "type": "string",
                          "example": "one_time_all_order_items_discount"
                        },
                        "description": {
                          "type": "string",
                          "example": "One-Time All Order Items Discount"
                        },
                        "customer": {
                          "type": "string",
                          "example": "00026001"
                        },
                        "merchant": {
                          "type": "string",
                          "example": "ac4f7938383a11e89ecbbc764e1107f2"
                        },
                        "order": {
                          "type": "string",
                          "example": "a4f656f6ed4511eebfaf6a353c182723"
                        },
                        "incentive": {
                          "type": "object",
                          "properties": {
                            "name": {
                              "type": "string",
                              "example": "One-Time All Order Items Discount"
                            },
                            "public_id": {
                              "type": "string",
                              "example": "d7163fc5629b4e109b2c96d0f952393f"
                            },
                            "type": {
                              "type": "string",
                              "example": "Discount"
                            },
                            "field": {
                              "type": "string",
                              "example": "total_price"
                            },
                            "discount_type": {
                              "type": "string",
                              "example": "Discount Percent"
                            },
                            "value": {
                              "type": "string",
                              "example": "75.00"
                            },
                            "threshold_field": {},
                            "threshold_value": {},
                            "target": {
                              "type": "string",
                              "example": "item"
                            }
                          }
                        },
                        "created": {
                          "type": "string",
                          "example": "2024-04-02 10:51:43"
                        },
                        "last_updated": {
                          "type": "string",
                          "example": "2024-04-02 10:51:43"
                        },
                        "expires": {
                          "type": "string",
                          "example": "2024-05-21 00:00:00"
                        },
                        "stacking_type": {
                          "type": "string",
                          "example": "additional"
                        },
                        "item": {}
                      }
                    }
                  ]
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
                    "value": "{\n  \"[field_name]\": \"field_name error detail\"\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "[field_name]": {
                      "type": "string",
                      "example": "field_name error detail"
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