# FIX Protocol

Kalshi supports FIX (Financial Information eXchange) for low-latency professional trading. This reference covers the transport, message dialect, supported session types, authentication, and the canonical message recipes.

> **When to use FIX vs. REST/WebSocket:** FIX is for institutional / co-located low-latency trading. If you're outside a Kalshi co-lo and your strategy can tolerate 10–50 ms, REST + WebSocket is simpler and gets you 90% of the way. Use FIX when you need single-digit-millisecond order entry, drop-copy reconciliation, or the formal message guarantees the protocol provides.

## Transport and dialect

- **Transport**: FIXT.1.1 — the modern session-layer FIX transport.
- **Application messages**: FIX 5.0 SP2 (FIX50SP2) — the modern application-layer dialect.
- **Heartbeats**: default 30 seconds (configurable in Logon).
- **Sequence numbers**: per-session, monotonically increasing, with built-in recovery.

This combination (FIXT.1.1 + FIX50SP2) is the standard modern FIX stack — most institutional venues use it. Older FIX 4.2 / 4.4 implementations are not supported.

## Session types

Kalshi exposes multiple session types per product. You log into one session per type per FIX engine instance.

### Event-contracts (prediction) sessions

| Session | Purpose |
| --- | --- |
| **Order Entry** | Place / cancel / amend orders. Receives ExecutionReport drop-back. |
| **Drop Copy** | Receive a copy of all your order events. Read-only. Used by risk/back-office. |
| **Market Data** | Subscribe to orderbook + trades + ticker. |
| **Post-Trade** | Settled trades + clearing events. Prediction-only. |
| **RFQ (Request-for-Quote)** | Block-trade RFQ flow. Prediction-only. |

### Perps (margin) sessions

| Session | Purpose |
| --- | --- |
| Order Entry | Place / cancel / amend perps orders. |
| Drop Copy | Read-only event copy. |
| Market Data | Perps orderbook + trades + funding. |

## Authentication via RSA-PSS (in Logon)

Same RSA-PSS key as REST — the Logon message embeds a signed payload:

- The signed input is constructed from the session's `Username(553)`, `SendingTime(52)`, and `SenderCompID(49)`, concatenated.
- The signature is base64-encoded into `RawData(95)`, with `RawDataLength(96)` set accordingly.
- The `EncryptMethod(98)` is `0` (none — TLS handles encryption).
- The `Password(554)` is omitted (RSA-PSS replaces password auth).

Exact concatenation order and any framing characters depend on the Kalshi spec — verify against the live FIX gateway docs at sign-up. The `kalshi-sdk` community SDK encapsulates this in `FixClient.from_env()`.

## Logon flow

```
1. Open TCP+TLS connection to Kalshi FIX gateway.
2. Send Logon(35=A) with embedded RSA-PSS RawData.
3. Receive Logon(35=A) ack.
4. Begin sending application messages.
5. Send heartbeats every 30 s (default); receive heartbeats from server.
6. On sequence gap: send ResendRequest(35=2).
7. On disconnect: reconnect, Logon again, expect sequence-recovery flow.
```

## Common application messages

### NewOrderSingle (35=D)

Place a new order.

| Tag | Field | Notes |
| --- | --- | --- |
| 11 | ClOrdID | Your idempotency key. Required, unique. |
| 55 | Symbol | Market ticker (e.g., `KXNBAGAME-26MAY25NYKCLE-NYK`). |
| 54 | Side | `1=BUY` (yes-buy / bid), `2=SELL`, `7=SELL_SHORT`, etc. Kalshi has dialect-specific extensions for yes/no semantics. |
| 38 | OrderQty | Number of contracts. |
| 40 | OrdType | `1=MARKET`, `2=LIMIT`. |
| 44 | Price | Limit price in dollars (decimal). |
| 59 | TimeInForce | `0=DAY`, `1=GTC`, `3=IOC`, `4=FOK`, `6=GTD`. |

Example (illustrative — verify with the live FIX spec):

```
8=FIXT.1.1|9=...|35=D|49=YOUR-COMP-ID|56=KALSHI|34=42|52=20260526-14:30:00.123|
11=client-order-id-uuid|55=KXNBAGAME-26MAY25NYKCLE-NYK|54=1|38=10|40=2|44=0.65|59=1|10=...|
```

### ExecutionReport (35=8)

Server-to-client report of order events: ack, partial fill, full fill, cancel, reject.

| Tag | Field | Notes |
| --- | --- | --- |
| 11 | ClOrdID | Mirror of your value. |
| 17 | ExecID | Execution event ID. |
| 37 | OrderID | Kalshi order ID. |
| 39 | OrdStatus | `0=NEW`, `1=PARTIALLY_FILLED`, `2=FILLED`, `4=CANCELED`, `8=REJECTED`. |
| 150 | ExecType | What kind of event (similar enum). |
| 32 | LastQty | Quantity on this fill. |
| 31 | LastPx | Price on this fill. |
| 151 | LeavesQty | Remaining open quantity. |
| 14 | CumQty | Cumulative filled. |
| 6 | AvgPx | Average fill price. |

### OrderCancelRequest (35=F)

Cancel an order by its `OrigClOrdID(41)` or `OrderID(37)`.

### OrderCancelReplaceRequest (35=G)

Amend price/qty in one round trip — replaces an existing order with new parameters.

### Logout (35=5)

Gracefully end the session.

### Heartbeat (35=0), TestRequest (35=1), ResendRequest (35=2)

Session-layer messages handled by the FIX engine.

## Sequence-gap recovery

If your client expects message #42 but receives #45, send:

```
35=2 (ResendRequest), 7=42, 16=44
```

The server resends 42, 43, 44 (possibly as gap-fill if some weren't important).

If your engine's incoming sequence is ahead of what the server has, the server sends Logout. You restart with a higher `MsgSeqNum(34)`.

## Drop Copy session

Subscribe once at logon. Receives a copy of every ExecutionReport for your orders — including events placed via REST, WebSocket, FIX order entry, or the web UI. This is the canonical "what happened to my orders" feed for risk systems that want a single source.

## Market Data session

Use `MarketDataRequest(35=V)` to subscribe to a market's book:

| Tag | Field | Notes |
| --- | --- | --- |
| 262 | MDReqID | Your subscription ID. |
| 263 | SubscriptionRequestType | `1`=snapshot+updates, `0`=snapshot only, `2`=unsubscribe. |
| 264 | MarketDepth | `0`=full book, `1`=top-of-book. |
| 267 | NoMDEntryTypes | Number of entry types you want. |
| 269 | MDEntryType | `0`=bid, `1`=offer, `2`=trade. |
| 146 | NoRelatedSym | Number of symbols you're subscribing to. |
| 55 | Symbol (repeated) | Market ticker. |

The server responds with `MarketDataSnapshotFullRefresh(35=W)` (full snapshot) and then `MarketDataIncrementalRefresh(35=X)` (deltas).

## Post-Trade (prediction only)

After a market settles, Kalshi sends post-trade events on this session — settlement value, payout, etc. Use this for SCM-style settlement integration if you're a Self-Clearing Member.

## RFQ (prediction only)

Request-for-Quote for block trades. Send `QuoteRequest(35=R)`; receive `Quote(35=S)` from one or more market makers; accept with `NewOrderSingle` referencing the quote ID. Used by institutional flow above the on-screen sizes.

## Code (community SDK example)

The `kalshi-sdk` (TexasCoding) bundles a Python FIX engine — usable directly:

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
            cl_ord_id="order-1",
            symbol="KXNBAGAME-26MAY25NYKCLE-NYK",
            side=Side.BUY_YES,
            order_qty=Decimal("10"),
            price=Decimal("0.55"),
        ))
        await asyncio.sleep(2)

asyncio.run(main())
```

For perps:

```python
from kalshi import MarginFixClient, FixEnvironment

client = MarginFixClient.from_env(environment=FixEnvironment.PRODUCTION)
async with client.order_entry(on_message=on_message) as session:
    ...
```

For raw FIX (without the SDK), use `quickfix-python`, `simplefix`, or a custom engine. Build messages with the typed fields above; serialize per FIXT.1.1.

## Connection details

- **TLS only.** No plaintext FIX.
- Endpoint hostnames + ports are issued by Kalshi at FIX enrollment (it's an opt-in for FIX-eligible accounts).
- Typical setup: production has its own pair of host:port; demo has another.

## When to choose FIX

- You're operating from co-location (NY/NY-metro for event-contracts, varies for perps).
- You need < 5 ms round-trip order entry.
- You need a standard message protocol that integrates with your existing OMS/EMS.
- You need Drop Copy for risk-system integration.
- You want post-trade / settlement events as first-class FIX messages.

Most retail users never need FIX. The WebSocket + REST combo is sufficient for everything short of HFT.

## Common FIX failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| Logon rejected with bad signature | Wrong RSA-PSS payload format | Verify with SDK or live spec. |
| Reconnect loop | Sequence numbers out of sync | Reset both sides' sequence; or send `Logon` with `ResetSeqNumFlag(141)=Y`. |
| ExecReport missing for known fill | Drop Copy not enabled | Open the Drop Copy session. |
| MarketDataIncrementalRefresh gaps | Slow consumer; backpressure | Process faster or subscribe to top-of-book only. |
| Heartbeat timeout | Firewall stripped a TCP packet | Reconnect; consider keepalive at TCP layer. |
| Order rejected (8/35=8 with OrdRejReason) | Same as REST rejects | Check `OrdRejReason(103)` for the specific reason. |

## Original sources

- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — `FixClient` / `MarginFixClient` examples.
- Official (gated): https://docs.kalshi.com/api-reference/fix/ (when present).
- FIXT.1.1 spec: https://www.fixtrading.org/standards/fixt-online/
- FIX 5.0 SP2: https://www.fixtrading.org/standards/fix-5-0-sp-2/
