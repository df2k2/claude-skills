# Ordinal Based Rotating Products

## What are Ordinal Based Rotating Products

Ordinal Rotation allows merchants to establish an ordered list of products for delivery within a subscription plan. This list dictates the specific product a customer receives at each delivery interval.

## How Ordinal Based Rotating Products Work

To create an Ordinal Rotation Subscription program, a series of *selection rules* will need to be defined using the Ordergroove API. Each selection rule consists of a `product`, a `starting_ordinal`, and a `public_id`.

* **product**: This identifies the specific product that will be delivered at a designated point in the sequence.
* **starting\_ordinal**: This is a non-negative whole number that represents the first delivery "position" for the product in the planned sequence. See the *Additional Considerations* section below for more details on how\
  `starting_ordinal` works.
  * The `starting_ordinal` is a natural number that represents the first delivery "position" for the product in the planned sequence. The sequencing is zero-based, and as such at least a `starting_ordinal` of 0 is required. This zeroth ordinal represents the customer's first product delivery - the one that will be generated as part of the checkout order. The first renewal order will have a `starting_ordinal` of 1, and so on. For example, if a product has a `starting_ordinal` of 2, it means the customer will receive that product on their third delivery (second renewal order). If there are no `starting_ordinal`s with a number greater than 2, they will also receive that product on all subsequent renewal orders.
* The `public_id` is a random ID generated and assigned to the Selection Rule.

### Additional Considerations for `starting_ordinal`

* **Repeating Products**: If a product has no Selection Rules with a `starting_ordinal` greater than a specific value (e.g., no rules with `starting_ordinal` greater than 2), the customer will continue to receive that product on all subsequent renewal orders.
  * Note: If the product is configured as a Cyclical Rotation, the customer will not continue receiving the final product. Instead they will restart the subscription journey, starting from the product that was delivered as part of their checkout order.
* **Gaps in the Sequence**: Selection Rules can have gaps in the starting\_ordinal sequence. For example, if there are rules for `starting_ordinal` values of 0, 1, 2, and 5. In this case, deliveries for renewal orders between starting\_ordinal 2 and 5 (not inclusive) wouldn't have an explicitly defined rule associated with them. all receive the product associated with the selection rule with a starting\_ordinal of 2. In this scenario, the system would deliver the product associated with the previously defined rule in the sequence (i.e., the product with a starting\_ordinal of 2 in this example).
* **Zeroth Ordinal Required**: Ordinal rotations require a selection rule with a starting\_ordinal of 0. This zeroth ordinal signifies the customer's first delivery product - the one that will be generated as part of the checkout order. The first renewal order will have a position associated with a `starting_ordinal` of 1, and so on. For example, if a Selection Rule has a `starting_ordinal` of 2, it means the customer will receive the product associated with that Selection Rule on their third delivery (second renewal order).

## Cyclical Rotations

An Ordinal Rotation can configured as a Cyclical Rotation. A Cyclical Rotation will not **not** continue using the final Selection Rule to determine all Delivery Products after the initial delivery of the product. Instead, the customer will have their subscription journey restarted at the beginning. Essentially their ordinal position will be reset to 0 after they hit the Selection Rule with the highest `starting_ordinal`. See below for an example.

## Product Selection

The delivery product in an Ordinal Rotation Subscription depends on the customer's position within the pre-defined delivery sequence. This sequence dictates which product is delivered at each renewal order. As the customer progresses through the subscription program, the system automatically references their order position to determine the corresponding delivery product.

1. **Identifying the Customer's Order Position**
   1. **Checkout Order:** The checkout order will always use the Selection Rule with a `starting_ordinal` of 0.
   2. **Renewal Order - Default:** The system identifies the current order position for the customer's subscription. This order position is incremented by one for every order.
   3. **Renewal Order - Cyclical:** If the subscription is for a Cyclical Rotation, the order position will never be incremented past the max configured `starting_ordinal`. Instead their order position will be reset to 0.
2. **Find Selection Rule**
   1. **Exact Match:** The system searches for a selection rule that where the `starting_ordinal` matches the customer's order position.
   2. **No Exact Match:** If no matching selection rule is found (i.e., there's no rule with a `starting_ordinal` equal to the order position), the system will default to the selection rule that was used for the previous order.
3. **Delivery Product Selection:** The product associated with the chose Selection Rule will become the Delivery Product that the customer will receive with their order.

In simpler terms, the system follows the planned sequence defined by the Selection Rules to determine the Delivery Product for each order. If there's a gap in the Selection Rules for a specific order position (no rule with a matching `starting_ordinal`), the system defaults to the Selection Rule used in the previous order. Cyclical Rotations will always reset to 0 after receiving all Delivery Products.

### Example

Consider the following configuration for Selection Rules associated with an Ordinal Based subscription program:

| Coffee Product      | Starting Ordinal |
| ------------------- | ---------------- |
| Light Roast Blend   | 0                |
| Medium Roast Blend  | 1                |
| Dark Roast Blend    | 4                |
| Coffee of the Month | 5                |

In this example:

1. Your customer goes through initial checkout and receives the *Light Roast Blend*.
2. On their first renewal order, the `starting_ordinal` increments to 1 and the customer is sent the *Medium Roast Blend*.
3. The customer will receive the *Medium Roast Blend* on the second and third renewal orders because there are no explicitly defined rules with a `starting_ordinal` of 2 or 3.
4. The customer receives the *Dark Roast Blend* from the 4th renewal order.
5. Once the order position surpasses the final Selection Rule's `starting_ordinal`:
   1. **Default Configuration:** The customer is sent Coffee of the Month for the 5th renewal order and all subsequent renewals until a Selection Rule associated with a higher `starting_ordinal` is defined.
   2. **Cyclical Configuration:** If the program is setup to be Cyclical, they will instead restart the delivery journey at Light Roast Blend after receiving Coffee of the Month.

| Order Number | Order Position - Delivery Product (Default Configuration) | Order Position - Delivery Product (Cyclical Configuration) |
| :----------- | :-------------------------------------------------------- | :--------------------------------------------------------- |
| 0            | 0 - Light Roast Blend                                     | 0 - Light Roast Blend                                      |
| 1            | 1 - Medium Roast Blend                                    | 1 - Medium Roast Blend                                     |
| 2            | 2 - Medium Roast Blend                                    | 2 - Medium Roast Blend                                     |
| 3            | 3 - Medium Roast Blend                                    | 3 - Medium Roast Blend                                     |
| 4            | 4 - Dark Roast Blend                                      | 4 - Medium Roast Blend                                     |
| 5            | 5 - Coffee of the Month                                   | 5 - Coffee of the Month                                    |
| 6            | 6 - Coffee of the Month                                   | 0 - Light Roast Blend                                      |
| 7            | 7 - Coffee of the Month                                   | 1 - Medium Roast Blend                                     |