<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.2.html -->

# Upgrading to 1.3.2

This includes missing PHP `8.4` support for two files:

`src/Magewire/Checkout/Payment/MethodList.php`
`src/Magewire/Checkout/Shipping/MethodList.php`

Please refer to the [changelog](changelog.html#132-2025-05-09) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.2
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No deprecations

## Templates changes

- No template changes

## Translation changes

- No translation changes.

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
