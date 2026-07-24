# Webhooks

Gelato sends webhook events when state changes happen — order lifecycle events (order status, item status, tracking codes, delivery estimates) and store product / template lifecycle events. This reference covers configuration, event types, payload shapes, retry semantics, signature verification, and idempotency patterns. Ground truth for every payload shape: the captured official page at `references/sources/gelato-official-docs/webhooks.md`.

## Configuration

Webhooks are configured in the dashboard, not via API:

1. Sign in at https://dashboard.gelato.com/.
2. Navigate to the **Webhooks** section (under Account / Integrations / Settings depending on UI version).
3. Add a webhook URL — must be:
   - HTTPS (HTTP is rejected).
   - Publicly reachable from Gelato's servers.
   - Capable of returning a 2xx response within a reasonable timeout (a few seconds).
4. Pick the events to subscribe to (one URL can subscribe to all events, or different URLs per event type).
5. Save.

You can configure multiple webhook URLs — useful for fan-out (one URL for production, another for staging-mirror).

## Event types

The publicly documented events (per the captured official page):

| Event | Fires when |
| --- | --- |
| `order_status_updated` | Order-level fulfillment status changes (carries per-item tracking once shipped) |
| `order_item_status_updated` | Item-level fulfillment status changes (per line item) |
| `order_item_tracking_code_updated` | An item ships — tracking code + shipping provider |
| `order_delivery_estimate_updated` | **Beta** (request via apisupport@gelato.com) — an order's estimated min/max delivery date increases |
| `store_product_created` / `_updated` / `_deleted` | A store product is created / updated (or published) / deleted |
| `store_product_template_created` / `_updated` / `_deleted` | A store product template is created / updated / deleted |

One more event name exists in the wild but is **absent from the official webhooks page**: `catalog_product_stock_availability_updated` (see below).

### `order_status_updated`

Fires on every order-level transition: `created` → `passed` → `printed` → `shipped`, plus cancellations.

Payload (official shape — note there is **no** top-level `financialStatus` and **no** `shipment` object; tracking rides per-item in `items[].fulfillments[]`):

```json
{
  "id": "os_5e5680ce494f6",
  "event": "order_status_updated",
  "orderId": "a6a1f9ce-2bdd-4a9e-9f8d-0009df0e24d9",
  "storeId": null,
  "orderReferenceId": "your-internal-order-id",
  "fulfillmentStatus": "shipped",
  "items": [
    {
      "itemReferenceId": "your-line-1",
      "fulfillmentStatus": "shipped",
      "fulfillments": [
        {
          "trackingCode": "code123",
          "trackingUrl": "http://example.com/tracking?code=code123",
          "shipmentMethodName": "DHL Express Domestic BR",
          "shipmentMethodUid": "dhl_express_domestic_br",
          "fulfillmentCountry": "BR",
          "fulfillmentStateProvince": "SP",
          "fulfillmentFacilityId": "940fec84-54bc-44fc-a8a3-7d6f02cf8f14"
        }
      ]
    }
  ]
}
```

The exact set of fields varies by transition — `items[].fulfillments[]` fills in once packages exist (an early `created` event carries no tracking). Treat the shape as additive. For financial state (`paid`, `refunded`, …) fetch `GET /v4/orders/{orderId}` — the webhook does not carry `financialStatus`.

### `order_item_status_updated`

Fires on item-level fulfillment-status changes. Useful when an order has items produced in different facilities and they ship at different times. ⚠ Field-name gotcha: the item's status arrives as **`status`** (not `fulfillmentStatus`), and there is no `previousFulfillmentStatus` — track prior state yourself.

```json
{
  "id": "is_5b6403bd3cf1f",
  "event": "order_item_status_updated",
  "itemReferenceId": "your-line-1",
  "orderReferenceId": "your-internal-order-id",
  "orderId": "e82885f8-f92a-4326-b2c7-77d010f6996f",
  "storeId": null,
  "fulfillmentCountry": "US",
  "fulfillmentStateProvince": "NY",
  "fulfillmentFacilityId": "21315db8-e694-4ded-a72a-98f60814c6e8",
  "status": "passed",
  "comment": "",
  "created": "2018-08-03T07:26:52+00:00"
}
```

### `order_item_tracking_code_updated`

Fires when an item ships. Flat per-item payload: `id`, `event`, `orderId`, `storeId`, `itemReferenceId`, `orderReferenceId`, `trackingCode`, `trackingUrl`, `shipmentMethodName`, `shipmentMethodUid`, production-location fields, `created`. Redundant with `order_status_updated`'s `items[].fulfillments[]` — subscribe to whichever is simpler for your handler. Full example: the captured official page.

### `order_delivery_estimate_updated` (beta)

Access on request via apisupport@gelato.com. Fires when an order's estimated delivery window **increases** (multi-package orders report the most conservative estimate). Payload: `id`, `event`, `orderId`, `storeId`, `orderReferenceId`, `minDeliveryDate`, `maxDeliveryDate`, `created`.

### Store product / template lifecycle events

`store_product_{created,updated,deleted}` and `store_product_template_{created,updated,deleted}` fire as products/templates change in a connected store. `created`/`updated` payloads carry the full product or template snapshot (same shape as the Ecommerce GET endpoints — variants, `imagePlaceholders`, `textPlaceholders`, preview URLs); `deleted` carries just `id`, `event`, and the deleted `storeProductId` / `storeProductTemplateId`. These matter for template-registry patterns: there is **no list endpoint for templates**, so the `store_product_template_*` webhooks (plus per-ID GETs) are how you keep a local template registry current.

### `catalog_product_stock_availability_updated` (⚠ not in the official docs)

This event name is used by integrations in the wild but is **absent from the official webhooks page** — re-confirmed by the 2026-07-24 snapshot refresh. Its payload shape is therefore unverified; the sketch below is a best-effort reconstruction. Capture a live event before depending on any field, and prefer polling `POST /v3/stock/region-availability` as the mainline for stock data.

```json
{
  "event": "catalog_product_stock_availability_updated",
  "productUid": "apparel_product_gca_t-shirt_..._gsi_s_gco_white_gpr_4-4",
  "region": "EU",
  "available": false,
  "expectedBackInStock": "2026-06-15"
}
```

## Delivery semantics

| Property | Value |
| --- | --- |
| Method | `POST` |
| Content-Type | `application/json` |
| Encryption | HTTPS-only |
| Retry policy | **3 attempts**, **5 seconds** between attempts |
| Success criterion | HTTP `2xx` response |
| Failure outcome after 3 failed attempts | Event dropped — no further retries |

The 3-retry / 5-second-gap policy is tight by design — Gelato won't queue events indefinitely. If your endpoint is down or slow, you'll miss events.

### Implication: webhooks alone are not a reliable source of truth

For high-value orders or business-critical flows, supplement webhooks with:

- **Periodic polling** of `GET /v4/orders/{id}` for orders not yet at a terminal status (`shipped`, `canceled`, `refunded`).
- **Reconciliation jobs** that nightly `POST /v4/orders:search` for orders in your DB with status mismatch.
- **Idempotency** on every event so that a re-delivered or stale event is safe.

## Idempotency

Every documented event payload carries a unique event **`id`** (`os_…`, `is_…`, `tc_…`, `sp…_…`) — the natural dedup key. Order events also include `orderId` (Gelato's) and `orderReferenceId` (yours). Your handler must be safe to call multiple times for the same event.

Pattern:

```typescript
async function handleWebhook(payload: any) {
  // 1. Dedup on the event id (composite fallback for anything without one)
  const eventKey = payload.id
    ?? `${payload.orderId}:${payload.event}:${payload.fulfillmentStatus ?? payload.status}`;

  // 2. Check if we've already processed this exact key
  if (await db.processed_webhook_events.exists(eventKey)) {
    return { status: 'already_processed' };
  }

  // 3. Apply the state change
  await db.transaction(async (tx) => {
    await tx.orders.update({
      where: { gelato_id: payload.orderId },
      data: {
        fulfillment_status: payload.fulfillmentStatus,
        // financialStatus is NOT on the webhook — GET /v4/orders/{id} if you track it
        shipment_tracking:  payload.items?.flatMap((i: any) => i.fulfillments ?? []),
      },
    });
    await tx.processed_webhook_events.insert({ event_key: eventKey });
  });

  return { status: 'ok' };
}
```

This makes retries (Gelato's or your own webhook proxy's) safe.

## Order-of-arrival is not guaranteed

A `shipped` event may arrive before a `passed` event for the same order, especially if your endpoint had a transient failure. Don't assume monotonic state progression — always check the *current* fulfillmentStatus against your stored state and apply the transition only if the new state is "later":

```typescript
const STATUS_ORDER = ['draft', 'created', 'pending_approval', 'on_hold', 'passed', 'printed', 'shipped', 'canceled', 'failed'];

function isLaterStatus(current: string, incoming: string): boolean {
  return STATUS_ORDER.indexOf(incoming) > STATUS_ORDER.indexOf(current);
}
```

(Note: `canceled` and `failed` are terminal states that should generally win over earlier-stage events.)

## Signature verification

Gelato does **not** publish a documented HMAC signature scheme for webhook validation (as of the current public docs). To verify webhooks are genuinely from Gelato:

- **IP allow-list**: restrict your webhook endpoint to known Gelato IP ranges. (Contact Gelato support for the current list.)
- **Shared secret**: include a secret token in the webhook URL itself (e.g., `https://your-app.example.com/webhooks/gelato?token=<secret>`) and check it in your handler.
- **Basic Auth**: configure your webhook URL with HTTP Basic Auth (`https://user:pass@your-app.example.com/webhooks/gelato`) — Gelato will send the credentials in the `Authorization` header.

The Basic Auth pattern is the most portable. Set a long random password, and validate it in your handler:

```typescript
app.post('/webhooks/gelato', (req, res) => {
  const auth = req.headers.authorization;
  if (auth !== `Basic ${Buffer.from(`gelato:${process.env.WEBHOOK_SECRET}`).toString('base64')}`) {
    return res.status(401).send('Unauthorized');
  }
  // ... process payload ...
  res.json({ ok: true });
});
```

## Handler best practices

1. **Return 2xx quickly.** Acknowledge the webhook before doing heavy work. If you take > 5 seconds, you risk Gelato timing out and retrying.

   ```typescript
   app.post('/webhooks/gelato', async (req, res) => {
     await queue.enqueue('process-gelato-event', req.body); // queue for async processing
     res.status(202).json({ accepted: true });
   });
   ```

2. **Log everything.** Persist the raw payload to a log table or object store before processing — invaluable for debugging.

3. **Validate JSON.** Webhooks should always be valid JSON; if you get malformed input, you're not actually getting hit by Gelato.

4. **Don't 5xx on business-logic errors.** If you 500 because "this order isn't in our DB", Gelato retries 3x and then drops. Better to 200 (you received it) and queue the orphan for manual review.

5. **Monitor delivery rate.** Track `webhooks_received / webhooks_expected` over time. A drop signals connectivity or auth issues.

6. **Test with the dashboard's webhook tester.** Gelato's dashboard has a "Send test event" feature on each webhook config. Use it during setup and after any handler change.

## Webhook payload fields you should care about

| Field | Always present | What it tells you |
| --- | --- | --- |
| `id` | YES (documented events) | Unique event identifier — use as your dedup key. |
| `event` | YES | Which event type fired. |
| `orderId` | order events | Gelato's order ID. Use to fetch full details via `GET /v4/orders/{orderId}`. |
| `orderReferenceId` | order events | Your internal ID — primary lookup key in your DB. |
| `fulfillmentStatus` | `order_status_updated` (order-level + per-item); arrives as `status` on `order_item_status_updated` | Current fulfillment status. |
| `items[].fulfillments[]` | `order_status_updated`, once packages exist | Tracking codes + URLs, shipping method, production location. |
| `storeId` | connected-store orders only | The connected store this order belongs to. Null for direct-API/UI orders. |

`financialStatus` is **not** included in any webhook payload — for payment state (`paid`, `refunded`, …), `GET /v4/orders/{orderId}`. In general the webhook is a notification; the full state is in the order endpoint.

## Common failure modes

| Symptom | Cause | Fix |
| --- | --- | --- |
| No webhooks ever arrive | URL misconfigured, not registered in dashboard | Confirm in dashboard.gelato.com → Webhooks. |
| Some events arrive, others don't | URL is rate-limited or timing out | Acknowledge fast, queue for async. |
| Webhook arrives but `orderId` not in DB | Race between order creation and webhook delivery | Webhook for `created` can arrive before your POST `/v4/orders` response. Use `orderReferenceId` as primary key in your DB. |
| Tracking code missing on `shipped` | Shipment method has `hasTracking: false` | Pick a tracked method if tracking matters. |
| Duplicate processing | No idempotency check | Add an `eventKey` dedup table. |
| Auth-protected endpoint rejecting webhooks | Forgot to put credentials in URL | Use Basic Auth (`https://user:pass@host/...`) format in dashboard. |

## Configuration via the Order Desk pattern (legacy)

For very-old integrations, Gelato has the **Order Desk** legacy console that supports configuring webhooks per-order. New integrations should use the standard webhook configuration in the dashboard, not Order Desk.

## Combining with the Orders API for full sync

A robust order-sync pattern:

```
On POST /v4/orders success:
    Store {gelato_id, orderReferenceId, status: 'created'} in DB

On every webhook:
    1. Look up order by orderReferenceId (or gelato_id)
    2. If not found: log + reconciliation queue
    3. If found and status is "later" than stored: update
    4. If shipped: extract tracking codes; notify customer

Nightly:
    POST /v4/orders:search for orders created in last 7 days
    For each: GET /v4/orders/{id} and reconcile against DB
```

## Original sources

- `references/sources/gelato-official-docs/webhooks.md` — captured official webhooks reference (every event type's exact payload shape + configuration).
- Official live (gated): https://dashboard.gelato.com/docs/webhooks/
- Help center: https://support.gelato.com/en/articles/8996576-how-do-i-configure-notifications-webhooks
- The ekkolon SDK doesn't include webhook-handler code (only API-call code) — the official docs (captured above) are the only source for the exact payload shape.
