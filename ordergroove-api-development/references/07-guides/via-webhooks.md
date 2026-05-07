# Webhooks overview (Legacy)

Webhooks are proactive notifications, via HTTP requests from one application to another, that a specific event has occurred. Put simply, webhooks allow you to send Ordergroove to proactively contact your application(s) with information about the events that happen in your program - for example, if a subscription is created, an order is skipped, etc.

Here is a simplified example:

<Image align="center" src="https://files.readme.io/fcefe25-Screenshot_from_2020-09-17_14-12-49.png" />

***

## What Events Are Currently Available?

* [Subscriber events](https://developer.ordergroove.com/reference/webhooks-subscriber-events)
* [Subscription events](https://developer.ordergroove.com/reference/webhook-subscription-events)
* [Order events](https://developer.ordergroove.com/reference/webhooks-order-events)
* [Order item events](https://developer.ordergroove.com/reference/webhooks-item-events)

***

## Set up Webhooks

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Open up the **Profile Icon** on the top right, select **Developers** and **Webhooks**.
3. Click the **Enable Toggle** to activate a new target.
4. **Paste** the endpoint where you want the events to be sent in the URL Field.
5. Click **Save**.

Once saved, a verification key will populate in the Verification Key field. You can create up to 10 separate targets for your store.

<Image align="center" src="https://files.readme.io/3ed7360-Screenshot_2023-05-09_at_09_44_01.png" />