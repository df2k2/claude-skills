# Update

Updates an individual customer's extra data, locale, or price code.

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
        Examples
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td style={{ textAlign: "left" }}>
        extra\_data
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer extra\_data (JSON string)
      </td>

      <td style={{ textAlign: "left" }}>
        "\{"subscriber\_key": "[another\_email@ordergroove.com](mailto:another_email@ordergroove.com)"}"

        null
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        locale
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer locale
      </td>

      <td style={{ textAlign: "left" }}>
        "en-us"

        "fr-ca"

        null
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
        "abc 123"

        "prom\_customer"

        null
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
    "/customers/{merchant_user_id}/update": {
      "patch": {
        "summary": "Update",
        "description": "Updates an individual customer's extra data or locale.",
        "operationId": "update",
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
                "properties": {
                  "extra_data": {
                    "type": "string",
                    "description": "Customer extra data"
                  },
                  "locale": {
                    "type": "string",
                    "description": "Customer locale (case insensitive, hyphens and dashes are interchangeable) e.g. 'fr-ca', 'es_ES'"
                  },
                  "price_code": {
                    "type": "string",
                    "description": "Customer price code"
                  }
                }
              },
              "examples": {
                "200 OK": {
                  "value": {
                    "extra_data": "{\"key\": \"value\"}",
                    "locale": "es-ar"
                  }
                },
                "200 locale: case insensitive, hyphen/dash allowed": {
                  "value": {
                    "locale": "Fr_cA"
                  }
                },
                "400 Bad Request (locale)": {
                  "value": {
                    "locale": "en-us",
                    "extra_data": "{notJSON"
                  }
                },
                "400 Bad Request (extra_data)": {
                  "value": {
                    "locale": "en-us",
                    "extra_data": "{notJSON"
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
                    "value": "{\n    \"extra_data\": \"{\\\"key\\\": \\\"value\\\"}\",\n    \"locale\": \"es-ar\"\n}"
                  },
                  "locale: case insensitive, hyphen/dash allowed": {
                    "value": "{\n    \"extra_data\": \"{\\\"key\\\": \\\"value\\\"}\",\n    \"locale\": \"fr-ca\"\n}"
                  }
                },
                "schema": {
                  "oneOf": [
                    {
                      "type": "object",
                      "properties": {
                        "extra_data": {
                          "type": "string",
                          "example": "{\"key\": \"value\"}"
                        },
                        "locale": {
                          "type": "string",
                          "example": "es-ar"
                        }
                      }
                    },
                    {
                      "title": "locale: case insensitive, hyphen/dash allowed",
                      "type": "object",
                      "properties": {
                        "extra_data": {
                          "type": "string",
                          "example": "{\"key\": \"value\"}"
                        },
                        "locale": {
                          "type": "string",
                          "example": "fr-ca"
                        }
                      }
                    }
                  ]
                }
              }
            }
          },
          "400": {
            "description": "400",
            "content": {
              "application/json": {
                "examples": {
                  "Bad Request (locale)": {
                    "value": "{\n    \"locale\": [\n        \"Invalid locale: en-UnitedStates\"\n    ]\n}"
                  },
                  "Bad Request (extra_data)": {
                    "value": "{\n    \"extra_data\": [\n        \"Invalid JSON extra_data: {notJSON\"\n    ]\n}"
                  }
                },
                "schema": {
                  "oneOf": [
                    {
                      "title": "Bad Request (locale)",
                      "type": "object",
                      "properties": {
                        "locale": {
                          "type": "array",
                          "items": {
                            "type": "string",
                            "example": "Invalid locale: en-UnitedStates"
                          }
                        }
                      }
                    },
                    {
                      "title": "Bad Request (extra_data)",
                      "type": "object",
                      "properties": {
                        "extra_data": {
                          "type": "array",
                          "items": {
                            "type": "string",
                            "example": "Invalid JSON extra_data: {notJSON"
                          }
                        }
                      }
                    }
                  ]
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
                    "value": "{\n  \"detail\": \"Authentication Failed\"\n}"
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