# Update

Activates or deactivates the specified payment method.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

***

> ❗️ Shopify Integrations
>
> If you are on a Shopify installation, **do not** use this or any of Ordergroove's endpoints. Use Shopify's [customerPaymentMethodSendUpdateEmail](https://shopify.dev/docs/api/admin-graphql/2024-07/mutations/customerpaymentmethodsendupdateemail) instead.

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
        customer
      </td>

      <td>
        string
      </td>

      <td>
        Customer ID
      </td>

      <td>
        "00026001"
      </td>
    </tr>

    <tr>
      <td>
        billing\_address
      </td>

      <td>
        string
      </td>

      <td>
        Customer billing address (encrypted)
      </td>

      <td>
        "c4cfc106ccc411e8ada3bc764e101db1"
      </td>
    </tr>

    <tr>
      <td>
        cc\_number\_ending
      </td>

      <td>
        string
      </td>

      <td>
        Last four digits of credit card number
      </td>

      <td>
        "4111"
      </td>
    </tr>

    <tr>
      <td>
        public\_id
      </td>

      <td>
        string
      </td>

      <td>
        Payment ID
      </td>

      <td>
        "f9cb2f93e1c845eb9de9eff46ddb3cbf"
      </td>
    </tr>

    <tr>
      <td>
        label
      </td>

      <td>
        string
      </td>

      <td />

      <td />
    </tr>

    <tr>
      <td>
        token\_id
      </td>

      <td>
        string
      </td>

      <td />

      <td />
    </tr>

    <tr>
      <td>
        cc\_holder
      </td>

      <td>
        string
      </td>

      <td>
        Cardholder name
      </td>

      <td>
        "John Doe"
      </td>
    </tr>

    <tr>
      <td>
        cc\_type
      </td>

      <td>
        integer
      </td>

      <td>
        Credit card type code
      </td>

      <td>
        1
      </td>
    </tr>

    <tr>
      <td>
        cc\_exp\_date
      </td>

      <td>
        string
      </td>

      <td>
        Expiration date (format: MM/YYYY)
      </td>

      <td>
        "11/2028"
      </td>
    </tr>

    <tr>
      <td>
        payment\_method
      </td>

      <td>
        string
      </td>

      <td>
        Payment method:

        * credit card
        * paypal
      </td>

      <td>
        "credit card"
      </td>
    </tr>

    <tr>
      <td>
        live
      </td>

      <td>
        boolean
      </td>

      <td>
        Account status:\
        active = True
      </td>

      <td>
        True
      </td>
    </tr>

    <tr>
      <td>
        created
      </td>

      <td>
        string
      </td>

      <td>
        Date of payment method creation
      </td>

      <td>
        "2018-10-10 14:43:32"
      </td>
    </tr>

    <tr>
      <td>
        last\_updated
      </td>

      <td>
        string
      </td>

      <td>
        Date of last payment method update
      </td>

      <td>
        "2018-10-10 14:43:32"
      </td>
    </tr>
  </tbody>
</Table>

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
    "/payments/{payment_id}/update/": {
      "patch": {
        "summary": "Update",
        "description": "Activates or deactivates the specified payment method.",
        "operationId": "payments-update",
        "parameters": [
          {
            "name": "payment_id",
            "in": "path",
            "description": "Unique Address Id",
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
                  "live"
                ],
                "properties": {
                  "live": {
                    "type": "boolean",
                    "description": "Account status: active = True"
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
                    "value": "{\n    \"customer\": \"00026001\",\n    \"billing_address\": \"c4cfc106ccc411e8ada3bc764e101db1\",\n    \"cc_number_ending\": null,\n    \"public_id\": \"c4d1d4e6ccc411e8ada3bc764e101db1\",\n    \"label\": null,\n    \"token_id\": \"5CA94EAA-AADE-4918-ABEE-8C8531411BAE\",\n    \"cc_holder\": null,\n    \"cc_type\": 1,\n    \"cc_exp_date\": \"02/2020\",\n    \"payment_method\": \"credit card\",\n    \"live\": false,\n    \"created\": \"2018-10-10 14:43:32\",\n    \"last_updated\": \"2018-10-10 14:43:32\"\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "customer": {
                      "type": "string",
                      "example": "00026001"
                    },
                    "billing_address": {
                      "type": "string",
                      "example": "c4cfc106ccc411e8ada3bc764e101db1"
                    },
                    "cc_number_ending": {},
                    "public_id": {
                      "type": "string",
                      "example": "c4d1d4e6ccc411e8ada3bc764e101db1"
                    },
                    "label": {},
                    "token_id": {
                      "type": "string",
                      "example": "5CA94EAA-AADE-4918-ABEE-8C8531411BAE"
                    },
                    "cc_holder": {},
                    "cc_type": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "cc_exp_date": {
                      "type": "string",
                      "example": "02/2020"
                    },
                    "payment_method": {
                      "type": "string",
                      "example": "credit card"
                    },
                    "live": {
                      "type": "boolean",
                      "example": false,
                      "default": true
                    },
                    "created": {
                      "type": "string",
                      "example": "2018-10-10 14:43:32"
                    },
                    "last_updated": {
                      "type": "string",
                      "example": "2018-10-10 14:43:32"
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
              "application/json": {
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