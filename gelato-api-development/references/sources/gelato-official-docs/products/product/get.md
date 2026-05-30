<!-- Source: https://dashboard.gelato.com/docs/products/product/get/
     Retrieved: 2026-05-30 (live, latest) -->

# Get product

# Get product

Use this endpoint to get information about a single product.

`GET https://product.gelatoapis.com/v3/products/{{productUid}}`

#### Request example

```
$ curl -X GET "https://product.gelatoapis.com/v3/products/cards_pf_bb_pt_110-lb-cover-uncoated_cl_4-0_hor" \
    -H 'X-API-KEY: {{apiKey}}'
```

#### Response example

```
{
    "productUid": "8pp-accordion-fold_pf_dl_pt_100-lb-text-coated-silk_cl_4-4_ft_8pp-accordion-fold-ver_ver",
    "attributes": {
        "CoatingType": "none",
        "ColorType": "4-4",
        "FoldingType": "8pp-accordion-fold-ver",
        "Orientation": "ver",
        "PaperFormat": "DL",
        "PaperType": "100-lb-text-coated-silk",
        "ProductStatus": "activated",
        "ProtectionType": "none",
        "SpotFinishingType": "none",
        "Variable": "no"
    },
    "weight": {
        "value": 1.341,
        "measureUnit": "grams"
    },
    "supportedCountries": [
        "US",
        "CA"
    ],
    "notSupportedCountries": [
        "BD",
        "BM",
        "BR",
        "AI",
        "DO",
        "IS"
    ],
    "isStockable": false,
    "isPrintable": true,
    "validPageCounts": [5,10,20,30]
}
```

#### Query Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| **productUid** _(required)_ | string | Unique product identifier. It can be taken from `productUid` parameter in Products list API response. |

#### Response Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| **productUid** _(required)_ | string | Unique product identifier. |
| **attributes** _(required)_ | ProductAttributes | Associative array of product attributes. |
| **weight** _(required)_ | WeightObject | Weight of the product. |
| **supportedCountries** _(required)_ | string\[\] | Codes array of supported countries. Each string is the two-character [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code that identifies the country or region. Please note: the country code for United Kingdom is `GB` and not `UK` as used in the top-level domain names for that country.  
_Pattern: ^\[A-Z\]{2}$_ |
| **notSupportedCountries** _(required)_ | string\[\] | Code array of countries that are not supported. Each string is the two-character [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code that identifies the country or region. Please note: the country code for United Kingdom is `GB` and not `UK` as used in the top-level domain names for that country.  
_Pattern: ^\[A-Z\]{2}$_ |
| **isStockable** _(required)_ | boolean | Describes if the product is a stockable item. A stockable item has a limited stock level which can be depleted. Example of stockable items are frames, hangers and framed posters. A non-stockable item can be regarded as having infinite stock. Examples of non-stockable items are cards, calendars and posters. Which products are stockable and non-stockable are subject to change in the future. |
| **isPrintable** _(required)_ | boolean | Describes if the product is a printable item. Example of non-printable items are frames or hangers. Examples of printable items are cards, calendars and posters. |
| **validPageCounts** _(optional)_ | int\[\] | The list of page counts which are supported for multi-page products. This parameter is returned only for multi-page products |

`ProductAttributes`

Associative array of product attributes.

Keys represent attributes names. These are the same as `ProductAttributeUid` in Catalog info API response.

Values represent attribute values. These are the same as `ProductAttributeValueUid` in Catalog info API response.

```
{
    "CoatingType": "none",
    "ColorType": "4-4",
    "FoldingType": "8pp-accordion-fold-ver"
}
```

`WeightObject` parameters

| Parameter | Type | Description |
| --- | --- | --- |
| **value** _(required)_ | double | Weight value. |
| **measureUnit** _(required)_ | string | Unit of measurement - grams or lbs. |

* * *
