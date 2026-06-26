# Orders and Trading

The order surface is in transition. Legacy `/portfolio/orders` (single-market, YES/NO sides, cents-or-decimal pricing depending on SDK) still works. **V2 event-scoped orders** at `/portfolio/events/orders/*` (spec v3.18.0+) are the modern path — single book per market with `bid`/`ask` sides, `Decimal` dollar prices, batched variants. Legacy will be deprecated **no earlier than May 6, 2026**.

This reference covers both, when to use which, the full request/response shape, the order lifecycle, and common rejection causes.

## Legacy: `/portfolio/orders`

### Endpoints

| Verb | Path | Purpose |
| --- | --- | --- |
| POST | `/portfolio/orders` | Create order |
| GET | `/portfolio/orders` | List orders |
| GET | `/portfolio/orders/{order_id}` | Get one |
| DELETE | `/portfolio/orders/{order_id}` | Cancel |
| PUT | `/portfolio/orders/{order_id}/amend` | Amend |
| POST | `/portfolio/orders/{order_id}/decrease` | Decrease count |

### Create order request (legacy)

```json
{
  "ticker": "KXNBAGAME-26MAY25NYKCLE-NYK",
  "client_order_id": "your-uuid-here",
  "side": "yes",                          // or "no"
  "action": "buy",                        // or "sell"
  "type": "limit",                        // or "market"
  "count": 10,                            // contracts
  "yes_price": 65,                        // cents [legacy] — or "0.65" [some SDKs]
  "time_in_force": "good_till_canceled",
  "expiration_ts": null,
  "sell_position_floor": null,
  "buy_max_cost": null
}
```

### Key fields (legacy)

| Field | Type | Notes |
| --- | --- | --- |
| `ticker` | string | Market ticker, e.g., `KXNBAGAME-26MAY25NYKCLE-NYK`. |
| `client_order_id` | string | Your idempotency key. UUID convention. **Mandatory** for safe retries. |
| `side` | `"yes"` \| `"no"` | Which side of the binary contract. |
| `action` | `"buy"` \| `"sell"` | Buy = open / increase; sell = close / decrease. |
| `type` | `"limit"` \| `"market"` | Limit needs a price; market doesn't. |
| `count` | int | Number of contracts. |
| `yes_price` or `no_price` | int (cents) or string (dollars) | Limit price. Provide one of `yes_price` or `no_price`. **Watch the unit** — some SDKs use cents, some use decimal-dollar strings. |
| `time_in_force` | enum | `good_till_canceled`, `immediate_or_cancel`, `fill_or_kill`, `good_till_date`. |
| `expiration_ts` | int (Unix s) | Required when `time_in_force=good_till_date`. |
| `sell_position_floor` | int | Don't sell below this position count. |
| `buy_max_cost` | int (cents) | Cap total cost on a buy. |

### Response

```json
{
  "order": {
    "order_id": "abc123",
    "user_id": "user-uuid",
    "ticker": "...",
    "client_order_id": "...",
    "type": "limit",
    "side": "yes",
    "action": "buy",
    "status": "resting",                  // resting / executed / canceled
    "yes_price": 65,
    "no_price": 35,
    "count": 10,
    "remaining_count": 7,
    "queue_position": 4,
    "created_time": "...",
    "expiration_time": null,
    "last_update_time": "..."
  }
}
```

## V2: `/portfolio/events/orders` (current)

The V2 family was introduced in spec v3.18.0. Differences from legacy:

- **Single book per market** with `side: "bid" | "ask"` instead of `yes`/`no`.
- **Prices as decimal-dollar strings** (`"0.6500"`) using fixed-point dollars up to 4 decimal places.
- **Counts as `Decimal`** (not int) — fixed-point counts for fractional support.
- **Batch variants** for create and cancel.
- **Self-trade prevention** policy explicit in the request.

### Endpoints

| Verb | Path | Purpose |
| --- | --- | --- |
| POST | `/portfolio/events/orders` | Create V2 |
| GET | `/portfolio/events/orders/{order_id}` | Get V2 |
| PUT | `/portfolio/events/orders/{order_id}/amend` | Amend V2 |
| POST | `/portfolio/events/orders/{order_id}/decrease` | Decrease V2 |
| DELETE | `/portfolio/events/orders/{order_id}` | Cancel V2 |
| POST | `/portfolio/events/orders/batch_create` | Batch create |
| POST | `/portfolio/events/orders/batch_cancel` | Batch cancel |

### Create order V2 request

```json
{
  "ticker": "KXNBAGAME-26MAY25NYKCLE-NYK",
  "client_order_id": "your-uuid-here",
  "side": "bid",                          // or "ask"
  "count": "10",                          // decimal string
  "price": "0.6500",                      // decimal dollars
  "time_in_force": "good_till_canceled",
  "self_trade_prevention_type": "taker_at_cross",
  "order_group_id": null
}
```

### Key fields (V2)

| Field | Type | Notes |
| --- | --- | --- |
| `ticker` | string | Market ticker. |
| `client_order_id` | string (UUID) | Idempotency key. **Required.** |
| `side` | `"bid"` \| `"ask"` | Bid = buy; ask = sell. Single book per market. |
| `count` | Decimal string | Number of contracts. |
| `price` | Decimal string | Limit price in dollars (0.0000 — 1.0000). |
| `time_in_force` | enum | Same as legacy. |
| `self_trade_prevention_type` | enum | E.g., `"taker_at_cross"`, `"cancel_oldest"`. |
| `order_group_id` | string \| null | Optional group membership. |

### V2 response

```json
{
  "order": {
    "order_id": "abc123",
    "client_order_id": "your-uuid-here",
    "ticker": "...",
    "side": "bid",
    "status": "resting",
    "count": "10",
    "remaining_count": "10",
    "fill_count": "0",
    "price": "0.6500",
    "time_in_force": "good_till_canceled",
    "created_time": "...",
    "last_update_time": "..."
  }
}
```

## Order lifecycle (status values)

```
created  ─┐
          ├─► resting ─┬─► executed   (fully filled)
          │            ├─► canceled
          │            └─► expired
          │
          └─► rejected  (validation failed; never entered the book)
```

| Status | Meaning |
| --- | --- |
| `created` | Acknowledged, awaiting book placement. |
| `resting` | On the book, awaiting fills. `remaining_count` > 0. |
| `executed` | Fully filled. `remaining_count` = 0. |
| `canceled` | You (or a group cancel) canceled. |
| `expired` | `good_till_date` reached. |
| `rejected` | Validation rejected (e.g., insufficient funds, market closed). |

## time_in_force values

| Value | Behavior |
| --- | --- |
| `good_till_canceled` | Rests on book until explicitly canceled. |
| `immediate_or_cancel` (IOC) | Fill what you can immediately; cancel the rest. |
| `fill_or_kill` (FOK) | Fill the entire order immediately, or cancel completely. |
| `good_till_date` | Rests on book until `expiration_ts`, then auto-cancel. Set `expiration_ts` as Unix epoch seconds. |

## Idempotency with `client_order_id`

Always pass a UUID. Retry behavior:

- Resending the same `client_order_id` returns the existing order (200) rather than creating a duplicate.
- This applies on Kalshi's side for a window (~24 hours).
- For batch creates, each entry's `client_order_id` must be unique within the batch.

Pattern:

```python
import uuid

cid = str(uuid.uuid4())
try:
    order = client.orders.create_v2(
        ticker="...",
        client_order_id=cid,
        side="bid",
        count="10",
        price="0.6500",
        time_in_force="good_till_canceled",
    )
except (httpx.NetworkError, httpx.TimeoutException):
    # Retry with the SAME cid — server returns existing order if it exists.
    order = client.orders.create_v2(...)
```

## Cancelling

```bash
DELETE /trade-api/v2/portfolio/events/orders/{order_id}
```

Returns the canceled order's final state. Idempotent — canceling an already-canceled order returns 200 with the canceled state.

## Amending

```bash
PUT /trade-api/v2/portfolio/events/orders/{order_id}/amend
{ "price": "0.7000" }
```

Common pattern is to amend price rather than cancel+recreate, which preserves queue position when supported.

## Decreasing count

```bash
POST /trade-api/v2/portfolio/events/orders/{order_id}/decrease
{ "decrease_by": "5" }
```

Reduces remaining_count by N without changing other order properties.

## Batch operations

### Batch create

```json
POST /portfolio/events/orders/batch_create
{
  "orders": [
    { "ticker": "...A", "client_order_id": "uuid-1", "side": "bid", "count": "10", "price": "0.50", "time_in_force": "good_till_canceled" },
    { "ticker": "...B", "client_order_id": "uuid-2", "side": "bid", "count": "5",  "price": "0.40", "time_in_force": "good_till_canceled" }
  ]
}
```

Response is an array; each element is either an order object or an error object. The whole batch can succeed or partial-succeed; HTTP status is 200 if processing happened.

### Batch cancel

```json
POST /portfolio/events/orders/batch_cancel
{
  "order_ids": ["abc", "def"]
}
```

## Order groups

Bundle related orders so canceling the group cancels all members atomically:

```python
group = client.order_groups.create(name="bracket-strategy-1")
client.orders.create_v2(..., order_group_id=group.id)
client.orders.create_v2(..., order_group_id=group.id)
# Cancel them all at once:
client.order_groups.cancel(group.id)
```

Useful for:

- Bracket orders (one entry + one TP + one SL).
- Quoting both sides of a market (cancel both if one fills).
- Multi-leg basket trades.

## Self-trade prevention

When you both bid and offer in the same market, your own orders can cross. The `self_trade_prevention_type` field lets you choose what happens:

| Value | Behavior |
| --- | --- |
| `taker_at_cross` | The incoming (taker) order is canceled when it would cross your own resting order. |
| `cancel_oldest` | Your resting (maker) order is canceled instead, letting the taker proceed. |
| `cancel_both` | Both are canceled. |

Default varies by account. Pick deliberately for market-making strategies.

## Common rejection reasons

| Reject reason | Cause | Fix |
| --- | --- | --- |
| `insufficient_funds` | Wallet balance < order cost | Top up; or reduce size. |
| `market_closed` | Market in `closed` / `settled` state | Check market status before placing. |
| `position_limit_exceeded` | Per-market position cap | Reduce size; or split across markets. |
| `invalid_price` | Price not in [0.01, 0.99] (binary markets can't trade at 0 or 100 ¢) | Use a valid price tick. |
| `invalid_count` | Count ≤ 0 or non-integer when integer required | Use Decimal-string format for V2; int for legacy. |
| `duplicate_client_order_id` | `client_order_id` already used (rare — usually returns existing order instead) | Generate fresh UUID. |
| `self_trade_prevented` | Order would cross own order | Adjust price or use STP policy. |
| `rate_limit` | Too many orders / second | Slow down; respect endpoint costs. |

## Polling vs. WebSocket for own-order tracking

For order state changes, two patterns:

### Polling

```python
order = client.orders.get(order_id)
while order.status == "resting":
    time.sleep(1)
    order = client.orders.get(order_id)
```

Fine for one-off scripts. Not for systems with many open orders.

### WebSocket (`user_orders` channel)

Subscribe to the `user_orders` channel and `fill` channel; events stream as your orders change state. This is the right pattern for production systems. See `references/websocket-api.md`.

## Code recipes

### Place a limit YES bid at 50¢ for 10 contracts (V2)

```python
import uuid
from decimal import Decimal
from kalshi import KalshiClient, CreateOrderV2Request

with KalshiClient.from_env() as client:
    resp = client.orders.create_v2(request=CreateOrderV2Request(
        ticker="KXNBAGAME-26MAY25NYKCLE-NYK",
        client_order_id=str(uuid.uuid4()),
        side="bid",
        count=Decimal("10"),
        price=Decimal("0.50"),
        time_in_force="good_till_canceled",
        self_trade_prevention_type="taker_at_cross",
    ))
    print(resp.order_id, resp.status, resp.remaining_count)
```

### Cancel an order

```python
client.orders.cancel_v2(order_id="abc123")
```

### Quote both sides (market-making skeleton)

```python
group = client.order_groups.create(name=f"quote-{ticker}")
bid = client.orders.create_v2(
    ticker=ticker, side="bid", count=Decimal("10"), price=Decimal("0.45"),
    time_in_force="good_till_canceled",
    self_trade_prevention_type="cancel_oldest",
    order_group_id=group.id,
    client_order_id=str(uuid.uuid4()),
)
ask = client.orders.create_v2(
    ticker=ticker, side="ask", count=Decimal("10"), price=Decimal("0.55"),
    time_in_force="good_till_canceled",
    self_trade_prevention_type="cancel_oldest",
    order_group_id=group.id,
    client_order_id=str(uuid.uuid4()),
)
# Later, requote — cancel the whole group atomically:
client.order_groups.cancel(group.id)
```

## Migration: legacy → V2

| Legacy concept | V2 equivalent |
| --- | --- |
| `side: "yes"` + `action: "buy"` + `yes_price: 65` | `side: "bid"` + `price: "0.65"` |
| `side: "no"` + `action: "buy"` + `no_price: 35` | `side: "ask"` + `price: "0.65"` (same market, opposite side) |
| `side: "yes"` + `action: "sell"` + `yes_price: 70` | `side: "ask"` + `price: "0.70"` (selling YES = posting an ask) |
| Integer cents | Decimal-string dollars |
| Path: `/portfolio/orders` | `/portfolio/events/orders` |
| Order IDs are different namespaces | Cannot interleave — pick one |

Stop creating new orders on the legacy path. For systems with active legacy orders, let them settle / cancel naturally and create new orders on V2.

## Original sources

- `references/sources/openapi-specs/openapi.yaml` — exact V2 + legacy request/response shapes.
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — V2 code examples.
- Official (gated): https://docs.kalshi.com/api-reference/orders/create-order, create-order-v2, get-order.
