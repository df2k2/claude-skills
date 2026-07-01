# Getting Started

The first encounter with the Akeneo PIM Web API. Understand what it is and which edition you're on, learn the base-URL model, get a token, and run your first read requests. Once these work, move on to the deeper references.

## What the Akeneo Web API is

[Akeneo PIM](https://www.akeneo.com) is a Product Information Management platform — the single place a company centralizes, enriches, and distributes its product catalog. The **Web API** is the developer-facing surface for reading and writing that catalog: products and product models; the catalog *structure* (families, family variants, attributes, options, categories, channels, locales, currencies, measurement families); and, on the higher editions, reference entities and assets. On the modern SaaS surface it also spans GraphQL, the Event Platform (webhooks), Catalogs for Apps, and an MCP server.

It's a **RESTful, JSON-only** API. Four verbs: `GET` (read), `POST` (create), `PATCH` (partial update — **creates the resource if it doesn't exist**), `DELETE`. `Content-Type: application/json` is mandatory on writes (a missing/wrong value returns `415`).

## Editions and versions

This skill is **SaaS/Serenity-forward** but the classic Community/Enterprise on-prem API is covered too. Know which one you're on — the auth model and some resources differ.

| Edition | What it is | Auth model | Notable extras |
| --- | --- | --- | --- |
| **Serenity (SaaS)** | Cloud, continuously updated (unversioned/rolling) | **App** or **Connection** | GraphQL, Event Platform, Apps, Catalogs, MCP, UUID products |
| **Growth Edition** | Entry SaaS tier | App / Connection | Serenity-like |
| **Enterprise (EE)** | On-prem / PaaS, licensed | Connection | Reference entities, Asset Manager, published products, workflows, catalog permissions |
| **Community (CE)** | On-prem, open source | Connection | REST core: products, catalog structure, media (no reference entities/assets) |

- **On-prem majors**: **4.0, 5.0, 6.0, 7.0**, plus **Serenity** (SaaS). Event payloads are version-keyed (`events-reference-{5.0,6.0,7.0,serenity}`).
- **UUID products arrived in 7.x.** Products are addressable by **UUID** (`/products-uuid/{uuid}`) *and* by identifier (`/products/{code}`); both coexist post-7.x. Classic CE/EE is identifier-only. See `rest-api-overview.md`.

## The base-URL model

Every REST call lives under **`{pim_url}/api/rest/v1/`**, where `{pim_url}` is *your own* PIM instance:

```
https://my-pim.cloud.akeneo.com/api/rest/v1/products
```

The `v1` segment is the only REST API version; requesting anything else returns `404`.

> **`api.akeneo.com` is the documentation site, not a live PIM.** If you're pointing requests at `api.akeneo.com` expecting catalog data, that's the #1 base-URL mistake. Live calls go to the customer's host (`https://<name>.cloud.akeneo.com/...` for SaaS, or the on-prem hostname). The SaaS spec's server is templated `{your-pim-url}`; the classic spec uses `demo.akeneo.com` purely as an example host.

Requesting the root `GET {pim}/api/rest/v1` (no auth) returns the machine-readable list of available endpoints for that instance — a quick way to confirm reachability and see which resources the edition exposes.

## The two machine-readable specs

Both are embedded under `references/sources/openapi-specs/` and are the **source of truth** when SDKs, blog posts, or curated docs disagree.

| Spec file | Standard | Surface | Size |
| --- | --- | --- | --- |
| `saas-openapi.json` | **OpenAPI 3.1.0** | SaaS/Serenity — UUID products, Catalogs, Workflows, Apps, Extensions | 92 paths / 152 operations / 94 schemas |
| `classic-web-api.json` | **Swagger 2.0** | Classic CE/EE on-prem/PaaS REST | 78 paths / 137 operations / 76 schemas |

`SPEC-SUMMARY.md` in the same folder is a flat, greppable catalog of every operation and schema across both. Generate clients from `saas-openapi.json` (modern) or `classic-web-api.json` (on-prem). The SaaS spec formalizes three security schemes — `basicToken` (the token request), `bearerToken` (Connection 1-hour token), and `appToken` (App permanent token) — mirroring the two auth models below.

## Your first requests

The walk-through below uses a **Connection** (OAuth2 password grant), the simplest path for a back-office/ERP integration. Building an **App** instead? See the decision box at the end and `authentication.md`. Auth is kept deliberately light here — full detail (refresh, App flow, OpenID, scopes) is in `authentication.md`.

### Step 1 — Create a Connection and get credentials

In the PIM UI, go to **Connect → Connection settings**, click **Create**, give it a label (e.g. `ERP`), pick a flow type, and save. The `Credentials` section then shows a **client ID** and **secret**, plus an auto-generated **API username and password**. You need all four. (The password is shown once — regenerate it if you didn't save it.)

### Step 2 — Get a bearer token

Base64-encode `client_id:secret` (the two joined by a colon) for the `Authorization: Basic` header, then POST the API username/password:

```bash
curl -X POST https://my-pim.cloud.akeneo.com/api/oauth/v1/token \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(printf '%s:%s' "$CLIENT_ID" "$SECRET" | base64)" \
  -d '{
        "grant_type": "password",
        "username": "your_API_username",
        "password": "its_password"
      }'
```

Response:

```json
{
  "access_token": "NzFiYTM4ZTEwMjcwZTcyZWIzZTA0NmY3NjE3MTIyMjM1Y2Nl...",
  "expires_in": 3600,
  "token_type": "bearer",
  "scope": null,
  "refresh_token": "MDk2ZmIwODBkYmE3YjNjZWQ4ZTk2NTk2N2JmNjkyZDQ4..."
}
```

The `access_token` is valid for **1 hour** (`expires_in: 3600`); the `refresh_token` lasts **14 days**. Every subsequent API call uses `Authorization: Bearer <access_token>`. Only two routes need no token: the API root and this token route.

### Step 3 — List categories (authenticated read)

```bash
curl https://my-pim.cloud.akeneo.com/api/rest/v1/categories \
  -H "Authorization: Bearer $TOKEN"
```

Collection responses are HAL-shaped — items under `_embedded.items`, navigation under `_links`:

```json
{
  "_links": {
    "self":  { "href": ".../api/rest/v1/categories?page=1&limit=10" },
    "first": { "href": ".../api/rest/v1/categories?page=1&limit=10" },
    "next":  { "href": ".../api/rest/v1/categories?page=2&limit=10" }
  },
  "current_page": 1,
  "_embedded": {
    "items": [
      { "code": "master",            "parent": null,     "updated": "2021-05-21T11:32:00+02:00", "position": 1, "labels": { "en_US": "Master catalog" } },
      { "code": "winter_collection", "parent": "master", "updated": "2021-05-21T11:32:00+02:00", "position": 1, "labels": { "en_US": "Winter collection", "fr_FR": "Collection hiver" } }
    ]
  }
}
```

Default page size is 10, max 100 (`limit` query param). Never build `page`/`search_after` values by hand — follow the `_links.next.href`. For big collections (products), prefer `search_after` over `page`. See `rest-api-overview.md`.

### Step 4 — Read a product

By UUID (modern SaaS/7.x):

```bash
curl https://my-pim.cloud.akeneo.com/api/rest/v1/products-uuid/25566245-55c3-42ce-86d9-8610ac459fa8 \
  -H "Authorization: Bearer $TOKEN"
```

By identifier (works on all editions):

```bash
curl https://my-pim.cloud.akeneo.com/api/rest/v1/products/top \
  -H "Authorization: Bearer $TOKEN"
```

A product's data lives in `values`, keyed by attribute code. Each entry is an array of `{locale, scope, data}` objects — `locale` is non-null only for *localizable* attributes, `scope` (a channel code) non-null only for *scopable* ones:

```json
{
  "uuid": "25566245-55c3-42ce-86d9-8610ac459fa8",
  "enabled": true,
  "family": "tshirt",
  "categories": ["summer_collection"],
  "parent": null,
  "values": {
    "sku":   [ { "data": "top", "locale": null, "scope": null } ],
    "name":  [ { "data": "Top", "locale": "en_US", "scope": null },
               { "data": "Débardeur", "locale": "fr_FR", "scope": null } ],
    "description": [
      { "data": "Summer top", "locale": "en_US", "scope": "ecommerce" },
      { "data": "Débardeur pour l'été", "locale": "fr_FR", "scope": "ecommerce" }
    ],
    "price": [ { "locale": null, "scope": null,
                 "data": [ { "amount": "15.5", "currency": "EUR" }, { "amount": "15", "currency": "USD" } ] } ],
    "color": [ { "locale": null, "scope": null, "data": "black" } ]
  }
}
```

Getting the `locale`/`scope` flags wrong is the single most common `422` on writes. The value structure is covered in depth in `products-and-models.md`.

## Import the Postman collection

The official collection is embedded at `references/sources/postman/akeneo-postman-collection.json` (named *Akeneo API REFERENCE*) — 152 example requests, foldered by resource, mirroring the SaaS spec tags.

1. In Postman: **Import** → select that JSON file.
2. Set the collection variables. It ships with `baseUrl` (default `https://pim-url.cloud.akeneo.com`) / `your-pim-url`, plus `clientId`, `secret`, `username`, `password` — point `baseUrl` at your PIM and fill the four credentials from your Connection.
3. Run **Authentication → Get an authentication token** first. That request uses **Basic** auth (its Basic username/password are your `clientId`/`secret`) and a JSON body of `username` / `password` / `grant_type: password`. Copy the returned `access_token` into the collection's bearer variable (`bearerToken`).
4. Every other request inherits **collection-level Bearer auth** (`{{bearerToken}}`), so once the token is set they authenticate automatically.

> Minor gotcha: the collection's declared variable list and the names its requests reference aren't perfectly aligned (the token request reads `basicAuthUsername`/`basicAuthPassword`; collection auth reads `bearerToken`). If a request 401s, open its **Authorization** tab and confirm the variable it points at actually holds your value.

## Connection vs App — quick decision

Two completely different OAuth2 flows. Picking the wrong one is the #1 integration failure. Full detail (curl, refresh, code challenge, OpenID, scope tables) is in **`authentication.md`** — this is only the one-line chooser.

| | **Connection** (Connector) | **App** (App Store / custom App) |
| --- | --- | --- |
| Grant | `password` (+ refresh) | `authorization_code` with a **code challenge** |
| Token endpoint | `POST {pim}/api/oauth/v1/token` | `POST {pim}/connect/apps/v1/oauth2/token` |
| Token life | **1 hour** (+ 14-day refresh) | **No expiration** (revocable; re-auth if revoked) |
| Best for | ERP/back-office/on-prem, the Magento connector | Marketplace / multi-tenant / SaaS apps |

- **Choose Connection** for a single-tenant integration you control (ERP sync, on-prem CE/EE, the Magento 2 connector). Simplest to stand up: create it in the UI, request a token, go.
- **Choose App** to distribute on the Akeneo App Store or serve many PIM tenants, or when you want OpenID Connect user identity. App building (scopes, activation/callback URLs, UI Extensions) is in `apps-and-connections.md`.

## What you now have

- A Connection (client ID/secret + API user) or an understanding of which auth model you need.
- A working token request and a bearer token.
- Confirmed read access to categories and products, and the `{locale, scope, data}` value shape.

Next steps:

- `authentication.md` — get auth right (both models, refresh, OpenID, scopes); everything downstream depends on this.
- `rest-api-overview.md` — the full endpoint map, UUID vs identifier, pagination, filtering, upsert semantics, response shapes.
- `products-and-models.md` — products, product models, and the value structure in depth.
- `catalog-structure.md` — families, attributes, options, categories, channels, locales you need before writing products.
- `errors-and-rate-limits.md` / `common-pitfalls.md` — the unhappy paths.

## Original sources

- `references/sources/akeneo-official-docs/rest-api/introduction.md`, `overview.md`, `why-the-api.md` — REST API basics, root URI, verbs, JSON/format headers, endpoint listing.
- `references/sources/akeneo-official-docs/rest-api/authentication.md` — Connection token request/response and the two unauthenticated routes.
- `references/sources/akeneo-official-docs/rest-api/pagination.md` — HAL `_links`/`_embedded` envelope, `page` vs `search_after`, limits.
- `references/sources/akeneo-official-docs/concepts/introduction.md` — what a PIM is.
- `references/sources/akeneo-official-docs/tutorials/guides/how-to-get-pim-product-information.md` — product `values` structure and example payloads.
- `references/sources/akeneo-official-docs/getting-started/connect-the-pim-4x/step-1.md` — creating a Connection in the UI.
- `references/sources/openapi-specs/saas-openapi.json`, `classic-web-api.json`, `SPEC-SUMMARY.md` — spec sizes, server URLs, security schemes, endpoint catalog.
- `references/sources/postman/akeneo-postman-collection.json` — collection name, variables, Authentication folder, collection-level bearer auth.
- `SKILL.md` — editions/versions, base path, UUID-since-7.x, the two auth models.
