# Product Catalog API (v3)

Base URL: `https://product.gelatoapis.com`

The Catalog API is the discovery surface — it tells you what Gelato can print, which attributes define each product family, how much each variant costs at each quantity, and whether stock-able items are available in your destination region. This reference covers every endpoint.

## Endpoint inventory

| Verb | Path | Purpose |
| --- | --- | --- |
| `GET` | `/v3/catalogs` | List all catalogs (paginated) |
| `GET` | `/v3/catalogs/{catalogUid}` | Get a catalog + its attribute schema |
| `POST` | `/v3/catalogs/{catalogUid}/products:search` | Search products in a catalog with attribute filters |
| `GET` | `/v3/products/{productUid}` | Get details for one product |
| `GET` | `/v3/products/{productUid}/prices` | Get the price tiers for a product |
| `GET` | `/v3/products/{productUid}/cover-dimensions?pageCount=N` | Get cover layout dimensions (photo books, brochures) |
| `POST` | `/v3/stock/region-availability` | Bulk-check stock availability in regions |

## 1. List catalogs

```http
GET /v3/catalogs
X-API-KEY: <key>
```

Response:

```json
{
  "data": [
    { "catalogUid": "apparel_product",        "title": "Apparel" },
    { "catalogUid": "cards",                  "title": "Cards" },
    { "catalogUid": "posters",                "title": "Posters" },
    { "catalogUid": "canvas",                 "title": "Canvas" },
    { "catalogUid": "photobooks-hard",        "title": "Hardcover Photo Books" },
    { "catalogUid": "photobooks-soft",        "title": "Softcover Photo Books" },
    { "catalogUid": "wall-calendars",         "title": "Wall Calendars" },
    { "catalogUid": "mugs",                   "title": "Mugs" },
    { "catalogUid": "phone-cases",            "title": "Phone Cases" },
    { "catalogUid": "tote-bags",              "title": "Tote Bags" }
  ],
  "pagination": { "total": 30, "offset": 0 }
}
```

(The exact list of catalogs and their titles is dynamic — query for the current set.)

## 2. Get a catalog and its attribute schema

```http
GET /v3/catalogs/{catalogUid}
X-API-KEY: <key>
```

Example:

```bash
curl -H "X-API-KEY: $KEY" https://product.gelatoapis.com/v3/catalogs/apparel_product
```

Response:

```json
{
  "catalogUid": "apparel_product",
  "title": "Apparel",
  "productAttributes": [
    {
      "productAttributeUid": "GarmentCategory",
      "title": "Garment Category",
      "values": [
        { "productAttributeValueUid": "t-shirt",        "title": "T-Shirt" },
        { "productAttributeValueUid": "sweatshirt",     "title": "Sweatshirt" },
        { "productAttributeValueUid": "hoodie",         "title": "Hoodie" }
      ]
    },
    {
      "productAttributeUid": "GarmentSize",
      "title": "Garment Size",
      "values": [
        { "productAttributeValueUid": "xs", "title": "XS" },
        { "productAttributeValueUid": "s",  "title": "S" },
        { "productAttributeValueUid": "m",  "title": "M" },
        { "productAttributeValueUid": "l",  "title": "L" },
        { "productAttributeValueUid": "xl", "title": "XL" }
      ]
    },
    {
      "productAttributeUid": "GarmentColor",
      "title": "Garment Color",
      "values": [
        { "productAttributeValueUid": "white", "title": "White" },
        { "productAttributeValueUid": "black", "title": "Black" }
      ]
    }
  ]
}
```

Use this to drive a UI: "Pick a category", "Pick a size", "Pick a color".

The `productAttributeUid` is what you pass to `:search` as keys in `attributeFilters`. The `productAttributeValueUid` is what you pass as values.

## 3. Search products in a catalog

```http
POST /v3/catalogs/{catalogUid}/products:search
Content-Type: application/json
X-API-KEY: <key>
```

Body:

```json
{
  "attributeFilters": {
    "GarmentCategory": "t-shirt",
    "GarmentColor": "white",
    "GarmentSize": "s"
  },
  "offset": 0,
  "limit": 100
}
```

`attributeFilters` values can be:

- A string: single value match.
- A number: numeric attribute match.
- A boolean: boolean attribute match.
- An array of strings/numbers: any of these values (OR match).

`limit` is capped at **500**.

Response:

```json
{
  "products": [
    {
      "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
      "attributes": {
        "GarmentCategory": "t-shirt",
        "GarmentSize": "s",
        "GarmentColor": "white",
        "GarmentCut": "unisex"
      },
      "weight": { "value": 250, "measureUnit": "g" },
      "dimensions": [
        { "value": 280, "measureUnit": "mm" },
        { "value": 200, "measureUnit": "mm" }
      ],
      "supportedCountries": ["US", "CA", "GB", "DE", "FR", "..."]
    }
  ],
  "hits": {
    "attributeHits": {
      "GarmentColor": {
        "white": 1,
        "black": 1
      },
      "GarmentSize": {
        "s": 1,
        "m": 1,
        "l": 1
      }
    }
  }
}
```

The `hits.attributeHits` is faceted-search data — how many products match for each value of each attribute, useful for showing counts next to filter options.

## 4. Get product details

```http
GET /v3/products/{productUid}
X-API-KEY: <key>
```

Response (richer than the search result):

```json
{
  "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
  "attributes": { /* full attribute map */ },
  "weight":     { "value": 250, "measureUnit": "g" },
  "dimensions": [ { "value": 280, "measureUnit": "mm" }, ... ],
  "supportedCountries": ["US", "CA", "..."],
  "isStockable": true,
  "isPrintable": true,
  "validPageCounts": [24, 48, 96, 116]
}
```

`isStockable` — sometimes-stocked SKU; check region availability before ordering bulk.
`isPrintable` — has printable surfaces (most products do; some swag like blank mugs don't).
`validPageCounts` — only meaningful for multi-page products (photobooks, notebooks, calendars).

## 5. Get product prices

```http
GET /v3/products/{productUid}/prices
X-API-KEY: <key>
```

Response:

```json
{
  "data": [
    { "currency": "USD", "quantity": 1,   "priceBase": 14.50, "price": 14.50, "pageCount": null },
    { "currency": "USD", "quantity": 10,  "priceBase": 11.00, "price": 11.00, "pageCount": null },
    { "currency": "USD", "quantity": 50,  "priceBase":  9.20, "price":  9.20, "pageCount": null },
    { "currency": "USD", "quantity": 100, "priceBase":  8.75, "price":  8.75, "pageCount": null },
    { "currency": "EUR", "quantity": 1,   "priceBase": 13.00, "price": 13.00, "pageCount": null },
    { "currency": "GBP", "quantity": 1,   "priceBase": 11.50, "price": 11.50, "pageCount": null }
  ]
}
```

- `priceBase` — list price; `price` — what you pay (after any account-level discounts).
- The schedule is quantity-tiered. Buying 100 at once is cheaper per unit than 10 separate orders of 10.
- For multi-page products, expect entries per (currency, quantity, pageCount) combination.

This pricing is **what Gelato charges you**. To compute what you charge your customer, layer on your own markup.

## 6. Get cover dimensions (multi-page products only)

```http
GET /v3/products/{productUid}/cover-dimensions?pageCount=116
X-API-KEY: <key>
```

Response:

```json
{
  "productUid": "...",
  "pageCount": 116,
  "measureUnit": "mm",
  "wraparoundInsideWidth":  10,
  "wraparoundInsideHeight": 10,
  "frontWidth":  210,
  "frontHeight": 297,
  "backWidth":   210,
  "backHeight":  297,
  "spineWidth":  12,
  "spineHeight": 297,
  "contentBleed":     3,
  "contentEdgeMargin": 5,
  "contentSafeMargin": 8
}
```

The spine width grows with page count. Use these dimensions to compose a single wraparound cover PDF (back | spine | front), correctly sized for the chosen page count.

## 7. Bulk stock availability

```http
POST /v3/stock/region-availability
Content-Type: application/json
X-API-KEY: <key>
```

Body:

```json
{
  "products": [
    "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
    "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_m_gco_white_gpr_4-4",
    "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_l_gco_white_gpr_4-4"
  ]
}
```

Response: stock status per product per region (Gelato has data centers in NA, EU, Asia, AU). Used to:

- Confirm a SKU is in stock before showing it on a storefront.
- Decide which fulfillment region to bias toward.
- Pre-warn customers about back-order delays.

Only products with `isStockable: true` have meaningful results.

## Recipe: "Find me a black L unisex hoodie that ships to Germany"

```typescript
const apiKey = process.env.GELATO_API_KEY!;
const headers = { 'X-API-KEY': apiKey, 'Content-Type': 'application/json' };

// 1. Find products matching the attributes
const searchRes = await fetch(
  'https://product.gelatoapis.com/v3/catalogs/apparel_product/products:search',
  {
    method: 'POST',
    headers,
    body: JSON.stringify({
      attributeFilters: {
        GarmentCategory: 'hoodie',
        GarmentSize:     'l',
        GarmentColor:    'black',
        GarmentCut:      'unisex',
      },
      limit: 50,
    }),
  }
);
const { products } = await searchRes.json();

// 2. Filter to products that ship to Germany
const deProducts = products.filter(p => p.supportedCountries.includes('DE'));
if (deProducts.length === 0) throw new Error('No matching product ships to DE');

// 3. Take the first match; fetch price
const productUid = deProducts[0].productUid;
const priceRes = await fetch(
  `https://product.gelatoapis.com/v3/products/${encodeURIComponent(productUid)}/prices`,
  { headers }
);
const { data: prices } = await priceRes.json();

// 4. Find EUR price at quantity 1
const eurPrice = prices.find(p => p.currency === 'EUR' && p.quantity === 1);
console.log(`Product UID: ${productUid}`);
console.log(`Price (EUR, qty 1): €${eurPrice.price}`);
```

## Catalog conventions worth knowing

- **Apparel** catalog `catalogUid` is `apparel_product` (note the `_product` suffix). Other apparel-adjacent catalogs may exist; check the list.
- **Stockable** products (apparel, mugs, phone cases) have inventory; **printable-on-demand** products (cards, posters, photobooks) are produced fresh each time.
- **Region support** is not the same as shipment availability — a product can be "supported" in a country but require a shipment method that isn't available for that exact address.
- **Catalog IDs are stable**; product UIDs within them can churn as Gelato adds/retires SKUs. Don't hardcode UIDs from a fresh search at deploy time without periodic refresh.

## Pagination

- `offset` (default 0), `limit` (default 100, max 500 for `:search`).
- Some endpoints return a `pagination` object with `total` and `offset`; iterate until you've consumed all items.

## Original sources

- `references/sources/gelato-admin-node/src/services/products/products-api.ts`
- `references/sources/gelato-admin-node/src/services/products/catalog.ts`
- `references/sources/gelato-admin-node/src/services/products/product.ts`
- `references/sources/gelato-admin-node/src/services/products/prices.ts`
- `references/sources/gelato-admin-node/src/services/products/stock-availability.ts`
- `references/sources/gelato-admin-node/src/services/products/cover-dimensions.ts`
- Official (gated): https://dashboard.gelato.com/docs/products/ and https://dashboard.gelato.com/docs/stock/.
