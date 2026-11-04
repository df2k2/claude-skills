<!-- source: https://docs.hyva.io/hyva-themes/upgrading/security-changelog.html -->

# Security Changelog - Hyvä Themes

This page documents security-relevant vulnerability fixes for Hyvä Themes (Default Theme and Theme Module).

## Default Theme [1.5.3](changelog-default-theme.html#153-2026-10-12), [1.4.11](changelog-default-theme.html#1411-2026-10-12), [1.3.23](changelog-default-theme.html#1323-2026-10-12) - 2026-10-12

### Cross-Site Scripting in the MSRP Price and Popup Templates

Both MSRP templates escaped values for HTML while rendering them into JavaScript. In the price template this allowed a crafted product name to break out of the string and run script on the storefront for shoppers viewing the product, because the browser decodes the HTML entities in the `x-data` attribute before Alpine evaluates it. In the popup template a crafted MSRP explanation message could inject markup and script into the popup.

Both templates now escape these values for JavaScript. In 1.4.11 and 1.5.3 the MSRP templates are also made CSP safe, so child themes overriding `Magento_Msrp/templates/popup.phtml` or `Magento_Msrp/templates/product/price/msrp.phtml` need to update both templates together.

- **Impact:** Cross-Site Scripting (Storefront)
- **Severity:** Low
- **Affected versions:** >= 1.3.6 < 1.3.23, >= 1.4.0 < 1.4.11, >= 1.5.0 < 1.5.3
- **Note:** Exploiting this requires write access to product data, for example through the admin, a product import or the API, or admin access to the MSRP configuration. Because of the limited risk the fix ships with the regular releases and not as a separate patch release.

The Default Theme CSP is affected through the popup template only. Its MSRP price template already passes the product name to Alpine through a JSON encoded data attribute. Update to the same versions to get the fix.

Many thanks to Jelle Janssens (Singto BV) for reporting this issue!

Full changelog entry for [1.5.3](changelog-default-theme.html#153-2026-10-12), [1.4.11](changelog-default-theme.html#1411-2026-10-12) and [1.3.23](changelog-default-theme.html#1323-2026-10-12).
