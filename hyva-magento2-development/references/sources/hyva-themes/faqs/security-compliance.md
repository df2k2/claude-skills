<!-- source: https://docs.hyva.io/hyva-themes/faqs/security-compliance.html -->

# Security Compliance

## Introduction

Hyvä Themes takes security seriously. This page covers various measures we have implemented to protect our customers' data and ensure the integrity of their online stores.

## Script Hijacking & Injection

When using the CSP-enabled version of Hyvä Theme and Hyvä Checkout, the frontend is protected by a strict Content Security Policy (CSP). This policy works by sending HTTP headers that define exactly which scripts are allowed to run in the browser.

Importantly: Enforced strict CSP in Hyvä Checkout

On every checkout page load/request, the browser applies the policy, and only scripts explicitly permitted by the CSP (including valid nonced inline scripts) are allowed to execute.

### PCI-DSS relevance (payment pages)

Strict CSP is also an important part of PCI-DSS 4.0 alignment for payment-related pages: PCI-DSS 4.0 requires disallowing the `unsafe-eval` and `unsafe-inline` CSP directives for scripts on payment-related pages (effective April 1, 2025).

For the full background, scope discussion, and implementation strategy options, see the dedicated documentation:
[Content Security Policy (CSP) for Hyvä Themes](../writing-code/csp/index.html).

Hyvä uses nonces for inline scripts. This means:

- Each allowed inline script is assigned a unique, random nonce on every request.
- The browser will only execute scripts that carry the correct nonce.
- Any injected, unknown, or malicious scripts (e.g., from XSS or compromised third-party tags) are blocked by the browser and simply won't run.

This significantly reduces the risk of:

- Script hijacking
- JavaScript injection
- Malicious third-party scripts executing on the checkout

In short: when using the CSP version of Hyvä Theme and Hyvä Checkout, only explicitly approved scripts can run on the frontend, including the checkout journey.

Nonces and SHA hashes for strict CSP

Hyvä uses two complementary techniques to allow inline scripts while maintaining strict CSP:

- **Nonces** are used on uncached pages: Each inline script receives a unique, random nonce attribute on every request. The browser only executes scripts matching the current nonce.
- **SHA-256 hashes** are used on full-page cached pages: When content is cached, SHA-256 hashes of allowed inline scripts are added to the CSP HTTP header instead.

For a detailed explanation of how these techniques work, including when to use each one and common CSP gotchas, see [Nonce and SHA Hashes for CSP in Magento](../writing-code/csp/nonce-and-sha-hashes.html).

## Security Policy

A comprehensive SECURITY.md outlines our approach to security in our projects.

### Reporting a Vulnerability

If you believe you've found a security vulnerability, we encourage you to let us know.
Please report by emailing us at `security at hyva.io`.
We take security seriously and will respond as quickly as possible.

### Bug Bounty Program

We do not have a paid bug bounty program at this time. However, we appreciate your efforts in helping us keep our projects secure.

### Guidelines for Reporting

When reporting a vulnerability, please include the following information:

- A clear description of the vulnerability.
- Steps to reproduce the issue.
- Any relevant screenshots or logs.
- Your contact information (optional) for follow-up questions.

### Response Timeline

We aim to acknowledge your report within 5 business days. Please note that complexity may affect the time it takes to fix the issue, and there is no fixed deadline for resolutions.

### Disclosure Policy

We will determine public disclosure timelines on a case-by-case basis once an issue has been resolved. Our goal is to balance transparency with user safety.

### Our Commitment

We commit to:

- Acknowledging your report promptly.
- Investigating all reported vulnerabilities thoroughly.
- Keeping you updated on our progress towards fixing the issue.

Content of SECURITY.md

You can find an example [hyva-themes/magento2-theme-module](https://github.com/hyva-themes/magento2-theme-module/blob/master/SECURITY.md).

## Hall of Fame

We extend our gratitude to the following security researchers and contributors who have responsibly disclosed vulnerabilities and helped improve the security of Hyvä products:

### External Researchers

- **Jacques Kirchner** - Sensitive data exposure in URL detection
- **Mihai Ardeleanu** - Sensitive data exposure in URL detection
- **Pieter Zandbergen** - Session fixation vulnerability identification
- **Wout Kramer** - Frontend UI issue identification

*Protecting Hyvä since 2020*

### Internal Research

Our dedicated internal security team continuously audits, reviews, and improves the security of Hyvä products through:

- Continuous security audits and code reviews
- Vulnerability identification and remediation
- Security testing and validation
- Ongoing improvements to the Hyvä security posture

*Making e-commerce secure, one vulnerability at a time.*

Thank you for your commitment to responsible disclosure and helping us maintain the security and integrity of the Hyvä ecosystem.
