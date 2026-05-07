<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.5.html -->

# Upgrading to 1.3.5

This release is a maintenance release, mostly focused on bug fixes.

Please refer to the [changelog](changelog.html#135-2025-09-18) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.5
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No deprecations

## Template changes

- src/view/frontend/templates/checkout/price-summary/cart-items/type/default.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/checkout/payment/method-list.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
