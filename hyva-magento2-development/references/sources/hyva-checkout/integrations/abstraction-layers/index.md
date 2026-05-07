<!-- source: https://docs.hyva.io/hyva-checkout/integrations/abstraction-layers/index.html -->

# Abstraction Layers in Hyvä Checkout

Hyvä Checkout provides abstraction layers to give developers a head start when integrating third-party modules. Each abstraction layer exposes a clear API and system configuration options that enable features and allow adapter selection.

Hyvä Checkout is built to provide all the essential tools for a feature-rich, flexible, high-performance checkout experience. Rather than reinventing functionality that third-party vendors already handle well, abstraction layers handle the UX integration so you can focus on the parts that are unique to your project.

For example, an address autofill feature or a guest-to-customer transformer both need additional frontend fields - but the core business logic already lives in the third-party module. The abstraction layer bridges that gap without requiring a full rewrite.

Note

Each abstraction layer is unique. Read the documentation for the specific layer you're working with before building your integration.

## Building Integrations on an Abstraction Layer

Abstraction layers provide the foundation for your own custom integration modules. Think of your module as sitting between the third-party module and the abstraction layer - your module uses the abstraction's API to wire the third-party functionality into Hyvä Checkout without compromising the checkout experience.

This approach has a defined scope: the abstraction layer covers what makes sense for all integrations globally. If a specific integration requires additional options beyond what the abstraction provides, those need to be implemented in your custom module.
