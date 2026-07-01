# SDKs and Tools

Akeneo ships **one official SDK — the PHP client** (`akeneo/api-php-client`). There is **no official Python, JavaScript, Java, Go, or .NET SDK.** For every other language the supported path is to **generate a client from one of the two embedded specs** (OpenAPI 3.1.0 for SaaS, Swagger 2.0 for classic) or drive the API from the **official Postman collection**. This file is the practical tooling map; deep PHP-client usage lives in `php-client.md`, the MCP server in `mcp-server.md`.

## At-a-glance

| Tool | Kind | Languages | Maintainer | Status | Use for |
| --- | --- | --- | --- | --- | --- |
| `akeneo/api-php-client` | Official SDK | PHP ≥ 8.2 | Akeneo | Active | Any PHP integration; the Magento 2 connector |
| **OpenAPI codegen** from `saas-openapi.json` | Generate-your-own | Any (OAS 3.1) | You | — | Non-PHP clients on **SaaS/Serenity** |
| **Swagger codegen** from `classic-web-api.json` | Generate-your-own | Any (Swagger 2.0) | You | — | Non-PHP clients on **on-prem CE/EE** |
| **Postman collection** | Official examples | HTTP / any | Akeneo | Active | Exploration, manual calls, generating snippets |
| **Akeneo MCP server** | Official MCP | Any MCP host | Akeneo | Active (SaaS) | LLM/agent access to a PIM → see `mcp-server.md` |
| Community Python / Node clients | Unofficial | Python / JS | Third parties | Unverified | Convenience only — verify against the specs |

## Picking a path

| Situation | Use |
| --- | --- |
| PHP (incl. Magento connector) | `akeneo/api-php-client` → `php-client.md` |
| Python / JS / Go / Java / .NET / Rust, SaaS PIM | Generate from `saas-openapi.json` (OpenAPI 3.1.0) |
| Python / JS / … on an **on-prem** PIM | Generate from `classic-web-api.json` (Swagger 2.0) |
| Quick manual calls / debugging / learning | Postman collection |
| An LLM agent that reads/writes the PIM | Akeneo MCP server (`mcp-server.md`) |
| Deciding what an endpoint does | The specs — `references/sources/openapi-specs/` + `SPEC-SUMMARY.md` |

## The official PHP client

`akeneo/api-php-client` (namespace `Akeneo\Pim\ApiClient`, built via `AkeneoPimClientBuilder`) is the only first-party SDK. It's PSR-18/17 based, covers CE **and** EE in one unified package (the old `akeneo/api-php-client-ee` is archived and merged in), and is the exact library the Akeneo Connector for Magento 2 depends on. Full API — install, auth, pagination, upsert, media, exceptions — is in **`php-client.md`**.

```bash
composer require akeneo/api-php-client php-http/guzzle7-adapter:^1.0 http-interop/http-factory-guzzle:^1.0
```

## Community / unofficial SDKs (other languages)

Akeneo does **not** publish SDKs outside PHP. A handful of community wrappers exist (e.g. Python packages searchable on PyPI, Node wrappers on npm, sometimes named `akeneo-api-client` or similar). They are **unofficial, community-maintained, of varying freshness, and NOT vendored or verified in this skill** — treat any method name from them as unconfirmed, and cross-check every request/response against the two specs below. For anything long-lived, **generating from the spec is more reliable** than adopting an unmaintained wrapper: you get the current surface and can regenerate when the spec moves.

## Generating a client from the specs (the cross-language path)

Both machine-readable specs are embedded under `references/sources/openapi-specs/` and are the source of truth:

| Spec file | Format | Surface | Shape |
| --- | --- | --- | --- |
| `saas-openapi.json` | **OpenAPI 3.1.0** | SaaS / Serenity (UUID products, Catalogs, …) | ~92 paths / 152 operations / 94 schemas / 42 tags |
| `classic-web-api.json` | **Swagger 2.0** | Classic on-prem CE/EE | ~78 paths / 137 operations |

`SPEC-SUMMARY.md` in that folder is a flat catalog of every operation and schema across both.

```bash
# SaaS surface (OpenAPI 3.1.0) — use a generator with real 3.1 support
openapi-generator generate \
  -i references/sources/openapi-specs/saas-openapi.json \
  -g python -o ./akeneo-python

# TypeScript types straight from the spec
npx openapi-typescript references/sources/openapi-specs/saas-openapi.json -o akeneo-api.d.ts

# Classic on-prem surface (Swagger 2.0) — broadly supported by every generator
openapi-generator generate \
  -i references/sources/openapi-specs/classic-web-api.json \
  -g go -o ./akeneo-go

# Java, C#, PHP, Rust, etc.
openapi-generator generate -i .../saas-openapi.json -g java -o ./akeneo-java
```

**Watch the OpenAPI version when choosing a generator:**

- `saas-openapi.json` is **OpenAPI 3.1.0**. Older tools and **`swagger-codegen`** target Swagger 2.0 / OAS 3.0 and **choke on 3.1** (e.g. `type: ["string","null"]` unions, `$schema`, JSON-Schema-2020-12 keywords). Use a current **`openapi-generator`** (7.x) or a 3.1-aware tool. If your toolchain is stuck on 3.0, down-convert the spec first.
- `classic-web-api.json` is **Swagger 2.0** — supported by essentially every generator (`swagger-codegen`, `openapi-generator`, `oapi-codegen`, etc.).

**Auth is not generated for you.** As with any codegen, the generated client models the request/response shapes only — it does **not** implement Akeneo's OAuth. You still get a token yourself and set `Authorization: Bearer <token>`:

- **Connection**: `POST {pim}/api/oauth/v1/token`, `grant_type=password`, `client_id:secret` in a `Basic` header.
- **App**: authorization-code flow with a `code_challenge` at `POST {pim}/connect/apps/v1/oauth2/token` (non-expiring token).

Both flows and their pitfalls are in `authentication.md`. Point every generated client at the **customer's** PIM host (`{pim_url}`), not `api.akeneo.com` (that's the docs site).

## Postman collection

The official collection is embedded at `references/sources/postman/akeneo-postman-collection.json` (also public at `api.akeneo.com/files/akeneo-postman-collection.json`). It carries ~152 example requests mirroring the spec tags — the fastest way to poke the API by hand or to lift a correct request body.

1. Postman → **Import** → the JSON file.
2. Set collection/environment **variables**: your PIM base URL, `client_id`, `secret`, `username`/`password` (or an App/Bearer token).
3. Run the **token** request first, capture the access token into a variable, then fire the resource requests (they send `Authorization: Bearer {{token}}`).
4. **Code snippet** panel exports any request to cURL, Python `requests`, PHP, Node, Go, etc. — handy for bootstrapping a non-PHP integration without full codegen.

## Akeneo MCP server

For agent/LLM-driven access there's an official **Akeneo MCP server** (Model Context Protocol) that exposes PIM operations as tools — an alternative to writing REST or SDK code when the caller is an AI agent. Setup, available tools, and auth are in **`mcp-server.md`**.

## Spec-tracking discipline

Whatever you generate or wrap, **treat the two specs (and, for PHP, the client `src/`) as ground truth** — SDKs, generated code, and blog posts drift:

- The PHP client only exposes endpoints that existed when its version was cut (it's backward compatible but not forward — see the compatibility matrix in `php-client.md`).
- Generated clients are a snapshot; **regenerate when the spec changes.** SaaS is rolling/unversioned, so re-pull `saas-openapi.json` periodically.
- Community wrappers can lag arbitrarily and are unverified here.

Refresh the embedded specs/Postman with `bash scripts/akeneo-pim/fetch_docs.sh`, then `python3 scripts/akeneo-pim/gen_spec_summary.py` (per SKILL.md).

## Common mistakes

| Mistake | Fix |
| --- | --- |
| Looking for an official Python/JS SDK | There isn't one — generate from the spec or use Postman |
| Requiring `akeneo/api-php-client-ee` | Archived and merged into `akeneo/api-php-client` (see `php-client.md`) |
| Feeding `saas-openapi.json` to `swagger-codegen` | It's OpenAPI **3.1** — use current `openapi-generator`; down-convert if stuck on 3.0 |
| Generating from the wrong spec | SaaS/Serenity → `saas-openapi.json`; on-prem CE/EE → `classic-web-api.json` |
| Expecting codegen to handle auth | It doesn't — implement the token flow yourself (`authentication.md`) |
| Pointing a client at `api.akeneo.com` | That's the docs site; call the customer's `{pim_url}/api/rest/v1/…` |
| Trusting an unofficial wrapper's method names | Verify against the specs / `SPEC-SUMMARY.md` |

## Original sources

- `php-client.md` — the official PHP client (this skill)
- `mcp-server.md` — the Akeneo MCP server (this skill)
- `authentication.md` — Connection vs App OAuth flows (this skill)
- `references/sources/openapi-specs/saas-openapi.json` (OpenAPI 3.1.0) + `classic-web-api.json` (Swagger 2.0) + `SPEC-SUMMARY.md`
- `references/sources/postman/akeneo-postman-collection.json` (public: https://api.akeneo.com/files/akeneo-postman-collection.json)
- `references/sources/api-php-client-source/` — the official PHP client source
- Public docs: https://api.akeneo.com/ (docs site) · https://api.akeneo.com/php-client/introduction.html · Packagist: https://packagist.org/packages/akeneo/api-php-client
- openapi-generator: https://openapi-generator.tech · swagger-codegen: https://github.com/swagger-api/swagger-codegen
