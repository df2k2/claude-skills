# Retrieve

Returns information about an individual customer account by its unique identifier.

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
    "/customers/{merchant_user_id}/": {
      "get": {
        "summary": "Retrieve",
        "description": "Returns information about an individual customer account by its unique identifier.",
        "operationId": "customers-retrieve",
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
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"id\": 1599349,\n    \"merchant_user_id\": \"00026001\",\n    \"session_id\": \"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086\",\n    \"user_token_id\": \"abc123\",\n    \"first_name\": \"Nathan\",\n    \"last_name\": \"Torres\",\n    \"email\": \"nathan.torres@ordergroove.com\",\n    \"phone_number\": \"+13154055372\",\n    \"phone_type\": 2,\n    \"live\": true,\n    \"created\": \"2018-10-10 14:43:32\",\n    \"last_updated\": \"2018-11-15 21:44:19\",\n    \"extra_data\": \"\",\n    \"locale\": \"en-us\",\n    \"price_code\": \"\"\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "merchant": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2"
                    },
                    "id": {
                      "type": "integer",
                      "example": 1599349,
                      "default": 0
                    },
                    "merchant_user_id": {
                      "type": "string",
                      "example": "00026001"
                    },
                    "session_id": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"
                    },
                    "user_token_id": {
                      "type": "string",
                      "example": "abc123"
                    },
                    "first_name": {
                      "type": "string",
                      "example": "Nathan"
                    },
                    "last_name": {
                      "type": "string",
                      "example": "Torres"
                    },
                    "email": {
                      "type": "string",
                      "example": "nathan.torres@ordergroove.com"
                    },
                    "phone_number": {
                      "type": "string",
                      "example": "+13154055372"
                    },
                    "phone_type": {
                      "type": "integer",
                      "example": 2,
                      "default": 0
                    },
                    "live": {
                      "type": "boolean",
                      "example": true,
                      "default": true
                    },
                    "created": {
                      "type": "string",
                      "example": "2018-10-10 14:43:32"
                    },
                    "last_updated": {
                      "type": "string",
                      "example": "2018-11-15 21:44:19"
                    },
                    "extra_data": {
                      "type": "string",
                      "example": ""
                    },
                    "locale": {
                      "type": "string",
                      "example": "en-us"
                    },
                    "price_code": {
                      "type": "string",
                      "example": ""
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
                    "value": "{\n  \"detail\": \"Unable to find requested asset.\"\n}"
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