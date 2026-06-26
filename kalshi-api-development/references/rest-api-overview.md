# REST API Overview

A map of the entire Kalshi event-contracts REST surface at `https://api.elections.kalshi.com/trade-api/v2` (production) / `https://demo-api.kalshi.co/trade-api/v2` (demo). The current `openapi.yaml` declares 104 operations across 19 resources. This reference is the topical map; for exact request/response shapes, consult the OpenAPI spec at `references/sources/openapi-specs/openapi.yaml`.

The **perpetual-futures** product has its own host (`external-api.kalshi.com`) and its own spec (`perps_openapi.yaml`, 34 operations) — see `references/perps-margin.md`.

## Top-level resource groups

| Group | Purpose | Auth required |
| --- | --- | --- |
| `/exchange/*` | Exchange-level state | mostly public |
| `/series/*` | Series catalog | public |
| `/events/*` | Event catalog | public |
| `/markets/*` | Market catalog + market data | public |
| `/markets/trades` | Public trades feed | public |
| `/communications/*` | Exchange announcements | mixed |
| `/multivariate/*` | Multivariate (parlay-style) markets | mixed |
| `/live-data/*` | Real-time live-data convenience endpoint | mixed |
| `/portfolio/balance` | Wallet balance | YES |
| `/portfolio/positions` | Open + settled positions | YES |
| `/portfolio/orders` | **Legacy** single-market orders | YES |
| `/portfolio/events/orders` | **V2** event-scoped orders (current) | YES |
| `/portfolio/fills` | Fills history | YES |
| `/portfolio/settlements` | Settlement history | YES |
| `/portfolio/deposits` | Funding deposits | YES |
| `/portfolio/withdrawals` | Funding withdrawals | YES |
| `/portfolio/order_groups` | Order-group lifecycle | YES |
| `/account/*` | Account info, endpoint costs | YES |
| `/auth/login`, `/auth/logout` | Legacy session auth | (deprecated — use RSA-PSS) |

## /exchange

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/exchange/status` | Is the exchange online and trading? |
| GET | `/exchange/schedule` | Trading hours, holiday calendar |
| GET | `/exchange/announcements` | Exchange announcements |

`status` is the lightest possible health check; safe to call without auth as a network reachability test.

## /series

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/series` | List all series, paginated |
| GET | `/series/{series_ticker}` | Get one series by ticker |

Common filters: category, tags, status.

## /events

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/events` | List events; filter by `series_ticker`, `status`, `with_nested_markets` |
| GET | `/events/{event_ticker}` | Get one event |

The `with_nested_markets=true` query parameter inlines each event's markets into the response — saves a separate `/markets` round-trip.

## /markets

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/markets` | List markets; filter by `tickers`, `event_ticker`, `series_ticker`, `status`, `min_close_ts`, `max_close_ts` |
| GET | `/markets/{ticker}` | Get one market by ticker |
| GET | `/markets/{ticker}/orderbook` | Current orderbook snapshot |
| GET | `/markets/{ticker}/candlesticks` | OHLC candlesticks (historical) |
| GET | `/markets/{ticker}/history` | Tick-level history |
| GET | `/markets/trades` | Public trades feed (filter by ticker + time) |

`/markets/{ticker}/orderbook` is the snapshot you bootstrap a WebSocket `orderbook_delta` stream with — see `references/websocket-api.md`.

`/markets/trades` (note: at `/markets/trades` not `/markets/{ticker}/trades`) is filterable by `ticker`, `min_ts`, `max_ts`, `cursor`, `limit`. Use it for historical trade replay.

## /portfolio

### Balance

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/portfolio/balance` | Wallet balance |

Returns:

```json
{
  "balance": 100000,      // in cents (check current spec — fields evolve)
  "payout": 50000
}
```

### Positions

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/portfolio/positions` | List positions; filter by `event_ticker`, `ticker`, settlement status |

### Orders (legacy, single-market)

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/portfolio/orders` | List orders; filter by ticker, status, time |
| POST | `/portfolio/orders` | Create order |
| GET | `/portfolio/orders/{order_id}` | Get one order |
| DELETE | `/portfolio/orders/{order_id}` | Cancel order |
| PUT | `/portfolio/orders/{order_id}/amend` | Amend order (price/count) |
| POST | `/portfolio/orders/{order_id}/decrease` | Decrease order count |

**To be deprecated no earlier than May 6, 2026**. See V2 below.

### Orders V2 (event-scoped, current)

| Verb | Path | Purpose |
| --- | --- | --- |
| POST | `/portfolio/events/orders` | Create order V2 |
| GET | `/portfolio/events/orders/{order_id}` | Get one V2 order |
| PUT | `/portfolio/events/orders/{order_id}/amend` | Amend V2 order |
| POST | `/portfolio/events/orders/{order_id}/decrease` | Decrease V2 order |
| DELETE | `/portfolio/events/orders/{order_id}` | Cancel V2 order |
| POST | `/portfolio/events/orders/batch_create` | Batch create |
| POST | `/portfolio/events/orders/batch_cancel` | Batch cancel |

V2 uses `side: "bid" | "ask"` (single book per market) and `price` as decimal-dollar `Decimal`.

### Fills

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/portfolio/fills` | Your fills (executions). Filter by `ticker`, `order_id`, `min_ts`, `max_ts` |

### Settlements

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/portfolio/settlements` | Settled positions |

### Funding

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/portfolio/deposits` | Deposit history |
| GET | `/portfolio/withdrawals` | Withdrawal history |
| POST | `/portfolio/withdrawals` | Initiate withdrawal (if your account is enabled) |

### Order groups

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/portfolio/order_groups` | List your groups |
| POST | `/portfolio/order_groups` | Create a group |
| GET | `/portfolio/order_groups/{id}` | Get one group |
| DELETE | `/portfolio/order_groups/{id}` | Cancel all orders in the group |

Order groups let you bundle related orders so a cancel of the group cancels all members atomically. Useful for basket trades and conditional strategies.

## /account

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/account` | Account profile |
| GET | `/account/endpoint_costs` | Cost / weight assigned to each endpoint for rate-limit accounting |

`/account/endpoint_costs` is the introspection endpoint for Kalshi's weighted rate limiter — see `references/errors-and-rate-limits.md`.

## /multivariate

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/multivariate/markets` | List multivariate (parlay-style) markets |
| GET | `/multivariate/markets/{ticker}` | Get one |
| GET | `/multivariate/markets/{ticker}/orderbook` | Multivariate orderbook |

Multivariate markets resolve based on the combined outcome of multiple underlying events. E.g., "both team A wins AND team B wins" → a single contract.

## /live-data

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/live-data` | Aggregated real-time data — convenience endpoint |

Often used by dashboards.

## /communications

| Verb | Path | Purpose |
| --- | --- | --- |
| GET | `/communications` | Exchange-level announcements |

## /auth (legacy)

| Verb | Path | Purpose |
| --- | --- | --- |
| POST | `/auth/login` | Email/password login (LEGACY — deprecated) |
| POST | `/auth/logout` | Logout |

Modern code uses RSA-PSS — these endpoints are kept for backward compat with very old SDKs and shouldn't be used by new integrations.

## Pagination

List endpoints support cursor-based pagination:

```
GET /markets?status=open&limit=200
→ { "markets": [...], "cursor": "abc123" }

GET /markets?status=open&limit=200&cursor=abc123
→ { "markets": [...], "cursor": "def456" }

...until "cursor" is empty or absent.
```

Typical `limit` ranges: 1 — 1000 depending on endpoint; default ~100.

## Filtering conventions

- **List endpoints** accept multiple filters as query params, typically ANDed together.
- Common filter parameters:
  - `status` (e.g., `open`, `closed`, `settled`).
  - `series_ticker` / `event_ticker` / `tickers` (comma-separated tickers).
  - `min_ts` / `max_ts` (Unix epoch seconds).
  - `cursor` / `limit` for pagination.
- **Tickers in path** are URL-encoded (rare for Kalshi tickers since they're ASCII).

## Response envelope conventions

Most responses are flat top-level JSON objects with the resource name pluralized:

```json
GET /markets
{ "markets": [...], "cursor": "..." }

GET /markets/KXNBAGAME-26MAY25NYKCLE-NYK
{ "market": {...} }

GET /portfolio/positions
{ "event_positions": [...], "market_positions": [...] }
```

Errors return a 4xx/5xx HTTP status and a JSON body — see `references/errors-and-rate-limits.md`.

## Idempotency

- `POST /portfolio/orders` and `POST /portfolio/events/orders` both accept `client_order_id` — provide a UUID per order. Re-sending the same `client_order_id` returns the existing order rather than creating a duplicate.
- `DELETE` operations are idempotent by HTTP semantics.
- `PUT` (amend) is idempotent.

The official SDKs auto-fill `client_order_id` if you omit it. For batch creates, every order in the batch needs a unique `client_order_id`.

## Endpoint costs

Each endpoint has a weight assigned to it for the weighted rate limiter. Get the live map:

```bash
curl -H "KALSHI-ACCESS-KEY: ..." \
     -H "KALSHI-ACCESS-TIMESTAMP: ..." \
     -H "KALSHI-ACCESS-SIGNATURE: ..." \
     https://api.elections.kalshi.com/trade-api/v2/account/endpoint_costs
```

A read endpoint like `GET /markets` might cost 1; `POST /portfolio/orders` might cost 10. Plan throughput accordingly. See `references/errors-and-rate-limits.md`.

## Generating a client from the spec

The OpenAPI spec at `references/sources/openapi-specs/openapi.yaml` is consumable by any generator:

```bash
# Python (officially used by Kalshi for their auto-generated SDK)
openapi-python-client generate --path openapi.yaml --meta poetry

# TypeScript types
openapi-typescript openapi.yaml -o kalshi-api.ts

# Go
oapi-codegen -package kalshi openapi.yaml > kalshi.gen.go

# Rust
openapi-generator generate -i openapi.yaml -g rust -o kalshi-rs
```

The official `kalshi_python_sync` / `kalshi_python_async` packages are exactly this — auto-generated, republished weekly.

## Quick reference table — most common endpoints

| Use case | Endpoint |
| --- | --- |
| Health check | `GET /exchange/status` |
| Get balance | `GET /portfolio/balance` |
| Browse open markets | `GET /markets?status=open&limit=200` |
| Detail of one market | `GET /markets/{ticker}` |
| Current orderbook | `GET /markets/{ticker}/orderbook` |
| Place an order (V2) | `POST /portfolio/events/orders` |
| Cancel an order | `DELETE /portfolio/events/orders/{order_id}` |
| List my open orders | `GET /portfolio/orders?status=resting` (or V2 equivalent) |
| List my fills | `GET /portfolio/fills` |
| List my positions | `GET /portfolio/positions` |
| Settlement history | `GET /portfolio/settlements` |

## Original sources

- `references/sources/openapi-specs/openapi.yaml` — the canonical spec (when present).
- Official site (gated): https://docs.kalshi.com/api-reference/
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — comprehensive surface coverage.
