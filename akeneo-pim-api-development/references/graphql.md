# GraphQL API

Akeneo's **GraphQL API** is a **read-only** query surface that sits in front of the PIM's REST API — the docs state plainly that "GraphQL aggregates the GET Rest API calls." It lets a client pull products, catalog structure, reference entities and assets with exactly the fields it needs in one round-trip, instead of chaining many REST `GET`s. It is one of the **newer SaaS/Serenity surfaces** (alongside the Event Platform, Catalogs, and the MCP server, see mcp-server.md) and is **not** part of the classic on-prem REST API. For writes — and for anything the GraphQL schema doesn't cover — you keep using REST (rest-api-overview.md).

Two things about it are unusual and cause most of the early confusion:

- **The endpoint is a single hosted host, not your PIM.** Every request is a `POST` to **`https://graphql.sdk.akeneo.cloud`** (the same URL also serves the GraphiQL in-browser IDE). Your PIM instance is identified by the **`X-PIM-URL` header**, not by the URL you POST to. Contrast REST, which you call directly at `{pim_url}/api/rest/v1/…`.
- **It reuses REST API tokens.** There is no separate GraphQL credential. You pass a normal REST API bearer token (from an **App** or a **Connection**) in the `X-PIM-TOKEN` header — the same App/Connection auth models documented in authentication.md and apps-and-connections.md.

## Availability (Serenity / EE-SaaS + Growth only)

GraphQL is a SaaS-only surface. The compatibility matrix from the docs:

| Akeneo PIM Edition | GraphQL supported? |
| --- | --- |
| Enterprise Edition (SaaS / Serenity) | **Supported** |
| Enterprise Edition (PaaS) | Not supported |
| Growth Edition | **Supported** |
| Community Edition | Not supported |

So: if the target is on-prem CE/EE (PaaS) or Community, GraphQL is unavailable — use REST. `systemInformation` (a root query, below) returns the PIM version and edition if you need to detect this at runtime.

## Authentication — the same App / Connection tokens as REST

Because GraphQL wraps the REST API, **a REST API token is required**. The docs recognize the two standard token types (identical to the rest of the skill):

| Token type | Lifetime | How obtained | Recommended for |
| --- | --- | --- | --- |
| **Connection token** | 1 hour | Generated when you connect to the API (password grant) | Testing / quick starts |
| **App token** | Permanent | Generated via OAuth2 for App connections | Development / production |

Akeneo recommends an **App token** for development and a **Connection token** for testing. Full flows live in authentication.md (Connection password grant) and apps-and-connections.md (App authorization-code grant).

GraphQL even exposes a convenience **`token` query** so you can mint a Connection token from the GraphiQL IDE without a separate REST call — you supply `username`, `password`, `clientId`, `clientSecret` (all required) and read back `data.accessToken`:

```graphql
{
  token(
    username: "my-username"
    password: "my-password"
    clientId: "my-client-id"
    clientSecret: "my-client-secret"
  ) {
    data {
      accessToken
    }
  }
}
```

For the `token` query you send only the `X-PIM-URL` and `X-PIM-CLIENT-ID` headers (you don't have a token yet). For every other query you must add `X-PIM-TOKEN`.

## The endpoint and required headers

```bash
curl -X POST https://graphql.sdk.akeneo.cloud \
  -H 'Content-Type: application/json' \
  -H 'X-PIM-URL: https://your-pim-url.cloud.akeneo.com' \
  -H 'X-PIM-CLIENT-ID: your-client-id' \
  -H 'X-PIM-TOKEN: your-token' \
  -d '{"query":"{ products(limit: 5) { items { uuid } } }"}'
```

| Header | Meaning |
| --- | --- |
| `X-PIM-URL` | Your PIM instance URL (e.g. `https://my-pim.sandbox.cloud.akeneo.com/`) |
| `X-PIM-CLIENT-ID` | Your connection/app `client_id` |
| `X-PIM-TOKEN` | Your REST API access token (App or Connection) |

Header names are case-insensitive; the docs use both `X-PIM-…` and `x-pim-…` forms. The body is standard GraphQL-over-HTTP JSON: `{ "query": "…", "variables": { … } }`.

## Common notions — how PIM entities map to GraphQL

Each PIM resource is exposed as a **root query** returning a collection wrapper. Every collection has three standard sub-objects:

- **`items`** — the records; select the fields you want.
- **`links`** — pagination pointers (`next` / `self` / `first`).
- **`queryInformation`** — metadata: `requestComplexity`, `requestComplexityDetail`, and `deprecations`.

The root queries (and the REST resource each wraps):

| GraphQL root query | Returns | Required argument | Backing REST resource |
| --- | --- | --- | --- |
| `products` | Products (simple + variants), by UUID | — | `GET /products-uuid` |
| `productModels` | Product models | — | Product model |
| `families` | Families | — | Family |
| `categories` | Categories | — | Category |
| `attributes` | Attributes | — | Attribute |
| `attributeOptions` | Options of one attribute | `attributeCode` | Attribute option |
| `locales` | Locales | — | Locale |
| `currencies` | Currencies | — | Currency |
| `channels` | Channels | — | Channel |
| `measurementFamilies` | Measurement families | — | Measurement family |
| `assetFamilies` | Asset families | — | Asset family |
| `assetsRecords` | Assets of one asset family | `assetFamily` | Asset |
| `referenceEntities` | Reference entities | — | Reference entities |
| `referenceEntitiesRecords` | Records of one reference entity | `referenceEntity` | Reference entity record |
| `token` | An access token | `username`,`password`,`clientId`,`clientSecret` | Authentication |
| `systemInformation` | PIM version + edition | — (none) | System |

### Value and label shapes (note the REST → GraphQL rename)

- **Attribute values** come back as `{ locale, channel, data }`. Note GraphQL calls the channel dimension **`channel`**, where REST calls it `scope` — same concept (`locale` is null unless the attribute is localizable; `channel` is null unless it is scopable). See products-and-models.md for the localizable/scopable rules.
- **Labels** are arrays of `{ localeCode, localeValue }` objects (not a `locale → string` map).
- On a `products` item you can select `uuid`, `enabled`, `created`, `updated`, `parent { code }`, `variationValues`, `categories { code labels }`, `family { code labels attributeAsLabel attributeAsImage }`, `simpleAssociations { type products { uuid } }`, and `attributes { code labels type sortOrder group { … } values relatedObject { code labels } }`.
- To hydrate the reference-entity records / assets **behind** an attribute, add `relatedObject { code labels }` and request `values(nestedObjectValueLevel: 1)` (use `2` to go a level deeper).

## Queries and arguments

### Pagination (`limit` + `links.next` → `page`)

`limit` accepts **1–100** (the max page size). To page, request `links { next }`, then feed that `next` value into the **`page`** argument of the next call. `next` is `null` when there are no more pages (and a trailing page can legitimately come back empty).

```graphql
# page 1
{ products(limit: 5) { links { next } items { uuid created } } }
# → links.next = "00fd49f2-c417-4a40-8a7b-439a6e51923b"

# page 2: pass that cursor to `page`
{ products(limit: 5, page: "00fd49f2-c417-4a40-8a7b-439a6e51923b") {
    links { next } items { uuid created } } }
```

The **type of `page` differs by query**: for `products`, `productModels`, `assetFamilies`, `assetsRecords`, `referenceEntities`, and `referenceEntitiesRecords` it is a **String** cursor (the `uuid`/`code` of the last item). For `families`, `categories`, `attributes`, `attributeOptions`, `locales`, `currencies`, and `channels` it is an **Int** page number. In all cases the value to use is whatever `links.next` returned.

### Filtering with `search` (stringified, JSON-escaped REST filters)

Because GraphQL runs on the REST API, the **`search`** argument (type **String**) accepts a **stringified, JSON-escaped** version of the same filter clauses documented for REST at `api.akeneo.com/documentation/filter.html`:

```graphql
{
  products(search: "{\"updated\":[{\"operator\":\"SINCE LAST N DAYS\",\"value\":30}]}") {
    links { next }
    items { uuid updated }
  }
}
```

Unescaped, that filter is `{"updated":[{"operator":"SINCE LAST N DAYS","value":30}]}`. Any REST filter (`created`, `enabled`, `categories`, `completeness`, attribute filters, …) works the same way once escaped.

### Convenience arguments (per query)

The `products` / `productModels` queries also expose typed arguments that call REST search under the hood so you can skip hand-escaping `search`:

| Argument | Type | Applies to | Notes |
| --- | --- | --- | --- |
| `limit` / `page` | Int / String‑or‑Int | most queries | pagination (above) |
| `locales` | String[] | most | keep only values/labels for these locales |
| `channel` | String | products, productModels, assetsRecords, referenceEntitiesRecords | keep only values for this channel |
| `currencies` | String[] | products, productModels | keep only these currencies |
| `search` | String | products, productModels, categories, attributes, assetsRecords, referenceEntitiesRecords | escaped REST filter |
| `categories` / `families` | String[] | products, productModels | filter by category/family codes |
| `uuid` | String[] | products | fetch specific products |
| `codes` | String[] | productModels, families, categories, attributes, assetsRecords, referenceEntitiesRecords | fetch specific items |
| `parent` | String | products | variants of a product-model **code** |
| `noParent` | Enum | products, productModels | only accepts `YES` → only simple products / only root models |
| `attributesToLoad` | String[] | products, productModels | restrict which attribute values load (big perf win) |
| `convertMeasurements` | Boolean | products, productModels | convert measurement values to the `channel`'s configured unit |
| `hasProducts` / `updatedAfter` | Boolean / String(ISO 8601) | families | filter families |
| `enabled` | Boolean | locales, currencies | only enabled/disabled |
| `root` / `parent` | Boolean / String | categories | only roots / children of a parent code |
| `types` / `identifier` | String[] / Boolean | attributes | by attribute type / identifier attributes |

### A worked example (first query)

```graphql
{
  products(limit: 1, locales: "en_US") {
    items {
      uuid
      family { code labels }
      categories { code labels }
      attributes {
        code
        type
        sortOrder
        group { code labels sortOrder }
        values
      }
    }
  }
}
```

`values` on each attribute returns the `{ locale, channel, data }` array. Add `attributesToLoad: ["name","price"]` to load only those attributes.

## Browsing capabilities (GraphiQL)

The full schema is discoverable in the **GraphiQL** in-browser IDE at `https://graphql.sdk.akeneo.cloud`. It provides a Documentation Explorer and a Query Explorer (click fields to build queries), history, syntax/error highlighting, `ctrl+space` autocompletion, and `ctrl+enter` to run. Supply the same three headers (`X-PIM-URL`, `X-PIM-CLIENT-ID`, `X-PIM-TOKEN`) in its Headers panel. This is the authoritative way to see the exact GraphQL type/field names — the docs describe the root queries and their common fields but do not publish a formal SDL, so browse GraphiQL (or introspection) for the complete schema.

## Limitations

- **Read-only.** The documented surface is entirely queries; there are **no documented mutations** — all writes go through REST (rest-api-overview.md).
- **Rate limit: 500 requests / 10 s per PIM URL.** A 429 (see below) means back off — simplify the query, fetch smaller pages, and add exponential-backoff pauses between paginated calls.
- **One query per call.** Multiple top-level selections in a single request are rejected: `"Operation Error: Only one selection is allowed at once, found 2"`.
- **Query depth limits** (every `{ … }` you open adds a level). Per-query maxima:

  | Query | Max depth | | Query | Max depth |
  | --- | --- | --- | --- | --- |
  | products | 8 | | categories | 8 |
  | productModels | 7 | | families | 5 |
  | referenceEntities | 5 | | assetFamilies | 5 |
  | attributes | 4 | | channels | 4 |
  | measurementFamilies | 4 | | attributeOptions | 3 |
  | assetsRecords | 3 | | currencies | 3 |
  | locales | 3 | | referenceEntitiesRecords | 3 |
  | systemInformation | 3 | | | |

  Exceeding it returns e.g. `"Depth Error: Query depth limit of 6 for query: [products] exceeded, found 7."`
- **Query complexity cap: 5,000.** Each query is priced (default **object cost = 5**, **field cost = 1**; `queryInformation` and `links` cost **0**; special fields `variationValues`/`variationAxes` cost **5**; an **exponential depth factor starting at 2** multiplies nested costs; then the whole thing is multiplied by the `limit`). Over the cap you get `"Cost Error: Query Cost limit of 5000 exceeded, found 6200…"`. Check a query's price up front by selecting `queryInformation { requestComplexity requestComplexityDetail }`.
- **Assets: links only, no binaries.** GraphQL exposes **Asset Media Links** and **Asset Shared Links** (main media only) but **not** asset media file **binaries**, with no plan to add them — your integration needs a DAM link or shared-link setup. (Product/reference-entity media files are likewise not served as binaries.)
- **Caching.** Sub-queries are cached ~5 minutes (main queries are not); the cache is shared across instances, so recent writes may lag briefly in nested fields.

## Error handling

Like most GraphQL servers, successful transport returns **HTTP 200 even for query errors** — always inspect the `errors` array, not just the status code. Each error carries `message`, `locations` (`line`/`column`), `path`, and sometimes `extensions`:

- **Validation / schema errors** (wrong field, invalid `search` JSON, one-query, depth, complexity) have **no `extensions`**.
- **Errors bubbled up from the PIM** always include `extensions.http_code` + `extensions.http_message`: `401` (invalid/expired token — refresh it), `422` (bad data, e.g. `"Scope \"abc\" does not exist."`), `429` (PIM over-solicited).

A few conditions do return a non-200 status: **`415 Unsupported Media Type`** (empty POST body), **`429 Too Many Requests`** (rate limit), **`500 Internal Server Error`** (check `status.akeneo.com`). See errors-and-rate-limits.md for the REST-side status codes these map to.

## Best practices

- **Query only what you need** — GraphQL's whole point; skip expensive nested objects (e.g. `family { attributeRequirements … }`) you won't use.
- **Use `attributesToLoad`** on `products`/`productModels` to load only the attribute values you need — the single biggest response-time win.
- **Use variables**, not inline args, for reusable static queries: `query MyQuery($limit: Int) { products(limit: $limit) { items { uuid } } }` with `"variables": {"limit": 10}`.
- **Enable compression** with `Accept-Encoding: gzip, deflate, br, zstd`. The server prefers **Brotli (`br`)** — make sure your client can decompress Brotli, or request `gzip` only to avoid unreadable binary.
- **Watch deprecations**: `queryInformation { deprecations }`, an `x-deprecations-count` response header, and orange highlighting in GraphiQL all surface deprecated fields/arguments.

## When to use GraphQL vs REST

Akeneo's own recommendation:

| Your integration… | Use |
| --- | --- |
| needs **read only** | **GraphQL** |
| needs read **with filtering, no UI** | **GraphQL** + the `search` argument |
| needs read with filtering **behind a UI** | GraphQL + `CatalogsForApps` (on the roadmap) |
| needs **write only**, or **little data** to fetch+write | **REST** |
| needs **complex relational reads + writes** | **both** — GraphQL to read, REST to write |

In short: reach for GraphQL to **read** rich, related catalog data efficiently on Serenity; stay on REST for **all writes** and for CE/EE-PaaS where GraphQL isn't available.

## Original sources

- `references/sources/akeneo-official-docs/graphql/getting-started.md` — token, first query, headers
- `references/sources/akeneo-official-docs/graphql/browse-graphql-capabilities.md` — GraphiQL IDE
- `references/sources/akeneo-official-docs/graphql/common-notions.md` — pagination, aliasing, `search`
- `references/sources/akeneo-official-docs/graphql/queries-and-arguments.md` — every root query + argument
- `references/sources/akeneo-official-docs/graphql/use-cases.md` — worked example queries + responses
- `references/sources/akeneo-official-docs/graphql/best-practices.md` — attributesToLoad, compression, variables, deprecations
- `references/sources/akeneo-official-docs/graphql/limitations.md` — rate limit, depth table, one-query, assets
- `references/sources/akeneo-official-docs/graphql/advanced.md` — cache, complexity/cost calculation
- `references/sources/akeneo-official-docs/graphql/error-codes.md` — errors array, extensions, 415/429/500
- `references/sources/akeneo-official-docs/graphql/compatibility.md` — edition support matrix
- `references/sources/akeneo-official-docs/graphql/recommendations.md` — GraphQL vs REST decision tree
- `references/sources/akeneo-official-docs/graphql/integration.md` — curl/PHP/Node/Python snippets
- Live GraphQL endpoint + GraphiQL IDE: `https://graphql.sdk.akeneo.cloud`
