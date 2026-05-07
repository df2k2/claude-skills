# Cancel

Cancels an order.  If the order is associated with a subscription, the subsequent order will be created based on its set frequency.

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
        Example
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td style={{ textAlign: "left" }}>
        merchant
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Merchant ID
      </td>

      <td style={{ textAlign: "left" }}>
        "275dbe1d77f34aca968fb75a8dbb4c82"
      </td>
    </tr>

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
        "11100-C01"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        payment
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Payment record ID
      </td>

      <td style={{ textAlign: "left" }}>
        "25e4d2761d294dd48efd96fdf668a2d9"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        shipping\_address
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Shipping address record ID
      </td>

      <td style={{ textAlign: "left" }}>
        "03197d2512904301aaed774a256e71c8"
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
        Order ID
      </td>

      <td style={{ textAlign: "left" }}>
        "f9cb2f93e1c845eb9de9eff46ddb3cbf"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        sub\_total
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Subtotal of items in order
      </td>

      <td style={{ textAlign: "left" }}>
        "285.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        tax\_total
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Tax applied to order
      </td>

      <td style={{ textAlign: "left" }}>
        "22.44"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        shipping\_total
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Shipping cost applied to order
      </td>

      <td style={{ textAlign: "left" }}>
        "0.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        discount\_total
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Discount applied to order
      </td>

      <td style={{ textAlign: "left" }}>
        "15.00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        total
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Total price of order
      </td>

      <td style={{ textAlign: "left" }}>
        "undefined"
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
        Date created
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29 00:00:00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        place
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date for order placement
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29 00:00:00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        cancelled
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date of cancellation;

        'null' = not cancelled
      </td>

      <td style={{ textAlign: "left" }}>
        "null"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        tries
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Number of order attempts
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        generic\_error\_count
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        0
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        status
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Order status
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        type
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Order Type
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        order\_merchant\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Order ID in your system
      </td>

      <td style={{ textAlign: "left" }}>
        "301617"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        rejected\_message
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Rejection message from merchant
      </td>

      <td style={{ textAlign: "left" }}>
        ""
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        extra\_data
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Raw JSON string that should be JSON.parse() as key/value store for any extra information
      </td>

      <td style={{ textAlign: "left" }}>
        "\{"some": "extra", "fields": "here"}"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        locked
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        false
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        oos\_free\_shipping
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        false
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
    "/orders/{order_id}/cancel/": {
      "patch": {
        "summary": "Cancel",
        "description": "Cancels an order.  If the order is associated with a subscription, the subsequent order will be created based on its set frequency.",
        "operationId": "orders-cancel",
        "parameters": [
          {
            "name": "order_id",
            "in": "path",
            "description": "Unique order ID",
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
                    "value": "{\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"customer\": \"00026001\",\n    \"payment\": \"070001bc02fd11e99542bc764e1043b0\",\n    \"shipping_address\": \"66c25cd0564011e9abc5bc764e107990\",\n    \"public_id\": \"c4e05d04ccc411e8ada3bc764e101db1\",\n    \"sub_total\": \"22.90\",\n    \"tax_total\": \"0.00\",\n    \"shipping_total\": \"5.99\",\n    \"discount_total\": \"21.08\",\n    \"total\": \"28.89\",\n    \"created\": \"2018-10-10 14:43:32\",\n    \"place\": \"2019-06-06 12:08:37\",\n    \"cancelled\": \"2019-04-05 12:13:32\",\n    \"tries\": 1,\n    \"generic_error_count\": 0,\n    \"status\": 1,\n    \"type\": 1,\n    \"order_merchant_id\": \"\",\n    \"rejected_message\": \"\",\n    \"extra_data\": \"\",\n    \"locked\": false,\n    \"oos_free_shipping\": false\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "merchant": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2"
                    },
                    "customer": {
                      "type": "string",
                      "example": "00026001"
                    },
                    "payment": {
                      "type": "string",
                      "example": "070001bc02fd11e99542bc764e1043b0"
                    },
                    "shipping_address": {
                      "type": "string",
                      "example": "66c25cd0564011e9abc5bc764e107990"
                    },
                    "public_id": {
                      "type": "string",
                      "example": "c4e05d04ccc411e8ada3bc764e101db1"
                    },
                    "sub_total": {
                      "type": "string",
                      "example": "22.90"
                    },
                    "tax_total": {
                      "type": "string",
                      "example": "0.00"
                    },
                    "shipping_total": {
                      "type": "string",
                      "example": "5.99"
                    },
                    "discount_total": {
                      "type": "string",
                      "example": "21.08"
                    },
                    "total": {
                      "type": "string",
                      "example": "28.89"
                    },
                    "created": {
                      "type": "string",
                      "example": "2018-10-10 14:43:32"
                    },
                    "place": {
                      "type": "string",
                      "example": "2019-06-06 12:08:37"
                    },
                    "cancelled": {
                      "type": "string",
                      "example": "2019-04-05 12:13:32"
                    },
                    "tries": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "generic_error_count": {
                      "type": "integer",
                      "example": 0,
                      "default": 0
                    },
                    "status": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "type": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "order_merchant_id": {
                      "type": "string",
                      "example": ""
                    },
                    "rejected_message": {
                      "type": "string",
                      "example": ""
                    },
                    "extra_data": {
                      "type": "string",
                      "example": ""
                    },
                    "locked": {
                      "type": "boolean",
                      "example": false,
                      "default": true
                    },
                    "oos_free_shipping": {
                      "type": "boolean",
                      "example": false,
                      "default": true
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
                    "value": "{\n  \"[field_name]\": \"field_name error detail\"\n}\n"
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