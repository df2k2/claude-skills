# kalshi-sdk (TexasCoding) — captured 2026-06-26

> Captured verbatim from https://github.com/TexasCoding/kalshi-python-sdk (MIT licensed).
> The local fetch script (`scripts/kalshi/fetch_docs.sh`) is the canonical refresh path;
> this file is a snapshot so the skill remains useful when GitHub egress is unavailable.

# kalshi-sdk

A professional, spec-first Python SDK for the [Kalshi](https://kalshi.com) prediction markets API.

- **Full coverage** of the Kalshi REST API (104 operations across 19 resources, OpenAPI v3.21.0) and WebSocket API (12 typed `subscribe_*` channels + 2 escape-hatch).
- **Perps (margin) API**: standalone `PerpsClient` / `AsyncPerpsClient` + `PerpsWebSocket` for the perpetual-futures exchange (34 REST operations, 6 WS channels), plus a `KlearClient` for the Self-Clearing-Member "Klear" settlement API (9 operations).
- **FIX protocol**: an async-first FIX engine (FIXT.1.1 / FIX50SP2) for both products — order-entry, drop-copy, market-data, post-trade (prediction), and RFQ (prediction) sessions (plus order-group management over the order-entry session) with typed message models, sequence recovery, and order-book / settlement reassembly. `from kalshi import FixClient` / `MarginFixClient`.
- **V2 event-market orders**: `create_v2` / `amend_v2` / `decrease_v2` / `cancel_v2` plus batched variants on `/portfolio/events/orders/*`. Legacy `/portfolio/orders` keeps working — deprecated no earlier than May 6, 2026.
- **Funding & cost introspection**: `portfolio.deposits()`, `portfolio.withdrawals()`, `account.endpoint_costs()`.
- **Sync and async** clients sharing one transport — no thread-pool wrapping.
- **Typed end-to-end**: Pydantic v2 models, `mypy --strict` clean, ships `py.typed`. `Literal` types on fixed-enum kwargs.
- **Spec-aligned with drift guards**: hard-fail contract tests catch query, body, and WebSocket payload drift on every commit.
- **Safe defaults**: only idempotent verbs (`GET`/`HEAD`/`OPTIONS`) retry; `POST`/`DELETE` never retry to avoid duplicate orders or cancels.
- **DataFrame-ready**: optional `pandas` / `polars` extras for analysis workflows.
- **Offline-testable**: record/replay mock transport (`kalshi.testing`) for SDK consumers building integration tests.

Full documentation: https://texascoding.github.io/kalshi-python-sdk/

## Install

```bash
pip install kalshi-sdk
```

Requires Python 3.12+.

## Quickstart — sync

```python
from kalshi import KalshiClient

with KalshiClient(
    key_id="your-key-id",
    private_key_path="~/.kalshi/private_key.pem",
) as client:
    page = client.markets.list(status="open", limit=10)
    for market in page:
        print(market.ticker, market.yes_bid, market.yes_ask)
```

## Quickstart — async

```python
import asyncio
from kalshi import AsyncKalshiClient

async def main() -> None:
    async with AsyncKalshiClient(
        key_id="your-key-id",
        private_key_path="~/.kalshi/private_key.pem",
    ) as client:
        async for market in client.markets.list_all(status="open"):
            print(market.ticker, market.yes_bid)

asyncio.run(main())
```

## Authentication

Kalshi uses RSA-PSS request signing. Generate a key pair in your Kalshi
[account settings](https://kalshi.com/account/profile) and download the PEM.

### From environment variables

```bash
export KALSHI_KEY_ID="..."
export KALSHI_PRIVATE_KEY_PATH="~/.kalshi/private_key.pem"
# or, inline:
export KALSHI_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----..."

# Optional:
export KALSHI_DEMO=true              # use the demo (sandbox) environment
export KALSHI_API_BASE_URL=...       # override base URL
```

```python
from kalshi import KalshiClient
client = KalshiClient.from_env()
```

`from_env()` returns an **unauthenticated** client if no credentials are set.
Public endpoints still work; private endpoints raise `AuthRequiredError`.

### Demo vs production

```python
KalshiClient(key_id="...", private_key_path="...", demo=True)   # sandbox
KalshiClient(key_id="...", private_key_path="...")              # production (default)
```

## Placing orders

```python
from kalshi import KalshiClient

with KalshiClient.from_env() as client:
    order = client.orders.create(
        ticker="EXAMPLE-25-T",
        side="yes",
        action="buy",
        count=10,
        yes_price="0.65",          # 65 cents
        time_in_force="good_till_canceled",
        client_order_id="my-uuid", # idempotency key
    )
    print(order.order_id, order.status)
```

Prices are decimal dollars (e.g. `"0.65"`) per the Kalshi spec. Internally
the SDK uses `Decimal` via the `DollarDecimal` type — never `float`.

### V2 event-market orders

Spec v3.18.0 introduced the V2 family on `/portfolio/events/orders/*` —
event-scoped semantics with single-book `bid`/`ask` sides and fixed-point
dollar prices. Legacy `/portfolio/orders` keeps working and will be
deprecated no earlier than May 6, 2026.

```python
import uuid
from decimal import Decimal
from kalshi import KalshiClient, CreateOrderV2Request

with KalshiClient.from_env() as client:
    resp = client.orders.create_v2(request=CreateOrderV2Request(
        ticker="EVENT-MKT",
        client_order_id=str(uuid.uuid4()),
        side="bid",                         # BookSideLiteral: "bid" | "ask"
        count=Decimal("10"),
        price=Decimal("0.50"),
        time_in_force="good_till_canceled",
        self_trade_prevention_type="taker_at_cross",
    ))
    print(resp.order_id, resp.remaining_count, resp.fill_count)
```

## WebSocket streaming

```python
import asyncio
from kalshi import KalshiAuth, KalshiConfig
from kalshi.ws import KalshiWebSocket

async def main() -> None:
    auth = KalshiAuth.from_key_path("your-key-id", "~/.kalshi/private_key.pem")
    config = KalshiConfig.demo()

    ws = KalshiWebSocket(auth=auth, config=config)
    async with ws.connect() as session:
        stream = await session.subscribe_orderbook_delta(tickers=["EXAMPLE-25-T"])
        async for msg in stream:
            print(msg)

asyncio.run(main())
```

The 12 typed channels are:
`subscribe_ticker`, `subscribe_trade`, `subscribe_orderbook_delta`,
`subscribe_fill`, `subscribe_market_positions`, `subscribe_user_orders`,
`subscribe_order_group`, `subscribe_market_lifecycle`,
`subscribe_multivariate`, `subscribe_multivariate_lifecycle`,
`subscribe_communications`, `subscribe_cfbenchmarks_value`. The AsyncAPI's
`control_frames` and `root` channels are reachable through the generic
`subscribe(channel, ...)` escape hatch.

## Perps (margin) trading

Perps is a separate exchange on its own host.

- Prod base URL: `https://external-api.kalshi.com/trade-api/v2`
- Demo base URL: `https://external-api.demo.kalshi.co/trade-api/v2`

```python
from kalshi import PerpsClient
with PerpsClient.from_env(demo=True) as perps:
    print(perps.exchange.status())
    for m in perps.markets.list(status="active"):
        print(m.ticker, m.bid, m.ask)
    print(perps.margin.balance())
```

Resource families: `exchange`, `markets`, `orders`, `order_groups`,
`portfolio`, `margin`, `funding`, `transfers`.

WebSocket channels: `subscribe_ticker` (carries `funding_rate` +
`next_funding_time_ms`), `subscribe_orderbook_delta`, `subscribe_trade`,
`subscribe_fill`, `subscribe_user_orders`, `subscribe_order_group`.

Prices are `DollarDecimal` (FixedPointDollars, up to 6 decimals); counts are
`FixedPointCount` (2 decimals, `_fp` wire suffix). REST timestamps are RFC3339;
**WebSocket timestamps are Unix epoch milliseconds** (`*_ms` fields).

The Self-Clearing-Member "Klear" settlement API is a third surface via
`KlearClient`, using **Bearer token** auth (`access_token=...`) rather than
RSA-PSS.

## FIX protocol (low-latency)

```python
import asyncio
from decimal import Decimal
from kalshi import FixClient, FixEnvironment
from kalshi.fix import NewOrderSingle, ExecutionReport, Side, decode_app_message

async def main() -> None:
    async def on_message(raw) -> None:
        msg = decode_app_message(raw)
        if isinstance(msg, ExecutionReport):
            print(msg.cl_ord_id, msg.exec_type, msg.ord_status)

    client = FixClient.from_env(environment=FixEnvironment.DEMO)
    async with client.order_entry(on_message=on_message) as session:
        await session.send(NewOrderSingle(
            cl_ord_id="order-1", symbol="KXNBAGAME-26MAY25NYKCLE-NYK",
            side=Side.BUY_YES, order_qty=Decimal("10"), price=Decimal("0.55"),
        ))
        await asyncio.sleep(2)

asyncio.run(main())
```

Prediction uses `FixClient`; margin uses `MarginFixClient`. FIXT.1.1 /
FIX50SP2. Sessions: order-entry, drop-copy, market-data, post-trade
(prediction), RFQ (prediction), plus order-group management over
order-entry.

## Error hierarchy

```python
from kalshi import (
    KalshiError,
    KalshiAuthError,        # 401 / 403
    AuthRequiredError,      # private endpoint called without credentials
    KalshiNotFoundError,    # 404
    KalshiValidationError,  # 400 (has .details: dict[str, str])
    KalshiRateLimitError,   # 429 (has .retry_after: float | None)
    KalshiServerError,      # 5xx
    KalshiWebSocketError,
    KalshiConnectionError,
    KalshiSequenceGapError,
    KalshiBackpressureError,
    KalshiSubscriptionError,
)
```

## Retry policy

- Retries on `429`, `502`, `503`, `504`, `500` (idempotent GET only).
- `POST` and `DELETE` are **never** retried — duplicate order / cancel risk.
- Exponential backoff with jitter, capped at `retry_max_delay`.
- `Retry-After` is honored but capped at `retry_max_delay`.

## Pagination

```python
# Cursor loop:
page = client.markets.list(status="open", limit=200)
while True:
    for market in page: ...
    if not page.has_next: break
    page = client.markets.list(status="open", limit=200, cursor=page.cursor)

# Or:
for market in client.markets.list_all(status="open"): ...
```

## Resources

| | |
|---|---|
| Documentation site | https://texascoding.github.io/kalshi-python-sdk/ |
| Kalshi REST OpenAPI spec | https://docs.kalshi.com/openapi.yaml |
| Kalshi WebSocket AsyncAPI spec | https://docs.kalshi.com/asyncapi.yaml |
| Production base URL | `https://api.elections.kalshi.com/trade-api/v2` |
| Demo base URL | `https://demo-api.kalshi.co/trade-api/v2` |
