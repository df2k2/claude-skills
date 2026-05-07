# List

Returns a list all of customer subscriptions for a merchant, or a list of subscriptions for an individual customer.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope

  Note: Application API Scope with Bulk Operations permission is required to list subscriptions for more than one customer.
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
        customer
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Customer ID
      </td>

      <td style={{ textAlign: "left" }}>
        `"00026001"`
      </td>
    </tr>

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
        `"ac4f7938383a11e89ecbbc764e1107f2"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        product
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Product ID
      </td>

      <td style={{ textAlign: "left" }}>
        `"0070000693"`
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
        `"070001bc02fd11e99542bc764e1043b0"`
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
        `"66c25cd0564011e9abc5bc764e107990"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        offer
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Offer ID
      </td>

      <td style={{ textAlign: "left" }}>
        `"a748aa648ac811e8af3bbc764e106cf4"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        subscription\_type
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Subscription Type
      </td>

      <td style={{ textAlign: "left" }}>
        `"Replenish"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        components
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Legacy Bundle components
      </td>

      <td style={{ textAlign: "left" }}>
        `"product_id_1,product_id_2"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        components
      </td>

      <td style={{ textAlign: "left" }}>
        array of objects
      </td>

      <td style={{ textAlign: "left" }}>
        New Bundle components
      </td>

      <td style={{ textAlign: "left" }}>
        See example below
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
        Raw JSON string that should be JSON.parse() as key/value store for any extra information.
      </td>

      <td style={{ textAlign: "left" }}>
        See example below
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
        Subscription ID
      </td>

      <td style={{ textAlign: "left" }}>
        `"f9cb2f93e1c845eb9de9eff46ddb3cbf"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        product\_attribute
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        `"null"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        quantity
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Number of items
      </td>

      <td style={{ textAlign: "left" }}>
        `21`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        price
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Price

        **Note**: Usually passed as "null" unless you explicitly lock a subscription price
      </td>

      <td style={{ textAlign: "left" }}>
        `"12.99"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        frequency\_days
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Order placement interval in days
      </td>

      <td style={{ textAlign: "left" }}>
        `42`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        reminder\_days
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Days before order placement to email reminder (minimum of 5)
      </td>

      <td style={{ textAlign: "left" }}>
        `42`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        every
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Number of periods
      </td>

      <td style={{ textAlign: "left" }}>
        `6`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        every\_period
      </td>

      <td style={{ textAlign: "left" }}>
        integer
      </td>

      <td style={{ textAlign: "left" }}>
        Type of period
      </td>

      <td style={{ textAlign: "left" }}>
        `3`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        start\_date
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date of subscription start, in format YYYY-MM-DD
      </td>

      <td style={{ textAlign: "left" }}>
        `"2019-07-21"`
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
        Date of subscription cancellation; null=not cancelled.
      </td>

      <td style={{ textAlign: "left" }}>
        `"null"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        cancel\_reason
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Pipe-delimited cancel reason code and cancel reason details
      </td>

      <td style={{ textAlign: "left" }}>
        `"4|Overstocked"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        cancel\_reason\_code
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Cancel reason code
      </td>

      <td style={{ textAlign: "left" }}>
        `"4"`
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
        `"USD"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        ~~iteration~~
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        *Deprecated*
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        ~~sequence~~
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        *Deprecated*
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        session\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Session ID, obtained from og\_session\_id cookie
      </td>

      <td style={{ textAlign: "left" }}>
        `"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        merchant\_order\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Order ID in your system
      </td>

      <td style={{ textAlign: "left" }}>
        `"301617"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        ~~customer\_rep~~
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        *Deprecated*
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        ~~club~~
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        *Deprecated*
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
        `"2017-02-29 12:00:00"`
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
        Date updated
      </td>

      <td style={{ textAlign: "left" }}>
        `"2017-02-29 12:00:00"`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        live
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }}>
        True=active subscription; False=inactive subscription
      </td>

      <td style={{ textAlign: "left" }}>
        `True`
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        prepaid\_subscription\_context
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        [Prepaid information](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data) (Returned only if prepaid is enabled)
      </td>

      <td style={{ textAlign: "left" }}>
        See example below
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        free\_trial\_subscription\_context
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Returned only if subscription has free trial
      </td>

      <td style={{ textAlign: "left" }}>
        See example below
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        grantees
      </td>

      <td style={{ textAlign: "left" }}>
        array
      </td>

      <td style={{ textAlign: "left" }}>
        list of grantees that a subscription has
      </td>

      <td style={{ textAlign: "left" }}>
        See example below
      </td>
    </tr>
  </tbody>
</Table>

## JSON Examples

### New Bundle Components Example

```json
[  
  {  
    "public_id": "79d2dc76245111eeb185acde48001122",  
    "quantity": 1,  
    "product": "0070067690"  
  },  
  {  
    "public_id": "7eeaa504245111eeb185acde48001122",  
    "quantity": 3,  
    "product": "0070067691"  
  }  
]
```

### Extra Data Example

```json
{"some": "extra", "fields": "here"}
```

### Prepaid Subscription Context Example

```json
{
  "prepaid_orders_remaining": 0,
  "prepaid_orders_per_billing": 3,
  "renewal_behavior": "autorenew",
  "last_renewal_revenue": 100.8,
  "prepaid_origin_merchant_order_id": "#3082"
}
```

### Free Trial Subscription Context Example

```json
{
  "product": "53485191069987",
  "days": 15,
  "conversion_item": 38998940,
  "expiration": "2025-09-23T13:12:22.704013",
  "is_in_free_trial": false
}
```

<br />

### Grantees Example

```json
[
  {
    "external_id": "abc",
		"name": "Grantee 1"
  },
  {
    "external_id": "def",
		"name": "Grantee 2"
  },
]
```

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
    "/subscriptions/": {
      "get": {
        "summary": "List",
        "description": "Returns a list all of customer subscriptions for a merchant, or a list of subscriptions for an individual customer.",
        "operationId": "subscriptions-list",
        "parameters": [
          {
            "name": "live",
            "in": "query",
            "description": "Subscription status: active (True) or inactive (False)",
            "schema": {
              "type": "array",
              "items": {
                "type": "boolean"
              }
            }
          },
          {
            "name": "product",
            "in": "query",
            "description": "Unique product identifier",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "shipping_address",
            "in": "query",
            "description": "Address ID",
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
            "name": "created",
            "in": "query",
            "description": "Subscription's created date exact match (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_start",
            "in": "query",
            "description": "Subscription's created date later or equal than parameter (yyyy-mm-dd)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "created_end",
            "in": "query",
            "description": "Subscription's created date sooner or equal than parameter (yyyy-mm-dd)",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "updated",
            "in": "query",
            "description": "Subscription's updated date exact match (yyyy-mm-dd). On subscription creation is populated with same value as created field.",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated_start",
            "in": "query",
            "description": "Subscription's updated datetime later or equal than parameter (yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
            }
          },
          {
            "name": "updated_end",
            "in": "query",
            "description": "Subscription's updated date time is sooner or equal than parameter (yyyy-mm-ddThh:mm:ss)",
            "schema": {
              "type": "string",
              "format": "date"
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
                    "value": "{\n  \"count\": 1,\n  \"next\": \"https://restapi.ordergroove.com/subscriptions/?page=1\",\n  \"previous\": \"https://restapi.ordergroove.com/subscriptions/?page=3\",\n  \"results\": [\n    {\n      \"public_id\": \"f9cb2f93e1c845eb9de9eff46ddb3cbf\",\n      \"product_attribute\": null,\n      \"price\": \"12.99\",\n      \"frequency_days\": 42,\n      \"reminder_days\": 42,\n      \"start_date\": \"2017-02-29 12:00:00\",\n      \"cancelled\": null,\n      \"cancel_reason_code\": \"4|\",\n      \"cancel_reason\": \"4|Overstocked\",\n      \"merchant_order_id\": \"301617\",\n      \"subscription_type\": \"Replenish\",\n      \"components\": [\n        {  \n      \t\t\"public_id\": \"79d2dc76245111eeb185acde48001122\",  \n    \t\t  \"quantity\": 1,  \n    \t\t  \"product\": \"0070067690\"  \n   \t\t  },  \n    \t\t{  \n     \t\t  \"public_id\": \"7eeaa504245111eeb185acde48001122\",  \n      \t  \"quantity\": 3,  \n      \t  \"product\": \"0070067691\"  \n    \t\t}  \n      ],\n      \"created\": \"2017-02-29 12:00:00\",\n      \"updated\": \"2017-02-29 12:00:00\",\n      \"extra_data\": \"{\\\"some\\\": \\\"extra\\\", \\\"fields\\\": \\\"here\\\"}\",\n      \"live\": \"True\"\n    }\n  ]\n}"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "count": {
                      "type": "integer",
                      "example": 1,
                      "default": 0
                    },
                    "next": {
                      "type": "string",
                      "example": "https://restapi.ordergroove.com/subscriptions/?page=1"
                    },
                    "previous": {
                      "type": "string",
                      "example": "https://restapi.ordergroove.com/subscriptions/?page=3"
                    },
                    "results": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "public_id": {
                            "type": "string",
                            "example": "f9cb2f93e1c845eb9de9eff46ddb3cbf"
                          },
                          "product_attribute": {},
                          "price": {
                            "type": "string",
                            "example": "12.99"
                          },
                          "frequency_days": {
                            "type": "integer",
                            "example": 42,
                            "default": 0
                          },
                          "reminder_days": {
                            "type": "integer",
                            "example": 42,
                            "default": 0
                          },
                          "start_date": {
                            "type": "string",
                            "example": "2017-02-29 12:00:00"
                          },
                          "cancelled": {},
                          "cancel_reason_code": {
                            "type": "string",
                            "example": "4|"
                          },
                          "cancel_reason": {
                            "type": "string",
                            "example": "4|Overstocked"
                          },
                          "merchant_order_id": {
                            "type": "string",
                            "example": "301617"
                          },
                          "subscription_type": {
                            "type": "string",
                            "example": "Replenish"
                          },
                          "components": {
                            "type": "array",
                            "items": {
                              "type": "object",
                              "properties": {
                                "public_id": {
                                  "type": "string",
                                  "example": "79d2dc76245111eeb185acde48001122"
                                },
                                "quantity": {
                                  "type": "integer",
                                  "example": 1,
                                  "default": 0
                                },
                                "product": {
                                  "type": "string",
                                  "example": "0070067690"
                                }
                              }
                            }
                          },
                          "created": {
                            "type": "string",
                            "example": "2017-02-29 12:00:00"
                          },
                          "updated": {
                            "type": "string",
                            "example": "2017-02-29 12:00:00"
                          },
                          "extra_data": {
                            "type": "string",
                            "example": "{\"some\": \"extra\", \"fields\": \"here\"}"
                          },
                          "live": {
                            "type": "string",
                            "example": "True"
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