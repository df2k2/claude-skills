# Official Gelato API Docs — captured snapshot

Markdown snapshot of the **official Gelato API documentation** (`https://dashboard.gelato.com/docs/`),
retrieved **2026-05-30** directly from the live site (the docs are a static MkDocs Material site behind a
Cloudflare challenge; fetched with a headless Chromium that clears the challenge, then converted
HTML→markdown). This is the **authoritative endpoint reference** — request/response examples are fenced
code blocks and every parameter table is preserved.

**Refreshed 2026-07-24** (via an authenticated real-browser session against the live docs): every existing
page was re-verified against the current live docs — **no content drift** was found (the 2026-05-30 capture
is still accurate). Two pages that are new since May were added: `shipment/price.md`
(`POST /v1/prices:search`) and `products/v3.md` (the consolidated "API: Product V3" single-page reference).
These two files carry a `Retrieved: 2026-07-24` header; all others remain `2026-05-30`.

**Legacy deliberately excluded** (replaced by current endpoints): Orders **v2** (`/docs/orders/v2/*`),
Orders **v3** (`/docs/orders/v3/*`), Products **v2** (`/docs/products/v2/`). Use Orders **v4** + the
current Product/Shipment/Ecommerce endpoints below.

> 3 archived URLs were **not present** in the current docs and were skipped: `orders/status/`,
> `orders/shipping-address-get/`, `orders/shipping-address-update/` — order status is covered by
> `orders/order_details.md`, and v4 has no separate shipping-address endpoint (address edits go through
> `orders/v4/patch.md`).

## Files → endpoint / topic

| File | Endpoint / topic |
| --- | --- |
| `index.md` | Docs home |
| `get-started.md` | Auth (`X-API-KEY`), base URLs, first request |
| `orders/order_details.md` | How orders work — statuses, split orders, receipts, shipment |
| `orders/migrationGuides.md` | v3→v4 migration notes |
| `orders/v4/create.md` | `POST /v4/orders` — create order (full request/response + ItemObject, files, address) |
| `orders/v4/get.md` | `GET /v4/orders/{id}` |
| `orders/v4/search.md` | `POST /v4/orders:search` |
| `orders/v4/quote.md` | `POST /v4/orders:quote` |
| `orders/v4/patch.md` | `PATCH /v4/orders/{id}` (edit draft / promote / address) |
| `orders/v4/cancel.md` | `POST /v4/orders/{id}:cancel` |
| `orders/v4/delete.md` | `DELETE /v4/orders/{id}` (drafts only) |
| `products/catalog/list.md` | `GET /v3/catalogs` |
| `products/catalog/get.md` | `GET /v3/catalogs/{uid}` (attribute schema) |
| `products/product/search.md` | `POST /v3/catalogs/{uid}/products:search` |
| `products/product/get.md` | `GET /v3/products/{uid}` |
| `products/prices.md` | `GET /v3/products/{uid}/prices` |
| `products/product/cover-dimensions.md` | `GET /v3/products/{uid}/cover-dimensions` |
| `products/stock/region-availability.md` | `POST /v3/stock/region-availability` |
| `products/v3.md` | Consolidated **Product V3** reference — catalogs, catalog info, products, product info, prices on one page (added 2026-07-24; overlaps the granular `products/*` files above) |
| `shipment/methods.md` | `GET /v1/shipment-methods` |
| `shipment/price.md` | `POST /v1/prices:search` — shipment prices by product + quantity + destination country, no order/recipient required (added 2026-07-24) |
| `ecommerce/products/list.md` | `GET /v1/stores/{storeId}/products` |
| `ecommerce/products/get.md` | `GET /v1/stores/{storeId}/products/{id}` |
| `ecommerce/products/create-from-template.md` | `POST /v1/stores/{storeId}/products` (incl. `imagePlaceholders`, `fitMethod`) |
| `ecommerce/templates/get.md` | `GET /v1/templates/{id}` (variants, `imagePlaceholders` with `printArea`/mm dims) |
| `webhooks.md` | Webhook event types + payloads (configured in the dashboard, not via API) |
| `guides/create-product-from-template.md` | Guide: create a store product from a template |
| `guides/embroidery.md` | Guide: embroidery file/thread requirements |
| `guides/branded-packaging-guide.md` | Guide: branded packaging |

Each file begins with an HTML comment recording its source URL + retrieval date. To refresh: re-run a
headless-Chromium harvest of these URLs (Cloudflare blocks plain `curl`/WebFetch with HTTP 403).
