# Create

Creates a resource.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name                   | Type   | Description                  | Example                                        |
| :--------------------- | :----- | :--------------------------- | :--------------------------------------------- |
| merchant               | string | Merchant ID                  | "ac4f7938383a11e89ecbbc764e1107f2"             |
| public\_id             | string | Resource ID                  | "c4cd7f86ccc411e8ada3bc764e101db1"             |
| name                   | string | Resource name                | "4k Resolution Movies"                         |
| external\_resource\_id | string | Merchant resource ID         | "id1234"                                       |
| description            | string | Resource description         | "Unlocks streaming of movies in 4K resolution" |
| image\_url             | string | Resource image URL           | "ordergroove.com/resource/resource\_id.png"    |
| created                | string | Date of resource creation    | "2017-02-29 12:00:00"                          |
| last\_updated          | string | Date of last resource update | "2017-02-29 12:00:00"                          |

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
    "/resources/create/": {
      "post": {
        "summary": "Create",
        "description": "Creates a resource.",
        "operationId": "resource-create",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "name",
                  "external_resource_id"
                ],
                "properties": {
                  "name": {
                    "type": "string",
                    "description": "Resource name"
                  },
                  "external_resource_id": {
                    "type": "string",
                    "description": "Merchant resource ID"
                  },
                  "description": {
                    "type": "string",
                    "description": "Resource description"
                  },
                  "image_url": {
                    "type": "string",
                    "description": "Resource image URL"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "201",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"public_id\": \"ecb42bee71ff11efb72ef29e3ec3bb34\",\n  \"merchant\": \"339536244b7c11eb8d37ee71e0f3a639\",\n  \"name\": \"Piano lesson\",\n  \"external_resource_id\": \"123456\",\n  \"description\": null,\n  \"image_url\": \"http://some.image.com\",\n  \"created\": \"2020-12-31 23:28:48\",\n  \"last_updated\": \"2020-12-31 23:28:48\"\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "public_id": {
                      "type": "string",
                      "example": "ecb42bee71ff11efb72ef29e3ec3bb34"
                    },
                    "merchant": {
                      "type": "string",
                      "example": "339536244b7c11eb8d37ee71e0f3a639"
                    },
                    "name": {
                      "type": "string",
                      "example": "Piano lesson"
                    },
                    "external_resource_id": {
                      "type": "string",
                      "example": "123456"
                    },
                    "description": {},
                    "image_url": {
                      "type": "string",
                      "example": "http://some.image.com"
                    },
                    "created": {
                      "type": "string",
                      "example": "2020-12-31 23:28:48"
                    },
                    "last_updated": {
                      "type": "string",
                      "example": "2020-12-31 23:28:48"
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
                    "value": "{\n  \"[field_name]\": [\"field_name error 1\", \"field_name error 2\"]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "[field_name]": {
                      "type": "array",
                      "items": {
                        "type": "string",
                        "example": "field_name error 1"
                      }
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