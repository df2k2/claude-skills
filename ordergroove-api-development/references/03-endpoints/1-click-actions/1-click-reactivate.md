# 1-Click Reactivate

Reactivates a customer’s subscription. The first order date is set to the next day. The customer will get charged the next day, and will resume all previous subscription settings such as frequency and quantity.

<Callout icon="🔐" theme="default">
  ### Authentication

  No authentication required for this endpoint.
</Callout>

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
    "/one_click/reactivate": {
      "get": {
        "summary": "1-Click Reactivate",
        "description": "Reactivates a customer’s subscription. The first order date is set to the next day. The customer will get charged the next day, and will resume all previous subscription settings such as frequency and quantity.",
        "operationId": "1-click-reactivate",
        "parameters": [
          {
            "name": "token",
            "in": "query",
            "description": "1-Click action token for the subscription",
            "required": true,
            "schema": {
              "type": "string"
            }
          },
          {
            "in": "query",
            "name": "winback_id",
            "schema": {
              "type": "string"
            },
            "description": "The id of the winback discount that will be applied to the subscription's next order"
          }
        ],
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {}
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
                    "value": "{\"error\": “string”}"
                  }
                }
              }
            }
          }
        },
        "deprecated": false,
        "x-readme": {
          "code-samples": [
            {
              "language": "text",
              "code": "https://restapi.ordergroove.com/one_click/reactivate/?token={{event.action_token}}"
            }
          ],
          "samples-languages": [
            "text"
          ]
        }
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