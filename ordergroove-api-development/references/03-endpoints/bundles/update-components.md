# Update Components

Atomically modify (create, update, and/or delete) components associated with a subscription

This endpoint updates all components linked to a subscription. Changing the components will impact items that will still be sent as well as new ones created in the future

## Validations

A single subscription can not have multiple components for the same product, and this endpoint will not allow you to make modifications that break this systemic rule or leaves subscription’s components in any kind of incoherent state. As a result, you will receive a 400 error and no modifications will occur if you provide a request payload that:

* Attempts to create a component for a product that is already present in the subscription’s component list.
* Attempts to update a component to a product that is also being provided to the create input in the same request.
* Attempts to remove all components from a subscription.
* Attempts to delete and update the same component in a single request.

In addition, the following validations will also be applied at the field level:

* Any provided quantity field must be an integer greater than or equal to 1.
* Any provided product input must be a product that exists in Ordergroove’s system.
* The components provided in either the update or delete input must be associated with the subscription that was specified in the url-path.

<br />

You will receive empty lists in the created, updated, or deleted response fields if you did not provide any values for the respective input field on the request payload.

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
    "/subscriptions/{subscription_public_Id}/components/bulk_operation/": {
      "post": {
        "summary": "Update Components",
        "description": "Atomically modify (create, update, and/or delete) components associated with a subscription",
        "operationId": "update-components",
        "parameters": [
          {
            "name": "subscription_public_Id",
            "in": "path",
            "description": "Unique subscription ID",
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
                    "description": "Bundle Components to create with product and its quantity",
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
                  "update": {
                    "type": "array",
                    "description": "Bundle Components to be updated with fields to change",
                    "items": {
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "description": "The id of the component to be modified"
                        },
                        "quantity": {
                          "type": "integer",
                          "description": "The new quantity to set for the component",
                          "format": "int32"
                        },
                        "product": {
                          "type": "string",
                          "description": "The new product to set for the component"
                        }
                      },
                      "required": [
                        "public_id"
                      ],
                      "type": "object"
                    }
                  },
                  "delete": {
                    "type": "array",
                    "description": "Bundle components public ids to be deleted [\"85eae83c245111eeb185acde48001122\",\"b3928a0c3c4211eeac2bacde48001122\"]",
                    "items": {
                      "type": "string"
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
                    "value": "{\n    \"created\": [{\n        \"public_id\": \"c5a95e1a3c8711eeaea2acde48001122\",\n        \"product\": \"new_product_1\",\n        \"quantity\": 2\n    },{\n        \"public_id\": \"df2b47a43c8711eeaea2acde48001122\", \n        \"product\": \"new_product_2\",\n        \"quantity\": 1\n    }],\n    \"updated\": [{\n        \"public_id\": \"b3928a0c3c4211eeac2bacde48001122\",\n        \"product\": \"existing_product_1\",\n        \"quantity\": 2\n    }],\n    \"deleted\": [{\n        \"public_id\": \"da850a7c3c4211eeac2bacde48001122\",\n        \"product\": \"existing_product_2\",\n        \"quantity\": 2\n    }]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "created": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "public_id": {
                            "type": "string",
                            "example": "c5a95e1a3c8711eeaea2acde48001122"
                          },
                          "product": {
                            "type": "string",
                            "example": "new_product_1"
                          },
                          "quantity": {
                            "type": "integer",
                            "example": 2,
                            "default": 0
                          }
                        }
                      }
                    },
                    "updated": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "public_id": {
                            "type": "string",
                            "example": "b3928a0c3c4211eeac2bacde48001122"
                          },
                          "product": {
                            "type": "string",
                            "example": "existing_product_1"
                          },
                          "quantity": {
                            "type": "integer",
                            "example": 2,
                            "default": 0
                          }
                        }
                      }
                    },
                    "deleted": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "public_id": {
                            "type": "string",
                            "example": "da850a7c3c4211eeac2bacde48001122"
                          },
                          "product": {
                            "type": "string",
                            "example": "existing_product_2"
                          },
                          "quantity": {
                            "type": "integer",
                            "example": 2,
                            "default": 0
                          }
                        }
                      }
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
          "404": {
            "description": "404",
            "content": {
              "text/plain": {
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