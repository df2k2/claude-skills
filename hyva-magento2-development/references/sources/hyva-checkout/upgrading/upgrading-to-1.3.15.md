<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.15.html -->

# Upgrading to 1.3.15

This release adds Google reCAPTCHA support, a postcode format validation setting and changes to how checkout addresses are saved. It also brings the EAV address attribute support from `1.3.1000-beta1` to `1.3.1000-beta3` into the stable 1.3.x line, and updates the checkout styling to match the Hyvä default theme.

Please refer to the [changelog](changelog-1.x.html#1315-2026-10-12) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.15
```

## Address Form Configuration Data Migration

When you upgrade to `1.3.15`, two data patches run automatically to update your existing billing and shipping address form configuration:

- **`MigrateAddressConfig`** backs up your current billing and shipping address form configuration (to a `..._legacy` config path) and migrates the legacy `enabled`/`required` field flags into their own dedicated configuration values.
- **`RemoveCustomerAttributesFromAddressConfig`** removes customer-entity attributes (such as `dob`, `taxvat` and `gender`) from the address form configuration, since these cannot be saved against an address entity.

To roll the migration back, this console command restores the backed-up address form configuration:

```
bin/magento hyva:checkout-attributes:restore
```

Add the `--dry-run` (`-d`) option to preview what the restore would change without applying anything.

Custom attribute values are validated but not persisted on Magento Open Source

On **Magento Open Source**, Hyvä Checkout does **not** persist the submitted values of custom EAV attributes out of the box. On **Adobe Commerce**, these values are saved automatically through the `Magento_CustomerCustomAttributes` module. See [Adding Custom Address Attributes](../devdocs/form-customization/adding-custom-address-attributes.html) for details.

## Backward Incompatible Changes

- Tailwind v2 is no longer supported. The checkout requires a theme using Tailwind 3 or 4.
- The minimum `hyva-themes/magento2-theme-module` version is now `^1.3.16`.
- The coupon code component is rebuilt as a form. Review any override of `checkout/coupon-code.phtml` or customization of `Hyva\Checkout\Magewire\Checkout\CouponCode`.
- Checkout and step names that produce a layout handle ending in `stepfirst` or `steplast` are no longer allowed.

## Deprecations

- `Hyva\Checkout\Magewire\Checkout\CouponCode::applyCouponCode()` and `revokeCouponCode()` are deprecated.
- The **Enabled** and **Required** columns in the admin address field configuration grid are no longer configurable. Both values are now derived from the underlying EAV attribute definition.

## Template changes

New templates:

- src/view/frontend/templates/checkout/address-view/entity-details.phtml
- src/view/frontend/templates/checkout/address-view/same-address-toggle.phtml
- src/view/frontend/templates/checkout/address-view/shipping-details/address.phtml
- src/view/frontend/templates/checkout/coupon-code/apply-revoke-button.phtml
- src/view/frontend/templates/checkout/coupon-code/coupon-code-field.phtml
- src/view/frontend/templates/checkout/place-order-recaptcha.phtml
- src/view/frontend/templates/form/element/recaptcha.phtml
- src/view/frontend/templates/form/field/date.phtml
- src/view/frontend/templates/form/field/multiline.phtml
- src/view/frontend/templates/form/field/multiselect.phtml
- src/view/frontend/templates/form/field/textarea.phtml
- src/view/frontend/templates/html/loader/spinner.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-coupon-code.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/place-order-recaptcha.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/recaptcha.phtml
- src/view/frontend/templates/page/js/checkout-form-postcode-validation.phtml
- src/view/frontend/templates/page/js/checkout-form-recaptcha-validation.phtml
- src/view/frontend/templates/page/js/magewire/directive/multiselect.phtml
- src/view/frontend/templates/page/loader/spinner.phtml

Updated templates:

- src/view/frontend/templates/breadcrumbs.phtml
- src/view/frontend/templates/breadcrumbs/progress-bar.phtml
- src/view/frontend/templates/breadcrumbs/waypoints.phtml
- src/view/frontend/templates/checkout/address-view/address-form.phtml
- src/view/frontend/templates/checkout/address-view/address-form/field/save-address-book/label.phtml
- src/view/frontend/templates/checkout/address-view/address-list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/form.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/address-view/address-list/list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/select.phtml
- src/view/frontend/templates/checkout/address-view/billing-details.phtml
- src/view/frontend/templates/checkout/address-view/billing-details/address.phtml
- src/view/frontend/templates/checkout/address-view/shipping-details.phtml
- src/view/frontend/templates/checkout/coupon-code.phtml
- src/view/frontend/templates/checkout/customer-comment.phtml
- src/view/frontend/templates/checkout/payment/method-list.phtml
- src/view/frontend/templates/checkout/payment/method/checkmo.phtml
- src/view/frontend/templates/checkout/payment/method/purchaseorder.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items/type/default.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/discount.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/grand-total-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/tax-grandtotal-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/grand-total.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/shipping.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/subtotal.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/tax.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/weee.phtml
- src/view/frontend/templates/checkout/shipping-summary.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/checkout/terms-conditions/list.phtml
- src/view/frontend/templates/form/element/html/comment.phtml
- src/view/frontend/templates/form/element/html/icon.phtml
- src/view/frontend/templates/form/element/html/label.phtml
- src/view/frontend/templates/form/field/checkbox.phtml
- src/view/frontend/templates/form/field/html/hint-text.phtml
- src/view/frontend/templates/form/field/html/tooltip.phtml
- src/view/frontend/templates/form/field/password.phtml
- src/view/frontend/templates/form/field/radio.phtml
- src/view/frontend/templates/form/field/select.phtml
- src/view/frontend/templates/form/field/street.phtml
- src/view/frontend/templates/form/field/text.phtml
- src/view/frontend/templates/layout/2columns.phtml
- src/view/frontend/templates/layout/3columns.phtml
- src/view/frontend/templates/magewire/component/form.phtml
- src/view/frontend/templates/main/place-order/redirect.phtml
- src/view/frontend/templates/navigation/history.phtml
- src/view/frontend/templates/navigation/place-order.phtml
- src/view/frontend/templates/overrides/Magento\_Customer/form/login.phtml
- src/view/frontend/templates/page/header/checkout-header.phtml
- src/view/frontend/templates/page/header/logo.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-view/address-list.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/coupon-code.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/customer-comment.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/evaluation-redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/terms-conditions.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/multi-tabs-compatibility.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/init-config.phtml
- src/view/frontend/templates/page/js/api/v1/message/dialog.phtml
- src/view/frontend/templates/page/js/checkout-form-validation.phtml
- src/view/frontend/templates/page/js/magewire/plugin/error.phtml
- src/view/frontend/templates/page/messenger.phtml
- src/view/frontend/templates/section/title.phtml

If you override any of these templates in a child theme, review your overrides against the new versions.

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog-1.x.html#1315-2026-10-12).
