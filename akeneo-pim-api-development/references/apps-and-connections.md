# Apps, Connections & UI Extensions

Two ways to integrate a third party with Akeneo PIM — a **Connection** (the classic connector model) or an **App** (the modern, SaaS-compliant model) — plus **UI Extensions**, a lightweight way to inject links, iframes, actions, and panels into the PIM interface itself.

This file covers *which* integration model to choose, how to build and publish an App, and the full UI-Extensions surface. The OAuth **mechanics** (authorization-code + code challenge, OpenID, scopes, the Connection password grant) live in `authentication.md`; the **catalogs** feature Apps use to read mapped product data lives in `catalogs-and-mapping.md`. This page summarizes both where they touch the App lifecycle and points onward.

> **Heads-up on the App Store.** Nearly every App-Store / App-Portal doc page now carries the notice: *"we are not actively accepting new submissions"* (Akeneo will support partners with a defined joint business case). **Custom apps and UI Extensions are unaffected** — you can still build, connect, and run them against any PIM. Only public App-Store *listing* is gated.

## App vs Connection: which model?

Akeneo has two integration credentials. Picking the model is upstream of picking an auth flow (see `authentication.md` for the flows themselves).

| | **Connection** ("Connector") | **App** (custom or App-Store) |
| --- | --- | --- |
| Where credentials come from | *Connect → Connection settings* in the PIM | The customer's PIM (custom app) **or** the App Portal (App-Store app) |
| Auth flow | `password` grant → `POST {pim}/api/oauth/v1/token` (1h token + 14d refresh) | `authorization_code` + code challenge → `POST {pim}/connect/apps/v1/oauth2/token` (non-expiring token) |
| In-PIM activation UX | none — you hand credentials to a back-office job | streamlined **Connect** button; user grants scopes in a wizard |
| Catalogs for Apps | no | **yes** — user-configured product selection + mapping (see `catalogs-and-mapping.md`) |
| OpenID user identity | no | **yes** (optional `openid`/`profile`/`email` scopes → `id_token`) |
| Multi-tenant / marketplace | awkward (per-instance credentials) | designed for it |
| Best for | ERP / back-office / on-prem jobs, the **Magento 2 connector** | SaaS integrations, App-Store products, one-off "custom" needs |

**Why Apps over Connectors.** An App connects "directly from within PIM, with a streamlined process of activation and configuration." Beyond OAuth 2.0, an App benefits from **catalogs for apps** (get a pre-filtered, pre-mapped product selection the user configures in their own PIM — so you never build a filtering UI), can read/write via the **REST API, GraphQL API, and Event Platform**, and can authenticate PIM users via **OpenID Connect**. A Connection is still the right tool for server-to-server back-office integrations (and is what the Akeneo→Magento connector uses).

### Custom App vs App-Store (SaaS) App

Both are technically Apps — same OAuth flow, same features. The difference is *where you get credentials* and *who can install it*:

- **Custom app** — bespoke, **single-tenant** (one custom app = one PIM instance), full developer control. You get credentials from your **customer's PIM**, not the App Store, and connect it **without publishing**. Ideal when no on-the-shelf App on the App Store meets the exact need. You still "benefit from all app features without publishing it."
- **SaaS app** (App-Store app) — **multi-tenant**, standardized functionality, published on the Akeneo App Store for quick install by many customers (trade-off: limited per-customer customization).

Regardless of type, **you host, update, and maintain the app** — Akeneo does not run your server (Custom Components are the one exception; see below). Note the practical order: *"once you begin developing your app, you will need to use the custom app journey to add the URL of your app in the PIM… for testing. After your app has been submitted for Akeneo's validation, you can then decide whether you want to list it as a custom app or a SaaS app."*

### App lifecycle at a glance

1. **Build** the app and expose its two URLs (activate + callback — see below).
2. **Create a custom app** in a PIM developer sandbox to get a `client_id`/`client_secret` and test the connect flow. (Requires the *"Create and delete custom apps"* role permission — *System → Roles → Permissions → Connect*.)
3. **Implement the OAuth activation flow** → obtain a permanent access token (mechanics in `authentication.md`).
4. *(App-Store path only)* **Create an app record** in the App Portal, fill in listing info, and **submit for review** (security + UX).
5. **Approved → live** on the in-PIM App Store; users discover and **Connect** it themselves.
6. **Monitor** activations and pageviews via the App Portal.

## Building an App

### The two required URLs

Every App integration declares two public HTTPS endpoints (validated at submission; must be publicly reachable):

- **Activate URL** — where the PIM redirects the user when they click **Connect**. The originating PIM is passed as a query param, so a multi-tenant app knows which host to authorize against:
  ```http
  https://my-app.example.com/oauth/activate?pim_url=https%3A%2F%2Fmy-pim.cloud.akeneo.com
  ```
  From here your app starts the Authorization Request by redirecting the user to the PIM's authorize endpoint (with `response_type=code`, `client_id`, space-separated `scope`, and a random `state`):
  ```http
  https://my-pim.cloud.akeneo.com/connect/apps/v1/authorize?response_type=code&client_id=[ID]&scope=[SCOPES]&state=[STATE]
  ```
- **Callback URL** — where the PIM redirects the user at the end of the consent wizard, carrying the authorization `code` and your `state`:
  ```http
  https://my-app.example.com/oauth/callback?code=[AUTHORIZATION_CODE]&state=[STATE]
  ```
  Your server then exchanges that `code` for a **permanent access token** at `POST {pim}/connect/apps/v1/oauth2/token`, substituting the client secret with a `code_identifier` + `code_challenge` (= `sha256(code_identifier + client_secret)`). Full request/response, error handling, OpenID, and scope tables are in `authentication.md`.

### The connect / activation flow (summary)

```
user clicks Connect
   → PIM redirects to  Activate URL  (?pim_url=…)
   → app redirects to  {pim}/connect/apps/v1/authorize  (response_type=code, scope=…, state=…)
   → user reviews & grants scopes in the PIM wizard
   → PIM redirects to  Callback URL  (?code=…&state=…)      ← validate state matches
   → app POSTs to  {pim}/connect/apps/v1/oauth2/token       (code + code_identifier + code_challenge)
   → app stores the non-expiring access_token  (add openid/email/profile scopes to also get an id_token)
```

Tokens are **non-expiring but revocable** by a PIM user; there is no refresh — if revoked, re-run the flow. The code is short-lived (the token request must complete within ~30 s or you get `invalid_grant: Code has expired`).

### Creating a custom app to get credentials

From the target PIM: *Connect → App Store → **Create an App*** (if the button is missing, enable the *"Create and delete custom apps"* permission on your role). Fill in the **Activate URL** and **Callback URL**, click **Create**, then **copy the `client_id`/`client_secret`** (shown once) into your app config, and click **Done**. The custom app then appears in the App Store page and can be connected like any App. Credentials can be rotated later via *Connect → Connected app → **Regenerate***.

### Developer tools & starter kit

- **Start App / Sample Apps** — Akeneo's `github.com/akeneo/sample-apps` bootstraps a working App in **PHP, Node.js, or Python** with predefined authorization scopes and the activate/callback endpoints already wired. Recommended starting point over hand-rolling OAuth.
- **App developer starter kit** — a PIM developer sandbox to build and test against.
- **ngrok** (or any tunnel) — during local dev, expose your app over a public HTTPS URL so the PIM can reach your activate/callback endpoints (`ngrok http 8000`), and register that URL as the custom app's URLs.
- **Postman collection** — `api.akeneo.com/files/akeneo-postman-collection.json` mirrors the REST surface (used below for the Extensions API too).

### Securing your app

Publication-security requirements (also good practice for custom apps):

- **Least-privilege scopes** — request only the OAuth scopes the app actually needs (full scope list in `authentication.md`).
- **Secrets management** — store the access token and `client_id`/`client_secret` in a dedicated secrets manager (store/rotate/monitor); follow OWASP secret-management guidance. API calls run server-side; never expose secrets to a browser.
- **Code & dependency hygiene** — no known CVEs in third-party deps; patch promptly; OWASP Top Ten SAST; Source Composition Analysis.
- **Container hardening** — CIS benchmarks for any Docker images.
- **Fair use** — comply with the PIM API fair-usage limits.

## The App Portal (publish path)

The **App Portal** (`manage.apps.akeneo.com`) is where partners manage listings, submit to the App Store, and view analytics. Its sections: **Dashboard** (analytics + your app list), **Activations**, **Leads**, **Ratings & Reviews** (not yet live), **My company** (profile + members), **Dev resources**, and **Technical blog**.

**Portal workflow:** create your account (from an Akeneo invite email) → add members & assign roles → **add your app** (create an app record) → test & submit → monitor status & usage. You don't need a finished app to create the record.

### Create an app record

From **Dashboard → Create a new App**, choose the **App type**, enter a **name**, and agree to the App Store T&Cs. On creating, the portal shows a **Display app credentials** button — **save the `client_id`/`client_secret` immediately** (recoverable only by regenerating). You can then fill in all listing fields. (Roles: *Partner administrator* or *Partner developer*.) Apps can be **deleted** only while in **Draft** or **Rejected** status.

### Publish (submit for review)

Submission runs through the HelpDesk: register, review requirements, request App Portal access, **submit**, then open tickets for a **Security Review** and a **UX Review**; await approval. Key listing requirements:

- **App name** — must contain the third-party software's name (and your company name if you're an integrator); **must not** contain the "Akeneo" trademark; 70 chars max; no marketing jargon.
- **Version** — SemVer, or literally `SaaS` for continuously deployed apps.
- **Logo, short description, description, visuals, categories** — mandatory; optional video, slug, release notes, price model (Free / Fixed / Quote-based), feature list.
- **Activation button setup** — the **Activate URL** and **Callback URL** (double-check both are public before submitting).
- **Requirements** — declare the **PIM editions/versions** the app supports. This is strategic: the in-PIM App Store **only shows your app on the editions/versions you declare** (derive them from the API endpoints you call and their compatibility). Keep this current after each PIM release.
- **Help & support, documentation** — English, install + user guide + known limits.
- **Security** — code scanning (SCA, secrets scanning, OWASP SAST, Docker scan) *or* a recent pen-test summary *or* a security questionnaire.

### Availability, notifications, team, performance

- **Availability** — the general flow: fill info → **Submit** (status → *Submitted*) → resolve any reviewer feedback in the **Activity** section → after approval it can take **up to 24 h to go live**. Only an **Akeneo administrator** can remove a published app (request via the Helpdesk).
- **Notifications** — subscribe (per user profile) to **app activation requests** and **new submissions**.
- **Team** — manage members in **My company**; two roles: **Partner administrator** (all app info + company/member management) and **Partner developer** (all app info; create/edit/submit/delete apps). A user has exactly one role.
- **Performance** — **App Analytics** on the Dashboard/Activations sections reports past-week **pageviews** and **activations**.

### From custom app → App-Store app

Develop and validate as a **custom app** (connected to a real PIM sandbox, no listing) → create an **app record** in the App Portal → **submit for review** (security + UX) → **approved → live** on the App Store where any customer can discover and connect it. Per the overview, the custom-app journey is the required *testing* step, and you decide at submission time whether the integration is listed as a custom app or a SaaS app.

## Catalogs (pointer)

**Catalogs** are an App-only feature: a user-configured, pre-filtered **product selection** (by families, categories, etc.) that your app reads via `/api/rest/v1/catalogs/*`, optionally through a **product mapping schema** so you get data in *your* shape without building a filter or mapping UI. Limits: **200 catalogs/app**, **25 selection criteria/selection**, **600 mapping targets** (UI slows past ~200). An invalidated selection auto-disables the catalog (you get HTTP 200 with an `error` payload). Full detail — endpoints, the mapping schema versions, the `read_catalogs`/`write_catalogs`/`delete_catalogs` scopes — is in `catalogs-and-mapping.md`.

## UI Extensions

**UI Extensions** inject new features **directly into the PIM interface** — a button, an embedded page, a background action, or a data panel — to tailor the enrichment UX. They are managed in *PIM System → Extensions* or via the **Extensions REST API**, and are **owned by a Connection or an App** (they are not themselves an App). Division of responsibility: **Akeneo** owns the extension framework, its API, and the admin UI; **you** own any custom code, iframes, and their support.

### Extension types

Five types (`types-overview.md`):

| Type | What it does | Transport | Notes / limits |
| --- | --- | --- | --- |
| **Link** | Opens external content in a **new browser tab** | (navigation) | Simplest; always new-tab (not configurable) |
| **Action** | Runs a **background task** on user trigger | HTTP **POST** (JSON body) | 5 s timeout, no retries, no progress UI, ≤500 grid items, no concurrent re-run; optional `secret` signs the body (SHA-512) |
| **Data Component** | Fetches data and renders it in a PIM **panel** | HTTP **GET** | Read-only, JSON-only, no styling/interactivity, loads once (no auto-refresh) |
| **Iframe** ("Embedded view") | Embeds external content **inside** the PIM | iframe + query params / `postMessage` | Sends `user[*]`, `position`, `tenant`, and context (product/category/record) params; `postMessage` for grid selection, context changes, `reload_parent`, and JWT verification |
| **Custom Component** | A **JS app built with the Akeneo Extension SDK**, run in a secure **PIM-hosted** sandbox | SDK (authenticated) | Most powerful; **no external hosting** needed; auth uses the current user's session. See `advanced-extensions/` |

The first four are configuration-only (a URL + credentials + position). **Custom Component** is a real bundled JavaScript/TypeScript/React app you deploy to the PIM — the only type Akeneo hosts for you.

### Positions

An extension's **position** fixes where it renders; available positions depend on type (`positions.md`). Highlights:

- **Header** (`pim.product.header`, `pim.product-model.header`, `pim.sub-product-model.header`) — supported by **all** UI types (Link/Action/Iframe/Data/Custom).
- **Tabs** (`pim.product.tab`, `pim.product-model.tab`, `pim.category.tab`, `pim.reference-entity-record.tab`, `pim.activity.navigation.tab`, `pim.performance.analytics.tab`) — **Iframe / Data / Custom** only.
- **Panels** (`pim.product.panel`, `pim.product-model.panel`, `pim.sub-product-model.panel`) — Iframe / Data / Custom.
- **Grid action bar** (`pim.product-grid.action-bar`) — Action / Iframe / Data / Custom (bulk over selected products/models; ≤500 items; some filters not applied).
- **Product list menu** (`pim.product.index`) — **Action only** (the top-left menu of the product list page).

**Links** are limited to the three header positions; **Actions** add the grid action bar and the product-list menu.

### URL placeholders

For **Link**, **Action**, and **Data Component** extensions, the configured URL can embed `%attribute_code%` placeholders, replaced at click/trigger time with the product's values (`url-placeholders.md`):

- Always-available identifiers: **`%uuid%`** (products), **`%code%`** (product models), and any `identifier`-type attribute (e.g. `%sku%`).
- Any `text` / `textarea` attribute: `%name%`, `%description%`, custom text attrs.
- Placeholders work in the path or query, multiple per URL. Localizable/scopable attributes resolve against the **current user's locale/channel**. A missing value → empty string. (If the URL *begins* with a placeholder, its validity isn't checked.)

### Credentials

Extensions can call authenticated endpoints. Credentials are set per extension and sent as request headers; they are **encrypted at rest** and applied **server-side** (never exposed to the PIM front end) (`credentials.md`):

| Method | Header sent |
| --- | --- |
| Basic Authentication | `Authorization: base64_encode(username:password)` |
| Bearer Token | `Authorization: Bearer <token>` |
| Custom Credentials | `<custom_header_key>: <custom_header_value>` |

### Filtering & display

Restrict and order extensions (`filtering.md`): by **user group** (permissions tab; none = all users), by **product selection** (same filter builder as the product grid), or by **individual user email** (`userEmails` in the API config — handy for beta rollout). Multiple extensions in one position order by **weight** (lower first, then alphabetical). Statuses: **Active**, **Inactive**, and **To Update** (invalid/outdated config after a migration or missing credentials — not shown to users until fixed).

### The Extensions API

Manage extensions programmatically with the same capabilities as the UI (`api.md`). Authenticate with a **Connection or App** token; authorize via the Connection permission **"Extensions → Manage your extensions using the API"** or, for Apps, the **`manage_extensions`** scope. An extension is **owned by a user** — a Connection can manage only extensions it (or same-user Connections) created; an App only its own. Endpoints live under **`/api/rest/v1/ui-extensions`** (`POST` create, `PATCH /{uuid}` update, `DELETE /{uuid}`).

### Concrete example

The one-minute UI path: *PIM System → Extensions → **Create → Link***, give it a name (technical, no spaces) and label ("link to Google"), keep position **Product Header**, and set the URL `https://www.google.com/search?q=%uuid%`. Refresh a product page → a header button appears that opens Google with that product's UUID.

The same as an API call (a **Link** at the product header):

```bash
curl --request POST "$TARGET_PIM_URL/api/rest/v1/ui-extensions" \
  --header "Authorization: Bearer $PIM_API_TOKEN" \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "my_awesome_extension",
    "version": "V1.02",
    "type": "link",
    "position": "pim.product.header",
    "configuration": {
      "url": "https://myapp.com/product?sku=%sku%",
      "default_label": "My awesome extension",
      "labels": { "en_US": "My awesome extension" }
    }
  }'
```

An **Action** adds a `secret` (≥32 chars) to sign the POST body and a `credentials` array; an **Iframe** typically targets a `*.tab` position. Copy the returned extension **UUID** — it's required to `PATCH` or `DELETE` the extension.

## Pointers

- **OAuth mechanics** (App authorization-code + `code_challenge`, token request/response, OpenID `id_token`/`sub`, the full scope tables, and the Connection password grant) → `authentication.md`.
- **Catalogs API + product mapping schema** → `catalogs-and-mapping.md`.
- **Reading/writing catalog data** once connected (products, structure, pagination) → `rest-api-overview.md`, `products-and-models.md`, `catalog-structure.md`.
- **Custom Component SDK** deep-dive → the vendored `advanced-extensions/` docs.

## Original sources

Vendored under `references/sources/akeneo-official-docs/` (source commit `524078c…`):

- `apps/overview.md` — what an App is, how it fits the Product Cloud, Custom vs SaaS apps, hosting responsibility.
- `apps/create-custom-app.md` — custom app creation, role permission, credentials, regeneration.
- `apps/authentication-and-authorization.md` — OAuth 2.0 flow, activate/callback/authorize/token URLs, code challenge, OpenID, scope tables (mechanics summarized here, detailed in `authentication.md`).
- `apps/secure-your-app.md` — publication security requirements.
- `apps/app-developer-tools.md`, `apps/homepage.md` — Start App / sample-apps starter kit.
- `apps/catalogs.md` — catalogs-for-apps overview and limits (pointer).
- `apps/create-the-ux-of-your-app.md` — App UX guidelines (referenced for review criteria).
- `tutorials/guides/how-to-get-your-app-token.md`, `apps/create-app/activate-php.md` — end-to-end activation flow, ngrok tunnel, custom-app-in-sandbox testing.
- `app-portal/get-started.md`, `create-app-record.md`, `publish-your-app.md`, `manage-app-availability.md`, `manage-app-notifications.md`, `manage-your-team.md`, `measure-app-performance.md` — the App Portal path.
- `extensions/overview.md`, `getting-started.md`, `types-overview.md`, `link.md`, `action.md`, `iframe.md`, `data-component.md`, `positions.md`, `credentials.md`, `url-placeholders.md`, `filtering.md`, `api.md`, `faq.md` — UI Extensions.
- `advanced-extensions/overview.md` — Custom Component (SDK) extensions.
- Live docs: https://api.akeneo.com/apps/overview.html · https://api.akeneo.com/extensions/overview.html · App Portal https://manage.apps.akeneo.com/
