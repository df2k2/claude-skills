# 10 — Shipping Rates

Two endpoints, both `POST`. They return the available shipping services for a recipient + cart, with per-service price and estimated delivery date.

| Version | Path | Envelope | Special rate limit |
|---|---|---|---|
| v2 | `POST /v2/shipping-rates` | `data` | **5 req/60s when summary item qty > 100** (default otherwise: 120 req/60s) |
| v1 | `POST /shipping/rates` | `code`/`result` | 120 req/60s |

Both produce the same conceptual answer. Use v2 for new code.

## v2 — request

```http
POST /v2/shipping-rates HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "recipient": {
    "country_code": "US",
    "state_code":   "CA",
    "zip":          "91311"
  },
  "items": [
    {
      "source": "catalog",
      "catalog_variant_id": 4011,
      "quantity": 2
    },
    {
      "source": "sync",
      "sync_variant_id":     50000123,
      "quantity": 1
    }
  ],
  "currency": "USD",
  "locale":   "en_US"
}
```

Required:

- `recipient.country_code` — ISO-3166-1 alpha-2.
- `recipient.state_code` — required for `US`, `CA`, `AU`, `JP`. Optional elsewhere.
- `items[]` — one or more line items. Each must specify `source` and the matching ID field (see below).

Optional:

- `recipient.zip` — produces a more accurate quote, especially for US.
- `currency` — quote in this currency. Defaults to the store payout currency.
- `locale` — translate service names (`X-PF-Language` header has the same effect).

### Item `source` options

| `source` | ID field |
|---|---|
| `catalog` | `catalog_variant_id` |
| `sync` | `sync_variant_id` |
| `external` | `external_variant_id` |
| `warehouse` | `warehouse_product_variant_id` |

## v2 — response

```json
{
  "data": [
    {
      "id": "STANDARD",
      "name": "Flat Rate (3-5 business days after fulfillment)",
      "rate": "4.95",
      "currency": "USD",
      "min_delivery_days": 3,
      "max_delivery_days": 5,
      "min_delivery_date": "2026-05-20",
      "max_delivery_date": "2026-05-22"
    },
    {
      "id": "PRINTFUL_FAST",
      "name": "Express (1-3 business days after fulfillment)",
      "rate": "12.95",
      "currency": "USD",
      "min_delivery_days": 1,
      "max_delivery_days": 3,
      "min_delivery_date": "2026-05-18",
      "max_delivery_date": "2026-05-20"
    }
  ]
}
```

The `id` is what you pass as `order.shipping` when creating the order (see [`07-orders-v2.md`](07-orders-v2.md)). Service IDs are stable but the list varies by region and item type — always quote before assuming a specific service exists.

## Why the 5-req/min limit matters

Shipping-rate calculation is expensive (per-region carrier APIs, multi-item routing). Printful drops the rate limit to **5 req/60s** when the summary item quantity (`sum(items[].quantity)`) exceeds 100. Hitting the limit triggers the standard 60-second lockout.

Mitigations for high-quantity quotes:

1. **Aggregate identical items** into one line with a higher `quantity` rather than many lines of `quantity: 1` — the limit is on summary quantity, not on item count, but fewer items also means fewer rates to compute and a faster response.
2. **Cache rates** for short-lived UI flows. The (recipient country, item composition) tuple is stable for the duration of a checkout session — cache for 5–10 minutes.
3. **Bulk-quote at checkout, not on every cart change** — only fetch rates when the customer reaches shipping selection.

## Country/state code accuracy

- The `country_code` must be exactly two ASCII uppercase letters from ISO-3166-1 alpha-2. `USA`, `US-NY`, lowercase `us` all return `422`.
- The `state_code` for the US, CA, AU, JP is the ISO-3166-2 subdivision part without the country prefix. Examples: `CA` for California, `ON` for Ontario, `NSW` for New South Wales, `13` for Tokyo. The full list comes from `GET /v2/countries`.
- For other countries, omit `state_code` entirely. Sending a state code for, e.g. Germany, returns a `422`.

## Estimating before an address is finalized

`country_code` alone is sufficient for a rough quote (and `state_code` for US/CA/AU/JP). Show "Shipping from $4.95" on a product page using only the user's country — refine when they enter a zip during checkout.

## v1 — request and response

Identical concept, v1 envelope:

```http
POST /shipping/rates HTTP/1.1
Authorization: Bearer {token}

{
  "recipient": { "country_code": "US", "state_code": "CA", "zip": "91311" },
  "items": [ { "variant_id": 4011, "quantity": 2 } ],
  "currency": "USD",
  "locale":   "en_US"
}
```

v1 item shape uses `variant_id` (catalog variant) or `sync_variant_id` rather than the `source` discriminator.

Response:

```json
{
  "code": 200,
  "result": [
    { "id": "STANDARD", "name": "…", "rate": "4.95", "currency": "USD", "minDeliveryDays": 3, "maxDeliveryDays": 5 }
  ]
}
```

Note v1's `minDeliveryDays` / `maxDeliveryDays` are camelCase strings inside the `result` — a rare exception to the otherwise snake_case API. v2 normalized this to `min_delivery_days` / `max_delivery_days` snake_case.

## Original sources

- v2 endpoint: see **Shipping Rates v2** section in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Schemas: `CatalogShippingRateItem`, `WarehouseShippingRateItem`, `ShippingRatesAddress` in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
