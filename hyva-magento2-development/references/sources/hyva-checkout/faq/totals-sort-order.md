<!-- source: https://docs.hyva.io/hyva-checkout/faq/totals-sort-order.html -->

# Controlling Totals Sort Order in Hyvä Checkout

Custom totals items (like a custom fee) can be injected into the Hyvä Checkout price summary using a phtml template. You do this by adding a custom block to the `price-summary.total-segments` block via layout XML, with a child block aliased using the total name (e.g., `custom_fee`).

The following layout XML example adds a custom fee total segment to the Hyvä Checkout price summary:

view/frontend/layout/hyva\_checkout\_components.xml

```
<!-- Add a custom total segment to the Hyvä Checkout price summary -->
<referenceBlock name="price-summary.total-segments">
    <block name="price-summary.total-segments.custom_fee"
           as="custom_fee"
           template="..."
    />
</referenceBlock>
```

## Why Layout XML `before` and `after` Attributes Don't Control Sort Order

It might seem logical to use the `after` or `before` layout XML attributes to control the display order of totals. However, these attributes only affect the virtual block structure - they don't change the visible order in the checkout.

Hyvä Checkout respects Magento's system configuration for totals sort order instead. This means administrators can adjust the order through config values rather than requiring a developer to modify layout XML.

## Setting the Default Totals Sort Order via `config.xml`

You can set the default sort order for a custom total by adding it to the `totals_sort` configuration group in your module's `config.xml`. The numeric value determines the position - lower numbers appear first.

etc/config.xml

```
<?xml version="1.0"?>
<!-- Define the default sort order for the custom_fee total segment -->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Store:etc/config.xsd"
>
    <default>
        <sales>
            <totals_sort>
                <!-- Sort order value: lower numbers appear first -->
                <custom_fee>69</custom_fee>
            </totals_sort>
        </sales>
    </default>
</config>
```

## Making Totals Sort Order Configurable in the Magento Admin Panel

To let administrators change the sort order without touching code, add a field to the Magento admin system configuration. This field references the `totals_sort` group and appears under **Sales > Sales > Checkout Totals Sort Order**.

etc/adminhtml/system.xml

```
<?xml version="1.0"?>
<!-- Add an admin-configurable sort order field for the custom_fee total -->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Config:etc/system_file.xsd"
>
    <system>
        <section id="sales">
            <group id="totals_sort">
                <!-- This field lets admins override the default sort order -->
                <field id="custom_fee"
                       translate="label"
                       type="text"
                       sortOrder="4"
                       showInDefault="1"
                       showInWebsite="1"
                       canRestore="1"
                >
                    <label>Custom Fee</label>
                    <validate>required-number validate-number</validate>
                </field>
            </group>
        </section>
    </system>
</config>
```

No Code Changes Needed

Once this admin field is in place, store administrators can adjust the custom fee's position in the checkout totals summary directly from **Stores > Configuration > Sales > Sales > Checkout Totals Sort Order**.
