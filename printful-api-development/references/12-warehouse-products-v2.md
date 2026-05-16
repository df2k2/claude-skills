# 12 — Warehouse Products (v2)

Printful Warehousing is a 3PL service: merchants ship their own inventory to a Printful fulfillment center, Printful stores it, and Printful picks/packs/ships it as part of normal order flow. This is a separate product from the on-demand printing business; many integrations never touch it.

Use the Warehouse Products API when:

- The merchant has enrolled in Printful Warehousing (visible in dashboard → Warehouse section).
- You need to list the warehoused SKUs and their stock levels.
- You need to create orders that pull from warehouse stock (`source: "warehouse"` on order items).

## Endpoints

| Method | Path | What |
|---|---|---|
| `GET` | `/v2/warehouse-products` | List warehouse products (paginated). |
| `GET` | `/v2/warehouse-products/{warehouse_product_id}` | Single warehouse product, including variants and stock. |

Warehouse products are **not catalog products** — they are merchant-owned SKUs that Printful happens to be storing.

## Listing

```http
GET /v2/warehouse-products?limit=50 HTTP/1.1
Authorization: Bearer {token}
X-PF-Store-Id: {store_id}
```

Response (per `WarehouseItemSummary`):

```json
{
  "data": [
    {
      "id": 7777,
      "external_id": "merchant-sku-mug-12oz",
      "name": "12oz Custom Mug",
      "variants_count": 3,
      "thumbnail_url": "https://files.cdn.printful.com/.../mug.jpg",
      "in_stock": true,
      "out_of_stock_variants_count": 0
    }
  ],
  "paging": { "offset": 0, "limit": 50, "total": 17 },
  "_links": { … }
}
```

## Single product

```http
GET /v2/warehouse-products/7777 HTTP/1.1
```

Response (per `WarehouseItemReadonly`):

```json
{
  "data": {
    "id": 7777,
    "external_id": "merchant-sku-mug-12oz",
    "name": "12oz Custom Mug",
    "thumbnail_url": "https://…",
    "variants": [
      {
        "id": 88001,
        "external_id": "merchant-sku-mug-12oz-blue",
        "name": "12oz Custom Mug — Blue",
        "stock":      143,
        "reserved":   12,
        "available":  131,
        "low_stock_threshold": 25
      }
    ]
  }
}
```

Stock fields:

- `stock` — total units in Printful's warehouse for this merchant.
- `reserved` — committed to pending orders, not yet shipped.
- `available` — `stock - reserved`. **This is the number you can order.**
- `low_stock_threshold` — merchant-configured warning level.

## Ordering from warehouse stock

In an order item, set `source: "warehouse"` and `warehouse_product_variant_id`:

```json
{
  "source": "warehouse",
  "warehouse_product_variant_id": 88001,
  "quantity": 2
}
```

No `placements` block — warehouse items are pre-built, finished products. Mixing warehouse items and on-demand items in the same order is supported; Printful may split the shipment.

## Replenishing stock

Replenishment (sending more inventory to Printful) is initiated from the dashboard, not the API. The API is read-only for inventory levels.

## Webhook event

`stock_updated` (v2 webhook) fires when warehouse stock changes (sale, replenishment, manual adjustment). Subscribe via `POST /v2/webhooks/stock_updated`. The payload includes `warehouse_product_variant_id`, the new `available`, `stock`, and `reserved` counts.

## When the merchant isn't enrolled

Calling these endpoints on a store without Warehousing returns either an empty list or a `403` depending on configuration. Don't surface UI for these endpoints unless `GET /v2/warehouse-products` returns a non-empty list.

## Original sources

- Endpoint metadata: **Warehouse Products v2** section in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Schemas: `WarehouseItemSummary`, `WarehouseItemReadonly`, `ItemWithoutPlacements` in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
