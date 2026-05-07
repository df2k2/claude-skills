# Staged Migrations

Staged migrations allow you to migrate from another subscription platform to Ordergroove in phases by dividing your subscriber base into smaller batches that are moved incrementally. Both platforms remain active throughout the process until migration is fully complete.

This guide details one specific type of migration, for a general overview take a look at [Migrate my data to Ordergroove](https://developer.ordergroove.com/docs/program-migration).

***

## Roles and Responsibilities

### Merchant Team Responsibilities

Merchant dev teams are responsible for building the mechanisms to route customers to the correct place, mitigate/correct any potential issues, and determine the overall process and timeline of events to ensure migration is successful

### Ordergroove Responsibilities

Ordergroove is responsible for assisting with the data ingestion process and can help you test your data, provide guidance on file format requirements, and help to plan the timeline of events

***

## Benefits and Risks of Staged Migrations

A staged migration enables you to observe how smaller chunks of subscribers perform on Ordergroove and identify potential inconsistencies within a smaller dataset before ingesting larger amounts of data. While this can be beneficial in allowing for real-world testing and comparison in parallel, it adds several additional considerations in managing two completely independent data sets on two completely different systems, and does not minimize the potential for errors.

**Benefits**

* Gradual subscriber migration allows performance monitoring across both systems.
* If significant issues arise in early batches, they can be removed from Ordergroove, corrected, and reprocessed at a smaller scale.

**Risks**

* **Data integrity and portability**: Maintaining separate data sets in multiple systems increases complexity. Data may become difficult—or impossible—to move between platforms as it evolves.
* **Resource demands**: Running parallel systems requires additional development work and safeguards. If the migration is outsourced, this may lead to increased scope and billable hours.
* **System complexity**: Ordergroove supports data ingestion consistently, whether done gradually or all at once. The additional burden for staggered migration falls largely on the merchant and development teams. Ordergroove’s involvement may be limited to validating data readiness for ingestion.
* **Timeline impact**: Extending the migration over a longer period may delay full transition to the new eCommerce system, potentially affecting business operations.

***

## Technical Requirements

### Data Hygiene

Clean, high-quality data is the single most important factor in ensuring a successful data migration—regardless of whether you're planning a full ingestion into Ordergroove at once or opting for a phased approach.

Our most successful migrations result from consistent, thorough testing using [Ordergroove’s migration tool](https://help.ordergroove.com/hc/en-us/articles/42087029479827-Migrating-your-Data-with-the-New-Migration-Tool). This tool enables you to upload data files and review processed subscription records in two categories:

* **Needs Review**: These records contain data inconsistencies or issues that will prevent successful migration. Ideally, these should be corrected in the source system, but at a minimum, they must be fixed in the upload file before being reprocessed.
* **Ready to Go**: These records have passed validation and meet all data requirements. They are ready for ingestion into Ordergroove.

### Determining Migration Batches

* In order to effectively test batches of subscribers, you should identify the sample sizes that work best to test various scenarios (different payment methods, different subscription types, etc)
* **Active vs Inactive Subscribers** - Once this is established, then the active subs should be migrated by the next order date.

### Timeline Planning

Given the added complexity of a scaled migration, Ordergroove strongly recommends minimizing the duration during which two separate data sets are actively maintained. Running parallel systems increases the risk of data drift, synchronization issues, and operational overhead.

To reduce exposure, aim to validate and finalize early migration batches as quickly as possible. Our guidance is to limit the parallel run period to **no more than 2–3 weeks**, during which both systems should be closely monitored for data inconsistencies, sync errors, and unexpected behavior.

The shorter this dual-system window, the lower the risk and the smoother the transition.

### Two Separate Stores

This approach is designed for merchants operating separate stores or sites, where one can run the legacy subscription platform while the other operates on Ordergroove.

***

## Platform and Payment Processor Implementation Requirements

### System Architecture Requirements

To facilitate a staged migration, you must meet several requirements. At a high level, you must be able to move customers from legacy systems into Ordergroove completely, in no scenario should a given customer exist in both places in an active state. This has implications for both existing subscribers and for new subscription creation, depending on how you handle:

#### Existing subscriber handling

* You are able to operate/maintain two separate production environments in parallel to prevent cross-pollination of subscribers/subscriber data
  * 2 subscriber data sets (customers migrated into Ordergroove, and customers still on legacy systems/not yet migrated to Ordergroove)
  * 2 places for subscribers to see and manage subscriptions
    * When any of your existing subscribers log in, they will need to be routed to the correct environment where they can manage their subscriptions

#### New subscription creation

* With two environments running in parallel, you will need to decide where new subscribers/subscriptions are created. You may choose to enable Ordergroove on the “live” site and maintain a place for legacy subscribers not yet moved to Ordergroove to continue managing subscriptions, or you may choose to keep the legacy system on the front end (eg continue creating new subscriptions in the legacy system while moving batches of subscribers into Ordergroove.) This decision has different potential risks:
  * If Ordergroove is “live” on production, existing subscribers still in the legacy system may create new subscriptions in Ordergroove.
    * The customer will have subs in both systems. It will be challenging to direct customers to the correct location to manage their subscriptions.
    * The customer may inadvertently sign up for a duplicate subscription on the new site that already exists on the legacy site.
  * If the legacy system remains “live” on production, subscribers who have already been migrated to Ordergroove may create new subscriptions in the legacy system.
    * [Ordergroove’s migration tool](https://help.ordergroove.com/hc/en-us/articles/42087029479827-Migrating-your-Data-with-the-New-Migration-Tool) allows you to add new subscriptions for existing users, but to avoid duplication of data the format of the data must be changed to associate the new subscription with the existing customer/address/payment/subscription data already in Ordergroove - this can add substantial effort in updating existing subscribers already in Ordergroove with the new/additive subscriptions.
    * Customers who add new payment information for new subscriptions in the legacy system will need to have their payment method tokenized with Shopify Payments.

### Payment migration considerations

Your migration may require payment changes or re-tokenization, which introduces added complexity and increases risk—particularly when managing parallel data sets across systems. Key considerations include:

* **Gateway-specific behavior**: Different payment gateways may return varied responses and error codes, resulting in inconsistent data and performance metrics across systems. Testing and error-handling logic must account for these discrepancies.
* **Third-party limitations**: Payment migrations are often handled by third-party vendors who may lack the ability to re-tokenize or create payment records at scale. This can lead to bottlenecks or non-uniform handling of payment data.
* **Dual payment systems**: Just as dual subscription data sets introduce risk, maintaining two separate sets of payment information adds complexity. If customers update their payment methods during the migration window, you may need to perform additional reconciliation or re-tokenization to handle changes and deltas between systems.

Mitigating these risks requires careful coordination between platform teams, payment providers, and any third-party migration vendors involved.

***

## Monitoring and Validation

A phased migration strategy enables continued support for recurring subscription orders across both systems: migrated customers can be processed via Ordergroove, while non-migrated customers continue through the legacy platform.

Ordergroove provides visibility into order activity through its **Analytics interface** and **order placement logs**, which can be used to validate behavior and monitor performance during migration.

Note that differences in data structures, logging formats, and event timing between systems may lead to discrepancies in reporting. Reconciling these differences may require custom analysis, data transformation, or integration logic to ensure accurate cross-system comparisons.