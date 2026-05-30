# Decoding the `productUid`

`productUid` is the most important string in the Gelato API. It encodes every attribute of a product variant — type, size, color, paper stock, finish, page count, print sides — in a single underscore-separated key. It appears on every order item, every quote item, every template variant. Getting it wrong is the single most common cause of order failures. This reference covers the encoding scheme, the canonical way to discover valid UIDs (via the catalog), and the recipe for resolving "I want a black L unisex crewneck t-shirt with two-sided printing" into a real UID.

## The encoding scheme

A `productUid` is a stack of segments:

```
{catalog}_product_{family_prefix1}_{value1}_{family_prefix2}_{value2}_..._{family_prefixN}_{valueN}
```

Each `_xxx_value` segment maps to a `productAttributeUid` from the catalog. The 3-letter prefix is an attribute family.

### Example (apparel)

```
apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4
│         │       │   │       │   │        │   │      │   │       │   │  │   │     │   │
│         │       │   │       │   │        │   │      │   │       │   │  │   │     │   └─ value: 4-color front + 4-color back
│         │       │   │       │   │        │   │      │   │       │   │  │   │     └───── family: garment print (gpr)
│         │       │   │       │   │        │   │      │   │       │   │  │   └─────────── value: white
│         │       │   │       │   │        │   │      │   │       │   │  └─────────────── family: garment color (gco)
│         │       │   │       │   │        │   │      │   │       │   └────────────────── value: S (size small)
│         │       │   │       │   │        │   │      │   │       └────────────────────── family: garment size (gsi)
│         │       │   │       │   │        │   │      │   └────────────────────────────── value: classic quality
│         │       │   │       │   │        │   │      └────────────────────────────────── family: garment quality (gqa)
│         │       │   │       │   │        │   └───────────────────────────────────────── value: unisex cut
│         │       │   │       │   │        └───────────────────────────────────────────── family: garment cut (gcu)
│         │       │   │       │   └────────────────────────────────────────────────────── value: crewneck
│         │       │   │       └────────────────────────────────────────────────────────── family: garment style cut (gsc)
│         │       │   └────────────────────────────────────────────────────────────────── value: t-shirt
│         │       └────────────────────────────────────────────────────────────────────── family: garment category (gca)
│         └────────────────────────────────────────────────────────────────────────────── always "_product" for apparel
└──────────────────────────────────────────────────────────────────────────────────────── catalog: apparel
```

### Example (cards)

```
cards_pf_a5_pt_350-gsm-coated-silk_cl_4-4_ver
│      │  │  │  │                  │  │   │
│      │  │  │  │                  │  │   └─ orientation
│      │  │  │  │                  │  └───── color: 4-4 (4-color both sides)
│      │  │  │  │                  └──────── family: color (cl)
│      │  │  │  └─────────────────────────── value: 350gsm coated silk
│      │  │  └────────────────────────────── family: paper type (pt)
│      │  └───────────────────────────────── value: A5 size
│      └──────────────────────────────────── family: paper format (pf)
└─────────────────────────────────────────── catalog: cards
```

### Family prefix examples (not exhaustive — discover via catalog)

| Prefix | Family | Common in |
| --- | --- | --- |
| `gca` | Garment Category Attribute | apparel |
| `gsc` | Garment Style Cut | apparel |
| `gcu` | Garment Cut | apparel |
| `gqa` | Garment Quality | apparel |
| `gsi` | Garment Size | apparel |
| `gco` | Garment Color | apparel |
| `gpr` | Garment Print | apparel |
| `pf`  | Paper Format | cards, posters |
| `pt`  | Paper Type | cards, posters |
| `cl`  | Color (sided print) | cards, brochures |
| `bf`  | Book Format | photobooks |
| `bc`  | Book Cover | photobooks |
| `bp`  | Book Paper | photobooks |
| `bpc` | Book Page Count (varies) | photobooks |

Different catalogs use different prefixes. **Don't memorize these** — query the catalog for the exact prefixes and valid values.

## Don't construct, discover

Hand-constructing a `productUid` from intuition is the fastest path to a `422 Unprocessable Entity` on order create. The correct workflow:

1. **List catalogs**: `GET https://product.gelatoapis.com/v3/catalogs` → choose one.
2. **Get the catalog's attributes**: `GET https://product.gelatoapis.com/v3/catalogs/{catalogUid}` → returns `productAttributes[]`, each with `productAttributeUid`, title, and a list of allowed `values[]`.
3. **Search products in the catalog** by attribute: `POST https://product.gelatoapis.com/v3/catalogs/{catalogUid}/products:search` with `attributeFilters` set to the values you want.
4. **Read the `productUid`** from each returned product.

Code recipe:

```typescript
const res = await fetch(
  `https://product.gelatoapis.com/v3/catalogs/apparel_product/products:search`,
  {
    method: 'POST',
    headers: { 'X-API-KEY': key, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      attributeFilters: {
        GarmentCategory: 't-shirt',
        GarmentColor: 'white',
        GarmentSize: 's',
        GarmentCut: 'unisex',
      },
      limit: 50,
    }),
  }
);
const { products } = await res.json();
const productUid = products[0].productUid;
// → "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4"
```

You can also fetch the per-product details via `GET /v3/products/{productUid}` once you have a UID.

## Why the encoding is verbose

The flat string format means:

- Every variant has a canonical, deterministic ID.
- Two clients querying the same attributes get the same UID.
- The UID is URL-safe, log-friendly, and orderable as a string.
- Adding new attributes doesn't change existing UIDs.

The trade-off is that the UID gets long. A photobook with all options spelled out can run 100+ characters.

## Common cases of "I got the wrong UID"

| Symptom | Cause | Fix |
| --- | --- | --- |
| 422 "productUid not found" | Used a UID from a different catalog (e.g., a cards UID on apparel) | Re-query the right catalog. |
| 422 "productUid not found" | Typo in the constructed UID | Don't construct, list. |
| 422 "Combination not available" | Valid attributes individually but the combination isn't a real product (e.g., that size + color isn't stocked) | Use products:search with all the attributes; if no result, the combination doesn't exist. |
| 422 "Product retired" | UID was valid historically but no longer | Catalog rotates; refresh. |
| Order succeeds but wrong color/size shipped | Used the wrong UID; sometimes Gelato accepts close-but-not-exact UIDs | Validate every UID against the catalog before shipping. |

## Per-product details

`GET https://product.gelatoapis.com/v3/products/{productUid}` returns:

```json
{
  "productUid": "...",
  "attributes": { /* every attribute family → value */ },
  "weight": { "value": 250, "measureUnit": "g" },
  "dimensions": [
    { "value": 280, "measureUnit": "mm" },
    { "value": 200, "measureUnit": "mm" },
    { "value": 30,  "measureUnit": "mm" }
  ],
  "supportedCountries": ["US", "CA", "GB", "DE", "FR", "..."],
  "isStockable": true,
  "isPrintable": true,
  "validPageCounts": [24, 48, 96, 116]
}
```

`validPageCounts` is only relevant for multi-page products (photobooks, notebooks).

## Per-product prices

`GET https://product.gelatoapis.com/v3/products/{productUid}/prices` returns:

```json
{
  "data": [
    { "currency": "USD", "quantity": 1,   "priceBase": 14.50, "price": 14.50, "pageCount": null },
    { "currency": "USD", "quantity": 10,  "priceBase": 11.00, "price": 11.00, "pageCount": null },
    { "currency": "USD", "quantity": 100, "priceBase":  8.75, "price":  8.75, "pageCount": null },
    { "currency": "EUR", "quantity": 1,   "priceBase": 13.00, "price": 13.00, "pageCount": null }
  ]
}
```

Pricing is tiered by quantity — buying more drops the per-unit price. For multi-page products, prices vary by `pageCount` too.

## Per-product cover dimensions (photo books, brochures)

`GET https://product.gelatoapis.com/v3/products/{productUid}/cover-dimensions?pageCount=116` returns the printable cover layout (width, height, spine width):

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

Used to compose the cover PDF programmatically.

## Per-product stock availability

`POST https://product.gelatoapis.com/v3/stock/region-availability`

Body:

```json
{
  "products": [
    "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
    "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_m_gco_white_gpr_4-4"
  ]
}
```

Returns availability per region for each stockable product. Useful before placing bulk orders.

## Where this connects

- **Order create / quote**: every `items[].productUid` or `products[].productUid` is one of these strings.
- **Templates**: every `variants[].productUid` in a template is one of these strings.
- **Stock**: queryable for the subset of products with `isStockable: true`.

## Original sources

- `references/sources/gelato-admin-node/src/services/products/products-api.ts` — endpoint paths.
- `references/sources/gelato-admin-node/src/services/products/product.ts` — Product type.
- `references/sources/gelato-admin-node/src/services/products/catalog.ts` — Catalog + ProductAttribute types.
- `references/sources/gelato-admin-node/src/services/products/prices.ts` — pricing object shape.
- `references/sources/gelato-admin-node/src/services/products/cover-dimensions.ts` — cover dimensions shape.
- Official (gated): https://dashboard.gelato.com/docs/products/.
