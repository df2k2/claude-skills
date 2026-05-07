<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/security-changelog.html -->

# Security Changelog - Hyvä Checkout

This page documents security-relevant vulnerability fixes for Hyvä Checkout.

## [1.3.4] - 2025-07-16

### Conditional Customer Session ID Regeneration

Session IDs were not properly regenerated for insecure HTTP connections (non-HTTPS), creating a session fixation risk where attackers could force users to use predictable or known session identifiers.

- **Impact:** Session Security
- **Severity:** Medium
- **Affected versions:** < 1.3.4
- **Note:** This issue only affects non-HTTPS deployments, which are extremely rare in modern e-commerce. HTTPS is the default for virtually all production stores. Magento core already provides protections against this. Real-world exploitation risk is minimal in 2025+.

[Full changelog entry](changelog.html#134-2025-07-16)

## [1.1.28] - 2025-01-23

### Sensitive Details Exposure in URL on Guest Login

Regression from Alpine.js v3.14.4 and newer in the Guest Details component. This affected users who upgraded to `hyva-themes/magento2-theme-module:1.3.10` with "Enable Login" activated at checkout. Guest login form submission was appending email and password as query parameters in the URL, causing sensitive credentials to appear in the browser address bar, HTTP logs, browser history, and any proxies. This information could be retrieved with local or network access to the device.

- **Impact:** Data Exposure (Credentials)
- **Severity:** Critical
- **Affected versions:** < 1.1.28
- **Root Cause:** Alpine.js v3.14.4+ regression (triggered by hyva-themes/magento2-theme-module:1.3.10)

[Full changelog entry](changelog.html#1128-2025-01-23)

## [1.0.1] - 2023-05-02

### Bypass of Required Form Fields

Client-side form field validation could be bypassed, allowing submission of the form without required fields being populated. Server-side validation correctly enforces required fields and rejects invalid submissions.

- **Impact:** Client-side UX issue
- **Severity:** Low
- **Affected versions:** 1.0.0
- **Note:** Server-side validation prevents actual data integrity issues. Version 1.0.0 is ancient (May 2023) with likely no active deployments.

[Full changelog entry](changelog.html#101-2023-05-02)
