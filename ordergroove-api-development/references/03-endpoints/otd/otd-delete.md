# Delete

Deletes a single one-time incentive by its unique identifier.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

## Response Body Definitions

| Name           | Type   | Description             | Example                          |
| :------------- | :----- | :---------------------- | :------------------------------- |
| public\_id     | string | One-Time Incentive ID   | 8637c3fe9b7011eaa2c1bc764e107990 |
| external\_code | string | External Code           | awesome\_discount                |
| description    | string | Description             | One-Time Incentive               |
| merchant       | string | Merchant ID             | ac4f7938383a11e89ecbbc764e1107f2 |
| customer       | string | Customer ID             | 00026001                         |
| order          | string | Order ID                | c4e05d04ccc411e8ada3bc764e101db1 |
| created        | string | Datetime of creation    | 2020-05-21 09:36:57              |
| last\_updated  | string | Datetime of last update | 2020-05-21 09:36:57              |
| incentive      | object | Incentive object        |                                  |

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
    "/one_time_incentives/{one_time_incentive_id}/delete/": {
      "delete": {
        "summary": "Delete",
        "description": "Deletes a single one-time incentive by its unique identifier.",
        "operationId": "otd-delete",
        "parameters": [
          {
            "name": "one_time_incentive_id",
            "in": "path",
            "description": "Unique one-time incentive id",
            "schema": {
              "type": "string"
            },
            "required": true
          }
        ],
        "responses": {
          "404": {
            "description": "404",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\"detail\": \"Not found\"}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "detail": {
                      "type": "string",
                      "example": "Not found"
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