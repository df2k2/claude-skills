# 14 — Webhooks

Printful pushes events to a merchant-defined URL when things happen: an order ships, a file finishes processing, a mockup task completes, stock changes. v2 introduced **signed**, **expiring**, **HTTPS-only** webhooks with per-event configuration. v1 has a simpler all-or-nothing model.

## Differences at a glance

| | v1 | v2 |
|---|---|---|
| URL scheme | HTTP or HTTPS | **HTTPS only** |
| Signing | Optional `verifier_token` ping during setup; no per-event signing | **HMAC-SHA256** signature on every event (`X-PF-Signature`) |
| Expiration | Permanent (until disabled) | `default_expires_at` set on the config; events stop after expiry |
| Configuration | One URL + array of `types` per store | Per-event config; URL/secret/expiry can vary by event |
| Disable | `DELETE /webhooks` (whole store) | `DELETE /v2/webhooks` (whole store) or `DELETE /v2/webhooks/{eventType}` (one event) |
| Retry schedule | 1, 4, 16, 64, 256, 1024 min | Same: 1, 4, 16, 64, 256, 1024 min |
| New events | — | `mockup_task_finished`, `approval_sheet_created`, `catalog_stock_updated` (real-time), `catalog_price_changed` |

## v2 — set up

### Store-level configuration

```http
POST /v2/webhooks HTTP/1.1
Authorization: Bearer {token}
X-PF-Store-Id: {store_id}
Content-Type: application/json

{
  "url": "https://yourapp.example.com/printful/webhook",
  "default_expires_at": "2027-05-16T00:00:00Z"
}
```

Response:

```json
{
  "data": {
    "url": "https://yourapp.example.com/printful/webhook",
    "public_key":  "wh_pub_abc123",
    "secret_key":  "1a2b3c4d5e6f...   (64 hex chars; the HMAC secret, hex-encoded)",
    "default_expires_at": "2027-05-16T00:00:00Z",
    "expires_at_max": "2027-05-16T00:00:00Z"
  }
}
```

Save the `secret_key` immediately — it is returned only at create time.

`public_key` is sent on every event in the `X-PF-Public-Key` header so you can route to the right secret when supporting multiple configurations on the same URL.

### Enabling individual events

```http
POST /v2/webhooks/order_failed HTTP/1.1
Authorization: Bearer {token}
X-PF-Store-Id: {store_id}
Content-Type: application/json

{
  "expires_at": "2027-05-16T00:00:00Z"
}
```

Some events accept additional config. For example, `catalog_stock_updated` accepts a `product_ids` filter:

```json
{
  "expires_at": "2027-05-16T00:00:00Z",
  "product_ids": [71, 162, 380]
}
```

### Disabling

- `DELETE /v2/webhooks` — disables all events for the store.
- `DELETE /v2/webhooks/{eventType}` — disables one event.
- `GET /v2/webhooks` — current store config.
- `GET /v2/webhooks/{eventType}` — current event config.

### Event payload shape

Every event:

```http
POST /printful/webhook HTTP/1.1
Host: yourapp.example.com
Content-Type: application/json
X-PF-Public-Key: wh_pub_abc123
X-PF-Signature:  sha256=4f1a8c…
User-Agent: Printful Webhook v2
```

```json
{
  "type": "package_shipped",
  "occurred_at": "2026-05-17T10:00:00Z",
  "retries": 0,
  "store_id": 100,
  "data": {
    "order": { "id": 12345678, "external_id": "shopify-1001", "status": "fulfilled", … },
    "shipment": { … }
  }
}
```

Top-level fields:

| Field | Type | Meaning |
|---|---|---|
| `type` | string | Event type name (`package_shipped`, `order_failed`, etc.). |
| `occurred_at` | ISO 8601 UTC | When the event happened. |
| `retries` | int | Number of previous delivery attempts. `0` on first try. |
| `store_id` | int | Store the event belongs to. |
| `data` | object | Event-specific payload. |

### Signature verification

The signature is `HMAC-SHA256(secret_key_bytes, raw_request_body)`, hex-encoded, sent as `X-PF-Signature: sha256={hex}`.

**Critical**: the `secret_key` is returned hex-encoded. Hex-decode it before passing to HMAC.

Node.js:

```javascript
import crypto from "crypto";

function verify(signatureHeader, rawBody, secretKeyHex) {
  if (!signatureHeader || !signatureHeader.startsWith("sha256=")) return false;
  const provided = signatureHeader.slice("sha256=".length);
  const secret = Buffer.from(secretKeyHex, "hex");
  const expected = crypto.createHmac("sha256", secret).update(rawBody).digest("hex");
  // constant-time compare to avoid timing attacks
  return crypto.timingSafeEqual(Buffer.from(expected, "hex"), Buffer.from(provided, "hex"));
}

// In Express, use express.raw({ type: "application/json" }) so req.body is a Buffer
app.post("/printful/webhook", express.raw({ type: "application/json" }), (req, res) => {
  const ok = verify(req.header("X-PF-Signature"), req.body, process.env.PF_WEBHOOK_SECRET);
  if (!ok) return res.status(401).send("invalid signature");
  const event = JSON.parse(req.body.toString("utf8"));
  // ... handle event ...
  res.sendStatus(200);
});
```

Python (Flask):

```python
import hmac, hashlib, os
from flask import Flask, request, abort

app = Flask(__name__)

@app.post("/printful/webhook")
def handler():
    sig = request.headers.get("X-PF-Signature", "")
    if not sig.startswith("sha256="):
        abort(401)
    secret = bytes.fromhex(os.environ["PF_WEBHOOK_SECRET"])
    raw = request.get_data()
    expected = hmac.new(secret, raw, hashlib.sha256).hexdigest()
    if not hmac.compare_digest(expected, sig[len("sha256="):]):
        abort(401)
    event = request.get_json(force=True)
    # ... handle event ...
    return "", 200
```

PHP:

```php
$secret = hex2bin($_ENV['PF_WEBHOOK_SECRET']);
$raw    = file_get_contents('php://input');
$sig    = $_SERVER['HTTP_X_PF_SIGNATURE'] ?? '';
if (strpos($sig, 'sha256=') !== 0) { http_response_code(401); exit; }
$expected = hash_hmac('sha256', $raw, $secret);
if (!hash_equals($expected, substr($sig, 7))) { http_response_code(401); exit; }
$event = json_decode($raw, true);
```

### Retry schedule

If your endpoint returns a non-2xx (or times out at 30s), Printful retries:

```
attempt 1 → +1 min   → attempt 2 → +4 min   → attempt 3 → +16 min  →
attempt 4 → +64 min  → attempt 5 → +256 min → attempt 6 → +1024 min
```

Total span: ~22 hours. After the 6th failed attempt the event is dropped (but you can list undelivered events in the dashboard).

Make your handler **idempotent**: same event delivered multiple times shouldn't double-process. Deduplicate by `(event.type, event.occurred_at, event.data.order.id)` or similar.

### Expiration

Each event subscription has an `expires_at`. After expiry, events for that subscription stop firing. Printful's UI surfaces upcoming expirations; in code, set a calendar reminder or auto-refresh by re-POSTing the config periodically.

## v2 — event catalog

The current event types (some require specific scopes):

| `type` | Triggered when |
|---|---|
| `package_shipped` | A shipment label is created and the package is in carrier hands. Payload includes `order` + `shipment` with tracking. |
| `package_returned` | A shipment was returned to Printful (RTS). |
| `order_created` | Any order moves into `pending` (e.g. confirmed via API). |
| `order_updated` | Material change to a `pending`/`inprocess` order (e.g. address update). |
| `order_failed` | Order failed to be charged or fulfilled. |
| `order_canceled` | Order was canceled (by API, merchant, or Printful). |
| `order_put_hold` | Order moved to `onhold`. |
| `order_remove_hold` | Order moved off `onhold`. |
| `order_refunded` | Order was refunded. |
| `product_synced` | A Sync Product was successfully synced from the platform integration. |
| `product_updated` | A Sync Product was updated. |
| `product_deleted` | A Sync Product was deleted. |
| `catalog_stock_updated` | Stock changed for one or more catalog variants. Real-time on v2 (5-minute refresh). |
| `catalog_price_changed` | A catalog variant's price changed. v2-only. |
| `shipment_sent` | Alias-like; tracking number assigned. |
| `mockup_task_finished` | An async mockup task completed (success or fail). |
| `approval_sheet_created` | A new approval sheet needs merchant action. |
| `stock_updated` | Warehouse Products stock changed. |
| `print_file_updated` | A processed print file's status changed. |

Not every event applies to every store type — e.g. `product_synced` only fires on integrated stores (Shopify, WooCommerce, etc.), not on `api` stores.

## v1 — set up

```http
POST /webhooks HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "url": "https://yourapp.example.com/printful/webhook-v1",
  "types": [
    "package_shipped",
    "package_returned",
    "order_failed",
    "order_canceled",
    "product_synced"
  ],
  "params": { "store_synced": { "filter_only_active": true } }
}
```

Constraints:

- One URL per store. Re-POSTing replaces the previous configuration.
- All-or-nothing scope per store; you cannot point different events at different URLs (use v2 for that).
- No signature header. The only verification mechanism is the IP allow-list (Printful publishes its source IP ranges) and HTTPS itself.

### v1 disable

```http
DELETE /webhooks HTTP/1.1
```

## v1 — event payload

Same conceptual structure, but the envelope is flatter:

```json
{
  "type": "package_shipped",
  "created": 1716000000,
  "retries": 0,
  "store": 100,
  "data": {
    "order": { … },
    "shipment": { "tracking_number": "1Z…", "tracking_url": "…" }
  }
}
```

- `created` is Unix epoch, not ISO 8601.
- `store` (not `store_id`).
- No `X-PF-Signature` or `X-PF-Public-Key` headers.

## Common pitfalls

- **Verifying against the parsed JSON instead of the raw bytes.** HMAC must run over the exact bytes Printful sent. If you let your framework parse-and-restringify before HMAC, the recomputed signature will differ.
- **Using the hex string of `secret_key` as the HMAC key directly** (without hex-decoding). Some libraries treat the key as a string; the result silently doesn't match.
- **Returning 200 before processing**, then crashing the processor. Printful won't retry. Make processing transactional, or use a job queue and ack 200 only after enqueue succeeds.
- **Treating delivery as exactly-once.** Retries are real; deduplicate by `event.occurred_at + event.data.order.id` (or similar).
- **Sending `Content-Length: 0` 200 responses** vs response bodies — Printful accepts either, but some load balancers in front of your endpoint may not. Test end-to-end.

## Simulator

v1 has a [Webhook Simulator](https://www.printful.com/api/webhook-simulator) — paste a URL and an event type, click "Send", inspect the result. v2 simulator does not exist yet; exercise v2 events by triggering real events (draft → confirm → cancel → etc.) on a test store.

## Original sources

- v2 endpoint catalog: **Webhook v2** in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- v2 tag description (signing + retry table): `tags[name=Webhook v2].description` in [`sources/printful-v2-openapi.json`](sources/printful-v2-openapi.json).
- Schemas: `Webhook`, `WebhookCreated`, `WebhookInfoRequest`, `WebhookInfoResponse`, `EventConfigurationRequest`, `EventConfigurationResponse`, `CatalogStockUpdatedEventConfigurationRequest`, `DefaultEventConfigurationRequest`, `WebhookOrderData`, `WebhookShipmentData` in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
- v1 webhook endpoints in code: [`sources/PrintfulWebhook.php`](sources/PrintfulWebhook.php).
