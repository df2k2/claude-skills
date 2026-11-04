<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/payments/payment-integration-api.html -->

# Payment Integration API for Hyva Checkout

The Hyva Checkout Payment Integration API lets you register payment methods, configure display properties like icons and subtitles, and implement `EvaluationInterface` to control checkout flow based on payment status. This page covers layout XML registration, metadata arguments, and the evaluation system that gates the Place Order button.

## Registering a Payment Method in Layout XML

Any payment method enabled in Magento system configuration automatically appears in the Hyva Checkout payment step. However, payment methods that require customer interaction (forms, redirects, or SDK integrations) must register a template block so their UI renders when the customer selects the method.

Register payment method templates as children of the `checkout.payment.methods` block in your module's `hyva_checkout_components.xml` layout file. The block `as` attribute must exactly match the Magento payment method code.

view/frontend/layout/hyva\_checkout\_components.xml

```
<!-- Register a payment method template block under checkout.payment.methods -->
<referenceBlock name="checkout.payment.methods">
    <!-- The "as" alias MUST match the Magento payment method code -->
    <block name="checkout.payment.method.checkmo"
           as="checkmo"
           template="Hyva_Checkout::component/payment/method/checkmo.phtml"/>
</referenceBlock>
```

Block alias must match the payment method code

The `as="checkmo"` attribute must exactly match the Magento payment method code. Hyva Checkout uses the alias to associate the template with the correct payment method. If the alias does not match, the template will not render.

The template renders only when the customer selects the payment method. Payment method display order is determined by the Magento system configuration **Sort Order** values, not by block order in layout XML.

## Accessing Payment Method Data in Templates

Inside the payment template `.phtml` file, access the `PaymentMethodInterface` instance through the block's `method` data key.

component/payment/method/checkmo.phtml

```
<?php
/** @var \Magento\Quote\Api\Data\PaymentMethodInterface $method */
$method = $block->getData('method');

// Access payment method properties
$methodCode  = $method->getCode();   // e.g. "checkmo"
$methodTitle = $method->getTitle();  // e.g. "Check / Money Order"
```

For simple payment methods that only display information (like Check/Money Order), the template alone is sufficient. See the built-in example at `hyva-themes/magento2-hyva-checkout/src/view/frontend/templates/component/payment/method/checkmo.phtml`.

## Configuring Payment Method Display Properties with Metadata

Configure frontend display properties such as icons and subtitles using the `metadata` block argument in layout XML. Metadata extends payment methods with visual features without modifying the Magento payment method object itself.

### Adding an SVG Icon to a Payment Method

Display an SVG icon next to the payment method title by loading it from a [Hyva icon pack extension](../../../hyva-themes/view-utilities/hyva-svg-icon-modules/index.html) or from your module's `view/frontend/web/svg` folder.

The `metadata` argument nests the icon configuration inside the block's `<arguments>` node. The `svg` item specifies the icon path in `icon-pack-name/icon-name` format.

view/frontend/layout/hyva\_checkout\_components.xml

```
<referenceBlock name="checkout.payment.methods">
    <block name="checkout.payment.method.checkmo"
           as="checkmo"
           template="Hyva_Checkout::component/payment/method/checkmo.phtml">
        <arguments>
            <argument name="metadata" xsi:type="array">
                <item name="icon" xsi:type="array">
                    <!-- Path format: icon-pack-name/icon-name or module svg path -->
                    <item name="svg" xsi:type="string">payment-icons/light/paypal</item>
                    <!-- Optional: pass extra SVG attributes -->
                    <item name="attributes" xsi:type="array">
                        <item name="fill" xsi:type="string">none</item>
                    </item>
                </item>
            </argument>
        </arguments>
    </block>
</referenceBlock>
```

Available since Hyva Checkout 1.0.5

SVG icon support in payment method metadata was introduced in Hyva Checkout version 1.0.5.

### Adding an Image Icon to a Payment Method

Load a raster image (PNG, JPG) from your module's `view/frontend/web/` directory using the `src` item instead of `svg`. Magento's asset repository resolves the image path at runtime.

view/frontend/layout/hyva\_checkout\_components.xml

```
<referenceBlock name="checkout.payment.methods">
    <block name="checkout.payment.method.checkmo"
           as="checkmo"
           template="Hyva_Checkout::component/payment/method/checkmo.phtml">
        <arguments>
            <argument name="metadata" xsi:type="array">
                <item name="icon" xsi:type="array">
                    <!-- Use "src" for raster images instead of "svg" -->
                    <item name="src" xsi:type="string">Magento_Payment::images/cc/vi.png</item>
                    <!-- Optional: HTML attributes for the rendered <img> tag -->
                    <item name="attributes" xsi:type="array">
                        <item name="width" xsi:type="number">100</item>
                        <item name="loading" xsi:type="string">lazy</item>
                        <item name="alt" xsi:type="string" translate="true">VISA card icon</item>
                    </item>
                </item>
            </argument>
        </arguments>
    </block>
</referenceBlock>
```

Available since Hyva Checkout 1.1.22

Image icon support in payment method metadata was introduced in Hyva Checkout version 1.1.22.

### Adding a Subtitle to a Payment Method

Display a subtitle below the payment method title using the `subtitle` metadata item. The subtitle value can be either a static string or a Magento system configuration path that resolves at runtime.

Use a plain string for a fixed subtitle:

view/frontend/layout/hyva\_checkout\_components.xml

```
<referenceBlock name="checkout.payment.methods">
    <referenceBlock name="checkout.payment.method.checkmo">
        <arguments>
            <argument name="metadata" xsi:type="array">
                <!-- Static subtitle text shown below the method title -->
                <item name="subtitle" xsi:type="string">
                    Visa, Mastercard &amp; More
                </item>
            </argument>
        </arguments>
    </referenceBlock>
</referenceBlock>
```

Use a configuration path to load the subtitle from Magento admin settings:

view/frontend/layout/hyva\_checkout\_components.xml

```
<argument name="metadata" xsi:type="array">
    <!-- Config path resolves to the value stored in core_config_data -->
    <item name="subtitle" xsi:type="string">payment/my-psp/my-awesome-subtitle</item>
</argument>
```

## Controlling Checkout Flow with EvaluationInterface

Payment methods that require customer interaction should implement `EvaluationInterface` to control the checkout flow. The `evaluateCompletion()` method returns an evaluation result that decides whether the customer can continue: a `Success` result lets them, and an `ErrorMessage` result stops the navigation and tells them what's missing.

### Evaluation Result Types for Payment Methods

The `EvaluationResultFactory` provides the two result types that control whether a click on Proceed or Place Order continues:

| Result Type | Effect | When to Use |
| --- | --- | --- |
| `ErrorMessage` (`createErrorMessage()->withMessage(...)`) | Stops the navigation with a message | The customer has not completed a required payment action |
| `Success` (`createSuccess()`) | Lets the customer continue | The customer has provided all required payment data |

Implement `evaluateCompletion()` on your payment method model to return the appropriate result. The method receives an `EvaluationResultFactory` and must return an `EvaluationResultInterface`.

EvaluationInterface Implementation

```
public function evaluateCompletion(EvaluationResultFactory $factory): EvaluationResultInterface
{
    // Return Success only when all required payment data is present
    return $this->isRequiredDataPresent()
        ? $factory->createSuccess()
        : $factory->createErrorMessage()->withMessage('Please complete your payment details.'); // Stops navigation with a message
}

private function isRequiredDataPresent(): bool
{
    // Check for payment token, authorization, or other required data
    // ...
}
```

Evaluation only runs for the selected payment method

The `evaluateCompletion()` method is only called when the customer has selected the payment method. Unselected payment methods do not affect checkout flow.

## Frontend Payment Flow Examples

The following tables illustrate typical payment flows from the customer's perspective, showing how `EvaluationInterface` results control whether the customer can continue with Proceed or Place Order at each step.

### Redirect to PSP Payment Flow

In a redirect flow, the customer leaves the checkout to complete payment on the PSP website, then returns with an authorization token.

| Step | Customer Action | Payment UI State | Proceed / Place Order | Evaluation |
| --- | --- | --- | --- | --- |
| 1 | Visits payment step | No method selected | Stops with "Please select a payment method" | - |
| 2 | Selects payment method | Displays redirect button(s) | Stops with a message | `ErrorMessage` |
| 3 | Clicks PSP button | Transferred to PSP website | - | - |
| 4 | Completes PSP form | PSP sends token to Magento | - | - |
| 5 | Redirected to checkout | Shows "Payment Authorized" message | Continues | `Success` |

### Iframe or Hosted Form Payment Flow

In an iframe flow, the PSP form renders inline within the checkout page. The customer completes the form without leaving the page.

| Step | Customer Action | Payment UI State | Proceed / Place Order | Evaluation |
| --- | --- | --- | --- | --- |
| 1 | Visits payment step | No method selected | Stops with "Please select a payment method" | - |
| 2 | Selects payment method | PSP form displays in iframe | Stops with a message | `ErrorMessage` |
| 3 | Enters payment data | Waiting for PSP token | Stops with a message | `ErrorMessage` |
| 4 | Completes PSP form | Shows "Payment Authorized" message | Continues | `Success` |
