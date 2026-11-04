<!-- source: https://docs.hyva.io/hyva-checkout/index.html -->

# Hyvä Checkout

Hyvä Checkout is a stand-alone commercial product

A separate license is required to use Hyvä Checkout. Visit [hyva.io](https://www.hyva.io/hyva-checkout.html) for pricing and licensing details.

Hyvä Checkout is the native checkout solution for Hyvä Themes, built for deep integration and easy customization. Because Hyvä Checkout can be scoped to specific store views, you can roll it out gradually, keeping other checkout solutions in place on store views where Hyvä Checkout is not yet active.

Ready to install it? Continue to [Installing Hyvä Checkout](getting-started/index.html).

Two release lines: Checkout 3.x and Checkout 1.x

Hyvä Checkout 3.x is the current release line and runs on Magewire 3. Checkout 1.x is the previous line and runs on Magewire 1. Code written for Checkout 1.x keeps working on Checkout 3.x through the [v1bc module](faq/what-is-v1bc.html), which Checkout 3.x installs. Wherever the two lines differ, these docs show version tabs. [Release Lines and Magewire Versions](getting-started/release-lines.html) sums up what you need to know for a store on Checkout 3.x and for an extension that supports both lines.

## Where to Start with Hyvä Checkout

Hyvä Checkout is built on [Magewire](magewire/index.html), a server-driven PHP component framework, so there's a bit of background to pick up before you write your first checkout component. This reading path gets you productive quickly:

1. **[Install Hyvä Checkout](getting-started/index.html)** and enable it for a store view.
2. **[Check your release line](getting-started/release-lines.html)** and what it means for your store or extension.
3. **[Read the Quickstart](getting-started/quickstart.html)** for the core concepts, architecture pillars and file conventions.
4. **[Learn the Magewire basics](magewire/index.html)** you need for checkout components.
5. **Pick the guide for your task** from the overview below.

## Hyvä Checkout Documentation Overview

The Hyvä Checkout documentation is organized by task. Pick the area that matches what you're building.

- **Getting Started**

  ---

  Requirements, installation with a license key or as a partner, and the admin settings that switch a store view to Hyvä Checkout.

  [Install Hyvä Checkout](getting-started/index.html)
- **Magewire in Hyvä Checkout**

  ---

  The component framework behind every checkout step: components, templates, events, lifecycle hooks, and how Magewire works with Alpine.js.

  [Learn Magewire for Hyvä Checkout](magewire/index.html)
- **Custom Checkouts and Steps**

  ---

  Define checkouts and steps in `hyva_checkout.xml`, place components with layout handles, and control when steps are available.

  [Build a custom checkout](devdocs/custom-checkout/hyva-checkout-xml.html)
- **Forms and Address Fields**

  ---

  Customize the shipping, billing and guest forms with the Form API: add fields, set attributes and values, and make fields depend on each other.

  [Customize checkout forms](devdocs/form-customization/index.html)
- **Evaluation API**

  ---

  Validate checkout data on the server and tell the frontend what to do next, from blocking navigation to showing messages.

  [Use the Evaluation API](devdocs/evaluation-api/index.html)
- **Payments and Shipping**

  ---

  Integrate payment and shipping methods, and control how orders are placed with Place Order Services.

  [Integrate a payment method](devdocs/payments/payment-introduction.html)
- **Frontend JavaScript API**

  ---

  The `hyvaCheckout` JavaScript namespace for payment, storage, validation, evaluation and checkout events.

  [Explore the Frontend API](devdocs/frontend-api/index.html)
- **Content Security Policy**

  ---

  Run Hyvä Checkout under a strict CSP, register inline scripts, and make theme components CSP compatible.

  [Make your checkout CSP compliant](devdocs/csp/index.html)
- **Integrations**

  ---

  Payment, shipping and address finder modules that already support Hyvä Checkout, plus community extensions.

  [Browse integrations](integrations/available-payment-methods.html)
- **FAQ**

  ---

  Answers to common questions and errors, from two-column layouts to missing totals.

  [Read the FAQ](faq/404-component-not-found.html)

## Using Hyvä Checkout on a Luma Store

Hyvä Checkout can run on stores that use a Luma theme, so it doesn't require a full Hyvä Themes setup. See the [Hyvä Checkout FAQ](faq/hyva-theme-requirement.html) for setup instructions.

## A/B Testing Hyvä Checkout Performance

When introducing Hyvä Checkout to an existing store, it's useful to measure how the new checkout performs compared to the existing Luma-based checkout. Elgentos published an open source Magento 2 module for this purpose: [elgentos/magento2-hyva-checkout-ab-test](https://github.com/elgentos/magento2-hyva-checkout-ab-test).

The module is quick to set up. Keep in mind that a large data set is needed to get statistically meaningful A/B test results.

## Support

Post questions to an appropriate channel in the [Hyvä Slack](https://hyva.io/slack). License holders can also submit technical support requests through the [technical support form](https://www.hyva.io/request-hyva-support/request/index/) in the Hyvä customer portal.
