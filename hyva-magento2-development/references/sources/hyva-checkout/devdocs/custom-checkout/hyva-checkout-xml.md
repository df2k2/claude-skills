<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/custom-checkout/hyva-checkout-xml.html -->

# The hyva\_checkout.xml file

## How Hyva Checkout uses hyva\_checkout.xml

The `hyva_checkout.xml` configuration file is where you define checkout variants and their step sequences in Hyva Checkout. You can run multiple checkout configurations within a single Magento instance, each tailored to different store views or business requirements.

Place the file at `etc/hyva_checkout.xml` in either a module or a theme. When a checkout page loads, Magento merges all `hyva_checkout.xml` files from active modules and the current theme hierarchy into one configuration. That merged result determines which steps display and under what conditions.

Every Hyva Checkout configuration requires two things:

- A unique **name** used for references in other configuration files and layout handles.
- A human-readable **label** displayed in the admin dropdown.

You assign checkout configurations to specific Magento Websites or Store Views at **Hyva Themes > Checkout > General > Checkout** in the admin.

Reference file

The `magento2-hyva-checkout` module ships with a reference `etc/hyva_checkout.xml` that contains the default checkout configurations included with Hyva Checkout.

The hyva\_checkout.xsd schema

The XML schema for `hyva_checkout.xml` is located in `hyva-themes/magento2-hyva-checkout` at `src/etc/hyva_checkout.xsd`. This schema defines all valid elements, attributes, and their relationships.

## Steps vs. components

The `hyva_checkout.xml` file controls **step order and visibility**, not step content. The actual contents of each step - components like login forms, address lists, and quote summaries - are configured using [layout XML](layout-handles.html), not `hyva_checkout.xml`.

Components can be shared between multiple steps or restricted to a single step, depending on your configuration.

## Checkout config merging

All `etc/hyva_checkout.xml` files from active modules and the current theme hierarchy are merged to produce the final checkout configuration. The merging process follows a priority order similar to Magento's theme fallback system.

Theme-scoped merging

Theme `hyva_checkout.xml` files are only merged if the theme is active for the current store view. This lets you customize the checkout per-theme without affecting other store views.

The merge order determines priority. Later files override values from earlier files:

1. All module `hyva_checkout.xml` files in module load order
2. The base theme `hyva_checkout.xml`
3. The `hyva_checkout.xml` files from other themes in the theme fallback chain
4. The current theme `hyva_checkout.xml`

## Checkout element attributes

The `<checkout>` element wraps one or more steps and defines a checkout variant. Here are the available attributes:

| Attribute | Required | Description |
| --- | --- | --- |
| `name` | Yes | Unique identifier for the checkout. Used in other `hyva_checkout.xml` files and to construct layout handles. |
| `label` | Yes | Human-readable label shown in the admin checkout selection dropdown. |
| `layout` | No | Default structure of a checkout step into which components can be arranged (e.g., `2columns`). |
| `parent` | No | Name of a parent checkout configuration to inherit from. |
| `visible` | No | Whether this checkout appears in the admin selection dropdown. |

## Step element attributes

Each `<step>` within a `<checkout>` represents a page the visitor sees during the checkout flow. Here are the available attributes:

| Attribute | Required | Description |
| --- | --- | --- |
| `name` | Yes | Step identifier used in other `hyva_checkout.xml` files and to construct layout handles. |
| `label` | Yes | Displayed in the checkout step navigation on the front end. Passed through the `__()` translation function. |
| `route` | No | URL segment for the step. Used for deep links. Defaults to the step name. |
| `layout` | No | Structure of the checkout step into which components can be arranged (overrides the checkout-level layout). |
| `remove` | No | Remove a step that was declared in a different `hyva_checkout.xml` file. |
| `ifconfig` | No | Only use the step if the given system config path has a truthy value. Negate with `!` as the first character. |
| `before` | No | Name of another step before which this step should be placed. |
| `after` | No | Name of another step after which this step should be placed. |
| `clone` | No | Replicate a step from another checkout using a dotted path: `{checkout_name}.{step_name}` (since 1.1.17). |

## Condition element attributes

The `<condition>` element controls step visibility. When multiple conditions exist on a step, the step only shows if **all** conditions are true.

| Attribute | Required | Description |
| --- | --- | --- |
| `name` | Yes | Identifier for the condition, used for references in other `hyva_checkout.xml` files. |
| `if` | No | A condition class name (implementing `Hyva\Checkout\Model\CustomConditionInterface`) or a condition identifier string mapped to a class in `frontend/di.xml`. |
| `remove` | No | Remove a condition that was declared in a different `hyva_checkout.xml` file. |
| `before` | No | Evaluate this condition before the condition with the given name. |
| `after` | No | Evaluate this condition after the condition with the given name. |
| `method` | No | Name of the method on the condition class to call (defaults to `validate`). |

## Update (handle) element attributes

The `<update>` element includes a layout XML handle in a step. You can make it conditional with the `if` attribute.

| Attribute | Required | Description |
| --- | --- | --- |
| `handle` | Yes | Layout XML handle to include in the step. |
| `if` | No | Only include the handle if this condition is truthy. Accepts a class name or condition identifier, same as `<condition>`. |
| `method` | No | An alternative class method name (defaults to `validate`). |
| `processor` | No | An advanced option to specify a different layout handle processor. |
| `remove` | No | Remove the handle from the step. |

## Complete annotated example

Here is a full `hyva_checkout.xml` example showing all available elements working together. This is a good starting point when creating your own checkout configuration.

```
<?xml version="1.0"?>
<!-- All hyva_checkout.xml files are merged at runtime into one configuration -->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Hyva_Checkout:etc/hyva_checkout.xsd"
>
    <!-- Define a checkout variant with a unique name and admin label -->
    <checkout name="my-checkout" label="My Checkout" layout="2columns">

        <!-- Define a step with a URL route and its own layout override -->
        <step name="login" label="Customer Login" route="login" layout="1column">

            <!-- Step conditions: all must be true for the step to show -->
            <condition name="is_customer_required" if="is_customer_required" />
            <condition name="is_guest" if="is_guest"/>

            <!-- Conditionally include a layout handle based on quote type -->
            <update handle="my_virtual_quote_layout" if="is_virtual"/>
        </step>
    </checkout>
</config>
```

## Related Topics

- **[Checkout layout handles](layout-handles.html)** - How to configure the content that appears within each checkout step using layout XML
- **[Config step conditions](step-conditions.html)** - How to create and use conditions that control step visibility
