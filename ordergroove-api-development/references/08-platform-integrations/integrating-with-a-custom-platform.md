# Product Feed

The Product Feed is a file sent to our platform via SFTP on a recurring basis to keep Ordergroove in sync with your product information. It should include all products, whether or not they're eligible for subscriptions. We check for new files every 30 minutes, so you can refresh as often as that.

**Note**: If you're not sending the feed continuously throughout the day, we recommend running it before order placement to avoid rejections from out-of-stock items.

***

## Requirements

The product feed should be created with the following format:

Filename: \<MERCHANT\_ID>.Products.xml\
Drop site location: \<SFTP\_SITE>

> 🚧 Note
>
> Any applicable field containing special characters (e.g. &, trademark symbols, accents, etc.) must be wrapped in CDATA. Best practice is to always wrap product names and category names in CDATA at a minimum.
>
> Fields labeled "Optional" should be excluded from the file if they do not contain a specific value, as we will attempt to validate them if they are included. Example: if not setting an "in\_stock" boolean value, please remove \<in\_stock>\</in\_stock> tagging entirely vs. adding empty tags or using self-closing XML tags eg \<in\_stock/>.

***

## Example

```xml
<products>
...
<product>
  <name><![CDATA[Product XYZ]]></name>
  <product_id>AB4483902</product_id>
  <sku>45987234980</sku>
  <groups> // These fields are optional
    <group type="sku_swap"><![CDATA[Product Group A]]></group>
    <group type="incentive"><![CDATA[Incentive Group A]]></group>
  </groups>
  <price>19.99</price>
  <details_url>http://www.merchanturl.com/details/product.com</details_url>
  <image_url>https://www.merchanturl.com/images/product.jpg</image_url>
  <autoship_eligible>1</autoship_eligible> //Optional
  <in_stock>1</in_stock>
  <discontinued>0</discontinued> //Optional
  <extra_data> //Optional
    <field key="variant_name">Size X</field>
  </extra_data>
  <relationships> //These fields are optional
    <relationship>
      <name>discontinued_replacement</name>
        <related>
          <product_id>12</product_id>
        </related>
      </relationship>
    </relationships>
  <every>6</every> //Optional
  <every_period>2</every_period> //Optional
</product>
...
</products>
```

***

## Field Definition

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr style="background-color: #8171dc; color: #fff; font-weight: bold;">
        <td style="width: 25%; padding-left: 5px;">
          <font color="#2f3941" face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px; font-weight: 400;">Field</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font color="#2f3941" face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px; font-weight: 400;">Description</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font color="#2f3941" face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px; font-weight: 400;">Data Type</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font color="#2f3941" face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px; font-weight: 400;">Validation</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">name</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">The name of the product</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 1024 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">product_id</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">The unique identifier of the product in your database</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 64 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">sku</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">The product's SKU</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 64 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">groups</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">(optional)</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Used for SKU Swap and Incentives. All products assigned to the same group will be swappable between each other</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 64 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">price</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">The price of the product</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Decimal up to 99999999.99</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Must be a decimal (not wrapped in quotation marks), must have two digits after decimal point. This should not be set to anything other than what the customer should be charged (shouldn't change to $0, for example)</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">details_url</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Fully qualified URL of the product details page</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 400 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">image_url</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">Fully qualified URL of the product's image file</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 400 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Note: Must be HTTPS</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">autoship_eligible</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">(optional)</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">A flag that marks the product as eligible for subscription</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">0 = not eligible</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">1 = eligible</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Tinyint(1)</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Must be 1 or 0 as a value, must not be wrapped in quotation marks</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">in_stock</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">A flag that marks the product as available in terms of inventory. 1=In stock, 0=Out of Stock. A product can become temporarily out of stock, which will temporarily stop orders being placed with that product. Additionally, no checkout flow offers will be served for out of stock products, but impulse upsell offers will be served as the product may come back in stock prior to order placement</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Tinyint(1)</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Must be 1 or 0 as a value, must not be wrapped in quotation marks</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">discontinued</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">(optional)</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">An optional flag that marks the product as no longer available.<br><br>0=Not discontinued<br>1=Discontinued.<br><br>When we receive a discontinued flag, all subscriptions with that product will be cancelled and the customer will be notified via email. If a product is discontinued, it must be ineligible for autoship<br>(autoship_eligible = 0)<br>out of stock (in_stock = 0)</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Tinyint(1)</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;"><span>Must be 1 or 0 as a value, must not be wrapped in quotation marks.</span><br><br>NOTE: In order to discontinue a product it must also be marked as Not Eligible and Out of Stock.</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">extra_data</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">(optional)</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">The value to be displayed in the SKU swap dropdown. Optional field - can be used to display a name other than the full product name</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 1024 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">relationships</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">(optional)</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">This is where the related product ID can be defined for discontinued product replacement SKU swap. The relationship name within this node will determine if an e-mail will be triggered. If the relationship name = discontinued_silent_replacement, subscribers will NOT be informed of the swap. If the relationship name = discontinued_replacement, an e-mail will be sent to all subscribers of the product to inform them of the swap.<br><br>NOTE: The subscriber will only be notified once the swap has been completed.</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String, up to 64 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">every</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">(optional)</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">The number of days, weeks, or months used in order to specify a product-specific default frequency.</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">INT, up to 10 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">&nbsp;</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">every_period</span>
            </font>
          </p>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">(optional)</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">The frequency period used in order to specify a product-specific default frequency where:<br>1 = days<br>2 = weeks<br>3 = months<br>4 = years</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">INT, up to 6 characters</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">Example:<br>&lt;every&gt;4&lt;/every&gt;<br>&lt;every_period&gt;2&lt;/every_period&gt;<br><br>The above example translates into 4 weeks</span>
          </font>
        </td>
      </tr>
      <tr>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">product_type</span>
          </font>
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">&nbsp;</span>
            </font>
          </p>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
              <span style="font-size: 15px;">The type of product, default is standard.</span>
            </font>
          </p>
          <ul>
            <li>
              <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
                <span style="font-size: 15px;">standard</span>
              </font>
            </li>
            <li>
              <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
                <span style="font-size: 15px;">static price bundle</span>
              </font>
            </li>
            <li>
              <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
                <span style="font-size: 15px;">dynamic price bundle</span>
              </font>
            </li>
          </ul>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <font face="-apple-system, system-ui, Segoe UI, Helvetica, Arial, sans-serif">
            <span style="font-size: 15px;">String</span>
          </font>
        </td>
        <td style="width: 25%; padding-left: 5px;">
          <p>
            product_type will always be set to <em>standard</em> if nothing
            is provided. On product creation can be set to a bundle type.
          </p>
          <p>
            <strong>product_type cannot be changed after product creation</strong>
          </p>
        </td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>