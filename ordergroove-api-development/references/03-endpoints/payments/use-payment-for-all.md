# Use payment for all

Associates provided payment to all orders and subscriptions of a customer.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✔️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
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
    "/payments/{payment_id}/use_for_all/": {
      "post": {
        "summary": "Use payment for all",
        "description": "Associates provided payment to all orders and subscriptions of a customer.",
        "operationId": "use-payment-for-all",
        "parameters": [
          {
            "name": "payment_id",
            "in": "path",
            "description": "Unique Payment Id",
            "schema": {
              "type": "string"
            },
            "required": true
          }
        ],
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": ""
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
          },
          "404": {
            "description": "404",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"detail\": \"Unable to find requested asset.\"\n}\n"
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
        "deprecated": false,
        "x-readme": {
          "code-samples": [
            {
              "language": "shell",
              "code": "curl --request POST \\\n     --url 'https://restapi.ordergroove.com/payments/payment_id/use_for_all?api_key=null' \\\n     --header 'Accept: application/json' \\\n     --header 'Content-Type: application/json'"
            },
            {
              "language": "ruby",
              "code": "require 'uri'\nrequire 'net/http'\nrequire 'openssl'\n\nurl = URI(\"https://restapi.ordergroove.com/payments/payment_id/use_for_all?api_key=null\")\n\nhttp = Net::HTTP.new(url.host, url.port)\nhttp.use_ssl = true\n\nrequest = Net::HTTP::Post.new(url)\nrequest[\"Accept\"] = 'application/json'\nrequest[\"Content-Type\"] = 'application/json'\n\nresponse = http.request(request)\nputs response.read_body"
            },
            {
              "language": "php",
              "code": "<?php\nrequire_once('vendor/autoload.php');\n\n$client = new \\GuzzleHttp\\Client();\n\n$response = $client->request('POST', 'https://restapi.ordergroove.com/payments/payment_id/use_for_all?api_key=null', [\n  'headers' => [\n    'Accept' => 'application/json',\n    'Content-Type' => 'application/json',\n  ],\n]);\n\necho $response->getBody();"
            },
            {
              "language": "python",
              "code": "import requests\n\nurl = \"https://restapi.ordergroove.com/payments/payment_id/use_for_all?api_key=null\"\n\nheaders = {\n    \"Accept\": \"application/json\",\n    \"Content-Type\": \"application/json\"\n}\n\nresponse = requests.post(url, headers=headers)\n\nprint(response.text)"
            }
          ],
          "samples-languages": [
            "shell",
            "ruby",
            "php",
            "python"
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