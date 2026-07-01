# Common Pitfalls — "why isn't this working?"

The Akeneo failures that come up again and again, grouped by symptom. Each entry: the cause and
the fix. Deep detail lives in the topic references named in each row.

## Authentication (401 / 403)

| Symptom | Cause | Fix |
| --- | --- | --- |
| 401 on every call | Wrong **auth model** — using an App flow against a Connector or vice-versa | Connection → `POST {pim}/api/oauth/v1/token` (`grant_type=password`); App → `POST {pim}/connect/apps/v1/oauth2/token` (`grant_type=authorization_code` + `code_challenge`). See `authentication.md`. |
| 401 despite a "valid" token | Sending `Authorization: Basic …` on **API** calls | `Basic base64(client_id:secret)` is **only** for the token request. API calls use `Authorization: Bearer <access_token>`. |
| Worked an hour ago, now 401 | **Connection** access tokens expire after **3600 s (1 h)** | Refresh with `grant_type=refresh_token` (refresh token lasts 14 days). App tokens don't expire — if an App call 401s, the user **revoked** it; re-run the authorization flow. |
| App token exchange fails `invalid_grant` "Code has expired" | Authorization `code` is single-use and short-lived (~30 s) | Exchange it immediately; don't log-and-replay. Recompute `code_challenge = sha256(code_identifier + client_secret)` per request. |
| 403 with an HTML block page | A **corporate web filter / firewall**, not Akeneo | Check egress; the PIM returns JSON errors, not HTML. |
| 403 on a resource you can read in the UI | The **Connection's permissions / ACL** (or App scope) don't grant it | Grant the permission on the Connection, or request the scope (`read_*`/`write_*`) in the App authorization. A 404 can also mean "no permission." |

## Product values (422)

The single most common data bug. `values[attr] = [{ "locale": …, "scope": …, "data": … }]`.

| Symptom | Cause | Fix |
| --- | --- | --- |
| 422 "attribute is localizable, you must specify a locale" | Attribute is **localizable** but you sent `locale: null` | Set `locale` to a real locale code (e.g. `en_US`). |
| 422 "attribute cannot be localizable" | Attribute is **not** localizable but you sent a `locale` | Set `locale: null`. |
| 422 about `scope` | Same, for **scopable** attributes and the channel `scope` field | `scope` = a channel code iff scopable, else `null`. |
| 422 "attribute does not exist" / "option does not exist" | Unknown attribute or option **code** (or not in the family) | Read `catalog-structure.md`; import/create the attribute/option first; options are case-sensitive codes. |
| 422 on `data` | Wrong **data shape for the attribute type** (e.g. a string where a `{amount,unit}` metric or `{amount,currency}` price array is expected) | Match the type — see the data-shape table in `products-and-models.md`. |
| Value won't clear | Omitting it (PATCH merges, doesn't delete) | Send the value with `data: null` to erase it. |

## Products: UUID vs identifier

| Symptom | Cause | Fix |
| --- | --- | --- |
| 404 on `/products-uuid/{code}` | Mixing the two families — passing an **identifier** to the **UUID** endpoint | `/products/{identifier}` and `/products-uuid/{uuid}` are distinct. Pick one family and stay in it. |
| "UUID endpoints don't exist" | PIM older than **7.0** | UUID products arrived in 7.x; on ≤6.x use identifiers only. |
| Product model not found by UUID | **Product models & family variants are addressed by `code`**, never UUID | Use the code. |

## Edition mismatches (404)

| Symptom | Cause | Fix |
| --- | --- | --- |
| 404 on `/reference-entities`, `/asset-families`, published products, or workflows | Those are **EE / Serenity** only | On CE they don't exist — it's an edition issue, not a wrong path. The community Magento connector also doesn't import them. See `reference-entities-and-assets.md`. |
| `channel` vs `scope` confusion | **Reference-entity & asset** record values use `channel`; **product** values use `scope` (both mean the channel code) | Use `channel` for records/assets, `scope` for products. |

## Writes & bulk

| Symptom | Cause | Fix |
| --- | --- | --- |
| Bulk import "succeeded" but data is missing | Collection **`PATCH` always returns HTTP 200** — per-item results are in the body | Parse the newline-delimited response; check each line's `status_code` (201/204 ok, 422 failed) and `message`. See `rest-api-overview.md`. |
| Measurement-family bulk fails as NDJSON | `measurement-families` bulk `PATCH` takes a **JSON array**, not newline-delimited JSON | It's the odd one out — send an array. Everything else uses `application/vnd.akeneo.collection+json` NDJSON. |
| Can't create/update a locale or currency | **Locales and currencies are read-only** over the API | Manage them in the PIM UI / channel config. |
| 413 (or a 403) on a large write | Payload too big | Batch ≤ 100 items per bulk request; keep the body under the size limit. |

## Pagination & filtering

| Symptom | Cause | Fix |
| --- | --- | --- |
| No total count with `search_after` | `search_after` is a **cursor** — no `items_count`, no `previous` link | Use `pagination_type=page&with_count=true` if you need totals (small sets only). |
| Deep paging breaks around page ~100 | `page` pagination has a **10,000-item offset cap** | Switch to `search_after` for large collections (products, records). |
| Reference-entity records won't page by number | Records support **`search_after` only** | Use the cursor. |
| `search` filter ignored | `search` must be a **stringified JSON** object with the right operator per attribute type | See the filter grammar in `rest-api-overview.md`; set `search_locale`/`search_scope` when filtering localizable/scopable attributes. |

## Rate limiting (429) — hosted platforms

Akeneo **publishes** limits for the hosted platform (Serenity/Growth/hosted PaaS) in
`good-practices.md`: **~100 req/s per instance, 4 concurrent calls per connection, 10 concurrent
per instance, and 3 req/s for attribute-option writes**. There are **no** `X-RateLimit-*` headers
(an optional `Retry-After` may appear on 429). Self-hosted CE/EE has no Akeneo-imposed limiter.

| Symptom | Cause | Fix |
| --- | --- | --- |
| Sporadic 429 under load | Exceeding concurrency / req-per-second | Cap concurrency (≤4/connection), add exponential backoff, batch writes, cache catalog reads. |
| Attribute-option imports 429 constantly | The **3 req/s** attribute-option write ceiling | Bulk them and throttle to the documented rate. |

## Tooling & environment

| Symptom | Cause | Fix |
| --- | --- | --- |
| Calling `api.akeneo.com` gets docs HTML, not data | `api.akeneo.com` is the **documentation site** | Call the customer PIM: `{pim_url}/api/rest/v1/…`. The SaaS spec server is templated `{your-pim-url}`. |
| Postman auth "just doesn't work" | The embedded collection has a **variable-name inconsistency** (requests reference `basicAuthUsername`/`basicAuthPassword`/`bearerToken` while the collection declares `clientId`/`secret`/`username`/`password`) | Set the variables the **requests** actually use; see `getting-started.md`. |
| `composer require akeneo/api-php-client-ee` fails / is stale | The **EE client is archived and merged** into the single client | Use `akeneo/api-php-client` for CE **and** EE. See `php-client.md`. |
| App Store submission blocked | Akeneo is **not currently accepting new App-Store submissions** | Custom apps + UI extensions still work fine; see `apps-and-connections.md`. |

## Events / webhooks

| Symptom | Cause | Fix |
| --- | --- | --- |
| Building on the "Events API" and hitting deprecation notices | The original **Events API is deprecated**; the **Event Platform** is current | Build on the Event Platform; migrate existing subscriptions. See `events-and-webhooks.md`. |
| Webhook signature never validates | Not verifying against the documented signing scheme, or mutating the raw body first | Verify the signature on the **raw** payload before parsing; ack fast, process async, dedupe. |
| Event payload fields differ across environments | Payloads are **version-keyed** (5.0/6.0/7.0/serenity) | Check the matching `events-reference` for the target PIM version. |

## Original sources

Synthesized from the curated references in this skill (`authentication.md`, `rest-api-overview.md`,
`products-and-models.md`, `catalog-structure.md`, `reference-entities-and-assets.md`,
`errors-and-rate-limits.md`, `events-and-webhooks.md`, `apps-and-connections.md`, `php-client.md`)
and the vendored sources they cite — chiefly `references/sources/akeneo-official-docs/rest-api/`
(`good-practices.md`, `troubleshooting.md`, `responses.md`), the two specs under
`references/sources/openapi-specs/`, and the Postman collection.
