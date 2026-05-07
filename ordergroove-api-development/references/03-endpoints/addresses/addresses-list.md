# List

Returns an array of all addresses available to the merchant.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope (including with trust\_level: recognized)

  Note: Application API Scope with Bulk Operations permission is required to list addresses for more than one customer.
</Callout>

## Response Body Definitions

| Name                  | Type    | Description                                    | Example                            |
| :-------------------- | :------ | :--------------------------------------------- | :--------------------------------- |
| customer              | string  | Customer ID                                    | "00026001"                         |
| public\_id            | string  | Address ID                                     | "c4cd7f86ccc411e8ada3bc764e101db1" |
| label                 | string  |                                                |                                    |
| first\_name           | string  | Customer first name                            | "Nathan"                           |
| last\_name            | string  | Customer last name                             | "Torres"                           |
| company\_name         | string  | Customer company name                          | "Torres Tower Construction LLC"    |
| address               | string  | Customer primary address                       | "75 Broad St Fl 23"                |
| address2              | string  | Additional customer address                    | "123 Broadway"                     |
| city                  | string  | Customer city name                             | "New York"                         |
| state\_province\_code | string  | Customer state or province                     | "NY"                               |
| zip\_postal\_code     | string  | Customer postal code                           | "10004-2487"                       |
| phone                 | string  | Customer phone number                          | "3154055372"                       |
| fax                   | string  | Customer fax number                            | "3839191337"                       |
| country\_code         | string  | Customer country code                          | "US"                               |
| live                  | boolean | Whether the Address object is considered live  | True                               |
| created               | string  | Date time the Address object was created       | "2018-10-10 14:43:32"              |
| updated               | string  | Date time the Address object was last modified | "2025-03-13 04:43:32"              |
| token\_id             | string  |                                                |                                    |
| store\_public\_id     | string  |                                                |                                    |

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
    "/addresses/": {
      "get": {
        "summary": "List",
        "description": "Returns an array of all addresses available to the merchant.",
        "operationId": "addresses-list",
        "parameters": [
          {
            "name": "customer",
            "in": "query",
            "description": "Customer ID (only available in API user scope)",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "live",
            "in": "query",
            "description": "Address status: active (True) or inactive (False)",
            "schema": {
              "type": "boolean"
            }
          },
          {
            "name": "updated_start",
            "in": "query",
            "description": "Addresses whose updated datetime is greater than or equal to the given datetime (yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated_end",
            "in": "query",
            "description": "Addresses whose updated datetime is less than or equal to the given datetime (yyyy-mm-ddThh:mm:ss)",
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
                    "value": "{\n  \"customer\": \"00026001\",\n  \"public_id\": \"c4cd7f86ccc411e8ada3bc764e101db1\",\n  \"label\": null,\n  \"first_name\": \"Nathan\",\n  \"last_name\": \"Torres\",\n  \"company_name\": null,\n  \"address\": \"75 Broad St Fl 23\",\n  \"address2\": null,\n  \"city\": \"New York\",\n  \"state_province_code\": \"NY\",\n  \"zip_postal_code\": \"10004-2487\",\n  \"phone\": \"3154055372\",\n  \"fax\": null,\n  \"country_code\": \"US\",\n  \"live\": true,\n  \"created\": \"2018-10-10 14:43:32\",\n  \"updated\": \"2018-10-10 14:43:32\",\n  \"token_id\": null,\n\t\"store_public_id\": null\n}\n"
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
                    "updated": {
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