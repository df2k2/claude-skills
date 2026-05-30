# Common Pitfalls

The "why is this not working?" catalog. Mapped from symptom → root cause → fix, with pointers to the deep reference.

## Authentication

| Symptom | Cause | Fix |
| --- | --- | --- |
| `401 Unauthorized` on every request | `X-API-KEY` header missing | Add header: `X-API-KEY: <your-key>`. |
| `401 Unauthorized` after working previously | Key revoked from dashboard | Generate new key at https://dashboard.gelato.com/keys/manage. |
| `401` on sandbox tests | Used production key on sandbox or vice-versa | There is no public sandbox; only one set of keys. If you're hitting a non-`*.gelatoapis.com` host, you're at the wrong API. |
| Header sent but still 401 | Wrong header name (used `Authorization` or `api-key`) | Must be exactly `X-API-KEY`. |
| `401` after `git push` | Committed key to public repo and auto-revoked | Generate new key; use env vars / secrets manager. |

## Wrong base URL

| Symptom | Cause | Fix |
| --- | --- | --- |
| `404 Not Found` on `api.gelato.com/v2/...` | Legacy v2 host (retired) | Migrate to per-service hosts: `order.gelatoapis.com`, `product.gelatoapis.com`, `shipment.gelatoapis.com`, `ecommerce.gelatoapis.com`. |
| `ENOTFOUND` / DNS failure | Typo (e.g., `gelatoapi.com` vs. `gelatoapis.com`) | Note the **s** at the end of `gelatoapis`. |
| `403` from `dashboard.gelato.com/docs/...` | That's the doc site, not the API | Use `*.gelatoapis.com` for API calls. |
| `404` for Orders v3 endpoints | Already migrated to v4 | Most new work uses v4. v3 mostly still works but missing features. |
| Cross-service host confusion | Tried `https://order.gelatoapis.com/v3/catalogs` | Catalogs are on `product.gelatoapis.com`, not `order.gelatoapis.com`. |

## productUid

| Symptom | Cause | Fix |
| --- | --- | --- |
| `422 Invalid productUid` | Constructed UID by hand | Query catalog with `POST /v3/catalogs/{catalogUid}/products:search` and use the returned UID verbatim. See `references/product-uid-format.md`. |
| `422` but UID is structurally valid | UID is from a different catalog than the one you're ordering from | Re-query the right catalog. |
| `422 Combination not available` | Attribute combination doesn't map to a real SKU | Use `products:search` with all attributes; if no result, that combination isn't sold. |
| `422 Product retired` | UID was valid historically but no longer | Refresh; product was discontinued. |
| Order succeeds but wrong color/size shipped | Used a stale UID from a cached / hardcoded list | Re-validate UIDs against the live catalog periodically. |

## File URLs

| Symptom | Cause | Fix |
| --- | --- | --- |
| `422 File URL unreachable` | URL behind auth | Make publicly fetchable; presigned S3 with ≥ 24h expiry. |
| `422 File URL unreachable` after a delay | Presigned URL expired before Gelato fetched | Bump expiry to ≥ 24h. |
| `422 Unsupported file format` | Submitted DOCX, PSD, AI, or HEIC | Convert to PDF (preferred), PNG, JPEG, TIFF, or SVG. |
| File fetched but print is fuzzy | Resolution < 300 DPI at print-area size | Re-export at higher resolution. |
| Colors look wrong | RGB → CMYK conversion drift | Submit CMYK with embedded ICC profile; prefer PDF/X. |
| Sleeve / back artwork ignored | Product doesn't have that print area | Confirm productUid supports the area (e.g., `gpr_4-4` = front + back). |
| `processedFileUrl` stuck at null | Processing failed silently | Check dashboard order events; contact support if needed. |

## Order create

| Symptom | Cause | Fix |
| --- | --- | --- |
| `422 Invalid address` on a US order | Missing `state` (US requires 2-letter state code) | Add `state: "NY"` etc. Same for CA, AU. |
| `422 Invalid country` | Used `"USA"` or `"United States"` | Use ISO 3166-1 alpha-2: `"US"`. Same for `"GB"` not `"UK"`. |
| `422 currency not supported` | Account/wallet doesn't include the requested currency | Use a currency in your configured wallets/contract. |
| `422 shipmentMethodUid not available` | Method doesn't serve destination country | Pre-filter Shipment Methods by `country` first; or omit and let Gelato pick. |
| `409 Order already exists` | Re-submitted with same `orderReferenceId` | Look up the existing order; or generate a new reference. |
| `402 Payment refused` (`financialStatus: refused`) | Wallet empty / card declined / invoice limit | Top up wallet, update card, contact billing. |
| Order created, fulfillmentStatus stays `created` for hours | Stuck in queue / Gelato side issue | Wait; if > 1 hour, check dashboard or contact support. |
| Order created but fulfillmentStatus `failed` | Validation issue (file, product, address) | Read the error in the dashboard; fix and resubmit (with new reference if needed). |
| Order stuck in `pending_approval` | Account configured for manual review | Approve in dashboard or contact account team to disable manual review. |
| Order stuck in `on_hold` | Gelato flagged for support review | Contact support@gelato.com with order ID. |

## Draft vs. order

| Symptom | Cause | Fix |
| --- | --- | --- |
| Tried to `DELETE` a production order | Only drafts are deletable | Use `POST /v4/orders/{id}:cancel` instead (if still cancelable). |
| Tried to `:cancel` an already-shipped order | Past the cancel-eligible window | Can't cancel; contact support for any refund. |
| `PATCH` returns "draft only" | Tried to patch a production order | Only drafts can be patched. Cancel + re-create if needed. |
| Charge happened on a draft | You converted to order without realizing | Drafts only charge when patched with `orderType: "order"` or created with `orderType: "order"` from the start. |

## Quote API

| Symptom | Cause | Fix |
| --- | --- | --- |
| Quote returns no shipment methods | Destination country has no service for these items | Verify country code; check if products ship there via Catalog `supportedCountries`. |
| Quote prices differ from final order charge | FX rates moved; tier breakpoint hit; promo applied | Quotes are estimates; final charge is computed at order create. |
| `allowMultipleQuotes: false` returned single but expected split | Production region routing chose one site for all items | Set `allowMultipleQuotes: true` to see per-region splits. |

## Webhooks

| Symptom | Cause | Fix |
| --- | --- | --- |
| No webhooks ever arrive | URL not registered, or wrong URL | Confirm in dashboard.gelato.com → Webhooks. |
| Webhooks register but never deliver | Endpoint returns 5xx or times out | Return 2xx fast; queue heavy work. See `references/webhooks.md`. |
| Webhook delivers once then stops | First delivery returned non-2xx; retries (3x, 5s gap) exhausted; event dropped | Fix endpoint; supplement with periodic polling for missed events. |
| Webhook payload has `orderId` you don't recognize | The order was created on a connected storefront, not via your direct API | Look up by `orderReferenceId` (the storefront's order ID) or by `storeId`. |
| Webhook arrives before your `POST /v4/orders` response | Race condition | Use `orderReferenceId` as your primary DB key; insert it before the API call, update with `orderId` after. |
| Duplicate processing | No idempotency | Track processed event keys (e.g., `{orderId}:{fulfillmentStatus}:{financialStatus}`); skip duplicates. |
| Out-of-order events (shipped arrives before passed) | Webhook delivery retry sequence | Apply only "later" status transitions; check `STATUS_ORDER`. |
| Signature can't be verified | Gelato doesn't publish an HMAC scheme | Use Basic Auth (`https://user:pass@your-host/...`) or shared-secret query param. |

## Multi-page products

| Symptom | Cause | Fix |
| --- | --- | --- |
| `422 pageCount required` | Multi-page product (photobook, notebook) needs pageCount | Add `pageCount: N` to the item. |
| `422 Invalid pageCount` | Page count not in product's `validPageCounts` | Use one of the allowed values (`GET /v3/products/{productUid}`). |
| Spine text crooked / off | Composed cover without re-fetching cover-dimensions for the actual pageCount | Cover layout (spine width especially) changes with page count; re-fetch per pageCount. |
| Forgot to include cover pages in pageCount | Total includes covers (2 inner + 2 outer) | A 112-inner-page notebook is `pageCount: 116`. |

## Storefront integration

| Symptom | Cause | Fix |
| --- | --- | --- |
| `POST /v1/stores/{storeId}/products` returns `status: publishing_error` | Variant push to Shopify/Etsy failed | Check `publishingErrorCode` (e.g., invalid product on storefront side). |
| Product published but not visible on storefront | `isVisibleInTheOnlineStore: false` | Re-create with `true`, or toggle on the storefront UI. |
| Etsy product has tags truncated | Etsy enforces 20-char tag limit | Trim tags to 20 chars for Etsy. |
| Variants on storefront show `connectionStatus: not_connected` | Variant wasn't linked back to a Gelato productUid | Re-connect in dashboard.gelato.com → Ecommerce → store mapping. |
| Order from Shopify doesn't reach Gelato | Integration disconnected / app uninstalled | Re-connect in Shopify; reauthorize Gelato app. |

## Pricing

| Symptom | Cause | Fix |
| --- | --- | --- |
| Order cheaper than expected | Hit a quantity-tier breakpoint | Tier prices apply per-line-item quantity. Confirm with `/v3/products/.../prices`. |
| Order more expensive than expected | Each line item priced at its own tier (5 items × qty 1 = each priced at qty-1) | Combine into one line item if SKUs are identical. |
| VAT applied when reverse-charge expected | `isBusiness: false` or VAT number not on file | Set `isBusiness: true`; verify account VAT number. |
| Discount not visible in receipt | Tier discount not active at order time, or no promo on account | Check tier start date; account-level promos only. |

## Currency

| Symptom | Cause | Fix |
| --- | --- | --- |
| `422 Currency XXX is not supported` | Wallet/contract doesn't include that currency | Use a configured currency, or top up a sub-wallet. |
| Got USD charge for JPY order | Wallet currency mismatch → auto-converted with fees | Fund a JPY sub-wallet to avoid conversion fees. |

## Cancellation / refund

| Symptom | Cause | Fix |
| --- | --- | --- |
| `:cancel` returns error "order already passed" | Order moved to `passed`/`printed`/`shipped` | Can't cancel; contact support for any refund. |
| Refund didn't go to original payment method | Refund is usually credited back to wallet, even if original was card | Check wallet balance; contact billing if you need actual reversal. |
| Partial refund | Production defect on some items | Receipt shows partial refund line; reconcile in your system. |

## Currency / region routing

| Symptom | Cause | Fix |
| --- | --- | --- |
| Order took 2 weeks instead of expected 5 days | Routed to a distant production region | Gelato routes by capacity + product availability; complain to support if persistent. |
| Order split into multiple sub-orders | Items needed different production regions | `connectedOrderIds` lists the sub-orders; each ships separately. |

## When you can't figure it out

1. Check the dashboard's order detail page for any error events / notes.
2. `GET /v4/orders/{id}` and read every field carefully.
3. Look up the productUid in the catalog to confirm it's current.
4. Check webhook delivery history in the dashboard.
5. Email `support@gelato.com` with: order ID, orderReferenceId, the time of the failure, and the exact request payload (sanitize keys).
6. Slack: Gelato runs a partner Slack for some account tiers — ask your account manager for an invite.

## Original sources

Aggregates patterns from:

- `references/orders-api.md`
- `references/product-uid-format.md`
- `references/files-and-print-files.md`
- `references/webhooks.md`
- `references/pricing-currencies-charging.md`
- `references/error-handling-rate-limits.md`
- `references/integrations-and-platforms.md`
