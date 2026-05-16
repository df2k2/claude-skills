# 09 — File Library (v2)

The File Library stores every print file uploaded to your Printful store. Files are referenced by `file_id` in orders and mockup tasks. **You usually don't need to call this API directly** — passing a file URL inline when creating an order/mockup uploads the file automatically. Use the explicit File API only when you want fine-grained control: tracking processing status, pre-warming files before an order, or hiding files from the dashboard's File Library UI.

> **Caution**: The v1 list endpoint `GET /files` is **gone** — it returns `HTTP 410 Gone`. There is no list endpoint in v2 either. You can only reach a file by its `file_id` once you know it.

## Endpoints

| Method | Path | What |
|---|---|---|
| `POST` | `/v2/files` | Add a file (async — returns `waiting` then transitions to `ok` / `failed`). |
| `GET`  | `/v2/files/{id}` | Retrieve a file by ID. Use to poll status. |

## Adding a file

```http
POST /v2/files HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "url":     "https://your-cdn.example.com/design.png",
  "type":    "default",
  "visible": true,
  "options": [
    { "id": "template_position", "value": "center" }
  ]
}
```

Required:

- `url` — publicly fetchable URL (HTTPS preferred). Printful's worker downloads from here. Authenticated/private URLs are not supported.

Optional:

- `type` — `default` (the print itself, the most common), `preview` (a low-res preview already rendered), `template` (for advanced workflows). Default is `default`.
- `visible` — `true` shows the file in the dashboard's File Library. `false` hides it (useful for transient per-order designs you don't want clogging the UI).
- `options[]` — file-level options (rare; most placement options live on the order item, not the file).

Response (`202 Accepted`):

```json
{
  "data": {
    "id": 987654,
    "url": "https://your-cdn.example.com/design.png",
    "type": "default",
    "hash": null,
    "filename": null,
    "mime_type": null,
    "size": null,
    "width": null,
    "height": null,
    "dpi": null,
    "status": "waiting",
    "created": "2026-05-16T18:00:00Z",
    "thumbnail_url": null,
    "preview_url": null,
    "visible": true
  }
}
```

`status: "waiting"` means Printful is downloading and processing. Fields like `width`, `height`, `dpi`, `hash`, `thumbnail_url` are populated **after** processing.

## File deduplication

If you POST a file with the same `url` that was already uploaded for this store, **Printful returns the existing file** (same `id`) without re-downloading. This is intentional — it makes retries safe.

**Caveat**: If the content at that URL changed but the URL did not, you'll still get the stale cached file. Bust the cache by adding a version query string:

```
https://your-cdn.example.com/design.png?v=2026-05-16T18:00:00Z
```

## Polling for processing completion

```http
GET /v2/files/987654 HTTP/1.1
Authorization: Bearer {token}
```

```json
{
  "data": {
    "id": 987654,
    "url": "https://your-cdn.example.com/design.png?v=2026-05-16T18:00:00Z",
    "type": "default",
    "hash": "a83fc8d…",
    "filename": "design.png",
    "mime_type": "image/png",
    "size": 4218302,
    "width": 3000,
    "height": 4000,
    "dpi": 300,
    "status": "ok",
    "created": "2026-05-16T18:00:00Z",
    "thumbnail_url": "https://files.cdn.printful.com/.../thumb.jpg",
    "preview_url":   "https://files.cdn.printful.com/.../preview.jpg",
    "visible": true
  }
}
```

Statuses:

- `waiting` — queued for download.
- `processing` — downloading / converting.
- `ok` — ready to use in orders.
- `failed` — could not process (file too small, unsupported format, URL unreachable). Inspect the response's `error` block for details.

Typical processing time: 5–30 seconds.

## Using files in orders and mockups

Pass `{ "type": "file", "file_id": 987654 }` inside a `placements[].layers` array. See [`07-orders-v2.md`](07-orders-v2.md) and [`08-mockup-generator.md`](08-mockup-generator.md).

If you pass `{ "type": "file", "url": "..." }` directly to an order/mockup, Printful uploads the file behind the scenes — but **a confirmed order can revert to `failed` if the underlying file processing fails after confirmation**. To avoid this risk:

1. `POST /v2/files` and store the returned `id`.
2. Poll until `status: "ok"`.
3. Then submit the order with `{ "file_id": 987654 }`.

For high-volume integrations where a confirmed-then-failed flip would be expensive, this pre-warming pattern is worth the extra round trip.

## File requirements

| Aspect | Limit |
|---|---|
| Formats | PNG, JPG, SVG (some products), PDF (some products) |
| Max file size | ~200 MB (Printful prefers ≤50 MB) |
| Min DPI | Per-product. Common: 150 DPI for DTG; up to 300 DPI for posters/canvas. Check `min_dpi` on the catalog template metadata. |
| Color profile | sRGB. CMYK files are converted; embedded ICC profiles are stripped. |
| Transparency | PNG transparency preserved for DTG and embroidery. JPGs have no transparency. |

The full per-product requirements are at `https://help.printful.com/hc/en-us/articles/360014846679-File-guidelines` — that page is more authoritative than this skill for edge formats.

## Visibility / cleanup

`visible: false` files don't appear in the dashboard File Library UI, but they're still stored and billed against the merchant's file quota. There is no public delete endpoint for files; they're cleaned up automatically by Printful after a long retention period (or you can delete them from the dashboard UI).

## Original sources

- v2 endpoints: **Files v2** section in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Schemas: `File`, `AddFile`, `FileLayer`, `FileOptionPrices` in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
- Tag description (with the HTTP 410 warning about v1): see `tags[name=Files v2].description` in the OpenAPI spec.
