# Events & Webhooks

Akeneo pushes catalog changes (product created/updated/deleted, and more) to your integration instead of making you poll. There are **two systems**, and picking the right one is the first decision:

- **Event Platform** — **CURRENT.** A subscription-based, API-first delivery service. You register a *subscriber* + *subscriptions* through a management API, and it streams **CloudEvents**-formatted events to an **HTTPS webhook**, a **Google Pub/Sub** topic, or a **Kafka** topic. At-least-once delivery, retries, filters, 30+ event types. Lead with this. (Migrate onto it: `events-api/migrate-to-event-platform.md`; from the deprecated side: `event-platform/migrate-from-deprecated-event-api.md`.)
- **Events API** — **DEPRECATED**, retires **December 31, 2026.** The original PIM-configured webhook (product/product-model only, full-payload, 4 000 events/hour cap). Still works until retirement; both can run in parallel during migration.

> These are **not** the same product and are **not** wire-compatible: different endpoints, different payload envelopes, and — critically — **different signature schemes** (see *Signature verification*). Don't point both at the same destination URL; per `event-platform/getting-started.md`, sharing a URL suppresses Event Platform delivery.

For auth models (Connection vs App) see `authentication.md` and `apps-and-connections.md`; for the REST surface those events point back to, see `rest-api-overview.md` and `products-and-models.md`.

## The two systems at a glance

| | **Event Platform** (current) | **Events API** (deprecated) |
| --- | --- | --- |
| Status | Current, actively developed | Deprecated — retires **2026-12-31** |
| Config surface | Management API (`event.prd.sdk.akeneo.cloud/api/v1`) — API-first, no UI | PIM UI (*Connect → Connection*), Apps **not** supported |
| Destinations | `https` webhook, `pubsub`, `kafka` | HTTPS webhook only (one Request URL) |
| Payload | **CloudEvents 1.0**, lightweight (UUID + author; delta or full) | `{events:[…]}`, **full product imprint** per event |
| Event coverage | Wide (product, product-model, +30 types) | product + product-model only |
| Delivery guarantee | **At-least-once** + retry (5/10/20 min) | Best-effort; "can be lost, duplicated, or out of order" |
| Capacity | Adaptive 1–100 events/s (HTTPS); quotas only | **4 000 events/hour**, batches of ≤10 |
| Subscriptions | 20 subscribers × 20 subscriptions per PIM | **3** subscriptions max |
| Ack deadline | **5 s** → 200 OK | **0.5 s** (500 ms) |
| Self-triggered events | **Delivered** (you must filter them) | **Suppressed** by the PIM |
| Signature header | `X-AKENEO-SIGNATURE-PRIMARY` (HMAC over **body**) | `X-Akeneo-Request-Signature` (HMAC over **`ts.body`**) |
| Editions | EE SaaS ✅, Growth ✅, EE PaaS ❌, CE ❌ | SaaS only, PIM ≥ 5.0 |

---

# Event Platform (current)

## Mental model

```
  Akeneo PIM  ──(change happens)──▶  Event Platform  ──(CloudEvent)──▶  your destination
   {pim_url}                          event.prd.sdk.akeneo.cloud         (https | pubsub | kafka)
       ▲                                     ▲
       │  you manage config via the Management API (subscribers + subscriptions)
       └───────── auth: a valid PIM token (Connection OR App) + the "Event Platform" permission checkbox
```

- A **Subscriber** = the link to **one** PIM instance + connection. Multi-tenant App on N PIMs → **N subscribers** (one per instance).
- A **Subscription** = "send these event types, that match this filter, to this destination." Many subscriptions per subscriber; each targets exactly one destination.
- The PIM emits an event → the platform matches it against your subscriptions/filters → delivers a CloudEvent to each matching destination, retrying on failure.

## Management API & authentication

All configuration goes through the **management API** base URL:

```
https://event.prd.sdk.akeneo.cloud/api/v1
```

**Authentication** (`authentication-and-authorization.md`): every management call needs a **valid PIM API token** — the *same* Bearer token you use for the PIM REST API, obtained from either a **Connection** (`password` grant at `{pim}/api/oauth/v1/token`) or an **App** token. Pass it, plus the PIM URL and client id, as headers:

| Header | Value |
| --- | --- |
| `X-PIM-URL` | Your PIM base URL, e.g. `https://my-pim.cloud.akeneo.com` |
| `X-PIM-TOKEN` | The PIM access token (the same value you'd send as `Authorization: Bearer …`) |
| `X-PIM-CLIENT-ID` | The Connection/App `client_id` |

> The PIM token lives **1 hour** (Connection grant). Refresh it before it expires; the Postman collection referenced in `getting-started.md` regenerates it automatically from connection credentials.

**Authorization:** a global **Event Platform permission checkbox** must be enabled on the Connection (or the App's connection settings) — otherwise you cannot subscribe, and if it is unchecked *after* subscribing, the subscription is **automatically suspended**. Permissions are global (all-or-nothing); you cannot scope specific rights.

Core endpoints (full OpenAPI spec and Postman collection are hosted, not vendored — see *Original sources*):

| Method + path | Purpose |
| --- | --- |
| `POST /subscribers` | Create a subscriber |
| `GET/PATCH/DELETE /subscribers/{id}` | Manage a subscriber |
| `POST /subscribers/{id}/subscriptions` | Create a subscription |
| `GET/PATCH/DELETE …/subscriptions/{id}` | Manage a subscription |
| `POST …/subscriptions/{id}/suspend` and `…/resume` | Pause / resume delivery |
| `GET /logs` | Query delivery/action logs (30-day window) |

## Subscribers

A subscriber ties all your subscriptions to one PIM. Properties (`concepts.md`):

| Property | Notes |
| --- | --- |
| `id` | Assigned by the platform (UUID) |
| `name` | Your label |
| `subject` | Set from the `X-PIM-URL` header (the source PIM) |
| `contact.technical_email` | Where status emails (suspended/revoked/resumed) are sent |
| `notification_channels` | `["email"]` (default), `["webhook"]`, or both — see *Notification webhooks* |
| `notification_webhook_url` | HTTPS URL; required when `webhook` is a channel (no redirects followed) |
| `notification_webhook_secret` | 16–256 chars; signs notification payloads; never returned by the API |
| `status` | `active` or `deleted` (deleted is terminal — cannot be reactivated) |

```bash
curl -X POST 'https://event.prd.sdk.akeneo.cloud/api/v1/subscribers' \
  -H "X-PIM-URL: $TARGET_PIM_URL" -H "X-PIM-TOKEN: $PIM_API_TOKEN" \
  -H "X-PIM-CLIENT-ID: $CLIENT_ID" -H 'Content-Type: application/json' \
  -d '{"name":"my subscriber","contact":{"technical_email":"ops@example.com"}}'
# → { "id": "01905a84-…", "status": "active", … }
```

## Subscriptions

| Property | Notes |
| --- | --- |
| `id` | Assigned by the platform |
| `source` | Only `pim` today |
| `subject` | The PIM URL (from `X-PIM-URL`) |
| `type` | `https`, `pubsub`, or `kafka` |
| `events` | Array of event-type strings to receive (see *Event catalog*) |
| `config` | Destination config, shape depends on `type` (below) |
| `filter` | Optional single filter expression (see *Event filters*) |
| `send_product_identifier` | Default `false`. When `true`, product events also include the product `identifier` (not just `uuid`). Applies only to the product events listed below. |
| `status` | `active`, `suspended`, `revoked`, or `deleted` |

Subscription statuses:

| Status | Meaning |
| --- | --- |
| `active` | Receiving events |
| `suspended` | Stopped by the platform (excessive errors) or by you. **Resumable**, but events during suspension are **lost, not buffered.** |
| `revoked` | The connection/App was removed from the PIM. Terminal. |
| `deleted` | Terminal — cannot be reactivated |

`send_product_identifier` affects only: `com.akeneo.pim.v1.product.created`, `.updated`, `.updated.delta`, `.deleted`, `.became-complete`, `.became-incomplete`.

> **Activation delay:** after creating/updating a subscription there is a **several-minute** propagation delay before it goes live. Wait before expecting events (`getting-started.md`, `faq.md`).

## Subscription types (destinations)

### `pubsub` — Google Cloud Pub/Sub (preferred, most resilient)

```json
{ "source":"pim", "subject":"https://my-pim.cloud.akeneo.com",
  "events":["com.akeneo.pim.v1.product.updated"],
  "type":"pubsub",
  "config":{ "project_id":"your_gcp_project", "topic_id":"your_topic" } }
```

Grant publish rights: add principal **`delivery-sa@akecld-prd-sdk-aep-prd.iam.gserviceaccount.com`** with role **Pub/Sub Publisher** on the topic. Akeneo's GCP project number (if needed) is **`973566433018`**. Pub/Sub absorbs bursts for you — no per-endpoint rate limiting to implement.

### `https` — webhook

```json
{ "source":"pim", "subject":"https://my-pim.cloud.akeneo.com",
  "events":["com.akeneo.pim.v1.product.updated"],
  "type":"https",
  "config":{ "url":"https://your_webhook_url",
    "secret":{ "primary":"sign-secret", "secondary":"optional-rotation-secret" } } }
```

Requirements (`concepts.md`, `key-platform-behaviors.md`):
- **Public HTTPS**, no auth, **no redirects** (a `3xx` → immediate suspension).
- **Respond `200 OK` within 5 s.** Slower → retry, then suspension. Ack fast, process async.
- **Return `HTTP 429` under load** — the platform's adaptive throttle relies on it. No `Retry-After` support (the header is ignored). Endpoints that don't 429 risk being overwhelmed.
- At least a `primary` secret is required (for HMAC signing); `secondary` eases rotation.
- Optional IP allow-listing: current egress IP is **`34.140.80.128`**, but Akeneo recommends allow-listing the **`europe-west1`** ranges from Google Cloud's `cloud.json` (the single IP is not guaranteed stable).

### `kafka` — Apache Kafka topic

```json
{ "type":"kafka",
  "config":{ "broker":"kafka-cluster.example.com:9092", "topic":"pim-events",
    "sasl_auth":{ "mechanism":"plain", "username":"…", "password":"…" },
    "tls":{ "server_name":"…", "ca_pem":"…", "client_cert_pem":"…", "client_key_pem":"…" } } }
```

`sasl_auth.mechanism` supports `plain` (SCRAM/OAuth Bearer on request). `tls` is optional; all four PEM fields are required when present. Failed deliveries retry with exponential backoff.

### Custom HTTP headers (all types)

Add `config.headers` (max **5**) to inject a static API key or routing hint. Names: `a-zA-Z0-9-`, ≤128 chars; values: printable ASCII, ≤256 chars. Reserved (rejected): `Content-Type`, `User-Agent`, `X-Correlation-ID`, `Host`, `Authorization`, `Cookie`, and anything starting `X-AKENEO-SIGNATURE-`. For HTTPS, custom headers are injected **after** signing, so they are **not** covered by the HMAC. Header values are redacted in API responses.

## Delivery payload format (CloudEvents)

Every delivered event is a **CloudEvents 1.0** message in **structured mode** (metadata + data together in the body), regardless of destination type (`concepts.md`):

```json
{
  "specversion": "1.0",
  "id": "018e197c-dfe2-70f8-9346-1a8e016f5fbb",
  "source": "akeneo-event-platform",
  "type": "com.akeneo.pim.v1.product.deleted",
  "subject": "0190fe8a-6213-76ce-8a9f-ba36a5ef555a",
  "datacontenttype": "application/json",
  "dataschema": "https://event.prd.sdk.akeneo.cloud/spec/com.akeneo.pim.v1.product.deleted.schema.json",
  "time": "2024-03-07T15:16:37Z",
  "data": {
    "product": { "uuid": "3444ec1b-058e-4208-9b6c-284f47a7aa17",
                 "identifier": "my-product-identifier" },
    "author":  { "identifier": "b238e9f7-fcec-45bd-9431-d43cd624b244", "type": "api" }
  }
}
```

| Envelope field | Meaning |
| --- | --- |
| `specversion` | CloudEvents version (`1.0`) |
| `id` | Unique event id — **use for deduplication** |
| `source` | Always `akeneo-event-platform` |
| `type` | The event type (see *Event catalog*) |
| `subject` | The **subscription id** the event came from (use it to route multi-tenant traffic) |
| `datacontenttype` | `application/json` |
| `dataschema` | URL of the JSON Schema for `data` |
| `time` | When the change happened — **use for ordering** |
| `data` | Event payload: the changed entity (`product`/`product_model`) + `author` |

- `data.product.identifier` is present **only** when `send_product_identifier: true`; otherwise you get `uuid` only.
- `data.author` = who caused the change: `identifier` (the acting user/`client_id`) and `type` (`ui`, `api`, `job`, `system`, …). Match `author.identifier` against your own `client_id` to drop self-triggered events (see *Recipe*).
- **`*.updated.delta`** events carry only what changed; **`*.updated`** carries a fuller snapshot. The exact per-type `data` schemas live on the hosted *available-events* page (see *Original sources*) — not vendored here.

## Signature verification (HTTPS destinations)

Each HTTPS delivery is signed by HMAC. The platform computes the HMAC-SHA256 of the **payload body** with your configured secret(s) and sends:

| Header | Value |
| --- | --- |
| `X-AKENEO-SIGNATURE-PRIMARY` | HMAC-SHA256 of the body, using `config.secret.primary` |
| `X-AKENEO-SIGNATURE-SECONDARY` | Same over `config.secret.secondary` (if set) — enables zero-downtime rotation |
| `X-AKENEO-SIGNATURE-ALGORITHM` | Currently always `HmacSHA256` |

Two signatures let you rotate: accept either while you swap secrets. Verify (Node.js, from `concepts.md`):

```js
const crypto = require('crypto');
const computed = crypto.createHmac('sha256', secret)
  .update(JSON.stringify(req.body))     // sign the body; prefer the RAW body bytes
  .digest('hex');
if (computed !== req.header('X-AKENEO-SIGNATURE-PRIMARY')) return; // reject
```

> Prefer the **raw request bytes** and a **constant-time compare** (`crypto.timingSafeEqual`, PHP `hash_equals`, Python `hmac.compare_digest`). This scheme is **different from the deprecated Events API**, which signs `timestamp + "." + body` and uses `X-Akeneo-Request-Signature` — do not reuse verification code across the two.

## Event filters

Attach an optional **single** `filter` expression to a subscription to receive only matching events (`available-filters.md`). Strongly recommended, especially for delta events, to cut noise.

| Filter | Syntax | Applies to |
| --- | --- | --- |
| User | `user="<user_uuid>"` | all event types |
| User type | `user_type="<type>"` — `user`, `api`, `job`, `system`, `unknown-user-type` | all event types |
| Attribute | `attribute="<attr_code>"` | `product.updated.delta`, `product-model.updated.delta` |
| Scope / Channel | `scope="<channel>"` or `channel="<channel>"` | the two `*.updated.delta` events |
| Locale | `locale="<locale>"` | the two `*.updated.delta` events |

Operators: `and`, `or`, `not`, `in`. Constraints: **1 filter per subscription**, ≤ **500 chars**, ≤ **4 operators**. Values must be double-quoted (`user="system"` ✅, `user=system` ❌); group with parentheses.

```
(attribute="name" and locale="fr_FR") and not user="system"
not (attribute in ["price", "internal_notes"])
```

Note: for `channel`/`scope`/`locale`, the filter also matches **non-scopable / non-localizable** attributes (and `in` additionally matches null fields) — a practical convenience so you don't accidentally drop those. If a filtered field is absent from an event, the event is silently skipped.

## Key delivery behaviors

- **At-least-once** (`key-platform-behaviors.md`): **expect duplicates and out-of-order events.** Dedupe on `id`; order/recency via `time`. Retried events are the common source of reordering (`faq.md`: sequence is "likely" preserved but *not guaranteed*).
- **Adaptive throughput (HTTPS):** delivery rate auto-scales **1 → 100 events/s** based on your responses — `200` ramps it up, `429` throttles it down. Events throttled and undelivered for **> 1 hour** hurt your success rate.
- **Delivery timeout:** **5 s** to return `200`; slower enters the retry flow.
- **Retry policy (transient failures):** retry at **+5 min, +10 min, +20 min**; after **3 attempts** the event is **dropped.** Best-effort, non-configurable.
- **Suspension policy:**
  - *Criteria-based (immediate):* endpoint returns `404`; endpoint returns any `3xx`; the platform isn't authorized to publish to your Pub/Sub topic.
  - *Threshold-based:* success rate **< 90 % over the rolling hour** (counting `5xx`, `4xx`, timeouts, and `429`s left undelivered > 1 h).
- **No replay/backfill:** the platform does not store events; you **cannot query past events.** Build a **reconciliation job** (periodic REST pull) so a suspension or outage doesn't permanently lose data (`best-practices.md`).
- **Batch your callbacks:** never call the PIM REST API synchronously from an event handler. Queue events and pull the PIM in **batches**, respecting PIM rate limits (`errors-and-rate-limits.md`).

## Notification webhooks (subscription status)

Separate from event delivery: when a subscription flips to **suspended / revoked / resumed**, the platform notifies you on your subscriber's `notification_channels` (`notification-webhooks.md`). Default is `email`; opt into `webhook` by setting `notification_webhook_url` + `notification_webhook_secret`.

The webhook is a `POST` with `notification_type` ∈ `subscription.suspended.system`, `subscription.suspended.user`, `subscription.revoked`, `subscription.resumed`:

```json
{ "notification_type":"subscription.suspended.system", "timestamp":"2026-04-29T12:34:56Z",
  "subscription_id":"018e1ec5-…-a2a6", "subscriber_id":"018e1ec5-…-a2a5",
  "destination":"https://my-app.example.com/webhook",
  "events":["com.akeneo.pim.v1.product.created","com.akeneo.pim.v1.product.updated"],
  "reason":"Success rate dropped below 90%", "subject":"https://example.cloud.akeneo.com/" }
```

Signed with **HMAC-SHA256 over the raw body** using `notification_webhook_secret` (a **single** secret — no primary/secondary), header `X-AKENEO-SIGNATURE-PRIMARY` + `X-AKENEO-SIGNATURE-ALGORITHM: HmacSHA256`. Ack with `2xx` within **5 s**; the platform retries up to **3×** (delays 1 s, 2 s) on `5xx`/`429`, does not retry other `4xx`, follows no redirects. If all webhook attempts fail and `email` isn't a channel, it falls back to emailing `technical_email`.

## Limits, quotas & compatibility

- **Limits:** 20 subscribers per PIM; 20 subscriptions per subscriber (`limitations.md`).
- **Quotas:** none imposed, but millions of events/day may warrant a conversation with Akeneo.
- **PIM compatibility** (`compatibility.md`): **Enterprise SaaS ✅, Growth ✅**; **Enterprise PaaS ❌, Community ❌.**

## Logs API

`GET /logs` returns paginated, filterable delivery logs for **the last 30 days** (`logs.md`). Two `log_type`s: **`action`** (e.g. `subscription_suspended_by_the_user`) and **`error`** (e.g. `failed_to_deliver_event`, with `error_type`/`error_code`/`error_message`). Filter by time range, type, `subscriber_id`, `subscription_id`. Error logs with the same `subscription_id` + `error_message` inside a 5-minute window are **deduplicated** into one entry (timestamped at the latest occurrence).

---

# The event catalog

## Event Platform event types

CloudEvents `type` strings, grouped. These are the types confirmed in the vendored docs; Akeneo advertises **30+** total (attribute, category, etc.), but that full list lives only on the hosted *available-events* page — **not vendored here** (see *Original sources*).

**Product events** — `data.product` = `{ uuid, identifier? }` (+ `author`):

| Type | Fires when |
| --- | --- |
| `com.akeneo.pim.v1.product.created` | A product is created |
| `com.akeneo.pim.v1.product.updated` | A product is updated (fuller snapshot) |
| `com.akeneo.pim.v1.product.updated.delta` | A product is updated — **only changed data** (filterable by attribute/scope/locale) |
| `com.akeneo.pim.v1.product.deleted` | A product is deleted |
| `com.akeneo.pim.v1.product.became-complete` | A product crossed into "complete" |
| `com.akeneo.pim.v1.product.became-incomplete` | A product fell back to "incomplete" |

**Product-model events** — `data.product_model` (+ `author`):

| Type | Fires when |
| --- | --- |
| `com.akeneo.pim.v1.product-model.created` | A product model is created |
| `com.akeneo.pim.v1.product-model.updated.delta` | A product model is updated — only changed data |
| `com.akeneo.pim.v1.product-model.deleted` | A product model is deleted |

> The six that reproduce the old Events API behavior (per `events-api/migrate-to-event-platform.md`) are: `product.created`, `product.updated.delta`, `product.deleted`, `product-model.created`, `product-model.updated.delta`, `product-model.deleted`. Note product-model events use **`.deleted`** (not `.removed`) and only the **`.updated.delta`** variant appears in the vendored sources.

## Deprecated Events API payloads — version-keyed (5.0 / 6.0 / 7.0 / serenity)

The `events-reference/` bundle documents the **deprecated Events API** wire format (full product imprint), keyed by PIM version. Six actions: `product.created`, `product.updated`, `product.removed`, `product_model.created`, `product_model.updated`, `product_model.removed`. All are wrapped in the `{ "events": [ … ] }` envelope with per-event metadata (`action`, `event_id`, `event_datetime`, `author`, `author_type`, `pim_source`) and a `data.resource` object.

**The only schema difference across versions is product identity:**

| Version | `product.*` `data.resource` identity fields |
| --- | --- |
| **5.0** | `identifier` only |
| **6.0** | `identifier` only |
| **7.0** | `uuid` **and** `identifier` |
| **serenity** | `uuid` **and** `identifier` |

`product_model.*` payloads are **identical across all four versions** (models are keyed by `code`, never a UUID). Everything else in the product `resource` (`enabled`, `family`, `categories`, `groups`, `parent`, `values` as `{locale,scope,data}` arrays, `associations`, `quantified_associations`, `created`, `updated`, EE-only `metadata.workflow_status`) is the same across versions.

`product.created` / `product.updated` full resource (serenity example, abridged):

```json
{ "events": [{
  "action": "product.created", "event_id": "c306e088-…", "event_datetime": "2020-10-20T09:13:59+00:00",
  "author": "peter", "author_type": "ui", "pim_source": "https://demo.akeneo.com",
  "data": { "resource": {
    "uuid": "1fd20ad8-…", "identifier": "1111111304",   // ← uuid only on 7.0/serenity
    "family": "accessories", "parent": null, "groups": [], "categories": ["…"], "enabled": true,
    "values": { "name": [{ "locale": null, "scope": null, "data": "Sunglasses" }],
                "description": [{ "locale": "en_US", "scope": "ecommerce", "data": "<p>…</p>" }] },
    "created": "2020-10-20T08:30:28+00:00", "updated": "2020-10-20T09:13:59+00:00",
    "associations": { "PACK": { "groups": [], "products": [], "product_models": [] }, "…": {} },
    "quantified_associations": [], "metadata": { "workflow_status": "working_copy" } } } }] }
```

Removal payloads carry only identity — `product.removed`: `data.resource` = `{ identifier }` on 5.0/6.0, `{ identifier, uuid }` on 7.0/serenity; `product_model.removed`: `data.resource` = `{ code }` on every version. `author_type` values seen: `ui`, `api`.

---

# Deprecated Events API (brief)

What it was (`events-api/overview.md`): the original push mechanism, available since **PIM 5.0**, **SaaS only**, configured in the PIM UI on a **Connection** (Apps are **not** supported). It delivered `product.*` and `product_model.*` events (create/update/remove) as batched JSON POSTs (≤10 events per request) to a single HTTPS **Request URL**.

- **Signature (differs from Event Platform!):** header `X-Akeneo-Request-Signature` + `X-Akeneo-Request-Timestamp`. Verify by HMAC-SHA256 of `timestamp + "." + rawBody` with the connection secret, then `hash_equals` compare (`events-api/security.md`). Also use the timestamp to reject stale requests. Local/private/reserved IPs (RFC 6890 ranges) are blocked as targets.
- **Limits (`events-api/limits-and-scalability.md`):** **3** subscriptions, **4 000** requests/hour, **10** events/batch, **0.5 s** request timeout.
- **EE permissions apply (`events-api/more-about-events.md`):** you receive events only for products in categories your connection can view (unclassified → delivered); values you lack attribute-group/locale permission for are stripped from the payload.
- **Self-triggered events are suppressed** by the PIM (no loop) — the opposite of the Event Platform, where you must filter them yourself.
- **Debugging:** an "Event Logs" UI in the PIM (errors/warnings kept 72 h, latest 100 info/notice logs) — PIM ≥ 6.0.

**Migrate → Event Platform** (`events-api/migrate-to-event-platform.md`, `events-api/deprecation-faq.md`): create a subscriber + one subscription via the management API, enable the permission checkbox, and switch to a **UUID-only** mindset (identifiers are no longer transmitted by default; models are unaffected). Move from full snapshots to **`*.updated.delta`** events, add self-event filtering, and harden your endpoint for higher throughput. Both systems can run in parallel until the **2026-12-31** retirement. The `event-platform/migrate-from-deprecated-event-api.md` file is present but empty in this bundle; use the events-api migration guide.

---

# Recipe: consume a webhook safely

The one pattern that matters. Ack fast, verify, dedupe, process async, and drop self-triggered events.

```js
// Express HTTPS destination for the Event Platform.
const crypto = require('crypto');

// Capture the RAW body so the HMAC matches exactly what Akeneo signed.
app.use(express.json({ verify: (req, _res, buf) => { req.rawBody = buf; } }));

const PRIMARY = process.env.AKENEO_PRIMARY_SECRET;
const SECONDARY = process.env.AKENEO_SECONDARY_SECRET;   // optional, for rotation
const MY_CLIENT_ID = process.env.MY_PIM_CLIENT_ID;
const seen = new Set();                                   // back with Redis/DB in prod

function verify(rawBody, header, secret) {
  if (!secret || !header) return false;
  const computed = crypto.createHmac('sha256', secret).update(rawBody).digest('hex');
  const a = Buffer.from(computed, 'hex'), b = Buffer.from(header, 'hex');
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

app.post('/akeneo/events', (req, res) => {
  // 1. VERIFY signature (accept primary OR secondary during rotation).
  const sig = req.header('X-AKENEO-SIGNATURE-PRIMARY');
  if (!verify(req.rawBody, sig, PRIMARY) && !verify(req.rawBody, sig, SECONDARY)) {
    return res.status(401).end();                         // reject forgeries
  }

  const evt = req.body;                                   // CloudEvent

  // 2. DEDUPE on the CloudEvents id (delivery is at-least-once).
  if (seen.has(evt.id)) return res.status(200).end();
  seen.add(evt.id);

  // 3. DROP self-triggered events to avoid infinite loops.
  if (evt.data?.author?.identifier === MY_CLIENT_ID) return res.status(200).end();

  // 4. ACK FAST, then process asynchronously (must return 200 within 5s).
  queue.enqueue(evt).then(() => {/* batch-pull the PIM REST API later */});
  return res.status(200).end();                           // return 429 instead when overloaded
});
```

Checklist:
1. **Verify** the HMAC over the **raw body** (constant-time), accepting primary/secondary during rotation. (Deprecated Events API: sign `timestamp + "." + body` and read `X-Akeneo-Request-Signature`.)
2. **Ack within 5 s** with `200` (or `429` when you're saturated so the platform backs off).
3. **Process asynchronously** — enqueue, never call the PIM inline from the handler.
4. **Dedupe** on CloudEvents `id`; use `time` to resolve ordering.
5. **Drop self-triggered events** (`data.author.identifier == your client_id`).
6. **Reconcile periodically** via the REST API — events can be lost during suspension/outage; delta events give you only what changed, so pull full state from `products`/`products-uuid` when you need it (`products-and-models.md`).

## Original sources

- `event-platform/` — the current system: `overview.md`, `getting-started.md`, `concepts.md` (subscriber/subscription, subscription types, CloudEvents payload, HMAC), `authentication-and-authorization.md`, `available-filters.md`, `notification-webhooks.md`, `key-platform-behaviors.md` (at-least-once, throughput, retries, suspension), `best-practices.md`, `limitations.md`, `compatibility.md`, `api-reference.md`, `integration-examples.md`, `logs.md`, `faq.md`. (`migrate-from-deprecated-event-api.md` exists but is empty.)
- `events-api/` — the deprecated Events API: `overview.md`, `subscription.md`, `security.md` (signature), `more-about-events.md`, `limits-and-scalability.md`, `migrate-to-event-platform.md`, `deprecation-faq.md`.
- `events-reference/events-reference-{5.0,6.0,7.0,serenity}/` — version-keyed deprecated-Events-API payloads: `products.md`, `product-models.md`, and `resources/*.yml` schemas (product & product-model created/updated/removed).
- **Not vendored** (hosted by Akeneo, treat as source of truth): the Event Platform **OpenAPI spec** and **Postman collection** (`storage.googleapis.com/akecld-prd-sdk-aep-prd-api-assets/…`), and the **available-events** page listing the full 30+ event catalog and per-type `data` schemas (`api.akeneo.com/event-platform/available-events.html`).
