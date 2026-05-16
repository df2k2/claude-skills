# 06 — Catalog (v2)

The catalog is **read-only**. It describes every blank product Printful can print/embroider on, every variant of every product, prices, sizes, regional availability, and mockup data.

> **The variant ID is what you order, not the product ID.** A "product" is a shirt model (e.g. Bella+Canvas 3001, ID `71`). A "variant" is one size/color of that model (e.g. White / M, ID `4011`). Order endpoints take `catalog_variant_id`, not `catalog_product_id`. Mixing them creates the wrong thing or returns a 400.

## Endpoint list

All endpoints are `GET`, base `https://api.printful.com/v2/`.

| Path | What |
|---|---|
| `catalog-products` | Paginated list of products. Heavy filtering. |
| `catalog-products/{id}` | A single product (metadata, available techniques, placements, options). |
| `catalog-products/{id}/catalog-variants` | The list of variants for one product. |
| `catalog-variants/{id}` | A single variant. |
| `catalog-products/{id}/catalog-categories` | Categories the product belongs to. |
| `catalog-categories` | All categories (filterable list). |
| `catalog-categories/{id}` | One category. |
| `catalog-products/{id}/sizes` | Full size guide (Measure-yourself + Product-measure tables). |
| `catalog-products/{id}/prices` | Prices for every variant in every selling region. |
| `catalog-variants/{id}/prices` | Prices for one variant. |
| `catalog-products/{id}/images` | Blank product images (the "naked" mockup styles before adding design data). |
| `catalog-variants/{id}/images` | Blank images of one variant. |
| `catalog-products/{id}/shipping-countries` | Countries Printful ships this product to. |
| `catalog-products/{id}/mockup-styles` | Available mockup style IDs (Men's Front, Women's Lifestyle Back, etc.). |
| `catalog-products/{id}/mockup-templates` | Detailed mockup templates: template image + placement coordinates per variant. |
| `catalog-products/{id}/availability` | Stock availability per selling region (read first before ordering). |
| `catalog-variants/{id}/availability` | Same, for one variant. |

## `GET /v2/catalog-products` — list products

Query parameters (most-used):

| Param | Type | Notes |
|---|---|---|
| `offset` | int | Default 0. |
| `limit` | int | Default 20, max 100. |
| `categories_ids` | csv ints | Filter to products in these categories (`GET /v2/catalog-categories` to find IDs). |
| `techniques` | csv strings | One or more of `dtg`, `dtf`, `dtfilm`, `embroidery`, `cut-sew`, `sublimation`, `print` (engraving), etc. See `TechniqueEnum` in the schema dump. |
| `placements` | csv strings | Filter to products with these placements (e.g. `front,back,sleeve_left`). |
| `colors` | csv strings | Available colors. Names per Printful's catalog (`white`, `black`, `red`, etc.). |
| `selling_region_name` | string | e.g. `north_america`, `europe`. Filters availability by region. |
| `search` | string | Free-text title search. |
| `sort` | string | `id`, `-id`, `created`, `-created`, etc. |

Response (`data` array of `CatalogItemSummary`):

```json
{
  "data": [
    {
      "id": 71,
      "main_category_id": 24,
      "type": "T-SHIRT",
      "name": "Unisex Staple T-Shirt | Bella + Canvas 3001",
      "brand": "Bella + Canvas",
      "model": "3001",
      "image": "https://files.cdn.printful.com/.../71_1670253910.jpg",
      "variant_count": 130,
      "currency": "USD",
      "is_discontinued": false,
      "description": "...",
      "sizes": ["XS","S","M","L","XL","2XL","3XL","4XL","5XL"],
      "colors": [ { "name": "White", "value": "#ffffff" }, … ],
      "techniques": ["dtg","dtf"],
      "placements": [ … ],
      "options": [ … ],
      "_links": { … }
    }
  ],
  "paging": { "offset": 0, "limit": 20, "total": 412 },
  "_links": { "self": …, "next": … }
}
```

The `placements` array tells you what locations on the product can be printed/embroidered (front, back, sleeve, label, etc.) plus per-placement metadata. `options` lists product-level options (e.g. stitch color for embroidery, lifelike option for canvas prints).

## `GET /v2/catalog-products/{id}` — one product

Returns a `CatalogItem`. Same shape as the list summary but with full descriptions, full options, full placement metadata, and the full size list. Use this once per product to cache locally.

## `GET /v2/catalog-products/{id}/catalog-variants` — list variants

Returns the variant matrix for a product:

```json
{
  "data": [
    {
      "id": 4011,
      "catalog_product_id": 71,
      "name": "Bella + Canvas 3001 Unisex Staple T-Shirt - White / M",
      "size": "M",
      "color": "White",
      "color_code": "#ffffff",
      "color_code2": null,
      "image": "https://files.cdn.printful.com/.../4011_1670253914.jpg",
      "price": "9.85",
      "currency": "USD",
      "in_stock": true,
      "availability_regions": { "north_america": "in_stock", "europe": "in_stock" }
    },
    ...
  ]
}
```

This is the endpoint you call to **find the variant ID for a (color, size) tuple**.

## `GET /v2/catalog-variants/{id}` — one variant

Returns `Variant` schema. Identical to the matrix row, no extra fields.

## `GET /v2/catalog-products/{id}/sizes` — size guide

Returns a `ProductSizeGuide` with one or two `SizeTable` entries:

- `type: "measure_yourself"` — how to measure the body.
- `type: "product_measure"` — measurements of the garment laid flat.

```json
{
  "data": {
    "product_id": 71,
    "available_sizes": ["S","M","L","XL","2XL"],
    "size_tables": [
      {
        "type": "measure_yourself",
        "unit": "inches",
        "description": "<p>…</p>",
        "image_url": "https://files.cdn.printful.com/.../sizeguide.png",
        "image_description": "<h6>A Length</h6>...",
        "measurements": [
          {
            "type_label": "Length",
            "values": [
              { "size": "S", "value": "25.2" },
              { "size": "M", "value": "26.0" },
              …
            ]
          },
          {
            "type_label": "Chest",
            "values": [
              { "size": "S", "min_value": "34", "max_value": "37" },
              …
            ]
          }
        ]
      }
    ]
  }
}
```

Query parameter `unit=cm` switches to centimeters; default is inches.

## `GET /v2/catalog-products/{id}/prices` — product prices

Pricing model:

- **Base price** per variant.
- **Placement price** added per print placement (e.g. back print adds $5.95 on top of the base front-print T-shirt price).
- **Technique price** — same placement can have different prices for DTG vs embroidery vs DTF.
- **Selling region** — prices differ by region (US vs EU vs ROW).

The response groups all of these:

```json
{
  "data": {
    "product_id": 71,
    "currency": "USD",
    "variants": [
      {
        "id": 4011,
        "techniques": [
          {
            "technique": "dtg",
            "placements": [
              { "placement": "front", "price": "9.85" },
              { "placement": "back",  "price": "5.95" }
            ],
            "additional_price": "0.00"
          }
        ]
      }
    ]
  }
}
```

Pricing also exposes selling-region variants on certain products. For the canonical schema see `ProductPrices`, `VariantPrices`, `VariantTechniquePrice`, `FileOptionPrices`, and `LayerOptionPrices` in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).

## `GET /v2/catalog-variants/{id}/prices` — one variant

Same shape, scoped to one variant. Faster than fetching the whole product.

## `GET /v2/catalog-products/{id}/images` and `/v2/catalog-variants/{id}/images`

Returns the **blank** product/variant images (no design applied). Use these for catalog browse UIs.

Each variant exposes images keyed by mockup style + view name. Example:

```json
{
  "data": {
    "variant_id": 4011,
    "images": [
      { "style_id": 1115, "style_name": "Men's", "view_name": "Front", "image_url": "https://..." },
      { "style_id": 1103, "style_name": "Men's", "view_name": "Left sleeve", "image_url": "https://..." }
    ]
  }
}
```

## `GET /v2/catalog-products/{id}/mockup-styles`

Returns the mockup styles a product supports. Each style has an `id`, a `style_name` (e.g. `Men's`, `Women's`, `Women's Lifestyle`), and a `view_name` (e.g. `Front`, `Back`, `Left sleeve`, `Flat`). You pass `mockup_style_ids` to the mockup generator to control which renders you get.

```json
{
  "data": {
    "product_id": 71,
    "mockup_styles": [
      { "style_id": 1115, "style_name": "Men's",            "view_name": "Front" },
      { "style_id": 1117, "style_name": "Women's",          "view_name": "Front" },
      { "style_id": 768,  "style_name": "Women's Lifestyle","view_name": "Front" },
      …
    ]
  }
}
```

## `GET /v2/catalog-products/{id}/mockup-templates`

Returns the **low-level template data** Printful uses to render mockups: template image URLs, placement coordinates (in pixels), conflicting placements (e.g. "you can't have a front print AND a label print on the same shirt"), and the variant-to-template mapping.

Use this when building a custom design preview UI; **don't** use it to render the final mockup — submit to the mockup generator instead.

## `GET /v2/catalog-products/{id}/shipping-countries`

Returns the list of ISO-3166 alpha-2 country codes that Printful will ship this product to. Use this **before** quoting shipping rates — it's faster and cheaper than calling shipping rates with an unsupported country.

```json
{
  "data": [
    { "code": "US", "name": "United States" },
    { "code": "CA", "name": "Canada" },
    …
  ]
}
```

## `GET /v2/catalog-products/{id}/availability` and `/v2/catalog-variants/{id}/availability`

Reports stock availability per **selling region** (`north_america`, `europe`, `asia_pacific`, etc.):

```json
{
  "data": {
    "product_id": 71,
    "variants": [
      {
        "variant_id": 4011,
        "techniques": [
          { "technique": "dtg",        "selling_regions": [
              { "name": "north_america", "availability": "in_stock"  },
              { "name": "europe",        "availability": "low_stock" }
          ]},
          { "technique": "embroidery", "selling_regions": [
              { "name": "north_america", "availability": "out_of_stock" }
          ]}
        ]
      }
    ]
  }
}
```

`availability` values: `in_stock`, `low_stock`, `out_of_stock`, `discontinued`, `temporary_out_of_stock`. **Subscribe to the `catalog_stock_updated` webhook** to get push notifications (every 5 minutes on v2; was every 24h on v1).

## `GET /v2/catalog-categories` and `/v2/catalog-categories/{id}`

Categories form a tree (e.g. `Apparel` → `Men's` → `Men's T-shirts`). Use them to filter `GET /v2/catalog-products?categories_ids=…`. The list endpoint returns every category in one call (the tree is small enough — ~100 entries).

## Caching strategy

The catalog changes slowly. Caching for **24h** is safe for product metadata, variants, sizes, mockup styles, and templates. Availability changes more often — cache for **5–15 minutes** and subscribe to `catalog_stock_updated`. Prices change with selling-region rules; cache for ≤24h and refresh on `catalog_price_changed` (v2-only webhook event).

## Code example — find the variant ID for "Bella+Canvas 3001 / White / M"

```javascript
const PF = "https://api.printful.com";
const token = process.env.PF_TOKEN;

const resp = await fetch(`${PF}/v2/catalog-products/71/catalog-variants?limit=200`, {
  headers: { Authorization: `Bearer ${token}` }
});
const { data } = await resp.json();
const v = data.find(x => x.color === "White" && x.size === "M");
console.log(v.id); // → 4011
```

## Original sources

- All endpoint metadata: **Catalog v2** section of [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Schemas — `CatalogItem`, `CatalogItemSummary`, `Variant`, `ProductPrices`, `VariantPrices`, `ProductSizeGuide`, `SizeTable`, `Measurement`, `MockupStyles`, `MockupTemplates`, `VariantStockAvailability`, `TechniqueStockAvailability`, `SellingRegionStockAvailability` — see [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
