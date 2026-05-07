# Workflow Events

Custom event that can be fired from our Workflows

## Workflow Event Object

| Name                          | Type   | Description                                         | Example                                     |
| :---------------------------- | :----- | :-------------------------------------------------- | :------------------------------------------ |
| id                            | str    | Identifier of the event                             | "zzzz1111yyyy2222xxxx"                      |
| type                          | str    | The type of event that occurred                     | "workflow\.send\_communication""            |
| created                       | int    | Unix timestamp when the event occurred              | 1758652772                                  |
| data                          | object | Event payload                                       | See JSON below                              |
| data.key                      | str    | The user created identifier to differentiate events | free\_gift                                  |
| data.object.type              | str    | Resource type of event object                       | workflow                                    |
| data.object.merchant          | str    | Identifier of merchant                              | 519f1f120e3411ef984b1e8a267ce85a            |
| data.object.workflow\_id      | array  | Identifier of the workflow                          | 519f1f120e3411ef984b1e8a267ce85a            |
| data.object.workflow\_name    | str    | Name of the workflow                                | "dee489eb3c6f419dbd65fb99f33c60f5"          |
| data.object.execution\_id     | str    | Identifier of the workflow execution                | "519f1f120e3411ef984b1e8a267ce85a"          |
| data.subscriber.email         | str    | The email of the subscriber                         | [test@example.com](mailto:test@example.com) |
| data.subscriber.phone\_number | str    | The phone number of the subscriber                  | 555-555-5555                                |
| data.subscriber.first\_name   | str    | The first name of the subscriber                    | Joe                                         |
| data.subscriber.last\_name    | str    | The last name of the subscriber                     | Smith                                       |
| data.execution\_context       | object | Key-Value pair containing workflow execution data   | {}                                          |

* Example data:

```json
{
  "id": "mmmm4444nnnn3333pppp",
  "type": "workflow.send_communication",
  "created": 1622589211,
  "data": {
    "key": "free_gift",
    "object": {
      "type": "workflow",
      "merchant": "aaaa1111bbbb2222cccc",
      "workflow_id": "dddjjjjkk3343",
      "workflow_name": "My Workflow",
      "execution_id": "aaaa1111bbbb2222cccc",
    },
    "subscriber": {
       "email": "test@example.com",
      "first_name": "Joe",
      "last_name": "Smith",
      "phone_number": "555-555-5555"
    },
    execution_context: {
      "foo": "bar"
    }
  }
}
```

<br />

## Workflow Event Types

<HTMLBlock>
  {`
  <div role="tablist">
    <ul role="list">
      <li>
        <h4><i>workflow.send_communication</i></h4>
      </li>
      <div>
        Triggered from a "Send Communication" node in a workflow that is configured to use an Ordergroove webhook. The execution context will depend on the type of workflow and the nodes preceding the send communication node.
      </div>
    </ul>
  </div>

  <style></style>
  `}
</HTMLBlock>