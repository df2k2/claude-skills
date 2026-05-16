# 17 — Common pitfalls

Tagged with the **actual error** you'll see when you trip the wire.

## 1. Using `product_id` where `variant_id` is expected

**Symptom**: a 400 like `"The catalog variant 71 does not exist"` (`71` is the Bella+Canvas 3001 *product* ID), or — worse — an order accepted for an *entirely different product* whose variant ID happens to be `71`.

**Fix**: Always resolve to a `catalog_variant_id` via `GET /v2/catalog-products/{product_id}/catalog-variants` before submitting orders, mockups, or shipping quotes. The catalog endpoints are read-only and cheap to cache. Printful's own docs warn about this explicitly: variant IDs are global, product IDs are not order-grade.

## 2. Mixing v1 and v2 envelopes

**Symptom**: `Cannot read properties of undefined (reading 'id')` because your code reads `response.result.id`, but you hit a v2 endpoint that returns `{ "data": {…} }`.

**Fix**: One transport function per version, or a single transport that inspects the path:

```javascript
function unwrap(json, path) {
  return path.startsWith("/v2/") ? json.data : json.result;
}
```

Better: also branch error handling on `Content-Type` (`application/problem+json` ⇒ RFC 9457, `application/json` ⇒ legacy).

## 3. Forgetting the `@` prefix on v1 external-ID order lookup

**Symptom**: `404` on `GET /orders/my-order-123`.

**Fix**: Prefix with `@`: `GET /orders/@my-order-123`. v2 uses a query parameter instead: `GET /v2/orders?external_id=my-order-123`.

## 4. HTTP-Basic auth on a v2 endpoint

**Symptom**: `401 Unauthorized` on `/v2/...` even though the legacy store key works on v1.

**Fix**: v2 accepts **only** OAuth Bearer tokens. Issue a Personal Access Token at `https://developers.printful.com/tokens` and use `Authorization: Bearer …`. Drop HTTP Basic.

## 5. Calling `/v2/orders/{id}/confirmation` on an empty draft

**Symptom**: `409 Conflict` with `detail: "Order has no items"`.

**Fix**: Add at least one item via `POST /v2/orders/{id}/order-items` before confirming. (Or use the single-shot create with `confirm: true` and `order_items: [...]` in the same body.)

## 6. Editing an order after `inprocess`

**Symptom**: `409 Conflict` with `detail: "Order is not in a state that can be modified"`.

**Fix**: Edits are only safe on `draft` and (mostly) `pending` orders. Once fulfillment starts, addresses and items are locked. Cancel and re-create if absolutely necessary — and call DELETE only on `draft` or `pending` orders (cancel-after-charge needs Printful support).

## 7. Sending `placements` for a `source: "sync"` item

**Symptom**: `400 ValidationError` with `pointer: "/order_items/0/placements"` saying the field is not allowed.

**Fix**: Sync variants already have design data attached via Sync Product files. For `source: "sync"` or `source: "external"`, omit `placements`. The `placements` block is for `source: "catalog"` and `source: "warehouse"` (warehouse rarely has placements since it's pre-built).

## 8. Hex-decoding the signature, not the secret

**Symptom**: Every webhook signature comparison fails, even with the right secret.

**Fix**: The `secret_key` returned by `POST /v2/webhooks` is **hex-encoded**. Hex-decode it to bytes, then pass to HMAC. The signature sent on requests is also hex-encoded, but comparison is hex-string-to-hex-string. See [`14-webhooks.md`](14-webhooks.md) for verified code in Node, Python, and PHP.

## 9. Verifying against the parsed JSON body

**Symptom**: Signature mismatch on every webhook.

**Fix**: HMAC must run over the **raw bytes** Printful sent. If your framework auto-parses JSON and then you `JSON.stringify` the parsed object, key ordering and whitespace differ — HMAC fails. In Express, use `express.raw({ type: "application/json" })` for the webhook route; in Flask, use `request.get_data()` (not `request.json`).

## 10. Treating webhook delivery as exactly-once

**Symptom**: Duplicate orders / duplicate shipping emails after a temporary outage.

**Fix**: Printful retries on non-2xx up to 6 times across ~22h. Build the handler to deduplicate, e.g.:

```sql
INSERT INTO processed_webhooks (event_type, occurred_at, order_id)
VALUES ($1, $2, $3)
ON CONFLICT DO NOTHING
RETURNING id;
-- if no row returned, the event was already processed; skip
```

## 11. Polling mockup tasks too fast

**Symptom**: 429 rate-limit + 60s lockout, especially on bulk mockup jobs.

**Fix**: Wait at least 2 seconds between polls (matches the v2 leaky-bucket refill rate). Better: subscribe to `mockup_task_finished` and drop polling entirely. For very large batches, **stagger task creation** at ≤1 RPS rather than firing 100 creates in parallel.

## 12. Forgetting `X-PF-Store-Id` on multi-store tokens

**Symptom**: An order created in the "wrong" store (the default), or `403` on store-scoped reads.

**Fix**: Always send `X-PF-Store-Id: {store_id}` when the token has `stores_list` scope. Single-store tokens ignore the header but it doesn't hurt.

## 13. Quoting shipping with summary quantity > 100

**Symptom**: Repeated `429` on shipping rate calls; lockouts persist for a minute at a time.

**Fix**: When `sum(items[].quantity) > 100`, Printful caps shipping-rate calls at **5/min**. Aggregate identical line items into one `quantity: N` line, and cache rates per (recipient country, item composition) for the duration of the checkout session.

## 14. Skipping `external_id` on order creation

**Symptom**: After a network blip, you re-POST and get a *second* order in Printful for the same customer — double charge.

**Fix**: Set `external_id` on every order. Retries with the same `external_id` return `409 Conflict`; on conflict, `GET /v2/orders?external_id=...` to recover the original order ID. Treat the 409 as success.

## 15. Confirming an order whose file isn't `ok` yet

**Symptom**: Order moves to `failed` shortly after confirmation with `"File processing failed"`.

**Fix**: For high-volume integrations, pre-upload files via `POST /v2/files`, poll until `status: "ok"`, then create the order with `{ "file_id": N }` in the layer (not `{ "url": ... }`). The auto-upload-on-order convenience path works but exposes you to the post-confirm-revert risk.

## 16. Floats for prices

**Symptom**: `Total $17.45` vs `Total $17.450000000001` in the UI.

**Fix**: v2 returns prices as strings (`"17.45"`). Parse with a fixed-decimal library (Decimal in Python, big.js in JS, BCMath in PHP). Never `parseFloat` + `+` for money.

## 17. Mixing `placement` names across products

**Symptom**: `400` saying `"placement 'mug_wraparound' is not supported on product 71"`.

**Fix**: Placement names are **per-product**. A T-shirt has `front`, `back`, `sleeve_*`, `inside_label`. A mug has `mug_wraparound`, `mug_left`, `mug_right`. Use `GET /v2/catalog-products/{id}` and read the `placements[]` array to know what's valid.

## 18. Forgetting product/variant **availability** before ordering

**Symptom**: Order accepted, then transitions to `failed` with `"Variant is out of stock in this region"`.

**Fix**: Before order creation, check `GET /v2/catalog-variants/{id}/availability` and inspect the relevant selling region. Subscribe to `catalog_stock_updated` (real-time on v2, refreshes every 5 min) to know when a variant is back in stock.

## 19. Treating Sync Products as if they live in v2

**Symptom**: `404` on `GET /v2/store/products`.

**Fix**: Sync Products are v1-only. Use `GET /store/products` (no `/v2/` prefix). They can still be referenced from v2 orders via `source: "sync"`.

## 20. Sending camelCase or UPPER_SNAKE

**Symptom**: Cryptic `400 ValidationError` with `pointer: ""` — meaning the body didn't match any expected field.

**Fix**: snake_case everywhere: `external_id`, `catalog_variant_id`, `country_code`, `retail_price`. Not `externalId`. Not `EXTERNAL_ID`. The only camelCase fields are in v1 shipping-rate responses (`minDeliveryDays` / `maxDeliveryDays`) — fixed in v2.

## 21. Skipping `state_code` for US / CA / AU / JP

**Symptom**: `422` on order creation with `"state_code is required for this country"`.

**Fix**: For shipments to the US, Canada, Australia, or Japan, `state_code` is mandatory. For other countries, omit it entirely.

## 22. Logging tokens

**Symptom**: A token leaks into a log aggregator and a contractor with access uses it to create orders against a merchant's billing.

**Fix**: Add `Authorization` and any `secret_key` to your logger's redact list. Treat the webhook `secret_key` the same as a token.

## 23. Hard-coding rate limits

**Symptom**: Code assumes 120/min, then Printful reduces a specific endpoint to 30/min in a future release; suddenly your job throttles.

**Fix**: Read `X-Ratelimit-Limit` and `X-Ratelimit-Remaining` headers at runtime. Use those to drive your own bucket. Don't hard-code numeric caps.

## 24. Assuming there's a staging environment

**Symptom**: You create a "fake" order on prod thinking it won't charge. It does.

**Fix**: There is **no staging API**. Mitigations: (a) create a separate Printful test store, (b) keep all test orders in `draft` (never call `/confirmation`), (c) for webhooks, use the v1 simulator (https://www.printful.com/api/webhook-simulator).

## 25. Confusing `costs.subtotal` and `retail_costs.subtotal`

**Symptom**: Customs declarations report Printful's wholesale cost as the item value, leading to import disputes.

**Fix**: `costs` is what Printful charges *you* (wholesale + shipping + Printful fees). `retail_costs` is what *you* charged the customer (retail price + the shipping you collected). The packing slip and customs declaration use `retail_costs`. Set it.
