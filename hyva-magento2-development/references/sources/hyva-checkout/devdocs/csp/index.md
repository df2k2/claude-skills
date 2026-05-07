<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/csp/index.html -->

# Content Security Policy (CSP) for Hyvä Checkout

Hyvä Checkout 1.3.x and newer enforce strict Content Security Policy (CSP) on all checkout pages, meeting PCI-DSS 4.0 requirements out of the box. Strict CSP prevents JavaScript skimming attacks by blocking unauthorized script execution during the checkout process.

CSP fundamentals for Hyvä Themes

For a comprehensive introduction to CSP concepts, Alpine CSP compatibility, and migration tools, see the [Hyvä Theme CSP developer documentation](../../../hyva-themes/writing-code/csp/index.html).

## PCI-DSS 4.0 Compliance in Hyvä Checkout

PCI-DSS 4.0 requires strict Content Security Policies on payment-related pages. Hyvä Checkout satisfies these requirements by disabling `unsafe-inline` and `unsafe-eval` CSP directives and enforcing nonce-based script authorization on checkout pages.

The following script execution controls apply to Hyvä Checkout pages:

- **No `unsafe-inline` or `unsafe-eval`** -- Both CSP directives are disabled on checkout pages, preventing arbitrary script execution.
- **Nonce-based authorization** -- Every inline `<script>` tag must include a valid `nonce` attribute. Scripts without a matching nonce are blocked by the browser.
- **Alpine CSP build required** -- Hyvä Checkout uses the Alpine.js CSP build, which does not evaluate inline expressions. All Alpine components on checkout pages must follow [CSP-compatible patterns](../../../hyva-themes/writing-code/csp/alpine-csp.html).

## Strict CSP Enforcement on Checkout Pages

Hyvä Checkout enforces strict CSP rules that go beyond basic header configuration. These rules ensure that only explicitly authorized scripts run during the checkout flow.

- **All scripts require a valid nonce** -- The Magento CSP nonce is applied to every authorized script. Any script tag missing the nonce is blocked.
- **No dynamic script injection** -- Scripts must be present in the original page source. Dynamically injected scripts (for example, appended via JavaScript) are not authorized and will not execute.
- **No exceptions for inline execution** -- Every inline script must be registered and nonced. There are no bypasses or fallback modes on checkout pages.

These strict CSP enforcement rules significantly reduce the risk of cross-site scripting (XSS) attacks and JavaScript skimming on payment pages.

## Making Shared Templates CSP-Compatible for Checkout

Hyvä Checkout shares templates with the Hyvä Theme for common page elements like header and footer blocks. Because Hyvä Checkout runs in strict CSP mode with Alpine CSP, any shared template containing inline JavaScript or Alpine expressions must be CSP-compatible -- otherwise the shared template will break checkout rendering.

To make shared templates CSP-compatible for Hyvä Checkout:

- **Register inline scripts** -- Update shared templates to use CSP-safe patterns. Register each inline script with `<?php $hyvaCsp->registerInlineScript() ?>` immediately after the opening `<script>` tag.
- **Scan your theme with the migration tool** -- If you are unsure which templates need changes, run the [Hyvä Theme CSP Migration Tool](../../../hyva-themes/writing-code/csp/migration-tool.html) to scan your theme for CSP-incompatible patterns.
- **Reference the Hyvä Default Theme** -- Hyvä Default Theme version 1.3.12 and newer ships with CSP-compatible versions of shared components. Use the Hyvä Default Theme templates as a reference when updating custom components for CSP compatibility.

Custom Alpine components on checkout pages

Any custom Alpine component rendered on a checkout page must use the Alpine CSP build conventions. Standard Alpine `x-data` inline expressions will not work under strict CSP. See [Alpine CSP constructor functions](../../../hyva-themes/writing-code/csp/alpine-csp-constructor-functions.html) for the required pattern.
