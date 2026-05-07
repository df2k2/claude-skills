# Tracking Affiliate Codes on Recurring Orders

Brands and retailers can track affiliate codes (and other similar data) on recurring orders by referencing the initial order that created the subscription.

***

## 1. Subscribe to Ordergroove Webhooks

1. Navigate to the Webhooks section of Ordergroove.
2. Enable the toggle by clicking it to ON.
3. In the URL field, enter the endpoint where you wish for all events to be sent.
4. Click the Save button.
5. Once saved, a verification key will populate in the Verification Key field.
6. Click the Copy button to automatically copy the key to your clipboard.

***

## 2. Listen for the item.successfully\_placed event

* This event will fire for each item successfully placed with a recurring order.
* Retrieve the JSON subscription ID that created the item.

<Image align="center" width="550px" src="https://files.readme.io/445ebc4-Snip20210316_10.png" />

***

## 3. Call Subscriptions-Retrieve REST API

* Using the subscription ID from the previous step as the URL parameter in the request
* Retrieve the merchant\_order\_id that created the subscription

<Image align="center" width="500px" src="https://files.readme.io/0310e53-Snip20210316_11.png" />

***

## 4. Retrieve relevant affiliate data

Use the order ID from the previous step to retrieve the relevant affiliate data from your e-commerce platform.