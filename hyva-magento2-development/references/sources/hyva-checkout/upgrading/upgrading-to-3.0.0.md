<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-3.0.0.html -->

# Upgrading to 3.0.0

Hyvä Checkout 3.0.0 is the first stable release of Hyvä Checkout on Magewire v3, following `3.0.0-beta1`. The 1.3.x line stays on Magewire v1, see [Release Lines and Magewire Versions](../getting-started/release-lines.html).

This release refuses guest orders where Magento doesn't allow guest checkout, restores compatibility with more Checkout 1.3 customizations, and fixes the findings of the 3.0 API contract tests and the release review. Read [What Merchants Will Notice](#what-merchants-will-notice) first. The [changelog](changelog.html#300-2026-10-27) has the details.

Hyvä Checkout 3.0.0 installs the Magewire 1 backward compatibility module `hyva-themes/magento2-hyva-checkout-v1bc`, so components, templates and integrations written for Checkout 1.x keep working in almost all cases. See [What Is the v1bc Module in Hyvä Checkout?](../faq/what-is-v1bc.html) for a short explanation, and [The Magewire 1 Backward Compatibility Module (v1bc)](../magewire/v1bc.html) for the details.

Hyvä Enterprise and Checkout 3.x

Hyvä Enterprise projects upgrade together with the releases of `hyva-themes/magento2-ee-hyva-enterprise-checkout`, and of `hyva-themes/magento2-ee-hyva-enterprise-checkout-b2b` where used, that support Checkout 3. Earlier releases of these modules require Checkout 1.3.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä Checkout first. Then run:

```
composer require hyva-themes/magento2-hyva-checkout:^3.0 --update-with-dependencies
bin/magento setup:upgrade
```

Use `composer require` rather than `composer update`: an existing `^1.3` or beta constraint in `composer.json` has to be replaced, and `composer update` only accepts a version within the current constraint. The command also updates the v1bc module, whose release 1.0.0 requires Hyvä Checkout 3.0.0.

If you allowed beta releases for a 3.0.0 or 1.4.0 beta (`"minimum-stability": "beta"`), you can return to your previous setting once no other package needs it.

## What Merchants Will Notice

These changes apply to every upgrade, from Checkout 1.x and from a beta:

- **Guests can't place an order where Magento doesn't allow guest checkout.** This includes carts with downloadable products under Magento's default "Disable Guest Checkout if Cart Contains Downloadable Items: Yes": the one page checkout refuses such a guest at Place Order with "Please sign in or create an account to place this order.". If guests should be able to check out, check "Allow Guest Checkout" (**Stores > Configuration > Sales > Checkout > Checkout Options**) and "Disable Guest Checkout if Cart Contains Downloadable Items" (**Stores > Configuration > Catalog > Catalog > Downloadable Product Options**). With "Enable Onepage Checkout" off, the checkout redirects to the cart, as Magento's own checkout does.
- **The Place Order reCAPTCHA applies to orders placed through the checkout**, and to other placements of a cart whose checkout showed the challenge. PayPal Express from the cart and Instant Purchase work again while it's enabled. Payment modules with a place order endpoint of their own, see the [changelog entry](changelog.html#300-2026-10-27).
- **In Magento's default mode, customers no longer see error details.** A failed request offers to reload the page. Developer mode still shows the server's error output.
- **A zero tax line is hidden** unless **Sales > Tax > Shopping Cart Display Settings > Display Zero Tax Subtotal** is "Yes".
- **The new phrase "Edit Address: %1"** names the Edit buttons of the address list. Add it to your store's translations.
- **The debug mode (Developer > Debug > Mode) now takes effect when saved for a website or store view.** Check for values saved there.
- **REST cart totals no longer carry Hyvä's tax details**, because Hyvä's totals plugin now runs on the storefront only.
- **Payment integrations:** after each refresh of the payment method list, the checkout activates the method saved on the quote. A method activated only in the browser, without saving it to the quote, is switched back.

## Upgrading From Checkout 1.x

### Backward Incompatible Changes

- The checkout moves from Magewire 1 to Magewire 3 and requires PHP 8.2 or newer. See the [1.4.0-beta1 changelog](changelog.html#140-beta1-2026-06-30) for the changes this brings.
- Requires `magewirephp/magewire` `~3.7.2` and `hyva-themes/magento2-hyva-checkout-v1bc` `^1.0`.
- Tailwind v2 is no longer supported. The checkout requires a theme using Tailwind 3 or 4.
- The minimum `hyva-themes/magento2-theme-module` version is `^1.3.16`.
- The coupon code component is rebuilt as a form. Review any override of `checkout/coupon-code.phtml` or customization of `Hyva\Checkout\Magewire\Checkout\CouponCode`.
- Checkout and step names that produce a layout handle ending in `stepfirst` or `steplast` are no longer allowed.
- `submit()` of every Form API form now refuses an empty required field on the server, also a custom form extending `AbstractForm` that was written for 1.x. Override `requiresOnSubmit()` to opt a field out.
- The `hyva_checkout_layout_process_before` events are dispatched now. They were documented but never dispatched on 1.x, so existing observers of them start running.
- Magewire only starts on checkout pages. A page outside the checkout that renders Magewire components, for example a payment status page, needs `<update handle="hyva_checkout_magewire_startup"/>` in its layout. See [Components on a Module's Own Pages](../magewire/migrating-to-magewire-3.html#components-on-a-modules-own-pages).

### Customizations That Need a Change

Most Checkout 1.3 code keeps working through v1bc. These changes can't serve 1.3 and 3.0 code alike:

- **Observers of `magewire_<event>` Magento events**, such as `magewire_shipping_method_selected`, only run while `Hyva_CheckoutV1bc` is enabled. Move them to a `hyva_checkout_*` event or a component event before you disable the module.
- **Form modifier listeners typed on the 1.x address form classes** (`AbstractMagewireAddressForm`, `MagewireAddressFormInterface`) are logged and skipped. Leave the component parameter untyped, see [Listener Type Hints](../devdocs/form-api/form-modification-hooks.html#listener-type-hints-on-checkout-3x).
- **A form modifier that makes an address or guest details field live with a plain `wire:model`**, for example for a postcode lookup, has to set `wire:model.live`. On these forms, a plain `wire:model` stays deferred, also with v1bc. Checkout 1.x treats `wire:model.live` like a plain `wire:model`, so the same modifier works on both release lines.
- **`AbstractForm` subclasses** that override `updating()` or `updated()` with the 1.x signature `($value, string $name)`, or call `parent::updatingData()` or `parent::updatedData()`, have to change. A `parent::mount()` call works while v1bc is enabled. Remove it before you disable v1bc.
- **Overrides with a 1.3 signature** of the methods listed below no longer load. Change them to the 3.0 signatures shown.

Methods and constructors whose signature changed

- `AbstractEntityForm::init(?callable $callback = null)`, `AbstractAddressForm::edit($id = null)`, `EvaluationResultFactory::createEvent(?string $event = null)` and `WithAttributes::removeAttributesStartingWith(string $prefix): static`
- `WithBaseMagewireAttributesModifier` extends `AbstractEntityFormModifier` (`apply(AbstractEntityForm): AbstractEntityForm`) instead of implementing `EntityFormModifierInterface`
- `MagewireAddressModifier`: `$serializer` and `$escaper` are `protected readonly` constructor properties, and `applyHyvaValidationApiModifications()` and `applyCountryModifications()` take an `AbstractForm`
- The Magewire `ShippingDetailsForm` constructor has no `$form` parameter
- `AbstractEntityFormElement::removeRelative()` names its parameter `$element`. Overrides still load; only callers that pass it as a named argument need a change

For changes at the Magewire level, such as scripts a re-render adds or `emit()` with several arguments, see [Supporting Checkout 1.x and Checkout 3.x With v1bc](../magewire/migrating-to-magewire-3.html#supporting-checkout-1x-and-checkout-3x-with-v1bc).

### Deprecations

- `Hyva\Checkout\Magewire\Checkout\CouponCode::applyCouponCode()` and `revokeCouponCode()` are deprecated.
- 3.0.0 also deprecates a few Checkout 1.x leftovers and two `ProgressOverlay` methods. See the [changelog](changelog.html#300-2026-10-27).

### After the Upgrade

Test every checkout integration on a development or staging environment. Code that reads the internals of core checkout components works through emulation.

Once none of your components or integrations need Magewire 1, you can [disable the v1bc module](../magewire/v1bc.html#disabling-the-v1bc-module). Move observers of `magewire_<event>` events first: the check for Checkout 1.x code doesn't report them.

## Upgrading From a 3.0.0 or 1.4.0 Beta

Also read [What Merchants Will Notice](#what-merchants-will-notice) and [Customizations That Need a Change](#customizations-that-need-a-change): both apply to beta users too.

### Renamed Magewire v1 Backward Compatibility Module

The module in `hyva-themes/magento2-hyva-checkout-v1bc` is renamed from `Hyva_CheckoutMwv1bc` to `Hyva_CheckoutV1bc`. Hyvä Checkout recognizes both names.

- `bin/magento setup:upgrade` enables `Hyva_CheckoutV1bc` and removes `Hyva_CheckoutMwv1bc` from `app/etc/config.php`.
- If you disabled `Hyva_CheckoutMwv1bc`, disable the renamed module again after the upgrade:

  ```
  bin/magento module:disable Hyva_CheckoutV1bc
  bin/magento setup:upgrade
  ```
- Update code that references one of the old names, for example a layout file that moves one of the module's blocks: the namespace is now `Hyva\CheckoutV1bc\`, the layout handles `hyva_checkout_v1bc_*` and the block names `hyva.checkout.v1bc.*`.

### Backward Incompatible Changes Since 3.0.0-beta1

- Magewire's scripts, styles, notifier and loading indicator are removed from pages where Magewire isn't started. A module page that renders Magewire components adds the `hyva_checkout_magewire_startup` handle, see [Components on a Module's Own Pages](../magewire/migrating-to-magewire-3.html#components-on-a-modules-own-pages).
- The shipping and billing address forms now ignore identifying fields such as `id` and `quote_id` in the submitted form data. Customizations that set these fields through the address form data no longer work.
- `submit()` of every Form API form now refuses an empty required field on the server. Override `requiresOnSubmit()` to opt a field out.
- The `hyva_checkout_layout_process_before` events are dispatched now, so existing observers of them start running.
- `$uncallables` and `getUncallables()` are enforced again for every component: a template that calls a listed method from the browser (`wire:click`, `$wire.call()`) now fails.
- `form:trigger:submit:magewire` and `form:execute:submit:magewire` also fire after a failed save. Check `$exception` in listeners that assume the save succeeded.
- `hyvaCheckout.order.place()` resolves `false` when a payment method's `canPlaceOrder()` held the order and nothing redirects.
- `hyvaCheckout.evaluation.run()` resolves after the result is processed, and rejects when processing fails.
- With v1bc, a plain `wire:model` on the address and guest details forms stays deferred. In the betas, v1bc made it live.
- A beta override of `AbstractForm::dispatchFormModificationHook()` that declares `static` and returns the parent's result must declare no return type, or `AbstractEntityForm`.
- `Hyva\Checkout\Model\Component\SameAddressOrder` is no longer marked `@api`. Collecting the billing address first is experimental in this release and may change in a later release.

## Template Changes

If you override any of the templates below in a child theme, review your overrides against the new versions.

Templates changed compared to 3.0.0-beta1 (1 new, 50 updated, 2 removed)

New templates:

- src/view/frontend/templates/form/field/html/visibility-toggle.phtml

Updated templates:

- src/view/frontend/templates/checkout/address-view/address-list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/address-view/address-list/list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/select.phtml
- src/view/frontend/templates/checkout/coupon-code.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items/type/default.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/tax.phtml
- src/view/frontend/templates/form/field/checkbox.phtml
- src/view/frontend/templates/form/field/date.phtml
- src/view/frontend/templates/form/field/multiline.phtml
- src/view/frontend/templates/form/field/multiselect.phtml
- src/view/frontend/templates/form/field/password.phtml
- src/view/frontend/templates/form/field/radio.phtml
- src/view/frontend/templates/form/field/select.phtml
- src/view/frontend/templates/form/field/street.phtml
- src/view/frontend/templates/form/field/text.phtml
- src/view/frontend/templates/form/field/textarea.phtml
- src/view/frontend/templates/magewire/component/form.phtml
- src/view/frontend/templates/navigation/place-order.phtml
- src/view/frontend/templates/overrides/Magento\_Customer/form/login-component.phtml
- src/view/frontend/templates/page/js/api/v1.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-view/address-list.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/checkout-loader.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/customer-comment.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-guest-details.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/message-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/navigation-component.phtml
- src/view/frontend/templates/page/js/api/v1/directive/navigation.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/deferable-dialog-events.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/progress-overlay.phtml
- src/view/frontend/templates/page/js/api/v1/init-config.phtml
- src/view/frontend/templates/page/js/api/v1/init-evaluation.phtml
- src/view/frontend/templates/page/js/api/v1/init-message.phtml
- src/view/frontend/templates/page/js/api/v1/init-navigation.phtml
- src/view/frontend/templates/page/js/api/v1/init-payment.phtml
- src/view/frontend/templates/page/js/api/v1/init-validation.phtml
- src/view/frontend/templates/page/js/api/v1/init.phtml
- src/view/frontend/templates/page/js/api/v1/message/dialog.phtml
- src/view/frontend/templates/page/js/api/v1/validation/cascading-step-validation.phtml
- src/view/frontend/templates/page/js/magewire/plugin/error.phtml
- src/view/frontend/templates/page/js/magewire/startup/events.phtml
- src/view/frontend/templates/page/js/magewire/startup/flash-messages.phtml
- src/view/frontend/templates/page/js/magewire/startup/missing-warning.phtml
- src/view/frontend/templates/page/js/magewire/startup/runtime.phtml
- src/view/frontend/templates/page/js/magewire/startup/script.phtml
- src/view/frontend/templates/page/js/magewire/v1-detection.phtml

Removed templates:

- src/view/frontend/templates/checkout/address-view/address-list/form.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/multi-tabs-compatibility.phtml

Templates changed compared to 1.3.15 (12 new, 56 updated, 4 removed)

New templates:

- src/view/frontend/templates/form/field/html/visibility-toggle.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-address-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-billing-details.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-shipping-details.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/progress-overlay.phtml
- src/view/frontend/templates/page/js/magewire/startup/alpinejs.phtml
- src/view/frontend/templates/page/js/magewire/startup/events.phtml
- src/view/frontend/templates/page/js/magewire/startup/flash-messages.phtml
- src/view/frontend/templates/page/js/magewire/startup/missing-warning.phtml
- src/view/frontend/templates/page/js/magewire/startup/runtime.phtml
- src/view/frontend/templates/page/js/magewire/startup/script.phtml
- src/view/frontend/templates/page/js/magewire/v1-detection.phtml

Updated templates:

- src/view/frontend/templates/checkout/address-view/address-list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/address-view/address-list/list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/select.phtml
- src/view/frontend/templates/checkout/address-view/same-address-toggle.phtml
- src/view/frontend/templates/checkout/coupon-code.phtml
- src/view/frontend/templates/checkout/customer-comment.phtml
- src/view/frontend/templates/checkout/payment/method-list.phtml
- src/view/frontend/templates/checkout/payment/method/purchaseorder.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items/type/default.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/discount.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/tax.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/checkout/terms-conditions/list.phtml
- src/view/frontend/templates/form/field/checkbox.phtml
- src/view/frontend/templates/form/field/date.phtml
- src/view/frontend/templates/form/field/multiline.phtml
- src/view/frontend/templates/form/field/multiselect.phtml
- src/view/frontend/templates/form/field/password.phtml
- src/view/frontend/templates/form/field/radio.phtml
- src/view/frontend/templates/form/field/select.phtml
- src/view/frontend/templates/form/field/street.phtml
- src/view/frontend/templates/form/field/text.phtml
- src/view/frontend/templates/form/field/textarea.phtml
- src/view/frontend/templates/html/loader/spinner.phtml
- src/view/frontend/templates/magewire/component/form.phtml
- src/view/frontend/templates/navigation/place-order.phtml
- src/view/frontend/templates/overrides/Magento\_Customer/form/login-component.phtml
- src/view/frontend/templates/page/js/api/v1.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-view/address-list.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/checkout-loader.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/coupon-code.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/customer-comment.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-guest-details.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/message-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/navigation-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/password-visibility.phtml
- src/view/frontend/templates/page/js/api/v1/directive/navigation.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/deferable-dialog-events.phtml
- src/view/frontend/templates/page/js/api/v1/init-config.phtml
- src/view/frontend/templates/page/js/api/v1/init-evaluation.phtml
- src/view/frontend/templates/page/js/api/v1/init-message.phtml
- src/view/frontend/templates/page/js/api/v1/init-navigation.phtml
- src/view/frontend/templates/page/js/api/v1/init-payment.phtml
- src/view/frontend/templates/page/js/api/v1/init-shipping.phtml
- src/view/frontend/templates/page/js/api/v1/init-validation.phtml
- src/view/frontend/templates/page/js/api/v1/init.phtml
- src/view/frontend/templates/page/js/api/v1/message/dialog.phtml
- src/view/frontend/templates/page/js/api/v1/validation/cascading-step-validation.phtml
- src/view/frontend/templates/page/js/checkout-form-validation.phtml
- src/view/frontend/templates/page/js/magewire/directive/multiselect.phtml
- src/view/frontend/templates/page/js/magewire/plugin/error.phtml

Removed templates:

- src/view/frontend/templates/checkout/address-view/address-list/form.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/multi-tabs-compatibility.phtml
- src/view/frontend/templates/page/js/magewire/directive/auto-save.phtml
- src/view/frontend/templates/page/loader/spinner.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html#300-2026-10-27).
