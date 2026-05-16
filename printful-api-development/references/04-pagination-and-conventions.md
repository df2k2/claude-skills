# 04 — Pagination and conventions

## Pagination

### v1 — offset/limit with `paging` envelope

Every list endpoint accepts two query parameters:

| Parameter | Default | Max | Meaning |
|---|---|---|---|
| `offset` | `0` | — | Items to skip from the beginning |
| `limit` | `20` (most), `10` (orders) | `100` | Items per page |

The response wraps the array under `result` and adds a `paging` block:

```json
{
  "code": 200,
  "result": [ { "id": 1 }, { "id": 2 } ],
  "paging": {
    "offset": 0,
    "limit": 20,
    "total": 137
  }
}
```

Iterate by incrementing `offset` by `limit` until `offset >= total` or you receive fewer items than `limit`. **Do not call list endpoints in tight loops** — at `limit=100` a 10 000-item store needs 100 calls, which on v1 burns through half your minute-rate-limit.

### v2 — same shape, uniformized

v2 keeps `offset` + `limit` but standardizes them across every endpoint and adds HATEOAS links:

```json
{
  "data": [ { "id": 1 }, { "id": 2 } ],
  "paging": {
    "offset": 0,
    "limit": 20,
    "total": 137
  },
  "_links": {
    "self":  { "href": "https://api.printful.com/v2/orders?offset=0&limit=20" },
    "next":  { "href": "https://api.printful.com/v2/orders?offset=20&limit=20" },
    "prev":  { "href": null }
  }
}
```

Prefer following `_links.next.href` over manually computing the next offset — it preserves any other query parameters and is robust to query-string changes in future API versions. If `_links.next.href` is `null` or absent, you're at the last page.

### Sorting and filtering

Sorting differs per endpoint. Common parameters on v2:

- `sort` — comma-separated field list; prefix with `-` for descending (e.g. `sort=-created_at,name`).
- `filters[<field>]` — field-level filter (e.g. `filters[status]=draft`).

Catalog v2 supports rich filtering, e.g.:

- `?categories_ids=24,25` — limit to categories.
- `?techniques=dtg,embroidery` — limit by print technique.
- `?placements=front,back` — limit by available placement.
- `?colors=red,blue` — limit by available color.

See the per-endpoint reference for the exact filter list.

## Naming and casing

- Request and response JSON is **`snake_case`**. Examples: `external_id`, `catalog_variant_id`, `retail_costs`, `placement_id`, `country_code`, `state_code`.
- HTTP headers are conventional kebab-case (`Authorization`, `X-PF-Store-Id`, `X-PF-Language`, `X-Ratelimit-*`).
- Query parameter casing matches request body casing — `snake_case` everywhere.

## Time

- v2: ISO 8601 in UTC, e.g. `"2026-05-16T18:42:31Z"`. Never with a timezone offset other than `Z`.
- v1: Unix epoch (integer seconds since 1970-01-01 UTC) on most fields. A few endpoints inherited the ISO format during partial migrations — always confirm by inspecting the response.

Inputs follow the same rule per version: v1 takes epoch ints, v2 takes ISO 8601 UTC strings.

## Currency and prices

- v2 returns **prices as strings with up to 2 decimal places**: `"19.95"`, `"100.00"`, `"3.5"` (trailing zero may or may not be present). Parse as fixed-decimal, not as float, to avoid IEEE-754 rounding errors when summing.
- v1 returns **prices as numbers** (floats). The same caution about floating-point applies.
- Order responses are in the **store's payout currency** (set in the Printful dashboard). On the catalog endpoints you can request a different currency via `?currency=USD` where supported.
- Supported currencies (per Printful's billing UI): USD, EUR, GBP, CAD, AUD, JPY, MXN, NOK, SEK, CHF, ILS, BRL, NZD, RON, PLN, BGN, CZK, DKK, HUF, AED, INR, PHP, COP, HKD, THB, TWD. The catalog `?currency=` parameter only accepts a subset of these — non-supported values return a `422`.

## IDs

| Field | Notes |
|---|---|
| `id` (numeric) | Printful's internal ID. Stable within the resource type. |
| `external_id` (string) | **Your** ID. Pass it on order creation; recover the order later with `GET /v2/orders?external_id=…` or v1 `GET /orders/@{external_id}`. Max length is 32 ASCII chars; allowed characters include letters, digits, `_`, `-`, `.`. |
| `catalog_product_id` / `catalog_variant_id` | Identifies blank items in the catalog. Variant IDs are global and stable; do not store the **name** as the identifier. |
| `sync_product_id` / `sync_variant_id` | Identifies merchant-store-mapped items (v1 only). Each `sync_variant` has a `variant_id` pointing at the catalog. |
| `store_id` | Identifies a Printful store. Multi-store apps must specify it. |
| `task_key` / `task_id` | Identifies async jobs (mockup, order estimation, file processing). |
| `placement_id` | Identifies a print location on a product (`front`, `back`, `embroidery_chest_left`, etc.). |

### v1 external_id quirk

To `GET` a v1 order by external ID, **prefix with `@`**:

```bash
curl https://api.printful.com/orders/@my-order-001 -H "Authorization: Bearer $PF_TOKEN"
```

Without the `@`, Printful treats `my-order-001` as an internal numeric ID and returns `404`. v2 dropped this convention — use the query parameter form `GET /v2/orders?external_id=my-order-001`.

## Headers you may want to send

| Header | When |
|---|---|
| `Authorization: Bearer …` | Always (or HTTP Basic for legacy store key on v1). |
| `Content-Type: application/json` | Every request with a body. |
| `Accept: application/json` | Optional — JSON is the default. |
| `X-PF-Store-Id: {store_id}` | Multi-store OAuth tokens. Picks the active store. |
| `X-PF-Language: {locale}` | Translate human-readable strings (product titles, type names). See [`11-countries-and-localization.md`](11-countries-and-localization.md). |
| `User-Agent: <your app>/<version>` | Strongly recommended — helps Printful diagnose issues. |

## Response headers you may want to read

| Header | When |
|---|---|
| `X-Ratelimit-Limit`, `X-Ratelimit-Remaining`, `X-Ratelimit-Reset`, `X-Ratelimit-Policy` | Always (see `03-rate-limits-and-errors.md`). |
| `Retry-After` | On `429` and some `5xx` responses. |
| `Content-Type` | `application/json` vs `application/problem+json` distinguishes v2 error formats. |
| `Location` | On a few async-task creates — points at the polling URL. |

## Boolean and null conventions

- Booleans are real JSON booleans, never `"true"` strings or `1`/`0`.
- A field that is *not applicable* is **omitted** in v2 responses, set to `null` in some v1 responses. When you build code that walks fields, expect both.
- On request bodies, sending `null` for an optional field is allowed but has the same meaning as omitting it. Sending `""` (empty string) is **not** the same as `null` — for most string fields it triggers a validation error.

## Idempotency

There is no `Idempotency-Key` header. The two pragmatic substitutes:

1. **For order creation**: pass an `external_id`. A retry of the same `POST /v2/orders` with the same `external_id` returns `409 Conflict`; `GET` the order by `external_id` to recover it.
2. **For file upload**: Printful **deduplicates by URL**. Sending the same `url` twice returns the same `file.id` — no new file is created. This is safe to retry, with one caveat: if you changed the file content but kept the URL, the deduplicated record still points at the old bytes. Bust the cache by appending `?v={timestamp}` to the URL.

## Original sources

- Pagination block: see `Paging` schema in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
- Localisation tag: `tags[name=Localisation].description` in [`sources/printful-v2-openapi.json`](sources/printful-v2-openapi.json).
