# 02 — Authentication

Printful supports three authentication modes. **For new integrations, use the OAuth Bearer token (Personal Access Token).** The legacy store key still works on v1 but is being phased out.

## Mode 1 — Personal Access Token (OAuth Bearer, private app)

This is the right answer for almost every integration: a single merchant connecting their own store to their own backend.

### Creating a token

1. Sign in as the merchant at `https://www.printful.com`.
2. Go to `https://developers.printful.com/tokens` (or in the dashboard: **Settings → API Access**).
3. Click **Create token**.
4. Pick the store the token will be scoped to (one token = one store, unless you elevate via `stores_list` scope, see below).
5. Pick scopes. Default is read+write on everything; tighten with `*/read` variants where possible.
6. Choose an expiration (max ~1 year; can be "never" if the merchant disables the limit, but Printful's UI may require an expiration).
7. Copy the token starting with `pf_`, `smk_`, or another short prefix. **Printful displays it once — there is no "view secret" later.**

### Using the token

Send it on every request:

```http
GET /v2/orders HTTP/1.1
Host: api.printful.com
Authorization: Bearer pf_xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Works on **both v1 and v2** with the same syntax.

### Scopes

The OAuth scopes table (also returned by `GET /v2/oauth-scopes` for the currently-bound token):

| Scope | Includes |
|---|---|
| `orders` | Read + write access to orders, order items, shipments, invoices, order estimation tasks |
| `orders/read` | Read-only versions of the above |
| `stores_list` | Read + write access to multiple stores (required for multi-store apps) |
| `stores_list/read` | Read-only multi-store listing |
| `file_library` | Read + write access to the file library |
| `file_library/read` | Read-only file library |
| `webhooks` | Read + write access to webhooks (configure URL, secret, per-event enable/disable) |
| `webhooks/read` | Read-only webhook config |

There are also scopes that are inherent to a Personal Token without an explicit name (catalog access is implicit; shipping rates is implicit). The Printful UI lists every scope at token-creation time.

`GET /v2/oauth-scopes` returns the granted scopes for the bearer token. Useful for diagnostics:

```bash
curl https://api.printful.com/v2/oauth-scopes \
  -H "Authorization: Bearer $PF_TOKEN"
```

```json
{
  "data": [
    { "scope": "orders", "read_write": true },
    { "scope": "file_library", "read_write": false }
  ]
}
```

## Mode 2 — OAuth 2.0 Authorization Code (public app)

Use this when your service connects **multiple merchants** to Printful (a SaaS product, a marketplace, a custom storefront platform). Printful issues each merchant an access token bound to their store.

### Registering the app

1. Visit `https://developers.printful.com/dashboard/`.
2. Click **Create app**.
3. Provide:
   - **App name**, **icon**, **description** (shown on the merchant's consent screen).
   - **Redirect URI** — your HTTPS callback URL.
   - **Default scopes** — the minimum the app will request.
4. Save. Copy the **Client ID** and **Client Secret**.

### Authorization flow

```
        Merchant browser
              │
              │  1. GET https://www.printful.com/oauth/authorize
              │       ?client_id={CLIENT_ID}
              │       &redirect_uri={your callback URL}
              │       &response_type=code
              │       &scope=orders+webhooks+file_library
              │       &state={CSRF nonce}
              ▼
       Printful consent page
              │
              │  2. Merchant approves
              ▼
   Redirect back to your callback:
   GET {your callback}?code={AUTH_CODE}&state={CSRF nonce}
              │
              │  3. Your backend POSTs to token endpoint
              ▼
   POST https://www.printful.com/oauth/token
   Content-Type: application/x-www-form-urlencoded

   grant_type=authorization_code
   &code={AUTH_CODE}
   &redirect_uri={your callback URL}
   &client_id={CLIENT_ID}
   &client_secret={CLIENT_SECRET}
              │
              ▼
   {
     "access_token":  "{Bearer token}",
     "token_type":    "Bearer",
     "expires_in":    31536000,         // seconds; ~1 year
     "refresh_token": "{refresh}",
     "scope":         "orders webhooks file_library"
   }
```

Store the `access_token` (encrypted at rest), the `refresh_token`, and the `store_id` (call `GET /v2/stores` to discover it, or read the `state` you sent).

### Refreshing

When `expires_in` runs out (or you get a `401` with `token_expired` reason):

```http
POST https://www.printful.com/oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token
&refresh_token={REFRESH_TOKEN}
&client_id={CLIENT_ID}
&client_secret={CLIENT_SECRET}
```

Response is identical in shape to the initial token response.

### Acting on behalf of a store

A multi-store OAuth token can have access to several stores under the same Printful account. Pick the target store on each call:

```http
GET /v2/orders HTTP/1.1
Authorization: Bearer {token}
X-PF-Store-Id: 12345
```

Without `X-PF-Store-Id`, Printful picks the default store associated with the token. For tokens bound to a single store, the header is optional but harmless.

## Mode 3 — Legacy Store Key (HTTP Basic, v1 only)

Older integrations use a per-store API key passed as the **username** of HTTP Basic Auth, with an **empty password**:

```http
GET /orders HTTP/1.1
Authorization: Basic {base64("storekey:")}
```

```bash
curl https://api.printful.com/orders \
  -u 'storekey-32-chars-or-longer:'
```

The key looks like a 32+ char random string and is generated in the dashboard under **Settings → Stores → API**. It is read-write, has no scopes, and is permanent until rotated.

**Constraints**:
- Works on v1 paths only. v2 paths return `401`.
- Bound to a single store.
- No scopes — every store key has full read+write access.
- Deprecated for new integrations. Existing keys keep working.

Treat a leaked store key like a password — rotate it immediately in the dashboard if exposed.

### Using both auth methods in one client

The official PHP SDK switches between modes by helper:

```php
use Printful\PrintfulApiClient;

// Legacy
$pf = PrintfulApiClient::createLegacyStoreKeyClient($STORE_KEY);

// OAuth (works for both v1 and v2)
$pf = PrintfulApiClient::createOauthClient($BEARER_TOKEN);

// Call v1
$orders = $pf->get('orders', ['limit' => 10]);   // hits /orders

// Call v2 — just prefix the path with v2/
$orders = $pf->get('v2/orders', ['limit' => 10]); // hits /v2/orders
```

See [`sources/PrintfulApiClient.php`](sources/PrintfulApiClient.php) for the full transport (curl options, error handling, response decoding).

## CORS and client-side calls

The API does **not allow `Authorization: Bearer` calls from the browser** in the general case — `api.printful.com` does not send permissive CORS headers for arbitrary origins. Treat every Printful call as server-to-server. For client-side flows (e.g. a product designer that talks to your backend), build a thin proxy on your server that holds the token and forwards requests.

The only exception is the **Embedded Design Maker (EDM)** product, which has its own token system, short-lived design tokens, and CORS configured for its own JS bundle. That is a separate enterprise offering documented at `developers.printful.com/docs/edm/`.

## Authentication failure modes

| HTTP | v2 `type` | When |
|---|---|---|
| `401` | `…/#errors/unauthorized` | No `Authorization` header, or token is malformed |
| `401` | `…/#errors/token-expired` | Token has expired (refresh or recreate) |
| `401` | `…/#errors/token-revoked` | Merchant deauthorized the app, or token was deleted in dashboard |
| `403` | `…/#errors/forbidden` | Token lacks the required scope, or `X-PF-Store-Id` points at a store the token doesn't cover |
| `403` | `…/#errors/store-not-allowed` | Multi-store call without `stores_list` scope |

On v1 the failures collapse to a single `{"code": 401, "result": "..."}` body — inspect `result` for the human-readable reason.

## Where to store tokens

- **Personal Access Tokens**: encrypted at rest (e.g. AWS Secrets Manager, GCP Secret Manager, Hashicorp Vault). Never commit to git. Never log. Never send to the browser.
- **OAuth access tokens + refresh tokens**: encrypted, scoped to the merchant's account record in your database. Rotate via refresh token before they expire.
- **Webhook `secret_key`**: same level of protection as a token. It is the only thing that lets you verify webhook authenticity.

## Original sources

- OpenAPI `components.securitySchemes.OAuth` — see `sources/printful-v2-openapi.json`.
- v1 PHP SDK auth implementation: [`sources/PrintfulApiClient.php`](sources/PrintfulApiClient.php) (look at `setCredentials()`).
- Token UI: `https://developers.printful.com/tokens`.
- App registration UI: `https://developers.printful.com/dashboard/`.
