# orders

# orders

## Arguments

| Argument               | Type      | Required | Description                                               |
| ---------------------- | --------- | -------- | --------------------------------------------------------- |
| `customer`             | `String`  | No       | Filter by customer ID.                                    |
| `status`               | `[Int!]`  | No       | Filter by order status codes.                             |
| `subscription`         | `String`  | No       | Filter by subscription public ID.                         |
| `place`                | `Date`    | No       | Filter by exact placement date (YYYY-MM-DD).              |
| `placeStart`           | `Date`    | No       | Filter orders placed on or after this date (YYYY-MM-DD).  |
| `placeEnd`             | `Date`    | No       | Filter orders placed on or before this date (YYYY-MM-DD). |
| `includePrepaidOrders` | `Boolean` | No       | Include prepaid orders in results. Defaults to true.      |
| `first`                | `Int`     | No       | Return the first N results.                               |
| `after`                | `String`  | No       | Cursor to paginate forward from.                          |
| `last`                 | `Int`     | No       | Return the last N results.                                |
| `before`               | `String`  | No       | Cursor to paginate backward from.                         |

## Return Type

`OrderConnection!`

### OrderConnection

| Field      | Type            | Description |
| ---------- | --------------- | ----------- |
| `edges`    | `[OrderEdge!]!` |             |
| `pageInfo` | `PageInfo!`     |             |

#### OrderEdge

| Field    | Type         | Description |
| -------- | ------------ | ----------- |
| `cursor` | `String!`    |             |
| `node`   | `OrderType!` |             |

##### OrderType

| Field               | Type                       | Description |
| ------------------- | -------------------------- | ----------- |
| `publicId`          | `String`                   |             |
| `status`            | `Int!`                     |             |
| `subTotal`          | `Decimal!`                 |             |
| `taxTotal`          | `Decimal!`                 |             |
| `shippingTotal`     | `Decimal!`                 |             |
| `discountTotal`     | `Decimal!`                 |             |
| `total`             | `Decimal!`                 |             |
| `place`             | `DateTime`                 |             |
| `created`           | `DateTime`                 |             |
| `updated`           | `DateTime`                 |             |
| `cancelled`         | `DateTime`                 |             |
| `orderMerchantId`   | `String`                   |             |
| `rejectedMessage`   | `String`                   |             |
| `extraData`         | `String`                   |             |
| `locked`            | `Boolean!`                 |             |
| `oosFreeShipping`   | `Boolean!`                 |             |
| `currencyCode`      | `String`                   |             |
| `tries`             | `Int!`                     |             |
| `genericErrorCount` | `Int!`                     |             |
| `customer`          | `CustomerType`             |             |
| `merchantPublicId`  | `String!`                  |             |
| `hasPlan`           | `Boolean!`                 |             |
| `oneTimeIncentives` | `[OneTimeIncentiveType!]!` |             |
| `shippingAddress`   | `AddressType`              |             |
| `payment`           | `PaymentType`              |             |
| `items`             | `ItemsPage!`               |             |

###### CustomerType

| Field            | Type        | Description |
| ---------------- | ----------- | ----------- |
| `merchantUserId` | `String`    |             |
| `firstName`      | `String`    |             |
| `lastName`       | `String`    |             |
| `email`          | `String`    |             |
| `phoneNumber`    | `String`    |             |
| `phoneType`      | `Int`       |             |
| `priceCode`      | `String`    |             |
| `live`           | `Boolean!`  |             |
| `created`        | `DateTime!` |             |
| `lastUpdated`    | `DateTime!` |             |
| `locale`         | `Int`       |             |
| `extraData`      | `String`    |             |

###### OneTimeIncentiveType

| Field               | Type            | Description |
| ------------------- | --------------- | ----------- |
| `publicId`          | `String!`       |             |
| `externalCode`      | `String!`       |             |
| `description`       | `String!`       |             |
| `stackingType`      | `Int!`          |             |
| `onetimeCouponType` | `String!`       |             |
| `expires`           | `DateTime`      |             |
| `appliedAt`         | `DateTime`      |             |
| `created`           | `DateTime!`     |             |
| `lastUpdated`       | `DateTime!`     |             |
| `incentive`         | `IncentiveType` |             |

###### AddressType

| Field               | Type        | Description |
| ------------------- | ----------- | ----------- |
| `publicId`          | `String`    |             |
| `firstName`         | `String!`   |             |
| `lastName`          | `String!`   |             |
| `address`           | `String!`   |             |
| `address2`          | `String`    |             |
| `city`              | `String!`   |             |
| `stateProvinceCode` | `String!`   |             |
| `zipPostalCode`     | `String!`   |             |
| `countryCode`       | `String!`   |             |
| `companyName`       | `String`    |             |
| `phone`             | `String`    |             |
| `fax`               | `String`    |             |
| `tokenId`           | `String`    |             |
| `priceCode`         | `String`    |             |
| `label`             | `String`    |             |
| `live`              | `Boolean!`  |             |
| `created`           | `DateTime!` |             |

###### PaymentType

| Field            | Type          | Description |
| ---------------- | ------------- | ----------- |
| `publicId`       | `String`      |             |
| `ccType`         | `Int`         |             |
| `paymentMethod`  | `Int`         |             |
| `label`          | `String`      |             |
| `cycle`          | `Int`         |             |
| `cycleStatus`    | `Int`         |             |
| `live`           | `Boolean!`    |             |
| `created`        | `DateTime!`   |             |
| `lastUpdated`    | `DateTime!`   |             |
| `tokenId`        | `String`      |             |
| `billingAddress` | `AddressType` |             |
| `ccNumberEnding` | `String`      |             |
| `ccExpDate`      | `String`      |             |
| `ccHolder`       | `String`      |             |

###### ItemsPage

| Field     | Type           | Description |
| --------- | -------------- | ----------- |
| `nodes`   | `[ItemType!]!` |             |
| `hasMore` | `Boolean!`     |             |

###### ItemType

| Field                   | Type                       | Description |
| ----------------------- | -------------------------- | ----------- |
| `publicId`              | `String`                   |             |
| `price`                 | `Decimal!`                 |             |
| `extraCost`             | `Decimal!`                 |             |
| `totalPrice`            | `Decimal!`                 |             |
| `oneTime`               | `Boolean!`                 |             |
| `frozen`                | `Boolean!`                 |             |
| `firstPlaced`           | `DateTime`                 |             |
| `subscription`          | `SubscriptionType`         |             |
| `orderPublicId`         | `String!`                  |             |
| `offerPublicId`         | `String`                   |             |
| `subscriptionComponent` | `ComponentType`            |             |
| `components`            | `[ProductType!]!`          |             |
| `oneTimeIncentives`     | `[OneTimeIncentiveType!]!` |             |
| `quantity`              | `Int!`                     |             |
| `product`               | `ProductType`              |             |

###### SubscriptionType

| Field                          | Type                               | Description                           |
| ------------------------------ | ---------------------------------- | ------------------------------------- |
| `id`                           | `ID!`                              | The Globally Unique ID of this object |
| `publicId`                     | `String`                           |                                       |
| `quantity`                     | `Int!`                             |                                       |
| `price`                        | `Decimal`                          |                                       |
| `frequencyDays`                | `Int`                              |                                       |
| `every`                        | `Int`                              |                                       |
| `everyPeriod`                  | `Int`                              |                                       |
| `startDate`                    | `Date!`                            |                                       |
| `cancelled`                    | `DateTime`                         |                                       |
| `cancelReason`                 | `String`                           |                                       |
| `subscriptionType`             | `String`                           |                                       |
| `live`                         | `Boolean!`                         |                                       |
| `externalId`                   | `String`                           |                                       |
| `currencyCode`                 | `String`                           |                                       |
| `sessionId`                    | `String!`                          |                                       |
| `merchantOrderId`              | `String`                           |                                       |
| `created`                      | `DateTime`                         |                                       |
| `updated`                      | `DateTime`                         |                                       |
| `extraData`                    | `String`                           |                                       |
| `reminderDays`                 | `Int`                              |                                       |
| `product`                      | `ProductType`                      |                                       |
| `customer`                     | `CustomerType`                     |                                       |
| `shippingAddress`              | `AddressType`                      |                                       |
| `payment`                      | `PaymentType`                      |                                       |
| `merchantPublicId`             | `String!`                          |                                       |
| `offerPublicId`                | `String`                           |                                       |
| `cancelReasonCode`             | `CancelReasonType`                 |                                       |
| `components`                   | `[ComponentType!]`                 |                                       |
| `prepaidSubscriptionContext`   | `PrepaidSubscriptionContextType`   |                                       |
| `freeTrialSubscriptionContext` | `FreeTrialSubscriptionContextType` |                                       |
| `grantees`                     | `[GranteeType!]!`                  |                                       |
| `queuedActions`                | `[QueuedActionType!]`              |                                       |

###### ProductType

| Field               | Type                   | Description |
| ------------------- | ---------------------- | ----------- |
| `name`              | `String`               |             |
| `price`             | `Decimal!`             |             |
| `externalProductId` | `String!`              |             |
| `sku`               | `String!`              |             |
| `imageUrl`          | `String`               |             |
| `detailUrl`         | `String`               |             |
| `productType`       | `String!`              |             |
| `autoshipEnabled`   | `Boolean!`             |             |
| `autoshipByDefault` | `Boolean!`             |             |
| `discontinued`      | `Boolean!`             |             |
| `live`              | `Boolean!`             |             |
| `every`             | `Int`                  |             |
| `everyPeriod`       | `Int`                  |             |
| `extraData`         | `String`               |             |
| `created`           | `DateTime`             |             |
| `lastUpdate`        | `DateTime`             |             |
| `groups`            | `[ProductGroupType!]!` |             |
| `prepaidEligible`   | `Boolean!`             |             |

###### ProductGroupType

| Field       | Type      | Description |
| ----------- | --------- | ----------- |
| `name`      | `String!` |             |
| `groupType` | `String!` |             |

###### CancelReasonType

| Field    | Type      | Description |
| -------- | --------- | ----------- |
| `code`   | `Int!`    |             |
| `reason` | `String!` |             |

###### ComponentType

| Field      | Type          | Description |
| ---------- | ------------- | ----------- |
| `publicId` | `String!`     |             |
| `quantity` | `Int`         |             |
| `product`  | `ProductType` |             |

###### PrepaidSubscriptionContextType

| Field                          | Type       | Description |
| ------------------------------ | ---------- | ----------- |
| `prepaidOrdersRemaining`       | `Int!`     |             |
| `prepaidOrdersPerBilling`      | `Int!`     |             |
| `renewalBehavior`              | `String!`  |             |
| `lastRenewalRevenue`           | `Decimal!` |             |
| `prepaidOriginMerchantOrderId` | `String`   |             |

###### FreeTrialSubscriptionContextType

| Field            | Type          | Description |
| ---------------- | ------------- | ----------- |
| `days`           | `Int!`        |             |
| `expiration`     | `DateTime!`   |             |
| `product`        | `ProductType` |             |
| `conversionItem` | `String`      |             |
| `isInFreeTrial`  | `Boolean!`    |             |

###### GranteeType

| Field        | Type      | Description |
| ------------ | --------- | ----------- |
| `externalId` | `String!` |             |
| `name`       | `String!` |             |

###### QueuedActionType

| Field      | Type       | Description |
| ---------- | ---------- | ----------- |
| `publicId` | `String!`  |             |
| `skip`     | `Boolean!` |             |
| `index`    | `Int!`     |             |
| `ordinal`  | `Int!`     |             |
| `date`     | `DateTime` |             |

#### PageInfo

Information to aid in pagination.

| Field             | Type       | Description                                        |
| ----------------- | ---------- | -------------------------------------------------- |
| `hasNextPage`     | `Boolean!` | When paginating forwards, are there more items?    |
| `hasPreviousPage` | `Boolean!` | When paginating backwards, are there more items?   |
| `startCursor`     | `String`   | When paginating backwards, the cursor to continue. |
| `endCursor`       | `String`   | When paginating forwards, the cursor to continue.  |