# Getting Started

The first encounter with Kalshi. Sign up, generate keys, run a few read-only requests, run one authenticated request. Once this is working you can move on to the deeper references.

## Step 1: Create accounts

Two accounts are useful:

- **Production**: https://kalshi.com — real money, KYC required, takes a day or two to clear.
- **Demo (sandbox)**: https://demo.kalshi.co — separate account, separate signup, no real money. Use this for development.

You can develop on demo without finishing prod KYC. The demo account's user ID is independent — don't expect production state to mirror.

## Step 2: Generate an API key pair

From the Kalshi UI (production or demo):

1. Sign in.
2. Account & Security → API Keys (some versions of the UI label this "API" or "Developer").
3. Click **Create Key**.
4. Save:
   - The **Key ID** (visible string) — this is `KALSHI-ACCESS-KEY` in headers.
   - The **Private Key** (downloaded as a `.key` or `.pem` file). **Saved once; can't be retrieved later.**
5. Save the private key somewhere secure (`~/.kalshi/private_key.pem`, a secrets manager, etc.).

**For the perpetual-futures (perps) product**, generate a **separate key pair** in the perps section of the UI. Event-contracts keys are not valid for perps and vice versa.

## Step 3: Understand the base URLs

```
PRODUCTION
==========
Event-contracts REST   https://api.elections.kalshi.com/trade-api/v2
Event-contracts WS     wss://api.elections.kalshi.com/trade-api/ws/v2
Perps REST             https://external-api.kalshi.com/trade-api/v2
Perps WS               wss://external-api.kalshi.com/trade-api/ws/v2

DEMO (sandbox)
==============
Event-contracts REST   https://demo-api.kalshi.co/trade-api/v2
Event-contracts WS     wss://demo-api.kalshi.co/trade-api/ws/v2
Perps REST             https://external-api.demo.kalshi.co/trade-api/v2
Perps WS               wss://external-api.demo.kalshi.co/trade-api/ws/v2
```

Notes:

- Production event-contracts is at `api.elections.kalshi.com` (the "elections" historical-name is retained for everything, not just elections markets).
- Demo uses the `.co` TLD; production uses `.com`. Watch this — typos here silently hit the wrong environment.
- The **WebSocket path** is `/trade-api/ws/v2`, not `/trade-api/v2/ws`.

## Step 4: First request — public, no auth

The simplest sanity check is hitting `/exchange/status` (no auth required):

```bash
curl https://demo-api.kalshi.co/trade-api/v2/exchange/status
```

Expected:

```json
{
  "exchange_active": true,
  "trading_active": true
}
```

If you get JSON, your network can reach Kalshi and the demo is up. If you get a connection error, you're blocked outbound or DNS is misconfigured.

## Step 5: Second request — list markets (public)

```bash
curl 'https://demo-api.kalshi.co/trade-api/v2/markets?status=open&limit=5'
```

Returns up to 5 open markets:

```json
{
  "markets": [
    {
      "ticker": "...",
      "event_ticker": "...",
      "series_ticker": "...",
      "status": "active",
      "yes_bid": 52,
      "yes_ask": 54,
      "no_bid": 46,
      "no_ask": 48,
      "open_time": "...",
      "close_time": "...",
      ...
    }
  ],
  "cursor": "..."
}
```

Pagination is via `cursor`. Pass `cursor=<value>` on the next request to get the next page.

## Step 6: Generate an RSA-PSS signature

The next request will be authenticated. The signature recipe:

```
signing_input = timestamp_ms + http_method + path
signature     = base64(RSA_PSS(SHA256, signing_input, private_key))
```

Where `path` is **just the path part** (`/trade-api/v2/portfolio/balance`), not the full URL, and **does not include query string or body**.

Headers:

```
KALSHI-ACCESS-KEY:       <your-key-id>
KALSHI-ACCESS-TIMESTAMP: <unix-epoch-milliseconds-as-string>
KALSHI-ACCESS-SIGNATURE: <base64 signature>
Accept:                  application/json
```

Quick Python recipe:

```python
import base64, time
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding

with open("private_key.pem", "rb") as f:
    private_key = serialization.load_pem_private_key(f.read(), password=None)

method = "GET"
path = "/trade-api/v2/portfolio/balance"
timestamp = str(int(time.time() * 1000))

message = (timestamp + method + path).encode("utf-8")

signature = private_key.sign(
    message,
    padding.PSS(mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.DIGEST_LENGTH),
    hashes.SHA256(),
)
sig_b64 = base64.b64encode(signature).decode("ascii")
```

Full details + Node/Go/Rust recipes in `references/authentication-rsa-pss.md`.

## Step 7: First authenticated request — balance

```bash
TS=$(($(date +%s) * 1000))
METHOD="GET"
PATH_="/trade-api/v2/portfolio/balance"
SIG=$(python3 sign.py "$TS" "$METHOD" "$PATH_")  # script from §6

curl -H "KALSHI-ACCESS-KEY: $KALSHI_KEY_ID" \
     -H "KALSHI-ACCESS-TIMESTAMP: $TS" \
     -H "KALSHI-ACCESS-SIGNATURE: $SIG" \
     "https://demo-api.kalshi.co/trade-api/v2$PATH_"
```

Expected:

```json
{
  "balance": 10000,
  "payout": 0
}
```

(`balance` is in cents for the legacy/balance endpoint; check current spec.)

If you get `401`, see `references/authentication-rsa-pss.md` — almost always one of:

- Clock skew (>5 sec drift between your `timestamp` and server time).
- Signed the wrong payload (included query string, or body, or full URL).
- Wrong padding (`RSA_PKCS1` instead of `RSA_PSS`).
- Key from one product (event-contracts) sent to the other host (perps).
- Demo key used against production URL or vice versa.

## Step 8: First WebSocket connection

The WS URL takes the same RSA-PSS signature, but signed against the path `/trade-api/ws/v2` with method `GET`. Most SDKs handle this transparently. Manual recipe:

```python
import asyncio
import websockets
import base64, time, json
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding

KEY_ID = "..."
WS_URL = "wss://demo-api.kalshi.co/trade-api/ws/v2"

with open("private_key.pem", "rb") as f:
    private_key = serialization.load_pem_private_key(f.read(), password=None)

method = "GET"
path = "/trade-api/ws/v2"
ts = str(int(time.time() * 1000))
sig = base64.b64encode(private_key.sign(
    (ts + method + path).encode(),
    padding.PSS(mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.DIGEST_LENGTH),
    hashes.SHA256(),
)).decode()

headers = {
    "KALSHI-ACCESS-KEY": KEY_ID,
    "KALSHI-ACCESS-TIMESTAMP": ts,
    "KALSHI-ACCESS-SIGNATURE": sig,
}

async def main():
    async with websockets.connect(WS_URL, extra_headers=headers) as ws:
        await ws.send(json.dumps({
            "id": 1,
            "cmd": "subscribe",
            "params": {"channels": ["ticker"], "market_tickers": ["KXNBAGAME-26MAY25NYKCLE-NYK"]}
        }))
        async for msg in ws:
            print(msg)

asyncio.run(main())
```

## What you now have

- A demo account.
- A key pair on file (key ID + private key PEM).
- Confirmed access to public + private endpoints.
- A working RSA-PSS signing function in your language of choice.
- A first WebSocket subscription.

Next steps:

- `references/authentication-rsa-pss.md` — get auth right; everything downstream depends on this.
- `references/markets-events-series.md` — understand the catalog you'll be browsing.
- `references/rest-api-overview.md` — the full endpoint map.
- `references/orders-and-trading.md` — when you're ready to place real orders.
- `references/websocket-api.md` — when you need live data at scale.
- `references/sdks-and-tools.md` — which SDK to install (don't roll your own unless you have a reason).

## Common first-request failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| `401 Unauthorized` on every authenticated request | Signing wrong payload, clock skew, wrong host | See `references/authentication-rsa-pss.md`. |
| `401 Unauthorized` on demo only | Demo key used on prod URL or vice versa | Match key to host. |
| `403 Forbidden` on private endpoints | Key not approved for that endpoint scope, or perps key on event-contracts host | Use the right key for the right product. |
| `404 Not Found` | Hitting `api.kalshi.com/v1/...` (legacy) instead of `api.elections.kalshi.com/trade-api/v2/...` | Update base URL. |
| `ENOTFOUND demo-api.kalshi.co` | DNS / outbound HTTPS blocked | Allow outbound 443 to `*.kalshi.com` and `*.kalshi.co`. |
| `SSL: CERTIFICATE_VERIFY_FAILED` | Old root certificates | Update `certifi` / `ca-certificates`. |
| `400 Bad Request` with no body | Forgot `Content-Type: application/json` on POST | Add the header. |
| Public endpoint works, private 401 | Signature header missing one of the three required headers | All three (`KEY`, `TIMESTAMP`, `SIGNATURE`) are mandatory. |

## Storing credentials

- Never commit the private key PEM to git. Use `.env` + `.gitignore`, a secrets manager (AWS Secrets Manager, Doppler, 1Password), or platform env vars.
- The `KALSHI_KEY_ID` is **not** sensitive on its own (it's an identifier, not a credential), but treat it as semi-sensitive — it lets an attacker know which account they're trying to compromise.
- Rotate by revoking the old key in the UI and generating a new one. Sessions and active orders are unaffected (keys are stateless).
- Use separate keys per environment (dev / staging / prod). Don't share keys across CI runs.

## Original sources

- `references/sources/openapi-specs/README.md` — describes how to obtain the canonical OpenAPI / AsyncAPI specs.
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — the most comprehensive community SDK's getting-started.
- Official getting-started (gated): https://docs.kalshi.com/getting_started/quick_start_authenticated_requests
- Official market-data quickstart (gated): https://docs.kalshi.com/getting_started/quick_start_market_data
