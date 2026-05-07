# Subscriber Events

## Subscriber Event Object

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
        id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Identifier of the event
      </td>

      <td style={{ textAlign: "left" }}>
        “mmmm4444nnnn3333pppp”
      </td>
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
        See below for full list of event types
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        created
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestampe when the event occurred
      </td>

      <td style={{ textAlign: "left" }}>
        1622589211
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Type
      </td>

      <td style={{ textAlign: "left" }}>
        See JSON below
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.type
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Resource type of event
      </td>

      <td style={{ textAlign: "left" }}>
        "Subscription"
      </td>
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
        "aaaa1111bbbb2222cccc"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.merchant\_user\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        ID of consumer from  merchant system.
      </td>

      <td style={{ textAlign: "left" }}>
        "dddjjjjkk3343"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.subscription
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        ID of corresponding subscription that triggered the subscriber event. Is empty if event can have more than one subscription
      </td>

      <td style={{ textAlign: "left" }}>
        "ssss3333llll2222bbbb"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.subscriptions
      </td>

      <td style={{ textAlign: "left" }}>
        array
      </td>

      <td style={{ textAlign: "left" }}>
        List of the ids of the corresponding subscriptions that triggered the event. Is empty if event can only have one subscription.
      </td>

      <td style={{ textAlign: "left" }}>
        \["ssss3333llll2222bbbb", "ssss3333llll2222aaaa"]
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.session\_id
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Session ID, obtained from og\_session\_id cookie
      </td>

      <td style={{ textAlign: "left" }}>
        "aaaa1111bbbb2222cccc.450125.1299622365"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.first\_name
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Customer first name
      </td>

      <td style={{ textAlign: "left" }}>
        "John"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.last\_name
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Customer last name
      </td>

      <td style={{ textAlign: "left" }}>
        "Smith"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.email
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Customer email
      </td>

      <td style={{ textAlign: "left" }}>
        "[john.smith@email.com](mailto:john.smith@email.com)"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.phone\_number
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Customer phone number
      </td>

      <td style={{ textAlign: "left" }}>
        "555-555-5555"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.phone\_type
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Phone type enum.

        Options: 0, 1, 2, 3
      </td>

      <td style={{ textAlign: "left" }}>
        2
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.phone\_type\_display
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Readable version of phone type enum.

        Options: "invalid", "landline", "mobile", "voip"
      </td>

      <td style={{ textAlign: "left" }}>
        "mobile"
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.live
      </td>

      <td style={{ textAlign: "left" }}>
        bool
      </td>

      <td style={{ textAlign: "left" }}>
        Customer status. "true" if they have any subscriptions active;  false if no subscriptions are active.
      </td>

      <td style={{ textAlign: "left" }}>
        true
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.created
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the customer was created
      </td>

      <td style={{ textAlign: "left" }}>
        1298407706
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.last\_updated
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Unix timestamp when the customer was last updated
      </td>

      <td style={{ textAlign: "left" }}>
        1301323663
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.extra\_data
      </td>

      <td style={{ textAlign: "left" }}>
        object
      </td>

      <td style={{ textAlign: "left" }}>
        Key/value store for any extra information about the customer
      </td>

      <td style={{ textAlign: "left" }}>
        \{"some": "extra", "fields": "here"}
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.locale
      </td>

      <td style={{ textAlign: "left" }}>
        int
      </td>

      <td style={{ textAlign: "left" }}>
        Locale enum.

        Options: 1 - 46
      </td>

      <td style={{ textAlign: "left" }}>
        1
      </td>
    </tr>

    <tr>
      <td style={{ textAlign: "left" }}>
        data.object.locale\_display
      </td>

      <td style={{ textAlign: "left" }}>
        str
      </td>

      <td style={{ textAlign: "left" }}>
        Readable version of locale enum.
      </td>

      <td style={{ textAlign: "left" }}>
        "en-us"
      </td>
    </tr>
  </tbody>
</Table>

* Example data:

```json
{
  "id": "mmmm4444nnnn3333pppp",
  "type": "subscriber.create",
  "created": 1622589211,
  "data": {
    "object": {
      "type": "subscriber",
      "merchant": "aaaa1111bbbb2222cccc",
      "merchant_user_id": "dddjjjjkk3343",
      "subscription": "ssss3333llll2222bbbb",
      "subscriptions": ["ssss3333llll2222aaaa", "ssss3333llll2222cccc"],
      "session_id": "aaaa1111bbbb2222cccc.450125.1299622365",
      "first_name": "John",
      "last_name": "Smith",
      "email": "john.smith@email.com",
      "phone_number": "555-555-5555",
      "phone_type": 2,
      "phone_type_display": "mobile",
      "live": true,
      "created": 1298407706,
      "last_updated": 1301323663,
      "extra_data": {},
      "locale": 1,
      "locale_display": "en-us",
    }
  }
}
```

## Subscriber Event Types

<HTMLBlock>
  {`
  <div>
    <ul>
      <li>
        <h4><i>subscriber.create</i></h4>
      </li>
      <div>
        Triggered when a customer has created their first subscription. Contains the public id of the first subscription created in the "subscription" property. Has an empty "subscriptions" property. This event can only ever occur once for a customer.
      </div>
      <li>
  	    <h4><i>subscriber.cancel</i></h4>
      </li>
      <div>
        Triggered when a customer has cancelled their last active subscription and thus will no longer be generating any recurring revenue.  Contains the public id of the last subscription canceled in the "subscription" property. Has an empty "subscriptions" property. This event can be triggered multiple times for a customer. For example: I cancel my last subscription, reactivate it, and then cancel it again. This event will be triggered twice.
      </div>
       <li>
  	    <h4><i>subscriber.subscriptions_created</i></h4>
      </li>
      <div>
        Triggered when a subscriber creates one or more subscriptions. Contain the public ids of the subscriptions that were created in the "subscriptions" property. Has an empty "subscription" property.
      </div>
    </ul>
  </div>

  <style></style>
  `}
</HTMLBlock>