# Getting Started

Ordergroove provides a read-only GraphQL API for fetching subscriptions and orders with all their related data in a single request. Unlike the REST API where you may need multiple calls to assemble a complete picture, GraphQL lets you specify exactly the fields you need and get multiple fields back at once.

If you're new to GraphQL, the official <Anchor label="Introduction to GraphQL" target="_blank" href="https://graphql.org/learn/">Introduction to GraphQL</Anchor> is the best place to start.\
The sections below cover how Ordergroove's GraphQL API works.

## Endpoints

| Environment | URL                                                               |
| ----------- | ----------------------------------------------------------------- |
| PRODUCTION  | `POST https://restapi.ordergroove.com/graphql/{version}/`         |
| STAGING     | `POST https://staging.restapi.ordergroove.com/graphql/{version}/` |

<br />

## Versioning

The API uses date-based URL versioning. Versions follow a `YYYY-MM` format and appear in the URL path:

```
/graphql/2026-01/
```

<br />

New versions are only created when breaking changes are necessary. A version may remain current for months or years as long as the schema evolves additively.

**What is not a breaking change** (deployed to the current version):

* Adding new fields, types, or root queries
* Adding optional arguments to existing fields
* Deprecating a field (marking it, not removing it)

**What requires a new version:**

* Removing or renaming a field or type
* Changing a field's return type
* Making an optional argument required

<br />

### Versions List

| Version    | Description                          |
| ---------- | ------------------------------------ |
| `unstable` | Always the latest version of GraphQL |
| `2026-01`  | Current latest GraphQL Version       |

<br />

### Deprecation and sunset

When a new version is released, the previous version enters a **12-month deprecation window**. During this period:

* The old version continues to work normally
* Responses from the old version include a `Sunset` header with the sunset date
* After the window closes, the old version returns `410 Gone`

Individual fields within a version may also be deprecated using GraphQL's `@deprecated` directive.

## Authentication

The GraphQL API uses the same authentication as the REST API. See <Anchor label="Authentication" target="_blank" href="/reference/authentication">Authentication</Anchor> for details on obtaining API keys and generating signatures.

## Data scoping

All query results are automatically scoped to the authenticated merchant's data:

* **Application API scope** - access to all merchant data across customers. Users with the "API Access" group can query without a `customer` filter.
* **Storefront API scope** - access is limited to the authenticated customer's data only.

## Request Format

A GraphQL request consists of a `POST` request to a GraphQL endpoint with a GQL query.

```json
{
  "query": "query GetSubscription($id: String!) { subscription(publicId: $id) { publicId quantity } }",
  "variables": { "id": "sub-abc-123" }
}
```

| Field       | Required | Description                                               |
| ----------- | -------- | --------------------------------------------------------- |
| `query`     | Yes      | The GraphQL query string                                  |
| `variables` | No       | Key-value pairs for any variables referenced in the query |

### Response format

Successful responses return a `data` object matching the shape of your query:

```json
{
  "data": {
    "subscription": {
      "publicId": "sub-abc-123",
      "quantity": 1
    }
  }
}
```

Errors return an `errors` array:

```json
{
  "errors": [
    { "message": "Description of the problem." }
  ]
}
```

<br />

## Sample Query

Fetch a single subscription by its ID:

```bash
curl -X POST https://restapi.ordergroove.com/graphql/2026-01/ \
  -H "Content-Type: application/json" \
  -H "x-api-key: your_api_key" \
  -d '{
    "query": "{ subscription(publicId: \"sub-abc-123\") { publicId quantity price product { name sku } } }"
  }'
```

```json
{
  "data": {
    "subscription": {
      "publicId": "sub-abc-123",
      "quantity": 1,
      "price": "29.99",
      "product": {
        "name": "Sample product",
        "sku": "sample-sku-abc-123"
      }
    }
  }
}
```

## Limits

The GraphQL API does not support subqueries or query batching. Each request executes a single top-level query against one of the available root fields.

| Limit                | Value            |
| -------------------- | ---------------- |
| Max page size        | 100 (default 10) |
| Max items per order  | 100              |
| Max query depth      | 9                |
| Max query complexity | 200 points       |

### Complexity Costs

The API enforces a **query complexity limit of 200 points** per request. Complexity is calculated by walking your query and summing up the cost of each field:

| Field type    | Cost     | Examples                            |
| ------------- | -------- | ----------------------------------- |
| Scalar        | 1 point  | strings, numbers, booleans          |
| Nested object | 5 points | types that contain their own fields |

For example, this query costs **9 points**:

```graphql
{
  subscription(publicId: "abc") {
    publicId        # 1
    quantity        # 1
    product {       # 5
      name          # 1
      sku           # 1
    }
  }
}
```

Queries exceeding the complexity limit are rejected with a `400` before execution. Design your queries to request only the fields you need.

## Further Reading

* <Anchor label="Introduction to GraphQL" target="_blank" href="https://graphql.org/learn/">Introduction to GraphQL</Anchor> — official tutorial covering queries, schemas, and core concepts
* <Anchor label="How to GraphQL" target="_blank" href="https://www.howtographql.com/">How to GraphQL</Anchor> — fullstack tutorial from zero to production
* <Anchor label="Authentication" target="_blank" href="/reference/authentication">Authentication</Anchor> — obtaining API keys and generating signatures
* <Anchor label="GraphQL Definitions" target="_blank" href="/page/graphql-order">GraphQL Definitions</Anchor>  — full field reference for all query and object types