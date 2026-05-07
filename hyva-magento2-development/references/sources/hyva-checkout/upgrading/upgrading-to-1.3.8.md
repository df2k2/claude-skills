<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.8.html -->

# Upgrading to 1.3.8

This release is a maintenance release, mostly focused on bug fixes.

Please refer to the [changelog](changelog.html#138-2025-12-15) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.8
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No deprecations

## Notable Template Changes

These templates include key frontend logic updates that must be applied during the upgrade.

- src/view/frontend/templates/checkout/shipping/method-list.phtml

## Template changes

- src/view/frontend/templates/checkout/address-view/billing-details.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
