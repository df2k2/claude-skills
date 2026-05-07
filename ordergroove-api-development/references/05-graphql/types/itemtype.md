# ItemType

# ItemType

### ItemType

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

#### SubscriptionType

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

##### ProductType

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

##### CustomerType

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

##### AddressType

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

##### PaymentType

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

##### CancelReasonType

| Field    | Type      | Description |
| -------- | --------- | ----------- |
| `code`   | `Int!`    |             |
| `reason` | `String!` |             |

##### ComponentType

| Field      | Type          | Description |
| ---------- | ------------- | ----------- |
| `publicId` | `String!`     |             |
| `quantity` | `Int`         |             |
| `product`  | `ProductType` |             |

##### PrepaidSubscriptionContextType

| Field                          | Type       | Description |
| ------------------------------ | ---------- | ----------- |
| `prepaidOrdersRemaining`       | `Int!`     |             |
| `prepaidOrdersPerBilling`      | `Int!`     |             |
| `renewalBehavior`              | `String!`  |             |
| `lastRenewalRevenue`           | `Decimal!` |             |
| `prepaidOriginMerchantOrderId` | `String`   |             |

##### FreeTrialSubscriptionContextType

| Field            | Type          | Description |
| ---------------- | ------------- | ----------- |
| `days`           | `Int!`        |             |
| `expiration`     | `DateTime!`   |             |
| `product`        | `ProductType` |             |
| `conversionItem` | `String`      |             |
| `isInFreeTrial`  | `Boolean!`    |             |

##### GranteeType

| Field        | Type      | Description |
| ------------ | --------- | ----------- |
| `externalId` | `String!` |             |
| `name`       | `String!` |             |

##### QueuedActionType

| Field      | Type       | Description |
| ---------- | ---------- | ----------- |
| `publicId` | `String!`  |             |
| `skip`     | `Boolean!` |             |
| `index`    | `Int!`     |             |
| `ordinal`  | `Int!`     |             |
| `date`     | `DateTime` |             |

#### OneTimeIncentiveType

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