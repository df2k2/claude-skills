<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-11.html -->

# Upgrading to 1.4.11

Hyvä Theme 1.4.11 is a maintenance release for both the `Hyva_Theme` module and the Default Theme.
It fixes a cross-site scripting issue in the MSRP templates, makes those templates CSP safe, and contains two small fixes in the Theme Module.

Safe Module Update

You can update the `Hyva_Theme` module to 1.4.11 without updating the Default Theme.

## Security fix

### Cross-site scripting in the MSRP templates

Both MSRP templates escaped values for HTML while rendering them into JavaScript.
In the price template this allowed a crafted product name to break out of the string and run script on the storefront, because the browser decodes the HTML entities in the `x-data` attribute before Alpine evaluates it.
In the popup template the HTML escaping of the MSRP explanation messages prevented a break-out, but a crafted message could still break the popup script.
Both templates now escape these values for JavaScript.

The issue is rated low severity, because exploiting it requires write access to product data.
For details, see the [Security Changelog](security-changelog.html#cross-site-scripting-in-the-msrp-price-and-popup-templates).

## CSP safe MSRP templates

Alongside the security fix, the MSRP templates no longer rely on inline Alpine expressions:

- The price and "What's this?" buttons pass their data through a `data-msrp-data` attribute, which is read with `JSON.parse`.
- The `initMsrpPrice` and `initMsrpPopover` components are registered with `Alpine.data` instead of being declared in the `x-data` attribute.
- The inline script is registered with `$hyvaCsp->registerInlineScript()`.

The `msrp-popover` event and its `{ msrpData, target }` payload are unchanged, so custom code that dispatches or listens to it keeps working.

## Theme Module fixes

- **Min-max form validation template path**:
  The `hyva_form_validation_min_max` layout handle now references `Hyva_Theme::form/js/min-max-validation.phtml` instead of `Hyva_Enterprise::form/min-max-validation.phtml`.
- **Admin config tab logo after compact static content deploy**:
  The Hyvä logo in the admin configuration tab no longer returns a 404 after running `setup:static-content:deploy -s compact`.

## Backward compatibility

This release is backward compatible, unless your theme overrides one of the MSRP templates.

If your theme overrides `Magento_Msrp/templates/popup.phtml` or `Magento_Msrp/templates/product/price/msrp.phtml`, the override receives neither the security fix nor the CSP changes.
The new `msrp.phtml` uses the `initMsrpPrice` component, which is registered in the new `popup.phtml`.
If you override only `popup.phtml` with an older copy, the "Click for price" and "What's this?" buttons stop working, so always update both templates together.

Base your copies on the new templates, see [merge request #1549](https://gitlab.hyva.io/hyva-themes/magento2-default-theme/-/merge_requests/1549).
If you only apply the security fix, use `escapeJs` for the product id and name in `msrp.phtml`.
In `popup.phtml`, keep the existing `escapeHtml(..., ["br"])` on the explanation messages and wrap its result in `escapeJs`.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#1411-2026-10-12)
- [Changelog Theme Module](changelog-theme-module.html#1411-2026-10-12)

## Tooling

Check the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
