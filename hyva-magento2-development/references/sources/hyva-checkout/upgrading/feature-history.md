<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/feature-history.html -->

# Hyvä Checkout Feature History

This page lists every notable feature added to Hyvä Checkout, organized by version. Use it to find out when a specific capability was introduced, or to decide which version you need to upgrade to.

Looking for a particular feature without upgrading too far ahead? Just scan the list below - each version tag shows exactly what it brought to the table.

## Hyvä Checkout 1.3.x Releases

### Version 1.3.9

- **Pre-populate checkout name fields for logged-in customers** - Experimental feature that fills name fields automatically when a customer is logged in.
- **Multi-tab checkout stability** - Improved stale data and empty cart detection when customers use multiple browser tabs during Hyvä Checkout.

### Version 1.3.6

- **Frontend JavaScript Payment API** - A new JavaScript API for managing payment methods on the Hyvä Checkout frontend.

### Version 1.3.4

- **Custom redirect template via Place Order Service** - Set a custom redirect template when the order is placed through the Place Order Service.
- **Shipping total display config** - Control whether the shipping total appears before a shipping method is selected.
- **Combined carrier title and method name** - New config to display the carrier title and shipping method name together.
- **Telephone field frontend validation** - Added client-side validation for telephone input fields.

### Version 1.3.2

- **PHP 8.4 support fix** - Resolved missing PHP `8.4` compatibility in 2 files.

### Version 1.3.1

- **PHP 8.4 and Magento 2.4.8 compatibility** - Full support for PHP `8.4` and Magento `2.4.8`.
- **Redirect-only payment methods** - Added support for payment methods that rely solely on redirects.
- **Navigation handling and dynamic Alpine components** - Improved navigation behavior with dynamic Alpine component support in Hyvä Checkout.
- **Auto-save fix for checkboxes and radio buttons** - Fixed an issue where auto-save did not work correctly for checkbox and radio button inputs.
- **Mobile UX "Review Your Order" label** - Added a "Review Your Order" label to improve the mobile checkout experience.
- **"Free Shipping" label config** - New system configuration option to show a "Free Shipping" label.

### Version 1.3.0

- **CSP strict mode for checkout redesign** - Content Security Policy (CSP) strict mode support for the Hyvä Checkout redesign.

## Hyvä Checkout 1.2.x Release

### Version 1.2.0

- **Checkout UX design refresh** - A visual redesign of the Hyvä Checkout user experience.
- **Accessibility improvements** - Enhanced accessibility across the checkout flow.
- **Shipping method icons** - Visual icons displayed alongside shipping methods.
- **Return to Cart buttons** - Configurable "Return to Cart" buttons (disabled by default). Enable through system config.
- **Progress bar breadcrumbs** - A new progress bar breadcrumbs display component (disabled by default).

## Hyvä Checkout 1.1.x Releases

### Version 1.1.29 CSP

- **CSP strict mode support** - Content Security Policy (CSP) strict mode support for Hyvä Checkout.

### Version 1.1.29

- **Admin toggle for field autosave** - Toggle field autosave on or off in shipping and billing address forms via the admin panel.
- **Zero Subtotal Checkout** - Automatically hide other payment methods when a customer's cart qualifies for Zero Subtotal Checkout.
- **Render Billing Address config** - New `Render Billing Address` config value (enabled by default).
- **Disable Form Auto Saving config** - New `Disable Form Auto Saving` config value (disabled by default).

### Version 1.1.27

- **Form auto-save removal** - Removed the default form auto-save behavior.
- **Magewire `wire:auto-save` directive** - A checkout-specific Magewire `wire:auto-save` directive, including a `.self` modifier.
- **Frontend form validation before XHR** - Client-side form validation runs before any XHR request (for example, email validation on the Guest Details form).

### Version 1.1.26

- **Developer Experimental config section** - A new `Developer > Experimental` system configuration section in the Hyvä Checkout admin.
- **Auto-select payment and shipping methods** - Experimental option to automatically select payment and shipping methods.

### Version 1.1.25

- **Place Order config in Developer section** - Moved the Place Order system configuration into the Developer section.
- **Cascading Step Validation** - Validates that all required checkout steps were completed successfully before proceeding.
- **Message Dialog evaluation result type** - Displays a frontend dialog or modal orchestrated from the backend.
- **Evaluation result type `Tagging`** - Mark evaluation result types with a unique identifier.
- **Evaluation result type `Sequence`** - Determine the execution position of an evaluation result.
- **Evaluation result type `Result`** - Determine whether an evaluation result is positive or negative.
- **`Batch::filter()` method** - Filter method for the Evaluation result type Batch.
- **`Batch::containsFailureResults()` method** - Check if a Batch contains failure results.
- **`Batch::containsSuccessResults()` method** - Check if a Batch contains success results.
- **Local session storage clearance** - Clear local session storage when checkout place order succeeds.
- **`AbstractEntityForm::modify` callback** - Inject a modification callback without registering a modifier class.

### Version 1.1.24

- **Guest details on virtual-only checkouts** - Guest email and authentication for existing customers on virtual-only Hyvä Checkout orders.

### Version 1.1.23

- **Reinstated `collectTotals()` method** - Re-added the experimental `collectTotals()` method in `Hyva\Checkout\ViewModel\Checkout\PriceSummaryTotalSegments`.

### Version 1.1.22

- **`AbstractMethodMetaData` for method icons** - The `Hyva\Checkout\Model\AbstractMethodMetaData` class supports icons and images for shipping methods and other method types.
- **Magewire upgrade to 1.11.1** - Upgraded Magewire from 1.11.0 to 1.11.1.

### Version 1.1.21

- **`AbstractEntityForm::modifyFields`** - Apply easy, repeated changes across all form fields.
- **`AbstractEntityForm::modifyField`** - Apply changes to a single form field without checking if it exists first.
- **`AbstractEntityForm::modifyElements`** - Apply repeated adjustments across all form elements.
- **`AbstractEntityForm::modifyElement`** - Apply changes to a single form element without verifying its existence.

### Version 1.1.19

- **`validateGroup` method** - Selective field validation using the `validateGroup` method.

### Version 1.1.18

- **`hyvaCheckout.message.dialog()` API** - A universal JavaScript API for displaying checkout message dialogs.
- **URL route-based step management** - Manage Hyvä Checkout steps through URL routes.

### Version 1.1.17

- **Step cloning** - Clone steps using the `clone` step attribute in `hyva_checkout.xml`.
- **Coupon emit events** - Coupon `code` included in applied and revoked Magewire emit events.
- **Magewire 404 error modal** - Display a modal when a Magewire update returns a 404 response.

### Version 1.1.16

- **PHP 8.3 support** - Added PHP `8.3` compatibility.
- **Magento 2.4.7 support** - Added Magento `2.4.7` compatibility.
- **Radio field form renderer** - New form renderer template for radio input fields.
- **Image and URL element renderers** - New form renderer templates for image and URL elements.

### Version 1.1.15

- **Multi-tab out-of-sync modal** - Notification modal when checkout state falls out of sync across multiple tabs.
- **Cash On Delivery renderer** - A dedicated renderer for the Cash On Delivery payment method.
- **Top destination country options** - Frequently used countries appear at the top of the country selection dropdown.

### Version 1.1.13

- **Frontend Config and Storage APIs** - JavaScript APIs for managing checkout configuration and browser storage.
- **Magewire abstract form component** - A reusable abstract form component for Magewire-based checkout forms.
- **Evaluation API result types** - New result types: Batch, NavigationTask, Redirect, Validation, Executable, and Custom.
- **Redirect notification dialog** - Configurable notification and confirmation dialog for checkout redirects.

### Version 1.1.12

- **Guest details and authentication** - Guest email entry and authentication flow for existing customers during Hyvä Checkout.

### Version 1.1.11

- **Inclusive and exclusive tax display** - Prices show both tax-inclusive and tax-exclusive amounts for shipping methods, total summary, and cart items.
- **Form element accessory rendering** - Render accessory elements alongside form fields.
- **"Billing as shipping address" emit event** - New Magewire emit event for the "Billing as shipping address" toggle.

### Version 1.1.9

- **Payment methods refresh on coupon change** - The payment methods list refreshes automatically when a coupon code is applied or revoked.

### Version 1.1.7

- **Named navigation button classes** - Each navigation bar button gets a named CSS class for easier styling.
- **Single-row street field renderer** - A one-column row street field renderer that displays street fields in a single row.
- **Hidden field renderer** - A `hidden` input renderer for including hidden fields in checkout forms.

### Version 1.1.6

- **IntelliSense compatibility** - IDE IntelliSense support for Hyvä Checkout development.

### Version 1.1.5

- **Disable form modifiers with `null`** - Pass a `null` argument item to disable specific form modifiers.
- **Per-store street field labels** - Configure street field labels on a per-store basis.
- **`hasAttributesStartingWith` method** - New method on the Field object to check for attributes by prefix.

### Version 1.1.4

- **Built-with HTTP response header** - Hyvä Checkout routes now include a `built-with` HTTP response header.

### Version 1.1.2

- **`form:updated` and `form:field:updated` hooks** - New form modification hooks that fire when the form or individual fields are updated.
- **`AbstractEntityField::getPreviousValue()` method** - Retrieve the previous value of a form field.

### Version 1.1.1

- **Checkbox field template** - New form field template for checkbox inputs.
- **Address submitted emit event** - Emit event fires when an address is submitted, carrying the save result.
- **Order place redirect template** - Main component redirect template on order place completion.
- **Form element label renderer** - Dedicated renderer for form element labels.
- **Street grid renderer** - Optional grid renderer for shipping and billing street fields.

### Version 1.1.0

- **Form modification API** - API for modifying Hyvä Checkout forms programmatically.
- **Form field grouping** - Group related form fields together.
- **Magewire emit events for address and coupon components** - Emit events for the Shipping, Billing address, and Coupon Magewire components.

## Hyvä Checkout 1.0.x Releases

### Version 1.0.6

- **Customer address selection list view** - A "list" view renderer for the customer address selection component.

### Version 1.0.5

- **Save billing address to address book** - Allow customers to save their billing address to their customer address book.
- **Weee tax totals renderer** - A dedicated order totals renderer for Weee (Waste Electrical and Electronic Equipment) tax.
- **Payment method subtitle and SVG icon** - Add a subtitle and SVG logo icon to payment methods.
- **Nested DOM elements in navigation buttons** - Support for nested DOM elements inside Hyvä Checkout navigation buttons.
- **Checkout cache enabled by default** - The Hyvä Checkout cache is now enabled by default.

### Version 1.0.4

- **Address and country change listeners** - Listeners that trigger payment method list updates when the address or country changes.
- **Checkout page as widget target** - The Hyvä Checkout page type is available as a widget instance target location.
- **Composer PHP requirement narrowed** - Composer PHP requirement set between `7.4` and `8.3`.
- **Component Resolver sort order** - Sort order support for the Hyvä Checkout Magewire Component Resolver.

### Version 1.0.1

- **PHP 8.2 support** - Added PHP `8.2` compatibility.
- **Default totals renderer template** - A default renderer template for checkout order totals.
