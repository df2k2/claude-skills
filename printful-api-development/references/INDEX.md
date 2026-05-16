# Printful API references — topic map

Use this file as the entry point. Open the curated reference first; drop down to `sources/printful-v2-openapi.json` (or the auto-generated `printful-v2-endpoints.md` / `printful-v2-schemas.md`) when you need an exact field name or response shape.

## Curated guides

| File | What's inside |
|---|---|
| [`01-overview-and-versioning.md`](01-overview-and-versioning.md) | v1 vs v2 differences, base URL, response envelopes, what each version supports |
| [`02-authentication.md`](02-authentication.md) | Personal Access Tokens, OAuth Authorization Code flow, scopes, legacy store-key Basic Auth |
| [`03-rate-limits-and-errors.md`](03-rate-limits-and-errors.md) | Leaky-bucket headers, 60-second lockouts, RFC 9457 problem details, v1 error format |
| [`04-pagination-and-conventions.md`](04-pagination-and-conventions.md) | offset/limit on v1, uniform `paging` block + `_links` on v2, naming, dates, currency |
| [`05-stores-and-store-context.md`](05-stores-and-store-context.md) | Store types, multi-store via `X-PF-Store-Id`, statistics endpoint |
| [`06-catalog-v2.md`](06-catalog-v2.md) | The blank-product catalog: products, variants, prices, sizes, mockup styles, availability |
| [`07-orders-v2.md`](07-orders-v2.md) | Order lifecycle, draft → pending → fulfilled, design layers, items, shipments, invoices |
| [`08-mockup-generator.md`](08-mockup-generator.md) | Mockups v1 (`/mockup-generator/...`) and v2 (`/v2/mockup-tasks`), polling, templates |
| [`09-files-v2.md`](09-files-v2.md) | File library, async processing, dedup, visibility |
| [`10-shipping-rates.md`](10-shipping-rates.md) | v1 `/shipping/rates` and v2 `/v2/shipping-rates` |
| [`11-countries-and-localization.md`](11-countries-and-localization.md) | Country/state codes, `X-PF-Language` |
| [`12-warehouse-products-v2.md`](12-warehouse-products-v2.md) | Printful Warehousing (3PL) integration |
| [`13-approval-sheets-v2.md`](13-approval-sheets-v2.md) | Approval sheet retrieval + webhook |
| [`14-webhooks.md`](14-webhooks.md) | v1 vs v2 events, HMAC-SHA256 signing, retry schedule, simulator |
| [`15-v1-legacy-endpoints.md`](15-v1-legacy-endpoints.md) | Endpoints that remain v1-only (sync products, tax rates, country v1, products catalog v1) |
| [`16-design-recipes.md`](16-design-recipes.md) | End-to-end code recipes (Node / Python / cURL) |
| [`17-common-pitfalls.md`](17-common-pitfalls.md) | Mistakes to avoid, with the actual error messages they produce |

## Auto-generated source material

| File | What's inside |
|---|---|
| [`sources/printful-v2-openapi.json`](sources/printful-v2-openapi.json) | The canonical v2 OpenAPI 2.0.0-beta spec (578 KB, 39 paths, 134 schemas). Search with `jq`. |
| [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md) | Auto-generated endpoint catalog — one section per tag, summary + request/response schemas |
| [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md) | Auto-generated schema catalog — every component schema with field list, types, enums |
| [`sources/PrintfulApiClient.php`](sources/PrintfulApiClient.php) | Official v1 PHP SDK transport — shows auth, response envelope, error handling |
| [`sources/PrintfulOrder.php`](sources/PrintfulOrder.php) | v1 order endpoints in code form |
| [`sources/PrintfulProducts.php`](sources/PrintfulProducts.php) | v1 `/store/products` (Sync Products) endpoints |
| [`sources/PrintfulMockupGenerator.php`](sources/PrintfulMockupGenerator.php) | v1 mockup generator endpoints |
| [`sources/PrintfulTaxRates.php`](sources/PrintfulTaxRates.php) | v1 tax endpoints |
| [`sources/PrintfulWebhook.php`](sources/PrintfulWebhook.php) | v1 webhook endpoints |

## Endpoint quick index

Every v2 endpoint, grouped by tag:

### Catalog v2 (17 endpoints)
- `GET /v2/catalog-products` — list
- `GET /v2/catalog-products/{id}` — single
- `GET /v2/catalog-products/{id}/catalog-variants` — variants of a product
- `GET /v2/catalog-variants/{id}` — single variant
- `GET /v2/catalog-categories` — list
- `GET /v2/catalog-categories/{id}` — single
- `GET /v2/catalog-products/{id}/catalog-categories` — categories of a product
- `GET /v2/catalog-products/{id}/sizes` — size guide
- `GET /v2/catalog-products/{id}/prices` — prices (all variants)
- `GET /v2/catalog-variants/{id}/prices` — variant prices
- `GET /v2/catalog-products/{id}/images` — blank images (product)
- `GET /v2/catalog-variants/{id}/images` — blank images (variant)
- `GET /v2/catalog-products/{id}/shipping-countries` — where it ships
- `GET /v2/catalog-products/{id}/mockup-styles` — available mockup style IDs
- `GET /v2/catalog-products/{id}/mockup-templates` — mockup template data
- `GET /v2/catalog-products/{id}/availability` — stock by region
- `GET /v2/catalog-variants/{id}/availability` — variant stock by region

### Orders v2 (15 endpoints)
- `GET /v2/orders` — list
- `POST /v2/orders` — create (with or without items)
- `GET /v2/orders/{order_id}` — single
- `PATCH /v2/orders/{order_id}` — update draft
- `DELETE /v2/orders/{order_id}` — cancel
- `POST /v2/orders/{order_id}/confirmation` — submit for fulfillment
- `GET /v2/orders/{order_id}/order-items` — list items
- `POST /v2/orders/{order_id}/order-items` — add item
- `GET /v2/orders/{order_id}/order-items/{order_item_id}` — single item
- `PATCH /v2/orders/{order_id}/order-items/{order_item_id}` — update item
- `DELETE /v2/orders/{order_id}/order-items/{order_item_id}` — delete item
- `GET /v2/orders/{order_id}/shipments` — shipment list w/ tracking events
- `GET /v2/orders/{order_id}/invoices` — invoice
- `GET /v2/order-estimation-tasks` — poll cost estimate task
- `POST /v2/order-estimation-tasks` — create cost estimate task

### Files v2 (2)
- `POST /v2/files` — add a file (async processing)
- `GET /v2/files/{id}` — single file (poll until status=`ok`)

### Mockup Generator v2 (2)
- `POST /v2/mockup-tasks` — create mockup task
- `GET /v2/mockup-tasks` — list tasks (filter by `id` to retrieve a specific one)

### Shipping Rates v2 (1)
- `POST /v2/shipping-rates` — quote shipping

### Countries v2 (1)
- `GET /v2/countries` — country + state codes

### Warehouse Products v2 (2)
- `GET /v2/warehouse-products` — list
- `GET /v2/warehouse-products/{warehouse_product_id}` — single

### Approval Sheets v2 (1)
- `GET /v2/approval-sheets` — list

### Stores v2 (3)
- `GET /v2/stores` — list (requires `stores_list` scope)
- `GET /v2/stores/{store_id}` — single
- `GET /v2/stores/{store_id}/statistics` — sales & cost stats

### Webhook v2 (6)
- `GET /v2/webhooks` — store-level config (URL, public_key, secret_key, default_expires_at)
- `POST /v2/webhooks` — create or replace store-level config
- `DELETE /v2/webhooks` — disable webhooks (per store)
- `GET /v2/webhooks/{eventType}` — per-event config
- `POST /v2/webhooks/{eventType}` — enable/configure one event
- `DELETE /v2/webhooks/{eventType}` — disable one event

### OAuth Scopes v2 (1)
- `GET /v2/oauth-scopes` — introspect the scopes the current token has

### v1 endpoints still relevant (curated; not exhaustive)
- `GET/POST/PUT/DELETE /orders` — v1 order CRUD (envelope: `code` + `result`)
- `POST /orders/{id}/confirm` — confirm a v1 draft
- `POST /orders/estimate-costs` — synchronous cost estimate (v1)
- `GET/POST/PUT/DELETE /store/products` and `/store/variants` — Sync Products & Variants (only on v1)
- `POST /mockup-generator/create-task/{product_id}` + `GET /mockup-generator/task?task_key=…` — v1 mockup flow
- `GET /mockup-generator/templates/{product_id}` and `/printfiles/{product_id}` — template & printfile data
- `POST /tax/rates`, `GET /tax/countries` — tax rate calculation (v1 only)
- `POST /shipping/rates` — v1 shipping quote
- `GET /countries`, `GET /products`, `GET /products/{id}` — v1 country list and v1 catalog
- `GET/POST/DELETE /webhooks` — v1 webhook registration (no per-event configuration)
