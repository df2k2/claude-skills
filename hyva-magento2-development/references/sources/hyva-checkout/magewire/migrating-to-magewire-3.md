<!-- source: https://docs.hyva.io/hyva-checkout/magewire/migrating-to-magewire-3.html -->

# Migrating Checkout Components From Magewire 1 to Magewire 3

Hyvä Checkout 3.x installs the `hyva-themes/magento2-hyva-checkout-v1bc` module, so a module written for Hyvä Checkout 1.x (Magewire 1) can support Checkout 1.x and Checkout 3.x with the same code. Most such modules need no change at all. This page first lists what a module does need to change for that, and what it doesn't, then describes how to write components that also run without the [v1bc module](v1bc.html).

## Supporting Checkout 1.x and Checkout 3.x With v1bc

On checkout pages, v1bc runs components written for 1.x in v1 mode: the v1 PHP lifecycle, `$listeners`, `emit()`, the v1 JavaScript API and events, `wire:model` with v1's defer semantics, auto-save and the other v1 behavior listed in [What the v1bc Module Provides](v1bc.html#what-the-v1bc-module-provides). Hyvä Checkout 3.x also still dispatches the Checkout 1.x form modification hooks, such as `form:boot` and `form:shipping:updated`, so form modifiers written for 1.x keep working.

### Necessary, If the Module Does This

| The module… | Change | Details |
| --- | --- | --- |
| Renders Magewire components on a page of its own, e.g. a payment status or wait page | Add `<update handle="hyva_checkout_magewire_startup"/>` to that page's layout. Components there run in v3 mode, unless their class opts in, and get no v1 JavaScript API, so they follow [the best practice](#the-best-practice) and use only JavaScript APIs both versions have | [Components on a module's own pages](#components-on-a-modules-own-pages) |
| Redirects with `redirect($path, $params)` | Build the URL with `Magento\Framework\UrlInterface` and pass the finished URL; Magewire 3.7 drops `$params` | [Components on a module's own pages](#components-on-a-modules-own-pages) |
| Uses the return value of `redirect()`, e.g. `return $this->redirect('checkout/cart');` in a method declaring v1's `Redirect` return type | Call `$this->redirect(...)` as a statement, in a method returning `void`: Magewire 3's `redirect()` returns nothing. Since v1bc 1.0.1, an action or listener declaring `Redirect` follows the redirect too in v1 mode, e.g. on checkout pages, but other code using the return value fails with a `TypeError` | [Known differences](v1bc.html#known-differences-from-magewire-1) |
| Creates a class depending on `Magento\Framework\App\Action\Context` during a component update, e.g. a payment method model | Allow Checkout 3.0.1 or later on the 3.x line, e.g. `^1.3 || ^3.0.1`: on 3.0.0, the update then fails with a 500 and 'The element with the "…" ID wasn't found', on the payment step with `checkout.payment.methods.after` | [Changelog 3.0.1](../upgrading/changelog.html#301-2026-11-02) |
| Recognizes a component's update request by its URL (`/livewire/message/<name>`) or route (`magewire_post_livewire`), in JavaScript, PHP or tests, or reads `getParam('fingerprint')`, `serverMemo` or `updates` in PHP | Match `/magewire/update` and read the component names from the request body as well; in PHP, read `$request->getParam('components')`. v1bc keeps the v1 URL only for a request of a single v1 component; Hyvä Checkout's own components are native v3 in Checkout 3.x | [Recognizing a component's update request](#recognizing-a-components-update-request) |
| Renders a `<script>` in a component's template that only a re-render adds, e.g. once a payment method is selected | Move the code into `x-data` / `x-init`, or into a script rendered outside the component: Magewire 3 doesn't run a script a re-render adds | [Known differences](v1bc.html#known-differences-from-magewire-1) |
| Starts a component template with a condition or loop, so that its first HTML is inside an `if`, `foreach` or `switch`, e.g. `<?php if ($block->isEnabled()): ?><div>…</div><?php endif; ?>` | Render the root element unconditionally and put the condition inside it. On Checkout 3.0.0, every render that takes another branch fails with `Undefined variable $…`. Checkout 3.0.1 moves Magewire's fragment start in front of the condition, but not in every template, e.g. not when a `return` follows it | [Changelog 3.0.1](../upgrading/changelog.html#301-2026-11-02) |
| Registers `Alpine.data()` (or sets up globals an `x-data` reads) in a `magewire:load` listener | Move it to `alpine:init`: unlike v1, `magewire:load` fires after Alpine.js initialized the page | [JavaScript: lifecycle events and hooks](#javascript-lifecycle-events-and-hooks) |
| Emits with several positional arguments, `emit('event', 'a', 'b')` | Pass one array: v3 passes the first argument only | [Known differences](v1bc.html#known-differences-from-magewire-1) |
| Calls `dispatchBrowserEvent('event')` without data, or with data that isn't an array (a string, a number) | Pass an array, e.g. `[]` or `['message' => 'Saved']`: with Magewire 3.7 the request fails otherwise | [Known differences](v1bc.html#known-differences-from-magewire-1) |
| Makes an address or guest details field live with a plain `wire:model` in a form modifier, e.g. for a postcode lookup | Set `wire:model.live`. On Checkout 3.x these forms keep a plain `wire:model` deferred, also with v1bc; on 1.x, `.live` behaves like a plain `wire:model` | [Upgrading to 3.0.0](../upgrading/upgrading-to-3.0.0.html#customizations-that-need-a-change) |
| Overrides a Checkout method whose signature changed, or `AbstractForm::updating()` / `updated()` | Such overrides can't serve both lines: they need a version check or a different hook | [Upgrading to 3.0.0](../upgrading/upgrading-to-3.0.0.html#customizations-that-need-a-change) |
| Relies on `emitUp()` / `emitToRefreshUp()` reaching the ancestors only, on `skipRender(false)`, or on `reset([...], true)` running `boot()` | Don't: v3 behaves differently, and v1bc can't change it yet | [Known differences](v1bc.html#known-differences-from-magewire-1) |
| Has form modifier listeners that type-hint the address form component as `MagewireAddressFormInterface` or `AbstractMagewireAddressForm`, or call its methods such as `store()` or `getDifferences()` | Leave the component parameter untyped, or type it `\Magewirephp\Magewire\Component`, and use modification hooks instead of the component's methods. On 3.x, the address forms are `AbstractAddressForm` components, and a listener with the 1.x type hint never runs | [Listener type hints](../devdocs/form-api/form-modification-hooks.html#listener-type-hints-on-checkout-3x) |

### Not Necessary

- **Moving code out of `boot()`, or following the other PHP rules below.** v1bc applies the browser state again after `boot()` for v1 components, so v1 code keeps its v1 order. The rules matter for native v3 components only.
- **Rewriting JavaScript for v3.** The v1 JavaScript API, the v1 hooks and `magewire:available` / `magewire:load` are provided on checkout pages.
- **Replacing `$listeners`, `emit()` or `emitTo()`.** An associative emit payload still reaches a v1 listener as one array argument, and `emitTo()` targets a layout block name as in v1.
- **Removing auto-save.** v1bc provides `wire:auto-save`, the "Auto Save" field configuration and its admin settings.
- **Moving 1.x address forms (`AbstractMagewireAddressForm`) to Checkout 3's forms**, or moving form modifiers off the 1.x hooks. Checkout 3.x still dispatches them; only the type hints above need a change.
- **Adding `#[HandleBackwardsCompatibility]`.** Components in the checkout run in v1 mode without it.
- **Requiring v1bc.** Checkout 3.x installs it. Don't add it to the module's `composer.json`: v1bc requires Checkout 3.x, so the module could no longer be installed on Checkout 1.x.

Test the module on both versions: on Checkout 1.x and on Checkout 3.x with v1bc installed and enabled.

## Code That Also Runs Without v1bc

The rest of this page is for code that should also run without v1bc, as a native Magewire 3 component, for example on a module's own pages, on stores that disable v1bc, or in a release that drops Checkout 1.x support. It shows how to set initial, computed and server-owned values so a component behaves the same on Hyvä Checkout 1.x (Magewire 1), on Hyvä Checkout 3.x with Magewire 3, and on Hyvä Checkout 3.x with v1bc.

### Why `boot()` Is Not the Place for Defaults

Magewire 3 inherits its request order from Livewire 3: on a subsequent request, `HandleComponents::update()` restores the public properties from the snapshot first, and only then triggers the lifecycle hooks, `boot()` included. Anything `boot()` assigns to a public property overwrites what came back from the browser.

Magewire 1 reimplemented Livewire 2's lifecycle. Its `ComponentManager` plugin calls `boot()` (and `mount()` on the first request) before the property hydrator assigns the browser state, so there the browser state wins.

v1bc restores the v1 order for v1 components only: it keeps the restored state and applies it again after `boot()`. Native v3 classes, including Hyvä Checkout's own, keep the v3 order. Code that follows this page does not depend on either.

### Where the Hooks Run

|  | Magewire 1 (`ComponentManager` plugin) | Magewire 3 (`SupportLifecycleHooks`) |
| --- | --- | --- |
| First render | `boot()` → `mount()` → hydrators → `booted()` | `boot()` → `mount()` → `booted()` |
| Later requests | `boot()` → hydrators (browser state) → `hydrate()` → `booted()` → updates and calls | properties restored → `boot()` → `hydrate()` → `booted()` → updates and calls |

Only `boot()` moves relative to the browser state. `mount()`, `hydrate()` and `booted()` run at the same point on both versions; in particular, `booted()` always runs after the browser state is restored and before the request's updates and calls are applied.

### The Best Practice

| Kind of value | Do this | Same on v1 and v3 |
| --- | --- | --- |
| Fixed default | Property declaration: `public string $method = '';` | Yes |
| Initial value from the server, after which the customer's choice wins | Assign it in `mount()` | Yes (see [the v1 refresh caveat](#the-v1-refresh-caveat)) |
| Value the server owns on every request, e.g. re-read from the quote | Assign it in `booted()` | Yes, every request, after the browser state |
| Data only needed to render: method lists, options, labels | A protected property filled in `boot()`, or a getter method the template calls | Yes; protected properties are never in the snapshot |
| Services | Constructor injection | Yes |

The following component applies each row of the table:

```
class DeliveryDate extends \Magewirephp\Magewire\Component
{
    // Fixed default.
    public string $slot = '';

    // Render-only data: not part of the snapshot.
    protected array $availableSlots = [];

    public function __construct(
        private readonly SlotProvider $slotProvider,
        private readonly CheckoutSession $checkoutSession
    ) {
    }

    public function boot(): void
    {
        $this->availableSlots = $this->slotProvider->getSlots();
    }

    // Initial value from the server; the customer's choice wins afterwards.
    public function mount(): void
    {
        $this->slot = (string) $this->checkoutSession->getQuote()->getData('delivery_slot');
    }

    // Normalize input here, assign it and return it.
    public function updatedSlot(string $value): string
    {
        $this->slot = in_array($value, array_column($this->availableSlots, 'code'), true) ? $value : '';

        return $this->slot;
    }

    public function getAvailableSlots(): array
    {
        return $this->availableSlots;
    }
}
```

### Rules That Avoid the Remaining Differences

- **Never assign defaults to public properties in `boot()`.** On v1 the browser state overwrites them; on v3 they overwrite the browser state.
- **Normalize input in `updatedFoo()`, not `updatingFoo()`.** Assign the result to `$this->foo` and also return it: v1 assigns the return value, v3 ignores it but keeps your assignment. Don't change a value in `updatingFoo()`; v3 sets the browser value after that hook, whatever it returns.
- **Use the property specific hooks `updatedFoo($value)`, not the generic `updated()` / `updating()`.** The generic hooks get their arguments in the opposite order (v1 `($value, $name)`, v3 `($name, $value)`), and Magewire only swaps them for components in v1 mode.
- **Don't use `#[Computed]`.** It is v3 only, and Magewire 3.7 does not register it. `#[Locked]` (`Magewirephp\Magewire\Attributes\Locked`) does work in Magewire 3.7: the browser can't change the property. It has no effect on Magewire 1, so code that also runs on Checkout 1.x validates the value on the server as well.
- **For events, use `dispatch()` / `#[On]` in new code, or `emit()` with a single associative array.** On a v1 component the listener receives that array as one argument; on a v3 component, as named arguments. Name the listener parameters after the keys, and let v1 listeners accept the array.

### The v1 Refresh Caveat

In v1, a request that only handles an event mapped onto `refresh` reset the public properties to their class defaults plus what `boot()` assigns, without running `mount()` again. A value set only in `mount()` therefore falls back to its default after such a refresh on v1, while v3 keeps it. A value that must survive a v1 refresh belongs in `booted()`.

## JavaScript: Lifecycle Events and Hooks

Unlike the PHP side, JavaScript can't be written once against a single API for both v1 and v3. Magewire 1 runs Livewire 2, which has neither the v3 events nor the v3 hooks, and its hook callbacks take positional arguments instead of one object.

| Combination | Works? |
| --- | --- |
| v1 JS on Checkout 1.x | Yes |
| v1 JS on Checkout 3.x | Only while v1bc is installed and enabled |
| v3 JS on Checkout 3.x, with or without v1bc, also with `magewirephp/magewire-hyva-theme` | Yes, following the rules below |
| v3 JS on Checkout 1.x | No |
| One file for 1.x and 3.x | Only with two code paths, see below |

What each setup provides

|  | Checkout 3.x alone | Checkout 3.x + v1bc | Theme with magewire-hyva-theme |
| --- | --- | --- | --- |
| `magewire:init` (before components start) | Yes (Checkout's startup renames `livewire:init`) | Yes | Yes (the theme package renames it) |
| `magewire:initialized` (after components start) | Yes | Yes | Yes |
| v3 hooks (`component.init`, `element.init`, `morph.*`, `commit`, `request`) | Yes | Yes | Yes |
| `magewire:available` / `magewire:load` | Not dispatched | v1 order; `magewire:load` after Alpine.js initialized the page | Swapped timing |
| v1 hooks (`component.initialized`, `element.*`, `message.*`) | No | Yes, in the v1 order, for every component | Partly, through its own compatibility layer |

In v1, `magewire:available` fired once the Magewire object existed, before the components started, and `magewire:load` fired after they had started, before Alpine.js initialized the page. `magewirephp/magewire-hyva-theme` maps them the other way round, following the rename of `livewire:load` to `livewire:init` in Livewire 3's upgrade guide. v1bc keeps the v1 order relative to the component start, but its `magewire:load` fires after Alpine.js initialized the page, so its listeners run after every `x-data` and `x-init`: register `Alpine.data()` in `alpine:init`. v1bc steps aside when the theme package is installed.

### v3 Code That Works in Every v3 Setup

```
// Register hooks, directives and listeners before the components start, so the hooks see every component,
// including the ones Checkout's step navigation renders later.
document.addEventListener('magewire:init', () => {
    Magewire.hook('component.init', ({ component }) => {
        if (component.name !== 'checkout.my-component') return;
        // per component setup
    });

    Magewire.hook('commit', ({ component, succeed, fail }) => {
        succeed(({ snapshot, effects }) => { /* after the server answered */ });
    });

    Magewire.on('payment_method_selected', ({ method }) => { /* named payload */ });
}, { once: true });

// Only for work that needs the started page, e.g. reading the components already on it.
document.addEventListener('magewire:initialized', () => { /* Magewire.find(...) */ }, { once: true });
```

- Register hooks, `Magewire.on()` listeners and directives in `magewire:init`, and use the v3 hook names. Prefer a `component.init` hook over `magewire:initialized` plus `Magewire.find()`: the hook also covers components that render later.
- Don't listen to `magewire:available` or `magewire:load` in new code. Whether and when they fire depends on which package provides them.
- Register directives with the v3 signature: `Magewire.directive(name, ({ el, directive, component, cleanup }) => …)`.
- Send events with a named payload and read it with `({ key }) => …`. Positional parameters reach `Magewire.on()` as one array on plain v3, while v1bc spreads them into arguments.
- Magewire itself does not dispatch `magewire:init`; Hyvä Checkout's startup and the theme package do. Code that may also run on a bare Magewire 3 installation without either listens to `livewire:init` and `livewire:initialized`, which the bundled runtime always fires.

### One File for Checkout 1.x and 3.x

When a single package must support both, keep two code paths and choose at runtime:

```
(() => {
    let isV3 = false;
    document.addEventListener('livewire:init', () => isV3 = true, { once: true }); // only Livewire v3 fires it

    const register = () => {
        if (isV3) {
            // v3: Magewire.hook('component.init', ({ component }) => …), 'commit', …
        } else {
            // v1: Magewire.hook('component.initialized', component => …), 'message.received', …
        }
    };

    // v3: magewire:init. v1: magewire:available, which fired before the components started. Each setup fires them
    // in a different order, so register once, at whichever comes first.
    let done = false;
    ['magewire:init', 'magewire:available'].forEach(name => document.addEventListener(name, () => {
        if (! done) {
            done = true;
            register();
        }
    }, { once: true }));
})();
```

Not yet tested in every setup

This snippet has not been run against all setups yet. Test it on each release line and setup your module supports.

## Events Between PHP Components

To send an event that both versions understand, use `emit()` with one associative array. Magewire 1 has no `dispatch()`, and Magewire 3 keeps `emit()` on every component. Listen through `$listeners`, because v1 has no `#[On]`. Name the listener parameter after the payload key, and accept v1's single array:

```
protected $listeners = ['shipping_method_selected' => 'onShippingMethodSelected'];

// v1 passes the whole array as the first argument; v3 binds the 'code' key to $code.
public function onShippingMethodSelected($code = null): void
{
    $code = is_array($code) ? ($code['code'] ?? null) : $code;
    // …
}
```

## Recognizing a Component's Update Request

Magewire 1 posted each component to its own URL, `window.livewire_app_url` followed by the component name, e.g. `/magewire/post/livewire/message/checkout.shipping.methods`, and the PHP full action name of that request was `magewire_post_livewire`. Magewire 3 posts every update to `POST /magewire/update`, one request can carry several components, and its router sets no route, controller or action name, so `getFullActionName()` returns `__`. Code that recognizes an update by its URL or route stops matching.

v1bc keeps `window.livewire_app_url`, and for a request that carries a single v1 component, it appends the component name to the update URL (`/magewire/update?component=<name>`), so a check like `url.endsWith('<name>')` still matches. That doesn't cover Hyvä Checkout's own components, which are native v3 in Checkout 3.x, requests with several components, PHP code or tests.

- **Don't inspect the request when you can avoid it.** To get data to a component, pass it through the component, as a property or an action argument, instead of adding it to the request body in a `fetch()` wrapper.
- **In PHP, read the components from `$request->getParam('components')`.** Magewire 1 also put the update payload into Magento's request params, so `getParam('fingerprint')`, `getParam('serverMemo')` or `getParam('updates')` worked. On Magewire 3 they don't exist. Each entry of `components` is a `ComponentRequestContext` with `getSnapshot()->getMemoValue('name')`, `getUpdates()` and `getCalls()`.
- **In JavaScript, match the update URL and read the components from the request body.** The following function works on both versions.

  Recognizing an update request in JavaScript

  ```
  function isUpdateOf(url, options, componentName) {
      if (typeof url !== 'string' || ! options || options.method !== 'POST') {
          return false;
      }

      // v1: one URL per component.
      if (window.livewire_app_url && url.indexOf(window.livewire_app_url) === 0 && url.endsWith(componentName)) {
          return true;
      }

      // v3: one URL for all components; the request body names them.
      if (new URL(url, location.href).pathname.endsWith('/magewire/update')) {
          try {
              return (JSON.parse(options.body).components || []).some(component => {
                  const snapshot = JSON.parse(component.snapshot || '{}');

                  return snapshot.memo && snapshot.memo.name === componentName;
              });
          } catch (error) {
              return false;
          }
      }

      return false;
  }
  ```

  Compare the path, not the end of the URL: with v1bc, a request for a single v1 component ends in `?component=<name>`.
- **In PHP, check the route of both versions.** On v3 alone, `Magewirephp\Magewire\MagewireServiceProvider::runtime()->mode()->isSubsequent()` tells whether the request is a component update. For both versions, check the v1 action name and the path Magewire 3's router matches:

  ```
  $isMagewireUpdate = $request->getFullActionName() === 'magewire_post_livewire'
      || str_starts_with((string) $request->getPathInfo(), '/magewire/update');
  ```
- **In end-to-end tests, wait for the update and check the request body,** not the component's URL. The following Playwright helper works on both versions.

  Recognizing an update request in a Playwright test

  ```
  const isUpdateOf = (response, componentName) => {
      if (response.url().includes(`/livewire/message/${componentName}`)) {
          return true; // Hyvä Checkout 1.x
      }

      if (! new URL(response.url()).pathname.endsWith('/magewire/update')) {
          return false;
      }

      try {
          return (response.request().postDataJSON().components || [])
              .some(component => JSON.parse(component.snapshot).memo?.name === componentName);
      } catch (error) {
          return false;
      }
  };

  await page.waitForResponse(response => isUpdateOf(response, 'checkout.guest-details') && response.ok());
  ```

## Components on a Module's Own Pages

Hyvä Checkout 1.x started Magewire on every page that rendered a component. Hyvä Checkout 3.x starts it on checkout pages only, so a component on a module's own page, for example a payment status or wait page, no longer loads there. Add Hyvä Checkout's startup handle to that page's layout:

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <!--
        Hyvä Checkout 3 starts Magewire on checkout pages only; this handle starts it on this page, too.
        Hyvä Checkout 1.x has no such handle, so it changes nothing there.
    -->
    <update handle="hyva_checkout_magewire_startup"/>
    <body>
        <!-- the page's Magewire components -->
    </body>
</page>
```

- **The same layout file works on 1.x and 3.x.** An `<update>` of a handle that doesn't exist does nothing, so the module needs no version check.
- **Only pages outside the checkout need it.** Components inside the checkout start without it.
- **Magewire only loads when a component renders.** When none renders, the theme's own Alpine.js loads as usual.
- **On a theme that isn't CSP compatible, many of the theme's Alpine components fail on such a page.** Where a component renders, Magewire 3.7 loads Alpine's CSP build in place of the theme's Alpine.js. Components the CSP build can't evaluate stop working, with `Undefined variable` errors in the browser console: an `x-data` calling a global function instead of a component registered with `Alpine.data()`, e.g. the price box, swatches, wishlist and compare buttons on product cards, and expressions using `event` instead of `$event`, e.g. the header's listener for the customer section data. Simple expressions keep working, so a toggle that works doesn't mean the page is fine. Test the page on the store's theme, and don't add the handle to every page (`default.xml`), e.g. for a button in the minicart or on product pages.
- **Rely only on v1 APIs that Magewire 3 also has.** A component on another page runs in v3 mode unless its class opts in with `#[HandleBackwardsCompatibility]`, and v1bc's v1 JavaScript API is only on checkout pages. It gets what Magewire 3 itself provides, e.g. `Magewire.find()`, `$wire.get()`, `$wire.call()`, `wire:click` and `wire:poll`.
- **Build redirect URLs with parameters yourself.** Magewire 3.7.2 drops the parameters of `redirect($path, $params)` (see [Known Differences From Magewire 1](v1bc.html#known-differences-from-magewire-1)). Inject `Magento\Framework\UrlInterface` and pass the finished URL; this works on v1 as well:

  ```
  $this->redirect($this->urlBuilder->getUrl('mollie/checkout/redirect', ['paymentToken' => $paymentToken]));
  ```

In developer mode, a page that renders Magewire components while nothing starts Magewire writes a warning to `var/log/system.log` and the browser console. A store that installs `magewirephp/magewire-hyva-theme` starts Magewire on every page, and the handle then changes nothing.

For example, `mollie/magento2-hyva-checkout` added the handle to its point-of-sale wait page (`hyva_mollie_checkout_pointofsale.xml`) and its express checkout page (`hyva_mollie_express_process.xml`), and built the wait page's retry redirect with the URL builder ([mollie/magento2-hyva-checkout#102](https://github.com/mollie/magento2-hyva-checkout/pull/102)).

## Auto-Save (`wire:auto-save`)

Hyvä Checkout 1.x saved address forms without the customer asking for it:

- the 1.x address forms (`AbstractMagewireAddressForm`) called `store()` once the customer stopped typing for the "Autosave Timeout" (`hyva_themes_checkout/developer/shipping_billing_form/autosave_timeout`, 3000 ms), for every field marked `wire:auto-save`
- a field marked `wire:auto-save.self` (the email field with sign in enabled, the "Auto Save" column of the address field configuration while "Disable Form Auto Saving" is on, or a form modifier) sent its value by itself, 1.5 s after the last key stroke (`wire:auto-save.self.3000ms` for another delay)
- `AbstractForm` submitted the form on `dehydrate()` when `canAutoSave()` allowed it; a subclass such as 1.3.15's `CouponCode` overrode it to never auto-save

Hyvä Checkout 3.x does none of this. Its address forms submit on `dehydrate()` of any request that updates them and on step navigation, only the country syncs right away, `isAutoSave()` is deprecated and returns `false`, the deprecated `canAutoSave()` only tells whether `dehydrate()` saves the form, and the settings are gone from its admin. Until a checkout no longer depends on auto-save, `hyva-themes/magento2-hyva-checkout-v1bc` provides all of it, including the admin settings. Migrate in four steps:

1. **Keep v1bc enabled.** A Checkout 1.x configuration and the forms built for it keep working with it, so the checkout can be upgraded first and migrated afterwards.
2. **Change the forms so they no longer depend on auto-save.** Persist a value when the customer acts, not after a pause:
   - Values that only have to be saved before the customer leaves the step need nothing: Checkout 3.x saves its address forms on Next, and an `AbstractForm` submits on `dehydrate()` while `$autosave` is on.
   - A value that other components need right away (shipping methods, totals, a payment method) is saved on change: bind it with `wire:model.live` (or `wire:model.blur` for text fields) instead of `wire:auto-save.self`, or call an action from an event, e.g. `wire:change="saveCity"`, that saves it.
   - Replace a `canAutoSave()` override: set `public bool $autosave = false;` on a form that must not save on the way past, and save it from an explicit action (as Checkout 3's `CouponCode` applies a coupon on `trigger('apply')`).
   - Move a 1.x address form (`AbstractMagewireAddressForm`) to Checkout 3's `ShippingDetailsForm` / `BillingDetailsForm`; drop `getAutoSaveTimeout()` and `autoSaveTimeout`.
   - Remove `wire:auto-save` attributes that form modifiers set, `isAutoSave()` checks and `IS_AUTO_SAVE` data, and scripts that look for `[wire\:auto-save]`.
3. **Verify.** Uncheck "Auto Save" for every address form field and "Disable Form Auto Saving", then run through the checkout: every value a later step or another component needs must be saved without waiting. Search the code base and the theme for `auto-save`, `isAutoSave`, `canAutoSave` and `autoSaveTimeout`.
4. **Disable v1bc** (see [Disabling the v1bc Module](v1bc.html#disabling-the-v1bc-module)) once nothing else needs it. Its auto-save settings go with it.

## Related Topics

- [The Magewire 1 Backward Compatibility Module (v1bc)](v1bc.html): what it covers, its known differences and disabling it
- [Magewire in Hyvä Checkout](index.html): Magewire concepts and a Magewire 1 to Magewire 3 cheat sheet
- [Upgrading to 3.0.0](../upgrading/upgrading-to-3.0.0.html): moving from Checkout 1.x to 3.x
- [Magewire 3 documentation](https://docs.magewirephp.nl/)
