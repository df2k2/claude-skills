<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.4.0-beta5.html -->

# Upgrading to 1.4.0-beta5

Beta release - not for production use

Hyvä Checkout `1.4.0-beta5` is a beta intended for testing and evaluation only. Do **not** run it on a production store. Install it in a development or staging environment so you can validate the new behavior ahead of a stable release.

This is a maintenance release focused on important bug fixes.

Please refer to the [changelog](changelog.html#140-beta5-2026-09-22) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.4.0-beta5
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

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html#140-beta5-2026-09-22).
