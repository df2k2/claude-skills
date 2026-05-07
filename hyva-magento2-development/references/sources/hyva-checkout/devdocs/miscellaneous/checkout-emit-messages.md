<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/miscellaneous/checkout-emit-messages.html -->

# Checkout Emit Messages

Hyva Checkout emits a variety of Magewire messages during the checkout process. Custom Magewire components can listen to these checkout emit messages and re-render when specific checkout events occur. JavaScript listeners can also subscribe to these messages, as described in [Listening to Messages in JavaScript](../../magewire/emit-messages.html#listening-to-magewire-emit-messages-in-javascript).

Each checkout step emits both a general message and a more specific message depending on whether the customer is a guest or a logged-in customer. This lets components react to broad events (like any shipping address being saved) or narrow events (like a guest billing address being submitted).

## Shipping Address Emit Messages

Hyva Checkout emits shipping address messages when a customer adds, submits, saves, or selects a shipping address. Each action emits a general message plus a guest-specific or customer-specific variant.

### Shipping Address Added

The `shipping_address_added` messages fire when a new shipping address is first entered into the checkout form.

- `shipping_address_added`
- `guest_shipping_address_added`
- `customer_shipping_address_added`

### Shipping Address Submitted

The `shipping_address_submitted` messages fire when the customer submits the shipping address form for validation.

- `shipping_address_submitted`
- `guest_shipping_address_submitted`
- `customer_shipping_address_submitted`

### Shipping Address Saved

The `shipping_address_saved` messages fire after the shipping address has been successfully persisted to the quote.

- `shipping_address_saved`
- `guest_shipping_address_saved`
- `customer_shipping_address_saved`

### Shipping Address Selected

The `shipping_address_activated` message fires when a customer selects an existing shipping address from the address book.

- `shipping_address_activated`

## Billing Address Emit Messages

Hyva Checkout emits billing address messages using the same pattern as shipping address messages. Each billing address action emits a general message plus a guest-specific or customer-specific variant.

### Billing Address Added

The `billing_address_added` messages fire when a new billing address is first entered into the checkout form.

- `billing_address_added`
- `guest_billing_address_added`
- `customer_billing_address_added`

### Billing Address Submitted

The `billing_address_submitted` messages fire when the customer submits the billing address form for validation.

- `billing_address_submitted`
- `guest_billing_address_submitted`
- `customer_billing_address_submitted`

### Billing Address Saved

The `billing_address_saved` messages fire after the billing address has been successfully persisted to the quote.

- `billing_address_saved`
- `guest_billing_address_saved`
- `customer_billing_address_saved`

### Billing Address Selected

The `billing_address_activated` message fires when a customer selects an existing billing address from the address book.

- `billing_address_activated`

## Coupon Code Emit Messages

Hyva Checkout emits coupon code messages when a customer applies or removes a coupon during checkout.

- `coupon_code_applied` fires when a coupon code is successfully applied to the cart.
- `coupon_code_revoked` fires when a previously applied coupon code is removed.

## Payment Method Emit Messages

Hyva Checkout emits a payment method message when the customer chooses a payment option.

- `payment_method_selected` fires when the customer selects a payment method during checkout.

## Shipping Method Emit Messages

Hyva Checkout emits a shipping method message when the customer picks a shipping option.

- `shipping_method_selected` fires when the customer selects a shipping method during checkout.

## Updating Component Listeners with Plugins

Every Magewire component in Hyva Checkout can define event listeners using the `$listeners` property, provided by the [Magewire `Event` trait](https://github.com/magewirephp/magewire/blob/main/src/Model/Concern/Event.php). The `Event` trait also exposes a `getListeners()` method, which makes it straightforward to customize a component's listeners using the [Magento plugin system](https://developer.adobe.com/commerce/php/development/components/plugins).

Common use cases for modifying checkout component listeners include adding a listener for a new event, removing an existing listener, or changing the method that runs when a particular event fires.

### How to Customize Checkout Component Listeners

Customizing a Magewire component's event listeners requires two steps: defining a plugin in `etc/frontend/di.xml` and implementing the listener modification logic in a plugin class.

**Step 1:** Register the plugin in `etc/frontend/di.xml`. The following example targets a hypothetical `Hyva\Checkout\Magewire\Checkout\Foo` component.

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <type name="Hyva\Checkout\Magewire\Checkout\Foo">
        <plugin name="update_hyva_checkout_foo_component_listeners"
                type="Vendor\Module\Plugin\UpdateFooListeners"/>
    </type>
</config>
```

**Step 2:** Implement the plugin class with an `afterGetListeners` method. This after-plugin receives the current `$listeners` array and returns the modified version.

```
<?php
declare(strict_types=1);

namespace Vendor\Module\Plugin;

class UpdateFooListeners
{
    public function afterGetListeners(
        \Hyva\Checkout\Magewire\Checkout\Foo $subject,
        array $listeners
    ): array {
        // Adding a new listener: re-render on the "foo" event
        $listeners['foo'] = 'refresh';

        // Removing a listener: stop reacting to the "bar" event
        unset($listeners['bar']);

        // Updating a listener: call a different method for the "baz" event
        $listeners['baz'] = 'someOtherFunction';

        return $listeners;
    }
}
```

Tip

When adding listeners for checkout emit messages, use the specific guest or customer variant (for example, `guest_shipping_address_saved`) if the component should only react for one customer type. Use the general variant (for example, `shipping_address_saved`) to react regardless of customer type.
