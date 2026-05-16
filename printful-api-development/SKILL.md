---
name: printful-api-development
description: Authoritative reference for developing against the Printful print-on-demand developer API. Use this skill whenever the user mentions Printful, PF, the Printful API, `api.printful.com`, sync products, the mockup generator, print files / printfiles, design layers, catalog products/variants, store keys, OAuth private tokens, Personal Access Tokens, approval sheets, warehouse products, or asks to write code that calls `api.printful.com` (v1 or v2). Trigger on requests to create/update Printful orders, build a mockup, calculate shipping or tax via Printful, register or verify Printful webhooks, sync a Shopify/WooCommerce/Wix/Squarespace product to Printful, manage product variants in a Printful store, look up Printful catalog variant IDs, configure OAuth flows or scopes for a Printful app, handle the `code`/`result` envelope on v1, the `data`/`paging` envelope on v2, or any endpoint under `/orders`, `/store/products`, `/store/variants`, `/mockup-generator`, `/webhooks`, `/shipping/rates`, `/tax/rates`, `/products` (catalog), `/v2/catalog-products`, `/v2/orders`, `/v2/mockup-tasks`, `/v2/files`, `/v2/webhooks`, `/v2/warehouse-products`, `/v2/approval-sheets`, `/v2/stores`, or `/v2/shipping-rates`. Use even when the user just describes a print-on-demand workflow without naming Printful (e.g. "place a custom T-shirt order from our Shopify checkout", "render a mug mockup with this design", "verify a fulfillment webhook signature") — the full v2 OpenAPI spec, every endpoint, every schema, and the v1 SDK source are embedded in `references/sources/`.
---

# Printful Developer API

Printful is a print-on-demand fulfillment platform. Merchants integrate with Printful to: browse the blank-product catalog, upload designs, generate mockups, sync their storefront's products to Printful variants, submit orders for fulfillment, retrieve shipping/tax rates, and receive webhook events about order status, stock changes, and mockup tasks.

This skill is the on-disk reference for everything a developer needs to build against `api.printful.com`. Both the **stable v1 API** and the **v2 API (open beta — production-ready)** are documented here.

## Repository layout

```
printful-api-development/
├── SKILL.md                                ← you are here
└── references/
    ├── INDEX.md                            ← curated topic map (read this first)
    ├── 01-overview-and-versioning.md       ← v1 vs v2, base URL, response envelopes
    ├── 02-authentication.md                ← Personal tokens, OAuth 2.0, scopes, legacy store key
    ├── 03-rate-limits-and-errors.md        ← leaky bucket (v2), 120/min (v1), RFC 9457 errors
    ├── 04-pagination-and-conventions.md    ← offset/limit (v1), uniform paging (v2), locale, currency
    ├── 05-stores-and-store-context.md      ← multi-store, `X-PF-Store-Id`, store types
    ├── 06-catalog-v2.md                    ← /v2/catalog-products, variants, prices, sizes, mockup-styles
    ├── 07-orders-v2.md                     ← order lifecycle, itemised build, design layers, statuses
    ├── 08-mockup-generator.md              ← async tasks, v1 vs v2, polling, layers, templates
    ├── 09-files-v2.md                      ← file library, async upload, dedup, statuses
    ├── 10-shipping-rates.md                ← v1 /shipping/rates, v2 /v2/shipping-rates
    ├── 11-countries-and-localization.md    ← country/state codes, X-PF-Language
    ├── 12-warehouse-products-v2.md         ← Printful Warehousing (3PL) products
    ├── 13-approval-sheets-v2.md            ← approval sheet webhook + retrieval
    ├── 14-webhooks.md                      ← v1 and v2 events, HMAC-SHA256 signing, retries
    ├── 15-v1-legacy-endpoints.md           ← v1-only surface: tax rates, sync, country, products (catalog v1)
    ├── 16-design-recipes.md                ← end-to-end recipes (create order, mockup, shipping quote)
    ├── 17-common-pitfalls.md               ← what NOT to do
    └── sources/                            ← raw / auto-generated source material
        ├── printful-v2-openapi.json        ← official OpenAPI 2.0.0-beta spec (canonical)
        ├── printful-v2-endpoints.md        ← auto-generated endpoint catalog (39 paths, 11 tags)
        ├── printful-v2-schemas.md          ← auto-generated schema catalog (134 schemas)
        ├── PrintfulApiClient.php           ← official v1 PHP SDK transport (auth pattern)
        ├── PrintfulOrder.php               ← v1 order endpoints reference
        ├── PrintfulProducts.php            ← v1 sync product endpoints reference
        ├── PrintfulMockupGenerator.php     ← v1 mockup generator reference
        ├── PrintfulTaxRates.php            ← v1 tax endpoints reference
        └── PrintfulWebhook.php             ← v1 webhook endpoints reference
```

When the curated reference isn't enough, **search the OpenAPI JSON**:

```bash
# Find an endpoint that mentions "shipping" in the v2 spec
jq -r '.paths | keys[] | select(test("shipping"))' \
   printful-api-development/references/sources/printful-v2-openapi.json

# Print every property of the Order schema
jq '.components.schemas.Order' \
   printful-api-development/references/sources/printful-v2-openapi.json

# Find every endpoint that returns ProblemDetails (RFC 9457)
jq '.paths | to_entries[] | {path:.key, methods:(.value | to_entries[] | {method:.key,uses_problem_details: (.value.responses // {} | to_entries[] | select(.value.content."application/problem+json" != null) | .key)})}' \
   printful-api-development/references/sources/printful-v2-openapi.json
```

The auto-generated `printful-v2-endpoints.md` and `printful-v2-schemas.md` are also full-text-searchable with grep — but they're derived files; the OpenAPI JSON is canonical.

## Critical things to know up front

Before answering anything substantive, internalize these. They come up constantly.

### 1. Two API versions live at the same host

Base URL for both: **`https://api.printful.com`**.

- **v1 (stable)** — paths like `/orders`, `/store/products`, `/mockup-generator/...`, `/webhooks`, `/tax/rates`, `/shipping/rates`. Response envelope: `{ "code": 200, "result": …, "paging"?: { … } }`.
- **v2 (open beta, production-ready)** — paths prefixed `/v2/...`. Response envelope: `{ "data": …, "paging"?: … , "_links"?: … }` (RFC HATEOAS-style with `_links`). Errors follow [RFC 9457 Problem Details](https://www.rfc-editor.org/rfc/rfc9457) with `Content-Type: application/problem+json`.

**Don't mix the envelopes.** A v1 success has `code` and `result`. A v2 success has `data`. Code that destructures `response.result` will silently break against v2.

Some functionality only exists in v1 (tax rates, sync products / `/store/products`, the v1 mockup generator). Some only in v2 (approval sheets, modern mockup tasks, store statistics, warehouse products, signed webhooks). When in doubt, see [`references/01-overview-and-versioning.md`](references/01-overview-and-versioning.md).

### 2. Three authentication modes — pick the right one

| Mode | Header | Where used | Lifetime |
|---|---|---|---|
| **OAuth Bearer / Private token** | `Authorization: Bearer {token}` | v1 + v2 (current best practice) | Up to a year, configurable |
| **OAuth Authorization Code** | (returned `access_token` used as Bearer) | Public apps that act on behalf of multiple merchants | Refresh-token flow |
| **Legacy store key** | HTTP Basic Auth — the store key as the username, **empty password** | v1 only; deprecated for new apps but still supported | Permanent until rotated |

**OAuth scopes** (set on the Personal Access Token or requested in the auth-code flow): `orders`, `orders/read`, `stores_list`, `stores_list/read`, `file_library`, `file_library/read`, `webhooks`, `webhooks/read`. `read` suffix is read-only; no suffix is read+write.

Personal Access Tokens are created at **https://developers.printful.com/tokens** (sign in as the merchant, pick the store, choose scopes, copy the `pf_` / `smk_` prefixed token once — it isn't shown again). Tokens are scoped to a single store; for multi-store work, use the OAuth Authorization Code flow with `stores_list` scope and pass `X-PF-Store-Id: {store_id}` on each request.

Full details and a working OAuth code-exchange example: [`references/02-authentication.md`](references/02-authentication.md).

### 3. The data model — IDs are unforgiving

The catalog hierarchy is **Catalog Product → Catalog Variant**. Orders reference **variant IDs, not product IDs**. The Bella+Canvas 3001 unisex tee is product `71`, but ordering one in white size M requires the variant ID (e.g. `4011`). Using the product ID where a variant ID is expected creates "an entirely different product" (Printful's own warning) or a 400.

Storefront sync products are a separate layer:

- **Sync Product** (`/store/products/{id}` — v1 only) — represents one of the merchant's storefront products, mapped to one or more Printful catalog variants. Each Sync Product has one or more **Sync Variants** that bind a `external_id` (the merchant's SKU) to a Printful `variant_id` plus per-variant print files.
- **Catalog Product / Variant** (`/products/...` v1 or `/v2/catalog-products/...` v2) — the immutable blank catalog. Never mutated by API consumers.
- **Order Item** — references either a Sync Variant (via `sync_variant_id` / `external_variant_id`) or a Catalog Variant directly (via `catalog_variant_id` + design data).

Read [`references/06-catalog-v2.md`](references/06-catalog-v2.md) and [`references/07-orders-v2.md`](references/07-orders-v2.md) before writing any order code.

### 4. Order lifecycle is multi-step

```
   draft  →  pending  →  inprocess  →  onhold? / partial / fulfilled
                ↓
              failed → (edit and re-confirm)
                ↓
              canceled
```

- **`draft`** — created but not submitted. Free to edit, no charge. Use this stage as a server-side shopping cart.
- **`pending`** — confirmed for fulfillment; payment will be attempted from the merchant's Printful wallet/billing method.
- **`failed`** — submitted but blocked (bad address, invalid file, missing payment, etc.). Mutable; fix and re-confirm.
- **`inprocess` / `onhold` / `partial` / `fulfilled` / `canceled`** — terminal or near-terminal states managed by Printful.

In v1: `POST /orders?confirm=1` skips the draft step. In v2: `POST /v2/orders/{order_id}/confirmation` moves a draft to pending. See [`references/07-orders-v2.md`](references/07-orders-v2.md).

### 5. Rate limits — v1 is fixed-window, v2 is leaky-bucket

- **v1**: 120 requests/min sliding. Exceed → `429` + **60-second lockout**. No grace.
- **v2**: Leaky bucket. Default policy `120;w=60` (120 token capacity, refilled at 2 tokens/sec). Headers:
  - `X-Ratelimit-Limit: 120`
  - `X-Ratelimit-Remaining: 119`
  - `X-Ratelimit-Reset: 0.5` — **seconds** until the next token, not minutes
  - `X-Ratelimit-Policy: 120;w=60`
- Special: **Shipping rates** in v2 drop to **5 req/60s when summary item quantity > 100**.
- All `429` responses include a `Retry-After` header (seconds). Honor it.

See [`references/03-rate-limits-and-errors.md`](references/03-rate-limits-and-errors.md).

### 6. v2 errors follow RFC 9457

```
HTTP/1.1 404 Not Found
Content-Type: application/problem+json

{
  "type": "https://developers.printful.com/docs/v2-beta/#errors/not-found",
  "status": 404,
  "title": "Not Found",
  "detail": "The resource that you tried to access does not exist.",
  "instance": "01HXY…"   // include in support tickets
}
```

Validation errors add `errors[]` with `pointer` (JSON Pointer to the invalid field) and `detail`. The legacy v1 error format is `{ "code": 4xx, "result": "human message", "error": { "reason": "...", "message": "..." } }`. Not every v2 endpoint has migrated yet — Catalog GETs and several Order endpoints still emit v1-style errors. The OpenAPI spec lists exceptions; trust the `Content-Type` header at runtime.

### 7. Webhooks v2 are signed; v1 are not

v2 webhooks include an HTTPS-only URL, an expiration date, and an `X-PF-Signature: sha256={hex}` header computed as `HMAC-SHA256(secret_key, raw_body)`. The `secret_key` is returned **hex-encoded** — you must hex-decode it before passing to HMAC. v1 webhooks have neither signing nor HTTPS enforcement, and reuse the merchant's `verifier_token` mechanism only for the optional verification ping.

Retry policy (both versions): on non-2xx response, retry after 1, 4, 16, 64, 256, and 1024 minutes. Then drop.

See [`references/14-webhooks.md`](references/14-webhooks.md).

### 8. Mockups and files are asynchronous

- `POST /v2/mockup-tasks` (or v1 `POST /mockup-generator/create-task/{product_id}`) returns a task with status `pending`. Poll `GET /v2/mockup-tasks?id={id}` (or `GET /mockup-generator/task?task_key={key}` on v1) until status is `completed` or `failed`. Subscribe to the `mockup_task_finished` webhook to skip polling.
- `POST /v2/files` returns a file with status `waiting`; the real status (`ok` / `failed`) is reported asynchronously. **A confirmed order referencing an unfinished file can revert to `failed`** if processing fails after confirmation.

Don't block your request thread waiting on these. See [`references/08-mockup-generator.md`](references/08-mockup-generator.md) and [`references/09-files-v2.md`](references/09-files-v2.md).

## How to use this skill (your workflow)

When the user asks anything Printful-related, follow this loop:

1. **Identify the API version they're on.** Look for clues:
   - Path contains `/v2/` → v2.
   - Code reads `response.data` → v2. Reads `response.result` → v1.
   - Header is `Authorization: Bearer pf_…` or `smk_…` → Personal Access Token (works on both).
   - HTTP Basic Auth with a long random string as user → legacy store key (v1 only).
   - Mentions `external_id` with `@` prefix on order lookup → v1 convention (`GET /orders/@my-order-123`).

2. **Map the task to the right reference file**. Start with [`references/INDEX.md`](references/INDEX.md) — every task has an entry pointing at the right curated file plus the matching endpoint in `references/sources/printful-v2-endpoints.md`.

3. **For exact field names, schemas, or anything contractual** — read the corresponding section of `references/sources/printful-v2-openapi.json` (use `jq`) or `printful-v2-schemas.md`. The OpenAPI spec is canonical; if curated prose disagrees with it, trust the OpenAPI.

4. **Quote field names exactly.** Both APIs are `snake_case` JSON (`external_id`, `catalog_variant_id`, `retail_costs`, `placement_id`, `secret_key`, `store_id`). Never `camelCase`. Never `kebab-case`. Never quote `id` when the field is `catalog_variant_id`.

5. **For staging vs production** — Printful **does not have a staging environment**. All calls hit production. There is one mitigation: create a separate test store under the same Printful account, generate a token for it, and call against that store. Sample orders can be flagged with a draft state and never confirmed. Webhooks have a Simulator at https://www.printful.com/api/webhook-simulator (v1 only; v2 is not yet simulated). See [`references/05-stores-and-store-context.md`](references/05-stores-and-store-context.md).

6. **For sensitive data** — never log `Authorization` headers, OAuth tokens, store keys, or webhook `secret_key` values. Treat the `secret_key` like a signing key, not an identifier — it is the only thing that lets you verify event authenticity.

## Common task quickstart

| User wants to… | Endpoint(s) | Reference |
|---|---|---|
| Create a single-item order, skip the draft | `POST /v2/orders` then `POST /v2/orders/{order_id}/confirmation` | [07-orders-v2.md](references/07-orders-v2.md), [16-design-recipes.md](references/16-design-recipes.md) |
| Build an order one item at a time (shopping cart) | `POST /v2/orders` (draft, address only) then repeated `POST /v2/orders/{order_id}/order-items` | [07-orders-v2.md](references/07-orders-v2.md) |
| Look up an order by your own external ID | `GET /v2/orders?external_id=…` (or v1: `GET /orders/@{external_id}`) | [07-orders-v2.md](references/07-orders-v2.md) |
| Quote shipping before charging the customer | `POST /v2/shipping-rates` | [10-shipping-rates.md](references/10-shipping-rates.md) |
| Estimate full order cost (item + shipping + tax + Printful fees) | `POST /v2/order-estimation-tasks` then poll | [07-orders-v2.md](references/07-orders-v2.md) |
| Browse the blank-product catalog | `GET /v2/catalog-products?categories_ids=…` | [06-catalog-v2.md](references/06-catalog-v2.md) |
| Find the variant ID for a specific size/color | `GET /v2/catalog-products/{id}/catalog-variants` | [06-catalog-v2.md](references/06-catalog-v2.md) |
| Get a size guide | `GET /v2/catalog-products/{id}/sizes` | [06-catalog-v2.md](references/06-catalog-v2.md) |
| Render a mockup of a design on a product | `POST /v2/mockup-tasks`, poll `GET /v2/mockup-tasks?id=…` | [08-mockup-generator.md](references/08-mockup-generator.md) |
| Get a product's mockup styles (Men's Front, Women's Lifestyle Back, etc.) | `GET /v2/catalog-products/{id}/mockup-styles` | [06-catalog-v2.md](references/06-catalog-v2.md), [08-mockup-generator.md](references/08-mockup-generator.md) |
| Sync a Shopify/Wix product to Printful | v1 `POST /store/products` | [15-v1-legacy-endpoints.md](references/15-v1-legacy-endpoints.md) |
| List/update sync variants | v1 `/store/variants/{id}` | [15-v1-legacy-endpoints.md](references/15-v1-legacy-endpoints.md) |
| Calculate sales tax for an address | v1 `POST /tax/rates` | [15-v1-legacy-endpoints.md](references/15-v1-legacy-endpoints.md) |
| Register a webhook URL for the whole store | v2 `POST /v2/webhooks` (URL + default expiration + secret) | [14-webhooks.md](references/14-webhooks.md) |
| Enable a specific webhook event | v2 `POST /v2/webhooks/{eventType}` | [14-webhooks.md](references/14-webhooks.md) |
| Verify a v2 webhook signature | HMAC-SHA256 of raw request body with hex-decoded `secret_key`, compare to `X-PF-Signature: sha256=…` | [14-webhooks.md](references/14-webhooks.md) |
| Upload a print file to the library | `POST /v2/files` with `{ url, visible }` then poll status | [09-files-v2.md](references/09-files-v2.md) |
| List/get Printful Warehousing items | `GET /v2/warehouse-products` | [12-warehouse-products-v2.md](references/12-warehouse-products-v2.md) |
| Retrieve approval sheets for embroidery/POD orders | `GET /v2/approval-sheets` + handle `approval_sheet_created` webhook | [13-approval-sheets-v2.md](references/13-approval-sheets-v2.md) |
| Switch the active store in a multi-store integration | Send `X-PF-Store-Id: {store_id}` header | [05-stores-and-store-context.md](references/05-stores-and-store-context.md) |
| Get response strings in Spanish/French/etc. | Send `X-PF-Language: es_ES` header | [11-countries-and-localization.md](references/11-countries-and-localization.md) |
| Build an OAuth public app | Authorization Code flow at `https://www.printful.com/oauth/authorize` → token at `https://www.printful.com/oauth/token` | [02-authentication.md](references/02-authentication.md) |

## Things to avoid

- **Don't use `product_id` where `variant_id` (or `catalog_variant_id`) is expected.** They are different namespaces. The catalog product hierarchy is intentionally separate from the order line item layer.
- **Don't paste v1 envelope handling into a v2 code path.** `response.result` is undefined on v2; the data is in `response.data`.
- **Don't HTTP-Basic-Auth a v2 endpoint.** v2 only accepts Bearer tokens; Basic Auth returns `401`.
- **Don't expect synchronous mockups or file processing.** Both go through task queues. Poll or subscribe to the appropriate webhook.
- **Don't trust an order's pricing before confirmation.** Pricing is recalculated on every item add/edit; the `costs` block on the draft is informational. After confirmation, `costs` is final.
- **Don't ignore `429` lockouts** on v1 — the 60-second lockout is enforced regardless of how quickly the rate-limit counter would otherwise tick back.
- **Don't forget `X-PF-Store-Id`** when a Personal Token has multi-store access. Without it, the API picks a default store, which may not be the one you intended.
- **Don't drop the `external_id` on order creation.** It's how you correlate Printful orders back to your system; once set it cannot be changed.
- **Don't send Personal Tokens to the browser.** They have full write scope. For client-side flows, run an OAuth code-exchange backend.
- **Don't hex-encode a webhook signature for comparison without first hex-decoding the secret key** — Printful returns the `secret_key` as a hex string; treat the underlying bytes as the HMAC key.
- **Don't assume webhook delivery is exactly-once.** Retries on non-2xx responses can deliver the same event up to 7 times across ~22 hours. Make handlers idempotent (event id + occurred_at).
- **Don't write to the catalog.** It's read-only. Adjust the catalog via Sync Products (v1 `/store/products`), not by mutating catalog items.

## Sandbox / testing

Printful has **no shared sandbox**. Recommended testing pattern:

1. Create a separate Printful **test store** (in the Printful dashboard → Stores → Add new) — same account, isolated billing.
2. Generate a Personal Access Token scoped to that store.
3. Create orders as `draft` (omit `?confirm=1` on v1; do not call `POST /v2/orders/{id}/confirmation` on v2). Draft orders are free and editable.
4. Use Printful's [Webhook Simulator](https://www.printful.com/api/webhook-simulator) for v1 events. v2 webhooks must be exercised by triggering real events (create a draft, confirm, delete, etc.) against the test store.

## When the curated docs disagree with each other

The OpenAPI spec at [`references/sources/printful-v2-openapi.json`](references/sources/printful-v2-openapi.json) is the canonical contract for v2. If the curated prose and the OpenAPI block disagree, trust the OpenAPI. For v1, the canonical reference is the live developer site (`developers.printful.com/docs/`) plus the Printful PHP SDK source mirrored at [`references/sources/Printful*.php`](references/sources/). The SDK is occasionally a few releases behind on edge fields but is reliable for endpoint paths, auth, and the response envelope.

## When information truly isn't here

This skill targets:
- The full v2 OpenAPI (39 paths, 134 schemas, as of the bundled snapshot).
- The v1 endpoints that remain in active use (sync products, tax rates, the original mockup generator, v1 webhooks).
- The OAuth 2.0 flow as documented for the public developer portal.

It does **not** include:
- The Printful merchant dashboard UI.
- Pricing tiers, partner program terms, or commercial agreements.
- Internal/private endpoints that aren't on developer.printful.com.
- The Embedded Design Maker (a separate Enterprise product with its own OpenAPI — point users to `developers.printful.com/docs/edm/` if they ask).

For those, direct the user to their Printful account manager or `support@printful.com`. Do not invent endpoints, fields, or payloads — say "not in the embedded docs" and stop.
