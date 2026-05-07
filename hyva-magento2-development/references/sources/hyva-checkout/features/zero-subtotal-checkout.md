<!-- source: https://docs.hyva.io/hyva-checkout/features/zero-subtotal-checkout.html -->

# Zero Subtotal Checkout in Hyvä Checkout

Hyvä Checkout supports zero subtotal checkout, letting customers complete orders that require no payment - for example, when a 100% discount coupon or store credit covers the full order total. You can control which payment methods appear during zero subtotal checkout through the Magento admin.

## Admin Configuration for Zero Subtotal Checkout

Hyvä Checkout provides two configuration options for zero subtotal orders. You'll find them in the Magento admin under `Stores -> Settings -> Configuration -> Hyvä Themes -> Checkout`.

### Removing Non-Zero Payment Methods from Checkout

**Path:** `Components -> Payment`

**Default Value:** `No`

When a customer's order total is zero, they don't need to provide payment information. Enabling this option removes all payment methods except the ones you specifically allow for zero subtotal checkout. This keeps the checkout clean and avoids confusing customers with irrelevant payment options.

### Selecting Payment Methods for Zero Subtotal Orders

**Path:** `Components -> Payment`

**Default Value:** `No Payment Information Required` (`free`)

This setting lists every installed payment method, including disabled ones (suffixed with `(disabled)`). Any payment method you select here will remain visible during zero subtotal checkout - everything else gets removed when the order value is zero.

Practical Example

If you want both the `free` method and a custom `purchase_order` method to appear during zero subtotal checkout, select both in this list. All other payment methods will be hidden.

## How Zero Subtotal Payment Filtering Works in Hyvä Checkout

### Payment Method Availability in Magento

The configuration list shows every installed payment method, but Magento still controls which methods are actually available to the customer. Magento uses the `Magento\Payment\Api\PaymentMethodListInterface::getActiveList()` method to filter the list of payment methods at checkout. This means a customer can never select a disabled payment method without additional customization, even if it appears in the admin configuration list.

Hyvä Checkout filters zero subtotal payment methods using the `Hyva\Checkout\Plugin\Magento\Quote\Api\PaymentMethodManagementInterface::afterGetList()` plugin. This plugin runs after Magento builds the payment method list and removes any methods not allowed for zero subtotal orders.

### Zero Total Validator Override in Hyvä Checkout

By default, Magento only allows the `free` payment method for zero subtotal orders. Hyvä Checkout removes that restriction so you can use any payment method you choose.

Hyvä Checkout achieves this by replacing the default Magento validator `Magento\Payment\Model\Checks\ZeroTotal` with a custom validator `Hyva\Checkout\Model\Payment\Checks\ZeroTotal`. The custom validator skips the "free method only" check, giving you full control over which payment methods are available during zero subtotal checkout.
