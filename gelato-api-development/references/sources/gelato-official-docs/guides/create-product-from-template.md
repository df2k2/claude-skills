<!-- Source: https://dashboard.gelato.com/docs/guides/create-product-from-template/
     Retrieved: 2026-05-30 (live, latest) -->

# Creating Products From Template

# Creating Products From Template

Introducing the Gelato Create Product API - a robust solution for merchants seeking streamlined bulk product creation. With this powerful API, merchants can effortlessly add large volumes of products to their store programmatically, saving time, reducing errors, and scaling their business efficiently. By leveraging pre-defined product templates in Gelato dashboard and making API calls, merchants can swiftly generate and publish product listings, automating their workflow and maximizing productivity.

1.  Create a product template in dashboard with all the required information about variants, mockups, details and pricing. ![Templates page](https://dashboard.gelato.com/docs/img/ecommerce/product_from_template/templates.png)
    
2.  Add new image layer and rename it with proper names if you prefer or leave it as default. The layer name should be unique and is used in API as placeholder names. ![Editor page](https://dashboard.gelato.com/docs/img/ecommerce/product_from_template/add_image_layer.png)
    
3.  Set product mockups, details, prices and save template.
    
4.  Copy Template ID from UI on the Templates page
    

![Copy Template ID](https://dashboard.gelato.com/docs/img/ecommerce/product_from_template/copy_template_id.png)

1.  Open store page and copy Store ID from the URL

![Copy Store ID](https://dashboard.gelato.com/docs/img/ecommerce/product_from_template/copy_store_id.png)

Tip: You can use Template Id to send request to [Get Template API](https://dashboard.gelato.com/docs/ecommerce/templates/get/#request) which returns a list of product variants with image placeholders. Make API call using Template ID and Store ID with image placeholders to [Create Product API](https://dashboard.gelato.com/docs/ecommerce/products/create-from-template/#request) which immediately creates a new product and then continues with creating and publishing variants, and mockups images in the background. To check the status of the product, use [Get Product API](https://dashboard.gelato.com/docs/ecommerce/products/get/#request).
