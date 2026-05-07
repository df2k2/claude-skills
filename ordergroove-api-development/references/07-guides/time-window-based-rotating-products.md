# Time Window Based Rotating Products

Time-Window Rotation allows your customers to subscribe to a pre-determined series of products, based on time frames (windows). Each order sent for placement will be checked against the start and end dates you set, and the customer will be sent the appropriate item.

## Overview of Time-Window Based Rotating Products

Time-Window based Rotation depends on creating a list of **selection rules** (products associated with a starting date).

There are no explicitly defined ending dates for any single **selection rule**– ending dates are relatively defined by other selection rules in the rotation.\
The nearest upcoming starting date of another product determines the end date of the current one.

![](https://files.readme.io/a3c609a-Screenshot_2024-05-22_at_11.44.27_AM.png)

***

## Example Subscription

Let's take a look at an example customer subscription, using the image above. You have the following Time-Window based products:

* Brazilian Coffee Bag, Shipped from 8/1/24 to 9/1/24
* Light Roast Coffee Bag, Shipped from 9/1/24 to 10/1/24
* Specialty Blend Coffee Bag, Shipped from 10/1/24 to Ongoing

If a customer signs up for a *monthly subscription*, starting on 8/1, they will receive the following products:

1. Initial Checkout 8/1: Brazilian Coffee Bag
2. Recurring Order 9/1: Light Roast Coffee Bag
3. Recurring Order 10/1, 11/1, 12/1, etc: Specialty Blend Coffee Bag

If that same customer signs up for a *bi-weekly subscription* starting on 8/1, their shipments will look different:

1. Initial Checkout 8/1: Brazilian Coffee Bag
2. Recurring Order 8/15: Brazilian Coffee Bag
3. Recurring Order 8/29: Brazilian Coffee Bag
4. Recurring Order 9/12: Light Roast Coffee Bag
5. Recurring Order 9/26: Light Roast Coffee Bag
6. Recurring Order 10/10 and beyond: Specialty Blend Coffee Bag

***

## How Time-Window based Rotating Products Work

There are **3 validation rules** for defining these selection rules:

1. You must define at least one selection rule (we wouldn’t have anything to choose otherwise)
2. One of the selection rules must have a starting date in the past (so that we don’t ever have an invalid state where we don’t know which product should be delivered)
3. No two selection rules can have the same starting date (otherwise we wouldn’t know which product to choose between them, but you can have multiple selection rules with the same product)

### Product Selection

The product sent out for fulfillment during Order Placement will be based on the order’s place date of the item at Order Reminder time for normal flows.

For Send Now flows we will use the current date (at the time at which Send Now is triggered) to figure out which product to send out for fulfillment during Order Placement.

If the Order Reminder occurred before Send Now, the product will still be based on what was chosen during Order Reminder time.