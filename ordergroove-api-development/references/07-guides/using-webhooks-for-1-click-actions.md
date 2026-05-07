# Using Webhooks for 1-Click Actions

1-click actions let your subscribers manage their subscriptions directly from emails - delaying shipments, reactivating subscriptions, or taking other actions - with a single click. Instead of logging into the subscription manager, they click a URL in your email, land on a confirmation page, and the action processes automatically.

<Callout icon="📘" theme="info">
  Using Klaviyo or Attentive? We've already built 1-click actions for these platforms. Check out our [Klaviyo documentation](https://help.ordergroove.com/hc/en-us/articles/13554075021971-Add-1-Click-Actions-to-Klaviyo-Flows) and [Attentive documentation](https://help.ordergroove.com/hc/en-us/articles/27625934837651-Add-1-Click-Actions-to-Attentive-Journeys) for ready-to-use implementations.
</Callout>

This guide is for developers using other email service providers (ESPs) like Bloom Reach, Salesforce Commerce Cloud, SendGrid, or any platform that supports webhooks. If you're not using Klaviyo or Attentive, [webhooks](https://developer.ordergroove.com/reference/webhooks-overview) are your recommended path forward.

***

## How 1-Click Actions Work

Our 1-click system uses **action tokens** to securely authorize subscriber actions. Here's the high-level flow:

1. **Use our webhook events to connect** to your ESP containing subscription data and an action token
2. **Include the 1-click urls in your ESP messaging** using the action token and the specific action you want to enable
3. **Subscribers click the URL** in their email
4. **They land on your page** where our JavaScript automatically processes the action token and completes the request

The action token is a secure credential that tells our system which subscription or order to modify and confirms the subscriber's authorization. Your ESP receives this token through webhook events, just like it would receive any other subscription data.

***

## Prerequisites

Before you begin, you will need:

* Developer access to your ESP or marketing automation platform
* Access to [Ordergroove](https://rc3.ordergroove.com/) and the Webhooks page
* The Action Token must be enabled for your merchant account.
  * The Action Token is not enabled by default, [Contact Ordergroove Support](https://help.ordergroove.com/hc/en-us/requests/new) or your Customer Success Manager to get the Action Token enabled)
* A landing page on your site that can process the action and display a confirmation message

***

## Step 1: Set Up Webhooks

Use webhooks to send subscription and order data — including the Action Token — to your ESP.

1. Log in to [Ordergroove](https://rc3.ordergroove.com/) and go to Developers → Webhooks
2. Create a new webhook. Give the new webhook a name and Set the endpoint to the URL where your ESP (or middleware) listens for webhook data
3. Select the Event Types you want to send
   * Reactivate is tied to subscription.cancel
   * All other events are tied to order.reminder

***

## Step 2: Build the 1-Click URL

In your ESP, you'll construct URLs that include the action token. The token is available as a variable in your webhook data that you can reference in your email templates.

Your ESP's templating syntax will vary, but the concept is the same: pull the action token from the event data and insert it into your URL.

<Callout icon="🚧">
  **Ensure you are using the correct URL structure for your implementation:**

  * Standard Implementation: If you use Ordergroove’s `main.js` or `oca.js`, follow the URL structures in our <Anchor label="Knowledge Center" target="_blank" href="https://help.ordergroove.com/hc/en-us/articles/13554075021971-Add-1-Click-Actions-to-Klaviyo-Flows#01H7X9Y1GVJHXBHA13TD15KRKN">Knowledge Center</Anchor>.
  * **Custom Implementation**: The examples below assume you are handling actions via a custom solution or webhook and have logic to parse these specific query string parameters.
</Callout>

### Supported Actions

The currently supported actions are:

### Delay

Push the next order date out (default: 14 days).

Example Delay: `https://yourdomain.com/subscription-actions?token={{action_token}}&action=delay`

Example Delay with custom time frame: `https://yourdomain.com/subscription-actions?token={{action_token}}&action=delay&days=21`

### Skip

Cancels (skips) one order. If the order is associated with a subscription, the subsequent order will be created based on its set frequency.

Example Skip: `https://yourdomain.com/subscription-actions?token={{action_token}}&action=skip`

### Reactivate

Resume a paused subscription.

Example Reactivate: `https://yourdomain.com/subscription-actions?token={{action_token}}&action=reactivate`

### Reactivate with Discount

Resume a paused subscription with a *Winback Incentive* applied.

Note: Reactivate with Discount and Winback Incentives are currently in Alpha, please reach out to <Anchor label="support" target="_blank" href="https://help.ordergroove.com/hc/en-us/requests/new">support</Anchor> to have both enabled for your store. Once Winback Incentives are enabled, create a new one with [these instructions](https://help.ordergroove.com/hc/en-us/articles/13554075021971-Add-1-Click-Actions-to-Klaviyo-Flows#h_01KG0141VXSK79Y5BG50EGZP91).

Example Reactivate with Discount: `https://yourdomain.com/subscription-actions?token={{action_token}}&action=reactivate&og_winback_id=DISCOUNT_ID`

### Upsell

Add products or upgrade subscription tiers.

Example Upsell: `https://yourdomain.com/subscription-actions?token={{action_token}}&action=upsell`

***

## Step 3: Set Up Your Landing Page

Create a landing page that receives and processes the action\_token. Include Ordergroove’s JavaScript snippet `oca.js` to handle token validation and execute the selected action.

`ocs.js` automatically:

* Reads the action token from the URL
* Validates the request with Ordergroove
* Processes the action
* Displays confirmation to the subscriber

***

## Step 4: Test The Experience

1. **Trigger a test webhook event** to verify your ESP is receiving data.
2. **Send a test email to confirm** the `{{action_token}}` populates in the link.
3. **Click the link** and confirm the landing page loads, validates the token, and processes the action correctly.
4. **Monitor logs** in your ESP and Ordergroove for any errors or missing payload data.

***

## Related Documentation

* [Add 1-Click Actions to Klaviyo Flows](https://help.ordergroove.com/hc/en-us/articles/13554075021971-Add-1-Click-Actions-to-Klaviyo-Flows)
* [Add 1-Click Actions to Attentive Journeys](https://help.ordergroove.com/hc/en-us/articles/27625934837651-Add-1-Click-Actions-to-Attentive-Journeys)
* [Webhooks Overview](https://developer.ordergroove.com/reference/webhooks-overview)