# Rest vs GraphQL

This document covers the key differences between Ordergroove's REST API and GraphQL API for developers familiar with one and moving to the other.

## Field Naming

The REST API uses **snake\_case**. The GraphQL API uses **camelCase**. When mapping fields with both APIs you will need to convert between the naming conventions.

### Examples

| REST                 | GraphQL            |
| -------------------- | ------------------ |
| `public_id`          | `publicId`         |
| `merchant_user_id`   | `merchantUserId`   |
| `cc_number_ending`   | `ccNumberEnding`   |
| `every_period`       | `everyPeriod`      |
| `frequency_days`     | `frequencyDays`    |
| `cancel_reason_code` | `cancelReasonCode` |
| `shipping_total`     | `shippingTotal`    |
| `order_merchant_id`  | `orderMerchantId`  |

## DateTime Format

All `DateTime` fields in the GraphQL API conform to [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) standards and include an explicit America/Chicago UTC offset. The correct offset is determined per value.

### Date-only fields

Some fields represent a calendar date with no meaningful time component. Because GraphQL exposes them as `DateTime`, they will always carry `T00:00:00` in the response:

| Field                    | Notes                             | Example                     |
| ------------------------ | --------------------------------- | --------------------------- |
| `subscription.startDate` | Backed by a date-only model field | `2024-03-15T00:00:00-06:00` |

For these fields, only the date portion is meaningful — the time can be ignored.