<!-- source: https://docs.hyva.io/hyva-checkout/faq/main-wire-element-could-not-be-found.html -->

# Main Wire Element Could Not Be Found

Hyvä Checkout with the Fallback Module (`hyva-themes/magento2-theme-fallback`) can show JavaScript errors when the Theme Fallback configuration still includes the checkout page. The two most common error messages are:

Error Messages

- `Main wire element could not be found`
- `ReferenceError: Magewire is not defined`

## Symptoms of the Theme Fallback Error

The primary symptom is that the Luma checkout theme loads instead of the Hyvä Checkout page. This happens because the `checkout/index` page is still listed in the Hyvä Theme Fallback settings, which forces Magento to render the checkout using the Luma layout rather than the Hyvä Checkout Magewire components.

## How to Fix the "Main Wire Element Could Not Be Found" Error

To resolve this error, remove the checkout page from the Hyvä Theme Fallback configuration:

1. Go to **Stores > Configuration > Hyvä Themes > Theme Fallback** in the Magento Admin.
2. Find `checkout/index` in the fallback list and remove it.
3. Save the configuration and flush the Magento cache.

Tip

After saving, make sure to clear the full page cache so the updated configuration takes effect on the storefront.
