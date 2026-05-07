# Add a subscription offer to quickview, homepage, or other areas of your site

This doc only applies to Direct Offers on Shopify.

We support offers on quick view, homepage, and other areas of your site where the url does not reflect the product or variant that the user selects by adding the `data-shopify-product-handle` attribute to the offer with the product handle.

### For OS1.0:

Instead of rendering the `ordergroove_offer.liquid` file, add the below code where you want the offer to appear.

```Text Offer
<og-offer product="{{ product.selected_or_first_available_variant.id }}"
data-shopify-product-handle="{{ product.handle }}"
location="my-location"></og-offer>
```

***

### For OS2.0:

Quickview offers requires setting an additional attribute in our og-offer tag which is not present in our Online Store 2.0 Offer block.

As a workaround with an Online Store 2.0 theme, you can create a 'Liquid code' block in the Shopify Customizer through 'Add block' -> 'Liquid code'. Then, in the text box for the Liquid code, please paste the following:

```Text Offer
<og-offer product="{{ product.selected_or_first_available_variant.id }}"
data-shopify-product-handle="{{ product.handle }}"
location="my-location"></og-offer>
```

This will display our offer on your site just like the offer block, and supports quick view. If you change the 'location' name for your offer, you will also need to change it in this block.