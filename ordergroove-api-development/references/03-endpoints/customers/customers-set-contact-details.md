# Set Contact Details

Updates an individual customer's phone number or email address.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name          | Type   | Description           | Example                                                                                          |
| :------------ | :----- | :-------------------- | :----------------------------------------------------------------------------------------------- |
| email         | string | Customer email        | "[john@doe.com](mailto:john@doe.com)"                                                            |
| phone\_number | string | Customer phone number | "+15551231234"                                                                                   |
| extra\_data   | string | Customer extra\_data  | "\{"subscriber\_key": "[another\_email@ordergroove.com](mailto:another_email@ordergroove.com)"}" |

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
    "/customers/{merchant_user_id}/set_contact_details": {
      "patch": {
        "summary": "Set Contact Details",
        "description": "Updates an individual customer's phone number or email address.",
        "operationId": "customers-set-contact-details",
        "parameters": [
          {
            "name": "merchant_user_id",
            "in": "path",
            "description": "Merchant User ID",
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
                "required": [
                  "email",
                  "phone_number"
                ],
                "properties": {
                  "email": {
                    "type": "string",
                    "description": "Customer email"
                  },
                  "phone_number": {
                    "type": "string",
                    "description": "Customer phone number"
                  },
                  "extra_data (deprecated)": {
                    "type": "string",
                    "description": "(deprecated) Customer extra data. For updating this field, please use /customers/{merchant_user_id}/update instead."
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
                    "value": "{\n    \"phone_number\": \"+3212321232\",\n    \"email\": \"michal.swiader@ordergroove.com\",\n    \"extra_data\": \"{\\\"subscriber_key\\\": \\\"another_email@ordergroove.com\\\"}\"\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "phone_number": {
                      "type": "string",
                      "example": "+3212321232"
                    },
                    "email": {
                      "type": "string",
                      "example": "michal.swiader@ordergroove.com"
                    },
                    "extra_data": {
                      "type": "string",
                      "example": "{\"subscriber_key\": \"another_email@ordergroove.com\"}"
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
          },
          "404": {
            "description": "404",
            "content": {
              "text/plain": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"detail\": \"Unable to find requested asset.\"\n}\n"
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