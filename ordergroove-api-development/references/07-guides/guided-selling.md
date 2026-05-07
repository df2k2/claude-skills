# Guided Selling

Guided selling is the ability to gather customer product preferences through quizzes in the discovery process, in order to suggest products curated to the customer’s responses.

For general information take a look at the [Knowledge Center](https://help.ordergroove.com/hc/en-us/articles/8889289116947-Guided-Selling-Personalize-product-discovery). In this guide we'll go through how to set it up.

***

## Set up Guided Selling

Ordergroove can be integrated into your guided selling flows to allow you the ability to capture subscription enrollment as a part of your selling journey. There are 2 options to integrate Ordergroove with this experience.

### Option 1: Using the Ordergroove widget

Ordergroove will inject an enrollment offer in your guided selling flow as long as you have that section of the experience tagged with Ordergroove content. Typically this will be at the time you want the customer to select their frequency once they have chosen their product. If your experience outputs multiple products that the customer will subscribe to, then you can either tag each product with an Ordergroove enrollment offer widget, or implement option 2.

Add the following tag(s) to the section of the guided selling flow that you want to capture the frequency:

```html
<og-offer product="your-product-id" location="X"></og-offer>
```

> 📘 Note
>
> You’ll need to make sure this is on the same page as the Shopify Add to Cart button. Ordergroove interacts with that submit action to write a selling plan to the cart for the product in the tag.

You can set up a frequency-only offer in Ordergroove’s Admin portal under the Subscriptions > Enrollment section and give it any location name that you define in the tag (placeholder above of location=”X”).

<Image align="center" src="https://files.readme.io/d942167-Guided.png" />

### Option 2: Using your own content

In this option, you can capture all of the selections the customer makes for a subscription and then write selling plans for each into the cart. The selling plan corresponds to the frequency that the customer has selected. You can find detail on adding a selling plan for an item by using [Shopify’s cartLinesUpdate Storefront API call](https://shopify.dev/api/storefront/2022-04/mutations/cartLinesUpdate). To determine which selling plan ID to use, you can refer to [Shopify’s Selling Plan Object](https://shopify.dev/api/liquid/objects/selling-plan) documentation.