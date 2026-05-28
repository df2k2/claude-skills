# Print Files: Formats, URL Requirements, and Per-Area Uploads

Every printable Gelato order item has a `files[]` array. Each entry is a URL to a print-ready file plus an optional `type` indicating *which* print area it covers. This reference covers file formats, URL requirements, the per-area `type` enum, image-placeholder behavior on templates, and how to prepare files for best print quality.

## The `File` object

```typescript
interface File {
  url: string;
  type?: 'default' | 'back' | 'neck-inner' | 'neck-outer' | 'sleeve-left' | 'sleeve-right' | 'inside';
}
```

That's the full shape. Used in:

- `POST /v4/orders` → `items[].files[]`
- `POST /v4/orders:quote` → `products[].files[]` (for quotes that depend on file-derived pricing)
- `PATCH /v4/orders/{id}` → `items[].files[]`

## The `type` enum (which print area)

The `type` tells Gelato *where* on the product the file should print. Defaults vary by product but commonly the most prominent area (e.g., the front for apparel).

| `type` | Used for |
| --- | --- |
| `default` | The main / front print area. Default if no `type` specified. |
| `back` | Back of garment, back of card. |
| `neck-inner` | Inside neck label (apparel). |
| `neck-outer` | Outside neck label (apparel). |
| `sleeve-left` | Left sleeve. |
| `sleeve-right` | Right sleeve. |
| `inside` | Inside of a folded card / book. |

For a single-sided product (poster, sticker), one file with `type: "default"` (or no type) is sufficient.

For a multi-sided apparel item with front + back + sleeve prints, ship four files:

```json
{
  "files": [
    { "type": "default",     "url": "https://cdn.example.com/front.pdf" },
    { "type": "back",        "url": "https://cdn.example.com/back.pdf" },
    { "type": "sleeve-left", "url": "https://cdn.example.com/sleeve-l.pdf" },
    { "type": "sleeve-right","url": "https://cdn.example.com/sleeve-r.pdf" }
  ]
}
```

The product's `productUid` tells Gelato which areas are printable — sending a `sleeve-left` file for a product without sleeve printing is silently ignored (or rejected, depending on the variant).

## Supported file formats

| Format | Notes |
| --- | --- |
| **PDF** | Recommended for print. Best: PDF/X-1a:2003 or PDF/X-4. Embedded fonts, flattened transparency. |
| **PNG** | Acceptable; loses color-management. Use for raster-only artwork; 300 DPI at the print area's intended size. |
| **JPEG** | Acceptable; lossy. Same DPI advice as PNG. Don't re-encode multiple times. |
| **TIFF** | Acceptable; lossless. Larger files than JPEG / PNG. |
| **SVG** | Acceptable for vector-only artwork. Make sure embedded fonts are converted to paths (or available in standard webfont stacks). |

### Why PDF/X for print

PDF/X-1a:2003 and PDF/X-4 are standardized subsets of PDF that:

- Embed all fonts (so the printer doesn't substitute).
- Embed or specify the output color profile (so colors are predictable).
- Flatten transparency (for PDF/X-1a) or preserve it correctly (for PDF/X-4).
- Forbid features that break print (JavaScript, audio, video).

Generators that produce PDF/X correctly: Adobe Acrobat (Save As Other → PDF/X), Affinity Publisher, LaTeX with the right preamble, Ghostscript with `-dPDFX=true`, Apache PDFBox, ReportLab + PostScript profiles.

### When PNG / JPEG is fine

For simple raster artwork (a Photoshop-rendered design at the exact print-area size), PNG at 300 DPI is fine. Color shifts vs. PDF/X are usually minor but more pronounced on apparel (cotton absorbs ink differently than paper).

## File URL requirements

Gelato downloads each `file.url` server-side during order processing. The URL must:

1. **Be HTTPS.** (HTTP may work but is discouraged; future-proof with HTTPS.)
2. **Be publicly fetchable** from Gelato's data centers. No auth wall, no IP allowlist that excludes Gelato.
3. **Resolve to the file directly.** No redirect to a login page; no HTML viewer; the response body must be the bytes of the file.
4. **Be available for at least 24 hours** after order creation. Gelato may fetch immediately or delay by a few hours during peak load.
5. **Set the right `Content-Type`** (e.g., `application/pdf`). Wrong content type can confuse the file processor.
6. **Not be enormous.** Practical ceiling around 250 MB per file; if you're approaching that, look at compression / splitting (multi-page products take one file per page in some flows).

### Common URL sources and their gotchas

| Source | OK? | Notes |
| --- | --- | --- |
| Public S3 bucket | yes | Make sure ACL is public-read. |
| Presigned S3 URL | yes | **Set the expiry to ≥ 24 hours.** Default 1 hour will likely expire before Gelato fetches. |
| Cloudflare R2 / GCS | yes | Same advice — public or long-lived signed URL. |
| Your own CDN | yes | Make sure your CDN doesn't cache 404s and serve them to Gelato. |
| GitHub raw content | yes for small files | Subject to GitHub's rate limits; don't use for production. |
| Dropbox/Google Drive share link | usually no | These typically return HTML viewer, not file bytes. Need to convert to direct link. |
| Localhost / private IP | NO | Gelato can't reach it. |
| URL behind your app's auth | NO | No way to give Gelato a session. |

## Image placeholders (template-based products)

When you `POST /v1/stores/{storeId}/products` to create a product from a template, the file payload uses `imagePlaceholders` instead of raw `files`:

```json
{
  "imagePlaceholders": [
    {
      "name":      "front",
      "fileUrl":   "https://cdn.example.com/artwork-front.png",
      "fitMethod": "slice"
    }
  ]
}
```

The `name` matches a template-defined placeholder name (e.g., "front", "back"). The `fitMethod`:

| `fitMethod` | Behavior |
| --- | --- |
| `slice` | Crop the image to fill the print area, preserving aspect ratio. Parts of the image outside the area are cut off. |
| `meet` | Fit the entire image inside the print area, preserving aspect ratio. Empty space (letterbox) is left around it. |

`slice` is the right choice for full-bleed artwork that you've already sized correctly. `meet` is right for centered logos / artwork that should appear in full.

The placeholder defines the print area's `width` and `height` in mm. Your artwork should be at least 300 DPI at those dimensions:

- For a placeholder 200 × 280 mm: `200/25.4 * 300 ≈ 2362` × `280/25.4 * 300 ≈ 3307` pixels minimum.

## Cover dimensions for multi-page products

For photo books, the cover is a single wrap-around file: back | spine | front. Get the exact dimensions:

```http
GET /v3/products/{productUid}/cover-dimensions?pageCount=116
```

Compose your cover PDF at `(backWidth + spineWidth + frontWidth) × max(heights)` plus bleed margins. Spine width grows with page count.

See `references/catalog-and-products.md` for the cover-dimensions response shape.

## Bleed, safe area, and edge margins

Print products have three zones:

```
┌─ Bleed       ─ extends past trim; gets cut off
│ ┌─ Trim     ─ where the cut actually happens
│ │ ┌─ Safe   ─ stay inside this for text / important content
│ │ │
│ │ │ <— Content area
│ │ │
│ │ └─ Safe
│ └─ Trim
└─ Bleed
```

Standard recommendations (vary by product):

- **Bleed**: ≥ 3 mm past trim. Solid backgrounds must extend to bleed.
- **Edge margin**: 3–5 mm inside trim. Cut tolerance.
- **Safe margin**: 5–10 mm inside trim. Text and logos should be inside this.

The Cover Dimensions endpoint exposes the exact `contentBleed`, `contentEdgeMargin`, `contentSafeMargin` for each multi-page product.

For non-multi-page products, consult the dashboard's per-product spec sheet or design template.

## Color profiles

- **CMYK** is the print-native color space.
- Most modern apparel printing uses **DTG (direct-to-garment)** which is also CMYK + white.
- Submitting **RGB** is fine — Gelato converts. But the conversion is heuristic, and saturated RGB blues / greens often shift in print.
- For best fidelity, work in CMYK from the start; preview with a sRGB-to-CMYK soft proof.
- Embedded ICC profiles in PDF/X are honored. For raster PNG/JPEG, the assumption is sRGB unless metadata says otherwise.

## DPI / resolution

- Target **300 DPI** at print-area size.
- Below 150 DPI, expect visible pixelation.
- Above 300 DPI is fine but no perceptual benefit; bigger files just slow processing.

## Page count for multi-page products

For products like photo books and notebooks, the `pageCount` field on the order item is mandatory and **counts every page**, including:

- Front outer cover (1)
- Front inner cover (1)
- Inner pages (each side of each leaf — 112 inner pages = 56 leaves)
- Back inner cover (1)
- Back outer cover (1)

So a "56-leaf wire-o notebook" is `pageCount: 116`.

The product's `validPageCounts` (from `GET /v3/products/{productUid}`) tells you which page counts are allowed.

## Processed files in the response

After Gelato processes your uploaded file, the response item includes a `processedFileUrl`:

```json
{
  "id": "g-item-1",
  "itemReferenceId": "line-1",
  "productUid": "...",
  "files": [{ "url": "https://your-cdn.example.com/print.pdf", "type": "default" }],
  "processedFileUrl": "https://gelato-cdn.example.com/processed/abc123.pdf",
  "previews": [
    { "type": "preview_default", "url": "https://gelato-cdn.example.com/preview.png" },
    { "type": "preview_thumbnail", "url": "https://gelato-cdn.example.com/thumb.png" }
  ]
}
```

The `processedFileUrl` is the imposed / press-ready file that actually goes to print. The `previews` array provides PNG previews — useful for confirming the artwork looks right before production.

## Common file failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| Order fails with "file URL unreachable" | URL behind auth / expired / private network | Make publicly fetchable; presigned URLs ≥ 24h. |
| Order fails with "unsupported format" | Submitted DOCX, PSD, AI, or other non-supported format | Convert to PDF, PNG, JPEG, TIFF, or SVG. |
| Print is fuzzy / pixelated | Image resolution too low for print area | Use ≥ 300 DPI at print-area size. |
| Print colors look wrong | RGB → CMYK conversion drift | Use CMYK source; embed ICC profile. |
| Text near edge gets cut off | Text inside bleed / edge zone | Keep text inside safe margin. |
| Spine text on photo book misaligned | Used wrong page count or didn't position for spine width | Re-fetch cover-dimensions for the actual page count. |
| Apparel print appears washed out | Light artwork on light garment without underbase | Add white underbase layer or check garment color choice. |
| File processed but item still shows `processedFileUrl: null` after hours | Processing failed silently | Check order events in dashboard; contact support if stuck. |

## Recipe: prepare a 2-sided apparel design

```typescript
const items = [{
  itemReferenceId: 'shirt-1',
  productUid: 'apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_m_gco_white_gpr_4-4',
  quantity: 1,
  files: [
    {
      type: 'default',  // = front
      url: 'https://cdn.example.com/orders/123/front.pdf',  // PDF/X-4, CMYK, 300 DPI at 200×280mm
    },
    {
      type: 'back',
      url: 'https://cdn.example.com/orders/123/back.pdf',
    },
  ],
}];
```

If the product is *not* 2-sided (the `gpr_4-4` suffix is 4-color front + 4-color back, so it is), the back file is silently ignored.

## Original sources

- `references/sources/gelato-admin-node/src/services/orders/order.ts` — `File`, `FileType`, `OrderCreateItemObject` types.
- Official (gated): https://dashboard.gelato.com/docs/orders/order_details/ (mentions PDF/X recommendations).
- Per-product design templates and spec sheets are downloadable from each product's page in the dashboard catalog.
