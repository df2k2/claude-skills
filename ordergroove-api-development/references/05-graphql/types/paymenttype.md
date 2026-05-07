# PaymentType

# PaymentType

### PaymentType

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

#### AddressType

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