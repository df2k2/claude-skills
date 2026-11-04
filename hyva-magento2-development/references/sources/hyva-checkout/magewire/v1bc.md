<!-- source: https://docs.hyva.io/hyva-checkout/magewire/v1bc.html -->

# The Magewire 1 Backward Compatibility Module (v1bc)

Who this page is for

Developers bringing a Checkout 1.x integration to Checkout 3.x. New Checkout 3.x integrations don't need it. Not a developer? Read [What Is the v1bc Module?](../faq/what-is-v1bc.html)

Hyvä Checkout 3.x runs on Magewire 3. The `hyva-themes/magento2-hyva-checkout-v1bc` package (module `Hyva_CheckoutV1bc`) keeps components, templates and JavaScript written for Hyvä Checkout 1.x and Magewire 1 working on it, side by side with native Magewire 3 components. Hyvä Checkout 3.x installs it as a dependency, so there is nothing to install.

What you need to know:

- **On checkout pages, Magewire 1 code keeps working.** Every component that doesn't opt out runs in **v1 mode**: it gets the Magewire 1 PHP behavior, the v1 JavaScript API and events, and the Magewire 1 meaning of `wire:model`.
- **New and migrated components inside the checkout must opt out of v1 mode** with `#[HandleBackwardsCompatibility(enabled: false)]`. Nothing else opts a component out of v1 mode, other Magewire 3 attributes such as `#[On]` included. Without it, a native Magewire 3 component runs in v1 mode: for example, an `updated*()` hook that returns nothing sets its property to `null`, and a plain `wire:model` is live.
- **Outside the checkout, components run as native Magewire 3**, unless their class opts in, and the v1 JavaScript API isn't available there. See [Which Pages the v1bc Module Covers](#which-pages-the-v1bc-module-covers).
- **A few Magewire 1 behaviors can't be emulated.** See [Known Differences From Magewire 1](#known-differences-from-magewire-1).
- **Modules don't require v1bc themselves.** It requires Checkout 3.x, so a module that adds it to its `composer.json` can no longer be installed on Checkout 1.x.

To find out what a module written for Checkout 1.x has to change to run on both release lines, see [Supporting Checkout 1.x and Checkout 3.x With v1bc](migrating-to-magewire-3.html#supporting-checkout-1x-and-checkout-3x-with-v1bc). The full reference is the module's README, in `vendor/hyva-themes/magento2-hyva-checkout-v1bc/README.md` of your Magento installation, or in the [v1bc repository on GitLab](https://gitlab.hyva.io/hyva-checkout/checkout-v1bc) (Hyvä GitLab access required).

## Opting a Component In or Out of v1 Mode

A component class controls its mode with the `#[HandleBackwardsCompatibility]` attribute. The following example opts one component out of v1 mode and another one in:

```
use Magewirephp\Magewire\Component;
use Magewirephp\Magewire\Features\SupportMagewireBackwardsCompatibility\HandleBackwardsCompatibility;

// A new or migrated component inside the checkout: use native Magewire 3 semantics
#[HandleBackwardsCompatibility(enabled: false)]
class DeliveryDate extends Component
{
}

// A Magewire 1 component that renders outside the hyva-checkout-main container
#[HandleBackwardsCompatibility]
class LegacyGiftMessage extends Component
{
}
```

Use the full attribute class name

The attribute class is `Magewirephp\Magewire\Features\SupportMagewireBackwardsCompatibility\HandleBackwardsCompatibility`. An import from `Magewirephp\Magewire\Attributes\` does not exist, and a component with a wrong import silently keeps its default mode.

Which components run in v1 mode by default

On checkout pages, a component runs in v1 mode when either of these applies, unless its class carries `#[HandleBackwardsCompatibility(enabled: false)]`:

- the Hyvä Checkout component resolver constructs it, or
- it renders inside the `hyva-checkout-main` layout container.

Hyvä Checkout's own components are native Magewire 3 code. Most of them still run in v1 mode, so a theme override of a Checkout template written for 1.x keeps working, but their own methods keep Magewire 3 semantics. A Magewire 1 subclass of a Checkout component gets Magewire 1 behavior for the methods it declares itself.

The shipping and billing address forms, also in the address list, the coupon code form and the guest details form opt out of v1 mode. Address autocompletes written for 1.x keep working with them: `sync()` and `emit*()` on these forms' `$wire` still work, e.g. `Magewire.find('checkout.shipping-details.address-form').sync('address.city', city)`. In new code, use `$set('address.city', city)` and `$dispatch()`, which work with and without v1bc.

Code written for Checkout 1.x that reads the internals of core checkout components therefore works through emulation, so test it on Checkout 3.x.

## Which Pages the v1bc Module Covers

**On checkout pages**, v1bc covers every component that doesn't opt out of v1 mode. **On other pages**, it only covers components whose class opts in with `#[HandleBackwardsCompatibility]`, and only their PHP behavior: the v1 JavaScript API isn't there, so stick to `wire:click`, `wire:poll`, `$wire.get()`, `$wire.call()` and `Magewire.find()`.

**On every page and for every component**, the Magewire 1 ways to declare a component in layout XML keep working: the array form of the `magewire` argument, and a component on a block created with `createBlock()`.

Hyvä Checkout 3.x starts Magewire on checkout pages only. A module that renders Magewire components on a page of its own adds `<update handle="hyva_checkout_magewire_startup"/>` to that page's layout. See [Components on a Module's Own Pages](migrating-to-magewire-3.html#components-on-a-modules-own-pages).

Some Magewire 1 behaviors apply to every component

**Components in v3 mode** keep Magewire 3 semantics. While v1bc is enabled, a few Magewire 1 behaviors apply to every component, Hyvä Checkout's own included: every event a component emits or dispatches also fires the Magento event `magewire_<event>`, an event named `refresh` re-renders every component, a `Phrase` or other `JsonSerializable` object in a public property is accepted, and in production a failed update request answers with Magewire 1's JSON error body. Don't rely on them in native Magewire 3 code: without v1bc they're gone. The v1bc README lists them all.

## Known Differences From Magewire 1

A few Magewire 1 behaviors can't be emulated without changes to Magewire itself. A module written for Checkout 1.x may have to change these:

- **A `<script>` that a component's re-render adds doesn't run**, e.g. in a payment method's template once the method is selected. Move the code into `x-data` / `x-init`, or into a script rendered outside the component. A script present on the first render runs as before.
- **`magewire:load` fires after Alpine.js initialized the page**, so its listeners run after every `x-data` and `x-init`. Register `Alpine.data()`, and globals an `x-data` reads, in `alpine:init`, not in a `magewire:load` listener.
- **`dispatchBrowserEvent()` without data, or with data that isn't an array**, such as a string, fails the request. Pass an array, e.g. `[]` or `['message' => 'Saved']`. A browser event also reaches PHP listeners of an event with the same name. Fixed in Magewire 3.8.0.
- **`emit('event', 'a', 'b')` passes `'a'` only.** Pass a single array instead.
- **Don't keep a `DataObject` or a Magento model in a public property.** Magewire 3 sends its data, protected data included, to the page. Keep an ID and load the model when you need it.
- **PHP `emitUp()` and `emitToRefreshUp()` reach every listening component**, not only ancestors.
- **`reset([...], true)` called in PHP doesn't run `boot()`** on the fresh instance, and `reset()` restores class defaults, not the values from the layout.
- **`redirect()` returns nothing.** Since v1bc 1.0.1, an action or listener declaring v1's `Redirect` return type, e.g. `public function cancel(): Redirect { return $this->redirect('checkout/cart'); }`, follows the redirect as in v1, and its return value is `null`. A helper method with that return type, or other code that uses the return value of `redirect()`, still fails with a `TypeError`. Call `redirect()` without using its return value.

Magewire 3.8.0 fixes the following, but v1bc 1.0.x requires Magewire 3.7 (`~3.7.2`), so the fixes only apply once a later release allows Magewire 3.8:

- `redirect('path', $params)` drops `$params`. Build the URL with `Magento\Framework\UrlInterface` and pass the finished URL.
- `skipRender(false)` doesn't re-enable rendering.

The README's "Known differences from v1" lists the smaller ones, e.g. PHP accessors, the hydrator order and JavaScript APIs that don't exist.

## What the v1bc Module Provides

The module emulates Magewire 1 for components in v1 mode, in the templates and JavaScript, in PHP and in the loader. The README has the full reference.

The main Magewire 1 behaviors v1bc provides

**Templates and JavaScript** (checkout pages):

- `wire:model` modifiers with their Magewire 1 meaning: a plain `wire:model` is live (except in Hyvä Checkout's own guest details and address forms, where it stays deferred), `.defer` is deferred, and `.lazy` syncs on change.
- `$emit`, `$emitUp`, `$emitSelf` and `$emitTo` in templates and on `$wire`, mapped to Magewire 3 dispatches.
- The Hyvä Checkout 1.x `wire:auto-save` directive.
- The Magewire 1 globals, events and hooks: `Magewire.emit()`, `Magewire.on()`, `magewire:load`, `magewire:available`, `message.sent`, `message.received` and the other v1 hook names.

**PHP** (every page, for components in v1 mode):

- Associative emit payloads, `$listeners` and `emitToRefresh()`.
- Magewire 1 lifecycle hook behavior, including assigned return values of `updating*()` and `updated*()` hooks.
- v1 component resolvers and hydrators registered in `di.xml`.

**PHP** (every component, while v1bc is enabled):

- The Magento event `magewire_<event>` for every dispatched event, Hyvä Checkout's own components included.
- The global `refresh` listener, and plugins on `getListeners()`.
- In production, a failed update request on any storefront page answers with Magewire 1's JSON error body, so `Magewire.onError()` callbacks, Hyvä Checkout's reload dialog included, work. The message is `Internal Server Error`; the exception is in the log.

**The v1 loader** (checkout pages):

- `$loader`, the overlay, notifications and `magewire:loader:*` events, for every checkout component.
- The loader settings under **Stores > Configuration > Advanced > Developer > Magewire > Loader**, at their 1.x paths and with the 1.x defaults.

## Disabling the v1bc Module

Once none of your components, templates or integrations need Magewire 1, you can disable the module. Before you do, check for these, because the check for Magewire 1 code described below doesn't report them:

- **Observers of `magewire_<event>` Magento events**, e.g. `magewire_shipping_address_activated`. Move them to a `hyva_checkout_*` event or a component event.
- **`parent::mount()` calls in `AbstractForm` subclasses.** Remove them.
- **A `Phrase` or other `JsonSerializable` object in a public property** of a native Magewire 3 component, on any page. Without v1bc, Magewire 3 refuses it with "Property type not supported".
- **Plugins on a component's `getListeners()`.** Magewire 3 declares the method protected, so only v1bc runs them. Use the `magewire:listeners` layout argument instead, see [Updating Component Listeners](../devdocs/miscellaneous/checkout-emit-messages.html#updating-component-listeners-with-plugins).
- **Plugins on the 1.x `BillingDetails::updatedBillingAsShipping()`.** v1bc runs them when the customer toggles the same-address checkbox. Listen to the `billing_as_shipping_address_updated` event instead.

Then disable the module:

```
bin/magento module:disable Hyva_CheckoutV1bc
bin/magento setup:upgrade
```

The package stays installed: Hyvä Checkout 3.x requires it, so `composer remove` doesn't work.

The module adds its templates to the Tailwind CSS sources of Hyvä themes, so regenerate `app/etc/hyva-themes.json` with `bin/magento hyva:config:generate` and rebuild the theme CSS after you disable or enable it.

While the module is disabled, Hyvä Checkout 3.x looks for components and JavaScript that look like they are written for Magewire 1. In developer mode it logs them to `var/log/system.log` and the browser console; in production mode it shows an admin system message. A migrated component can declare itself with `#[HandleBackwardsCompatibility(enabled: false)]`.

Upgrading from a 3.0.0 beta

In the beta releases, the module was called `Hyva_CheckoutMwv1bc`. See [Renamed Magewire v1 Backward Compatibility Module](../upgrading/upgrading-to-3.0.0.html#renamed-magewire-v1-backward-compatibility-module).

## Related Topics

- [Hyvä Checkout Release Lines](../getting-started/release-lines.html): the two release lines and how the version tabs work
- [Migrating Checkout Components From Magewire 1 to Magewire 3](migrating-to-magewire-3.html): what a module supporting both lines changes, and how to write code that runs without v1bc
- [Magewire in Hyvä Checkout](index.html): Magewire concepts and a Magewire 1 to Magewire 3 cheat sheet
- [Upgrading to 3.0.0](../upgrading/upgrading-to-3.0.0.html): moving from Checkout 1.x to 3.x
