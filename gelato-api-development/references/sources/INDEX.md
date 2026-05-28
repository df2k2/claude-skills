# Embedded Source Docs — Topic Index

This skill bundles two community SDKs for the Gelato API as embedded source-of-truth references. The official Gelato API documentation at `https://dashboard.gelato.com/docs/` is **gated** (returns HTTP 403 to unauthenticated GETs) and not redistributable, so it isn't bundled here. The sources below are the next best thing — well-typed, MIT/Apache-2.0 licensed, and accurate for the current v3/v4 endpoints.

## Trees

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

## Why the official docs aren't bundled

The official Gelato API documentation at https://dashboard.gelato.com/docs/ is served behind the dashboard's web portal. Unauthenticated GETs to the page URLs return HTTP 403 (Cloudflare WAF), and the doc site is not open-source. Bundling a scraped copy would be a license violation and quickly outdated. The user should consult the official docs interactively for the canonical reference.

The curated `references/*.md` files in this skill distill what's publicly observable via:

1. The two SDKs bundled here.
2. Confirmed details from web search (which surfaces extracted snippets, e.g., curl examples on the Create Order page).
3. Help-center articles at https://support.gelato.com/ and https://apisupport.gelato.com/.

## Refresh

`scripts/gelato/fetch_docs.sh` re-clones both SDKs and re-populates this tree. Run it when:

- `ekkolon/gelato-admin-node` has shipped updates that reflect new Gelato endpoints.
- You want the latest README / LICENSE.

The legacy `npm-gelato-api` rarely changes (it's effectively abandoned), but the fetch script re-pulls it for parity.
