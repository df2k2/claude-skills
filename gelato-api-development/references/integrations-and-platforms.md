# Integrations and Platforms

Gelato has two distinct integration surfaces beyond the raw HTTP API: **storefront integrations** (Shopify, Etsy, WooCommerce, BigCommerce, Wix, Squarespace, etc.) that automate order flow from e-commerce platforms, and **GelatoConnect** which is the production-partner-facing API (different product, different audience). Plus a handful of third-party integrations like Odoo and Order Desk. This reference is a map of which integration to choose for which situation.

## Storefront integrations

Native integrations are listed at https://www.gelato.com/integrations. The currently supported platforms:

| Platform | What it does | Setup |
| --- | --- | --- |
| **Shopify** | Bidirectional: products pushed from Gelato → Shopify; orders pushed from Shopify → Gelato; tracking back to Shopify. | App install from Shopify App Store + connect in dashboard. |
| **Etsy** | Same flow, scoped to Etsy's product / listing model. | Connect via dashboard.gelato.com/ecommerce. |
| **WooCommerce** | Same flow via Gelato WooCommerce plugin. | WordPress plugin install + API keys. |
| **BigCommerce** | Same flow. | App install + connect. |
| **Wix** | Same flow, via Wix-specific app. | App install. |
| **Squarespace** | Same flow. | App install. |
| **TikTok Shop** | Newer integration. | Check dashboard for current status. |

### How a storefront integration works end-to-end

```
1. Designer creates a template in dashboard.gelato.com.
2. Designer pushes a product to the connected store
   (via UI or via POST /v1/stores/{storeId}/products from the Ecommerce API).
3. Gelato composes preview images + variants and publishes to the store.
4. Product is now live on Shopify / Etsy / etc., visible to buyers.
5. Buyer places order on the storefront.
6. Storefront integration captures the order and creates a Gelato order
   automatically with the right productUid + files + shipping address.
7. Gelato charges the seller's wallet/card (or invoices) for production cost.
8. Gelato produces and ships.
9. Tracking codes flow back to the storefront, marking the storefront order as fulfilled.
```

The developer never calls `POST /v4/orders` directly in this flow — the integration does it.

### When to use storefront integration vs. direct API

| Use storefront integration when... | Use direct API when... |
| --- | --- |
| You're using one of the supported platforms. | Custom storefront / headless. |
| Your product catalog matches a Gelato template. | Highly variable products. |
| You're OK with Gelato's automatic order creation. | You need full control over `orderReferenceId`, `metadata`, draft → patch flows. |
| You want automatic tracking back. | You manage tracking notifications yourself. |
| You're a designer / non-developer. | You have engineering capacity. |

### Common storefront-integration questions

| Question | Answer |
| --- | --- |
| Can I edit a published product from the API? | No — edit in the storefront, or delete + re-push. |
| Can I add my own custom variants outside the template? | Only via the storefront. The Ecommerce API only creates from templates. |
| Do I get webhooks for storefront orders? | Yes — same `order_status_updated` events; `channel` field is `"shopify"`/`"etsy"`/etc. |
| Can I have multiple stores connected to one Gelato account? | Yes — `storeId` distinguishes them; `GET /v1/stores/{storeId}/products` is per-store. |
| Does the integration handle storefront tax / VAT? | The storefront handles customer-facing tax; Gelato handles production-side VAT for the seller. |

## Order Desk

[Order Desk](https://apisupport.gelato.com/hc/en-us/articles/360016975040-Getting-started-with-Order-Desk) is a legacy order-management UI that some Gelato customers use. It's:

- An older integration layer between storefronts and Gelato.
- Mostly superseded by the native storefront integrations.
- Still supported for migration paths.

For new integrations, skip Order Desk and use the native storefront integration or the direct API.

## Odoo

[Odoo](https://www.odoo.com/documentation/18.0/applications/sales/sales/gelato.html) is an open-source ERP/CRM that has a Gelato connector. Use it when:

- The customer is already on Odoo for ERP/CRM.
- You want orders created in Odoo to flow to Gelato for fulfillment.

The Odoo connector wraps the Gelato API on the Odoo side. Documentation at the Odoo docs link above.

## GelatoConnect (DIFFERENT PRODUCT — confirm scope)

`https://connect-api.live.gelato.tech/docs/` is **GelatoConnect**, which is a different product from the standard Gelato API:

- **Audience**: production partners (print facilities, fulfillment centers) **receiving** orders from Gelato.
- **Not for**: developers placing orders **into** Gelato.
- API has its own surfaces: Order Intake, Logistics (shipping order create), etc.

If a user references `connect-api.live.gelato.tech` or "GelatoConnect", **confirm scope before continuing**:

- Are they a print-shop integrating to receive orders from Gelato? → GelatoConnect docs.
- Are they a developer placing orders into Gelato? → standard Gelato API (this skill).

The two share branding but the API contracts, hosts, and conceptual model are unrelated.

GelatoConnect-specific endpoints (out of scope for this skill):

- `https://connect-api.live.gelato.tech/docs/order-intake/api/submit_order/` — receive a new order.
- `https://connect-api.live.gelato.tech/docs/logistics/api/order_create/` — create a shipping order.

## Multi-region fulfillment

Gelato has production sites worldwide (NA, EU, Asia, AU). When you place an order, Gelato routes to the production facility closest to the destination, automatically. As a developer, you don't choose the region — Gelato does, based on:

- Destination country.
- Product availability in each region.
- Production capacity.

For multi-item orders that need different production regions (e.g., apparel produced in EU, posters produced in NA), the order can split. The response's `connectedOrderIds` lists the connected sub-orders.

## Currency / locale considerations

- Storefront prices are independent of Gelato production prices.
- Your storefront can charge customers in their local currency; you pay Gelato in your wallet's currency.
- Markup calculation: `(your storefront price - Gelato production price) - any storefront fees = your margin`.

## Webhooks across integrations

All integrations use the same Gelato webhook event types (`order_status_updated`, `order_item_status_updated`). The `channel` field on the order tells you which integration produced it:

| `channel` | Meaning |
| --- | --- |
| `api` | Direct API call (no storefront). |
| `ui` | Manual dashboard entry. |
| `shopify` | Shopify integration. |
| `etsy` | Etsy integration. |

(Other channels exist for newer integrations.)

## Programmatic webhook configuration is not available

You can't `POST` a webhook configuration via API. Manage webhook URLs in `dashboard.gelato.com` → Webhooks.

## Third-party SDKs and tools

| SDK | Language | Status | Notes |
| --- | --- | --- | --- |
| [`ekkolon/gelato-admin-node`](https://github.com/ekkolon/gelato-admin-node) | TypeScript / Node.js | Active, community | Apache-2.0. Tracks v3/v4 endpoints. Recommended. |
| [`gelato-api/npm-gelato-api`](https://github.com/gelato-api/npm-gelato-api) | Node.js | Legacy (v2 era) | MIT. Don't use for new code; the v2 API it targets is retired. |
| Official PHP/Python/Go SDKs | — | None public | No first-party SDKs as of current. The API is small enough to wrap inline. |

## Picking the right surface — decision flow

```
Are you building a new integration?
├── Yes
│   ├── Is your storefront Shopify/Etsy/WooCommerce/BigCommerce/Wix/Squarespace?
│   │   ├── Yes → Use the native storefront integration. Configure in dashboard.gelato.com.
│   │   │       Use the Ecommerce API only if you need to programmatically push templates.
│   │   └── No  → Use the direct API. POST /v4/orders, etc.
│   └──
└── No (debugging existing)
    ├── Code calls api.gelato.com/v2/... → migrate to per-service hosts (order.gelatoapis.com etc).
    ├── Code calls dashboard.gelato.com/docs/... → not callable; that's the doc site.
    ├── Code calls connect-api.live.gelato.tech/... → GelatoConnect, different product. Confirm scope.
    └── Code calls *.gelatoapis.com → standard API; this skill covers it.
```

## Original sources

- https://www.gelato.com/integrations (current platform list).
- https://www.odoo.com/documentation/18.0/applications/sales/sales/gelato.html (Odoo connector).
- https://apisupport.gelato.com/hc/en-us/articles/360016975040-Getting-started-with-Order-Desk (Order Desk).
- https://connect-api.live.gelato.tech/docs/ (GelatoConnect — different product).
- https://www.gelato.com/order-flow (Order Flow API overview).
- Official (gated): https://dashboard.gelato.com/docs/ — main API docs.
