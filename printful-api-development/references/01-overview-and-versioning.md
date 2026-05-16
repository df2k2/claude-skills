# 01 — Overview and versioning

## Base URL

```
https://api.printful.com
```

There is **one production host**. There is no `staging.api.printful.com`, no `sandbox.printful.com`, and no regional shards. The same host serves both v1 and v2.

## API versions

Printful runs two versions side by side:

| | v1 | v2 (open beta) |
|---|---|---|
| Path prefix | none (e.g. `/orders`, `/store/products`) | `/v2/` (e.g. `/v2/orders`) |
| Status | Stable, mature, will not be retired in the near term | Open beta, production-ready, marked `2.0.0-beta` in OpenAPI |
| Response envelope | `{ "code": 200, "result": …, "paging"?: { "offset", "limit", "total" } }` | `{ "data": …, "paging"?: …, "_links"?: … }` |
| Error format | `{ "code": 4xx, "result": "message", "error": { "reason", "message" } }` | RFC 9457 Problem Details (`application/problem+json`) — except a handful of endpoints still on the legacy format |
| Rate limiting | Fixed 120/min + 60-sec lockout | Leaky bucket, default `120;w=60`, RFC `X-Ratelimit-*` headers |
| Time format | Unix epoch on most fields | ISO 8601, UTC |
| Price format | Float | String with ≤2 decimals (e.g. `"19.95"`) |
| Auth | OAuth Bearer **or** legacy store key (HTTP Basic) | OAuth Bearer only |
| Multi-store | `Authorization` header with OAuth + optional `X-PF-Store-Id` | Same |

### Why both exist

v1 (sometimes called the "Store API") has been around since Printful's launch. v2 was introduced in 2024 to fix design-data limitations (multiple layers per placement, embroidery thread auto-detection), error consistency, and webhook security. **v2 is the recommended target for new integrations.** v1 is not deprecated and continues to receive bug fixes, but new features (approval sheets, warehouse products, signed webhooks, store statistics) land on v2 only.

### What's exclusive to each

**v2 only** — there is no v1 equivalent:
- `/v2/approval-sheets` (and the `approval_sheet_created` webhook event)
- `/v2/warehouse-products`
- `/v2/stores/{store_id}/statistics`
- `/v2/oauth-scopes`
- Signed webhooks (HMAC-SHA256 + secret key + expiration)
- Catalog mockup styles, mockup templates, prices, availability per region
- Itemized order building (create draft → add items → confirm)
- Multi-layer design data with positioning per layer

**v1 only** — no v2 equivalent yet:
- `/store/products` and `/store/variants` (Sync Products and Sync Variants — the merchant's external SKU mapping)
- `/tax/rates` and `/tax/countries`
- `/mockup-generator/printfiles/{product_id}` (low-level printfile metadata for building a custom mockup UI)
- `/mockup-generator/templates/{product_id}` (template image + variant mapping)
- `/orders/estimate-costs` (synchronous; v2 replaces with the async `/v2/order-estimation-tasks`)

**Both** — pick the version that matches the rest of your integration:
- Orders CRUD
- Mockup generation (v1 `/mockup-generator/create-task/{product_id}` ↔ v2 `/v2/mockup-tasks`)
- Catalog browse (v1 `/products` ↔ v2 `/v2/catalog-products`)
- Shipping rates (v1 `/shipping/rates` ↔ v2 `/v2/shipping-rates`)
- Webhooks (v1 `/webhooks` ↔ v2 `/v2/webhooks/{eventType}`)
- Countries (v1 `/countries` ↔ v2 `/v2/countries`)
- Files (v1 `/files` is **gone — returns HTTP 410**; the v1 file flow used to allow upload-by-URL but the explicit endpoint was retired; use v2 `/v2/files` instead, or just pass file URLs inline when creating orders)

## Response envelopes — examples

### v1 success

```http
HTTP/1.1 200 OK
Content-Type: application/json
```

```json
{
  "code": 200,
  "result": {
    "id": 12345678,
    "external_id": "my-order-001",
    "status": "draft"
  }
}
```

### v1 list with paging

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

### v2 single resource

```json
{
  "data": {
    "id": 12345678,
    "external_id": "my-order-001",
    "status": "draft"
  }
}
```

### v2 list

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
    "next":  { "href": "https://api.printful.com/v2/orders?offset=20&limit=20" }
  }
}
```

### v1 error

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json
```

```json
{
  "code": 400,
  "result": "Missing required field 'recipient'",
  "error": {
    "reason": "ValidationError",
    "message": "Missing required field 'recipient'"
  }
}
```

### v2 error (RFC 9457)

```http
HTTP/1.1 400 Bad Request
Content-Type: application/problem+json
```

```json
{
  "type": "https://developers.printful.com/docs/v2-beta/#errors/validation-error",
  "status": 400,
  "title": "Validation Error",
  "detail": "The request data is not valid",
  "instance": "01HZ8…",
  "errors": [
    {
      "source": { "pointer": "/recipient/zip" },
      "detail": "The zip is required."
    }
  ]
}
```

### Endpoints still on v1-style errors inside v2

Per the OpenAPI spec, the following v2 endpoints have **not yet** migrated to RFC 9457 and still return v1-style error JSON:

- **Catalog**: every `GET /v2/catalog-*` endpoint (products, variants, categories, sizes, prices, images, mockup-templates).
- **Orders**: `getOrders`, `createOrder`, `updateOrder`, `getOrder`, `confirmOrder`, `getItemById`, `updateItem`, `deleteItemById`, `getShipments`, `getInvoice`.
- **Order estimation tasks**: both endpoints.
- **Shipping rates**: `calculateShippingRates`.
- **Files**: `addFile`, `getFile`.
- **Mockup generator**: both endpoints.
- **Stores**: `getStores`, `getStoreById`, `getStoreStatisticsById`.
- **Warehouse products**: both endpoints.
- **OAuth scopes**: `getOAuthScopes`.

Treat the `Content-Type` of the error response as the source of truth at runtime — `application/problem+json` ⇒ RFC 9457, `application/json` ⇒ legacy.

## Locale and currency

- Default response language: English (US).
- To translate human-readable strings (product titles, descriptions, type labels), send **`X-PF-Language: <locale>`** where `<locale>` ∈ `en_US`, `en_GB`, `en_CA`, `es_ES`, `fr_FR`, `de_DE`, `it_IT`, `ja_JP`.
- Currency on order responses is the **store's configured payout currency**, set in the Printful dashboard. To request prices in a different currency on the catalog endpoints, send `?currency=USD` (or another ISO-4217 code that Printful supports). Not every endpoint accepts a currency override — check the per-endpoint reference.

## Migration path: v1 → v2 in practice

For an existing v1 integration, the minimum-disruption migration is:

1. **Switch auth to OAuth Bearer** if you're still on legacy store-key Basic Auth — same token works for both versions, makes the rest of the migration easier.
2. **Pick a single endpoint family** (orders, mockup generator, or catalog) and migrate it in isolation. Keep the rest of the code on v1.
3. **Update path** to add `/v2/` prefix.
4. **Update response handling** from `response.result` to `response.data`.
5. **Update error handling** to recognise both the legacy format and `application/problem+json`.
6. **Update price/date parsing** — v2 returns prices as strings, dates as ISO 8601 UTC.
7. **For orders**: switch from "create order with all items in one request" to "create draft, add items, confirm". The single-request flow still works, but the itemized flow makes inventory checks and cost preview easier.
8. **For webhooks**: configure signing on v2 events (`POST /v2/webhooks` with `default_expires_at` and `secret_key`). Update your handler to verify `X-PF-Signature`.

## Original sources

- Embedded OpenAPI: [`sources/printful-v2-openapi.json`](sources/printful-v2-openapi.json) — see `info.description` for Printful's own migration write-up.
- Auto-generated endpoint catalog: [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Live developer site: `https://developers.printful.com/docs/v2-beta/` (v2) and `https://developers.printful.com/docs/` (v1).
