# Akeneo official docs (embedded prose)

Curated prose vendored from **`akeneo/pim-api-docs`** (the source of [api.akeneo.com](https://api.akeneo.com)), commit `524078c23ed1145375b6e197aeb102042ad72804`. Only the documentation content is vendored — the site's build assets, fonts, and images are excluded.

| Directory | What's here |
| --- | --- |
| `rest-api/` | REST fundamentals: authentication (+ `authentication_old`), overview, pagination, filter, update, responses, permissions, good-practices, troubleshooting |
| `concepts/` | Data-model concepts: products, catalog-structure, reference-entities, asset-manager, pam (legacy), target-market-settings |
| `event-platform/` | The **current** Event Platform (webhooks): concepts, getting-started, auth, filters, behaviors, notification-webhooks, migration |
| `events-api/` | The **deprecated** original Events API + migration guide |
| `events-reference/` | Version-keyed event payload references: `events-reference-{5.0,6.0,7.0,serenity}` |
| `apps/` + `app-portal/` | Building Apps + publishing on the App Store; App OAuth; catalogs; securing an app |
| `graphql/` | The GraphQL API (Serenity) |
| `php-client/` | Usage docs for `akeneo/api-php-client` (source vendored separately under `../api-php-client-source/`) |
| `mapping/` | Product **mapping schema** (versioned) for Apps/Catalogs |
| `mcp/` | The Akeneo **MCP server** |
| `extensions/` + `advanced-extensions/` | UI Extensions (links / iframes / actions in the PIM UI) |
| `getting-started/` + `guides/` + `tutorials/` | Onboarding tutorials (version-tagged) + integration guides (ERP/ecommerce/DAM/print/syndication/translation) |
| `px-insights/` + `supplier-data-manager/` + `misc/` | Adjacent product surfaces (PX Insights, Supplier Data Manager) + misc |

## Refresh

```bash
bash scripts/akeneo-pim/fetch_docs.sh   # re-clones pim-api-docs (sparse content/) and re-copies the allow-listed prose
```

The commit the prose was vendored at is recorded in `.source-commit`.

## Licensing

This prose is © Akeneo and retains its upstream terms. It is embedded here as reference material for building against the Akeneo API. Do not redistribute the `sources/` tree as standalone work.
