# Converting an Alpine.js Component to Strict-CSP-Safe in Hyvä Magento 2

This guide walks you through converting your terms-and-conditions toggle to be compatible with a strict, PCI-DSS compliant Content Security Policy (CSP) on a Hyvä Magento 2 storefront.

---

## 1. Why your current code is not CSP-safe

Your current snippet:

```html
<div x-data="{ accepted: false }">
  <button @click="accepted = !accepted">Toggle</button>
  <div x-show="accepted">terms…</div>
</div>
```

Under a strict CSP (no `unsafe-inline`, no `unsafe-eval`), the following are a problem:

1. **`x-data="{ accepted: false }"`** – Alpine evaluates the attribute string with `new Function(...)`, which is `eval`-equivalent. Modern Alpine ships a CSP-safe build, but that build only accepts an **identifier** here, not an inline object literal.
2. **`@click="accepted = !accepted"`** – The CSP-safe Alpine build does not allow arbitrary expressions in directives. It only accepts a method/property reference defined on the component data object.
3. **`x-show="accepted"`** – Same restriction; the CSP-safe build only accepts a single property identifier, not an arbitrary expression. (A bare property name like `accepted` is allowed.)

PCI-DSS v4.0 (effective March 2025, requirement 6.4.3 / 11.6.1) effectively requires payment pages to be served with a strict CSP and integrity-pinned scripts. Hyvä supports this through the `MagentoHyva_CspSafeAlpine` configuration plus Magento's native `Magento_Csp` module.

---

## 2. The Hyvä-recommended pattern

In Hyvä, CSP-safe Alpine components are written by:

- Declaring **named components** with `Alpine.data('myComponent', () => ({ ... }))` in a JS module that is loaded as an ES module (or registered before `alpine:init`).
- Replacing inline expressions in `x-data`, `@click`, `x-show`, etc. with **bare identifiers** that resolve to data, methods, or getters on that component.
- Loading that JS as a hashed/SRI external file (no inline `<script>` blocks).

Hyvä's documentation calls this approach “Pure Alpine.js components” for CSP. It is the same pattern Alpine's official `@alpinejs/csp` build requires.

---

## 3. File layout

For a typical Hyvä theme (replace the vendor/theme path with yours):

```
app/design/frontend/<Vendor>/<theme>/
  Magento_Checkout/
    templates/
      payment/
        terms-toggle.phtml          <-- new partial, or block include
  web/
    tailwind/
      tailwind.config.js
    js/
      payment/
        terms-toggle.js             <-- the Alpine component
  Magento_Csp/
    etc/
      csp_whitelist.xml             <-- if you need to whitelist anything
```

If you are placing the JS through Hyvä's standard module bundling, the equivalent module path is:

```
app/code/<Vendor>/<Module>/view/frontend/web/js/payment/terms-toggle.js
app/code/<Vendor>/<Module>/view/frontend/templates/payment/terms-toggle.phtml
```

---

## 4. Step-by-step conversion

### Step 4.1 – Create the Alpine component module

**File:** `app/design/frontend/<Vendor>/<theme>/web/js/payment/terms-toggle.js`

```js
// CSP-safe Alpine component for the payment "Terms & Conditions" toggle.
// Registered as a named component so templates can reference it by name.
export default function termsToggle() {
    return {
        accepted: false,

        // Method bound to @click; no inline expressions in markup.
        toggle() {
            this.accepted = !this.accepted;
        },

        // Optional: explicit accessor used by x-show / x-bind.
        get isOpen() {
            return this.accepted;
        },
    };
}
```

### Step 4.2 – Register the component before Alpine initializes

In Hyvä, Alpine loads via the `requirejs-config.js`/`Magento_Theme/templates/page/js/alpine.phtml` chain. The cleanest place to register a custom component is a small bootstrap file that listens for `alpine:init`.

**File:** `app/design/frontend/<Vendor>/<theme>/Magento_Theme/templates/page/js/components.phtml`

```php
<?php
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
?>
<script type="module">
    import termsToggle from '<?= $escaper->escapeUrl(
        $block->getViewFileUrl('js/payment/terms-toggle.js')
    ) ?>';

    document.addEventListener('alpine:init', () => {
        window.Alpine.data('termsToggle', termsToggle);
    });
</script>
```

Two important notes:

1. The `<script type="module">` block above is an inline script. Under a strict CSP it will only run if it is hashed and the hash is whitelisted. Hyvä's CSP integration computes hashes for inline blocks rendered server-side, so this works automatically when `default-src 'self' 'unsafe-inline'` is replaced with `script-src 'self' 'sha256-...'`. If you prefer no inline script at all, move the registration into the external JS file (see Step 4.4).
2. Make sure this template is included on the payment page, e.g. via a layout XML reference to `head.additional`, `before.body.end`, or by adding it to your `default.xml`.

### Step 4.3 – Convert the markup to use the named component

**File:** `app/design/frontend/<Vendor>/<theme>/Magento_Checkout/templates/payment/terms-toggle.phtml`

```html
<div x-data="termsToggle">
    <button type="button"
            @click="toggle"
            :aria-expanded="accepted"
            aria-controls="payment-terms-panel"
            class="btn btn-secondary">
        <?= $escaper->escapeHtml(__('Toggle')) ?>
    </button>

    <div x-show="accepted"
         x-cloak
         id="payment-terms-panel"
         role="region">
        <?= $escaper->escapeHtml(__('terms…')) ?>
    </div>
</div>
```

Why this is now CSP-safe:

- `x-data="termsToggle"` – a bare identifier (the registered component name), no expression evaluation.
- `@click="toggle"` – a bare method reference, not an inline expression.
- `x-show="accepted"` – a single property name, allowed by the CSP-safe Alpine build.
- `:aria-expanded="accepted"` – also a bare property reference, allowed.

Add `x-cloak` (and a tiny `[x-cloak]{ display: none !important; }` rule, which Hyvä already ships in its base CSS) to prevent FOUC before Alpine binds.

### Step 4.4 – (Recommended) Eliminate the inline script

If you want zero inline scripts on the payment page, register the component from an external file:

**File:** `app/design/frontend/<Vendor>/<theme>/web/js/payment/terms-toggle.bootstrap.js`

```js
import termsToggle from './terms-toggle.js';

document.addEventListener('alpine:init', () => {
    window.Alpine.data('termsToggle', termsToggle);
});
```

Then load it in layout XML:

**File:** `app/design/frontend/<Vendor>/<theme>/Magento_Checkout/layout/checkout_index_index.xml`

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <head>
        <script src="js/payment/terms-toggle.bootstrap.js" type="module"/>
    </head>
</page>
```

Magento will resolve `js/payment/terms-toggle.bootstrap.js` against your theme's `web/` folder. Because it is a real file served from the same origin, it is covered by `script-src 'self'` and needs no hash or `unsafe-inline`.

### Step 4.5 – Switch Alpine to the CSP build

Hyvä's default Alpine includes the expression evaluator. For PCI pages you want the CSP-safe build (`@alpinejs/csp`).

In your theme's `web/tailwind/tailwind.config.js` / build pipeline, or in the file that bundles Alpine, replace:

```js
import Alpine from 'alpinejs';
```

with:

```js
import Alpine from '@alpinejs/csp';
```

Then rebuild Hyvä's frontend assets:

```bash
cd app/design/frontend/<Vendor>/<theme>/web/tailwind
npm install
npm run build-prod
```

If your theme inherits from Hyvä's default and you prefer not to fork the bundling, you can still ship the CSP-safe Alpine build only on the checkout/payment route by conditionally including a different `<script>` in `head.additional` for that route. The simplest route-aware switch is in `Magento_Checkout/layout/checkout_index_index.xml`.

### Step 4.6 – Update CSP whitelist if needed

Magento's strict CSP is configured in `Magento_Csp/etc/csp_whitelist.xml`. If you serve the JS from the same origin you do not need any additions. If you load Alpine or your component from a CDN, declare it:

**File:** `app/code/<Vendor>/<Module>/etc/csp_whitelist.xml`

```xml
<?xml version="1.0"?>
<csp_whitelist xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Csp:etc/csp_whitelist.xsd">
    <policies>
        <policy id="script-src">
            <values>
                <value id="self" type="host">'self'</value>
                <!-- Add CDN host only if you really need it -->
                <!-- <value id="cdn" type="host">https://cdn.example.com</value> -->
            </values>
        </policy>
    </policies>
</csp_whitelist>
```

Set CSP to enforce mode (not report-only) for the checkout area in `app/etc/config.php` or via `bin/magento config:set`:

```bash
bin/magento config:set csp/mode/storefront/checkout_index_index restrict
bin/magento cache:clean
```

(In Magento 2.4.7+ the path may be `system/csp/mode/...`; consult your version. The key point is: enforce, not report-only, on the payment page.)

### Step 4.7 – Deploy and verify

```bash
bin/magento setup:upgrade
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f
bin/magento cache:flush
```

Then in the browser:

1. Open DevTools → Console on the payment page.
2. Confirm there are no `Refused to execute inline script…` or `Refused to evaluate a string as JavaScript…` errors.
3. Click the Toggle button. The terms panel should expand and collapse.
4. Network tab: confirm `terms-toggle.js` and `terms-toggle.bootstrap.js` are served from your own origin.
5. Run a header check (e.g. `curl -I` or [securityheaders.com](https://securityheaders.com/)) and confirm the `Content-Security-Policy` header has no `unsafe-inline` and no `unsafe-eval` for `script-src`.

---

## 5. Summary of the diff

Before:

```html
<div x-data="{ accepted: false }">
  <button @click="accepted = !accepted">Toggle</button>
  <div x-show="accepted">terms…</div>
</div>
```

After:

```html
<div x-data="termsToggle">
  <button type="button" @click="toggle" :aria-expanded="accepted">Toggle</button>
  <div x-show="accepted" x-cloak>terms…</div>
</div>
```

Plus an external module registering the named component and the CSP-safe Alpine build.

---

## 6. Common pitfalls

- **Forgetting `Alpine.data()` registration order.** If your bootstrap script runs after `alpine:init` has already fired, the component will not be registered. Always wrap registration in the `alpine:init` event listener, or load the script with `defer` before Alpine itself.
- **Using getters with side effects.** The CSP-safe build re-reads bindings often; keep getters pure.
- **Leaving inline event handlers elsewhere on the page.** A single `onclick="..."` anywhere on the payment template will still violate the policy.
- **Magic globals.** `$dispatch`, `$refs`, `$el` are available inside methods — use them rather than reaching out to `document.querySelector` from inline expressions.
- **Multiple instances.** Because the component factory is a function, each `x-data="termsToggle"` gets its own state — safe to reuse.
- **Forms with auto-submit and CAPTCHA.** Make sure your CSP whitelist also covers any payment iframe origins (e.g. Adyen, Stripe Elements, Braintree hosted fields). They are unrelated to this toggle but commonly the next thing to fail under strict CSP.

---

## 7. Quick checklist

- [ ] Replaced inline `x-data` object with named component identifier.
- [ ] Replaced `@click` expression with a method reference.
- [ ] `x-show` uses a bare property name.
- [ ] Component registered via `Alpine.data()` in an external module.
- [ ] Theme bundles `@alpinejs/csp` instead of `alpinejs`.
- [ ] No `unsafe-inline` / `unsafe-eval` in the deployed CSP header on the payment page.
- [ ] Static content redeployed and caches flushed.
- [ ] Manual test: button toggles, no CSP violations in console.

That is the full conversion. Once deployed, the payment page should pass both PCI-DSS strict-CSP requirements and an automated CSP scanner with the toggle working identically to before.
