# 1-Click Skip

Cancels (skips) an order.  If the order is associated with a subscription, the subsequent order will be created based on its set frequency.

<Callout icon="🔐" theme="default">
  ### Authentication

  No authentication required for this endpoint.
</Callout>

<br />

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
    "/one_click/skip": {
      "get": {
        "description": "",
        "operationId": "get_new-endpoint",
        "responses": {
          "200": {
            "description": "200"
          },
          "400": {
            "description": "Bad Request",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {}
                }
              }
            }
          }
        },
        "parameters": [
          {
            "in": "query",
            "name": "token",
            "schema": {
              "type": "string"
            },
            "description": "1-Click action token for the subscription",
            "required": true
          }
        ]
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