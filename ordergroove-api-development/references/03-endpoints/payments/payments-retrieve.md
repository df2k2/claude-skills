# Retrieve

Retrieves a single payment method for an individual customer account by its unique identifier.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th style={{ textAlign: "left" }}>
        Name
      </th>

      <th style={{ textAlign: "left" }}>
        Type
      </th>

      <th style={{ textAlign: "left" }}>
        Description
      </th>

      <th style={{ textAlign: "left" }}>
        Example
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td style={{ textAlign: "left" }}>
        customer
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer ID
      </td>

      <td style={{ textAlign: "left" }}>
        "00026001"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        billing\_address
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer billing address (encrypted)
      </td>

      <td style={{ textAlign: "left" }}>
        "c4cfc106ccc411e8ada3bc764e101db1"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        cc\_number\_ending
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Last four digits of credit card number
      </td>

      <td style={{ textAlign: "left" }}>
        "4111"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Payment ID
      </td>

      <td style={{ textAlign: "left" }}>
        "f9cb2f93e1c845eb9de9eff46ddb3cbf"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        label
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        token\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        cc\_holder
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Cardholder name
      </td>

      <td style={{ textAlign: "left" }}>
        "John Doe"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        cc\_type
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Credit card type code
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        cc\_exp\_date
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Expiration date (format: MM/YYYY)
      </td>

      <td style={{ textAlign: "left" }}>
        "11/2028"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        payment\_method
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Payment method:

        * credit card
        * paypal
      </td>

      <td style={{ textAlign: "left" }}>
        "credit card"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        live
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }}>
        Account status:\
        active = True
      </td>

      <td style={{ textAlign: "left" }}>
        True
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        created
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date of payment method creation
      </td>

      <td style={{ textAlign: "left" }}>
        "2018-10-10 14:43:32"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        last\_updated
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date of last payment method update
      </td>

      <td style={{ textAlign: "left" }}>
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
    "/payments/{payment_id}/": {
      "get": {
        "summary": "Retrieve",
        "description": "Retrieves a single payment method for an individual customer account by its unique identifier.",
        "operationId": "payments-retrieve",
        "parameters": [
          {
            "name": "payment_id",
            "in": "path",
            "description": "Unique Address ID",
            "schema": {
              "type": "string"
            },
            "required": true
          }
        ],
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