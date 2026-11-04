# Hyvä Checkout

## When to read this

You're customizing the checkout step UI, integrating a payment method, adding shipping fields, or trying to understand how Magewire fits in. Hyvä Checkout is a separate package from the Hyvä Theme — it has its own architecture.

## What Hyvä Checkout is

Hyvä Checkout is a one-page checkout for Hyvä themes. It uses Magewire, a Magento port of Laravel's Livewire, to handle server-driven reactive UI without writing custom JS for every interaction. The Magewire components are PHP classes that update their own state and re-render their phtml on user input.

It runs under **strict CSP by default** (PCI-DSS 4.0 compliant). All Alpine code in checkout templates must be CSP-safe.

## Release lines — Checkout 3.x (Magewire 3) vs 1.x (Magewire 1) — check first

| Line | Versions | Magewire | PHP | Status |
| --- | --- | --- | --- | --- |
| **Checkout 3.x** | `3.0.0`+ (latest 3.0.1), plus the `3.0.0` and `1.4.0` betas | Magewire 3 (`magewirephp/magewire ~3.7.2`) | 8.2+ | **Current** — use for new projects |
| **Checkout 1.x** | `1.3.x` (latest 1.3.15) and older, plus the `1.3.1000` betas | Magewire 1 (`^1.13.3`) | 8.1+ | Previous |

Find the installed line with `composer show hyva-themes/magento2-hyva-checkout | grep versions`. A version starting with `3.` **or `1.4.`** is Checkout 3.x: the 1.4.0 betas already ran on Magewire 3, and the line was renamed to 3.0.

**v1bc** (`hyva-themes/magento2-hyva-checkout-v1bc`, module `Hyva_CheckoutV1bc`) ships with Checkout 3.x and keeps Magewire 1 code working:
- **Inside the checkout**, every component runs in **v1 mode** unless it opts out, so most 1.x extensions work unchanged.
- **New or migrated components** opt out with `#[HandleBackwardsCompatibility(enabled: false)]` and are written against Magewire 3.
- **Keep v1bc enabled.** Never add it to your own module's `composer.json`: it requires Checkout 3.x, so your module could no longer install on 1.x.

**Writing code for both lines** (e.g. an extension). Keep the Magewire 1 code; on 3.x it runs through v1bc. Then:
- Bind with `wire:model.live` (sync on change) or `wire:model.defer` (send with the next request). A plain `wire:model` is **live on Magewire 1 but deferred on Magewire 3**.
- Send events with `emit('name', ['key' => $value])` (one associative array) plus `$listeners`.
- Change values in `updatedFoo($value)`. Avoid the generic `updated()` / `updating()` hooks, whose arguments are swapped on v3: `($name, $value)`.
- Read properties directly (`$magewire->foo`). Native Magewire 3 components have no magic `getFoo()`.
- Test on 1.x **and** on 3.x with v1bc enabled.

**Pages outside the checkout** that render Magewire components (e.g. a payment status page) need `<update handle="hyva_checkout_magewire_startup"/>` in their layout on 3.x. Magewire only starts on checkout pages.

Read before moving code to Magewire 3:
- `references/sources/hyva-checkout/magewire/index.md` — the Magewire 1 → 3 cheat sheet
- `references/sources/hyva-checkout/magewire/migrating-to-magewire-3.md`
- `references/sources/hyva-checkout/magewire/v1bc.md`

## Installing

Hyvä Checkout is a separate Composer package:
```bash
composer require hyva-themes/magento2-hyva-checkout
bin/magento setup:upgrade
```

Then enable the Hyvä Checkout in **Stores > Configuration > Sales > Checkout > Hyvä Checkout**.

**Upgrading 1.x → 3.x:** run `composer require hyva-themes/magento2-hyva-checkout:^3.0 --update-with-dependencies && bin/magento setup:upgrade`.
- Use `composer require`, not `composer update`: an existing `^1.3` constraint must be replaced. The command also pulls in v1bc 1.0.

Backward-incompatible changes:
- PHP 8.2+
- Tailwind v2 themes are not supported (Tailwind 3 or 4 required)
- `hyva-themes/magento2-theme-module ^1.3.16`
- The coupon-code component was rebuilt as a form
- Form API `submit()` rejects empty required fields server-side
- `magewire_<event>` Magento observers only run while v1bc is enabled

Full list: `references/sources/hyva-checkout/upgrading/upgrading-to-3.0.0.md`.

## Architecture overview

The checkout page is composed of **components** (Magewire classes) arranged via XML in a config file. Each component:

1. Has a PHP class extending `\Magewirephp\Magewire\Component`, or a Hyvä Checkout subclass such as `\Hyva\Checkout\Magewire\Component\AbstractForm` for Form API forms.
2. Has a corresponding phtml template that renders the component's state.
3. Re-renders on the server whenever a Magewire action is fired.
4. Communicates with sibling components via events: `dispatch()` + `#[On]` on Magewire 3, `emit()` + `$listeners` on Magewire 1. It reaches the browser with `dispatchBrowserEvent()`.

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

use Magewirephp\Magewire\Component;
use Magewirephp\Magewire\Features\SupportMagewireBackwardsCompatibility\HandleBackwardsCompatibility;

// Checkout 3.x: run as a native Magewire 3 component (leave this attribute out on Checkout 1.x).
#[HandleBackwardsCompatibility(enabled: false)]
class MyCustomComponent extends Component
{
    public string $note = '';

    public function saveNote(): void
    {
        // persist $this->note somewhere — quote extension attribute, session, custom table
        $this->dispatch('note-saved', text: $this->note);   // Magewire 1: $this->emit('note-saved', ['text' => $this->note]);
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

On **Magewire 3** a plain `wire:model` is **deferred**: the value travels with the next request, here the Save click. Use `wire:model.live` to sync on every change, or `.blur` for on-blur. On **Magewire 1** a plain `wire:model` syncs on every change.

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
3. In the template, render the input with `wire:model.live="myField"` (syncs on change on both lines), or `wire:model.defer` to send it with the next request. On Magewire 3, `.lazy` is only an alias of `.change`, so prefer the explicit modifiers.
4. On `updatedMyField`, persist to the quote (extension attribute) so it survives navigation.
5. If a **form modifier** makes an address or guest-details field live (e.g. a postcode lookup), it must set `wire:model.live`. On Checkout 3.x's forms a plain `wire:model` stays deferred, even with v1bc.

### Trigger a sibling component to refresh
Magewire 3 (Checkout 3.x):
```php
$this->dispatch('shipping-method-updated', code: $code);           // ->to('block.name') to target one component
```
```php
use Magewirephp\Magewire\Attributes\On;

class CartSummary extends \Magewirephp\Magewire\Component {
    #[On('shipping-method-updated')]
    public function refresh(string $code): void { /* … */ }        // payload bound by key
}
```
Magewire 1, which also runs on 3.x via v1bc:
```php
$this->emit('shipping-method-updated', ['code' => $code]);
// receiver:
protected $listeners = ['shipping-method-updated' => 'refresh'];
public function refresh(array $payload): void { /* $payload['code'] */ }
```

### Dispatch a browser event from a Magewire component
For Alpine listeners on the same page:
```php
$this->dispatchBrowserEvent('order-totals-updated', ['total' => 99.99]);
```
```html
<div x-data @order-totals-updated.window="$el.textContent = $event.detail.total"></div>
```

The data array becomes `event.detail`, the same way Hyvä Checkout's own `checkout:shipping:method-activate` exposes `event.detail.method`. **Always pass an array**, even `[]`: with Magewire 3.7 / v1bc, a call without data, or with a string or number, fails the request.

## Don't

- Don't use UI components, Knockout, or RequireJS in checkout templates. They aren't loaded.
- Don't use unsafe-inline Alpine — checkout is CSP-strict.
- Don't write `setup-content-deploy` checks specific to checkout — the build is normal.
- Don't try to build a checkout step in pure JS that doesn't go through Magewire — you'll fight the framework. Use Magewire for everything that touches the quote, address, payment, or shipping.
- Don't expect `text/x-magento-init` to work — checkout strips Magento's UI-component infrastructure.
- Don't write new Magewire 1-only code for Checkout 3.x. Opt the component out of v1 mode with `#[HandleBackwardsCompatibility(enabled: false)]`, or follow the "code for both lines" rules above.
- Don't require `hyva-themes/magento2-hyva-checkout-v1bc` in your module's `composer.json`, and don't disable v1bc while any extension still needs Magewire 1. Observers of `magewire_<event>` stop running without it.

## Useful references

- The full Hyvä Checkout devdocs: `hyva-checkout/devdocs/`
- Magewire docs: Magewire 3 at [docs.magewirephp.nl](https://docs.magewirephp.nl/), Magewire 1 at [magewirephp.github.io/magewire](https://magewirephp.github.io/magewire/)
- Available payment integrations: [docs.hyva.io/hyva-checkout/integrations/available-payment-methods.html](https://docs.hyva.io/hyva-checkout/integrations/available-payment-methods.html)
- Example payment method: [docs.hyva.io/hyva-checkout/examples/js-payment-method.html](https://docs.hyva.io/hyva-checkout/examples/js-payment-method.html)

## Original sources

- `references/sources/hyva-checkout/index.md` — overview
- `references/sources/hyva-checkout/getting-started/index.md` — install + activation
- `references/sources/hyva-checkout/glossary.md` — terminology
- `references/sources/hyva-checkout/features/index.md` — feature catalogue
- `references/sources/hyva-checkout/magewire/index.md` — Magewire framework basics, Magewire 1 → 3 cheat sheet, "code that runs on both release lines"
- `references/sources/hyva-checkout/getting-started/release-lines.md` — Checkout 3.x vs 1.x, version detection
- `references/sources/hyva-checkout/faq/what-is-v1bc.md`, `references/sources/hyva-checkout/magewire/v1bc.md` — the Magewire 1 compatibility module
- `references/sources/hyva-checkout/magewire/migrating-to-magewire-3.md` — migrating components, JS hooks, pages outside the checkout
- `references/sources/hyva-checkout/magewire/emit-messages.md` — `dispatch()` / `#[On]` vs `emit()` / `$listeners`
- `references/sources/hyva-checkout/upgrading/upgrading-to-3.0.0.md` — 1.x → 3.x upgrade and backward-incompatible changes
- `references/sources/hyva-checkout/upgrading/changelog.md` (3.x), `changelog-1.x.md` (1.x)
- `references/sources/hyva-checkout/devdocs/frontend-api/events.md` — browser events (`checkout:*`) and their `event.detail`
- `references/sources/hyva-checkout/devdocs/form-api/magewire-driven-forms.md` — `AbstractForm` on Checkout 3.x
- `references/sources/hyva-checkout/devdocs/custom-checkout/hyva-checkout-xml.md` — checkout XML reference
- `references/sources/hyva-checkout/examples/js-payment-method.md` — full payment method example
- `references/sources/hyva-checkout/integrations/available-payment-methods.md` — supported payment methods
- `references/sources/hyva-checkout/faq/404-component-not-found.md` — common "component not found" debugging
- `references/sources/hyva-checkout/upgrading/index.md` — checkout upgrade notes
- For Magewire itself: [magewirephp.github.io/magewire](https://magewirephp.github.io/magewire/) (external)
