# Entitlements Events

## Entitlement Event Object

<br />

<Table align={["left","left","left","left","left"]}>
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

      <th style={{ textAlign: "left" }} />
    </tr>
  </thead>

  <tbody>
    <tr>
      <td style={{ textAlign: "left" }}>
        id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Identifier of the event
      </td>

      <td style={{ textAlign: "left" }}>
        "zzzz1111yyyy2222xxxx"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        type
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        The type of event that occurred
      </td>

      <td style={{ textAlign: "left" }}>
        "entitlement.entitlements\_granted""
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        created
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the event occurred
      </td>

      <td style={{ textAlign: "left" }}>
        1758652772
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Event payload
      </td>

      <td style={{ textAlign: "left" }}>
        See JSON below
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.type
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Resource type of event object
      </td>

      <td style={{ textAlign: "left" }}>
        "entitlement"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.merchant
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Identifier of merchant
      </td>

      <td style={{ textAlign: "left" }}>
        "519f1f120e3411ef984b1e8a267ce85a"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements
      </td>

      <td style={{ textAlign: "left" }}>
        array
      </td>

      <td style={{ textAlign: "left" }}>
        List of entitlement objects
      </td>

      <td style={{ textAlign: "left" }}>
        \[\{...}, \{...}]
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Public identifier of the entitlement
      </td>

      <td style={{ textAlign: "left" }}>
        "dee489eb3c6f419dbd65fb99f33c60f5"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].access\_type
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Access type for the entitlement  \nOptions: "time\_based"
      </td>

      <td style={{ textAlign: "left" }}>
        "time\_based"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].created
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the entitlement was created
      </td>

      <td style={{ textAlign: "left" }}>
        1755841156
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].last\_updated
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the entitlement was last updated
      </td>

      <td style={{ textAlign: "left" }}>
        1758652772
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].expiration
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the entitlement expires
      </td>

      <td style={{ textAlign: "left" }}>
        1763701794
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].grace\_period
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Grace period (seconds) after expiration during which access may continue
      </td>

      <td style={{ textAlign: "left" }}>
        345600
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].live
      </td>

      <td style={{ textAlign: "left" }}>
        bool
      </td>

      <td style={{ textAlign: "left" }}>
        Indicates whether the resource associated with this entitlement can be accessed. If the expiration date has passed but the grace period is still in effect, this field will be `true`.
      </td>

      <td style={{ textAlign: "left" }}>
        true
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Details of the transaction that granted or modified the entitlement
      </td>

      <td style={{ textAlign: "left" }}>
        \{ ... }
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Public identifier of the transaction
      </td>

      <td style={{ textAlign: "left" }}>
        "1f3650bb2d75463e8b71b61f38289c9c"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.transaction\_type
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Transaction type  \nOptions: "grant\_credit"
      </td>

      <td style={{ textAlign: "left" }}>
        "grant\_credit"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.source\_action
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Originating action in merchant workflow
      </td>

      <td style={{ textAlign: "left" }}>
        "order-placement"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.source\_object
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Type of object that initiated the transaction
      </td>

      <td style={{ textAlign: "left" }}>
        "item"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.source\_object\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Identifier of the source object
      </td>

      <td style={{ textAlign: "left" }}>
        "169719f6110d40b2b157381924f95bf9"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.transaction\_initiation\_time
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the transaction was initiated
      </td>

      <td style={{ textAlign: "left" }}>
        1758652772
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.transaction\_execution\_time
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the transaction executed
      </td>

      <td style={{ textAlign: "left" }}>
        1758652772
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.time\_amount
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Amount of time credited (seconds)
      </td>

      <td style={{ textAlign: "left" }}>
        1296000
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].entitlement\_transaction.grace\_period
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Transaction-level grace period (seconds), if applicable
      </td>

      <td style={{ textAlign: "left" }}>
        345600
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].grantees
      </td>

      <td style={{ textAlign: "left" }}>
        array
      </td>

      <td style={{ textAlign: "left" }}>
        List of grantees associated to the entitlement `null` if there are none.
      </td>

      <td style={{ textAlign: "left" }}>
        \[
        \{
        "external\_id": "grantee-001",
        "name": "Grantee Name",
        "created": 1758652772,
        "updated": 1758652772
        },\
        ...\
        ]
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].resource
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Resource to which the entitlement applies
      </td>

      <td style={{ textAlign: "left" }}>
        \{ ... }
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].resource.public\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Public identifier of the resource
      </td>

      <td style={{ textAlign: "left" }}>
        "8bc97390ff944451a8e4bee89bf18473"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].resource.name
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Resource display name
      </td>

      <td style={{ textAlign: "left" }}>
        "Test Resource 2"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].resource.description
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Resource description
      </td>

      <td style={{ textAlign: "left" }}>
        "Test Description 2"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].resource.external\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        External identifier of the resource in merchant system
      </td>

      <td style={{ textAlign: "left" }}>
        "654321"
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.entitlements\[].resource.image\_url
      </td>

      <td style={{ textAlign: "left" }}>
        str \\
      </td>

      <td style={{ textAlign: "left" }}>
        null
      </td>

      <td style={{ textAlign: "left" }}>
        Image URL for the resource, if any
      </td>

      <td style={{ textAlign: "left" }}>
        null
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.context
      </td>

      <td style={{ textAlign: "left" }}>
        object \\
      </td>

      <td style={{ textAlign: "left" }}>
        null
      </td>

      <td style={{ textAlign: "left" }}>
        Optional context specific to the event
      </td>

      <td style={{ textAlign: "left" }}>
        null
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.snapshot
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Arbitrary snapshot data at time of event
      </td>

      <td style={{ textAlign: "left" }}>
        \{}
      </td>

      <td style={{ textAlign: "left" }} />
    </tr>
  </tbody>
</Table>

* Example data:

```json
{
   "id":"5dcc6524c8b3491aba893dbc33282fe9",
   "type":"entitlement.entitlements_granted",
   "created":1758652772,
   "data":{
      "object":{
         "customer":"9621785248035",
         "entitlements":[
            {
               "access_type":"time_based",
               "created":1753215926,
               "entitlement_transaction":{
                  "grace_period":86400,
                  "public_id":"a6ac2b763b4c45db9b3cb4f2e43fa2bb",
                  "source_action":"order-placement",
                  "source_object":"item",
                  "source_object_id":"169719f6110d40b2b157381924f95bf9",
                  "time_amount":2592000,
                  "transaction_execution_time":1758652772,
                  "transaction_initiation_time":1758652772,
                  "transaction_type":"grant_credit"
               },
               "expiration":4098185509,
               "grace_period":86400,
               "live": true,
               "last_updated":1758652772,
               "public_id":"36a82fb6bb9549e0877058b2eb8644ad",
               "grantees": [
                  {
                     "external_id": "grantee-001",
                     "name": "Alice",
                     "created": 1758652772,
                     "updated": 1758652772
                  },
                  {
                     "external_id": "grantee-002",
                     "name": "Bob",
                     "created": 1758652772,
                     "updated": 1758652772
                  }
               ],
               "resource":{
                  "description":"Test Description 1",
                  "external_id":"123456",
                  "image_url":"http://example.com/resource1.jpg",
                  "name":"Test Resource 1",
                  "public_id":"c84a13fc8e904e0f80e6377b15f0464a"
               }
            },
            {
               "access_type":"time_based",
               "created":1755841156,
               "entitlement_transaction":{
                  "grace_period":345600,
                  "public_id":"1f3650bb2d75463e8b71b61f38289c9c",
                  "source_action":"order-placement",
                  "source_object":"item",
                  "source_object_id":"169719f6110d40b2b157381924f95bf9",
                  "time_amount":1296000,
                  "transaction_execution_time":1758652772,
                  "transaction_initiation_time":1758652772,
                  "transaction_type":"grant_credit"
               },
               "expiration":1759942309,
               "grace_period":345600,
               "live": false,
               "last_updated":1758652772,
               "public_id":"dee489eb3c6f419dbd65fb99f33c60f5",
               "grantees": null,
               "resource":{
                  "description":"Test Description 2",
                  "external_id":"654321",
                  "image_url":null,
                  "name":"Test Resource 2",
                  "public_id":"8bc97390ff944451a8e4bee89bf18473"
               }
            }
         ],
         "merchant":"519f1f120e3411ef984b1e8a267ce85a",
         "type":"entitlement"
      },
      "context":null,
      "snapshot":{
         
      }
   }
}
```

<br />

## Entitlement Event Types

<HTMLBlock>
  {`
  <div>
    <ul>
      <li>
        <h4><i>entitlement.entitlements_granted</i></h4>    
      </li>
      <div>                                                 
          Triggered when a customer has been granted one or more entitlements. If multiple entitlements are granted for a customer at the same time, they are clustered together in a single event.
      </div>
      <li>
        <h4><i>entitlement.entitlements_expiring</i></h4>
      </li>
      <div>
        Triggered when an entitlement is approaching expiration. These events fire one week prior to the expiration date whenever possible. If the entitlement lifetime is shorter than one week, the event fires as late as possible (for example: created with 6 days of access → event fires 6 days before expiration). Multiple entitlements with matching conditions are clustered together in a single event.
      </div>
      <li>
        <h4><i>entitlement.entitlements_expired</i></h4>
      </li>
      <div>
        Triggered when an entitlement has reached its expiration time. If an entitlement includes a grace period, the customer continues to have access until that grace period ends, at which point the entitlement.entitlements_grace_period_expired event will be triggered. Multiple entitlements that expire at the same time are clustered together in a single event.
      </div>
      <li>
        <h4><i>entitlement.entitlements_grace_period_expired</i></h4>
      </li>
      <div>
        Triggered when an entitlement has reached the end of its configured grace period. Multiple entitlements whose grace period expire at the same time are clustered together in a single event.
      </div>
      <li>
        <h4><i>entitlement.entitlements_expiration_modified</i></h4>
      </li>
      <div>
        Triggered when the expiration date of one or more entitlements has been modified through our APIs, either extended or shortened. This is typically initiated by a representative such as a customer service agent. Multiple entitlements whose expiration date is modified at the same time are clustered together in a single event.
      </div>
      <li>
        <h4><i>entitlement.entitlements_voided</i></h4>     
      </li>
      <div>
          Triggered when one or more entitlements have been voided, immediately revoking the customer's access. This is typically initiated by a representative such as a customer service agent. Multiple entitlements voided at the same time are clustered together
        in a single event.
     </div>
  </ul>
  </div>

  <style></style>
  `}
</HTMLBlock>

<br />