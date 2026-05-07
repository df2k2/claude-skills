<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.3.html -->

# Upgrading to 1.3.3

This release is a maintenance release, mostly focused on bug fixes.

Please refer to the [changelog](changelog.html#133-2025-06-19) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.3
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No deprecations

## Templates changes

- src/view/frontend/templates/page/js/api/v1/init-loader.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/executables/browser.phtml
- src/view/frontend/templates/page/js/api/v1/init-evaluation.phtml
- src/view/frontend/templates/form/field/street.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-guest-details.phtml
- src/view/frontend/templates/page/messenger.phtml
- src/view/frontend/templates/page/js/api/v1.phtml
- src/view/frontend/templates/form/field/html/tooltip.phtml

## Translation changes

- "No shipping methods available.","No shipping methods available."
- "The shipping method is missing. Select the shipping method and try again.","The shipping method is missing. Select the shipping method and try again."
- "%s is a required field.","%s is a required field."
- "Street Address line one is a required field.","Street Address line one is a required field."
- "Street Address line two is a required field.","Street Address line two is a required field."
- "Street Address line three is a required field.","Street Address line three is a required field."

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
