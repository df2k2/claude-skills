# 07 — Orders (v2)

The Orders API is the heart of the integration. It manages the lifecycle from draft → fulfilled, takes the design data (file URLs + placement positioning), calculates costs, and exposes shipments and invoices.

## Endpoint list

All paths are `https://api.printful.com/v2/`.

| Method | Path | What |
|---|---|---|
| `GET`    | `orders` | List orders (filterable). |
| `POST`   | `orders` | Create order (draft, or single-shot with items). |
| `GET`    | `orders/{order_id}` | Single order. |
| `PATCH`  | `orders/{order_id}` | Update a draft order (address, gift, packing slip, retail costs, currency). |
| `DELETE` | `orders/{order_id}` | Cancel a draft, or cancel a pending order before fulfillment starts. |
| `POST`   | `orders/{order_id}/confirmation` | Submit a draft for fulfillment. |
| `GET`    | `orders/{order_id}/order-items` | List items on the order. |
| `POST`   | `orders/{order_id}/order-items` | Add an item to a draft. |
| `GET`    | `orders/{order_id}/order-items/{order_item_id}` | One item. |
| `PATCH`  | `orders/{order_id}/order-items/{order_item_id}` | Update an item on a draft. |
| `DELETE` | `orders/{order_id}/order-items/{order_item_id}` | Remove an item from a draft. |
| `GET`    | `orders/{order_id}/shipments` | Shipments + tracking events. |
| `GET`    | `orders/{order_id}/invoices` | Invoice for the order. |
| `POST`   | `order-estimation-tasks` | Create an async cost-estimate task. |
| `GET`    | `order-estimation-tasks` | Poll the task. |

## Order lifecycle

```
   ┌──────┐  POST /v2/orders/{id}/confirmation   ┌─────────┐
   │ draft│ ─────────────────────────────────▶   │ pending │
   └──────┘                                       └─────────┘
       ▲                                               │
       │   PATCH/POST item                              │
       │   (until confirmed)                            │
       │                                               ▼
       │                                       ┌───────────┐
       │  (Printful corrects/edits)            │ inprocess │
       │                                       └───────────┘
       │                                               │
       │   ┌──────────┐                                ▼
       └──▶│  failed  │                       ┌────────────────┐
           └──────────┘                       │ fulfilled /    │
                ▲                             │ partial /      │
                │                             │ onhold /       │
                │                             │ canceled       │
                │                             └────────────────┘
```

Statuses (`Order.status`):

| Status | Meaning |
|---|---|
| `draft` | Created but not submitted. Editable. No charge. Cancellable for free. |
| `pending` | Submitted; charging in progress. Editable in limited ways (some fields locked). |
| `failed` | Submitted but blocked (bad address, missing payment, invalid file). Editable; re-confirm. |
| `inprocess` | Fulfillment started. Most edits locked. |
| `onhold` | Held for review (suspected issue, manual approval needed). |
| `partial` | Some items shipped, others not (multi-shipment orders). |
| `fulfilled` | All items shipped. |
| `canceled` | Cancelled by merchant or Printful. |
| `archived` | Old completed orders moved out of the active list (still queryable). |

`POST /v2/orders/{id}/confirmation` transitions `draft → pending`. `DELETE` transitions `draft → canceled` for free, or `pending → canceled` if charging hasn't finished; later cancels may be refused (`409 Conflict`).

## Order anatomy

The `Order` schema (full field list in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md#order)):

```json
{
  "id": 12345678,
  "external_id": "shopify-1001",
  "store_id": 100,
  "status": "draft",
  "shipping": "STANDARD",
  "shipping_service_name": "Flat Rate (3-5 business days after fulfillment)",
  "created_at": "2026-05-16T14:00:00Z",
  "updated_at": "2026-05-16T14:00:00Z",
  "recipient":   { … Address … },
  "retail_costs":{ "currency": "USD", "subtotal": "29.95", … },
  "costs":       { "currency": "USD", "subtotal": "12.50", "shipping": "4.95", "tax": "0.00", "vat": "0.00", "discount": "0.00", "total": "17.45" },
  "gift":        { "subject": "Happy Birthday", "message": "…" } | null,
  "packing_slip":{ "email": "store@example.com", "phone": "…", "message": "…", "logo_url": "…", "store_name": "…", "custom_order_id": "…" } | null,
  "currency": "USD",
  "order_items": [ … Item … ],
  "_links": { … }
}
```

Key fields:

- **`external_id`** — your ID. Pass on creation. Used for dedup (`409` on collision). Recover with `GET /v2/orders?external_id=…`.
- **`shipping`** — service code. Common values: `STANDARD`, `PRINTFUL_FAST` (faster, more expensive), `LV1` (registered, tracked), region-specific codes. List the available services for the recipient via the shipping rates endpoint.
- **`recipient`** — see `Address` schema. `country_code` (required, ISO-3166-1 alpha-2) and `state_code` (required for US/CA/AU/JP) are the only strictly required fields; `address1`, `city`, `zip` are required for actual fulfillment but optional in a pre-shipping-quote draft.
- **`retail_costs`** — what you charged the customer. Used on the packing slip; doesn't change what Printful charges *you*. Set this so customs values are correct.
- **`costs`** — what Printful will charge you. Recalculated on every change to the draft. **Don't rely on this before `pending`** — values can shift.
- **`gift` / `packing_slip`** — optional customization printed on the slip.

### Address

```json
{
  "name":       "Jane Doe",
  "company":    "Acme",
  "address1":   "19749 Dearborn St",
  "address2":   "Apt 4",
  "city":       "Chatsworth",
  "state_code": "CA",
  "state_name": "California",
  "country_code": "US",
  "country_name": "United States",
  "zip":        "91311",
  "phone":      "+15555550100",
  "email":      "jane@example.com",
  "tax_number": "…"  // for EU VAT shipments
}
```

`country_name` and `state_name` are optional — Printful resolves them from the codes. Sending only the codes is fine.

## Creating an order — minimal draft (no items)

```http
POST /v2/orders HTTP/1.1
Host: api.printful.com
Authorization: Bearer {token}
Content-Type: application/json

{
  "recipient": {
    "address1": "19749 Dearborn St",
    "city": "Chatsworth",
    "state_code": "CA",
    "country_code": "US",
    "zip": "91311"
  }
}
```

Response: 200 with the new order object, `status: "draft"`, `order_items: []`. Use this when you don't yet know what the customer will buy (cart flow).

## Creating an order with items in one request

```http
POST /v2/orders HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "external_id": "shopify-1001",
  "recipient":   { … },
  "shipping":    "STANDARD",
  "order_items": [
    {
      "source": "catalog",
      "catalog_variant_id": 4011,
      "quantity": 1,
      "placements": [
        {
          "placement": "front",
          "technique": "dtg",
          "layers": [
            { "type": "file", "url": "https://your-cdn.example.com/design.png" }
          ]
        }
      ]
    }
  ]
}
```

This creates the order **as a draft**. To skip the draft state and submit immediately, pass `confirm: true` at the top level (some integrations also use a `?confirm=1` query parameter — both work):

```json
{
  "confirm": true,
  "external_id": "shopify-1001",
  "recipient":   { … },
  "order_items": [ … ]
}
```

## Adding items to an existing draft

```http
POST /v2/orders/{order_id}/order-items HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "source": "catalog",
  "catalog_variant_id": 4011,
  "quantity": 2,
  "placements": [ { … } ]
}
```

Each add re-calculates `costs`. The response is the entire updated order.

### Item sources

```
"source": "catalog"     ← order against a Catalog Variant directly; supply design data via `placements`
"source": "sync"        ← order against a Sync Variant (uses pre-mapped design data from /store/variants); supply `sync_variant_id`
"source": "external"    ← order against a Sync Variant by external (merchant) ID; supply `external_variant_id`
"source": "warehouse"   ← order from Printful Warehousing stock; supply `warehouse_product_variant_id`
```

For `sync` and `external` sources, **no `placements` block is needed** — the Sync Variant already has the design files attached. For `catalog` and `warehouse`, the `placements` block carries the design data.

## Design data: `placements` and `layers`

A `placement` describes where on the product the design goes. The `layers` array stacks one or more files/colors at that placement.

```json
{
  "placement": "front",
  "technique": "dtg",
  "layers": [
    {
      "type": "file",
      "url": "https://your-cdn.example.com/main-design.png",
      "position": {
        "area_width": 1800,
        "area_height": 2400,
        "width": 1500,
        "height": 1500,
        "top": 300,
        "left": 150
      }
    },
    {
      "type": "text",
      "content": "Hello",
      "font": "Anton",
      "color": "#FF0000",
      "size": 72
    }
  ],
  "options": [
    { "id": "lifelike",                   "value": true },
    { "id": "thread_colors",              "value": ["#FF0000","#00FF00"] }
  ]
}
```

- **`placement`** — values vary per product. Common: `front`, `back`, `sleeve_left`, `sleeve_right`, `inside_label`, `embroidery_chest_left`, `embroidery_back`, `mug_wraparound`, `default` (single-placement products). The catalog endpoint lists allowed placements.
- **`technique`** — print/embroidery method. Must match an allowed technique on this product/placement (see catalog availability).
- **`layers[]`** — types: `file` (raster/vector file by URL or `file_id`), `text` (live text rendering), `embroidery_layer` (embroidery-specific). Multiple layers stack bottom-to-top.
- **`position`** — coordinates in printfile pixel space. `area_*` are the placement canvas dimensions; the layer's `width/height/top/left` are within that canvas. Omit `position` to use Printful's auto-centered default fit.
- **`options[]`** — placement-level switches. Examples: `lifelike` (canvas matte vs gloss), `thread_colors` (embroidery palette override, hex list), `stitch_color` (custom border stitch), `inside_label_type` (which inside label variant), `notes_for_designer`. See the per-product catalog data for which options apply.

### `file` layer — by URL vs by ID

By URL is the common case. Printful downloads, processes, and stores the file in the merchant's File Library:

```json
{ "type": "file", "url": "https://cdn.example.com/design.png" }
```

By File ID (if you uploaded via `POST /v2/files` earlier and want explicit control or dedup):

```json
{ "type": "file", "file_id": 12345 }
```

If a file with the same `url` was already uploaded, Printful reuses the existing `file_id` — no re-upload, no extra processing. See [`09-files-v2.md`](09-files-v2.md).

### Embroidery layers

For embroidery techniques, the **default** is **auto thread color detection** — Printful analyzes the file and picks thread colors. If you want explicit control, send `options[].id = "thread_colors"` with a hex array, or use `embroidery_layer` typed layers.

## Updating an item

```http
PATCH /v2/orders/{order_id}/order-items/{order_item_id} HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "quantity": 3
}
```

Send only the changed fields. Allowed changes on a draft: `quantity`, `placements`, `external_id`, `notes`. Disallowed once `confirmed`: anything except `notes`.

## Updating an order

```http
PATCH /v2/orders/{order_id} HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "recipient": { "address1": "Corrected 123 Main St", … },
  "shipping": "PRINTFUL_FAST"
}
```

Allowed in `draft`. Allowed in `failed` (so you can fix the address and reconfirm). Restricted in `pending` (some fields only). Locked in `inprocess` / `fulfilled` / `canceled`.

## Confirming an order

```http
POST /v2/orders/{order_id}/confirmation HTTP/1.1
Authorization: Bearer {token}
```

No body required. Transitions `draft → pending`. From here Printful charges your Printful balance / billing method and starts fulfillment.

A failed charge transitions to `failed` (not `canceled`). Fix the underlying issue (add funds, fix card, fix items) and re-confirm. Confirmation on an already-`pending` or later order returns `409 Conflict`.

## Cost estimation (without creating an order)

Use this to quote shipping + product + tax in a single call before committing.

### v2 — async task

```http
POST /v2/order-estimation-tasks HTTP/1.1

{
  "recipient": { "country_code": "US", "state_code": "CA", "zip": "91311" },
  "shipping":  "STANDARD",
  "currency":  "USD",
  "order_items": [
    { "source": "catalog", "catalog_variant_id": 4011, "quantity": 1, "placements": [ … ] }
  ]
}
```

Returns `202 Accepted`:

```json
{ "data": { "id": "task_abc123", "status": "pending" } }
```

Poll:

```http
GET /v2/order-estimation-tasks?id=task_abc123
```

Response when complete (`status: "completed"`):

```json
{
  "data": {
    "id": "task_abc123",
    "status": "completed",
    "result": {
      "costs": { "currency": "USD", "subtotal": "12.50", "shipping": "4.95", "tax": "0.00", "vat": "0.00", "total": "17.45" }
    }
  }
}
```

Statuses: `pending`, `completed`, `failed`. Polling interval: 2–5 seconds is typical; the calc usually finishes in <5s.

### v1 — synchronous

v1's equivalent is **synchronous**: `POST /orders/estimate-costs` returns the cost block directly. Convenient for low-volume flows; v2's async version scales better.

## Listing orders

```bash
curl "https://api.printful.com/v2/orders?status=pending&limit=50" \
  -H "Authorization: Bearer $PF_TOKEN"
```

Common filters:

- `status` — `draft`, `pending`, `failed`, `inprocess`, `partial`, `fulfilled`, `canceled`, `archived`.
- `external_id` — exact match.
- `created_from` / `created_to` — ISO 8601 UTC range.

Use the `_links.next.href` to paginate.

## Shipments

```http
GET /v2/orders/{order_id}/shipments HTTP/1.1
```

Each shipment carries tracking data:

```json
{
  "data": [
    {
      "id": 1234567,
      "order_id": 12345678,
      "carrier": "FedEx",
      "service": "SmartPost",
      "tracking_number": "1Z…",
      "tracking_url": "https://www.fedex.com/…",
      "ship_date": "2026-05-17T08:00:00Z",
      "estimated_delivery_dates": { "min_date": "2026-05-20", "max_date": "2026-05-22" },
      "departure_country_code": "US",
      "items": [
        { "order_item_id": 9999, "quantity": 1 }
      ],
      "tracking_events": [
        { "occurred_at": "2026-05-17T08:00:00Z", "status": "label_created" },
        { "occurred_at": "2026-05-17T20:00:00Z", "status": "in_transit", "location": "Charlotte, NC" }
      ]
    }
  ]
}
```

`tracking_events` is the new-in-v2 detail; v1 returned a flat `tracking_number` + `tracking_url` only.

## Invoices

```http
GET /v2/orders/{order_id}/invoices HTTP/1.1
```

Returns the invoice PDF URL plus the structured cost breakdown. Use it as the source of truth for accounting (the `costs` block on the order can shift before fulfillment, the invoice is final).

## Items vs placements (mental model)

```
Order
├── Item #1  (one product variant + design)
│   ├── source: catalog | sync | external | warehouse
│   ├── catalog_variant_id / sync_variant_id / external_variant_id / warehouse_product_variant_id
│   ├── quantity
│   └── placements[]
│       ├── { placement: "front", technique: "dtg",
│       │     layers: [ { file }, { text } ],
│       │     options: [ … ] }
│       └── { placement: "back",  technique: "dtg",
│             layers: [ { file } ] }
└── Item #2
    └── …
```

One product can have multiple placements (front + back), and each placement can have multiple stacked layers.

## Common pitfalls

- **Sending `catalog_variant_id` for `source: "sync"`** — `400`. Use `sync_variant_id` for sync source.
- **Forgetting `placements`** on a `catalog`/`warehouse` item — `400 ValidationError`.
- **Using `product_id` where `variant_id` is expected** — `404 Not Found` (variant ID with that integer doesn't exist) or `400` (variant ID exists but isn't compatible with the requested placement).
- **Calling `confirmation` on a draft with no items** — `409 Conflict`: drafts must have ≥1 item before confirmation.
- **Editing an order in `inprocess` state** — `409`. Cancel and re-create if absolutely necessary.
- **Relying on the v1 `@external_id` form on v2** — v2 uses `?external_id=` query param instead.

## Original sources

- Endpoint metadata: **Orders v2** section in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Schemas — `Order`, `OrderSummary`, `Item`, `ItemReadonly`, `Address`, `Costs`, `RetailCosts`, `Gift`, `PackingSlip`, `Shipment`, `ShipmentItem`, `TrackingEvent`, `Placement`, `Layer`, `FileLayer`, `LayerPosition`, `LayerOptions` — see [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
- v1 order endpoint patterns: [`sources/PrintfulOrder.php`](sources/PrintfulOrder.php).
