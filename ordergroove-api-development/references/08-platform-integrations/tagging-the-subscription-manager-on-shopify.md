# Tagging the Subscription Manager

You can update your customers/accounts page to include a link to Ordergroove’s Subscription Manager. If your customers/accounts page supports blocks where you want the link to be, check out our streamlined process for Online Store 2.0 at [Install Ordergroove on an Online Store 2.0 theme](https://developer.ordergroove.com/docs/use-ordergroove-with-online-store-20).

> 📘 Platform
>
> This article is only applicable for stores on Shopify.

***

## Before you start

Ordergroove's enrollment offer may not appear correctly if there are code snippets from other subscription programs present. To prevent this issue, please ensure that your theme is clean of other code snippets before installation.

***

## Add the Subscription Manager code

1. Open the theme code editor on Shopify.
2. Search in the list of files for a file called `ordergroove_subscription_interface_link.liquid`. If it exists, skip ahead to the section ‘Add link to the Subscription Manager’.
3. If it doesn’t exist, go to the ‘Snippets’ folder and add a snippet called `ordergroove_subscription_interface_link.liquid`. In the blank new file, please paste the following code.

```Text customers/account.liquid
{% comment %}

Please add following code in customers/account.liquid at the end.

{%- render 'ordergroove_subscription_interface_link' -%}

{% endcomment %}

{% if customer %}
  {% assign secret_key = shop.metafields.ordergroove.themeHashKey.value %}
  {% assign customer_id = customer.id  %}
  {% assign timestamp = "now" | date: "%s" %}
  {% assign signature = customer_id | append: "|" | append: timestamp | hmac_sha256: secret_key %}
  <p><a href="/apps/subscriptions/manage/?customer={{customer.id}}&customer_signature={{signature}}&customer_timestamp={{timestamp}}" class="btn btn--small">Manage Your Subscriptions</a></p>
{% endif %}
```

***

## Add link to the Subscription Manager

1. Open the theme editor on Shopify.
2. Find the file for the accounts page (the most common file is *customers/account.liquid*).
3. Add the following line of code to your customer account page:

```liquid
{%- render 'ordergroove_subscription_interface_link' -%}
```

Here is an example in the Debut theme's *customer/account.liquid*:

<Image align="center" width="600px" src="https://files.readme.io/ef3e794-3749c47-smi.png" />

This line of code will create a button that will take the user to the Subscription Manager. You can move that line of code to change where the button is placed on this page.