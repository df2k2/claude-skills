# Getting Started

The first encounter with Gelato. Sign up, generate an API key, understand the base URLs, make a first request. Everything that needs to happen before any other reference makes sense.

## Step 1: Sign up at gelato.com

- https://gelato.com → Sign up → fill in account details.
- Free to create an account; you only pay for orders you place.
- For production access (versus sandbox), you need to add a payment method or fund a wallet. Most accounts start in test mode and can place draft orders without funding.

## Step 2: Generate an API key

- Sign in to the Gelato Dashboard: https://dashboard.gelato.com/
- Navigate to https://dashboard.gelato.com/keys/manage
- Click **Create New API Key** (or similar — UI label varies).
- Name the key (e.g., "production", "staging", "ci-tests").
- Copy the key. **You only see it once.** Store it in your secrets manager.

You can create multiple API keys per account. Each is independent — revoking one doesn't affect others. Recommended pattern: one key per environment (production / staging / dev / each developer).

## Step 3: Understand the base URLs

The Gelato API is split across four hosts. There is no single root.

| Service | Base URL | Version |
| --- | --- | --- |
| Orders | `https://order.gelatoapis.com` | v4 (current), v3 (deprecated) |
| Product Catalog | `https://product.gelatoapis.com` | v3 (current) |
| Shipment Methods | `https://shipment.gelatoapis.com` | v1 |
| Ecommerce (stores, products, templates) | `https://ecommerce.gelatoapis.com` | v1 |

So a full URL is, e.g., `https://order.gelatoapis.com/v4/orders` — host + version + resource path.

The same API key authenticates calls to all four hosts.

> **Legacy**: `api.gelato.com/v2/...` was the original 2018-era endpoint. Don't use it for new code. Old SDKs (like `gelato-api/npm-gelato-api` v2-era) point at this. Migrate to the per-service hosts above.

## Step 4: Auth — `X-API-KEY` header

Every request requires:

```
X-API-KEY: <your-api-key>
```

Not `Authorization`, not `Bearer`, not query-string. Just `X-API-KEY` as a request header.

All requests must be over **HTTPS**. Plain HTTP is rejected.

Example request:

```bash
curl -X GET \
     -H 'X-API-KEY: 1234567890abcdef1234567890abcdef' \
     -H 'Content-Type: application/json' \
     https://shipment.gelatoapis.com/v1/shipment-methods
```

If auth fails you'll get `401 Unauthorized` with a JSON error body.

## Step 5: First request — list shipment methods

A safe "hello world" — read-only, no side effects, no money:

```bash
curl -X GET \
     -H 'X-API-KEY: $GELATO_API_KEY' \
     -H 'Content-Type: application/json' \
     https://shipment.gelatoapis.com/v1/shipment-methods?country=US
```

Expected response:

```json
{
  "shipmentMethods": [
    {
      "shipmentMethodUid": "ups_ground",
      "type": "normal",
      "name": "UPS Ground",
      "isBusiness": true,
      "isPrivate": true,
      "hasTracking": true,
      "supportedCountries": ["US"]
    },
    {
      "shipmentMethodUid": "ups_2nd_day_air",
      "type": "express",
      "name": "UPS 2nd Day Air",
      "isBusiness": true,
      "isPrivate": true,
      "hasTracking": true,
      "supportedCountries": ["US"]
    }
  ]
}
```

If you get this, your key works and your network can reach Gelato.

## Step 6: Second request — list catalogs

```bash
curl -X GET \
     -H 'X-API-KEY: $GELATO_API_KEY' \
     -H 'Content-Type: application/json' \
     https://product.gelatoapis.com/v3/catalogs
```

Returns a paginated list:

```json
{
  "data": [
    { "catalogUid": "apparel_product", "title": "Apparel" },
    { "catalogUid": "cards",           "title": "Cards" },
    { "catalogUid": "posters",         "title": "Posters" },
    { "catalogUid": "photobooks-hard", "title": "Hardcover Photo Books" }
  ],
  "pagination": { "total": 30, "offset": 0 }
}
```

Pick a catalog → list its products → capture a `productUid`. See `references/catalog-and-products.md` next.

## Step 7: Third request — quote an order (no side effect)

```bash
curl -X POST \
     -H 'X-API-KEY: $GELATO_API_KEY' \
     -H 'Content-Type: application/json' \
     -d '{
       "orderReferenceId": "test-quote-001",
       "customerReferenceId": "test-customer",
       "currency": "USD",
       "recipient": {
         "country": "US",
         "firstName": "Test",
         "lastName": "Customer",
         "addressLine1": "123 Main St",
         "city": "San Francisco",
         "postCode": "94103",
         "state": "CA",
         "email": "test@example.com"
       },
       "products": [
         {
           "itemReferenceId": "item-1",
           "productUid": "<a-real-productUid-from-the-catalog>",
           "quantity": 1
         }
       ]
     }' \
     https://order.gelatoapis.com/v4/orders:quote
```

A successful quote returns shipment options + per-line pricing. No order is created.

## Step 8: When you're ready to spend money — a real (draft) order

```bash
curl -X POST \
     -H 'X-API-KEY: $GELATO_API_KEY' \
     -H 'Content-Type: application/json' \
     -d '{
       "orderType": "draft",
       "orderReferenceId": "first-real-order-001",
       "customerReferenceId": "first-customer",
       "currency": "USD",
       "items": [
         {
           "itemReferenceId": "item-1",
           "productUid": "<real-productUid>",
           "files": [
             { "type": "default", "url": "https://your-cdn.example.com/print.pdf" }
           ],
           "quantity": 1
         }
       ],
       "shipmentMethodUid": "normal",
       "shippingAddress": {
         "firstName": "Test",
         "lastName": "Customer",
         "addressLine1": "123 Main St",
         "city": "San Francisco",
         "postCode": "94103",
         "state": "CA",
         "country": "US",
         "email": "test@example.com"
       }
     }' \
     https://order.gelatoapis.com/v4/orders
```

Because `orderType` is `"draft"`, this won't charge anything or enter production. Inspect it in the dashboard, fix any issues, then promote to a real order via Patch (`orderType: "order"`) or delete it.

## What you have now

- API key in env (`GELATO_API_KEY=...`).
- Confirmed access to all four hosts.
- A draft order you can iterate on.
- An understanding of which subdomain handles what.

Next steps:

- `references/orders-api.md` — full order lifecycle.
- `references/product-uid-format.md` — decoding the productUid scheme.
- `references/catalog-and-products.md` — finding the right product.
- `references/webhooks.md` — registering an endpoint for status callbacks.

## Common first-request failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| `401 Unauthorized` | Key missing, wrong, or revoked | Check `X-API-KEY` header, regenerate at dashboard.gelato.com/keys/manage |
| `403 Forbidden` | Key is for sandbox / different account, or account isn't permitted to call this endpoint | Verify scope; some endpoints require Gelato+ tier |
| `404 Not Found` on the host | Hitting `api.gelato.com` instead of the right subdomain | Switch to `order.gelatoapis.com` / etc. |
| `ENOTFOUND order.gelatoapis.com` | DNS / network blocked outbound | Allow outbound HTTPS to `*.gelatoapis.com` |
| `SSL_ERROR` | Old OpenSSL / Node | Use Node 18+ / a modern OpenSSL |
| `400 Bad Request` with no body | Forgot `Content-Type: application/json` on POST | Add the header |

## Storing your key

- **Never commit** the key to git. Use `.env` + `.gitignore`, a secrets manager (AWS Secrets Manager, Doppler, 1Password), or the host platform's environment variables (Vercel, Netlify, Heroku Config Vars, etc.).
- **Rotate** if leaked: revoke at `dashboard.gelato.com/keys/manage` and generate a new one. Sessions / connections are not affected (the key is stateless).
- **Use separate keys per environment** — never share a production key with staging or with CI.

## Original sources

- `references/sources/gelato-admin-node/README.md` — the SDK's getting-started prose (includes the same `https://dashboard.gelato.com/keys/manage` link).
- `references/sources/gelato-admin-node/src/client/http-client.ts` — confirms `X-API-KEY` header usage in the SDK.
- `references/sources/gelato-admin-node/src/utils/urls.ts` — base URL combinator (used throughout).
