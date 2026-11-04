<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/adding-custom-address-attributes.html -->

# Adding Custom Address Attributes to Hyvä Checkout

Hyvä Checkout automatically renders customer **address** EAV attributes in the shipping and billing address forms. Creating one is the standard Magento approach, a data patch that calls `addAttribute()`, with a single Hyvä-specific requirement: the address attribute must be assigned to the `customer_register_address` form.

Available since Hyvä Checkout 1.3.15 and 3.0.0-beta1

EAV attribute support in the Hyvä Checkout address forms ships with the stable **1.3.15** release and with **3.0.0-beta1** (it was first previewed in the 1.3.1000 betas). It works the same on both release lines. Earlier 1.3.x releases don't have it. See [Upgrading to 1.3.15](../../upgrading/upgrading-to-1.3.15.html) and [Upgrading to 3.0.0-beta1](../../upgrading/upgrading-to-3.0.0-beta1.html).

## Supported EAV Input Types in Checkout Address Forms

Hyvä Checkout renders and validates these EAV frontend input types in the shipping and billing address forms:

| Input type | Renders as |
| --- | --- |
| `text` | Single-line text input |
| `textarea` | Multi-line text area |
| `date` | Date input |
| `select` | Dropdown |
| `boolean` | Yes/No dropdown |
| `multiselect` | Multiple select |
| `multiline` | Multiple single-line inputs |

The `file` and `image` input types are **not** supported in the Hyvä Checkout address forms.

## Step 1 - Create the Address Attribute in a Data Patch

Create the address attribute the standard Magento way, from a data patch in your module. This example adds `example_attribute` to the address entity as a single-line text input:

Vendor/Module/Setup/Patch/Data/AddCheckoutAddressAttribute.php

```
$customerSetup->addAttribute(
    \Magento\Customer\Api\AddressMetadataInterface::ENTITY_TYPE_ADDRESS,
    'example_attribute',
    [
        'label'        => 'Example Attribute',
        'type'         => 'varchar', // storage/backend type
        'input'        => 'text',    // one of the supported input types above
        'required'     => false,
        'system'       => false,
        'user_defined' => true,
        'sort_order'   => 100,
    ]
);
```

Option-based and multiline types need a little more

- For `select` and `multiselect`, also provide a source model and options, for example `'source' => \Magento\Eav\Model\Entity\Attribute\Source\Table::class` and `'option' => ['values' => ['One', 'Two', 'Three']]`. `multiselect` additionally needs `'backend' => \Magento\Eav\Model\Entity\Attribute\Backend\ArrayBackend::class`.
- For `multiline`, set `'multiline_count'` to the number of lines.
- To render min/max length validation, store `validate_rules` on the attribute, for example `['min_text_length' => 3, 'max_text_length' => 20]`.

## Step 2 - Assign the Attribute to the customer\_register\_address Form

Assigning the attribute to `customer_register_address` is the only Hyvä-specific step. An address attribute is only rendered in the Hyvä Checkout address forms when its `used_in_forms` list includes `customer_register_address`:

Vendor/Module/Setup/Patch/Data/AddCheckoutAddressAttribute.php

```
$attribute = $customerSetup->getEavConfig()->getAttribute(
    \Magento\Customer\Api\AddressMetadataInterface::ENTITY_TYPE_ADDRESS,
    'example_attribute'
);

// customer_register_address is what makes the attribute show up in Hyvä Checkout.
// The other two forms are optional, they expose the attribute in the customer
// account address form and in the admin customer address form.
$attribute->setData('used_in_forms', [
    'customer_register_address',
    'customer_address_edit',
    'adminhtml_customer_address',
]);

$this->attributeResource->save($attribute);
```

## Step 3 - Apply the Data Patch and Flush the Cache

Run the data patch and clear the cache so Hyvä Checkout picks up the new address attribute:

```
bin/magento setup:upgrade
bin/magento cache:flush
```

The attribute now renders in the Hyvä Checkout shipping and billing address forms, with validation applied from its EAV configuration.

## Saving Submitted Custom Address Attribute Values

Hyvä Checkout renders and validates custom address attributes, but where the submitted values end up depends on which Magento edition you run.

Storing submitted values is your responsibility on Magento Open Source

On **Magento Open Source**, Hyvä Checkout does not persist custom address attribute values out of the box, there is no save service for them. You need to implement your own save service to store the submitted values.

On **Adobe Commerce**, these values are saved automatically through the `Magento_CustomerCustomAttributes` module, giving parity with the native Luma checkout.

## Related Topics

- **[Field Attributes](field-attributes.html)**: Attributes you can set on a rendered form field, such as labels, placeholders and validation rules
- **[Entity Form Modifiers](entity-form-modifiers.html)**: Change or remove address fields after Hyvä Checkout builds the form from EAV attributes
- **[Form Customization Overview](index.html)**: How entity forms, modifiers and renderers fit together
- **[Upgrading to 1.3.15](../../upgrading/upgrading-to-1.3.15.html)**: Review the address form configuration data migration
- **[Upgrading to 3.0.0](../../upgrading/upgrading-to-3.0.0.html)**: Upgrade to Checkout 3.x
