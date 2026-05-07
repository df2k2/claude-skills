# Create

Creates a new customer account.

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
        merchant
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Merchant ID
      </td>

      <td style={{ textAlign: "left" }}>
        "275dbe1d77f34aca968fb75a8dbb4c82"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        merchant\_user\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Merchant User ID
      </td>

      <td style={{ textAlign: "left" }}>
        "TEST"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        session\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Session ID, obtained from og\_session\_id cookie
      </td>

      <td style={{ textAlign: "left" }}>
        "5bda04dc429d11e4bd78bc764e106cf4.463053.1418160308"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        user\_token\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        User Token ID
      </td>

      <td style={{ textAlign: "left" }}>
        "bda1c6b0084811e6965ebc764e106cf4"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        first\_name
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer first name
      </td>

      <td style={{ textAlign: "left" }}>
        "John"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        last\_name
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer last name
      </td>

      <td style={{ textAlign: "left" }}>
        "Doe"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        email
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer email
      </td>

      <td style={{ textAlign: "left" }}>
        "[john@doe.com](mailto:john@doe.com)"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        phone\_number
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer phone number
      </td>

      <td style={{ textAlign: "left" }}>
        "+15551231234"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        phone\_type
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Customer phone type.

        Options: 0, 1, 2, 3

        0 = "Invalid"\
        1 = "Landline"\
        2 = "Mobile"\
        3 = "VoIP"
      </td>

      <td style={{ textAlign: "left" }}>
        1
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
        Account status: active = 'True'
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
        Date of customer account creation
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29 12:00:00"
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
        Date of most recent customer account update
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29 12:00:00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        last\_login
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date of most recent customer login
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29 12:00:00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        extra\_data
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Raw JSON string that should be JSON.parse() as key/value store for any extra information
      </td>

      <td style={{ textAlign: "left" }}>
        "\{"some": "extra", "fields": "here"}"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        locale
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Customer locale code
      </td>

      <td style={{ textAlign: "left" }}>
        42
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        experiences
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Raw JSON string that should be JSON.parse() as key/value store for experiences set to true or false.
      </td>

      <td style={{ textAlign: "left" }}>
        "\{"reorder": true, "subscription-management": false}"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        price\_code
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer price code
      </td>

      <td style={{ textAlign: "left" }}>
        "prom\_customer"
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
    "/customers/create/": {
      "post": {
        "summary": "Create",
        "description": "Creates a new customer account.",
        "operationId": "customers-create",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "merchant",
                  "merchant_user_id",
                  "session_id",
                  "user_token_id",
                  "first_name",
                  "last_name",
                  "email",
                  "phone_number",
                  "phone_type",
                  "live",
                  "created",
                  "last_updated",
                  "last_login",
                  "locale"
                ],
                "properties": {
                  "merchant": {
                    "type": "string",
                    "description": "Merchant ID"
                  },
                  "merchant_user_id": {
                    "type": "string",
                    "description": "Merchant User ID"
                  },
                  "session_id": {
                    "type": "string",
                    "description": "Session ID, obtained from og_session_id cookie."
                  },
                  "user_token_id": {
                    "type": "string",
                    "description": "User Token ID"
                  },
                  "first_name": {
                    "type": "string",
                    "description": "Customer first name"
                  },
                  "last_name": {
                    "type": "string",
                    "description": "Customer last name"
                  },
                  "email": {
                    "type": "string",
                    "description": "Customer email"
                  },
                  "phone_number": {
                    "type": "string",
                    "description": "Customer phone number"
                  },
                  "phone_type": {
                    "type": "string",
                    "description": "Customer phone type: \"invalid\", \"landline\", \"mobile\", or \"voip\""
                  },
                  "live": {
                    "type": "boolean",
                    "description": "Account status: active = True"
                  },
                  "created": {
                    "type": "string",
                    "description": "Date of account creation"
                  },
                  "last_updated": {
                    "type": "string",
                    "description": "Date of last customer account update"
                  },
                  "last_login": {
                    "type": "string",
                    "description": "Date of last customer account login"
                  },
                  "extra_data": {
                    "type": "string",
                    "description": "Raw JSON string that should be JSON.parse() as key/value store for any extra information."
                  },
                  "locale": {
                    "type": "integer",
                    "description": "Customer locale code. Accepts a locale string (e.g. `\"en-US\"`) or an integer ID for backwards compatibility.",
                    "format": "int32"
                  },
                  "experiences": {
                    "type": "string",
                    "description": "Experience name and Boolean value as key/value store, formatted as raw JSON string, to be JSON.parse() on retrieval"
                  },
                  "price_code": {
                    "type": "string",
                    "description": "Customer price code"
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