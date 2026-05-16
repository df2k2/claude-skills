# claude-skills

A collection of [Claude](https://claude.ai) [skills](https://docs.anthropic.com/claude/skills) for ecommerce and web development work — heavyweight reference packs that load on demand when Claude detects a matching task.

Each skill is a self-contained directory with a `SKILL.md` (the entry point + description matcher) and a `references/` tree containing curated topic guides plus the raw upstream documentation. When the user's prompt matches a skill's `description`, Claude reads `SKILL.md` and decides which reference files to open. The reference files are written to be opened individually — not all at once — so a skill can ship megabytes of documentation without bloating the context window.

## Skills

| Skill | What it covers | Size |
|---|---|---|
| [`magento2-development/`](magento2-development/) | Adobe Commerce / Magento Open Source 2.4.x — PHP modules, DI, plugins, observers, EAV, declarative schema, layout XML, RequireJS / Knockout / UI components, Web APIs (REST / SOAP / GraphQL), admin area, CLI / cron / queues, indexing & caching, and Adobe Commerce-only features (B2B, Page Builder, Target Rule, Staging, MSI). Ships ~2 700 source markdown files from the official AdobeDocs and `magento/devdocs` repos. | 29 MB |
| [`hyva-magento2-development/`](hyva-magento2-development/) | Hyvä themes for Magento 2 — Hyvä 1.4.x with Tailwind CSS v4 and Alpine.js v3, phtml templates, Alpine components, view models, hyva.config.json, hyva-themes/magento2-* packages, Magewire / Hyvä Checkout, compatibility modules for Luma extensions, Tailwind v3→v4 migration. | 3.4 MB |
| [`ordergroove-api-development/`](ordergroove-api-development/) | OrderGroove subscription commerce platform — every REST endpoint, every GraphQL type, every webhook payload, the Subscription Manager front-end widget, platform integrations (Shopify, Recharge migration, etc.), Purchase POST, 1-click actions. | 11 MB |
| [`printful-api-development/`](printful-api-development/) | Printful print-on-demand developer API (v1 stable + v2 open beta) — catalog, orders, mockup generator, files, shipping rates, webhooks (incl. HMAC-SHA256 verification), Sync Products, warehouse products, approval sheets, OAuth scopes, Personal Access Tokens. Ships the full v2 OpenAPI spec (39 paths, 134 schemas) plus the official v1 PHP SDK source. | 908 KB |

## Layout

```
.
├── README.md                              ← you are here
├── magento2-development/
│   ├── SKILL.md
│   └── references/
│       ├── *.md                           ← curated topic guides
│       └── sources/                       ← upstream docs (commerce-php, commerce-webapi, commerce-frontend-core, devdocs-v2.4)
├── hyva-magento2-development/
│   ├── SKILL.md
│   ├── evals/
│   └── references/
│       ├── *.md
│       └── sources/                       ← Hyvä docs from hyva-themes/website + community docs
├── ordergroove-api-development/
│   ├── SKILL.md
│   └── references/
│       ├── 01-getting-started/
│       ├── 02-data-model/
│       ├── 03-endpoints/                  ← 114 REST endpoint files
│       ├── 04-webhooks/
│       ├── 05-graphql/
│       ├── 06-subscription-manager/
│       ├── 07-guides/
│       └── 08-platform-integrations/
├── printful-api-development/
│   ├── SKILL.md
│   └── references/
│       ├── INDEX.md                       ← topic map
│       ├── 01-overview-and-versioning.md
│       ├── … (17 curated guides) …
│       ├── 17-common-pitfalls.md
│       └── sources/
│           ├── printful-v2-openapi.json   ← canonical OpenAPI 2.0.0-beta
│           ├── printful-v2-endpoints.md   ← auto-generated endpoint catalog
│           ├── printful-v2-schemas.md     ← auto-generated schema catalog
│           └── Printful*.php              ← official v1 PHP SDK
├── misc/                                  ← packaged `.skill` archives + work-in-progress sketches
└── scripts/                               ← helper scripts for refreshing each skill's source docs
    ├── hyva/
    ├── magento2/
    └── printful/
```

## Using a skill

### In Claude Code or any Claude harness with skills enabled

Drop the skill directory (or a symlink to it) into your skills directory:

```bash
# Claude Code default location
mkdir -p ~/.claude/skills
ln -s "$PWD/printful-api-development" ~/.claude/skills/

# Or for a project-scoped skill, drop it under <repo>/.claude/skills/
mkdir -p .claude/skills
ln -s "$PWD/../claude-skills/printful-api-development" .claude/skills/
```

Restart your Claude harness. The skill loads automatically when Claude detects a matching task — you don't have to invoke it manually.

### Packaged `.skill` archives

The `misc/` directory ships `.skill` files (zip archives with the same internal layout) that some harnesses can install directly. See your harness's docs for the install command.

## Refreshing the upstream documentation

Every skill that embeds upstream docs has a fetch script under `scripts/<skill>/`:

```bash
# Magento 2 / Adobe Commerce — re-clones the AdobeDocs repos + magento/devdocs v2.4
./scripts/magento2/fetch_docs.sh

# Hyvä — fetches the curated link lists in scripts/hyva/*.txt
python3 ./scripts/hyva/fetch_links_to_md.py

# Printful — re-fetches the v2 OpenAPI spec + the official PHP SDK source
./scripts/printful/fetch_docs.sh
```

Run periodically (e.g. quarterly) to keep the embedded docs current. Each script regenerates any auto-generated INDEX / catalog files and reports a size delta so you can review the diff before committing.

## Adding a new skill

The existing skills follow a deliberate template:

1. **One directory per skill**, named `<topic>-development` (or similar).
2. **`SKILL.md`** at the root with YAML frontmatter:
   - `name` — kebab-case, matches the directory.
   - `description` — *long*. Enumerates every trigger phrase, endpoint, file name, technology, and synonym Claude might see. The longer and more specific the description, the more reliably the skill loads. The `magento2-development` skill's description is ~3 KB; the `printful-api-development` skill's is ~1.6 KB. This is by design — don't be terse.
3. **A "Critical things to know up-front" section** in `SKILL.md` — the 5–10 facts that come up in every task. Auth, base URL, response envelope, gotchas. Most "Claude wrote wrong code" failures trace back to one of these.
4. **A `references/` directory** with curated topic guides (`01-…md`, `02-…md`, …) and an `INDEX.md` or task-quickstart table that maps "user asked about X" → "open file Y".
5. **A `references/sources/` directory** (optional but recommended) with the raw upstream documentation, vendored at a known commit. Use a fetch script (`scripts/<skill>/fetch_docs.sh`) to refresh it.
6. **Don't try to write a "master" reference that covers everything in one file** — Claude reads files individually, and a 50 KB master file costs context that smaller files don't. Split by topic.

Cross-skill conventions:

- Reference files end with an **"Original sources"** pointer listing the upstream files that informed them. Makes it easy to update when upstream changes.
- API skills include a **task→endpoint quickstart table** in `SKILL.md` for the highest-frequency operations.
- API skills include a **"Things to avoid"** section in `SKILL.md` plus a longer `common-pitfalls.md` reference.
- Auto-generated catalog files (e.g. endpoint listings derived from an OpenAPI spec) live under `sources/` so they're trivially regeneratable, not under the curated `references/` root.

## License

The skills themselves (the markdown files in `SKILL.md` and `references/*.md`) are under this repo's license. The embedded `sources/` trees retain their original upstream licenses (Adobe / Magento / Hyvä / OrderGroove / Printful) — see the source file headers for details. Do not redistribute the `sources/` trees as standalone work.
