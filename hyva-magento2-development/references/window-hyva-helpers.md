# `window.hyva` Helper Functions

## When to read this

You need to read/write a cookie, format a price, post a form via JS, get the form key, or call any of the helpers Hyvä exposes globally. These are defined in `vendor/hyva-themes/magento2-theme-module/src/view/frontend/templates/page/js/hyva.phtml`.

## Cookie helpers

### `hyva.getCookie(name)`
```js
const consent = hyva.getCookie('cookie_consent');
```

### `hyva.setCookie(name, value, days, skipSetDomain)`
```js
hyva.setCookie('preferred_currency', 'EUR', 30);
```
- `days` is optional (omit for session cookie behavior)
- `skipSetDomain` is optional. Set to `true` for cookies that Magento sets without a domain (like `mage-messages`) to avoid duplicates.

By default cookies are blocked unless the visitor has consented. To always allow a cookie regardless of consent:

```js
window.addEventListener('load', () => {
    window.cookie_consent_config = window.cookie_consent_config || {};
    window.cookie_consent_config.necessary = window.cookie_consent_config.necessary || [];
    window.cookie_consent_config.necessary.push('my-cookie');
});
```

### `hyva.setSessionCookie(name, value, skipSetDomain)` (since 1.2.9 / 1.3.5)
Same as `setCookie` but with no expiry — cleared when the browser closes.

## Storage helpers

### `hyva.getBrowserStorage()`
Returns `localStorage` if available, otherwise `sessionStorage`, otherwise `false` (Safari private mode). Always check the return:
```js
const storage = hyva.getBrowserStorage();
if (storage) {
    storage.setItem('preferences', JSON.stringify(prefs));
}
```

## Form helpers

### `hyva.getFormKey()`
Returns the current form key from the cookie (or generates one). Always include this in POSTs to Magento controllers:
```js
fetch('/contact/index/post/', {
    method: 'POST',
    body: new URLSearchParams({
        form_key: hyva.getFormKey(),
        name, email, comment
    })
});
```

### `hyva.postForm(postParams)`
Builds a `<form>`, fills hidden inputs from `data`, and submits it (full-page POST). Auto-includes `form_key` and `uenc`.

```js
hyva.postForm({
    action: 'https://example.com/custom_quote/move/inQuote/',
    data: {
        id: '123',
        note: 'Hello'
    },
    skipUenc: false   // optional, since 1.2.4
});
```

In Alpine:
```html
<button @click.prevent="hyva.postForm({
    action: '/custom/save/url',
    data: { id: '<?= (int)$id ?>' }
})">Submit</button>
```

### `hyva.getUenc()` (since 1.1.17)
Returns the current page URL base64-encoded the way Magento expects. Used to redirect back after a controller action:
```js
const body = `form_key=${hyva.getFormKey()}&uenc=${hyva.getUenc()}`;
```

## String helpers

### `hyva.str(template, ...args)` (since 1.1.17)
Replaces `%1`, `%2`, … with positional arguments. Mirrors PHP `__()`:
```js
hyva.str('Welcome %1!', customer.firstName);     // "Welcome Jane!"
hyva.str('%2 %1 %3', 'a', 'b', 'c');             // "b a c"
hyva.str('100%%', );                             // "100%"  (escape %)
```
Use `%%2` to render a literal `%2`.

### `hyva.strf(template, ...args)` (since 1.1.14)
Same idea but starts at `%0`:
```js
hyva.strf('%0 %1', 'Hi', 'Jane');  // "Hi Jane"
```

Prefer `hyva.str` for symmetry with PHP `__('Welcome %1', $name)`.

## Price formatting

### `hyva.formatPrice(value, showSign, options = {})`
Formats according to current store currency.

```js
hyva.formatPrice(19.99);              // "$19.99"  (or whatever currency)
hyva.formatPrice(-5);                 // "−$5.00"
hyva.formatPrice(5, true);            // "+$5.00"  showSign=true
```

Since 1.3.6 `options` is passed to `Intl.NumberFormat`:
```js
hyva.formatPrice(19.99, false, { maximumFractionDigits: 0 });  // "$20"
```

Custom separators (since 1.3.10):
```js
hyva.formatPrice(1234.56, false, {
    groupSeparator: ' ',
    decimalSeparator: ','
});
```

## DOM helpers

### `hyva.replaceDomElement(targetSelector, content)` (since 1.1.14)
Takes an HTML response, finds the element matching `targetSelector` inside it, and replaces the same selector on the page. Useful for partial-page Ajax responses where Magento renders a full-page HTML you only want a piece of.

```js
fetch(currentUrl)
    .then(r => r.text())
    .then(html => hyva.replaceDomElement('#maincontent', html));
```

Scripts inside the replacement are extracted and re-injected into `<head>` so they execute.

### `hyva.activateScripts(node)` (since 1.3.6)
Lower-level helper — given an Element, takes its `<script>` children and re-injects them into `<head>` so the browser parses them. Useful when you've built up an HTML fragment from a Fetch response:

```js
const tempContainer = document.createElement('div');
tempContainer.innerHTML = htmlFragment;
hyva.activateScripts(tempContainer);
document.querySelector('#target').replaceWith(tempContainer);
```

## Focus management (since 1.2.6)

### `hyva.trapFocus(rootElement)`
Constrains keyboard tab navigation to focusable elements inside `rootElement`. Auto-focuses the first one.

```js
const modal = document.querySelector('#myModal');
modal.classList.remove('hidden');
hyva.trapFocus(modal);
```

### `hyva.releaseFocus(rootElement)`
Releases the trap when closing the modal.
```js
modal.classList.add('hidden');
hyva.releaseFocus(modal);
```

For Alpine modal patterns, prefer the `@alpinejs/focus` plugin:
```html
<div x-data="{ open: false }">
    <button @click="open = true">Open</button>
    <div x-show="open" x-trap.noscroll="open" x-init>…</div>
</div>
```

Both work; `x-trap` is simpler for Alpine code.

## Lifecycle: `hyva.alpineInitialized(callback)` (since 1.2.8 / 1.3.4)

Runs the callback once Alpine has fully initialized — works the same in Alpine v2 and v3. Prefer this over `DOMContentLoaded` for component-level setup:

```js
hyva.alpineInitialized(() => {
    Alpine.data('myComponent', () => ({
        // …
    }));
});
```

In Alpine v3 this is equivalent to `window.addEventListener('alpine:initialized', cb, { once: true })`.

## CSP-friendly helpers

### `hyva.createBooleanObject(name, value, additionalMethods)` (since 1.3.11)
Returns an object with `<name>`, `not<Name>`, `<name>True`, `<name>False`, `toggle` properties — used to flip booleans without `!` (forbidden under CSP).

```js
const menu = hyva.createBooleanObject('open', false, {
    async load() { /* … */ }
});
// menu.open → false
// menu.notOpen → true
// menu.toggle() → flips
```

See `alpine-csp.md` for the full pattern.

### `hyva.safeParseNumber(rawValue)` (since 1.3.11)
Replacement for `x-model.number` under CSP. Returns a `Number` (or `0` for invalid).
```js
setQty(e) { this.qty = hyva.safeParseNumber(e.target.value); }
```

## Patterns

### Posting JSON to a Magento controller
```js
const r = await fetch('/api/custom_endpoint/', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
        form_key: hyva.getFormKey(),
        ...payload
    })
});
```

### Posting form-encoded
```js
const body = new URLSearchParams({
    form_key: hyva.getFormKey(),
    name: 'Jane',
    email: 'j@example.com'
});
const r = await fetch('/contact/index/post/', { method: 'POST', body });
if (r.ok) {
    window.dispatchEvent(new Event('reload-customer-section-data'));
    window.dispatchMessages([{ type: 'success', text: 'Sent' }], 4000);
}
```

### A "back to top" button using stored preference
```html
<button x-data="{
    visible: $persist(false).as('back-to-top-visible'),
    init() {
        window.addEventListener('scroll', () => {
            this.visible = window.scrollY > 800;
        }, { passive: true });
    }
}"
    x-show="visible"
    x-cloak
    @click="window.scrollTo({ top: 0, behavior: 'smooth' })"
    class="fixed bottom-4 right-4 btn btn-primary"
>↑</button>
```

(`$persist` comes from the Alpine Persist plugin bundled in Hyvä; not strictly a `hyva.*` helper but commonly used together.)

## Original sources

- `references/sources/hyva-themes/writing-code/the-window-hyva-object.md` — the canonical reference for every `hyva.*` helper
- `references/sources/hyva-themes/writing-code/using-fetch.md` — fetch patterns paired with `hyva.getFormKey`, `hyva.getUenc`
- `references/sources/hyva-themes/writing-code/building-urls-in-js.md` — URL building from JS
- `references/sources/hyva-themes/writing-code/window-dispatchmessages.md` — `window.dispatchMessages` (a related global function)
- The actual JS source is in `vendor/hyva-themes/magento2-theme-module/src/view/frontend/templates/page/js/hyva.phtml` — read the implementation when version-specific behavior is unclear
