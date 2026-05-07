<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.6.html -->

# Upgrading to 1.3.6

The key highlight is the new Frontend JavaScript Payment API, which provides a more robust and flexible way to build JS-driven payment methods, greatly improving the developer experience.

Please refer to the [changelog](changelog.html#136-2025-11-04) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.6
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No deprecations

## Template changes

- src/view/frontend/templates/page/js/api/v1/alpinejs/terms-conditions.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/debug/tests.phtml
- src/view/frontend/templates/page/js/api/v1/directive/navigation.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/executables/browser.phtml
- src/view/frontend/templates/page/js/api/v1/navigation/browser-history.phtml
- src/view/frontend/templates/page/js/api/v1/validation/cascading-step-validation.phtml
- src/view/frontend/templates/page/js/api/v1/init-config.phtml
- src/view/frontend/templates/page/js/api/v1/init-debug.phtml
- src/view/frontend/templates/page/js/api/v1/init-evaluation.phtml
- src/view/frontend/templates/page/js/api/v1/init-navigation.phtml
- src/view/frontend/templates/page/js/api/v1/init-payment.phtml
- src/view/frontend/templates/page/js/api/v1/init.phtml
- src/view/frontend/templates/page/js/api/v1.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
