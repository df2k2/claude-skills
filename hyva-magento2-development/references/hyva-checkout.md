# Hyvä Checkout

## When to read this

You're customizing the checkout step UI, integrating a payment method, adding shipping fields, or trying to understand how Magewire fits in. Hyvä Checkout is a separate package from the Hyvä Theme — it has its own architecture.

## What Hyvä Checkout is

Hyvä Checkout is a one-page checkout for Hyvä themes. It uses [Magewire](https://magewirephp.github.io/magewire/) — a Magento port of Laravel's Livewire — to handle server-driven reactive UI without writing custom JS for every interaction. The Magewire components are PHP classes that update their own state and re-render their phtml on user input.

It runs under **strict CSP by default** (PCI-DSS 4.0 compliant). All Alpine code in checkout templates must be CSP-safe.

## Installing

Hyvä Checkout is a separate Composer package:
```bash
composer require hyva-themes/magento2-hyva-checkout
bin/magento setup:upgrade
```

Then enable the Hyvä Checkout in **Stores > Configuration > Sales > Checkout > Hyvä Checkout**.

## Architecture overview

The checkout page is composed of **components** (Magewire classes) arranged via XML in a config file. Each component:

1. Has a PHP class extending `Hyva\Checkout\Magewire\Component\AbstractMagewireComponent` (or one of its subclasses).
2. Has a corresponding phtml template that renders the component's state.
3. Re-renders on the server whenever a Magewire action is fired.
4. Communicates with sibling components via events (`emit`, `dispatchBrowserEvent`).

```
hyva-checkout/
├── etc/checkout.xml          (the structure: components, slots, hierarchy)
├── Magewire/Component/...    (PHP classes)
└── view/frontend/templates/...  (phtml templates)
```

## `hyva-checkout.xml`

The structure of the checkout page is defined in `view/frontend/layout/hyva_checkout_index_index.xml` AND in `etc/hyva-checkout.xml` files merged across modules.

A typical layout:
```xml
<?xml version="1.0" encoding="utf-8"?>
<checkout xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:noNamespaceSchemaLocation="urn:hyva:checkout:config">
    <components>
        <component name="my-custom-component"
                   class="Acme\Module\Magewire\Component\MyCustomComponent"
                   template="Acme_Module::checkout/my-custom-component.phtml"
                   sortOrder="50">
            <parent name="checkout.shipping.method" />
        </component>
    </components>
</checkout>
```

The exact schema/elements depend on the Hyvä Checkout version — see `vendor/hyva-themes/magento2-hyva-checkout/` for the up-to-date xsd.

## A minimal Magewire component

```php
<?php
declare(strict_types=1);

namespace Acme\Module\Magewire\Component;

use Hyva\Checkout\Magewire\Component\AbstractMagewireComponent;

class MyCustomComponent extends AbstractMagewireComponent
{
    public string $note = '';

    public function saveNote(): void
    {
        // persist $this->note somewhere — quote extension attribute, session, custom table
        $this->emit('note-saved', ['text' => $this->note]);
    }
}
```

```php
<?php
/** @var \Acme\Module\Magewire\Component\MyCustomComponent $magewire */
/** @var \Magento\Framework\Escaper $escaper */
?>
<div class="note-component">
    <label class="block">
        <?= $escaper->escapeHtml(__('Order note')) ?>
        <textarea wire:model="note" rows="3" class="form-textarea w-full"></textarea>
    </label>
    <button wire:click="saveNote" class="btn btn-primary mt-2">
        <?= $escaper->escapeHtml(__('Save')) ?>
    </button>
</div>
```

`wire:model` two-way binds to the public property. `wire:click` calls a public method. No custom JS needed.

## Magewire vs. Alpine

**Magewire** for server-validated state, payment integrations, shipping calculations — anything that needs server data or where you want the SSOT in PHP.

**Alpine** for purely client-side toggles — accordion sections, "show more" links, focus management, etc.

You can use both in the same template. They don't conflict.

## CSP compliance in checkout

Because Hyvä Checkout runs under strict CSP:
- `x-data="{ open: false }"` — ❌
- `wire:click="save"` — ✓ (Magewire's directive isn't an inline expression)
- `@click="open = !open"` — ❌ — use `@click="toggle"` plus a registered Alpine component

If you write Alpine in a checkout template, follow `alpine-csp.md` rules strictly.

## Adding a payment method

Hyvä Checkout payment methods live in their own modules. The minimal shape:

1. **Magewire component** for the payment form (`Acme_PaymentX_Magewire_Component_Method`)
2. **Template** that renders the payment-specific inputs (or, if redirect-based, a marketing message)
3. **Registration** in `etc/hyva-checkout.xml` under the payment slot:
   ```xml
   <component name="payment.acme-payment-x"
              class="Acme\PaymentX\Magewire\Component\Method"
              template="Acme_PaymentX::checkout/payment/method.phtml"
              method="acme_payment_x">
       <parent name="checkout.payment.methods" />
   </component>
   ```
4. **Validation logic** in the Magewire component (e.g., `validateBeforePlaceOrder()`)

For redirect-based payment methods (Adyen, Mollie, Stripe redirect, etc.), the Magewire component is essentially a stub — the actual redirect is handled by `Magento_Payment` after the order places. For in-context payment buttons (PayPal Express, Apple Pay), there's a separate registration mechanism. See the [Hyvä Checkout integrations docs](https://docs.hyva.io/hyva-checkout/integrations/available-payment-methods.html).

## Hyvä Checkout XML layout

The `hyva_checkout_index_index.xml` file is where the *whole* checkout layout is composed. It's not a normal Magento layout XML — it uses a Hyvä Checkout-specific namespace and element vocabulary. See `vendor/hyva-themes/magento2-hyva-checkout/etc/hyva-checkout.xml` for the canonical structure and the `hyva-checkout-xml.md` doc for details.

## Common patterns

### Add a custom field above the shipping address
1. Create a Magewire component (`MyField`) with a public string property and `mount()`/`updated*()` hooks.
2. Register it as a child of `checkout.shipping.address` in `hyva-checkout.xml`.
3. In the template, render the input with `wire:model.lazy="myField"` (or `wire:model.defer` to debounce).
4. On `updatedMyField`, persist to the quote (extension attribute) so it survives navigation.

### Trigger a sibling component to refresh
```php
$this->emit('shipping-method-updated', ['code' => $code]);
```
Then in the receiver:
```php
class CartSummary extends AbstractMagewireComponent {
    protected $listeners = ['shipping-method-updated' => 'refresh'];
    public function refresh(): void { /* … */ }
}
```

### Dispatch a browser event from a Magewire component
For Alpine listeners on the same page:
```php
$this->dispatchBrowserEvent('order-totals-updated', ['total' => 99.99]);
```
```html
<div x-data @order-totals-updated.window="$el.textContent = $event.detail[0].total"></div>
```

(Magewire wraps detail in an array — note the `$event.detail[0].total`.)

## Don't

- Don't use UI components, Knockout, or RequireJS in checkout templates. They aren't loaded.
- Don't use unsafe-inline Alpine — checkout is CSP-strict.
- Don't write `setup-content-deploy` checks specific to checkout — the build is normal.
- Don't try to build a checkout step in pure JS that doesn't go through Magewire — you'll fight the framework. Use Magewire for everything that touches the quote, address, payment, or shipping.
- Don't expect `text/x-magento-init` to work — checkout strips Magento's UI-component infrastructure.

## Useful references

- The full Hyvä Checkout devdocs: `hyva-checkout/devdocs/`
- Magewire docs: [magewirephp.github.io/magewire](https://magewirephp.github.io/magewire/)
- Available payment integrations: [docs.hyva.io/hyva-checkout/integrations/available-payment-methods.html](https://docs.hyva.io/hyva-checkout/integrations/available-payment-methods.html)
- Example payment method: [docs.hyva.io/hyva-checkout/examples/js-payment-method.html](https://docs.hyva.io/hyva-checkout/examples/js-payment-method.html)

## Original sources

- `references/sources/hyva-checkout/index.md` — overview
- `references/sources/hyva-checkout/getting-started/index.md` — install + activation
- `references/sources/hyva-checkout/glossary.md` — terminology
- `references/sources/hyva-checkout/features/index.md` — feature catalogue
- `references/sources/hyva-checkout/magewire/index.md` — Magewire framework basics
- `references/sources/hyva-checkout/devdocs/custom-checkout/hyva-checkout-xml.md` — checkout XML reference
- `references/sources/hyva-checkout/examples/js-payment-method.md` — full payment method example
- `references/sources/hyva-checkout/integrations/available-payment-methods.md` — supported payment methods
- `references/sources/hyva-checkout/faq/404-component-not-found.md` — common "component not found" debugging
- `references/sources/hyva-checkout/upgrading/index.md` — checkout upgrade notes
- For Magewire itself: [magewirephp.github.io/magewire](https://magewirephp.github.io/magewire/) (external)
