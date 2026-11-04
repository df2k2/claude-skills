<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/miscellaneous/dynamically-determining-available-payment-methods.html -->

# Dynamically Determining Available Payment Methods in Hyvä Checkout

Some Payment Service Providers (PSPs) let you determine available payment methods dynamically - for example, based on the PSP configuration, the customer's country of origin, or purchase history. Instead of showing a static list, the checkout makes an API request to the PSP before rendering payment options, and the response controls which methods the customer actually sees.

## Filtering Payment Methods with an After-Plugin

In Hyvä Checkout, the way to dynamically filter payment methods is with an after-plugin on `\Magento\Quote\Api\PaymentMethodManagementInterface::getList()`. This method returns all available payment methods for the current quote. Your after-plugin intercepts that return value and removes any methods that shouldn't be available to the customer.

This approach gives you full control: you can call the PSP API inside the plugin logic, then filter the method list based on the API response.

## Registering the Payment Method Filter Plugin

To register the after-plugin, add it to `etc/frontend/di.xml` in your module. The plugin intercepts `PaymentMethodManagementInterface::getList()` and lets you filter the returned payment methods.

app/code/Example/PaymentProvider/etc/frontend/di.xml

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <!-- Plugin to dynamically filter available payment methods via PSP API -->
    <type name="Magento\Quote\Api\PaymentMethodManagementInterface">
        <plugin name="example_payment_method"
                type="Example\PaymentProvider\Plugin\AvailableMethodsFilterPlugin"/>
    </type>
</config>
```

Declare the plugin in frontend scope only

Make sure you place this plugin declaration in `etc/frontend/di.xml`, not in the global or adminhtml scope. The payment method filtering should only apply to the storefront checkout, not to admin order creation or other areas.
