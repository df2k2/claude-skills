# Free Trials

These endpoints let you configure free trials for a given product. Currently, this feature is only fully supported for digital products.

## How Free Trials Work

When you configure a free trial on a product, you must specify the duration in days.\
Once a subscription is created for that product:

* **Next order date:** Instead of following the plan’s regular cadence, the subscription’s first next order date is set to the subscription creation date plus the configured free trial days.
* **Entitlements for digital plans:** If the product is a digital plan, the time-based entitlements created will expire when the free trial ends, rather than using the duration defined in the plan’s resource grants.
* **Persistence of configuration:** If the free trial configuration for a product is updated later, existing subscriptions will keep their original free trial settings. The new configuration only applies to subscriptions created after the change.
* **Uniqueness:** Each product can have only one free trial configuration at a time.

You can use the endpoints in this section to create, update, or delete a free trial configuration.

***

## Example Lifecycle

**Scenario:** A product is configured with a 14-day free trial.

1. **Day 0 (Subscription creation):**
   * Customer subscribes to the product.
   * The next order date is set to *Day 14* instead of following the plan’s cadence.
   * Entitlements are granted to the customer, set to expire on *Day 14*.

2. **Day 14 (End of free trial):**
   * Free trial entitlements expire.
   * The first paid billing cycle begins.
   * The next order date is now set according to the product’s subscription cadence.
   * New entitlements are created with the regular expiration rules defined in the product’s plan.

3. **Configuration changes:**
   * If the merchant changes the free trial duration to 30 days on *Day 5*, existing subscriptions (those started on *Day 0*) will still end their trial on *Day 14*.
   * Only subscriptions created after *Day 5* will get a 30-day free trial.

***