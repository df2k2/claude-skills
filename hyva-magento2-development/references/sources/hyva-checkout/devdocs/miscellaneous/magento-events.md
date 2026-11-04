<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/miscellaneous/magento-events.html -->

# Hyvä Checkout Magento Events

Hyvä Checkout dispatches several Magento events during the checkout lifecycle. You can observe these events in your custom modules to run code at specific points - for example, when the checkout initializes, when a step loads, or when the layout is being processed.

## The `hyva_checkout_init_after` Event

The `hyva_checkout_init_after` event fires when a customer loads the Hyvä Checkout for the first time, or when the customer revisits the checkout after one of the following events has been triggered:

- `hyva_checkout_quote_id_changed`
- `customer_login`
- `customer_address_save_after`
- `sales_quote_remove_item`

If you need to trigger a checkout session reset for a custom event, use the `Hyva\Checkout\Observer\Frontend\HyvaCheckoutSessionReset` class inside an `etc/frontend/events.xml` file in your module.

## Checkout Init Events: `hyva_checkout_{checkout_name}_init` and `hyva_checkout_{checkout_name}_{step_name}_init`

These Hyvä Checkout init events fire when the checkout step configuration loads for the first step. If the checkout only has a single step, both events are dispatched as well.

Use these events to run code specifically on the first step of a given checkout. Replace `{checkout_name}` with your checkout's identifier and `{step_name}` with the step identifier.

## Checkout Booted Events: `hyva_checkout_{checkout_name}_booted` and `hyva_checkout_{checkout_name}_{step_name}_booted`

The Hyvä Checkout booted events fire on every step when the step configuration loads. Unlike the init events (which only fire on the first step), the booted events fire each time any step loads.

Use these events to run code on every step of a specific checkout, or to target a particular checkout/step combination.

## Shipping Address Activated Event

Hyvä Checkout dispatches a Magento event when the customer selects a different shipping address from the address list. Hyvä Checkout observes it itself to unset the selected shipping method when that method is no longer available for the new address. The event name depends on the release line.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Observe `hyva_checkout_shipping_address_activated`. The shipping address list component dispatches it explicitly, with the selected address ID in the `id` argument.

Magewire 3 doesn't turn component events into Magento events, so Magewire 3 itself doesn't dispatch the `magewire_shipping_address_activated` event that Checkout 1.x uses. While the [v1bc module](../../magewire/v1bc.html) is enabled, every component event also fires the `magewire_<event>` Magento event, so existing observers of `magewire_shipping_address_activated` keep working. Use `hyva_checkout_shipping_address_activated` for new code, and move existing observers to it before you disable v1bc.

Observe `magewire_shipping_address_activated`. Magewire 1 dispatches a Magento event named `magewire_<event>` for every event a component emits, and the shipping address list component emits `shipping_address_activated` with the selected address ID in the `id` argument.

## Layout Process Events: `hyva_checkout_layout_process_before`

The Hyvä Checkout layout process events fire when step layout directives are processed. Three variants are dispatched, ranging from general to specific:

- `hyva_checkout_layout_process_before_hyva_checkout` - fires for all Hyvä Checkouts
- `hyva_checkout_layout_process_before_hyva_checkout_{checkout_name}` - fires for a specific checkout
- `hyva_checkout_layout_process_before_hyva_checkout_{checkout_name}_{step_name}` - fires for a specific checkout/step combination

These events let you conditionally load a layout handle for a particular checkout or step. The event payload includes a `page` argument containing an instance of `Magento\Framework\View\Result\Page`.

Step-specific layout handles

Step-specific layout handles can also be applied via [checkout XML](../custom-checkout/hyva-checkout-xml.html) without using events.
