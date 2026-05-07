<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.2.0.html -->

# Upgrading to 1.2.0

This release introduces a refreshed design for the checkout page, aimed at improving both aesthetics and user experience. The update includes several stylistic changes. These changes are designed to enhance usability and create a more visually appealing checkout process for users.

Please refer to the [changelog](changelog.html#120-2025-03-05) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.
Then, to upgrade, run the command

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.2.0
```

## Checkout Design Refresh

This release enhances the overall checkout experience with a focus on both visual design and accessibility improvements.
The updated design includes refined visual styles, improved spacing, and clearer form elements, all aimed at making the
checkout process more intuitive and user-friendly.

Key updates include:

- Accessibility improvements such as making **click events** fully accessible through associated labels, adding
  **ARIA controls** to dropdowns, and ensuring that information previously hidden in tooltips is now displayed as
  **hint text** below relevant fields for better visibility. These changes help improve the user experience for
  individuals with disabilities and ensure a smoother interaction with the checkout.
- The **Signup / Create Account** section has been moved from the breadcrumb container to the **Guest Details** section
  for better flow and organization. Additionally, **new titles** have been added to the Guest section to provide more
  clarity throughout the form-filling process.
- The **cart summary** has been moved to the **top of the sidebar** with a clear title, making it more prominent and
  easier for users to understand what is being summarized.
- In terms of usability, the payment and shipping options have received **better spacing**, making them clearer and
  easier to navigate. This update also improves the **checkbox and radio button styles**, making these elements more
  visible and easier to select.
- A new design option for tooltips now allows content to be displayed beneath the main field for improved clarity and
  accessibility. The classic tooltip style remains available, along with the hint text display option, both of which can
  be managed in the admin settings. These updates enhance usability, accessibility, and aesthetics, ensuring a smoother
  and more user-friendly checkout experience for all users. This setting can be found under **Store > Configuration > Hyvä Themes > Checkout > Design > Form Fields > Tooltip Style**.
- A new breadcrumb design can now be configured in the admin to appear as a progress bar stepper, providing a more
  visual and intuitive navigation experience. The classic breadcrumb style remains available and can also be managed in the
  admin settings. This setting can be found under **Store > Configuration > Hyvä Themes > Checkout > Breadcrumbs > Breadcrumbs display**.
- Introduced support for shipping method logos, following the same approach as payment methods. You can find implementation
  details [here](../devdocs/shipping/shipping-integration-api.html#displaying-an-icon-for-a-shipping-method).
- Added `Show Back to Cart Button` which can be configured in the admin to appear, this gives the user the ability to
  return to the without needing to use the browser back buttons. This setting can be found under **Store > Configuration > Hyvä Themes > Checkout > Navigation > Show Back to Cart Button**.

### Upgrade

Under normal circumstances, no additional actions are required after upgrading. However, we strongly recommend thoroughly testing your implementation, especially

## Backward Incompatible Changes

There are quite a number of backward incompatible changes in this release, but we expect the impact to be limited to the template files listed below.

## Deprecations

- No Deprecations.

## Templates changes

- src/view/frontend/templates/breadcrumbs/progress-bar.phtml
- src/view/frontend/templates/breadcrumbs/signin-register.phtml
- src/view/frontend/templates/breadcrumbs/waypoints.phtml
- src/view/frontend/templates/checkout/address-view/address-form/field/save-address-book/label.phtml
- src/view/frontend/templates/checkout/address-view/address-form/field/save-address-book.phtml
- src/view/frontend/templates/checkout/address-view/address-list/form.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/address-view/address-list/list.phtml
- src/view/frontend/templates/checkout/address-view/address-list/saved-address-js.phtml
- src/view/frontend/templates/checkout/address-view/address-list/select.phtml
- src/view/frontend/templates/checkout/address-view/billing-details/address.phtml
- src/view/frontend/templates/checkout/address-view/address-form.phtml
- src/view/frontend/templates/checkout/address-view/address-list.phtml
- src/view/frontend/templates/checkout/address-view/billing-details.phtml
- src/view/frontend/templates/checkout/payment/method/checkmo.phtml
- src/view/frontend/templates/checkout/payment/method-list.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items/type/default.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/shipping-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/subtotal-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/tax-grandtotal-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/discount.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/grand-total.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/shipping.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/subtotal.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/tax.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/weee.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/checkout/terms-conditions/list.phtml
- src/view/frontend/templates/checkout/terms-conditions/message.phtml
- src/view/frontend/templates/checkout/coupon-code.phtml
- src/view/frontend/templates/checkout/customer-comment.phtml
- src/view/frontend/templates/checkout/shipping-summary.phtml
- src/view/frontend/templates/checkout/terms-conditions.phtml
- src/view/frontend/templates/form/element/html/comment.phtml
- src/view/frontend/templates/form/element/html/container.phtml
- src/view/frontend/templates/form/element/html/icon.phtml
- src/view/frontend/templates/form/element/html/label.phtml
- src/view/frontend/templates/form/element/html/not-found.phtml
- src/view/frontend/templates/form/element/button.phtml
- src/view/frontend/templates/form/element/image.phtml
- src/view/frontend/templates/form/element/url.phtml
- src/view/frontend/templates/form/field/html/hint-text.phtml
- src/view/frontend/templates/form/field/html/tooltip.phtml
- src/view/frontend/templates/form/field/checkbox.phtml
- src/view/frontend/templates/form/field/hidden.phtml
- src/view/frontend/templates/form/field/password.phtml
- src/view/frontend/templates/form/field/radio.phtml
- src/view/frontend/templates/form/field/select.phtml
- src/view/frontend/templates/form/field/street.phtml
- src/view/frontend/templates/form/field/text.phtml
- src/view/frontend/templates/layout/1column.phtml
- src/view/frontend/templates/layout/2columns.phtml
- src/view/frontend/templates/layout/3columns.phtml
- src/view/frontend/templates/magewire/component/form.phtml
- src/view/frontend/templates/navigation/history.phtml
- src/view/frontend/templates/navigation/place-order.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component/magewire-form-guest-details.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/magewire-form-component.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/navigation-component.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/executables/navigation.phtml
- src/view/frontend/templates/page/js/api/v1/evaluation/redirect-dialog.phtml
- src/view/frontend/templates/page/js/api/v1/navigation/browser-history.phtml
- src/view/frontend/templates/page/js/api/v1/storage/clear-all.phtml
- src/view/frontend/templates/page/js/api/v1/validation/cascading-step-validation.phtml
- src/view/frontend/templates/page/js/api/v1/init-config.phtml
- src/view/frontend/templates/page/js/api/v1/init-evaluation.phtml
- src/view/frontend/templates/page/js/api/v1/init-loader.phtml
- src/view/frontend/templates/page/js/api/v1/init-message.phtml
- src/view/frontend/templates/page/js/api/v1/init-navigation.phtml
- src/view/frontend/templates/page/js/api/v1/init-shipping.phtml
- src/view/frontend/templates/page/js/api/v1/init-storage.phtml
- src/view/frontend/templates/page/js/api/v1/init-validation.phtml
- src/view/frontend/templates/page/js/api/v1.phtml
- src/view/frontend/templates/page/js/magewire/plugin/error.phtml
- src/view/frontend/templates/section/title.phtml
- src/view/frontend/templates/breadcrumbs.phtml
- src/view/frontend/templates/main.phtml
- src/view/frontend/templates/navigation.phtml

## Translation changes

- "Regular shopper?","Regular shopper?"
- "or","or"

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
