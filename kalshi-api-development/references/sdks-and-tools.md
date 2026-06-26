# SDKs and Tools

There's no single canonical Kalshi SDK. There are at least four well-known Python packages plus a TypeScript one, plus the option of generating your own client from the OpenAPI / AsyncAPI specs. This reference compares them and recommends which to use when.

## At-a-glance comparison

| SDK | License | Maintainer | Coverage | Sync/Async | WebSocket | FIX | Perps | Status (mid-2026) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `kalshi_python_sync` | Apache-2.0 | Kalshi (official) | Full REST, OpenAPI-generated | Sync | No | No | Partial | Active, weekly releases |
| `kalshi_python_async` | Apache-2.0 | Kalshi (official) | Full REST, OpenAPI-generated | Async | No | No | Partial | Active, weekly releases |
| `kalshi-sdk` (TexasCoding) | MIT | Community | Full REST + WS + FIX + Perps + Klear | Both | All 12 channels | FIXT.1.1 + FIX50SP2 | Yes | Active |
| `pykalshi` (arshka) | MIT | Community | REST + WS focus | Both | Streaming + pandas | No | No | Active |
| `kalshi-client` (vaguenebula) | MIT | Community | Light REST wrapper | Sync | No | No | No | Active |
| `kalshi-python` (lowgrind) | Apache-2.0 | Kalshi (legacy) | Old v1/v2 | Sync | No | No | No | **DEPRECATED** — email/password auth gone |

## Picking a SDK

| Need | Pick |
| --- | --- |
| Quick script, low complexity | `kalshi-client` (vaguenebula) — smallest learning curve |
| Production trading system | `kalshi-sdk` (TexasCoding) — full coverage, drift guards, types |
| OpenAPI-generated, spec-tracking | `kalshi_python_sync` or `kalshi_python_async` (official) |
| Streaming + pandas analysis | `pykalshi` (arshka) — designed for it |
| FIX or perps or Klear | `kalshi-sdk` (TexasCoding) — only one that covers all three |
| TypeScript | Official `@kalshi/api` or generate from OpenAPI yourself |
| Other languages | Generate from `openapi.yaml` with openapi-generator |

## The official SDKs

The current canonical Python packages are **`kalshi_python_sync`** and **`kalshi_python_async`**. Both are:

- Auto-generated from `openapi.yaml` weekly (typically Tuesday–Wednesday).
- Published on PyPI.
- Apache-2.0 licensed.
- Maintained by Kalshi.

The older combined `kalshi-python` package (lowgrind/kalshi-python on GitHub) is deprecated — it predates RSA-PSS auth and shows email/password login.

Install:

```bash
pip install kalshi-python-sync
# or
pip install kalshi-python-async
```

These SDKs cover **REST only**. For WebSocket or FIX, you need a different package (`kalshi-sdk` is the easiest one).

### Official SDK quickstart

```python
import kalshi_python_sync as kalshi

config = kalshi.Configuration(host="https://demo-api.kalshi.co/trade-api/v2")
config.api_key = ...
config.private_key_pem = ...

api = kalshi.MarketApi(kalshi.ApiClient(config))
markets = api.get_markets(status="open", limit=10)
```

(Exact constructor names vary by version; check the package README.)

## `kalshi-sdk` (TexasCoding) — the comprehensive community choice

The community SDK with the broadest coverage:

- **Full REST coverage** of the event-contracts API (104 ops / 19 resources).
- **All 12 WebSocket channels** typed.
- **FIX engine** (FIXT.1.1 / FIX50SP2) for both event-contracts and perps.
- **Perps**: `PerpsClient` / `AsyncPerpsClient` / `PerpsWebSocket`.
- **Klear**: `KlearClient` for SCMs (Bearer-token auth).
- **V2 event-market orders** as first-class.
- **Pydantic v2** typed end-to-end, `mypy --strict` clean.
- **Drift guards**: contract tests fail on every commit if the SDK drifts from the live spec.
- **Sync + async** sharing one transport.

Install:

```bash
pip install kalshi-sdk
```

Requires Python 3.12+.

Quickstart:

```python
from kalshi import KalshiClient

with KalshiClient.from_env(demo=True) as client:
    page = client.markets.list(status="open", limit=10)
    for market in page:
        print(market.ticker, market.yes_bid, market.yes_ask)
```

The README captured at `references/sources/sdk-snippets/kalshi-python-sdk/README.md` has the most comprehensive examples.

## `pykalshi` (arshka) — streaming + pandas

A more opinionated streaming-focused SDK:

- WebSocket streaming with managed reconnects.
- Local orderbook state from deltas.
- pandas DataFrame conversions.
- Pydantic models.
- Rich Jupyter notebook output.

Less comprehensive REST coverage than `kalshi-sdk` but cleaner for analysis workflows.

Install:

```bash
pip install pykalshi
```

## `kalshi-client` (vaguenebula) — minimal

A lightweight, single-file-ish client. Good for quick scripts and learning the API:

```python
from kalshi_client.client import KalshiClient
from kalshi_client.utils import load_private_key_from_file

client = KalshiClient(
    key_id="your-key-id",
    private_key=load_private_key_from_file("private_key.txt"),
)
print(client.get_balance())
```

Less type safety, fewer features, simpler. Good for one-off scripts.

## Roll-your-own from OpenAPI

If you want maximum control or are working in a non-Python language:

```bash
# Get the specs
curl -O https://docs.kalshi.com/openapi.yaml
curl -O https://docs.kalshi.com/asyncapi.yaml
curl -O https://docs.kalshi.com/perps_openapi.yaml

# Python
openapi-python-client generate --path openapi.yaml --meta poetry

# TypeScript types
openapi-typescript openapi.yaml -o kalshi-api.ts

# Go
oapi-codegen -package kalshi openapi.yaml > kalshi.gen.go

# Rust
openapi-generator generate -i openapi.yaml -g rust -o kalshi-rs
```

You'll still need to implement RSA-PSS request signing yourself (the generated client only handles the request shape) — see `references/authentication-rsa-pss.md`.

## Other-language ecosystems

| Language | Notable libraries |
| --- | --- |
| TypeScript | Official `@kalshi/api` (npm); generate from OpenAPI |
| Rust | `arvchahal/kalshi-rs` (community, GitHub) |
| Go | Generate from OpenAPI (no popular wrapper yet) |
| Java | Generate from OpenAPI |
| C#/.NET | Generate from OpenAPI |

## Spec-tracking discipline

Whichever SDK you choose, treat the OpenAPI / AsyncAPI specs at `docs.kalshi.com` as the source of truth. SDKs lag:

- The official auto-generated SDKs lag by up to a week.
- Community SDKs (TexasCoding's especially) have drift-guard tests but can still lag by hours.
- All of them can be outpaced by an emergency spec update from Kalshi.

For market-sensitive integrations, regenerate from the live spec weekly or monthly. The `kalshi-sdk` contract tests catch most drifts.

## Tooling

- **Postman collection**: Not officially distributed. Some community ones exist on Postman Public Workspaces.
- **OpenAPI viewers**: ReDoc, Swagger UI — point at the YAML.
- **WebSocket testers**: `wscat`, `websocat`, browser DevTools. For Kalshi auth, you need a signed header — easiest via Python with `websockets` + the recipe in `references/getting-started.md`.
- **FIX simulators**: `quickfix-python`, `simplefix` — useful for local testing without hitting Kalshi.

## Comparison cheatsheet

```
            Coverage    Sync    Async   WS      FIX     Perps   Klear   License
official    ★★★★★      ✓      ✓      ✗      ✗      ★★    ✗      Apache-2.0
TexasCoding ★★★★★      ✓      ✓      ✓      ✓      ✓      ✓      MIT
pykalshi    ★★★         ✗      ✓      ✓      ✗      ✗      ✗      MIT
vaguenebula ★★          ✓      ✗      ✗      ✗      ✗      ✗      MIT
lowgrind    deprecated
```

## Common SDK selection mistakes

| Mistake | Fix |
| --- | --- |
| Installing `kalshi-python` (deprecated) | Install `kalshi-python-sync` or `kalshi-python-async`. |
| Trying to do WebSocket with the official SDK | Use `kalshi-sdk` (TexasCoding) or `pykalshi`. |
| Trying to use the official SDK for perps | Use `kalshi-sdk`'s `PerpsClient`. |
| Using `kalshi-client` (minimal) for production | Use `kalshi-sdk` for production; `kalshi-client` for scripts. |
| Mixing sync `kalshi-sdk` with `asyncio` | Use `AsyncKalshiClient` instead, or use sync only. |
| Importing legacy v1 / v2 paths from old SDK code | Migrate to v2 + V2 orders. |

## Original sources

- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` (TexasCoding)
- `references/sources/sdk-snippets/pykalshi/README.md` (arshka)
- `references/sources/sdk-snippets/kalshi-client/README.md` (vaguenebula)
- `references/sources/sdk-snippets/kalshi-python-legacy/README.md` (lowgrind, legacy)
- Official (gated): https://docs.kalshi.com/sdks/overview
- PyPI: https://pypi.org/project/kalshi-python-sync/, /kalshi-python-async/, /kalshi-sdk/, /pykalshi/, /kalshi-client/
