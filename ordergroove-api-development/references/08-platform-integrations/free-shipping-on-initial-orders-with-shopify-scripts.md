# Free shipping on initial orders

If you are on **Shopify Plus**, you can use Shopify Functions to give customers free shipping when they purchase a subscription from your store. This will apply to the initial order when a customer checks out with a subscription on your Shopify site. You can also set up free shipping for recurring orders from the Flex Incentives page within Ordergroove.

Note that free shipping set up in Ordergroove only applies to recurring subscription orders, and not the initial order when a customer purchases a subscription. <Anchor label="See this article for more information about subscription shipping and delivery for Shopify" target="_blank" href="https://help.ordergroove.com/hc/en-us/articles/4406641707923-Shopify-Shipping-and-Delivery#h_01GSBNF4X0QT5RQ97JG98T5PVB">See this article for more information about subscription shipping and delivery for Shopify</Anchor>.

<Callout icon="📘" theme="info">
  **Looking for the legacy Shopify Scripts version?**

  If you are maintaining an existing implementation or migrating from Shopify Scripts, you can still access the original [Scripts-based guide here](https://developer.ordergroove.com/docs/copy-of-free-shipping-on-initial-orders). Please note that Scripts will stop functioning on June 30, 2026.
</Callout>

***

## Requirements

Shopify functions require a custom app or paid app from the Shopify app store. Custom apps can only be made by Shopify Partners - so this guide is meant for developers working with Shopify clients.

***

## Instructions

Shopify Functions allow developers to customize the backend logic of Shopify. Functions are continually being updated so it is best to first reference Shopify’s official <Anchor label="documentation" target="_blank" href="https://shopify.dev/docs/apps/build/functions">documentation</Anchor>.

At at high-level:

* App developers create and deploy apps that contain functions.
* Merchants install the app on their Shopify store and configure the function. An API call is made with the function configuration.
* Customers interact with a Shopify store and Shopify executes the function.

You can use Shopify apps to generate Functions. Or, if you need complete control, you can create your own Function. For an Initial Offer Incentive (IOI) you will need a Discount Function.

You can read the full documentation here on creating a [Shopify Discount Function](https://shopify.dev/docs/apps/build/discounts/build-discount-function?extension=javascript).

Here is a quick start guide on creating a basic Discount Function app to discount subscription line items by 20%. This can be combined with our Initial Order Incentive (IOI) Product Discount Function.

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
   3. Select Language (*the example code below assumes Javascript*)
7. Edit file: `ordergroove-discount/src/cart_delivery_options_discounts_generate_run.graphql`
   Replace full file with below code:

```javascript
query DeliveryInput {
  cart {
    lines {
      sellingPlanAllocation {
        sellingPlan {
          id
        }
      }
      merchandise {
        __typename
      }
    }
    deliveryGroups {
      id
      deliveryOptions {
        handle
      }
    }
  }
}
```

8. Edit file: `ordergroove-discount/src/cart_delivery_options_discounts_generate_run.js`
   Replace full file with below code:

```javascript
/**
 * @typedef {import("../generated/api").Input} Input
 * @typedef {import("../generated/api").CartDeliveryOptionsDiscountsGenerateRunResult} CartDeliveryOptionsDiscountsGenerateRunResult
 */

/**
 * cartDeliveryOptionsDiscountsGenerateRun
 *
 * If the cart has at least one line with a selling plan (subscription),
 * apply 100% off shipping (free shipping) to all delivery groups.
 *
 * Mixed carts are allowed: as long as there is at least one subscription line,
 * all delivery options are discounted to free.
 *
 * @param {Input} input
 * @returns {CartDeliveryOptionsDiscountsGenerateRunResult}
 */
export function cartDeliveryOptionsDiscountsGenerateRun(input) {
  const cart = input.cart;

  // No cart or no lines => nothing to do.
  if (!cart || !cart.lines || cart.lines.length === 0) {
    return { operations: [] };
  }

  // 1. Check if there is at least one line with a selling plan allocation.
  const hasSellingPlanLine = cart.lines.some((line) => {
    // We don't need variant details here, just that a selling plan exists.
    return Boolean(line.sellingPlanAllocation);
  });

  // If there are no subscription lines, do not discount shipping.
  if (!hasSellingPlanLine) {
    return { operations: [] };
  }

  // Static message – no metafield/config needed.
  const message = "Free shipping for subscription orders";

  // 2. Build discount candidates for each delivery group.
  const candidates = [];

  if (Array.isArray(cart.deliveryGroups)) {
    for (const group of cart.deliveryGroups) {
      // Ensure we have an ID to target.
      if (!group || !group.id) continue;

      candidates.push({
        // Target the entire group (all its delivery options).
        targets: [
          {
            deliveryGroup: {
              id: group.id
            }
          }
        ],
        message,
        // 100% off shipping => free shipping
        value: {
          percentage: {
            value: 100
          }
        }
      });
    }
  }

  if (candidates.length === 0) {
    return { operations: [] };
  }

  // 3. Wrap candidates in the deliveryDiscountsAdd operation.
  return {
    operations: [
      {
        deliveryDiscountsAdd: {
          candidates,
          // Apply to ALL candidates/groups.
          selectionStrategy: "ALL"
        }
      }
    ]
  };
}

```

9. Run `shopify app deploy`

***

## Further Customizations

For further customizations to the above script, you can reference <Anchor label="Shopify's excellent documentation on the Shopify Help Center" target="_blank" href="https://shopify.dev/docs/api/functions/latest">Shopify's excellent documentation on the Shopify Help Center</Anchor>. You'll find <Anchor label="great examples of building Functions" target="_blank" href="https://shopify.dev/docs/apps/build/discounts/build-discount-function">great examples of building Functions</Anchor> that you can adapt and use with your subscription program.

<br />