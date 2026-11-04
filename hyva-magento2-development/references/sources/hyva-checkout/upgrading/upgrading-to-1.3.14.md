<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.14.html -->

# Upgrading to 1.3.14

This is a maintenance release focused on important bug fixes.

Please refer to the [changelog](changelog-1.x.html#1314-2026-09-15) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.14
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No Deprecations.

## Template changes

- src/view/frontend/templates/page/js/api/v1/directive/navigation.phtml
- src/view/frontend/templates/page/js/api/v1/init-payment.phtml
- src/view/frontend/templates/page/js/api/v1.phtml
- src/view/frontend/templates/checkout/terms-conditions/list.phtml
- src/view/frontend/templates/overrides/Magento\_Customer/form/login.phtml
- src/view/frontend/templates/page/js/api/v1/init-validation.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog-1.x.html#1314-2026-09-15).
