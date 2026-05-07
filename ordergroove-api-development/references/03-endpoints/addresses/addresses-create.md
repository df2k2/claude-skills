# Create

Creates address information for an individual customer.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope (including with trust\_level: recognized)
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
        public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Address ID
      </td>

      <td style={{ textAlign: "left" }}>
        "c4cd7f86ccc411e8ada3bc764e101db1"
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
        first\_name
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer first name
      </td>

      <td style={{ textAlign: "left" }}>
        "Nathan"
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
        "Torres"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        company\_name
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer company name
      </td>

      <td style={{ textAlign: "left" }}>
        "Torres Tower Construction LLC"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        address
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer primary address
      </td>

      <td style={{ textAlign: "left" }}>
        "75 Broad St Fl 23"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        address2
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Additional customer address
      </td>

      <td style={{ textAlign: "left" }}>
        "123 Broadway"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        city
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer city name
      </td>

      <td style={{ textAlign: "left" }}>
        "New York"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        state\_province\_code
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer state or province
      </td>

      <td style={{ textAlign: "left" }}>
        "NY"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        zip\_postal\_code
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer postal code
      </td>

      <td style={{ textAlign: "left" }}>
        "10004-2487"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        phone
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer phone number
      </td>

      <td style={{ textAlign: "left" }}>
        "3154055372"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        fax
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer fax number
      </td>

      <td style={{ textAlign: "left" }}>
        "3839191337"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        country\_code
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer country code
      </td>

      <td style={{ textAlign: "left" }}>
        "US"
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
        Date of account creation
      </td>

      <td style={{ textAlign: "left" }}>
        "2018-10-10 14:43:32"
      </td>
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
        store\_public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }} />
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
    "/addresses/create/": {
      "post": {
        "summary": "Create",
        "description": "Creates address information for an individual customer.",
        "operationId": "addresses-create",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "customer",
                  "address_type",
                  "first_name",
                  "last_name",
                  "address",
                  "city",
                  "state_province_code",
                  "zip_postal_code",
                  "country_code",
                  "phone"
                ],
                "properties": {
                  "customer": {
                    "type": "string",
                    "description": "Customer ID"
                  },
                  "address_type": {
                    "type": "string",
                    "description": "Customer address type ('billing_address' or 'shipping_address')"
                  },
                  "first_name": {
                    "type": "string",
                    "description": "Customer first name"
                  },
                  "last_name": {
                    "type": "string",
                    "description": "Customer last name"
                  },
                  "label": {
                    "type": "string"
                  },
                  "company_name": {
                    "type": "string",
                    "description": "Customer company name"
                  },
                  "address": {
                    "type": "string",
                    "description": "Customer primary address"
                  },
                  "address2": {
                    "type": "string",
                    "description": "Additional customer address"
                  },
                  "city": {
                    "type": "string",
                    "description": "Customer city name"
                  },
                  "state_province_code": {
                    "type": "string",
                    "description": "Customer state or province"
                  },
                  "zip_postal_code": {
                    "type": "string",
                    "description": "Customer postal code"
                  },
                  "country_code": {
                    "type": "string",
                    "description": "Customer country code"
                  },
                  "phone": {
                    "type": "string",
                    "description": "Customer phone number"
                  },
                  "fax": {
                    "type": "string",
                    "description": "Customer fax number"
                  },
                  "token_id": {
                    "type": "string",
                    "description": "External merchant reference"
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
                    "value": "{\n  \"customer\": \"00026001\",\n  \"public_id\": \"c4cd7f86ccc411e8ada3bc764e101db1\",\n  \"label\": null,\n  \"first_name\": \"Nathan\",\n  \"last_name\": \"Torres\",\n  \"company_name\": null,\n  \"address\": \"75 Broad St Fl 23\",\n  \"address2\": null,\n  \"city\": \"New York\",\n  \"state_province_code\": \"NY\",\n  \"zip_postal_code\": \"10004-2487\",\n  \"phone\": \"3154055372\",\n  \"fax\": null,\n  \"country_code\": \"US\",\n  \"live\": true,\n  \"created\": \"2018-10-10 14:43:32\",\n  \"token_id\": null,\n\t\"store_public_id\": null\n}\n\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "customer": {
                      "type": "string",
                      "example": "00026001"
                    },
                    "public_id": {
                      "type": "string",
                      "example": "c4cd7f86ccc411e8ada3bc764e101db1"
                    },
                    "label": {},
                    "first_name": {
                      "type": "string",
                      "example": "Nathan"
                    },
                    "last_name": {
                      "type": "string",
                      "example": "Torres"
                    },
                    "company_name": {},
                    "address": {
                      "type": "string",
                      "example": "75 Broad St Fl 23"
                    },
                    "address2": {},
                    "city": {
                      "type": "string",
                      "example": "New York"
                    },
                    "state_province_code": {
                      "type": "string",
                      "example": "NY"
                    },
                    "zip_postal_code": {
                      "type": "string",
                      "example": "10004-2487"
                    },
                    "phone": {
                      "type": "string",
                      "example": "3154055372"
                    },
                    "fax": {},
                    "country_code": {
                      "type": "string",
                      "example": "US"
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
                    "token_id": {},
                    "store_public_id": {}
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