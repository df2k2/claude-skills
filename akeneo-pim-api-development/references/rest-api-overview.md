# REST API Overview

A map of the entire Akeneo PIM REST surface and the conventions every endpoint shares — the endpoint catalog, the UUID-vs-identifier product split, upsert (`PATCH`) semantics, pagination, filtering, and response shapes. Every REST call lives under the base path **`{pim}/api/rest/v1/`** (e.g. `https://my-pim.cloud.akeneo.com/api/rest/v1/products`). `{pim}` is the customer's own PIM host — **not** `api.akeneo.com`, which is only the documentation site.

Two machine-readable specs are embedded and are the source of truth for exact request/response shapes (this file is the topical map):

- `references/sources/openapi-specs/saas-openapi.json` — **OpenAPI 3.1.0**, the SaaS/Serenity surface (**152 operations / 92 paths / 94 schemas**). Adds `products-uuid/search`, Catalogs, Workflows, Rule definitions, UI Extensions, the Data Architect Agent, and Permissions.
- `references/sources/openapi-specs/classic-web-api.json` — **Swagger 2.0**, the classic CE/EE on-prem surface (**137 operations / 78 paths**). Adds Published products and the deprecated PAM assets / `measure-families`.

`references/sources/openapi-specs/SPEC-SUMMARY.md` is the flat, greppable catalog of every operation and schema across both. Grep the JSON specs for field-level detail; do not read `saas-openapi.json` whole (it is ~5 MB).

Only **4 HTTP verbs** are used: `GET` (fetch), `POST` (create), `PATCH` (partial update / upsert — creates the resource if it does not exist), `DELETE`.

## Endpoint map of `/api/rest/v1/`

Resource groups below are grouped by role. "Surface" marks where a group lives: **CE/EE** = both specs; **EE** = Enterprise/Serenity only (404s on CE); **SaaS** = Serenity only; **Apps** = App-token concept; **classic** = only in `classic-web-api.json`. Unless noted, list endpoints are paginated and both a bulk `PATCH` (collection) and a single `PATCH`/`POST` exist.

### Catalog structure

| Group | Base path | Ops | Surface |
| --- | --- | --- | --- |
| Families | `/families`, `/families/{code}` | GET, POST, PATCH (bulk+single), DELETE | CE/EE |
| Family variants | `/families/{family_code}/variants`, `/{code}` | GET, POST, PATCH (bulk+single) | CE/EE |
| Attributes | `/attributes`, `/attributes/{code}` | GET, POST, PATCH (bulk+single) | CE/EE |
| Attribute options | `/attributes/{attribute_code}/options`, `/{code}` | GET, POST, PATCH (bulk+single) | CE/EE |
| Attribute groups | `/attribute-groups`, `/attribute-groups/{code}` | GET, POST, PATCH (bulk+single) | CE/EE |
| Association types | `/association-types`, `/association-types/{code}` | GET, POST, PATCH (bulk+single) | CE/EE |
| Categories | `/categories`, `/categories/{code}`, `/category-media-files` | GET, POST, PATCH (bulk+single) | CE/EE |
| Channels | `/channels`, `/channels/{code}` | GET, POST, PATCH (bulk+single) | CE/EE |
| Locales | `/locales`, `/locales/{code}` | **GET only** | CE/EE |
| Currencies | `/currencies`, `/currencies/{code}` | **GET only** | CE/EE |
| Measurement families | `/measurement-families` | GET, PATCH (bulk) — **no `{code}` route** | CE/EE |
| Measure families *(deprecated v5.0)* | `/measure-families`, `/measure-families/{code}` | GET only | classic |

### Product data

| Group | Base path | Ops | Surface |
| --- | --- | --- | --- |
| Products **[identifier]** | `/products`, `/products/{code}` | GET, POST, PATCH (bulk+single), DELETE | CE/EE |
| Products **[uuid]** | `/products-uuid`, `/products-uuid/{uuid}`, `/products-uuid/search` | GET, POST, **POST `/search`**, PATCH (bulk+single), DELETE | CE/EE (uuid since 7.0) |
| Product models | `/product-models`, `/product-models/{code}` | GET, POST, PATCH (bulk+single), DELETE | CE/EE |
| Product media files | `/media-files`, `/media-files/{code}`, `/{code}/download` | GET, POST | CE/EE |
| Drafts / proposals *(EE)* | `…/{code}/draft`, `…/{code}/proposal` | GET draft, POST proposal | EE |
| Published products | `/published-products`, `/published-products/{code}` | **GET only** | EE (classic spec) |

### Enrichment (EE / Serenity)

| Group | Base path | Surface |
| --- | --- | --- |
| Reference entities | `/reference-entities`, `/reference-entities/{code}` | EE |
| Reference entity attributes / options | `/reference-entities/{reference_entity_code}/attributes[/{code}][/options]` | EE |
| Reference entity records | `/reference-entities/{reference_entity_code}/records[/{code}]`; `/reference-entities/records` (all records, SaaS) | EE |
| Reference entity media files | `/reference-entities-media-files[/{code}]` | EE |
| Asset families | `/asset-families`, `/asset-families/{code}` | EE |
| Assets | `/asset-families/{asset_family_code}/assets[/{code}]` | EE |
| Asset attributes / options | `/asset-families/{asset_family_code}/attributes[/{code}][/options]` | EE |
| Asset media files | `/asset-media-files[/{code}]` | EE |
| PAM assets *(deprecated)* | `/assets`, `/asset-categories`, `/asset-tags`, `…/reference-files`, `…/variation-files` | classic |

### Apps, platform & admin

| Group | Base path | Surface |
| --- | --- | --- |
| **API root** (endpoint list) | `GET /api/rest/v1` | CE/EE (see below) |
| Authentication (token) | `POST /api/oauth/v1/token` *(not under `/rest/v1`)* | CE/EE — see authentication.md |
| Catalogs | `/catalogs`, `/catalogs/{id}` (+ `/duplicate`) | Apps (SaaS) |
| Catalog products | `/catalogs/{id}/products`, `/products/{uuid}`, `/product-uuids`, `/mapped-products`, `/mapped-models` | Apps (SaaS) |
| Product mapping schema | `/catalogs/{id}/mapping-schemas/product` (GET/PUT/DELETE) | Apps — see catalogs-and-mapping.md |
| Permissions | `/permissions/{uuid}/channels`, `/permissions/{uuid}/locales` | EE/SaaS |
| Workflows | `/workflows`, `/workflows/{uuid}`, `/workflows/executions`, `/workflows/tasks[/{uuid}]`, `/workflows/steps/{uuid}/assignees` | SaaS |
| Rule definitions | `/rule-definitions`, `/rule-definitions/{code}` (GET/PUT) | SaaS |
| UI Extensions | `/ui-extensions[/{uuid}]` | SaaS |
| Data Architect Agent | `/data-model-designer/modelization-suggestion[s]…` | SaaS |
| Jobs | `POST /jobs/import/{code}`, `POST /jobs/export/{code}` | CE/EE |
| System | `GET /system-information` | CE/EE |

Reference-entity **records** and **reference entities themselves** support only the `search_after` pagination method (see Pagination below). Products, product models, and assets carry a large set of enrichment query params (see Sorting & other query params).

## The API root — list of available endpoints

`GET {pim}/api/rest/v1` returns the host plus the full route table the instance exposes — the authoritative, per-instance list of endpoints and their allowed methods:

```http
GET /api/rest/v1
Accept: application/json

HTTP/1.1 200 OK
{
  "host": "https://mysandbox.demo.cloud.akeneo.com",
  "authentication": {
    "fos_oauth_server_token": { "route": "/api/oauth/v1/token", "methods": ["POST"] }
  },
  "routes": {
    "pim_api_family_list":           { "route": "/api/rest/v1/families",           "methods": ["GET"] },
    "pim_api_family_partial_update": { "route": "/api/rest/v1/families/{code}",     "methods": ["PATCH"] },
    "pim_api_product_delete":        { "route": "/api/rest/v1/products-uuid/{uuid}","methods": ["DELETE"] }
  }
}
```

Per the official docs this route **does not require authentication** — it and the token route (`POST /api/oauth/v1/token`) are the only two routes reachable without a token. Use it as a reachability/capability probe. (Note: `saas-openapi.json` annotates this operation with a `bearerToken` security scheme, which contradicts the prose; the prose and SKILL treat it as unauthenticated.)

## Products: UUID vs identifier

Products are addressable by **two coexisting endpoint families**, both under `/api/rest/v1/`:

| | Identifier family | UUID family |
| --- | --- | --- |
| List / bulk | `/products` | `/products-uuid` |
| Single | `/products/{code}` | `/products-uuid/{uuid}` |
| Search (POST body) | — | `/products-uuid/search` |
| Key field in payload | `identifier` (SKU-like string) | `uuid` (RFC-4122) |
| Availability | all versions, CE/EE | **7.0+ / SaaS**, CE/EE |

- **UUID landed in 7.x**; identifiers are still fully supported. On SaaS both families are live; classic CE/EE pre-7.0 is identifier-only.
- **Do not mix families for the same product** — pick one addressing scheme per integration and stay on it. A `POST` to the wrong family, or a UUID on an identifier route, yields 404/405.
- Product **models** are always addressed by `code` (`/product-models/{code}`); there is no UUID variant for models.
- The `uuid`/`identifier` distinction only affects products. Everything else (families, attributes, categories, channels, …) is keyed by `code`.

Product/model payload shape, the `{locale, scope, data}` value structure, families, and variants are covered in **products-and-models.md** and **catalog-structure.md**.

## Upsert semantics (`PATCH`)

Akeneo has (almost) no separate "create" step — `PATCH` **creates or updates**. `POST` exists on most collections for explicit creation (returns `201`), but `PATCH` is the idiomatic write.

### Single resource — `Content-Type: application/json`

`PATCH /products-uuid/{uuid}` (or `/categories/{code}`, `/families/{code}`, …) applies a **partial merge**, not a replace. The merge rules (`rest-api/update.md`):

1. If a property's value is an **object**, it is **merged** key-by-key with the stored value (e.g. adding one `labels` locale keeps the others).
2. If the value is a **scalar or array**, it **replaces** the stored value wholesale (e.g. `categories: ["boots"]` overwrites the whole list).
3. For objects/arrays the **data types must match** — a type mismatch (e.g. `labels: null`) changes nothing and returns `422`.
4. Any property **not mentioned** is left untouched.

**Product values merge at the `{attribute → [{locale, scope, data}]}` level.** Each `(attribute, locale, scope)` triple is addressed independently: sending one triple adds/overwrites just that triple and leaves siblings intact. To **erase** one value, send it with `"data": null` (the entry stays, its `data` becomes `null`); to leave a value alone, omit it. `locale` is non-null only for *localizable* attributes and `scope` (channel) only for *scopable* ones — getting these wrong is the most common `422`. See products-and-models.md.

Single-write responses: `201 Created` (+ `Location` header) when the resource is created, `204 No Content` when updated or deleted, `200 OK` on GET.

### Bulk collection — `Content-Type: application/vnd.akeneo.collection+json`

`PATCH /products`, `/products-uuid`, `/product-models`, `/categories`, `/attributes`, `/families`, … accept a **newline-delimited JSON** body: **one resource object per line** (not a JSON array). Each line is a standard-format resource; existing resources may use additive keys like `add_categories` / `remove_categories`.

```http
PATCH /api/rest/v1/products-uuid
Content-Type: application/vnd.akeneo.collection+json

{"uuid":"fc24e6c3-933c-4a93-8a81-e5c703d134d5","values":{"description":[{"scope":"ecommerce","locale":"en_US","data":"My amazing cap"}]}}
{"uuid":"573dd613-0c7f-4143-83d5-63cc5e535966","values":{"sku":[{"data":"updated_sku","locale":null,"scope":null}]},"group":["promotion"]}
{"uuid":"25566245-55c3-42ce-86d9-8610ac459fa8","values":{"sku":[{"data":"new_product","locale":null,"scope":null}]},"family":"clothes"}
```

**Limits:** max **100 items per request**; each JSON line ≤ **1,000,000 characters**. Exceeding the item count returns `413 Request Entity Too Large` (a payload too large for the platform can surface as `403` instead).

**Response is always `200 OK` at the HTTP level**, with a body that is itself newline-delimited JSON — one status object per input line, so partial success is normal. Inspect every line's `status_code`:

```
{"line":1,"uuid":"fc24e6c3-933c-4a93-8a81-e5c703d134d5","status_code":204}
{"line":2,"uuid":"573dd613-0c7f-4143-83d5-63cc5e535966","status_code":422,"message":"Property \"group\" does not exist."}
{"line":3,"uuid":"25566245-55c3-42ce-86d9-8610ac459fa8","status_code":201}
```

Per-line `status_code` is `204` (updated), `201` (created), or `422` (validation error, with `message`). The identifier-family bulk endpoint uses `"identifier"` (or `"code"`) instead of `"uuid"` in each status line. The bulk `PATCH` responses (both specs) declare request and success bodies as `application/vnd.akeneo.collection+json`; sending the wrong `Content-Type` returns `415`.

## Pagination

Every list response is HAL-shaped with a `_links` block and `_embedded.items`. Two pagination methods exist, selected by `pagination_type`.

**Common params:** `limit` (results per page; default **10**, **max 100** — >100 returns `422`), `pagination_type` (`page` | `search_after`, default `page`).

### `pagination_type=page` (offset — the default)

Available on all resources. Response carries `current_page`, `_links` (`self`, `first`, plus `previous`/`next` where they exist), and — only when **`with_count=true`** — an `items_count` total:

```http
GET /api/rest/v1/categories?pagination_type=page&page=2&limit=20

{
  "_links": {
    "self":     { "href": ".../categories?page=2&limit=20" },
    "first":    { "href": ".../categories?page=1&limit=20" },
    "previous": { "href": ".../categories?page=1&limit=20" },
    "next":     { "href": ".../categories?page=3&limit=20" }
  },
  "current_page": 2,
  "items_count": 1234,            // only present with with_count=true
  "_embedded": { "items": [ ... ] }
}
```

`with_count` is **expensive on large catalogs** — leave it off unless you need the total. Never build `page`/`search_after` URLs by hand: **follow the `_links` hrefs**. High page numbers slow down and can return duplicates, and there is a hard offset cap: fetching beyond the 10,000th product (e.g. `page=101&limit=100`) returns `422` telling you to switch to `search_after`.

### `pagination_type=search_after` (cursor — recommended for large sets)

**Strongly recommended for high-volume entities**: products, product models, published products, assets, and asset families. For **reference entities, reference entity records, and reference entity attribute options it is the *only* method** (no `pagination_type` needed).

```http
GET /api/rest/v1/products-uuid?pagination_type=search_after&limit=20

{
  "_links": {
    "self":  { "href": ".../products-uuid?pagination_type=search_after&search_after=qaXbcde&limit=20" },
    "first": { "href": ".../products-uuid?pagination_type=search_after&limit=20" },
    "next":  { "href": ".../products-uuid?pagination_type=search_after&search_after=qaXbcdedsfeF&limit=20" }
  },
  "_embedded": { "items": [ ... ] }
}
```

Trade-offs vs. offset:

- Entities are sorted by the product **primary key**; the `search_after` cursor is opaque — **never set it manually**, only follow `_links.next`.
- **No `previous` link, no `current_page`, and no total count** (`with_count` is unavailable here, by design, for speed). You know you are done when there is no `next` link.
- Both methods return the same envelope shape even when `items` is empty.

## Filtering

List endpoints accept the **`search`** query param: a **stringified JSON** object mapping a property (or attribute code) to an array of criteria. Multiple properties are ANDed; multiple criteria on one property are also combined.

```
/api/rest/v1/products-uuid?search={PROPERTY:[{"operator":OP,"value":VALUE,"locale":LOCALE,"scope":SCOPE}]}
```

- Include `"locale"` only when the attribute is **localizable**, `"scope"` (a channel code) only when it is **scopable**.
- Filterable **product properties**: `uuid` / `identifier` (`IN`, `NOT IN`), `categories` (`IN`, `NOT IN`, `IN OR UNCLASSIFIED`, `IN CHILDREN`, `NOT IN CHILDREN`, `UNCLASSIFIED`), `enabled` (`=`, `!=`), `completeness` (`<`,`<=`,`=`,`!=`,`>`,`>=`, plus `…ON ALL LOCALES` variants; needs `scope`), `groups`, `family`, `created` / `updated` (`=`,`!=`,`<`,`>`,`BETWEEN`,`NOT BETWEEN`,`SINCE LAST N DAYS`), `parent`, and `quality_score` (`IN`; needs `scope`+`locale`). EE adds `updated_including_linked_entities` / `updated_including_linked_type`.
- Filtering on **product values** uses the attribute code as the key; the allowed operators depend on the **attribute type** (e.g. text/textarea → `STARTS WITH`, `CONTAINS`, `DOES NOT CONTAIN`, `=`, `!=`, `IN`, `NOT IN`, `EMPTY`, `NOT EMPTY`; number/metric/price → `<`,`<=`,`=`,`!=`,`>=`,`>`; simple/multiselect → `IN`,`NOT IN`,`EMPTY`,`NOT EMPTY`; date → `<`,`=`,`!=`,`>`,`BETWEEN`,`NOT BETWEEN`).
- Product models filter on the same properties (`identifier`, `categories`, `completeness` with `AT LEAST` / `ALL COMPLETE|INCOMPLETE`, `family`, `created`/`updated`, `parent`) plus their values (since v2.3).

**Examples:**

```
# enabled AND 70%+ complete on ecommerce
/api/rest/v1/products-uuid?search={"enabled":[{"operator":"=","value":true}],"completeness":[{"operator":">","value":70,"scope":"ecommerce"}]}

# name contains "shirt" on en_US / mobile (localizable + scopable attribute)
/api/rest/v1/products-uuid?search={"name":[{"operator":"CONTAINS","value":"shirt","locale":"en_US","scope":"mobile"}]}
```

**Helper params to avoid repetition:** `search_locale` (apply one locale to every criterion missing a `locale`) and `search_scope` (same for `scope`).

**Long filters → POST search.** `POST /api/rest/v1/products-uuid/search` takes the same filter (as a `search` string) plus `scope`/`locales`/pagination in a JSON body, sidestepping URL-length limits. (SaaS + classic.)

**Asset filtering (EE/SaaS)** additionally supports explicit logical operators — a single root `and` **or** `or`, freely nestable, over asset properties (`code`, `updated`, `complete`) and attribute values. See **assets-filter-logical-operators.md** and reference-entities-and-assets.md.

## Response envelope & content types

- **List responses:** HAL — top-level `_links` (`self`/`first`/`previous`/`next`, each `{ "href": … }`), optional `current_page` / `items_count`, and `_embedded.items[]`. Each item carries its own `_links.self`.
- **Single-resource responses:** the bare resource object in Akeneo standard format (no HAL wrapper), e.g. a product's `uuid`/`identifier`, `family`, `categories`, `values`, `associations`, `created`, `updated`.
- **Content-type headers:** `Accept: application/json` is optional on reads (any other value → `406`). `Content-Type: application/json` is **mandatory** on single `POST`/`PATCH` (missing or other value → `415`). Bulk `PATCH` uses `Content-Type: application/vnd.akeneo.collection+json`.
- **Errors** return the matching 4xx/5xx status with a JSON body (`code`, `message`, and often an `errors[]` array or a `_links.documentation`). Full status-code catalog, batch/rate limits, and retry guidance are in **errors-and-rate-limits.md**.

## Sorting & other common query params

- **Sorting is not user-controllable on product lists** — there is no `sort` param. Under `search_after` results come back ordered by primary key; the offset method returns the same primary-key order. Order data client-side if you need a different sort.
- **Value-trimming (products / product models / published products):** `attributes` (comma-separated attribute codes to return), `locales` (return only these locales' values plus non-localizable ones), `scope` (return only this channel's scopable values plus non-scopable ones). These shrink each item's `values`; they do **not** filter which products come back (that is `search`).
- **Enrichment flags (default `false`; product endpoints unless noted):** `with_count` (adds `items_count`), `with_attribute_options` (option labels via `linked_data`, 5.0+), `with_table_select_options` (7.0+), `with_quality_scores` (5.0+ products / 6.0+ models), `with_completenesses` (6.0+), `convert_measurements`, `with_asset_share_links`, `with_enabled_assets_only`, `with_root_parent`, `with_workflow_execution_statuses` (SaaS). Categories add `with_position` / `with_enriched_attributes`.

## Quick reference — conventions at a glance

| Concern | Rule |
| --- | --- |
| Base path | `{pim}/api/rest/v1/…` (customer host, not `api.akeneo.com`) |
| Verbs | GET / POST / PATCH (upsert) / DELETE only |
| Create-or-update | `PATCH` single (`application/json`) or bulk (`application/vnd.akeneo.collection+json`) |
| Bulk body | newline-delimited JSON, ≤100 items, ≤1,000,000 chars/line, always HTTP 200 + per-line `status_code` |
| Product addressing | `/products/{code}` (identifier) **or** `/products-uuid/{uuid}` (7.0+); never mix |
| Page limit | `limit` default 10, max 100 |
| Big lists | `pagination_type=search_after`, follow `_links.next`, no total count |
| Filter | `?search={…stringified JSON…}` (or `POST /products-uuid/search`) |
| Trim returned values | `attributes` / `locales` / `scope` |
| Single-write success | 201 (created, + `Location`) / 204 (updated·deleted) |

## Original sources

- `references/sources/openapi-specs/saas-openapi.json` (OpenAPI 3.1.0) and `classic-web-api.json` (Swagger 2.0) — the two authoritative specs; `SPEC-SUMMARY.md` is the flat operation/schema catalog. Bulk `PATCH` request/response content type `application/vnd.akeneo.collection+json` and the per-line status body verified in both (`classic-swagger-src/resources/products_uuid/routes/products_uuid.yaml`), pagination `_links`/`current_page`/`items_count` fields verified in the `Pagination` / `SearchAfterPagination` definitions and the Postman schema.
- `references/sources/akeneo-official-docs/rest-api/` — `overview.md` (root endpoint, verbs, headers), `pagination.md` (page vs search_after, limits, offset cap), `filter.md` (`search` grammar, operators, `search_locale`/`search_scope`, value-trimming), `update.md` (PATCH merge rules, product-value upsert/erase), `responses.md` (status codes), `good-practices.md` (concurrency/rate guidance), `assets-filter-logical-operators.md` (asset AND/OR filters).
- Cross-references: authentication.md, products-and-models.md, catalog-structure.md, reference-entities-and-assets.md, catalogs-and-mapping.md, errors-and-rate-limits.md.
