# Kalshi OpenAPI / AsyncAPI specs

This directory **should** hold the three spec files Kalshi publishes:

| File | Purpose |
| --- | --- |
| `openapi.yaml` | REST API for the **event-contracts** product (OpenAPI v3.21.0, 104 ops / 19 resources) |
| `asyncapi.yaml` | WebSocket API for event-contracts (12 typed `subscribe_*` channels + 2 escape-hatch: `control_frames`, `root`) |
| `perps_openapi.yaml` | REST API for the **perpetual-futures (margin)** product (34 ops) |

Live URLs:

- https://docs.kalshi.com/openapi.yaml
- https://docs.kalshi.com/asyncapi.yaml
- https://docs.kalshi.com/perps_openapi.yaml

## Why they may not be present in this skill

`docs.kalshi.com` is fronted by Cloudflare. From environments without a real
browser (CI runners, sandboxes), the YAML URLs commonly return HTTP 403 (the
"Just a moment…" interstitial). When you check out this repository in a normal
developer environment, the bundled `scripts/kalshi/fetch_docs.sh` will succeed
and populate this directory with the live specs.

## Refresh

```bash
# Standard refresh (works from most developer machines + most CI):
bash scripts/kalshi/fetch_docs.sh
```

If `curl` still 403s, use a headless browser (Playwright / Puppeteer) that
clears the Cloudflare challenge:

```python
# fetch_specs_headless.py
from playwright.sync_api import sync_playwright
import pathlib

DEST = pathlib.Path("kalshi-api-development/references/sources/openapi-specs")
UA = ("Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) "
      "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15")

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    ctx = browser.new_context(user_agent=UA)
    page = ctx.new_page()
    # First request solves the Cloudflare challenge and sets cf_clearance.
    page.goto("https://docs.kalshi.com/", wait_until="networkidle")
    for name in ("openapi.yaml", "asyncapi.yaml", "perps_openapi.yaml"):
        page.goto(f"https://docs.kalshi.com/{name}", wait_until="networkidle")
        body = page.content()
        # Strip the <html><body><pre>…</pre></body></html> wrapper Chromium adds
        # around raw text responses:
        start = body.find("<pre")
        end = body.rfind("</pre>")
        if start != -1 and end != -1:
            body = body[body.find(">", start) + 1 : end]
        (DEST / name).write_text(body)
        print(f"saved {name} ({len(body)} bytes)")
    browser.close()
```

## What's in each spec (high-level shape)

The actual content is whatever Kalshi has published *today*; the shapes below
are the durable contract reflected in the community SDKs that consume these
specs (see `../sdk-snippets/`).

### `openapi.yaml` (event-contracts REST)

19 resource groups, ~104 operations. The resource families:

- `/exchange` — `status`, `schedule`, `announcements`, `endpoint_costs`.
- `/series` — list, get, by ticker.
- `/events` — list, get (with optional `with_nested_markets`).
- `/markets` — list (filterable: `status`, `series_ticker`, `event_ticker`, `tickers`), get, `orderbook`, `candlesticks`, `history`.
- `/markets/trades` — public trades feed.
- `/portfolio/balance` — wallet balance.
- `/portfolio/positions` — open and settled.
- `/portfolio/orders` — legacy single-market orders: list, create, get, cancel, decrease, amend.
- `/portfolio/events/orders` — **V2 event-scoped orders** (spec ≥ 3.18.0): `create_v2`, `get`, `amend_v2`, `decrease_v2`, `cancel_v2`, batched variants.
- `/portfolio/fills` — fills history.
- `/portfolio/settlements` — settlement history.
- `/portfolio/deposits`, `/portfolio/withdrawals` — funding history.
- `/portfolio/order_groups` — order-group lifecycle.
- `/communications` — admin announcements.
- `/multivariate` — multivariate (parlay-style) market endpoints.
- `/live-data` — `get-live-data`.
- `/auth/login`, `/auth/logout` — legacy auth (replaced by per-request RSA-PSS).
- `/sso` — single-sign-on shims.

Base URL embedded as a server entry:

- Production: `https://api.elections.kalshi.com/trade-api/v2`
- Demo: `https://demo-api.kalshi.co/trade-api/v2`

### `asyncapi.yaml` (WebSocket)

12 typed channels (per AsyncAPI's `channels` map) plus 2 escape-hatches
(`control_frames`, `root`). The 12:

| Channel | Streams |
| --- | --- |
| `ticker` | top-of-book ticker updates per market |
| `trade` | public trade feed |
| `orderbook_delta` | book deltas + snapshot |
| `fill` | your fills |
| `market_positions` | your positions per market |
| `user_orders` | your order lifecycle events |
| `order_group` | your order-group events |
| `market_lifecycle` | market open/close/settle |
| `multivariate` | multivariate market updates |
| `multivariate_lifecycle` | multivariate lifecycle |
| `communications` | exchange announcements |
| `cfbenchmarks_value` | CF Benchmarks index values |

WebSocket URL: `wss://api.elections.kalshi.com/trade-api/ws/v2` (prod) /
`wss://demo-api.kalshi.co/trade-api/ws/v2` (demo).

Auth is RSA-PSS signature on the upgrade request — same scheme as REST, with
the path being `/trade-api/ws/v2` and method `GET`.

### `perps_openapi.yaml` (perpetual-futures / margin REST)

34 operations across 8 resource groups: `exchange`, `markets`, `orders`,
`order_groups`, `portfolio`, `margin` (balance/risk/fees), `funding`,
`transfers`.

Base URL embedded:

- Production: `https://external-api.kalshi.com/trade-api/v2`
- Demo: `https://external-api.demo.kalshi.co/trade-api/v2`

(Note: the perps API uses a *different* set of API keys from the
event-contracts API, even though both are RSA-PSS-signed and same key format.
Issue separate keys in the Kalshi UI.)

## Using these specs

The specs are designed for code-generation. Common workflows:

```bash
# Generate a Python client with openapi-python-client
openapi-python-client generate --path openapi.yaml --meta poetry

# Generate a TypeScript client with openapi-typescript
openapi-typescript openapi.yaml -o kalshi-api-types.ts

# Generate a Go client
oapi-codegen -package kalshi openapi.yaml > kalshi.gen.go

# Generate a Rust client
openapi-generator generate -i openapi.yaml -g rust -o kalshi-rs
```

The official `kalshi_python_sync` / `kalshi_python_async` SDKs are
OpenAPI-generated; the community `kalshi-sdk` (TexasCoding) tracks both specs
with drift guards on every commit.
