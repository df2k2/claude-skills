<!-- source: https://docs.hyva.io/hyva-checkout/glossary.html -->

# Hyvä Checkout Glossary

This glossary defines terms used throughout the Hyvä Checkout documentation. Words can mean different things depending on context, so these definitions help keep everyone on the same page.

## Checkout Session

A Hyvä Checkout session is the period of time between a customer adding an item to their cart and that cart being cleared or updated. The checkout session tracks the customer's progress through the checkout flow, including shipping, payment, and order placement.

## Release Line

A Hyvä Checkout release line is a major version series that receives its own releases. **Checkout 3.x** (including the 1.4.0 betas), the current line, runs on Magewire 3, and **Checkout 1.x**, the previous line, runs on Magewire 1. Pages that differ between the two show version tabs. See [Release Lines and Magewire Versions](getting-started/release-lines.html).

## Magewire 1 and Magewire 3

Magewire is the server-driven PHP component framework that powers Hyvä Checkout. Magewire 1 is a port of Livewire 2 and is used by Hyvä Checkout 1.x. Magewire 3 is a port of Livewire 3 and is used by Hyvä Checkout 3.x. See [Magewire in Hyvä Checkout](magewire/index.html).

## v1bc Module

The v1bc module (`hyva-themes/magento2-hyva-checkout-v1bc`, Magento module `Hyva_CheckoutV1bc`) is the Magewire 1 backward compatibility layer that Hyvä Checkout 3.x installs. It lets components, templates and JavaScript written for Magewire 1 keep working on Checkout 3.x: on checkout pages by default, and on other pages for components that carry the `#[HandleBackwardsCompatibility]` attribute. See [The Magewire 1 Backward Compatibility Module (v1bc)](magewire/v1bc.html), or [What Is the v1bc Module in Hyvä Checkout?](faq/what-is-v1bc.html) for a short explanation without the technical details.

## Preceding and Subsequent Requests

The preceding request is the initial page load that renders the checkout and its Magewire components. Subsequent requests are the Magewire update requests that run while the customer interacts with the checkout. See [Magewire Component Lifecycle](magewire/component-lifecycle.html).
