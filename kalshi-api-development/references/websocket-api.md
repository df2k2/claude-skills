# WebSocket API

Real-time streaming of market data, order updates, and exchange events. The current AsyncAPI declares **12 typed channels** plus 2 escape-hatches. This reference covers the connection lifecycle, every channel, message shapes, sequencing, reconnection, and the canonical orderbook-reconstruction recipe.

## Endpoints

| Env | URL |
| --- | --- |
| Production | `wss://api.elections.kalshi.com/trade-api/ws/v2` |
| Demo | `wss://demo-api.kalshi.co/trade-api/ws/v2` |
| Perps prod | `wss://external-api.kalshi.com/trade-api/ws/v2` |
| Perps demo | `wss://external-api.demo.kalshi.co/trade-api/ws/v2` |

(Perps has its own WS surface — see `references/perps-margin.md`.)

## Auth

The WebSocket upgrade is HTTP. Send the same three RSA-PSS headers as REST:

```
KALSHI-ACCESS-KEY:       <key_id>
KALSHI-ACCESS-TIMESTAMP: <unix_ms>
KALSHI-ACCESS-SIGNATURE: <base64>
```

The signed payload is:

```
signing_input = timestamp_ms + "GET" + "/trade-api/ws/v2"
```

Note: **`/trade-api/ws/v2` exactly, no trailing slash.** A trailing slash will produce a valid 200 upgrade but a 401 on next frame, depending on the gateway version.

Public market-data channels (`ticker`, `trade`, `orderbook_delta`, `market_lifecycle`, `multivariate`, `multivariate_lifecycle`, `communications`, `cfbenchmarks_value`) can technically be subscribed without auth on some deployments — but most SDKs require auth uniformly. Always sign.

## Connection lifecycle

```
1. Open WS connection with signed headers.
2. (Optional) Send `version` command to negotiate protocol version.
3. Send `subscribe` command with channels + filters.
4. Receive `subscribed` ack with subscription_id.
5. Stream of typed messages flows.
6. Send `unsubscribe` to stop a stream; close connection to stop all.
```

### Subscribe message

```json
{
  "id": 1,
  "cmd": "subscribe",
  "params": {
    "channels": ["ticker", "orderbook_delta"],
    "market_tickers": ["KXNBAGAME-26MAY25NYKCLE-NYK", "KXNBAGAME-26MAY25NYKCLE-CLE"]
  }
}
```

Fields:

- `id` (int) — your client-side request ID; echoed in the ack.
- `cmd` — `"subscribe"`, `"unsubscribe"`, `"version"`.
- `params.channels` — array of channel names.
- `params.market_tickers` — filter to specific markets (where applicable).
- `params.event_tickers` — for event-level subscriptions.

### Subscribed ack

```json
{
  "id": 1,
  "type": "subscribed",
  "msg": {
    "channel": "orderbook_delta",
    "sid": 42                        // subscription ID
  }
}
```

### Unsubscribe

```json
{ "id": 2, "cmd": "unsubscribe", "params": { "sids": [42] } }
```

## The 12 typed channels

| Channel | Public/private | What it streams |
| --- | --- | --- |
| `ticker` | public | Best bid / best ask updates per market |
| `trade` | public | All public trades |
| `orderbook_delta` | public | Book deltas + initial snapshot |
| `fill` | private | Your fills |
| `market_positions` | private | Your positions per market |
| `user_orders` | private | Your order lifecycle events |
| `order_group` | private | Order-group lifecycle events |
| `market_lifecycle` | public | Market open/close/settle/result |
| `multivariate` | public | Multivariate market updates |
| `multivariate_lifecycle` | public | Multivariate lifecycle |
| `communications` | public | Exchange announcements |
| `cfbenchmarks_value` | public | CF Benchmarks index values |

Plus two escape-hatches in the AsyncAPI (`control_frames` and `root`) for protocol-level messages — typically only used internally by SDKs.

### `ticker`

```json
{
  "type": "ticker",
  "sid": 42,
  "seq": 1234,
  "msg": {
    "market_ticker": "KXNBAGAME-26MAY25NYKCLE-NYK",
    "yes_bid": 53,
    "yes_ask": 55,
    "no_bid": 45,
    "no_ask": 47,
    "price": 54,                    // last trade price
    "volume": 12000,
    "open_interest": 8000,
    "ts": "..."
  }
}
```

Best for "show me current prices for these N markets" — low frequency, very lightweight.

### `trade`

```json
{
  "type": "trade",
  "sid": 43,
  "seq": 1235,
  "msg": {
    "market_ticker": "...",
    "trade_id": "...",
    "yes_price": 54,
    "no_price": 46,
    "count": 5,
    "taker_side": "yes",
    "ts": "..."
  }
}
```

One message per public trade.

### `orderbook_delta`

The most important channel for market makers. Two message types:

**Snapshot** (first message after subscribe):

```json
{
  "type": "orderbook_snapshot",
  "sid": 44,
  "seq": 0,
  "msg": {
    "market_ticker": "...",
    "yes":  [[54, 200], [53, 500], [52, 1000]],
    "no":   [[46, 100], [45, 300], [44, 800]]
  }
}
```

**Delta** (each subsequent change):

```json
{
  "type": "orderbook_delta",
  "sid": 44,
  "seq": 1,
  "msg": {
    "market_ticker": "...",
    "price": 54,
    "side":  "yes",                 // or "no"
    "delta": -100                   // negative = removed; positive = added
  }
}
```

Apply deltas to the snapshot keyed by `(side, price)`. When the resulting count at a price level reaches zero, remove the level.

### `fill`

```json
{
  "type": "fill",
  "sid": 45,
  "seq": 2000,
  "msg": {
    "order_id": "...",
    "trade_id": "...",
    "market_ticker": "...",
    "side": "yes",
    "action": "buy",
    "count": 10,
    "yes_price": 54,
    "no_price": 46,
    "is_taker": true,
    "ts": "..."
  }
}
```

Real-time fill notification for your own orders.

### `user_orders`

Lifecycle events for your orders:

```json
{
  "type": "user_order_update",
  "sid": 46,
  "seq": 2001,
  "msg": {
    "order_id": "...",
    "status": "executed",            // resting / executed / canceled / amended
    "remaining_count": 0,
    "fill_count": 10,
    "ts": "..."
  }
}
```

Primary signal for "did my order fill?". Use instead of polling `GET /portfolio/orders/{id}`.

### `market_positions`

Your position per market as it changes:

```json
{
  "type": "market_position",
  "sid": 47,
  "seq": 2002,
  "msg": {
    "market_ticker": "...",
    "position": 10,
    "market_exposure": 540,
    "realized_pnl": 0,
    "ts": "..."
  }
}
```

### `order_group`

Group lifecycle events when you use order groups:

```json
{
  "type": "order_group_update",
  "sid": 48,
  "seq": 2003,
  "msg": {
    "order_group_id": "...",
    "status": "canceled",            // active / canceled
    "ts": "..."
  }
}
```

### `market_lifecycle`

Public market status transitions:

```json
{
  "type": "market_lifecycle",
  "sid": 49,
  "seq": 3001,
  "msg": {
    "market_ticker": "...",
    "old_status": "active",
    "new_status": "closed",
    "ts": "..."
  }
}
```

Useful for trading-system halts on market close.

### `multivariate`, `multivariate_lifecycle`

Same shapes as `ticker` / `market_lifecycle` but for multivariate (parlay-style) markets.

### `communications`

```json
{
  "type": "communication",
  "sid": 50,
  "seq": 4001,
  "msg": {
    "subject": "...",
    "body": "...",
    "level": "info",                 // info / warning / critical
    "ts": "..."
  }
}
```

Exchange announcements — connection-impacting maintenance, etc. Always subscribe to this in production systems.

### `cfbenchmarks_value`

Index values from CF Benchmarks (used for crypto / financial settlements):

```json
{
  "type": "cfbenchmarks_value",
  "sid": 51,
  "seq": 5001,
  "msg": {
    "index_id": "...",
    "value": "...",
    "ts": "..."
  }
}
```

## Sequencing and gap detection

Every message carries a `seq` (sequence number) that monotonically increases **per subscription**. If you see a gap (`seq` jumps non-sequentially), you've missed messages — discard local state, unsubscribe, re-subscribe, and re-bootstrap.

```python
last_seq = None
async for msg in stream:
    seq = msg["seq"]
    if last_seq is not None and seq != last_seq + 1:
        logger.warning(f"sequence gap: {last_seq} -> {seq}; resubscribing")
        raise SequenceGap()
    last_seq = seq
    apply(msg)
```

Different channels have different `seq` counters; track per-subscription, not globally.

## Reconnection / resilience

Plan for disconnects:

1. **Connection drop** → reconnect with fresh RSA-PSS signature (the old one is expired).
2. **Resubscribe** to all channels.
3. **For `orderbook_delta`**: re-snapshot via REST and discard the old book.
4. **For `user_orders` / `fill`**: pull missed state via REST (`GET /portfolio/orders?status=resting`, `GET /portfolio/fills?min_ts=<last_known>`).

Recommended: exponential backoff on reconnect with jitter (1s, 2s, 4s, ..., capped at 30s). Don't hammer.

## Orderbook reconstruction recipe

The single most important pattern.

```python
import asyncio
from collections import defaultdict

class LocalBook:
    def __init__(self):
        self.yes = defaultdict(int)   # price_cents -> count
        self.no  = defaultdict(int)
        self.last_seq = None
        self.snapshot_seq = None

    def apply_snapshot(self, snap, seq):
        self.yes.clear(); self.no.clear()
        for p, c in snap["yes"]:
            self.yes[p] = c
        for p, c in snap["no"]:
            self.no[p] = c
        self.snapshot_seq = seq
        self.last_seq = seq

    def apply_delta(self, side, price, delta, seq):
        if seq <= self.snapshot_seq:
            return  # already in snapshot
        if seq != self.last_seq + 1:
            raise SequenceGap()
        book = self.yes if side == "yes" else self.no
        book[price] += delta
        if book[price] <= 0:
            del book[price]
        self.last_seq = seq

    def best_bid_ask(self):
        yes_prices = sorted(self.yes.keys(), reverse=True)
        no_prices  = sorted(self.no.keys(), reverse=True)
        return {
            "yes_bid": yes_prices[0] if yes_prices else None,
            "no_bid":  no_prices[0]  if no_prices  else None,
        }

async def run(ws, ticker):
    book = LocalBook()
    # 1. Subscribe to deltas BEFORE getting snapshot to ensure no gap.
    await ws.send_subscribe(channels=["orderbook_delta"], market_tickers=[ticker])
    # Collect early deltas while waiting for snapshot.
    pending = []
    async for msg in ws:
        if msg["type"] == "orderbook_snapshot":
            book.apply_snapshot(msg["msg"], msg["seq"])
            # Apply buffered deltas
            for d in pending:
                if d["seq"] > book.snapshot_seq:
                    book.apply_delta(d["msg"]["side"], d["msg"]["price"], d["msg"]["delta"], d["seq"])
            pending = []
            break
        elif msg["type"] == "orderbook_delta":
            pending.append(msg)
    # 2. Main loop
    async for msg in ws:
        try:
            if msg["type"] == "orderbook_delta":
                book.apply_delta(msg["msg"]["side"], msg["msg"]["price"], msg["msg"]["delta"], msg["seq"])
        except SequenceGap:
            return await run(ws, ticker)  # restart from scratch
```

The `pending` buffer is critical — between sending `subscribe` and receiving the snapshot, deltas can arrive. Without buffering you miss them.

## Latency expectations

Approximate ranges (varies with network proximity):

| Channel | Typical latency to client |
| --- | --- |
| `ticker` | < 50ms |
| `trade` | < 50ms |
| `orderbook_delta` | < 30ms |
| `fill` | < 30ms |
| `user_orders` | < 30ms |
| `market_lifecycle` | < 100ms |

For sub-millisecond latency, use FIX from a colocated environment — see `references/fix-protocol.md`.

## Heartbeats / keepalive

Kalshi sends WebSocket ping frames; respond with pong. Most clients (Python `websockets`, Node `ws`) handle this automatically. If you implement at the raw socket layer, you must respond.

If the connection goes silent (no messages, no pings) for > 30 seconds, treat as disconnected and reconnect.

## Backpressure

A slow consumer that doesn't drain its receive buffer will eventually:

1. Fill the socket's TCP receive buffer.
2. Kalshi's send queue backs up.
3. Kalshi may drop your connection.

Mitigation:

- Process messages quickly; offload heavy work to a queue.
- Track lag (compare message `ts` to wall clock); alert if > 5s.
- For low-volume strategies, this won't matter. For high-volume, use a ring buffer between WS recv and your strategy code.

## Subscription limits

Per connection there's a limit on simultaneous subscriptions (the exact number depends on account tier, ~ hundreds). For many markets, group filters into single subscriptions instead of one subscription per ticker.

## Common WebSocket failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| `401` on upgrade | Signed wrong path or expired timestamp | Sign exactly `GET/trade-api/ws/v2` with fresh timestamp. |
| Connection opens then immediately closes | Auth correct but subscription failed | Check the `subscribed` ack vs. `error` response. |
| Book diverges from REST snapshot | Missed a delta during reconnect | Re-snapshot via REST + discard local state. |
| Messages arrive but `seq` is missing/duplicated | SDK bug or improper deduplication | Track per-subscription `seq` strictly. |
| `1006` close code (abnormal) | Network blip / proxy issue | Exponential-backoff reconnect. |
| `1008` close code (policy violation) | Rate-limit / abusive behavior | Slow down; check rate limit. |
| Subscribed to private channel but get no auth | Forgot signed headers on upgrade | Send all three RSA-PSS headers. |

## Original sources

- `references/sources/openapi-specs/asyncapi.yaml` — the canonical channel + message specs.
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — `KalshiWebSocket` example.
- `references/sources/sdk-snippets/pykalshi/README.md` — streaming-focused community SDK.
- Official (gated): https://docs.kalshi.com/api-reference/websocket/.
