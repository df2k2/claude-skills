---
name: akeneo-pim-api-development
description: "Build, integrate, and debug applications against the Akeneo PIM (Product Information Management) Web API documented at api.akeneo.com — REST, GraphQL, the Event Platform (webhooks), the Apps/Connections OAuth framework, the official akeneo/api-php-client, and the Akeneo MCP server. Covers both the modern SaaS/Serenity surface (OpenAPI 3.1.0, UUID products, Catalogs, Workflows) and the classic Community/Enterprise on-prem REST API (Swagger 2.0, OAuth2 password grant). Use this skill whenever the user is integrating Akeneo PIM to read or write product data, product models, families, family variants, attributes, attribute options/groups, association types, categories, channels, locales, currencies, measurement families, reference entities, assets (Asset Manager), catalogs, or catalog mapping schemas; authenticating a Connection (client_id/secret + username/password → /api/oauth/v1/token) or an App (authorization-code grant with a code_challenge → /connect/apps/v1/oauth2/token, non-expiring token, OpenID Connect); subscribing to product/attribute/category events via the Event Platform (or migrating off the deprecated Events API); querying the GraphQL API; building an App for the Akeneo App Store or a custom App; using UI Extensions; using the PHP API client (Akeneo\\Pim\\ApiClient, AkeneoPimClientBuilder); using the Akeneo MCP server; generating clients from the OpenAPI/Swagger specs; or debugging 401/403/422 responses, locale/scope value errors, pagination (search_after vs page), or identifier-vs-UUID confusion. Trigger on mentions of Akeneo, Akeneo PIM, PIM API, api.akeneo.com, Serenity, Akeneo SaaS, Growth Edition, Community Edition, Enterprise Edition, PIM.ai, /api/rest/v1/, /api/oauth/v1/token, /connect/apps/v1/, cloud.akeneo.com, product model, family variant, reference entity, asset family, attribute option, attribute group, association type, measurement family, catalog structure, scopable/localizable attribute, channel/scope, akeneo/api-php-client, Akeneo\\Pim\\ApiClient, AkeneoPimClientBuilder, Akeneo Event Platform, Akeneo webhook, Akeneo Events API, Akeneo GraphQL, Akeneo App, Akeneo Connection, Akeneo App Store, code_challenge/code_identifier, Akeneo MCP, product mapping schema, Akeneo Catalogs API, PIMGento. This skill documents the API-integration surface; for the Akeneo→Magento 2 connector module use the akeneo-magento2-connector skill instead. NOTE: api.akeneo.com and the specs are PUBLIC and return HTTP 200 to any normal client; the SaaS OpenAPI spec, the Postman collection, and the pim-api-docs prose are all embedded under references/sources/. Treat the OpenAPI/Swagger specs as the source of truth when the SDKs or curated docs disagree."
---

# Akeneo PIM API Development

[Akeneo PIM](https://www.akeneo.com) is a Product Information Management platform. Its **Web API** (documented at [api.akeneo.com](https://api.akeneo.com)) is the developer-facing surface for reading and writing catalog data and structure — REST + GraphQL + webhooks (Event Platform) + an Apps/OAuth framework. This skill is the developer guide to that surface and ships the official specs, the Postman collection, the docs prose, and the PHP client source as embedded source-of-truth.

The skill has three layers of documentation:

1. **Curated references** in `references/*.md` — synthesized guides for every part of the API with example payloads, code recipes, and gotchas. Read these first.
2. **The two official specs + the docs bundle + the Postman collection** in `references/sources/` — the **authoritative source-of-truth**. When curated docs and the specs disagree, trust the specs.
3. **The official PHP client source** in `references/sources/api-php-client-source/` — `akeneo/api-php-client`, the library the Magento 2 connector (and most PHP integrations) use.

> **Everything Akeneo publishes here is a public file.** The SaaS OpenAPI spec (`storage.googleapis.com/akecld-prd-pim-saas-shared-openapi-spec/openapi.json`), the Postman collection (`api.akeneo.com/files/akeneo-postman-collection.json`), and the `akeneo/pim-api-docs` prose all return HTTP 200 with no auth. There is no Cloudflare/JS challenge and no known DNS/category filtering. `scripts/akeneo-pim/fetch_docs.sh` refreshes them (add `HTTPS_PROXY` if your egress is proxied).

## Scope and versions

This skill is **SaaS/Serenity-forward** but covers the **classic Community/Enterprise** REST API too. Know which one you're on — auth and some resources differ.

| Edition | What it is | API surface | Auth |
| --- | --- | --- | --- |
| **Serenity (SaaS)** | Cloud, continuously updated | Full modern surface: REST + GraphQL + Event Platform + Apps + Catalogs + MCP | **App** (authorization-code + code_challenge) *or* **Connection** (password grant) |
| **Enterprise (EE)** | On-prem/PaaS, licensed | REST incl. reference entities, Asset Manager, permissions, published products, workflows | Connection (password grant) |
| **Community (CE)** | On-prem, open source | REST core: products, catalog structure, media | Connection (password grant) |
| **Growth Edition** | Entry SaaS tier | Serenity-like | App / Connection |

- **PIM versions**: on-prem majors **4.0, 5.0, 6.0, 7.0** + **Serenity** (SaaS, unversioned/rolling). **UUID products arrived in 7.x** (identifiers still supported). Event payloads are version-keyed (`events-reference-{5.0,6.0,7.0,serenity}`).
- **Base path**: every REST call is under **`{pim_url}/api/rest/v1/`** (e.g. `https://my-pim.cloud.akeneo.com/api/rest/v1/products`).
- **Two machine-readable specs** (both embedded, `references/sources/openapi-specs/`):
  - `saas-openapi.json` — **OpenAPI 3.1.0**, the SaaS/Serenity surface: **92 paths / 152 operations / 94 schemas / 42 tags**.
  - `classic-web-api.json` — **Swagger 2.0**, the classic CE/EE REST surface: **78 paths / 137 operations**.
- If the user is calling `api.akeneo.com` expecting a live PIM, correct them: **`api.akeneo.com` is the documentation site.** Live calls go to *their* PIM instance (`{pim_url}/api/rest/v1/...`).

## The two authentication models (get this right first)

Akeneo has **two completely different OAuth2 flows**. Picking the wrong one is the #1 integration failure.

| | **Connection** (Connector) | **App** (App Store / custom App) |
| --- | --- | --- |
| Grant | `password` (+ `refresh_token`) | `authorization_code` with a **code challenge** (not the raw secret) |
| Token endpoint | `POST {pim}/api/oauth/v1/token` | `POST {pim}/connect/apps/v1/oauth2/token` |
| Credentials | `client_id:secret` (Basic header) **+ API username/password** | `client_id` + `code` + `code_identifier` + `code_challenge` |
| Authorize step | none (direct token request) | `GET {pim}/connect/apps/v1/authorize?response_type=code&client_id=…&scope=…&state=…` |
| Access token life | **1 hour** (`expires_in: 3600`); refresh token **14 days** | **No expiration** (revocable by a PIM user; no refresh — re-auth if revoked) |
| Scopes | connection permissions (UI) | space-separated `scope` list (`read_products write_products …`, EE scopes tagged) |
| Best for | ERP/back-office/on-prem integrations, the Magento connector | Marketplace/multi-tenant apps, SaaS |

- **Connection** (`references/authentication.md`): create a Connection in *Connect → Connection settings*; it yields `client_id`/`secret` **and** an auto-generated API username/password. Base64-encode `client_id:secret` for the `Authorization: Basic` header; POST `grant_type=password` with the username/password. Only two routes need no token: the API root and the token route.
- **App** (`references/apps-and-connections.md`): OAuth authorization-code flow. The token request replaces the client secret with a **`code_challenge` = sha256(code_identifier + client_secret)** and a random **`code_identifier`**. Add OpenID scopes (`openid email profile`) to also get an **`id_token`** (JWT, verify via `{pim}/connect/apps/v1/openid/public-key`; `sub` is the stable user id).

## How the Akeneo API fits together (mental model)

```
                         Akeneo PIM instance  —  {pim_url}
                                   │
     ┌──────────────── REST  {pim_url}/api/rest/v1/*  (source of truth: the 2 specs) ─────────────┐
     ▼                                                                                             ▼
  CATALOG STRUCTURE                          PRODUCT DATA                        ENRICHMENT (EE / Serenity)
  families, family variants,   products (by UUID or identifier),    reference entities (+records/attrs/media),
  attributes, options, groups, product models, media files,         assets / Asset Manager (asset families…),
  association types, categories, values = {attr: [{locale,scope,    catalogs + product mapping (Apps),
  channels, locales, currencies,          data}]}                   workflows (Serenity/EE)
  measurement families
     │                                   │                                        │
     └──────── auth: Connection (password grant) OR App (authorization-code + code_challenge) ─────┘
                                   │
     other surfaces (Serenity-forward — note: these run on CENTRAL Akeneo hosts, not {pim_url}):
       • GraphQL          — graphql.sdk.akeneo.cloud, PIM passed via X-PIM-URL header (references/graphql.md)
       • Event Platform   — managed at event.prd.sdk.akeneo.cloud/api/v1; delivers webhooks (references/events-and-webhooks.md)
       • Apps / App Store — build & publish Apps; UI Extensions (references/apps-and-connections.md)
       • MCP server       — server.mcp.akeneo.cloud/mcp (references/mcp-server.md)
       • PHP client       — akeneo/api-php-client (references/php-client.md)
```

### Key concepts

- **Values are localizable/scopable.** A product's `values` map each attribute code to an array of `{locale, scope, data}` entries. `locale` is null unless the attribute is *localizable*; `scope` (a channel code) is null unless the attribute is *scopable*. Getting these two flags wrong is the most common 422. See `references/products-and-models.md`.
- **Products: UUID vs identifier.** Modern SaaS addresses products by **UUID** (`/api/rest/v1/products-uuid/{uuid}`) *and* by identifier (`/api/rest/v1/products/{code}`). Classic CE/EE uses the **identifier** (SKU-like). Both coexist post-7.x. Don't mix the two endpoint families for the same code.
- **Product models & family variants.** A *product model* is the parent of variant products; a *family variant* defines the variation axes/levels. One or two variation levels. See `references/products-and-models.md`.
- **Upsert semantics.** `PATCH` on a single resource (or a line-delimited JSON body on the collection) **creates or updates** — Akeneo has no separate "create" for most resources. Partial updates merge at the value level.
- **Pagination has two methods.** `pagination_type=page` (offset, with counts) or **`search_after`** (cursor, scalable). Large collections (products) should use `search_after`. See `references/rest-api-overview.md`.
- **Reference entities & assets are EE/Serenity.** CE does not have them. The community Magento connector does **not** import them.
- **Catalogs** are an **App** concept: a curated, mapped product selection an App reads via `/api/rest/v1/catalogs/*`, with a **product mapping schema**. See `references/catalogs-and-mapping.md`.

## When to consult this skill vs. just answer

Trigger on:

- Any work against a `{pim}/api/rest/v1/*` endpoint, the GraphQL API, the Event Platform, or the Apps OAuth flow.
- A failed Akeneo request — 401/403 (auth model / token / scopes), 422 (value/locale/scope shape), 404 (edition vs endpoint).
- Anything about products, product models, families, family variants, attributes, options, categories, channels, locales, reference entities, assets, catalogs.
- Choosing between a **Connection** and an **App**; between **identifier** and **UUID**; between the classic and SaaS specs.
- Building or generating a client (PHP client, OpenAPI codegen, Postman).
- Webhooks / Event Platform subscription, signature verification, or migrating off the deprecated Events API.
- The Akeneo MCP server.

Defer when the task is dominated by a host platform that merely consumes Akeneo data (e.g. the Magento connector module itself → `akeneo-magento2-connector`; a generic ETL framework).

## How to find what you need

| Task | Reference |
| --- | --- |
| Editions/versions, base URL, first call, importing the Postman collection | `references/getting-started.md` |
| Auth: Connection password grant vs App authorization-code (+ OpenID, scopes, refresh) | `references/authentication.md` |
| Endpoint map, UUID vs identifier, pagination, filtering, upsert, response shapes | `references/rest-api-overview.md` |
| Products, product models, the `{locale,scope,data}` value structure, media | `references/products-and-models.md` |
| Families, variants, attributes, options/groups, association types, categories, channels, locales, currencies, measurement families | `references/catalog-structure.md` |
| Reference entities + Asset Manager (EE/Serenity) | `references/reference-entities-and-assets.md` |
| Catalogs API + product mapping schema (Apps) | `references/catalogs-and-mapping.md` |
| Event Platform (webhooks) + deprecated Events API + version-keyed event reference | `references/events-and-webhooks.md` |
| GraphQL API (Serenity) | `references/graphql.md` |
| Building Apps (App Store, OAuth scopes, custom apps) + UI Extensions | `references/apps-and-connections.md` |
| Akeneo MCP server | `references/mcp-server.md` |
| Official PHP client (`akeneo/api-php-client`) | `references/php-client.md` |
| SDK/tooling comparison (PHP, community SDKs, Postman, codegen, MCP) | `references/sdks-and-tools.md` |
| Status codes, error shapes, rate/limits, pagination caps, troubleshooting | `references/errors-and-rate-limits.md` |
| The "why isn't this working" catalog | `references/common-pitfalls.md` |
| Flat catalog of every operation + schema across both specs | `references/sources/openapi-specs/SPEC-SUMMARY.md` |
| Topic → file map for the embedded sources | `references/sources/INDEX.md` |

## Critical things to know up-front

### 1. There are two auth models — pick before you code
Connection = `password` grant at `/api/oauth/v1/token` (1h token + 14d refresh). App = `authorization_code` at `/connect/apps/v1/oauth2/token` using a `code_challenge` (non-expiring token). They are not interchangeable. See the table above and `references/authentication.md`.

### 2. `api.akeneo.com` is docs, not your PIM
Live requests go to the customer's PIM host under `/api/rest/v1/`. The SaaS spec's server is templated `{your-pim-url}`.

### 3. Product values carry locale + scope
`values[attr] = [{ "locale": <code|null>, "scope": <channel|null>, "data": … }]`. `locale` non-null only for *localizable* attributes; `scope` non-null only for *scopable* attributes. Mismatches → 422. This is the single most common data-shape bug.

### 4. UUID and identifier products coexist
SaaS exposes `/products` (by identifier) **and** `/products-uuid` (by UUID). UUID landed in 7.x. Classic CE/EE is identifier-only. Use one family consistently.

### 5. Most writes are upserts via PATCH
`PATCH /products/{code}` (or a newline-delimited JSON collection body) creates-or-updates and merges partially. There is usually no separate POST-to-create.

### 6. Pagination: prefer `search_after` for big collections
`page` gives counts but doesn't scale; `search_after` is the cursor method for products/large sets. Responses use HAL `_links` (`self`/`first`/`next`/`previous`).

### 7. EE-only resources 404 on CE
Reference entities, assets, published products, workflows exist only on EE/Serenity. A 404 there usually means "wrong edition," not "wrong path."

### 8. The two specs are ground truth; SaaS is OpenAPI 3.1, classic is Swagger 2.0
Generate clients from `saas-openapi.json` (modern) or `classic-web-api.json` (on-prem). When an SDK or a blog post disagrees with the spec (or the live API), the spec wins. `SPEC-SUMMARY.md` is the flat catalog.

### 9. Events: use the Event Platform, not the old Events API
The **Event Platform** is current; the original **Events API** is deprecated (migration guide embedded). Verify webhook signatures. Payloads differ by PIM version. See `references/events-and-webhooks.md`.

### 10. The PHP client is unified (EE client is dead)
Use **`akeneo/api-php-client`** for CE **and** EE — the old `akeneo/api-php-client-ee` is archived and merged in. It's PSR-18/17 based; build with `AkeneoPimClientBuilder`. It's also the exact library the Magento 2 connector depends on.

## Workflow for "build a new Akeneo integration"

1. **Confirm edition + auth model.** Serenity/App vs on-prem/Connection. Different token endpoints. (`references/authentication.md`)
2. **Create credentials.** Connection (client_id/secret + API user) or App (client_id/secret + OAuth flow).
3. **Get a token**, then hit an unauthenticated sanity endpoint (the API root) and an authenticated one:
   ```bash
   curl {pim}/api/rest/v1/categories -H "Authorization: Bearer $TOKEN"
   ```
4. **Model your data.** Understand families/attributes and the `{locale,scope,data}` value shape before writing products. (`references/catalog-structure.md`, `references/products-and-models.md`)
5. **Read the catalog** (families, attributes, channels, locales) — you need these codes to write valid products.
6. **Write products** with `PATCH` (single or newline-delimited collection), correct locale/scope per attribute. (`references/products-and-models.md`)
7. **Page through large sets** with `search_after`. (`references/rest-api-overview.md`)
8. **Subscribe to changes** via the Event Platform if you need push. (`references/events-and-webhooks.md`)
9. **Handle the unhappy paths**: token refresh/re-auth, 422 value errors, 404 edition mismatches, rate limits. (`references/errors-and-rate-limits.md`, `references/common-pitfalls.md`)

## Workflow for "debug a failing Akeneo request"

1. **401 / 403?** → `references/authentication.md`. Wrong auth model (Connection vs App), expired connection token (1h), missing/insufficient App scope, or wrong `Authorization` header form (`Basic` for the token request, `Bearer` for API calls).
2. **422?** Value shape — wrong/absent `locale` or `scope`, unknown attribute/option code, wrong data type for the attribute type. → `references/products-and-models.md`, `references/common-pitfalls.md`.
3. **404?** Wrong edition (EE resource on CE), wrong product family (`/products` vs `/products-uuid`), or a typo'd code.
4. **400 on write?** Malformed line-delimited JSON, or a `PATCH` body that isn't a partial value merge.
5. **Pagination surprises?** Mixing `page` and `search_after`, or expecting a total count from `search_after` (there isn't one).
6. **Webhook not firing / signature invalid?** Event Platform subscription + signature verification. → `references/events-and-webhooks.md`.

## Embedded source-of-truth & refresh

Everything Akeneo publishes for the API is embedded under `references/sources/`:

- `openapi-specs/` — `saas-openapi.json` (3.1.0) + `classic-web-api.json` (Swagger 2.0) + `classic-swagger-src/` (split source) + `SPEC-SUMMARY.md` (flat catalog) + `README.md`.
- `postman/akeneo-postman-collection.json` — 152 example requests mirroring the spec tags.
- `api-php-client-source/` — the official PHP client (`src/`, README, composer.json).
- `akeneo-official-docs/` — the `pim-api-docs` prose (rest-api, concepts, event-platform, apps, graphql, php-client, mapping, mcp, extensions, getting-started, guides, …).

**Refresh:** `bash scripts/akeneo-pim/fetch_docs.sh` (add `HTTPS_PROXY=…` if proxied), then `python3 scripts/akeneo-pim/gen_spec_summary.py` to regenerate the catalog.

## Source-of-truth hierarchy

1. The live PIM API (run the actual request against the instance).
2. The two specs in `references/sources/openapi-specs/`.
3. The official `akeneo/api-php-client` source.
4. The embedded docs prose + Postman collection.
5. The curated references in this skill.
6. Past blog posts / tutorials.

## Related skill

For the **Akeneo Connector for Magento 2 / Adobe Commerce** (the PHP module that imports Akeneo catalog data into a Magento store), use the **`akeneo-magento2-connector`** skill. It depends on the same `akeneo/api-php-client` documented here.
