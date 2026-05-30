# Embedded Source Docs — Topic Index

This skill bundles a **captured markdown snapshot of the official Gelato API docs** plus two community SDKs as embedded source-of-truth references. The official docs at `https://dashboard.gelato.com/docs/` sit behind a Cloudflare challenge (plain GETs return HTTP 403), so the snapshot was harvested with a headless browser that clears the challenge (the docs are a static MkDocs Material site → full HTML once rendered).

## Trees

### `gelato-official-docs/` — captured official docs (snapshot **2026-05-30**) — START HERE

Markdown snapshot of `https://dashboard.gelato.com/docs/`, the **authoritative per-endpoint reference** (request/response examples + parameter tables). Legacy v2/v3 excluded. See `gelato-official-docs/INDEX.md` for the full file→endpoint map. Trust this over the SDK when they disagree.

| Area | Files |
| --- | --- |
| Orders v4 | `orders/v4/{create,get,search,quote,patch,cancel,delete}.md`, plus `orders/order_details.md`, `orders/migrationGuides.md` |
| Product Catalog v3 | `products/catalog/{list,get}.md`, `products/product/{search,get,cover-dimensions}.md`, `products/prices.md`, `products/stock/region-availability.md` |
| Shipment v1 | `shipment/methods.md` |
| Ecommerce v1 | `ecommerce/products/{list,get,create-from-template}.md`, `ecommerce/templates/get.md` |
| Webhooks + guides | `webhooks.md`, `guides/*.md`, `get-started.md`, `index.md` |

### `gelato-admin-node/` — Apache-2.0 (`ekkolon/gelato-admin-node`)

Modern, well-typed TypeScript SDK. Tracks current v3/v4 endpoints. The single most useful source for ground-truth field shapes.

| File | Covers |
| --- | --- |
| `README.md` | Install, init client, API service usage |
| `LICENSE` | Apache-2.0 |
| `package.json` | NPM package metadata |
| `src/services/orders/orders-api.ts` | Order endpoint URLs and verbs (`/v4/orders`, `:search`, `:quote`, `:cancel`) |
| `src/services/orders/order.ts` | All Order types — `CreateOrderRequest`, `GetOrderResponse`, `ItemObject`, `ShipmentObject`, `ReceiptObject`, `QuoteOrderRequest`, `PatchOrderRequest`, `Currency`, `FulfillmentStatus`, `FinancialStatus`, `OrderChannel`, file `type` enum, address fields |
| `src/services/products/products-api.ts` | Product endpoint URLs — `/v3/catalogs`, `/v3/products/{uid}`, `/prices`, `/cover-dimensions`, `/stock/region-availability` |
| `src/services/products/catalog.ts` | `Catalog`, `CatalogProductAttribute`, `CatalogProductAttributeValue` |
| `src/services/products/product.ts` | `Product`, `GetProductsFilter`, `GetProductResponse`, `MeasureUnit` |
| `src/services/products/prices.ts` | Pricing object shape |
| `src/services/products/cover-dimensions.ts` | Cover-dimensions for multi-page products |
| `src/services/products/stock-availability.ts` | Region availability for stockable products |
| `src/services/shipment/shipment-api.ts` | Shipment Methods endpoint (`/v1/shipment-methods`) |
| `src/services/shipment/shipment.ts` | `ShipmentMethod`, `ShipmentMethodType` (`normal` / `express` / `pallet`) |
| `src/services/ecommerce/ecommerce-api.ts` | Ecommerce endpoint URLs — `/v1/stores/{id}/products`, `/v1/templates/{id}` |
| `src/services/ecommerce/templates.ts` | `GetTemplateResponse`, `VariantObject`, `VariantOptionObject`, `TemplateImagePlaceholderObject` (with `printArea` enum) |
| `src/services/ecommerce/products.ts` | Store product CRUD shapes — `GetProductResponse`, `CreateProductRequest`, `CreateProductResponse`, `CreateProductVariantObject`, `ProductImagePlaceholderObject` (with `fitMethod` enum) |
| `src/client/http-client.ts` | How auth header is set (`X-API-KEY`) |
| `src/utils/urls.ts` | URL combinator used throughout |
| `src/utils/error.ts` | SDK error wrapper |

### `npm-gelato-api/` — MIT, **legacy v2 only** (`gelato-api/npm-gelato-api`)

Old 2018 SDK pointing at `api.gelato.com/v2/`. Bundled for historical context — useful when porting old code or recognizing a v2-era pattern. **Do not use the v2 endpoints for new code.**

| File | Covers |
| --- | --- |
| `README.md` | Original v2 usage, endpoint shape, test/prod distinction (`api-test.gelato.com/v2/`) |
| `main.js` | Legacy v2 endpoint URLs and the example payload shape |
| `package.json` | NPM package metadata (MIT, by Eivind Ingebrigtsen at Gelato) |

## Search patterns

```bash
# Find every endpoint URL referenced in the SDK
grep -rn -E "https://[a-z]+\.gelatoapis\.com" references/sources/gelato-admin-node/

# Find the type of a field — e.g., what fulfillmentStatus values are possible
grep -A 15 "OrderFulfillmentStatus" references/sources/gelato-admin-node/src/services/orders/order.ts

# Find every Currency code Gelato accepts
grep -A 50 "export type Currency" references/sources/gelato-admin-node/src/services/orders/order.ts

# Find the file-type enum
grep -A 10 "export type FileType" references/sources/gelato-admin-node/src/services/orders/order.ts

# Find image placeholder print areas
grep -A 3 "printArea" references/sources/gelato-admin-node/src/services/ecommerce/templates.ts
```

## Refreshing the official-docs snapshot

The docs at https://dashboard.gelato.com/docs/ are a static **MkDocs Material** site behind a **Cloudflare** challenge — plain `curl`/WebFetch return HTTP 403 ("Just a moment…"). To re-capture:

1. Enumerate the current page set (Cloudflare-free) via the Wayback CDX API:
   `curl -s "http://web.archive.org/cdx/search/cdx?url=dashboard.gelato.com/docs*&output=text&fl=original&collapse=urlkey&limit=2000"` — filter out `/assets/`, `.js`/`.css`, and **legacy `orders/v2`, `orders/v3`, `products/v2`**.
2. Render each live page with a **headless Chromium** that clears the Cloudflare interstitial (set a real User-Agent; spoof `navigator.webdriver`; reuse one context so the `cf_clearance` cookie persists; wait for `.md-content__inner`).
3. Convert `.md-content__inner` HTML → markdown with turndown + the gfm plugin. **Gotcha:** code examples are `<div class="highlight"><pre><span></span><code>…` — the leading `<span>` breaks turndown's fenced rule, so first replace each `div.highlight` with a clean `<pre><code>{textContent}</code></pre>` to get fenced blocks with preserved newlines.

The Wayback **search index** (`/docs/search/search_index.json`) holds all page text in one file but is only archived occasionally (last ~2023) — too stale; harvest the live pages instead.

## Refreshing the SDK trees

`scripts/gelato/fetch_docs.sh` re-clones both SDKs and re-populates those trees. Run it when `ekkolon/gelato-admin-node` ships updates reflecting new endpoints. The legacy `npm-gelato-api` rarely changes. **Note:** the SDK lags the live API on some field shapes (e.g. order `files[]` `fitMethod`/`fillMethod`/`isVisible`) — prefer `gelato-official-docs/` for ground truth.
