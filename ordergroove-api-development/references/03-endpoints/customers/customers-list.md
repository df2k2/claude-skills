# List

This request will return an array of all customers.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope

  Note: Application API Scope with Bulk Operations permission is required to list more than one customer.
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
        Customer phone type.\
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
    "/customers/": {
      "get": {
        "summary": "List",
        "description": "This request will return an array of all customers.",
        "operationId": "customers-list",
        "parameters": [
          {
            "name": "live",
            "in": "query",
            "description": "Account status: active = 'True'",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "email",
            "in": "query",
            "description": "Customer's email address",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "updated",
            "in": "query",
            "description": "Objects whose updated date matches exactly (yyyy-mm-dd). On customer creation it is populated with same value as created field.",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated_start",
            "in": "query",
            "description": "Objects whose updated datetime is greater than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated_end",
            "in": "query",
            "description": "Objects whose updated datetime is less than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created",
            "in": "query",
            "description": "Objects whose created date matches exactly (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_start",
            "in": "query",
            "description": "Objects whose created datetime is greater than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_end",
            "in": "query",
            "description": "Objects whose created datetime is less than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n  \"merchant_user_id\": \"00040003\",\n  \"session_id\": \"ac4f7938383a11e89ecbbc764e1107f2.66746.1539289512\",\n  \"user_token_id\": \"\",\n  \"first_name\": \"APPLE\",\n  \"last_name\": \"CIDER\",\n  \"email\": \"acider@test.com\",\n  \"phone_number\": \"+15165551212\",\n  \"phone_type\": 0,\n  \"live\": true,\n  \"created\": \"2018-11-12 15:45:39\",\n  \"last_updated\": \"2018-11-15 21:49:10\",\n  \"last_login\": null,\n  \"extra_data\": null,\n\t\"locale\": 1\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "merchant": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2"
                    },
                    "merchant_user_id": {
                      "type": "string",
                      "example": "00040003"
                    },
                    "session_id": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2.66746.1539289512"
                    },
                    "user_token_id": {
                      "type": "string",
                      "example": ""
                    },
                    "first_name": {
                      "type": "string",
                      "example": "APPLE"
                    },
                    "last_name": {
                      "type": "string",
                      "example": "CIDER"
                    },
                    "email": {
                      "type": "string",
                      "example": "acider@test.com"
                    },
                    "phone_number": {
                      "type": "string",
                      "example": "+15165551212"
                    },
                    "phone_type": {
                      "type": "integer",
                      "example": 0,
                      "default": 0
                    },
                    "live": {
                      "type": "boolean",
                      "example": true,
                      "default": true
                    },
                    "created": {
                      "type": "string",
                      "example": "2018-11-12 15:45:39"
                    },
                    "last_updated": {
                      "type": "string",
                      "example": "2018-11-15 21:49:10"
                    },
                    "last_login": {},
                    "extra_data": {},
                    "locale": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
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