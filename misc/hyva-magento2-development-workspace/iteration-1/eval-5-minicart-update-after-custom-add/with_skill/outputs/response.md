# Updating the Hyvä Mini-Cart Immediately After a Custom Add-to-Cart `fetch`

## Short answer

After your `fetch()` succeeds, dispatch the `reload-customer-section-data` event on `window`:

```js
window.dispatchEvent(new Event('reload-customer-section-data'));
```

Hyvä's section-data loader listens for that event, re-fetches `/customer/section/load`, stores the fresh payload in `localStorage`, and broadcasts `private-content-loaded`. The mini-cart count in the header (which is already wired to `private-content-loaded`) updates immediately — no page navigation required.

## Why your current code doesn't update the count

Hyvä deliberately replaced Luma's Knockout/`customerData` machinery. There is no `customerData.invalidate(['cart'])`, no UI component subscription, no observables. Instead:

1. All customer sections (`cart`, `customer`, `wishlist`, `messages`, …) load **together** in one Ajax call to `/customer/section/load`.
2. The result is cached in `localStorage` and rebroadcast as a single `private-content-loaded` event, with the full data in `event.detail.data`.
3. The mini-cart component reads `cart.summary_count` from that event payload.

The native form post that Magento uses for `/checkout/cart/add/` triggers a full page reload, which makes the loader run on the next request. Your `fetch()` call skips that reload — so unless you tell the loader "go re-check," nothing knows the cart changed.

The trigger event is `reload-customer-section-data`. That's the entire integration point.

## What "immediately" actually requires

The loader has a small optimization: it only re-fetches from the server if either:

- The `private_content_version` cookie has changed (Magento updates this automatically on any **POST** request via `Magento\Framework\App\PageCache\Version::process()`), **or**
- The cached data is older than 1 hour.

Because your custom controller is hit via `POST`, Magento updates `private_content_version` for you. So a plain dispatch is enough:

```js
window.dispatchEvent(new Event('reload-customer-section-data'));
```

If for some reason your controller uses GET (it shouldn't for cart mutations, but just in case), force the next refresh by clearing the cache marker first:

```js
hyva.setCookie('mage-cache-sessid', '', -1, true);
window.dispatchEvent(new Event('reload-customer-section-data'));
```

⚠️ Do **not** manually delete `private_content_version` or `cookieVersion` — those are infrastructure cookies; clearing them breaks the reload mechanism.

## Drop-in fix for your button

Assuming your current click handler looks something like the snippet you described, here's the Hyvä-correct version:

```html
<button
    type="button"
    x-data="bundleAdder()"
    @click="addBundle(['SKU-A', 'SKU-B', 'SKU-C'])"
    class="btn btn-primary"
>
    <?= $escaper->escapeHtml(__('Add Bundle to Cart')) ?>
</button>

<script>
function bundleAdder() {
    return {
        loading: false,
        async addBundle(skus) {
            if (this.loading) return;
            this.loading = true;
            try {
                const body = new URLSearchParams({
                    form_key: hyva.getFormKey(),
                    skus: JSON.stringify(skus)
                });

                const r = await fetch('<?= $escaper->escapeJs($block->getUrl('acme/bundle/add')) ?>', {
                    method: 'POST',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    body
                });

                if (!r.ok) {
                    throw new Error('HTTP ' + r.status);
                }

                // 1) Tell Hyvä's section-data loader the cart changed.
                window.dispatchEvent(new Event('reload-customer-section-data'));

                // 2) (Optional) toast the user.
                if (typeof window.dispatchMessages === 'function') {
                    window.dispatchMessages(
                        [{ type: 'success', text: '<?= $escaper->escapeJs(__('Bundle added to cart')) ?>' }],
                        4000
                    );
                }

                // 3) (Optional) pop the mini-cart open.
                window.dispatchEvent(new Event('toggle-cart'));
            } catch (e) {
                if (typeof window.dispatchMessages === 'function') {
                    window.dispatchMessages(
                        [{ type: 'error', text: '<?= $escaper->escapeJs(__('Could not add bundle')) ?>' }],
                        6000
                    );
                }
            } finally {
                this.loading = false;
            }
        }
    };
}
</script>
```

Three things to note:

- `hyva.getFormKey()` — Magento controllers (including yours) reject POSTs without a valid form key. This helper reads/generates the cookie value.
- `$escaper->escapeJs(...)` — never embed raw PHP into JS in Hyvä. The skill's pattern is `$escaper->escapeJs(...)` for inline scripts and `$escaper->escapeHtmlAttr(...)` for attribute values (or `json_encode(...)` for structured data passed to `x-data`).
- The dispatch is the load-bearing line — everything else (toast, opening the drawer) is optional polish.

If you're working under **strict CSP** (`Hyva/default-csp` parent or Hyvä Checkout), inline `x-data="{ ... }"` and `<script>` blocks won't run. Move the component to a registered Alpine component:

```js
// app/design/frontend/Acme/default/web/js/bundle-adder.js (loaded via theme assets)
hyva.alpineInitialized(() => {
    Alpine.data('bundleAdder', () => ({
        loading: false,
        async addBundle(skus) {
            // …same body…
        }
    }));
});
```

```html
<button x-data="bundleAdder" @click="addBundle(['SKU-A', 'SKU-B'])">…</button>
```

## How to verify it's working

1. Open the browser console.
2. Listen for the broadcast:
   ```js
   addEventListener('private-content-loaded', e => console.log('cart:', e.detail.data.cart));
   ```
3. Click your "Add Bundle to Cart" button.
4. You should see one log entry firing right after your fetch resolves, and `cart.summary_count` should reflect the new total. If it doesn't change on the first click, watch the **Network** tab — you should see a request to `/customer/section/load` after the dispatch. If that request never fires, your dispatch isn't reaching the listener (check that you're firing on `window`, not `document`).

## Server-side checklist (in case the count *still* doesn't change)

If the dispatch fires, the network call to `/customer/section/load` runs, but `cart.summary_count` is wrong, the issue is server-side, not client-side:

- **Confirm the controller is `POST`-only.** If it's GET, `private_content_version` won't be bumped; force a refresh client-side as shown above, or call `\Magento\Framework\App\PageCache\Version::process()` from your controller.
- **Confirm the items actually landed in the quote.** Use `bin/magento dev:log:enable` and log `$cart->getQuote()->getItemsCount()` after `$this->cartRepository->save($cart->getQuote())`.
- **If you're in FPC + Varnish**, `/customer/section/load` must not be cached. Hyvä's defaults are correct, but custom Varnish VCLs sometimes break this — check that the response has `X-Magento-Tags-Pattern` and that your VCL passes the route through.
- **Custom section?** If you added a custom section provider via `etc/frontend/sections.xml`, register the action that should invalidate it:
  ```xml
  <?xml version="1.0"?>
  <config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Customer:etc/sections.xsd">
      <action name="acme/bundle/add">
          <section name="cart"/>
      </action>
  </config>
  ```
  This tells Magento "when somebody POSTs to `acme/bundle/add`, the `cart` section is dirty." Without this, `private_content_version` won't bump for **your custom route** specifically. The standard `/checkout/cart/add/` route already has this wired; custom routes do not.

That last point is the most common gotcha for custom controllers. If you registered a route at `acme/bundle/add` but never told Magento it invalidates the cart section, the version cookie won't change after the POST, the loader will think nothing changed, and the mini-cart will stay stale.

## Common Hyvä events related to the cart

For reference, here are the cart-adjacent events you'll likely use alongside `reload-customer-section-data`:

| Event | Purpose |
| --- | --- |
| `reload-customer-section-data` | Force the section-data loader to re-fetch / re-broadcast. |
| `private-content-loaded` | Fired by the loader; carries the full data object in `event.detail.data`. Listen here. |
| `toggle-cart` | Open the mini-cart slider. Pass `{ detail: { isOpen: false } }` to close (since 1.3.0). |
| `clear-messages` | Clear the toast/splash messages. |

## Things to avoid (Luma muscle memory)

- **Don't** call `customerData.invalidate(['cart'])` — that API doesn't exist in Hyvä.
- **Don't** dispatch on `document` — Hyvä's listeners are on `window`.
- **Don't** use jQuery `$.ajax` or `$(document).trigger(...)` — neither jQuery nor Knockout is loaded.
- **Don't** use `<script type="text/x-magento-init">` blocks for this — Hyvä's `default.xml` strips most of that plumbing.
- **Don't** dispatch `private-content-loaded` yourself — only the loader should fire it. Use `reload-customer-section-data` to ask the loader to do its job.

## TL;DR

Add this single line right after your successful `fetch()`:

```js
window.dispatchEvent(new Event('reload-customer-section-data'));
```

If your custom route still doesn't refresh the cart count, register it in `etc/frontend/sections.xml` so Magento knows to bump `private_content_version` after POSTs to it.
