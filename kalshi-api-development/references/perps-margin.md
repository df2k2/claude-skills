# Perpetual Futures (Perps / Margin)

Kalshi runs a **second** exchange separate from the event-contracts (prediction) markets: perpetual futures with margin. This is a distinct product with its own hosts, its own API keys, its own OpenAPI spec, and its own WebSocket / FIX surfaces.

If you have not opted into perps trading on your Kalshi account, this reference doesn't apply.

## Hosts

| Env | REST | WebSocket |
| --- | --- | --- |
| Production | `https://external-api.kalshi.com/trade-api/v2` | `wss://external-api.kalshi.com/trade-api/ws/v2` |
| Demo | `https://external-api.demo.kalshi.co/trade-api/v2` | `wss://external-api.demo.kalshi.co/trade-api/ws/v2` |

Note: Different from event-contracts hosts (`api.elections.kalshi.com` and `demo-api.kalshi.co`). The `/trade-api/v2` path is shared but the subdomain differs.

## Keys

Perps requires **separate API keys** from event-contracts. Generate them in the perps section of the Kalshi UI. Auth scheme is the same RSA-PSS, but the keys themselves are different.

Environment variable convention:

```bash
# Event-contracts keys
export KALSHI_KEY_ID=...
export KALSHI_PRIVATE_KEY_PATH=~/.kalshi/event-contracts-private.pem

# Perps keys
export KALSHI_PERPS_KEY_ID=...
export KALSHI_PERPS_PRIVATE_KEY_PATH=~/.kalshi/perps-private.pem
```

The community `kalshi-sdk` reads these separately:

```python
from kalshi import PerpsClient
with PerpsClient.from_env(demo=True) as perps:
    print(perps.exchange.status())
```

## Resource model

The perps OpenAPI spec declares ~34 operations across 8 resource groups:

| Group | Purpose |
| --- | --- |
| `/exchange` | Exchange status, schedule, announcements |
| `/markets` | Perps market catalog + market data |
| `/orders` | Order entry / lifecycle (similar to event-contracts) |
| `/order_groups` | Order-group lifecycle |
| `/portfolio` | Balance + positions |
| `/margin` | Margin / risk / fees endpoints |
| `/funding` | Funding-rate history, current rate |
| `/transfers` | Move funds between margin sub-accounts |

## Key perps concepts

### Perpetual contracts

A perp is a futures contract with **no expiration**. Instead of converging to spot at a settlement date, the contract's price tracks the underlying via a periodic **funding** mechanism:

- If the perp trades **above** the underlying index, longs pay shorts.
- If it trades **below**, shorts pay longs.
- The size of the payment is the **funding rate** × notional.
- Funding settles at fixed intervals (e.g., hourly).

### Funding rate

The funding rate is published per market, expressed as a percentage of notional, applied at the next funding time.

WebSocket `ticker` channel for perps carries:

```json
{
  "ticker": "PERP-...",
  "bid": "...",
  "ask": "...",
  "mark_price": "...",
  "index_price": "...",
  "funding_rate": "0.0001",        // 0.01% per funding period
  "next_funding_time_ms": 1717459200000
}
```

REST equivalent: `GET /funding/...` returns history + next.

### Mark price

The price used for:

- Funding calculations.
- Margin / liquidation triggers.
- Unrealized P&L.

Computed by Kalshi from index + premium components — not the last trade. Don't conflate `mark_price` with `last_price`.

### Margin

Each position has:

- **Initial margin** — required to open.
- **Maintenance margin** — required to keep open. If equity drops below, liquidation begins.

Get current values:

```http
GET /trade-api/v2/margin/balance
GET /trade-api/v2/margin/risk
GET /trade-api/v2/margin/fees
```

Balance breaks down available / locked / unrealized P&L per sub-account.

### Sub-accounts

Perps supports multiple sub-accounts per Kalshi account for isolating risk. Transfers between them:

```http
POST /trade-api/v2/transfers
{
  "from_subaccount_id": "...",
  "to_subaccount_id": "...",
  "amount": "100.00"
}
```

## Orders

Same general shape as event-contracts V2 orders but with perps-specific fields:

```json
{
  "ticker": "PERP-...",
  "client_order_id": "uuid",
  "side": "buy",                    // or "sell"
  "type": "limit",                  // or "market"
  "count": "1.50",                  // perps may support fractional
  "price": "65000.5000",            // fixed-point dollars (up to 6 decimals for some markets)
  "time_in_force": "good_till_canceled",
  "reduce_only": false,
  "post_only": false
}
```

| Field | Notes |
| --- | --- |
| `reduce_only` | Order can only reduce position, not flip it. Useful for take-profit / stop-loss. |
| `post_only` | Order is canceled if it would cross immediately (only place as maker). |
| `count` | `FixedPointCount` — 2-decimal precision in some markets (wire suffix `_fp`). |
| `price` | `DollarDecimal` — up to 6 decimals depending on market. |

## WebSocket channels (perps)

6 channels:

| Channel | Streams |
| --- | --- |
| `ticker` | Top-of-book + `funding_rate` + `next_funding_time_ms` |
| `orderbook_delta` | Deltas + snapshots |
| `trade` | Public trades |
| `fill` | Your fills |
| `user_orders` | Your order lifecycle |
| `order_group` | Order-group events |

Same connection semantics as event-contracts WebSocket — same RSA-PSS upgrade (but with perps keys), same sequence numbering, same reconnect / resnapshot pattern.

**Timestamp gotcha**: perps WebSocket fields with `_ms` suffix are Unix epoch milliseconds. REST responses use RFC3339 strings. Mixing them is a common bug.

## Klear settlement API

A **third surface**, separate from both event-contracts and perps direct trading: **Klear** is the Self-Clearing-Member (SCM) settlement API.

| Capability | Endpoints |
| --- | --- |
| Margin reports | `GET /klear/margin/reports/...` |
| Settlement balances | `GET /klear/settlements/balances` |
| Obligations | `GET /klear/obligations` |
| Withdrawals | `GET/POST /klear/withdrawals` |

**Auth for Klear is HTTP Bearer token**, not RSA-PSS:

```
Authorization: Bearer <klear_access_token>
```

Klear access tokens are issued to SCMs by Kalshi out-of-band. Only relevant if your firm is a Self-Clearing Member; retail accounts have no Klear access.

In the community SDK:

```python
from kalshi import KlearClient
with KlearClient(admin_user_id="...", access_token="...") as klear:
    reports = klear.margin_reports.list()
```

## FIX for perps

Perps has its own FIX endpoint (`MarginFixClient` in the community SDK). Same RSA-PSS auth scheme as event-contracts FIX, but with perps keys and different host:port.

```python
from kalshi import MarginFixClient, FixEnvironment

client = MarginFixClient.from_env(environment=FixEnvironment.PRODUCTION)
async with client.order_entry(on_message=on_message) as session:
    ...
```

## When to use perps vs. event-contracts

| Use case | Product |
| --- | --- |
| Yes/no contracts on discrete events (sports, elections, FOMC) | Event-contracts |
| Continuous price exposure to crypto / FX / commodities | Perps |
| Settled contracts that expire | Event-contracts |
| Funding-rate-paid perpetual exposure | Perps |
| Margin trading with leverage | Perps |
| Cash account (no leverage) | Event-contracts |

The two are economically very different products — event-contracts pay out at settlement, perps pay funding continuously.

## Common perps failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| `401` on perps host | Used event-contracts key | Use the perps-specific key. |
| `403` on `external-api.kalshi.com` | Account not enrolled for perps | Sign up for perps in the UI. |
| Position larger than expected | Forgot `reduce_only` on a closing order | Set `reduce_only: true`. |
| Order liquidates immediately | Below maintenance margin | Top up; or reduce position. |
| Funding payment surprise | Held position across funding boundary | Track `next_funding_time_ms`. |
| WebSocket timestamp parse error | Mixed `_ms` with RFC3339 | Use the right format per source. |
| Klear endpoint 401 | RSA-PSS used instead of Bearer | Switch auth scheme. |

## Original sources

- `references/sources/openapi-specs/perps_openapi.yaml` — canonical perps API contract.
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — `PerpsClient`, `PerpsWebSocket`, `MarginFixClient`, `KlearClient` examples.
- Official (gated): https://docs.kalshi.com/api-reference/perps/ (when present).
