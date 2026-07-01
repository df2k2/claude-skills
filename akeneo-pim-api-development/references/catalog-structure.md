# Catalog Structure — Families, Attributes, Categories, Channels

Before you can write a single product, you have to model the **catalog structure**: the families, attributes, options, categories, channels, locales and currencies that define what a product *can* say and in which languages/scopes it says it. Reading these resources gives you the codes you need to build valid product `values` (the `{locale, scope, data}` shape lives in `products-and-models.md`); writing them provisions a fresh PIM. This reference covers every catalog-structure resource: its endpoints, its key fields, and a real example.

Everything here is under the standard REST base path `{pim_url}/api/rest/v1/` and authenticated with a Bearer token (see `authentication.md`). Response envelopes, pagination and filtering are described in `rest-api-overview.md`.

## The structure map

```
Channel (scope)            Category tree                 Family  ── attribute_as_label ─┐
  code: ecommerce            master (root)                 code: camcorders             │
  locales:   [en_US, …]  ┌──▶  ├── tvs_projectors          attributes: [ … ] ───────────┤
  currencies:[USD, EUR]  │     └── cameras                 attribute_requirements:      │
  category_tree: master ─┘          └── camcorders           { ecommerce:[…], print:[…] } │
  conversion_units: {…}                                                                  ▼
       │                                                    Attribute  (the vocabulary)
  Locale   en_US, fr_FR, de_DE …  (enable per PIM)            code: name
  Currency USD, EUR …             (enable per PIM)            type: pim_catalog_text
                                                              group: marketing ──▶ Attribute group
  Measurement family  WEIGHT → standard GRAM {units…}         localizable / scopable
       ▲ conversion targets referenced by channel.conversion_units
                                                            Attribute option  (for *select types)
  Family variant   (variation model for a family)             code: red   attribute: color
    variant_attribute_sets: [ {level, axes, attributes} … ]   sort_order  labels{…}
       └─ drives product models + variant products          Association type  upsell / x_sell
```

Products point *into* this structure (family, categories, attribute values); the structure itself is standalone.

## Conventions shared by all these resources

- **Codes are the identity.** Every resource is addressed by a `code` (a locale is `en_US`, a currency `USD`). Codes are immutable once created.
- **`labels` are a locale→string map**, e.g. `{"en_US": "Weight", "fr_FR": "Poids"}`, and are purely cosmetic (UI display). The locale keys must be *activated* locales.
- **Writes are upserts.** `PATCH /{resource}/{code}` **creates or updates** — there is no separate create for most flows (a `POST /{resource}` also exists on SaaS for a strict create). Partial bodies merge.
- **Two write shapes:** a single resource (`PATCH …/{code}`, body = one JSON object) or **bulk** (`PATCH …/{resource}`, body = **newline-delimited JSON**, one object per line, **max 100 lines** per call — see `rest-api-overview.md`). **Exception: measurement families** are bulk-written with a **JSON array**, not NDJSON (details below).
- **List responses are HAL** (`_embedded.items[]` + `_links`), paginated with `page`/`limit` (small settings collections) — big collections like products use `search_after`, but structure collections are small enough for `page`.
- **Availability:** categories, attributes, options, families, locales, channels exist in **all** versions (CE + EE, 1.7→7.x→SaaS). Family variants, attribute groups, association types, currencies arrived in **2.0**. Measurement families (the modern ones) arrived in **5.0**. Items flagged EE below are Enterprise/Serenity only and 404 on CE.

---

## Attributes

An **attribute** is a characteristic of a product (name, description, color, weight, price…). It is the vocabulary of your catalog: products carry *values* for attributes, families group attributes, and the attribute's `type` + `localizable`/`scopable` flags dictate the exact JSON shape of every value.

**Endpoints** (identical on SaaS and classic):

| Method | Path | Purpose |
| --- | --- | --- |
| GET | `/attributes` | List attributes (paginated) |
| GET | `/attributes/{code}` | Get one attribute |
| POST | `/attributes` | Create one (strict create) |
| PATCH | `/attributes/{code}` | Upsert one |
| PATCH | `/attributes` | Upsert several (NDJSON) |

There is **no DELETE** for attributes via the API.

### Attribute types

The `type` field is a fixed enum. These are the **19 types** in the SaaS spec (the concept docs describe them as "up to 13" for older CE builds — the extra ones are EE/Serenity):

| Type (`type` value) | What it is | Value `data` shape (example) | EE-only? |
| --- | --- | --- | --- |
| `pim_catalog_identifier` | Unique product code (SKU/MPN). Mandatory to create a product. | `"SKU-12345"` (string) | |
| `pim_catalog_text` | Single-line text (≤255 by default) | `"T-shirt long sleeves"` | |
| `pim_catalog_textarea` | Multi-line / rich text | `"Long description…"` | |
| `pim_catalog_number` | Numeric | `42.5` | |
| `pim_catalog_boolean` | Yes/No | `true` | |
| `pim_catalog_simpleselect` | Single choice from options | `"black"` (option code) | |
| `pim_catalog_multiselect` | Multiple choices from options | `["summer_2017","winter_2016"]` | |
| `pim_catalog_price_collection` | Price per currency | `[{"amount":"12.50","currency":"USD"},{"amount":10,"currency":"EUR"}]` | |
| `pim_catalog_metric` | Measurement (value+unit) | `{"amount":"800.0000","unit":"GRAM","symbol":"g"}` | |
| `pim_catalog_date` | Date | `"2021-04-29T08:58:00Z"` | |
| `pim_catalog_file` | Uploaded file (csv, doc, pdf…) | `"f/2/e/6/…_myFile.pdf"` (media code) | |
| `pim_catalog_image` | Uploaded image | `"1/d/7/f/…_1356.jpg"` (media code) | |
| `pim_reference_data_simpleselect` | Single choice from *custom reference data* | `"fabricA"` (reference-data code) | needs reference-data bundle |
| `pim_reference_data_multiselect` | Multiple choices from custom reference data | `["fabricA","fabricB"]` | needs reference-data bundle |
| `akeneo_reference_entity` | Single link to a reference-entity record | `"record_code"` | EE |
| `akeneo_reference_entity_collection` | Multiple links to reference-entity records | `["rec_a","rec_b"]` | EE |
| `pim_catalog_asset_collection` | Links to Asset Manager assets | `["left_side","right_side"]` | EE |
| `pim_catalog_product_link` | Unidirectional link to a product/model | `{"type":"product","id":"fc24e6c3-…"}` | |
| `pim_catalog_table` | Multi-column table | `[{"ingredient":"Sugar","quantity":10,"organic":true}]` | Growth + EE |

The `data` column is what shows up inside a product `value` (`values[code] = [{"locale":…,"scope":…,"data":<here>}]`). The authoritative per-type value schemas and their locale/scope rules are documented in **`products-and-models.md`** — this table is the quick map; go there when building product payloads. (Reference-data and reference-entity/asset types are enrichment concepts; see `reference-entities-and-assets.md`.)

### Key attribute fields

| Field | Notes |
| --- | --- |
| `code` * | Immutable identity. |
| `type` * | One of the enum above. |
| `group` * | Attribute group code (attributes must belong to a group). `group_labels` returned since 5.0. |
| `localizable` | `true` ⇒ one value **per locale** (value entries carry a non-null `locale`). Default `false`. |
| `scopable` | `true` ⇒ one value **per channel** (value entries carry a non-null `scope`). Default `false`. |
| `available_locales` | Makes the attribute **locale-specific** (only editable for these locales, e.g. a "Canadian tax" attribute only for `en_CA`/`fr_CA`). |
| `unique` | Two products cannot share the same value (identifier-like). |
| `useable_as_grid_filter` | Whether it appears as a product-grid filter in the UI. |
| `sort_order` | Order within its group. |
| `labels` | locale→label map. |

**Validation / type-specific fields** (most are `null` unless the `type` uses them):

- **Text / textarea:** `max_characters`, `validation_rule` (`email`/`url`/`regexp`), `validation_regexp`, `wysiwyg_enabled` (textarea only).
- **Number / metric:** `number_min`, `number_max`, `decimals_allowed`, `negative_allowed`.
- **Metric:** `metric_family` (a measurement family code) + `default_metric_unit` (a unit code within it) — both required for `pim_catalog_metric`.
- **Date:** `date_min`, `date_max` (ISO date), `display_time`.
- **File / image:** `allowed_extensions` (array), `max_file_size` (MB, string).
- **Reference data / reference entity:** `reference_data_name` (the reference-data or reference-entity code).
- **Identifier:** `is_main_identifier` (which identifier is the primary one, 7.x/SaaS with multiple identifiers).
- **Decimals:** `decimal_places_strategy` (`round`/`forbid`/`trim`) + `decimal_places`.
- **Select import:** `enable_option_creation_during_import` (auto-create options on import).
- **Asset collection:** `max_items_count`.
- **Table:** `table_configuration` (array of column defs — see below).

### Real example — create a date attribute

```http
POST /api/rest/v1/attributes
```
```json
{
  "code": "release_date",
  "type": "pim_catalog_date",
  "group": "marketing",
  "localizable": false,
  "scopable": false,
  "unique": false,
  "useable_as_grid_filter": true,
  "date_min": "2017-06-28T08:00:00",
  "date_max": "2017-08-08T22:00:00",
  "sort_order": 1,
  "labels": { "en_US": "Sale date", "fr_FR": "Date des soldes" }
}
```

A read-back adds every other field as `null` (see the full 30-field shape in `catalog-structure` concept docs). Bulk update is NDJSON — one object per line:

```
{"code":"description","useable_as_grid_filter":true}
{"code":"short_description","group":"marketing"}
{"code":"release_date","date_min":"2017-06-28T08:00:00"}
```

### Table attributes (`pim_catalog_table`)

The columns of a table attribute are defined in `table_configuration` — an array of column objects, each with a unique `code` and a `data_type` (`select`, `text`, `boolean`, `number`, `incremental_number`, `reference_entity`, `product_link`, `measurement`, `date`), plus optional `labels` and validation. **Constraints:** at least **2 columns**, the **first column must be `select`**, up to **10 columns**, and up to **200 000 options** for a select column. Table is a **Growth/Enterprise-only** type.

---

## Attribute options

Options are the available choices for the four "select" attribute types: `pim_catalog_simpleselect`, `pim_catalog_multiselect`, `pim_reference_data_simpleselect`, `pim_reference_data_multiselect`. A product's simpleselect value is an option `code`; a multiselect is an array of option codes.

**Endpoints** — nested under their attribute:

| Method | Path |
| --- | --- |
| GET | `/attributes/{attribute_code}/options` |
| GET | `/attributes/{attribute_code}/options/{code}` |
| POST | `/attributes/{attribute_code}/options` |
| PATCH | `/attributes/{attribute_code}/options/{code}` |
| PATCH | `/attributes/{attribute_code}/options` (NDJSON bulk) |

**Fields:** `code` (option identity), `attribute` (owning attribute code), `sort_order` (int), `labels` (locale→label). Real example:

```json
{
  "code": "black",
  "attribute": "a_simple_select",
  "sort_order": 2,
  "labels": { "en_US": "Black", "fr_FR": "Noir" }
}
```

Note the option `code` is only unique **within its attribute** (two different select attributes can both have a `black` option).

---

## Attribute groups

Attribute groups organize attributes in the UI (the "Marketing" / "Technical" tabs). Every attribute belongs to exactly one group. *(Endpoints available since 2.0.)*

**Endpoints:** GET `/attribute-groups`, GET `/attribute-groups/{code}`, POST `/attribute-groups`, PATCH `/attribute-groups/{code}`, PATCH `/attribute-groups` (NDJSON).

**Fields:** `code` *, `sort_order` (int, order among groups), `attributes` (array of member attribute codes), `labels`.

```json
{
  "code": "marketing",
  "sort_order": 4,
  "attributes": ["sku","name","description","release_date","price"],
  "labels": { "en_US": "Marketing", "fr_FR": "Marketing" }
}
```

---

## Families

A **family** is a template: the set of attributes a product of that family inherits, which attribute is its label/image, and which attributes are **required for completeness** per channel. A product belongs to **at most one** family (and may have none).

**Endpoints:** GET `/families`, GET `/families/{code}`, POST `/families`, PATCH `/families/{code}`, PATCH `/families` (NDJSON), **DELETE** `/families/{code}` (families are one of the few structure resources with a DELETE).

**Key fields:**

| Field | Notes |
| --- | --- |
| `code` * | Family identity. |
| `attributes` | Array of attribute codes composing the family. |
| `attribute_as_label` * | Attribute used as the product label (usually a text attr like `name`). |
| `attribute_as_image` | Attribute used as the main picture (an image attr), or `null`. |
| `attribute_requirements` | **Object keyed by channel code** → array of attribute codes required for completeness on that channel. |
| `labels` | locale→label. |
| `parent` | Parent family code, or `null`. (Family inheritance; usually `null`.) |

```json
{
  "code": "caps",
  "attributes": ["sku","name","description","price","color","picture","material"],
  "attribute_as_label": "name",
  "attribute_as_image": "picture",
  "attribute_requirements": {
    "ecommerce": ["sku","name","description","price","color"],
    "tablet":    ["sku","name","description","price"]
  },
  "labels": { "en_US": "Caps", "fr_FR": "Casquettes" },
  "parent": null
}
```

The channel keys in `attribute_requirements` must be **existing channel codes** — this is how completeness is computed per scope.

---

## Family variants

A **family variant** models products-with-variants for a given family: how many **variation levels** (1 or 2), the **axes** (attributes that distinguish variants, e.g. `color`, `size`), and how attributes are distributed between levels. It is the schema behind *product models* and *variant products* (see `products-and-models.md`). *(Endpoints available since 2.0; CE + EE.)*

**Endpoints** — nested under the family:

| Method | Path |
| --- | --- |
| GET | `/families/{family_code}/variants` |
| GET | `/families/{family_code}/variants/{code}` |
| POST | `/families/{family_code}/variants` |
| PATCH | `/families/{family_code}/variants/{code}` |
| PATCH | `/families/{family_code}/variants` (NDJSON) |

**Fields:** `code` *, `labels`, `common_attributes` (attributes shared across all variants, read-side default `[]`), and `variant_attribute_sets` * — an array of **enrichment levels**, each `{ "level": <1|2>, "axes": [attr codes], "attributes": [attr codes] }`.

```json
{
  "code": "shoesVariant",
  "labels": { "en_US": "Shoes variant", "fr_FR": "Variante de chaussures" },
  "variant_attribute_sets": [
    { "level": 1, "axes": ["color"], "attributes": ["color","material"] },
    { "level": 2, "axes": ["size"],  "attributes": ["sku","size"] }
  ]
}
```

Here level 1 (the product model) varies by `color`; level 2 (the variant products) varies by `size`. Axes attributes must be attribute types allowed as axes (simpleselect, boolean, metric, identifier, reference data). There is no DELETE for family variants via the API.

---

## Association types

An **association type** names the nature of a product-to-product relationship (upsell, cross-sell, substitution…). Two boolean flags shape its behavior. *(Since 2.0.)*

**Endpoints:** GET `/association-types`, GET `/association-types/{code}`, POST `/association-types`, PATCH `/association-types/{code}`, PATCH `/association-types` (NDJSON).

**Fields:**

| Field | Notes |
| --- | --- |
| `code` * | Identity. |
| `labels` | locale→label. |
| `is_two_way` | `true` ⇒ bidirectional: associating A→B implies B→A. Default `false`. |
| `is_quantified` | `true` ⇒ associations carry a **quantity** (e.g. bill-of-materials); product payloads then use `quantified_associations`. Default `false`. |

```json
{
  "code": "upsell",
  "labels": { "en_US": "Upsell", "fr_FR": "Vente incitative" },
  "is_quantified": false,
  "is_two_way": false
}
```

Both flags are present in the classic (CE/EE) spec as well as SaaS.

---

## Categories

A **category** classifies products. Categories form **trees** (root category = the tree; unlimited depth). A product can be classified in one or many categories. Channels bind to exactly one category tree via `category_tree`.

**Endpoints:** GET `/categories`, GET `/categories/{code}`, POST `/categories`, PATCH `/categories/{code}`, PATCH `/categories` (NDJSON). SaaS also has `POST /category-media-files` + `GET /category-media-files/{file_path}/download` for enriched-category media.

**Core fields:** `code` *, `parent` (parent category code, or `null` for a root), `labels`, `updated` (read-only), `position` (order within its level, **only returned when you pass `?with_position=true`**).

```json
// Root category (the tree itself)
{ "code": "master", "parent": null,
  "labels": { "en_US": "Master catalog", "fr_FR": "Catalogue principal" } }
```
```json
// A subcategory
{ "code": "tvs_projectors", "parent": "master",
  "labels": { "en_US": "TVs and projectors", "fr_FR": "Téléviseurs et projecteurs" } }
```

Bulk create/update is NDJSON; a child references its parent's code:

```
{"code":"spring_collection","parent":null}
{"code":"woman","parent":"spring_collection"}
{"code":"man","parent":"spring_collection"}
```

### Enriched categories (EE / Serenity)

Newer PIMs (7.0/SaaS, EE) let categories carry **attribute values**, **completeness requirements** and **validations** — "category enrichment". These extra fields are returned only when you request `?with_enriched_attributes=true`:

- `values` — a map of category attribute values, each `{ "data": …, "channel": …, "locale": …, "attribute_code": … }` (localizable/scopable like product values).
- `channel_requirements` — channel codes on which the category is required for product completeness.
- `validations` (root categories only) — `max_categories_per_product`, `only_leaves`, `is_mandatory`.

```json
{
  "code": "winter_collection",
  "parent": null,
  "labels": { "en_US": "Winter collection", "fr_FR": "Collection hiver" },
  "values": [
    { "data": "<p>Winter collection description</p>", "channel": "ecommerce", "locale": "en_US", "attribute_code": "a_text_area_attribute" },
    { "data": true, "channel": "ecommerce", "locale": "en_US", "attribute_code": "a_boolean_attribute" }
  ],
  "channel_requirements": ["ecommerce","mobile"],
  "validations": { "max_categories_per_product": 42, "only_leaves": false, "is_mandatory": true }
}
```

---

## Channels

A **channel** (a.k.a. **scope**) is a distribution target — a website, a print catalog, a mobile app. It defines which **locales** and **currencies** are in play, which **category tree** it exports, and how measurement values are **converted**. A scopable attribute has one value per channel; the channel code is exactly the `scope` in a product value.

**Endpoints:** GET `/channels`, GET `/channels/{code}`, POST `/channels`, PATCH `/channels/{code}`, PATCH `/channels` (NDJSON).

**Fields:**

| Field | Notes |
| --- | --- |
| `code` * | Channel/scope identity. |
| `locales` | Activated locale codes for this channel. |
| `currencies` | Activated currency codes for this channel. |
| `category_tree` | Root category code the channel exports. |
| `conversion_units` | Which unit to convert each metric attribute into for this channel (see below). |
| `labels` | locale→label. |

```json
{
  "code": "ecommerce",
  "currencies": ["USD","EUR"],
  "locales": ["de_DE","en_US","fr_FR"],
  "category_tree": "master",
  "conversion_units": { "weight": "KILOGRAM" },
  "labels": { "en_US": "Ecommerce", "de_DE": "Ecommerce", "fr_FR": "E-commerce" }
}
```

**`conversion_units`** maps an attribute code → target unit code (`{"weight":"KILOGRAM"}`). On EE/Serenity it also supports advanced rules keyed by measurement-family + locale (`pim_config_family_rules`) or attribute + locale (`pim_config_attribute_locale_rules`), each cell being either a unit string or `{ "unit", "decimal_places_strategy": "round"|"trim", "decimal_places": 1-4 }`. To actually receive converted values, request products with `?scope={channel}&convert_measurements=true` (the `scope` param is mandatory then).

---

## Locales

A **locale** is language + country (`en_US`, `fr_FR`, `de_DE`). Locales are **read-only via the API** — you activate/deactivate them in the PIM UI; you can only list/get them. A locale is `enabled` globally, and separately *bound to channels* (a locale is only usable where a channel lists it).

**Endpoints:** GET `/locales`, GET `/locales/{code}`. **Fields:** `code`, `enabled` (boolean).

```json
{ "code": "en_US", "enabled": true }
```

Locale codes are what appear as the `locale` key inside a *localizable* attribute's value entries and in every `labels` map.

---

## Currencies

A **currency** (`USD`, `EUR`…) enables price storage. Like locales, currencies are **read-only via the API** (managed in the UI); a currency is activated per channel via `channel.currencies`. *(Endpoints since 2.0.)*

**Endpoints:** GET `/currencies`, GET `/currencies/{code}`. **Fields:** `code`, `enabled` (boolean), `label`.

```json
{ "code": "EUR", "enabled": true, "label": "Euro" }
```

Currency codes are what appear inside `pim_catalog_price_collection` value data (`{"amount":"12.50","currency":"USD"}`).

---

## Measurement families (and the deprecated measure families)

A **measurement family** groups convertible units for one physical dimension (Weight, Area, Temperature…). It names a **standard unit** and, for every other unit, the operations to convert *from* the standard. This is what powers `pim_catalog_metric` attributes and channel `conversion_units`. *(Modern endpoints since 5.0; CE + EE.)*

**Endpoints** (note the limited surface):

| Method | Path | Notes |
| --- | --- | --- |
| GET | `/measurement-families` | List **all** families — **not paginated** (hard cap: ≤100 families, ≤50 units each). |
| PATCH | `/measurement-families` | Bulk create/update — **body is a JSON array**, *not* NDLJSON. |

There is **no** single-GET, POST, or DELETE for measurement families. Writes go only through the bulk array PATCH.

**Fields:** `code` *, `labels`, `standard_unit_code` * (must be one of the `units`), and `units` * — an **object keyed by unit code**, each `{ code, labels, symbol, convert_from_standard: [ {operator, value} … ] }`. Operators: `add`, `sub`, `mul`, `div`; 1–5 operations per unit, applied **in order**.

```json
[
  {
    "code": "AREA",
    "labels": { "en_US": "Area", "fr_FR": "Surface" },
    "standard_unit_code": "SQUARE_METER",
    "units": {
      "SQUARE_METER": {
        "code": "SQUARE_METER", "symbol": "m²",
        "labels": { "en_US": "Square meter" },
        "convert_from_standard": [ { "operator": "mul", "value": "1" } ]
      },
      "SQUARE_MILLIMETER": {
        "code": "SQUARE_MILLIMETER", "symbol": "mm²",
        "labels": { "en_US": "Square millimeter" },
        "convert_from_standard": [ { "operator": "mul", "value": "0.000001" } ]
      }
    }
  }
]
```

Multi-step example (Fahrenheit → standard Kelvin needs three ordered ops): `sub 32`, `div 1.8`, `add 273.15`.

**Deprecated "measure families"** (`GET /measure-families`, `GET /measure-families/{code}`) exist **only in the classic CE/EE spec** and are **deprecated as of 5.0**. Their read shape differs: a flat `units` **array** of `{ code, convert: {mul: "…"}, symbol }` with a `standard` field. Prefer `measurement-families` on any 5.0+ instance; the deprecated ones are read-only and can't be created via API.

---

## Localizable / scopable — why this section matters for products

The whole reason to read catalog structure before writing products is to get the **locale/scope contract** right (the #1 source of 422s):

- An attribute's **`localizable`** flag decides whether each product value carries a non-null `locale`; **`scopable`** decides `scope`. Reading `/attributes/{code}` tells you which.
- The **valid `locale` values** are the activated locales (`/locales`) — and, for a scoped write, only locales that the target **channel** lists.
- The **valid `scope` values** are channel codes (`/channels`).
- **`available_locales`** on an attribute further restricts a locale-specific attribute.
- **Currencies** constrain `price_collection` data; **metric units** must belong to the attribute's `metric_family`.

Get these four codes lists (attributes, locales, channels, currencies) first; then build product `values` per `products-and-models.md`.

## Common pitfalls

| Symptom | Cause | Fix |
| --- | --- | --- |
| `404` on `/reference-entities`, table attr rejected, asset_collection missing | EE/Serenity-only feature on a CE instance | Confirm edition; those types/resources don't exist on Community. |
| `422` "attribute … is not localizable/scopable" | Product value has a `locale`/`scope` the attribute's flags forbid (or omits one it requires) | Read `/attributes/{code}`; match `localizable`/`scopable` exactly. |
| Measurement-family bulk PATCH rejected as malformed | Sent NDJSON like other bulk endpoints | Measurement families take a **JSON array**, not newline-delimited objects. |
| Family `attribute_requirements` ignored | Keyed by a non-existent channel code | Keys must be existing channel codes; create channels first. |
| Category `position` always absent | Not requested | Add `?with_position=true` (and `?with_enriched_attributes=true` for `values`). |
| Can't create a locale/currency via API | They're read-only over REST | Activate in the PIM UI (or via channel binding); the API only lists/gets them. |
| Deprecated `/measure-families` 404 on SaaS | Only in the classic CE/EE spec | Use `/measurement-families` on 5.0+/Serenity. |
| Option code "collides" across attributes | Assumed global uniqueness | Option `code` is unique only within its attribute. |

## Original sources

- `references/sources/akeneo-official-docs/concepts/catalog-structure.md` — Category, Attribute (types table), Attribute option, Family, Family variant, Attribute group, Association type (concept + JSON formats).
- `references/sources/akeneo-official-docs/concepts/target-market-settings.md` — Locale, Channel, `conversion_units`, Currency, Measure family (deprecated) and Measurement family (units/operators).
- `references/sources/openapi-specs/saas-openapi.json` — authoritative schemas: `family`, `family_variant`, `attribute` (full `type` enum + validation fields), `attribute_option`, `attribute_group`, `association_type`, `category` (+ `values`/`validations`/`position`), `channel`, `locale`, `currency`, `measurement_family_upsert`, and the `pim_catalog_*` value schemas.
- `references/sources/openapi-specs/classic-web-api.json` — classic CE/EE surface: `MeasureFamily` (deprecated), `Locale`/`Currency` (`enabled`), classic `Category`/`AssociationType`.
- `references/sources/openapi-specs/SPEC-SUMMARY.md` — flat endpoint catalog for both specs.
- `references/sources/postman/akeneo-postman-collection.json` — real request bodies (folders: Family, Family variant, Attribute, Attribute option, Attribute group, Association type, Category, Channel, Measurement family).
- Cross-references: `products-and-models.md` (per-type value `data` shapes, `{locale,scope,data}`), `rest-api-overview.md` (pagination, bulk NDJSON, HAL envelopes), `reference-entities-and-assets.md` (EE reference-entity / asset attribute types).
