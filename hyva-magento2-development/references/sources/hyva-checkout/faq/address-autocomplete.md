<!-- source: https://docs.hyva.io/hyva-checkout/faq/address-autocomplete.html -->

# Address Validation and Auto-Completion in Hyva Checkout

Hyva Checkout supports address validation and address auto-completion through third-party modules and extensions. Address autocomplete integrations for Hyva Checkout fall into two categories:

- **Backend PHP-based implementations** that use Magewire for server-side validation
- **Frontend JavaScript-based implementations** that typically use a vendor-supplied SDK

## Reference Modules for Address Validation

Several existing address validation modules serve as reference implementations for building custom Hyva Checkout integrations:

- **PostCode NL** is a server-side Magewire-based address validation integration. Use `hyva-themes/magento2-hyva-checkout-postnl` as a reference for backend address autocomplete implementations.
- **Loqate** is a JavaScript-based address validation integration. Reference the package `hyva-themes/magento2-hyva-checkout-loqate`.

Getting started with a custom address validation integration

Study the existing address validation modules listed above and pick the one closest to the service you want to integrate. Use that module's code as a starting point and adjust the implementation to match your address validation provider's API.
