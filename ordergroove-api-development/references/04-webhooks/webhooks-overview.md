# Webhooks Overview

Webhooks are proactive notifications, via HTTP requests from one application to another, that a specific event has occurred. Put simply, webhooks allow you to send Ordergroove to proactively contact your application(s) with information about the events that happen in your subscription program - for example, if a subscription is created, an order is skipped, etc.

Here is a simplified example:

<Image align="center" border={false} src="https://files.readme.io/1e4e653-797cb96-Screenshot_from_2020-09-17_14-12-49.png" />

## Why Would I Use Webhooks?

Webhooks allow you to create custom applications that automate or create additional functionality and experiences not otherwise native to Ordergroove's platform. Some examples you might use a webhook for:

* Automatically cancel a subscription after a certain number of shipments
* Update your CRM with information about subscribers, subscriptions, and orders
* Send additional marketing emails at significant points in a subscription or subscriber's lifecycle

**Note**: Ordergroove runs the webhook delivery process every 5 minutes, and anything that still is in the queue gets retried.

***

## Create and Manage Webhooks

You can create, configure, and disable webhooks in the [Ordergroove Admin](https://rc3.ordergroove.com/webhooks/). **Note**: you will need an Ordergroove login, your organization can set one up.

1. Log in to [Ordergroove](https://rc3.ordergroove.com/webhooks/).
2. Go to **Developers** on the top toolbar, and select **Webhooks**.
3. Click **+ CREATE WEBHOOK** to begin
4. Select which events you want to receive webhook notification for and any additional webhooks data that you want included in the payload. For example, an order event will only contain order level information. If you select to add subscription and item level data, that will also be sent in the payload of the webhook.

<Image align="center" border={false} width="575px" src="https://files.readme.io/3c4a505-7fb256b-image1_clean.png" />

***

## Authentication

Verification keys are used to sign webhook requests, allowing the recipient to verify that the requests are genuinely issued by Ordergroove. In the event the verification key of a given route needs to be changed, because it got compromised or due for routine security updates, it is possible to start a key rotation process so that webhooks requests start being signed with a new key.

### Key Rotation Process

When the key rotation process is initiated for a webhook route, a transitional period of 24 hours begins. During this period, the Ordergroove-Signature header in webhook requests will include signatures for both the new and the old verification keys.

The format for these headers will be `ts=<TIMESTAMP>,sig=<PAYLOAD_SIGNED_WITH_NEW_KEY>,sig=<PAYLOAD_SIGNED_WITH_OLD_KEY>`. This dual-signature approach ensures a smooth transition, allowing the recipient to verify the webhook requests using either the old or the new key.

### Transition Completion

After the 24-hour transition period, the Ordergroove-Signature header will revert to its standard format, containing only the new key signature: `ts=<TIMESTAMP>,sig=<PAYLOAD_SIGNED_WITH_NEW_KEY>`.

At this point, the old verification key becomes obsolete for request verification. It is imperative that all webhook recipients update their systems to use the new verification key within this 24-hour window to maintain uninterrupted verification of webhook requests.

In order to initiate a verification key rotation process for a given webhook, follow these steps:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to Developers > Webhooks.
3. Locate the webhook you want to enable, click the **3 dots**, and select **Regenerate key**.

<Image align="center" border={false} src="https://files.readme.io/12c01b8-image12_regenerate_clean.png" />

4. Confirm the operation by clicking **Regenerate key**

<Image align="center" border={false} src="https://files.readme.io/7e265b5-image4.png" />

5. After the operation completes successfully, the new key is available for copying it from the Verification Key column and adopting it in the recipient servers.

***

## Test Events

You can  test your webhook events right in Ordergroove without going to your website to make a test customer and manually creating subscriptions with your credit card.

The *webhooks test events* feature allows you to generate fake payloads for different types of events. This will help you early in the implementation process by making sure your webhook target can receive the data and parse it correctly.

### Sending Test Events

1. Log in to [Ordergroove](https://rc3.ordergroove.com/), and go to Developers > Webhooks.
2. Locate the Webhook you want to test, and click the configuration dropdown to the right.
3. Select **Send test events**
4. A pop-up will ask you to **Confirm**, and the test events are sent.

<Image align="center" border={false} src="https://files.readme.io/c1295d8-image3_clean.png" />

### Results

You can see the delivery result of the test events in the *deliveries log page.*

***

## FAQ

**Can I Configure Only Some Events To Be Sent To My Endpoint?**\
Yes! We have now included the ability to filter which Webhook events are sent to each of your targets.