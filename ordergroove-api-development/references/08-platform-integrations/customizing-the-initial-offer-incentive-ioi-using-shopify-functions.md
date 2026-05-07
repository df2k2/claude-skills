# Customizing the Initial Offer Incentive (IOI)

If you are trying to offer your customers an Initial Offer Incentive, you may be able to use <Anchor label="our feature in your Ordergroove Admin" target="_blank" href="https://help.ordergroove.com/hc/en-us/articles/4406884025363">our feature in your Ordergroove Admin</Anchor>. However, if you want to customize your customer experience even further, we recommend you use <Anchor label="Shopify Functions" target="_blank" href="https://shopify.dev/docs/apps/build/functions">Shopify Functions</Anchor>.

Shopify Functions inject code into the backend logic of Shopify. These allow you to create unique experiences for your customers in their cart and at checkout. Find out more in [Shopify's Help Center](https://help.shopify.com/en/manual/checkout-settings/script-editor) articles.

<Callout icon="📘" theme="info">
  **Looking for the legacy Shopify Scripts version?**

  If you are maintaining an existing implementation or migrating from Shopify Scripts, you can still access the original [Scripts-based guide here](https://developer.ordergroove.com/docs/copy-of-customizing-the-initial-offer-incentive-ioi). Please note that Scripts will stop functioning on June 30, 2026.
</Callout>

***

## Requirements

Shopify functions require a custom app or paid app from the Shopify app store. Custom apps can only be made by Shopify Partners - so this guide is meant for developers working with Shopify clients.

***

## Getting Started

Shopify Functions allow developers to customize the backend logic of Shopify. Functions are continually being updated so it is best to first reference Shopify’s official <Anchor label="documentation" target="_blank" href="https://shopify.dev/docs/apps/build/functions">documentation</Anchor>.

At at high-level:

* App developers create and deploy apps that contain functions.
* Merchants install the app on their Shopify store and configure the function. An API call is made with the function configuration.
* Customers interact with a Shopify store and Shopify executes the function.

You can use Shopify apps to generate Functions. Or, if you need complete control, you can create your own Function. For an Initial Offer Incentive (IOI) you will need a Discount Function.

You can read the full documentation here on creating a [Shopify Discount Function](https://shopify.dev/docs/apps/build/discounts/build-discount-function?extension=javascript).

Here is a quick start guide on creating a basic Discount Function app to discount subscription line items by 20%. This can be combined with our Free shipping on initial orders Discount Function.

**Note**: This guide is accurate as of Shopify Function API version 2026-01.

1. Use Shopify CLI version 3.69.4+
2. Use Node version 22.9.9+
3. Navigate to a local directory on your computer where you want to create the app
4. Run the command `shopify app init` to create an app
   1. Select `Build an extension-only app`
   2. Select `Yes, create it as a new app`
   3. Name your app (example: `ordergroove-discount`)
   4. You can now see your app in your Shopify Partner Dashboard
5. Run `cd ordergroove-discount`
6. Run `shopify app generate extension`
   1. Select the extension to create
   2. Name your extension
   3. Select Language *(the example code below assumes Javascript)*
7. Edit file: `ordergroove-discount/src/cart_lines_discounts_generate_run.graphql`\
   Replace full file with below code:
   ```javascript
   query CartInput {
     cart {
       lines {
         id
         quantity
         sellingPlanAllocation {
           sellingPlan {
             id
             name
           }
         }
         merchandise {
           __typename
           ... on ProductVariant {
             id
             title
           }
         }
       }
     }
   }

   ```
8. Edit file: `ordergroove-discount/src/cart_lines_discounts_generate_run.js
   `Replace full file with below code:

```javascript
import { ProductDiscountSelectionStrategy } from '../generated/api';

/**
 * @typedef {import('../generated/api').Input} Input
 * @typedef {import('../generated/api').CartLinesDiscountsGenerateRunResult} CartLinesDiscountsGenerateRunResult
 */

/**
 * cartLinesDiscountsGenerateRun
 *
 * If a cart line has a sellingPlanAllocation (i.e. it's on a subscription / has a selling plan),
 * apply a flat 20% discount to that line.
 *
 * @param {Input} input
 * @returns {CartLinesDiscountsGenerateRunResult}
 */
export function cartLinesDiscountsGenerateRun(input) {
  const DISCOUNT_PERCENTAGE = 20; // 20%

  const candidates = [];

  if (!input.cart?.lines || input.cart.lines.length === 0) {
    return { operations: [] };
  }

  for (const line of input.cart.lines) {
    // Only consider product variants with a selling plan allocation
    if (
      line.merchandise.__typename !== 'ProductVariant' ||
      !line.sellingPlanAllocation
    ) {
      continue;
    }

    const variant = line.merchandise;

    const message = variant.title
      ? `${DISCOUNT_PERCENTAGE}% off subscription for ${variant.title}!`
      : `${DISCOUNT_PERCENTAGE}% off this subscription!`;

    candidates.push({
      value: {
        percentage: {
          value: 20
        },
      },
      targets: [
        {
          productVariant: {
            id: variant.id,
            quantity: line.quantity,
          },
        },
      ],
      message,
    });
  }

  if (candidates.length === 0) {
    return { operations: [] };
  }

  return {
    operations: [
      {
        productDiscountsAdd: {
          candidates,
          selectionStrategy: ProductDiscountSelectionStrategy.First,
        },
      },
    ],
  };
}
```

9. Run `shopify app deploy`

<br />

### Further Customizations

For further customizations to the above script, you can reference <Anchor label="Shopify's excellent documentation on the Shopify Help Center" target="_blank" href="https://shopify.dev/docs/api/functions/latest">Shopify's excellent documentation on the Shopify Help Center</Anchor>. You'll find great examples of building Functions that you can adapt and use with your subscription program.

***

## Related Articles

* <Anchor label="Shopify’s guide on Functions" target="_blank" href="https://shopify.dev/docs/apps/build/functions">Shopify’s guide on Functions</Anchor>
* <Anchor label="Shopify’s Function API docs" target="_blank" href="https://shopify.dev/docs/api/functions/latest">Shopify’s Function API docs</Anchor>

<br />