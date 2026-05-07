# Subscription Manager From The Customer's Perspective

Once customers subscribe to your products, they can manage their ongoing orders through the Subscription Manager. It lives in the account section of your store, keeping their subscription and personal details secure.

The Subscription Manager ships with a default theme that's fully tested and ready to launch. If you'd like to customize the look and feel to match your site, head to Subscriptions > Management in Ordergroove's top navigation.

***

## Actions Customers Can Take In The Subscription Manager

The Subscription Manager allows customers to self-manage various aspects of their subscriptions by logging into their account on the store website.

<Image align="center" width="600px" src="https://files.readme.io/00f4194-Screen_Shot_2021-09-21_at_3.47.18_PM.png" />

### Send Now

Queues the order on Ordergroove’s servers for placement to your eCommerce system today rather than its originally scheduled date.  Once a customer clicks "Send ASAP," the order will go into an "Order Processing" state, where the customer can no longer make any edits to the order.  Any subscription items will have a new order created for today’s date + subscription frequency.

### Change Order Date

Updates the shipment date for the entire order. If changing the date causes the order to coincide with an existing order with the same billing and shipping information, the orders will be merged.

### Skip Shipment

Effectively cancels an order in the series of subscription orders. Calculates the next subscription order date by adding the subscription frequency to the current order date. This is true, regardless of today’s date.

### Remove Item From This Shipment

Remove an individual item from the order. Removing all items from an order effectively cancels the order (but not the subscription). When enabled, there must be at least two items in the order for this option to display.  This feature will apply to subscription items only - customers will be able to remove one-time Instant Upsell items even if it’s disabled in Ordergroove.

### Cancel Subscription

Cancels the subscription and any future orders to that item. Customers will be prompted to select a cancel reason.

### Pause Subscription

Changes the order date of the individual subscription item, rather than the entire order. This option will only display if there are at least two items in the order.

### Change Billing Information

Allows your customers to update their payment information. This will either link to an external payment wallet or open an Ordergroove modal, depending on payment vaulting ownership.

### Change Shipping Information

Allows your customers to update their shipping addresses. This will either link to an external address management page or open an Ordergroove modal, depending on program requirements.

> 📘 All of the features above are configured in [Ordergroove](https://rc3.ordergroove.com/), under Subscriptions > Management.

### Change Quantity

Change the quantity of an individual item. The quantity options for your subscription program can be configured in Ordergroove, under [Subscriptions > Subscription Settings](https://rc3.ordergroove.com/subscriptions/settings/).

### Change Frequency

Change the delivery frequency of an individual subscription item within the order. Changing the frequency has no impact on the next upcoming order date. The frequency options for your subscription program can be configured in Subscriptions > Subscription Settings.

### SKU Swap

This allows the customer to change their subscription product from a limited set of options (e.g., swap from one size to another for the same brand/style). SKU Swap groups can be defined using the [product configuration file](https://help.ordergroove.com/hc/en-us/articles/360041692694-How-to-Fill-Out-Your-Product-Configuration-File-Template-). SKU Swap is only available for subscription items, not one-time Instant Upsell items.

***

### The Subscription Cancellation Customer Experience

Within the Subscription Manager, users can opt to cancel their subscription by selecting the *Cancel Subscription* option at the subscription item level.

<Image align="center" src="https://files.readme.io/96d8a29-Screenshot_2023-03-22_180548.png" />

By clicking *Cancel Subscription*, your customer will be prompted to choose a reason from a list of cancellation reasons. A selection of a listed cancel reason is required to cancel their subscription. Upon selecting *“Other,”* the user will be required to fill in the free text box. To complete the cancelation, the user will need to select the CTA ‘*Cancel Subscription*.’

**Note**: If there are multiple items in an upcoming order, only the selected item will be canceled.

If the user opts not to cancel the subscription, they can click the CTA ‘**Nevermind**’ on the popup modal or the **X** in the upper right-hand corner.

***

## Cancellation Email

Once the user has canceled their subscription, a confirmation email will be sent to their associated email address confirming that cancelation. Within that email, the customer will see the product they have canceled and anchor links that redirect the customer either back to the product or their Subscription Manager to manage their subscriptions.

You can style and configure these transaction emails to align with your brand.

<Image align="center" width="600px" src="https://files.readme.io/dd5a209-cancel4.png" />

***

## Reactivating A Subscription

Canceled subscriptions live within the Subscription Manager, at the bottom of the interface under **Subscriptions (Inactive)** The product, cancellation date, and a button to reactivate appear for inactive subscriptions.

Your customers can reactivate their canceled subscription at any time within the Subscription Manager by clicking the **Reactive Subscription** button listed next to their inactive subscription. If the product that was part of that subscription has been discontinued, the option to reactivate the subscription will appear greyed out, and the user will be unable to reactivate that subscription.

<Image align="center" width="600px" src="https://files.readme.io/b210b6c-cancel3.png" />

***

## The Customer Payment Edit Experience

Ordergroove recommends a default payment method be set for all recurring orders. A customer’s subscription payment information will display on their Subscription Manager, select transactional emails (if configured), and within the CSA under their account details.

When a customer checks out with a subscription, you will vault and tokenize the payment method used and pass the token information and any relevant card details to Ordergroove via the Purchase Post. Subscribed customers should have access to stored payment details within their account settings to update this payment method as needed, and/or to set a default payment method to be used for recurring orders.

On the Subscription Manager, upon clicking **Change billing**, the customer will be redirected to their payment wallet on your site to edit or update their payment information.

When a customer updates their payment method, it should update the customer's payment information in Ordergroove, if they have existing subscriptions. In some cases this update will be automated, but depending on your implementation and requirements you may need to set up specific API requests to handle it. Please refer to your implementation documentation for platform-specific handling.

You will be unable to edit the customer’s payment within Ordergroove. All changes must be made to your e-commerce platform.

***

## On Shopify Payments

The customer will click on the Send Email button on the Subscription Manager page.

<Image align="center" width="600px" src="https://files.readme.io/49d2ba7-shopifysmi.jpg" />

The customer will receive an email, directing them to provide new payment information through a checkout-type page on your Shopify store. From there, the customer can add a new credit card to their profile.

<Image align="center" width="600px" src="https://files.readme.io/8373789-shopifysmi3.jpg" />

Shopify will let Ordergroove know that the customer has updated their credit card. Ordergroove will update all of the subscriptions for that customer to use that new credit card.