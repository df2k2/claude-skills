# 11 — Countries and Localization

## Country and state codes

Printful uses ISO 3166 codes everywhere addresses are involved.

| Code | Standard | Example |
|---|---|---|
| `country_code` | ISO-3166-1 alpha-2 (two uppercase letters) | `US`, `GB`, `DE`, `JP` |
| `state_code` | ISO-3166-2 subdivision without country prefix | `CA` (California), `ON` (Ontario), `NSW` (New South Wales), `13` (Tokyo) |

`state_code` is **required** for orders shipping to `US`, `CA`, `AU`, and `JP`. For all other countries, omit it (sending one for, e.g. Germany returns a `422`).

## `GET /v2/countries`

Returns every country Printful ships to, with state/region subdivisions:

```bash
curl https://api.printful.com/v2/countries -H "Authorization: Bearer $PF_TOKEN"
```

```json
{
  "data": [
    {
      "code": "US",
      "name": "United States",
      "region": "north_america",
      "states": [
        { "code": "AL", "name": "Alabama" },
        { "code": "AK", "name": "Alaska" },
        { "code": "CA", "name": "California" },
        … 50 entries …
      ]
    },
    {
      "code": "DE",
      "name": "Germany",
      "region": "europe",
      "states": []
    },
    …
  ]
}
```

Cache the response — it changes when Printful adds/drops a country (rare).

## v1 — `GET /countries`

Same content under the v1 envelope:

```json
{
  "code": 200,
  "result": [
    { "code": "US", "name": "United States", "states": [ { "code": "CA", "name": "California" } ] },
    …
  ]
}
```

The v1 response **does not include the `region` field**. v2 adds it (used for catalog selling-region filtering).

## Language localization

Some response strings are translatable: product names, product descriptions, category names, type labels, mockup style names, shipping service names, and a few size-guide entries. Numeric IDs, codes, and structural fields are not translated.

Trigger translation by sending the **`X-PF-Language`** header:

```http
GET /v2/catalog-products/71 HTTP/1.1
Authorization: Bearer {token}
X-PF-Language: es_ES
```

Supported values:

| Header value | Language |
|---|---|
| `en_US` | English (US) — default |
| `en_GB` | English (UK) |
| `en_CA` | English (Canada) |
| `es_ES` | Spanish |
| `fr_FR` | French |
| `de_DE` | German |
| `it_IT` | Italian |
| `ja_JP` | Japanese |

Sending an unsupported value silently falls back to `en_US` (no error).

### Example

`GET /products/71` with `X-PF-Language: en_US`:

```json
{ "code": 200, "result": { "product": { "type_name": "T-Shirt", "title": "Unisex Staple T-Shirt | Bella + Canvas 3001", … } } }
```

`GET /products/71` with `X-PF-Language: es_ES`:

```json
{ "code": 200, "result": { "product": { "type_name": "Camiseta", "title": "Camiseta esencial unisex | Bella + Canvas 3001", … } } }
```

## Currency localization

Currency is per-store (the payout currency) but the catalog endpoints accept a `?currency=` query parameter to quote in a different currency. Order responses always use the store's currency — there is no per-call currency override on orders.

Supported currencies (from Printful's billing UI): `USD`, `EUR`, `GBP`, `CAD`, `AUD`, `JPY`, `MXN`, `NOK`, `SEK`, `CHF`, `ILS`, `BRL`, `NZD`, `RON`, `PLN`, `BGN`, `CZK`, `DKK`, `HUF`, `AED`, `INR`, `PHP`, `COP`, `HKD`, `THB`, `TWD`.

`?currency=` on the catalog accepts a subset (USD, EUR, GBP, CAD, AUD, MXN, NZD, JPY, BRL, …). Non-supported values return `422`. To check support, hit `GET /v2/catalog-products/71/prices?currency=XYZ` and watch for the validation error.

## Time zones

All ISO 8601 timestamps in v2 are UTC (`Z` suffix). v1 returns Unix epoch integers. Convert to the user's local time zone in your UI layer; never in the API request.

## Number formatting

- Prices in v2: strings with `.` decimal separator, e.g. `"19.95"`. **Always parse as fixed-decimal**, never as float for arithmetic.
- Prices in v1: floats.
- Quantities: integers.
- Latitudes/longitudes: not part of the Printful API surface.

## Original sources

- Tag descriptions: `Localisation` and `Countries v2` sections in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- `Country` schema in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
