# Modify

This Endpoint Allows for the modification of expiration dates on a given entitlement

<br />

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ [Application API Scope](https://developer.ordergroove.com/reference/authentication#application-api-scope)
</Callout>

## Side-effects:

1. Entitlement status updated to active
2. EntitlementTransaction created
3. If the call is on a meta-entitlement and renewal\_date\_correction is not disabled, then all existing orders with product will be moved to new expiration date.
4. New “entitlement.entitlements\_expiration\_modified” event is triggered upon successful modification

## Response Body Definitions

### Entitlement Object

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
        public\_id
      </td>

      <td>
        string
      </td>

      <td>
        Entitlement ID
      </td>

      <td>
        "c4cd7f86ccc411e8ada3bc764e101db1"
      </td>
    </tr>

    <tr>
      <td>
        merchant\_user\_id
      </td>

      <td>
        string
      </td>

      <td>
        Customer ID
      </td>

      <td>
        "11100-C01"
      </td>
    </tr>

    <tr>
      <td>
        initial\_activation\_date
      </td>

      <td>
        string
      </td>

      <td>
        Initial activation date (UTC)
      </td>

      <td>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td>
        latest\_activation\_date
      </td>

      <td>
        string
      </td>

      <td>
        Latest activation date (UTC)
      </td>

      <td>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td>
        grace\_period
      </td>

      <td>
        string
      </td>

      <td>
        Grace period in seconds
      </td>

      <td>
        86400
      </td>
    </tr>

    <tr>
      <td>
        live
      </td>

      <td>
        bool
      </td>

      <td>
        Whether the resource associated with this entitlement is accessible (considers grace\_period)
      </td>

      <td>
        true
      </td>
    </tr>

    <tr>
      <td>
        access\_type
      </td>

      <td>
        string
      </td>

      <td>
        Entitlement access type (enum)
      </td>

      <td>
        "time\_based"
      </td>
    </tr>

    <tr>
      <td>
        expiration
      </td>

      <td>
        string
      </td>

      <td>
        Entitlement access expiration date (UTC)
      </td>

      <td>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td>
        created
      </td>

      <td>
        string
      </td>

      <td>
        Date of resource creation (UTC)
      </td>

      <td>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td>
        last\_updated
      </td>

      <td>
        string
      </td>

      <td>
        Date of last resource update (UTC)
      </td>

      <td>
        "2017-02-29T12:00:00.00Z"
      </td>
    </tr>

    <tr>
      <td>
        resource
      </td>

      <td>
        object
      </td>

      <td>
        Resource information (see Resource Object below)
      </td>

      <td>
        \{"name": "sample resource", ... }
      </td>
    </tr>

    <tr>
      <td>
        grantees
      </td>

      <td>
        array
      </td>

      <td>
        List of grantees associated to the entitlement. `null` if there are none.
      </td>

      <td>
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

#### Resource Object

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

#### Grantee Object

| Name         | Type            | Description             | Example               |
| :----------- | :-------------- | :---------------------- | :-------------------- |
| external\_id | string          | Merchant ID             | "grantee-001"         |
| name         | string          | Resource ID             | "Grantee Name"        |
| created      | datetime string | Datetime of creation    | "2020-12-31 23:28:48" |
| updated      | datetime string | Datetime of last update | "2020-12-31 23:28:48" |

### Entitlement Transaction Object

| Name                          | Type            | Description                                         | Example                                                                |
| :---------------------------- | :-------------- | :-------------------------------------------------- | :--------------------------------------------------------------------- |
| transaction\_type             | string          | The type of transaction this is                     | "modify\_expiration"                                                   |
| public\_id                    | string          | ID of transaction                                   | "71a591cb40be4985ab9ce2746329c865"                                     |
| entitlement\_public\_id       | string          | ID of entitlement transaction was on                | "6bba77e50a244f818f32f17e2da5aed8"                                     |
| merchant\_user\_id            | datetime string | Datetime of last update                             | "23773486874988"                                                       |
| resource\_public\_id          | string          | ID of resource                                      | "450a64bf72024d99998f6c7541fefa42"                                     |
| merchant\_public\_id          | string          | ID of merchant                                      | "80c9a167fb434fa0abe215c7f19a86cc"                                     |
| transaction\_initiation\_time | datetime string | time when transaction was set up                    | "2026-03-11T18:51:45.520224856Z"                                       |
| transaction\_execution\_time  | datetime string | time when transaction was executed                  | "2026-03-11T18:51:45.520224856Z"                                       |
| source\_action                | string          | action that triggered the transaction               | "api-call"                                                             |
| source\_object                | string          | source object that triggered transaction            | "user"                                                                 |
| source\_object\_id            | string          | id of source object                                 | "dd0756ea-f502-4292-931e-b48f26677ef9\_2026-03-11T18:51:45.520224856Z" |
| access\_type                  | string          | entitlement access type                             | time-based                                                             |
| grace\_period                 | integer         | time in seconds of entitlement grace period         | 0                                                                      |
| expiration                    | datetime string | datetime of expiration                              | "2028-03-01T23:59:59Z"                                                 |
| grace\_period\_expiration     | datetime string | datetime of expiration with grace period in account | "2028-03-01T23:59:59Z"                                                 |

### Renewal Correction

This only appears if merchant does not have renewal correction disabled and the entitlement being modified is a meta-entitlement.

<br />

| Name                | Type         | Description                                                                   | Example                                    |
| :------------------ | :----------- | :---------------------------------------------------------------------------- | :----------------------------------------- |
| Success             | boolean      | Whether the entire renewal correction was successful                          | true                                       |
| updated\_order\_ids | string array | Only appears if at least one order renewal date was successfully corrected    | \["order\_id1", "order\_id2"]              |
| failed\_order\_ids  | string array | Only appears if at least one order failed to get their renewal date corrected | \["order\_id3"]                            |
| message             | string       | explanation of any potential failure in renewal correction attempt            | "Renewal date correction partially failed" |

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
    "/entitlements/{entitlement.public_id}/modify_expiration/": {
      "post": {
        "description": "",
        "responses": {
          "200": {
            "description": "",
            "content": {
              "application/json": {
                "examples": {
                  "OK": {
                    "summary": "OK",
                    "value": {
                      "results": {
                        "entitlement_transaction": {
                          "transaction_type": "modify_expiration",
                          "public_id": "71a591cb40be4985ab9ce2746329c865",
                          "entitlement_public_id": "6bba77e50a244f818f32f17e2da5aed8",
                          "merchant_user_id": "23773486874988",
                          "resource_public_id": "450a64bf72024d99998f6c7541fefa42",
                          "merchant_public_id": "80c9a167fb434fa0abe215c7f19a86cc",
                          "transaction_initiation_time": "2026-03-11T18:51:45.520224856Z",
                          "transaction_execution_time": "2026-03-11T18:51:45.520224856Z",
                          "source_action": "api-call",
                          "source_object": "user",
                          "source_object_id": "dd0756ea-f502-4292-931e-b48f26677ef9_2026-03-11T18:51:45.520224856Z",
                          "access_type": "time_based",
                          "grace_period": 0,
                          "expiration": "2028-03-01T23:59:59Z",
                          "grace_period_expiration": "2028-03-01T23:59:59Z"
                        },
                        "entitlement": {
                          "merchant": "80c9a167fb434fa0abe215c7f19a86cc",
                          "public_id": "6bba77e50a244f818f32f17e2da5aed8",
                          "merchant_user_id": "23773486874988",
                          "initial_activation_date": null,
                          "latest_activation_date": null,
                          "grace_period": 0,
                          "live": true,
                          "access_type": "time_based",
                          "expiration": "2028-03-01T23:59:59Z",
                          "created": "2026-03-03T17:06:09.424Z",
                          "last_updated": "2026-03-11T18:51:45.521796755Z",
                          "resource": {
                            "public_id": "450a64bf72024d99998f6c7541fefa42",
                            "merchant": "80c9a167fb434fa0abe215c7f19a86cc",
                            "name": "Meta Plan Candidate 01",
                            "external_resource_id": "52810769170796",
                            "description": null,
                            "image_url": null,
                            "created": "2025-10-28T17:48:10.806Z",
                            "last_updated": "2025-10-28T17:48:10.806Z"
                          },
                          "grantees": null
                        },
                        "renewal_correction": {
                          "success": true,
                          "updated_order_ids": [
                            "d8dee1f287c4429b83ff54f438937d98"
                          ]
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        "parameters": [
          {
            "in": "path",
            "name": "entitlement.public_id",
            "schema": {
              "type": "string"
            },
            "required": true,
            "description": "Public_id of entitlement"
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "expiration": {
                    "type": "string",
                    "description": "New expiration date (YYYY-MM-DD) of entitlement. Cannot be past date.",
                    "format": "date"
                  }
                },
                "required": [
                  "expiration"
                ]
              }
            }
          }
        },
        "operationId": "post_entitlements-entitlement-public-id-modify-expiration"
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