<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.1.html -->

# Upgrading to 1.3.1

This release introduces PHP `8.4` + Magento `2.4.8` support, redirect-only payment compatibility, dynamic payment method handling, improvements to Alpine component loading, mobile UX, auto-save for form inputs, and a new "Free Shipping" label option.

Alongside several other important fixes improvements.

Please refer to the [changelog](changelog.html#131-2025-05-08) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.1
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- src/view/frontend/templates/checkout/payment/method-list-activate.phtml (Deleted)
- src/view/frontend/templates/checkout/shipping/method-list-activate.phtml (Deleted)

## Templates changes

- src/view/frontend/templates/page/js/api/v1/init.phtml
- src/view/frontend/templates/page/js/api/v1/init-payment.phtml
- src/view/frontend/templates/page/js/api/v1/init-shipping.phtml
- src/view/frontend/templates/page/js/api/v1/init-navigation.phtml
- src/view/frontend/templates/page/js/api/v1.phtml
- src/view/frontend/templates/page/js/magewire/directive/auto-save.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/shipping-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/shipping.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/checkout/address-view/address-list.phtml
- src/view/frontend/templates/checkout/payment/method-list-activate.phtml (Deleted)
- src/view/frontend/templates/checkout/shipping/method-list-activate.phtml (Deleted)
- src/view/frontend/templates/checkout/payment/method-list.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/shipping/method-option.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/checkout-loader.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/evaluation-redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/form-element-tool-tip.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/message-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/navigation-component.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/executables/page.phtml
- src/view/frontend/templates/page/js/api/v1/message/dialog.phtml
- src/view/frontend/templates/page/js/api/v1/init-evaluation.phtml

For this release, we moved all `-js.phtml` suffixed templates to a more structured location under `src/view/frontend/templates/page/js/api/v1/alpinejs/`. Below are the updated paths:

Upgrading to `1.3.1` from `1.3.0`

This information is relevant only if you are upgrading directly from version `1.3.0` to `1.3.1`.

- src/view/frontend/templates/checkout/address-view/address-list-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/address-view/address-list.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/tax-grandtotal-details-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/price-summary/total-segments/extension-attributes/tax-grand-total-details.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/address-view/address-list/saved-address-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/shipping/method-activate.phtml
- src/view/frontend/templates/breadcrumbs/breadcrumbs-navigation-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/breadcrumbs-navigation.phtml
- src/view/frontend/templates/checkout/coupon-code-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/coupon-code.phtml
- src/view/frontend/templates/checkout/customer-comment-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/customer-comment.phtml
- src/view/frontend/templates/form/field/password-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/password-visibility.phtml
- src/view/frontend/templates/checkout/terms-conditions-js.phtml → src/view/frontend/templates/page/js/api/v1/alpinejs/terms-conditions.phtml

## Translation changes

- No translation changes.

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
