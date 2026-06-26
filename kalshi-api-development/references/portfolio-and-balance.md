# Portfolio: Balance, Positions, Fills, Settlements, Funding

The portfolio surface is all the authenticated read endpoints for "what's in my account right now / what happened to it". This reference covers every endpoint under `/portfolio/*` (except orders, which has its own reference).

## /portfolio/balance

```http
GET /trade-api/v2/portfolio/balance
```

Response:

```json
{
  "balance": 100000,   // in cents (verify against current spec)
  "payout": 50000      // total payable from settled positions awaiting payout
}
```

This is the **available wallet balance** — what you can place orders against. It's reduced by:

- Pending order reservations (the worst-case cost of resting orders).
- Pending withdrawals.

Increased by:

- Deposits.
- Settled positions (the `payout` field) once they roll over.

Field semantics can evolve — always check the OpenAPI spec for current shape.

## /portfolio/positions

```http
GET /trade-api/v2/portfolio/positions?event_ticker=KXNBAGAME-26MAY25NYKCLE
```

Common filters:

| Param | Notes |
| --- | --- |
| `event_ticker` | Filter to one event |
| `ticker` | Filter to one market |
| `settlement_status` | `all`, `unsettled`, `settled` |
| `count_filter` | E.g., only positions where you hold > 0 |
| `cursor`, `limit` | Pagination |

Response:

```json
{
  "event_positions": [
    {
      "event_ticker": "KXNBAGAME-26MAY25NYKCLE",
      "event_exposure": 1000,         // cents at risk on the event
      "fees_paid": 50,
      "realized_pnl": 0,
      "resting_order_count": 1,
      "total_traded": 2,
      "user_id": "..."
    }
  ],
  "market_positions": [
    {
      "ticker": "KXNBAGAME-26MAY25NYKCLE-NYK",
      "position": 10,                 // # contracts held; signed (positive = yes, negative = no)
      "market_exposure": 650,         // cents at risk
      "realized_pnl": 0,
      "total_traded": 1,
      "fees_paid": 25,
      "resting_orders_count": 1,
      "last_updated_ts": "..."
    }
  ],
  "cursor": "..."
}
```

The position sign convention: positive count = net YES holding; negative = net NO holding. (Some APIs split into separate yes/no — verify against the spec.)

### What "settled" means here

A market position is **settled** when the underlying market has resolved (`status: settled`) and the cash has flowed:

- If you held YES and YES won → you receive $1.00 per contract minus fees.
- If you held NO and NO won → same on the NO side.
- If you held the losing side → contracts worth $0.

The `payout` on `/portfolio/balance` tracks the total cash awaiting credit from settled positions.

## /portfolio/fills

A **fill** is a single execution of an order — could be the entire order at once, or a partial fill where only some contracts execute against the resting book.

```http
GET /trade-api/v2/portfolio/fills?
  ticker=KXNBAGAME-26MAY25NYKCLE-NYK&
  order_id=...&
  min_ts=...&
  max_ts=...&
  cursor=...&
  limit=200
```

Response:

```json
{
  "fills": [
    {
      "trade_id": "...",
      "order_id": "...",
      "ticker": "...",
      "side": "yes",
      "action": "buy",
      "count": 10,
      "yes_price": 65,
      "no_price": 35,
      "is_taker": true,             // were you the aggressor?
      "created_time": "..."
    }
  ],
  "cursor": "..."
}
```

Use this for:

- Reconciling your orders' execution history.
- Computing per-trade P&L (fill price minus current mark).
- Detecting partial fills you may have missed via WebSocket.

For real-time fill notifications, subscribe to the WebSocket `fill` channel.

## /portfolio/settlements

```http
GET /trade-api/v2/portfolio/settlements?cursor=...&limit=200
```

Returns settled positions — one entry per market that has resolved:

```json
{
  "settlements": [
    {
      "ticker": "...",
      "yes_count": 10,
      "no_count": 0,
      "yes_total_cost": 650,
      "no_total_cost": 0,
      "revenue": 1000,             // cash received from settlement
      "settled_time": "..."
    }
  ],
  "cursor": "..."
}
```

Useful for P&L reporting — sum `revenue - (yes_total_cost + no_total_cost)` for net P&L.

## /portfolio/deposits

```http
GET /trade-api/v2/portfolio/deposits
```

Funding deposits into your wallet:

```json
{
  "deposits": [
    {
      "deposit_id": "...",
      "amount": 50000,           // cents
      "currency": "USD",
      "type": "ach_pull",        // ach_pull / debit_card / wire / bonus
      "status": "completed",     // pending / completed / failed
      "created_time": "..."
    }
  ],
  "cursor": "..."
}
```

## /portfolio/withdrawals

```http
GET  /trade-api/v2/portfolio/withdrawals    # list
POST /trade-api/v2/portfolio/withdrawals    # initiate (if your account is enabled)
```

POST body:

```json
{
  "amount": 50000,
  "destination_account_id": "..."
}
```

Withdrawals to bank accounts. Subject to:

- Bank account verification (in the UI, not API).
- Daily / monthly limits.
- A clearing period (typically 1–3 business days for ACH).

Status values: `pending`, `processing`, `completed`, `failed`, `canceled`.

## Reconciliation pattern (recommended)

A production system should periodically reconcile its local state against Kalshi's:

```python
def reconcile():
    # 1. Open positions
    expected_positions = my_db.open_positions()
    actual_positions   = client.portfolio.positions(settlement_status="unsettled")
    diff = compare(expected_positions, actual_positions)
    if diff:
        alert("position drift", diff)

    # 2. Recent fills
    last_ts = my_db.last_fill_ts()
    new_fills = client.portfolio.fills(min_ts=last_ts)
    for fill in new_fills:
        if not my_db.has_fill(fill.trade_id):
            my_db.insert_fill(fill)

    # 3. Balance
    balance = client.portfolio.balance()
    if balance.balance != my_db.expected_balance():
        alert("balance drift")
```

Run on a cadence appropriate to your strategy (every minute for active trading, every hour for slow systems).

## Pagination across portfolio endpoints

All list endpoints use cursor pagination:

```python
cursor = None
all_fills = []
while True:
    page = client.portfolio.fills(cursor=cursor, limit=200)
    all_fills.extend(page.fills)
    if not page.cursor:
        break
    cursor = page.cursor
```

Most SDKs expose a `list_all()` helper that does this for you.

## Important caveats

### Position direction encoding

The `position` integer on a market position is signed. Sign convention varies by SDK and version:

- Some SDKs report `position > 0` for net YES, `position < 0` for net NO.
- Others split into `yes_position` and `no_position` (always non-negative).

Read the spec for your version. **Don't assume.**

### Fees

Per-trade fees are reflected in `fees_paid` on positions. Kalshi has fee schedules that vary by:

- Market category (sports / political / financial).
- Volume tier.
- Maker vs. taker (some markets give maker rebates).

See `/account` for your current schedule and tier.

### Pending order cost

`/portfolio/balance` deducts the **worst-case cost** of resting orders from available balance — so if you have a $0.50 × 10-contract bid resting, your balance is reduced by $5 until the order fills or cancels. This prevents over-leveraging via stacked orders.

### Settlement timing

Markets settle when the underlying resolves. For most categories this is automatic (e.g., game result confirmed by data feed). Some markets have a manual resolution lag (judicial reviews, political markets). The `result` field on the market is set when settlement completes.

## Common portfolio failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| `balance` lower than expected | Resting orders reserved | `GET /portfolio/orders?status=resting` to confirm. |
| Positions don't match own DB | Out-of-band cancel/fill | Subscribe to `user_orders` + `fill` WS channels. |
| Fills missing for a known order | Filtered out by cursor pagination edge case | Iterate fully; don't trust a single page. |
| Withdrawal stuck `pending` | Bank account not verified | Verify in Kalshi UI. |
| `position_limit_exceeded` on order create | Per-market cap reached | Check current position; reduce. |

## Original sources

- `references/sources/openapi-specs/openapi.yaml` — authoritative for fields.
- Official (gated): https://docs.kalshi.com/api-reference/portfolio/get-balance, /positions, /fills, /settlements.
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — `portfolio.*` resource group examples.
