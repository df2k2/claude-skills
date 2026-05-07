# Migrating Digital Subscriptions

This guide covers how to migrate existing digital subscriptions into Ordergroove. If you're moving customers from a third-party platform — or from a custom integration — the migration process will create subscription records in Ordergroove and, where applicable, grant the appropriate entitlements so customers retain access to their digital content without interruption.

Before proceeding, it's worth familiarizing yourself with how digital subscriptions work in Ordergroove, particularly the concepts of entitlements, resources, and plan statuses, as these are central to understanding migration behavior. See [Digital Subscriptions](https://developer.ordergroove.com/docs/digital-subscriptions) for a full overview.

***

## Overview

At a high level, the migration will:

1. **Create the subscription record(s)** in Ordergroove based on your existing subscriber data.
2. **Optionally grant entitlements (access to digital resources)** based on whether the subscription is live and/or has an expiration anchor (typically `next_order_date`, unless overridden by `entitlements_expiration_override`).

A few things to keep in mind before you begin:

* Free trial status from your previous platform is not carried over. If a customer was in a free trial, their first charge date should be reflected in `next_order_date`.
* The migration is not retroactive — entitlements are only granted based on the data provided in the migration payload, not inferred from billing history.
* For the general migration file format and shared fields, refer to the [Program Migration](https://developer.ordergroove.com/docs/program-migration) guide. This document covers only the digital-specific fields and behavior.

***

## Requirements

* You are migrating **digital subscriptions** (where the subscription record includes `"is_digital": true`).
* The **plan/product** referenced by `"product"` is already configured in Ordergroove as a **digital plan** that grants one or more **resources** (e.g., `Access`, `Support`, `Discounts`).
* Your migration payload includes a `subscriptions` array with the following:
  * `live` (boolean)
  * `next_order_date` (future date or null)
  * `entitlements_expiration_override` (optional, only valid for not live subscriptions)
  * `grantees` (array of objects, optional)
* Whether or not a subscription initially had a free trial, or is currently in a free trial, is not considered during the migration process

***

## Input Shape

The digital subscription input shape is as follows, please refer to [Program Migration](https://developer.ordergroove.com/docs/program-migration) for the full migration file format:

```json
{
  "...": "...",
  "subscriptions": [
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": true,
      "next_order_date": "2027-01-01",
      "entitlements_expiration_override": "2027-01-02",
      “grantees”: [
        {
          "external_id": "student_1234",
          "name": "John Doe"
        }
      ]
    }
  ]
}
```

***

## Scenario Examples

### 1. Subscription is live

Input:

```json
"subscriptions": [
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": true,
      "next_order_date": "2027-01-01"
    }
```

Expected Result:

* ✅ Subscription is created
* ✅ Entitlements granted for all resources associated with the plan (e.g. `Access`, `Support`, `Discounts`), expiration will match next\_order\_date
* ❌ entitlements\_expiration\_override is not supported on live subscriptions
* ❌ If subscription is live and next\_order\_date is null or in the past, the subscription will not be created and an error is thrown

<br />

### 2. Subscription is not live

Input:

```json
"subscriptions": [
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": false,
      "next_order_date": null,
      "entitlements_expiration_override": "2027-01-02"
    }
```

Expected Result:

* ✅ Subscription is created
* ⚠️ `next_order_date` will be ignored and set to null in all cases because no upcoming order exists for not live subscriptions
* ✅ Entitlements will not be created for not live subscriptions unless `entitlements_expiration_override` is present and set to a future date
* ✅ If `entitlements_expiration_override` is present, entitlements will be granted for all resources associated with the plan (e.g. `Access`, `Support`, `Discounts`), with expiration set to the date provided

<br />

### 3. Multiple subscriptions to different plans, with shared resources

Input:

```json
"subscriptions": [
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": true,
      "next_order_date": "2027-01-01"
    },
    {
      "is_digital": true,
      "product": "prod_ext_id_2",
      "live": true,
      "next_order_date": "2027-01-01"
    }
```

Assume:

* Plan `prod_ext_id_1` grants resources `Access`, `Support`
* Plan `prod_ext_id_2` grants resources `Access`, `Discounts`

Expected Result:

* ✅ Both subscriptions are created
* ✅ Resource expirations will stack so in this case the customer will have:
  * Entitlements to `Support`, and `Discounts` until 2027-01-01
  * If the migration was run on 2026-01-01, the expiration date of `Access` would be 2028-01-01 (two years worth of the entitlement)

<br />

### 4. Multiple subscriptions for a single customer to the same plan, One Subscription Per Plan is enabled

Input:

```json
"subscriptions": [
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": true,
      "next_order_date": "2027-01-01"
    },
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": true,
      "next_order_date": "2027-01-01"
    }
```

Expected Result:

* ❌ This scenario is not allowed when One Subscription Per Plan is enabled for a particular plan. No subscriptions or entitlements will be created.
* ⚠️ When grantees are present, One Subscription Per Plan is enforced at the grantee level rather than the customer level

<br />

### 5. Multiple subscriptions for a single customer to the same plan, One Subscription Per Plan is disabled

Input:

```json
"subscriptions": [
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": true,
      "next_order_date": "2027-01-01"
    },
    {
      "is_digital": true,
      "product": "prod_ext_id_1",
      "live": true,
      "next_order_date": "2027-01-01"
    }
```

Expected Result:

* ✅ Both subscriptions are created
* ✅ Entitlement expiration for the resources associated with the plan (e.g. `Access`, `Support`, `Discounts`) will stack, so in this case if the migration was run on 2026-01-01 the expiration date of the resources would be set to 2028-01-01
* ✅ Both subscriptions will share the same `next_order_date`, which in this case will be set to 2028-01-01