# Errors, Rate Limits, and Pagination Caps

How the Akeneo PIM REST API signals failure, the exact shapes of its error bodies (including per-line bulk results and per-property `422` validation errors), the documented rate-limit / concurrency ceilings, the hard pagination caps, and a symptom → cause → fix table. Everything here is grounded in the vendored specs and docs; nothing is invented.

> **`code` is the numeric HTTP status, not a string error slug.** Unlike many APIs, Akeneo's error `code` field echoes the HTTP status as an **integer** (`401`, `422`, …). There is no machine-readable string error code — you branch on the HTTP status and parse `message` for humans. Parse defensively; some errors add `errors[]` or `_links`, most don't.

## Error response shape

Almost every 4xx returns the **standard two-field body** (spec schema `response_error` / classic `Error`):

```json
{
  "code": 422,
  "message": "Validation failed."
}
```

Two documented variants extend it:

1. **With a documentation link** (`response_error_with_link`) — returned for some `422`s (unknown property, wrong data type):
   ```json
   {
     "code": 422,
     "message": "Property 'extra_property' does not exist. Check the standard format documentation.",
     "_links": { "documentation": { "href": "https://.../standard_format/..." } }
   }
   ```
2. **With a validation `errors[]` array** — returned when field-level validation of a product/record write fails (see [The 422 validation body](#the-422-validation-body-errors)).

## HTTP status code summary

| Status | Meaning in Akeneo | Typical cause | What to do |
| --- | --- | --- | --- |
| **200 OK** | GET of a resource/collection succeeded; **also** the response for a bulk `PATCH` collection (body is newline-delimited per-line JSON) | — | Use the body. For bulk, inspect each line's `status_code`. |
| **201 Created** | A resource was created | POST/PATCH created a new entity | Read the `Location` header for its URL. |
| **204 No Content** | A single resource was updated or deleted | PATCH/DELETE on one resource | Success, empty body. `Location` header points at the resource. |
| **400 Bad Request** | Malformed JSON | Missing comma/quote, non-JSON body | Fix the JSON; don't retry as-is. |
| **401 Unauthorized** | No/!valid authentication | Missing `Authorization` header, `Basic` where `Bearer` is required (or vice-versa), expired Connection token (1h) | Re-check the auth model / refresh the token → `authentication.md`. |
| **403 Forbidden** | Authenticated but not permitted **or** payload too large | Missing ACL for the action; **or** an over-large request the platform refuses (see note) | Grant the ACL, or split the payload into smaller chunks. |
| **404 Not Found** | Resource doesn't exist **or** caller lacks permission to see it | Wrong code/UUID; EE-only resource on CE; **or** a permission masking the resource | Verify the code and edition; check the user's permissions. |
| **405 Method Not Allowed** | Verb not implemented on that route | e.g. `POST` to `/products-uuid/{uuid}` (only `GET,PATCH,DELETE`) | Use an allowed method (the `Allow` list is in `message`). |
| **406 Not Acceptable** | `Accept` header isn't `application/json` | Wrong `Accept` on a GET | Send `Accept: application/json`. |
| **409 Conflict** | Request conflicts with current state | Concurrent requests hitting the same resource; resource deleted mid-process | Re-fetch state and retry the logical operation. |
| **413 Request Entity Too Large** | Batch too big / payload too large | > 100 items in one bulk request, or a JSON line > 1,000,000 chars | Split into ≤ 100-item batches; shrink lines. |
| **415 Unsupported Media Type** | `Content-type` isn't `application/json` (or is missing) | Forgot `Content-Type: application/json` on POST/PATCH | Set the header on every write. |
| **422 Unprocessable Entity** | Data understood but invalid | Bad locale/scope, unknown attribute/option, wrong data type, `limit > 100`, offset cap exceeded, bad OAuth params | Read `message`/`errors[]`; fix the data → `products-and-models.md`. |
| **429 Too Many Requests** | Rate limit tripped | Too many req/s or too many concurrent calls | Honor `Retry-After` if present, else exponential backoff + jitter. |
| **5xx (500/502/503/504)** | Server-side / gateway error | Transient server condition, overload | Retry with exponential backoff + jitter (writes are usually idempotent — see below). |

> **403 vs 413 for oversized payloads:** the docs warn that a payload too large for the platform can surface as **either** `413` **or** `403`. If you get an unexpected `403` on a large write, try smaller batches before assuming an ACL problem.

> **404 can mean "no permission."** Akeneo notes that a "does not exist" answer may actually mean the API user isn't allowed to see the resource. Rule out permissions before assuming a bad code.

## The 422 validation body (`errors[]`)

For product / product-model / reference-entity / asset writes, a validation failure returns `message: "Validation failed."` plus an **`errors[]` array with one entry per invalid value**. This is the single most common write failure and the shape you must parse:

```json
{
  "code": 422,
  "message": "Validation failed.",
  "errors": [
    {
      "property": "values",
      "message": "The tommh value is not in the brand attribute option list.",
      "attribute": "brand",
      "locale": null,
      "scope": null
    }
  ]
}
```

Per-error fields (all except `property`/`message` are nullable):

| Field | Meaning |
| --- | --- |
| `property` | The invalid property (usually `values`, or a top-level field like `family`). |
| `message` | Human-readable reason. |
| `attribute` | Attribute code the error is on (`null` if not attribute-specific). |
| `locale` | Locale code involved (`null` if not localizable / not the cause). |
| `scope` | Channel code involved (`null` if not scopable / not the cause). |

`attribute` + `locale` + `scope` together pinpoint which `{locale, scope, data}` value entry Akeneo rejected — invaluable for the classic "wrong locale/scope on a value" `422`. See `products-and-models.md` for the value model and `common-pitfalls.md` for the frequent offenders.

Two other `422` flavors carry **no** `errors[]`, only `message` (+ optional `_links`): unknown property (`"Property 'x' does not exist…"`) and wrong data type on a merge (`"Property 'labels' expects an array as data, 'NULL' given."`). The PHP client surfaces the array via `$e->getResponseErrors()` on `UnprocessableEntityHttpException` (empty array when the body has none).

## Bulk / collection responses (newline-delimited PATCH)

A `PATCH` (or `POST`) to a **collection** endpoint (`/products`, `/products-uuid`, `/categories`, `/attributes`, …) takes a body of **one JSON object per line** and returns **`200 OK` whose body is itself newline-delimited JSON — one status object per input line**. The overall HTTP status is `200` even if individual lines failed; you **must** inspect each line.

Per-line object (spec schema `ErrorByLine`; `ErrorByLineProductUuid` for the UUID product route):

| Field | Meaning |
| --- | --- |
| `line` | 1-based line number in the request body. |
| `identifier` | Product identifier — only on the identifier product route. |
| `uuid` | Product UUID — only on `/products-uuid`. |
| `code` | Resource code — for non-product resources (categories, attributes, …). |
| `status_code` | Per-line HTTP status: `201` created, `204` updated, `422`/`400`/… failed. |
| `message` | Failure reason — present only when `status_code` is an error. |

Example response body (identifier products — three input lines, mixed outcome):

```
{"line":1,"identifier":"cap","status_code":204}
{"line":2,"identifier":"mug","status_code":422,"message":"Property \"group\" does not exist."}
{"line":3,"identifier":"tshirt","status_code":201}
```

UUID route (`/products-uuid`) — same shape with `uuid` instead of `identifier`:

```
{"line":1,"uuid":"fc24e6c3-933c-4a93-8a81-e5c703d134d5","status_code":204}
{"line":2,"uuid":"573dd613-0c7f-4143-83d5-63cc5e535966","status_code":422,"message":"Property \"group\" does not exist."}
```

Non-product collections (e.g. attribute options) use `code` instead: `{"line":2,"code":"red","status_code":422,"message":"Property \"label\" does not exist…"}`.

The PHP client returns these as an iterable of associative arrays from `upsertList(...)` — read `$line['line']`, `$line['identifier']`/`['uuid']`, `$line['status_code']`, and `$line['message']` (see `php-client.md`). Whole-batch failures (auth, batch too big, wrong content-type) still return the normal top-level `401`/`403`/`413`/`415` bodies, not per-line JSON.

**Workflow executions (`POST /workflows/executions`) use a different multi-status shape** — HTTP **`207`** with a top-level summary rather than per-line JSON:

```json
{
  "code": 207,
  "message": "Workflow executions started with some errors",
  "processed": 2,
  "errors": [
    { "index": 3, "message": "Cannot start workflow execution: Workflow with UUID ... does not exist or is not enabled." }
  ]
}
```

## Rate limits and concurrency

**Official numbers exist** — Akeneo publishes concrete ceilings in `rest-api/good-practices.md` (these govern the **hosted platform**: Serenity SaaS, Growth Edition, and Akeneo-hosted PaaS):

| Limit | Value |
| --- | --- |
| Concurrent calls **per PIM connection** | **4** |
| Concurrent calls **per PIM instance** | **10** |
| General request rate **per PIM instance** | **100 requests / second** |
| Creating/updating **attribute options** (`PATCH /attributes/{code}/options`) | **3 requests / second** per instance |

Bursts are tolerated, but *sustained* over-usage trips the protection sooner and returns **`429`**. There is no published per-tier table, no token-bucket cost list, and no `X-RateLimit-*` headers — the four numbers above are the whole documented surface.

**Handling a 429.** The response may include a **`Retry-After` header** (seconds to wait); the docs describe it as added to `429`s, while the good-practices guidance says to honor it *if present*. So: **honor `Retry-After` when the header is there; otherwise fall back to exponential backoff with jitter.** The PHP client exposes it via `$e->getRetryAfter()` on `TooManyRequestsHttpException`. The `429` body is the standard `{code, message}` (`"You have exceeded the limit of API requests per second."`).

**Which responses to retry** (per `good-practices.md`): **`408`, `429`, and all `5xx`**, plus socket timeouts / TCP disconnects. Do **not** retry `400`/`401`/`403`/`404`/`405`/`406`/`415`/`422` — those are your bug; fix the request. Recommended retry policy:

- **Exponential backoff with jitter** — e.g. 1s, 2s, 4s, 8s, 16s, plus a small random offset to avoid a thundering herd.
- **Cap attempts** at ~5–8; alert past that.
- **Rely on idempotency** — an upsert (`PATCH` a product) run twice yields the same result, so retrying after a stall/timeout is safe. A bare create (`POST`) is *not* idempotent (a second call makes a second resource); prefer `PATCH`-upsert for retry-safe writes.
- **Cache catalog data** (families, attributes, channels, locales — they change rarely) and **use the bulk/batch endpoints** to cut request count.

**SaaS vs on-prem.** The numbers above are the *hosted* platform's protection. A **self-managed Community/Enterprise** instance you host yourself has **no Akeneo-imposed rate limiter** — throughput is bounded by your own server sizing — but the same concurrency discipline is prudent, and a fronting reverse-proxy / load balancer can still emit `429`/`503` under load. Never assume "on-prem = unlimited."

## Pagination limits

Full mechanics live in `rest-api-overview.md`; the hard caps that produce errors:

| Cap | Value | Failure if exceeded |
| --- | --- | --- |
| `limit` (page size) | **max 100** (default 10) | `422 "You cannot request more than 100 items."` |
| Offset (`page`) pagination depth | ~**10,000 items** (e.g. `page=101&limit=100`) | `422 "You have reached the maximum number of pages … Please use the search after pagination type instead"` |
| Items per **bulk** request | **max 100** | `413 "Too many resources to process, 100 is the maximum allowed."` |
| Individual JSON **line** length (bulk body) | **1,000,000 characters** | `413` |

Consequences: paginate large collections (products, product models, published products, assets, reference entities/records) with **`search_after`**, not `page` — `search_after` has no offset cap, avoids duplicates, and is the *only* method available for reference entities and their records. `search_after` responses omit any total count (`with_count` is unavailable) and expose navigation only through the `_links` (`self`/`first`/`next`) HAL links — never hand-craft the `search_after` cursor or `page` value. See `rest-api-overview.md`.

## Troubleshooting: symptom → cause → fix

Mirrors `rest-api/troubleshooting.md` plus the most common status-code failures:

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `422 "Parameter \"client_id\" is missing … or secret is invalid"` on the token call | `client_id:secret` base64 encoded with a trailing newline | Encode with `echo -n "client_id:secret" \| base64` (the `-n` matters). → `authentication.md` |
| Same `422` even with correct base64 | Apache stripped the `Authorization` header | Add `SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1` to the vhost. |
| `401 "Authentication is required"` | Missing header, or `Basic` used for API calls (only the *token* request is `Basic`; API calls are `Bearer`) | Send `Authorization: Bearer <token>`; re-check the auth model. → `authentication.md` |
| `401` after ~1 hour of a working Connection | Connection access token expired (`expires_in: 3600`) | Refresh with the refresh token (valid 14 days), or re-request. → `authentication.md` |
| `403 "… not allowed to administrate …"` | API user lacks the ACL for that action | Grant the permission in the PIM; or the payload is too large → split it. |
| `404 "… does not exist"` on a code you know exists | Wrong edition (EE-only resource on CE), wrong product route (`/products` vs `/products-uuid`), **or** the user lacks permission to see it | Confirm edition/route; check the user's permissions. |
| `415` on every write | Missing/incorrect `Content-Type` | Send `Content-Type: application/json`. |
| `422` with `errors[]` citing `attribute`/`locale`/`scope` | Wrong `locale`/`scope` on a value, or unknown attribute/option code | Match the attribute's localizable/scopable flags; verify option codes. → `products-and-models.md`, `common-pitfalls.md` |
| Bulk `PATCH` returned `200` but some products didn't change | Per-line failures — `200` is the envelope, not per-item success | Parse each line's `status_code`/`message`; retry only the failed lines. |
| `413` on a bulk write | > 100 items, or a line > 1,000,000 chars | Chunk into ≤ 100-item batches. |
| Just-`POST`ed product missing from a filtered `GET` search | Read-after-write eventual consistency (search index lags the primary store) | Fetch by ID/code (not search) if you need it immediately; otherwise allow indexing latency. |
| Redirected to a login/connection page on every API route | `security.yml` firewall keys out of order (project upgraded from ≤ 1.6) | Order `oauth_token` → `api_index` → `api` **before** `main`. (on-prem only) |
| Persistent `429` while seemingly slow | Concurrency ceiling hit (4/connection, 10/instance), not just req/s | Cap in-flight requests; add backoff + jitter; cache catalog reads. |
| `429` specifically when writing attribute options | That endpoint is capped at **3 req/s** | Throttle attribute-option writes; batch them. |

## Original sources

- `references/sources/akeneo-official-docs/rest-api/responses.md` — canonical status-code list and body examples (400/401/403/404/405/406/409/413/415/422/429 + 200/201/204).
- `references/sources/akeneo-official-docs/rest-api/troubleshooting.md` — missing-client-id, header-stripping, firewall order, read-after-write consistency.
- `references/sources/akeneo-official-docs/rest-api/good-practices.md` — the documented concurrency/rate limits (4/10 concurrent, 100 req/s, 3 req/s for attribute options), `429` + `Retry-After` handling, and the retry (408/429/5xx, backoff-with-jitter) guidance.
- `references/sources/akeneo-official-docs/rest-api/pagination.md` — `limit` max 100, offset cap (~10,000), `search_after` vs `page`.
- `references/sources/akeneo-official-docs/rest-api/update.md` — PATCH merge rules; a `null`-to-array `422` example.
- `references/sources/akeneo-official-docs/php-client/exception.md` — the PHP client exception hierarchy, `getResponseErrors()`, `getRetryAfter()`.
- `references/sources/akeneo-official-docs/php-client/resources/products/products.md` — `upsertList()` per-line result fields (`line`, `identifier`, `status_code`, `message`).
- `references/sources/openapi-specs/saas-openapi.json` — response components `422` (with `errors[]` of `property`/`message`/`attribute`/`locale`/`scope`), `422_with_link`, `429`, `413`, `409`, `207_post_workflow_execution`; schemas `response_error`, `response_error_with_link`.
- `references/sources/openapi-specs/classic-swagger-src/definitions.yaml` — `Error`, `ErrorByLine`, `ErrorByLineProductUuid`, `ErrorByObject` schemas; `classic-swagger-src/resources/products*/routes/*.yaml` — bulk per-line `200` examples.
