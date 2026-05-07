<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/custom-checkout/layout-handles.html -->

# Hyva Checkout Layout Handles

Hyva Checkout uses Magento layout XML handles to control what appears inside each checkout step. Layout handles let you add, remove, or rearrange components, forms, and blocks within a step - just like standard Magento layout XML, but scoped to the checkout.

Each checkout step has its own set of layout handles, and they follow a naming convention based on the checkout name and step name. Child checkouts inherit handles from their parent, so you can build on existing configurations without duplicating layout XML.

Layout XML and Module Sequence

When declaring checkout-related layout XML inside a module, add `Hyva_Checkout` to the `<sequence>` of your module's `etc/module.xml` file. This ensures the base checkout layout is evaluated before your custom layout declarations.

```
<module name="My_Module">
    <sequence>
        <module name="Hyva_Checkout"/>
    </sequence>
</module>
```

This is not necessary for theme-based checkout layout XML.

## Base Checkouts and Child Checkouts

Hyva Checkout supports configuration inheritance through a parent-child model. This inheritance determines which layout handles are available during rendering.

A **child checkout** inherits layout configuration from a parent checkout using the `parent` attribute. This is the most common setup. The following XML declares a child checkout that inherits from the "default" checkout:

```
<checkout name="my-child-checkout" label="A Child Checkout" parent="default">
    ...
</checkout>
```

A **base checkout** has no parent and serves as the foundation for child checkouts. Base checkouts omit the `parent` attribute entirely. Here's the Hyva default base checkout:

```
<checkout name="default" label="Hyvä Default" layout="2columns">
    ...
</checkout>
```

## Layout Handle Processing Order

Layout handles are processed in a specific order, and this order matters because later handles can override earlier ones. The available handles differ depending on whether the checkout is a base checkout or a child checkout.

### Base Checkout Handles

For base checkouts (no `parent` attribute), Hyva Checkout processes layout handles in this order:

1. `hyva_checkout_components` - shared reusable component declarations
2. `hyva_checkout_layout_<step-layout>` - e.g. `hyva_checkout_layout_2columns`
3. `hyva_checkout_<checkout-name>` - e.g. `hyva_checkout_default`
4. `hyva_checkout_<checkout-name>_<step-name>` - e.g. `hyva_checkout_default_login`

### Child Checkout Handles

For child checkouts (with a `parent` attribute), the parent's layout handles are processed first, followed by the child-specific handles. This is how child checkouts inherit and then extend parent configurations:

1. `hyva_checkout_components` - shared reusable component declarations
2. `hyva_checkout_layout_<step-layout>` - e.g. `hyva_checkout_layout_2columns`
3. `hyva_checkout_<checkout-parent-name>` - e.g. `hyva_checkout_default`
4. `hyva_checkout_<checkout-parent-name>_<step-name>` - e.g. `hyva_checkout_default_login`
5. `hyva_checkout_<checkout-name>` - e.g. `hyva_checkout_custom`
6. `hyva_checkout_<checkout-name>_<step-name>` - e.g. `hyva_checkout_custom_login`

Conditional Layout Handles

You can include additional layout handles conditionally using `<update handle="..."/>` within a `<step/>` configuration in your `hyva_checkout.xml` file.

## Declaring Reusable Components with `hyva_checkout_components`

The `hyva_checkout_components` layout handle is where you declare checkout components that need to appear in multiple steps. Instead of duplicating component definitions across step-specific layout files, you define them once in this handle and then move them where needed.

Components declared in this handle are added as children of the `hyva.checkout.components` container block. This block is not rendered directly - it acts as a virtual container that holds component declarations for later placement via Magento's `<move>` directive.

The following layout XML from the Hyva Checkout module shows how to declare a reusable Magewire component inside a section container within the `hyva_checkout_components` handle:

hyva\_checkout\_components.xml

```
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>

        <!-- Declare component blocks as children of a section container, -->
        <!-- or as direct children of the hyva.checkout.components block. -->

        <referenceContainer name="checkout.shipping-details.section">
            <!-- Magewire-driven component for reuse across checkout steps -->
            <block name="hyva-checkout-example">
                <arguments>
                    <argument name="magewire" xsi:type="object">
                        Hyva\CheckoutCheck\Magewire\Example
                    </argument>
                </arguments>
            </block>
        </referenceContainer>
    </body>
</page>
```

Once declared in `hyva_checkout_components`, you can move these components into specific checkout steps using standard Magento `<move>` directives in step-specific layout handles.

## Related Topics

- **[The hyva\_checkout.xml File](hyva-checkout-xml.html)** - How to define checkout configurations, steps, and inheritance
- **[Step Conditions](step-conditions.html)** - Controlling when checkout steps are displayed
