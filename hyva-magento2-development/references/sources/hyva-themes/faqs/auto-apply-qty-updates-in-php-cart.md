<!-- source: https://docs.hyva.io/hyva-themes/faqs/auto-apply-qty-updates-in-php-cart.html -->

# Cart item quantity updates requires clicking Update Cart (PHP Cart)

The cart page uses a conservative UI experience out of the box,
and requires visitors to click the "Update Shopping Cart" button after making changes.

Since you are reading this page, you probably are wondering why it doesn't use Ajax.

In Hyvä we try to keep things simple where possible, and in this case it seemed an appropriate default behavior.

Changing the cart page to apply item quantity updates automatically
with Ajax requires customizing the template `Magento_Checkout/templates/php-cart/item/default.phtml`.

By adding the following event listener to the input field, the form will be submitted automatically two seconds after a visitor changes the quantity:

```
x-on:change.debounce.2000ms="$event.target.form && $event.target.form.dispatchEvent(new Event('submit', { cancelable: true }));"
```

Here is the full input field code for reference:

```
<input
    id="cart-<?= $escaper->escapeHtmlAttr($item->getId()) ?>-qty"
    name="cart[<?= $escaper->escapeHtmlAttr($item->getId()) ?>][qty]"
    value="<?= $escaper->escapeHtmlAttr($block->getQty()) ?>"
    type="number"
    size="4"
    step="any"
    title="<?= $escaper->escapeHtmlAttr(__('Qty')) ?>"
    class="qty form-input px-2 py-2 w-20 text-center"
    required
    min="0"
    @change.debounce.2000ms="$event.target.form && $event.target.form.dispatchEvent(new Event('submit', { cancelable: true }));"
    data-role="cart-item-qty"
>
```

Using `dispatchEvent` on the `form` ensures any JavaScript form submission events are being triggered.
In this case, it will trigger the `hyva.postCart` event that reloads the cart data without a full page request.

If you don't want Ajax requests, but still want to apply quantity changes automatically, use this instead:

```
x-on:change.debounce.2000ms="$event.target.form.submit()"
```
