# Marketplace EQP REST API

The Marketplace EQP REST API gives programmatic access to everything the Marketplace Developer Portal does, minus a couple of UI-only operations (generating EQP API keys themselves, and generating Marketplace access keys). This reference covers auth, base URLs, the resource model, the most-used endpoint patterns, callbacks for state updates, batch semantics, and error handling. Use it when scripting Marketplace submission into CI/CD, or for any "I want to update a listing without opening a browser" task.

## Base URLs

| Env | URL |
| --- | --- |
| Production | `https://commercedeveloper-api.adobe.com` |
| Sandbox | `https://commercedeveloper-sandbox-api.adobe.com` |

The two are entirely separate — keys, tokens, profiles, listing IDs, callbacks. Decide upfront which you're scripting against.

Sandbox is partner-tier-only. Free sellers can still use the production API with their own EQP API access keys; they just can't rehearse against sandbox.

## API characteristics

- **HTTPS only** — HTTP is rejected.
- **JSON** for all responses; JSON for almost all request bodies (except file uploads, which use multipart).
- **REST verbs**: GET (read), POST (create), PUT (update; can act as PATCH), DELETE (remove).
- **Versioning**: all paths under `/rest/v1/`.
- **UTC** for all timestamps.
- **Batch-aware**: certain endpoints accept arrays of items in one request.

## Auth — two-step session token flow

The API uses Basic Auth on **one** endpoint (to exchange app credentials for a session token) and Bearer tokens on **every other** endpoint.

### Step 1: Get a session token

```http
POST /rest/v1/app/session/token
Authorization: Basic <base64(app_id:app_secret)>
Content-Type: application/json

{
  "grant_type": "session",
  "expires_in": 7200
}
```

Curl:

```bash
curl -X POST \
     -u 'AQ17NZ49WC:8820c99614d65f923df7660276f20e029d73e2ca' \
     -H 'Content-Type: application/json' \
     -d '{ "grant_type" : "session" }' \
     https://commercedeveloper-sandbox-api.adobe.com/rest/v1/app/session/token
```

Response:

```json
{
  "mage_id": "MAG123456789",
  "ust": "baGXoStRuR9VCDFQGZNzgNqbqu5WUwlr.cAxZJ9m22Le7",
  "expires_in": 7200
}
```

- `mage_id` — your Mage ID (the URL parameter for /users/ endpoints).
- `ust` — User Session Token. Treat as bearer.
- `expires_in` — seconds until expiry.

Notes:
- `grant_type` must be `session`. No other grant types.
- `expires_in` is requested duration; system may shorten if you exceed its max.
- You can have multiple concurrent active session tokens.
- Don't wait for a token to expire before getting another.
- Sandbox tokens ≠ production tokens.

### Step 2: Use the bearer

Every subsequent call:

```bash
curl -X GET \
     -H 'Authorization: Bearer baGXoStRuR9VCDFQGZNzgNqbqu5WUwlr.cAxZJ9m22Le7' \
     https://commercedeveloper-sandbox-api.adobe.com/rest/v1/users/MAG123456789
```

## Resource model

The API is organized around these top-level resources:

| Resource | Purpose |
| --- | --- |
| **app/session/token** | Get / refresh session tokens. |
| **users** | User profile, Marketplace access keys (for installs), EQP callbacks, user reports. |
| **files** | Upload code zips, PDF docs, icons, gallery images. |
| **products/packages** | Create / update listings, submit for review, list, filter. |
| **products/packages/.../status** | Test results for a submission. |
| **reports/metrics** | Aggregated cross-Marketplace reports (under refinement). |

The conceptual workflow:

```
1. POST /rest/v1/files/uploads        ── upload zip                    → file_upload_id
2. POST /rest/v1/files/uploads        ── upload user-guide PDF         → file_upload_id
3. POST /rest/v1/files/uploads        ── upload icon                   → file_upload_id
4. POST /rest/v1/files/uploads        ── upload gallery images        → file_upload_id (x N)
5. POST /rest/v1/products/packages    ── create draft listing with file IDs
                                                                      → submission_id
6. PUT  /rest/v1/products/packages/{submission_id}
                                       ── update fields, set action.technical/marketing = "submit"
7. GET  /rest/v1/products/packages/{submission_id}/status
                                       ── poll for test results
8. (or) receive POST to your registered callback URL when status changes
```

## Endpoints — `users`

### Get your profile

```http
GET /rest/v1/users/{mage_id}
GET /rest/v1/users/{mage_id}?style=summary
```

Returns your full profile JSON: addresses, PayPal, partner status, social links, IMS orgs, registered API callbacks.

### Update your profile

```http
PUT /rest/v1/users/{mage_id}
Content-Type: application/json
Authorization: Bearer ...

{
  "personal_url": "https://...",
  "personal_bio": "...",
  "api_callbacks": [
    { "name": "My 1st EQP Callback",
      "url":  "https://developer.example.com/rest/v1/callback",
      "username": "key",
      "password": "secret"
    }
  ]
}
```

The `api_callbacks` array is how callbacks are registered (no UI for this — API only).

### Marketplace access keys (Composer keys; not EQP API keys)

These are the keys buyers / sellers use against `repo.magento.com`.

```http
GET     /rest/v1/users/{mage_id}/keys                                  ── list
POST    /rest/v1/users/{mage_id}/keys                                  ── create new
PUT     /rest/v1/users/{mage_id}/keys/{url_encoded_label_of_m2_key}    ── update (regen / rename)
DELETE  /rest/v1/users/{mage_id}/keys/{url_encoded_label_of_m2_key}?uid={mage_id}
                                                                       ── delete
```

The label is the human-readable name you gave the key. URL-encode it.

### User reports

```http
GET /rest/v1/users/{mage_id}/reports/pageviews
GET /rest/v1/users/{mage_id}/reports/totals
GET /rest/v1/users/{mage_id}/reports/sales
```

Aggregate metrics for your account. Often empty in sandbox.

## Endpoints — `files`

### Get info about an uploaded file

```http
GET /rest/v1/files/uploads/{file_upload_id}
GET /rest/v1/files/uploads                       ── list all files you've uploaded (paginated)
```

Response includes `malware_status` (`pass` / `fail` / `in-progress`). Don't reference a file in a package until `malware_status` is `pass`.

### Upload a file

```http
POST /rest/v1/files/uploads
Authorization: Bearer ...
Content-Type: multipart/form-data
```

Body is multipart with the file payload. Returns:

```json
{
  "file_upload_id": "5c129cd41ba478.65767699.1",
  "filename": "icon.png",
  "content_type": "image/png",
  "size": 123456,
  "malware_status": "in-progress",
  "url": "https://commercedeveloper-sandbox-static.adobe.com/.../icon.png"
}
```

Curl:

```bash
curl -X POST \
     -H 'Authorization: Bearer ...' \
     -F 'file=@./your-extension-1.2.0.zip' \
     https://commercedeveloper-sandbox-api.adobe.com/rest/v1/files/uploads
```

Files can be referenced by multiple packages — useful for shared assets (e.g., one company-icon that several listings use).

The `malware_status` returns to `in-progress` initially; you must wait for it to resolve to `pass` before referencing the file in a package. Two options:

1. **Poll** `GET /rest/v1/files/uploads/{id}` periodically until `malware_status` is `pass`.
2. **Register a callback** and let Adobe POST `malware_scan_complete` when it's done.

## Endpoints — `products/packages`

The big one. Create / read / update / submit listings.

### Endpoint inventory

```http
POST   /rest/v1/products/packages                              ── create new submission(s)
PUT    /rest/v1/products/packages                              ── batch update by submission_id
PUT    /rest/v1/products/packages/{submission_id}              ── single update
PUT    /rest/v1/products/packages/{item_id}                    ── single update by user-supplied item_id
GET    /rest/v1/products/packages                              ── list (filterable)
GET    /rest/v1/products/packages/{submission_id}              ── single by submission_id
GET    /rest/v1/products/packages/skus                         ── list by SKU
GET    /rest/v1/products/packages/skus/{url_encoded_sku}       ── single by SKU
GET    /rest/v1/products/packages/items                        ── list by user-supplied item_id
GET    /rest/v1/products/packages/items/{item_id}              ── single by item_id
```

### Create a draft submission

A minimal POST that just creates a draft slot:

```http
POST /rest/v1/products/packages
Content-Type: application/json
Authorization: Bearer ...

[
  {
    "action":   { "technical": "draft", "marketing": "draft" },
    "type":     "extension",
    "platform": "M2",
    "name":     "Awesome Connector",
    "version":  "1.0.0"
  }
]
```

The body is always an array (batch convention). For one submission, an array of one. Response gives you a `submission_id`.

### Full submission in one POST

The complete shape (abridged):

```json
[
  {
    "action": { "technical": "submit", "marketing": "submit" },
    "type":     "extension",
    "platform": "M2",
    "version_compatibility": [
      { "edition": "CE", "versions": ["2.4.7", "2.4.8", "2.4.9"] }
    ],
    "name":     "One Click Checkout",
    "long_description": "<p>...</p>",
    "release_notes":    "<ul><li>Initial release</li></ul>",
    "version":  "1.1.5",
    "artifact": { "file_upload_id": "5c11e656057b42.97931218.5" },
    "documentation_artifacts": {
      "user":         { "file_upload_id": "5c644d97bb7c41.37505716.6" },
      "installation": { "file_upload_id": "5c644daf21fee4.39102137.2" },
      "reference":    { "file_upload_id": "5c644f4dcb1900.18508194.9" }
    },
    "media_artifacts": {
      "icon_image":     { "file_upload_id": "5c129cd41ba478.65767699.1" },
      "gallery_images": [
        { "file_upload_id": "5c644fa344e5d7.04253635.8" },
        { "file_upload_id": "5c648b98446065.77844389.4" }
      ],
      "video_urls": [
        "https://www.youtube.com/watch?v=l33T2-YC4tk"
      ]
    },
    "categories": [
      "//Extensions//Payments & Security//Checkout Enhancements"
    ],
    "pricing_model": { "pricing_type": "one-time", "payment_period": 1 },
    "prices": [
      { "edition": "CE", "currency_code": "USD", "price": 99.00 },
      { "edition": "EE", "currency_code": "USD", "price": 199.00, "installation_price": 0.00 }
    ],
    "license_type": "osl-3.0"
  }
]
```

The `action` field gates state transitions:

- `"draft"` — saved but not submitted. Loose validation (basic type checks only).
- `"submit"` — full validation. Must have all required fields. Triggers EQP pipeline for that side (technical, marketing, or both).

Default is `draft` if omitted.

For incremental builds: POST `draft` → many PUT `draft` (one field at a time) → final PUT with `action.technical=submit, action.marketing=submit`.

### Update a draft

```http
PUT /rest/v1/products/packages/{submission_id}
Content-Type: application/json
Authorization: Bearer ...

[
  {
    "action": { "technical": "draft", "marketing": "draft" },
    "release_notes": "<ul><li>Updated note</li></ul>"
  }
]
```

PUTs are merging — fields you omit are unchanged. You don't have to re-send every field on every update.

### Submit for review

```http
PUT /rest/v1/products/packages/{submission_id}
[
  { "action": { "technical": "submit", "marketing": "submit" } }
]
```

This is what kicks off EQP.

### List your submissions

```http
GET /rest/v1/products/packages?type=theme&sort=+platform,-created_at
GET /rest/v1/products/packages?submission_id=12345
GET /rest/v1/products/packages?offset=0&limit=20
```

Filterable / sortable / paginated — see the **Filtering** section below.

## Endpoints — test results

```http
GET /rest/v1/products/packages/{submission_id}/status
GET /rest/v1/products/packages/sku/{url_encoded_sku}/status
GET /rest/v1/products/packages/item/{item_id}/status
GET /rest/v1/products/packages/{submission_id}/status/{tool_name}/{tool_run_id}
```

The `tool_name` is one of `malware`, `code_sniffer`, `copy_paste`, `installation`, `mftf_magento`, `mftf_vendor`, `footprint`, `semantic_version`, `manual_qa`. `tool_run_id` is the per-run ID assigned by EQP.

The summary endpoint returns:

```json
{
  "submission_id": "f4eacd72be",
  "eqp_status": {
    "overall": "in_progress",
    "technical": "in_automation",
    "marketing": "awaiting_marketing_review"
  },
  "tools": [
    { "name": "malware",      "tool_run_id": "abc", "status": "passed" },
    { "name": "code_sniffer", "tool_run_id": "def", "status": "failed" }
  ]
}
```

## Endpoints — reports

```http
GET /rest/v1/reports/metrics
GET /rest/v1/reports/metrics/{metric_name}
```

Aggregated cross-Marketplace metrics. Schema is "under refinement" per Adobe — expect changes. Often empty in sandbox.

## Callbacks

Register a URL in your profile, receive POSTs when events fire.

### Register

```http
PUT /rest/v1/users/{mage_id}
Authorization: Bearer ...
Content-Type: application/json

{
  "api_callbacks": [
    {
      "name": "My EQP Callback",
      "url": "https://your.example.com/eqp",
      "username": "key",
      "password": "secret"
    }
  ]
}
```

The `password` is write-only — never returned in GETs. Each callback request is authenticated with Basic Auth using `username:password`, base64-encoded:

```http
POST /eqp HTTP/1.1
Host: your.example.com
Authorization: Basic a2V5OnNlY3JldA==
Content-Type: application/json

{ ... payload ... }
```

### Event types

**Malware scan complete**:

```json
{
  "callback_event": "malware_scan_complete",
  "update_info": {
    "file_upload_id": "2309480238.238475.0",
    "tool_result": "passed",
    "modified_at": "2022-08-25 19:20:21"
  }
}
```

**EQP status update** (package state transitions):

```json
{
  "callback_event": "eqp_status_update",
  "update_info": {
    "submission_id": "s5w9k703ru",
    "item_id": "user_upload_version_1",
    "eqp_flow": "marketing",
    "current_status": "approved",
    "eqp_status": {
      "overall": "in_progress",
      "technical": "draft",
      "marketing": "approved"
    },
    "modified_at": "2022-08-25 19:20:21"
  }
}
```

Callbacks are HTTPS only. Adobe retries failed callbacks (no documented retry policy — handle idempotency on your side using the `submission_id` and `modified_at`).

## Batch processing

Many endpoints accept arrays. POST / PUT to `/rest/v1/products/packages` is the canonical batch — submit / update many in one request.

### Batch response

If the **entire** payload errors (e.g., 401), you get an HTTP 4xx with a normal error body. No item-level data.

If the batch parses, you always get **HTTP 200**, with per-item success/failure:

```json
[
  {
    "code": 200,
    "message": "Success",
    "submission_id": "f4eacd72be",
    "eqp_status": { ... },
    "created_at": "2020-04-17 16:00:00"
  },
  {
    "code": 1208,
    "message": "Insufficient information for Technical Submission"
  },
  {
    "code": 1210,
    "message": "Invalid SKU given. SKU must be of the form 'vendor_name/package_name'"
  }
]
```

Items that succeed succeed; items that fail fail; you process the array.

## Filtering, sorting, pagination

GET list endpoints support all three. Currently:

- `files` endpoints — pagination only.
- `packages` endpoints — pagination + sorting + filtering.

**Pagination**:

```
GET /rest/v1/products/packages?offset=0&limit=20
```

`limit=-1` returns everything remaining. Response includes `X-Total-Count` header.

**Sorting**:

```
GET /rest/v1/products/packages?sort=-platform,+name,-version
```

`-` prefix = descending, `+` = ascending.

**Filtering**:

```
GET /rest/v1/products/packages?type=theme&platform=M2&submission_id=12345
```

Any filterable field can be a query param. The single-object convenience endpoint and the batch endpoint with a single filter return different shapes:

- `GET /rest/v1/products/packages/12345/` → single object or 404.
- `GET /rest/v1/products/packages/?submission_id=12345` → array (0 or 1 element).

## Error handling

All HTTP 4xx errors contain:

```json
{
  "code": 1208,
  "message": "Insufficient information for Technical Submission"
}
```

For batch responses, see the section above — overall 200, per-item codes.

Common error codes:

- `1208` — Insufficient information for Technical Submission.
- `1210` — Invalid SKU given. SKU must be of the form `vendor_name/package_name`.
- `401` — Bearer expired / invalid / not yet exchanged.
- `403` — Operation not permitted (e.g., trying to use sandbox-only resource without partner status).

Match the message; the codes are stable.

## Limits and rate behavior

- **Max 3 active EQP API access keys per environment** (sandbox + production are separate).
- **Session tokens**: requested `expires_in` is honored up to the system max (Adobe doesn't publish the exact ceiling).
- **No published rate limit**, but treat the API as moderately rate-limited — Adobe will return 429 on abuse.
- **File upload size**: implicit 30 MB cap on code zips (same as the zip submission cap).

## Practical patterns

### Full submission script outline (pseudocode)

```bash
# 1. Get session
RES=$(curl -s -X POST -u "$APP_ID:$APP_SECRET" \
            -H 'Content-Type: application/json' \
            -d '{"grant_type":"session","expires_in":7200}' \
            https://commercedeveloper-api.adobe.com/rest/v1/app/session/token)
UST=$(echo "$RES" | jq -r '.ust')

# 2. Upload zip
ZIP_RES=$(curl -s -X POST -H "Authorization: Bearer $UST" \
                -F "file=@./your-ext-1.2.0.zip" \
                https://commercedeveloper-api.adobe.com/rest/v1/files/uploads)
ZIP_ID=$(echo "$ZIP_RES" | jq -r '.file_upload_id')

# 3. Wait for malware scan (or rely on a callback)
while true; do
  STATUS=$(curl -s -H "Authorization: Bearer $UST" \
                  "https://commercedeveloper-api.adobe.com/rest/v1/files/uploads/$ZIP_ID" \
                | jq -r '.malware_status')
  [ "$STATUS" = "pass" ] && break
  [ "$STATUS" = "fail" ] && { echo "Malware scan failed"; exit 1; }
  sleep 10
done

# 4. Upload PDF, icon, gallery (same pattern)

# 5. POST the package
SUBMISSION_RES=$(curl -s -X POST -H "Authorization: Bearer $UST" \
                         -H 'Content-Type: application/json' \
                         -d @submission.json \
                         https://commercedeveloper-api.adobe.com/rest/v1/products/packages)
SUBMISSION_ID=$(echo "$SUBMISSION_RES" | jq -r '.[0].submission_id')

# 6. PUT action: submit
curl -s -X PUT -H "Authorization: Bearer $UST" \
        -H 'Content-Type: application/json' \
        -d '[{"action":{"technical":"submit","marketing":"submit"}}]' \
        https://commercedeveloper-api.adobe.com/rest/v1/products/packages/$SUBMISSION_ID

# 7. Poll status (or use callbacks)
while true; do
  S=$(curl -s -H "Authorization: Bearer $UST" \
            "https://commercedeveloper-api.adobe.com/rest/v1/products/packages/$SUBMISSION_ID/status" \
          | jq -r '.eqp_status.overall')
  [ "$S" = "approved" ] && break
  [ "$S" = "rejected" ] && { echo "Rejected"; exit 1; }
  sleep 60
done
```

## Help / support

- Slack: workspace `Magento Open Source` (https://developer.adobe.com/open/magento/slack), channel `#marketplace-eqp-api`.
- Email: `magento-marketplace-eqp-apis@adobe.com`.
- Generic Marketplace support: `commercemarketplacesupport@adobe.com`.

## Original sources

- `references/sources/commerce-marketplace/guides/eqp/v1/index.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/getting-started.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/auth.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/rest-api.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/access-keys.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/users.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/files.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/packages.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/test-results.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/callbacks.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/reports.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/filtering.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/handling-errors.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/sandbox.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/help.md`
