# Products & Product Models — The Core Data Model

The **product** is the heart of Akeneo PIM: the entity that carries all catalog information. A product belongs to at most one **family** (its attribute template), can be classified in many **categories**, can belong to **groups**, can be a variant of a **product model**, and holds its enrichment in a **`values`** map plus **associations** to other products. This reference covers the product/product-model resources, the all-important `values` shape, and how to read and write them. For the surrounding structure (families, family variants, attributes, options, categories, channels, locales) see `catalog-structure.md`; for endpoint mechanics (pagination, filtering, HAL responses) see `rest-api-overview.md`; for EE-only reference entities and Asset Manager see `reference-entities-and-assets.md`.

## Two ways to address a product: identifier vs UUID

A product can be reached two ways, and **the two endpoint families must not be mixed for the same product**:

| | **By identifier** (classic + SaaS) | **By UUID** (SaaS / 7.x+) |
| --- | --- | --- |
| List / create | `GET`, `POST`, `PATCH` `/api/rest/v1/products` | `GET`, `POST`, `PATCH` `/api/rest/v1/products-uuid` |
| Single | `GET`, `PATCH`, `DELETE` `/api/rest/v1/products/{code}` | `GET`, `PATCH`, `DELETE` `/api/rest/v1/products-uuid/{uuid}` |
| Draft / proposal (EE) | `/products/{code}/draft`, `/products/{code}/proposal` | `/products-uuid/{uuid}/draft`, `/products-uuid/{uuid}/proposal` |
| Search (POST body) | — | `POST /api/rest/v1/products-uuid/search` |

- The `{code}` in the identifier family is the value of the product's single `pim_catalog_identifier` attribute (SKU-like). The `{uuid}` is a v4 UUID such as `fc24e6c3-933c-4a93-8a81-e5c703d134d5`.
- **UUID landed in 7.x** as 8 new endpoints that mirror the identifier ones. The reason: since November 2022 the product identifier became **optional and mutable** (you can switch your main identifier attribute from SKU to EAN), so the UUID gives every product one **immutable** handle. See `getting-started/from-identifiers-to-uuid-7x/` in the sources.
- Consequences of the identifier being optional, if you stay on `/products`: `GET /products` **won't return products that have no identifier** (you may silently miss rows); `associations` may contain **null** entries (a product associated to an identifier-less product); and `GET /products/{code}` can 404 if the identifier was cleared. New integrations should prefer `/products-uuid`.
- Classic **CE/EE on-prem is identifier-only** in practice; both families coexist post-7.x on SaaS/Serenity.

## The product resource (top-level fields)

Standard JSON format of a product (identifier form). Notice the identifier appears both as the top-level `identifier` and inside `values` as the `pim_catalog_identifier` attribute (here `sku`):

```json
{
  "identifier": "1111111195",
  "uuid": "fc24e6c3-933c-4a93-8a81-e5c703d134d5",
  "enabled": true,
  "family": "clothing",
  "categories": ["tshirts"],
  "groups": [],
  "parent": "jack_brown",
  "values": { "...": [] },
  "created": "2017-10-05T11:25:48+02:00",
  "updated": "2017-10-05T11:25:48+02:00",
  "associations": {},
  "quantified_associations": {},
  "metadata": { "workflow_status": "working_copy" }
}
```

| Field | Type | Notes |
| --- | --- | --- |
| `identifier` | string | The `pim_catalog_identifier` value. **Required** on the identifier endpoints; absent on `/products-uuid` payloads (which carry `uuid` instead). |
| `uuid` | string | Immutable v4 UUID. Present on both families from 7.x; the primary key on `/products-uuid`. On `POST /products-uuid`, **if you omit `uuid` the PIM generates one.** |
| `enabled` | boolean | Product on/off. Default `true`. (Product **models have no `enabled` field**.) |
| `family` | string / null | Family code. `null` for a non-variant product with no family. For a variant, must equal the parent model's family. |
| `categories` | array<string> | Category codes. Default `[]`. |
| `groups` | array<string> | Group codes the product belongs to. Default `[]`. |
| `parent` | string / null | Parent **product model** code when the product is a variant (since 2.0; movable since 2.3). `null` for a simple product. |
| `values` | object | The enrichment — attribute code → array of `{locale, scope, data}`. See below. |
| `associations` | object | Standard associations grouped by association-type code. |
| `quantified_associations` | object | Associations that carry a quantity (since 5.0). |
| `created` / `updated` | string (ISO-8601) | Read-only timestamps. |
| `metadata` | object | **EE only** (since 2.0). `workflow_status` ∈ `read_only`, `draft_in_progress`, `proposal_waiting_for_approval`, `working_copy`. Read-only. |
| `quality_scores` | array | Read-only Data-Quality grades per channel/locale. Only when `?with_quality_scores=true` (products 5.0+; product models 7.0+). |
| `completenesses` | array | Read-only completeness % per channel/locale. Only when `?with_completenesses=true` (6.0+). |
| `root_parent` | string | (UUID products) Read-only code of the top ancestor product model. |

Read one product: `GET /api/rest/v1/products-uuid/{uuid}` (or `/products/{code}`). Add `?with_attribute_options=true`, `?with_quality_scores=true`, `?with_completenesses=true` to enrich the response. Listing supports `search` (a JSON filter), `scope`, `locales`, `attributes`, and `page`/`search_after` pagination — see `rest-api-overview.md`.

## The value structure (this is the #1 thing to get right)

Every attribute's data lives under `values`, keyed by attribute code, as an **array of value objects**:

```json
"values": {
  "<attribute_code>": [
    {
      "locale": "<locale_code | null>",
      "scope":  "<channel_code | null>",
      "data":   "<shape depends on the attribute type>",
      "linked_data": { },          // read-only, 5.0+ : option/asset labels
      "attribute_type": "...",     // read-only, SaaS only
      "reference_data_name": "..." // read-only, SaaS only (ref-entity / asset attrs)
    }
  ]
}
```

- **`locale`** is a locale code (e.g. `en_US`) **only when the attribute is localizable**; otherwise it **must be `null`**.
- **`scope`** is a channel code (e.g. `ecommerce`) **only when the attribute is scopable**; otherwise it **must be `null`**.
- The array has **one entry per applicable `(locale, scope)` combination**. A non-localizable, non-scopable attribute has exactly one entry with both `null`. A localizable+scopable attribute has one entry for every locale×channel pair you enrich.
- `linked_data`, `attribute_type`, and `reference_data_name` are **read-only** — the API returns them but you cannot POST/PATCH them (`linked_data` holds resolved option/asset labels; `reference_data_name` names the reference entity or asset family).

Whether an attribute is localizable/scopable is defined on the attribute itself (`localizable`, `scopable` flags — see `catalog-structure.md`). **Getting these two flags wrong is the most common 422.**

### `data` shape by attribute type

| Attribute type | `data` shape | Example |
| --- | --- | --- |
| `pim_catalog_identifier` | string | `"1111111195"` |
| `pim_catalog_text`, `pim_catalog_textarea` | string | `"Tshirt long sleeves\n100% wool"` |
| `pim_catalog_number` | integer if `decimals_allowed:false`, else numeric **string** | `40` or `"89.897"` |
| `pim_catalog_boolean` | boolean | `true` |
| `pim_catalog_date` | ISO-8601 string | `"2021-04-29T08:58:00+01:00"` |
| `pim_catalog_simpleselect` | string = an **attribute option code** | `"blue"` |
| `pim_catalog_multiselect` | array of option codes | `["leather", "cotton"]` |
| `pim_catalog_price_collection` | array of `{amount, currency}` (amount string if decimals allowed) | `[{"amount":"25.50","currency":"EUR"}]` |
| `pim_catalog_metric` | object `{amount, unit, symbol}` (`symbol` read-only, resolved) | `{"amount":"800.0000","unit":"GRAM","symbol":"g"}` |
| `pim_catalog_file`, `pim_catalog_image` | string = a **product media file code** | `"f/2/e/6/f2e6…_myFile.pdf"` |
| `pim_catalog_reference_data_simpleselect` / `_multiselect` | option code string / array | `"bouroullec"` / `["winter_2019"]` |
| `pim_catalog_product_link` (EE, SaaS) | object `{type, id|identifier}` | `{"type":"product","id":"fc24e6c3-…"}` |
| `akeneo_reference_entity` (EE) | string = a record code | `"bouroullec"` |
| `akeneo_reference_entity_collection` (EE) | array of record codes | `["winter_2019","spring_2020"]` |
| `pim_catalog_asset_collection` (EE) | array of Asset Manager asset codes | `["allie_jean_frontview"]` |
| `pim_catalog_table` (EE/GE, 6.0+) | array of row objects `{column_code: cell}` | `[{"composition":"Frozen"}]` |

For number/metric/price: when the attribute's `decimals_allowed` is `true`, send the amount as a **string** (`"25.50"`) to avoid float rounding; when `false`, send an integer (`10`). Reference-entity / asset / product-link / table types are **Enterprise/SaaS only** — they 404/422 on CE. For reference entities and assets in depth, see `reference-entities-and-assets.md`.

### The four locale/scope combinations — one concrete product

```json
"values": {
  "sku": [
    { "locale": null,    "scope": null,        "data": "1111111195" }
  ],
  "name": [                                                  // localizable, not scopable
    { "locale": "en_US", "scope": null,        "data": "Jack" },
    { "locale": "fr_FR", "scope": null,        "data": "Jacques" }
  ],
  "release_date": [                                          // scopable, not localizable
    { "locale": null,    "scope": "ecommerce", "data": "2012-03-13T00:00:00+01:00" },
    { "locale": null,    "scope": "mobile",    "data": "2012-04-23T00:00:00+01:00" }
  ],
  "description": [                                           // localizable AND scopable
    { "locale": "en_US", "scope": "ecommerce", "data": "Long-sleeve winter tee" },
    { "locale": "en_US", "scope": "mobile",    "data": "LS winter tee" },
    { "locale": "fr_FR", "scope": "ecommerce", "data": "T-shirt manches longues" }
  ],
  "color":      [ { "locale": null, "scope": null, "data": "brown" } ],              // simpleselect
  "collection": [ { "locale": null, "scope": null, "data": ["summer_2017"] } ],      // multiselect
  "weight":     [ { "locale": null, "scope": null,
                    "data": { "amount": "800.0000", "unit": "GRAM", "symbol": "g" } } ],   // metric
  "price":      [ { "locale": null, "scope": null,
                    "data": [ { "amount": "25.50", "currency": "EUR" },
                              { "amount": "30.00", "currency": "USD" } ] } ],              // price
  "is_smart":   [ { "locale": null, "scope": null, "data": true } ]                  // boolean
}
```

## Writing products

Writes go through **`POST`** (create-only) or **`PATCH`** (create-or-update / upsert). There is no PUT for products. `Content-Type: application/json` for single-resource calls.

### Single product — PATCH upsert

```bash
PATCH /api/rest/v1/products-uuid/25566245-55c3-42ce-86d9-8610ac459fa8
Content-Type: application/json

{
  "enabled": true,
  "family": "tshirt",
  "categories": ["summer_collection"],
  "values": {
    "name":  [ { "locale": "en_US", "scope": null, "data": "Top" } ],
    "price": [ { "locale": null, "scope": null,
                 "data": [ { "amount": "15.5", "currency": "EUR" } ] } ]
  }
}
```

- If the product exists → merged and updated → **`204 No Content`**. If it does not → created → **`201 Created`** with a `Location` header.
- `POST /products` (or `/products-uuid`) **creates only** — it 422s if the identifier already exists. On `POST /products-uuid` an omitted `uuid` is generated by the PIM.

### Partial-merge (PATCH) rules

A PATCH touches only the keys you send (from `rest-api/update.md`):

1. **Objects are merged** with the existing value (e.g. adding `de_DE` to a `labels`/values map keeps the other keys).
2. **Non-objects (scalars, arrays) replace** the old value wholesale. So `"categories": ["boots"]` **overwrites** the whole category list — it is not additive.
3. Data types must match; a wrong type is rejected. `"labels": null` where an object is expected → **422** (`Property 'labels' expects an array as data, 'NULL' given.`).
4. Unspecified properties are **left untouched**.

For **values specifically**, each entry is addressed by its `(attribute, locale, scope)` triple. Sending one entry for `name`/`fr_FR` **adds/updates just that locale** and leaves `name`/`en_US` intact — you do not need to resend the whole attribute.

### Deleting a single value (data: null)

To **erase** one localized/scoped value, PATCH that exact entry with `"data": null`. The `(locale, scope)` slot remains but its data is cleared:

```json
{ "values": { "name": [ { "locale": "en_US", "scope": null, "data": null } ] } }
```

### Enabling / disabling, family, categories, associations

```json
{ "enabled": false }                                  // disable a product
{ "family": "clothes" }                               // (re)assign the family
{ "categories": ["shoes", "boots", "winter_2024"] }   // REPLACES the category set
```

- **Category deltas without a full replace**: the collection `PATCH` endpoints accept the intent keys **`add_categories`** and **`remove_categories`** on a line to add/remove categories (and analogous intents) without resending the whole array.
- **Convert a variant product to a simple one** (6.0+): PATCH `"parent": null`. Former values, categories, and associations (including those inherited from the model) are kept unless you override them.

### Bulk upsert — newline-delimited JSON

`PATCH /products` (or `/products-uuid`) with a body of **one product JSON object per line** (not a JSON array). This is the workhorse for imports.

```
PATCH /api/rest/v1/products
Content-Type: application/vnd.akeneo.collection+json

{"identifier":"cap","values":{"description":[{"scope":"ecommerce","locale":"en_US","data":"My amazing cap"}]}}
{"identifier":"mug","group":["promotion"]}
{"identifier":"tshirt","family":"clothes"}
```

The response is `200 OK` with **one JSON status line per input line**:

```
{"line":1,"identifier":"cap","status_code":204}
{"line":2,"identifier":"mug","status_code":422,"message":"Property \"group\" does not exist."}
{"line":3,"identifier":"tshirt","status_code":201}
```

- The UUID variant keys each result by `"uuid"` instead of `"identifier"`.
- **Limits: ≤ 100 products per request** (else `413 Too many resources to process, 100 is the maximum allowed.`), and each JSON line ≤ 1,000,000 characters. A too-large payload can surface as `403` instead of `413`. Split into batches.
- One bad line returns a 4xx `status_code` for that line only; the others still apply — always parse every result line.

## Product models & family variants

A **product model** is "like a product but not a product": it has no `enabled` flag, is addressed by **`code`**, and gathers variant products that differ along **variation axes**. It carries the common `values` its children share.

```json
{
  "code": "model-biker-jacket-leather",
  "family": "clothing",
  "family_variant": "clothing_material_size",
  "parent": "model-biker-jacket",
  "categories": ["summer_collection"],
  "values": {
    "material": [ { "locale": null, "scope": null, "data": "leather" } ],
    "name":     [ { "locale": "en_US", "scope": null, "data": "Biker jacket" } ]
  },
  "associations": {},
  "quantified_associations": {},
  "created": "2017-10-02T15:03:55+02:00",
  "updated": "2017-10-02T15:03:55+02:00"
}
```

Endpoints: `GET/POST/PATCH /api/rest/v1/product-models`, `GET/PATCH/DELETE /api/rest/v1/product-models/{code}` — same upsert + newline-delimited bulk semantics as products. `code`, `family`, and `family_variant` are **immutable** after creation; `parent` is movable (2.3+).

### Levels, axes, and how values distribute

The **family variant** (defined once on the family — see `catalog-structure.md`) declares 1 or 2 variant levels via `variant_attribute_sets`, each with `axes` (the distinguishing attributes) and `attributes` (what is enriched at that level):

```
family "clothing", family_variant "clothing_color_size":
  level 1  axes=[color]  attributes=[variation_name, variation_image, composition, color, material]
  level 2  axes=[size]   attributes=[sku, weight, size, ean]
```

This produces a tree whose depth equals the number of levels:

```
ROOT product model            (common values: name, description, brand…)
│   parent = null, family_variant = clothing_color_size
├── sub product model         (level-1 values: color = "blue", composition…)
│   │   parent = ROOT, distinguished by axis `color`
│   ├── variant PRODUCT        (level-2 values: size = "s", sku, weight, ean)
│   └── variant PRODUCT        (size = "m", …)
└── sub product model          (color = "red", …)
    └── variant PRODUCT         (size = "l", …)
```

- **1-level** family variant: a root product model directly parents variant **products** (one axis).
- **2-level**: root model → sub-models (level-1 axis) → variant products (level-2 axis).
- **Value distribution:** each attribute is enriched at exactly one place — common attributes on the root model, level-1 attributes on the sub-models, level-2 (incl. the identifier/`sku`) on the leaf variant products. The **axis attributes** (e.g. `color`, `size`) are what make siblings distinct.
- A variant product's `parent` must be an existing model whose `family_variant` matches, and its `family` must equal the model's family (else 422). Full family-variant CRUD and the `variant_attribute_sets` schema live in `catalog-structure.md`.

## Media / files on products

A `pim_catalog_file` or `pim_catalog_image` value's `data` is a **media file code** — a path-like string the PIM assigns, e.g. `1/d/7/f/1d7f0987…_10806799_1356.jpg`. You do **not** put binary or a URL in `data`; you upload the file first, then reference its code.

**Upload + attach in one call:** `POST /api/rest/v1/media-files`, `Content-Type: multipart/form-data`, with two parts:

- `file` — the binary file.
- **exactly one** of:
  - `product` — a JSON string: `{"identifier":"<sku>","attribute":"<attr_code>","scope":null,"locale":null}`
  - `product_model` — a JSON string: `{"code":"<model_code>","attribute":"<attr_code>","scope":null,"locale":null}`

```bash
curl -X POST https://{pim}/api/rest/v1/media-files \
  -H "Authorization: Bearer $TOKEN" \
  -F 'file=@packshot.jpg' \
  -F 'product={"identifier":"1111111195","attribute":"packshot","scope":null,"locale":null}'
```

On success → `201 Created`; the created media file code is the `Location`/response code. That single call both stores the file **and** sets it as that product's attribute value. Set `scope`/`locale` in the JSON to match the attribute's scopable/localizable flags. To attach an already-uploaded file to another value, PATCH the product with `"<attr>":[{"locale":…,"scope":…,"data":"<media_file_code>"}]`. Retrieve metadata via `GET /media-files/{code}` and bytes via `GET /media-files/{code}/download`. Media file object:

```json
{
  "code": "1/d/7/f/1d7f0987…_10806799_1356.jpg",
  "original_filename": "10806799-1356.jpg",
  "mime_type": "image/jpeg",
  "size": 16070,
  "extension": "jpg",
  "_links": { "download": { "href": "https://{pim}/api/rest/v1/media-files/1/d/7/f/…/download" } }
}
```

## Associations & quantified associations

**Standard associations** group related products/models/groups by **association-type code** (e.g. `PACK`, `UPSELL`, `X_SELL`, `SUBSTITUTION` — manage the types in `catalog-structure.md`). On the identifier endpoints `products` holds **identifiers**; on the UUID endpoints it holds **UUIDs**:

```json
"associations": {
  "PACK": {
    "products": ["d055527c-0698-4967-8f16-8a5f23f4e5cf"],   // UUIDs on /products-uuid
    "product_models": [],
    "groups": []
  }
}
```

**Quantified associations** (since 5.0) attach a **quantity** to each linked item; the association type must be flagged as quantified. `products` items are `{identifier|uuid, quantity}`; `product_models` items are `{code, quantity}`:

```json
"quantified_associations": {
  "PRODUCT_SET": {
    "products": [
      { "uuid": "fc24e6c3-933c-4a93-8a81-e5c703d134d5", "quantity": 2 },
      { "uuid": "a9b69002-a0b1-4ead-85c2-f8dbf59c6cfc", "quantity": 1 }
    ],
    "product_models": [ { "code": "model-biker-jacket-leather", "quantity": 2 } ]
  }
}
```

Because these are objects, a PATCH **merges by association type** but **replaces the array under each type** — send the full member list for a type you touch. Product models can carry associations too (same shape). Note: on `/products-uuid` an association to an identifier-less product can appear as `null`.

## Common 422s tied to values

Invalid data returns `422 Unprocessable Entity`, often with a per-error `errors[]` array naming the offending `property`, `attribute`, `locale`, and `scope`:

```json
{
  "code": 422,
  "message": "Validation failed.",
  "errors": [
    { "property": "values",
      "message": "The tommh value is not in the brand attribute option list.",
      "attribute": "brand", "locale": null, "scope": null }
  ]
}
```

| Symptom / message | Cause | Fix |
| --- | --- | --- |
| `…is not in the <attr> attribute option list.` | `data` is an option code that doesn't exist for a simple/multiselect | Create the option first (`catalog-structure.md`), or send an existing code. |
| `Property 'X' expects an array as data, 'NULL' given.` / type errors | `data` shape wrong for the attribute type (e.g. object vs array, null vs required) | Match the type table above; number/metric/price amounts as strings when decimals allowed. |
| Value rejected for a locale/scope, or "not localizable/scopable" | Sent a `locale`/`scope` for a flat attribute, or omitted one that's required | Set `locale`/`scope` to `null` unless the attribute is localizable/scopable; supply the code when it is. |
| `Property 'X' does not exist. Check the standard format documentation.` | Unknown top-level property or attribute code (typo, wrong edition) | Remove/rename it; confirm the attribute exists and the edition supports it. |
| `The <code> category does not exist in your PIM.` | Category/family/group/parent code not found | Create it or fix the code; remember "does not exist" can also mean **no permission**. |
| Variant product 422 on write | `parent` model's `family_variant`/`family` mismatch, or an axis value missing | Align `family` with the model; enrich the required axis at the right level. |

Also relevant: `400` malformed JSON; `401`/`403` auth/permission (see `authentication.md`); `404` wrong edition or cleared identifier; `413` batch > 100 items; `429` rate limit (honor `Retry-After`). See `errors-and-rate-limits.md`.

## Original sources

- `references/sources/akeneo-official-docs/concepts/products.md` — product & product-model standard format, the `values` format, all `data`-per-type examples, `linked_data`, product media file.
- `references/sources/akeneo-official-docs/concepts/catalog-structure.md` — family, family variant (`variant_attribute_sets`), attribute types, association types.
- `references/sources/akeneo-official-docs/rest-api/update.md` — PATCH merge rules; add/modify/erase product values (`data: null`).
- `references/sources/akeneo-official-docs/rest-api/responses.md` — 4xx/5xx bodies incl. the 422 `errors[]` shape and 413 batch limit.
- `references/sources/akeneo-official-docs/rest-api/good-practices.md` — concurrency, 100-req/s rate limit, retry/backoff.
- `references/sources/akeneo-official-docs/getting-started/from-identifiers-to-uuid-7x/welcome.md` — the identifier→UUID migration and its impacts.
- `references/sources/openapi-specs/classic-swagger-src/resources/products/` and `products_uuid/` and `product_models/` (definitions + routes) — field schemas, endpoints, POST/PATCH/DELETE, batch `ErrorByLine` examples.
- `references/sources/openapi-specs/classic-swagger-src/resources/media_files/routes/media_files.yaml` — multipart upload contract (`file` + `product`/`product_model`).
- `references/sources/postman/akeneo-postman-collection.json` — Product [uuid], Product [identifier], Product model, Product media file request bodies.
- `references/sources/openapi-specs/SPEC-SUMMARY.md` — flat catalog of every product/model operation across both specs.
