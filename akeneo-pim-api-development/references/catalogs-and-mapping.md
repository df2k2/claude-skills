# Catalogs & Product Mapping (Apps)

**Catalogs** are the data-sharing surface between an Akeneo PIM and an **App**. A catalog is an *App-scoped, user-curated, filtered selection of products* that the App reads through `{pim_url}/api/rest/v1/catalogs/*`. Optionally, the App attaches a **product mapping schema** — a JSON Schema describing the product shape the App wants — so the PIM returns product data pre-formatted to the App's target structure.

This is an **Apps feature only** (authorization-code / `code_challenge` flow — see `apps-and-connections.md` and `authentication.md`). It is **not** available to classic Connections and does **not** appear in the classic Swagger 2.0 spec; the endpoints live only in the SaaS/Serenity OpenAPI (`references/sources/openapi-specs/saas-openapi.json`, tags **Catalogs**, **Catalog products**, **Mapping schema for products**). The concept guide is `references/sources/akeneo-official-docs/apps/catalogs.md`; the meta-schemas are under `references/sources/akeneo-official-docs/mapping/product/`.

## Why catalogs exist

Normally an integration must build and maintain its own product-filtering UI and understand the whole PIM structure to let a user say "sync *these* products." Catalogs push that job into the PIM:

- **The PIM owns the filter UI.** Akeneo users pick the product selection (by family, category, etc.) inside Akeneo Product Cloud — your App ships no filtering interface.
- **You read only what the App needs.** Requesting a catalog's products returns just that curated selection.
- **You don't have to master the PIM's data model** to give users a relevant selection screen — the PIM already renders it.

The selection **criteria live PIM-side and are user-configured**; they are *not* set or returned through the catalog API object (which exposes only `name`, `enabled`, `managed_locales`, `managed_currencies`). Your App creates the empty catalog; the user fills in the selection and enables it.

### Scopes (request during app authorization)

Managing catalogs needs at least four scopes (see `apps-and-connections.md`):

| Scope | Grants |
| --- | --- |
| `read_products` | read product data behind a catalog |
| `read_catalogs` | list/get catalogs and their status |
| `write_catalogs` | create/update catalogs and push mapping schemas |
| `delete_catalogs` | delete catalogs |

### Limits

- **200 catalogs** per App.
- **25 selection criteria** per product selection.
- **600 targets** per product mapping schema (the config UI gets sluggish above **200**).

## Catalog lifecycle endpoints

All paths are under `{pim_url}/api/rest/v1/` (base path + auth: see `rest-api-overview.md`).

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/catalogs` | List the catalogs your App owns (`page`/`limit` pagination) |
| POST | `/catalogs` | Create a catalog → returns its **UUID** (`id`). Disabled by default |
| GET | `/catalogs/{id}` | Get one catalog — read `enabled` here to check status |
| PATCH | `/catalogs/{id}` | Update `name` / `managed_locales` / `managed_currencies` |
| DELETE | `/catalogs/{id}` | Delete a catalog |
| POST | `/catalogs/{id}/duplicate` | Duplicate a catalog (selection + mapping) |

### The catalog object

`GET /catalogs/{id}` (schema `catalog`):

```json
{
  "id": "12351d98-200e-4bbc-aa19-7fdda1bd14f2",
  "name": "My app catalog",
  "enabled": false,
  "managed_currencies": ["EUR", "USD", "GBP"],
  "managed_locales": ["fr_FR", "en_US"]
}
```

- `id` — catalog UUID, immutable; you use it in every subsequent call.
- `enabled` — `false` until a **PIM user** enables it (see below).
- `managed_locales` / `managed_currencies` — the locale/currency codes the App declares it will consume; the PIM uses them to scope returned values. Both optional.
- The **product selection criteria are not part of this payload** — they are configured and stored PIM-side by the user.

**Create** (`POST /catalogs`, schema `catalog_create`) requires only `name`:

```json
{
  "name": "My app catalog",
  "managed_currencies": ["EUR", "USD", "GBP"],
  "managed_locales": ["fr_FR", "en_US"]
}
```

**Duplicate** (`POST /catalogs/{id}/duplicate`) accepts an optional new `name`, `managed_locales`/`managed_currencies`, `skip_required_checks`, and `replace_mapping_locales_with` (rewrites every locale code in the copied mapping to one locale — handy for cloning a catalog to a new market).

### "Disabled until valid" behavior

Two facts to design around:

1. **New catalogs start disabled.** Only a PIM user can enable one — your App cannot self-enable. Until it is enabled you cannot retrieve products. Send the user to the in-PIM configuration screen:

   ```
   https://my-pim.cloud.akeneo.com/connect/apps/v1/catalogs/{catalog_uuid}
   ```

   Then poll `GET /catalogs/{id}` and wait for `"enabled": true`.

2. **The PIM auto-disables an invalid selection.** If the selection becomes invalid (e.g., a selected category is deleted), the PIM disables the catalog. Product reads then return **HTTP 200** (not an error status) whose body carries an `error` field:

   ```json
   {
     "error": "No products to synchronize. The catalog \"65f5a521-e65c-4d7b-8be8-1f267fa2729c\" has been disabled on the PIM side. Note that you can get catalogs status with the GET /api/rest/v1/catalogs endpoint."
   }
   ```

   Always check for an `error` key in a 200 body before treating the payload as products, then re-check `enabled` and prompt the user to fix the selection.

## Reading catalog products

Once a catalog is enabled, page through its products. All list endpoints are HAL — `_links` (`self`/`first`/`next`/`previous`) + `_embedded.items` — and use **`search_after`** cursor pagination with `limit`, plus `updated_before` / `updated_after` (ISO-8601) for delta syncs. See `rest-api-overview.md` for the shared pagination model.

| Verb | Path | Returns |
| --- | --- | --- |
| GET | `/catalogs/{id}/products` | Full PIM product payloads in the selection |
| GET | `/catalogs/{id}/products/{uuid}` | One product (by UUID) in the catalog |
| GET | `/catalogs/{id}/product-uuids` | Just the UUIDs (lightest; supports `with_count`) |
| GET | `/catalogs/{id}/mapped-products` | Products **shaped by your mapping schema** (mapping must be enabled) |
| GET | `/catalogs/{id}/mapped-models` | Mapped **models** (models/variants mapping mode) |
| GET | `/catalogs/{id}/mapped-models/{model_code}/variants` | Mapped **variants** of one model |

`/products` returns the standard product shape (same `values: {attr: [{locale, scope, data}]}` structure documented in `products-and-models.md`):

```json
{
  "_links": { "self": {...}, "first": {...}, "next": {...} },
  "_embedded": { "items": [
    {
      "uuid": "00073089-1310-4340-bcf0-9e33e4019b79",
      "enabled": true,
      "family": "mens_clothing",
      "categories": ["Cloths"],
      "groups": [],
      "values": {
        "Name":   [{ "data": "Product 416", "locale": null, "scope": null }],
        "Weight": [{ "data": { "amount": 10, "unit": "KILOGRAM" }, "locale": null, "scope": null }]
      },
      "created": "2022-03-14T15:25:45+00:00",
      "updated": "2022-06-24T12:54:58+00:00",
      "associations": { "PACK": { "products": [], "product_models": [], "groups": [] } }
    }
  ]}
}
```

`/product-uuids` is the cheapest way to enumerate a selection and diff it against your local store:

```json
{
  "_links": { "next": { "href": ".../product-uuids?search_after=eddfbd2a-...&with_count=true" } },
  "items_count": 10,
  "_embedded": { "items": [
    "844c736b-a19b-48a6-a354-6056044729f0",
    "b2a683ef-4a91-4ed3-b3fa-76dab065a8d5"
  ]}
}
```

## The product mapping schema

Reading raw PIM products means re-implementing Akeneo's value model on your side. The **product mapping** feature lets your App instead publish a **JSON Schema of the shape it wants**; the PIM user binds each of your targets to a PIM source, and `/mapped-*` endpoints return data already in your structure.

### What it is

A product mapping schema is a [JSON Schema](https://json-schema.org) document (the meta-schema is Draft 2020-12) that:

- declares `"$schema"` — the Akeneo **meta-schema version** your App targets, e.g. `https://api.akeneo.com/mapping/product/1.0.4/schema`;
- sets `"type": "object"` (required — the output is a JSON object);
- lists the **targets** you want under `"properties"`.

Minimal valid skeleton:

```json
{
  "$schema": "https://api.akeneo.com/mapping/product/1.0.4/schema",
  "type": "object",
  "properties": {
    "uuid": { "type": "string" },
    "name": { "title": "Product name", "type": "string" }
  }
}
```

- The **`uuid` target (type `string`) is mandatory** — a special target auto-mapped PIM-side.
- Every other target needs at least a `type`. `title` is optional but recommended: it becomes the field's **label in the mapping UI** the PIM renders for the user.

### Target descriptor structure (`type` / `format` / validation / `metadata`)

Each entry under `properties` is a **target descriptor** built from JSON-Schema keywords the Akeneo meta-schema whitelists:

| Keyword | Role |
| --- | --- |
| `type` | `string` \| `number` \| `boolean` \| `array` \| `object` |
| `title` | Human label shown in the PIM mapping screen |
| `description` | Longer help text |
| `format` | Value format hint — the meta-schema allows **`uri`**, **`regex`**, **`date-time`** |
| `pattern` / `minLength` / `maxLength` / `minimum` / `maximum` | Standard JSON-Schema validation constraints |
| `enum` | Allowed values — plain scalars, or `{ "code": ..., "value": ... }` objects to expose a code/label pair |
| `enumLink` | URL to an external option list (e.g. a spreadsheet) instead of an inline `enum` |
| `items` | Element descriptor when `type` is `array` |
| `properties` / `required` | Nested object shape (used for prices `{amount,currency}`, localized `{locale,value}` pairs, model/variant structures) |
| `metadata` | *(meta-schema 1.0.4+)* free-form `object` of string values attached to a target |

> **The App publishes the target *shape*, not the source binding.** Which PIM attribute (with its locale/scope) feeds each target is chosen by the **Akeneo user** in the mapping screen the PIM builds from your schema — *"We use your product mapping schema to display a screen where your users will configure their catalog."* That attribute→target binding is **not** sent by the App and is **not** exposed through the mapping-schema API; the API only stores/returns the JSON Schema of targets. Design targets whose `type`/`format`/`enum` make the intended source obvious to the user.

> **Empty values are omitted.** When a mapped PIM attribute is empty for a product, its target key is simply absent from the `/mapped-*` response — code defensively for missing keys.

### Special targets

Three copy-paste targets pull PIM-native structures (grab them from the version's `example` file):

- `pim_associations` — the product's associations (PACK/UPSELL/…), with associated products/models and quantities.
- `pim_parent` — the product's **parent** product model.
- `pim_root` — the product's **root** product model.

### Two mapping modes

The meta-schema's `properties` is a `oneOf` of two shapes, which selects how `/mapped-*` behaves:

- **Flat products mode** — a flat list of targets. `GET /mapped-products` returns fully **flattened products**.
- **Products-with-variants mode** — targets split across a model level and a `variants` level. `GET /mapped-models` returns the models and `GET /mapped-models/{model_code}/variants` (or the `variants` URI inlined in each model) returns their variants; `GET /mapped-products` returns the simple (non-variant) products.

A trimmed real mapping schema (adapted from `mapping/product/1.0.3/example`) showing scalars, arrays, enums, an `enumLink`, a localized array, and `pim_associations`:

```json
{
  "$id": "https://example.com/product",
  "$schema": "https://api.akeneo.com/mapping/product/1.0.3/schema",
  "type": "object",
  "properties": {
    "code":        { "title": "Model ID",            "type": "string" },
    "brand":       { "title": "Brand name",          "type": "string" },
    "description": { "title": "Product description", "type": "string" },
    "fabrics":     { "title": "Fabrics", "type": "array", "items": { "type": "string" } },
    "colors": {
      "type": "array",
      "items": { "type": "string", "enum": ["Red", "Green", "Blue", "Black", "White"] }
    },
    "colorCodes": {
      "title": "Color Codes",
      "type": "array",
      "items": { "type": "string", "enumLink": "https://docs.google.com/spreadsheets/d/1gqPrZy..." }
    },
    "localized_names": {
      "title": "Name with multiple locales",
      "type": "array",
      "items": {
        "type": "object",
        "properties": { "locale": { "type": "string" }, "value": { "type": "string" } },
        "required": ["locale", "value"]
      }
    },
    "pim_associations": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "code": { "type": "string" },
          "associated_objects": {
            "type": "array",
            "items": { "oneOf": [
              { "type": "object", "properties": { "type": { "const": "model" },   "code": { "type": "string" } }, "required": ["type", "code"] },
              { "type": "object", "properties": { "type": { "const": "product" }, "uuid": { "type": "string" } }, "required": ["type", "uuid"] }
            ]}
          }
        }
      }
    }
  }
}
```

A resulting `/mapped-products` item is exactly your target keys:

```json
{ "_embedded": { "items": [
  { "uuid": "04f47a54-8cc9-4c51-90e9-eb9aace0865f", "title": "Canon Video Visualiser RE-455X", "code": "sku-1234" }
]}}
```

### Mapping schema endpoints

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/catalogs/{id}/mapping-schemas/product` | Fetch the schema currently attached to a catalog |
| PUT | `/catalogs/{id}/mapping-schemas/product` | **Create or update** the catalog's product mapping schema (body = the JSON Schema) |
| DELETE | `/catalogs/{id}/mapping-schemas/product` | Remove the schema (catalog falls back to raw `/products`) |

`PUT` takes the full schema document as the body (schema `catalog_mapping_schema`; `$schema` + `properties` required). Validate against the meta-schema before pushing — Akeneo publishes an online validator pre-loaded with the meta-schema, or validate locally against `references/sources/akeneo-official-docs/mapping/product/{version}/schema`.

### Meta-schema versions on disk

Under `references/sources/akeneo-official-docs/mapping/product/` (each folder is a `schema` meta-schema, some with an `example`): **`0.0.1`–`0.0.13`, `0.1.0`, `0.2.0`, `0.3.0`, `1.0.0`, `1.0.1`, `1.0.2`, `1.0.3`, `1.0.4`**. Pin the `$schema` version your App was built against.

| Version | Notable addition |
| --- | --- |
| `0.0.1` | Minimal — string targets only |
| `0.1.0` | `boolean` type, `date-time` format |
| `1.0.0` | First `1.x` stable; `enum` as `{code, value}` objects; `uuid` mandatory target |
| `1.0.1` | `pim_associations` special target |
| `1.0.2` | `enumLink` (external option lists) |
| `1.0.3` | `pim_root` / `pim_parent` special targets |
| `1.0.4` | **latest** — target-level `metadata` object |

> The prose in `apps/catalogs.md` calls **1.0.3 (May 2024)** the "latest" and links its `example`; **1.0.4** is present on disk and is the newest meta-schema (adds `metadata`). The `saas-openapi.json` `catalog_mapping_schema` example still shows `1.0.0`. Any `1.0.x` is accepted; use the newest whose features you need.

## End-to-end: how an App uses catalogs + mapping

1. **Request scopes** `read_products read_catalogs write_catalogs delete_catalogs` when the user authorizes the App (`apps-and-connections.md`).
2. **Create a catalog** — `POST /catalogs` `{ "name": "..." }` → keep the returned `id` (UUID). It is disabled.
3. **(Optional) push a mapping schema** — `PUT /catalogs/{id}/mapping-schemas/product` with your JSON Schema of targets.
4. **Send the user to configure it** — redirect to `{pim}/connect/apps/v1/catalogs/{id}`. There the user sets the product selection (up to 25 criteria) and, if you pushed a schema, binds each target to a PIM attribute, then clicks **Enable catalog**.
5. **Wait for enablement** — poll `GET /catalogs/{id}` until `"enabled": true`.
6. **Read products** — `GET /catalogs/{id}/mapped-products` (App-shaped) if you mapped, else `GET /catalogs/{id}/products`; use `GET /catalogs/{id}/product-uuids` to enumerate/diff cheaply.
7. **Sync deltas** — re-poll with `updated_after` (+ `search_after` to page). See `rest-api-overview.md`.
8. **Stay resilient** — on any read, check for an `error` key in a 200 body (auto-disabled selection), re-check `enabled`, and prompt the user to fix the catalog.

## Quick reference

| Use case | Endpoint |
| --- | --- |
| Create a catalog | `POST /catalogs` |
| Check if enabled | `GET /catalogs/{id}` → `enabled` |
| Push target schema | `PUT /catalogs/{id}/mapping-schemas/product` |
| List curated products (raw) | `GET /catalogs/{id}/products` |
| List just UUIDs | `GET /catalogs/{id}/product-uuids?with_count=true` |
| List App-shaped products | `GET /catalogs/{id}/mapped-products` |
| List mapped models / variants | `GET /catalogs/{id}/mapped-models` · `.../mapped-models/{code}/variants` |
| Send user to config UI | `{pim}/connect/apps/v1/catalogs/{id}` |

## Original sources

- `references/sources/akeneo-official-docs/apps/catalogs.md` — the Catalogs-for-Apps concept guide (why, scopes, limits, disabled-until-valid, auto-deactivation payload, mapping walkthrough).
- `references/sources/akeneo-official-docs/mapping/product/{0.0.1…1.0.4}/schema` (+ `1.0.0/example`, `1.0.3/example`) — the versioned product mapping meta-schemas and example schemas; **1.0.4** is the latest.
- `references/sources/openapi-specs/saas-openapi.json` — SaaS OpenAPI 3.1.0; tags **Catalogs**, **Catalog products**, **Mapping schema for products**; schemas `catalog`, `catalog_create`, `catalog_upsert`, `catalog_duplicate`, `catalog_mapping_schema` (source of the request/response examples above). Catalogs are **absent** from `classic-web-api.json` (Apps-only).
- `references/sources/postman/akeneo-postman-collection.json` — folders *Catalogs*, *Catalog products*, *Mapping schema for products* (runnable request bodies + query params).
- `references/sources/openapi-specs/SPEC-SUMMARY.md` — flat operation catalog.
- Related: `apps-and-connections.md` (App OAuth + scopes), `authentication.md` (auth models), `products-and-models.md` (the `{locale,scope,data}` value shape returned by `/products`), `rest-api-overview.md` (HAL + `search_after` pagination).
