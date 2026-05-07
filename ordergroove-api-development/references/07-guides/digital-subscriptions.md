# Digital Subscriptions

Digital subscriptions provide consumers with ongoing access to non-physical goods such as memberships, eLearning, streaming content, IOT access, and more. Unlike physical subscriptions, which involve logistics and inventory, digital subscriptions are fulfilled instantly and continuously through digital entitlements. This unlocks new monetization opportunities for merchants of all kinds:

* Stores that sell both physical and digital subscriptions (e.g. supplements and membership program)
* Stores that sell a physical product with a digital subscription plan (e.g. fitness tracker)
* Stores that sell only digital content (e.g. eLearning platform)

***

## How Digital Subscriptions Work

**Shared Domains**

Digital subscriptions share a majority of the Ordergroove platform with physical subscriptions, which provides many efficiencies for both you and your customers. All of the following data models are shared:

* Products and Items
  * Product type *plan*
* Subscriptions
* Orders
* Customers
* Payments

**Digital Domains**

There are two digital domains that are key to running a digital subscription program and are not leveraged when running physical subscription programs.

* Entitlements
  * Entitlements are the ledger of what of digital resources a customer currently has access to
  * Entitlements can be granted based on an order placed through the eCommerce checkout or via a recurring subscription order placed by Ordergroove
  * Entitlements remain available until their expiration date, even if a customer has canceled their subscription and does not have an upcoming renewal
  * [API Reference](https://developer.ordergroove.com/reference/entitlements-list)
* Resources
  * Resources are the specific benefits that can be accessed via an entitlement
  * Resources can be any product in your catalog, physical or digital
  * Each subscription to a digital plan will grant at least one resource upon signup and subsequent renewals
  * [API Reference](https://developer.ordergroove.com/reference/resource-list)

**Digital Plan Statuses**

A digital plan's status is determined by the combination of two different domains. First, whether or not the subscription is live and will renew. Second, whether the customer still has remaining access to that plan based on the plan's meta entitlement being live. The following statuses are what will be displayed by default across Ordergroove interfaces:

* Active = subscription is live (will renew), access via entitlement is live
* Cancelled = subscription is not live (will not renew), access via entitlement is live
* Inactive = subscription is not live (will not renew), access via entitlement is not live
* Pending = subscription is live (will renew), access via entitlement is not live

**Example (click to view full size)**

<Image align="center" border={false} src="https://files.readme.io/a4c19a6b3991c092d27879fad1fc037dbc51a1a6987e52faedc0cbe8b226970c-chart_update.png" />

***

## Additional Configurations

**Free Trials**

Oftentimes a digital subscription plan will come with a free trial. This can be configured in Ordergroove when creating or editing the plan. Using this capability allows you to schedule the first plan charge date without any development work and also allows Ordergroove to track free trial context for the purpose of analytics and optimization.

**Grace Period**

A grace period is used to grant customers additional access to their entitlements beyond the expiration date. A typical reason for leveraging this functionality could be to allow customers to continue to leverage your platform even if their renewal order is still being retried for payment.

If a grace period is configured on a plan in Ordergroove, the entitlements granted by that plan will show as live=true as long as it is in the range of the expiration date plus the grace period.

**Account Hierarchy**

With digital subscription programs, it's common that a single customer account (as defined by an ecommerce platform) will manage subscription plans on behalf of a number of distinct entities (e.g. children, pets, IOT devices, etc.). Ordergroove is adding out-of-the-box support for a number of different permutations of Account Hierarchy so that the platform is ready to deploy for any business model. Here are some examples:

* Account contains a single entity with shared entitlements
  * Single plan --> a paid loyalty program with one membership per account
  * Multiple plans --> a single account subscribes to both tuba and violin lessons
* Account contains multiple entities with distinct entitlements
  * Single plan per entity --> an account has home security cameras and office security cameras, both of which require a distinct plan
  * Multiple plans per entity --> a parent account enrolls multiple children in online learning, and each child subscribes to multiple subjects
  * Shared plan --> a single account grants multiple users access to a platform via a family plan

**Subscription Manager**

Ordergroove has added a brand new Subscription Manger template that is purpose built for digital subscriptions. To utilize this template, open the Subscription Manager theme designer and choose "Plans" as the subscription type.

<Image align="center" border={false} src="https://files.readme.io/34cccadfc69d0dcf46968f80b83e6e808e09b616a8b822cf09dffbe137b54ed8-Screenshot_2025-12-03_at_11.19.58_AM.png" />

If you're using Ordergroove for both physical (Products) and digital (Plans) subscriptions you can load distinct Subscription Manager themes into two different sections of My Account by following [this guide](https://developer.ordergroove.com/docs/ab-testing-your-subscription-manager#/).