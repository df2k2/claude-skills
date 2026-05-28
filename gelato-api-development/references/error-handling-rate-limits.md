# Error Handling, Rate Limits, and Retries

How Gelato signals errors, when to retry, when not to, and the patterns for resilient API consumption.

## Error response shape

All HTTP 4xx and 5xx errors return a JSON body:

```json
{
  "code":    "INVALID_REQUEST",
  "message": "items[0].productUid is not a valid product UID"
}
```

(Exact field names vary slightly across services; some endpoints return `error: { code, message }` instead of top-level. Inspect what you get.)

## HTTP status code summary

| Status | Meaning | What to do |
| --- | --- | --- |
| 200 | Success (GET, POST that doesn't create) | Use the response body. |
| 201 | Created (POST that created a resource) | Use the response body; capture the returned ID. |
| 202 | Accepted (async operation queued) | Poll for completion if needed. |
| 204 | No Content (DELETE success) | Done. |
| 400 | Bad Request — malformed JSON, wrong content-type | Fix the request; don't retry. |
| 401 | Unauthorized — missing/invalid `X-API-KEY` | Check the key; don't retry. |
| 403 | Forbidden — auth OK but action not allowed (account tier, endpoint scope) | Don't retry blindly. |
| 404 | Not Found — wrong path or wrong ID | Verify URL / resource ID. |
| 409 | Conflict — duplicate `orderReferenceId`, etc. | Look up the existing resource; don't retry. |
| 422 | Unprocessable Entity — payload valid JSON but semantically wrong | Read `message`; fix payload. |
| 429 | Too Many Requests — rate-limited | Respect `Retry-After`; back off. |
| 5xx | Gelato server error | Retry with exponential backoff. |

## When to retry

| Condition | Retry? |
| --- | --- |
| Network error (connection refused, DNS failure, TLS handshake) | Yes — exponential backoff, up to ~5 attempts. |
| Timeout (no response within your client's timeout) | Yes — but be careful: the request may have succeeded server-side. Use idempotency. |
| 5xx response | Yes — exponential backoff. |
| 429 response | Yes — wait for `Retry-After` seconds, then continue. |
| 4xx response (other than 429) | **NO** — your request is wrong; retrying won't change anything. Fix the payload. |

## Idempotency for retries

Gelato uses `orderReferenceId` as a soft idempotency hint. When you retry `POST /v4/orders` after a timeout:

- **Use the same `orderReferenceId`** as the original attempt.
- If the original actually succeeded, Gelato returns the existing order (you get a 200/201 with the same `id` as before).
- If the original failed (e.g., never reached Gelato), the retry creates the order.

**Never generate a new `orderReferenceId` for a retry** — that creates a duplicate.

### Pattern

```typescript
async function createOrderWithRetry(orderPayload, maxAttempts = 3) {
  // orderReferenceId is fixed for the lifetime of the request
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      const res = await fetch('https://order.gelatoapis.com/v4/orders', {
        method: 'POST',
        headers: { 'X-API-KEY': API_KEY, 'Content-Type': 'application/json' },
        body: JSON.stringify(orderPayload),
        signal: AbortSignal.timeout(30_000),
      });

      if (res.ok) return await res.json();

      // 4xx (other than 429): don't retry
      if (res.status >= 400 && res.status < 500 && res.status !== 429) {
        throw new Error(`Gelato ${res.status}: ${await res.text()}`);
      }

      // 429: respect Retry-After
      if (res.status === 429) {
        const retryAfter = Number(res.headers.get('Retry-After')) || 30;
        await new Promise(r => setTimeout(r, retryAfter * 1000));
        continue;
      }

      // 5xx: exponential backoff
      await new Promise(r => setTimeout(r, 2 ** attempt * 1000));

    } catch (err) {
      // Network errors / timeouts: exponential backoff
      if (attempt === maxAttempts) throw err;
      await new Promise(r => setTimeout(r, 2 ** attempt * 1000));
    }
  }
  throw new Error('Max retries exceeded');
}
```

## Rate limits

Gelato doesn't publicly document exact rate limits, but in practice:

- **Light usage** (a few orders per minute) is unconstrained.
- **Batch operations** (10+ orders/sec, large catalog scans) can hit 429.
- The `Retry-After` header on 429 responses tells you when to retry.
- Spread bulk operations over time rather than bursting.

### Patterns that avoid limits

- **Cache catalog data.** Catalog endpoints rarely change; cache `/v3/catalogs` and per-catalog attributes for hours/days.
- **Bulk via search.** Use `POST /v4/orders:search` with a `limit` to fetch many orders in one call, rather than many `GET /v4/orders/{id}`.
- **Backoff on 429.** Don't bang the API the second after a rate-limit response.
- **Pipeline orders.** If creating 100 orders, do 5-10 in parallel, not all 100.

## Specific error patterns

### `INVALID_REQUEST` on `productUid`

```json
{ "code": "INVALID_REQUEST", "message": "Invalid productUid: xxxxx" }
```

- The UID format is wrong (you constructed by hand).
- The UID refers to a retired product.
- The UID is from a different catalog than expected.

**Fix**: re-query the catalog with `POST /v3/catalogs/{catalogUid}/products:search` using attribute filters, and copy the returned UID verbatim.

### `INVALID_REQUEST` on file URL

```json
{ "code": "INVALID_REQUEST", "message": "Cannot fetch file https://..." }
```

- URL behind auth.
- Presigned URL expired before fetch.
- IP-blocked.
- Returns HTML instead of file bytes (Dropbox / Drive viewer link).

**Fix**: ensure URL is publicly fetchable, presigned for ≥ 24h, returns the correct Content-Type.

### `INVALID_REQUEST` on address

```json
{ "code": "INVALID_REQUEST", "message": "shippingAddress.state is required for country US" }
```

US/CA/AU require a 2-letter state code. EU countries don't (the API ignores `state` for them).

### `INVALID_REQUEST` on currency

```json
{ "code": "INVALID_REQUEST", "message": "Currency XXX is not supported for this account" }
```

Your wallet/contract doesn't include that currency. Use a configured currency or contact billing.

### `INSUFFICIENT_FUNDS` on order create

```json
{ "code": "PAYMENT_REFUSED", "message": "Insufficient wallet balance" }
```

Top up the wallet in dashboard.

### `ORDER_ALREADY_EXISTS`

```json
{ "code": "ORDER_ALREADY_EXISTS", "message": "Order with reference xyz already exists" }
```

You re-submitted with the same `orderReferenceId`. If this is a duplicate, `GET /v4/orders/{existing-id}` to read state. If you actually meant a new order, generate a new reference.

## Timeouts

Suggested timeouts per endpoint type:

| Operation | Recommended client timeout |
| --- | --- |
| Catalog reads (`GET /v3/catalogs/...`) | 10s |
| Product reads | 10s |
| Quote (`POST /v4/orders:quote`) | 30s |
| Order create (`POST /v4/orders`) | 30s |
| Order get | 10s |
| Order search | 30s |
| Ecommerce template / store reads | 10s |
| Ecommerce create product (template publishing) | 60s |

`POST /v4/orders` can be slow when Gelato is fetching all your file URLs synchronously — be generous.

## Distinguishing transient from permanent failures

A heuristic table:

| Symptom | Class |
| --- | --- |
| `ECONNRESET`, `ETIMEDOUT`, `ENOTFOUND` | Transient — retry |
| 502, 503, 504 | Transient — retry |
| 500 | Usually transient — retry, but inspect; could be a Gelato bug |
| 429 | Transient — retry with `Retry-After` |
| 401 | Permanent — fix auth |
| 403 | Permanent — fix scope |
| 404 (on a known-good URL) | Likely permanent — wrong ID |
| 409 | Permanent — duplicate |
| 422 | Permanent — fix payload |

## Logging recommendation

Log every Gelato API call with:

- Method + path.
- `orderReferenceId` (if applicable) and Gelato `id` (if known).
- HTTP status.
- Response body (truncate to first 2KB).
- Latency.
- Retry attempt number.

This makes debugging missing orders or weird state transitions tractable.

## Webhook delivery failures (vs. API failures)

Note that webhook delivery from Gelato to you follows different rules — 3 retries with 5-second gaps, then dropped. That's a Gelato-side concern, not your API call retry policy. See `references/webhooks.md`.

## Original sources

- `references/sources/gelato-admin-node/src/utils/error.ts` — SDK error wrapper.
- Official: HTTP semantics are standard REST; Gelato's specific error codes are inconsistently documented in the gated docs.
