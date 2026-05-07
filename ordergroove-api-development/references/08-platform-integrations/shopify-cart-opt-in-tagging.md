# Cart Opt-In Tagging

These instructions will guide you to implement the new Ordergroove Cart Opt-In on your current or in-development theme.

> 📘 Platform
>
> This article is only relevant for stores on **Shopify**. eCommerce platforms outside of Shopify have cart opt-in installed by default, and don't need to worry about adding it to their program.

***

## Overview

There are 4 steps:

1. Add cart opt-in tags to the theme
2. Modify existing Ordergroove files to support cart opt-ins
3. Side cart customizations
4. Other store customizations

As a reminder, before making any changes to the theme, it is best to make a duplicate version of the theme to work on. This ensures that you can test the final version before it goes live in your store.

### Prerequisites

* Your store is on Shopify.
* You have an offer with location 'Cart' configured for your store.
* These instructions are aimed for themes where the cart is constructed using liquid. If your cart is not using liquid, for example is using handlebars, you will need to modify these instructions to work with your theme.
* Requires page tagging and nuances will occur if you're on a legacy install on the previous Ordergroove offers without a cart offer. If you're unsure, please reach out to [Ordergroove Support](https://help.ordergroove.com/hc/en-us/requests/new) and we'll be happy to confirm your install version.

> 🚧 Styling
>
> If your store has multiple offer locations and you plan on styling them differently from each other, for example changing the text in the mini cart, you will need to [create a different Enrollment Offer](https://help.ordergroove.com/hc/en-us/articles/360026386794) for each location in the [Ordergroove Merchant Admin](https://rc3.ordergroove.com/subscriptions/enrollment/home/).

***

## 1. Add cart offer tags to the theme

The tag for the cart offer needs to be added to the cart page and also the side cart page, if your theme has one. Search your theme for the files where the item information is displayed on the cart and side cart. For example, you would look for where the photo and description for your item are displayed in the cart.

> 👍 Tip
>
> In the theme Dawn, the cart page is titled ‘main-cart-items.liquid’, and in the theme Debut, the cart page is titled ‘*cart-template.liquid*’. Look for files in your theme with similar names.

Once you find the appropriate files, place the following code where you wish the offer to display. If your theme displays selling plan titles in the cart, we recommend placing this code above or below the code to display the selling plan.

```liquid
<og-offer product="{{item.key}}" location="cart" cart></og-offer>
```

Note that the product attribute in the og-offer tag is expecting the cart line item key. This is typically set through *\{\{item.key}}* in liquid. However, if your cart item list is not generated via liquid, you will need to change how you set this attribute.

If your cart item list is generated outside of liquid, please refer to your template language to identify the right syntax for accessing the variant Id and set the product attribute with that.

**Note**: An indicator for this is, if in your cart file, you need to place the tag between \{% raw %} and \{% endraw %}, which indicates exiting and re-entering liquid code.

***

## 2. Modify existing Ordergroove files to support cart offers

If you are just getting started with Ordergroove, please skip this and go to Step 4. Otherwise, if you have already been using us for subscriptions, please make the following changes to ensure your theme is ready to support cart offer.

1. Open the file ordergroove.js under assets. Remove all contents of the ordergroove.js file so the file is empty and save the file.
2. Open the file ‘ordergroove\_static\_asset.liquid’. Add attribute data-shopify-selling-plans to the script tag containing src=”[https://static.ordergroove.com/”](https://static.ordergroove.com/”) so it will appear as

```javascript
<script type="text/javascript" data-shopify-selling-plans src="https://static.ordergroove.com/{Ordergroove Merchant ID} /main.js"></script>
```

> 🚧 Important
>
> Double-check that this tag has the attribute data-shopify-selling-plans.

Note that this change upgrades you to the latest version of Ordergroove offers for Shopify. If you have built customizations based on the older version, they may no longer be supported. Please thoroughly check that all custom functionality works as expected.

***

## 3. Confirm the cart offer appears on your store

After making the above changes, preview your theme from Shopify admin. Navigate to a product that is subscription eligible and add it to cart. Then open the cart page. You should see the new cart offer appear on the page.

***

## 4. Side Cart Customizations

Ordergroove uses Shopify’s cart API to refresh the cart when a customer changes their subscription on our offer. This ensures that prices and selling plan titles are updated for a seamless user experience. However, if you are using a minicart or sidecart, or if your cart otherwise uses Javascript to refresh, you will need to hook Ordergroove’s cart refresh into your cart’s refresh process.

To do this, first you need to identify how your theme triggers the cart to refresh. If you are not the developer who works with your theme, you will likely want to engage their help in finding this, or reach out to the theme developer. Otherwise, a good place to start is how the quantity change triggers refresh of the cart. Once you identify this method, fill in the below template with your method.

```javascript
// Hooks OG cart updated to cart refresh
document.addEventListener('og-cart-updated', ev => {              
//your cart refresh method here
    ev.preventDefault();
});
```

Then open ordergroove\_static\_asset.liquid, and paste the above function with the rest of the javascript within the script tag containing javascript code, or somewhere else in your Javascript which runs for the cart.

For example, you can place it right under the following lines in ordergroove\_static\_asset.liquid:

```javascript
consentText: encodeURI(
'{{ 'shopify.checkout.payment.subscription_agreement_label_html' | t | replace: "'", "&apos;" | replace: "
", " " | strip_newlines }}'
),
consentWarning: '{{ 'shopify.checkout.field_errors.subscription_agreement_blank' | t | replace: "'", "&apos;" | replace: "
", " " | strip_newlines }}',
}
}
```

***

## Other Store Customizations

If your theme has any other customizations that affect how subscriptions are processed, they may be affected by upgrading to the new version of offers. Please regress and check all functionality to make sure that everything is working properly.