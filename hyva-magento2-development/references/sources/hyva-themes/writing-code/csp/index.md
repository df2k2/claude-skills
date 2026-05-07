<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/index.html -->

# Content Security Policy (CSP) for Hyvä Themes

Content Security Policy (CSP) is a browser security mechanism that restricts which scripts, styles, and other resources can execute on a web page. For Magento and Hyvä developers, CSP compliance is critical because PCI-DSS 4.0 requires disabling `unsafe-eval` and `unsafe-inline` CSP directives on payment-related pages since April 1, 2025.

This page explains the PCI-DSS requirements affecting Hyvä themes, the security threats that strict CSP prevents, and the CSP-compatible options Hyvä provides. For a general introduction to CSP concepts, see our blog post [What is CSP and why should I care?](https://www.hyva.io/blog/experts-insights/pci-dss-what-is-csp.html).

## Why Strict CSP Matters: Protecting Against JavaScript Skimming

Modern credit card skimming attacks no longer rely on compromised server-side payment forms. Since most merchants use payment service providers (PSPs) that handle payment processing via redirects or iframes, attackers have shifted tactics.

**Current attacks work as follows:** Attackers inject malicious JavaScript that intercepts customers before they reach the legitimate payment provider. The injected script redirects customers to phishing sites that mimic the real PSP interface. After customers enter their payment credentials on the fake site, they are forwarded to the real payment provider without noticing the interception. The attack succeeds even though the merchant's server-side payment handling remains secure.

**Strict CSP prevents these attacks** by blocking unauthorized script execution. When CSP is properly configured, only scripts explicitly authorized by the merchant can run on the page. Injected scripts — whether from compromised third-party dependencies, XSS vulnerabilities, or browser extensions — are blocked before they can execute.

## PCI-DSS 4.0 Requirements for Payment Pages

Since April 1, 2025, PCI-DSS 4.0 requires stricter CSP policies on payment-related pages. The `unsafe-eval` and `unsafe-inline` directives must be disallowed to prevent JavaScript injection attacks.

### Which Pages Require Strict CSP?

The PCI-DSS 4.0 specification states in requirement 6.4.3:

> All payment page scripts that are loaded and executed in the consumer's browser

The exact scope remains ambiguous. It is unclear whether this applies only to checkout pages or also to pages with in-context payment buttons (PayPal Express, Apple Pay, etc.).

The PCI-DSS 4.0.1 Self Assessment Questionnaire (SAQ-A) provides limited guidance:

> For SAQ A, Requirement 6 applies to merchant server(s) with a webpage that either 1) redirects customers from the merchant webpage to a TPSP/payment processor for payment processing (for example, with a URL redirect) or 2) includes a TPSP's/payment processor's embedded payment page/form (for example, one or more inline frames or iframes).

### Factors Affecting Compliance Requirements

Compliance interpretation may vary based on:

- Merchant's country of operation
- Type of goods sold
- Security track record of merchant and hosting provider
- Payment service provider requirements

## Merchant Responsibility for PCI-DSS Compliance

**Each merchant is responsible for evaluating their specific compliance requirements and implementing appropriate measures.** Hyvä cannot make this determination for merchants.

Hyvä provides CSP-compatible versions of both Hyvä Theme and Hyvä Checkout, but merchants must choose the appropriate implementation strategy based on their compliance requirements.

## Choosing Your CSP Implementation Strategy

Merchants can choose from several CSP implementation strategies depending on their compliance needs and development constraints:

| Strategy | Description | Best For |
| --- | --- | --- |
| **Strict CSP checkout only** | Enable CSP strict mode only on checkout pages | Merchants who need compliance with minimal code changes to their theme |
| **Strict CSP checkout + redirect buttons** | CSP checkout with redirect-based in-context payments | Merchants using PayPal Express, Apple Pay, or similar buttons who want to preserve UX |
| **Full theme CSP compatibility** | Use Alpine CSP build site-wide | Maximum security; requires migrating all Alpine expressions to CSP-compatible syntax |

### Decision Guide: Which Strategy Should You Choose?

**Choose "Strict CSP checkout only" if:**

- Your checkout uses Hyvä Checkout (which supports CSP out of the box)
- You do not have in-context payment buttons on product or cart pages
- You want to minimize migration effort

**Choose "Strict CSP checkout + redirect buttons" if:**

- Your checkout uses Hyvä Checkout (which supports CSP out of the box)
- You use in-context payment buttons (PayPal Express, Apple Pay) on non-checkout pages
- You want to preserve in-context payment UX while ensuring compliance
- You can configure your payment buttons to use redirects on checkout pages

**Choose "Full theme CSP compatibility" if:**

- Your checkout uses Hyvä Checkout (which supports CSP out of the box)
- You want maximum protection against JavaScript injection site-wide
- You are building a new theme and can write CSP-compatible code from the start
- You have resources to migrate existing Alpine expressions to CSP-compatible syntax
- Your payment processor requires strict CSP on all pages

## CSP Documentation Overview

This section contains detailed documentation for implementing CSP in Hyvä themes:

### Getting Started

- **[CSP Compatibility](csp-compatibility.html)**: Explains the `unsafe-eval` and `unsafe-inline` restrictions and how Hyvä handles them
- **[Hyvä Default Theme CSP Installation](hyva-default-theme-csp-installation.html)**: Step-by-step guide to installing the CSP-compatible version of Hyvä default theme
- **[Magento CSP Configuration](csp-magento-configuration.html)**: How to configure Magento's CSP headers for strict mode

### Alpine.js CSP Compatibility

- **[Alpine CSP](alpine-csp.html)**: Overview of Alpine CSP build limitations and how to write compatible code
- **[Alpine CSP Example Component](alpine-csp-example-component.html)**: Complete example showing CSP-compatible component structure
- **[Constructor Functions](alpine-csp-constructor-functions.html)**: How to register Alpine components for CSP compatibility
- **[Properties](alpine-csp-properties.html)**: Reading and accessing component properties in Alpine CSP
- **[Property Mutation](alpine-csp-property-mutation.html)**: Changing component state without inline expressions
- **[x-model Alternatives](alpine-csp-x-model.html)**: CSP-compatible replacements for `x-model` directive
- **[x-for Patterns](alpine-csp-x-for.html)**: Using iteration in Alpine CSP
- **[createBooleanObject Helper](alpine-csp-hyva-createbooleanobject.html)**: Utility for creating toggle-able boolean state objects

### Advanced Topics

- **[CSP and Block Caching](csp-and-block-caching.html)**: How CSP interacts with Magento's full-page cache and block caching
- **[In-Context Payment Buttons](csp-in-context-payment-buttons.html)**: Handling PayPal Express, Apple Pay, and similar buttons with CSP
- **[Migration Tool](migration-tool.html)**: Automated tool for converting standard Alpine code to CSP-compatible syntax

### Hyvä Checkout CSP

For CSP configuration specific to Hyvä Checkout, see the [Hyvä Checkout CSP Documentation](../../../hyva-checkout/devdocs/csp/index.html).
