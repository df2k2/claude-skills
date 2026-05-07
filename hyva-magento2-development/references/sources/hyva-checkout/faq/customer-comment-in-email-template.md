<!-- source: https://docs.hyva.io/hyva-checkout/faq/customer-comment-in-email-template.html -->

# Adding Customer Comments to Order Email Templates in Hyvä Checkout

By default, Hyvä Checkout stores customer comments in the order notes collection rather than the order object's `customer_note` field. This means the comment is not available in order email templates out of the box.

To include the customer comment in your order confirmation emails, you need two things: a `fieldset.xml` mapping that copies the comment to the order object, and an email template snippet that renders the comment.

## Step 1: Map the Customer Comment to the Order Object

Hyvä Checkout needs a fieldset mapping to copy the `customer_comment` quote field into the `customer_note` field on the order object. Create a `fieldset.xml` file inside your module's `etc/` directory.

The following `fieldset.xml` maps the quote's `customer_comment` field to the order's `customer_note` field during the quote-to-order conversion:

app/code/Vendor/Module/etc/fieldset.xml

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:DataObject/etc/fieldset.xsd">
    <scope id="global">
        <!-- Map the customer_comment from quote to customer_note on the order -->
        <fieldset id="sales_convert_quote">
            <field name="customer_comment">
                <aspect name="to_order" targetField="customer_note"/>
            </field>
        </fieldset>
    </scope>
</config>
```

Once this mapping is in place, the `customer_note` field on the order object is populated whenever a new order is placed with a customer comment.

## Step 2: Display the Customer Comment in the Email Template

With the `customer_note` field now available on the order object, you can render the comment in your order email template. Add the following snippet to your email template to conditionally display the customer comment:

```
{{depend order_data.customer_note}}
    <table class="message-info">
        <tr>
            <td>
                {{var order_data.customer_note|escape|nl2br}}
            </td>
        </tr>
    </table>
{{/depend}}
```

About the escape and nl2br filters

The `escape` filter sanitizes the comment string, stripping out HTML and other potentially unsafe content. The `nl2br` filter converts newline characters into `<br>` tags so the comment displays with proper line breaks in the email.
