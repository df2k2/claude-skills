# Converting an Alpine Toggle to CSP-Safe for a PCI-DSS Payment Page

Your current code uses three things that strict CSP forbids:

1. **An object literal in `x-data`** (`{ accepted: false }`) — Alpine's standard build evaluates this string at runtime via `Function()`, which strict CSP blocks.
2. **An assignment expression in `@click`** (`accepted = !accepted`) — same `Function()` evaluation.
3. **The boolean negation operator (`!`)** — even when an expression is otherwise simple, the CSP build of Alpine only allows property access and method calls, not operators.

Under `Hyva/default-csp` (and on any payment page since the PCI-DSS 4.0 deadline of 1 April 2025) you must:

- Register the component up front via `Alpine.data('name', () => ({...}))` on `alpine:init`.
- Reference it by **name** in `x-data="name"`, not by literal.
- Use `@click="methodName"` (no parens, or with literal-only args like `@click="setStatus('on')"`) — never an inline assignment.
- Use Hyvä's `hyva.createBooleanObject()` helper to flip booleans, since `!` is forbidden.

Below is the conversion, the layout wiring, the CSP nonce registration that the inline `<script>` needs, and the build/cache steps.

---

## 1. The CSP-safe template

Place this in your child theme. The path mirrors the upstream module the panel belongs to — for a payment-page terms toggle it's most likely `Magento_Checkout` (Hyvä Checkout) or whichever payment module you're patching. I'll show it under a generic checkout path; adjust the `Magento_Checkout` segment to match where you're rendering the panel.

`app/design/frontend/Acme/payment-csp/Magento_Checkout/templates/payment/terms-toggle.phtml`:

```php
<?php
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
$hyvaCsp = $viewModels->require(\Hyva\Theme\ViewModel\HyvaCsp::class);

$inlineScript = <<<JS
document.addEventListener('alpine:init', () => {
    Alpine.data('termsToggle', () => ({
        terms: hyva.createBooleanObject('accepted', false),
    }));
});
JS;

// Register the script body with the CSP nonce/hash provider so Magento
// emits an allowed inline-script directive for the response headers.
$hyvaCsp->registerInlineScript($inlineScript);
?>
<div x-data="termsToggle" class="terms-panel">
    <button
        type="button"
        @click="terms.toggle"
        :aria-expanded="terms.accepted"
        aria-controls="terms-body"
        class="btn btn-secondary"
    >
        <?= $escaper->escapeHtml(__('Toggle')) ?>
    </button>

    <div
        id="terms-body"
        x-show="terms.accepted"
        x-cloak
        class="mt-2 p-4 border border-gray-300 rounded"
    >
        <?= $escaper->escapeHtml(__('Terms and conditions content goes here.')) ?>
    </div>
</div>

<script><?= /* @noEscape */ $inlineScript ?></script>
```

### What changed, line by line

| Standard | CSP-safe | Why |
| --- | --- | --- |
| `x-data="{ accepted: false }"` | `x-data="termsToggle"` | Inline object literal needs `Function()`. The name resolves to the registered component. |
| `@click="accepted = !accepted"` | `@click="terms.toggle"` | Inline assignment + `!` are both forbidden. `terms.toggle` is just a method reference. |
| `x-show="accepted"` | `x-show="terms.accepted"` | Property access is allowed; we just access the boolean field on the helper object. |
| n/a | `x-cloak` | Optional but recommended — hides the panel until Alpine has hydrated, so it doesn't flash open before the registered component initializes. |

`hyva.createBooleanObject('accepted', false)` returns an object shaped like:

```js
{
    accepted: false,        // the value
    notAccepted: true,      // negated accessor (no `!` needed in templates)
    toggle()  { /* flips it */ },
    acceptedTrue()  { /* sets to true */ },
    acceptedFalse() { /* sets to false */ },
}
```

So if elsewhere you need "show this when **not** accepted":

```html
<p x-show="terms.notAccepted">Please accept the terms.</p>
```

…instead of the forbidden `x-show="!terms.accepted"`.

And if you need an explicit "decline" button that always sets it to false (rather than toggling):

```html
<button type="button" @click="terms.acceptedFalse">Decline</button>
<button type="button" @click="terms.acceptedTrue">Accept</button>
```

### About `x-cloak`

Make sure your child theme's CSS includes a `[x-cloak] { display: none !important; }` rule. Hyvä's default theme already ships this in `tailwind-source.css`; if you stripped it during a customization, add it back so the panel stays hidden until `Alpine.data('termsToggle', …)` runs.

---

## 2. Layout XML to render the block

Add the block to whatever container holds your terms section. For a payment page this is typically inside the payment method's container or `checkout.cart.totals`. Example for an arbitrary container:

`app/design/frontend/Acme/payment-csp/Magento_Checkout/layout/checkout_index_index.xml`:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="checkout.payment.terms">
            <block name="checkout.payment.terms.toggle"
                   template="Magento_Checkout::payment/terms-toggle.phtml"/>
        </referenceContainer>
    </body>
</page>
```

If the panel actually lives on a Hyvä Checkout step (Magewire), the layout handle is `hyva_checkout_components` and the container name will differ — let me know the exact location and I'll adjust. The Alpine pattern itself is identical regardless of where the block is rendered.

---

## 3. Why the inline `<script>` is wrapped via `$hyvaCsp`

Under strict CSP the response sends a `Content-Security-Policy` header like:

```
script-src 'self' 'nonce-abc123' 'sha256-…';
```

Any inline `<script>` block that isn't matched by the nonce or by a registered hash gets blocked by the browser. `$hyvaCsp->registerInlineScript($body)` (from `\Hyva\Theme\ViewModel\HyvaCsp`) computes the SHA-256 of `$body` and adds it to the response's CSP `script-src` source list, so the same body emitted in the `<script>` tag below matches and is allowed to run.

The pattern is:

```php
<?php
$inlineScript = <<<JS
/* … */
JS;
$hyvaCsp->registerInlineScript($inlineScript);
?>
<script><?= /* @noEscape */ $inlineScript ?></script>
```

Two important points:

1. **Capture the script body in a variable first**, then pass the *same* variable to both `registerInlineScript()` and the `<script>` tag. If the strings differ by even a byte (a stray newline, a different quote), the hashes won't match and the browser blocks the script.
2. **Don't escape the body when emitting it** — `<?= /* @noEscape */ $inlineScript ?>`. Escaping would change the bytes the browser sees and break the hash.

Alternative form when you want to defer string-building:

```php
$hyvaCsp->registerInlineScriptCallback(function() use ($escaper, $someValue) {
    return "Alpine.data('termsToggle', () => ({ /* … */ }));";
});
```

The callback runs once and Hyvä handles both the hash registration and the output. Useful when the script body depends on PHP values that need escaping into JS — use `$escaper->escapeJs($someValue)` for any string interpolated into the script.

---

## 4. If you'd rather not embed the script at all

For a payment page where you want zero inline scripts, move the registration to the theme module's frontend JS file:

`app/design/frontend/Acme/payment-csp/Magento_Theme/web/js/csp-components.js`:

```js
document.addEventListener('alpine:init', () => {
    Alpine.data('termsToggle', () => ({
        terms: hyva.createBooleanObject('accepted', false),
    }));
});
```

Then reference it from layout (preferred for production):

`app/design/frontend/Acme/payment-csp/Magento_Theme/layout/default.xml`:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <head>
        <script src="js/csp-components.js"/>
    </head>
</page>
```

External scripts are covered by the `script-src 'self'` directive without needing a nonce or hash, and you avoid the need to hash-register every snippet. This is the cleanest approach if you're maintaining many CSP-safe components.

If you go this route, drop the `$hyvaCsp->registerInlineScript(...)` call and the `<script>` block from the phtml entirely — the template just needs the `<div x-data="termsToggle">…</div>` markup.

---

## 5. Build & cache steps

After adding the files:

```bash
# Pick up the new template/layout
bin/magento cache:flush

# If you added the JS file route in section 4:
bin/magento setup:static-content:deploy -f en_US

# Tailwind: rebuild so any new utility classes (e.g. `border-gray-300`,
# `mt-2`, `rounded`) you used end up in the compiled CSS
cd app/design/frontend/Acme/payment-csp/web/tailwind
npm run build
```

For local dev, `npm run watch` from the `web/tailwind/` directory keeps the CSS rebuilding as you edit templates.

---

## 6. Verification checklist on the page

Open the payment page in Chrome with DevTools open:

1. **Console clean?** No `Refused to execute inline script because it violates the following Content Security Policy directive: …` errors. If you see one, it almost always means the `<script>` body sent to the browser doesn't byte-match what `registerInlineScript()` hashed.
2. **`Alpine` is registered?** In the console: `Alpine.version` should print, and `Alpine.$data(document.querySelector('[x-data="termsToggle"]'))` should return your component object with `terms: { accepted: false, … }`.
3. **Toggle works?** Click the button, watch `terms.accepted` flip in the Alpine devtools (or just see the panel appear).
4. **No `unsafe-eval` or `unsafe-inline` in the response CSP header.** Inspect the `Content-Security-Policy` response header on the page request — it should contain `'self'` plus `'nonce-…'` and/or `'sha256-…'` entries, but no `'unsafe-inline'` or `'unsafe-eval'`. If those are present, the theme isn't actually in strict-CSP mode and you'll want to verify your child theme's parent is `Hyva/default-csp`, not `Hyva/default`.

---

## 7. One thing worth confirming

Is your child theme inheriting from `Hyva/default-csp` (the CSP build of the default theme) or just from `Hyva/default`? The CSP build pulls in Alpine's CSP-only distribution, which is what makes `x-data="{…}"` actually fail noisily during dev rather than silently working. Check `app/design/frontend/Acme/payment-csp/theme.xml`:

```xml
<theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
    <title>Acme Payment CSP</title>
    <parent>Hyva/default-csp</parent>
</theme>
```

If it currently says `Hyva/default`, switch to `Hyva/default-csp` for any theme that renders payment pages, then run `bin/magento setup:upgrade && bin/magento cache:flush`. Without this, you'd be loading the eval-capable Alpine build, and the toggle "works" in dev but fails the moment the production CSP header is enforced.
