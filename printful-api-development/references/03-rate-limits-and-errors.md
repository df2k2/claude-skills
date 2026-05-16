# 03 — Rate limits and errors

## Rate limiting

Different versions use different algorithms.

### v1 — fixed-window with lockout

- **120 requests per 60-second sliding window**, per store.
- On the 121st request: HTTP `429 Too Many Requests` and a **60-second lockout** — every subsequent call returns `429` regardless of the rolling window until the lockout expires.
- Response includes `X-Ratelimit-Limit`, `X-Ratelimit-Remaining`, `X-Ratelimit-Reset` (Unix epoch when the window resets), and `Retry-After`.

```http
HTTP/1.1 429 Too Many Requests
X-Ratelimit-Limit: 120
X-Ratelimit-Remaining: 0
X-Ratelimit-Reset: 1716000000
Retry-After: 47
Content-Type: application/json

{
  "code": 429,
  "result": "Too many requests"
}
```

**Strategy**: target ≤2 RPS sustained on v1. A burst of 100 calls is fine; a sustained 3 RPS will trip the lockout repeatedly.

### v2 — leaky bucket (token bucket)

v2 uses a **leaky bucket** (Printful's own naming; functionally a token bucket since there's no queuing):

- **Bucket capacity**: 120 tokens (default).
- **Refill rate**: 2 tokens/second (the bucket refills to 120 in 60 seconds).
- Every successful request consumes 1 token.
- When the bucket hits 0: `429 Too Many Requests`, with `Retry-After` ≈ seconds until 1 token is available.

Headers:

```http
HTTP/1.1 200 OK
X-Ratelimit-Policy: 120;w=60
X-Ratelimit-Limit: 120
X-Ratelimit-Remaining: 119
X-Ratelimit-Reset: 0.5
```

- `X-Ratelimit-Policy: 120;w=60` — "120 tokens added per 60-second window".
- `X-Ratelimit-Remaining: 119` — tokens left in the bucket.
- `X-Ratelimit-Reset: 0.5` — **seconds** until the next token is added. After your first request it's typically 0.5 (matching the 2 tokens/sec refill).

The headers are modeled on the [IETF RateLimit Header Fields for HTTP](https://www.ietf.org/archive/id/draft-ietf-httpapi-ratelimit-headers-07.html) draft.

### Special: shipping rates throttling

On `POST /v2/shipping-rates` (and v1 `POST /shipping/rates`), **if the summary item quantity exceeds 100**, the limit drops to **5 requests per 60 seconds**. Hitting that limit also triggers a 60-second lockout. Quote in smaller batches or aggregate identical line items.

### Per-endpoint variation

The OpenAPI tags state:
- **Catalog v2**: 120 req/60s, 60s lockout on overflow.
- **Shipping Rates v2**: 120 req/60s default, 5 req/60s when `quantity_sum > 100`.

Other endpoints fall back to the default leaky bucket. Printful has stated they may tune individual endpoint limits over time — check the `X-Ratelimit-*` headers at runtime instead of hard-coding the cap.

### Backoff strategy

For client libraries:

```python
import time, httpx

def call_printful(client, method, url, **kwargs):
    while True:
        resp = client.request(method, url, **kwargs)
        if resp.status_code != 429:
            return resp
        retry_after = float(resp.headers.get("Retry-After", "1"))
        # v2 also exposes a more precise refill estimate
        ratelimit_reset = float(resp.headers.get("X-Ratelimit-Reset", retry_after))
        time.sleep(max(retry_after, ratelimit_reset))
```

For high-throughput jobs (bulk product sync, mass mockup generation): add a token-bucket on your side, sized below 2 RPS, with the actual bucket re-tuned from `X-Ratelimit-Remaining` after each response.

## Errors

### v2 — RFC 9457 Problem Details

Most v2 endpoints return errors as `application/problem+json`:

```http
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/problem+json
```

```json
{
  "type": "https://developers.printful.com/docs/v2-beta/#errors/validation-error",
  "status": 422,
  "title": "Validation Error",
  "detail": "The request data is not valid",
  "instance": "01HZ8...",
  "errors": [
    {
      "source": { "pointer": "/recipient/country_code" },
      "detail": "Invalid country code."
    },
    {
      "source": { "parameter": "limit" },
      "detail": "The limit must be between 1 and 100."
    }
  ]
}
```

Fields:

| Field | Type | Meaning |
|---|---|---|
| `type` | URI | Stable URL pointing at docs for this error class. Use it as a programmatic key. |
| `status` | int | HTTP status echo. |
| `title` | string | Short human summary. |
| `detail` | string | Explanation of this specific occurrence. |
| `instance` | string | Unique ID for this exact failure. **Include it in support tickets.** |
| `errors[]` | array | Optional. Field-level details for validation errors. |
| `errors[].source.pointer` | JSON Pointer | Path into the request body that failed (e.g. `/recipient/zip`). |
| `errors[].source.parameter` | string | Query/header parameter name when the failure is on a param. |
| `errors[].detail` | string | What's wrong with that field. |

The `type` URLs Printful uses (incomplete list — there are more):

- `…/#errors/unauthorized`
- `…/#errors/forbidden`
- `…/#errors/not-found`
- `…/#errors/validation-error`
- `…/#errors/conflict`
- `…/#errors/unprocessable-entity`
- `…/#errors/rate-limit-exceeded`
- `…/#errors/internal-server-error`
- `…/#errors/service-unavailable`

### v2 — endpoints still using legacy errors

Per the OpenAPI spec, these endpoints have not yet migrated to RFC 9457 and still return v1-style errors despite being on the `/v2/` prefix:

- **Catalog**: every `GET /v2/catalog-*` (products, variants, categories, sizes, prices, images, mockup-templates).
- **Orders**: `getOrders`, `createOrder`, `updateOrder`, `getOrder`, `confirmOrder`, `getItemById`, `updateItem`, `deleteItemById`, `getShipments`, `getInvoice`.
- **Order estimation tasks**: both endpoints.
- **Shipping rates**: `calculateShippingRates`.
- **Files**: `addFile`, `getFile`.
- **Mockup generator**: both endpoints.
- **Stores**: `getStores`, `getStoreById`, `getStoreStatisticsById`.
- **Warehouse products**: both endpoints.
- **OAuth scopes**: `getOAuthScopes`.

Always branch on `Content-Type`, not on whether the path starts with `/v2`.

### v1 — legacy format

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json
```

```json
{
  "code": 400,
  "result": "Missing required field 'recipient.address1'",
  "error": {
    "reason": "ValidationError",
    "message": "Missing required field 'recipient.address1'"
  }
}
```

The `code` echoes the HTTP status. `result` is a human-readable message. `error.reason` is a short tag — values include `ValidationError`, `Unauthorized`, `NotFound`, `Conflict`, `RateLimitError`, `InternalError`.

### Common HTTP status codes (across v1 and v2)

| Code | Meaning |
|---|---|
| `200` | OK |
| `201` | Created (most POSTs return 200 with the created entity; some return 201) |
| `202` | Accepted (async task created; check task status separately) |
| `204` | No content (DELETEs typically return 204 or 200 with `result: true`) |
| `400` | Bad request — malformed JSON or schema mismatch |
| `401` | Unauthorized — missing/invalid token |
| `403` | Forbidden — token lacks scope, or wrong `X-PF-Store-Id` |
| `404` | Not found |
| `409` | Conflict — typically when trying to confirm an already-confirmed order, or modify a non-draft order |
| `410` | Gone — the v1 `GET /files` list endpoint returns this; use `/v2/files` |
| `413` | Payload too large — usually a file upload over size limits |
| `422` | Unprocessable entity — validation passed schema, failed business rules |
| `429` | Rate limited (see above) |
| `500` | Internal — retry with backoff; report `instance` ID if v2 |
| `502 / 503` | Upstream/maintenance — retry with backoff |

### Retry rules

| Status | Retry? | How |
|---|---|---|
| `400 / 401 / 403 / 404 / 409 / 422` | No | Fix the request first. |
| `410` | No | The endpoint is gone — switch to v2. |
| `429` | Yes | Honour `Retry-After` or `X-Ratelimit-Reset`. |
| `500 / 502 / 503 / 504` | Yes | Exponential backoff (e.g. 1s, 2s, 4s, 8s, 16s) with jitter. Cap at ~5 retries. |

For idempotency, Printful does **not** support an `Idempotency-Key` header at this time. The order endpoints achieve a similar effect via `external_id` — passing the same `external_id` on `POST /v2/orders` will return a `409 Conflict` if the order already exists (the v2 OpenAPI lists this; v1 returns a similar but `400` error). Treat the conflict as a signal that the previous request succeeded, then `GET /v2/orders?external_id={…}` to recover the existing order.

### Logging recommendations

For every non-2xx response:

1. Capture the **request method + URL** (without secrets).
2. Capture the **response `Content-Type`** and either the full JSON body (short) or `instance` ID + `type` + first 500 bytes of `detail`.
3. Capture **`X-Ratelimit-*`** headers (helps diagnose throttling).
4. Capture the v2 `instance` ID — Printful's support team uses it to look up the exact request.

## Original sources

- Rate limiting prose: `info.description` and `tags[].description` for `Rate Limiting` in [`sources/printful-v2-openapi.json`](sources/printful-v2-openapi.json).
- Error model: see the `ProblemDetails`, `Error`, and `ServerErrorDetails` schemas in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
