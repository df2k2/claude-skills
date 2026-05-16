# Printful API v2 — Endpoint Catalog

Auto-generated from `printful-v2-openapi.json` (OpenAPI 2.0.0-beta).

Base URL: `https://api.printful.com`

All paths are prefixed `/v2`. Authentication: OAuth Bearer token (`Authorization: Bearer {token}`).


## Contents

- [Catalog v2](#catalog-v2) — 17 endpoint(s)
- [Orders v2](#orders-v2) — 15 endpoint(s)
- [Files v2](#files-v2) — 2 endpoint(s)
- [Mockup Generator v2](#mockup-generator-v2) — 2 endpoint(s)
- [Shipping Rates v2](#shipping-rates-v2) — 1 endpoint(s)
- [Countries v2](#countries-v2) — 1 endpoint(s)
- [Warehouse Products v2](#warehouse-products-v2) — 2 endpoint(s)
- [Approval Sheets v2](#approval-sheets-v2) — 1 endpoint(s)
- [Stores v2](#stores-v2) — 3 endpoint(s)
- [Webhook v2](#webhook-v2) — 6 endpoint(s)
- [OAuth Scopes v2](#oauth-scopes-v2) — 1 endpoint(s)


## Catalog v2

### `GET /v2/catalog-products`

**Retrieve a list of catalog products**

- `operationId`: `getProducts`

This endpoint retrieves a list of the products available in Printful's catalog. The list is paginated and can be filtered using various filters. The information returned includes details on how each product can be designed, such as the available placements, techniques, and additional options.
For a visual representation of the design data, please see the following diagram:
[<img src="images/catalog/design_data_diagram.png?center" width="700" alt="Design data diagram"/>](images/catalog/design_data_diagram.png)

### `GET /v2/catalog-products/{id}`

**Retrieve a single catalog product**

- `operationId`: `getProductById`

Returns information about a single specified catalog product. [See catalog product](#tag/Catalog-v2/What-is-a-catalog-product)

### `GET /v2/catalog-variants/{id}`

**Retrieve information about specific catalog variant**

- `operationId`: `getVariantById`

Returns information about single specified catalog variant. [See catalog variant](#tag/Catalog-v2/What-is-a-catalog-variant)

### `GET /v2/catalog-products/{id}/catalog-variants`

**Retrieve information about catalog product variants**

- `operationId`: `getProductVariantsById`

Returns information about all catalog variants associated with the specified
catalog product. [See catalog variant](#tag/Catalog-v2/What-is-a-catalog-variant)

### `GET /v2/catalog-categories`

**Retrieve a list of catalog categories**

- `operationId`: `getCategories`

Returns list of all categories that are present in the catalog. The categories specify the type of the product that is associated with it. For example, the category "Men’s T-shirts" indicates that the product is a subgroup of T-shirts specifically targeted at Men.
Categories can be used to filter the product list by specific tags [See categories_ids](#operation/getProducts)

### `GET /v2/catalog-categories/{id}`

**Retrieve information about specific category**

- `operationId`: `getCategoryById`

Returns information about a specific catalog category. The categories specify the type of the product that is associated with it. For example, the category "Men’s T-shirts" indicates that the product is a subgroup of T-shirts specifically targeted at Men.
Categories can be used to filter the product list by specific tags [See categories_ids](#operation/getProducts)

### `GET /v2/catalog-products/{id}/catalog-categories`

**Retrieve a list of catalog product categories**

- `operationId`: `getCategoriesByProductId`

To retrieve information about a particular products categories, use this feature. It returns details about the catalog categories associated with the catalog product. Categories help identify the type of product associated with them. For instance, the category "Men's T-shirts" denotes that the product is a subgroup of T-shirts intended for men.

### `GET /v2/catalog-products/{id}/sizes`

**Retrieve size guide for a catalog product**

- `operationId`: `getProductSizeGuideById`

Returns information about the size guide for a specific product.

### `GET /v2/catalog-products/{id}/prices`

**Retrieve catalog product prices**

- `operationId`: `getProductPricesById`

Calculates prices for specific catalog product based on selling region and specified currency. Calculations also include Store discounts. Selling region is used to specify product production currency, that is the price that the product is natively manufactured in. Different selling regions might affect the overall price amount. Currency parameter is used only to define the currency that the prices will be displayed in.

For more information on product pricing please refer to the information provided at https://www.printful.com/pricing
<div class="alert alert-info" style="word-wrap: break-word;…

### `GET /v2/catalog-variants/{id}/prices`

**Retrieve pricing information for the catalog variant**

- `operationId`: `getVariantPricesById`

Return pricing information from a single variant and the parent product

### `GET /v2/catalog-products/{id}/images`

**Retrieve blank images for a catalog product**

- `operationId`: `getProductImagesById`

This feature helps to fetch blank images for a catalog product. These blank images are always white and semi-transparent and can be colored by the user on the client-side as per the specified color in the `data.images.background_color` field. For some mockups the `data.images.background_image` could apply. The endpoint allows filtering of the result based on the type of the mockup, the placement, and the color of the product.

### `GET /v2/catalog-products/{id}/shipping-countries`

**Retrieve the shipping countries for a Product**

- `operationId`: `getProductShippingCountriesById`

Retrieve the list of countries the Catalog Product can be shipped to.

### `GET /v2/catalog-variants/{id}/images`

**Retrieve blank images for a catalog variant**

- `operationId`: `getVariantImagesById`

Returns images for a specified Variant.

### `GET /v2/catalog-products/{id}/mockup-styles`

**Retrieve catalog product mockup styles**

- `operationId`: `retrieveMockupStylesByProductId`

Returns information about available mockup styles for specified catalog product.

### `GET /v2/catalog-products/{id}/mockup-templates`

**Retrieve catalog product mockup templates**

- `operationId`: `getMockupTemplatesByProductId`

Returns positional data for specified catalog product mockups. The data from this endpoint could be used
to generate your own mockups without the need to use Printful's mockup generator.
![Mockup template](images/mockups/mockup_template.png)

### `GET /v2/catalog-products/{id}/availability`

**Retrieve catalog product stock availability**

- `operationId`: `getProductStockAvailabilityById`

Provides information about the catalog product stock status. Stock availability is grouped by variants &rarr; techniques &rarr; selling regions.

### `GET /v2/catalog-variants/{id}/availability`

**Retrieve catalog variant stock availability**

- `operationId`: `getVariantStockAvailabilityById`

Provides information about the catalog variant stock status. Stock availability is grouped by variants &rarr; techniques &rarr; selling regions.


## Orders v2

### `GET /v2/orders`

**Retrieve a list of orders**

- `operationId`: `getOrders`

Retrieve a list of orders from a specific store. The order list will be paginated with twenty items per page by default.

### `POST /v2/orders`

**Create a new order**

- `operationId`: `createOrder`

This endpoint allows the creation of a new order in which the default status will be `draft`.

### `GET /v2/orders/{order_id}`

**Retrieve a single order**

- `operationId`: `getOrder`

Retrieve a single order from the specified store. The result object will contain links to the same resource, order items, and shipments.

### `DELETE /v2/orders/{order_id}`

**Delete an order**

- `operationId`: `deleteOrder`

<div class="alert alert-danger">
  <strong>Warning:</strong> The DELETE HTTP method in version 2 of order in the 
  API will delete the order if the order can be deleted. This is distinct from 
  version 1 where the DELETE method will actually cancel the order rather than 
  delete it. Please, keep this in mind if you are migrating to version 2 from 
  version 1
</div>

Delete the order if it can be deleted. An order can be deleted if it's status is
`draft`, `failed` or `cancelled`. The order must also have not been charged yet
and there must be no payments pending.

### `PATCH /v2/orders/{order_id}`

**Update an order**

- `operationId`: `updateOrder`

Make a partial update of an order.

### `POST /v2/orders/{order_id}/confirmation`

**Confirm an order**

- `operationId`: `confirmOrder`

This endpoint allows customers to confirm the order and start the fulfillment in the production facility.

### `GET /v2/orders/{order_id}/order-items`

**Retrieve a list of order items**

- `operationId`: `getItemsByOrderId`

This endpoint retrieves the list of items that belong to the order.

### `POST /v2/orders/{order_id}/order-items`

**Create a new order item**

- `operationId`: `createItemByOrderId`

This endpoint allows the creation of a new item that will be added to an existing order.

### `GET /v2/orders/{order_id}/order-items/{order_item_id}`

**Retrieve a single order item**

- `operationId`: `getItemById`

This endpoint will retrieve a single order item specified in the request.

### `PATCH /v2/orders/{order_id}/order-items/{order_item_id}`

**Update an order item**

- `operationId`: `updateItem`

Make a partial update of an order item. NOTE that the source of the order item can't be changed via a PATCH request, to create an order item from another source you must delete the current one and add a new one.

### `DELETE /v2/orders/{order_id}/order-items/{order_item_id}`

**Delete Order Item**

- `operationId`: `deleteItemById`

Remove a single item from the order.

### `GET /v2/orders/{order_id}/shipments`

**Retrieve a list of shipments**

- `operationId`: `getShipments`

Shipments contain information about how and when your orders items will be delivered and fulfilled.

### `GET /v2/orders/{order_id}/invoices`

**Retrieve an invoice**

- `operationId`: `getInvoiceByOrderId`

Returns the invoice for an order as a base64 encoded document. Decoding the base64 content can be different depending on the client, for most browsers this format will alow you to view and display the invoice `data:application/pdf;base64,{the_base_64_content_string}`.

### `GET /v2/order-estimation-tasks`

**Retrieve an order estimation task**

- `operationId`: `getOrderEstimationTask`

Retrieve an order cost estimation task from a specific store.
Estimation results are only available for one hour after cost estimation task is done.

### `POST /v2/order-estimation-tasks`

**Create a new order estimation task**

- `operationId`: `createOrderEstimationTask`

Use this endpoint to estimate orders with items.


## Files v2

### `POST /v2/files`

**Add a new file**

- `operationId`: `addFile`

Adds a new File to the library by providing URL of the file.

If a file with identical URL already exists, then the original file is returned. If a file does not exist, a new file is created.

[See examples](#tag/Examples/File-Library-API-examples/Add-a-new-file)

### `GET /v2/files/{id}`

**Retrieve a single file from the file library**

- `operationId`: `getFileById`

Get basic information about the file stored in the file library


## Mockup Generator v2

### `POST /v2/mockup-tasks`

**Create Mockup Generator tasks**

- `operationId`: `createMockupGeneratorTasks`

Create Mockup Generator tasks

### `GET /v2/mockup-tasks`

**Retrieve Mockup Generator tasks**

- `operationId`: `getMockupGeneratorTasks`

Returns result of Mockup Generator tasks


## Shipping Rates v2

### `POST /v2/shipping-rates`

**Calculate Shipping Rates**

- `operationId`: `calculateShppingRates`

Returns available shipping options and rates for the given list of products.


## Countries v2

### `GET /v2/countries`

**Retrieve a list of countries**

- `operationId`: `getCountries`
- Parameters:
  - `limit` — query (integer)

Get information about all countries where Printful is available


## Warehouse Products v2

### `GET /v2/warehouse-products`

**Retrieve a list of warehouse products**

- `operationId`: `getWarehouseProducts`

This endpoint returns paginated results containing detailed information about warehouse products, including their variants, stock levels, and dimensions.

### `GET /v2/warehouse-products/{warehouse_product_id}`

**Retrieve a single warehouse product**

- `operationId`: `getWarehouseProductById`

Get information about a single warehouse product with it's stock location.


## Approval Sheets v2

### `GET /v2/approval-sheets`

**Retrieve a list of approval sheets**

- `operationId`: `getApprovalSheets`

Retrieve a list of approval sheets confirming suggested changes to files of on hold orders.


## Stores v2

### `GET /v2/stores/{store_id}`

**Retrieve a single store**

- `operationId`: `getStoreById`

Get information about a single store.

### `GET /v2/stores`

**Retrieves a list of stores**

- `operationId`: `getStores`

Retrieves a list of all stores available to the token. If the token is a store level token it will return only the one store, if it is an account level token it will return all stores available to the account.

### `GET /v2/stores/{store_id}/statistics`

**Retrieve statistics for a single store**

- `operationId`: `getReports`

Returns statistics for specified report types.

You need to specify the report types you want to retrieve in the `report_types` query parameter as a comma-separated list,
e.g. `report_types=sales_and_costs,profit`.

**Note**: You cannot get statistics for a period longer than 6 months.

#### Example

To get statistics in the default currency of a store for `sales_and_costs` and `profit` reports for August 2022, you can use the
following
URL: https://api.printful.com/v2/stores/{id}/statistics?report_types=sales_and_costs,profit&date_from=2022-08-01&date_to=2022-08-31.

### Report types

Current…


## Webhook v2

### `GET /v2/webhooks`

**Get webhook configuration**

- `operationId`: `getWebhooks`

Returns a configured webhook URL and a list of webhook event types enabled for the store

### `POST /v2/webhooks`

**Set up webhook configuration**

- `operationId`: `createWebhook`

Use this endpoint to enable a webhook URL for a store and select webhook event types that will be sent to this URL.

Note that only one webhook configuration can be active for each private OAuth token or app, calling this method will disable the previous webhook configuration.

Setting up the [Catalog stock updated](#operation/catalogStockUpdated) webhook requires passing products (currently only IDs are taken into account).

Stock update webhook (`catalog_stock_updated`) will only include information for the products specified in the `products` param.

Configuring all other events require the…

### `DELETE /v2/webhooks`

**Disable webhook support**

- `operationId`: `disableWebhook`

Removes the webhook URL and all event types from the store.

### `GET /v2/webhooks/{eventType}`

**Get event configuration**

- `operationId`: `getWebhookEventConfiguration`

Returns event configuration for store

### `POST /v2/webhooks/{eventType}`

**Set up event configuration**

- `operationId`: `createWebhookEventConfiguration`

Use this endpoint to create or replace specific event configuration for a store.

Setting up the [Catalog stock updated](#operation/catalogStockUpdated) webhook requires passing products (currently only IDs are taken into account).

Stock update webhook will only include information for the products specified in the `products` param.

### `DELETE /v2/webhooks/{eventType}`

**Disable support for event**

- `operationId`: `disableWebhookEvent`

Disables the event for a store and clears its configuration, leaving other webhooks intact.


## OAuth Scopes v2

### `GET /v2/oauth-scopes`

**Retrieve OAuth scopes**

- `operationId`: `getOAuthScopes`

This endpoint will retrieve all OAuth scopes associated with the used token

