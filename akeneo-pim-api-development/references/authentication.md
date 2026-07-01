# Authentication

Akeneo has **two completely different OAuth2 flows**, and picking the wrong one is the #1 integration failure. This reference covers both in full, with copy-pasteable requests.

- **Connection** (a.k.a. **Connector**) — OAuth2 **password grant**. A short-lived (1-hour) bearer token plus a 14-day refresh token. For single-tenant back-office/ERP integrations you control, on-prem CE/EE, and the Magento 2 connector.
- **App** — OAuth2 **authorization-code grant** with a **code challenge** (not the raw secret). A **non-expiring** token. For App Store / multi-tenant / SaaS apps, and the only path with OpenID Connect user identity.

Throughout, `{pim}` is *your* PIM host (e.g. `https://my-pim.cloud.akeneo.com`) — never `api.akeneo.com`, which is the docs site.

## Comparison at a glance

| | **Connection** (Connector) | **App** |
| --- | --- | --- |
| OAuth2 grant | `password` (+ `refresh_token`) | `authorization_code` with a **code challenge** |
| Token endpoint | `POST {pim}/api/oauth/v1/token` | `POST {pim}/connect/apps/v1/oauth2/token` |
| Authorize step | none (direct token request) | `GET {pim}/connect/apps/v1/authorize?...` (user consent) |
| Client auth | `Authorization: Basic base64(client_id:secret)` | `code_challenge = sha256(code_identifier + client_secret)` |
| Extra credentials | API **username + password** | authorization `code` + random `code_identifier` |
| Access-token life | **1 hour** (`expires_in: 3600`) | **No expiration** (revocable by a PIM user) |
| Renewal | `refresh_token` (14 days) | none — re-run the whole flow if revoked |
| Scopes | connection permissions/ACLs (UI) | space-separated `scope` list in the authorize request |
| User identity | n/a | optional **OpenID Connect** (`id_token`) |
| SaaS spec scheme | `basicToken` → `bearerToken` | `appToken` |

**When to use which:** if you're building one integration against one PIM you administer (ERP sync, on-prem, the connector), use a **Connection** — it's the fastest to stand up. If you're distributing an app to many PIM tenants (App Store or custom App per customer), or you need to authenticate the PIM user, use an **App**.

---

# Model A — Connection (password grant)

## Where credentials come from

Create a **Connection** in the PIM UI: **Connect → Connection settings → Create**, give it a label (e.g. `ERP`), pick a flow type, save. The `Credentials` section then gives you two pairs:

- **client ID** + **secret** — identify the connection; used for the `Authorization: Basic` header and to refresh tokens.
- an auto-generated **API username** + **password** — the API user whose permissions the token inherits.

You need **all four** to get a token. The password is shown only once; there's a **Regenerate** button if you didn't save it. If a secret leaks, revoke and regenerate it from the same screen.

> The token you get inherits the **permissions of the API user** (its role's Web-API ACLs, and — on EE — its user-group catalog permissions). Give API users dedicated roles; a role needs at least the **Overall Web API access** ACL to call the API at all. See `references/sources/akeneo-official-docs/rest-api/permissions.md`.

## Request a token

Base64-encode `client_id:secret` (joined by a colon) for the Basic header, then POST the API user's `username`/`password` with `grant_type=password`:

```bash
curl -X POST {pim}/api/oauth/v1/token \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(printf '%s:%s' "$CLIENT_ID" "$SECRET" | base64)" \
  -d '{
        "grant_type": "password",
        "username": "your_API_username",
        "password": "its_password"
      }'
```

`Content-Type: application/x-www-form-urlencoded` is also accepted. Response:

```json
{
  "access_token": "NzFiYTM4ZTEwMjcwZTcyZWIzZTA0NmY3NjE3MTIyMjM1Y2NlMmNlNWEyMTAzY2UzYmY0YWIxYmUzNTkyMDcyNQ",
  "expires_in": 3600,
  "token_type": "bearer",
  "scope": null,
  "refresh_token": "MDk2ZmIwODBkYmE3YjNjZWQ4ZTk2NTk2N2JmNjkyZDQ4NzA3YzhiZDQzMjJjODI5MmQ4ZmYxZjlkZmU1ZDNkMQ"
}
```

| Field | Meaning |
| --- | --- |
| `access_token` | Include on every REST call as `Authorization: Bearer <token>`. |
| `expires_in` | Token lifespan in seconds. Default **3600 (1 hour)**. |
| `refresh_token` | Used only to renew the `access_token`. Default lifespan **1209600 s (14 days)**. |
| `token_type` | Always `bearer`. |

## Use the token

```bash
curl {pim}/api/rest/v1/categories \
  -H "Authorization: Bearer NzFiYTM4ZTEwMjcwZTcyZWIzZTA0NmY3NjE3..."
```

> **Only two routes need no token:** the REST API root (`GET {pim}/api/rest/v1`, which lists available endpoints) and the token route itself. Everything else requires the Bearer header.

## Refresh an expired token

When the 1-hour `access_token` expires, exchange the `refresh_token` (same Basic header, `grant_type=refresh_token`):

```bash
curl -X POST {pim}/api/oauth/v1/token \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(printf '%s:%s' "$CLIENT_ID" "$SECRET" | base64)" \
  -d '{
        "grant_type": "refresh_token",
        "refresh_token": "MDk2ZmIwODBkYmE3YjNjZWQ4ZTk2NTk2N2JmNjkyZDQ4..."
      }'
```

The response is the same shape as the initial token, with a **new** `access_token` **and a new** `refresh_token` — store both; the old refresh token is spent. Don't request a brand-new token on every call: cache the access token and refresh it near expiry.

## Old PIM versions (≤ 3.x)

Credential generation differs on legacy on-prem PIMs (the token request itself is identical):

- **v2.x / 3.x** — create an **API connection** under **System → API connections → Create**; the client ID/secret appear in the grid. Revoking deletes the whole API connection. (API *users* are created separately under **System → Users** — use dedicated API users, not UI users.)
- **v1.7** — no UI; generate credentials on the server with the console command:
  ```bash
  php app/console pim:oauth-server:create-client \
      --grant_type="password" --grant_type="refresh_token" \
      --env=prod --label="ERP connection"
  ```
  Companion commands: `pim:oauth-server:list-clients` and `pim:oauth-server:revoke-client <client-id>` (both `--env=prod`).

On modern PIMs (> 3.0 / SaaS) always use the **Connect → Connection settings** flow above.

---

# Model B — App (authorization-code + code challenge)

An App is authorized by an Akeneo user through a consent screen, then exchanges a one-time `code` for a **permanent** access token. Instead of sending the raw client secret in the token request, the App proves its identity with a **code challenge** derived from the secret.

## Step 1 — Get client credentials

Creating an App (custom App in your sandbox, or a published App via the App Portal) yields a **client ID** and **client secret**. During development, create a **custom App**: **Connect → App Store → Create an App**, provide an **Activate URL** and a **Callback URL**, then copy the generated credentials. (Publishing later goes through <https://manage.apps.akeneo.com/>.)

## Step 2 — Ask for authorization

When a user clicks **Connect**, they hit your **activation URL** with the originating PIM in the query:

```
https://my-app.example.com/oauth/activate?pim_url=https%3A%2F%2Fmy-pim.cloud.akeneo.com
```

Your activation endpoint redirects the user to the PIM's authorize URL:

```
GET {pim}/connect/apps/v1/authorize?
      response_type=code&
      client_id=[OAUTH_CLIENT_ID]&
      scope=[SPACE_SEPARATED_SCOPES]&
      state=[RANDOM_STRING]
```

| Query param | Notes |
| --- | --- |
| `response_type` | Required. Always `code`. |
| `client_id` | Required. From your App credentials. |
| `scope` | Optional. Space-separated (e.g. `write_products read_assets`). Write implies read. See the scope tables below. |
| `state` | Recommended. A random string; **validate it matches** on the callback to prevent CSRF. |

The PIM shows a consent prompt. On approval, the user is redirected to your **callback URL** with the authorization code:

```
https://my-app.example.com/oauth/callback?code=[AUTHORIZATION_CODE]&state=[STATE]
```

Confirm `state` is identical to what you sent.

## Step 3 — Build the code challenge

To validate the App identity, the PIM requires a unique **code challenge** on each token request instead of the client secret:

- `code_identifier` — a high-entropy cryptographic random string.
- `code_challenge` — `sha256( code_identifier + client_secret )`.

```php
$codeIdentifier = bin2hex(random_bytes(30));
$codeChallenge  = hash('sha256', $codeIdentifier . '[CLIENT_SECRET]');
```

Equivalents in other languages:

```javascript
// Node.js
import crypto from "node:crypto";
const codeIdentifier = crypto.randomBytes(30).toString("hex");
const codeChallenge  = crypto.createHash("sha256")
  .update(codeIdentifier + CLIENT_SECRET).digest("hex");
```

```python
# Python
import os, hashlib
code_identifier = os.urandom(30).hex()
code_challenge  = hashlib.sha256((code_identifier + CLIENT_SECRET).encode()).hexdigest()
```

## Step 4 — Exchange the code for a token

POST to the App token endpoint, form-encoded. Note there is **no** client secret in the body — the `code_challenge` stands in for it:

```bash
curl -X POST {pim}/connect/apps/v1/oauth2/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "client_id=[OAUTH_CLIENT_ID]" \
  --data-urlencode "code_identifier=[CODE_IDENTIFIER]" \
  --data-urlencode "code_challenge=[CODE_CHALLENGE]" \
  --data-urlencode "code=[AUTHORIZATION_CODE]" \
  --data-urlencode "grant_type=authorization_code"
```

Success:

```json
{
  "access_token": "Y2YyYjM1ZjMyMmZlZmE5Yzg0OTNiYjRjZTJjNjk0ZTUxYTE0NWI5Zm",
  "token_type": "bearer",
  "scope": "read_products write_products"
}
```

- The **access token has no expiration date** — but it's **revocable** by a PIM user at any moment. There is **no refresh token**: if it's revoked, you re-run the whole authorization flow to get the user to grant a new one. **Store it securely.**
- The authorization `code` is short-lived: retrieve the token **within ~30 seconds** or you get

```json
{ "error": "invalid_grant", "error_description": "Code has expired" }
```

## Step 5 — Call the API

Same as any bearer token:

```bash
curl {pim}/api/rest/v1/products-uuid \
  -H "Authorization: Bearer Y2YyYjM1ZjMyMmZlZmE5Yzg0OTNiYjRj..."
```

## OpenID Connect — authenticate the user (optional)

To identify the PIM user connecting to your App, request the **OpenID scopes** (`openid email profile`) *in addition to* your authorization scopes during the **same** authorize request:

```
GET {pim}/connect/apps/v1/authorize?
      response_type=code&
      client_id=[OAUTH_CLIENT_ID]&
      scope=openid email profile read_products write_products&
      state=[STATE]
```

The token response then also carries an **`id_token`** (a JWT, `header.payload.signature`, signed **RS256**):

```json
{
  "access_token": "Y2YyYjM1ZjMyMmZlZmE5Yzg0OTNiYjRjZTJjNjk0ZTUxYTE0NWI5Zm",
  "token_type": "bearer",
  "scope": "openid email profile read_products write_products",
  "id_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRw...XcmmANmSC2RHqWOI"
}
```

### Decode and verify

Use a JWT library with **RS256** support — don't hand-roll it. Decoded payload:

```json
{
  "iss": "https://my-pim.cloud.akeneo.com",
  "jti": "c76d558d-d10a-4bac-b320-12c22e36b3db",
  "sub": "c6acd619-8a08-46c2-9a5e-41a175d9149d",
  "aud": "206f450e-09a1-44ed-a0b3-9dd80f980ace",
  "iat": 1643029678.467703,
  "exp": 1643033278.467703,
  "email": "john.doe@example.com",
  "email_verified": false,
  "firstname": "John",
  "lastname": "Doe"
}
```

| Claim | Meaning |
| --- | --- |
| `iss` | Token issuer (the PIM URL). |
| `jti` | Unique token id. |
| `sub` | **Unique, stable user id (a PPID).** The only claim you should use to identify a user. |
| `aud` | Your OAuth2 client id. |
| `iat` / `exp` | Issued-at / expiry timestamps. |
| `email`, `firstname`, `lastname` | Present only if you requested (and the user granted) `email` / `profile`. |
| `email_verified` | **Always `false`** — Akeneo does not verify emails. |

> `email`, `firstname`, `lastname` are user-editable and unverified — never treat them as a golden record. Identify users by **`sub`** only.

**Verify the signature** against the PIM's public key at `{pim}/connect/apps/v1/openid/public-key`. Akeneo rotates the key pair periodically, so **always fetch the latest** public key when validating (don't cache it indefinitely). OpenID is optional — you may use your own authentication instead.

## Updating an App's scopes

If your App later needs more scopes, it must run a **fresh authorization request listing all scopes it needs** (including already-granted ones); the flow ends with a new access token reflecting the updated scopes. There's no partial add.

To nudge users, notify the PIM that your required scopes changed:

```bash
curl -X POST "{pim}/connect/apps/v1/scopes/update?scopes=read_products%20write_products%20read_assets" \
  -H "Authorization: Bearer [APP_ACCESS_TOKEN]" \
  -H "Content-Type: application/json"
```

> This endpoint **only notifies** — it does **not** grant scopes. The actual grant still happens through a new authorization request. Also note: some PIM users aren't allowed to grant new scopes, so your App must keep working without them — don't force an authorization loop.

---

# Authorization scopes

Sent (space-separated) in the App authorize request. Any **write** scope implies the matching **read**. Scopes tagged **EE** require Enterprise Edition / Serenity.

| Scope | Grants access to |
| --- | --- |
| `read_products` | Read products |
| `write_products` | Write products |
| `delete_products` | Remove products |
| `read_catalog_structure` | Read attributes, attribute groups, families and family variants |
| `write_catalog_structure` | Write attributes, attribute groups, families and family variants |
| `read_attribute_options` | Read attribute options |
| `write_attribute_options` | Write attribute options |
| `read_categories` | Read categories |
| `write_categories` | Write categories |
| `read_channel_localization` | Read locales and currencies |
| `read_channel_settings` | Read channels |
| `write_channel_settings` | Write channels |
| `read_association_types` | Read association types |
| `write_association_types` | Write association types |
| `read_catalogs` | Read app catalogs |
| `write_catalogs` | Write app catalogs |
| `delete_catalogs` | Remove app catalogs |
| `read_asset_families` *(EE)* | Read asset families |
| `write_asset_families` *(EE)* | Write asset families |
| `read_assets` *(EE)* | Read assets |
| `write_assets` *(EE)* | Write assets |
| `delete_assets` *(EE)* | Remove assets |
| `read_reference_entities` *(EE)* | Read reference entities |
| `write_reference_entities` *(EE)* | Write reference entities |
| `read_reference_entity_records` *(EE)* | Read reference entity records |
| `write_reference_entity_records` *(EE)* | Write reference entity records |
| `read_workflows` *(EE)* | Read workflows and their steps |
| `read_workflow_step_assignees` *(EE)* | Read assignees for workflow steps |
| `read_workflow_tasks` *(EE)* | Read workflow tasks |
| `write_workflow_tasks` *(EE)* | Write workflow tasks |
| `create_suggestions` *(EE)* | Create suggestions |
| `read_suggestions` *(EE)* | Read suggestions |
| `manage_suggestions` *(EE)* | Manage suggestions |

# Authentication scopes (OpenID Connect)

| Scope | Grants access to |
| --- | --- |
| `openid` | Read user id (`sub`) |
| `profile` | Read user first name and last name (from the PIM user profile) |
| `email` | Read user email (from the PIM user profile) |

---

# Common 401 / 403 causes

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `401` on the **token request** | Wrong `Authorization: Basic` value — must be `base64(client_id:secret)`, not the API user creds | Rebuild the Basic header from client ID + secret. |
| `401` on **API calls** after ~1 hour (Connection) | Access token expired (`expires_in: 3600`) | Refresh with `grant_type=refresh_token`. |
| `401` using **Basic** on a data endpoint | Wrong header form — Basic is only for the token route | Use `Authorization: Bearer <access_token>` on `/api/rest/v1/*`. |
| `401` / `invalid_grant` on App token exchange | `code` expired (>30 s), or `code_challenge` ≠ `sha256(code_identifier + client_secret)` | Exchange the code immediately; recompute the challenge with the exact secret. |
| `401` after an App was working | Token **revoked** by a PIM user (App tokens don't expire but are revocable) | Re-run the full authorization flow. |
| `403` on a specific resource | Missing App **scope**, or Connection API user lacks the ACL / EE catalog permission | Add the scope (re-authorize) or grant the role/group permission. |
| `403` on write, read works | Read-only EE catalog permission, or write scope not granted | Grant write on the category/attribute-group, or add the `write_*` scope. |
| `404` where you expected data (EE) | EE **catalog permissions** hide products in categories your API user can't view | Grant the user group view/edit/own on the category. |
| Auth "just doesn't work" | **Wrong auth model** — hitting `/api/oauth/v1/token` for an App, or `/connect/apps/v1/oauth2/token` for a Connection | Match the endpoint to the model (see the table up top). |

For error-body shapes and status codes generally, see `errors-and-rate-limits.md`; for App building beyond auth (activation/callback, UI Extensions, publishing), see `apps-and-connections.md`.

## Original sources

- `references/sources/akeneo-official-docs/rest-api/authentication.md` — Connection password grant, Basic header, token/refresh requests and responses, `expires_in` 3600, refresh 1209600 s, the two unauthenticated routes.
- `references/sources/akeneo-official-docs/rest-api/authentication_old.md` — credential generation on ≤ 3.x PIMs (v2.x/3.x API connections; v1.7 console commands).
- `references/sources/akeneo-official-docs/rest-api/permissions.md` — API-user ACLs (Overall Web API access) and EE catalog permissions enforced via the token.
- `references/sources/akeneo-official-docs/apps/authentication-and-authorization.md` — App authorization-code flow, code challenge (PHP snippet), non-expiring token, OpenID id_token/payload/public-key, scope tables, scope-update notify.
- `references/sources/akeneo-official-docs/tutorials/guides/how-to-get-your-app-token.md` — end-to-end App activation/callback walkthrough and token response.
- `references/sources/openapi-specs/saas-openapi.json` — `basicToken` / `bearerToken` / `appToken` security schemes; `POST /api/oauth/v1/token`.
- `SKILL.md` — the two auth models, endpoints, token lifespans.
