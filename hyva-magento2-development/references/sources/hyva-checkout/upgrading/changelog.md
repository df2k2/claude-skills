<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/changelog.html -->

# Changelog - Hyvä Checkout 3.x

All notable changes to Hyvä Checkout 3.x (Magewire 3), the current release line, are documented on this page. The `1.4.0` beta releases are early 3.x pre-releases: Hyvä Checkout 3.0 was going to be 1.4 and was renamed to match the Magewire major version.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

Hyvä Checkout has two release lines, and each one has its own changelog. See [Release Lines and Magewire Versions](../getting-started/release-lines.html) to find out which one you're on.

| Release line | Latest release | Changelog | Upgrade notes |
| --- | --- | --- | --- |
| Checkout 3.x (Magewire 3, current) | [3.0.1](changelog.html#301-2026-11-02), 2026-11-02 | [Checkout 3.x Changelog](changelog.html) | [Upgrading to 3.0.1](upgrading-to-3.0.1.html) |
| Checkout 1.x (Magewire 1, previous) | [1.3.15](changelog-1.x.html#1315-2026-10-12), 2026-10-12 | [Checkout 1.x Changelog](changelog-1.x.html) | [Upgrading to 1.3.15](upgrading-to-1.3.15.html) |

## Looking for Checkout 1.x Releases?

Entries for Hyvä Checkout 1.x (1.3.x and older, and the 1.3.1000 beta releases) are in the [Checkout 1.x Changelog](changelog-1.x.html).

## [Unreleased](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/3.0.1...3.0.x-main)

## [3.0.1](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/3.0.0...3.0.1) - 2026-11-02

### Changed

- **Checkout 1.x Compatibility Module Updated to 1.0.1**

Upgrades the `hyva-themes/magento2-hyva-checkout-v1bc` dependency to `^1.0.1`. This fixes redirects in integrations written for Checkout 1.x, such as PayPal's "Cancel Payment" button, which failed with an error instead of redirecting.

For more information, please refer to [merge request #648](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/648).

### Fixed

- **Render Component Templates Whose First HTML Is Inside an `if`**

Magewire 3.7 starts a component template's fragment before its first HTML and ends it at the end of the file. When that HTML sat inside an `if`, a loop or a `switch`, every render taking another branch failed with `Undefined variable $…`; when that was the first render, the whole checkout page failed. In a loop, every pass left an output buffer open. Templates written for Checkout 1.x often start that way, e.g. `<?php if ($block->isEnabled()): ?>…<?php else: ?>…<?php endif; ?>`; the Stripe integration's did. Before Magewire compiles a template, Checkout now moves the start in front of that block. This applies to every Magewire component template on the storefront, not only on the checkout. Templates it can't change safely stay as they are, e.g. one with a `return` after the block (see `TemplateFragmentStart`).

`setup:upgrade` deletes the compiled Magewire views of the storefront once, so they are compiled again. Where it can't, it logs a warning. Run `bin/magento magewire:compile:clear --area=frontend` yourself in that case, on every server whose `var/magewire` the one running `setup:upgrade` doesn't share, and reset OPcache where it doesn't check file timestamps.

For more information, please refer to [merge request #645](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/645).

- **Fix the Fallback `bg-opacity` Calculation for `bg-white`**

The `bg-white` fallback for the `bg-opacity-*` classes that Tailwind 4 removed multiplied `--tw-bg-opacity` by `100%` instead of `1%`, so on Hyvä 1.4 and later, `bg-white` with a `bg-opacity-*` class rendered a fully opaque white background.

For more information, please refer to [merge request #644](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/644).

- **Go to the Payment Step When a Payment Method Depends on Magento's App\View**

With a payment method whose model depends on `Magento\Framework\App\Action\Context` installed, such as Stripe's, going to the payment step failed with a 500 and 'The element with the "checkout.payment.methods.after" ID wasn't found'. Creating such a class during a Magewire update created `Magento\Framework\App\View`, whose page builder replaced Magewire's and rebuilt the layout. Checkout now creates `App\View` before Magewire builds the layout of an update.

For more information, please refer to [merge request #642](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/642).

## [3.0.0](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/3.0.0-beta1..3.0.0) - 2026-10-27

First Stable Release of Hyvä Checkout on Magewire v3

`3.0.0` follows `3.0.0-beta1`. It refuses guest orders where Magento doesn't allow guest checkout: see the Security section of this release. The upgrade steps and what merchants will notice are in [Upgrading to 3.0.0](upgrading-to-3.0.0.html).

### Changed

- **Customizations Written for Checkout 1.3 That Still Need a Change**

A few changes can't serve 1.3 and 3.0 code alike: observers of `magewire_<event>` Magento events only run while `Hyva_CheckoutV1bc` is enabled, form modifier listeners typed on the 1.x address form classes are skipped, some method signatures changed, and a plain `wire:model` on the address and guest details forms stays deferred. See [Customizations That Need a Change](upgrading-to-3.0.0.html#customizations-that-need-a-change).

For more information, please refer to [merge request #638](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/638).

- **Hyvä's Totals Plugin Runs on the Storefront Only**

The plugin on `Magento\Quote\Model\Cart\TotalsConverter` that adds `tax_details` and the incl. tax shipping amount to the total segments is now registered for the storefront only. REST cart totals (`/V1/carts/mine/totals`, `/V1/guest-carts/:cartId/totals`) return Magento's own values again; before, their tax details came from the checkout session's quote, also in 1.3. A module that reads `tax_details` outside the storefront registers the plugin for its area itself.

For more information, please refer to [merge request #638](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/638).

- **Recognize the Renamed Module `Hyva_CheckoutV1bc`**

The module in `hyva-themes/magento2-hyva-checkout-v1bc` is renamed from `Hyva_CheckoutMwv1bc` to `Hyva_CheckoutV1bc`. Hyvä Checkout works with either name. Run `bin/magento setup:upgrade` to enable the renamed module.

For more information, please refer to [merge request #630](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/630).

- **Start Magewire on a Module's Own Pages With a Layout Handle**

Hyvä Checkout starts Magewire on checkout pages only. A module that renders Magewire components on a page of its own, such as a payment status page, adds `<update handle="hyva_checkout_magewire_startup"/>` to that page's layout. Hyvä Checkout 1.x ignores the handle, so the same layout works on both release lines.

- **Keep Magewire Off Pages Where It Isn't Started**

Magewire's scripts, styles, notifier and loading indicator are no longer output on pages where Magewire isn't started, such as category, product, CMS and cart pages. This saves around 40 KB of HTML and inline JavaScript per page and removes console errors on full-page-cached pages of Hyvä CSP themes.

For more information, please refer to [merge request #628](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/628).

- **Collecting the Billing Address First Is Experimental**

Asking for the billing address first, by replacing `Hyva\Checkout\Model\Component\SameAddressOrder`, is not complete yet. While "My billing and shipping address are the same" is ticked, saving or picking a billing address doesn't update the shipping address, so shipping rates and the delivery address can be out of date. The class is no longer marked `@api` and may change in a later release.

For more information, please refer to [merge request #629](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/629).

- **Save Address Forms to the Cart's Own Address Only**

The shipping and billing address forms now ignore identifying fields such as `id` and `quote_id` in the submitted form data, so they only ever update the current cart's address. Hyvä Checkout 1.3 is not affected.

For more information, please refer to [merge request #635](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/635).

- **Place an Order Only Once When Place Order Is Triggered Twice**

Calling `hyvaCheckout.order.place()` again while an order was being placed, for example through a second click, could leave the checkout stuck on its loaders even though the order was created. A second call during placement now waits for the first one instead of placing the order again. Once a placement fails, the order can be placed again.

For more information, please refer to [issue #526](https://gitlab.hyva.io/hyva-checkout/checkout/-/issues/526).

- **Render Magewire Components Outside the Checkout**

On a page outside the checkout that starts Magewire, such as a payment status page, components could fail with an error. Evaluation now only runs for components that implement `EvaluationInterface`.

For more information, please refer to [issue #405](https://gitlab.hyva.io/hyva-checkout/checkout/-/issues/405).

- **Restore Compatibility With Coupon Components From Hyvä Checkout 1.3.14 and Earlier**

Subclasses of `Hyva\Checkout\Magewire\Checkout\CouponCode` written for 1.3.14 and earlier load again. `applyCouponCode()` and `revokeCouponCode()` no longer declare a return type, and the constructor arguments added in 1.3.15 are optional. Coupon templates that bind the input to `couponCode` apply the code again instead of showing "No Coupon".

For more information, please refer to [merge request #629](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/629).

- **Keep "Save in Address Book" When Billing Is Set to the Same Address**

Ticking "My billing and shipping address are the same" now also copies the customer's "Save in address book" choice, so a new shipping address is saved to the address book when the customer asked for it.

For more information, please refer to [merge request #629](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/629).

### Deprecated

These deprecations come from the 3.0.0 release review. For more information, please refer to [merge request #638](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/638).

- **Checkout 1.x Leftovers**

Nothing in Checkout 3 uses `Hyva\Checkout\Model\CheckoutConfig`, the Magewire 1 resolver `Model\Magewire\Component\Resolver\Checkout` with `UpdateAdapterInterface` and `UpdateAdapter\CheckoutNavigate`, `WithRegionModifier::applyRegionIndexAsValueOnSelect()`, `SystemConfigDebug::canWriteKeyComponents()`, `SystemConfigExperimental::disableMainEvaluationResultMerge()`, `Magewire\Checkout\AddressView\BillingDetails\AddressForm` (use `BillingDetailsForm`), `Model\ConfigData\HyvaThemes\SystemConfigCustomerAddress` or the Alpine component `initCheckoutLoader`. They stay for code that still uses them.

- **`ProgressOverlay::withMessage()` and `withDataDrivenMessage()`**

The progress overlay shows a spinner and its title only, so a message has no effect. Use `withMessageTitle()`.

### Removed

These removals come from the 3.0.0 release review. For more information, please refer to [merge request #638](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/638).

- **Admin Settings Without an Effect on Checkout 3**

"Developer > Debug > Add unique keys to components" and "Developer > Experimental > Disable Main Evaluation Result Merge" did nothing on Magewire 3 and are gone, together with their Magewire 1 plugin and DI configuration.

- **Two Unused Templates**

`checkout/address-view/address-list/form.phtml` and the deprecated `page/js/api/v1/evaluation/multi-tabs-compatibility.phtml` were no longer rendered. A theme override of either can be deleted.

### Fixed

The following fixes come from the Checkout 3.0 API contract tests ([merge request #634](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/634)) and the 3.0.0 release review ([merge request #638](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/638)). The package's `CHANGELOG.md` has the full details of each fix.

#### Forms and Checkout 1.3 Compatibility

- **Show Field Errors Instead of an Error Page When a Server-Side Validation Fails**

A failed `validate()` in a component opted out of v1 mode, Checkout's own forms included, answered with a 500 and Magewire's error overlay. Such an action now ends quietly for every Magewire component on the storefront: the field errors render, and the action answers `false` to the browser, so a refused save holds the step navigation.

- **Enforce the Required Fields of Every Form API Form on the Server**

Only the address forms enforced required fields on the server. `AbstractForm::submit()` now refuses an empty required field the customer can see, for every Form API form, including custom forms written for Hyvä Checkout 1.3. Override `requiresOnSubmit()` to opt a field out. The guest details form doesn't require the sign-in password.

- **Cancel a Form Submission From a `form:submitting:magewire` Listener**

Throwing an `AcceptableException` in a `form:submitting:magewire` listener now cancels the submission, and `submit()` returns `false`. Before, the exception was only logged and the form was saved anyway.

- **Read the Address Type From the Component in a Form Listener**

`$component->getAddressType()` failed in a `form:build:magewire` listener, because the method is protected on the address forms. `AbstractAddressForm` now answers the call for listeners.

- **Let Form Modifiers Set Magewire Loading Attributes on Address Fields**

The address forms overwrote `wire:loading.class`, `wire:loading.attr` and `wire:target` that a modifier set on a field. They are now only defaults.

- **Pass a Form Hook's Named Arguments to Listeners With Other Parameter Names**

A listener of a hook such as `form:updated:data:magewire` that declared other parameter names than the hook's (`value`, `path`) never ran. It now gets the arguments it declares by name, and the others in parameter order.

- **Keep a Lower `maxlength` a Form Modifier Set on a Field**

`WithMaxLengthModifier` replaced a lower `maxlength` that a modifier had set. A lower limit now stays.

- **Add the `visibility-toggle` Accessory Template the Layout Declares**

The layout declared `Hyva_Checkout::form/field/html/visibility-toggle.phtml`, which didn't exist. The template now exists and renders nothing.

- **Show the Region Field Again When the Customer Changes to a Country That Requires One**

With "Display not required State" off, the region field stayed hidden after a change to a country that requires it. `WithRegionModifier` now shows it again; a field another modifier hid stays hidden.

- **Save a Form Inside a Component's Root Element When the Customer Continues**

The `magewire-form` validation only noticed unsaved changes when the `<form>` was the component's root element, so a form inside a `<div>` wasn't saved on Next. It now checks the component the form belongs to.

- **Checkout 1.x Form Subclasses Load Again**

1.x `AbstractForm` subclasses that redeclare `$logger`, override `dispatchFormModificationHook()` or call `parent::getUncallables()` load and run again. A few overrides still need a change, see [Customizations That Need a Change](upgrading-to-3.0.0.html#customizations-that-need-a-change).

- **Dispatch the Form Hooks of Checkout 1.x Again**

`form:mount:magewire`, `form:data:updating:magewire`, `form:data:updated:magewire` and 1.x per-path names such as `form:updating:data:street:1:magewire` fire again as deprecated hooks. The per-path hook passes `path`, `from` and `to`, as in 1.x.

- **Dispatch `form:trigger:submit:magewire` After a Failed Save Too**

The hook and its deprecated name `form:execute:submit:magewire` now fire after every save, with the `FormSubmitException` in `exception` when the save failed.

- **Refuse Browser Calls of a Component's Uncallable Methods Again**

Magewire 3 lets the browser call every public method, including methods a component lists in `$uncallables` or `getUncallables()`, such as `CartItems::getQuoteItemData()`, which returns cost prices. Checkout refuses those calls again for every component, and `AbstractForm::getUncallables()` lists the methods 1.3 protected.

- **Log a Failed Form Save Only When It Is a Fault**

`AbstractForm` no longer logs a save refused for the customer, such as a mistyped value, at `critical`; a refusal with a cause of its own is logged at `error`. The guest details log line no longer holds the email address.

- **Keep Typing in the Guest Email Field While the Email Address Syncs**

The email field was disabled during its background sync, so characters typed meanwhile were lost, also in 1.3. Now only the Sign In button is disabled, while the sign-in runs.

#### Payment and Order Placement

- **Tell the Customer When a Payment Method's `placeOrder()` Fails**

An error in the `placeOrder()` of a JavaScript payment method without its own `handleException()` was only written to the browser console. The default `handleException()` now shows "Something went wrong while placing the order. Please try again." in the payment messenger, unless the server refused the order with a message of its own.

- **Give a Payment Method Renderer Its Method on Its Own Component's Updates**

`$block->getData('method')` was null in a payment method renderer when the renderer's own Magewire component updated. It is now set for those updates too.

- **Show the Place Order Button Label of the Active Payment Method**

The navigation now shows the label that the active payment method's `placeOrderButton()` returns. A method keeping the default leaves the theme's own label.

- **Keep the Validator of the Payment Method the Customer Chose Last**

Switching payment methods while the previous method's `initialize()` was still running could leave that method's validator registered. Payment method transitions now run one after another.

- **Report a Method Activated With the Deprecated `payment.activate()` as the Active One**

After `hyvaCheckout.payment.activate()`, `getActive()` returned `null` and `hasActive()` returned `false`, also in 1.3. Both now report the selected method.

- **Activate a Payment Method Once Per Selection**

A 1.x payment method calling `payment.activate()` was initialized again on every selection. One listener now serves every selection, and a method still initializing when the customer goes back a step is taken down again.

- **Report an Order a Payment Method Held as Not Placed**

When a JavaScript payment method's `canPlaceOrder()` held the order and nothing redirects, `hyvaCheckout.order.place()` now resolves `false` and the Place Order button is enabled again. A placed order resolves `{result: true}`.

- **Update the Payment Methods When the Customer Picks an Address or a Shipping Method**

The payment method list now also refreshes on `billing_address_activated`, `shipping_address_activated` and `shipping_method_selected`, so methods restricted by country or order total are up to date. This was also missing in 1.3.

- **Activate the Payment Method the Server Picks When the Method List Refreshes**

When a module changes the quote's payment method during an address or shipping method change, the browser now activates that method through `checkout:payment:method-activate`, or takes the previous method and its validator down when the list no longer offers it.

- **Put a Refused Payment Method, Address or Billing Toggle Back**

When the server refuses a payment method, an address or the billing-as-shipping toggle, the browser shows the previous value again instead of the refused one.

- **Put Back a Shipping Method the Server Refused**

As for the payment method, a shipping method that couldn't be saved no longer stays selected.

- **Enforce the Place Order reCAPTCHA Only Where the Checkout Showed It**

With the "Place Order" reCAPTCHA on, PayPal Express from the cart, Instant Purchase and other flows outside the checkout were refused. The check now applies to Hyvä Checkout's own placement and to any placement of a quote whose checkout showed the challenge. A payment module placing orders through its own endpoint can stay guarded with `Hyva\Checkout\Model\ReCaptcha\PlaceOrderScope::run()`, and a wallet button should run `hyvaCheckout.validation.validate()` first.

- **Send a Place Order Service Without a Redirect of Its Own to the Success Page**

A service implementing only `PlaceOrderServiceInterface` whose `canRedirect()` is false placed the order and then failed with "Method Main::getRedirect does not exist". The fallback redirect works again.

- **Place Orders on Checkouts Whose Step Routes Differ From Their Names**

A step like `<step name="my_step" route="my-step">` kept the customer from placing the order. The `checkout:validation:*` events now also carry the step's `route`.

#### Evaluation, Validation and Navigation

- **Tear Down an Evaluation Result Before It Is Processed Again, and When Its Component Is Removed**

A processor's teardown now runs before every new run, also for an unchanged result, and when the component is removed, together with that run's `registerCleanup()` hooks. A teardown that removes a validation passes the step it registered it on: `hyvaCheckout.validation.remove(name, group, step)`.

- **Pass the Validation Result to a Validator With a Failure Result**

A validator registered with `registerValidator()` now gets `(element, component, result)` when its result has a failure result. The first two arguments are unchanged.

- **Process the Other Results of an Evaluation Batch When One Fails**

A batch stopped at its first failing result, so validations after it were never registered. Each result is now processed on its own.

- **Keep a Component's Error Message While Its Evaluation Batch Fails**

A batch was reported to the browser as passed even when one of its results failed, so a re-render cleared the component's error message. In a batch, `MessageDialog` and `Custom` results now count as failed unless set with `withTrueResult()`; `Batch::getResult()` is unchanged.

- **Show the Technical Malfunction Dialog When `evaluateCompletion()` Throws**

The customer saw the exception's message. As in 1.x, they now see the technical malfunction dialog, and the exception is logged.

- **Apply Evaluation Result Modifiers Again**

`EvaluationResultModifier`s registered in `di.xml` were ignored on Magewire 3. They apply again.

- **Read the Evaluation API Redirect Settings From Where the Admin Saves Them**

A forced confirmation dialog failed after the order was placed, and "Dialog Visibility Duration" was ignored. The "Confirmation Message" and "Notification Message" fields now only show while their dialog is enabled.

- **Apply the Argument Overrides of `evaluation.run()` to That Run Only**

Arguments passed to `hyvaCheckout.evaluation.run()` became the defaults of every later run. Each run now uses its own copy, and `run()` resolves once the result is processed and rejects when processing fails.

- **Keep the Checkout Storage Usable After `hyvaCheckout.storage.clear()`**

`clear()` left the storage unusable until the next page load. It now empties it to `{}`, and an order placed right after it is refused with the "Incomplete Checkout Process" dialog.

- **Treat Going Back Several Steps as Backwards Navigation**

Going back more than one step through the breadcrumbs or the browser history ran the tasks meant for going forwards.

- **Keep Dialogs Without a Cancel Button Open on Escape**

Escape closed the technical malfunction, stale data and empty cart dialogs, whose only action reloads the page.

- **Smaller Fixes in the Frontend API**

Translations of "Show less"/"Show all" and the place order alert are escaped and translatable, and a storage event from another tab that cleared the customer data no longer throws. `hyvaCheckout.loader` doesn't nest, as in 1.3; its `active` counter is deprecated.

#### Failed Requests, Errors and Sessions

- **Tell the Customer When an Update Request Fails in Production Mode**

A failed component update showed the customer nothing. When the server fails the update, the checkout now offers to reload the page; developer mode keeps Magewire's error modal. A request that gets no response, such as on a network failure, opens no dialog, as in 1.3: the checkout warns and lets the customer try again.

- **Recover the Navigation, Order Placement and Form Saves From a Failed Request**

After an HTTP or network error, the Next button, `hyvaCheckout.order.place()`, a `magewire-form` save and the guest sign-in overlay hung. The checkout's own calls now reject on a failed request, so their error handling runs.

- **Show the Server's Error Output in Developer Mode Only**

In Magento's default mode, Magewire's error modal and the `order:place:error` events showed raw exception text, which can hold internals such as SQL errors. Both now happen only in developer mode; default mode shows the reload dialog and the message meant for the customer.

- **Don't Show the Raw Message of a Failed Coupon to the Customer**

An unexpected coupon error now shows "Something went wrong while applying your coupon. Please try again." and is logged. Failed payment and shipping method saves are logged too.

- **Close the Sign-In Overlay When the Sign-In Doesn't Run**

When a `form:before:trigger:login:magewire` listener, such as the customer login reCAPTCHA, stopped the guest sign-in, the overlay stayed up until a page reload. It now closes when the request settles.

- **Redirect Only Checkout Requests to the Cart When the Session Expired**

The expired-cart redirect answered Magewire requests anywhere in the store. It now acts on updates of checkout components only.

- **Notice Cart Changes and an Expired Session in the Open Checkout**

When another tab changes the cart's items or subtotal, the checkout shows the "Information has been updated" dialog, which reloads the page. Once a guest's session has expired, the next checkout update redirects to the cart with "Your session has expired".

#### Order Summary, Events and Accessibility

- **Show the Order Summary's Unit Prices in the Display Currency**

Unit prices were base currency amounts with the display currency's symbol.

- **Update the Item Prices of the Order Summary When the Address Changes**

With prices shown incl. tax, the item rows kept the tax of the address the page was loaded with, also in 1.3.

- **Hide a Zero Tax Line Unless "Display Zero Tax Subtotal" Is On**

Like Magento's cart, the order summary only shows a zero tax line when **Sales > Tax > Shopping Cart Display Settings > Display Zero Tax Subtotal** is "Yes" (default "No").

- **Emit `shipping_address_added` and `billing_address_added` for a New Address Again**

Since 1.3.15 these events (and their `guest_` and `customer_` variants) were no longer emitted. They are emitted once per new address again.

- **Dispatch the `hyva_checkout_layout_process_before` Events**

The documented `hyva_checkout_layout_process_before` and `hyva_checkout_layout_process_before_<handle>` events were never dispatched, also on Hyvä Checkout 1.3. The checkout page now dispatches them, so observers written from the docs start running.

- **Pass the Previous Quote Id With `hyva_checkout_quote_id_changed`**

`previous` was `null` on the first change in a request, for example when a sign-in merged carts. It is now the id the session held before the change.

- **Accessibility of the Sign-In Overlay, Step Changes, Message Dialogs, Field Errors and the Address List**

The sign-in overlay holds focus and makes the checkout behind it inert, a step change is announced, the message dialog reads out its message, and server-side field errors set `aria-invalid` and `aria-describedby`. The address list's Edit buttons are named after their address with the new phrase "Edit Address: %1", which store translations need.

- **Smaller Fixes**

A blank street line fails the required check, a modifier's own `x-init` is kept, `canAutoSave()` answers whether `dehydrate()` saves, `EavAttributeBillingAddressForm` extends `EavAttributeForm` again, and field tooltips render once. The debug mode ("Developer > Debug > Mode") is read at store scope, so a value saved for a website or store view now takes effect.

### Security

These fixes come from the 3.0.0 release review. For more information, please refer to [merge request #638](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/638).

- **Refuse Guest Orders Where Magento Doesn't Allow Guest Checkout**

A guest could place an order although "Allow Guest Checkout" is "No", or while the cart holds downloadable products and "Disable Guest Checkout if Cart Contains Downloadable Items" is "Yes" (Magento's default), also in 1.3. Such an order is now refused with "Please sign in or create an account to place this order."; the one page checkout refuses it at Place Order. With "Enable Onepage Checkout" off, the checkout redirects to the cart, as Magento's does.

- **Smaller Hardening**

Log lines no longer contain the payment method code the browser sent, and the address forms and the order summary escape the submitted country and the cart item option values.

## [3.0.0-beta1](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/1.4.0-beta6..3.0.0-beta1) - 2026-10-12

> **Note:** First 3.0.0 beta release of Hyvä Checkout on Magewire v3, following the `1.4.0-beta` releases. The 1.3.x line stays on Magewire v1 and receives the same features in [1.3.15](changelog-1.x.html#1315-2026-10-12).

### Added

- **Report Components Written for Checkout 1.x While Their Compatibility Module Is Disabled**

While the v1bc module is disabled, the checkout looks for components and JavaScript written for Checkout 1.x. It logs them in developer mode and shows an admin system message in production. A migrated component opts out of v1 mode with `#[HandleBackwardsCompatibility(enabled: false)]`; while the module is enabled, only that attribute does.

- **Google reCAPTCHA for Guest Sign In, Coupon Code and Place Order**

Adds support for Google reCAPTCHA v2 checkbox, v2 invisible and v3 on the guest details sign in, the coupon code form and order placement. Each one uses the existing Magento settings under **Stores > Configuration > Security > Google reCAPTCHA Storefront** and is disabled by default.

The place order challenge renders on the step that holds the Place Order button. Orders placed through the Web API or the admin are not affected.

For more information, please refer to [merge request #578](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/578).

- **Positional Step Layout Handles**

Adds the `hyva_checkout_stepfirst` and `hyva_checkout_steplast` layout handles, plus `hyva_checkout_{checkout}_stepfirst` and `hyva_checkout_{checkout}_steplast`. They apply to whichever step is first or last for the current request.

A checkout or step can no longer be named `stepfirst` or `steplast`, or anything that produces a layout handle ending in one of them. Such a configuration is rejected with an error naming the handle.

For more information, please refer to [merge request #578](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/578).

- **Postcode Format Validation Setting**

Adds **Validate Postcode Format** under **Stores > Configuration > Hyvä Checkout > General > Address Forms > Postcode**. When enabled, the postcode is validated against the format Magento defines for the selected country in `zip_codes.xml`. Disabled by default.

For more information, please refer to [merge request #576](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/576).

Many thanks to Alexander Menk (iMi digital GmbH) for the contribution!

- **Option to Collect the Billing Address First**

The order of the shipping and billing address forms is defined in `Hyva\Checkout\Model\Component\SameAddressOrder`. Replace it with a DI preference to ask for the billing address first.

For more information, please refer to [merge request #570](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/570).

### Changed

- **Save Checkout Addresses to the Address Book on Order Placement**

Addresses entered by a logged in customer are kept in the checkout session and can be selected and switched between during checkout. They are added to the address book when the order is placed, if **Save in address book** is checked. The checkbox is now checked by default.

For more information, please refer to [merge request #570](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/570).

- **Rebuild the Coupon Code Component as a Form**

The coupon code component now extends `AbstractForm` and uses the `CouponCodeForm` entity form. `applyCouponCode()` and `revokeCouponCode()` are deprecated. Review any override of `checkout/coupon-code.phtml`.

For more information, please refer to [merge request #578](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/578).

- **Rework Checkout Styling to Match the Hyvä Default Theme on Tailwind v4**

Restructures the Tailwind sources, replaces the slate utilities with the semantic `ink` and `gray` equivalents and gives every border an explicit color, with older themes kept working through the `.v3` sources.

For more information, please refer to [merge request #590](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/590).

- **Replace Heroicons with Lucide Icons Across All Templates**

For more information, please refer to [merge request #590](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/590).

- **Update `hyva-themes/magento2-theme-module` from `^1.3.11` to `^1.3.16`**

Brings the minimum theme module version in line with the other Hyvä Commerce products.

For more information, please refer to [merge request #590](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/590).

- **Require Magewire `~3.7.2` and `hyva-themes/magento2-hyva-checkout-v1bc` `^1.0`**
- **Fix the Admin Configuration Tab Logo with `setup:static-content:deploy -s compact`**

The Hyvä Checkout logo in the admin configuration tab returned a 404 when static content was deployed with the compact strategy.

For more information, please refer to [merge request #607](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/607).

### Removed

- **Drop Tailwind v2 Support**

The checkout now only works with themes using Tailwind 3 and 4. Any older classes will not be compiled, which means the custom fallback classes are removed. Make sure you did not use any of those classes before upgrading.

For more information, please refer to [merge request #590](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/590).

- **Drop the `wire:auto-save` Directive**

The Checkout 1.x `wire:auto-save` directive, the "Auto Save" column of the address form fields and the autosave timeout setting are gone. Checkout 3 forms save on `dehydrate()` while `$autosave` is on, and on step navigation. The v1bc module provides the directive and the settings for checkouts that still depend on them.

## [1.4.0-beta6](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/1.4.0-beta5..1.4.0-beta6) - 2026-10-06

### Security

- **Update Magewire dependency**

Update the Magewire dependency to [v3.7.2 - Security release](https://github.com/magewirephp/magewire/releases/tag/3.7.2)

## [1.4.0-beta5](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/1.4.0-beta4..1.4.0-beta5) - 2026-09-22

### Changed

- **Guard validation registration against a null navigation step**

Logging in during checkout could throw `Failed to register validation '...': Cannot read properties of null (reading 'name')`. The validation registration now checks for an active navigation step before reading it.

For more information, please refer to [merge request #540](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/540).

Many thanks to Luuk Meijer (Emico) for the contribution!

- **Fix single line street fields rejecting autofilled values with commas**

With **Number of Lines in a Street Address** set to `1`, an autofilled street containing a comma was rejected with `"Street Address" cannot contain more then 1 lines.` and the address could not be saved.

For more information, please refer to [merge request #591](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/591).

- **Fix TypeError in ServerMemoConfig\Payment::getRedirectUrl() for non-string redirect URLs**

Payment methods returning a non-string value (for example `true`) from `getOrderPlaceRedirectUrl()` caused a fatal `strlen()` `TypeError` on the checkout page. Non-string redirect URLs are now handled gracefully.

For more information, please refer to [merge request #592](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/592).

Many thanks to Roman Pelenychko & Giacomo Moscardini (Webgriffe) for the contribution!

- **Replace x-html with x-text for customer login errors**

Alpine CSP 3.15.2 and newer reject the `x-html` directive and throw during component initialisation. Login errors are plain strings, so `x-text` keeps the message visible while remaining CSP compatible.

For more information, please refer to [merge request #593](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/593).

- **Reset region data when changing country**

Stale `region`, `region_id` and `region_code` values could remain on the quote address after switching to another country, which Magento's stricter quote address validation then rejects with `Invalid value "..." for field regionId.` The billing and shipping save services now normalise all three values against the selected country.

For more information, please refer to [merge request #594](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/594).

Many thanks to Christoph Hendreich (In-session) for the contribution!

- **Escape checkout agreement titles**

Checkout agreement titles were echoed raw, so markup in a condition name could break the checkout flow with `Evaluating a string as JavaScript violates the following Content Security Policy`. Titles are now escaped unless the agreement is flagged as HTML.

For more information, please refer to [merge request #595](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/595).

- **Report a failed order placement to the caller**

`hyvaCheckout.order.place()` resolved the same way whether the order was placed or the backend refused it, so a declined payment, insufficient stock or a gateway error all looked like a placed order. A placement that did not finish the navigation cycle now resolves with `false`, and no redirect to the success page takes place. A placed order resolves with `{result: true}`.

For more information, please refer to [merge request #597](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/597).

- **Address the topmost failing component on validation failure**

Stepping forward on a step that failed validation addressed the wrong component, scrolling past a failure that was still in view and focusing the first invalid field of the shipping address rather than the component that actually needed attention. Failing validations are now sorted by document position, and only the topmost one is scrolled to and focused. A component without an invalid field receives focus on its own container, so failures reported through the Evaluation API are covered too.

For more information, please refer to [merge request #601](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/601).

- **Merge checkout layout handles in page render order**

A checkout scoped layout handle could retarget a component template on the initial render, but the first Magewire re-render of that component brought back the Hyvä template, so switching a shipping or payment method visibly reverted the styling mid checkout. Component declaration handles are now merged before the active step handles, mirroring the page render, and the checkout page route handle is recovered for every component update.

For more information, please refer to [merge request #603](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/603).

Many thanks to Emils Malovka (Magebit) & Linass Joksass (Magebit) for the contribution!

## [1.4.0-beta4](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/1.4.0-beta3..1.4.0-beta4) - 2026-08-17

### Added

- **Add the cart item message to the order summary**

For more information, please refer to [merge request #551](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/551).

Many thanks to Thanh Hua (Jajuma) for the contribution!

### Changed

- **Added missing semicolon in text.phtml**

For more information, please refer to [merge request #567](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/567).

Many thanks to Christoph Hendreich (In-session) for the contribution!

- **Fix guest login on checkout when reCAPTCHA is enabled for Customer Login**

Fixed guest login failing on checkout ("ReCaptcha token element is missing") when reCAPTCHA is enabled for Customer Login, by attaching the `Hyva\Theme\ViewModel\ReCaptcha` view model to the `customer_form_login` block in `hyva_checkout_customer_account_login.xml`.

For more information, please refer to [merge request #567](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/567).

### Removed

- **Remove hyva\_checkout\_init\_after event from MethodList added in 1.4.0-beta2**

The dispatch of `hyva_checkout_init_after` has been removed from `src/Magewire/Checkout/Payment/MethodList.php`.

It was originally added in the `1.4.0-beta2` security release, but this event does not need to be triggered here and causes problems in certain scenarios.

For more information, please refer to [merge request #579](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/579).

## [1.4.0-beta3](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/1.4.0-beta2..1.4.0-beta3) - 2026-08-03

### Added

- **Reusable Progress Overlay for Blocking Checkout Actions**

Adds a non-closable, full-screen progress overlay (spinner, title, and message) that blocks all user interaction while a blocking action completes, typically right before a redirect, such as signing a customer in and returning them to the checkout.

For more information, please refer to [merge request #562](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/562).

- **Notification Evaluation Result**

Adds a `Notification` evaluation result (and `createNotification()` factory method) that surfaces a message through Magewire's notifier from within an evaluation result batch.

For more information, please refer to [merge request #562](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/562).

- **Expanded EAV Attribute Support in Checkout Address Forms**

Adds support for rendering and validating additional customer and customer address EAV attributes in the checkout billing and shipping address forms. The following frontend input types are now supported: Text Field, Text Area, Date, Dropdown, Yes/No (boolean), Multiple Select, and Multiline.

Only attributes associated with the `customer_register_address` form (as defined in the `customer_form_attribute` table) are shown on the storefront, all other EAV attributes are hidden. Each supported field type ships with its own validation rules, and Dropdown/Multiple Select fields now preselect their configured default value.

Please note that **File** and **Image** attribute input types are not supported.

For more information, please refer to [issue #223](https://gitlab.hyva.io/hyva-checkout/checkout/-/issues/223).

- **Data Patch: Migrate Legacy Address Form Configuration (`MigrateAddressConfig`)**

Introduces a data patch that migrates the legacy address form configuration to the new structure. For every scope (default, website and store) it:

```
1. Backs up the existing `eav_attribute_form_fields` JSON to a `..._legacy` config path so the change can be reverted.
2. Extracts the per-street-line `required` flags into dedicated flat config paths (backing the new per-line Required setting above).
3. Migrates any non-default `enabled`/`required` flags for the remaining fields into their own flat config paths.
4. Removes the now-migrated `enabled`/`required` keys from the JSON.
```

Each form and scope is migrated independently, so a failure in one does not block the others (failures are logged as warnings).

- **Data Patch: Remove Customer Attributes from Address Configuration (`RemoveCustomerAttributesFromAddressConfig`)**

Introduces a follow-up data patch (dependent on `MigrateAddressConfig`) that removes customer-entity attributes such as `dob`, `taxvat` and `gender` from the billing and shipping address form configuration. These attributes do not belong on an address form because they cannot be saved against an address entity, a customer holds a single value per attribute across multiple addresses, and guest customers have no customer entity. The `email` pseudo-field and all valid address attributes are preserved, and obsolete per-field config values for the removed attributes are cleaned up.

- **Console Command to Revert the Address Configuration Migration**

Adds `bin/magento hyva:checkout-attributes:restore` to roll back the migration by restoring the `..._legacy` backups. Supports a `--dry-run` (`-d`) option to preview the changes without applying them.

### Changed

- **Magewire 3.4 / Livewire v3 Compatibility**

Upgrades the Magewire dependency to `^3.4`.

- **Fix: Component Messages No Longer Cleared Prematurely**

A component's message is now cleared only when that same component reports a positive evaluation result.

- **Admin Address Field Configuration Changes**

The admin address-fields grid no longer exposes the **Enabled** and **Required** columns, both values are now derived directly from the underlying EAV attribute configuration rather than being set per field in checkout. The attribute list is now driven by the address attributes associated with the checkout registration form, and customer attributes are no longer loaded into the grid.

- **Data Persistence for Custom EAV Attributes Requires a Save Service on Magento Open Source**

Values captured for additional (custom) EAV attributes are rendered and validated in checkout but are **not persisted out of the box on Magento Open Source** — there is no save service for them, so a developer must integrate one to store the submitted values. On Adobe Commerce these values are saved automatically via the `Magento_CustomerCustomAttributes` module (Luma parity).

- **Graceful Redirect to Cart on Expired Checkout Session**

Adds centralised handling for expired or invalid checkout/cart sessions during Magewire checkout requests. Previously, once a session expired the stored quote id became stale and the next quote API call threw a `NoSuchEntityException`.

Please note that any exception which is **not** an expired cart is delegated to the default `ExceptionHandler`, so unrelated errors continue to render exactly as before.

For more information, please refer to [merge request #563](https://gitlab.hyva.io/hyva-checkout/checkout/-/merge_requests/563).

### Removed

- **"Enabled" and "Required" Toggles Removed from Admin Address Field Configuration**

Removes the ability to toggle **Enabled** and **Required** per field from the checkout admin configuration, these are now determined by the EAV attribute definition. The "Add field" button and the unused Custom CSS / Default Value columns have also been removed.

- **Customer Attributes Removed from Default Address Form Configuration**

The default billing and shipping address form configuration no longer includes the `dob`, `taxvat` and `gender` customer attributes (see the data patches above for existing installations).

## [1.4.0-beta2](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/1.4.0-beta1..1.4.0-beta2) - 2026-07-13

### Security

- **Fix Payment Method Availability Bypass via Magewire syncInput**

Merges the `1.3.12` security fix for the payment method availability bypass into the `1.4.0-beta` release line. The client-side payment method availability checks could be bypassed, allowing an unavailable or restricted method to be persisted to the quote. `MethodList::updatedMethod()` now writes through `PaymentMethodManagement::set()`, which validates availability before saving the method to the quote.

See the [1.3.12](changelog-1.x.html#1312-2026-07-13) entry for the full description.

## [1.4.0-beta1](https://gitlab.hyva.io/hyva-checkout/checkout/-/compare/1.3.11..1.4.0-beta1) - 2026-06-30

> **Note:** First beta on Magewire v3 — a large, mostly architectural release. The entries below group the changes that matter most to merchants and integrators.

### Added

- **Magewire v3 Extension Points**

Dedicated v3 hooks into the checkout framework: component resolvers (`HyvaCheckoutMainComponentResolver` and `HyvaCheckoutComponentResolver`, registered on Magewire's `ComponentResolverManager`) and lifecycle features (`SupportHyvaCheckoutConfig`/`Evaluation`/`Navigation` with matching hydrators) that hydrate checkout config, evaluation, and navigation state as first-class Magewire features. New `@internal` `CheckoutConfig`/`CheckoutConventions` models centralize layout handles, routes, and component method names.

- **"Shipping- & Billing Forms" Configuration Group**

New admin group with a **Log Deprecated Form Hook Usage** (`log_deprecated_hooks`) setting. When enabled (non-production only), a warning is logged to `var/log/system.log` whenever a deprecated `form:*` hook still has a listener, naming the modern hook to migrate to.

- **Disabled Field Styling and Lock Icon**

A `disabled-field` Tailwind component plus a lock icon in front of the label, so disabled/read-only fields read clearly.

- **`couponApplied` State on the Coupon Code Component**

`CouponCode` now exposes a `couponApplied` boolean (synced on boot, apply, and failure) that drives the input's applied styling and disabled state, instead of inferring it from `couponCode`.

- **`placeOrderButton()` Payment Method API Hook**

New `placeOrderButton()` method on the payment-method JS API returning `{ label }`, so the place-order button label can be customized per payment method.

- **Evaluation Processor Teardown Callbacks**

A custom evaluation processor may now return a teardown function, run when its result is superseded or the component is destroyed — a clean way to remove validations and other state without ad-hoc `message.received` hooks.

- **Expanded Automated Test Coverage**

Extensive new PHP integration tests and Playwright end-to-end specs (address book, coupon code, guest details, order comment, place-order failure, terms & conditions, purchase-order cross-step).

### Changed

- **Magewire v3 Compatibility**

Upgrades Hyvä Checkout to Magewire v3. Minimum PHP is now `>=8.2`, `magewirephp/magewire` is `3.2.0`, and two dedicated compatibility modules are pulled in:

```
- `magewirephp/magewire-hyva-theme` (`^3.0.1`) — bridges the Hyvä theme to v3 (flash-message support, backwards-compatibility emit/event JS, config observer, Tailwind/Alpine wiring).
- `magewirephp/magewire-hyva-checkout` (`^3.0`) — its `SupportHyvaCheckoutBackwardsCompatibility` feature re-emits the legacy client-side components, attributes, hooks, and events on the v3 lifecycle.
```

Component messaging also moved off the old `message.received` hook onto the new `*:magewire` lifecycle. For the framework changes, see the Magewire [CHANGELOG](https://github.com/magewirephp/magewire/blob/main/CHANGELOG.md) and [releases](https://github.com/magewirephp/magewire/releases).

- **Evaluation Pipeline on the v3 Request Lifecycle (Request Bundling)**

v3 bundles component updates into a single network round-trip. Evaluation results are now processed on the v3 `commit` → `succeed` hooks reading the new `effects.evaluation` payload, replacing the old `message.received`/`message.processed` hooks that read `serverMemo.evaluation`. Integrators with custom JS on the old `message.*` events or `serverMemo` must migrate to `commit`/`succeed` and the `effects` payload.

- **Alpine.js Now Provided by Magewire's Bundled Version**

Via `magewire-hyva-theme`, Magewire's bundled Alpine.js becomes the Alpine provider whenever Magewire is active — the theme's standalone Alpine.js is no longer loaded separately and is moved to load first so Alpine is ready before Magewire initializes. When Magewire is not driving the page, the theme's standalone Alpine.js is still rendered as a fallback.

- **Backwards Compatibility Layer for Magewire v3**

On top of the two compatibility modules, the checkout ships server-side BC wiring so existing integrations keep working: components (`CouponCode`, `GuestDetails`, `ShippingDetailsForm`, `BillingDetailsForm`) opt into Magewire's `SupportMagewireBackwardsCompatibility` via `#[HandleBackwardsCompatibility]`, and an `ArrayPropertyReconstructionResolver` (mapped for `AbstractMagewireAddressForm`'s `updatedAddress`/`updatingAddress`) rebuilds legacy array-style properties correctly under v3. The legacy `form:*` PHP hook contract is also preserved (see below).

- **Forms Driven by a New Magewire Form Abstraction**

Checkout forms are now driven by a reworked `AbstractForm` component (with `AbstractAddressForm` extending it), wired into the full v3 lifecycle. The hydrated form-data property is the source of truth, synced client-side via `formDataKey()`/`syncFormData()`, and each lifecycle step dispatches a modification hook.

This adds two hook layers: **entity-form hooks** (`form:*`) fired by `AbstractEntityForm`'s build pipeline for *every* form, and **Magewire component hooks** (`form:*:magewire`) fired by the new components on each lifecycle step (the component is passed as the second arg). The full `:magewire` set — `construct`, `loaded` (replaces the deprecated `form:fill`), `boot`/`booted`, `hydrate`/`dehydrate`, `updating`(`:data`/`:data:<path>`), `updated`(`:data`/`:data:<path>`), `submitting`, `trigger`(`:<method>`/`:submit`), `execute:submit` (deprecated alias), `build`, plus the address-only `action:create`/`action:edit` — is documented with fire timing and arguments in `src/Model/Form/EntityFormModifier/form_hooks.md`. Prefer the `*:magewire` hooks for new code.

- **Consolidated Shipping and Billing Address Form Components**

The nested `ShippingDetails\AddressForm` / `BillingDetails\AddressForm` components are replaced by top-level `ShippingDetailsForm` / `BillingDetailsForm`, both rendered through a single unified `magewire/component/form.phtml` template.

- **Reworked Form Modifiers and Client-Side Address Binding**

Address forms now bind client-side via Alpine, with the country field syncing immediately so dependent components refresh. New `WithCountryModifier` (applies the default country and notifies dependents on change), new `MagewireAddressModifier` and `WithBaseMagewireAttributesModifier`, and reworked `WithRegionModifier`/`WithAuthenticationModifier`/`WithBaseAttributesModifier`.

- **Preserve Legacy `form:*` Hook Contract Under Magewire v3**

`AbstractAddressForm` re-emits the legacy hooks with the same names, arguments, and order so third-party modifiers keep working: the `guest_`/`customer_`-prefixed `*_address_submitted`/`_saved` (and `*_address_added` on new addresses), with listeners made variadic-tolerant. Also fixes `form:action:edit` / `form:<type>:action:edit` to pass `$address` again and stops double-firing `form:build`.

- **Fix Evaluation Results Leaking Across Checkout Steps**

Fixes two causes of results leaking between steps (e.g. the Purchase Order "required" message showing on the shipping step): a `step_history` desync where a navigation pushed the target step twice (so `getBeforeLatest()` returned the wrong step — non-Main responses no longer overwrite navigator state), and evaluation cleanup, now a per-processor teardown run when a result changes instead of repeatedly registered `message.received` hooks. Adds a Playwright regression test for the shipping → payment → back → change-country flow.

- **Fix Empty Purchase Order Number Validation**

The updated-hook now assigns the normalized (`trim()`-ed) value back to `purchaseOrderNumber` — previously discarded — so a whitespace-only or emptied field is correctly treated as incomplete.

- **Fix Stale Region When Changing Country**

`WithRegionModifier` now clears an orphaned `region_id` when switching to a country without regions (keeping free-text regions) and drops a region that no longer maps to a valid option. Region options are applied on `form:loaded:magewire` (before the data sync) so a saved region pre-selects correctly when returning to checkout.

- **Fix New (Non–Address-Book) Shipping Address Not Selected in the List**

The active address entity is always cast (null → `0`), so a newly entered address not saved to the address book becomes the selected `value="0"` option instead of leaving a previous entry checked.

- **Fix DOM Clobbering for Fields Named `id`, `name`, `submit`, …**

Fields whose name matches a reserved `HTMLFormElement` property are now namespaced (`<namespace>-<name>`), preventing DOM clobbering that broke scripts reading e.g. `formElement.id`. Affects custom EAV attributes using those names.

- **Improve Guest Email Customer-Existence Check**

The existing-customer lookup no longer round-trips on every keystroke — it's debounced, fires only on a complete valid email (and is skipped during a `magewire:update`), and restores focus to the email field after re-render so revealing the password field no longer moves the cursor.

- **Fix Address Modal Being Re-Populated Mid-Edit**

The form is no longer auto-filled with the active address while the modal is open (and is now resolved lazily), preventing in-progress input from being clobbered.

- **Skip Saving Forms With No Changed Values**

`submit()` early-returns when a form's tracked values are unchanged, so a form with no edits is no longer re-saved.

- **Layout and Rendering Tweaks**

The Main component declares an explicit `magewire:resolver` (small perf win), the navigation loader spinner uses the v3 loading-icon template, and the Magewire error-plugin block moved from `hyva_checkout.xml` to `hyva_checkout_index_index.xml` (relocation only).

### Removed

- **Timer-Based Per-Change Autosave on the Shipping and Billing Address Forms**

The new `ShippingDetailsForm` / `BillingDetailsForm` no longer autosave on every field change (the old `autoSaveTimeout` ~3s debounce with the `saveAction => 'autosave'` request and `canAutoSave()` guard). The address binds client-side and is persisted on `dehydrate` and on step submit; only the country field still syncs immediately to refresh dependent shipping-method and totals components. The deprecated `AbstractMagewireAddressForm`-based components keep the old autosave for backwards compatibility.
