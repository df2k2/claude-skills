<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.0.html -->

# Upgrading to 1.3.0

This release introduces **Strict Content Security Policy (CSP)** support for Hyvä Checkout, enhancing security.
The checkout now enforces strict CSP and uses Alpine CSP instead of regular Alpine.
These changes make the checkout work without the `unsafe-eval` and `unsafe-inline` content security policies and facilitate PCI-DSS 4.0 compliance.

This upgrade adds **CSP support to the updated checkout redesign**.

Moving forward, the **1.3.x release line will serve as the standard release line**, receiving new features and updates.

Important CSP Considerations

If your theme includes custom/shared components that are also used within the checkout, ensure they are CSP-compatible, otherwise they will break the checkout.

For more details, refer to the [CSP Checkout without CSP Theme guide](../devdocs/csp/csp-checkout-with-non-csp-theme.html).

Please refer to the [changelog](changelog.html#130-2025-03-13) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.0
```

## Backward Incompatible Changes

- This version of the checkout breaks backward compatibility. All customizations will need to be adjusted accordingly.
  Please refer to the [CSP Checkout docs](../devdocs/csp/index.html)

## Deprecations

- No Deprecations.

## Templates changes

- src/view/frontend/templates/breadcrumbs/breadcrumbs-navigation-js.phtml
- src/view/frontend/templates/breadcrumbs/progress-bar.phtml
- src/view/frontend/templates/breadcrumbs/waypoints.phtml
- src/view/frontend/templates/checkout/address-view/address-form.phtml
- src/view/frontend/templates/checkout/address-view/address-list-js.phtml
- src/view/frontend/templates/checkout/address-view/address-list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/form.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/address-view/address-list/list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/saved-address-js.phtml
- src/view/frontend/templates/checkout/address-view/address-list/select.phtml
- src/view/frontend/templates/checkout/coupon-code-js.phtml
- src/view/frontend/templates/checkout/coupon-code.phtml
- src/view/frontend/templates/checkout/customer-comment-js.phtml
- src/view/frontend/templates/checkout/customer-comment.phtml
- src/view/frontend/templates/checkout/payment/method-list-activate.phtml
- src/view/frontend/templates/checkout/payment/method-list.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items-js.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/tax-grandtotal-details-js.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/tax-grandtotal-details.phtml
- src/view/frontend/templates/checkout/shipping/method-list-activate.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/checkout/terms-conditions-js.phtml
- src/view/frontend/templates/checkout/terms-conditions/list.phtml
- src/view/frontend/templates/form/field/html/tooltip-js.phtml
- src/view/frontend/templates/form/field/html/tooltip.phtml
- src/view/frontend/templates/form/field/password-js.phtml
- src/view/frontend/templates/form/field/password.phtml
- src/view/frontend/templates/navigation.phtml
- src/view/frontend/templates/navigation/history.phtml
- src/view/frontend/templates/navigation/place-order.phtml
- src/view/frontend/templates/page/js/api/v1.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/checkout-loader.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/evaluation-redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-guest-details.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/message-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/navigation-component.phtml
- src/view/frontend/templates/page/js/api/v1/directive/navigation.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/executables/navigation.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/multi-tabs-compatibility.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/init-config.phtml
- src/view/frontend/templates/page/js/api/v1/init-evaluation.phtml
- src/view/frontend/templates/page/js/api/v1/init-loader.phtml
- src/view/frontend/templates/page/js/api/v1/init-message.phtml
- src/view/frontend/templates/page/js/api/v1/init-navigation.phtml
- src/view/frontend/templates/page/js/api/v1/init-shipping.phtml
- src/view/frontend/templates/page/js/api/v1/init-storage.phtml
- src/view/frontend/templates/page/js/api/v1/init-validation.phtml
- src/view/frontend/templates/page/js/api/v1/init.phtml
- src/view/frontend/templates/page/js/api/v1/message/dialog.phtml
- src/view/frontend/templates/page/js/api/v1/navigation/browser-history.phtml
- src/view/frontend/templates/page/js/api/v1/storage/clear-all.phtml
- src/view/frontend/templates/page/js/api/v1/validation/cascading-step-validation.phtml
- src/view/frontend/templates/page/js/checkout-form-validation.phtml
- src/view/frontend/templates/page/js/magewire/directive/auto-save.phtml
- src/view/frontend/templates/page/js/magewire/plugin/error.phtml
- src/view/frontend/templates/page/messenger.phtml

## Translation changes

- No translation changes.

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
