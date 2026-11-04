<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-3.0.0-beta1.html -->

# Upgrading to 3.0.0-beta1

Beta release - not for production use

Hyvä Checkout `3.0.0-beta1` is a beta intended for testing and evaluation only. Do **not** run it on a production store. Install it in a development or staging environment so you can validate the new behavior ahead of a stable release.

Hyvä Checkout 3.0.0 is available

The stable 3.0.0 release supersedes this beta. See [Upgrading to 3.0.0](upgrading-to-3.0.0.html).

First 3.0.0 beta release of Hyvä Checkout on Magewire v3

`3.0.0-beta1` follows the `1.4.0-beta` releases. The 1.3.x line stays on Magewire v1 and receives the same features in [1.3.15](upgrading-to-1.3.15.html).

Allow beta releases in the project's `composer.json` (`"minimum-stability": "beta"`, with `"prefer-stable": true`) before installing it.

Checkouts that use components or integrations written for Magewire v1 use the separate `hyva-themes/magento2-hyva-checkout-v1bc` backward compatibility module. Depending on that, you can [keep or disable it](upgrading-to-3.0.0-beta1.html#keep-or-disable-the-magewire-v1-backward-compatibility-module).

This release adds Google reCAPTCHA support, a postcode format validation setting and changes to how checkout addresses are saved. It also updates the checkout styling to match the Hyvä default theme.

Please refer to the [changelog](changelog.html#300-beta1-2026-10-12) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:3.0.0-beta1
```

## Keep or Disable the Magewire v1 Backward Compatibility Module

If your checkout uses components or integrations written for Magewire v1, keep the `hyva-themes/magento2-hyva-checkout-v1bc` module. It provides backward compatibility so they keep working on Magewire v3.

If your checkout uses no Magewire v1 components or integrations, you can disable it.

```
bin/magento module:disable Hyva_CheckoutMwv1bc
bin/magento setup:upgrade
```

The module is renamed to `Hyva_CheckoutV1bc` in [3.0.0](upgrading-to-3.0.0.html#renamed-magewire-v1-backward-compatibility-module).

## Backward Incompatible Changes

- When upgrading from 1.3.x, the checkout moves from Magewire v1 to Magewire v3 and requires PHP 8.2 or newer. See the [1.4.0-beta1 changelog](changelog.html#140-beta1-2026-06-30) for the changes this brings.
- Requires `magewirephp/magewire` `~3.7.2` and `hyva-themes/magento2-hyva-checkout-v1bc` `^1.0`.
- Tailwind v2 is no longer supported. The checkout requires a theme using Tailwind 3 or 4.
- The minimum `hyva-themes/magento2-theme-module` version is now `^1.3.16`.
- The coupon code component is rebuilt as a form. Review any override of `checkout/coupon-code.phtml` or customization of `Hyva\Checkout\Magewire\Checkout\CouponCode`.
- Checkout and step names that produce a layout handle ending in `stepfirst` or `steplast` are no longer allowed.

## Deprecations

- `Hyva\Checkout\Magewire\Checkout\CouponCode::applyCouponCode()` and `revokeCouponCode()` are deprecated.

## Template changes

Compared to `1.4.0-beta6`:

New templates:

- src/view/frontend/templates/checkout/address-view/entity-details.phtml
- src/view/frontend/templates/checkout/address-view/same-address-toggle.phtml
- src/view/frontend/templates/checkout/address-view/shipping-details/address.phtml
- src/view/frontend/templates/checkout/coupon-code/apply-revoke-button.phtml
- src/view/frontend/templates/checkout/coupon-code/coupon-code-field.phtml
- src/view/frontend/templates/checkout/place-order-recaptcha.phtml
- src/view/frontend/templates/form/element/recaptcha.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-coupon-code.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/place-order-recaptcha.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/recaptcha.phtml
- src/view/frontend/templates/page/js/checkout-form-postcode-validation.phtml
- src/view/frontend/templates/page/js/checkout-form-recaptcha-validation.phtml

Updated templates:

- src/view/frontend/templates/breadcrumbs.phtml
- src/view/frontend/templates/breadcrumbs/progress-bar.phtml
- src/view/frontend/templates/breadcrumbs/waypoints.phtml
- src/view/frontend/templates/checkout/address-view/address-form.phtml
- src/view/frontend/templates/checkout/address-view/address-form/field/save-address-book/label.phtml
- src/view/frontend/templates/checkout/address-view/address-list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/form.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/address-view/address-list/list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/select.phtml
- src/view/frontend/templates/checkout/address-view/billing-details.phtml
- src/view/frontend/templates/checkout/address-view/billing-details/address.phtml
- src/view/frontend/templates/checkout/address-view/shipping-details.phtml
- src/view/frontend/templates/checkout/coupon-code.phtml
- src/view/frontend/templates/checkout/customer-comment.phtml
- src/view/frontend/templates/checkout/payment/method-list.phtml
- src/view/frontend/templates/checkout/payment/method/checkmo.phtml
- src/view/frontend/templates/checkout/payment/method/purchaseorder.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items/type/default.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/grand-total-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/tax-grandtotal-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/grand-total.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/shipping.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/subtotal.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/tax.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/weee.phtml
- src/view/frontend/templates/checkout/shipping-summary.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/checkout/terms-conditions/list.phtml
- src/view/frontend/templates/form/element/html/comment.phtml
- src/view/frontend/templates/form/element/html/icon.phtml
- src/view/frontend/templates/form/element/html/label.phtml
- src/view/frontend/templates/form/field/checkbox.phtml
- src/view/frontend/templates/form/field/html/hint-text.phtml
- src/view/frontend/templates/form/field/html/tooltip.phtml
- src/view/frontend/templates/form/field/password.phtml
- src/view/frontend/templates/form/field/radio.phtml
- src/view/frontend/templates/form/field/select.phtml
- src/view/frontend/templates/form/field/street.phtml
- src/view/frontend/templates/form/field/text.phtml
- src/view/frontend/templates/layout/2columns.phtml
- src/view/frontend/templates/layout/3columns.phtml
- src/view/frontend/templates/magewire/component/form.phtml
- src/view/frontend/templates/main/place-order/redirect.phtml
- src/view/frontend/templates/navigation/history.phtml
- src/view/frontend/templates/navigation/place-order.phtml
- src/view/frontend/templates/overrides/Magento\_Customer/form/login.phtml
- src/view/frontend/templates/page/header/checkout-header.phtml
- src/view/frontend/templates/page/header/logo.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-view/address-list.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/coupon-code.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/customer-comment.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/evaluation-redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/terms-conditions.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/multi-tabs-compatibility.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/init-config.phtml
- src/view/frontend/templates/page/js/api/v1/message/dialog.phtml
- src/view/frontend/templates/page/js/magewire/plugin/error.phtml
- src/view/frontend/templates/page/messenger.phtml
- src/view/frontend/templates/section/title.phtml

If you override any of these templates in a child theme, review your overrides against the new versions.

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html#300-beta1-2026-10-12).
