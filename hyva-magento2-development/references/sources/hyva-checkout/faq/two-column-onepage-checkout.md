<!-- source: https://docs.hyva.io/hyva-checkout/faq/two-column-onepage-checkout.html -->

# How to Create a Two-Column Onepage Checkout

Hyva Checkout supports multiple checkout layouts, including a two-column onepage checkout. By default, the onepage checkout uses a three-column layout, but you can register a custom checkout variant with a `2columns` layout to create a streamlined two-column onepage checkout. This guide walks through the full setup: declaring the checkout, selecting it in the admin, and adjusting the layout XML.

## Step 1: Declare the Custom Checkout

Register a new checkout in an `etc/hyva_checkout.xml` file inside your theme or a custom module.

Warning

The file path is `etc/hyva_checkout.xml` even inside a theme. Do **not** place it in `Hyva_Checkout/etc/hyva_checkout.xml`, which is a common mistake.

The following `hyva_checkout.xml` declaration registers a checkout named `client` with a two-column onepage layout:

etc/hyva\_checkout.xml

```
<!-- Register a two-column onepage checkout named "client" -->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Hyva_Checkout:etc/hyva_checkout.xsd">
    <checkout name="client"
              label="Client Two-Column Onepage"
              layout="2columns"
              parent="onepage"/>
</config>
```

The key attributes in this declaration:

- **`name`** - A unique identifier for the checkout (for example, `client`).
- **`layout`** - Set to `2columns` for a two-column layout.
- **`parent`** - Set to `onepage` so the checkout inherits the onepage checkout behavior.

## Step 2: Activate the Custom Checkout

After declaring the checkout, flush the Magento cache and then select the new `client` checkout in the Hyva Checkout configuration section of the Magento admin.

```
bin/magento cache:flush
```

Navigate to **Stores > Configuration > Hyva Themes > Checkout** and select the `client` checkout from the dropdown.

## Step 3: Create the Layout XML

Because the two-column layout removes the third column present in the default three-column onepage checkout, you need to move any components from that third column into one of the two remaining columns.

Create a layout XML file named after your checkout. The file name follows the pattern `hyva_checkout_<name>.xml`:

Warning

The layout file for a checkout named `client` with parent `onepage` is `hyva_checkout_client.xml`, **not** `hyva_checkout_client_onepage.xml`.

Hyva\_Checkout/layout/hyva\_checkout\_client.xml

```
<!-- Move components from the removed third column into the remaining two columns -->
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <move element="checkout.shipping.methods"
              destination="columns.main"
              after="-"/>
        <!-- Add additional move directives for any other components -->
    </body>
</page>
```

## Result

The two-column onepage checkout displays all checkout components across two columns with no breadcrumb navigation. This layout works well for stores that want a more compact, streamlined checkout experience.

Tip

If a component does not appear after switching to the two-column layout, check that you have moved it from the removed third column into either `columns.main` or `columns.sidebar` in your layout XML file.
