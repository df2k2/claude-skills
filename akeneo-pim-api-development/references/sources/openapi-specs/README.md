# Akeneo API specs (embedded)

The **two** machine-readable specs Akeneo publishes for its Web API, plus a generated catalog.

| File | Product surface | Standard | `info.version` | Scale |
| --- | --- | --- | --- | --- |
| `saas-openapi.json` | **SaaS / Serenity** Web API (modern: UUID products, Catalogs, Workflows, Apps) | **OpenAPI 3.1.0** | 1.0.0 | 92 paths / **152 ops** / 94 schemas / 42 tags |
| `classic-web-api.json` (+ `.yaml`) | **Classic CE/EE** REST (on-prem / PaaS) | **Swagger 2.0** | — | 78 paths / **137 ops** |
| `classic-swagger-src/` | split source of the classic spec (`definitions.yaml`, `parameters.yaml`, `paths.yaml`, `responses.yaml`, `resources/`) | — | — | — |
| `SPEC-SUMMARY.md` | generated flat catalog of **both** specs (op + schema index) | — | — | 289 ops total |

Live source URLs (both public, HTTP 200, no auth):

- SaaS: `https://storage.googleapis.com/akecld-prd-pim-saas-shared-openapi-spec/openapi.json`
- Classic: `akeneo/pim-api-docs` → `content/swagger/akeneo-web-api.json` (this repo, commit `524078c`)

> **Two surfaces, one base path.** Both specs describe endpoints under **`{pim_url}/api/rest/v1/`**. The SaaS spec's server is templated `{your-pim-url}` — point it at the customer PIM. Use `saas-openapi.json` for Serenity/Growth work and `classic-web-api.json` for on-prem CE/EE. When they disagree with an SDK or a blog post, the spec (or the live API) wins.

## Refresh

```bash
bash scripts/akeneo-pim/fetch_docs.sh            # re-fetch both specs + Postman + prose + PHP client
python3 scripts/akeneo-pim/gen_spec_summary.py   # regenerate SPEC-SUMMARY.md from both specs
```

Add `HTTPS_PROXY=…` if your egress is proxied. `fetch_docs.sh` validates the JSON and reports a size delta.

## Code generation

```bash
# SaaS (OpenAPI 3.1.0)
openapi-generator generate -i saas-openapi.json -g php     -o akeneo-saas-php
openapi-generator generate -i saas-openapi.json -g typescript-fetch -o akeneo-saas-ts
npx @redocly/cli preview-docs saas-openapi.json            # interactive view

# Classic (Swagger 2.0)
openapi-generator generate -i classic-web-api.json -g python -o akeneo-classic-py
```

For most PHP integrations, prefer the official `akeneo/api-php-client` (see `../api-php-client-source/` and `references/php-client.md`) over generated code.
