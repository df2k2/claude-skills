<!-- source: https://docs.hyva.io/hyva-checkout/getting-started/quickstart.html -->

# Hyvä Checkout Quickstart

Hyvä Checkout is a flexible, component-based checkout for Magento 2 built on [Magewire](../magewire/index.html) and the Hyvä frontend stack. It replaces the Luma checkout with a modular architecture where each checkout component operates independently, giving you full control over step layout, payment integration, and order placement logic.

This page covers the core concepts, architecture pillars, and file conventions you need to know before building on Hyvä Checkout.

## Prerequisites for Hyvä Checkout Development

Working with Hyvä Checkout assumes familiarity with the following Magento development topics:

- Layout XML and `.phtml` template files
- Block classes
- PHP ViewModels
- [Magewire](../magewire/index.html) - the server-driven component framework used throughout Hyvä Checkout

## Key Concepts to Understand Before You Start

Hyvä Checkout has a few architectural decisions that differ from Luma. Understanding these upfront will save you time.

**Hyvä Checkout is a component shell.** The checkout itself is an empty container. Individual components - address forms, shipping methods, payment methods, navigation buttons - are registered independently and placed into steps via layout XML. This design gives you flexibility to show any component at any step.

**Payment methods and Place Order are decoupled.** The "Place Order" button does not have to appear on the same step as the payment method. In fact, Hyvä Checkout treats it as bad practice to assume they are co-located. Always test your payment method integration on a step that has a subsequent step after it.

**The APIs reduce custom code, not add to it.** Hyvä Checkout ships with APIs for evaluation, navigation, payment, and more. These APIs exist to handle complexity that you would otherwise need to build yourself. Before writing custom code, check whether an existing API already covers your use case.

Not sure if Hyvä Checkout already handles your use case?

Before writing custom code, ask in [Slack](https://www.hyva.io/slack). The core covers a lot of ground, and a quick question can save hours of development time.

**APIs compose across contexts.** Some APIs, like the [Evaluation API](../devdocs/evaluation-api/index.html), were originally designed for Magewire components but have been extended to work in other contexts, such as the [Place Order Service API](../devdocs/place-order-service-api/index.html). Understanding each API's scope helps you choose the right tool for the job.

**Hyvä Checkout builds on what you already know.** Magewire, Layout XML, ViewModels, and PHP - these are the same Magento fundamentals you use every day. Hyvä Checkout extends them rather than replacing them.

## Fundamental Architecture Pillars

Hyvä Checkout is built on several core pillars. Everything else in the system is additional functionality layered on top. Getting comfortable with these pillars is the best starting point for Hyvä Checkout development.

### Magewire - the Core Engine

Magewire is the server-driven component framework that powers Hyvä Checkout. It handles step navigation, state management, the Evaluation API, and component rendering. The Main Magewire component coordinates the entire checkout and should never be overwritten or modified directly.

Checkout components can be built with other technology stacks, but the `hyvaCheckout` frontend API works best with Magewire-driven components. Non-Magewire components require more custom wiring to integrate with the checkout core.

### Layout XML and the `hyva_checkout_components.xml` Handle

Hyvä Checkout uses a structured layout system with dedicated handles and containers for every part of the checkout. The key conventions are:

- **Component registration**: Checkout components (Magewire blocks) are registered using the `hyva_checkout_components.xml` handle, which targets the `hyva.checkout.components` block. Registering a component here makes it reusable across any step.
- **Step placement**: Use a global checkout handle (`hyva_checkout_{checkout_name}.xml`) or a step-specific handle (`hyva_checkout_{checkout_name}_{step_name}.xml`) combined with `<move element="" destination=""/>` to place components into the correct columns for each step.
- **JavaScript templates**: Custom `<script>` blocks are stored in dedicated containers based on the area they extend. See the [JS Templates section](#working-with-javascript-templates) below for the full container map.

### Checkout Config - `hyva_checkout.xml`

The `hyva_checkout.xml` config file, located in your module's `/etc` folder, controls checkout-wide behavior. Reviewing all available options before building custom features is important - many common requirements are already configurable here without writing custom code.

### Evaluation API

The Evaluation API is a PHP-driven system that lets you validate and process checkout data on the server, then send a structured set of instructions back to the frontend. The frontend executes these instructions either immediately or when the customer clicks a navigation button like "Go to next step" or "Place order".

The Evaluation API is used extensively in the Hyvä Checkout core and is one of the most important concepts to understand. It is also used in other contexts, including the Place Order Service layer.

See the [Evaluation API documentation](../devdocs/evaluation-api/index.html) for full details.

### Place Order Services

Place Order Services control how orders are submitted. The default service handles standard orders. When a specific payment method is selected, Hyvä Checkout looks for a matching Place Order Service by name and uses that service instead - this lets PSPs and custom payment methods control the order placement flow without modifying core code.

Since version 1.3.6, a JavaScript-driven option for Place Order Services is also available. See the [Frontend API payment documentation](../devdocs/frontend-api/V1/payment.html) for details.

### Frontend API - the `hyvaCheckout` JavaScript Namespace

Hyvä Checkout initializes a global `hyvaCheckout` frontend API on page load. This API provides utilities across several subsections:

- `messaging` - display messages to the customer
- `order` - interact with order state
- `payment` - manage payment method selection and processing
- `storage` - read and write checkout data
- `config` - access checkout configuration

Understanding the Frontend API reduces the need for custom JavaScript and keeps integrations consistent with the checkout core.

See the [Frontend API documentation](../devdocs/frontend-api/index.html) for the full reference.

## File and Folder Conventions

Hyvä Checkout defines a clear location for almost every type of file. Following these conventions ensures your customizations are loaded in the correct order and remain upgrade-safe.

### Creating a New Magewire Checkout Component

Magewire components for Hyvä Checkout belong in the `Magewire/Checkout/...` directory of your module, nested in subdirectories as needed. To register a component so it can be placed on any step, add it to the `hyva_checkout_components.xml` layout handle targeting the `hyva.checkout.components` block.

Once registered, use a global checkout handle (`hyva_checkout_{checkout_name}.xml`) or a step-specific handle (`hyva_checkout_{checkout_name}_{step_name}.xml`) with `<move element="" destination=""/>` to position the component in the correct column for each step.

### Working with JavaScript Templates

When adding custom JavaScript to Hyvä Checkout, store it in a minimal `.phtml` template containing a `<script>` tag. These templates are injected outside the dynamic Main Magewire component so they are always available on page load. This approach is also required for CSP compatibility.

Each custom JavaScript template must be registered using the `hyva_checkout_index_index.xml` layout handle, referencing the container that matches the area of the `hyvaCheckout` API you are extending.

Template directory prefix

All JS template directories below are relative to `view/frontend/hyva/checkout/page/js/v1/`. This prefix is omitted from the table to keep paths readable.

The following table maps each `hyvaCheckout` API area to its reference container and template directory:

| API Area | Reference Container | Template Directory |
| --- | --- | --- |
| Storage | `hyva.checkout.init-storage.after` | `/storage` |
| Config | `hyva.checkout.init-config.after` | `/config` |
| Validation | `hyva.checkout.init-validation.after` | `/validation` |
| Evaluation | `hyva.checkout.init-evaluation.after` | `/evaluation` |
| Evaluation - Executables | `hyva.checkout.evaluation.executables` | `/evaluation/executables` |
| Navigation | `hyva.checkout.init-navigation.after` | `/navigation` |
| Payment | `hyva.checkout.init-payment.after` | `/payment` |
| Shipping | `hyva.checkout.init-shipping.after` | `/shipping` |
| Message | `hyva.checkout.init-message.after` | `/message` |
| Loader | `hyva.checkout.init-loader.after` | `/loader` |
| Viewport | `hyva.checkout.init-viewport.after` | `/viewport` |
| Debug | `hyva.checkout.init-debug.after` | `/debug` |

Not sure which container to use?

When in doubt, store your JS template in `view/frontend/hyva/checkout/page/js/api/v1` and use the `hyva.checkout.api-v1.after` reference container. This is also the recommended location for AlpineJS component templates. It is always worth finding a more specific container when possible, but this fallback works for any situation.
