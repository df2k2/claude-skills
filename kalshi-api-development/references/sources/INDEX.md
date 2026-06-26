# Embedded Source Docs — Topic Index

This is the **complete map** of every part of the skill — curated references, embedded SDK snippets, OpenAPI/AsyncAPI specs, and the gated official docs. Use this to find what you need.

## How the skill is structured

```
kalshi-api-development/
├── SKILL.md                              ← entry point; full mental model
├── references/                           ← curated guides (read first)
│   ├── getting-started.md
│   ├── authentication-rsa-pss.md
│   ├── rest-api-overview.md
│   ├── markets-events-series.md
│   ├── orders-and-trading.md
│   ├── portfolio-and-balance.md
│   ├── websocket-api.md
│   ├── fix-protocol.md
│   ├── perps-margin.md
│   ├── sdks-and-tools.md
│   ├── errors-and-rate-limits.md
│   ├── common-pitfalls.md
│   └── sources/                          ← embedded source material
│       ├── INDEX.md                      ← (this file)
│       ├── openapi-specs/                ← canonical spec YAMLs (see below)
│       ├── sdk-snippets/                 ← captured SDK READMEs
│       └── kalshi-official-docs/         ← captured docs.kalshi.com snapshot
└── scripts/kalshi/fetch_docs.sh          ← refresh script
```

## The full topic → file map

### Topic → curated reference

| Topic / task | Curated reference |
| --- | --- |
| What is Kalshi, what's the API surface, when to use this skill | `SKILL.md` |
| First API call, demo vs prod, key setup | `references/getting-started.md` |
| RSA-PSS signing — algorithm, headers, code (Python / Node / Go / Rust / curl) | `references/authentication-rsa-pss.md` |
| Endpoint map of `trade-api/v2` (exchange / series / events / markets / portfolio / etc.) | `references/rest-api-overview.md` |
| Series / event / market ticker scheme; catalog discovery flow | `references/markets-events-series.md` |
| Placing orders — legacy `/portfolio/orders` and V2 `/portfolio/events/orders` | `references/orders-and-trading.md` |
| Reading portfolio: balance / positions / fills / settlements / deposits / withdrawals | `references/portfolio-and-balance.md` |
| WebSocket: 12 channels, subscriptions, sequencing, reconnect, orderbook reconstruction | `references/websocket-api.md` |
| FIX protocol (FIXT.1.1 / FIX50SP2): sessions, logon, NewOrderSingle, recovery | `references/fix-protocol.md` |
| Perpetual futures / margin: separate hosts, separate keys, funding, mark price, Klear | `references/perps-margin.md` |
| Comparing SDKs (official sync/async, kalshi-sdk, pykalshi, kalshi-client) | `references/sdks-and-tools.md` |
| HTTP status codes, error shapes, retry policy, idempotency, rate limits, endpoint costs | `references/errors-and-rate-limits.md` |
| The "why isn't this working?" catalog | `references/common-pitfalls.md` |

### Topic → official docs page (gated; for refresh)

When the skill's curated docs aren't enough, the canonical detail lives at `docs.kalshi.com`. These pages are gated behind Cloudflare — see "Refreshing the docs snapshot" below.

| Topic | Official URL (gated) |
| --- | --- |
| Welcome / intro | https://docs.kalshi.com/welcome |
| API changelog | https://docs.kalshi.com/changelog |
| Quick start: authenticated requests | https://docs.kalshi.com/getting_started/quick_start_authenticated_requests |
| Quick start: market data | https://docs.kalshi.com/getting_started/quick_start_market_data |
| Historical data | https://docs.kalshi.com/getting_started/historical_data |
| SDKs overview | https://docs.kalshi.com/sdks/overview |
| API reference — Exchange | https://docs.kalshi.com/api-reference/exchange/... |
| API reference — Series (list, get) | https://docs.kalshi.com/api-reference/market/get-series-list, ... |
| API reference — Events (list, get) | https://docs.kalshi.com/api-reference/events/get-events, get-event |
| API reference — Markets (list, get, orderbook, candlesticks, history) | https://docs.kalshi.com/api-reference/market/get-market, get-markets, get-market-orderbook, get-trades, ... |
| API reference — Orders (legacy) | https://docs.kalshi.com/api-reference/orders/create-order, get-order, ... |
| API reference — Orders V2 | https://docs.kalshi.com/api-reference/orders/create-order-v2 |
| API reference — Portfolio (balance, positions, fills, settlements) | https://docs.kalshi.com/api-reference/portfolio/get-balance, ... |
| API reference — Live data | https://docs.kalshi.com/api-reference/live-data/get-live-data |
| API reference — WebSocket channels | https://docs.kalshi.com/api-reference/websocket/... |

### Topic → embedded source file

After running `scripts/kalshi/fetch_docs.sh` from a real-browser-capable environment:

| Topic | File |
| --- | --- |
| **`llms.txt`** — full plain-text bundle of docs.kalshi.com (URL index + every page's prose; Mintlify convention). The single best file to harvest. | `references/sources/kalshi-official-docs/llms.txt` |
| **`llms-full.txt`** — extended variant of llms.txt (longer/more complete) | `references/sources/kalshi-official-docs/llms-full.txt` |
| **OpenAPI** for event-contracts REST | `references/sources/openapi-specs/openapi.yaml` |
| **AsyncAPI** for event-contracts WebSocket | `references/sources/openapi-specs/asyncapi.yaml` |
| **OpenAPI** for perps REST | `references/sources/openapi-specs/perps_openapi.yaml` |
| How to refresh the spec files | `references/sources/openapi-specs/README.md` |
| Captured docs.kalshi.com individual pages | `references/sources/kalshi-official-docs/` |
| TexasCoding kalshi-python-sdk README | `references/sources/sdk-snippets/kalshi-python-sdk/README.md` |
| arshka pykalshi README | `references/sources/sdk-snippets/pykalshi/README.md` |
| vaguenebula kalshi-client README | `references/sources/sdk-snippets/kalshi-client/README.md` |
| Legacy lowgrind kalshi-python README (deprecated) | `references/sources/sdk-snippets/kalshi-python-legacy/README.md` |

## The OpenAPI / AsyncAPI / Perps OpenAPI specs

### Spec inventory

Kalshi publishes three machine-readable specs:

| File | URL | Purpose | Approx scope |
| --- | --- | --- | --- |
| `openapi.yaml` | https://docs.kalshi.com/openapi.yaml | Event-contracts REST | OpenAPI v3.21.0, 104 ops, 19 resources |
| `asyncapi.yaml` | https://docs.kalshi.com/asyncapi.yaml | Event-contracts WebSocket | 12 typed channels + 2 escape-hatch (`control_frames`, `root`) |
| `perps_openapi.yaml` | https://docs.kalshi.com/perps_openapi.yaml | Perpetual-futures REST | 34 ops, 8 resource groups |

### What lives in each spec

#### `openapi.yaml` — REST event-contracts

Resource groups (19):

```
/exchange/*                 status, schedule, announcements, endpoint_costs
/series/*                   list, get
/events/*                   list, get (optional with_nested_markets)
/markets/*                  list (filterable), get, orderbook, candlesticks, history
/markets/trades             public trades feed
/portfolio/balance          wallet balance
/portfolio/positions        positions
/portfolio/orders           LEGACY single-market orders (deprecated >= May 6, 2026)
/portfolio/events/orders    V2 event-scoped orders (spec ≥ 3.18.0)
/portfolio/fills            executions
/portfolio/settlements      settled positions
/portfolio/deposits         funding inflows
/portfolio/withdrawals      funding outflows
/portfolio/order_groups     order groups
/communications/*           announcements
/multivariate/*             multivariate (parlay) markets
/live-data                  convenience aggregator
/account/*                  account info + endpoint costs
/auth/login, /auth/logout   legacy session auth (deprecated)
```

Embedded base URLs:

- Production: `https://api.elections.kalshi.com/trade-api/v2`
- Demo: `https://demo-api.kalshi.co/trade-api/v2`

#### `asyncapi.yaml` — WebSocket event-contracts

12 typed channels:

```
ticker                       best bid/ask per market
trade                        public trades feed
orderbook_delta              snapshot + deltas
fill                         your fills
market_positions             your positions
user_orders                  your order lifecycle
order_group                  group lifecycle
market_lifecycle             open/close/settle events
multivariate                 multivariate market updates
multivariate_lifecycle       multivariate lifecycle
communications               announcements
cfbenchmarks_value           index values
```

Plus escape-hatch channels: `control_frames`, `root`.

Embedded URLs:

- Production: `wss://api.elections.kalshi.com/trade-api/ws/v2`
- Demo: `wss://demo-api.kalshi.co/trade-api/ws/v2`

#### `perps_openapi.yaml` — REST perpetual futures

Resource groups (8):

```
/exchange/*       status, schedule
/markets/*        perps market catalog + ticker / orderbook / trades
/orders/*         perps orders (with reduce_only, post_only)
/order_groups/*   perps order groups
/portfolio/*      balance, positions
/margin/*         balance, risk, fees
/funding/*        funding rate, history
/transfers/*      sub-account transfers
```

Embedded base URLs:

- Production: `https://external-api.kalshi.com/trade-api/v2`
- Demo: `https://external-api.demo.kalshi.co/trade-api/v2`

Perps uses **separate API keys** from event-contracts even though the auth scheme (RSA-PSS) is identical.

### Why the specs may be empty / placeholder

`docs.kalshi.com` is fronted by Cloudflare. Plain `curl` / WebFetch / fetch from CI runners commonly returns HTTP 403 ("Just a moment…"). When the skill is first checked out, the spec files may be placeholders or empty. Run the fetch script from a real-browser-capable environment to populate them.

### Refreshing the spec files

See `references/sources/openapi-specs/README.md` for:

- The standard `scripts/kalshi/fetch_docs.sh` flow (works from most workstations + most CI).
- The headless-browser recipe (Playwright) for when Cloudflare blocks plain curl.

### Using the specs

Once present, the specs feed standard OpenAPI/AsyncAPI tooling:

```bash
# Python
openapi-python-client generate --path openapi.yaml --meta poetry

# TypeScript
openapi-typescript openapi.yaml -o kalshi-api.ts

# Go
oapi-codegen -package kalshi openapi.yaml > kalshi.gen.go

# Rust
openapi-generator generate -i openapi.yaml -g rust -o kalshi-rs

# View interactively
npx @redocly/cli preview-docs openapi.yaml
```

## The SDK snippets

### `kalshi-python-sdk` (TexasCoding, MIT)

The most comprehensive community SDK. Covers REST + WebSocket + FIX for both event-contracts and perps, plus Klear settlement. The captured README at `sdk-snippets/kalshi-python-sdk/README.md` is the single best public reference for the modern API contract.

Highlights captured:

- REST: 104 operations across 19 resources.
- WebSocket: 12 typed `subscribe_*` channels.
- FIX: `FixClient` (prediction) + `MarginFixClient` (perps) with FIXT.1.1 / FIX50SP2.
- Perps: `PerpsClient` / `AsyncPerpsClient` / `PerpsWebSocket`.
- Klear: `KlearClient` (Bearer-token auth, NOT RSA-PSS).
- V2 event-market orders.

### `pykalshi` (arshka, MIT)

Streaming-focused SDK. Local orderbook state, pandas DataFrame integration, Jupyter-friendly. Less comprehensive REST coverage but cleaner for analysis.

### `kalshi-client` (vaguenebula, MIT)

Minimal, single-purpose REST wrapper. Best for quick scripts and learning the API. Fixes some outdated code from old Kalshi docs.

### `kalshi-python-legacy` (lowgrind, Apache-2.0) — DEPRECATED

The original Swagger-generated SDK with email/password auth and integer-cent `yes_price`. Bundled for historical context only. **Don't use for new code.**

## Headless capture: filling in the official-docs snapshot

`references/sources/kalshi-official-docs/README.md` contains the headless-browser recipe. Summary:

1. Enumerate URLs via Wayback CDX:
   ```bash
   curl -s "http://web.archive.org/cdx/search/cdx?url=docs.kalshi.com/*&output=text&fl=original&collapse=urlkey&limit=2000" \
     | grep -E '^https://docs\.kalshi\.com/' > urls.txt
   ```
2. Render each page in headless Chromium (Playwright):
   ```python
   page.goto(url, wait_until="networkidle")
   page.wait_for_selector("article, main, .content", timeout=30_000)
   html = page.content()
   ```
3. Convert HTML → markdown with turndown / markdownify, mirroring the URL path.

The resulting tree should look like:

```
kalshi-official-docs/
├── welcome.md
├── changelog.md
├── getting_started/
│   ├── quick_start_authenticated_requests.md
│   ├── quick_start_market_data.md
│   └── historical_data.md
├── sdks/
│   └── overview.md
└── api-reference/
    ├── exchange/...
    ├── events/get-event.md, get-events.md
    ├── market/get-market.md, get-market-orderbook.md, get-series-list.md, get-trades.md
    ├── orders/create-order.md, create-order-v2.md, get-order.md
    ├── portfolio/get-balance.md
    └── ... etc
```

## Search patterns

```bash
# Find every endpoint mentioned in the bundled SDK snippets
grep -rn -E "/trade-api/v[0-9]/[a-z/]+" references/sources/sdk-snippets/

# Find the V2 order shape
grep -A 20 "CreateOrderV2Request" references/sources/sdk-snippets/kalshi-python-sdk/README.md

# Find every WebSocket channel referenced
grep -nE 'subscribe_[a-z_]+' references/sources/sdk-snippets/kalshi-python-sdk/README.md

# Find every host (when specs are present)
grep -E 'https?://[a-z.-]+\.kalshi\.(com|co)' references/sources/openapi-specs/*.yaml
```

## Refreshing

`scripts/kalshi/fetch_docs.sh` is the canonical refresh path:

```bash
bash scripts/kalshi/fetch_docs.sh
```

What it does:

1. Tries to fetch `llms.txt`, `llms-full.txt`, `openapi.yaml`, `asyncapi.yaml`, `perps_openapi.yaml` from `docs.kalshi.com` (in that priority order — `llms.txt` is the highest-value file since it bundles the entire site as plain text).
2. Clones the community SDK repos to update `sdk-snippets/`.
3. Creates / updates `kalshi-official-docs/README.md` with the headless-capture recipe.

If Cloudflare or sandbox restrictions block the script, follow the headless recipe in `kalshi-official-docs/README.md` — the script writes that file with up-to-date instructions every run.

### Quick fact about `llms.txt`

`llms.txt` is a Mintlify-platform convention (Kalshi's docs are Mintlify-hosted). For any Mintlify-powered docs site, `/llms.txt` returns the URL index of all pages, and `/llms-full.txt` returns the URL index **plus** the concatenated full content of every page. For LLM-consumption purposes, **harvesting `llms-full.txt` alone is usually equivalent to harvesting the entire doc site**. Always try those two URLs first.

## Authoritative-source priority

When in doubt about an API contract:

1. The live API itself (run the actual request).
2. The OpenAPI / AsyncAPI / Perps OpenAPI YAML — `references/sources/openapi-specs/`.
3. The auto-generated official SDKs (`kalshi_python_sync` / `kalshi_python_async`) regenerated this week.
4. The community SDKs (especially `kalshi-sdk` by TexasCoding).
5. The curated references in this skill.
6. Past blog posts / tutorials.
