# GiftIncentiveType

# GiftIncentiveType

### GiftIncentiveType

| Field      | Type          | Description |
| ---------- | ------------- | ----------- |
| `name`     | `String!`     |             |
| `publicId` | `String!`     |             |
| `target`   | `String!`     |             |
| `product`  | `ProductType` |             |

#### ProductType

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

##### ProductGroupType

| Field       | Type      | Description |
| ----------- | --------- | ----------- |
| `name`      | `String!` |             |
| `groupType` | `String!` |             |