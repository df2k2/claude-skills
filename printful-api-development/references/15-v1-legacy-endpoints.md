# 15 — v1 legacy endpoints

Some functionality lives **only on v1**. Until v2 reaches feature parity, you'll hit these paths even in a mostly-v2 integration. All paths below are relative to `https://api.printful.com/`.

## Sync Products and Sync Variants (`/store/*`)

Sync Products map your storefront's items (SKUs) to Printful catalog variants. **There is no v2 equivalent yet**; if you sell custom-designed merch via Shopify/WooCommerce/Wix/etc., you'll use this surface.

### Endpoints

| Method | Path | What |
|---|---|---|
| `GET`    | `/store/products` | List sync products. |
| `GET`    | `/store/products/{id}` | One sync product + its sync variants. |
| `POST`   | `/store/products` | Create a sync product. |
| `PUT`    | `/store/products/{id}` | Update a sync product. |
| `DELETE` | `/store/products/{id}` | Delete a sync product. |
| `GET`    | `/store/variants/{id}` | One sync variant. |
| `POST`   | `/store/products/{id}/variants` | Add a variant to a sync product. |
| `PUT`    | `/store/variants/{id}` | Update a sync variant. |
| `DELETE` | `/store/variants/{id}` | Delete a sync variant. |

### Object shape

```json
{
  "code": 200,
  "result": {
    "sync_product": {
      "id": 50000001,
      "external_id": "shopify-prod-9999",
      "name":        "My Brand Tee",
      "variants":    3,
      "synced":      3,
      "thumbnail_url": "https://files.cdn.printful.com/.../thumb.png",
      "is_ignored":  false
    },
    "sync_variants": [
      {
        "id":            50001001,
        "external_id":   "shopify-var-1",
        "sync_product_id": 50000001,
        "name":          "My Brand Tee — White / M",
        "synced":        true,
        "variant_id":    4011,           // catalog variant
        "retail_price":  "24.99",
        "sku":           "SKU-001",
        "currency":      "USD",
        "product":       { "variant_id": 4011, "product_id": 71, "image": "…", "name": "…" },
        "files":         [
          { "type": "default", "id": 600001, "url": "https://files.cdn.printful.com/.../design.png", "preview_url": "…", "placement": "front" }
        ],
        "options":       [],
        "is_ignored":    false
      }
    ]
  }
}
```

### Listing

```bash
curl "https://api.printful.com/store/products?status=synced&limit=100&offset=0" \
  -H "Authorization: Bearer $PF_TOKEN"
```

Query params: `offset`, `limit`, `status` (`all`, `synced`, `unsynced`, `ignored`), `search`.

### Creating

```http
POST /store/products HTTP/1.1
Content-Type: application/json

{
  "sync_product": {
    "name": "My Brand Tee",
    "thumbnail": "https://your-cdn.example.com/tee_thumb.png",
    "external_id": "shopify-prod-9999"
  },
  "sync_variants": [
    {
      "variant_id": 4011,
      "external_id": "shopify-var-1",
      "retail_price": "24.99",
      "sku": "SKU-001",
      "files": [
        { "type": "default", "url": "https://your-cdn.example.com/design.png", "placement": "front" }
      ]
    }
  ]
}
```

`files[].type`: `default` (the print itself), `preview` (a custom preview to show in dashboards), `back`, `sleeve_left`, `sleeve_right`, `embroidery_chest_left`, etc. — the `placement` field is the source of truth; `type` is occasionally redundant.

### Updating a Sync Variant

```http
PUT /store/variants/50001001 HTTP/1.1
Content-Type: application/json

{
  "retail_price": "27.99",
  "files": [
    { "type": "default", "url": "https://your-cdn.example.com/new-design.png", "placement": "front" }
  ]
}
```

Updating `files` triggers re-processing and the `product_updated` webhook event.

### Deleting

`DELETE /store/products/{id}` removes the sync product and all its variants. `DELETE /store/variants/{id}` removes one variant.

### Ordering against a sync variant

In v2, set `source: "sync"` and `sync_variant_id` on the order item. In v1, set `sync_variant_id` (no source discriminator). See [`07-orders-v2.md`](07-orders-v2.md).

### v2 successor?

Printful has signaled that Sync Products will eventually move to v2, but as of the current OpenAPI snapshot there is no `/v2/store/*` surface. Plan integrations around the v1 endpoints for now.

## Tax Rates (`/tax/*`)

v1 only. There is no v2 tax endpoint; v2 omits this functionality entirely (Printful expects you to either rely on the order endpoint's automatic tax calculation or use a third-party tax service for complex jurisdictions).

### `POST /tax/rates`

```http
POST /tax/rates HTTP/1.1
Content-Type: application/json

{
  "recipient": {
    "country_code": "US",
    "state_code":   "CA",
    "city":         "Chatsworth",
    "zip":          "91311"
  }
}
```

Response:

```json
{
  "code": 200,
  "result": {
    "required": true,
    "rate":     0.10,
    "shipping_taxable": true
  }
}
```

`rate` is a decimal (e.g. `0.10` = 10%). `required` indicates whether Printful applies tax for this address (some jurisdictions auto-handle, some require explicit calculation). `shipping_taxable` indicates whether shipping itself is taxable in the jurisdiction.

### `GET /tax/countries`

Returns the list of countries (with state subdivisions) for which Printful provides tax calculation:

```json
{
  "code": 200,
  "result": [
    {
      "country_code": "US",
      "name": "United States",
      "states": [ { "state_code": "CA", "name": "California" }, … ]
    }
  ]
}
```

Use this to scope your "calculate tax via Printful" feature — for countries not in this list, fall back to your own tax engine.

## v1 catalog (`/products/*`)

v2 catalog is the recommended path for new code, but v1 still serves the same data and is the basis of many older integrations.

| Method | Path | What |
|---|---|---|
| `GET` | `/products` | List catalog products. |
| `GET` | `/products/{id}` | Single product + variants. |
| `GET` | `/products/variant/{variant_id}` | Single variant. |
| `GET` | `/products/{id}/sizes` | Size guide. |
| `GET` | `/products/{id}/prices` | Prices. |
| `GET` | `/products/{id}/images` | Blank images. |

Same conceptual data as v2, different envelope (`result` vs `data`). For new code use v2.

## v1 country list (`/countries`)

```bash
curl https://api.printful.com/countries -H "Authorization: Bearer $PF_TOKEN"
```

```json
{
  "code": 200,
  "result": [
    { "code": "US", "name": "United States", "states": [ { "code": "CA", "name": "California" } ] }
  ]
}
```

v2 (`GET /v2/countries`) has an extra `region` field; v1 omits it.

## v1 shipping (`/shipping/rates`)

See [`10-shipping-rates.md`](10-shipping-rates.md) — v1 request/response documented there.

## v1 orders (`/orders/*`)

Full surface mirrored in [`sources/PrintfulOrder.php`](sources/PrintfulOrder.php). Key differences from v2:

- Envelope: `code`/`result` (not `data`).
- External ID lookup uses `@` prefix: `GET /orders/@my-external-id`.
- Single-shot order create: `POST /orders?confirm=1` to skip the draft step.
- Confirmation: `POST /orders/{id}/confirm` (no trailing `ation`).
- Cost estimation: `POST /orders/estimate-costs` (synchronous; v2's async equivalent is `POST /v2/order-estimation-tasks`).
- Files inside items: v1 uses a flat `files` array per item, not `placements[].layers[]`. The v1 file model lacks multi-layer support per placement — for embroidery with custom thread colors or for stacked designs, use v2.

## v1 mockup generator (`/mockup-generator/*`)

Full surface documented in [`08-mockup-generator.md`](08-mockup-generator.md). Use the v1 endpoints when you specifically need:

- `GET /mockup-generator/printfiles/{product_id}` — per-variant printfile coordinates.
- `GET /mockup-generator/templates/{product_id}` — template images + placement-coordinate metadata.

These are not exposed in v2 yet. The rendering call itself (`POST /mockup-generator/create-task/{product_id}`) has a v2 successor.

## v1 webhooks (`/webhooks`)

See [`14-webhooks.md`](14-webhooks.md).

## Mixed v1+v2 in one integration

It's standard practice. The auth token works on both; the only thing you switch is the path prefix (and envelope handling). Example: a Shopify integration might use v1 `/store/products` to sync products, v2 `/v2/orders` to create orders, v2 `/v2/mockup-tasks` for previews, v1 `/tax/rates` for tax, and v2 `/v2/webhooks/*` for event subscriptions.

## Original sources

- v1 endpoint surface in code form: [`sources/PrintfulOrder.php`](sources/PrintfulOrder.php), [`sources/PrintfulProducts.php`](sources/PrintfulProducts.php), [`sources/PrintfulMockupGenerator.php`](sources/PrintfulMockupGenerator.php), [`sources/PrintfulTaxRates.php`](sources/PrintfulTaxRates.php), [`sources/PrintfulWebhook.php`](sources/PrintfulWebhook.php).
- Transport (auth + envelope handling): [`sources/PrintfulApiClient.php`](sources/PrintfulApiClient.php).
- Live developer site (v1): `https://developers.printful.com/docs/`.
