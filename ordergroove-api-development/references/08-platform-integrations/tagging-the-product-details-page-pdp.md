# Tagging the Product Details Page (PDP)

For Ordergroove's subscription offer to appear on your Shopify site, your product details page (PDP) needs to be tagged with an Ordergroove code snippet.

Our app can only automatically add blocks for Online Store 2.0 themes.

If your product details page (PDP) is not Online Store 2.0 (it does not use blocks), you can tag your PDP manually by following these steps.

Ordergroove's offer may not appear correctly if there are code snippets from other subscription programs present. To prevent this issue, please ensure before installation that your theme is clean of other code snippets.

> 📘 Platform
>
> This article is only relevant for stores using Shopify. If your store uses a Shopify Online Store 2.0 theme, please refer to [Install Ordergroove on an Online 2.0 Store Theme ](https://developer.ordergroove.com/docs/use-ordergroove-with-online-store-20)for help.

***

The steps to adding an offer tag depend on which version of Ordergroove’s Shopify integration your theme is on. If you are installing Ordergroove on a brand new theme, go to the section with Option 1. If you already have Ordergroove code on this theme, check if the file `ordergroove_offer.liquid` is present. If so, go to Option 2, otherwise go to Option 1.

## Option 1: Adding the Offer tag for recent themes

If you are using a recent theme or one that was injected after November 3, 2022, you are on our most recent integration and can use our upgraded offer tag.

1. Open the theme code editor on Shopify.
2. Find the file that contains the "add to cart" button. This file is usually a file with "product" in the name. The most common files are `product-template.liquid` or `product-form.liquid`, but it may be a different file depending on your theme. You can find the "add to cart" button within the file by hitting CTRL+F and searching for "add" in the search bar.
3. Once you find the appropriate file, paste the following code snippet **above** the "add to cart" button.

```Text Offer Tag
<og-offer product="{{ product.selected_or_first_available_variant.id }}" location="pdp"></og-offer>
```

4. Click save to save your changes.

Now that you've tagged the PDP properly, check it out on your site. If your subscription program is live, you can navigate to a product that is eligible for subscription and you should see the subscription options appear on the page.

## Option 2: Adding the Offer tag for Vintage Offers

If your theme is on an older version of our integration, you will have a file already present in your theme called `ordergroove_offer.liquid`. If this file is present, follow the following steps.

1. Open the theme code editor on Shopify.
2. Find the file that contains the "add to cart" button. This file is usually a file with "product" in the name. The most common files are *product-template.liquid* or *product-form.liquid*, but it may be a different file depending on your theme. You can find the "add to cart" button within the file by hitting CTRL+F and searching for "add" in the search bar.
3. Once you find the appropriate file, paste the following code snippet **above** the "add to cart" button.

```liquid
{%- render 'ordergroove_offer' product: product.selected_or_first_available_variant location: 'pdp' -%}
```

Here is an example in the Debut theme:

<Image align="center" width="600px" src="https://files.readme.io/574b492-e207d25-changed_to_current_variant.png" />

4. Click save to save your changes.

Now that you've tagged the PDP properly, check it out on your site. If your subscription program is live, you can navigate to a product that is eligible for subscription and you should see the subscription options appear on the page.