<!-- source: https://docs.hyva.io/hyva-checkout/integrations/abstraction-layers/autocomplete.html -->

# Autocomplete Abstraction Layer for Hyva Checkout

The Hyva Checkout autocomplete abstraction layer (`Hyva_CheckoutAutoComplete`) lets you build form autocomplete functionality using third-party address providers such as PostcodeNL or Google Places. Instead of wiring a provider directly into checkout templates, you implement a service adapter that the abstraction layer manages for you.

Already integrated providers

Before building a custom adapter, check the list of [address finders and address autocomplete integrations](../available-address-finders.html) that are already available for Hyva Checkout.

## Installation

Install the `hyva-themes/magento2-hyva-checkout-autocomplete` Composer package:

```
composer require hyva-themes/magento2-hyva-checkout-autocomplete
```

## Requirements

- PHP 8.1 or higher

## Building a Custom Autocomplete Adapter

To integrate an address autocomplete provider with Hyva Checkout, you need three things: a custom Magento module, a service adapter class, and dependency injection configuration. The sections below walk through each step.

### Step 1: Create the Module

Create a custom Magento module with a `sequence` entry for `Hyva_CheckoutAutoComplete`. The sequence entry ensures the autocomplete base module loads before your adapter module.

app/code/Vendor/Module/etc/module.xml

```
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd"
>
    <module name="Vendor_Module">
        <sequence>
            <!-- Load the autocomplete abstraction layer before this module -->
            <module name="Hyva_CheckoutAutoComplete"/>
        </sequence>
    </module>
</config>
```

### Step 2: Create the Service Adapter

Create a class that extends `AbstractServiceAdapter` from the `Hyva\CheckoutAutoComplete` namespace. The adapter tells the abstraction layer how to identify and access your autocomplete service, and how to modify the checkout address form.

app/code/Vendor/Module/Model/AddressAutoCompleteServiceAdapter/YourServiceAdapter.php

```
<?php

declare(strict_types=1);

namespace Vendor\Module\Model\AddressAutoCompleteServiceAdapter;

use Hyva\Checkout\Model\Form\AbstractEntityForm;
use Hyva\Checkout\Model\Form\EntityFormModifierInterface;
use Hyva\CheckoutAutoComplete\Model\AddressAutoCompleteServiceAdapter\AbstractServiceAdapter;

class YourServiceAdapter extends AbstractServiceAdapter
{
    private array $entityFormModifiers;

    public function __construct(
        // Entity form modifiers are injected via di.xml and applied to the address form
        array $entityFormModifiers = []
    ) {
        $this->entityFormModifiers = $entityFormModifiers;
    }

    /**
     * Return a human-readable name that identifies this autocomplete service.
     */
    public function getServiceName(): string
    {
        return 'Your Service Name Here';
    }

    /**
     * Return the API client object for your autocomplete provider.
     *
     * If you are writing a compatibility module for an existing extension,
     * return its PHP API client instance here.
     */
    public function accessServiceApi(): object
    {
        // Placeholder: replace with the actual API client when integrating a real provider
        return (object) [];
    }

    /**
     * Determine whether the autocomplete form modifications should be applied.
     *
     * Use this to check preconditions, for example whether valid API
     * credentials have been configured in the Magento admin.
     */
    public function canApplyEntityFormModifications(): bool
    {
        // Add your own condition here, e.g. check system configuration values
    }

    /**
     * Apply all registered entity form modifiers to the address form.
     */
    public function modifyEntityForm(AbstractEntityForm $form): void
    {
        /** @var EntityFormModifierInterface $modifier */
        foreach ($this->entityFormModifiers as $modifier) {
            $modifier->apply($form);
        }
    }
}
```

The four adapter methods

- `getServiceName()` returns a human-readable label for your provider.
- `accessServiceApi()` returns the API client object your provider needs.
- `canApplyEntityFormModifications()` acts as a gate: return `true` only when the service is properly configured.
- `modifyEntityForm()` applies form modifiers to the checkout address form.

### Step 3: Register the Adapter via Dependency Injection

Register your adapter with the `AddressAutoCompleteServiceAdapterProvider` in your module's `di.xml`. The abstraction layer will then pick up your adapter automatically.

app/code/Vendor/Module/etc/di.xml

```
<!-- Register the custom adapter so the autocomplete layer discovers it -->
<type name="Hyva\CheckoutAutoComplete\Model\AddressAutoCompleteServiceAdapterProvider">
    <arguments>
        <argument name="adapters" xsi:type="array">
            <item name="your_service_name" xsi:type="object">
                \Vendor\Module\Model\AddressAutoCompleteServiceAdapter\YourServiceAdapter
            </item>
        </argument>
    </arguments>
</type>
```

The `name` attribute on the `<item>` element (`your_service_name` in the example above) should be a unique snake\_case identifier for your autocomplete service.
