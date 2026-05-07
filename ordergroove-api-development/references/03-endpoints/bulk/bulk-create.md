# Bulk Create

Creates multiple products

## Response Body

```json
{
  "results": [
    {
      "product_id": "169869470520111636",
      "status": 200
    },
    {
      "product_id": "169869470520111637",
      "status": 400
    } 
  ]
}
```

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Name
      </th>

      <th>
        Type
      </th>

      <th>
        Description
      </th>

      <th>
        Example
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        product\_id
      </td>

      <td>
        string
      </td>

      <td>
        Product ID
      </td>

      <td>
        "0070000693"
      </td>
    </tr>

    <tr>
      <td>
        status
      </td>

      <td>
        int
      </td>

      <td>
        Status of the product create.\
        200 for success, 400 for error
      </td>

      <td>
        200
      </td>
    </tr>
  </tbody>
</Table>

## Throttle Rates

Requests are throttled at 600req/min.

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
    "/products-batch/create/": {
      "post": {
        "summary": "Bulk Create",
        "description": "Creates multiple products",
        "operationId": "bulk-create",
        "parameters": [
          {
            "name": "force_all_fields",
            "in": "query",
            "description": "Ignore manual product configuration rules",
            "schema": {
              "type": "string",
              "default": "false"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "RAW_BODY": {
                    "type": "array",
                    "description": "List of products (max 100)",
                    "items": {
                      "properties": {
                        "product_id": {
                          "type": "string",
                          "description": "Product ID (must be unique)"
                        },
                        "name": {
                          "type": "string",
                          "description": "Product Name"
                        },
                        "sku": {
                          "type": "string",
                          "description": "Product SKU"
                        },
                        "price": {
                          "type": "number",
                          "description": "Product price",
                          "format": "double"
                        },
                        "live": {
                          "type": "boolean",
                          "description": "Product liveliness",
                          "default": true
                        },
                        "image_url": {
                          "type": "string",
                          "description": "Product image url",
                          "default": "null"
                        },
                        "detail_url": {
                          "type": "string",
                          "description": "Product details url",
                          "default": "null"
                        },
                        "autoship_enabled": {
                          "type": "boolean",
                          "description": "Product autoship eligibility",
                          "default": false
                        },
                        "prepaid_eligible": {
                          "type": "boolean",
                          "description": "Product prepaid eligibility",
                          "default": false
                        },
                        "discontinued": {
                          "type": "boolean",
                          "description": "Product discontinued status",
                          "default": false
                        },
                        "autoship_by_default": {
                          "type": "boolean",
                          "description": "Product default autoship",
                          "default": false
                        },
                        "product_type": {
                          "type": "string",
                          "description": "Product type: \"standard\", \"bundle\", \"club\", \"dynamic price bundle\", \"static price bundle\"",
                          "default": "standard",
                          "enum": [
                            "standard",
                            "bundle",
                            "club",
                            "dynamic price bundle",
                            "static price bundle"
                          ]
                        },
                        "every": {
                          "type": "integer",
                          "description": "Number of periods",
                          "default": null,
                          "format": "int32"
                        },
                        "every_period": {
                          "type": "integer",
                          "description": "Type of periods",
                          "default": null,
                          "format": "int32"
                        },
                        "premier_enabled": {
                          "type": "integer",
                          "description": "Product premier: 0 for Disabled, 1 for Enabled, 2 for Tier",
                          "default": null,
                          "format": "int32"
                        },
                        "extra_data": {
                          "type": "string",
                          "description": "Raw JSON string that should be JSON.parse() as key/value store for any extra information.",
                          "default": ""
                        },
                        "groups": {
                          "type": "array",
                          "description": "Product Groups to be associated with the Product (notice that this list of groups will replace the current list of groups that are associated with the product)",
                          "items": {
                            "properties": {
                              "name": {
                                "type": "string",
                                "description": "Product group's name"
                              },
                              "group_type": {
                                "type": "string",
                                "description": "Product group's type"
                              }
                            },
                            "type": "object"
                          }
                        }
                      },
                      "required": [
                        "product_id"
                      ],
                      "type": "object"
                    }
                  }
                }
              }
            }
          }
        },
        "responses": {
          "207": {
            "description": "207",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"results\": [\n    {\n      \"product_id\": \"169869470520111636\",\n      \"status\": 200\n    },\n    {\n      \"product_id\": \"169869470520111637\",\n      \"status\": 400\n    }\n  ]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "results": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "product_id": {
                            "type": "string",
                            "example": "169869470520111636"
                          },
                          "status": {
                            "type": "integer",
                            "example": 200,
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