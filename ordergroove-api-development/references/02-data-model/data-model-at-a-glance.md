# Data model at a glance

Ordergroove’s data model is designed to provide flexibility to end users with a structure that allows for full automation or client-specific processes via rest APIs. All data is stored in a Relational Database, with both one-to-one and one-to-many relationships depending on how you look at the data.

There are four main data objects:

1. [Customer](#customer)
2. [Subscription](#subscription)
3. [Items](#items)
4. [Order](#order)

<Image align="center" border={true} src="https://files.readme.io/1549b67-Ordergroove_Data_Model.png" className="border" />

***

## API ERD

<Image align="center" src="https://files.readme.io/068da74943082b491d08068c22f98a3090d19a6fe59fdc4f1a0d3cf7db5e04dd-b1620826831e8092a63af7dc4f79c42193c24cb007b000b15dc61b256862c797-OG-ERD.png" />

***

## Merchant

Every Ordergroove client and unique integration has a merchant record in Ordergroove. Some clients may have multiple sites (separate brands, locales, etc); these are usually separate Merchants in Ordergroove. A merchant is usually represented by a *Merchant Public ID* when interacting with Ordergroove API endpoints.

***

## Customer

Customers are created in Ordergroove via purchase post, or via customer migrations from other platforms. Customers have Subscriptions, which are tied to active customer Address and Payment information.

### Important Customer Data

* id (Ordergroove customer ID)
* merchant\_id (Ordergroove Merchant ID)
* merchant\_user\_id (customer ID in eCommerce platform)
* first\_name (encrypted)
* last\_name (encrypted)
* email (encrypted)

### Key Relationships

* Customer > Subscription
* Customer > Order
* Customer > Address
* Customer > Payment

***

## Subscription

Customers have subscriptions. Each product a customer is subscribed to is its own subscription, and is referenceable via a subscription public ID. A subscription creates a recurring order based on the subscription’s frequency, and the discounts applied to the item or order subtotal are determined by the Offer ID associated with the subscription.

### Important Subscription Data

* id (Ordergroove subscription ID)
* public\_id (public Subscription ID)
* customer\_id (Ordergroove customer ID of customer associated with this subscription)
* product\_id (Ordergroove product ID, the product subscribed to)
* quantity (quantity of product subscribed to)
* payment\_id (Ordergroove payment ID, the payment object associated with this subscription)
* shipping \_address\_id (Ordergroove payment ID, the shipping address object associated with this subscription)
* frequency\_days (number of days between each subscription order’s place date)
* offer\_id (the Ordergroove offer ID tied to the subscription, this links incentive logic for recurring orders to the subscription)
* merchant\_order\_id (the ecommerce order number that created the subscription)
* live (Boolean value, live=0 customer has no active subscriptions, live=1 customer has at least one active subscription)
* every (numeric value of frequency)
* Every\_period (numeric value of the frequency period, 1=days, 2=weeks, 3=months, 4=years)

### Key Relationships

* Subscription > Item
* Subscription > Offer (incentive)

***

## Order

Orders are created by subscriptions, and contain items and all relevant information used to place orders to your eCommerce platform. Orders contain one or more items, and their place date is determined by previous order date + subscription frequency. Subscriptions only have one upcoming order, a subsequent order will be created when the current order is placed.

### Important Order Information

* id (Ordergroove order ID)
* public\_id (public order ID)
* customer\_id (Ordergroove customer ID of customer associated with this subscription)
* place (the date the order placement date, either a future date for unsent orders or a past date for orders that have been attempted)
* Status (current state of the order in the Ordergroove system) - We have a full list in [Order Status Codes](https://developer.ordergroove.com/reference/order-status-codes), but here are some of the most common statuses:
  * 1 - unsent
  * 3 - rejected
  * 5 - success
  * 6 - send now
  * 11 - pending placement
  * 15 - generic error
  * 18 - credit card retry
* sub\_total (order subtotal after subscription discounts)
* shipping\_total (shipping fee applied by Ordergroove)
* total (sub\_total + shipping\_total)
* order\_merchant\_id (order ID returned by eCommerce platform upon successful order placement)
* payment\_id (ID of the payment record used for the order)
* shipping\_address\_id (ID of the shipping address record used for the order)

### Key Relationships

* Order > item
* Order > One Time Incentive

***

## Items

Items are the individual products within an order. They may be associated with a subscription, or can be a one-time product that was added to a single order.

### Important Item Information

* Id (Ordergroove item ID)
* Public\_id (public item ID)
* Order\_id (Ordergroove order ID associated with the item)
* Subscription\_id (Ordergroove subscription ID associated with the item - will be NULL for one-time IU)
* Product\_id (Ordergroove product ID for the item - may be NULL for upcoming subscription items and will be populated after the order places)
* Quantity (item quantity)
* Price (unit price)
* Total\_price (line item price accounting for quantity and discount
* Offer\_id (the Ordergroove offer ID tied to the item, this links incentive logic for recurring orders to the subscription - this may be NULL for subscriptions created using the [Subscription Create In Order](https://developer.ordergroove.com/reference/subscriptions-create-in-order) endpoint)
* One\_time (Boolean indicator of the item being added using the [Item Create In Order](https://developer.ordergroove.com/reference/items-create-in-order) endpoint)

### Key Relationships

* Items > Subscriptions
* Items > Orders
* Items > Offer (Incentive)

***

## Product Information

Products is a replication of relevant product data from your eCommerce site, along with subscription-specific attributes to control an individual product’s eligibility for recurring purchase.

### Important Product Information

* Id (OG product ID)
* Price (product price received from product feed, the base price Ordergroove uses)
* External\_product\_id (the product’s unique identifier in your eCommerce platform)
* Autoship\_enabled (Boolean value, autoship\_enabled=0 the product is not available to be subscribed to on your website, autoship\_enabled=1 the product is available to be subscribed to on your website