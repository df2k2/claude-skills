# Showing Discounted Price

Online stores often see a lift in purchases and subscription sign-ups when shoppers can see the discounted price upfront. Ordergroove already shows the discounted price within the enrollment offer, but some merchants want to surface it elsewhere in their Shopify theme too. This article walks through one approach for displaying the discounted subscription price outside of Ordergroove's content.

> 📘 Platform
>
> *Showing a Discount Price* is automatically included within the enrollment offer for merchants on Shopify, but merchants on custom builds and other platforms need to build it out with their own development team. The following article details how you can build the discounted subscription price outside of Ordergroove's content on Shopify.

***

When using the Debut theme in Shopify, you can add the following code snippet to your *Copyproduct-price.liquid* file. Otherwise, you will have to find the specific file used to display pricing on the product detail page and add this code to that file instead.

> 🚧 Note
>
> The code being provided below is an example and was tested using the standard Shopify Debut theme. You may need to modify it to make it work within your Shopify store.\
> Ordergroove suggests testing this code in a duplicated test environment before transferring the code over to your live Shopify theme.

```liquid
{%- liquid
  # Ensure price is defined and handle conversion and discount calculation properly
  assign discount_percent = 15
  assign discount_amount = price | times: discount_percent | divided_by: 100
  assign discounted_price = price | minus: discount_amount

  # To ensure the price rounds to 16.99, round it down manually if necessary
  assign rounded_discounted_price = discounted_price | minus: 0.01 | floor

  # Format the prices with the money filter
  assign money_discounted_price = rounded_discounted_price | money
  assign money_price = price | money
-%}

<script type="text/javascript"> 
    var productId = "{{ variant.id }}"; 

  /** 
   * As the customer is opting into and out of subscription 
   * change the display of the price so that a customer can 
   * see the regular or discounted price depending on their selection. 
   */ 
  function handleOptinChange (changedState) { 
   try {
      var regularPriceNode = document.getElementById("regular-price"); 
      var subscriptionPriceNode = document.getElementById("subscription-price"); 

      if (productId != changedState.productId) {
        return; 
      } 

      if (changedState.optedIn) {
        subscriptionPriceNode.style.display = "block"; 
        regularPriceNode.style.display = "none"; 
      } 
      else {
       regularPriceNode.style.display = "block"
       subscriptionPriceNode.style.display = "none"; 
      } 
    }
    catch(e) {
      console.log(e.message);
    }
   }

   function checkOptinState() {
     try {
       /* Subscribe to a optin changed event */
       OG.addOptinChangedCallback(handleOptinChange);

       var productId = "{{ variant.id }}";
       var optins = OG.getOptins([productId]);
       var regularPriceNode = document.getElementById("regular-price");
       var subscriptionPriceNode = document.getElementById("subscription-price");

       if (optins.length < 1) {
         regularPriceNode.style.display = "block"
         return;
       }

       subscriptionPriceNode.style.display = "block";
    }
    catch {
      regularPriceNode.style.display = "block"
    }
  }

  function displayPriceInOffer() {
   /**
   * Assumes a single offer on the page
   * can be changed to whatever lookup you want
   * can also be changed to a loop if multiple offer tags exist on the same page
   */
   var offerElement = document.getElementsByTagName("og-offer")[0];
   optedInLabel = offerElement.querySelector("og-optin-button span[id='og-label']");
   optedOutLabel = offerElement.querySelector("og-optout-button span[id='og-label']");

   /* Wait until the offer is finished loading */
   if (!optedInLabel || !optedOutLabel) {
     setTimeout(displayPriceInOffer, 200);
     return;
   }

   /* Add the price to the offer label text */
   optedInLabel.innerHTML = "<span>"
      + document.querySelector("#subscription-price span[data-sale-price]").innerHTML
      + "</span> - "
      + optedInLabel.innerHTML;

   optedOutLabel.innerHTML = "<span>"
      + document.querySelector("#subscription-price span[data-regular-price] s").innerHTML
      + "</span> - "
      + optedOutLabel.innerHTML;
  }

  document.addEventListener("DOMContentLoaded", checkOptinState);
  document.addEventListener("DOMContentLoaded", displayPriceInOffer);
</script>

<!--
  The container which contains the discounted price and
  original price strike through
-->
<div id="subscription-price" style="display:none">
  <span class="price-item price-item--sale" data-sale-price>
    {{ money_discounted_price }}
  </span>
  <span class="price-item price-item--regular" data-regular-price>
    <s>{{ money_price }}</s>
  </span>
</div>

<!-- The container which contains the regular price -->
<div id="regular-price" style="display:none">
  <span class="price-item price-item--regular" data-regular-price>
    {{ money_price }}
  </span>
</div>
```

If the above code is implemented correctly on your site, your customers should see the discounted price and the original price, like the sample image below.

<Image align="center" src="https://files.readme.io/aeeedd1-Screen_Shot_2021-06-03_at_4.02.03_PM.png" />