# Update

Updates an existing product.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

<br />

## Response Body Definitions

| Name                  | Type    | Description                                                                               | Example                                                                            |
| :-------------------- | :------ | :---------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------- |
| name                  | string  | Product Name                                                                              | "Example Product Name"                                                             |
| external\_product\_id | string  | Product ID                                                                                | "0070000693"                                                                       |
| sku                   | string  | Product SKU                                                                               | "6b759bf8775511eeb9620242ac120002"                                                 |
| price                 | double  | Product price                                                                             | 38.59                                                                              |
| live                  | boolean | Product liveliness                                                                        | true                                                                               |
| image\_url            | string  | Product image url                                                                         | "[https://example.com/product\_image.png"](https://example.com/product_image.png") |
| detail\_url           | string  | Product detail url                                                                        | "[https://example.com/product\_url/"](https://example.com/product_url/")           |
| autoship\_enabled     | boolean | Product autoship eligibility                                                              | true                                                                               |
| prepaid\_eligible     | boolean | Product prepaid eligibility                                                               | true                                                                               |
| discontinued          | boolean | Product discontinued status                                                               | false                                                                              |
| autoship\_by\_default | boolean | Product default autoship                                                                  | True                                                                               |
| product\_type         | string  | Product type: "standard", "bundle", "club"                                                | "standard"                                                                         |
| every                 | int     | Number of periods                                                                         | 1                                                                                  |
| every\_period         | int     | Type of periods                                                                           | 1                                                                                  |
| ~~premier\_enabled~~  | int     |                                                                                           | *Deprecated*                                                                       |
| extra\_data           | string  | Raw JSON string that should be JSON.parse() as key/value store for any extra information. | \{"some": "extra", "fields": "here}                                                |
| offer\_profile        | string  | Offer profile id                                                                          | "9eb7306a775711eeb9620242ac120002"                                                 |
| incentive\_group      | string  | Incentive group id                                                                        | "b22fc760775711eeb9620242ac121232"                                                 |

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
    "/products/{external_product_id}/": {
      "patch": {
        "summary": "Update",
        "description": "Updates an existing product.",
        "operationId": "products-update",
        "parameters": [
          {
            "in": "path",
            "name": "external_product_id",
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
                  "autoship_by_default": {
                    "type": "boolean",
                    "default": false
                  },
                  "upsell_eligible": {
                    "type": "boolean",
                    "description": "Product upsell eligibility",
                    "default": false
                  },
                  "price": {
                    "type": "number",
                    "description": "Product price, must be in decimal. Ex: 15.00",
                    "format": "float"
                  },
                  "type": {
                    "type": "string",
                    "description": "Product type",
                    "default": "standard"
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
                    "value": "{\n  \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n  \"merchant_user_id\": \"12345\",\n  \"session_id\": \"5bda04dc429d11e4bd78bc764e106cf4.463053.1418160308\",\n  \"user_token_id\": \"bda1c6b0084811e6965ebc764e106cf4\",\n  \"first_name\": \"Michal\",\n  \"last_name\": \"Swiader\",\n  \"email\": \"michal@swiader.com\",\n  \"phone_number\": \"+15551231234\",\n  \"phone_type\": \"0\",\n  \"live\": \"True\",\n  \"created\": \"2020-02-29 12:00:00\",\n  \"last_updated\": \"2020-02-29 12:00:00\",\n  \"last_login\": \"2020-02-29 12:00:00\",\n  \"extra_data\": \"{\\\"some\\\": \\\"extra\\\", \\\"fields\\\": \\\"here\\\"}\",\n  \"locale\": 42\n\t\"experiences\": \"{\\\"reorder\\\": true, \\\"subscription-management\\\": false}\"\n}\n"
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
                    "value": "{\n  \"[field_name]\": \"field_name error detail\"\n}"
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