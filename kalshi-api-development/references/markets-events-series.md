# Markets, Events, Series — The Catalog Hierarchy

Kalshi organizes its tradable contracts in a three-level hierarchy: **series → events → markets**. Understanding this hierarchy is the foundation for every other API call. This reference explains the levels, the ticker formats, and the discovery flow.

## The three levels

```
Series                  KXNBAGAME
│   "All NBA game outcomes" — a recurring theme.
│   Series ticker is the prefix all related events share.
│
├── Event              KXNBAGAME-26MAY25NYKCLE
│   │   "NYK vs CLE on 2025-05-26 — one specific game"
│   │   Event ticker = series_ticker + "-" + event-specific suffix.
│   │
│   ├── Market         KXNBAGAME-26MAY25NYKCLE-NYK
│   │   "Will NYK win?" — binary yes/no contract
│   │
│   └── Market         KXNBAGAME-26MAY25NYKCLE-CLE
│       "Will CLE win?" — paired contract
│
└── Event              KXNBAGAME-27MAY25BOSDET
    │   "BOS vs DET on 2025-05-27"
    │
    ├── Market         KXNBAGAME-27MAY25BOSDET-BOS
    └── Market         KXNBAGAME-27MAY25BOSDET-DET
```

### Series

A **series** is a recurring theme that produces many events over time. Examples:

- `KXNBAGAME` — every NBA game outcome
- `KXFED` — every FOMC meeting (e.g., "will rates rise by Xbp?")
- `KXPRES` — presidential election markets
- `KXATPGAME` — every ATP tennis match
- `KXCPI` — monthly CPI prints

`series_ticker` is the persistent identifier — it doesn't change as new events are added.

### Event

An **event** is one instance of a series. For NBA, it's one specific game on one specific day. For FOMC, it's one meeting.

`event_ticker = series_ticker + "-" + event_suffix`. The suffix is series-specific (date + matchup for sports, date for FOMC, etc.).

Events have lifecycle states: `unopened`, `open`, `closed`, `settled`.

### Market

A **market** is one tradable binary (yes/no) contract under an event. A single event can have multiple markets:

- For a 2-team game, two markets (one per team's "to win") — or one market with the home team's win as YES.
- For a range market (FOMC: "rates between X and Y"), multiple markets, one per range.
- For a categorical market (election with N candidates), one market per candidate.

`market_ticker = event_ticker + "-" + outcome_suffix`.

Markets have a lifecycle: `initialized` → `active` → `closed` → `settled`.

## Discovery flow

A typical "I want to trade NBA games" exploration:

```python
import httpx

# 1. List all series (paginated)
r = httpx.get("https://demo-api.kalshi.co/trade-api/v2/series")
series = r.json()["series"]
# Find the NBA series
nba = next(s for s in series if s["ticker"] == "KXNBAGAME")

# 2. Get its events
r = httpx.get(
    "https://demo-api.kalshi.co/trade-api/v2/events",
    params={"series_ticker": "KXNBAGAME", "status": "open"},
)
events = r.json()["events"]

# 3. Get markets in one event (one game)
e = events[0]
r = httpx.get(
    "https://demo-api.kalshi.co/trade-api/v2/markets",
    params={"event_ticker": e["event_ticker"], "status": "open"},
)
markets = r.json()["markets"]
# markets has one entry per team / outcome

# Or, with_nested_markets in one shot:
r = httpx.get(
    "https://demo-api.kalshi.co/trade-api/v2/events",
    params={"series_ticker": "KXNBAGAME", "status": "open", "with_nested_markets": "true"},
)
events_with_markets = r.json()["events"]
```

## Filters on `/markets`

The `/markets` endpoint is the broadest catalog query. Useful filter combinations:

| Use case | Query |
| --- | --- |
| All markets in one event | `?event_ticker=KXNBAGAME-26MAY25NYKCLE` |
| All open markets in one series | `?series_ticker=KXNBAGAME&status=open` |
| Specific tickers | `?tickers=A,B,C` |
| Markets closing soon | `?min_close_ts=<now>&max_close_ts=<now+3600>` |
| Markets above a price threshold | (filter client-side; not server-side) |

`status` values: `unopened`, `open`, `active`, `closed`, `settled`. (Use the OpenAPI spec for the authoritative set.)

## Market object fields (high-level)

```json
{
  "ticker": "KXNBAGAME-26MAY25NYKCLE-NYK",
  "event_ticker": "KXNBAGAME-26MAY25NYKCLE",
  "market_type": "binary",
  "title": "Will NYK win?",
  "subtitle": "Game on 2025-05-26",
  "status": "active",
  "yes_bid": 52,
  "yes_ask": 54,
  "no_bid": 46,
  "no_ask": 48,
  "yes_sub_title": "Yes",
  "no_sub_title": "No",
  "open_time": "2025-05-26T18:00:00Z",
  "close_time": "2025-05-26T22:30:00Z",
  "expiration_time": "2025-05-27T00:00:00Z",
  "last_price": 53,
  "previous_yes_bid": 51,
  "previous_yes_ask": 53,
  "volume": 12450,
  "volume_24h": 5230,
  "open_interest": 8430,
  "liquidity": 1500,
  "result": "",                // "yes" / "no" / "" if not settled
  "settlement_value": null,
  "can_close_early": false,
  ...
}
```

(Exact field set evolves with the spec — confirm against `references/sources/openapi-specs/openapi.yaml`.)

**Prices are in cents** (0–100) in this shape — `yes_bid: 54` means 54¢. The V2 order endpoints accept prices as decimal-dollar strings (`"0.54"`).

## Yes / No equivalence

For every market:

```
P(yes_bid) + P(no_ask) ≈ 100   (cents)
P(yes_ask) + P(no_bid) ≈ 100
```

Buying YES at 54¢ is equivalent to selling NO at 46¢. The orderbook for NO is a mirror of YES, and the SDK / API typically lets you do either direction.

V2 event-scoped orders abstract this away — there's a single book per market with `bid` / `ask` sides, and the SDK derives YES/NO context from the event ticker.

## /markets/{ticker}/orderbook

Returns the current book snapshot — the input you bootstrap a WebSocket `orderbook_delta` stream with.

```json
{
  "orderbook": {
    "yes": [[54, 200], [53, 500], [52, 1000]],
    "no":  [[46, 100], [45, 300], [44, 800]]
  }
}
```

Each entry is `[price_cents, count]`. The first entry is the best price. The yes-side and no-side are independent books in the legacy view; V2 collapses them into a single book.

## /markets/{ticker}/candlesticks

OHLC candles for historical analysis:

```bash
GET /markets/{ticker}/candlesticks?
  start_ts=1717459200&
  end_ts=1717545600&
  period_interval=60     # seconds per candle
```

Response:

```json
{
  "candlesticks": [
    {
      "end_period_ts": 1717459260,
      "yes_price": { "open": 53, "low": 52, "high": 54, "close": 53, "mean": 53 },
      "yes_bid":   { "open": 52, "low": 52, "high": 54, "close": 53, "mean": 53 },
      "yes_ask":   { "open": 54, "low": 53, "high": 55, "close": 54, "mean": 54 },
      "price":     { "open": 53, "low": 52, "high": 54, "close": 53, "mean": 53 },
      "volume": 250,
      "open_interest": 8000
    }
  ]
}
```

## /markets/{ticker}/history

Tick-level historical events for one market — price changes, trades, status transitions. Higher resolution than candlesticks but heavier.

## /markets/trades

The public trades feed:

```bash
GET /markets/trades?ticker=KXNBAGAME-26MAY25NYKCLE-NYK&limit=100
```

Returns:

```json
{
  "trades": [
    {
      "ticker": "...",
      "trade_id": "...",
      "yes_price": 53,
      "no_price": 47,
      "count": 5,
      "taker_side": "yes",
      "created_time": "2025-05-26T20:15:23Z"
    }
  ],
  "cursor": "..."
}
```

Useful for building VWAP / tape feeds without a WebSocket. For real-time, use the `trade` WS channel.

## Ticker naming patterns

Series follow `KX<CAT>` patterns. Categories you'll commonly see:

- `KXFED*` — FOMC, rates.
- `KXCPI`, `KXCORECPI` — inflation prints.
- `KXNBAGAME`, `KXNFLGAME`, `KXMLBGAME`, `KXNHLGAME`, `KXATPGAME`, `KXWTAGAME` — sports.
- `KXPRES`, `KXSENATE`, `KXHOUSE`, `KXGOV` — political.
- `KXBTC`, `KXETH` — crypto.
- `KXOSCAR`, `KXEMMY` — entertainment.

Event suffixes encode date + identifiers; market suffixes encode the outcome.

Don't construct tickers from intuition — look them up via `/series` → `/events` → `/markets`.

## Common discovery pitfalls

| Symptom | Cause | Fix |
| --- | --- | --- |
| `404 Not Found` on `/markets/{ticker}` | Typo in ticker, or market settled and pruned | Verify via `/markets?tickers=X`. |
| Empty `markets` list when filtering | Status mismatch (e.g., `status=open` on a series with only `closed` events) | Drop the filter and inspect. |
| Pagination loop never ends | Forgot to update `cursor` parameter | Pass last response's `cursor` on each subsequent call. |
| `event_ticker` lookup returns no markets | Event hasn't opened yet | Check `event.status`; markets are created at event open. |

## Original sources

- `references/sources/openapi-specs/openapi.yaml` — authoritative for all field shapes.
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — examples in client form.
- Official (gated): https://docs.kalshi.com/api-reference/market/, /events/, /series/.
