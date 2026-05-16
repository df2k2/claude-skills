# 08 — Mockup Generator

The mockup generator renders preview images of how a design will look on a product variant. It is **always asynchronous** in both v1 and v2 — submit a task, then poll or subscribe to a webhook.

## v2 vs v1 — when to use which

| Feature | v2 (`/v2/mockup-tasks`) | v1 (`/mockup-generator/...`) |
|---|---|---|
| Endpoint pattern | Two endpoints (create + poll) | Four endpoints (create + poll + templates + printfiles) |
| Design data model | Multi-layer `placements` (same shape as Orders v2) | Flat `files[]` |
| Mockup style selection | Explicit `mockup_style_ids` | Implicit (per template metadata) |
| Polling | `GET /v2/mockup-tasks?id={task_id}` | `GET /mockup-generator/task?task_key={key}` |
| Webhook completion event | `mockup_task_finished` (v2 webhook) | None — must poll |
| Output formats | `jpg`, `png` | `jpg`, `png` |
| Templates/printfiles for custom UI | Not exposed in v2 yet | `GET /mockup-generator/templates/{id}`, `/printfiles/{id}` |

Use **v2** for new code unless you need to build a custom design tool that needs the raw printfile/template metadata (then fall back to v1 templates/printfiles, while still rendering via v2).

## v2 — `POST /v2/mockup-tasks`

Creates a mockup task.

```http
POST /v2/mockup-tasks HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "catalog_product_id": 71,
  "catalog_variant_ids": [4011, 4012, 4013],
  "mockup_style_ids":   [1115, 1117],
  "format": "jpg",
  "placements": [
    {
      "placement": "front",
      "technique": "dtg",
      "layers": [
        {
          "type": "file",
          "url":  "https://your-cdn.example.com/design.png"
        }
      ]
    }
  ]
}
```

Required:

- `catalog_product_id` — the product (Bella+Canvas 3001 = 71).
- `catalog_variant_ids[]` — one or more variants. Each renders separately.
- `placements[]` — design data in the same format as Orders v2 (`placement` + `technique` + `layers`).

Optional:

- `mockup_style_ids[]` — picks which mockup styles to render. Without it, Printful renders the default style for each variant. Discover style IDs with `GET /v2/catalog-products/{id}/mockup-styles`.
- `format` — `jpg` (smaller) or `png` (transparent background where available).

Response (`202 Accepted`):

```json
{
  "data": {
    "id": "task_abc123",
    "status": "pending",
    "created_at": "2026-05-16T18:00:00Z"
  }
}
```

The task is queued. Typical render time is 5–30 seconds per variant × style combination.

## v2 — `GET /v2/mockup-tasks` — poll

Polling pattern:

```http
GET /v2/mockup-tasks?id=task_abc123 HTTP/1.1
```

Statuses: `pending`, `completed`, `failed`.

Completed response:

```json
{
  "data": {
    "id": "task_abc123",
    "status": "completed",
    "created_at": "2026-05-16T18:00:00Z",
    "completed_at": "2026-05-16T18:00:18Z",
    "mockups": [
      {
        "placement": "front",
        "variant_ids": [4011, 4012],
        "style_id": 1115,
        "style_name": "Men's",
        "view_name": "Front",
        "mockup_url": "https://files.cdn.printful.com/.../mockup_a.jpg",
        "extra_urls": []
      }
    ],
    "printfiles": [
      { "placement": "front", "url": "https://files.cdn.printful.com/.../printfile.png", "variant_ids": [4011, 4012] }
    ]
  }
}
```

Note that one task can return **multiple mockup images** (one per variant×style combination). Printfiles (the high-res rendered design as it will go to the printer) are returned alongside — useful for showing customers an accurate preview of the printable area.

### Failed task

```json
{
  "data": {
    "id": "task_abc123",
    "status": "failed",
    "error": {
      "code": "file_too_small",
      "message": "The design file is below the minimum DPI for this product."
    }
  }
}
```

## v2 — listing tasks

`GET /v2/mockup-tasks` (no `id`) returns the recent tasks for the current store. Useful for resuming/inspecting jobs that completed during downtime.

## v2 — using the webhook

Configure `mockup_task_finished` via `POST /v2/webhooks/mockup_task_finished` to receive a push when a task completes. The payload includes the task `id`, `status`, `mockups[]`, and `printfiles[]` — same shape as the `GET` response. Use this to avoid polling.

See [`14-webhooks.md`](14-webhooks.md) for webhook setup.

## v1 — `POST /mockup-generator/create-task/{product_id}`

The v1 flow has the product ID in the URL path:

```http
POST /mockup-generator/create-task/71 HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "variant_ids": [4011, 4012],
  "format": "jpg",
  "option_groups": ["Men's", "Women's"],
  "product_options": { "lifelike": true },
  "files": [
    {
      "placement": "front",
      "image_url": "https://your-cdn.example.com/design.png",
      "position": { "area_width": 1800, "area_height": 2400, "width": 1500, "height": 1500, "top": 300, "left": 150 }
    }
  ]
}
```

Response (v1 envelope):

```json
{
  "code": 200,
  "result": {
    "task_key": "abc123",
    "status": "pending"
  }
}
```

`task_key` is the v1 equivalent of v2's `id`.

### v1 polling

```http
GET /mockup-generator/task?task_key=abc123 HTTP/1.1
```

Completed response:

```json
{
  "code": 200,
  "result": {
    "task_key": "abc123",
    "status": "completed",
    "mockups": [
      {
        "placement": "front",
        "variant_ids": [4011, 4012],
        "mockup_url": "https://files.cdn.printful.com/.../mockup.jpg",
        "extra": [
          { "title": "Men's / Front", "option": "1115", "url": "…" }
        ]
      }
    ],
    "printfiles": [ { "placement": "front", "url": "…", "variant_ids": [4011] } ]
  }
}
```

Statuses: `pending`, `completed`, `failed`.

### v1 — `GET /mockup-generator/printfiles/{product_id}`

Returns the per-variant printfile metadata needed to render a **custom design UI** (your own canvas where users can drag and resize their image):

```json
{
  "code": 200,
  "result": {
    "product_id": 71,
    "available_placements": { "front": "Front print", "back": "Back print", "label_inside": "Inside label" },
    "printfiles": [
      { "printfile_id": 100, "width": 1800, "height": 2400, "dpi": 150, "fill_mode": "fit", "can_rotate": false }
    ],
    "variant_printfiles": [
      { "variant_id": 4011, "placements": { "front": 100, "back": 100, "label_inside": 200 } }
    ]
  }
}
```

`variant_printfiles[*].placements` is a map from placement name to printfile ID. Same product can have different printfile IDs across variants (e.g. the kids' size has a smaller printable area than adults).

Use `?orientation=horizontal` or `vertical` on products with multiple orientations (wall art, mugs).

### v1 — `GET /mockup-generator/templates/{product_id}`

Returns rendering templates (background image + placement coordinates) for a custom mockup UI:

```json
{
  "code": 200,
  "result": {
    "version": 5,
    "min_dpi": 150,
    "variant_mapping": [ { "variant_id": 4011, "templates": [ { "placement": "front", "template_id": 9001 } ] } ],
    "templates": [
      {
        "template_id": 9001,
        "image_url": "https://files.cdn.printful.com/.../template_front.png",
        "background_url": null,
        "background_color": "#ffffff",
        "printfile_id": 100,
        "template_width":  1500,
        "template_height": 2000,
        "print_area_width":  900,
        "print_area_height": 1200,
        "print_area_top":    400,
        "print_area_left":   300,
        "is_template_on_front": true,
        "orientation": "horizontal"
      }
    ],
    "conflicting_placements": [
      { "placement": "label_inside", "conflicts": ["label_outside"] }
    ]
  }
}
```

The `print_area_*` fields tell you the bounding box of the printable region on the template image — overlay the user's design there in your UI. The `conflicting_placements` array tells you which placement pairs cannot coexist on the same order item (Printful enforces this; if your UI lets the user select both, the order will fail).

## Building a custom design preview UI — the recipe

1. `GET /v2/catalog-products/{product_id}/mockup-templates` (or v1 `/mockup-generator/templates/{product_id}` for the richer set).
2. Pick the template that matches the variant + placement the customer is editing.
3. Render the template image as the background.
4. Overlay the user's design within the `print_area_*` rectangle.
5. When the user is done, save the design + the chosen `position` (in printfile pixel coordinates).
6. Submit a real mockup task (`POST /v2/mockup-tasks`) to render a polished preview.
7. On checkout, submit the order with the same `placements` block.

## Limits

- Each task: up to **20 variants × all mockup styles** for that product. Beyond that, split into multiple tasks.
- File size: PNG/JPG up to ~200 MB (Printful prefers <50 MB). For very high-res files, use the file upload (`POST /v2/files`) to pre-process the file once and reference by `file_id` thereafter.
- Minimum DPI: enforced per-product. The catalog response includes `min_dpi`; submitting a file below that DPI causes the task to `fail`.

## Rate limiting

Mockup tasks share the default v2 rate limit (120 req/60s leaky bucket). Each task **creation** counts; **polls** also count. For large batches (e.g. mockups for 1000 products), pace the creates at ≤1 RPS and use the webhook to receive completions instead of polling.

## Original sources

- v2 endpoint metadata: **Mockup Generator v2** section in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Schemas: `MockupGeneratorTask`, `MockupTaskCreation`, `Mockup`, `MockupStyles`, `MockupTemplates`, `BaseMockupProduct`, `CatalogMockupProduct`, `TemplateMockupProduct` in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
- v1 mockup endpoints in code: [`sources/PrintfulMockupGenerator.php`](sources/PrintfulMockupGenerator.php).
