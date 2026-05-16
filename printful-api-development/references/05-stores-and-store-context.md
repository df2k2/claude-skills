# 05 — Stores and store context

In Printful, a **Store** is the top-level container for products, orders, billing, and integrations. A merchant can own multiple stores (one per brand, region, or platform integration).

## Store types

Set when the store is created in the Printful dashboard:

| Type | Description |
|---|---|
| `shopify` | Shopify integration — products sync automatically. |
| `etsy` | Etsy integration. |
| `woocommerce` | WooCommerce. |
| `bigcommerce` | BigCommerce. |
| `ecwid` | Ecwid. |
| `wix` | Wix. |
| `squarespace` | Squarespace. |
| `prestashop` | PrestaShop (via the Printful module). |
| `magento` | Magento 2 (via the Printful module). |
| `webhook` | Generic webhook-based custom integration. |
| `api` | A pure API store — no platform integration. **Use this for headless / custom integrations.** |

The store type affects how Sync Products behave. On `shopify` / `woocommerce` / etc., changes propagate back to the merchant's storefront. On `api` / `webhook` stores, Sync Products exist only inside Printful and your code is responsible for any storefront-side mirror.

## Listing stores

### v2

```bash
curl https://api.printful.com/v2/stores \
  -H "Authorization: Bearer $PF_TOKEN"
```

Returns one or more `StoreSchema` objects. Requires the **`stores_list`** OAuth scope unless the token is bound to a single store.

```json
{
  "data": [
    {
      "id": 12345,
      "name": "My Brand US",
      "type": "shopify",
      "website": "mybrand.com",
      "created": "2024-09-01T12:00:00Z",
      "currency": "USD",
      "payment_card": { … },
      "return_address": { … }
    }
  ]
}
```

### `GET /v2/stores/{store_id}`

Single store. Same shape as the list entry. Returns `404` if the store ID isn't accessible to the current token.

### `GET /v2/stores/{store_id}/statistics`

Returns aggregate sales-and-cost metrics for a date range. Useful for dashboards.

Query parameters:
- `from` (ISO 8601 date, required) — start of the range.
- `to` (ISO 8601 date, required) — end of the range.
- `currency` (optional) — convert all amounts to this currency.

Response (`SalesAndCosts` / `SalesAndCostsSummary` schemas):

```json
{
  "data": {
    "currency": "USD",
    "totals": {
      "sales": "12345.67",
      "costs": "8901.23",
      "profit": "3444.44",
      "orders_count": 87
    },
    "by_day": [
      {
        "date": "2026-05-01",
        "sales": "456.78",
        "costs": "320.12",
        "profit": "136.66",
        "orders_count": 4
      }
    ]
  }
}
```

The schema also includes `TotalPaidOrders`, `Costs`, `CostsByAmount`, `CostsByProduct`, `CostsByVariant`, and `AverageFulfillmentTime` blocks — see [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md) for the full field list.

## Selecting the active store on each call

If a token has access to multiple stores (OAuth with `stores_list` scope, or a Personal Token elevated to multi-store), every call needs to indicate which store to target. There are two equivalent ways:

### Header (recommended)

```http
GET /v2/orders HTTP/1.1
Authorization: Bearer {token}
X-PF-Store-Id: 12345
```

Header form works on **every endpoint** and is the only way to scope endpoints that don't accept a `store_id` query parameter.

### Query parameter (older v1 convention)

```http
GET /orders?store_id=12345 HTTP/1.1
Authorization: Bearer {token}
```

Some v1 endpoints accept `store_id` in the query string. **The header takes precedence** when both are sent.

## Single-store tokens

A Personal Access Token is bound to a single store at creation time. Multi-store header/parameter values are ignored (or 403'd, depending on the endpoint) — the token's store is always used. For diagnostics, call `GET /v2/oauth-scopes` to confirm the granted scopes.

## Default store fallback

If a multi-store token does not send `X-PF-Store-Id` (or `store_id`), Printful uses the **default store** — the one marked as default in the Printful dashboard. This is rarely what you want; **always send `X-PF-Store-Id`** on multi-store integrations.

## Webhook URL scope

Webhook configuration is **per-store**. Calling `POST /v2/webhooks` configures the URL + secret for the current store only. Multi-store apps must call it once per store (with the matching `X-PF-Store-Id`).

The webhook event payload includes a `store_id` field — use it to route the event back to the right merchant in your database.

## Return address

Each store has a default **return address** displayed on the shipping label when fulfillment fails. Set in the dashboard under **Settings → Stores → Return address**. The `GET /v2/stores/{store_id}` response includes the configured `return_address` block (or `null` if unset).

## Currency

The store's payout currency is set in the dashboard and returned on `GET /v2/stores/{store_id}` as `currency`. All order responses are quoted in this currency unless the endpoint accepts a `currency` override (catalog endpoints do; orders do not).

## Original sources

- `StoreSchema`, `StoreStatistics`, `SalesAndCosts*`, `TotalPaidOrders`, `Costs*` — see [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
- Stores endpoints — see the **Stores v2** section of [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
