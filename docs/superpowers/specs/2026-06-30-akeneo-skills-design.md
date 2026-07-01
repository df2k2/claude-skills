# Akeneo Skills — Design Spec

**Date:** 2026-06-30
**Status:** Approved (brainstorming), pending implementation plan
**Author:** Claude (with Chris Snedaker)

## Summary

Add **two new sibling skills** to the `claude-skills` repo, following the repo's
gold-standard `*-api-development` skill template (long trigger-rich `SKILL.md` →
curated `references/*.md` → vendored `references/sources/` → `INDEX.md` topic map →
`scripts/<skill>/fetch_docs.sh` refresher):

1. **`akeneo-pim-api-development`** — building/integrating/debugging against the Akeneo
   Web API (REST + GraphQL + Events/webhooks + Apps/OAuth + the official PHP client +
   the Akeneo MCP server). **SaaS/Serenity-forward, but also covers classic CE/EE.**
2. **`akeneo-magento2-connector`** — installing, configuring, customizing, and debugging
   the official `akeneo/magento2-connector-community` Magento 2 module (pull/import:
   Akeneo → Magento). Defers generic Magento 2 mechanics to the existing
   `magento2-development` skill; focuses on connector-specific knowledge.

The two skills cross-link (both center on the shared `akeneo/api-php-client` library).

## Locked decisions

| Decision | Choice | Rationale |
| --- | --- | --- |
| Packaging | **Two skills** (not one combined) | Disjoint trigger surfaces (API integration vs. a Magento PHP module); focused descriptions match more precisely; independent install; matches repo's one-domain-per-skill convention |
| Edition coverage | **SaaS-forward, cover both** CE/EE + Serenity | Docs and the connector both span both; "latest documentation" = SaaS; on-prem CE/EE still widely deployed |
| Depth | **Comprehensive** — curated guides + embedded sources + full topic map + refresh scripts | Explicit user requirement ("well-developed", "thorough map of all the documentation") |
| Connector vs. generic Magento | Connector skill **defers** to `magento2-development` | Avoid re-teaching Magento; keep the connector skill focused and deep |

## Upstream source inventory (verified reachable 2026-06-30)

All sources return HTTP 200 from this environment — **Akeneo is not DNS/category-filtered**,
so fetch scripts use plain `curl`/`git` with an optional `HTTPS_PROXY`
passthrough. No SOCKS/SSH transport needed.

| Source | URL | Format | Scale | Notes |
| --- | --- | --- | --- | --- |
| **SaaS OpenAPI spec** | `https://storage.googleapis.com/akecld-prd-pim-saas-shared-openapi-spec/openapi.json` | OpenAPI **3.1.0** JSON | 92 paths / **152 ops** / 94 schemas / 42 tags (5.2 MB) | Modern Serenity surface; server templated `{your-pim-url}` |
| **Postman collection** | `https://api.akeneo.com/files/akeneo-postman-collection.json` | Postman v2.1 | 152 requests, folders mirror the spec tags (1.0 MB) | Example payloads for every operation |
| **API docs site source** | `https://github.com/akeneo/pim-api-docs` (branch `master`) | Static-site repo | ~94 MB repo (vendor **only** `content/` prose + `content/swagger/` spec, not build assets/fonts/img) | Source of api.akeneo.com |
| **Classic CE/EE REST spec** | `pim-api-docs:/content/swagger/akeneo-web-api.{json,yaml}` (+ split `definitions/parameters/paths/responses.yaml`, `resources/`) | Swagger/OpenAPI | on-prem/PaaS REST surface | Complements the SaaS spec |
| **Official PHP client** | `https://github.com/akeneo/api-php-client` (branch `master`) | PHP library (`src/`, `spec/`, `tests/`, README, CHANGELOG, composer.json, LICENCE.txt) | ~1.2 MB; latest tag **v11.3.0**; connector pins **11.4.0** | **No `docs/` dir** — docs = README + `content/php-client/` prose |
| **Magento 2 connector** | `https://github.com/akeneo/magento2-connector-community` (branch `master`) | Full Magento 2 module | ~2.4 MB; current tag **v105.1.2** | Depends on `akeneo/api-php-client 11.4.0`, PHP ≥8.0, `magento/framework` ≥102 (Magento 2.4.x) |
| **Akeneo MCP docs** | `pim-api-docs:/content/mcp/` (`overview`, `capabilities`, `getting-started`, `use-cases`) | Markdown prose | 4 files | **No standalone MCP repo** in the akeneo org (search → 0). MCP is a hosted/documented server |

## Akeneo domain facts captured during discovery (ground truth)

These get baked into the curated guides:

- **Editions:** Community Edition (CE, open source, on-prem), Enterprise Edition (EE — adds
  reference entities, Asset Manager, permissions, published products, workflows), Growth
  Edition, and **Serenity (SaaS, continuously updated)**.
- **PIM versions:** 4.0, 5.0, 6.0, 7.0 (on-prem/PaaS) + Serenity. Event references are
  version-keyed (`events-reference-{5.0,6.0,7.0,serenity}`). **Identifiers → UUID** products
  landed in **7.x** (`getting-started/from-identifiers-to-uuid-7x`).
- **Two auth models:** (a) classic **OAuth2 password grant** (`client_id`/`secret` +
  username/password → bearer + refresh) for CE/EE/PaaS; (b) **App / Connection OAuth**
  (authorization-code + scopes) for SaaS/Apps. The SaaS spec exposes tags `Authentication`,
  `Permissions`, `Extensions`.
- **Products** carry values keyed by **locale × scope (channel)** with typed `data` — the #1
  source of confusion. Products addressable by **UUID** (modern) or **identifier** (classic).
- **Webhooks:** the **Event Platform** (current) supersedes the deprecated **Events API**
  (`events-api/migrate-to-event-platform.md`, `event-platform/migrate-from-deprecated-event-api.md`).
  Signature verification + subscription flow documented.
- **PHP client is now unified:** `akeneo/api-php-client-ee` is **archived and merged** into
  `akeneo/api-php-client` ("Moved to …/api-php-client"). Use the single client for CE **and**
  EE. (Bake into `php-client.md` + `common-pitfalls.md`.)
- **Connector is pull/import-only** (Akeneo → Magento), run via admin grid /
  `bin/magento akeneo_connector:*` console commands / cron. Jobs: **Import (base), Category,
  Family, Attribute, Option, Product**. `etc/` wires di/events/crontab/cron_groups/db_schema/
  webapi/acl/module.

## Skill 1 — `akeneo-pim-api-development`

### Purpose & triggers
Any work against the Akeneo Web API: REST (products/catalog-structure/reference-entities/
assets/catalogs), GraphQL, Events/webhooks, Apps & Connections OAuth, the PHP client, the MCP
server. Trigger phrases: Akeneo, PIM, api.akeneo.com, `/api/rest/v1/`, product model, family
variant, reference entity, asset family, attribute option, channel/locale/scope, Serenity,
Growth Edition, App OAuth/connection, Event Platform, `akeneo/api-php-client`, Akeneo MCP, etc.
(Full enumerated list authored in `SKILL.md` frontmatter — long, keyword-rich style.)

### Directory layout
```
akeneo-pim-api-development/
├── SKILL.md
├── references/
│   ├── getting-started.md
│   ├── authentication.md
│   ├── rest-api-overview.md
│   ├── products-and-models.md
│   ├── catalog-structure.md
│   ├── reference-entities-and-assets.md
│   ├── catalogs-and-mapping.md
│   ├── events-and-webhooks.md
│   ├── graphql.md
│   ├── apps-and-connections.md
│   ├── mcp-server.md
│   ├── php-client.md
│   ├── sdks-and-tools.md
│   ├── errors-and-rate-limits.md
│   ├── common-pitfalls.md
│   └── sources/
│       ├── INDEX.md                              ← complete topic → file map
│       ├── openapi-specs/
│       │   ├── saas-openapi.json                 ← SaaS/Serenity, OpenAPI 3.1.0, 152 ops
│       │   ├── classic-web-api.json / .yaml      ← classic CE/EE REST (+ split yaml, resources/)
│       │   ├── SPEC-SUMMARY.md                   ← generated flat catalog of BOTH specs
│       │   └── README.md                         ← refresh guide
│       ├── postman/
│       │   └── akeneo-postman-collection.json    ← 152 example requests
│       ├── api-php-client-source/                ← vendored akeneo/api-php-client @ tag
│       │   └── src/ + README.md + CHANGELOG.md + composer.json + LICENCE.txt
│       └── akeneo-official-docs/                 ← prose vendored from pim-api-docs/content/
│           ├── rest-api/  concepts/
│           ├── event-platform/  events-api/  events-reference/{5.0,6.0,7.0,serenity}/
│           ├── apps/  app-portal/  graphql/  php-client/  mapping/  mcp/
│           ├── extensions/  advanced-extensions/
│           ├── getting-started/  guides/  tutorials/
│           └── README.md                         ← provenance + refresh
└── scripts/akeneo-pim/                           ← in-skill (self-contained)
    ├── fetch_docs.sh
    └── gen_spec_summary.py
```

### Curated references (~15)
| File | Covers |
| --- | --- |
| `getting-started.md` | Editions + versions, base URLs, first call, Postman import |
| `authentication.md` | The two auth models (password grant vs App OAuth), refresh, 401s |
| `rest-api-overview.md` | Endpoint map; UUID vs identifier; pagination/filtering; PATCH-upsert; response envelope |
| `products-and-models.md` | Products (uuid+identifier), product models, locale/scope/`data` values, media |
| `catalog-structure.md` | Families, variants, attributes, options/groups, association types, categories, channels, locales, currencies, measurement families |
| `reference-entities-and-assets.md` | Reference entities + Asset Manager (EE/Serenity) |
| `catalogs-and-mapping.md` | Catalogs API + product mapping schema (App data-sharing) |
| `events-and-webhooks.md` | Event Platform (current) vs deprecated Events API; subscription, signature verification, version-keyed event reference |
| `graphql.md` | GraphQL (Serenity): queries/arguments, capabilities, limits, error codes |
| `apps-and-connections.md` | Building Apps (App portal, OAuth scopes, custom apps), UI Extensions |
| `mcp-server.md` | Akeneo MCP server: overview, capabilities, getting-started, use-cases, relation to REST |
| `php-client.md` | Official `akeneo/api-php-client` (unified; EE merged): auth, resources, pagination, exceptions |
| `sdks-and-tools.md` | PHP client + community SDKs (python/node) + Postman + MCP |
| `errors-and-rate-limits.md` | Status codes, error shapes, rate limits, pagination caps, troubleshooting |
| `common-pitfalls.md` | locale/scope on values, uuid vs identifier, wrong auth model, deprecated Events API, EE draft/published, channel/locale activation, dead EE client |

### scripts/akeneo-pim/
- `fetch_docs.sh` — fetch SaaS `openapi.json` (googleapis) + Postman (api.akeneo.com);
  `git clone --depth 1` `pim-api-docs` and copy `content/` prose + `content/swagger/` spec;
  `git clone --depth 1` `api-php-client` at the pinned tag and copy `src/`+README+CHANGELOG+
  composer.json+LICENCE. Validate JSON/YAML. Report size delta. Optional `HTTPS_PROXY`.
- `gen_spec_summary.py` — regenerate `SPEC-SUMMARY.md` (paths/ops/tags/schemas) from **both** specs.

## Skill 2 — `akeneo-magento2-connector`

### Purpose & triggers
Configuring/customizing/debugging the `akeneo/magento2-connector-community` module. Triggers:
Akeneo Magento connector, `akeneo/module-magento2-connector-community`,
`akeneo_connector:*`, importing Akeneo products into Magento, connector jobs, attribute
mapping, connector cron, `Akeneo\Connector`, etc.

### Directory layout
```
akeneo-magento2-connector/
├── SKILL.md
├── references/
│   ├── getting-started.md
│   ├── configuration.md
│   ├── jobs-and-imports.md
│   ├── running-imports.md
│   ├── architecture.md
│   ├── customizing.md
│   ├── troubleshooting.md
│   ├── upgrade-and-versions.md
│   └── sources/
│       ├── INDEX.md                              ← topic map + where each concern lives in source
│       └── magento2-connector-source/            ← full module vendored @ tag v105.1.2
│           └── (Api Block Console Controller Converter Cron Executor Helper Job Logger
│               Model Observer Setup Ui ViewModel etc i18n view + README + CHANGELOG + composer.json)
└── scripts/akeneo-magento2/                      ← in-skill (self-contained)
    └── fetch_docs.sh
```

### Curated references (~8)
| File | Covers |
| --- | --- |
| `getting-started.md` | What it is (pull/import-only); compat matrix (connector v105.x ↔ Magento 2.4.x/fw≥102 ↔ PHP≥8.0 ↔ api-php-client 11.4.0 ↔ Akeneo editions); composer install; **cross-link to Skill 1** for the shared client |
| `configuration.md` | Admin config: API credentials, website/store + attribute + channel/locale/currency mapping, product filters, image/asset & category import |
| `jobs-and-imports.md` | Import Job pipeline (Import base + Category/Family/Attribute/Option/Product), step/executor model, order of operations, full vs delta, product-model handling |
| `running-imports.md` | Admin grid, `bin/magento akeneo_connector:*`, cron (cron_groups/crontab), executor/queue, logs |
| `architecture.md` | Module structure + `etc/` wiring (di/events/crontab/db_schema/webapi/acl); **defers generic Magento to `magento2-development`** |
| `customizing.md` | Plugins/observers around jobs, custom converters, added mappings, events the connector fires |
| `troubleshooting.md` | Auth/connection, memory/timeout on big catalogs, attribute-type mismatch, missing mappings, image import, partial imports, cron, reindex |
| `upgrade-and-versions.md` | Version/compat matrix + CHANGELOG highlights + upgrade steps |

### scripts/akeneo-magento2/
- `fetch_docs.sh` — `git clone --depth 1` connector at the latest tag, copy source into
  `sources/magento2-connector-source/`, record the tag, report size delta. Optional `HTTPS_PROXY`.

## Shared mechanics & housekeeping

- **`SKILL.md` shape** (both): long trigger-rich frontmatter `description`; mental model;
  "Critical things to know up-front" (numbered 5–10 facts); task → reference quickstart table;
  build/debug workflows; source-of-truth hierarchy.
- **Source-of-truth hierarchy** (each skill): live API → OpenAPI/Swagger specs → official
  PHP client / connector source → curated references → blog posts.
- **Cross-linking:** Skill 1 `php-client.md` ↔ Skill 2 `getting-started.md` (shared
  `akeneo/api-php-client`); Skill 2 `architecture.md` → `magento2-development`. Skill 2 does
  **not** duplicate the ~1.2 MB client source — it references Skill 1's vendored copy.
- **Licensing note** (each `sources/README.md`): connector is OSL-3.0/AFL-3.0; pim-api-docs
  content + specs + PHP client retain Akeneo's terms — `sources/` not redistributable standalone.
- **Top-level `README.md`:** add both skills to the skills table + the layout diagram + the
  "Refreshing the upstream documentation" section.

## Non-goals

- Not re-teaching generic Magento 2 (defer to `magento2-development` / `hyva-magento2-development`).
- Not authoring new SDKs — documenting existing ones.
- Not covering Akeneo's internal Symfony app/bundle development — only the **Web API** and the
  **connector**.
- Not covering Akeneo admin/catalog-onboarding UX — developer surface only.

## Open implementation notes

- **api-php-client tag pin:** connector requires `11.4.0`; repo's latest visible git tag is
  `v11.3.0`. Fetch script pins to `v11.4.0` with fallback to latest tag; record the resolved
  tag in `sources/README.md`.
- **pim-api-docs is ~94 MB:** vendor only `content/` prose + `content/swagger/` spec, never the
  build assets / fonts / img. Fetch script copies a curated subdir allow-list.
- **Network:** not filtered; simple `curl`/`git`. Keep an `HTTPS_PROXY`/`ALL_PROXY` env
  passthrough for corporate networks.
- **`events-reference-*` are per-version dirs** — vendor all four (5.0/6.0/7.0/serenity) so
  the skill can answer version-specific webhook-payload questions.
- **Scripts live inside each skill** (`<skill>/scripts/<name>/`),
  so each skill stays self-contained/portable — not at repo-root `scripts/` like the older skills.
- **Plan decomposition:** implementation naturally splits into two plans (one per skill), Skill 1
  first (the connector skill cross-links it). `writing-plans` may produce two plans or one
  two-phase plan.

## Acceptance criteria

1. Both skill directories exist with a complete `SKILL.md` (trigger-rich description,
   critical-facts section, quickstart table) and all curated `references/*.md` authored (not
   stubs).
2. `references/sources/` for each skill contains the vendored artifacts listed above, current
   as of the fetch date, with a `sources/README.md` recording provenance + versions/tags.
3. `references/sources/INDEX.md` in each skill maps every topic to its file (the "thorough map").
4. `SPEC-SUMMARY.md` generated from both PIM specs; JSON/YAML validate.
5. `scripts/akeneo-pim/{fetch_docs.sh,gen_spec_summary.py}` and
   `scripts/akeneo-magento2/fetch_docs.sh` run cleanly and report a size delta.
6. Top-level `README.md` updated to list both skills.
7. Cross-links between the two skills resolve; connector skill defers generic Magento to
   `magento2-development`.
