# Embedded Source Docs — Topic Index (akeneo-pim-api-development)

The **complete map** of this skill — curated references, the two embedded specs, the Postman
collection, the docs prose, and the PHP client source. Use it to find what you need.

## How the skill is structured

```
akeneo-pim-api-development/
├── SKILL.md                              ← entry point; mental model, the two auth models, critical facts
├── scripts/akeneo-pim/
│   ├── fetch_docs.sh                     ← refresh specs + Postman + prose + PHP client (HTTPS_PROXY aware)
│   └── gen_spec_summary.py               ← regenerate SPEC-SUMMARY.md from both specs
├── references/                           ← curated guides (read first)
│   ├── getting-started.md
│   ├── authentication.md                 ← Connection (password) vs App (authorization-code + code_challenge)
│   ├── rest-api-overview.md
│   ├── products-and-models.md
│   ├── catalog-structure.md
│   ├── reference-entities-and-assets.md  ← EE / Serenity
│   ├── catalogs-and-mapping.md           ← Apps data-sharing
│   ├── events-and-webhooks.md            ← Event Platform (+ deprecated Events API)
│   ├── graphql.md
│   ├── apps-and-connections.md
│   ├── mcp-server.md
│   ├── php-client.md
│   ├── sdks-and-tools.md
│   ├── errors-and-rate-limits.md
│   ├── common-pitfalls.md
│   └── sources/                          ← embedded source-of-truth
│       ├── INDEX.md                      ← (this file)
│       ├── openapi-specs/                ← saas-openapi.json + classic-web-api.json + SPEC-SUMMARY.md + README
│       ├── postman/                      ← akeneo-postman-collection.json (152 requests)
│       ├── api-php-client-source/        ← akeneo/api-php-client (src + README + composer.json)
│       └── akeneo-official-docs/         ← pim-api-docs content prose (+ README with provenance)
```

## Topic → curated reference

| Topic / task | Curated reference |
| --- | --- |
| Editions/versions, base URL, first call, Postman import | `references/getting-started.md` |
| Auth: Connection password grant vs App authorization-code (+ OpenID, scopes, refresh) | `references/authentication.md` |
| Endpoint map, UUID vs identifier, pagination (`search_after`/`page`), filtering, upsert, HAL responses | `references/rest-api-overview.md` |
| Products, product models, the `{locale,scope,data}` value structure, media | `references/products-and-models.md` |
| Families, family variants, attributes, options/groups, association types, categories, channels, locales, currencies, measurement families | `references/catalog-structure.md` |
| Reference entities + Asset Manager (EE/Serenity) | `references/reference-entities-and-assets.md` |
| Catalogs API + product mapping schema (Apps) | `references/catalogs-and-mapping.md` |
| Event Platform (webhooks) + deprecated Events API + version-keyed events | `references/events-and-webhooks.md` |
| GraphQL API (Serenity) | `references/graphql.md` |
| Building Apps (App Store/custom, OAuth scopes) + UI Extensions | `references/apps-and-connections.md` |
| Akeneo MCP server | `references/mcp-server.md` |
| Official PHP client (`akeneo/api-php-client`) | `references/php-client.md` |
| SDK/tooling map (PHP, community, Postman, codegen, MCP) | `references/sdks-and-tools.md` |
| Status codes, error shapes, rate limits, pagination caps | `references/errors-and-rate-limits.md` |
| "Why isn't this working?" catalog | `references/common-pitfalls.md` |

## Topic → embedded source-of-truth

| Topic | File |
| --- | --- |
| Flat catalog of every operation + schema across both specs | `openapi-specs/SPEC-SUMMARY.md` |
| **SaaS / Serenity** Web API spec (OpenAPI 3.1.0, 152 ops) | `openapi-specs/saas-openapi.json` |
| **Classic CE/EE** REST spec (Swagger 2.0, 137 ops) | `openapi-specs/classic-web-api.json` (+ `.yaml`, `classic-swagger-src/`) |
| Example requests for every resource (152) | `postman/akeneo-postman-collection.json` |
| Official PHP client source (`Akeneo\Pim\ApiClient`) | `api-php-client-source/src/` (+ README, composer.json) |
| REST fundamentals prose (auth/pagination/filter/update/responses/permissions) | `akeneo-official-docs/rest-api/` |
| Data-model concepts (products, catalog-structure, reference-entities, asset-manager, pam, target-market-settings) | `akeneo-official-docs/concepts/` |
| Event Platform (current webhooks) | `akeneo-official-docs/event-platform/` |
| Deprecated Events API + migration | `akeneo-official-docs/events-api/` |
| Event payloads by PIM version (5.0/6.0/7.0/serenity) | `akeneo-official-docs/events-reference/` |
| Apps + App Portal (OAuth, catalogs, publishing) | `akeneo-official-docs/apps/`, `akeneo-official-docs/app-portal/` |
| GraphQL prose | `akeneo-official-docs/graphql/` |
| PHP client usage prose | `akeneo-official-docs/php-client/` |
| Product mapping schema (versioned) | `akeneo-official-docs/mapping/` |
| Akeneo MCP server prose | `akeneo-official-docs/mcp/` |
| UI Extensions | `akeneo-official-docs/extensions/`, `akeneo-official-docs/advanced-extensions/` |
| Onboarding tutorials + integration guides | `akeneo-official-docs/getting-started/`, `akeneo-official-docs/guides/`, `akeneo-official-docs/tutorials/` |

## The two specs at a glance

| File | Surface | Standard | Ops | Base path |
| --- | --- | --- | --- | --- |
| `saas-openapi.json` | SaaS / Serenity (UUID products, Catalogs, Workflows, Apps) | OpenAPI 3.1.0 | 152 | `{pim}/api/rest/v1/` |
| `classic-web-api.json` | Classic CE/EE (on-prem/PaaS) | Swagger 2.0 | 137 | `{pim}/api/rest/v1/` |

## The two auth models at a glance

| | Connection (Connector) | App |
| --- | --- | --- |
| Grant | `password` + `refresh_token` | `authorization_code` + code_challenge |
| Token endpoint | `POST {pim}/api/oauth/v1/token` | `POST {pim}/connect/apps/v1/oauth2/token` |
| Token life | access 1h / refresh 14d | non-expiring (revocable) |
| Detail | `references/authentication.md` | `references/authentication.md` + `references/apps-and-connections.md` |

## Search patterns

```bash
# Every operation for a resource (both specs, via the catalog)
grep -nE '/api/rest/v1/products' references/sources/openapi-specs/SPEC-SUMMARY.md

# A specific schema in the SaaS spec (don't open the 5MB file — grep it)
grep -n '"Product"' references/sources/openapi-specs/saas-openapi.json

# Real request body for a resource (Postman)
python3 -c "import json;d=json.load(open('references/sources/postman/akeneo-postman-collection.json'));print([i['name'] for i in d['item']])"

# The PHP client's resource getters
grep -rn 'public function get.*Api' references/sources/api-php-client-source/src/AkeneoPimClientInterface.php

# All event types documented for a PIM version
ls references/sources/akeneo-official-docs/events-reference/events-reference-serenity/
```

## Authoritative-source priority

1. The live PIM API (run the actual request against the instance).
2. The two specs in `openapi-specs/`.
3. The official `akeneo/api-php-client` source.
4. The embedded prose + Postman collection.
5. The curated references in this skill.
6. Past blog posts / tutorials.

## Refresh

`bash scripts/akeneo-pim/fetch_docs.sh` (add `HTTPS_PROXY=…` if proxied) then
`python3 scripts/akeneo-pim/gen_spec_summary.py`. Provenance is recorded in
`akeneo-official-docs/.source-commit` and `api-php-client-source/.source-tag`.
