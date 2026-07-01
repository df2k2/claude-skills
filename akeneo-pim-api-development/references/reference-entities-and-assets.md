# Reference Entities & Assets (Asset Manager) — EE / Serenity enrichment

Reference entities and the Asset Manager are Akeneo's two **rich-content enrichment** systems. They live *alongside* products: a product carries only a *reference* (a code, or a list of codes) to a record or an asset, while the record/asset itself holds its own attributes, values, and lifecycle in a separate resource tree.

> ## Edition availability — read this first
>
> **Reference entities and the Asset Manager are Enterprise Edition (EE) and Serenity (SaaS) only.** They do **not** exist in Community Edition (CE): every `reference-entities/*` and `asset-families/*` route returns **404 on CE** — that is "wrong edition," not "wrong path" (see the `#7` rule in `SKILL.md`). The community **Akeneo Connector for Magento 2 does not import reference entities or Asset-Manager assets** at all (that's the `akeneo-magento2-connector` skill). Both surfaces appear in *both* embedded specs — the SaaS `saas-openapi.json` (Serenity) and the classic `classic-web-api.json` (on-prem EE) — because the classic spec covers CE **and** EE; the resources are gated by license, not by spec.
>
> - **Reference entity** — introduced in PIM **3.0** (`versions=3.x,4.0,5.0,6.0,7.0,SaaS editions=EE`).
> - **Asset Manager** — the *asset* resource landed in **3.2**; the full family/naming-convention/transformation machinery is **4.0+** (`editions=EE`). It **replaces** the old **PAM** ("Product Asset Management"), which was **removed in 4.0** and is deprecated — see [Legacy PAM](#legacy-pam-the-old-asset-system) at the bottom.

## The one gotcha that spans this whole file: `channel` vs `scope`

Product values, reference-entity record values, and asset values all share the same `{locale, channel/scope, data}` triple — **but the channel key is named differently**:

| Value lives on… | Channel key | `attribute_type` present? | Reference file |
| --- | --- | --- | --- |
| **Product / product model** | **`scope`** | yes (SaaS) | `products-and-models.md` |
| **Reference entity record** | **`channel`** | no | this file |
| **Asset (Asset Manager)** | **`channel`** | yes (SaaS only) | this file |

So a product value is `{"locale": …, "scope": …, "data": …}` but a record/asset value is `{"locale": …, "channel": …, "data": …}`. Sending `scope` to a record endpoint (or `channel` to a product endpoint) is a classic 422. In all three, `locale` is `null` unless the attribute is *localizable* and the channel key is `null` unless the attribute is *scopable*.

---

# Part 1 — Reference Entities

A **reference entity** is a product-adjacent object with its own attributes and lifecycle — brands, ranges, manufacturers, colors, materials, designers, care instructions, countries… A product links to a reference entity's **records** through a dedicated product attribute type.

## The model

```
Reference entity            reference-entities/{code}          e.g. "designer", "brand", "country"
│   { code, labels, image }
│
├── Reference entity attribute      …/{code}/attributes/{code}
│   │   describes the RECORDS (NOT the same as a product "attribute")
│   │   types: text, image, number, single_option, multiple_options,
│   │          reference_entity_single_link, reference_entity_multiple_links, asset_collection
│   │
│   └── Reference entity attribute option   …/attributes/{attr}/options/{code}
│           only for single_option / multiple_options
│
├── Reference entity record          …/{code}/records/{code}    e.g. "starck", "kartell"
│       { code, values: { attr: [ {locale, channel, data} ] } }
│       a record can be linked to one or MANY products
│
└── media files                      reference-entities-media-files   (images on records & on the entity)
```

- The "**Reference entity attribute**" resource is **not** the product "Attribute" resource, even though the JSON looks similar — the first describes records, the second describes products. Same warning for "attribute option."
- **Max 100 attributes** per reference entity and **max 100 options** per attribute → the attribute-list and option-list responses are **not paginated**.

## Endpoints

| Verb & path | Notes |
| --- | --- |
| `GET  /reference-entities` | list (paginated) |
| `GET  /reference-entities/{code}` | one entity |
| `PATCH /reference-entities/{code}` | **upsert** an entity (create-or-update). There is **no POST and no DELETE** for the entity itself. |
| `GET  /reference-entities/{re}/attributes` | list (not paginated, ≤100) |
| `GET  /reference-entities/{re}/attributes/{code}` | one attribute |
| `PATCH /reference-entities/{re}/attributes/{code}` | upsert an attribute |
| `GET  /reference-entities/{re}/attributes/{attr}/options` | list (not paginated, ≤100) |
| `GET  /reference-entities/{re}/attributes/{attr}/options/{code}` | one option |
| `PATCH /reference-entities/{re}/attributes/{attr}/options/{code}` | upsert an option |
| `GET  /reference-entities/{re}/records` | list records (**`search_after` cursor pagination**) |
| `PATCH /reference-entities/{re}/records` | **upsert several records** — JSON *array* body |
| `GET  /reference-entities/{re}/records/{code}` | one record |
| `PATCH /reference-entities/{re}/records/{code}` | upsert one record |
| `GET  /reference-entities/records` | **SaaS only** — records across *all* entities (`?reference_entity=&channel=&locales=&search=…`) |
| `POST /reference-entities-media-files` | upload a media binary (multipart) |
| `GET  /reference-entities-media-files/{code}` | download a media binary |

All writes are **PATCH upserts** — partial, value-level merges (see `rest-api-overview.md`). No dedicated "create." Record lists filter/sort with the same `search` + `search_after` machinery as products.

## Reference entity, attribute, option — JSON

**Entity** (`PATCH /reference-entities/brands`) — `image` is a media-file code (see upload below):

```json
{
  "code": "brands",
  "labels": { "en_US": "Brands", "fr_FR": "Marques" },
  "image": "0/2/d/6/54d81dc888ba1501a8g765f3ab5797569f3bv756c_ref_img.png"
}
```

**Attribute** — shape varies by `type`. Common flags: `value_per_locale`, `value_per_channel`, `is_required_for_completeness`.

```json
// text
{ "code": "description", "labels": {"en_US":"Description"}, "type": "text",
  "value_per_locale": true, "value_per_channel": false, "is_required_for_completeness": true,
  "max_characters": null, "is_textarea": true, "is_rich_text_editor": true,
  "validation_rule": null, "validation_regexp": null }

// image  (value_per_channel:true would make it scopable)
{ "code": "photo", "labels": {"en_US":"Photo"}, "type": "image",
  "value_per_locale": false, "value_per_channel": false, "is_required_for_completeness": true,
  "allowed_extensions": ["jpg"], "max_file_size": "10" }

// number (since 3.2)
{ "code": "creation_year", "type": "number", "value_per_locale": false, "value_per_channel": false,
  "is_required_for_completeness": false, "decimals_allowed": false, "min_value": "1800", "max_value": "2100" }

// single_option / multiple_options  (then manage options via the options endpoint)
{ "code": "nationality", "type": "single_option",
  "value_per_locale": false, "value_per_channel": false, "is_required_for_completeness": false }

// reference_entity_single_link / reference_entity_multiple_links  (a record → record link)
{ "code": "country", "type": "reference_entity_single_link",
  "value_per_locale": false, "value_per_channel": false, "is_required_for_completeness": false,
  "reference_entity_code": "country" }

// asset_collection  (a record → Asset-Manager assets link)
{ "code": "brand", "type": "asset_collection",
  "value_per_locale": false, "value_per_channel": false, "is_required_for_completeness": false,
  "asset_family_identifier": "logos" }
```

**Attribute option** — options are only for `single_option` / `multiple_options`:

```json
{ "code": "europe", "labels": { "en_US": "Europe", "fr_FR": "Europe" } }
```

## Record value structure (`{locale, channel, data}` — note `channel`)

A record's `values` map each attribute code to an array of `{locale, channel, data}` entries. **`channel`, not `scope`.** No `attribute_type` field (unlike assets/products).

```json
// PATCH /reference-entities/designer/records/A   (or an array on …/records)
{
  "code": "A",
  "values": {
    "label":       [ { "locale": "en_US", "channel": null, "data": "A" } ],
    "image":       [ { "locale": null,   "channel": null, "data": "0/c/b/0/0cb0c0e11…_image.jpg" } ],
    "description": [
      { "locale": "en_US", "channel": null, "data": "A, the Italian furniture company…" },
      { "locale": "fr_FR", "channel": null, "data": "A, l'éditeur de meuble italien…" }
    ],
    "designer":      [ { "locale": null, "channel": null, "data": "starck" } ],
    "country":       [ { "locale": null, "channel": null, "data": "italy"  } ],
    "creation_year": [ { "locale": null, "channel": null, "data": "1949"   } ],
    "photo":         [ { "locale": null, "channel": null, "data": "5/1/d/8/51d81dc77…_img.png" } ]
  }
}
```

**`data` format per attribute type:**

| Attribute type | `data` | Example |
| --- | --- | --- |
| Text / Image / Number | string | `"1949"`, `"5/1/d/8/…_img.png"` |
| Single select | string (option code) | `"yellow"` |
| Multi select | array of strings | `["leather", "cotton"]` |
| Reference entity single link | string (record code) | `"italy"` |
| Reference entity multi link | array of record codes | `["starck", "dixon"]` |
| Asset collection | array of asset codes | `["packshot", "badge"]` |

Localizable/scopable behaves exactly like product values, but with `channel`:

```json
// localizable, not scopable → one entry per locale, channel:null
"short_description": [
  { "locale": "en_US", "channel": null, "data": "A well-known manufacturer…" },
  { "locale": "fr_FR", "channel": null, "data": "Un fabricant renommé…" }
]
// scopable, not localizable → one entry per channel, locale:null
"image": [
  { "locale": null, "channel": "ecommerce", "data": "…_img_ecommerce.png" },
  { "locale": null, "channel": "mobile",    "data": "…_img_mobile.png" }
]
```

## Record media files (upload an image, then reference its code)

Images on records (and on the entity's own `image`) are **two-step**: upload the binary, then put the returned **code** into a record value's `data`.

```bash
# 1. POST the binary — multipart/form-data, form field name "file"
curl -X POST {pim}/api/rest/v1/reference-entities-media-files \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@brand_logo.png"
# 201 Created. The response returns the media-file code in a response header
#   (asset-media-file-code) and a Location header. Capture that code.

# 2. PATCH the record, using the code as the value data
curl -X PATCH {pim}/api/rest/v1/reference-entities/brand/records/kartell \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{ "values": { "image": [ { "locale": null, "channel": null,
        "data": "0/c/b/0/0cb0c0e115dedba676f8d1ad8343ec207ab54c7b_image.jpg" } ] } }'
```

`GET /reference-entities-media-files/{code}` downloads the binary back.

## Linking a product to a record

A product references records through a **product attribute** (created via the normal `/attributes` endpoint, see `catalog-structure.md`) of one of these types:

| Product attribute type | `data` | Links to |
| --- | --- | --- |
| `akeneo_reference_entity` | string (one record code) | a single record |
| `akeneo_reference_entity_collection` | array of record codes | many records |

On the **product** the value uses **`scope`** (product convention) plus `attribute_type` and `reference_data_name` (the reference-entity code):

```json
// PATCH /products/{sku}  — the product value that points at record(s)
{
  "values": {
    "designer": [
      { "locale": null, "scope": null, "data": "bouroullec",
        "attribute_type": "akeneo_reference_entity", "reference_data_name": "designer_ref" }
    ],
    "collections": [
      { "locale": null, "scope": null, "data": ["winter_2019", "spring_2020"],
        "attribute_type": "akeneo_reference_entity_collection", "reference_data_name": "designer_ref" }
    ]
  }
}
```

`reference_data_name` is the reference-entity code the attribute points at. (It's read-only/derived and only present in the SaaS response; you set the linkage by choosing the attribute + putting record codes in `data`.)

---

# Part 2 — Asset Manager (the current asset system)

The **Asset Manager** is the modern way to attach images, videos, and documents to products/product models. Assets are grouped into **asset families** (each family = a template with its own attributes), can carry many files, can **auto-link** to products via product-link rules and naming conventions, and can auto-generate **transformations** (thumbnails, colorspace, etc.). It is EE/Serenity only and **supersedes PAM**.

## The model

```
Asset family                 asset-families/{code}        e.g. "packshots", "model_pictures", "user_guides"
│   { code, labels, attribute_as_main_media,
│     naming_convention, product_link_rules[≤2], transformations[≤10],
│     sharing_enabled, auto_tagging_enabled }
│   (asset attributes are NOT shared between families)
│
├── Asset attribute          …/{code}/attributes/{code}
│   │   types: text, single_option, multiple_options, auto_tagging(*), number,
│   │          media_file, media_link, boolean(SaaS), date(SaaS), record(SaaS)
│   │
│   └── Asset attribute option   …/attributes/{attr}/options/{code}   (single/multiple only)
│
├── Asset                     …/{code}/assets/{code}      e.g. "sku_54628_picture1"
│       { code, asset_family_code, status, start_date, end_date,
│         values: { attr: [ {locale, channel, data, attribute_type} ] }, created, updated }
│
└── media files              asset-media-files            (binaries behind media_file attributes)
```
(*) `auto_tagging` attributes are **created automatically** when the family option is enabled — you cannot create them through the attribute API.

## Endpoints

| Verb & path | Notes |
| --- | --- |
| `GET  /asset-families` / `GET …/{code}` / `PATCH …/{code}` | list / read / **upsert** a family (no POST/DELETE) |
| `GET  /asset-families/{af}/attributes` (+ `/{code}`) | list (≤100, unpaginated) / read |
| `PATCH /asset-families/{af}/attributes/{code}` | upsert an attribute |
| `GET  /asset-families/{af}/attributes/{attr}/options` (+ `/{code}`) | list (≤100) / read |
| `PATCH /asset-families/{af}/attributes/{attr}/options/{code}` | upsert an option |
| `DELETE /asset-families/{af}/attributes/{attr}/options/{code}` | delete an option (SaaS) |
| `GET  /asset-families/{af}/assets` | list (`search_after`, `?channel=&locales=&search=&with_asset_auto_tags=`) |
| `PATCH /asset-families/{af}/assets` | **upsert several assets** — JSON array |
| `GET  /asset-families/{af}/assets/{code}` | one asset |
| `PATCH /asset-families/{af}/assets/{code}` | upsert one asset |
| `DELETE /asset-families/{af}/assets/{code}` | delete an asset |
| `POST /asset-media-files` | upload a media binary (multipart) |
| `GET  /asset-media-files/{code}` | download a media binary |

## Asset family JSON

```json
// PATCH /asset-families/model_pictures
{
  "code": "model_pictures",
  "labels": { "en_US": "Model pictures", "fr_FR": "Photographies en pied" },
  "attribute_as_main_media": "main_image",
  "naming_convention": {
    "source": { "property": "code", "channel": null, "locale": null },
    "pattern": "/(?P<product_ref>.*)-.*/",
    "abort_asset_creation_on_error": true
  },
  "product_link_rules": [
    { "product_selections": [ { "field": "sku", "operator": "EQUALS", "value": "{{product_ref}}" } ],
      "assign_assets_to":  [ { "attribute": "model_pictures", "mode": "replace" } ] }
  ],
  "transformations": [
    { "label": "Thumbnail + B&W", "filename_suffix": "_thumbnailBW",
      "source": { "attribute": "main_image", "channel": null, "locale": null },
      "target": { "attribute": "thumbnail",  "channel": null, "locale": null },
      "operations": [
        { "type": "thumbnail",  "parameters": { "width": 150, "height": 150 } },
        { "type": "colorspace", "parameters": { "colorspace": "grey" } }
      ] }
  ],
  "sharing_enabled": true,
  "auto_tagging_enabled": false
}
```

- **`naming_convention`** extracts data (e.g. a SKU) from the asset code or main-media filename via a named-capture regex, auto-populating non-localizable/non-scopable `text`/`single_option`/`number` attributes on asset creation.
- **`product_link_rules`** (≤2 per family) auto-assign assets to products: a `product_selections` filter (`field`/`operator`/`value`, e.g. `sku = {{product_ref}}`, `categories IN […]`, `family`, `enabled`, `parent`) plus `assign_assets_to` (target `attribute` + `mode` `add`|`replace`). `{{asset_attribute_code}}` **extrapolation** lets one rule adapt per asset (e.g. `"value": "sku_{{product_ref}}_{{main_color}}"`, `"locale": "{{locale}}"`).
- **`transformations`** (≤10) generate derived media_file variations. Operations: `thumbnail`, `scale`, `resize`, `colorspace` (`rgb`/`grey`), `resolution`, `optimize_jpeg` (6.0+). Each needs a `filename_prefix`/`filename_suffix`; two transformations can't share a target attr+channel+locale or a target filename, and a source can't equal another's target.

## Asset attribute types

Same envelope as reference-entity attributes (`code`, `labels`, `type`, `value_per_locale`, `value_per_channel`, `is_required_for_completeness`) plus `is_read_only`, `default_value`, and type-specifics:

```json
// text     — max_characters, is_textarea, is_rich_text_editor, validation_rule/regexp
// number   — plain numeric
// single_option / multiple_options   — options managed via the options endpoint
// boolean (SaaS)   — data is a real bool
// date (SaaS)      — data is an ISO-8601 string
// media_file
{ "code": "picture", "type": "media_file", "media_type": "image",
  "value_per_locale": false, "value_per_channel": false, "is_required_for_completeness": true,
  "is_read_only": false, "allowed_extensions": ["jpg"], "max_file_size": "10" }
//   media_type ∈ image | pdf(4.0+) | other

// media_link  — asset points at an EXTERNAL url (CDN/DAM), not stored in the PIM
{ "code": "media_link", "type": "media_link",
  "value_per_locale": false, "value_per_channel": false, "is_required_for_completeness": false,
  "is_read_only": false, "prefix": "dam.com/my_assets/", "suffix": null, "media_type": "image" }
//   media_type ∈ image | pdf | youtube | vimeo | other  (youtube/vimeo/pdf are 4.0+)

// record (SaaS)  — asset → reference-entity record link
{ "code": "brand", "type": "record",
  "value_per_locale": false, "value_per_channel": false, "is_required_for_completeness": true,
  "is_read_only": false, "reference_entity": "brand" }
```

Options JSON is identical to reference-entity options: `{ "code": "small", "labels": { "en_US": "S" } }`.

## Asset value structure (`{locale, channel, data, attribute_type}`)

Assets use **`channel`** (like records) **plus** an `attribute_type` on each value (SaaS only). A single asset can hold many files (e.g. one PDF per locale).

```json
// PATCH /asset-families/frontview/assets/sku_54628_picture1
{
  "code": "sku_54628_picture1",
  "asset_family_code": "frontview",
  "status": "enabled",
  "start_date": null,
  "end_date": null,
  "values": {
    "media_preview": [
      { "locale": null, "channel": null, "data": "sku_54628_picture1.jpg", "attribute_type": "media_file" }
    ],
    "alt_tag": [
      { "locale": "en_US", "channel": null, "data": "Amor jacket, blue", "attribute_type": "text" },
      { "locale": "fr_FR", "channel": null, "data": "Veste Amor, bleu",  "attribute_type": "text" }
    ],
    "model_is_wearing_size": [
      { "locale": null, "channel": null, "data": "s", "attribute_type": "single_option" }
    ],
    "main_colors": [
      { "locale": null, "channel": null, "data": ["red","purple"], "attribute_type": "multiple_options" }
    ],
    "model_height": [
      { "locale": null, "channel": "ecommerce", "data": "1.65m", "attribute_type": "text" }
    ]
  },
  "created": "2021-05-31T09:23:34+00:00",
  "updated": "2021-05-31T09:23:34+00:00"
}
```

**`data` format per asset-attribute type:** Text/Media file/Single option/Number/Media link/Record → string; Multiple options → array of strings; Boolean → bool; Date → ISO-8601 string. A `record` value's `data` is a reference-entity **record code** (e.g. `"kartell"`).

**Read-only enrichment fields** (SaaS, response only — never PATCH/POST them):
- `_links` on `media_file` values → `{ download: {href}, share_link: {href} }` (`share_link` only if family `sharing_enabled`).
- `linked_data` on `media_link` → `{ full_url, prefix, suffix }` (for youtube/vimeo the `full_url` is expanded from an id); on `media_file` → `{ size, mime_type, extension, original_filename, updated_at }`; on `auto_tags` (when `?with_asset_auto_tags=true`) → per-tag `labels`.

## Asset media files (upload, then reference the code)

Same two-step as record media, on the asset endpoints:

```bash
# 1. Upload the binary (multipart form field "file")
curl -X POST {pim}/api/rest/v1/asset-media-files \
  -H "Authorization: Bearer $TOKEN" -F "file=@sku_54628_picture1.jpg"
# 201 → response header  asset-media-file-code: <code>   (+ Location). Capture <code>.

# 2. PATCH the asset, putting <code> in a media_file value's data
curl -X PATCH {pim}/api/rest/v1/asset-families/frontview/assets/sku_54628_picture1 \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{ "values": { "media_preview": [ { "locale": null, "channel": null,
        "data": "0/0/9/d/009d38fe…_amy_socks_model_picture.png", "attribute_type": "media_file" } ] } }'
```

`media_link` attributes need **no upload** — they just store an external URL fragment as `data`.

## Linking a product to assets

Products/product models reference assets through a product attribute of type **`pim_catalog_asset_collection`** (created via `/attributes`; put it in the relevant **families** — see `catalog-structure.md`). Assign either by API (add asset codes to the value `data`), in the product's *Assets* tab, or automatically via the family's product-link rules.

```json
// PATCH /products/{sku}  — product value pointing at asset codes (product uses "scope")
{
  "values": {
    "model_pictures": [
      { "locale": null, "scope": null,
        "data": ["allie_jean_frontview", "allie_jean_backview"],
        "attribute_type": "pim_catalog_asset_collection",
        "reference_data_name": "packshots" }
    ]
  }
}
```

`reference_data_name` is the **asset family code**. If you have the asset codes but not the family, `GET /attributes/{assetCollectionAttributeCode}` returns the family in its `reference_data_name` property.

---

## Legacy PAM (the old asset system)

`pam.md` documents **PAM** ("Product Asset Management"), the **deprecated** asset system used in PIM **v1.7–3.2 (EE)**. It was **removed in v4.0** — all PAM REST routes are gone from the modern PIM and appear **only in the classic on-prem spec** (`GET/PATCH /assets`, `/asset-categories`, `/asset-tags`, `/assets/{code}/reference-files/…`, `/assets/{code}/variation-files/…`). PAM linked to products via the `pim_assets_collection` product attribute type (note: some SaaS product payloads still show `pim_assets_collection` as the `attribute_type` for the *new* asset collection — the resource is what's deprecated, not necessarily every legacy code path).

**Do not build new integrations on PAM.** Its concepts map onto the Asset Manager: PAM asset categories/tags → `single_option`/`multiple_options` asset attributes; PAM variation files → transformations. If you're on 4.0+/Serenity, PAM simply isn't there. This file's Asset Manager (Part 2) is the **current** system.

## Common pitfalls

| Symptom | Cause | Fix |
| --- | --- | --- |
| `404` on every `reference-entities/*` or `asset-families/*` call | CE instance (or the resource is license-gated) | These are EE/Serenity only. Confirm edition; there is no CE equivalent. |
| `422` on a record/asset value | Sent `scope` instead of **`channel`** | Records and assets use `channel`; only *products* use `scope`. |
| `422` on a product's RE/asset value | Sent `channel` instead of **`scope`**, or omitted `reference_data_name` | Product values use `scope`; the linking attribute types carry `attribute_type` + `reference_data_name`. |
| Image/media "not found" after PATCH | Put a filename in `data` instead of the uploaded **media-file code** | Upload first (`…-media-files`), read the code from the `asset-media-file-code`/`Location` response header, then reference that code. |
| Tried to `POST` to create an entity/family | Only `PATCH` upsert exists | `PATCH /reference-entities/{code}` and `/asset-families/{code}` create-or-update; there's no create/delete for the entity/family. |
| Auto-tagging attribute rejected by the attribute API | `auto_tagging` is system-generated | Enable `auto_tagging_enabled` on the family; you can't create the attribute directly. |
| Attribute/option list "missing" pagination links | ≤100 cap ⇒ not paginated | Attribute and option lists return everything; only *record*/*asset* lists paginate (`search_after`). |
| Expecting the Magento connector to sync these | Community connector doesn't import reference entities/assets | Handle enrichment separately; see the `akeneo-magento2-connector` skill. |

## Original sources

- `references/sources/akeneo-official-docs/concepts/reference-entities.md` — reference entity / attribute / option / record / media-file concepts + record value formats (uses `channel`).
- `references/sources/akeneo-official-docs/concepts/asset-manager.md` — asset family, attribute types, asset value structure, naming convention, product-link rules, transformations, media files, `_links`/`linked_data`.
- `references/sources/akeneo-official-docs/concepts/pam.md` — the deprecated PAM asset system (removed in 4.0).
- `references/sources/akeneo-official-docs/concepts/products.md` (lines ~574–637) — how products point at records/assets: `akeneo_reference_entity`, `akeneo_reference_entity_collection`, `pim_catalog_asset_collection` (product values use `scope` + `reference_data_name`).
- `references/sources/akeneo-official-docs/concepts/catalog-structure.md` (lines ~84–86) — the product attribute types for RE/asset linking.
- `references/sources/postman/akeneo-postman-collection.json` — *Reference entity\**, *Asset family\**, *Asset\** folders: exact routes, PATCH bodies, `multipart/form-data` `file` uploads.
- `references/sources/openapi-specs/saas-openapi.json` + `classic-web-api.json` (via `SPEC-SUMMARY.md`) — endpoint inventory; media-file `POST` = multipart `file` → `201` with `Location` + `asset-media-file-code` headers.
