<!-- source: https://docs.hyva.io/hyva-checkout/faq/hyva-theme-requirement.html -->

# Does Hyvä Checkout Require a Hyvä Theme?

Yes, Hyvä Checkout requires a Hyvä Theme. The checkout depends on features and functionality provided by the Hyvä Theme, so the theme is a hard dependency.

However, the rest of your store pages **do not** need to run on a Hyvä Theme. You can use the Hyvä theme fallback mechanism to load the Hyvä Default theme only for the checkout, while keeping your existing theme (like Luma) for the rest of the store.

Using Hyvä Checkout with a Luma-based store?

Check out the [Luma Checkout FAQ](luma-checkout-faq.html) for a full walkthrough of the theme fallback approach.

## Configuring the Hyvä Theme Fallback for Checkout

To set up a Hyvä theme fallback for Hyvä Checkout, configure these three settings in the Magento admin panel under **HYVA THEMES -> Fallback theme -> General Settings**:

1. **Enable the fallback theme**
   Set `HYVA THEMES -> Fallback theme -> General Settings -> Enable` to "Yes".
   The configuration path is `hyva_theme_fallback/general/enable`.
2. **Set the theme full path**
   Set `HYVA THEMES -> Fallback theme -> General Settings -> Theme full path` to `frontend/Hyva/default` to use the default Hyvä Theme.
   The configuration path is `hyva_theme_fallback/general/theme_full_path`.
3. **Specify the checkout URL**
   In `HYVA THEMES -> Fallback theme -> General Settings -> Apply fallback to requests containing`, add `hyva_checkout/index`. This tells Magento to use the Hyvä Theme only for the checkout pages.
   The configuration path is `hyva_theme_fallback/general/list_part_of_url`.
