# Refreshing the Hyvä Mini-Cart After a Custom "Add Bundle to Cart" POST

## Why the mini-cart doesn't refresh

In Hyvä the mini-cart is a small Alpine.js component backed by a private-content "section" called `cart`. Magento ships with a JS module called `Magento_Customer/js/section-config` (and on Hyvä, a thin wrapper) that keeps a copy of every "section" in `localStorage` and exposes them as Alpine `$store.customer` / `hyva.getCart()`.

Sections are normally invalidated through Magento's `customer/section/load` AJAX endpoint, but only when one of the following happens:

1. The browser fires `submit` on a form whose action is in `etc/frontend/sections.xml` (Magento's default form-tracking) **OR**
2. Some JS explicitly calls `hyva.reloadCustomerSectionData()` / `hyva.replaceDomElement()` etc.

Because you're calling a custom controller with `fetch`, Magento's form interceptor never sees the request, so the local section cache is still the old version. The header simply renders what's in `localStorage`. After a full page navigation the cookie `section_data_ids` is out of sync with the server's `private_content_version` cookie, so Magento reloads the sections — that's why it works after a navigation.

The fix is to tell Hyvä to refresh the section data right after your `fetch` resolves successfully.

---

## Solution overview

You have three good options. Pick **one**:

| Option | When to use |
|---|---|
| **A.** Call `window.dispatchEvent(new Event('reload-customer-section-data'))` after the `fetch` resolves | Cleanest — works with the stock `Magento_Customer/js/customer-data` model rebuilt by Hyvä. |
| **B.** Have the controller invalidate the cart section on the server, then call `hyva.reloadCustomerSectionData()` from JS | Recommended for production code. Server is the source of truth. |
| **C.** Manually mutate the Alpine `$store.customer` `cart` section | Only if you can't make a second AJAX hop, e.g. for purely-JS demos. |

Below is a complete working setup using A + B, which is what most Hyvä modules ship.

---

## 1. The custom controller — invalidate the section server-side

Your controller must do two things after it adds the items:

1. Save the quote
2. Mark the `cart` section as dirty so the next `customer/section/load` returns fresh data

```php
<?php
declare(strict_types=1);

namespace Vendor\BundleAdd\Controller\Cart;

use Magento\Checkout\Model\Cart as CheckoutCart;
use Magento\Catalog\Api\ProductRepositoryInterface;
use Magento\Customer\CustomerData\SectionPoolInterface;
use Magento\Framework\App\Action\HttpPostActionInterface;
use Magento\Framework\App\RequestInterface;
use Magento\Framework\Controller\Result\JsonFactory;
use Magento\Framework\DataObject;
use Magento\Framework\Exception\NoSuchEntityException;
use Psr\Log\LoggerInterface;

class AddBundle implements HttpPostActionInterface
{
    public function __construct(
        private readonly RequestInterface $request,
        private readonly JsonFactory $jsonFactory,
        private readonly CheckoutCart $cart,
        private readonly ProductRepositoryInterface $productRepository,
        private readonly SectionPoolInterface $sectionPool,
        private readonly LoggerInterface $logger
    ) {
    }

    public function execute()
    {
        $result = $this->jsonFactory->create();

        try {
            $payload = json_decode((string) $this->request->getContent(), true) ?? [];
            $skus    = $payload['skus'] ?? [];

            if (!is_array($skus) || $skus === []) {
                return $result->setHttpResponseCode(400)
                    ->setData(['success' => false, 'message' => 'No SKUs provided']);
            }

            foreach ($skus as $sku) {
                try {
                    $product = $this->productRepository->get((string) $sku);
                } catch (NoSuchEntityException) {
                    continue;
                }
                $this->cart->addProduct(
                    $product,
                    new DataObject(['qty' => $payload['qty'][$sku] ?? 1])
                );
            }

            $this->cart->save();

            // Tell Magento private-content layer that the cart section changed.
            // The keys passed here MUST be section names; the SectionPool then
            // bumps `section_data_ids` so the next /customer/section/load returns
            // fresh data for these sections.
            $sections = $this->sectionPool->getSectionsData(['cart'], true);

            return $result->setData([
                'success'  => true,
                'sections' => $sections,        // <-- send to JS so we can update store immediately
                'qty'      => $this->cart->getQuote()->getItemsQty(),
            ]);
        } catch (\Throwable $e) {
            $this->logger->error('Add bundle to cart failed', ['exception' => $e]);
            return $result->setHttpResponseCode(500)
                ->setData(['success' => false, 'message' => $e->getMessage()]);
        }
    }
}
```

> Note: `SectionPoolInterface::getSectionsData(['cart'], true)` does double duty: it returns the latest section payload AND it triggers `Magento\Customer\CustomerData\Section::getSectionDataIds()` to update the `section_data_ids` cookie via the `Magento\Framework\App\Response\Http\Interceptor`. After this call the `private_content_version` cookie also changes.

The matching `routes.xml` (under `etc/frontend/`):

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:App/etc/routes.xsd">
    <router id="standard">
        <route id="bundleadd" frontName="bundleadd">
            <module name="Vendor_BundleAdd"/>
        </route>
    </router>
</config>
```

If you're using a `POST` to a custom URL you must also add `etc/csrf_whitelist.xml` or extend `CsrfAwareActionInterface`. The simplest approach is to send the form key with your fetch (see the JS below) so Magento's CSRF check passes.

---

## 2. The JS — fire the fetch, then refresh the mini-cart

This is the only piece you really need to fix. Replace your current button handler with the snippet below. The two important calls are:

* `window.dispatchEvent(new CustomEvent('reload-customer-section-data'))`
* `window.dispatchEvent(new CustomEvent('private-content-loaded', { detail: { data: sections } }))`

### Option A — minimal: trigger a section reload

```html
<button
    type="button"
    x-data="bundleAdder({ skus: ['SKU-1','SKU-2','SKU-3'] })"
    @click="addBundle()"
    :disabled="loading"
    class="btn btn-primary">
    <span x-show="!loading">Add Bundle to Cart</span>
    <span x-show="loading">Adding…</span>
</button>

<script>
    function bundleAdder(config) {
        return {
            loading: false,
            skus: config.skus,

            async addBundle() {
                this.loading = true;

                try {
                    const formKey = hyva.getFormKey();   // Hyvä helper – reads cookie/localStorage
                    const response = await fetch('/bundleadd/cart/add', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-Requested-With': 'XMLHttpRequest',
                            'Accept': 'application/json',
                        },
                        credentials: 'include',
                        body: JSON.stringify({
                            form_key: formKey,
                            skus: this.skus,
                        }),
                    });

                    const json = await response.json();

                    if (!response.ok || !json.success) {
                        window.dispatchMessages?.(
                            [{ type: 'error', text: json.message || hyva.strings.get('generic.error') }],
                            5000
                        );
                        return;
                    }

                    // 1) If the controller already returned the section payload,
                    //    push it straight into customer-data so we skip the second AJAX.
                    if (json.sections) {
                        window.dispatchEvent(new CustomEvent('private-content-loaded', {
                            detail: { data: json.sections }
                        }));
                    } else {
                        // 2) Otherwise, ask Hyvä to reload all sections from the server.
                        window.dispatchEvent(new CustomEvent('reload-customer-section-data'));
                    }

                    window.dispatchMessages?.(
                        [{ type: 'success', text: 'Bundle added to your cart' }],
                        5000
                    );
                } catch (e) {
                    console.error(e);
                    window.dispatchMessages?.(
                        [{ type: 'error', text: hyva.strings.get('generic.error') }],
                        5000
                    );
                } finally {
                    this.loading = false;
                }
            }
        };
    }
</script>
```

### Why these events work

Hyvä registers two listeners in `Magento_Customer/templates/js/customer-data.phtml` (rendered by the `Magento_Customer::js/customer-data.phtml` template that Hyvä bundles):

* `reload-customer-section-data` — calls `hyva.reloadCustomerSectionData()`, which fetches `/customer/section/load/?sections=*` and writes the result back into `localStorage` keyed `mage-cache-storage`. Every Alpine component listening on `private-content-loaded` (the mini-cart, the wishlist counter, the compare counter, etc.) re-renders.
* `private-content-loaded` — synchronously updates `mage-cache-storage` with whatever `detail.data` you pass and broadcasts to listeners. This is what the `customer/section/load` response handler dispatches internally, so dispatching it yourself with the payload from your controller skips the extra round-trip.

Both events are dispatched on `window`, exactly as in stock Hyvä code.

---

## 3. Verify the mini-cart binds to the right store

Open `vendor/hyva-themes/magento2-default-theme/Magento_Theme/templates/html/header/minicart.phtml` (or your override) and you'll see something like:

```html
<div x-data="initMiniCart()"
     @private-content-loaded.window="receivePrivateContent($event)"
     ...
>
    <span class="counter-number" x-text="cart.summary_count ?? 0"></span>
</div>
```

`receivePrivateContent` reads `event.detail.data.cart` and copies it onto `this.cart`. So the moment your fetch handler dispatches `private-content-loaded` (or `reload-customer-section-data` finishes), the counter updates without a navigation.

---

## 4. CSRF, cookies, and other gotchas

* **Form key.** `hyva.getFormKey()` returns the value of the `form_key` cookie. You must include it in either the body, a header (`X-Magento-Form-Key`), or as a URL parameter, otherwise the controller will be rejected with a 403 unless you implement `CsrfAwareActionInterface` and return `true` from `validateForCsrf()`.
* **`credentials: 'include'`** is required so the `PHPSESSID`, `form_key`, and `section_data_ids` cookies are sent. Without it the controller adds to a **different** quote and the section reload happens on yet another session.
* **Cache-busting on the section reload.** `reloadCustomerSectionData()` appends a `_=<timestamp>` query so Varnish/Fastly never serve a cached `customer/section/load`. Make sure `pub/.htaccess` (or your edge config) doesn't strip that query.
* **Don't call `location.reload()`** — that defeats the whole point and produces a flash of the old count.
* **If you have full-page cache** (Varnish), the *page* HTML stays cached, but `customer/section/load` is a non-cached AJAX endpoint — so the counter still refreshes correctly.
* **Multiple buttons in a row.** Debounce the click (the `loading` flag above is enough) — calling `reload-customer-section-data` twice in quick succession will fire two AJAX calls and the second response can clobber a partial update.
* **Messages.** `window.dispatchMessages()` is Hyvä's helper for the global notification bar. It lives in `view/frontend/templates/page/js/messages.phtml`.

---

## 5. End-to-end test

1. Open the storefront, note the mini-cart count (say it's 2).
2. Click "Add Bundle to Cart".
3. Open DevTools → Network. You should see:
   * `POST /bundleadd/cart/add` → 200 with `{success:true, ...}`
   * (Option A only) `GET /customer/section/load/?sections=cart...` → 200
4. Mini-cart number updates to the new total without a navigation.
5. Open DevTools → Application → Local Storage → `mage-cache-storage`. The `cart` key has the new `summary_count` and `items` array.

If step 4 doesn't happen, the most common causes are:

* No `form_key` was sent → controller threw a 403 silently. Check the Network tab.
* The fetch went to a different domain than the storefront → cookies aren't sent, server has no quote.
* `etc/frontend/sections.xml` in your module forgot to map the new route. (You don't need this when you dispatch the events yourself, but you do need it if you want the *stock* form-submit interceptor to refresh sections automatically.) Example if you wanted that behavior:

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:Customer:etc/sections.xsd">
    <action name="bundleadd/cart/add">
        <section name="cart"/>
    </action>
</config>
```

---

## TL;DR

After your `fetch` resolves, dispatch one of these on `window`:

```js
// Cheapest: re-fetch sections from the server
window.dispatchEvent(new Event('reload-customer-section-data'));

// Or, if your controller returned the new section payload:
window.dispatchEvent(new CustomEvent('private-content-loaded', {
    detail: { data: response.sections }
}));
```

That's the single line that bridges your custom controller to Hyvä's mini-cart, header counter, and any other component bound to `private-content-loaded`.
