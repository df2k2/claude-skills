# Webhooks Index

OrderGroove sends HTTP POST callbacks to your server every time a relevant event happens (subscription created, order skipped, item out-of-stock, etc.). This directory contains the full event catalog with payload schemas.

## Read in this order if new to webhooks

1. [webhooks-overview.md](webhooks-overview.md) — what webhooks are, how to create them in the OG Admin, key rotation, test events.
2. [configuring-your-server-for-ordergroove-webhooks.md](configuring-your-server-for-ordergroove-webhooks.md) — receiving server requirements, signature verification (HMAC-SHA256 in `Ordergroove-Signature: ts=…,sig=…` header).
3. [events-and-payloads.md](events-and-payloads.md) — common payload structure (envelope, snapshot resource extensions, etc.).
4. The event-specific files below for whichever events you care about.
5. [troubleshooting-webhooks.md](troubleshooting-webhooks.md) — debugging delivery failures and retries.

## Event catalog

| File | Resource | Event names |
|---|---|---|
| [webhooks-subscriber-events.md](webhooks-subscriber-events.md) | Customer / Subscriber | `subscriber.create`, `subscriber.cancel`, `subscriber.subscriptions_created` |
| [webhook-subscription-events.md](webhook-subscription-events.md) | Subscription | `subscription.created`, `subscription.cancel`, `subscription.sku_swap`, `subscription.change_live`, `subscription.change_frequency`, `subscription.change_components`, `subscription.change_quantity`, `subscription.change_shipping_address`, `subscription.change_payment`, `subscription.refresh_one_click_token` |
| [webhooks-order-events.md](webhooks-order-events.md) | Order | `order.change_shipping_address`, `order.change_payment`, `order.change_next_order_date`, `order.skip_order`, `order.send_now`, `order.cancel`, `order.success`, `order.delete`, `order.generic_error`, `order.reject`, `order.reminder`, `order.retryable_placement_failure`, `order.refresh_one_click_token` |
| [webhooks-item-events.md](webhooks-item-events.md) | Item | `item.create`, `item.change_quantity`, `item.remove`, `item.item_subscribe`, `item.update_price`, `item.successfully_placed`, `item.out_of_stock` |
| [entitlements-events.md](entitlements-events.md) | Entitlements | Entitlement-related webhook events (modify expiration, etc.) |
| [workflow-events.md](workflow-events.md) | Workflow | Cross-resource workflow events |

## Where related docs live

- Resource Extensions (the "snapshot" enrichment of webhook payloads): see [`../01-getting-started/resource-overview.md`](../01-getting-started/resource-overview.md).
- Configuring webhooks programmatically (instead of via Admin UI): see [`../07-guides/configure-webhooks-via-api.md`](../07-guides/configure-webhooks-via-api.md).
- Using webhook one-click tokens for email/SMS deep links: see [`../07-guides/using-webhooks-for-1-click-actions.md`](../07-guides/using-webhooks-for-1-click-actions.md).
- Sync events (replay older events): see [`../07-guides/sync-events.md`](../07-guides/sync-events.md).
- Building data pipelines from webhooks: see [`../07-guides/sync-ordergroove-data-into-internal-systems.md`](../07-guides/sync-ordergroove-data-into-internal-systems.md), [`../07-guides/implement-custom-data-pipelines.md`](../07-guides/implement-custom-data-pipelines.md).
