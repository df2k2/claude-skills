<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.10.html -->

# Upgrading to 1.3.10

This release is a maintenance release, mostly focused on bug fixes.

Please refer to the [changelog](changelog.html#1310-2026-04-23) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.10
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No Deprecations.

## Templates added

Temporary File Additions

Please note that these files are a **temporary** fix until we introduce [In-Checkout Login/Register Workflows](https://www.hyva.io/roadmap?product=hyva-checkout#design-ux-user-experience-in-checkout-login-register-workflows) in a future release.

- src/view/frontend/templates/overrides/Magento\_Customer/form/login-component.phtml
- src/view/frontend/templates/overrides/Magento\_Customer/form/login.phtml

## Template changes

- src/view/frontend/templates/page/js/api/v1/alpinejs/checkout-loader.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/address-view/address-list/form.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
