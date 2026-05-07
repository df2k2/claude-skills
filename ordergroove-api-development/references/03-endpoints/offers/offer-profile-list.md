# List

Lists all offer profiles for an individual User.

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)

  ✖️ [Storefront API Scope](https://developer.ordergroove.com/reference/authentication#storefront-api-scope)
</Callout>

### Standard Flex Incentives support:

The control for inclusion/filtering of standard flex incentives is made through the parameter `offer_profile_category` which has three possible values:

* `all` - Returns all offer profiles without SFI details.
* `all_with_standard_flex_incentives` - Returns all offer profiles, and includes SFI details for those that support it.
* `only_with_standard_flex_incentives` - Returns only offer profiles that contain SFI, and includes the SFI details.

## Response Body Definitions

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Name
      </th>

      <th>
        Type
      </th>

      <th>
        Description
      </th>

      <th>
        Example
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        public\_id
      </td>

      <td>
        string
      </td>

      <td>
        Unique Offer Profile ID
      </td>

      <td>
        "e3e9ac44a24f15e485b0bc764e107cf3"
      </td>
    </tr>

    <tr>
      <td>
        name
      </td>

      <td>
        string
      </td>

      <td>
        Name of Offer Profile
      </td>

      <td>
        Default Offer Profile
      </td>
    </tr>

    <tr>
      <td>
        merchant
      </td>

      <td>
        string
      </td>

      <td>
        Merchant ID
      </td>

      <td>
        "ac4f7938383a11e89ecbbc764e1107f2"
      </td>
    </tr>

    <tr>
      <td>
        live
      </td>

      <td>
        boolean
      </td>

      <td>
        True=active profile;\
        False=inactive profile
      </td>

      <td>
        true
      </td>
    </tr>

    <tr>
      <td>
        status
      </td>

      <td>
        string
      </td>

      <td>
        Offer profile status (available, archived)
      </td>

      <td>
        available
      </td>
    </tr>

    <tr>
      <td>
        weight
      </td>

      <td>
        integer
      </td>

      <td>
        Profile weight
      </td>

      <td>
        100 or 0
      </td>
    </tr>

    <tr>
      <td>
        offers
      </td>

      <td>
        array
      </td>

      <td>
        List of Offer IDs associated with the profile
      </td>

      <td>
        \["a748aa648ac811e8af3bbc764e106cf4"]
      </td>
    </tr>

    <tr>
      <td>
        recurring\_coupon
      </td>

      <td>
        object
      </td>

      <td>
        Recurring Coupon object
      </td>

      <td>
        \{} or null
      </td>
    </tr>

    <tr>
      <td>
        initial\_coupon
      </td>

      <td>
        object
      </td>

      <td>
        Initial Coupon object
      </td>

      <td>
        \{} or null
      </td>
    </tr>
  </tbody>
</Table>

## Response Body Definitions (Recurring Coupon Object)

| Name                       | Type   | Description                     | Example                                                                                                                         |
| :------------------------- | :----- | :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------ |
| public\_id                 | string | Unique Recurring Coupon ID      | "ff48e9fdc8eb4d79abd7c8c573523d25"                                                                                              |
| name                       | string | Recurring Coupon name           | "Demo Store Incentives"                                                                                                         |
| code                       | string | Recurring Coupon code           | "demo\_store"                                                                                                                   |
| discounts                  | object | Discounts object                | \{} or null                                                                                                                     |
| standard\_flex\_incentives | object | Standard Flex Incentives object | Returned only when offer\_profile\_category is all\_with\_standard\_flex\_incentives or only\_with\_standard\_flex\_incentives. |

## Response Body Definitions (Initial Coupon Object)

| Name                       | Type   | Description                     | Example                                                                                                                         |
| :------------------------- | :----- | :------------------------------ | :------------------------------------------------------------------------------------------------------------------------------ |
| public\_id                 | string | Unique Recurring Coupon ID      | "ff48e9fdc8eb4d79abd7c8c573523d25"                                                                                              |
| name                       | string | Recurring Coupon name           | "Demo Store Incentives"                                                                                                         |
| code                       | string | Recurring Coupon code           | "demo\_store"                                                                                                                   |
| discounts                  | object | Discounts object                | \{} or null                                                                                                                     |
| standard\_flex\_incentives | object | Standard Flex Incentives object | Returned only when offer\_profile\_category is all\_with\_standard\_flex\_incentives or only\_with\_standard\_flex\_incentives. |

## Response Body Definitions (Discounts Object)

| Name             | Type    | Description        | Example                            |
| :--------------- | :------ | :----------------- | :--------------------------------- |
| public\_id       | string  | Unique Discount ID | "c67dec11aedb4885aa9a58c3f89de746" |
| name             | string  | Discount name      | "Free shipping on orders over $50" |
| object           | integer |                    | 1                                  |
| type             | string  |                    | 2                                  |
| value            | string  | Discount value     | "100"                              |
| threshold\_field | integer |                    | 3                                  |
| threshold\_value | string  |                    | "50"                               |

## Response Body Definitions (Standard Flex Incentives Object)

| Name           | Type   | Description                                         | Example                            |
| :------------- | :----- | :-------------------------------------------------- | :--------------------------------- |
| public\_id     | string | Unique Standard Flex Incentive ID                   | "c67dec11aedb4885aa9a58c3f89de746" |
| offer\_profile | string | Parent Offer profile ID                             | "e3e9ac44a24f15e485b0bc764e107cf3" |
| criteria       | object | Criteria tree that determines when incentives apply | \{}                                |
| incentives     | array  | One or more incentive definitions                   | \{}                                |

## Response Body Definitions (Criteria Node Object)

| Name             | Type   | Description                                                            | Example      |
| :--------------- | :----- | :--------------------------------------------------------------------- | :----------- |
| node\_type       | string | Specifies the type of node. (AND, OR, NOT, PREMISE)                    | “PREMISE”    |
| children         | array  | AND, OR nodes have two children.                                       | \[] or null  |
| standard         | string | The SFI standard / type                                                | “PSI”        |
| premise\_value   | string | Type will depend on the standard. Can be an in, array, string or none. | “10”         |
| premise\_operand | string | The comparison operator that will be used to the premise               | “LESS\_THAN” |

## Response Body Definitions (Incentive Object)

| Name              | Type   | Description                                                                                        | Example             |
| :---------------- | :----- | :------------------------------------------------------------------------------------------------- | :------------------ |
| incentive\_type   | string | discount\_percent, discount\_amount, gift                                                          | “discount\_percent” |
| incentive\_value  | mixed  | Must be 0-100 for discount\_percent incentive types. Must be the "external\_product\_id" for gifts | 20                  |
| incentive\_target | string | order, item, shipping                                                                              | “order”             |
| threshold\_field  | string | Type will depend on the standard. Can be an in, array, string or none.                             | “”                  |
| threshold\_value  | string | The comparison operator that will be used to the premise                                           | “”                  |

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
    "/offer_profiles/": {
      "get": {
        "summary": "List",
        "description": "Lists all offer profiles for an individual User.",
        "operationId": "offer-profile-list",
        "parameters": [
          {
            "name": "offer_profile_category",
            "in": "query",
            "description": "Controls inclusion/filtering of offer profiles with SFI.",
            "schema": {
              "type": "string",
              "enum": [
                "all",
                "all_with_standard_flex_incentives",
                "only_with_standard_flex_incentives"
              ]
            }
          },
          {
            "in": "query",
            "name": "status",
            "schema": {
              "type": "string",
              "default": "available",
              "enum": [
                "available",
                "archived",
                "all"
              ]
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
                    "value": {
                      "public_id": "e3e9ac44a24f15e485b0bc764e107cf3",
                      "name": "offer profile name",
                      "weight": 100,
                      "live": true,
                      "status": "available",
                      "offers": [
                        "a748aa648ac811e8af3bbc764e106cf4"
                      ],
                      "recurring_coupon": {
                        "public_id": "ff48e9fdc8eb4d79abd7c8c573523d25",
                        "name": "Demo Store Incentives",
                        "code": "demo_store",
                        "discounts": [
                          {
                            "public_id": "c67dec11aedb4885aa9a58c3f89de746",
                            "name": "Free shipping on orders over $50",
                            "object": 1,
                            "field": 2,
                            "type": "Free discount_percent",
                            "value": "100",
                            "threshold_field": 3,
                            "threshold_value": "50"
                          }
                        ]
                      },
                      "initial_coupon": {
                        "public_id": "ff48e9fdc8eb4d79abd7c8c573523d25",
                        "name": "Demo Store Incentives",
                        "code": "demo_store",
                        "discounts": [
                          {
                            "public_id": "c67dec11aedb4885aa9a58c3f89de746",
                            "name": "Free shipping on orders over $50",
                            "object": 1,
                            "field": 2,
                            "type": "Free discount_percent",
                            "value": "100",
                            "threshold_field": 3,
                            "threshold_value": "50"
                          }
                        ]
                      }
                    }
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "public_id": {
                      "type": "string",
                      "example": "e3e9ac44a24f15e485b0bc764e107cf3"
                    },
                    "name": {
                      "type": "string",
                      "example": "offer profile name"
                    },
                    "live": {
                      "type": "boolean",
                      "default": "true"
                    },
                    "status": {
                      "type": "string",
                      "default": "available",
                      "enum": [
                        "available",
                        "archived"
                      ]
                    },
                    "weight": {
                      "type": "integer",
                      "example": 100,
                      "default": 0
                    },
                    "offers": {
                      "type": "array",
                      "items": {
                        "type": "string",
                        "example": "a748aa648ac811e8af3bbc764e106cf4"
                      }
                    },
                    "recurring_coupon": {
                      "type": "object",
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "example": "ff48e9fdc8eb4d79abd7c8c573523d25"
                        },
                        "name": {
                          "type": "string",
                          "example": "Demo Store Incentives"
                        },
                        "code": {
                          "type": "string",
                          "example": "demo_store"
                        },
                        "discounts": {
                          "type": "array",
                          "items": {
                            "type": "object",
                            "properties": {
                              "public_id": {
                                "type": "string",
                                "example": "c67dec11aedb4885aa9a58c3f89de746"
                              },
                              "name": {
                                "type": "string",
                                "example": "Free shipping on orders over $50"
                              },
                              "object": {
                                "type": "integer",
                                "example": 1,
                                "default": 0
                              },
                              "field": {
                                "type": "integer",
                                "example": 2,
                                "default": 0
                              },
                              "type": {
                                "type": "string",
                                "example": "Free discount_percent"
                              },
                              "value": {
                                "type": "string",
                                "example": "100"
                              },
                              "threshold_field": {
                                "type": "integer",
                                "example": 3,
                                "default": 0
                              },
                              "threshold_value": {
                                "type": "string",
                                "example": "50"
                              }
                            }
                          }
                        }
                      }
                    },
                    "initial_coupon": {
                      "type": "object",
                      "properties": {
                        "public_id": {
                          "type": "string",
                          "example": "ff48e9fdc8eb4d79abd7c8c573523d25"
                        },
                        "name": {
                          "type": "string",
                          "example": "Demo Store Incentives"
                        },
                        "code": {
                          "type": "string",
                          "example": "demo_store"
                        },
                        "discounts": {
                          "type": "array",
                          "items": {
                            "type": "object",
                            "properties": {
                              "public_id": {
                                "type": "string",
                                "example": "c67dec11aedb4885aa9a58c3f89de746"
                              },
                              "name": {
                                "type": "string",
                                "example": "Free shipping on orders over $50"
                              },
                              "object": {
                                "type": "integer",
                                "example": 1,
                                "default": 0
                              },
                              "field": {
                                "type": "integer",
                                "example": 2,
                                "default": 0
                              },
                              "type": {
                                "type": "string",
                                "example": "Free discount_percent"
                              },
                              "value": {
                                "type": "string",
                                "example": "100"
                              },
                              "threshold_field": {
                                "type": "integer",
                                "example": 3,
                                "default": 0
                              },
                              "threshold_value": {
                                "type": "string",
                                "example": "50"
                              }
                            }
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