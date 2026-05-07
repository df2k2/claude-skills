# Recurring Order Placement

Learn how to implement recurring order placement for subscription orders using Ordergroove's XML-based API or batch methods, including request/response formats and error handling.

To receive recurring subscription orders, your system needs to ingest XML containing the order information. From there, you'll build the cart on your backend using the data from Ordergroove, process the order, and return an XML response indicating success or failure. The order XML is based on what was passed in the Purchase POST, plus any incentives Ordergroove powers for the program.

You don't need to use every field in the XML to create an order — for example, you might ignore Order Subtotal Value and rely on Order Total Value instead. Ordergroove can send orders as often as once an hour. When choosing a merchant's daily order placement hour, we avoid 02:00 and 15:00 (CST) as the first hour of the day, since they can conflict with our release schedule and daylight savings time.

***

## API Method

To use the API method, you need to expose an endpoint to which we will send the order information via an HTTPS POST. There is one request/response pair per order.

Ordergroove includes the following [Authentication Header](https://developer.ordergroove.com/docs/hmac-and-aes-authentication) with all API calls:

```text
Content-Type: application/xml
Authorization: {"public_id": "<merchant_public_id>", "sig": "<signature>", "ts": <timestamp>, "sig_field": "<merchant_user_id>"} 
```

## Batch Method

Ordergroove also supports batching orders together into a file and dropping it on the OG SFTP drop site so you can process the orders at your leisure. OG will supply you with the necessary credentials for access to the drop site. Once you have retrieved the order file you will need to remove/delete it from the SFTP. The drop site is also where you would drop off the respective response files containing the results of orders you have processed.

**Filename Structures:**

* Batch request filename: `<MERCHANT_ID>_batch_orders_MM-DD-YYYY_HHMMSS.xml`
* Batch response filename: `<MERCHANT_ID>.BatchResponseMM-DD-YYYY_HHMMSS.xml`

> 📘 Note
>
> The end of the request and response filenames are time-stamped to ensure that no files are overwritten.

## Example XML Request

```xml
<?xml version="1.0" encoding="UTF-8"?>
<order>
  <head>
    <orderOgId>17071718</orderOgId>                                                 <!-- Recurring OG Order ID -->
    <orderPublicId>0a52e64caa1911ecbea15e94dbd6dbdx</orderPublicId>                 <!-- Recurring Public Order ID -->
    <orderOgDate><![CDATA[2022-03-23]]></orderOgDate>                               <!-- Date OG Places Order -->
    <orderSourcePartnerId>196</orderSourcePartnerId>                                <!-- Merchant OG ID -->
    <orderSourcePartnerName><![CDATA[Pet Store]]></orderSourcePartnerName>          <!-- Merchant Name -->
    <orderItemsCount>1</orderItemsCount>
    <orderSubtotalValue>10.39</orderSubtotalValue>
    <orderSubtotalDiscount>0.00</orderSubtotalDiscount>
    <orderSalesTax>0.00</orderSalesTax>
    <orderDiscount>2.60</orderDiscount>                                             <!-- Sum of any recurring and one-time discounts -->
    <orderShipping>0.00</orderShipping>
    <orderTotalValue>10.39</orderTotalValue>
    <orderCurrency>USD</orderCurrency>
    <orderPaymentPublicId>3c9efe848c0511ebaf4c2ec47f35ff80</orderPaymentPublicId>   <!-- Recurring Public Payment ID -->
    <orderPaymentDataLocation>OG</orderPaymentDataLocation>
    <orderPaymentMethod>CC</orderPaymentMethod>
    <orderCcType><![CDATA[Visa]]></orderCcType>
    <orderCcOwner/>
    <orderCcNumber/>
    <orderCcExpire><![CDATA[q42FjUuxkypYzVfumFf31pIMS7y+ZfBf/PmQwRSAECE=]]></orderCcExpire>
    <orderTokenId><![CDATA[ABC123456789DEF]]></orderTokenId>                        <!-- Payment Token Provided by Merchant -->
    <orderPaymentLabel/>                                                          
  </head>
  <customer>
    <customerOgId>4778263</customerOgId>                                            <!-- Customer OG ID -->
    <customerPartnerId><![CDATA[DC69410241]]></customerPartnerId>                   <!-- Customer Merchant ID -->
    <customerName><![CDATA[Nicholas Bundy]]></customerName>
    <customerFirstName><![CDATA[Nicholas]]></customerFirstName>
    <customerLastName><![CDATA[Bundy]]></customerLastName>
    <customerEmail><![CDATA[nicholas.bundy@ordergroove.com]]></customerEmail>
    <customerLocale><![CDATA[en-us]]></customerLocale>
    <customerShippingFirstName><![CDATA[Nicholas]]></customerShippingFirstName>
    <customerShippingLastName><![CDATA[Bundy]]></customerShippingLastName>
    <customerShippingAddress><![CDATA[75 Broad St Fl 23]]></customerShippingAddress>
    <customerShippingAddress1><![CDATA[75 Broad St]]></customerShippingAddress1>
    <customerShippingAddress2><![CDATA[Fl 23]]></customerShippingAddress2>
    <customerShippingCity><![CDATA[New York]]></customerShippingCity>
    <customerShippingState><![CDATA[NY]]></customerShippingState>
    <customerShippingZip><![CDATA[10004]]></customerShippingZip>
    <customerShippingPhone/>
    <customerShippingFax/>
    <customerShippingCompany/>
    <customerShippingCountry><![CDATA[US]]></customerShippingCountry>
    <customerBillingFirstName><![CDATA[Nicholas]]></customerBillingFirstName>
    <customerBillingLastName><![CDATA[Bundy]]></customerBillingLastName>
    <customerBillingAddress><![CDATA[75 Broad St Fl 23]]></customerBillingAddress>
    <customerBillingAddress1><![CDATA[75 Broad St]]></customerBillingAddress1>
    <customerBillingAddress2><![CDATA[Fl 23]]></customerBillingAddress2>
    <customerBillingCity><![CDATA[New York]]></customerBillingCity>
    <customerBillingState><![CDATA[NY]]></customerBillingState>
    <customerBillingZip><![CDATA[10004]]></customerBillingZip>
    <customerBillingPhone/>
    <customerBillingFax/>
    <customerBillingCompany/>
    <customerBillingCountry><![CDATA[US]]></customerBillingCountry>
  </customer>
  <items>
    <item>
      <publicId>53045416aae111ecb1798e2cf0ff778f</publicId>                         <!-- Item OG ID -->
      <offerPublicId>a60cd8da1f6111ea9096bc764e101db1</offerPublicId>               <!-- Public OG Offer ID -->
      <offerProfilePublicId>a5e467c41f6111eabd2bbc764e101db1</offerProfilePublicId> <!-- Public OG Offer Profile ID -->
      <qty>2</qty>
      <sku><![CDATA[17550870]]></sku>
      <name><![CDATA[Training Treat Pack]]></name>
      <product_id><![CDATA[17550870]]></product_id>
      <discount>5.20</discount>                                                     <!-- Discount * Quantity -->
      <unitary_discount>2.60</unitary_discount>                                     <!-- Discount on an individual item -->
      <finalPrice>20.78</finalPrice>                                                <!-- (Price * Quantity) - Discount -->
      <price>12.99</price>                                                          <!-- Price Per Item -->
    </item>
  </items>
</order>
```

**Note:**

* Ordergroove will wrap applicable fields of the request in CDATA.
* Ordergroove recommends flagging recurring subscription orders within your OMS for tracking purposes.
* Order placement testing initiated by Ordergroove's backend is required in order to complete full end-to-end testing prior to launch.

## Additional Order Placement Objects

In addition to the standard XML content, you may have additional objects such as legacy bundle components or subscription extra data that you would like returned as a part of the order XML. Below is an example of what those 2 additions would look like within the `<items>` node.

```xml
<items>
  <item>
    <publicId>53045416aae111ecb1798e2cf0ff778f</publicId>
    <offerPublicId>a60cd8da1f6111ea9096bc764e101db1</offerPublicId>
    <offerProfilePublicId>a5e467c41f6111eabd2bbc764e101db1</offerProfilePublicId>
    <type>one-time</type>                                                           <!-- Used w/Instant Upsell -->
    <qty>2</qty>
    <sku><![CDATA[17550870]]></sku>
    <name><![CDATA[Training Treat Pack]]></name>
    <product_id><![CDATA[17550870]]></product_id>
    <discount>5.20</discount>
    <unitary_discount>2.60</unitary_discount>
    <finalPrice>20.78</finalPrice>
    <price>12.99</price>
    <components>                                                                    <!-- Used w/ Legacy Bundles -->
      <component>
        <product_id>B987654</product_id>
        <sku>B987654</sku>
        <qty>2</qty>
      </component>
      <component>
        <product_id>C000000</product_id>
        <sku>C000000</sku>
        <qty>2</qty>
      </component>
    </components>
    <subscription>                                                                  <!-- Used w/Headless Integration -->
      <publicId>74ec471c8c1211eb898efe0ed7e0111f</publicId>
      <startDate>2022-03-17</startDate>
      <originalOrderId>977968</originalOrderId>
      <every>2</every>
      <everyPeriod>2</everyPeriod>
      <frequencyDays>14</frequencyDays>
      <extraData>                                                                   <!-- Returned as it's received in Purchase Post -->
        <pet_name><![CDATA[Rover]]></pet_name>
        <breed><![CDATA[Great Pyranese]]></breed>
      </extraData>
    </subscription>
  </item>
</items>
```

## Order Placement Response

Upon placing the order, you will need to return an XML object back to Ordergroove.

### API Method Success Response Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<order>
  <code>SUCCESS</code>
  <orderId>1224</orderId>
</order>
```

### Batch Method Success Response Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<orders>
  <order>
    <ogOrderId>119994</ogOrderId>
    <code>SUCCESS</code>
    <orderId>1224</orderId>
  </order>
</orders>
```

### API Error Response Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<order>
  <code>ERROR</code>
  <errorCode>110</errorCode>
  <errorMsg>The credit card number provided is not valid.</errorMsg>
</order>
```

### Batch Error Response Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<orders> 
  <order>
    <ogOrderId>119994</ogOrderId>
    <code>ERROR</code>
    <errorCode>110</errorCode>
    <errorMsg>The credit card number provided is not valid.</errorMsg>
  </order>
</orders>
```

## Error Response Codes

An order may be rejected for a number of reasons. To standardize communication to Ordergroove that a failure occurred, we use error codes.

> 📘 Note
>
> It is important we receive these error codes because we will react differently to each code, including sending the customer-specific email communications. If the response mapping is incorrect, the customer will receive an incorrect communication via email.

### Available Error Codes

* **020** — technical issue when placing order
* **100** — invalid credit card type
* **110** — invalid credit card number
* **120** — invalid credit card expiration date
* **130** — invalid billing address
* **140** — payment declined
* **150** — PayPal issue
* **160** — Payment Declined - Do Not Retry
* **170** — No Default Card on File
* **180** — Strong Customer Authentication (SCA) Requested
* **810** — Order superseded by Send Now action performed on a subsequent order
* **999** — generic order processing issue - should be used for temporary errors (ie temporary stock issues)

Please use these error code numbers, but use the error message from your payment gateway or processor. The descriptions above are general categories of errors.

### Ordergroove Response To Order Placement Errors

Based on the category of error that was incurred during order placement, Ordergroove will take different actions on the order. Below is a brief description of what action Ordergroove will take in response to the main four types of order placement errors.

* **Error During Order Generation/Placement** - If Ordergroove is unable to successfully generate the order XML, or is unable to connect to your order placement API, the order will be retried at the next order placement time (usually the next day). These orders are retried for 90 days or the subscription frequency, whichever is shorter.

* **Valid Error Response** - If OG receives a valid error response from your system, the customer will be notified of the error (e.g. Credit Card issue). The order is put in a rejected state.

* **Response Processing Error** - If OG is unable to understand the order response from your system (batch or API), the order is not retried and is put in a rejected state. The customer will not be notified of their order status.

* **Generic Error Response (999)** - If you respond with an error code of 999, OG will read this as an unknown error that occurred during your order placement process. These orders will be retried 3 times (once per order placement period) and if OG continues to receive a response with an error code of 999 each time, the order will be rejected. The customer will be notified when the order is rejected. If OG does not receive any responses to the retries, the order will remain in a pending status in OG's system and the customer will not be notified.

For a reference of what emails get triggered based on responses, take a look at the [Transactional Program Email](https://help.ordergroove.com/hc/en-us/articles/360033726953-Transactional-Program-Emails) article in the Knowledge Center for more information.

## Price Lock

Ordergroove incorporates logic so that if a price changes after a customer has already received the order reminder email, the customer will receive the lower of the two prices. In order to use this logic, it is required that you pick up the final price for each item in the order XML.