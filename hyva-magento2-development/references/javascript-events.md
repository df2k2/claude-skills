# Hyvä JavaScript Events

## When to read this

You need to react to changes in customer/cart state, open the mini-cart, refresh section data, react to product option changes, or wire components together via events.

## Why events, not observables?

Hyvä deliberately doesn't use Knockout observables. Components communicate via DOM `CustomEvent`s dispatched on `window`. This keeps state simple — no observable graph, no subscription leaks — at the cost of explicit `addEventListener` plumbing.

## Subscribing

Native:
```js
window.addEventListener('private-content-loaded', e => myFunc(e.detail.data));
```

Alpine:
```html
<div @private-content-loaded.window="customer = $event.detail.data.customer">…</div>
```

## Dispatching

Native:
```js
window.dispatchEvent(new Event('reload-customer-section-data'));
window.dispatchEvent(new CustomEvent('toggle-cart', { detail: { isOpen: false } }));
```

Alpine inside a component:
```html
<button @click="$dispatch('toggle-cart')">View cart</button>
```
But `$dispatch` originates at the current element. To reach window-level listeners, either dispatch directly on window or use `.window` on listeners.

## The events you'll use most

### `private-content-loaded`
Customer section data has been loaded (from cache or server). The full data object is in `event.detail.data`.

```html
<div x-data="{ customer: false, cart: false }"
     @private-content-loaded.window="
        customer = $event.detail.data.customer;
        cart = $event.detail.data.cart;
     ">
    <template x-if="customer">
        <span>Hi <span x-text="customer.firstname"></span></span>
    </template>
    <template x-if="cart">
        <span>Cart: <span x-text="cart.summary_count"></span></span>
    </template>
</div>
```

In Hyvä the section data is **always loaded together** as one object. There's no per-section subscription like Luma's `customerData.get('cart')`.

### `reload-customer-section-data`
Force the customer data to refresh. Useful after an Ajax POST that changed cart/customer state without a page navigation.

```js
fetch('/customer/account/save/', { method: 'POST', body: data })
    .then(r => {
        if (r.ok) {
            window.dispatchEvent(new Event('reload-customer-section-data'));
        }
    });
```

The data only re-fetches from the server if the `private_content_version` cookie has changed or it's been an hour. To **force** an immediate server refresh:
```js
hyva.setCookie('mage-cache-sessid', '', -1, true);  // clear the storage marker
window.dispatchEvent(new Event('reload-customer-section-data'));
```

⚠️ Don't manually delete `private_content_version` or `cookieVersion` — those are infrastructure cookies; removing them breaks reload.

### `toggle-mobile-menu`
Open/close the mobile navigation overlay. No-op on larger viewports.
```js
window.dispatchEvent(new Event('toggle-mobile-menu'));
```

### `toggle-authentication`
Open the auth slider, or redirect to checkout if already logged in / guest checkout enabled.
```js
window.dispatchEvent(new Event('toggle-authentication'));

// optional alternate redirect after login:
window.dispatchEvent(new CustomEvent('toggle-authentication', { detail: { url: '/' } }));
```

### `toggle-cart`
Open the mini-cart. Since 1.3.0, also closes it with `{ isOpen: false }`:
```js
window.dispatchEvent(new Event('toggle-cart'));                                    // open
window.dispatchEvent(new CustomEvent('toggle-cart', { detail: { isOpen: false } })); // close
```

### `clear-messages` (since 1.1.2)
Clears all splash messages.
```js
window.dispatchEvent(new Event('clear-messages'));
```

### `configurable-selection-changed` (since 1.1.4) — PDP
Fired when a configurable product option is selected on a PDP. Payload:
```js
{
  productId: '12',
  optionId: '93',
  value: '15',
  productIndex: '5',           // simple product ID for image
  selectedValues: { '93': '15' },
  candidates: ['5', '6']        // simples matching current selection
}
```
If `candidates.length === 1`, all required options are selected.

### `listing-configurable-selection-changed` (since 1.2.4) — listings
Same payload, fired on category/search listings.

### `update-product-final-price` — PDP
Fired when option selection changes the price.
```html
<input @update-product-final-price.window="recalculateWithFinalPrice($event.detail)">
```

### `update-prices-<productId>` — PDP & listings
Fired with `{ tierPrices, basePrice, baseOldPrice, finalPrice, oldPrice }` when the price should be updated for a specific product.

```js
window.dispatchEvent(new CustomEvent('update-prices-68', {
    detail: {
        tierPrices: [],
        basePrice: { amount: 5 },
        baseOldPrice: { amount: 15 }
    }
}));
```

⚠️ `tierPrices` must be present — pass `[]` if none.

### `update-qty-<productId>` — PDP
Fired when the quantity input changes.
```js
window.addEventListener('update-qty-' + productId, e => this.qty = e.detail);
```

### `update-gallery` — PDP
Replace the gallery images. Pass an array of image objects:
```js
window.dispatchEvent(new CustomEvent('update-gallery', {
    detail: [{
        thumb: 'https://…/thumb.jpg',
        img:   'https://…/medium.jpg',
        full:  'https://…/large.jpg',
        caption: 'Front view',
        position: 1,
        isMain: false,
        type: 'image',         // or 'video'
        videoUrl: null         // or 'https://youtu.be/...'
    }]
}));
```

Empty array reverts to default gallery:
```js
window.dispatchEvent(new CustomEvent('update-gallery', { detail: [] }));
```

## Toast/notification dispatching: `dispatchMessages`

Not technically an event — it's a function on `window` provided by the message component:

```js
window.dispatchMessages([
    { type: 'success', text: 'Item added to cart' },
    { type: 'warning', text: 'Stock running low' }
], 5000);
```

Types: `success`, `notice`, `warning`, `error`. Final argument: auto-dismiss timeout in ms (omit or `0` for sticky).

Defensive call (might be missing in deeply customized themes):
```js
typeof window.dispatchMessages === 'function' && window.dispatchMessages([...]);
```

## Common patterns

### Update mini-cart count after a custom add-to-cart

```js
async function addToCart(sku, qty) {
    const r = await fetch('/checkout/cart/add/', {
        method: 'POST',
        body: new URLSearchParams({
            form_key: hyva.getFormKey(),
            qty,
            product: sku
        })
    });
    if (r.ok) {
        window.dispatchEvent(new Event('reload-customer-section-data'));
        window.dispatchMessages([{ type: 'success', text: 'Added!' }], 4000);
    }
}
```

### Open cart from a custom button anywhere on the page
```html
<button @click="$dispatch('toggle-cart')">View cart</button>
```

If outside any Alpine component:
```html
<button onclick="window.dispatchEvent(new Event('toggle-cart'))">View cart</button>
```
(In CSP-strict mode, prefer the Alpine variant — inline `onclick` may be blocked.)

### React to a configurable selection
```html
<div x-data="{ selectedSku: null }"
     @configurable-selection-changed.window="
        if ($event.detail.candidates.length === 1) {
            selectedSku = $event.detail.productIndex;
        }
     ">
    <span x-show="selectedSku" x-text="selectedSku"></span>
</div>
```

## Custom events

Inventing your own events is encouraged for cross-component coordination. Conventions:

- Use kebab-case names: `acme-coupon-applied`
- Include detail: `new CustomEvent('acme-coupon-applied', { detail: { code, discount } })`
- Document the event in your module's README

```js
// dispatcher
window.dispatchEvent(new CustomEvent('acme-coupon-applied', {
    detail: { code: 'SAVE10', discount: 10 }
}));

// listener
window.addEventListener('acme-coupon-applied', e => {
    console.log('Coupon:', e.detail.code);
});
```

## Don't

- Don't use jQuery's `$(document).trigger(...)` — it's not loaded.
- Don't depend on `customerData.get('cart')` — that API is Luma-only.
- Don't dispatch on the `document` instead of `window` — Hyvä's listeners are on `window`.
- Don't expect events to return values — use a follow-up event or a `Promise`-aware pattern.

## Original sources

- `references/sources/hyva-themes/writing-code/hyva-javascript-events.md` — the canonical event reference
- `references/sources/hyva-themes/writing-code/working-with-sectiondata.md` — `private-content-loaded` and section data lifecycle
- `references/sources/hyva-themes/writing-code/window-dispatchmessages.md` — `window.dispatchMessages` reference
- `references/sources/hyva-themes/writing-code/pdp-pricing-logic.md` — `update-prices-<id>` event in detail
- `references/sources/hyva-themes/writing-code/using-fetch.md` — fetch + dispatching follow-up events
