<!-- Source: https://dashboard.gelato.com/docs/orders/v4/quote/
     Retrieved: 2026-05-30 (live, latest) -->

# Quote order

# Quote order

Use the Quote API to get the list of shipping methods and the product requested.

`POST https://order.gelatoapis.com/v4/orders:quote`

#### Request example

```
$ curl -X POST \
   https://order.gelatoapis.com/v4/orders:quote \
   -H 'Content-Type: application/json' \
   -H 'X-API-KEY: {{apiKey}}' \
   -d '{
        "orderReferenceId": "{{myOrderId}}",
        "customerReferenceId": "{{myCustomerId}}",
        "currency": "USD",
        "allowMultipleQuotes": false,
        "recipient": {
             "country": "US",
             "companyName": "Example",
             "firstName": "Paul",
             "lastName": "Smith",
             "addressLine1": "451 Clarkson Ave",
             "addressLine2": "Brooklyn",
             "state": "NY",
             "city": "New York",
             "postCode": "11203",
             "email": "apisupport@gelato.com",
             "phone": "123456789"
         },
        "products": [
            {
                "itemReferenceId": "{{myItemId1}}",
                "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
                "files": [
                    {
                        "type": "default",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    },
                    {
                        "type": "back",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    }
                ], 
                "quantity": 100
            },
            {
                "itemReferenceId": "{{myItemId2}}",
                "productUid": "cards_pf_5r_pt_100-lb-cover-coated-silk_cl_4-4_hor",
                "files": [
                    {
                        "type": "default",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/business_card_empty.pdf"
                    }
                ], 
                "quantity": 30
            }
        ]
    }'
```

#### Response example

```
{
  "orderReferenceId": "{{myOrderId}}",
  "quotes": [
    {
      "id": "c22cf4c2-0249-48d0-ac51-c47d24c01f02",
      "itemReferenceIds": [
        "{{myItemId1}}",
        "{{myItemId2}}"
      ],
      "fulfillmentCountry": "US",
      "shipmentMethods": [
        {
          "name": "UPS Surepost",
          "shipmentMethodUid": "ups_surepost",
          "price": 5.11,
          "currency": "EUR",
          "minDeliveryDays": 6,
          "maxDeliveryDays": 7,
          "minDeliveryDate": "2019-08-29",
          "maxDeliveryDate": "2019-08-30",
          "type": "normal",
          "isPrivate": true,
          "isBusiness": true,
          "totalWeight": 613,
          "numberOfParcels": 1,
          "incoTerms": "DDP"
        },
        {
          "name": "UPS Ground Commercial",
          "shipmentMethodUid": "ups_ground_commercial",
          "price": 5.11,
          "currency": "EUR",
          "minDeliveryDays": 5,
          "maxDeliveryDays": 6,
          "minDeliveryDate": "2019-08-28",
          "maxDeliveryDate": "2019-08-29",
          "type": "normal",
          "isPrivate": true,
          "isBusiness": true,
          "totalWeight": 613,
          "numberOfParcels": 1
        },
        {
          "name": "UPS Next Day Commercial",
          "shipmentMethodUid": "ups_next_day_commercial",
          "price": 25.11,
          "currency": "EUR",
          "minDeliveryDays": 4,
          "maxDeliveryDays": 4,
          "minDeliveryDate": "2019-08-27",
          "maxDeliveryDate": "2019-08-27",
          "type": "express",
          "isPrivate": true,
          "isBusiness": true,
          "totalWeight": 613,
          "numberOfParcels": 1
        }
      ],
      "products": [
        {
          "itemReferenceId": "{{myItemId1}}",
          "productUid": "cards_pf_bx_pt_110-lb-cover-uncoated_cl_4-4_hor",
          "quantity": 100,
          "price": 25.11,
          "currency": "EUR"
        },
        {
          "itemReferenceId": "{{myItemId2}}",
          "productUid": "cards_pf_5r_pt_100-lb-cover-coated-silk_cl_4-4_hor",
          "quantity": 100,
          "price": 25.11,
          "currency": "EUR"
        }
      ]
    }
  ]
}
```

#### Request

| Parameter | Type | Description |
| --- | --- | --- |
| **orderReferenceId** _(required)_ | string | Reference to your internal order id. |
| **customerReferenceId** _(required)_ | string | Reference to your internal customer id. |
| **recipient** _(required)_ | RecipientObject | Recipient address information. |
| **products** _(required)_ | ProductObject\[\] | List of products. |
| **currency** _(required)_ | string | Currency iso code in [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) standard. Currency that the order should be charged in.  
Supported currencies: EUR, USD, JPY, BGN, CZK, DKK, GBP, HUF, PLN, RON, SEK, CHF, ISK, NOK, HRK, RUB, TRY, AUD, BRL, CAD, CNY, HKD, IDR, ILS, INR, KRW, MXN, MYR, NZD, PHP, SGD, THB, ZAR, CLP, AED  
\*\* Note\*\*: It is applicable only for customers using wallets or credit cards for payments. |
| **allowMultipleQuotes** _(optional)_ | boolean | This parameter controls if the quote returned shall allow for separate quotes per fulfillment facility; true will permit this and false will limit to a single quote with aggregated min/max delivery days. Default: true. Note: We always try to fulfill your order from a single fulfillment facility, if this is not possible multiple quotes will be returned. |

`ProductObject`

| Parameter | Type | Description |
| --- | --- | --- |
| **itemReferenceId** _(required)_ | string | Reference to your internal order item id. Must be unique within order. |
| **productUid** _(required)_ | string | Type of printing product in [product uid](https://dashboard.gelato.com/docs/get-started/#product-uid) format. |
| **pageCount** _(optional)_ | integer | The page count for multipage products. This parameter is only needed for multi-page products. All pages in the product, including front and back cover are included in the count. For example for a Wire-o Notebook there are 112 inner pages (56 leaves), 2 front (outer and inside) and 2 back cover (outer and inside) pages, total 116 pages. The `pageCount` is 116. [Read more](https://apigelato.zendesk.com/hc/en-us/articles/360010280579-Multipage-formats) |
| **files** _(optional)_ | File\[\] | Files that would be used to generate product file. Files are required for printable products only. Supported file formats are: PDF, PNG, TIFF, SVG and JPEG. For PDF files, please use one of the compatible [PDF/X](https://en.wikipedia.org/wiki/PDF/X) standards, for example in [PDF/X-1a:2003](https://www.iso.org/standard/39938.html) or [PDF/X-4](https://www.iso.org/standard/42876.html) standard. |
| **quantity** _(required)_ | integer | The product quantity. Define how many copies of product should be printed. _The minimum value is 1_ |

`RecipientObject`

Please note that addresses for China (CN), Japan (JP), South Korea (KR) and Russia (RU) must be entered in local language due to shipping providers' requirements. Please see detailed requirements by field below

| Parameter | Type | Description |
| --- | --- | --- |
| **country** _(required)_ | string | The two-character [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code that identifies the country or region. Please note: the country code for United Kingdom is `GB` and not `UK` as used in the top-level domain names for that country.  
\* Pattern: ^\[A-Z\]{2}$\* |
| **firstName** _(required)_ | string | The first name of the recipient at this address.  
_Maximum length is 25 characters. It can be any symbol or character._ |
| **lastName** _(required)_ | string | The last name of the recipient at this address.  
_Maximum length is 25 characters. It can be any symbol or character._ |
| **companyName** _(optional)_ | string | The company name of the recipient at this address.  
_Maximum length is 60 characters. It can be any symbol or character._ |
| **addressLine1** _(required)_ | string | The first line of the address. For example, number, street, and so on.  
\* Maximum length is 35 characters. It must be in local language for Russia (RU), China (CN), Japan (JP) and South Korea (KR). Up to 10 Latin characters are allowed.\* |
| **addressLine2** _(optional)_ | string | The second line of the address. For example, suite or apartment number.  
_Maximum length is 35 characters. It must be in local language for Russia (RU), China (CN), Japan (JP) and South Korea (KR). Up to 10 Latin characters are allowed._ |
| **city** _(required)_ | string | The city name.  
_Maximum length is 30 characters. It must be in local language for Russia (RU), China (CN), Japan (JP) and South Korea (KR)._ |
| **postCode** _(required)_ | string | The postal code, which is the zip code or equivalent. Typically required for countries with a postal code or an equivalent. See [postal code](https://en.wikipedia.org/wiki/Postal_code).  
_Maximum length is 15 characters_ |
| **state** _(optional)_ | string | The code for a US state or the equivalent for other countries. Required for requests if the address is in one of these countries: Australia, Canada or United States.  
_Maximum length is 35 characters_. See [list of state codes](https://apigelato.zendesk.com/hc/en-us/articles/360013540520-Country-and-State-Codes) |
| **email** _(required)_ | string | The email address for the recipient.  
_Pattern: .+@\["-\].+$_ |
| **phone** _(optional)_ | string | The phone number, in [E.123 format](https://en.wikipedia.org/wiki/E.123).  
_Maximum length is 25 characters_ |
| **isBusiness** _(optional)_ | bool | Boolean value, declares the recipient being a business. Use if tax for recipient country is different for private and business customers (e.g. in Brazil) to change federalTaxId field type. Mandatory for Brazil if recipient is a company. |
| **federalTaxId** _(optional)_ | string | The Federal Tax identification number of recipient. Use to provide CPF/CNPJ of a Brazilian recipient. Mandatory for Brazil. _In order to supply CNPJ instead of CPF, set isBusiness field to true._ |
| **stateTaxId** _(optional)_ | string | The State Tax identification number of recipient. Use to provide IE of a Brazilian recipient. Mandatory for Brazil if recipient is a company. _In order to supply this field, set isBusiness field to true._ |
| **registrationStateCode** _(optional)_ | string | The code number for a US state or the equivalent for other countries that defines state where recipient company is registered. Mandatory for Brazil if recipient is a company. _In order to supply this field, set isBusiness field to true._ |

### Response

| Parameter | Type | Description |
| --- | --- | --- |
| **orderReferenceId** _(required)_ | string | Reference to your internal order id. |
| **quotes** _(required)_ | QuoteObject | List of quotes with production information and shipment methods. |

`QuoteObject` parameters

| Parameter | Type | Description |
| --- | --- | --- |
| **id** _(required)_ | string | Quote Id. |
| **itemReferenceIds** _(required)_ | string\[\] | List of your internal item IDs. |
| **fulfillmentCountry** _(required)_ | string | The two-character [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code that identifies the country where the product will be shipped from. |
| **shipmentMethods** _(required)_ | ShipmentMethodObject\[\] | List of available shipping methods. |
| **products** _(required)_ | ProductObject\[\] | List of products. |

`ShipmentMethodObject` parameters

| Parameter | Type | Description |
| --- | --- | --- |
| **name** _(required)_ | string | The shipment method name. |
| **shipmentMethodUid** _(required)_ | string | The shipment method uid. |
| **price** _(required)_ | double | The shipping price. |
| **currency** _(required)_ | string | The currency of the sipping price. |
| **minDeliveryDays** _(required)_ | integer | Minimum days estimate to produce and deliver the product. |
| **maxDeliveryDays** _(required)_ | integer | Maximum days estimate to produce and deliver the product. |
| **minDeliveryDate** _(required)_ | string | Minimum date estimate to produce and deliver the product. |
| **maxDeliveryDate** _(required)_ | string | Maximum date estimate to produce and deliver the product |
| **type** _(required)_ | string | The shipping service type. Can be: `normal`, `standard`, `express`, `pick_up` or `pallet`. |
| **isPrivate** _(required)_ | boolean | The shipping method type is private. |
| **isBusiness** _(required)_ | boolean | The shipping method type is business. |
| **totalWeight** _(required)_ | integer | Total weight of the product in grams, including the weight of the parcel. |
| **numberOfParcels** _(required)_ | integer | Count of shipping parcels. Depending on the product type and quantity ordered, the product might be split into parcels if a weight of the product exceeds the available weight or size for the shipping method. |

`ProductObject`

| Parameter | Type | Description |
| --- | --- | --- |
| **itemReferenceId** _(required)_ | string | Reference to your internal order item id. Must be unique within order. |
| **productUid** _(required)_ | string | Type of printing product in [product uid](https://dashboard.gelato.com/docs/get-started/#product-uid) format. |
| **pageCount** _(optional)_ | integer | The page count for multipage products. This parameter is only needed for multi-page products. All pages in the product, including front and back cover are included in the count. For example for a Wire-o Notebook there are 112 inner pages (56 leaves), 2 front (outer and inside) and 2 back cover (outer and inside) pages, total 116 pages. The `pageCount` is 116. [Read more](https://apigelato.zendesk.com/hc/en-us/articles/360010280579-Multipage-formats) |
| **quantity** _(required)_ | integer | The product quantity. |
| **price** _(required)_ | float | The product price |
| **currency** _(required)_ | string | The currency of price |

* * *
