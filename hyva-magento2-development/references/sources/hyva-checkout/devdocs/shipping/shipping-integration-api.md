<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/shipping/shipping-integration-api.html -->

# Shipping Integration API for Hyvä Checkout

The Hyvä Checkout Shipping Integration API lets you register custom shipping methods, configure display properties like icons, and add interactive UI elements for features like pickup location selection or delivery time slots. If a shipping method needs customer interaction beyond just selecting a rate, this API is how you wire it up.

Shipping methods enabled in Magento system configuration automatically appear in the Hyvä Checkout shipping step. This page covers how to register custom templates, add Magewire components for dynamic behavior, and configure display metadata like icons.

## Registering a Shipping Method Template in Hyvä Checkout

Any active Magento shipping method shows up in checkout without extra configuration. But when a shipping method needs additional customer input - like choosing a pickup point or selecting a delivery window - you need to register a template block that renders the custom UI when the customer selects that method.

### Layout XML Block Registration for Shipping Methods

Register shipping method templates as children of the `checkout.shipping.methods` block in your module's `layout/hyva_checkout_components.xml` file. The block `as` attribute (alias) must follow the pattern `carrierCode_methodCode`.

view/frontend/layout/hyva\_checkout\_components.xml

```
<!-- Register a custom shipping method template in Hyvä Checkout -->
<referenceBlock name="checkout.shipping.methods">
    <!-- The "as" attribute links this block to the correct shipping method -->
    <block name="checkout.shipping.method.custom-shipping"
           as="carrierCode_methodCode"
           template="Hyva_Checkout::component/shipping/method/custom-shipping.phtml"/>
</referenceBlock>
```

Block Alias Format

The `as` attribute must start with the carrier code, followed by an underscore, then the method code (e.g., `flatrate_flatrate`, `tablerate_bestway`). Hyvä Checkout uses this alias to associate the template with the correct shipping method.

The template renders only when the customer selects the corresponding shipping method. Template naming conventions are flexible, but following the pattern shown above keeps things maintainable.

### Adding a Magewire Component to a Shipping Method

For shipping methods that need dynamic server interaction - like fetching pickup locations from an API or calculating delivery windows on the fly - add a Magewire component by specifying the `magewire` argument on the block.

view/frontend/layout/hyva\_checkout\_components.xml

```
<!-- Shipping method block with a Magewire component for dynamic behavior -->
<referenceBlock name="checkout.shipping.methods">
    <block name="checkout.shipping.method.custom-shipping"
           as="carrierCode_methodCode"
           template="Hyva_Checkout::component/shipping/method/custom-shipping.phtml">
        <arguments>
            <!-- The Magewire component handles server-side logic (e.g., API calls, calculations) -->
            <argument name="magewire" xsi:type="object">
                Hyva\Checkout\Magewire\Checkout\Shipping\CustomShipping
            </argument>
        </arguments>
    </block>
</referenceBlock>
```

The Magewire component handles all server-side logic while the `.phtml` template manages the UI. Check out the [Magewire documentation](../../magewire/index.html) for details on building Magewire components.

## Configuring Shipping Method Display Properties

You can configure frontend display properties using metadata block arguments. Metadata extends shipping methods with features like icons without modifying the underlying Magento shipping method object.

### Displaying an Icon for a Shipping Method

Display an icon next to the shipping method title using either SVG icons or image files.

Available Since Version 1.1.27

Shipping method icon support was introduced in Hyvä Checkout version 1.1.27.

#### SVG Icons for Shipping Methods

Load SVG icons from a [Hyvä icon pack extension](../../../hyva-themes/view-utilities/hyva-svg-icon-modules/index.html) or from your module's `view/frontend/web/svg` folder. The `svg` item value follows the format `icon-pack-name/icon-name`.

view/frontend/layout/hyva\_checkout\_components.xml

```
<!-- Add an SVG icon to the tablerate_bestway shipping method -->
<referenceBlock name="checkout.shipping.methods">
    <block name="checkout.shipping.method.tablerate_bestway"
           as="tablerate_bestway">
        <arguments>
            <argument name="metadata" xsi:type="array">
                <item name="icon" xsi:type="array">
                    <!-- Format: icon-pack-name/icon-name -->
                    <item name="svg" xsi:type="string">payment-icons/clean/paypal</item>
                    <!-- Optional: pass additional SVG attributes -->
                    <item name="attributes" xsi:type="array">
                        <item name="fill" xsi:type="string">none</item>
                    </item>
                </item>
            </argument>
        </arguments>
    </block>
</referenceBlock>
```

For more on working with SVG icons and the `SvgIcons` view model, see the [SvgIcons documentation](../../../hyva-themes/writing-code/working-with-view-models/svgicons.html).

#### Image Icons for Shipping Methods

Load image files from your module's `view/frontend/web/` directory using the `src` item. Magento's asset repository resolves the path, so you use the standard `Module_Name::filename` notation.

view/frontend/layout/hyva\_checkout\_components.xml

```
<!-- Add an image icon to the tablerate_bestway shipping method -->
<referenceBlock name="checkout.shipping.methods">
    <block name="checkout.shipping.method.tablerate_bestway"
           as="tablerate_bestway">
        <arguments>
            <argument name="metadata" xsi:type="array">
                <item name="icon" xsi:type="array">
                    <!-- Image path uses Magento's asset repository notation -->
                    <item name="src" xsi:type="string">Magento_Theme::calendar.png</item>
                    <!-- Optional: HTML attributes applied to the img tag -->
                    <item name="attributes" xsi:type="array">
                        <item name="width" xsi:type="number">100</item>
                        <item name="loading" xsi:type="string">lazy</item>
                        <item name="alt" xsi:type="string" translate="true">Calendar icon</item>
                        <item name="data-my-custom-attribute" xsi:type="string">Hello World!</item>
                    </item>
                </item>
            </argument>
        </arguments>
    </block>
</referenceBlock>
```

## Related Topics

- **[Magewire Documentation](../../magewire/index.html)** - Learn how to build Magewire components for dynamic shipping method functionality
- **[Hyvä SVG Icon Modules](../../../hyva-themes/view-utilities/hyva-svg-icon-modules/index.html)** - Set up icon packs for use with shipping method icons
- **[SvgIcons View Model](../../../hyva-themes/writing-code/working-with-view-models/svgicons.html)** - Work with SVG icons in Hyvä themes using the SvgIcons view model
