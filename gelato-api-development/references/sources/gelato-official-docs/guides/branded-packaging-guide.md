<!-- Source: https://dashboard.gelato.com/docs/guides/branded-packaging-guide/
     Retrieved: 2026-05-30 (live, latest) -->

# Using Branded Inserts & Labels

# Using Branded Inserts & Labels

Beta Feature

To get access to this beta feature contact us on [apisupport@gelato.com](mailto:apisupport@gelato.com). Only available to Gelato+ / Gelato+ Gold customers.

Your product’s packaging is as important as the product itself, it is meant to communicate a purpose: what your brand stands for and what it means for your customer. It only takes about 7 seconds to form the first impression of a brand. Add your brand to the packaging and include an insert in the package to thank the customer, promote other products, or anything else that helps your brand and customers.

## Adding inserts and labels to an order

Go to [https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/branding/configure](https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/branding/configure) and click on Label and Insert to get the available product UIDs for each of the items.

In this example, we will use a horizontal insert and a vertical label.

-   Branded Label - vertical: `branded_sticker_101x76-mm-4x3-inch-label_bopp-white-gloss-perm-60-micron_external-application_4-0_ver`
-   Branded Insert - horizontal: `branded_insert_101x152-mm-4x6-inch_170-gsm-65lb-uncoated_insert_4-0_hor`

Inserts and labels are treated as order items and to add them is like adding any other product to the order create request.

Note only one label and one insert (quantity = 1) can be added to an order. If more are sent in the request the order will not be accepted.

### Example:

```
{
        "orderReferenceId": "KJFW812UD",
        "customerReferenceId": "12345",
        "currency": "USD",
        "items": [
            {
                "itemReferenceId": "poster-50x70cm",
                "productUid": "flat_500x700-mm-20x28-inch_170-gsm-65lb-uncoated_4-0_ver",
                "files": [ {
                    "url": "https://www.dropbox.com/s/p52nqmhd3queehj/Custom%20Document%20_%20508x708%20mm.png?dl=1",
                    "type": "default"
                    }
                ],
                "quantity": 1
            },
            {
                "itemReferenceId": "branded-insert-horizontal",
                "productUid": "branded_insert_101x152-mm-4x6-inch_170-gsm-65lb-uncoated_insert_4-0_hor",
                "files": [ {
                    "url": "https://www.dropbox.com/s/p52nqmhd3queehj/Custom%20Document%20_%20508x708%20mm.png?dl=1",
                    "type": "default"
                    }
                ],
                "quantity": 1
            },
            {
                "itemReferenceId": "branded-label-vertical",
                "productUid": "branded_sticker_101x76-mm-4x3-inch-label_bopp-white-gloss-perm-60-micron_external-application_4-0_ver",
                "files": [ {
                    "url": "https://www.dropbox.com/s/p52nqmhd3queehj/Custom%20Document%20_%20508x708%20mm.png?dl=1",
                    "type": "default"
                    }
                ],
                "quantity": 1
            }
        ],        
        "shipmentMethodUid": "standard",
        "shippingAddress": {
            "companyName": "Paul's Company LLC",
            "firstName": "Paul",
            "lastName": "Smith",
            "addressLine1": "451 Clarkson Ave",
            "addressLine2": "Brooklyn",
            "state": "NY",
            "city": "New York",
            "postCode": "11203",
            "country": "US",
            "email": "firstname.lastname@email.com",
            "phone": "123456789"
        },
        "returnAddress": {
            "companyName": "Paul's Company LLC"
        }
    }
```

## Use case: Personalize the insert for each customer

Move to 1:1-personalization and relevance for your customers. Give each customer a unique tailored insert. You can for example add the customer’s name in a thank you note or suggest them products based on what they have already purchased. As long as you can generate the print files ahead of placing the order you can do 1:1-personalized marketing.

Examples of what customers have done using 1:1-personalization and inserts:

1.  Showcase top 3-6 products for that customer based on what they have already purchased
2.  Personalize thank you note with the customer’s name
3.  Unique, individual, discount code for the customer.
