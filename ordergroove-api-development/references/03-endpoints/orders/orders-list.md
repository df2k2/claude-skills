# List

Lists all of a single user’s orders.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope (including with trust\_level: recognized)

  Note: Application API Scope with Bulk Operations permission is required to list orders for more than one customer.
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
        Order Public ID
      </td>

      <td style={{ textAlign: "left" }}>
        "f9cb2f93e1c845eb9de9eff46ddb3cbf"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        currency\_code
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Three letter ISO currency code
      </td>

      <td style={{ textAlign: "left" }}>
        "USD"
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
        Date time the order was created
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29 00:00:00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        updated
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date time the order was last modified
      </td>

      <td style={{ textAlign: "left" }}>
        "2025-02-29 00:00:00"
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

When the query param **?include\_has\_plan=true** is provided, each order object in the response will include a **has\_plan** boolean field indicating whether the order contains at least one product with product\_type=plan.

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
    "/orders/": {
      "get": {
        "summary": "List",
        "description": "Lists all of a single user’s orders.",
        "operationId": "orders-list",
        "parameters": [
          {
            "name": "status",
            "in": "query",
            "description": "Order status",
            "schema": {
              "type": "integer",
              "format": "int32"
            }
          },
          {
            "name": "subscription",
            "in": "query",
            "description": "Subscription ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "customer",
            "in": "query",
            "description": "Customer ID (only available in API user scope)",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "place",
            "in": "query",
            "description": "Order's place date exact match (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "place_start",
            "in": "query",
            "description": "Order's place date later or equal than parameter (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "place_end",
            "in": "query",
            "description": "Order's place date sooner or equal than parameter (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created",
            "in": "query",
            "description": "Orders whose created date matches exactly (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_start",
            "in": "query",
            "description": "Orders whose created datetime is greater than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_end",
            "in": "query",
            "description": "Orders whose created datetime is less than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated",
            "in": "query",
            "description": "Orders whose updated date matches exactly (yyyy-mm-dd). On order creation it is populated with same value as created field.",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated_start",
            "in": "query",
            "description": "Orders whose updated datetime is greater than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated_end",
            "in": "query",
            "description": "Orders whose updated datetime is less than or equal to the given datetime (yyyy-mm-dd or yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "include_has_plan",
            "in": "query",
            "description": "If true, each order object in the response includes a has_plan field indicating whether that order contains at least one product with product_type=plan",
            "schema": {
              "type": "boolean",
              "default": false
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
                    "value": "{\n\"results\": [\n        {\n            \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n            \"customer\": \"00026001\",\n            \"payment\": \"394a7f26d61611e88b4abc764e1043b0\",\n            \"shipping_address\": \"c4cd7f86ccc411e8ada3bc764e101db1\",\n            \"public_id\": \"6120b166d62d11e8aaf0bc764e107990\",\n            \"sub_total\": \"95.12\",\n            \"tax_total\": \"0.00\",\n            \"shipping_total\": \"0.00\",\n            \"discount_total\": \"91.78\",\n            \"total\": \"95.12\",\n            \"created\": \"2018-10-22 14:05:02\",\n            \"updated\": \"2018-10-22 14:05:02\",\n            \"place\": \"2018-10-22 15:06:25\",\n            \"cancelled\": null,\n            \"tries\": 1,\n            \"generic_error_count\": 0,\n            \"status\": 3,\n            \"type\": 1,\n            \"order_merchant_id\": null,\n            \"rejected_message\": \"{\\\"message\\\": \\\"Unable to ingest order 2938617 into D365. Unable to find any PaymentToken against the provided CustomerProfileID\\\", \\\"code\\\": \\\"020\\\"}\",\n            \"extra_data\": null,\n            \"locked\": false,\n            \"oos_free_shipping\": false\n        }\n    ] \n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "results": {
                      "type": "array",
                      "items": {
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
                            "example": "394a7f26d61611e88b4abc764e1043b0"
                          },
                          "shipping_address": {
                            "type": "string",
                            "example": "c4cd7f86ccc411e8ada3bc764e101db1"
                          },
                          "public_id": {
                            "type": "string",
                            "example": "6120b166d62d11e8aaf0bc764e107990"
                          },
                          "sub_total": {
                            "type": "string",
                            "example": "95.12"
                          },
                          "tax_total": {
                            "type": "string",
                            "example": "0.00"
                          },
                          "shipping_total": {
                            "type": "string",
                            "example": "0.00"
                          },
                          "discount_total": {
                            "type": "string",
                            "example": "91.78"
                          },
                          "total": {
                            "type": "string",
                            "example": "95.12"
                          },
                          "created": {
                            "type": "string",
                            "example": "2018-10-22 14:05:02"
                          },
                          "updated": {
                            "type": "string",
                            "example": "2018-10-22 14:05:02"
                          },
                          "place": {
                            "type": "string",
                            "example": "2018-10-22 15:06:25"
                          },
                          "cancelled": {},
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
                            "example": 3,
                            "default": 0
                          },
                          "type": {
                            "type": "integer",
                            "example": 1,
                            "default": 0
                          },
                          "order_merchant_id": {},
                          "rejected_message": {
                            "type": "string",
                            "example": "{\"message\": \"Unable to ingest order 2938617 into D365. Unable to find any PaymentToken against the provided CustomerProfileID\", \"code\": \"020\"}"
                          },
                          "extra_data": {},
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