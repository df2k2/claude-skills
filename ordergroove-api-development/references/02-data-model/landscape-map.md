# Systems Landscape Map

Ordergroove’s platform has **six (6) major integration components** that will power your relationship commerce experience. This is also the recommended build order that takes into consideration integration dependencies.

1. [The Product Feed](#the-product-feed)
2. [Offers](#offers)
3. [Purchase Post](#purchase-post)
4. [Subscription Manager](#subscriber-dashboard)
5. [Order Placement](#order-placement)
6. [Customer Update APIs](#set-contact-details-api)

If you're on a supported eCommerce platform, our applications and cartridges handle many of these components for you automatically. We still recommend reading through them all though — having the full picture makes the integration easier to reason about, even when the work is being done for you.

***

## Offers

Offers are widgets placed onto multiple pages on your website that give a customer the option to enroll or subscribe to products that you have made eligible.

Typically they are hosted by Ordergroove and injected onto your website via Javascript, which we refer to as "page tagging." When using an Ordergroove App or Cartridge, this tagging is generally automated. For instructions on offer tagging please review the [Offer Tagging](https://developer.ordergroove.com/docs/offer-tagging) section of the documentation.

The Javascript for these widgets will attempt to copy your site’s existing HTML and CSS upon injection. They can also be styled and managed within Ordergroove.

If you wish, you may also host the offers directly on your site built on top of our headless APIs, which can be found in our Developers Portal.

### Promotions

Promotions are the underlying incentives that offers display and are used to entice a customer to sign-up for a subscription to your products and one continually given to the customer to keep them subscribing to your products.

The types of promotions used can vary greatly but some common examples include a % off, free shipping, a gift with purchase, and best deal guaranteed. You’ll be able to create and manage these promotions within Ordergroove.

***

## Subscription Manager

The Subscription Manager is a webpage that appears on your website behind their customer login screen that allows subscribers to manage their subscriptions. Similar to offers, this page is typically hosted by Ordergroove and injected onto your website via Javascript and an HTML element tag. However, should you wish, there are options for you to host and power this front end using Ordergroove APIs.

The Subscription Manager has options for a customer to manage their subscription, including changing the order's quantity, changing shipping frequency, skipping an order, sending an order now, and canceling a subscription.

The Subscription Manager can be managed and styled within Ordergroove.

Take a look at [Subscription Manager Overview](https://help.ordergroove.com/hc/en-us/articles/360051685314-Subscriber-Dashboard-Overview) in the Knowledge Center for more information and the [Subscription Manager Tagging and Authentication](https://developer.ordergroove.com/docs/subscription-manager-tagging-and-authentication) documentation.

***

## The Product Feed

The Product Feed is an XML file, in a prescribed format, that is sent to Ordergroove on a recurring basis via SFTP, which provides us with up-to-date information about your product catalog. Ordergroove uses this information to power your relationship commerce experiences.

You can configure which SKUs in your catalog are eligible for different Ordergroove Relationship Commerce solutions (e.g., subscription eligibility, instant upsell eligibility, etc.). Thus, they will be displayed on your website for enrollment.

Ordergroove can ingest a Product Feed up to every 30 minutes, on the half-hour. Note: OG does not track inventory counts, only stock status.

The [Product Feed](https://developer.ordergroove.com/docs/integrating-with-a-custom-platform) article in the Knowledge Center has additional information.

***

## Purchase Post

The Purchase Post is how a subscription record is created on the Ordergroove platform. This is done by sending a secure HTTP POST during the checkout process that provides Ordergroove with all of the necessary information to create one or more subscriptions on Ordergroove’s servers. It records the subscription SKU(s), order placement frequency, the customer’s ID with the eCommerce platform, and the payment token to be used for recurring charges.

Take a look at [Subscription Creation via Purchase POST](https://developer.ordergroove.com/docs/subscription-creation-via-purchase-post) in the Knowledge Center for more information.

***

## Order Placement

Order Placement is when Ordergroove places order requests into your eCommerce platform based on the current customer’s subscription records and their respective frequencies saved within the Ordergroove platform.

The [Recurring Order Placement](https://developer.ordergroove.com/docs/recurring-order-placement) article in the Knowledge Center has more information.

***

## Set Contact Details API

The Set Contact Details API is used when a customer changes the email address associated with their account on your website so that Ordergroove can be notified of this change. This is done through the Set Contact Details API.

Take a look at [Set Contact Details](https://developer.ordergroove.com/reference/customers-set-contact-details) API reference for additional information.

<Image align="center" src="https://files.readme.io/6893e2337bd3aec510c3217915added91f1bf1fd652ea606dba928ca294991e9-UpdatedLandscapeMap2025.png" />