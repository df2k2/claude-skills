# List

List entitlements associated to merchant's customers. Only relevant for merchants offering digital products.

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
        public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Entitlement ID
      </td>

      <td style={{ textAlign: "left" }}>
        "c4cd7f86ccc411e8ada3bc764e101db1"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        merchant\_user\_id
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
        initial\_activation\_date
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Initial activation date (UTC)
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        latest\_activation\_date
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Latest activation date (UTC)
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        grace\_period
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Grace period in seconds
      </td>

      <td style={{ textAlign: "left" }}>
        86400
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        live
      </td>

      <td style={{ textAlign: "left" }}>
        bool
      </td>

      <td style={{ textAlign: "left" }}>
        Whether the resource associated with this entitlement is accessible (considers grace\_period)
      </td>

      <td style={{ textAlign: "left" }}>
        true
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        access\_type
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Entitlement access type (enum)
      </td>

      <td style={{ textAlign: "left" }}>
        "time\_based"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        expiration
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Entitlement access expiration date (UTC)
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29T12:00:00.00Z"
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
        Date of resource creation (UTC)
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        last\_updated
      </td>

      <td style={{ textAlign: "left" }}>
        string
      </td>

      <td style={{ textAlign: "left" }}>
        Date of last resource update (UTC)
      </td>

      <td style={{ textAlign: "left" }}>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        resource
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Resource information (see Resource Object below)
      </td>

      <td style={{ textAlign: "left" }}>
        \{"name": "sample resource", ... }
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
        List of grantees associated to the entitlement. `null` if there are none.
      </td>

      <td style={{ textAlign: "left" }}>
        \[
        \{
        "external\_id": "grantee-001",
        "name": "Grantee Name",
        "created": "2017-02-29T12:00:00.00Z",
        "updated": "2017-02-29T12:00:00.00Z"
        },\
        ...\
        ]
      </td>
    </tr>
  </tbody>
</Table>

### Resource Object

| Name                   | Type   | Description                        | Example                                        |
| :--------------------- | :----- | :--------------------------------- | :--------------------------------------------- |
| merchant               | string | Merchant ID                        | "ac4f7938383a11e89ecbbc764e1107f2"             |
| public\_id             | string | Resource ID                        | "c4cd7f86ccc411e8ada3bc764e101db1"             |
| name                   | string | Resource name                      | "4k Resolution Movies"                         |
| external\_resource\_id | string | Merchant resource ID               | "id1234"                                       |
| description            | string | Resource description               | "Unlocks streaming of movies in 4K resolution" |
| image\_url             | string | Resource image URL                 | "ordergroove.com/resource/resource\_id.png"    |
| created                | string | Date of resource creation (UTC)    | "2017-02-29T12:00:00.00Z"                      |
| last\_updated          | string | Date of last resource update (UTC) | "2017-02-29T12:00:00.00Z"                      |

<br />

### Grantee Object

| Name         | Type            | Description             | Example               |
| :----------- | :-------------- | :---------------------- | :-------------------- |
| external\_id | string          | Merchant ID             | "grantee-001"         |
| name         | string          | Resource ID             | "Grantee Name"        |
| created      | datetime string | Datetime of creation    | "2020-12-31 23:28:48" |
| updated      | datetime string | Datetime of last update | "2020-12-31 23:28:48" |

# OpenAPI definition

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "ordergroove-entitlements-service-api",
    "version": "2.10.0"
  },
  "servers": [
    {
      "url": "https://restapi.ordergroove.com"
    }
  ],
  "security": [
    {}
  ],
  "paths": {
    "/entitlements/": {
      "get": {
        "summary": "List",
        "description": "List entitlements associated to merchant's customers. Only relevant for merchants offering digital products.",
        "operationId": "entitlements-list",
        "parameters": [
          {
            "name": "merchant",
            "in": "query",
            "description": "Merchant ID",
            "required": true,
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "merchant_user_id",
            "in": "query",
            "description": "Customer ID. If the request is made on behalf of a customer, only the entitlements tied to the calling customer are returned, regardless of the value provided in this field",
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "resource_public_id",
            "in": "query",
            "description": "Filters entitlements by a single resource public ID.",
            "schema": {
              "type": "string"
            }
          },
          {
            "in": "query",
            "name": "resource_public_ids",
            "schema": {
              "type": "string"
            },
            "description": "Filters entitlements to those associated with the specified resource public IDs. Provide a comma-separated list of resource public IDs. Cannot be used together with `resource_public_id`."
          },
          {
            "name": "external_resource_id",
            "in": "query",
            "description": "Merchant resource ID",
            "schema": {
              "type": "string"
            }
          },
          {
            "in": "query",
            "name": "live",
            "schema": {
              "type": "boolean"
            },
            "description": "Filters entitlements by whether their associated resources are accessible"
          },
          {
            "in": "query",
            "name": "resource_name",
            "schema": {
              "type": "string"
            },
            "description": "Filters entitlements by resource name (case-insensitive match)."
          },
          {
            "in": "query",
            "name": "grantee_external_ids_exact",
            "schema": {
              "type": "string"
            },
            "required": false,
            "description": "Filter entitlements by list of exact ids (returns entitlement if and only if every grantee passed in is present in the entitlement and no other grantees are present)\nexample: grantee_external_ids_exact=grantee_a,grantee_b returns entitlements with both grantee_a and grantee_b, but not entitlements with just grantee_a or entitlements that have grantee_a, grantee_b, but also grantee_c"
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
                      "next": "https://restapi.ordergroove.com/entitlements/?cursor=cD0yMDI0LTA0LTEwKz",
                      "previous": null,
                      "results": [
                        {
                          "merchant": "339536244b7c11eb8d37ee71e0f3a639",
                          "public_id": "4c6dceaa1ddc4361962f9f6b11c0af7a",
                          "merchant_user_id": "test_user_id",
                          "initial_activation_date": "2024-08-12T20:35:19.04Z",
                          "latest_activation_date": "2024-08-12T20:35:19.04Z",
                          "grace_period": null,
                          "live": false,
                          "access_type": "time_based",
                          "expiration": "2024-09-12T20:35:19.04Z",
                          "created": "2024-08-12T20:35:19.04Z",
                          "last_updated": "2024-08-12T20:35:19.04Z",
                          "resource": {
                            "public_id": "ecb42bee71ff11efb72ef29e3ec3bb34",
                            "merchant": "339536244b7c11eb8d37ee71e0f3a639",
                            "name": "Piano lesson",
                            "external_resource_id": "123456",
                            "description": null,
                            "image_url": "http://some.image.com",
                            "created": "2020-12-31 23:28:48",
                            "last_updated": "2020-12-31 23:28:48"
                          },
                          "grantees": [
                            {
                              "external_id": "grantee-001",
                              "name": "Grantee Name",
                              "created": "2020-12-31 23:28:48",
                              "updated": "2020-12-31 23:28:48"
                            }
                          ]
                        }
                      ]
                    }
                  }
                },
                "schema": {
                  "type": "object",
                  "properties": {
                    "next": {
                      "type": "string",
                      "description": "URL to get the next page of results. `null` if there are no more pages."
                    },
                    "previous": {
                      "type": "string",
                      "description": "URL to get the previous page of results. `null` if there are no previous pages."
                    },
                    "results": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "merchant": {
                            "type": "string",
                            "example": "339536244b7c11eb8d37ee71e0f3a639"
                          },
                          "public_id": {
                            "type": "string",
                            "example": "4c6dceaa1ddc4361962f9f6b11c0af7a"
                          },
                          "merchant_user_id": {
                            "type": "string",
                            "example": "test_user_id"
                          },
                          "initial_activation_date": {
                            "type": "string",
                            "example": "2024-08-12T20:35:19.04Z"
                          },
                          "latest_activation_date": {
                            "type": "string",
                            "example": "2024-08-12T20:35:19.04Z"
                          },
                          "grace_period": {
                            "type": "integer"
                          },
                          "live": {
                            "type": "boolean"
                          },
                          "access_type": {
                            "type": "string",
                            "example": "time_based"
                          },
                          "expiration": {
                            "type": "string",
                            "example": "2024-09-12T20:35:19.04Z"
                          },
                          "created": {
                            "type": "string",
                            "example": "2024-08-12T20:35:19.04Z"
                          },
                          "last_updated": {
                            "type": "string",
                            "example": "2024-08-12T20:35:19.04Z"
                          },
                          "resource": {
                            "type": "object",
                            "properties": {
                              "public_id": {
                                "type": "string",
                                "example": "ecb42bee71ff11efb72ef29e3ec3bb34"
                              },
                              "merchant": {
                                "type": "string",
                                "example": "339536244b7c11eb8d37ee71e0f3a639"
                              },
                              "name": {
                                "type": "string",
                                "example": "Piano lesson"
                              },
                              "external_resource_id": {
                                "type": "string",
                                "example": "123456"
                              },
                              "description": {
                                "type": "string"
                              },
                              "image_url": {
                                "type": "string",
                                "example": "http://some.image.com"
                              },
                              "created": {
                                "type": "string",
                                "example": "2020-12-31 23:28:48"
                              },
                              "last_updated": {
                                "type": "string",
                                "example": "2020-12-31 23:28:48"
                              }
                            }
                          },
                          "grantees": {
                            "type": "array",
                            "items": {
                              "properties": {},
                              "type": "object"
                            },
                            "description": ""
                          }
                        }
                      },
                      "description": "*Note:* This endpoint returns up to 100 entitlements per request by default, which differs from other endpoints in this API."
                    }
                  }
                }
              }
            }
          },
          "403": {
            "description": "403",
            "content": {
              "text/plain": {
                "examples": {
                  "Result": {
                    "value": "{\n  \"detail\": \"Authentication Failed\"\n}"
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