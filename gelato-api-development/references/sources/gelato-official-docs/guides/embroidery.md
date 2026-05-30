<!-- Source: https://dashboard.gelato.com/docs/guides/embroidery/
     Retrieved: 2026-05-30 (live, latest) -->

# Embroidery Integration

# Embroidery Integration

A step-by-step guide to order embroidery products programmatically. Currently, selected apparel and tote bag products are available for embroidery.

## 1\. Choose a product

Select in the [catalog](https://cdn-origin.gelato-api-dashboard.ie.live.gelato.tech/catalogue/categories) which product(s) to order for embroidery. On the product pages you can find the product UIDs that are needed to place the order. You can also programmatically find the right products with the [Search products API](https://dashboard.gelato.com/docs/products/product/search/).

For apparel and tote bags you don’t need to think about picking the UID that describes the exact print areas you want to use. If `order.items[n].adjustProductUidByFileTypes` is set to `true`, Gelato will automatically pick the right UID based on which files and file types you provide. This is covered further down.

**Example:**

If you place an order with the UID _´apparel\_product\_gca\_t-shirt\_gsc\_crewneck\_gcu\_unisex\_gqa\_heavy-weight\_gsi\_s\_gco\_white\_gpr\_4-0´_ which is a Small, White Heavyweight Unisex Crewneck T-shirt with print on the front (4-0) And then provide an Embroidery file with placement for chest-center-embroidery then the product UID will be automatically converted to _´apparel\_product\_gca\_t-shirt\_gsc\_crewneck\_gcu\_unisex\_gqa\_heavy-weight\_gsi\_s\_gco\_white\_gpr\_chstc-emb´_.

This makes it easy to order any DTG and Embroidery products using only one product UID per product variant (product + color + size).

## 2\. Specifying the file placements, thread colors and file visibility

### i. File placements

You specify the areas you want to embroider on with the parameter ‘type’ for each file in the order item files array. For example if you want to embroider center chest and left sleeve the files array looks like:

```
"files": [ 
    {
        "url": "https://fileurl.com",
        "type": "chest-center-embroidery",
        "threadColors": ["#a57742"],
        "isVisible": true
    },
    {
        "url": "https://anotherfileurl.com",
        "type": "sleeve-left-embroidery",
        "threadColors": ["#a57742"],
        "isVisible": true
    }
]
```

**Note:** Currently all print areas for one line item need to be either DTG or embroidery. Example: It is not possible to have embroidery on center chest and DTG printing on left sleeve.

### ii. Thread colors

You can manually set which thread colors you want to use or the system will automatically pick based on the closest match between the available thread colors and the colors used in your file. Max 6 thread colors can be used in one file. Remember to follow the guidelines for designing the embroidery file for the best result.

If you want the system to automatically pick the colors then omit the threadColors array.

If you want to define the colors yourself you can by setting the threadColors array. This can be helpful if you for example have a single-color design and you are offering your customers to choose which thread color they want to use. In the example below the thread color is set to white.

```
"files": [ 
    {
        "url": "https://somefileurl.com,
        "type": "chest-left-embroidery",
        "threadColors": ["#a57742"]
        "isVisible": true
    }
]
```

### iii. File visibility

You can set if the file should be visible in the file panel in the Editor in the Gelato dashboard. If you want to reuse the file later and have it available for doing changes in the dashboard it is recommended to set it to be visible.

If you are selling personalized designs where each design is unique for a customer then it can be helpful to set the file to not be visible. This way you do not see files in your file panel that you can’t later use for any other purpose (as they were unique to that customer).

File visibility is controlled by the flag ´isVisible´in the file object.

## 3\. Place the order

Use the Order create API to place the order. It works in the same way as ordering other products. Just add the file array in the way described above and everything else is the same.

Example request

```
{
  "orderReferenceId": "KJFW812UD",
  "customerReferenceId": "12345",
  "currency": "USD",
  "items": [
    {
      "itemReferenceId": "embroidery-product-1",
      "adjustProductUidByFileTypes": true,
      "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_heavy-weight_gsi_s_gco_white_gpr_4-0",
      "files": [
        {
          "url": "https://www.dropbox.com/s/p52nqmhd3queehj/Custom%20Document%20_%20508x708%20mm.png?dl=1",
          "type": "chest-left-embroidery",
          "threadColors": [
            "#000000",
            "#cb3265",
            "#670101",
            "#015498"
          ],
          "isVisible": true
        }
      ],
      "quantity": 1
    },
    {
      "itemReferenceId": "embroidery-product-2",
      "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_heavy-weight_gsi_s_gco_white_gpr_chstc-emb",
      "files": [
        {
          "id": "37365096-6628-4538-a9c2-fbf9892deb85",
          "type": "wrist-right-embroidery",
          "threadColors": [
            "#ffffff",
            "#343467",
            "#ffcd01",
            "#95a0a7"
          ],
          "isVisible": true
        }
      ],
      "quantity": 1
    },
    {
      "itemReferenceId": "embroidery-product-3",
      "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_heavy-weight_gsi_s_gco_white_gpr_chstc-emb",
      "files": [
        {
          "id": "37365096-6628-4538-a9c2-fbf9892deb85",
          "type": "sleeve-right-embroidery"
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

## 4\. Storing the file ids for repeat use (optional step)

If the designs you are submitting are going to be ordered multiple times you can use the file IDs to reference that file. You receive the file IDs in the order response. By using those the files will not be digitized again - saving you money and time.

## Supported colors

Unlike DTG, design files for Embroidery are required to have up to 6 colors. If there are more colors, we will automatically reduce the colors in the design file to 6 based on the colors in the supported color palette below. You can also specify your preferred colors as described in [order.items\[n\].files\[m\].threadColors](https://dashboard.gelato.com/docs/orders/v4/create/#request).

| Color | Preview | Color | Preview | Color | Preview |
| --- | --- | --- | --- | --- | --- |
| White  
#ffffff | ![White](https://via.placeholder.com/30/e5e8fd/000000?text=+) | Aqua  
#349aff | ![Aqua](https://via.placeholder.com/30/349aff/000000?text=+) | Grey  
#95a0a7 | ![Grey](https://via.placeholder.com/30/95a0a7/000000?text=+) |
| Black  
#000000 | ![Black](https://via.placeholder.com/30/000000/ffffff?text=+) | Maroon  
#670101 | ![Maroon](https://via.placeholder.com/30/670101/ffffff?text=+) | Royal  
#015498 | ![Royal](https://via.placeholder.com/30/015498/ffffff?text=+) |
| Navy  
#343467 | ![Navy](https://via.placeholder.com/30/343467/ffffff?text=+) | Kelly Green  
#41894b | ![Kelly Green](https://via.placeholder.com/30/41894b/ffffff?text=+) | Light Green  
#7ca45b | ![Light Green](https://via.placeholder.com/30/7ca45b/000000?text=+) |
| Red  
#cb333b | ![Red](https://via.placeholder.com/30/cb333b/ffffff?text=+) | Pink  
#cb3265 | ![Pink](https://via.placeholder.com/30/cb3265/ffffff?text=+) | Purple  
#6c5395 | ![Purple](https://via.placeholder.com/30/6c5395/ffffff?text=+) |
| Yellow  
#ffcd01 | ![Yellow](https://via.placeholder.com/30/ffcd01/000000?text=+) | Gold  
#a57742 | ![Gold](https://via.placeholder.com/30/a57742/ffffff?text=+) | Orange  
#da5f3d | ![Orange](https://via.placeholder.com/30/da5f3d/ffffff?text=+) |
