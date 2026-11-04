<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/payments/payment-introduction.html -->

# Hyvä Checkout Payment Integrations Introduction

Payment methods in Magento have very different requirements depending on how they collect payment data. This page covers the key concepts behind payment integrations in Hyvä Checkout, from simple offline methods to full gateway integrations with external Payment Service Providers (PSPs).

## Offline Payment Methods in Magento

Some Magento payment methods work entirely without contacting an external service. These are commonly called "offline payment methods" because no credit card data is collected and no third-party communication is needed.

A good example is the built-in *Check / Money Order* method. It handles everything within Magento itself - no PSP, no gateway, no external API calls.

Offline payment methods are the exception today. Most eCommerce transactions involve credit cards or other payment instruments that require external processing.

## Gateway Payment Methods and PCI-DSS Compliance

Collecting credit card data requires compliance with PCI-DSS (Payment Card Industry Data Security Standard). PCI-DSS exists to keep credit card data and personally identifiable information safe.

This is why payment methods that handle credit card information are built by integrating external Payment Service Providers. In Magento, these are sometimes called "gateway" payment methods.

Gateway payment methods delegate the actual collection of card data to the PSP. The Magento store only operates with result information - like authorization tokens - provided by the Payment Service Provider API.

## How PSP Integrations Collect Payment Data

How a Magento payment method delegates a customer to the PSP varies. Here are two common patterns:

**Redirect-based flow**: Some PSPs require the customer to leave the Magento website and complete steps on the PSP's website. After the process finishes, the customer is redirected back to the Magento checkout. If the payment was successful, an authorization token is passed to Magento - either during the redirect or via a side-channel webhook/API request.

**Iframe-based flow**: Other PSPs display an iframe containing a payment form directly in the checkout page. After the customer submits their card data, the PSP passes an authorization token to the Magento page via JavaScript using `window.postMessage()`.

Always Validate Payment Tokens Server-Side

Payment token validity must always be confirmed on the server side in PHP when the order is placed. All frontend browser validation is easy to bypass, so server-side verification is essential for security.

## Payment Tokens and Capture Timing

A payment token confirms that the credit card data was valid and authorizes the token holder (Magento) to capture the given amount. Payment tokens are typically valid for a single capture within a limited time window.

When the actual capture happens depends on the merchant's business process:

- **Capture at order placement** - the payment is captured immediately when the customer places the order.
- **Capture at shipment** - the payment is captured later, for example when the order is shipped.

Many More Integration Patterns

The redirect-based and iframe-based flows described above are just two common examples. PSP integrations can be implemented in many other ways depending on the provider's API and requirements.
