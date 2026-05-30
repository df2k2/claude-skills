<!-- Source: https://dashboard.gelato.com/docs/get-started/
     Retrieved: 2026-05-30 (live, latest) -->

# Get started

# Get started

## Orders

## Order structure

Via the API you provide three mandatory internal order references: `customerReferenceId` (your customer) , `orderReferenceId` (this order) and `itemReferenceId` (your order item identifier). Each of these parameters must be a string or numeric value representing your internal entities. To better understand the structure of reference parameters please look at the tree view below.

![Order structure](https://dashboard.gelato.com/docs/img/order_structure.svg)

## Product UID

> Product UID example:

```
{
  "productUid": "cards_pf_a5_pt_350-gsm-coated-silk_cl_4-4_ver"
}
```

The Product UID is a string encapsulating the detail of a product. Please look at the example in the code block.

## Files for print

Depending on the product we support different types of files. Print files can be either JPEG, PNG, SVG, or PDF.

Products with a single print area, such as Posters, Framed Posters, Canvas, Acrylic, Metallic, and Mugs, require a single print file.

For products with more than one print area, such as Photo Books, Greeting Cards, Calendars, and Apparel, a single multi-page PDF file can be provided or you can provide a single page raster file for each print area.

Set the file type to [default](https://dashboard.gelato.com/docs/orders/v4/create#request) in case of a single file.

The default type represents the primary print area. For example, it would mean front for apparel products and for folded cards, it will be cover + back pages.

### PDF details

The most print friendly files are [PDF/X](https://en.wikipedia.org/wiki/PDF/X). This is not a file format on its own, but a standard for [PDF](https://en.wikipedia.org/wiki/PDF) files that are intended for printers. [PDF/X](https://en.wikipedia.org/wiki/PDF/X) files have rules for colors, embedding of fonts, trim and bleed and cannot contain elements that are unrelated to print.

Please use this [link](https://dashboard.gelato.com/docs/img/products/cards_a5_4-4.pdf) to download a double side A5 format pdf example. This example has a product uid: `cards_pf_a5_pt_350-gsm-coated-silk_cl_4-4_ver`.

[Read more about files and how to create print-ready PDFs](https://apigelato.zendesk.com/hc/en-us/articles/360010094399)

![Product description](https://dashboard.gelato.com/docs/img/product_description.svg)

## Your first order

The easiest way to start is to send a [create order request](https://dashboard.gelato.com/docs/orders/v4/create), that's it. The order is now placed and will be printed and shipped.

[cURL](#__tabbed_1_1)[PHP](#__tabbed_1_2)[Python](#__tabbed_1_3)[Javascript](#__tabbed_1_4)

```
    $ curl -X POST \
    https://order.gelatoapis.com/v4/orders \
    -H 'Content-Type: application/json' \
    -H 'X-API-KEY: {{apiKey}}' \
    -d '{
        "orderType": "order",
        "orderReferenceId": "{{myOrderId}}",
        "customerReferenceId": "{{myCustomerId}}",
        "currency": "USD",
        "items": [
            {
                "itemReferenceId": "{{myItemId1}}",
                "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
                "files": [
                    {
                        "type": "default",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    },
                    {
                        "type":"back",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    }
                ],
                "quantity": 1
            }
        ],        
        "shipmentMethodUid": "express",
        "shippingAddress": {
            "companyName": "Example",
            "firstName": "Paul",
            "lastName": "Smith",
            "addressLine1": "451 Clarkson Ave",
            "addressLine2": "Brooklyn",
            "state": "NY",
            "city": "New York",
            "postCode": "11203",
            "country": "US",
            "email": "apisupport@gelato.com",
            "phone": "123456789"
        }
    }'
```

```
    <?php

    function request($url, $data, $headers)
    {
        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST => "POST",
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => $headers,
        ]);

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        if ($err) {
            die("cURL Error #:" . $err);
        } else {
            return $response;
        }
    }

    # === Define headers ===
    $headers = [
        "Content-Type: application/json",
        "X-API-KEY: {{apiKey}}"
    ];

    # === Set-up order request ===
    $orderUrl = "https://order.gelatoapis.com/v4/orders";
    $orderData = [
        "orderType" => "order",
        "orderReferenceId" => "{{myOrderId}}",
        "customerReferenceId" => "{{myCustomerId}}",
        "currency" => "USD",
        "items" => [
            [
                "itemReferenceId" => "{{myItemId1}}",
                "productUid" => "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
                "files" => [
                    [
                        "type" => "default",
                        "url" => "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    ],
                    [
                        "type" => "back",
                        "url" => "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    ]
                ],
                "quantity" => 1
            ]
        ],        
        "shipmentMethodUid" => "express",
        "shippingAddress" => [
            "companyName" => "Example",
            "firstName" => "Paul",
            "lastName" => "Smith",
            "addressLine1" => "451 Clarkson Ave",
            "addressLine2" => "Brooklyn",
            "state" => "NY",
            "city" => "New York",
            "postCode" => "11203",
            "country" => "US",
            "email" => "apisupport@gelato.com",
            "phone" => "123456789"
        ]
    ];

    # === Send create order request ===
    $response = request($orderUrl, $orderData, $headers);
    $orderCreateData = json_decode($response);

    echo $orderCreateData->message;
```

```
    import requests

    # === Define headers ===
    headers = {
        'Content-Type': 'application/json',
        'X-API-KEY': '{{apiKey}}'
    }

    # === Set-up order request ===
    orderUrl = "https://order.gelatoapis.com/v4/orders"
    orderJson = """{
        "orderType": "order",
        "orderReferenceId": "{{myOrderId}}",
        "customerReferenceId": "{{myCustomerId}}",
        "currency": "USD",
        "items": [
            {
                "itemReferenceId": "{{myItemId1}}",
                "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
                "files": [
                    {
                        "type": "default",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    },
                    {
                        "type":"back",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    }
                ],
                "quantity": 1
            }
        ],        
        "shipmentMethodUid": "express",
        "shippingAddress": {
            "companyName": "Example",
            "firstName": "Paul",
            "lastName": "Smith",
            "addressLine1": "451 Clarkson Ave",
            "addressLine2": "Brooklyn",
            "state": "NY",
            "city": "New York",
            "postCode": "11203",
            "country": "US",
            "email": "apisupport@gelato.com",
            "phone": "123456789"
        }
    }"""

    # === Send order request ===
    response = requests.request("POST", orderUrl, data=orderJson, headers=headers)
    print(response.json())
```

```
    let request = require('request');

    // === Define headers ===
    let headers = {
        'Content-Type' : 'application/json',
        'X-API-KEY' : '{{apiKey}}'
    };

    // === Set-up quote request ===
    let orderUrl = 'https://order.gelatoapis.com/v4/orders';
    let orderJson = {
        "orderType": "order",
        "orderReferenceId": "{{myOrderId}}",
        "customerReferenceId": "{{myCustomerId}}",
        "currency": "USD",
        "items": [
            {
                "itemReferenceId": "{{myItemId1}}",
                "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
                "files": [
                    {
                        "type": "default",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    },
                    {
                        "type":"back",
                        "url": "https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/docs/sample-print-files/logo.png"
                    }
                ],
                "quantity": 1
            }
        ],        
        "shipmentMethodUid": "express",
        "shippingAddress": {
            "companyName": "Example",
            "firstName": "Paul",
            "lastName": "Smith",
            "addressLine1": "451 Clarkson Ave",
            "addressLine2": "Brooklyn",
            "state": "NY",
            "city": "New York",
            "postCode": "11203",
            "country": "US",
            "email": "apisupport@gelato.com",
            "phone": "123456789"
        }
    };

    // === Send order request ===
    request.post({
        url:        orderUrl,
        headers:    headers,
        body:       JSON.stringify(orderJson)
    }, function(error, response, body){
        console.log(body);
    });
```

You can [setup notifications](https://dashboard.gelato.com/docs/webhooks) to get updates on the order as it is printed, shipped and delivered. You can also [cancel the order](https://dashboard.gelato.com/docs/orders/v4/cancel/).
