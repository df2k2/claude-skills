# Customer Section Data in Hyvä

## When to read this

You need to access cart/customer/wishlist data on the client, react to changes after a POST, force a refresh, or set a default for an extension that requires section data to always be present.

## How section data flows in Hyvä (vs. Luma)

Luma fetches each section individually with its own URL (`/customer/section/load/?sections=cart,customer`) and stores them as Knockout observables. Components subscribe to specific sections and re-render on change.

Hyvä loads **all sections together** in one Ajax call, stores them in `localStorage` as a single object, and broadcasts via the `private-content-loaded` event. Components subscribe to the event and pick out the keys they care about.

This is simpler:
- One request, not N
- No observable graph
- No per-section invalidation logic
- Easier to debug

The trade-off: every component that needs section data gets all of it. Performance impact is negligible because the data is small.

## Lifecycle

1. **Page loads.** A small footer script checks `localStorage` and the `private_content_version` cookie.
2. **Has cookie + cached data are fresh** (< 1 hour old, version matches): dispatches `private-content-loaded` with cached data.
3. **Cookie version changed or cache stale**: fetches `/customer/section/load`, stores it, dispatches `private-content-loaded` with new data.
4. **No cookie at all** (visitor never POSTed): uses the *default* section data rendered into the page source by the server. No Ajax call.
5. **Component dispatches `reload-customer-section-data`**: the loader re-runs (steps 2–4).

## Receiving section data in Alpine

```html
<div x-data="{ customer: false, cart: false }"
     @private-content-loaded.window="
        customer = $event.detail.data.customer;
        cart    = $event.detail.data.cart;
     ">
    <template x-if="customer && customer.fullname">
        <div>Hi <span x-text="customer.fullname"></span></div>
    </template>
    <template x-if="!customer || !customer.fullname">
        <div>Welcome guest</div>
    </template>
    <template x-if="cart">
        <div>Cart: <span x-text="cart.summary_count || 0"></span></div>
    </template>
</div>
```

For CSP-safe code:
```js
Alpine.data('greeter', () => ({
    customer: false,
    cart: false,
    receiveData(e) {
        this.customer = e.detail.data.customer;
        this.cart = e.detail.data.cart;
    }
}));
```
```html
<div x-data="greeter" @private-content-loaded.window="receiveData">…</div>
```

Note `receiveData` (no parens) — Alpine passes `$event` as the first arg.

## Receiving section data in plain JavaScript

```js
window.addEventListener('private-content-loaded', e => {
    const data = e.detail.data;
    if (data.customer && data.customer.firstname) {
        // …
    }
});
```

## Forcing a reload

After an Ajax POST that changed cart/customer state:
```js
window.dispatchEvent(new Event('reload-customer-section-data'));
```

This triggers the loader, which re-fetches **only if** `private_content_version` changed (which Magento updates automatically on POST) or the cache is > 1 hour old.

To **force** an immediate server fetch regardless:
```js
hyva.setCookie('mage-cache-sessid', '', -1, true);
window.dispatchEvent(new Event('reload-customer-section-data'));
```

⚠️ Don't manually delete `private_content_version` or `cookieVersion`. Those are infrastructure cookies; clearing them breaks the reload mechanism.

## Server-side: forcing the next-page-load to refresh

Magento updates `private_content_version` automatically on POST requests via `Magento\Framework\App\PageCache\Version::process()`. You don't need to do anything for normal controllers.

For **GET-based** state changes (rare, but possible) — e.g., a custom redirect that needs the cart to be re-fetched on the next page — inject the `Version` model and call `process`:

```php
public function __construct(
    private readonly \Magento\Framework\App\PageCache\Version $version
) {}

public function execute()
{
    // ...your logic...
    $this->version->process();
    return $this->resultRedirectFactory->create()->setPath('/');
}
```

## Inspecting section data

Open the browser console:
```js
addEventListener('private-content-loaded', e => console.log(e.detail.data));
dispatchEvent(new Event('reload-customer-section-data'));
```

This logs the entire data object — useful for discovering keys.

Common keys:
- `customer` — `{ firstname, fullname, custom_attributes, ... }`
- `cart` — `{ summary_count, subtotal, items, possible_onepage_checkout, ... }`
- `wishlist` — `{ counter, items, ... }`
- `compare-products` — `{ count, countCaption, items }`
- `directory-data` — currency rates
- `messages` — server-side flash messages (Hyvä shows these as toasts)
- Plus whatever extensions add

## Default section data (since 1.3.6)

For visitors with no session, the section data is **rendered into the page** rather than fetched. Mostly that data is empty/default values.

If an extension requires a specific shape always to be present (otherwise it errors), declare a default in `etc/frontend/di.xml`:

```xml
<type name="Hyva\Theme\ViewModel\CustomerSectionData">
    <arguments>
        <argument name="defaultSectionDataKeys" xsi:type="array">
            <item name="directory-data" xsi:type="boolean">true</item>
            <item name="wishlist" xsi:type="string">{"items": []}</item>
            <item name="acme-counter" xsi:type="string">{"value": 0}</item>
        </argument>
    </arguments>
</type>
```

- `boolean true` — include the section in default data with whatever value the section provider returns server-side
- `string "<json>"` — a literal JSON value to use as the default

Sections not listed in this config get an empty array `[]` in the default data.

## Common patterns

### Mini-cart count
Already wired in Hyvä — your custom add-to-cart only needs to dispatch `reload-customer-section-data` after a successful POST:
```js
const r = await fetch('/checkout/cart/add/', { method: 'POST', body });
if (r.ok) {
    window.dispatchEvent(new Event('reload-customer-section-data'));
}
```

### Custom counter for a third-party module
1. Create a section provider on the server side (extends `Magento\Customer\CustomerData\SectionSourceInterface`).
2. Register it in `etc/frontend/sections.xml`:
   ```xml
   <action name="acme/foo/save">
       <section name="acme-foo"/>
   </action>
   ```
3. Read it from `event.detail.data['acme-foo']` in your Alpine component.
4. (Optional) declare a default in `di.xml` so the data structure is present even before the customer interacts.

### Triggering a reload after a fetch GET
GET requests **do not** update `private_content_version`. If you need the section data to refresh after a GET that changed server state, force it client-side:
```js
hyva.setCookie('mage-cache-sessid', '', -1, true);
window.dispatchEvent(new Event('reload-customer-section-data'));
```

## Don't

- Don't expect Knockout-style observable subscriptions. There aren't any.
- Don't read `customerData.get('cart')` — that's Luma. Listen for `private-content-loaded`.
- Don't poll for changes. Trust the event-driven flow.
- Don't store sensitive data (PII, tokens) in section data — it lives in `localStorage`.
- Don't dispatch `private-content-loaded` yourself — Hyvä's loader owns that. Use `reload-customer-section-data` instead.

## Original sources

- `references/sources/hyva-themes/writing-code/working-with-sectiondata.md` — the canonical section data doc
- `references/sources/hyva-themes/writing-code/hyva-javascript-events.md` — the broader event ecosystem
- `references/sources/hyva-themes/faqs/auto-apply-qty-updates-in-php-cart.md` — pattern for cart updates
- `references/sources/hyva-themes/performance/block-html-full-page-caching.md` — interaction between FPC and section data
