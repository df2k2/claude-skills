<!-- source: https://docs.hyva.io/hyva-checkout/integrations/abstraction-layers/guest-to-customer.html -->

# Guest to Customer Abstraction Layer

The Hyva Checkout **Guest to Customer** abstraction layer lets you convert guest checkout users into registered Magento customer accounts automatically during order placement. The `Hyva_CheckoutGuestToCustomer` module provides a transform adapter interface that receives the `\Magento\Quote\Api\Data\CartInterface` quote object to create a store customer from guest checkout data.

## How the Guest to Customer Conversion Works

The Guest to Customer abstraction layer adds an opt-in checkbox below the email address input in the Guest Details component. By default, this checkbox is unchecked, so the guest must explicitly agree before their data is used for account creation.

### System Configuration Options

Two configuration settings control the Guest to Customer behavior, both found in the Magento admin panel:

1. **Hyvä Themes > Checkout > Components > Guest Details > Enable Guest to Customer** - toggles the opt-in checkbox visibility.
2. **Hyvä Themes > Checkout > Developer > Adapters > Guest to Customer** - selects which adapter handles the conversion.

### Order Placement Lifecycle

The Guest to Customer adapter runs during the `sales_model_service_quote_submit_before` observer event. At that point the adapter's `transform` method is invoked.

The `transform` method can return `true` or `false` or throw an exception. Any exception is logged automatically but does **not** interrupt the order placement process, so the customer's order always completes regardless of whether account creation succeeds.

## Compatible Modules

No third-party compatibility modules exist yet.

Have you built a Guest to Customer compatibility module? Please reach out to us via Slack so we can add it to the list for others to use.

## Installation

Install the `Hyva_CheckoutGuestToCustomer` module via Composer:

```
composer require hyva-themes/magento2-hyva-checkout-guest-to-customer
```

## Requirements

- PHP 8.1 or higher

## Building a Custom Guest to Customer Adapter

To implement your own Guest to Customer conversion logic, create a custom Magento module that depends on `Hyva_CheckoutGuestToCustomer`, then register an adapter class.

### Step 1: Declare the Module Dependency

Your custom module must declare a `sequence` dependency on `Hyva_CheckoutGuestToCustomer` in `module.xml`:

etc/module.xml

```
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd"
>
    <!-- Ensure Hyva_CheckoutGuestToCustomer loads first -->
    <module name="Vendor_Module">
        <sequence>
            <module name="Hyva_CheckoutGuestToCustomer"/>
        </sequence>
    </module>
</config>
```

### Step 2: Create the Adapter Class

Create a class that extends `AbstractGuestToCustomerAdapter`. This adapter class must implement two methods: `transform(QuoteInterface $quote)` for the conversion logic and `getServiceName()` for admin identification.

Model/HyvaCheckout/GuestToCustomer/ExampleGuestToCustomerAdapter.php

```
<?php

declare(strict_types=1);

namespace Vendor\Module\Model\HyvaCheckout\GuestToCustomer;

use Hyva\CheckoutGuestToCustomer\Model\AbstractGuestToCustomerAdapter;
use Magento\Quote\Api\Data\CartInterface as QuoteInterface;

class ExampleGuestToCustomerAdapter extends AbstractGuestToCustomerAdapter
{
    /**
     * Transform the guest into a registered customer account.
     *
     * Leverage the integration module's own API or service layer
     * for maximum compatibility with the third-party module.
     *
     * Return true on success, false on failure, or throw an exception.
     */
    public function transform(QuoteInterface $quote): bool
    {
        // Place your guest-to-customer conversion logic here.
        // The $quote object provides access to the guest's email,
        // name, and address data from the checkout.
        return true;
    }

    /**
     * Provide a human-readable service name.
     *
     * This name appears in the system configuration dropdown,
     * allowing administrators to select the active adapter.
     */
    public function getServiceName(): string
    {
        return 'Your Adapter Name';
    }
}
```

### Step 3: Register the Adapter via Dependency Injection

Inject your adapter into `GuestToCustomerManagement` through `di.xml` so the Guest to Customer module can discover it:

etc/di.xml

```
<!-- Register the custom Guest to Customer adapter -->
<type name="Hyva\CheckoutGuestToCustomer\Model\GuestToCustomerManagement">
    <arguments>
        <argument name="adapters" xsi:type="array">
            <!-- The item name should match your adapter's service identifier -->
            <item name="your_adapter_name" xsi:type="object">
                Vendor\Module\Model\HyvaCheckout\GuestToCustomer\ExampleGuestToCustomerAdapter
            </item>
        </argument>
    </arguments>
</type>
```

Once registered, your adapter will appear in the **Hyvä Themes > Checkout > Developer > Adapters > Guest to Customer** system configuration dropdown.
