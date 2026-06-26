# Common Pitfalls

The "why isn't this working?" catalog. Mapped from symptom → root cause → fix, with pointers to the deep reference.

## Authentication / signing

| Symptom | Cause | Fix |
| --- | --- | --- |
| `401 Unauthorized` on every authenticated request | One or more of the three headers missing | Need all of `KALSHI-ACCESS-KEY`, `KALSHI-ACCESS-TIMESTAMP`, `KALSHI-ACCESS-SIGNATURE`. |
| `401` after working fine for days | Key revoked / replaced in UI | Regenerate; update secrets. |
| `401` only on certain endpoints | Signing the wrong payload (e.g., included query string or body) | Sign exactly `timestamp + method + path`. Nothing else. |
| `401` sporadic (~5% of requests) | Clock skew | Sync clocks (NTP). Tolerance is ~5s. |
| `401` on POST only | Hashed body into signature | Body is **not** part of the signed payload. |
| `401` on WebSocket only | Trailing slash on path (`/trade-api/ws/v2/`) | Use `/trade-api/ws/v2` exactly. |
| `403 Forbidden` | Perps key on event-contracts host (or vice versa) | Use the right key for the right product. |
| `403` on demo only | Demo key against prod URL or vice versa | Match key environment to host. |
| `403` on Klear endpoints | Used RSA-PSS instead of Bearer token | Klear uses `Authorization: Bearer <token>`. |
| Signature seems right but server rejects | Used PKCS1-v1.5 instead of PSS | Switch to RSA-PSS. |
| Signature works once then fails | Reusing timestamp | Generate fresh `timestamp_ms` per request. |

See `references/authentication-rsa-pss.md`.

## Base URL / host

| Symptom | Cause | Fix |
| --- | --- | --- |
| `404` on everything | Hitting `api.kalshi.com/v1/...` (legacy) | Use `api.elections.kalshi.com/trade-api/v2`. |
| `ENOTFOUND` on `demo-api.kalshi.com` | Wrong TLD | Demo is `.co` (`demo-api.kalshi.co`); prod is `.com`. |
| Perps endpoints 404 | Used main host | Perps is `external-api.kalshi.com`. |
| WS connects but no messages | Wrong WS path (`/trade-api/v2/ws` instead of `/trade-api/ws/v2`) | Use `/trade-api/ws/v2`. |
| Demo orders never appear in prod | Demo and prod are separate accounts | Don't expect cross-environment state. |

## Tickers and catalog

| Symptom | Cause | Fix |
| --- | --- | --- |
| `market_not_found` | Typo in ticker or settled / pruned market | Look up via `/markets?tickers=A`. |
| Empty markets list with filter | Status filter too restrictive | Drop `status` first to see what's there. |
| Event has no markets | Event hasn't opened yet | Check `event.status`; markets are created at open. |
| Ticker decoded as nonsense | Hand-constructed instead of read from catalog | Use `/series` → `/events` → `/markets`. |

See `references/markets-events-series.md`.

## Orders

### Legacy `/portfolio/orders`

| Symptom | Cause | Fix |
| --- | --- | --- |
| Price 10× / 0.1× expected | Cents vs. decimal-dollar confusion | Legacy uses cents (`yes_price: 65` = 65¢). V2 uses dollar decimals (`"0.65"`). |
| `invalid_price` | Price not in 1–99 cents | Binary markets can't trade at 0 or 100. |
| `insufficient_funds` | Wallet < order cost | Top up wallet. |
| `position_limit_exceeded` | Per-market cap | Reduce count. |
| `duplicate_client_order_id` | Reused UUID | (Usually returns existing order; if not, generate fresh UUID.) |
| `self_trade_prevented` | Order would cross own order | Adjust or set STP policy. |
| Order rejected with no detail | Generic rejection | Check `code` + `message`; also check `/account` for any flags. |

### V2 `/portfolio/events/orders`

| Symptom | Cause | Fix |
| --- | --- | --- |
| 422 "side must be bid or ask" | Sent `"yes"` or `"no"` | V2 uses `bid` / `ask`. |
| 422 "price format" | Sent integer cents | Use decimal-dollar string (`"0.65"`). |
| 422 "count format" | Sent int | Use `Decimal` / decimal-string for V2. |
| Order doesn't appear when listing | Listing legacy `/portfolio/orders` won't show V2 orders | Use V2 list endpoint. |
| Migration to V2 forgets idempotency key | Old code didn't require it as strictly | Always include `client_order_id`. |

See `references/orders-and-trading.md`.

## WebSocket

| Symptom | Cause | Fix |
| --- | --- | --- |
| Upgrade 401 | Wrong signature payload | Sign `GET/trade-api/ws/v2` exactly. |
| Connection drops every minute | Heartbeat not implemented | Most libraries handle automatically — verify yours does. |
| Book diverges from REST | Missed a delta during reconnect | Re-snapshot; discard local book. |
| Messages out of order by `seq` | SDK bug or race | Track per-subscription seq strictly; gap → resubscribe. |
| Private channel subscription returns no auth error | Forgot signed headers on upgrade | All three headers required. |
| `1008` close code | Rate limit / abusive | Slow down; check rate limit. |
| Subscription succeeded but no data | Filter too narrow (e.g., wrong ticker) | Verify ticker via REST. |
| WS reconnect storm | No backoff | Exponential backoff with jitter. |

See `references/websocket-api.md`.

## Pricing semantics

| Symptom | Cause | Fix |
| --- | --- | --- |
| Ticker shows `yes_bid: 54` but UI shows $0.54 | Both correct — cents vs. dollar | 54¢ = $0.54. Don't double-convert. |
| Order rejected as "below 0.01" | Submitted $0 price | Minimum tradeable is $0.01 / 1¢. |
| Order rejected as "above 0.99" | Submitted $1 price | Maximum tradeable is $0.99 / 99¢. |
| Confused yes vs. no buy | Action of buying NO at 35¢ is same as selling YES at 65¢ | V2 simplifies — single book per market. |

## Perps

| Symptom | Cause | Fix |
| --- | --- | --- |
| `401` on `external-api.kalshi.com` | Used event-contracts key | Use perps key (separate). |
| Order liquidates immediately | Below maintenance margin | Top up margin; reduce position. |
| Funding payment surprise | Held through funding boundary | Track `next_funding_time_ms`. |
| Timestamp parse error in WS | Mixed `_ms` with RFC3339 | Perps WS uses Unix epoch ms; REST uses RFC3339. |
| Klear endpoint 401 | Used RSA-PSS instead of Bearer | Klear is `Authorization: Bearer <token>`. |
| Sub-account confusion | Order on wrong sub-account | Specify sub-account in request; use `/transfers` to move funds. |

See `references/perps-margin.md`.

## FIX

| Symptom | Cause | Fix |
| --- | --- | --- |
| Logon rejected as bad signature | Wrong payload format for RawData | Verify with SDK or live FIX spec. |
| Reconnect loop | Sequence numbers out of sync | Send Logon with `ResetSeqNumFlag(141)=Y` or send `ResendRequest(35=2)`. |
| ExecReports missing | Drop Copy not opened | Open Drop Copy session separately. |
| MD gaps | Slow consumer / backpressure | Subscribe to top-of-book; or process faster. |
| Heartbeat timeout | Firewall dropped packets | Reconnect; investigate TCP path. |

See `references/fix-protocol.md`.

## Rate limits

| Symptom | Cause | Fix |
| --- | --- | --- |
| `429` after deploy | Backfill hammering API | Add jitter, cache catalog. |
| `429` on order create burst | Many orders in burst | Spread + batch (`batch_create`). |
| `Retry-After: 60` | Long server throttle | Investigate; may need account-level action. |

See `references/errors-and-rate-limits.md`.

## SDKs

| Symptom | Cause | Fix |
| --- | --- | --- |
| `kalshi.ApiInstance(email=..., password=...)` fails | Using legacy `kalshi-python` (lowgrind) | Migrate to `kalshi-python-sync` or `kalshi-sdk`. |
| Async SDK can't be used in sync code | `kalshi_python_async` is async-only | Use `kalshi_python_sync` or `KalshiClient` (sync) from `kalshi-sdk`. |
| WS missing from official SDK | Official SDK is REST-only | Use `kalshi-sdk` (community) or `pykalshi`. |
| Perps missing from SDK | Official SDK has partial perps; community `kalshi-sdk` has full perps | Use `kalshi-sdk`. |
| Klear missing | Only `kalshi-sdk` exposes Klear | Use it; remember Bearer auth. |

See `references/sdks-and-tools.md`.

## State / reconciliation

| Symptom | Cause | Fix |
| --- | --- | --- |
| Local position different from `/portfolio/positions` | Missed fill notifications | Subscribe `fill` channel + periodic REST reconcile. |
| Order appears to fill on UI but not via API | Different sub-account / wrong env | Verify env + sub-account. |
| Settlement payment missing | Settlement in `pending` state | Check `/portfolio/settlements`; some take longer. |
| Withdrawal stuck | Bank verification needed | Verify in UI. |

## Demo vs. production

| Symptom | Cause | Fix |
| --- | --- | --- |
| Order placed on prod by mistake | Forgot to set demo flag | Always explicitly set `demo=True` in dev code. |
| Demo data feels stale | Demo has lower volume than prod | Expected — demo is a sandbox. |
| Demo key fails on prod | Keys are environment-scoped | Generate prod key separately. |
| KYC blocks prod orders | KYC incomplete | Finish KYC in Kalshi UI. |

## Documentation gating

| Symptom | Cause | Fix |
| --- | --- | --- |
| `curl https://docs.kalshi.com/openapi.yaml` returns 403 | Cloudflare challenge | Use a real browser; or run `scripts/kalshi/fetch_docs.sh` from a workstation; or use headless browser per `references/sources/openapi-specs/README.md`. |
| WebFetch on docs.kalshi.com fails | Same | Same. |
| llms.txt 403 | Same | Same. |

## What to do if you can't figure it out

1. Read the OpenAPI / AsyncAPI / Perps OpenAPI spec for the exact contract.
2. Compare against a known-working request from a community SDK's tests.
3. Reproduce the failing request with `curl -v` to get the full headers + body.
4. Email `support@kalshi.com` with the request ID (some endpoints return one in headers) and the exact request payload (sanitized).
5. Kalshi community: there are Discord / Slack / forum spaces — check `docs.kalshi.com` for current pointers.

## Original sources

Aggregates from:

- `references/getting-started.md`
- `references/authentication-rsa-pss.md`
- `references/rest-api-overview.md`
- `references/markets-events-series.md`
- `references/orders-and-trading.md`
- `references/portfolio-and-balance.md`
- `references/websocket-api.md`
- `references/fix-protocol.md`
- `references/perps-margin.md`
- `references/errors-and-rate-limits.md`
