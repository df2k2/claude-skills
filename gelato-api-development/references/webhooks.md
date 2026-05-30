# Webhooks

Gelato sends webhook events when state changes happen — primarily order status updates, but also file-related events (malware scan, stock availability). This reference covers configuration, event types, payload shapes, retry semantics, signature verification, and idempotency patterns.

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

The publicly documented events:

| Event | Fires when |
| --- | --- |
| `order_status_updated` | Order-level fulfillment / financial status changes |
| `order_item_status_updated` | Item-level fulfillment status changes (per line item) |
| `catalog_product_stock_availability_updated` | A stockable product's regional availability changes |

### `order_status_updated`

Fires on every order-level transition: `created` → `passed` → `printed` → `shipped`, plus financial transitions (`pending` → `paid`), cancellations, and refunds.

Payload (representative shape):

```json
{
  "event": "order_status_updated",
  "orderId": "gelato-order-id",
  "orderReferenceId": "your-internal-order-id",
  "storeId": null,
  "fulfillmentStatus": "shipped",
  "financialStatus": "paid",
  "items": [
    {
      "itemReferenceId": "your-line-1",
      "fulfillmentStatus": "shipped"
    }
  ],
  "shipment": {
    "shipmentMethodName": "UPS Ground",
    "shipmentMethodUid": "ups_ground",
    "packageCount": 1,
    "minDeliveryDate": "2026-06-01",
    "maxDeliveryDate": "2026-06-03",
    "packages": [
      {
        "trackingCode": "1Z999AA10123456784",
        "trackingUrl": "https://www.ups.com/track?tracknum=1Z999AA10123456784",
        "orderItemIds": ["g-item-1"]
      }
    ]
  }
}
```

The exact set of fields varies by transition — a `created` event won't have a `shipment`, a `shipped` event will. Treat the shape as additive.

### `order_item_status_updated`

Fires on item-level fulfillment-status changes. Useful when an order has items produced in different facilities and they ship at different times.

```json
{
  "event": "order_item_status_updated",
  "orderId": "gelato-order-id",
  "orderReferenceId": "your-internal-order-id",
  "itemId": "g-item-1",
  "itemReferenceId": "your-line-1",
  "fulfillmentStatus": "printed",
  "previousFulfillmentStatus": "passed"
}
```

### `catalog_product_stock_availability_updated`

Fires when stockable-product availability changes in a region.

```json
{
  "event": "catalog_product_stock_availability_updated",
  "productUid": "apparel_product_gca_t-shirt_..._gsi_s_gco_white_gpr_4-4",
  "region": "EU",
  "available": false,
  "expectedBackInStock": "2026-06-15"
}
```

Subscribe to this if you're caching product availability in your own database or showing "in stock" badges on your storefront.

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

Every webhook payload includes `orderId` (Gelato's) and `orderReferenceId` (yours). Your handler must be safe to call multiple times for the same `(orderId, fulfillmentStatus, financialStatus)` combination.

Pattern:

```typescript
async function handleWebhook(payload: any) {
  // 1. Compute a deterministic event key
  const eventKey = `${payload.orderId}:${payload.fulfillmentStatus}:${payload.financialStatus}`;

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
        financial_status:   payload.financialStatus,
        shipment_tracking:  payload.shipment?.packages,
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
| `event` | YES | Which event type fired. |
| `orderId` | order events | Gelato's order ID. Use to fetch full details via `GET /v4/orders/{orderId}`. |
| `orderReferenceId` | order events | Your internal ID — primary lookup key in your DB. |
| `fulfillmentStatus` | order events | Current order-level status. |
| `financialStatus` | order events | Current payment status. |
| `items[]` | order events | Slim per-item snapshot. For full item state, GET the order. |
| `shipment` | `shipped` event onwards | Tracking codes + URLs, package breakdown. |
| `storeId` | connected-store orders only | The connected store this order belongs to. Null for direct-API orders. |

For the canonical, exhaustive payload shape, fetch the order with `GET /v4/orders/{orderId}` after the webhook arrives — the webhook is a notification; the full state is in the order endpoint.

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

- Official (gated): https://dashboard.gelato.com/docs/webhooks/
- Help center: https://support.gelato.com/en/articles/8996576-how-do-i-configure-notifications-webhooks
- The ekkolon SDK doesn't include webhook-handler code (only API-call code) — the official docs are the only public source for the exact payload shape.
