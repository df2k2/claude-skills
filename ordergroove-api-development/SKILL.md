---
name: ordergroove-api-development
description: Authoritative reference for developing against the OrderGroove subscription commerce platform. Use this skill whenever the user mentions OrderGroove, OG, subscription commerce APIs, recurring orders, Subscription Manager (the OG widget), Purchase POST, or asks to write code that calls `restapi.ordergroove.com` / `sc.ordergroove.com`. Also use whenever the user asks about subscription, customer, order, item, address, payment, product, product-group, OTD/one-time-incentive, free trial, prepaid, bundle, rotating-product, entitlement, offer, resource-extension, webhook, 1-click-action, or GraphQL endpoints/types in an OG context. Even if the user just describes a recurring-order workflow without naming OG (e.g. "skip the next order", "change subscription frequency", "create a subscription on checkout", "verify a webhook signature"), check this skill before writing code — every endpoint, request body, response field, error code, and webhook payload is embedded in this skill's references/ tree.
---

# OrderGroove API Development

OrderGroove is a subscription commerce platform. Merchants run their recurring-order programs through it: create subscriptions, generate orders on a schedule, process payments, send reminder/skip/swap actions to shoppers, and stream events back to the merchant's systems via webhooks. This skill is the on-disk reference for everything a developer needs to build against it.

The full OrderGroove documentation tree (REST endpoints, GraphQL schema, webhooks, Subscription Manager front-end, platform integrations, migration guides) is embedded under `references/`. **You must read the relevant reference file before writing API-calling code or describing payload shapes** — endpoint paths, body fields, query parameters, response codes, and webhook payloads have specific names and types that you should not guess.

## Repository layout

```
ordergroove-api-development/
├── SKILL.md                    ← you are here
└── references/
    ├── 01-getting-started/     ← base URLs, auth, rate limits, pagination, resources
    ├── 02-data-model/          ← Customer/Subscription/Order/Item ERD and concepts
    ├── 03-endpoints/           ← every REST endpoint (114 files), grouped by resource
    │   └── INDEX.md            ← ★ master endpoint catalog (method + path + link)
    ├── 04-webhooks/            ← webhook event catalog and payloads
    │   └── INDEX.md
    ├── 05-graphql/             ← GraphQL queries, mutations, type definitions
    │   ├── INDEX.md
    │   └── page-html-archive/  ← original HTML exports (duplicate of types/, kept verbatim)
    ├── 06-subscription-manager/ ← front-end widget customization (Shopify, themes, custom elements)
    ├── 07-guides/              ← lifecycle, bundle/box/rotating patterns, sync events, offers
    └── 08-platform-integrations/ ← Shopify, custom platforms, PayPal, migrations from Recharge/etc.
```

Each top-level directory has an `INDEX.md` listing every file inside with a one-line description. **Open the INDEX before reading individual files** — you'll usually save a round trip.

## Critical things to know up-front

Before answering anything substantive, internalize these. They keep coming up.

### 1. Two API hosts — pick the right one
- `https://restapi.ordergroove.com` — almost everything (subscriptions, orders, items, customers, addresses, payments, products, etc.). Staging: `https://staging.restapi.ordergroove.com`.
- `https://sc.ordergroove.com` — **only** the Purchase POST flow (composite create at `/subscription/create`) and Purchase POST status. Staging: `https://staging.sc.ordergroove.com`.

If the user is creating a subscription at checkout (the most common flow), they're hitting `sc.ordergroove.com` not `restapi`. See [`references/03-endpoints/purchase-post/`](references/03-endpoints/purchase-post/).

### 2. Two authentication scopes — pick the right one
- **Application API Scope** — server-to-server. Header: `x-api-key: <key>`. Up to 10 keys per merchant. Some keys can have "Bulk Operations" permission to query across customers.
- **Storefront API Scope** — client-side. HMAC-SHA256 signed `OG-Authorization` header containing `{public_id, sig_field, ts, sig}` (and optionally `trust_level`). Signature is `customer_id|timestamp` (or `customer_id|trust_level|timestamp`), valid 2 hours.

**Never put an Application API key in client-side code.** Full details and a working JS example: [`references/01-getting-started/authentication.md`](references/01-getting-started/authentication.md).

### 3. The data model — subscriptions are tied to items, not orders
- A **Customer** has many **Subscriptions** (one per product they're subscribed to).
- A **Subscription** has a frequency, an offer, a payment, a shipping address, and a product/quantity.
- A Subscription generates one **Order** at a time (the next upcoming order). When that order places, the next one is created.
- An **Order** contains one or more **Items**. Items can be subscription-driven OR one-time additions.

Read [`references/02-data-model/data-model-at-a-glance.md`](references/02-data-model/data-model-at-a-glance.md) before doing anything that touches multiple objects — most "this isn't doing what I expected" questions trace back to misunderstanding this model.

### 4. HTTP status codes
- `200`, `201`, `204` — success.
- `400` — invalid request body. Response shape: `{ "[field_name]": "field_name error detail" }`.
- `401` — missing/invalid auth. `403` — auth failed (`{"detail": "Authentication Failed"}`). `404` — not found.
- `423` — **resource is locked**, retry shortly. Happens with concurrent ops on the same resource. Common gotcha.
- `429` — rate limit. See [`references/01-getting-started/ordergroove-api-rate-limits.md`](references/01-getting-started/ordergroove-api-rate-limits.md).
- `5xx` — OG outage; retry with backoff.

### 5. Order status codes are numeric
You'll see `status: 1` or `status: 5` — these are not arbitrary. The full table is in [`references/03-endpoints/orders/order-status-codes.md`](references/03-endpoints/orders/order-status-codes.md). Common ones:
- `1` unsent (queued)
- `3` rejected
- `5` success (placed)
- `6` send_now requested
- `11` pending placement
- `15` generic error
- `18` credit-card retry

### 6. Webhooks need signature verification
OG signs every webhook with HMAC-SHA256 in `Ordergroove-Signature: ts=<timestamp>,sig=<sig>` (sometimes two `sig=` values during key rotation — accept either for 24h). **Always verify** before trusting the body. See [`references/04-webhooks/configuring-your-server-for-ordergroove-webhooks.md`](references/04-webhooks/configuring-your-server-for-ordergroove-webhooks.md).

### 7. Frequency: `every` + `every_period`
Subscriptions express recurring intervals as `every: <int>` + `every_period: <int>` where:
- `1` = days
- `2` = weeks
- `3` = months
- `4` = years

So "every 6 months" = `every: 6, every_period: 3`. The `frequency_days` field is also returned (cached integer of total days).

## How to use this skill (your workflow)

When the user asks anything OG-related, follow this loop:

1. **Identify which slice of the docs answers the question.** Use the directory map above plus `INDEX.md` files. Most questions hit one of:
   - "How do I call X" → `references/03-endpoints/INDEX.md` → linked endpoint file.
   - "What does this webhook look like" → `references/04-webhooks/INDEX.md` → event file.
   - "How does Y work conceptually" → `references/02-data-model/` or `references/07-guides/`.
   - "Subscription Manager / theme / front-end" → `references/06-subscription-manager/`.
   - "Shopify-specific / migration / SFTP" → `references/08-platform-integrations/`.
   - "GraphQL field/type" → `references/05-graphql/types/`.

2. **Read the relevant file(s) in full** before writing code or describing payloads. Each endpoint file has:
   - A description and authentication scopes (Application / Storefront).
   - **Request body / query parameter table** with field names, types, descriptions, and examples.
   - **Response body table** with every returned field.
   - **Code examples** (usually JavaScript with `fetch` or `request`).
   - An **OpenAPI 3.1 JSON definition** at the bottom — use this as the canonical source of truth when the prose and OpenAPI disagree.

3. **Quote field names exactly as they appear** (`merchant_user_id`, not `merchantUserId`; `every_period`, not `everyPeriod`). The REST API is `snake_case`. The GraphQL API is `camelCase` (e.g. `merchantUserId`, `everyPeriod`). Don't mix them.

4. **For staging vs production** — never assume which the user is on. Default code samples to environment variables (`OG_BASE_URL`, `OG_API_KEY`) so the user can switch.

5. **For sensitive data** — never log or emit `x-api-key` values, Storefront API private keys, customer PII (encrypted in OG: `first_name`, `last_name`, `email`), or full PAN. The `payments-create` flow specifically requires a tokenized card via the OG-supported tokenizer; see the payments docs.

## Common task quickstart

These are the highest-frequency tasks. Each links to the right reference file — don't try to write code from memory.

| User wants to… | Endpoint(s) | Reference |
|---|---|---|
| Create a subscription on checkout | `POST sc.ordergroove.com/subscription/create` | [purchase-post-api.md](references/03-endpoints/purchase-post/purchase-post-api.md), [subscription-creation-via-purchase-post.md](references/07-guides/subscription-creation-via-purchase-post.md) |
| List subscriptions for a customer | `GET /subscriptions/?customer={id}` | [subscriptions-list.md](references/03-endpoints/subscriptions/subscriptions-list.md), [pagination.md](references/01-getting-started/pagination.md) |
| Skip the next order | `PATCH /orders/{order_id}/skip_subscription/` | [skip-subscription.md](references/03-endpoints/subscriptions/skip-subscription.md) |
| Change subscription frequency | `PATCH /subscriptions/{id}/change_frequency/` | [subscriptions-change-frequency.md](references/03-endpoints/subscriptions/subscriptions-change-frequency.md) |
| Change subscription product (SKU swap) | `PATCH /subscriptions/{public_id}/change_product/` | [subscriptions-change-product.md](references/03-endpoints/subscriptions/subscriptions-change-product.md) |
| Cancel a subscription | `PATCH /subscriptions/{id}/cancel/` | [subscriptions-cancel.md](references/03-endpoints/subscriptions/subscriptions-cancel.md) |
| Reactivate a cancelled subscription | `PATCH /subscriptions/{id}/reactivate/` | [subscriptions-reactivate.md](references/03-endpoints/subscriptions/subscriptions-reactivate.md) |
| Push next-order date | `PATCH /orders/{order_id}/change_place_date/` (or `/subscriptions/{id}/change_next_order_date/`) | [orders-change-place-date.md](references/03-endpoints/orders/orders-change-place-date.md), [change-next-order-date.md](references/03-endpoints/1-click-actions/change-next-order-date.md) |
| Send the next order now | `PATCH /orders/{order_id}/send_now/` | [orders-send-now.md](references/03-endpoints/orders/orders-send-now.md) |
| Update a customer's payment | `PATCH /payments/{payment_id}/update/` + optionally `POST /payments/{id}/use_for_all/` | [payments-update.md](references/03-endpoints/payments/payments-update.md), [use-payment-for-all.md](references/03-endpoints/payments/use-payment-for-all.md) |
| Add a one-time item to upcoming order | `POST /items/iu/` | [items-create-in-order.md](references/03-endpoints/items/items-create-in-order.md), [add-a-one-time-item-to-an-upcoming-order.md](references/07-guides/add-a-one-time-item-to-an-upcoming-order.md) |
| Apply a one-time discount | `POST /one_time_incentives/create/` | [otd/](references/03-endpoints/otd/) |
| Verify a webhook | HMAC-SHA256 of body with verification key, compare to `Ordergroove-Signature: sig=…` | [configuring-your-server-for-ordergroove-webhooks.md](references/04-webhooks/configuring-your-server-for-ordergroove-webhooks.md) |
| Receive `subscription.cancel` events | Webhook payload | [webhook-subscription-events.md](references/04-webhooks/webhook-subscription-events.md) |
| Build a 1-click skip link in email | Webhook delivers `signed_skip_url`; the link calls `/one_click/skip` | [using-webhooks-for-1-click-actions.md](references/07-guides/using-webhooks-for-1-click-actions.md), [1-click-skip-1.md](references/03-endpoints/1-click-actions/1-click-skip-1.md) |
| Create prepaid (paid-up-front) subscription | `PATCH /subscriptions/{id}/upgrade_to_prepaid/` | [prepaid/](references/03-endpoints/prepaid/) |
| Create a free trial config for a product | `POST /products/{product_id}/free_trials/create/` | [free-trials-create.md](references/03-endpoints/free-trials/free-trials-create.md) |
| Build a build-your-own-box / curation subscription | Components / rotating products | [bundle-subscriptions.md](references/07-guides/bundle-subscriptions.md), [bundles/](references/03-endpoints/bundles/), [rotating-products/](references/03-endpoints/rotating-products/) |
| Migrate from Recharge | Migration guide | [self-serve-migration-guide-for-recharge.md](references/08-platform-integrations/self-serve-migration-guide-for-recharge.md) |
| Customize Subscription Manager (the widget) | Subscription Manager docs | [subscription-manager/](references/06-subscription-manager/) |
| Choose REST vs GraphQL | Decision guide | [rest-vs-graphql.md](references/05-graphql/queries/rest-vs-graphql.md) |

## Things to avoid

- **Don't construct URLs by guessing.** Always look the path up in [`references/03-endpoints/INDEX.md`](references/03-endpoints/INDEX.md). Several endpoints look intuitive but use unusual paths (e.g. one-time-incentives live under `/one_time_incentives/`, not `/otd/`; subscription creation in-order is `/subscriptions/iu/`; item create-in-order is `/items/iu/`).
- **Don't mix REST `snake_case` with GraphQL `camelCase`.** They're separate APIs.
- **Don't paste request bodies that aren't JSON-encoded for Purchase POST.** Purchase POST uses an HTTP form with a single field `create_request` whose value is a URL-encoded JSON string. The `Content-Type` is `application/json` despite the form-style body. (Yes, this is unusual — see [purchase-post.md](references/03-endpoints/purchase-post/purchase-post.md).)
- **Don't omit `merchant_id` / `merchant_order_id` / `session_id`** on Purchase POST — these are required and validate synchronously even though the rest of the call is async.
- **Don't expect synchronous results from Purchase POST.** It returns a `subs_req_id`; poll `GET sc.ordergroove.com/subscription/{subs_req_id}/response` for the result. See [purchase-post-status.md](references/03-endpoints/purchase-post/purchase-post-status.md).
- **Don't ignore `423 Resource is currently in use`** — retry with a small backoff. Happens often when multiple updates target the same subscription concurrently.
- **Don't assume a key has Bulk Operations permission.** Without it, list endpoints scope to a single customer.

## Sandbox / testing

OrderGroove provides a Sandbox Store for safe testing. See [`references/08-platform-integrations/sandbox-store.md`](references/08-platform-integrations/sandbox-store.md). Webhooks have a built-in "Send test events" feature in the OG admin — see [`references/04-webhooks/webhooks-overview.md`](references/04-webhooks/webhooks-overview.md).

## When the docs disagree with each other

The OpenAPI definition at the bottom of each `references/03-endpoints/**/*.md` file is the canonical contract. If the prose table and the OpenAPI block conflict (rare but possible — the docs are auto-generated from the OpenAPI), trust the OpenAPI.

If something looks wrong or missing, check `references/05-graphql/page-html-archive/` for the original HTML exports — they may contain newer descriptions for some types.

## When information truly isn't here

The embedded docs cover the public OrderGroove developer site as of the most recent export. They do **not** include:
- The OrderGroove admin UI (operational dashboard, not API).
- Internal/private OG endpoints not on developer.ordergroove.com.
- Pricing, contracts, or non-technical content.

For those, point the user to their OG account manager or `https://help.ordergroove.com`. Do not invent endpoints, fields, or payloads — say "not in the embedded docs" and stop.

## Related skills

OrderGroove is layered onto a commerce storefront. For the host platform:

- **`magento2-development`** — integrating OrderGroove into a **Magento 2 / Adobe Commerce** store (backend: modules, plugins, the quote/order flow, REST / GraphQL).
- **`hyva-magento2-development`** — rendering the OrderGroove **Subscription Manager** and subscribe widgets on a **Hyvä** storefront (Tailwind + Alpine.js).
