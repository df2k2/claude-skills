# List

Returns a list all of One Time Incentives attached to subscriptions for a merchant, or a list of one incentives for an individual customer.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

| Name           | Type   | Description                                | Example                          |
| :------------- | :----- | :----------------------------------------- | :------------------------------- |
| public\_id     | string | One-Time Incentive ID                      | 8637c3fe9b7011eaa2c1bc764e107990 |
| external\_code | string | External Code                              | awesome\_discount                |
| description    | string | Description                                | One-Time Incentive               |
| merchant       | string | Merchant ID                                | ac4f7938383a11e89ecbbc764e1107f2 |
| customer       | string | Customer ID                                | 00026001                         |
| order          | string | Order ID                                   | c4e05d04ccc411e8ada3bc764e101db1 |
| created        | string | Datetime of creation                       | 2020-05-21 09:36:57              |
| last\_updated  | string | Datetime of last update                    | 2020-05-21 09:36:57              |
| incentive      | object | Incentive object                           |                                  |
| applied\_at    | string | Datetime of when the incentive was applied | 2020-05-21 09:36:57              |

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
    "/one_time_incentives/": {
      "get": {
        "summary": "List",
        "description": "Returns a list all of One Time Incentives attached to subscriptions for a merchant, or a list of one incentives for an individual customer.",
        "operationId": "otd-list",
        "parameters": [
          {
            "name": "order",
            "in": "query",
            "description": "Order Public ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "customer",
            "in": "query",
            "description": "Merchant Customer ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "external_code",
            "in": "query",
            "description": "External code on the OTD",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "item",
            "in": "query",
            "description": "Item Public ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "created",
            "in": "query",
            "description": "One Time Incentives whose created date matches exactly (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_start",
            "in": "query",
            "description": "One Time Incentives whose created datetime is greater than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_end",
            "in": "query",
            "description": "One Time Incentives whose created datetime is less than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "last_updated",
            "in": "query",
            "description": "One Time Incentives whose last updated date matches exactly (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "last_updated_start",
            "in": "query",
            "description": "One Time Incentives whose last updated datetime is greater than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "last_updated_end",
            "in": "query",
            "description": "One Time Incentives whose last updated datetime is less than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "applied_at",
            "in": "query",
            "description": "One Time Incentives applied on the specified date (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "applied_at_start",
            "in": "query",
            "description": "One Time Incentives applied after or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "applied_at_end",
            "in": "query",
            "description": "One Time Incentives applied before or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "include_item_level",
            "in": "query",
            "description": "If the list is filtered by order, include also the One Time Incentives for all the items linked to this order",
            "schema": {
              "type": "boolean"
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
                    "value": "[{\n    \"public_id\": \"8637c3fe9b7011eaa2c1bc764e107990\",\n    \"external_code\": \"awesome_discount\",\n    \"description\": \"One-time Incentive\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"customer\": \"00026001\",\n    \"order\": \"c4e05d04ccc411e8ada3bc764e101db1\",\n    \"created\": \"2020-05-21 09:36:57\",\n    \"last_updated\": \"2020-05-21 09:36:57\",\n    \"applied_at\": \"2020-05-22 09:00:15\"\n    \"incentive\": {\n        \"type\": \"Discount\",\n        \"public_id\": \"c34a8c03eae641d0ab7015bedec6fbd0\",\n        \"discount_type\": \"Discount Percent\",\n        \"target\": \"item\",\n        \"field\": \"total_price\",\n        \"name\": \"awesome discount\",\n        \"value\": \"10.00\"\n    }\n},{\n    \"public_id\": \"8637c3fe9b7011eaa2c1bc764e107990\",\n    \"external_code\": \"other awesomeme_discount\",\n    \"description\": \"One-time Incentive\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"customer\": \"00023208\",\n    \"order\": \"c2389472f03450287ada3bc764e101db1\",\n    \"created\": \"2020-06-13 014:16:57\",\n    \"last_updated\": \"2020-06-21 09:36:57\",\n    \"incentive\": {\n        \"type\": \"Discount\",\n        \"public_id\": \"32v37239087e641d0ab7015bedec6fbd0\",\n        \"discount_type\": \"Flat Amount\",\n        \"target\": \"item\",\n        \"field\": \"total_price\",\n        \"name\": \"other awesome discount\",\n        \"value\": \"5.00\"\n    },{\n    \"public_id\": \"8637c3fe9b7011eaa2c1bc764e107990\",\n    \"external_code\": \"other awesomeme_discount\",\n    \"description\": \"One-time Incentive\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"customer\": \"00023208\",\n    \"item\": \"c2389472f03450287ada3bc764e101db1\",\n    \"created\": \"2020-06-13 014:16:57\",\n    \"last_updated\": \"2020-06-21 09:36:57\",\n    \"incentive\": {\n        \"type\": \"Discount\",\n        \"public_id\": \"32v37239087e641d0ab7015bedec6fbd0\",\n        \"discount_type\": \"Flat Amount\",\n        \"target\": \"item\",\n        \"field\": \"total_price\",\n        \"name\": \"other awesome discount\",\n        \"value\": \"5.00\"\n    }\n}]"
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