# Errors, Rate Limits, and Retries

How Kalshi signals failures, when to retry, when not to, and the patterns for resilient API consumption.

## Error response shape

4xx/5xx errors return JSON:

```json
{
  "code":    "missing_parameters",
  "message": "Missing required parameter: ticker"
}
```

Some errors include a nested `details` object with field-level errors:

```json
{
  "code": "invalid_request",
  "message": "Validation failed",
  "details": {
    "yes_price": "must be between 1 and 99 cents"
  }
}
```

The exact wrapper varies slightly between endpoints — always parse defensively.

## HTTP status code summary

| Status | Meaning | What to do |
| --- | --- | --- |
| 200 | Success (GET, POST that doesn't create) | Use the response body. |
| 201 | Created (POST that created a resource) | Capture the returned ID. |
| 204 | No Content (DELETE success) | Done. |
| 400 | Bad Request — malformed JSON, wrong content-type | Fix payload; don't retry. |
| 401 | Unauthorized — RSA-PSS signature failed | Check signing; don't retry blindly. |
| 403 | Forbidden — auth OK but not permitted (e.g., perps key on event-contracts) | Fix the key; don't retry. |
| 404 | Not Found — wrong path / ID | Verify; don't retry. |
| 409 | Conflict — duplicate `client_order_id` etc. | Look up existing; don't retry. |
| 422 | Unprocessable Entity — semantically wrong | Read `code`/`message`; fix; don't retry. |
| 429 | Too Many Requests — rate-limited | Respect `Retry-After`; back off. |
| 500 | Internal Server Error | Retry with exponential backoff (idempotent only). |
| 502, 503, 504 | Bad Gateway / Service Unavailable / Gateway Timeout | Retry with exponential backoff. |

## Common error codes (body `code`)

| code | Meaning | Fix |
| --- | --- | --- |
| `missing_parameters` | A required field is absent | Add it. |
| `invalid_parameters` | A field has the wrong type or out-of-range value | Check spec. |
| `unauthorized` | Signature failed | See `references/authentication-rsa-pss.md`. |
| `forbidden` | Account doesn't have access to this endpoint | Check scope. |
| `insufficient_funds` | Wallet too low for the order | Top up. |
| `market_not_found` | Wrong ticker | Verify via `/markets`. |
| `market_closed` | Order on a closed/settled market | Check `status`. |
| `position_limit_exceeded` | Per-market cap reached | Reduce size. |
| `rate_limit_exceeded` | Too many requests | Back off. |
| `invalid_order_state` | Trying to cancel/amend already-terminal order | Check current status first. |
| `duplicate_client_order_id` | (rare — usually returns the existing order) | Generate fresh UUID. |
| `self_trade_prevented` | Order would cross your own resting order | Adjust price; use STP policy. |

## When to retry

| Condition | Retry? |
| --- | --- |
| Network error (connection refused, DNS, TLS handshake) | Yes — exponential backoff, up to ~5 attempts |
| Timeout (no response within client timeout) | Yes — but use idempotency (`client_order_id`) |
| 5xx response | Yes — exponential backoff |
| 429 response | Yes — wait `Retry-After` then continue |
| 4xx response (other than 429) | **No** — your request is wrong; fix it |

The official SDKs follow this policy. The community `kalshi-sdk` retries only **idempotent verbs** (`GET`, `HEAD`, `OPTIONS`). `POST` and `DELETE` are **never** retried automatically because of duplicate-order / cancel risk — you must use `client_order_id` and retry yourself if needed.

## Idempotency

The single most important thing for order create: **use `client_order_id`**.

```python
import uuid

def safe_create_order(...):
    cid = str(uuid.uuid4())
    for attempt in range(3):
        try:
            return client.orders.create_v2(client_order_id=cid, ...)
        except (httpx.NetworkError, httpx.TimeoutException):
            # Retry with same cid; server returns existing order if it exists.
            continue
        except KalshiServerError:
            # 5xx: backoff + retry
            time.sleep(2 ** attempt)
            continue
    raise OrderCreateFailed()
```

For cancels:

```python
try:
    client.orders.cancel_v2(order_id)
except KalshiNotFoundError:
    pass   # Already canceled
```

## Rate limits

Kalshi uses a **weighted rate limiter** — different endpoints cost different "weights". `GET /markets` might cost 1 weight unit; `POST /portfolio/orders` might cost 10. Your account has a per-second weight budget; exceeding it returns 429.

### Discover endpoint costs

```http
GET /trade-api/v2/account/endpoint_costs
```

Returns the current cost map. Useful to plan throughput:

```json
{
  "endpoint_costs": [
    { "path": "GET /markets", "cost": 1 },
    { "path": "POST /portfolio/orders", "cost": 10 },
    { "path": "DELETE /portfolio/orders/{order_id}", "cost": 5 }
  ]
}
```

### Practical throughput tips

- **Cache catalog data.** Series and event metadata rarely change.
- **Batch where possible.** Use `POST /portfolio/events/orders/batch_create` instead of N individual `POST /portfolio/events/orders`.
- **Prefer WebSocket for live data.** A single WS subscription to `ticker` is cheaper than polling `GET /markets/{ticker}` every second.
- **Filter aggressively.** `GET /markets?tickers=A,B,C` is one request; three `GET /markets/A`, `/B`, `/C` are three.
- **Pipeline, don't burst.** 100 orders/sec spread evenly is fine; 100 orders in 100ms is rate-limited.

### Honoring `Retry-After`

When you get 429:

```
HTTP/1.1 429 Too Many Requests
Retry-After: 5
```

Wait 5 seconds. The community SDK caps this internally so a maliciously-large `Retry-After` can't stall your code.

## Timeouts

Suggested per endpoint type:

| Operation | Recommended client timeout |
| --- | --- |
| `GET /exchange/status` | 5s |
| Catalog reads (`GET /markets`, `/events`, `/series`) | 10s |
| `GET /markets/{ticker}/orderbook` | 10s |
| `GET /portfolio/balance`, `/positions` | 10s |
| `POST /portfolio/orders` (V2) | 15s |
| `POST /portfolio/events/orders/batch_create` | 30s |
| `DELETE /portfolio/orders/{id}` | 10s |
| `GET /portfolio/fills` | 15s |

Order creates can take longer than reads because of routing, risk checks, and book matching. Be patient on POST.

## Transient vs. permanent failures

| Symptom | Class |
| --- | --- |
| `ECONNRESET`, `ETIMEDOUT`, `ENOTFOUND` | Transient — retry |
| 502, 503, 504 | Transient — retry |
| 500 | Usually transient — retry, but inspect |
| 429 | Transient — retry with `Retry-After` |
| 401 | Permanent — fix signing |
| 403 | Permanent — fix scope/key |
| 404 | Permanent — wrong path/ID |
| 409 | Permanent — duplicate; look up existing |
| 422 | Permanent — fix payload |

## Logging recommendation

Log every API call with:

- Method + path.
- Status code.
- Latency (request started → response received).
- `KALSHI-ACCESS-TIMESTAMP` (you generated it — useful for debugging skew).
- `code` and `message` from the response body (on error).
- `client_order_id` (for order endpoints — primary correlation key).
- Retry attempt number.

This makes debugging "the order didn't show up" investigations tractable.

## WebSocket-specific errors

WebSocket connections don't return HTTP status codes after the upgrade. Instead:

| WS close code | Meaning | Reaction |
| --- | --- | --- |
| 1000 | Normal closure | Reconnect if needed. |
| 1001 | Going away | Server maintenance — reconnect. |
| 1006 | Abnormal closure | Network blip — exponential-backoff reconnect. |
| 1008 | Policy violation (rate limit / abuse) | Slow down. |
| 1011 | Server error | Reconnect with backoff. |

After a reconnect, re-snapshot orderbooks and re-fetch missed `user_orders` / `fill` via REST.

## Common failure patterns

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Burst of 429s right after deploy | Backfill / catch-up logic hammering catalog endpoints | Add jitter; cache catalog. |
| 401 only on certain endpoints | Wrong path being signed (e.g., included query string) | See `references/authentication-rsa-pss.md`. |
| Orders silently dropped after a 5xx | Didn't retry; or retried with new `client_order_id` | Always retry with the same `client_order_id`. |
| WebSocket reconnect storm | No backoff on reconnect | Exponential backoff + jitter, cap at 30s. |
| Position drift over weeks | Missed fill notifications | Reconcile via `GET /portfolio/fills` periodically. |
| `Retry-After` huge value | Account-level throttle | Investigate; may need to talk to Kalshi support. |
| Latency spikes during market open | Burst of orders + reduced effective throughput | Pre-prepare connections; warm up; spread requests. |

## Recommended retry config

For the community `kalshi-sdk` (which lets you tune):

```python
from kalshi import KalshiClient, KalshiConfig

config = KalshiConfig(
    timeout=15.0,
    max_retries=5,
    retry_base_delay=0.5,
    retry_max_delay=15.0,
    http2=True,                 # opt-in HTTP/2 for connection multiplexing
)
client = KalshiClient(key_id="...", private_key_path="...", config=config)
```

## Original sources

- `references/sources/openapi-specs/openapi.yaml` — exact response shapes.
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — error hierarchy and retry policy reference.
- Official (gated): https://docs.kalshi.com/api-reference/ — per-endpoint error responses.
