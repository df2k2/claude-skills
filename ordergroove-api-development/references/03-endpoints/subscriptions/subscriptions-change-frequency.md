# Change Frequency

Changes how often to place an order.

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
        array of objects: `{`<br />
        `public_id:string`<br />
        `quantity:integer`<br />
        `product:string`<br />
        `}`
      </td>

      <td style={{ textAlign: "left" }}>
        New Bundle components
      </td>

      <td style={{ textAlign: "left" }}>
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
        ```json
        {"some": "extra", "fields": "here"}
        ```
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
        Date of subscription cancellation;<br />
        null=not cancelled.
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
        True=active subscription;<br />
        False=inactive subscription
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
        [Prepaid information](https://developer.ordergroove.com/reference/prepaid-subscriptions#prepaid-subscriptions-data)<br />
        Returned only if prepaid is enabled
      </td>

      <td style={{ textAlign: "left" }}>
        ```json
        {
          "prepaid_orders_remaining": 0,
          "prepaid_orders_per_billing": 3,
          "renewal_behavior": "autorenew",
          "last_renewal_revenue": 100.8,
          "prepaid_origin_merchant_order_id": "#3082"
        }
        ```

        or `{}`
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
    "/subscriptions/{subscription_id}/change_frequency/": {
      "patch": {
        "summary": "Change Frequency",
        "description": "Changes how often to place an order.",
        "operationId": "subscriptions-change-frequency",
        "parameters": [
          {
            "name": "subscription_id",
            "in": "path",
            "description": "Unique subscription ID",
            "schema": {
              "type": "string"
            },
            "required": true
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "required": [
                  "every",
                  "every_period"
                ],
                "properties": {
                  "every": {
                    "type": "integer",
                    "description": "Number of periods",
                    "format": "int32"
                  },
                  "every_period": {
                    "type": "integer",
                    "description": "Type of period",
                    "format": "int32"
                  }
                }
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "200",
            "content": {
              "application/json": {
                "examples": {
                  "Result": {
                    "value": "{\n    \"customer\": \"00026001\",\n    \"merchant\": \"ac4f7938383a11e89ecbbc764e1107f2\",\n    \"product\": \"0070000693\",\n    \"payment\": \"070001bc02fd11e99542bc764e1043b0\",\n    \"shipping_address\": \"66c25cd0564011e9abc5bc764e107990\",\n    \"offer\": \"a748aa648ac811e8af3bbc764e106cf4\",\n    \"subscription_type\": \"replenishment\",\n    \"components\": [],\n    \"extra_data\": {},\n    \"public_id\": \"607daa2accc811e88516bc764e106cf4\",\n    \"product_attribute\": null,\n    \"quantity\": 21,\n    \"price\": null,\n    \"frequency_days\": 180,\n    \"reminder_days\": 10,\n    \"every\": 6,\n    \"every_period\": 3,\n    \"start_date\": \"2018-12-27\",\n    \"cancelled\": null,\n    \"cancel_reason\": null,\n    \"cancel_reason_code\": null,\n    \"iteration\": null,\n    \"sequence\": null,\n    \"session_id\": \"ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086\",\n    \"merchant_order_id\": \"2906548\",\n    \"customer_rep\": null,\n    \"club\": null,\n    \"created\": \"2018-10-10 15:09:21\",\n    \"updated\": \"2019-04-04 11:28:39\",\n    \"live\": true\n}\n"
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "customer": {
                      "type": "string",
                      "example": "00026001"
                    },
                    "merchant": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2"
                    },
                    "product": {
                      "type": "string",
                      "example": "0070000693"
                    },
                    "payment": {
                      "type": "string",
                      "example": "070001bc02fd11e99542bc764e1043b0"
                    },
                    "shipping_address": {
                      "type": "string",
                      "example": "66c25cd0564011e9abc5bc764e107990"
                    },
                    "offer": {
                      "type": "string",
                      "example": "a748aa648ac811e8af3bbc764e106cf4"
                    },
                    "subscription_type": {
                      "type": "string",
                      "example": "replenishment"
                    },
                    "components": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {}
                      }
                    },
                    "extra_data": {
                      "type": "object",
                      "properties": {}
                    },
                    "public_id": {
                      "type": "string",
                      "example": "607daa2accc811e88516bc764e106cf4"
                    },
                    "product_attribute": {},
                    "quantity": {
                      "type": "integer",
                      "example": 21,
                      "default": 0
                    },
                    "price": {},
                    "frequency_days": {
                      "type": "integer",
                      "example": 180,
                      "default": 0
                    },
                    "reminder_days": {
                      "type": "integer",
                      "example": 10,
                      "default": 0
                    },
                    "every": {
                      "type": "integer",
                      "example": 6,
                      "default": 0
                    },
                    "every_period": {
                      "type": "integer",
                      "example": 3,
                      "default": 0
                    },
                    "start_date": {
                      "type": "string",
                      "example": "2018-12-27"
                    },
                    "cancelled": {},
                    "cancel_reason": {},
                    "cancel_reason_code": {},
                    "iteration": {},
                    "sequence": {},
                    "session_id": {
                      "type": "string",
                      "example": "ac4f7938383a11e89ecbbc764e1107f2.896371.1539022086"
                    },
                    "merchant_order_id": {
                      "type": "string",
                      "example": "2906548"
                    },
                    "customer_rep": {},
                    "club": {},
                    "created": {
                      "type": "string",
                      "example": "2018-10-10 15:09:21"
                    },
                    "updated": {
                      "type": "string",
                      "example": "2019-04-04 11:28:39"
                    },
                    "live": {
                      "type": "boolean",
                      "example": true,
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