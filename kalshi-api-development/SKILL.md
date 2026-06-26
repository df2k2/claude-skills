---
name: kalshi-api-development
description: "Build, integrate, and debug applications against the Kalshi prediction-markets and perpetual-futures API at docs.kalshi.com — REST (event-contracts at `api.elections.kalshi.com/trade-api/v2` and perps at `external-api.kalshi.com/trade-api/v2`), WebSocket (12 typed `subscribe_*` channels), and FIX (FIXT.1.1 / FIX50SP2) protocols. Use this skill whenever the user is integrating Kalshi for trading, querying market data (markets / events / series / orderbooks / trades / candlesticks), placing orders (legacy `/portfolio/orders` and V2 event-scoped `/portfolio/events/orders` introduced in spec v3.18.0), reading portfolio (balance / positions / fills / settlements / deposits / withdrawals), debugging RSA-PSS signed requests (`KALSHI-ACCESS-KEY` / `KALSHI-ACCESS-TIMESTAMP` / `KALSHI-ACCESS-SIGNATURE`), generating clients from the official `openapi.yaml` / `asyncapi.yaml` / `perps_openapi.yaml` specs, streaming `ticker` / `trade` / `orderbook_delta` / `fill` / `user_orders` / `order_group` / `market_lifecycle` / `multivariate` / `communications` / `cfbenchmarks_value`, working with order groups, multivariate (parlay-style) markets, FIX order-entry / drop-copy / market-data / post-trade / RFQ sessions, perps margin/funding/transfers/Klear-settlement APIs, or switching between demo (`demo-api.kalshi.co`) and production environments. Trigger on mentions of Kalshi, docs.kalshi.com, kalshi.com, prediction market, event contract, KXNBAGAME, KXFED, KXPRES (and other K-prefixed Kalshi tickers), `api.elections.kalshi.com`, `demo-api.kalshi.co`, `external-api.kalshi.com`, `trade-api/v2`, KalshiClient, kalshi_python, kalshi-python-sync, kalshi-python-async, kalshi-sdk, pykalshi, RSA-PSS signature for Kalshi, KALSHI-ACCESS-SIGNATURE, KALSHI-ACCESS-TIMESTAMP, KALSHI-ACCESS-KEY, yes_price / no_price (cents or decimal-dollars), series_ticker, event_ticker, market ticker, orderbook_delta, market_lifecycle, multivariate market, perpetual futures Kalshi, perps margin, Klear settlement, FIX order entry, drop copy, RFQ session, KalshiAuth, KalshiConfig, openapi.yaml Kalshi, asyncapi.yaml Kalshi, perps_openapi.yaml, market maker on Kalshi, Kalshi sandbox, Kalshi demo environment, Kalshi rate limit, endpoint cost. Trigger even when the user just says 'prediction market API' if context suggests Kalshi (mentioning `KX*` tickers, the RSA-PSS scheme, or a docs.kalshi.com link). NOTE: docs.kalshi.com is fronted by Cloudflare — plain `curl`/WebFetch returns HTTP 403 against the doc pages and YAML specs. The skill ships a fetch script (`scripts/kalshi/fetch_docs.sh`) that works from normal developer environments + a headless-browser recipe for sandboxes; treat the OpenAPI / AsyncAPI / Perps OpenAPI specs as the source of truth when SDKs and curated docs disagree."
---

# Kalshi API Development

[Kalshi](https://kalshi.com) is a CFTC-regulated event-contract (prediction-markets) exchange plus a perpetual-futures exchange. Its public API is the developer-facing trading surface for both — REST + WebSocket + FIX, with separate hosts and separate API keys for the two products. This skill is the developer guide to that surface.

The skill ships with three layers of documentation:

1. **Curated references** in `references/*.md` — synthesized guides for every part of the API with example payloads, code recipes, and gotchas. Read these first.
2. **OpenAPI / AsyncAPI / Perps OpenAPI specs** in `references/sources/openapi-specs/` — the YAML files Kalshi publishes at `https://docs.kalshi.com/{openapi,asyncapi,perps_openapi}.yaml`. **These are the authoritative source-of-truth for request/response shapes.** When the curated docs and the specs disagree, trust the specs. (Note: present only after running the fetch script in a real-browser-capable environment; see the section on docs hosting below.)
3. **SDK source snippets** in `references/sources/sdk-snippets/` — captured READMEs and selected source from the major Python SDKs: `kalshi-python-sdk` (TexasCoding; comprehensive, current); `kalshi-client` (vaguenebula; lightweight); `pykalshi` (arshka; streaming-focused); legacy `kalshi-python` (lowgrind; deprecated email/password auth).

> ⚠ **`docs.kalshi.com` is fronted by Cloudflare.** Plain `curl` / WebFetch / fetch from CI runners or sandboxes commonly returns HTTP 403 ("Just a moment…"). The skill's curated references distill the public contract reliably; for exact endpoint detail, run `scripts/kalshi/fetch_docs.sh` from a normal developer environment (or use the headless-browser recipe in `references/sources/openapi-specs/README.md`) to populate the spec files locally. When in doubt, sign in at `dashboard.kalshi.com`-side / the Kalshi docs site interactively.

## Scope and versions

This skill targets the **current** (2026) Kalshi API surface:

| Product | REST host (prod) | REST host (demo) | WebSocket (prod) | Spec |
| --- | --- | --- | --- | --- |
| Event contracts (prediction markets) | `https://api.elections.kalshi.com/trade-api/v2` | `https://demo-api.kalshi.co/trade-api/v2` | `wss://api.elections.kalshi.com/trade-api/ws/v2` | `openapi.yaml` v3.21.0 (104 ops, 19 resources) + `asyncapi.yaml` (12 channels) |
| Perpetual futures (margin) | `https://external-api.kalshi.com/trade-api/v2` | `https://external-api.demo.kalshi.co/trade-api/v2` | `wss://external-api.kalshi.com/trade-api/ws/v2` | `perps_openapi.yaml` (34 ops, 6 WS channels) |

- **Trade API version**: `v2`. The legacy `v1` is gone. Old SDKs that say `api.kalshi.com/v1/...` are historical only.
- **Order surface**: legacy `/portfolio/orders` (single-market) still works; **V2 event-scoped orders** at `/portfolio/events/orders/*` are the modern path (spec v3.18.0+). Legacy will be deprecated **no earlier than May 6, 2026**.
- **Auth**: per-request **RSA-PSS** signatures using `KALSHI-ACCESS-KEY` / `KALSHI-ACCESS-TIMESTAMP` / `KALSHI-ACCESS-SIGNATURE` headers. Email/password auth shown in the very old (2022-era) Swagger-generated SDK is **gone**.
- **FIX**: FIXT.1.1 transport with FIX50SP2 application messages; sessions for order-entry, drop-copy, market-data, post-trade (event-contracts only), and RFQ (event-contracts only).
- **Klear settlement API**: a separate Self-Clearing-Member API (9 ops) used by SCMs; **Bearer-token auth, not RSA-PSS**.

If the user is targeting `api.kalshi.com/v1/...`, `trading-api.kalshi.com`, email/password login, or `cents`-denominated `yes_price` in `Portfolio.CreateOrder`, they're on the legacy surface — stop and ask whether to migrate.

## When to consult this skill vs. just answer

Trigger on:

- Any work against `*.kalshi.com` / `*.kalshi.co` (or the WebSocket equivalents).
- A failed Kalshi request, a 401/403, a webhook/streaming connection issue, an RSA signature error.
- Anything about `productUid`-equivalents in Kalshi: `series_ticker`, `event_ticker`, `market_ticker`.
- Reading or writing the Kalshi `openapi.yaml` / `asyncapi.yaml` / `perps_openapi.yaml`.
- Choosing between the legacy single-market order API and the V2 event-scoped one.
- WebSocket sequencing (`seq` field), orderbook delta reconstruction, snapshot-then-delta synchronization.
- FIX session setup, sequence-gap recovery, RSA-PSS logon credentials.
- Perps-specific concepts: funding rate, mark price, margin/risk, transfers, Klear settlement.

Defer when the user's task is dominated by a host platform unrelated to Kalshi (e.g., a strategy backtest framework that happens to ingest Kalshi data; that's quant-finance territory).

## How the Kalshi API fits together (mental model)

```
                         Kalshi Trade API (event-contracts)
                                       │
                  ┌────────────────────┼─────────────────────┐
                  ▼                    ▼                     ▼
                REST               WebSocket                FIX
   api.elections.kalshi.com   wss://...trade-api/ws/v2    Order-entry / Drop-copy
   /trade-api/v2              12 typed channels           Market-data / Post-trade / RFQ
                  │                    │                     │
                  └──── all share ─────┴────── RSA-PSS auth ──┘
                              (KALSHI-ACCESS-KEY +
                               KALSHI-ACCESS-TIMESTAMP +
                               KALSHI-ACCESS-SIGNATURE)

                         Kalshi Perps API (perpetual futures)
                                       │
                  ┌────────────────────┼─────────────────────┐
                  ▼                    ▼                     ▼
                REST               WebSocket                FIX
   external-api.kalshi.com    wss://external-api...    MarginFixClient
   /trade-api/v2              6 channels (incl. ticker
                              with funding_rate)
                  │                    │                     │
                  └────── all share RSA-PSS auth, but        │
                          DIFFERENT API KEYS                 │
                                                             ▼
                                                Klear settlement API
                                                Bearer-token auth (NOT RSA-PSS)
                                                Self-Clearing-Member only
```

### Key concepts

- **Series / Event / Market** — three nested levels:
  - A **series** is a recurring market theme. `series_ticker` example: `KXNBAGAME` (NBA game outcomes), `KXFED` (FOMC meetings).
  - An **event** is one instance under a series. `event_ticker` example: `KXNBAGAME-26MAY25NYKCLE` (NYK vs CLE on 2025-05-26 under KXNBAGAME).
  - A **market** is one tradable contract under an event. `market_ticker` example: `KXNBAGAME-26MAY25NYKCLE-NYK` (NYK wins). Yes/no binary markets are most common; multi-outcome are modelled as multiple markets under one event.

- **yes / no sides** — Every binary market has YES and NO. Buying YES at $0.65 ↔ selling NO at $0.35 are economically identical. Order APIs accept `side: "yes" | "no"` for legacy / `side: "bid" | "ask"` for V2 event-scoped.

- **Price** — Dollars in `Decimal` form. V2 spec uses `Decimal` with up to 4 decimal places (e.g., `"0.6500"`). The legacy `/portfolio/orders` accepts both forms in some SDK variants (some serialize as integer cents, others as dollar strings); **always check what shape your specific client emits**.

- **Time in force** (`time_in_force`) — `good_till_canceled`, `immediate_or_cancel`, `fill_or_kill`, `good_till_date`.

- **client_order_id** — Your idempotency key. UUID is the convention. Re-send the same ID to safely retry a `create_order` after a network hiccup.

- **Order group** — A bundle of related orders. Cancelling the group cancels them all. Used in basket strategies and multi-leg trades. The WebSocket `order_group` channel streams group lifecycle.

- **Orderbook delta** — WebSocket `orderbook_delta` channel streams incremental price-level changes. To maintain a local book, you snapshot (REST `GET /markets/{ticker}/orderbook`) then apply deltas in `seq` order.

- **fill** — A partial or full execution of an order. The `fill` WS channel streams yours.

- **Multivariate markets** — Parlay-style markets that depend on multiple underlying events. Separate REST + WS surface.

- **Perps funding** — Perpetual contracts pay/receive funding periodically. WS `ticker` includes `funding_rate` and `next_funding_time_ms`.

## Confirm before assuming

Before writing integration code:

1. **Which product?** Event contracts (`api.elections.kalshi.com`) or perps (`external-api.kalshi.com`). Different keys.
2. **Demo or production?** Demo is at `demo-api.kalshi.co` and is permissive (no real money, market data shape may differ). Sign up at the demo URL separately if you don't already have a demo account.
3. **Legacy or V2 orders?** New code → V2 (`/portfolio/events/orders/*`). Touching existing code → match what's there until you can migrate.
4. **Sync or async?** The official `kalshi_python_sync` / `kalshi_python_async` are separate packages; `kalshi-sdk` (community) ships both with one transport.
5. **Building a quoting/market-making system?** You'll need WebSocket `orderbook_delta` + snapshot reassembly and `fill` for own-order tracking. The REST polling pattern won't scale.
6. **Building a low-latency / co-located system?** Use FIX; REST is fine for low-frequency.

## How to find what you need

The curated references cover everything deeply. Read the one(s) that match the task before writing code.

| Task | Reference |
| --- | --- |
| Get started: keys, demo vs prod, first request | `references/getting-started.md` |
| RSA-PSS signature: the algorithm, headers, code for Node/Python/Go/curl | `references/authentication-rsa-pss.md` |
| REST API endpoint map: every resource family on `/trade-api/v2` | `references/rest-api-overview.md` |
| Series, events, markets — the catalog hierarchy and ticker formats | `references/markets-events-series.md` |
| Placing orders — legacy `/portfolio/orders` and V2 `/portfolio/events/orders` | `references/orders-and-trading.md` |
| Reading portfolio: balance, positions, fills, settlements, deposits, withdrawals | `references/portfolio-and-balance.md` |
| WebSocket: 12 channels, subscriptions, sequencing, reconnect | `references/websocket-api.md` |
| FIX: FIXT.1.1 / FIX50SP2 sessions, logon, sequence recovery | `references/fix-protocol.md` |
| Perpetual futures: separate host, separate keys, funding, mark price, margin | `references/perps-margin.md` |
| SDK comparison: official sync/async, kalshi-sdk, pykalshi, kalshi-client | `references/sdks-and-tools.md` |
| Errors, retry policy, rate limits, idempotency | `references/errors-and-rate-limits.md` |
| Common failure patterns: 401, signature drift, delta gaps, order rejects | `references/common-pitfalls.md` |
| How to refresh the gated `docs.kalshi.com` snapshot and YAML specs | `references/sources/openapi-specs/README.md` |

`references/sources/INDEX.md` is the topic-to-file map for the embedded source docs.

## Critical things to know up-front

These come up over and over.

### 1. The Kalshi API is split across two products with separate hosts AND separate keys

- **Event-contracts** (prediction markets) → `api.elections.kalshi.com` (prod) / `demo-api.kalshi.co` (demo).
- **Perpetual futures** (margin) → `external-api.kalshi.com` (prod) / `external-api.demo.kalshi.co` (demo).

API keys issued for one don't work on the other. You generate them in different sections of the Kalshi UI. The auth scheme (RSA-PSS) is the same; the keys are not.

### 2. All authenticated requests need three headers

```
KALSHI-ACCESS-KEY:       <your-api-key-id>
KALSHI-ACCESS-TIMESTAMP: <unix-epoch-milliseconds-as-string>
KALSHI-ACCESS-SIGNATURE: <base64(RSA-PSS(timestamp + method + path, private_key))>
```

The signed payload is the **concatenation** of timestamp, HTTP method, and path — no separator, no body, no query string. See `references/authentication-rsa-pss.md` for the exact algorithm and code recipes. Skew tolerance is small (~5 seconds) — keep clocks in sync.

### 3. Public endpoints don't need auth

Market data — `/exchange/status`, `/series`, `/events`, `/markets`, `/markets/trades` — work without any headers. You can build read-only dashboards with no key at all. The official SDKs handle this by leaving credentials optional and falling back to `AuthRequiredError` on private endpoints.

### 4. The order surface is in transition: V1 → V2

- **Legacy** `/portfolio/orders` family — single-market, `side: "yes"|"no"`, `action: "buy"|"sell"`, separate `yes_price` / `no_price` (cents in some SDKs, decimal dollars in others — check yours).
- **V2** `/portfolio/events/orders` family (spec v3.18.0+) — event-scoped, single book with `side: "bid"|"ask"`, `count` + `price` as `Decimal` (fixed-point dollars up to 4 decimals).

Legacy will be deprecated **no earlier than May 6, 2026**. New code → V2. Don't mix the two in the same path.

### 5. WebSocket deltas need snapshot bootstrapping

To maintain a local orderbook from `orderbook_delta`:

1. Open the WS connection and subscribe (capture the first `seq`).
2. While subscribed, fetch `GET /markets/{ticker}/orderbook` to get the snapshot.
3. Apply only deltas with `seq` > snapshot's seq, in order.
4. On any gap (`seq` jumps), discard and re-snapshot.

Skipping the gap-detection step is the #1 cause of "my book is off by a few cents" in production. The community SDKs (`pykalshi`, `kalshi-sdk`) handle this internally.

### 6. Prices in V2 are decimal dollars; in legacy they may be cents

Check the SDK or the spec — don't assume. V2 spec example: `price: "0.5000"` means 50 cents. Legacy SDK example: `yes_price: 50` means 50 cents. Conflating these by an order of magnitude is bad.

### 7. The official SDKs split sync vs async into separate packages

`kalshi_python_sync` and `kalshi_python_async` are two distinct PyPI packages, both auto-generated from `openapi.yaml`. The old combined `kalshi-python` is deprecated. The community `kalshi-sdk` (TexasCoding) gives you both with one transport.

### 8. FIX uses the same RSA-PSS key

The FIX engine's logon uses the same RSA-PSS private key — concatenate the FIX timestamp + a fixed string + sender comp ID, sign, and embed in `RawData(95)` / `RawDataLength(96)`. Details in `references/fix-protocol.md`.

### 9. Perps WS timestamps are milliseconds; REST timestamps are RFC3339

Mixing them is a common bug. Perps WebSocket fields ending in `_ms` are Unix epoch milliseconds. REST responses use RFC3339 strings.

### 10. Treat the OpenAPI / AsyncAPI / Perps OpenAPI specs as ground truth

Kalshi publishes:

- `https://docs.kalshi.com/openapi.yaml` — REST event-contracts.
- `https://docs.kalshi.com/asyncapi.yaml` — WebSocket event-contracts.
- `https://docs.kalshi.com/perps_openapi.yaml` — REST perps.

SDKs lag the spec by days. When SDK and spec disagree, the spec wins (or the live API does). Active traders should regenerate clients from the live specs weekly.

## Workflow for "build a new Kalshi integration"

1. **Generate keys.** Sign up, complete KYC, go to Account Settings → API Keys → generate. Download the private key PEM. Save `key_id`. Repeat for perps if needed.
2. **Pick demo or prod.** Always start with demo. Demo: `demo-api.kalshi.co`; prod: `api.elections.kalshi.com`.
3. **Hit a public endpoint** with no auth to confirm DNS/TLS:
   ```bash
   curl https://demo-api.kalshi.co/trade-api/v2/exchange/status
   ```
4. **Generate the auth signature.** See `references/authentication-rsa-pss.md`.
5. **Hit a private endpoint** (balance) to confirm auth:
   ```bash
   curl -H "KALSHI-ACCESS-KEY: $K" \
        -H "KALSHI-ACCESS-TIMESTAMP: $TS" \
        -H "KALSHI-ACCESS-SIGNATURE: $SIG" \
        https://demo-api.kalshi.co/trade-api/v2/portfolio/balance
   ```
6. **Browse the catalog** — list series, list events, list markets to find what to trade. See `references/markets-events-series.md`.
7. **Subscribe via WebSocket** to `ticker` or `orderbook_delta` for live data. See `references/websocket-api.md`.
8. **Place a small test order** with a unique `client_order_id` and `time_in_force: "good_till_canceled"`. Use V2 endpoint. See `references/orders-and-trading.md`.
9. **Monitor fills** via the WS `fill` channel and `GET /portfolio/fills`.
10. **Implement the unhappy paths**: 401 (signature drift), 429 (rate limit), book gaps (re-snapshot), connection drops (re-auth + resubscribe).

## Workflow for "debug a failing Kalshi request"

1. **401 / 403?** → `references/authentication-rsa-pss.md`. Almost always one of: wrong host (event-contracts key on perps), clock skew, signing the wrong payload (don't include query string or body), wrong algorithm (`RSA-PSS` not `RSA-PKCS1-v1_5`).
2. **400 / 422?** Check the spec for the exact request shape. Common: wrong price format (cents vs decimal dollars), missing `client_order_id`, invalid `time_in_force`.
3. **404?** Wrong base URL, wrong product host, or wrong endpoint version (`v1` vs `v2`).
4. **429?** Rate limit. Back off; respect `Retry-After`. Cache catalog data.
5. **WebSocket disconnects?** Re-auth (the signed upgrade request expires); re-subscribe; re-snapshot books.
6. **Order rejected** with `insufficient_funds` / `market_closed` / `position_limit`? → `references/common-pitfalls.md`.

## Source-of-truth hierarchy

When in doubt about an API contract:

1. The live API itself (run the actual request).
2. The OpenAPI / AsyncAPI YAML specs at `docs.kalshi.com/{openapi,asyncapi,perps_openapi}.yaml` — bundled in `references/sources/openapi-specs/` after running the fetch script.
3. The auto-generated official SDKs (`kalshi_python_sync` / `kalshi_python_async`) regenerated this week.
4. The community SDKs (`kalshi-sdk` by TexasCoding, `pykalshi` by arshka, `kalshi-client` by vaguenebula) — bundled READMEs in `references/sources/sdk-snippets/`.
5. The curated references in this skill.
6. Past blog posts / tutorials.

## Source refresh

`scripts/kalshi/fetch_docs.sh` re-fetches the OpenAPI specs and clones the community SDKs. Run it from a normal developer environment (not a restricted CI sandbox). If Cloudflare blocks plain `curl`, the script's README points at a headless-browser recipe.
