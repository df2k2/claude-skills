# Purchase POST API

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

> 📘 URL Encoded Request Body
>
> Pay attention for the fact that the request body must always be URL encoded prior to any Purchase POST Request, otherwise you may have unexpected behavior due to incorrect data deserialization on OrderGrooves end. You can read more about URL Encoding [here](https://www.w3schools.com/tags/ref_urlencode.ASP)

# OpenAPI definition

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "ordergroove-payment-api",
    "version": "2.10.0"
  },
  "servers": [
    {
      "url": "https://sc.ordergroove.com"
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
    "/subscription/create": {
      "post": {
        "summary": "Purchase POST API",
        "description": "",
        "operationId": "purchase-post-api",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "merchant_id",
                  "merchant_order_id"
                ],
                "properties": {
                  "merchant_id": {
                    "type": "string",
                    "description": "merchant public id"
                  },
                  "og_cart_tracking": {
                    "type": "boolean",
                    "description": "If omitted or true, then session_id is required. Otherwise, session_id is optional."
                  },
                  "session_id": {
                    "type": "string",
                    "description": "Session Id, gotten from og_session_id cookie."
                  },
                  "merchant_order_id": {
                    "type": "string",
                    "description": "Order ID in your system"
                  },
                  "user": {
                    "properties": {
                      "user_id": {
                        "type": "string",
                        "description": "Merchant User ID"
                      },
                      "first_name": {
                        "type": "string"
                      },
                      "last_name": {
                        "type": "string"
                      },
                      "email": {
                        "type": "string"
                      },
                      "phone_number": {
                        "type": "string"
                      },
                      "extra_data": {
                        "properties": {
                          "key1": {
                            "type": "string"
                          },
                          "key2": {
                            "type": "string"
                          }
                        },
                        "required": [],
                        "type": "object"
                      },
                      "price_code": {
                        "type": "string",
                        "description": "An optional value that can be used to apply specific discounting to all subscriptions for the customer"
                      },
                      "shipping_address": {
                        "properties": {
                          "first_name": {
                            "type": "string"
                          },
                          "last_name": {
                            "type": "string"
                          },
                          "label": {
                            "type": "string",
                            "description": "optional"
                          },
                          "company_name": {
                            "type": "string",
                            "description": "optional"
                          },
                          "address": {
                            "type": "string"
                          },
                          "address2": {
                            "type": "string",
                            "description": "optional"
                          },
                          "city": {
                            "type": "string"
                          },
                          "state_province_code": {
                            "type": "string"
                          },
                          "zip_postal_code": {
                            "type": "string"
                          },
                          "country_code": {
                            "type": "string"
                          },
                          "phone": {
                            "type": "string"
                          },
                          "fax": {
                            "type": "string",
                            "description": "optional"
                          },
                          "token_id": {
                            "type": "string",
                            "description": "External merchant reference, optional"
                          },
                          "store_id": {
                            "type": "string",
                            "description": "optional"
                          }
                        },
                        "required": [],
                        "type": "object"
                      },
                      "billing_address": {
                        "properties": {
                          "first_name": {
                            "type": "string"
                          },
                          "last_name": {
                            "type": "string"
                          },
                          "label": {
                            "type": "string",
                            "description": "optional"
                          },
                          "company_name": {
                            "type": "string",
                            "description": "optional"
                          },
                          "address": {
                            "type": "string"
                          },
                          "address2": {
                            "type": "string",
                            "description": "optional"
                          },
                          "city": {
                            "type": "string"
                          },
                          "state_province_code": {
                            "type": "string"
                          },
                          "zip_postal_code": {
                            "type": "string"
                          },
                          "country_code": {
                            "type": "string"
                          },
                          "phone": {
                            "type": "string"
                          },
                          "fax": {
                            "type": "string",
                            "description": "optional"
                          },
                          "token_id": {
                            "type": "string",
                            "description": "optional"
                          }
                        },
                        "required": [],
                        "type": "object"
                      }
                    },
                    "required": [],
                    "type": "object",
                    "description": "The customer being created; required fields can be updated by contacting support."
                  },
                  "payment": {
                    "properties": {
                      "cc_number": {
                        "type": "string",
                        "description": "Last 4 digits of CC number - XXXXXXXXXXXXXXXX1234"
                      },
                      "cc_holder": {
                        "type": "string",
                        "description": "Encrypted credit card holder"
                      },
                      "cc_exp_date": {
                        "type": "string",
                        "description": "Encrypted credit card expiration date (format: MM/YYYY)"
                      },
                      "label": {
                        "type": "string"
                      },
                      "token_id": {
                        "type": "string"
                      },
                      "cc_type": {
                        "type": "string",
                        "description": "See Card Types in #credit-card-types"
                      },
                      "payment_method": {
                        "type": "string",
                        "description": "Method of payment - \"paypal\", \"credit card\", \"applepay\", or \"googlepay\"",
                        "default": "credit card"
                      }
                    },
                    "required": [],
                    "type": "object",
                    "description": "Required fields can be configured via RC3"
                  },
                  "products": {
                    "properties": {
                      "product": {
                        "type": "string",
                        "description": "Merchant Product ID"
                      },
                      "sku": {
                        "type": "string",
                        "description": "product sku"
                      },
                      "subscription_info": {
                        "properties": {
                          "price": {
                            "type": "string",
                            "description": "Price of subscription. To be used with price lock."
                          },
                          "quantity": {
                            "type": "integer",
                            "description": "Number of items",
                            "format": "int32"
                          },
                          "first_order_place_date": {
                            "type": "string",
                            "description": "Specify the placement date for the first recurring order of the subscription (format YYYY-MM-DD)"
                          },
                          "initial_order_offset_days": {
                            "type": "string",
                            "description": "Offset the first order placement date by x days (only used if first_order_place_date not present)"
                          },
                          "multi_item_bundle_components": {
                            "type": "array",
                            "description": "Creates a New Bundle Subscription. Bundle items will be created based on provided product ID and quantity.  **The subscription product should be a bundle product_type while the products in the array needs to be standard products**",
                            "items": {
                              "properties": {
                                "product": {
                                  "type": "string",
                                  "description": "The id of the product that is being added to the bundle"
                                },
                                "quantity": {
                                  "type": "integer",
                                  "description": "The quantity of the product being added",
                                  "default": 1,
                                  "format": "int32"
                                }
                              },
                              "required": [
                                "product",
                                "quantity"
                              ],
                              "type": "object"
                            }
                          },
                          "components": {
                            "type": "array",
                            "description": "Creates Legacy Bundles subscription. Strings in this array are product IDs associated with the parent subscription product.",
                            "items": {
                              "type": "string"
                            }
                          },
                          "tracking_override": {
                            "properties": {
                              "product": {
                                "type": "string",
                                "description": "Merchant Product ID for which to create the subscription - overrides product that was purchased"
                              },
                              "every": {
                                "type": "integer",
                                "description": "Frequency value - overrides tracked values (eg the 30 in 30 Days)",
                                "format": "int32"
                              },
                              "every_period": {
                                "type": "integer",
                                "description": "Frequency period type - overrides the tracked value: 1 = days, 2 = weeks, 3 = months, 4 = monthly",
                                "format": "int32"
                              },
                              "offer": {
                                "type": "string",
                                "description": "Incentive Offer ID to which the subscription will be associated with - overrides any tracked value."
                              }
                            },
                            "required": [],
                            "type": "object"
                          },
                          "subscription_type": {
                            "type": "string",
                            "description": "Can be set to 'prepaid' if you are creating a prepaid subscription. Merchant needs to be prepaid enabled to create be able to create it",
                            "enum": [
                              "prepaid"
                            ]
                          },
                          "prepaid_orders_per_billing": {
                            "type": "integer",
                            "description": "An integer greater than 2. This is the amount of orders that were paid for. It will only be used if subscription_type = 'prepaid'",
                            "format": "int32"
                          },
                          "renewal_behavior": {
                            "type": "string",
                            "description": "Custom renewal behavior you want when checking out with a prepaid item. When the prepaid cycle for this subscription ends, this behavior will be followed",
                            "enum": [
                              "autorenew",
                              "cancel",
                              "downgrade"
                            ]
                          },
                          "rotation_ordinal": {
                            "type": "integer",
                            "description": "An integer value greater than or equal to 0 used to determine the current progress of the rotating ordinal subscription.",
                            "format": "int32"
                          }
                        },
                        "required": [],
                        "type": "object"
                      },
                      "purchase_info": {
                        "properties": {
                          "quantity": {
                            "type": "integer",
                            "description": "Number of items the customer checkedout with in the first order",
                            "format": "int32"
                          },
                          "price": {
                            "type": "string",
                            "description": "Price per unit for the first order (without discounts)"
                          },
                          "discounted_price": {
                            "type": "string",
                            "description": "Price after discount in the first order"
                          },
                          "total": {
                            "type": "string",
                            "description": "Total discounted price for the product in the first checkout order"
                          },
                          "grantees": {
                            "type": "array",
                            "items": {
                              "properties": {
                                "grantee": {
                                  "type": "object",
                                  "properties": {
                                    "name": {
                                      "type": "string",
                                      "description": "Name of grantee"
                                    },
                                    "external_id": {
                                      "type": "string",
                                      "description": "External ID of grantee"
                                    }
                                  },
                                  "required": [
                                    "name",
                                    "external_id"
                                  ],
                                  "description": "Grantee object to be associated with subscription"
                                }
                              },
                              "type": "object"
                            },
                            "description": "Array of grantees, no duplicates allowed."
                          }
                        },
                        "required": [],
                        "type": "object"
                      }
                    },
                    "required": [],
                    "type": "object",
                    "description": "The products that this customer bought or subscribed to"
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
                    "value": "{\n\"result\": \"Subscription request received\",\n\"subs_req_id\":\"34900fjkc34i2kdcs\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "result": {
                      "type": "string",
                      "example": "Subscription request received"
                    },
                    "subs_req_id": {
                      "type": "string",
                      "example": "34900fjkc34i2kdcs"
                    }
                  }
                }
              }
            }
          },
          "206": {
            "description": "206",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"customer\": \"aab98a89as0989\",\n  \"payment\": \"f67a4sd564654s\",\n  \"subscriptions\": [{\n    \"some_product_id\": \"68b78786s78d6f\",\n  }],\n  \"errors\": {\n    \"products\": [{\n      \"sku is a required\"\n    }],\n    \"subscriptions\": [{\n      \"product\": \"faux-product\",\n      \"subscription\": {\n        \"product\": [\"Object with external_product_id=faux-product does not exist.\"],\n        \"quantity\": [\"This field is required.\"]\n      }\n    }\n  ]\n}"
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
                    "value": "{\n  \"session_id\": \"Session id cannot be null\",\n  \"start_date\": \"Start date must be in format mm/dd/yyyy\",\n  \"user_id\": \"User ID is a required field.\",\n  \"merchant_order_id\": \"Merchant order id is a required field.\",\n  \"customer\": {\n    \"[field_name]\": \"field_name error detail\"\n  },\n  \"shipping_address\": {\n    \"[field_name]\": \"field_name error detail\"\n  },\n  \"payment\": {\n    \"[field_name]\": \"field_name error detail\"\n  },\n  \"products\": [\n    {\n      \"sku\": \"sku is required\",\n      \"purchase_info\": {\n        \"[field_name]\": \"field_name error detail\"\n      }\n    }\n  ],\n  \"subscriptions\": [\n    {\n      \"subscription\": {\n        \"[field_name]\": \"field_name error detail\"\n      }\n    }\n  ]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "session_id": {
                      "type": "string",
                      "example": "Session id cannot be null"
                    },
                    "start_date": {
                      "type": "string",
                      "example": "Start date must be in format mm/dd/yyyy"
                    },
                    "user_id": {
                      "type": "string",
                      "example": "User ID is a required field."
                    },
                    "merchant_order_id": {
                      "type": "string",
                      "example": "Merchant order id is a required field."
                    },
                    "customer": {
                      "type": "object",
                      "properties": {
                        "[field_name]": {
                          "type": "string",
                          "example": "field_name error detail"
                        }
                      }
                    },
                    "shipping_address": {
                      "type": "object",
                      "properties": {
                        "[field_name]": {
                          "type": "string",
                          "example": "field_name error detail"
                        }
                      }
                    },
                    "payment": {
                      "type": "object",
                      "properties": {
                        "[field_name]": {
                          "type": "string",
                          "example": "field_name error detail"
                        }
                      }
                    },
                    "products": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "sku": {
                            "type": "string",
                            "example": "sku is required"
                          },
                          "purchase_info": {
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
                    },
                    "subscriptions": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "subscription": {
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
                  }
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
                    "value": "{\n  \"detail\": \"Authentication Failed\"\n}"
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