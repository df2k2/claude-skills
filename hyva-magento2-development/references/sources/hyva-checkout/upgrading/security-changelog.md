<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/security-changelog.html -->

# Security Changelog - Hyvä Checkout

This page documents security-relevant vulnerability fixes for Hyvä Checkout.

## [1.3.12] - 2026-07-13

### Payment Method Availability Bypass

CVSS Score: 7.5 (High) - Fixes a High-severity vulnerability where the client-side payment method availability checks could be bypassed, allowing an unavailable or restricted payment method to be persisted to the quote and carried through to order placement. This could permit an order to be placed with a payment method that should not have been available for that quote and store configuration.

The root cause was that the checkout wrote the selected payment method to the quote through a path that did not enforce Magento's payment method availability validation.

The fix replaces the bare setter with `PaymentMethodManagement::set()`, which enforces `isAvailable()` checks before writing the method to the quote. A method code that is not available for the current quote and store configuration is now rejected with a user-facing error message, and the component state is preserved from the last server-confirmed value rather than the rejected input.

The `boot()` and `evaluateSelection()` methods are also updated to read the quote via `CartRepositoryInterface` rather than the checkout session cache, ensuring the component always reflects the authoritative repository state.

This fix is included in `1.3.12` and is also available as a backport patch release for all earlier versions. Which backport tag you need depends on your current version, because some versions received a follow-up fix on top of the security patch:

| Your version | Upgrade to | Why |
| --- | --- | --- |
| `1.0.7` to `1.3.0` | `x.y.z.2` (for example `1.1.22.2`) | Security fix, plus a restored browser event that the security backport had dropped |
| `1.3.1` to `1.3.4` | `x.y.z.1` (for example `1.3.4.1`) | Security fix |
| `1.3.5` to `1.3.8` | `x.y.z.2` (for example `1.3.8.2`) | Security fix, plus a checkout-reset regression fix |
| `1.3.9` to `1.3.11` | `x.y.z.1` (for example `1.3.11.1`) | Security fix |
| `1.3.12` or later | `1.3.12` or later | Already includes the fix |

In all cases, changing your version constraint to `~x.y.z` and running `composer update` resolves to the correct highest patch automatically. If you pin an exact version, install the tag shown above.

For customers using Hyvä Checkout, we have backported this fix to all supported versions starting from `1.0.7.1` to ensure all clients receive protection.

> **Note:** The fix is also included in the `1.4.0-beta` release line, starting from `1.4.0-beta2`.
>
> **Note:** The separate CSP checkout variant (`hyva-themes/magento2-hyva-checkout-csp`) is patched as well. If you run that package, upgrade to `1.1.29.1`, or change your constraint to `~1.1.29` and run `composer update`.
>
> **Note:** On versions `1.3.5` through `1.3.8`, a separate checkout-reset regression was later fixed and backported on top of this security patch. If you are on one of these versions, upgrade to the `x.y.z.2` tag (for example `1.3.8.2`) instead of `.1`, so you receive both this security fix and the reset fix. A `~1.3.x` constraint with `composer update` resolves to the `.2` automatically. See the [changelog](changelog-1.x.html) for details.
>
> **Note:** On versions `1.0.7` through `1.3.0`, the payment-bypass backport accidentally dropped a browser event (`checkout:payment:method-activate`) that some payment methods rely on to activate on the client side, which stopped those methods working on the affected tags. This is fixed in the `x.y.z.2` tags for that range (see the table above).

A standalone patch file is available for manual application if you need to apply the fix immediately. You can request it through our Slack channels. Otherwise we recommend upgrading to version 1.3.12 or applying the appropriate backport version.

For more information, see the [Hyvä Security Advisory](../../welcome/security-advisories.html).

[Full changelog entry](changelog-1.x.html#1312-2026-07-13)

## [1.3.4] - 2025-07-16

### Conditional Customer Session ID Regeneration

Session IDs were not properly regenerated for insecure HTTP connections (non-HTTPS), creating a session fixation risk where attackers could force users to use predictable or known session identifiers.

- **Impact:** Session Security
- **Severity:** Medium
- **Affected versions:** < 1.3.4
- **Note:** This issue only affects non-HTTPS deployments, which are extremely rare in modern e-commerce. HTTPS is the default for virtually all production stores. Magento core already provides protections against this. Real-world exploitation risk is minimal in 2025+.

[Full changelog entry](changelog-1.x.html#134-2025-07-16)

## [1.1.28] - 2025-01-23

### Sensitive Details Exposure in URL on Guest Login

Regression from Alpine.js v3.14.4 and newer in the Guest Details component. This affected users who upgraded to `hyva-themes/magento2-theme-module:1.3.10` with "Enable Login" activated at checkout. Guest login form submission was appending email and password as query parameters in the URL, causing sensitive credentials to appear in the browser address bar, HTTP logs, browser history, and any proxies. This information could be retrieved with local or network access to the device.

- **Impact:** Data Exposure (Credentials)
- **Severity:** Critical
- **Affected versions:** < 1.1.28
- **Root Cause:** Alpine.js v3.14.4+ regression (triggered by hyva-themes/magento2-theme-module:1.3.10)

[Full changelog entry](changelog-1.x.html#1128-2025-01-23)

## [1.0.1] - 2023-05-02

### Bypass of Required Form Fields

Client-side form field validation could be bypassed, allowing submission of the form without required fields being populated. Server-side validation correctly enforces required fields and rejects invalid submissions.

- **Impact:** Client-side UX issue
- **Severity:** Low
- **Affected versions:** 1.0.0
- **Note:** Server-side validation prevents actual data integrity issues. Version 1.0.0 is ancient (May 2023) with likely no active deployments.

[Full changelog entry](changelog-1.x.html#101-2023-05-02)
