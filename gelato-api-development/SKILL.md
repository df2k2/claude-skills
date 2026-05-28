---
name: gelato-api-development
description: "Build, integrate, and debug applications against the Gelato print-on-demand REST API — Orders v4 (`order.gelatoapis.com`), Product Catalog v3 (`product.gelatoapis.com`), Shipment Methods v1 (`shipment.gelatoapis.com`), Ecommerce Stores/Templates v1 (`ecommerce.gelatoapis.com`), and webhook event handling. Use this skill whenever the user is integrating Gelato for print fulfillment, creating/quoting/canceling orders, working with `productUid` strings, building printable PDFs (PDF/X-1a, PDF/X-4) for Gelato file uploads, mapping a Shopify/Etsy/WooCommerce/BigCommerce/Wix/Squarespace storefront onto Gelato products, working with templates and image placeholders (front/back/neck-inner/neck-outer/sleeve-left/sleeve-right), parsing webhook events (`order_status_updated`, `order_item_status_updated`, `catalog_product_stock_availability_updated`), handling fulfillment / financial statuses (draft / pending_approval / on_hold / passed / printed / shipped / canceled / refunded), debugging X-API-KEY auth failures, debugging 'file URL unreachable' / 'invalid product UID' errors, choosing between draft and order types, picking shipment methods (normal / express / pallet), or scripting against Gelato from Node/Python/PHP/Go. Trigger on mentions of Gelato, Gelato API, GelatoConnect, `order.gelatoapis.com`, `product.gelatoapis.com`, `shipment.gelatoapis.com`, `ecommerce.gelatoapis.com`, X-API-KEY, productUid, orderReferenceId, customerReferenceId, shipmentMethodUid, draft order, Quote API, fulfillmentStatus, financialStatus, Gelato webhook, gelato.com/keys/manage, Gelato Dashboard, print-on-demand, POD fulfillment, Gelato Shopify integration, Gelato Etsy, Gelato template, Gelato variant, image placeholder, Gelato wallet, Gelato 85/15 (no — that's Adobe), Gelato pricing tiers, GelatoConnect order intake, GelatoConnect logistics, Gelato Order Desk. Trigger even when the user just says 'print-on-demand' if context suggests Gelato (e.g., they reference `gelatoapis.com` hostnames, the productUid encoding scheme, or a Gelato dashboard URL). NOTE: This skill covers the Gelato HTTP API — the customer-facing developer surface. It is NOT about GelatoConnect's production-partner APIs (those are for print facilities receiving orders from Gelato) — for GelatoConnect, confirm scope before continuing."
---

# Gelato Print-on-Demand API

Gelato is a global print-on-demand (POD) and fulfillment platform. Its public HTTP API lets developers programmatically place orders, browse the product catalog, query shipping options, manage e-commerce store templates, and receive webhook notifications as orders move through production. This skill is the developer-side guide to that API.

The skill ships with two layers of documentation:

1. **Curated references** in `references/*.md` — synthesized guides for every part of the API, with example payloads, gotchas, and recipe code. Read these first.
2. **Embedded SDK source** in `references/sources/` — the full TypeScript source of [`ekkolon/gelato-admin-node`](https://github.com/ekkolon/gelato-admin-node) (Apache-2.0), which is the most complete public type definition of the current Gelato API surface. The legacy [`gelato-api/npm-gelato-api`](https://github.com/gelato-api/npm-gelato-api) (MIT, v2-era) is included for historical context only.

> ⚠ **The official Gelato API documentation at `https://dashboard.gelato.com/docs/` is gated** behind the dashboard's web portal and is not redistributable. The curated references here distill the publicly-observable API contract; when a curated reference is insufficient, the user should sign in at the dashboard for the canonical reference page.

## Scope and versions

This skill targets the **current** (2026) Gelato API surface:

| Service | Base URL | Current version |
| --- | --- | --- |
| Orders | `https://order.gelatoapis.com` | **v4** (v3 is deprecated; v2 is legacy / removed) |
| Product Catalog | `https://product.gelatoapis.com` | **v3** |
| Shipment Methods | `https://shipment.gelatoapis.com` | **v1** |
| Ecommerce (stores, products, templates) | `https://ecommerce.gelatoapis.com` | **v1** |

Endpoints not listed above (`api.gelato.com/v2/...` from the 2018 SDK; the GelatoConnect partner-facing API at `connect-api.live.gelato.tech/docs/`) are out of scope of this skill. If the user asks about them, stop and confirm scope before continuing — GelatoConnect in particular is a different product for production-partner facilities, not for buyers/developers placing orders.

## When to consult this skill vs. just answer

Trigger on:

- Any work against `*.gelatoapis.com`.
- Integration with Gelato for fulfillment (Shopify, Etsy, WooCommerce, BigCommerce, Wix, Squarespace) where the user is touching API specifics, webhooks, or productUid mappings.
- A failed order, a 4xx response from Gelato, a webhook not arriving, a print-quality issue.
- Anything involving `productUid` decoding ("what does `apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4` mean?").
- PDF preparation for Gelato file uploads (PDF/X standards, bleed, fonts).
- Webhook signature verification or retry handling.
- Pricing / currency / VAT / wallet vs. credit-card payment questions.

Defer to a more specific skill when the user's work is dominated by the host platform — e.g., a Shopify theme question that incidentally mentions Gelato should go to a Shopify skill if one exists.

## How the Gelato API fits together (mental model)

A typical fulfillment flow:

```
1. (one-time)  Sign up at gelato.com → generate API key at dashboard.gelato.com/keys/manage
2.              Browse Product Catalog API → find catalog (e.g., "apparel") → list products
                → resolve a concrete productUid for the SKU you want to sell
3.              Use Shipment Methods API to learn which methods serve your destination country
4.              (optional) Quote API: POST a draft cart with productUid + quantity + shippingAddress
                → receive shipmentMethodUid + price options
5.              Create Order: POST /v4/orders with items[], shippingAddress, currency,
                orderReferenceId (your idempotency key), customerReferenceId
6.              Order moves through fulfillmentStatus: created → passed → printed → shipped
                (or canceled, or on_hold / pending_approval for review)
7.              Webhook notifications arrive at your registered callback URL on every status
                change (orderId, orderReferenceId, items[], tracking codes when shipped)
8.              Optionally GET /v4/orders/{id} to poll status; or use Search for batch updates
```

### Key concepts

- **productUid** — A long underscore-separated string encoding every product attribute (type, size, color, finish, paper, etc.). Generated by the catalog. You don't construct these by hand — you query the catalog and copy the `productUid` of the variant you want. Example: `apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4`. See `references/product-uid-format.md`.

- **orderReferenceId** — Your internal order ID. **You** generate this. Gelato uses it as a soft idempotency hint and for cross-referencing in webhooks. Should be unique per order.

- **customerReferenceId** — Your internal customer ID. Free-form string. Used for grouping orders by customer in your reports.

- **shipmentMethodUid** — The shipping method identifier returned by Shipment Methods or Quote API. You can also pass the strings `"normal"`, `"express"`, or `"pallet"` to let Gelato choose the cheapest method of that type. If omitted entirely, the cheapest available method is used.

- **orderType** — `"order"` (production-bound) or `"draft"` (saved for review; doesn't enter production). Only draft orders can be edited via the Patch API. Convert draft → order via the Patch API with `orderType: "order"`.

- **fulfillmentStatus** — `created`, `passed`, `failed`, `canceled`, `printed`, `shipped`, `draft`, `pending_approval`, `not_connected`, `on_hold`.

- **financialStatus** — `draft`, `pending`, `invoiced`, `to_be_invoiced`, `paid`, `canceled`, `partially_refunded`, `refunded`, `refused`.

- **Files** — Print files uploaded as URLs in the order request. Gelato fetches them. Supported formats: PDF (prefer PDF/X-1a:2003 or PDF/X-4), PNG, TIFF, SVG, JPEG. The `file.type` indicates *which print area* — `default`, `back`, `neck-inner`, `neck-outer`, `sleeve-left`, `sleeve-right`, `inside`.

## Confirm before assuming

Before writing integration code:

1. **Which version of which Gelato API?** Most active work is on Orders v4 + Product v3 + Shipment v1 + Ecommerce v1. If the user is reading old (2018-era) code that uses `api.gelato.com/v2/`, that's the legacy API — they need to migrate.
2. **Direct API or via an ecommerce-store integration?** Gelato natively integrates with Shopify, Etsy, WooCommerce, BigCommerce, Wix, Squarespace. If the storefront is one of these, the Ecommerce Stores/Templates API is the right surface and orders flow in automatically — you rarely call the Orders API directly. Direct API is for custom storefronts and headless commerce.
3. **Production or test?** Gelato does not document a public sandbox; all API calls go to production. Test orders should use a real-looking `orderReferenceId` and be canceled before they enter production (the window is short — once status hits `passed` you can't cancel).
4. **Wallet, credit card, or invoice?** Account-level billing affects the `currency` field on order create. Wallet/credit-card customers can request any of the supported ISO 4217 currencies; invoice customers are typically locked to one.
5. **What's the destination country?** Available shipment methods and applicable VAT both depend on destination. Brazil, Australia, and some other countries have extra required fields (federal/state tax IDs).

## How to find what you need

| Task | Reference |
| --- | --- |
| Getting an API key, base URLs, the `X-API-KEY` header, first request | `references/getting-started.md` |
| Orders API v4 — create / get / search / quote / patch / cancel / delete | `references/orders-api.md` |
| Decoding and constructing a `productUid`; the catalog → product → variant pipeline | `references/product-uid-format.md` |
| Product Catalog API — catalogs, products, prices, stock availability, cover dimensions | `references/catalog-and-products.md` |
| Shipment Methods API — normal/express/pallet, tracking, destination filtering | `references/shipment-methods.md` |
| Ecommerce API — stores, products, templates, variant options, image placeholders | `references/ecommerce-stores-and-templates.md` |
| Webhooks — event types, payload shape, retries, signature verification, configuration | `references/webhooks.md` |
| Preparing print files — PDF/X, bleed, resolution, image placeholders, file.type values | `references/files-and-print-files.md` |
| Pricing, currencies (40+ ISO 4217), VAT, wallet vs. credit-card, payouts | `references/pricing-currencies-charging.md` |
| Error handling, HTTP status codes, idempotency, retries | `references/error-handling-rate-limits.md` |
| Native integrations (Shopify, Etsy, WooCommerce, BigCommerce, Wix, Squarespace) + GelatoConnect | `references/integrations-and-platforms.md` |
| The common rejection / failure catalog with fixes | `references/common-pitfalls.md` |

`references/sources/INDEX.md` maps each topic to the matching SDK source file.

## Critical things to know up-front

These come up over and over.

### 1. The API is a constellation of four hosts, not one

Each Gelato API resource lives at its own subdomain:

- `order.gelatoapis.com` for everything order-related.
- `product.gelatoapis.com` for the catalog / product / pricing / stock surface.
- `shipment.gelatoapis.com` for shipment-method lookup.
- `ecommerce.gelatoapis.com` for connected-store features (templates, products on a store).

There's no single `api.gelatoapis.com` root. Many integration bugs trace to a hard-coded base URL that pointed at the wrong host.

### 2. `productUid` is the single most important string in the API

You'll see it everywhere — order items, quote items, template variants, prices, stock queries. It encodes the entire product variation (apparel type, size, color, paper, finish, page count) in an underscore-separated key=value scheme. **You cannot construct it from intuition** — you must query the Product Catalog API (`product.gelatoapis.com/v3/...`) to discover the exact UID for the SKU you want. Sending a malformed `productUid` is the most common cause of `422 Unprocessable Entity` on order create.

### 3. Orders are charged at creation, not on shipment

The instant you `POST /v4/orders` with `orderType: "order"`, Gelato attempts to charge the configured payment method (wallet balance, credit card on file, or invoice line). If the charge fails, the order does not enter production. **This is why `orderType: "draft"` exists** — to validate the payload, file URLs, and address without locking in payment. Draft orders are not produced and can be deleted with `DELETE /v4/orders/{id}` or converted with the Patch API.

### 4. File URLs must be publicly fetchable by Gelato's print servers

Gelato downloads each `file.url` server-side during order processing. URLs behind auth, behind a VPN, in a private S3 bucket without a presigned URL, or on a host that geo-blocks Gelato's data centers will fail with "file unreachable". Presigned S3 URLs that expire before processing also fail. Give the URL a lifetime of **at least 24 hours** to be safe.

### 5. PDF prep matters; PNG/JPEG often look worse than expected

For best print quality, Gelato recommends PDF/X-1a:2003 or PDF/X-4 with embedded fonts, 300 DPI minimum, CMYK or RGB color space with appropriate ICC profile, and bleed margins per the product's spec. PNG/JPEG are accepted but lose color-management fidelity. SVG and TIFF are accepted too, but PDF is the production-grade format.

### 6. Webhook retries are limited; idempotency is your job

Gelato retries failed webhook deliveries **3 times**, with **5 seconds** between attempts. After 3 failures, the event is dropped. If your endpoint is occasionally down, you'll miss notifications — supplement webhooks with periodic polling of `GET /v4/orders/{id}` for high-value orders. Each webhook payload includes both `orderId` (Gelato's ID) and `orderReferenceId` (your ID) — your handler must be idempotent on either.

### 7. The product UID format hard-couples to the catalog

A `productUid` like `apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4` decodes (roughly) as:

```
apparel_product                    catalog
_gca_t-shirt                       Garment Category Attribute = t-shirt
_gsc_crewneck                      Garment Style Cut = crewneck
_gcu_unisex                        Garment Cut = unisex
_gqa_classic                       Garment Quality = classic
_gsi_s                             Garment Size = S
_gco_white                         Garment Color = white
_gpr_4-4                           Garment Print = 4-color front, 4-color back
```

Each `_xxx_value` segment maps to a `productAttributeUid` that you can list with `GET /v3/catalogs/{catalogId}`. The 3-letter prefix (`gca`, `gsc`, etc.) is the attribute family. Don't try to construct these — list them.

### 8. The Quote API is the right way to estimate shipping before checkout

`POST /v4/orders:quote` accepts the same items + recipient and returns all available shipment methods with prices in your requested currency. Use this on the cart page to show the customer their shipping options. Quote requests are not orders and don't charge anything.

### 9. There's no public sandbox

Every API call goes to production. To test:

- Create draft orders (`orderType: "draft"`) — they don't charge or print.
- Cancel quickly if you create production orders by mistake (only possible before status hits `passed`/`printed`/`shipped`).
- Use a non-billable destination on draft orders.
- Set up a test API key separate from your production key (you can have multiple keys per account).

### 10. Integrations bypass most of the API for you

If the storefront is Shopify / Etsy / WooCommerce / BigCommerce / Wix / Squarespace, the native integration:

- Pulls products from Gelato templates into the storefront.
- When a buyer places an order, the integration creates the Gelato order automatically with the right `productUid`, files, and address.
- Tracking updates flow back to the storefront.

In this case, the developer rarely calls the Orders API directly. They might call the Ecommerce Templates API to programmatically create new product templates, or the Webhooks API to bolt on custom side-effects.

## Workflow for "build a new Gelato integration"

1. **Get the API key.** `references/getting-started.md`.
2. **Decide direct API or storefront integration.** `references/integrations-and-platforms.md`. If storefront, use the native connector; if direct, continue.
3. **Browse the catalog.** `references/catalog-and-products.md` — list catalogs, list products in your catalog, capture the `productUid` you want.
4. **(Optional) Look up shipment methods** for your target countries. `references/shipment-methods.md`.
5. **Build the order payload.** `references/orders-api.md` for the shape; `references/files-and-print-files.md` for the file URLs.
6. **Start in draft mode** to validate. POST with `orderType: "draft"`.
7. **Inspect the draft** via `GET /v4/orders/{id}`. Confirm address, productUid, files all resolved.
8. **Convert to order** via `PATCH /v4/orders/{id}` with `orderType: "order"` — or just `POST` a new one with `orderType: "order"` from the start once you're confident.
9. **Set up the webhook** to receive `order_status_updated` events. `references/webhooks.md`.
10. **Verify webhook handling** with a low-cost test order — watch each state transition fire.
11. **Add the unhappy paths**: file-fetch failures, payment declines, address validation failures.

## Workflow for "debug a failing Gelato order"

1. **What's the status?** `GET /v4/orders/{id}`. Note `fulfillmentStatus` and `financialStatus`.
2. **If `fulfillmentStatus === "failed"`** — read the error detail returned by Gelato. Common: bad productUid, missing required field, file URL unreachable, address validation failed.
3. **If `financialStatus === "refused"`** — charge failed. Check wallet balance / card on file in the dashboard.
4. **If stuck in `pending_approval`** — account is configured for manual review; needs admin action in the dashboard.
5. **If stuck in `on_hold`** — Gelato support flagged the order. Contact `support@gelato.com`.
6. **Look at the webhook history** in the dashboard for any events you might have missed.
7. **Cross-check the productUid** against the current catalog — products are occasionally retired or re-keyed.

See `references/common-pitfalls.md` for the full catalog.

## Source repos and where to refresh them

`scripts/gelato/fetch_docs.sh` re-clones:

- [`ekkolon/gelato-admin-node`](https://github.com/ekkolon/gelato-admin-node) — Apache-2.0, current v3/v4 endpoints, well-typed.
- [`gelato-api/npm-gelato-api`](https://github.com/gelato-api/npm-gelato-api) — MIT, **legacy v2 endpoints**, historical only.

The official Gelato docs at `https://dashboard.gelato.com/docs/` are the authoritative reference for the canonical request/response shapes — but they're not redistributable, so they're not bundled here. When in doubt, the user should consult that doc directly.
