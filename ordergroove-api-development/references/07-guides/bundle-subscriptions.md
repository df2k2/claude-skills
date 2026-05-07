# Bundle Subscriptions

Our new bundle suite provides an innovative approach to subscription management, allowing users to oversee a single subscription with multiple items. Customers can customize their bundle by selecting which items they want, offering flexibility and a streamlined order management process.

***

## New Bundles Capabilities

Ordergroove's legacy bundles are represented by a **single line item** for the entire bundle, whereas the new bundles model allows for **multiple line items** to be linked to the same subscription.

Here’s how orders are represented in the legacy bundles vs the new bundles:

<Image align="center" src="https://files.readme.io/0ee703b-image2.png" />

Legacy bundles have item components in their single item while new bundles have multiple items linked to the subscription component. Both use subscription components.

## New Bundles Model

Each subscription includes linked subscription components that dictate the creation of bundle items. These bundle items are standard SKU products delivered to customers, while the subscription itself is governed by a "bundle parent product" that defines the bundle's behavior.

<Image align="center" src="https://files.readme.io/f4c3c6b-Understanding_Bundles.jpg" />

## New Bundles Benefits

* Inventory management is more precise, as each item's specific SKU and quantity are accurately deducted from the stock
* Flex incentives can apply to each item
* Orders are more straightforward to manage as items will be changed and not components. This gives the ability to change the item only for the current order
* Customers can edit their orders more intuitively
* APIs have direct control over components
* The initial checkout order is the same as any regular checkout order facilitating fulfillment
* Offers two different types of pricing models (dynamic and static)

## Dynamic vs Static Price Bundle

Ordergroove offers two types of bundle pricing to accommodate a variety of use cases:

### Dynamic price bundle:

In dynamic bundles, each item retains its standard price. If a customer swaps an item for another of a different value or adjusts quantities, the bundle's total price changes accordingly, summing up the individual prices of all items.

<Image align="center" src="https://files.readme.io/a4e87fa-Screenshot_2024-05-21_at_13.55.39.png" />

* Dynamic bundle pricing is similar to having multiple subscriptions being shipped together
* The price of the product set in the item will always be followed, even when an item is SKU swapped.
* **The parent product price must be set to $0 in dynamic bundles.**

### Static price bundle

For static bundles, the total bundle price is determined by the parent product's price. Individual item prices within the bundle are adjusted in a weighted manner so that the sum equals the parent product's price, ensuring the bundle's total price consistently reflects the parent product's price plus any incentives. **The parent product price must be set to a positive value in static bundles.**

<Image align="center" src="https://files.readme.io/ac00532-Screenshot_2024-05-21_at_13.55.48.png" />

The **$20** price of the bundle parent product will be distributed between all items in a weighted manner. Each item adjusted price is calculated by:

<Image align="center" src="https://files.readme.io/66a2629-Screenshot_2024-05-21_at_16.22.15.png" />

Here is a price breakdown of each item price calculation.

* Order total before adjustments: $15 + $20 + $5 = **$40**
* Item 1 original total price: $15. Adjusted Item Price = ($15/$40) \* $20 = **$7.5**
* Item 2 original total price: $20. Adjusted Item Price = ($20/$40) \* $20 = **$10**
* Item 2 original total price: $5. Adjusted Item Price = ($5/$40) \* $20 = **$2.5**

***

## Important Considerations For Static Bundles

* Occasionally, in static bundles with incentives, **the total may be slightly off by one or two cents**. This discrepancy is due to how incentives are applied individually to each item, rather than to the entire bundle order. For example in one bundle order costing $10 with 20% off we expect the total to be $8. As the bundle divides the 20% discount for all items, some of them might lose a few cents due to the weighted price of static bundles. In this case, the total discounted bundle price could be $7.99 instead of $8.
* If the sum of item prices within the bundle is less than the parent product's price, **the pricing will default to dynamic**, based on the normal prices of the products rather than the parent product's price. For example, if the parent product is priced at **$60**, and the items are priced at $15, $20, and $5, totaling **$40**, the order will be calculated at **$40** ignoring the parent product price. The sum of item prices must exceed the parent product price to qualify for static bundle pricing. This ensures customers are not overcharged.

<Image align="center" src="https://files.readme.io/dc449f1-Screenshot_2024-05-21_at_16.25.35.png" />

***

## Bundle Limitations

Note that certain features are not yet available for the new bundles:

* Shopify Discount Codes
* Prepaid options
* Multi-currency (Shopify Markets) for static bundles

***

## Implementing new Bundles

* [Setting up Bundles](https://developer.ordergroove.com/docs/configuring-bundles)
* [Bundles APIs](https://developer.ordergroove.com/docs/bundle-api-components)
* [Box Subscription Creation on Shopify](https://developer.ordergroove.com/docs/box-subscription-creation-on-shopify)

## Implementing legacy bundles

* [Build Your Own Box Subscriptions](https://help.ordergroove.com/hc/en-us/articles/7050551420947-Build-Your-Own-Box-Subscriptions)
* [Build Your Own Box Subscriptions with Shopify](https://help.ordergroove.com/hc/en-us/articles/5141865223443-Build-Your-Own-Box-Subscriptions-with-Shopify)