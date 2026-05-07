# GraphQL Index

OrderGroove offers a GraphQL API for read access (`query`) and selected mutations alongside the REST API. See `queries/rest-vs-graphql.md` for when to choose GraphQL.

## Queries / Mutations

| Operation | File |
|---|---|
| `subscription(publicId)` query | [queries/subscription.md](queries/subscription.md) |
| Skip-order mutation | [queries/skip-order.md](queries/skip-order.md) |
| Send-now mutation | [queries/send-now.md](queries/send-now.md) |
| Change-date mutation | [queries/change-date.md](queries/change-date.md) |
| REST vs GraphQL — choosing between them | [queries/rest-vs-graphql.md](queries/rest-vs-graphql.md) |

## Type Definitions (markdown)

| Type | File |
|---|---|
| `SubscriptionType` | [types/subscriptiontype.md](types/subscriptiontype.md) |
| `SubscriptionConnection` (paginated list wrapper) | [types/subscriptionconnection.md](types/subscriptionconnection.md) |
| `SubscriptionEdge` | [types/subscriptionedge.md](types/subscriptionedge.md) |
| `OrderType` | [types/ordertype.md](types/ordertype.md) |
| `ItemType` | [types/itemtype.md](types/itemtype.md) |
| `ItemsPage` | [types/itemspage.md](types/itemspage.md) |
| `CustomerType` | [types/customertype.md](types/customertype.md) |
| `AddressType` | [types/addresstype.md](types/addresstype.md) |
| `PaymentType` | [types/paymenttype.md](types/paymenttype.md) |
| `ProductType` | [types/producttype.md](types/producttype.md) |
| `ProductGroupType` | [types/productgrouptype.md](types/productgrouptype.md) |
| `ComponentType` (bundles) | [types/componenttype.md](types/componenttype.md) |
| `CancelReasonType` | [types/cancelreasontype-1.md](types/cancelreasontype-1.md) |
| `IncentiveType` (base) | [types/incentivetype.md](types/incentivetype.md) |
| `DiscountIncentiveType` | [types/discountincentivetype.md](types/discountincentivetype.md) |
| `GiftIncentiveType` | [types/giftincentivetype.md](types/giftincentivetype.md) |
| `OneTimeIncentiveType` | [types/onetimeincentivetype.md](types/onetimeincentivetype.md) |
| `GranteeType` | [types/granteetype.md](types/granteetype.md) |
| `PrepaidSubscriptionContextType` | [types/prepaidsubscriptioncontexttype.md](types/prepaidsubscriptioncontexttype.md) |
| `FreeTrialSubscriptionContextType` | [types/freetrialsubscriptioncontexttype.md](types/freetrialsubscriptioncontexttype.md) |
| `QueuedActionType` | [types/queuedactiontype.md](types/queuedactiontype.md) |

## HTML archive (raw exports of developer.ordergroove.com pages)

The `page-html-archive/` subdirectory contains the original saved HTML pages of GraphQL types and queries (e.g. `graphql-type-CustomerType.md` is HTML with a `.md` extension). These duplicate the markdown above but are preserved verbatim for reference. Prefer the markdown files in `types/` and `queries/` for actual reading — they're clean and parseable.
