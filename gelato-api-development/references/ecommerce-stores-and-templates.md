# Ecommerce Stores, Products, and Templates API (v1)

Base URL: `https://ecommerce.gelatoapis.com`

This API is for **connected stores** — Shopify / Etsy / WooCommerce / BigCommerce / Wix / Squarespace storefronts that have been linked to Gelato through the dashboard's Ecommerce Integrations page. Once a store is connected, you can use this API to:

- Browse products that have been pushed from Gelato into the store.
- Create new store products from Gelato templates.
- Get template definitions (variants, image placeholders).
- Read variant/sync status to know which storefront variants are connected to Gelato products.

If you're building a custom storefront and not using one of the supported platforms, you don't need this API — go straight to the Orders API.

## Endpoint inventory

| Verb | Path | Purpose |
| --- | --- | --- |
| `GET` | `/v1/stores/{storeId}/products` | List products on a connected store |
| `GET` | `/v1/stores/{storeId}/products/{productId}` | Get one product's details |
| `POST` | `/v1/stores/{storeId}/products` | Create a product on the store from a template |
| `GET` | `/v1/templates/{templateId}` | Get template details (variants, image placeholders) |

## Concept: stores, templates, products, variants

```
Template
├── Variant (one per SKU permutation)
│   ├── productUid    (which Gelato product backs this variant)
│   ├── variantOptions[]  (e.g., Size: "L", Color: "Black")
│   └── imagePlaceholders[]  (named print areas with width/height)
│       ├── name: "front"
│       ├── printArea: "front"
│       ├── width: 200, height: 280
│       └── ...
└── ...
```

A **template** is a Gelato-side product definition with multiple variants and labeled print areas. You upload customer artwork into the image placeholders to produce a finished printable variant.

When you `POST` a template-based product to a store, Gelato:

1. Generates a final printable file by composing the template + your artwork into each image placeholder.
2. Creates the product on the connected storefront (Shopify, etc.) with all variants.
3. Returns the new product's ID (both in Gelato and in the external store).

Then, when a buyer places an order on the storefront, the integration:

1. Creates a Gelato order automatically with the right `productUid` and processed files.
2. Pushes fulfillment + tracking updates back to the storefront order.

## Get template

```http
GET /v1/templates/{templateId}
X-API-KEY: <key>
```

Response:

```json
{
  "id": "template-uuid-here",
  "templateName": "Classic Crewneck T-Shirt",
  "title": "Classic Crewneck T-Shirt",
  "description": "100% cotton crewneck tee, unisex fit.",
  "previewUrl": "https://gelato-cdn.example.com/preview.png",
  "variants": [
    {
      "id": "variant-uuid-1",
      "title": "S / White",
      "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
      "variantOptions": [
        { "name": "Size",  "value": "S" },
        { "name": "Color", "value": "White" }
      ],
      "imagePlaceholders": [
        {
          "name": "front",
          "printArea": "front",
          "height": 280,
          "width":  200
        },
        {
          "name": "back",
          "printArea": "back",
          "height": 280,
          "width":  200
        }
      ]
    }
    // ... more variants for each size/color combination
  ],
  "createdAt": "2026-01-15T10:00:00Z",
  "updatedAt": "2026-05-01T12:30:00Z"
}
```

### Image placeholder semantics

The `printArea` enum:

- `front` — front of garment.
- `back` — back of garment.
- `neck-inner` — inside neck label.
- `neck-outer` — outside neck label.
- `sleeve-left` — left sleeve.
- `sleeve-right` — right sleeve.

The `width` and `height` are in **millimeters**. Your uploaded artwork should match the aspect ratio (Gelato fits it per the `fitMethod`). Lower-resolution artwork will be upscaled; for print quality, target ≥ 300 DPI at the print area size.

## List products on a store

```http
GET /v1/stores/{storeId}/products?order=desc&orderBy=createdAt&offset=0&limit=100
X-API-KEY: <key>
```

Query params:

| Param | Type | Default | Notes |
| --- | --- | --- | --- |
| `order` | `"desc"` \| `"asc"` | `"desc"` | Sort direction. |
| `orderBy` | `"createdAt"` \| `"updatedAt"` | `"createdAt"` | Sort field. |
| `offset` | int | 0 | Pagination offset. |
| `limit` | int | 100 | Max 100. |

Response:

```json
{
  "products": [
    {
      "id":              "gelato-store-product-id-1",
      "storeId":         "store-uuid",
      "externalId":      "shopify-product-1234567",
      "title":           "Classic Crewneck T-Shirt",
      "description":     "100% cotton crewneck tee.",
      "previewUrl":      "https://...",
      "externalPreviewUrl":   "https://store.example.com/cdn/preview.jpg",
      "externalThumbnailUrl": "https://store.example.com/cdn/thumb.jpg",
      "publishingErrorCode": "",
      "status":          "active",
      "publishedAt":     "2026-05-01T12:00:00Z",
      "createdAt":       "2026-04-28T10:00:00Z",
      "updatedAt":       "2026-05-01T12:00:00Z",
      "variants": [
        {
          "id":               "gelato-variant-id-1",
          "productId":        "gelato-store-product-id-1",
          "title":            "S / White",
          "externalId":       "shopify-variant-987654321",
          "connectionStatus": "connected"
        }
      ],
      "productVariantOptions": [
        { "name": "Size",  "values": ["S", "M", "L"] },
        { "name": "Color", "values": ["White", "Black"] }
      ]
    }
  ]
}
```

### Status values

| `status` | Meaning |
| --- | --- |
| `created` | Created in Gelato but not yet pushed to the store. |
| `publishing` | Push to store in progress. |
| `publishing_error` | Push failed; see `publishingErrorCode`. |
| `active` | Live on the storefront, available for purchase. |

### Variant `connectionStatus` values

| `connectionStatus` | Meaning |
| --- | --- |
| `connected` | Variant on the storefront is linked to a Gelato product UID; orders flow automatically. |
| `not_connected` | Variant exists on the storefront but isn't linked to Gelato — orders for it won't go to Gelato. |
| `ignored` | Variant intentionally excluded from Gelato fulfillment. |

## Get one store product

```http
GET /v1/stores/{storeId}/products/{productId}
X-API-KEY: <key>
```

Returns the same shape as a single element of the list response.

## Create a product on the store from a template

```http
POST /v1/stores/{storeId}/products
Content-Type: application/json
X-API-KEY: <key>
```

Body:

```json
{
  "storeId":    "store-uuid",
  "templateId": "template-uuid",
  "title":       "My Custom Crewneck",
  "description": "Limited-edition print on a classic crewneck tee.",
  "isVisibleInTheOnlineStore": true,
  "salesChannels": ["web", "global"],
  "variants": [
    {
      "templateVariantId": "variant-uuid-1",
      "position": 0,
      "imagePlaceholders": [
        {
          "name":      "front",
          "fileUrl":   "https://your-cdn.example.com/artwork-front.png",
          "fitMethod": "slice"
        },
        {
          "name":      "back",
          "fileUrl":   "https://your-cdn.example.com/artwork-back.png",
          "fitMethod": "meet"
        }
      ]
    }
    // ... if you omit a variant, the template's default for that variant is used
  ],
  "tags": ["summer-2026", "limited-edition"]
}
```

### Field details

| Field | Required | Notes |
| --- | --- | --- |
| `storeId` | YES | The connected store's ID. |
| `templateId` | YES | The template to use as the base. |
| `title` | YES | Storefront-facing product title. |
| `description` | YES | Storefront-facing description. |
| `isVisibleInTheOnlineStore` | no (default false) | If false, product is created but hidden on the storefront. |
| `salesChannels` | no | `web` (default) or `global`. `global` publishes to the Point of Sale channel — Shopify only. |
| `variants` | no | If omitted, all template variants are created with template defaults. If partial, the rest use template defaults. |
| `variants[].templateVariantId` | YES | The variant ID from the template. |
| `variants[].position` | no (default 0) | Display order on the storefront. |
| `variants[].imagePlaceholders` | no | List of placeholders to update. Missing placeholders use the template's default. |
| `variants[].imagePlaceholders[].name` | YES | Must match a placeholder name from the template (e.g., "front"). |
| `variants[].imagePlaceholders[].fileUrl` | YES | URL to the artwork. Formats: jpg, jpeg, png, pdf. |
| `variants[].imagePlaceholders[].fitMethod` | no (default `"slice"`) | `"slice"` = crop to fill; `"meet"` = fit entirely, letterbox if needed. |
| `tags` | no | Up to 13 tags; ≤ 255 chars each (Etsy: ≤ 20). |

### Response

```json
{
  "id":          "gelato-store-product-id-2",
  "storeId":     "store-uuid",
  "externalId":  null,
  "title":       "My Custom Crewneck",
  "description": "...",
  "previewUrl":  "https://...",
  "status":      "publishing",
  "tags":        ["summer-2026", "limited-edition"],
  "publishedAt": null,
  "createdAt":   "2026-05-28T14:00:00Z",
  "updatedAt":   "2026-05-28T14:00:00Z"
}
```

`externalId` and `publishedAt` are null until the publish finishes. Poll `GET /v1/stores/{storeId}/products/{productId}` or listen for a webhook to know when the status becomes `active`.

## Recipe: "Push a custom-art shirt to my Shopify store"

```typescript
const apiKey = process.env.GELATO_API_KEY!;
const headers = { 'X-API-KEY': apiKey, 'Content-Type': 'application/json' };
const storeId = process.env.SHOPIFY_STORE_ID!;       // get from dashboard.gelato.com/ecommerce
const templateId = process.env.SHIRT_TEMPLATE_ID!;

// 1. Inspect the template to learn variants + placeholder names
const tmplRes = await fetch(`https://ecommerce.gelatoapis.com/v1/templates/${templateId}`, { headers });
const template = await tmplRes.json();
console.log('Variants:', template.variants.map(v => v.title));

// 2. Push a product using my artwork on each variant's front + back
const variants = template.variants.map(v => ({
  templateVariantId: v.id,
  imagePlaceholders: [
    { name: 'front', fileUrl: 'https://my-cdn.example.com/front.png', fitMethod: 'slice' },
    { name: 'back',  fileUrl: 'https://my-cdn.example.com/back.png',  fitMethod: 'slice' },
  ],
}));

const createRes = await fetch(`https://ecommerce.gelatoapis.com/v1/stores/${storeId}/products`, {
  method: 'POST', headers,
  body: JSON.stringify({
    storeId,
    templateId,
    title:       'Limited Edition Summer Tee',
    description: 'Available for 30 days only.',
    isVisibleInTheOnlineStore: true,
    variants,
    tags: ['summer-2026', 'limited'],
  }),
});
const product = await createRes.json();
console.log('Created (publishing...):', product.id, product.status);

// 3. Poll for active status
let p;
do {
  await new Promise(r => setTimeout(r, 5000));
  p = await (await fetch(
    `https://ecommerce.gelatoapis.com/v1/stores/${storeId}/products/${product.id}`,
    { headers }
  )).json();
  console.log('  status:', p.status);
} while (p.status === 'publishing');

if (p.status === 'active') {
  console.log(`Live on Shopify as ${p.externalId}: ${p.externalPreviewUrl}`);
} else {
  console.error('Publishing failed:', p.publishingErrorCode);
}
```

## How orders flow with a connected store

Once the product is `active`:

1. Buyer browses Shopify, adds variant to cart, checks out.
2. Shopify sends the new order to Gelato via the integration (no API call from you required).
3. Gelato creates an internal order with `channel: "shopify"` and `storeId` populated.
4. You receive the same `order_status_updated` webhooks as for direct-API orders.
5. Tracking updates from Gelato flow back to the Shopify order automatically.

For direct-API orders, `storeId` is null and `channel` is `"api"`.

## Limitations of the Ecommerce API

- **Cannot modify** an already-published product (you'd delete and re-create, or edit on the storefront).
- **Cannot delete** via this API (use the storefront).
- **Variant connection management** is done in the dashboard, not via API.
- **Etsy tag limit**: 20 chars per tag (other stores 255).

## Original sources

- `references/sources/gelato-admin-node/src/services/ecommerce/ecommerce-api.ts` — endpoint paths.
- `references/sources/gelato-admin-node/src/services/ecommerce/templates.ts` — Template + Variant + ImagePlaceholder types.
- `references/sources/gelato-admin-node/src/services/ecommerce/products.ts` — full Get/Create Product request/response shapes.
- Official (gated): https://dashboard.gelato.com/docs/ecommerce/templates/get/.
