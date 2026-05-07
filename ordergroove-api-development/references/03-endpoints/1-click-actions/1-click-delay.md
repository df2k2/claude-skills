# 1-Click Delay

Delays a subscribers upcoming shipment by 14 days. The number of days to delay can optionally be overwritten as a URL parameter.

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
    "/one_click/delay": {
      "get": {
        "summary": "1-Click Delay",
        "description": "Delays a subscribers upcoming shipment by 14 days. The number of days to delay can optionally be overwritten as a URL parameter.",
        "operationId": "1-click-delay",
        "parameters": [
          {
            "name": "days",
            "in": "query",
            "description": "Number of days to delay the order by",
            "schema": {
              "type": "integer",
              "format": "int32",
              "default": 14
            }
          },
          {
            "name": "token",
            "in": "query",
            "description": "1-Click action token for the order",
            "required": true,
            "schema": {
              "type": "string"
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
              "code": "https://restapi.ordergroove.com/one_click/delay/?days={{days}}&token={{event.action_token}}"
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