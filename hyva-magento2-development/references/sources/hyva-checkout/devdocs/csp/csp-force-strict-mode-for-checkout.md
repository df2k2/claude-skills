<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/csp/csp-force-strict-mode-for-checkout.html -->

# Strict Content Security Policy Mode in Hyvä Checkout

Hyvä Checkout enforces strict Content Security Policy (CSP) on the checkout route to meet PCI-DSS 4.0 compliance requirements. Strict CSP mode disables `unsafe-eval` and `unsafe-inline` directives for scripts, preventing dynamically evaluated code and inline event handlers from executing. All scripts on checkout pages must be authorized with cryptographic nonces, and inline event handlers like `onclick` are prohibited.

This security model protects checkout pages from XSS attacks and script injection vulnerabilities by ensuring only explicitly authorized scripts execute during payment processing.

Mandatory strict CSP enforcement

Hyvä Checkout enforces strict Content Security Policies on the checkout route. This is a mandatory security requirement for PCI-DSS 4.0 compliance and cannot be disabled.

## Understanding Hyvä Checkout's CSP Configuration

Magento's CSP implementation lets you define security policies for specific routes using `etc/config.xml`. Hyvä Checkout configures strict CSP for the checkout index route by default.

When Hyvä Checkout enforces strict CSP, the `report_only` setting is disabled (set to `0`). This means CSP violations block script execution rather than just logging warnings. The policies section disables `eval`, `inline`, and `event_handlers` for all script execution on the checkout page.

The following configuration shows how Hyvä Checkout implements this strict security model:

etc/config.xml

```
<!-- disable inline scripts on hyva checkout -->
<csp>
    <mode>
        <storefront_hyva_checkout_index_index>
            <report_only>0</report_only>
        </storefront_hyva_checkout_index_index>
    </mode>
    <policies>
        <storefront_hyva_checkout_index_index>
            <scripts>
                <eval>0</eval>
                <inline>0</inline>
                <event_handlers>0</event_handlers>
            </scripts>
        </storefront_hyva_checkout_index_index>
    </policies>
</csp>
```

## Applying Strict CSP to Custom Checkout Routes

If you've built custom routes for custom checkout functionality, apply the same strict CSP policies to those routes. This is especially important for payment provider routes that handle sensitive customer data.

Custom checkout routes need CSP protection because they often process payment information and customer details. By applying the same strict policies that Hyvä Checkout uses, you maintain PCI-DSS 4.0 compliance across all checkout-related pages.

### Step 1: Define Your Custom Route

First, define your custom route in `etc/frontend/routes.xml`. Here's an example for a payment module called `Payment_Provider` with a route `/payment/pay(/index)`:

etc/frontend/routes.xml

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:App/etc/routes.xsd">
    <router id="standard">
        <route id="payment_provider" frontName="payment">
            <module name="Payment_Provider"/>
        </route>
    </router>
</config>
```

### Step 2: Configure Strict CSP for Your Custom Route

After defining your route, add the strict CSP configuration to your module's `etc/config.xml` file. This configuration follows the same strict policy pattern used by Hyvä Checkout, disabling inline scripts, eval, and event handlers on your payment pages.

etc/config.xml

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Store:etc/config.xsd"
>
    <default>
        <!-- disable inline scripts on payment pages -->
        <csp>
            <mode>
                <storefront_payment_provider_pay_index>
                    <report_only>0</report_only>
                </storefront_payment_provider_pay_index>
            </mode>
            <policies>
                <storefront_payment_provider_pay_index>
                    <scripts>
                        <eval>0</eval>
                        <inline>0</inline>
                        <event_handlers>0</event_handlers>
                    </scripts>
                </storefront_payment_provider_pay_index>
            </policies>
        </csp>
    </default>
</config>
```

## Building CSP Config Keys for Routes

Magento CSP configuration keys follow a specific naming convention based on your route structure. Understanding this pattern helps you correctly configure CSP for any custom route.

For the payment provider example route `/payment/pay/index`, the CSP config key is `storefront_payment_provider_pay_index`. Each component of this key comes from a specific source:

- **Area prefix**: Either `storefront` or `admin` depending on the Magento area. Checkout pages always use `storefront`.
- **Route ID**: The `id` attribute value from your route configuration in `etc/frontend/routes.xml`. In this example, it's `payment_provider`.
- **Action path**: The folder name in your module's `Controllers` directory. Here it's `pay`.
- **Action class**: The action class file basename without the `.php` extension. Here it's `index` for the `Index.php` file.

Construct your CSP config key by joining these parts with underscores: `{area}_{routeId}_{actionPath}_{actionClass}`.

## Testing CSP Changes with Report-Only Mode

During development and testing, enable report-only mode to observe CSP violations without blocking script execution. When enabled, the browser logs CSP violations to the console but still allows scripts to run.

To enable report-only mode for your custom route, set `<report_only>1</report_only>` in your CSP configuration:

```
<storefront_payment_provider_pay_index>
    <report_only>1</report_only>
</storefront_payment_provider_pay_index>
```

In report-only mode, open your browser's developer console to view CSP violations. This lets you identify and fix violations before you switch to enforced mode for production. When you've resolved all violations, change `report_only` back to `0` to enforce strict CSP.

Monitoring CSP violations

Magento lets you configure a report URI where browsers send CSP violations for monitoring and analysis. Check the [Magento Developer Documentation](https://developer.adobe.com/commerce/php/development/security/content-security-policies#report-uri-configuration) for CSP report URI configuration details.
