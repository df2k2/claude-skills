# List

Returns a list of all merchant's products that are autoship enabled and not discontinued.

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
        "ac4f7938383a11e89ecbbc764e1107f2"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        groups
      </td>

      <td style={{ textAlign: "left" }}>
        array
      </td>

      <td style={{ textAlign: "left" }}>
        Array of group objects
      </td>

      <td style={{ textAlign: "left" }}>
        ```json
        [
          {
            "group_type": "foo",
            "name": "bar"
          }
        ]
        ```
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        name
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Product name
      </td>

      <td style={{ textAlign: "left" }}>
        "test"
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
        Product price
      </td>

      <td style={{ textAlign: "left" }}>
        "12.99"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        image\_url
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Product image URL
      </td>

      <td style={{ textAlign: "left" }}>
        "ordergroove.com/product/product\_id"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        detail\_url
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Product detail image URL
      </td>

      <td style={{ textAlign: "left" }}>
        "ordergroove.com/product/product\_id"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        external\_product\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Merchant product ID
      </td>

      <td style={{ textAlign: "left" }}>
        "62900-W01"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        sku
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Product SKU
      </td>

      <td style={{ textAlign: "left" }}>
        "123456789"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        autoship\_enabled
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }}>
        Autoship option enabled for product: enabled = true
      </td>

      <td style={{ textAlign: "left" }}>
        false
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        prepaid\_eligible
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }}>
        Product prepaid eligibility
      </td>

      <td style={{ textAlign: "left" }}>
        true
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        ~~premier\_enabled~~
      </td>

      <td style={{ textAlign: "left" }}>
        integer
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
        Date of product creation
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29 12:00:00"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        last\_update
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date of last product update
      </td>

      <td style={{ textAlign: "left" }}>
        "09/3099"
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
        Account status: active = True
      </td>

      <td style={{ textAlign: "left" }}>
        True
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        discontinued
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }}>
        Product status:\
        discontinued = True
      </td>

      <td style={{ textAlign: "left" }}>
        False
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
        "{\"some\": \"extra\", \"fields\": \"here\"}"
        ```
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        product\_type
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Product type
      </td>

      <td style={{ textAlign: "left" }}>
        "standard"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        autoship\_by\_default
      </td>

      <td style={{ textAlign: "left" }}>
        boolean
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }}>
        true
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
        30
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
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        offer\_profile
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Offer profile associated with product
      </td>

      <td style={{ textAlign: "left" }}>
        "OfferProfileId"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        incentive\_group
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }} />

      <td style={{ textAlign: "left" }} />
    </tr>
  </tbody>
</Table>

<br />

When the query param **?include\_product\_selection\_rules=true** is provided for a rotating product we will return all the selection rule configurations:

```json Time window
[
   {
      "public_id":"e1a61e620ed411ef8740767250df1ed7",
      "selection_rule_type":"TIME_WINDOW",
      "product_selection_list_elements":[
         {
            "public_id":"e1a626000ed411ef8740767250df1ed7",
            "product":"48398751432995",
            "starting_date":"2024-05-01T00:00:00Z"
         },
         {
            "public_id":"e1a62b140ed411ef8740767250df1ed7",
            "product":"48398752317731",
            "starting_date":"2024-06-01T00:00:00Z"
         },
         {
            "public_id":"e1a62fe20ed411ef8740767250df1ed7",
            "product":"48398760149283",
            "starting_date":"2024-07-01T00:00:00Z"
         }
      ],
      "configuration": {
            "reveal_moment": "ORDER_PLACEMENT",
            "pricing_policy": "BEST_PRICE"
        }
   }
]
```

```json Ordinal
[
   {
      "public_id":"e1a61e620ed411ef8740767250df1ed7",
      "selection_rule_type":"ORDINAL",
      "product_selection_list_elements":[
         {
            "public_id":"e1a626000ed411ef8740767250df1ed7",
            "product":"48398751432995",
            "starting_ordinal":"0"
         },
         {
            "public_id":"e1a62b140ed411ef8740767250df1ed7",
            "product":"48398752317731",
            "starting_ordinal":"1"
         },
         {
            "public_id":"e1a62fe20ed411ef8740767250df1ed7",
            "product":"48398760149283",
            "starting_ordinal":"4"
         }
      ],
      "configuration": {
            "reveal_moment": "ORDER_PLACEMENT",
            "cyclical_rotation_enabled": false,
            "pricing_policy": "BEST_PRICE"
        }
   }
]
```

When the query param **?include\_product\_resource\_grants=true** is provided for a rotating product we will return all plan\_product configuration:

```json
[
   {
       "resource": "c84a13fc8e904e0f80e6377b15f0464a",
       "product": "53485191069987",
       "public_id": "c0de05637e6e4828b8dc60cf1dc7af6f",
       "time_amount": 2592000,
       "grace_period": 86400,
       "created": "2025-05-28 13:56:05",
       "last_updated": "2025-05-29 16:46:20"
   },
   {
       "resource": "DSHUIGsgshuigsg80e89gffgh977758",
       "product": "53485191069987",
       "public_id": "7o8gh87fsf7dh87dhd7d988006ajjklf",
       "time_amount": 2592000,
       "grace_period": null,
       "created": "2025-05-28 13:56:05",
       "last_updated": "2025-06-09 20:12:43"
    }
]
```

When the query param **?include\_product\_free\_trials=true** is provided,\
a new field `product_free_trial_configurations` will be included in each product in the response.\
This field lists the free trial configurations associated with the product.\
If there are no free trial configurations for a given product, an empty array will be returned:

```json
[
   {
       "public_id": "9dcad53bf6b4446f873d5336e0e390b3",
       "duration_in_days": 15,
       "created": "2025-05-28 13:56:05",
       "last_updated": "2025-05-29 16:46:20"
   }
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
    "/products/": {
      "get": {
        "summary": "List",
        "description": "Returns a list of all merchant's products that are autoship enabled and not discontinued.",
        "operationId": "products-list",
        "parameters": [
          {
            "name": "search",
            "in": "query",
            "description": "A single string value used to search for products. The value in this parameter will be matched against product’s name, sku, or external_product_id, depending on the field specified in the \"fields\" parameter. e.g. /products?search=12345&fields=sku",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "fields",
            "in": "query",
            "description": "Specifies which field (name, sku, or external_product_id) the \"search\" parameter value should be matched against. name – Matches the search value against the product’s name. sku – Matches the search value against the product’s SKU. external_product_id – Matches the search value against the product’s external product ID. e.g. /products?search=12345&fields=sku",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "id_or_name",
            "in": "query",
            "description": "Case insensitive partial match for Product ID or Name",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "autoship_enabled",
            "in": "query",
            "description": "By default the endpoint will only return products that are autoship enabled, but you can change the behavior by passing \"all\" to return all products regardless of their autoship status. You can also pass \"false\" to only return products that are NOT autoship enabled",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "allow_discontinued",
            "in": "query",
            "description": "By default the endpoint returns non-discontinued products, but you can change the behavior by passing \"true\" to also include discontinued products. You can also pass \"strict\" to only list the discontinued products",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "group_name",
            "in": "query",
            "description": "Product group's name",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "group_type",
            "in": "query",
            "description": "Product group's type",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "autoship_by_default",
            "in": "query",
            "schema": {
              "type": "boolean"
            }
          },
          {
            "name": "live",
            "in": "query",
            "description": "Account status: active = True",
            "schema": {
              "type": "boolean"
            }
          },
          {
            "name": "external_product_ids[]",
            "in": "query",
            "description": "Product ID (could be passed multiple times in the query string to match multiple products). Note there is \"[]\" at the end of this field that is required",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "product_type",
            "in": "query",
            "description": "Product Type",
            "schema": {
              "type": "string",
              "enum": [
                "\"standard\"",
                "\"rotating\"",
                "\"static price bundle\"",
                "\"dynamic price bundle\""
              ]
            }
          },
          {
            "name": "include_product_selection_rules",
            "in": "query",
            "description": "For rotating products this param returns a product_selection_rules list with all selection_list_elements",
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
                    "value": "{\n    \"count\": 1,\n    \"next\": \"https://restapi.ordergroove.com/products/?page=2\",\n    \"previous\": null,\n    \"results\": [\n        {\n            \"merchant\": \"519f1f120e3411ef984b1e8a267ce85a\",\n            \"groups\": [\n                {\n                    \"name\": \"subscription\",\n                    \"group_type\": \"eligibility\"\n                }\n            ],\n            \"name\": \"Medium Roast Coffee Bag\",\n            \"price\": \"10.00\",\n            \"image_url\": \"image-url\",\n            \"detail_url\": \"product-url\",\n            \"external_product_id\": \"48398751432995\",\n            \"sku\": \"48398751432995\",\n            \"autoship_enabled\": true,\n            \"premier_enabled\": 0,\n            \"created\": \"2024-05-09 15:20:09\",\n            \"last_update\": \"2024-05-13 08:56:36\",\n            \"live\": true,\n            \"discontinued\": false,\n            \"extra_data\": null,\n            \"product_type\": \"standard\",\n            \"autoship_by_default\": true,\n            \"every\": null,\n            \"every_period\": null,\n            \"offer_profile\": null,\n            \"incentive_group\": null\n        },\n        {\n            \"merchant\": \"519f1f120e3411ef984b1e8a267ce85a\",\n            \"groups\": [\n                {\n                    \"group_type\": \"eligibility\",\n                    \"name\": \"prepaid\"\n                },\n                {\n                    \"name\": \"subscription\",\n                    \"group_type\": \"eligibility\"\n                }\n            ],\n            \"name\": \"Coffee Bag Subscription Club\",\n            \"price\": \"10.00\",\n            \"image_url\": \"image-url\",\n            \"detail_url\": \"product-url\",\n            \"external_product_id\": \"48398725906723\",\n            \"sku\": \"48398725906723\",\n            \"autoship_enabled\": true,\n            \"premier_enabled\": 0,\n            \"created\": \"2024-05-09 15:14:36\",\n            \"last_update\": \"2024-05-13 08:56:36\",\n            \"live\": true,\n            \"discontinued\": false,\n            \"extra_data\": null,\n            \"product_type\": \"rotating\",\n            \"autoship_by_default\": true,\n            \"every\": null,\n            \"every_period\": null,\n            \"offer_profile\": null,\n            \"incentive_group\": null\n        }\n    ]\n}"
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
                      "example": "https://restapi.ordergroove.com/products/?page=2"
                    },
                    "previous": {},
                    "results": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "merchant": {
                            "type": "string",
                            "example": "519f1f120e3411ef984b1e8a267ce85a"
                          },
                          "groups": {
                            "type": "array",
                            "items": {
                              "type": "object",
                              "properties": {
                                "name": {
                                  "type": "string",
                                  "example": "subscription"
                                },
                                "group_type": {
                                  "type": "string",
                                  "example": "eligibility"
                                }
                              }
                            }
                          },
                          "name": {
                            "type": "string",
                            "example": "Medium Roast Coffee Bag"
                          },
                          "price": {
                            "type": "string",
                            "example": "10.00"
                          },
                          "image_url": {
                            "type": "string",
                            "example": "image-url"
                          },
                          "detail_url": {
                            "type": "string",
                            "example": "product-url"
                          },
                          "external_product_id": {
                            "type": "string",
                            "example": "48398751432995"
                          },
                          "sku": {
                            "type": "string",
                            "example": "48398751432995"
                          },
                          "autoship_enabled": {
                            "type": "boolean",
                            "example": true,
                            "default": true
                          },
                          "premier_enabled": {
                            "type": "integer",
                            "example": 0,
                            "default": 0
                          },
                          "created": {
                            "type": "string",
                            "example": "2024-05-09 15:20:09"
                          },
                          "last_update": {
                            "type": "string",
                            "example": "2024-05-13 08:56:36"
                          },
                          "live": {
                            "type": "boolean",
                            "example": true,
                            "default": true
                          },
                          "discontinued": {
                            "type": "boolean",
                            "example": false,
                            "default": true
                          },
                          "extra_data": {},
                          "product_type": {
                            "type": "string",
                            "example": "standard"
                          },
                          "autoship_by_default": {
                            "type": "boolean",
                            "example": true,
                            "default": true
                          },
                          "every": {},
                          "every_period": {},
                          "offer_profile": {},
                          "incentive_group": {}
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