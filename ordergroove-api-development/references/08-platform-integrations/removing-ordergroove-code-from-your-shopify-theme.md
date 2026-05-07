# Removing Ordergroove code from your Shopify theme

This article shares steps for removing Ordergroove assets and code snippets from your Shopify theme. These are general guidelines and may vary depending on your theme and if you've done any further customization.

***

## Removing Ordergroove's Code

1. Open the code editor for the theme you'd like to remove Ordergroove from.
2. In the search box, type "ordergroove" and delete all of the files that start with "ordergroove"

<Image align="center" width="300px" src="https://files.readme.io/1ce4adf-mceclip0.png" />

3. Open the theme.js file and search for "ordergroove". Delete the following code snippets if you see them in the file:
   * \{%- render 'ordergroovestaticasset' -%}
   * \{%- render 'ordergroove\_global' -%}
4. Locate the product file that has the Ordergroove snippet (it may be product.liquid, product-template.liquid, or something else depending on your theme). Search for "ordergroove" and delete the following snippet if you find it in the file:
   * \{%- render 'ordergrooveoffer' product: current\_variant location: 'pdp' -%}
5. Open the customers/account.liquid file and search for "ordergroove". Delete the following code snippet if you locate it in the file:
   * \{%- render 'ordergroovesubscriptioninterface\_link' -%}