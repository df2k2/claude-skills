# Troubleshooting Cart Offers

Offers are javascript injected content that allow a customer to enroll in your subscription program for a particular product. All platforms now have the ability to tag an enrollment offer on the cart location page. If your cart offer is not working as expected, this article will help you troubleshoot and get your cart offer to function as intended.

Offers are javascript injected content that allow a customer to enroll in your subscription program for a particular product. All platforms now have the ability to tag an enrollment offer on the cart location page. If your cart offer is not working as expected, this article will help you troubleshoot and get your cart offer to function as intended.

> 📘 Platform
>
> This article is not applicable to merchants using BigCommerce. For BigCommerce integrations, please refer to our [BigCommerce Integration Guide](https://help.ordergroove.com/hc/en-us/articles/14154406802707-BigCommerce-Integration-Guide#before-you-begin-0) in the Knowledge Center.

***

## Platform-Agnostic Troubleshooting

### My Cart Offer Isn't Appearing On Page

1. First check that the Ordergroove offer tag is on your cart page. To do this, right-click to inspect the page. CTRL-F the elements to find the 'og-offer' tag. Within the tag, you should be able to see the product id, location and frequency.

```text
<og-offer product="300200" location="cart" frequency="1_3">
```

2. Next check that the Ordergroove main.js is tagged on the page. The main.js will be leveraged to load your offer content and styling. The main.js structure will consist of two elements, the frontend static domain, and your Merchant ID.

```text
<script type="text/javascript" src="<STATIC_DOMAIN>/<MERCHANT_ID>/main.js"></script>
```

***

### How To Upgrade Your Read-Only Offer

If you currently have an offer template on your cart page and your customers can only read the offer, then you should upgrade! We now have a cart offer template that would allow your customers to enroll in a subscription right on the cart page.

To make this change, first navigate to the Enrollment page on the Ordergroove app. After you click the 'Create' button and scroll down, you will be able to see the new Cart offer template.

<Image align="center" src="https://files.readme.io/0d92c22-pasted_image_0.png" />

Once you have created, customized and saved this new template, now all you need to do is update the location of the og-offer that you currently have on your cart page with this new one.

***

### Why aren't the same products in my cart separate subscriptions?

Did you add the same product to your cart, whether as a subscription or as one-time, and are now seeing a duplication in behavior, such as changing the opt-in status for all products in your cart?

This behavior is expected when you are using the same product ID across multiple products because our local storage tracks the product ID. The og-offer tag element is required to have a specific product attribute. This attribute allows one to opt in, opt out, and change the frequency of an opt-in.

So if you run into a scenario where there are either multiple opt-in's or offers with the same product ID, our local storage does not see them all as unique because they have the same product ID attribute.

***

## Shopify-Specific Troubleshooting

Ordergroove injects the code into Shopify's theme files, whereas merchants add their own tags on other platforms. Because of the automation, there are a few extra places to check if things aren't working correctly for Shopify stores.

### Is Your Cart Offer Tag In The Correct Theme Code File?

The tag for the cart offer needs to be added to the cart page and also the side cart page, if your theme has one. Search your theme for the files where the item information is displayed on the cart and side cart. For example, you would look for where the photo and description for your item are displayed in the cart.

> 👍 Pro Tip
>
> In the theme Dawn, the cart page is titled 'main-cart-items.liquid', and in the theme Debut, the cart page is titled 'cart-template.liquid'. Look for files in your theme with similar names.

***

### Is Your Cart Item List Generated via Liquid?

Note that the product attribute in the og-offer tag is expecting the product variant Id. This is typically set through `{{item.key}}` in liquid. However, if your cart item list is not generated via liquid, you will need to change how you set this attribute.

If your cart item list is generated outside of liquid, please refer to your template language to identify the right syntax for accessing the variant Id and set the product attribute with that.

**Tip**: If you're in your cart file, you need to place the tag between `{% raw %}` and `{% endraw %}`, which indicates exiting and re-entering liquid code.

***

### Are you on the latest version of Ordergroove offers?

You need to be on the latest version of Ordergroove offers to utilize our cart offer feature. Please check using the steps below to make sure your theme is ready to support cart offers.

1. Open the file ordergroove.js under assets and check that all contents of the file are empty. If not, remove all contents and save the file.
2. Open the file 'ordergroove\_static\_asset.liquid and check that you have the attribute `data-shopify-selling-plans` in the script tag containing `src="https://static.ordergroove.com/"`. It should appear as below:

```text
<script type="text/javascript" data-shopify-selling-plans src="https://static.ordergroove.com/{Ordergroove Merchant ID}/main.js"></script>
```

***

### Are You Using Javascript To Refresh Your Cart Page?

Ordergroove uses Shopify's cart API to refresh the cart when a customer changes their subscription on our offer. This ensures that prices and selling plan titles are updated for a seamless user experience.

However, if you are using a minicart or sidecart, or if your cart otherwise uses Javascript to refresh, you will need to hook Ordergroove's cart refresh into your cart's refresh process.

To do this, first you need to identify how your theme triggers the cart to refresh. If you are not the developer who works with your theme, you will likely want to get their help in finding this, or reach out to the theme developer. Otherwise, a good place to start is how the quantity change triggers refresh of the cart. Once you identify this method, fill in the below template with your method.

```javascript
// Hooks OG cart updated to cart refresh
document.addEventListener('og-cart-updated', ev => { 
//your cart refresh method here
ev.preventDefault();
});
```

Then open ordergroove\_static\_asset.liquid, and paste the above function with the rest of the javascript within the script tag containing javascript code, or somewhere else in your Javascript which runs for the cart.

For example, you can place it right under the following lines in ordergroove\_static\_asset.liquid (right above the script tag closing `</script>`):

```liquid
consentText: encodeURI(
'{{ 'shopify.checkout.payment.subscription_agreement_label_html' | t | replace: "'", "&apos;" | replace: "
", " " | strip_newlines }}'
),
consentWarning: '{{ 'shopify.checkout.field_errors.subscription_agreement_blank' | t | replace: "'", "&apos;" | replace: "
", " " | strip_newlines }}',
}
}
```