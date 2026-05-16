# Printful API v2 — Schema Catalog

Auto-generated from the OpenAPI spec. Lists every schema with its fields, types, and (when present) descriptions and enum values.


## `3dPuffOption`

Should thread use 3d puff technique

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `3d_puff` Example: `3d_puff` |
| `value` | boolean | ✓ | Whether the 3d puff technique should be used for the layer. Example: `True` |

## `AddFile`

Information about the added File

| Field | Type | Req | Description |
|---|---|---|---|
| `role` | string |  | Role of the file Enum: `printfile`, `label`, `preview` Example: `printfile` |
| `url` | string | ✓ | Source URL where the file is to be downloaded from. The use of .ai, .psd, and .tiff files has been deprecated, if your application uses these file types or accepts these types from users you will need to add validation. Example: `​https://w… |
| `filename` | string |  | If the filename is not provided, and something looking like a filename is present in the URL (e.g. "something.jpg"), it will be used. Otherwise, it will default to `{file_id}.{file_extension}`, with file extension determined based on the me… |
| `visible` | boolean |  | Show file in the Printfile Library Example: `True` |

## `AdditionalPlacements`

Info about additional product placements prices.

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | string | ✓ | ID or key of placement Example: `default` |
| `title` | string | ✓ | Title of the placement related Example: `Print file` |
| `type` | string | ✓ | Placement type Example: `Digital printing` |
| `technique_key` | string | ✓ | Key associated to the available technique Example: `digital` |
| `price` | string | ✓ | Price converted to the region currency Example: `19.75` |
| `discounted_price` | string | ✓ | Discounted price per region Example: `18.75` |
| `placement_options` | array of [`FileOptionPrices`](#fileoptionprices) | ✓ | Array containing the pricing information about the file options used |
| `layers` | array of [`Layers`](#layers) | ✓ | Array containing the pricing information about the layers. |

## `Address`

Information about the address

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string |  | Full name Example: `John Smith` |
| `company` | string |  | Company name Example: `John Smith Inc` |
| `address1` | string |  | Address line 1 Example: `19749 Dearborn St` |
| `address2` | string |  | Address line 2 |
| `city` | string |  | City Example: `Chatsworth` |
| `state_code` | string |  | State code Example: `CA` |
| `state_name` | string |  | State name Example: `California` |
| `country_code` | string |  | Country code Example: `US` |
| `country_name` | string |  | Country name Example: `United States` |
| `zip` | string |  | ZIP/Postal code Example: `91311` |
| `phone` | string |  | Phone number Example: `2312322334` |
| `email` | string |  | Email address Example: `firstname.secondname@domain.com` |
| `tax_number` | string |  | TAX number (`optional`, but in case of Brazil country this field becomes `required` and will be used as CPF/CNPJ number)<br> CPF format is 000.000.000-00 (14 characters);<br> CNPJ format is 00.000.000/0000-00 (18 characters). Example: `123.… |

## `AddressReadonly`

Information about the address

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Full name Example: `John Smith` |
| `company` | string | ✓ | Company name Example: `John Smith Inc` |
| `address1` | string | ✓ | Address line 1 Example: `19749 Dearborn St` |
| `address2` | string | ✓ | Address line 2 |
| `city` | string | ✓ | City Example: `Chatsworth` |
| `state_code` | string | ✓ | State code Example: `CA` |
| `state_name` | string | ✓ | State name Example: `California` |
| `country_code` | string | ✓ | Country code Example: `US` |
| `country_name` | string | ✓ | Country name Example: `United States` |
| `zip` | string | ✓ | ZIP/Postal code Example: `91311` |
| `phone` | string | ✓ | Phone number Example: `2312322334` |
| `email` | string | ✓ | Email address Example: `firstname.secondname@domain.com` |
| `tax_number` | string | ✓ | TAX number (`optional`, but in case of Brazil country this field becomes `required` and will be used as CPF/CNPJ number)<br> CPF format is 000.000.000-00 (14 characters);<br> CNPJ format is 00.000.000/0000-00 (18 characters). Example: `123.… |

## `ApprovalSheet`

Approval sheet

| Field | Type | Req | Description |
|---|---|---|---|
| `confirm_hash` | string | ✓ | Confirmation hash value. Example: `a14e51714be01f98487fcf5131727d31` |
| `status` | string | ✓ | Status of Approval Sheet. Enum: `waiting_for_action`, `approval_pending`, `approved`, `changes_requested`, `files_changed` Example: `waiting_for_action` |
| `submitted_design` | string | ✓ | URL to submitted design. Example: `https://s3.staging.printful.com/upload/approval-design/ae/ae7b3d3e965c238b3e5c1a4e15696f07_l` |
| `recommended_design` | string | ✓ | URL to recommended design. Example: `https://s3.staging.printful.com/upload/approval-design/aa/aaf9e1c6b32cb7a2c04d2746108d4124_l` |
| `approval_sheet` | string | ✓ | URL to Approval sheet. Example: `​https://example.com/approval-sheet.pdf` |
| `order_id` | integer | ✓ | Order ID. Example: `123` |
| `order_item_id` | integer | ✓ | Item ID. Example: `123` |
| `_links` | object | ✓ | HATEOAS links |

## `ApprovalSheetWebhookFile`

| Field | Type | Req | Description |
|---|---|---|---|
| `confirm_hash` | string |  | Example: `a14e51714be01f98487fcf5131727d31` |
| `submitted_design` | string |  | Example: `https://s3.staging.printful.com/upload/approval-design/ae/ae7b3d3e965c238b3e5c1a4e15696f07_l` |
| `recommended_design` | string |  | Example: `https://s3.staging.printful.com/upload/approval-design/aa/aaf9e1c6b32cb7a2c04d2746108d4124_l` |
| `approval_sheet` | string |  | Example: `https://www.printful.test/dashboard/order/download-approval-sheet-pdf?confirmationHash=13aa35854bfc67a85b7ce231aef2ae8` |

## `AverageFulfillmentTime`

Average fulfillment time report

| Field | Type | Req | Description |
|---|---|---|---|
| `value` | string | ✓ | Average time it took Printful to fulfill your orders. |
| `relative_difference` | string | ✓ | Relative difference from the value from the previous period. -1 means 100% decrease, 1 means 100% increase. 0 is returned if there is no change or the previous value was 0. |

## `BaseMockupProduct`

| Field | Type | Req | Description |
|---|---|---|---|
| `source` | string | ✓ | Mockup product source Example: `catalog` |
| `mockup_style_ids` | array of integer |  | Used to specify style of mockups that should be generated. For example:   * On the hanger   * On the Male/Female model   * Flat on the table   * etc. Available mockup styles for catalog product can be found under _[Retrieve catalog product … |

## `CalculationStatus`

If the costs are being calculated or recalculated, this will have the status `calculating`. Once finished the status will be `done`.

Type: `string` — enum.

Values:
- `done`
- `calculating`
- `failed`


## `CatalogItem`

`allOf` of:
- `object`
- [`Item`](#item)


## `CatalogItemReadonly`

`allOf` of:
- `object`
- [`ItemReadonly`](#itemreadonly)


## `CatalogItemSummary`

Simplified information about the Catalog Item

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Item ID Example: `1234` |
| `type` | string | ✓ | The item type Enum: `order_item`, `branding_item` Example: `order_item` |
| `source` | string | ✓ | Item source Enum: `catalog` Example: `catalog` |
| `catalog_variant_id` | integer | ✓ | Catalog Variant ID associated with the Item Example: `4011` |
| `external_id` | string | ✓ | Item user specified external ID Example: `123_abc` |
| `quantity` | integer | ✓ | Item quantity Example: `1` |
| `name` | string |  | Item custom name Example: `Custom name` |
| `price` | string | ✓ | The price Printful charges for the Item Example: `8.00` |
| `retail_price` | string | ✓ | Item retail price Example: `10.00` |
| `currency` | string | ✓ | The price currency Example: `EUR` |
| `retail_currency` | string | ✓ | The retail price currency Example: `USD` |
| `_links` | object | ✓ | HATEOAS links |

## `CatalogMockupProduct`

_(no properties)_


## `CatalogOption`

Catalog option definition

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Example: `3d_puff` |
| `techniques` | array of string | ✓ | Available techniques for option |
| `type` | string | ✓ | Type of accepted value Example: `boolean` |
| `values` | array of object | ✓ | List of available option values. |

## `CatalogShippingRateItem`

`allOf` of:
- `object`


## `CatalogStockUpdatedEventConfigurationRequest`

`allOf` of:
- `(inline)`
- [`DefaultEventConfigurationRequest`](#defaulteventconfigurationrequest)
- `(inline)`


## `Category`

Information about the Category

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Category ID Example: `24` |
| `parent_id` | integer | ✓ | ID of the parent Category. If there is no parent Category, null is returned. Example: `6` |
| `image_url` | string | ✓ | The URL of the Category image Example: `https://s3-printful.stage.printful.dev/upload/catalog_category/b1/b1513c82696405fcc316fc611c57f132_t?v=1646395980` |
| `title` | string | ✓ | Category title Example: `T-Shirts` |
| `_links` | object | ✓ | HATEOAS links |

## `Costs`

The Order costs (Printful prices)

| Field | Type | Req | Description |
|---|---|---|---|
| `calculation_status` | [`CalculationStatus`](#calculationstatus) | ✓ |  |
| `currency` | string | ✓ | The code of the currency in which the costs are returned. Example: `USD` |
| `subtotal` | string | ✓ | Total cost of all items. Example: `14.95` |
| `discount` | string | ✓ | Discount sum. Example: `1.79` |
| `shipping` | string | ✓ | Shipping costs. Example: `4.79` |
| `digitization` | string | ✓ | Digitization costs. Example: `3.95` |
| `additional_fee` | string | ✓ | Additional fee for custom product. Example: `0.00` |
| `fulfillment_fee` | string | ✓ | Custom product fulfillment fee. Example: `0.00` |
| `retail_delivery_fee` | string | ✓ | Retail delivery fee. Example: `0.00` |
| `vat` | string | ✓ | Sum of vat (not included in the item price). Example: `4.60` |
| `tax` | string | ✓ | Sum of taxes (not included in the item price). Example: `0.00` |
| `total` | string | ✓ | Grand Total (subtotal-discount+tax+vat+shipping). Example: `26.50` |

## `CostsByAmount`

Costs by amount report

Type: `array`


## `CostsByProduct`

Costs by product report

Type: `array`


## `CostsByVariant`

Costs by variant report

Type: `array`


## `Country`

| Field | Type | Req | Description |
|---|---|---|---|
| `code` | string | ✓ | Country code Example: `AU` |
| `name` | string | ✓ | Country name Example: `Australia` |
| `states` | array of object | ✓ | This array contains all states available for a country. If states are not required or not applicable for a given country this array will be empty. |

## `CustomBorderColorOption`

Used to specify the border color of a sticker

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `custom_border_color` Example: `custom_border_color` |
| `value` | string | ✓ | Color defined in hexadecimal format Example: `#FF0000` |

## `Customization`

The Order's customization values

| Field | Type | Req | Description |
|---|---|---|---|
| `gift` | [`Gift`](#gift) |  |  |
| `packing_slip` | [`PackingSlip`](#packingslip) |  |  |

## `CustomizationReadonly`

The Order's customization values

| Field | Type | Req | Description |
|---|---|---|---|
| `gift` | [`Gift`](#gift) | ✓ |  |
| `packing_slip` | [`PackingSlipReadonly`](#packingslipreadonly) | ✓ |  |

## `DefaultEventConfigurationRequest`

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string | ✓ | Event type. The dropdown shows values required for webhook event configuration. During the setup of a new webhook event please check this dropdown if the event does not require additional parameters to be set. Example: `shipment_sent` |
| `url` | string |  | Webhook URL (HTTPS-only) that will receive the event notifications. Example: `​https://www.example.com/printful/webhook` |

## `DesignPlacement`

Information about the product placements that can be used to specify the design placement

| Field | Type | Req | Description |
|---|---|---|---|
| `placement` | string | ✓ | Name of placement that can be used to place design in a correct spot on a product Example: `back` |
| `technique` | string | ✓ | Indicates technique for which the placements are available Example: `embroidery` |
| `layers` | array of object | ✓ | Available layers for that product |
| `placement_options` | array of [`CatalogOption`](#catalogoption) |  | Possible placement options |

## `Error`

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string |  | a URI that uniquely identifies the validation rule that failed. If it’s a URL, it should point to an explanation of the constraint in the documentation. Example: `https://developers.printful.com/docs/v2/errors#specific-validation-error` |
| `detail` | string |  | A human-readable explanation of the error Example: `Parameter `xyz` was incorrect` |
| `source` |  |  | Source of the value that caused the issue |
| `valid_values` | array of string |  | List of valid values that could be used instead to avoid the error |

## `EstimationAddress`

Information about the address for estimations.

| Field | Type | Req | Description |
|---|---|---|---|
| `state_code` | string |  | State code. Example: `CA` |
| `country_code` | string | ✓ | Country code Example: `US` |
| `zip` | string | ✓ | ZIP/Postal code Example: `91311` |

## `EventConfigurationRequest`

_(no properties)_


## `EventConfigurationResponse`

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string | ✓ | Event type. Example: `catalog_stock_updated` |
| `url` | string |  | Webhook URL (HTTPS-only) that will receive the event notifications. Example: `​https://www.example.com/printful/webhook` |
| `params` | array of object |  |  |

## `File`

Information about the File

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | File ID Example: `123` |
| `url` | string | ✓ | Source URL where the file was downloaded from. Example: `​https://www.example.com/files/tshirts/example.png` |
| `hash` | string | ✓ | MD5 checksum of the file Example: `ea44330b887dfec278dbc4626a759547` |
| `filename` | string | ✓ | File name Example: `shirt1.png` |
| `mime_type` | string | ✓ | MIME type of the file Example: `image/png` |
| `size` | integer | ✓ | Size in bytes Example: `45582633` |
| `width` | integer | ✓ | Width in pixels Example: `1000` |
| `height` | integer | ✓ | Height in pixels Example: `1000` |
| `dpi` | integer | ✓ | Resolution DPI.<br>**Note:** for vector files this may be indicated as only 72dpi, but it doesn't affect print quality since the vector files are resolution independent. Example: `300` |
| `status` | string | ✓ | File processing status Enum: `waiting`, `ok`, `failed`, `deleted` Example: `ok` |
| `created` | string | ✓ | File creation date Example: `2023-04-05T06:07:08Z` |
| `thumbnail_url` | string | ✓ | Small thumbnail URL Example: `https://files.cdn.printful.com/files/ea4/ea44330b887dfec278dbc4626a759547_thumb.png` |
| `preview_url` | string | ✓ | Medium preview image URL Example: `https://files.cdn.printful.com/files/ea4/ea44330b887dfec278dbc4626a759547_thumb.png` |
| `visible` | boolean | ✓ | Whether the file is shown in the Printfile Library. Example: `True` |
| `is_temporary` | boolean | ✓ | Whether it is a temporary printfile. Example: `False` |
| `_links` | object | ✓ | HATEOAS links |

## `FileLayer`

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string | ✓ | File type layer Example: `file` |
| `layer_options` | array of [`CatalogOption`](#catalogoption) |  | Possible layer options |

## `FileOptionPrices`

Info about additional product file option prices

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option name Example: `unlimited_color` |
| `type` | string | ✓ | Option value type Example: `array` |
| `values` | array of object | ✓ | Possible option values |
| `description` | string | ✓ | Option description Example: `Unlimited color` |
| `price` | object | ✓ | Additional price expressed in the region currency |

## `FilterSettings`

The list of the filters that were used in the request

Type: `array`


## `Gift`

The gift subject and message

| Field | Type | Req | Description |
|---|---|---|---|
| `subject` | string |  | Gift message subject Example: `To John` |
| `message` | string |  | Gift message Example: `Happy birthday!` |

## `HateoasLink`

| Field | Type | Req | Description |
|---|---|---|---|
| `href` | string | ✓ | The HREF of the linked resource. |

## `HeaderSource`

| Field | Type | Req | Description |
|---|---|---|---|
| `header` | string |  | Name of the header which is incorrect Example: `X-PF-Language` |

## `InsideLabelTypeOption`

Specify the type of inside label

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `inside_label_type` Example: `inside_label_type` |
| `value` | string | ✓ | Specifies type of inside label design that should be used Enum: `native`, `custom` |

## `InsidePocketOption`

Specify if inside pocket should be added to the product

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `inside_pocket` Example: `inside_pocket` |
| `value` | boolean | ✓ | Whether inside pocket should be added to the product. Example: `True` |

## `InternalId`

ID of the resource, assigned by Printful

Type: `integer`


## `Item`

Information about the Item

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer |  | Item ID Example: `1234` |
| `external_id` | [`ItemExternalId`](#itemexternalid) |  |  |
| `quantity` | integer |  | Item quantity Example: `1` |
| `retail_price` | string |  | Item retail price Example: `10.00` |
| `name` | string |  | Item custom name Example: `Custom name` |
| `placements` | [`PlacementsList`](#placementslist) |  |  |
| `orientation` | string |  | Orientation of the design. Applies only to the products that allow multiple orientations such as framed posters. Enum: `horizontal`, `vertical`, `any` Example: `horizontal` |
| `product_options` | [`ProductOptions`](#productoptions) |  |  |
| `_links` | object |  | HATEOAS links |

## `ItemExternalId`

Item user specified external ID

Type: `string`


## `ItemReadonly`

Information about the Item

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Item ID Example: `1234` |
| `external_id` | [`ItemExternalId`](#itemexternalid) | ✓ |  |
| `quantity` | integer | ✓ | Item quantity Example: `1` |
| `retail_price` | string | ✓ | Item retail price Example: `10.00` |
| `name` | string | ✓ | Item custom name Example: `Custom name` |
| `placements` | [`PlacementsList`](#placementslist) | ✓ |  |
| `product_options` | [`ProductOptions`](#productoptions) | ✓ |  |
| `_links` | object | ✓ | HATEOAS links |

## `ItemWithoutPlacements`

Information about the Item

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer |  | Item ID Example: `1234` |
| `external_id` | [`ItemExternalId`](#itemexternalid) |  |  |
| `quantity` | integer |  | Item quantity Example: `1` |
| `retail_price` | string |  | Item retail price Example: `10.00` |
| `name` | string |  | Item custom name Example: `Custom name` |
| `_links` | object |  | HATEOAS links |

## `ItemWithoutPlacementsReadonly`

Information about the Item

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Item ID Example: `1234` |
| `external_id` | [`ItemExternalId`](#itemexternalid) | ✓ |  |
| `quantity` | integer | ✓ | Item quantity Example: `1` |
| `retail_price` | string | ✓ | Item retail price Example: `10.00` |
| `name` | string | ✓ | Item custom name Example: `Custom name` |
| `_links` | object | ✓ | HATEOAS links |

## `KnitwearBaseColor`

Used to specify the base color on a knitwear product.

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `base_color` Example: `base_color` |
| `value` | [`KnitwearOptionValue`](#knitwearoptionvalue) | ✓ |  |

## `KnitwearColorReductionMode`

Used to set the color reduction mode for a knitwear product

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `color_reduction_mode` Example: `color_reduction_mode` |
| `value` | string | ✓ | Option value Enum: `solid`, `pixelated` Example: `pixelated` |

## `KnitwearOptionValue`

Option value

Type: `string` — enum.

Values:
- `#090909`
- `#404040`
- `#563c33`
- `#d52213`
- `#6e5242`
- `#7f6a53`
- `#cd5e38`
- `#b57648`
- `#d1773b`
- `#d68785`
- `#c6b5a7`
- `#d6c6b4`
- `#dcd3cc`
- `#edd9d9`
- `#e2dfdc`
- `#fdfafa`
- `#999996`
- `#dda032`
- `#d1c6ae`
- `#eddea4`
- `#48542e`
- `#6e8c4b`
- `#c0c1bd`
- `#243f33`
- `#c5d1d0`
- `#175387`
- `#237d96`
- `#787979`
- `#343d55`
- `#4e59be`
- `#566e99`
- `#504372`
- `#4c1c29`
- `#f66274`
- `#eda6b4`
- `#ddabc8`


## `KnitwearTrimColor`

Used to specify the color of the trim on a knitwear product.

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `trim_color` Example: `trim_color` |
| `value` | [`KnitwearOptionValue`](#knitwearoptionvalue) | ✓ |  |

## `KnitwearYarnColor`

Used to specify the yarn colors for the whole product. These are the colors that will be used across the whole product.

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `yarn_colors` Example: `yarn_colors` |
| `value` | array of [`KnitwearOptionValue`](#knitwearoptionvalue) | ✓ | Option value |

## `Layer`

Information about the Layer

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string | ✓ | Type of layer (e.g. file, text) Example: `file` |
| `url` | string | ✓ | File image URL if layer type is file Example: `​https://www.printful.com/static/images/layout/printful-logo.png` |
| `layer_options` | [`LayerOptions`](#layeroptions) |  |  |
| `position` | [`LayerPosition`](#layerposition) |  |  |

## `LayerOptionPrices`

Info about additional product item option prices

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option name Example: `3d_puff` |
| `type` | string | ✓ | Option value type Example: `array` |
| `values` | array of object | ✓ | Possible option values |
| `description` | string | ✓ | Option description Example: `3D puff` |
| `price` | object | ✓ | Additional price expressed in the region currency |

## `LayerOptions`

List of layer options

Type: `array`


## `LayerPosition`

Information about the Layer position. If the positions are not provided then the design will be automatically centered.

| Field | Type | Req | Description |
|---|---|---|---|
| `width` | number | ✓ | Layer width in inches Example: `10` |
| `height` | number | ✓ | Layer height in inches Example: `10` |
| `top` | number | ✓ | Layer top position in inches Example: `0` |
| `left` | number | ✓ | Layer left position in inches Example: `0` |

## `Layers`

Information about the layer prices

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string | ✓ | Type of layer Example: `file` |
| `additional_price` | string | ✓ | Additional price for layer Example: `0.00` |
| `layer_options` | array of [`LayerOptionPrices`](#layeroptionprices) | ✓ | Layer options prices |

## `LifelikeOption`

Specifies if generated mockup should use lifelike effect

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `lifelike` Example: `lifelike` |
| `value` | boolean | ✓ | Whether generated mockup should use lifelike effect. Example: `True` |

## `Measurement`

The information about a single size table measurement

| Field | Type | Req | Description |
|---|---|---|---|
| `type_label` | string | ✓ | Measurement type Example: `Length` |
| `unit` | string | ✓ | The measurement unit if it's not defined on the size table level or is different Example: `none` |
| `values` | array of [`MeasurementValue`](#measurementvalue) | ✓ | The measurement values for each size |

## `MeasurementValue`

The measurement value for a specific size

| Field | Type | Req | Description |
|---|---|---|---|
| `size` | string | ✓ | The size with which the value is associated Example: `S` |
| `value` | string |  | The single value associated with a size (whether this or `min_value` and `max_value` will be present) Example: `23.5` |
| `min_value` | string |  | The lower boundary of the value range (whether this and `max_value` or `value` will be present) Example: `20` |
| `max_value` | string |  | The upper boundary of the value range (whether this and `min_value` or `value` will be present) Example: `20` |

## `Mockup`

Result of mockup generator tasks.

| Field | Type | Req | Description |
|---|---|---|---|
| `placement` | string | ✓ | Placement name for which the mockup was generated Example: `front` |
| `display_name` | string | ✓ | This is a name that can be displayed to end customers. Example: `Front Print` |
| `technique` | string | ✓ | Technique name for which the mockup was generated Example: `dtg` |
| `style_id` | integer | ✓ | Mockup style identifier. Available mockup styles can be found under _[Retrieve catalog product mockup styles](#operation/retrieveMockupStylesByProductId)_. Example: `1` |
| `mockup_url` | string | ✓ | Temporary URL to generated mockup image. Image will be removed from the hosting after a day so make sure to persist a copy if needed. Example: `https://printful-upload.s3-accelerate.amazonaws.com/tmp/9c711aabb422cd386da3cb41735069f3/unisex-… |

## `MockupGeneratorTask`

Result of mockup generator task

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Unique task identifier used to check status of the task and retrieve the results once the task is ready. Example: `597350033` |
| `status` | string | ✓ | Task status:  * `completed` – Mockup Generator task was successfully processed  * `pending` – Mockup Generator task is still being processed  * `failed` – Mockup Generator task failed Enum: `completed`, `pending`, `failed` |
| `catalog_variant_mockups` | array of object | ✓ | A list of mockups grouped by variant. Note that the same list of mockups can appear under multiple variants, this happens in cases where the variants have the same mockups, for example if the only difference is the size of the variant. |
| `failure_reasons` | array of [`Error`](#error) | ✓ |  |
| `_links` | object | ✓ | HATEOAS links |

## `MockupStyles`

Data containing information about the available mockup styles

| Field | Type | Req | Description |
|---|---|---|---|
| `placement` | string | ✓ | Catalog product placement for which the mockup styles defined in `mockup_style_ids` could be used. Example: `front` |
| `display_name` | string | ✓ | Placement display name that can be shown to end-customers. Example: `Front print` |
| `technique` | string | ✓ | Technique name Example: `dtg` |
| `print_area_width` | number | ✓ | Print area width of a placement defined in inches Example: `5` |
| `print_area_height` | number | ✓ | Print area height of a placement defined in inches Example: `5` |
| `print_area_type` | string | ✓ | Type of the print area. Enum: `simple`, `advanced` |
| `dpi` | integer | ✓ | Print area DPI Example: `150` |
| `mockup_styles` | array of object | ✓ | A list of available mockup styles for example:   * On the hanger   * On the Male/Female model   * Flat on the table   * etc. |

## `MockupTaskCreation`

| Field | Type | Req | Description |
|---|---|---|---|
| `format` | string |  | Generated file format. PNG will have a transparent background, JPG will have a smaller file size. Enum: `jpg`, `png` |
| `mockup_width_px` | integer |  | Width of the mockup image in pixels. If not specified, the default value will be used. The default value is 1000px. If the value is specified as 2000 that means that resulting mockups will be 2000x2000px. Example: `1000` |
| `products` | array of object | ✓ |  |

## `MockupTemplates`

Data containing information about the available mockup templates which can be used for user-side positioning. For example for intention of generating mockups without the use of Printful's mockup generator.

| Field | Type | Req | Description |
|---|---|---|---|
| `catalog_variant_ids` | array of integer | ✓ | A list of variant IDs for which the positions apply. |
| `placement` | string | ✓ | Catalog product placement that is used for the design. Example: `front` |
| `technique` | string | ✓ | Catalog product technique that is used for the design. Example: `dtg` |
| `image_url` | string | ✓ | Semi-transparent main template image URL. Example: `https://www.printful.com/files/generator/40/11oz_template.png` |
| `background_url` | string | ✓ | Background image URL (optional). Used for certain mockups e.g. a wall behind hanged poster. If it's defined it is intended to be layered under the image defined in `image_url`. |
| `background_color` | string | ✓ | HEX color code that should be used as a background color of `image_url`. |
| `template_width` | integer | ✓ | Width of the whole template in pixels. Example: `560` |
| `template_height` | integer | ✓ | Height of the whole template in pixels. Example: `295` |
| `print_area_width` | integer | ✓ | Print area width (image is positioned in this area). Example: `520` |
| `print_area_height` | integer | ✓ | Print area height (image is positioned in this area). Example: `202` |
| `print_area_top` | integer | ✓ | Print area top offset (offset in template). Example: `18` |
| `print_area_left` | integer | ✓ | Print area left offset (offset in template). Example: `20` |
| `template_positioning` | string | ✓ | Should the main template image (image_url) be used as an overlay or as a background. Enum: `overlay`, `background` Example: `overlay` |
| `orientation` | string | ✓ | Wall art product orientation. Possible values: horizontal, vertical, any Enum: `horizontal`, `vertical`, `any` Example: `any` |
| `template_type` | string |  | Type of inside label used, "native" refers to labels that have preset information, "custom" are fully customizable and require the user to supply country of manufacturing origin, original garment size, and material information. "advanced" i… |
| `role` | string |  | Mockup template role. Enum: `primary`, `template`, `extra`, `unknown`, `advanced_template` Example: `template` |

## `NotesOption`

Include additional notes for fulfillment for embroidery prints

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `notes` Example: `notes` |
| `value` | string | ✓ | Additional notes for fulfillment for embroidery prints. Example: `Please make sure that top side of the print is within print area` |

## `OAuthScope`

Information about the OAuth scope

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Display name of the scope Enum: `View orders of the authorized store`, `View and manage orders of the authorized store`, `View store products`, `View and manage store products`, `View store files`, `View and manage store files`, `View store… |
| `value` | string | ✓ | The scope value Enum: `orders/read`, `orders`, `sync_products/read`, `sync_products`, `file_library/read`, `file_library`, `webhooks/read`, `webhooks/read` Example: `orders/read` |

## `Order`

Order

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Order ID Example: `123` |
| `external_id` | string | ✓ | Order ID from the external system Example: `4235234213` |
| `store_id` | integer | ✓ | Store ID Example: `10` |
| `shipping` | string | ✓ | Shipping method. Defaults to 'STANDARD' Example: `STANDARD` |
| `status` | string | ✓ | Order status:<br /> **draft** - order is not submitted for fulfillment<br /> **failed** - order was submitted for fulfillment but was not accepted because of an error (problem with address, printfiles, charging, etc.)<br /> **pending** - or… |
| `created_at` | string | ✓ | Time when the order was created Example: `2023-04-05T06:07:08Z` |
| `updated_at` | string | ✓ | Time when the order was updated Example: `2023-04-05T06:07:08Z` |
| `recipient` |  | ✓ | The recipient data. |
| `costs` | [`Costs`](#costs) | ✓ |  |
| `retail_costs` | [`RetailCosts`](#retailcosts) | ✓ |  |
| `order_items` | array of object | ✓ | Simplified order item list. For a full list of all items use the [Get Order Items](#operation/getItemsByOrderId) endpoint. |
| `customization` | [`CustomizationReadonly`](#customizationreadonly) |  |  |
| `_links` | object | ✓ | HATEOAS links |

## `OrderSummary`

Order summary

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Order ID Example: `123` |
| `external_id` | string | ✓ | Order ID from the external system Example: `4235234213` |
| `store_id` | integer | ✓ | Store ID Example: `10` |
| `shipping` | string | ✓ | Shipping method. Defaults to 'STANDARD' Example: `STANDARD` |
| `status` | string | ✓ | Order status:<br /> **draft** - order is not submitted for fulfillment<br /> **failed** - order was submitted for fulfillment but was not accepted because of an error (problem with address, printfiles, charging, etc.)<br /> **pending** - or… |
| `created_at` | string | ✓ | Time when the order was created Example: `2023-04-05T06:07:08Z` |
| `updated_at` | string | ✓ | Time when the order was updated Example: `2023-04-05T06:07:08Z` |
| `recipient` |  | ✓ | The recipient data. |
| `costs` | [`Costs`](#costs) | ✓ |  |
| `retail_costs` | [`RetailCosts`](#retailcosts) | ✓ |  |
| `order_items` | array of object | ✓ | Simplified order item list. For a full list of all items use the [Get Order Items](#operation/getItemsByOrderId) endpoint. |
| `_links` | object | ✓ | HATEOAS links |

## `PackingSlip`

The values for customized packing slip

| Field | Type | Req | Description |
|---|---|---|---|
| `email` | string |  | Customer service email Example: `test@example.com` |
| `phone` | string |  | Customer service phone Example: `+48000000000` |
| `message` | string |  | Custom packing slip message Example: `This is a message` |
| `logo_url` | string |  | URL address to a sticker we will put on a package Example: `https://example.com/image.jpg` |
| `store_name` | string |  | Store name override for the return address Example: `A store` |
| `custom_order_id` | string |  | Your own Order ID that will be printed instead of Printful's Order ID Example: `11235813` |

## `PackingSlipReadonly`

The values for customized packing slip

| Field | Type | Req | Description |
|---|---|---|---|
| `email` | string | ✓ | Customer service email Example: `test@example.com` |
| `phone` | string | ✓ | Customer service phone Example: `+48000000000` |
| `message` | string | ✓ | Custom packing slip message Example: `This is a message` |
| `logo_url` | string | ✓ | URL address to a sticker we will put on a package Example: `https://example.com/image.jpg` |
| `store_name` | string | ✓ | Store name override for the return address Example: `A store` |
| `custom_order_id` | string | ✓ | Your own Order ID that will be printed instead of Printful's Order ID Example: `11235813` |

## `Paging`

Paging information

| Field | Type | Req | Description |
|---|---|---|---|
| `total` | integer | ✓ | Total number of items available Example: `100` |
| `offset` | integer | ✓ | Current result set page offset Example: `10` |
| `limit` | integer | ✓ | Max number of items per page Example: `100` |

## `ParameterSource`

| Field | Type | Req | Description |
|---|---|---|---|
| `parameter` | string |  | Name of the URL query parameter that is incorrect Example: `limit` |

## `Placement`

A placement is used to represent the physical area in which a design will be printed, and the technique used. It includes the layers that will be printed on the placement.

| Field | Type | Req | Description |
|---|---|---|---|
| `placement` | string | ✓ | Name of the placement Example: `front` |
| `technique` | string | ✓ | Placement's technique Example: `dtg` |
| `print_area_type` | string |  | Type of the print area. Defaults to simple. Advanced type might be specified only for some specific products for example All-over Tote bag. In that case both sides of the product will be designed. Advanced designs are often more complicated… |
| `layers` | array of [`Layer`](#layer) | ✓ | Information about placement's layers |
| `placement_options` | [`PlacementOptions`](#placementoptions) |  |  |
| `status` | string | ✓ | Status of the placement design Enum: `ok`, `failed` |
| `status_explanation` | string | ✓ | Reason behind failed status Example: `Product with ID: 656 cannot have disjointed design elements.` |

## `Placement-2`

A placement is used to represent the physical area in which a design will be printed, and the technique used.

| Field | Type | Req | Description |
|---|---|---|---|
| `placement` | string | ✓ | Name of the placement Example: `front` |
| `technique` | string | ✓ | Placement's technique Example: `dtg` |
| `print_area_type` | string |  | Type of the print area. Defaults to simple. Advanced type might be specified only for some specific products for example All-over Tote bag. In that case both sides of the product will be designed. Advanced designs are often more complicated… |
| `placement_options` | [`PlacementOptions`](#placementoptions) |  | Status of the placement design |

## `PlacementList`

Each entry in this list represents a placement on the physical product.

Type: `array`


## `PlacementOptions`

List of placement options

Type: `array`


## `PlacementsList`

Each entry in this list represents a placement on the physical product and the design that will be printed in that location.

Type: `array`


## `PointerSource`

| Field | Type | Req | Description |
|---|---|---|---|
| `pointer` | string |  | Pointer to an invalid value in request body Example: `/order_items/0/placements` |

## `PrintfulCosts`

Printful costs report

| Field | Type | Req | Description |
|---|---|---|---|
| `value` | string | ✓ | Amount paid to Printful for fulfillment and shipping. |
| `relative_difference` | string | ✓ | Relative difference from the value from the previous period. -1 means 100% decrease, 1 means 100% increase. 0 is returned if there is no change or the previous value was 0. |

## `ProblemDetails`

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string |  | A URL that can be followed to get to our [documentation](#section/Errors) for the problem type. |
| `status` | integer |  | The HTTP status code. |
| `title` | string |  | A human-readable summary of the problem type. |
| `details` | string |  | A human-readable explanation specific to the occurrence of the problem. |
| `instance` | string |  | Optional. A URI that uniquely identifies the specific occurence of the problem |

## `Product`

Information about the Product

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Product ID Example: `362` |
| `main_category_id` | integer | ✓ | Main category of product Example: `24` |
| `type` | string | ✓ | Product type Example: `T-Shirt` |
| `name` | string | ✓ | Product name Example: `Unisex Organic T-Shirt \| Econscious EC1000` |
| `brand` | string | ✓ | Brand name Example: `Econscious` |
| `model` | string | ✓ | Model name Example: `Unisex Organic T-Shirt` |
| `image` | string | ✓ | URL of a sample image for this product Example: `https://files.cdn.printful.com/products/12/product_1550594502.jpg` |
| `variant_count` | integer | ✓ | Number of available variants for this product Example: `10` |
| `is_discontinued` | boolean | ✓ | Product is discontinued and can no longer be ordered Example: `False` |
| `description` | string | ✓ | Product description |
| `sizes` | array of string | ✓ | Product sizes |
| `colors` | array of object | ✓ | Product colors |
| `techniques` | array of [`Techniques`](#techniques) | ✓ | Product's techniques |
| `placements` | array of object | ✓ | Product's design placements |
| `product_options` | array of [`CatalogOption`](#catalogoption) | ✓ | Possible product options |

## `ProductData`

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer |  | Product ID. Example: `1` |

## `ProductInfo`

Information about the Catalog Product

_(no properties)_


## `ProductLinks`

HATEOAS links

| Field | Type | Req | Description |
|---|---|---|---|
| `self` | object | ✓ | Link to same resource |
| `variants` | object | ✓ | Link to product variants |
| `categories` | object | ✓ | Link to product categories |
| `product_prices` | object | ✓ | Link to product prices |
| `product_sizes` | object | ✓ | Link product size guides |
| `product_images` | object | ✓ | Link product images |
| `availability` | object | ✓ | Link to product stock availability endpoint |

## `ProductOptions`

List of product options

Type: `array`


## `ProductPrices`

Product prices information

| Field | Type | Req | Description |
|---|---|---|---|
| `currency` | string | ✓ | Abbreviation from the store currency or currency specified Example: `EUR` |
| `product` | object | ✓ | Product related with the pricing information |
| `variants` | array of [`VariantsPriceData`](#variantspricedata) | ✓ |  |

## `ProductSizeGuide`

Size Guide information for the Product

| Field | Type | Req | Description |
|---|---|---|---|
| `catalog_product_id` | integer | ✓ | Product ID Example: `13` |
| `available_sizes` | array of string | ✓ | The sizes available for the Product |
| `size_tables` | array of [`SizeTable`](#sizetable) | ✓ | Size tables for the product |

## `ProductTemplateItem`

`allOf` of:
- `object`
- [`ItemWithoutPlacements`](#itemwithoutplacements)


## `ProductsLinks`

HATEOAS links

| Field | Type | Req | Description |
|---|---|---|---|
| `self` | object | ✓ | Link to same resource |
| `next` | object |  | Link to next resource |
| `first` | object |  | Link to first resource |
| `last` | object |  | Link to the last resource |

## `ProductsParam`

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string |  | Param name. Enum: `products` Example: `products` |
| `value` | array of [`ProductData`](#productdata) |  | Param value - list of product data. |

## `Profit`

Profit report

| Field | Type | Req | Description |
|---|---|---|---|
| `value` | string | ✓ | The difference between Sales and Fulfillment. If retail price data is not available, profit might be negative |
| `relative_difference` | string | ✓ | Relative difference from the value from the previous period. -1 means 100% decrease, 1 means 100% increase. 0 is returned if there is no change or the previous value was 0. |

## `Response200`

| Field | Type | Req | Description |
|---|---|---|---|
| `code` | integer |  | Response status code `200` Example: `200` |

## `RetailCosts`

The Order's retail costs

| Field | Type | Req | Description |
|---|---|---|---|
| `calculation_status` | [`CalculationStatus`](#calculationstatus) | ✓ |  |
| `currency` | string | ✓ | The code of the currency in which the retail costs are returned. Example: `EUR` |
| `subtotal` | string | ✓ | Total cost of all items. Example: `26.55` |
| `discount` | string | ✓ | Discount sum. Example: `0.00` |
| `shipping` | string | ✓ | Shipping costs. Example: `4.79` |
| `vat` | string | ✓ | Sum of VAT (not included in the item price). Example: `0.00` |
| `tax` | string | ✓ | Sum of taxes (not included in the item price). Example: `0.00` |
| `total` | string | ✓ | Grand Total (subtotal-discount+tax+vat+shipping). Example: `31.34` |

## `RetailCosts-2`

Retail costs

| Field | Type | Req | Description |
|---|---|---|---|
| `currency` | string |  | The code of the currency in which the retail costs are returned. Example: `EUR` |
| `discount` | string |  | Discount sum. Example: `123.40` |
| `shipping` | string |  | Shipping costs. Example: `123.40` |
| `tax` | string |  | Sum of taxes (not included in the item price). Example: `123.40` |

## `SalesAndCosts`

Sales and costs report

Type: `array`


## `SalesAndCostsSummary`

Sales and costs summary report

Type: `array`


## `SellingRegionStockAvailability`

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Name of the selling region for which the stock availability apply Enum: `worldwide`, `north_america`, `canada`, `europe`, `spain`, `latvia`, `uk`, `france`, `germany`, `australia`, `japan`, `new_zealand`, `italy`, `brazil`, `southeast_asia`… |
| `availability` | string | ✓ | Availability status:   * in stock: The product is stocked in this region and fulfillable with the specified technique   * out of stock: Product went out of stock at the supplier in this region but is fulfillable with the specified technique… |
| `placement_option_availability` | array of object | ✓ | Availability of a placement options for a catalog variant in a specified selling region. If a placement option is present in this array and availability is set to true it means it is available for this product. If it is set to false it mean… |

## `ServerErrorDetails`

`allOf` of:
- [`ProblemDetails`](#problemdetails)
- `object`


## `Shipment`

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer |  | Example: `1` |
| `order_id` | integer |  | Example: `2` |
| `order_external_id` | string |  | Example: `my_custom_id_1234` |
| `carrier` | string |  | The carrier that will fulfill the shipment. Example: `USPS` |
| `service` | string |  | The service being used to fulfill the shipment. Example: `USPS Priority Mail` |
| `shipment_status` | string |  | Enum: `pending`, `onhold`, `canceled`, `packaged`, `shipped`, `returned`, `outstock` Example: `canceled` |
| `shipped_at` | string |  | Example: `2023-06-15T16:35:35Z` |
| `delivery_status` | string |  | Enum: `unknown`, `delivered`, `pre_transit`, `in_transit`, `out_for_delivery`, `available_for_pickup`, `return_to_sender`, `failure`, `canceled` |
| `delivered_at` | string |  | Example: `2023-06-15T16:35:35Z` |
| `departure_address` | object |  |  |
| `is_reshipment` | boolean |  | If there is an issue with items in a shipment, a reshipment might be necessary. This property will be false if it is the original shipment and true if it is a reshipment |
| `tracking_url` | string |  | Example: `​https://myorders.com/tracking/39925631` |
| `tracking_events` | array of [`TrackingEvent`](#trackingevent) |  |  |
| `estimated_delivery` | object |  |  |
| `shipment_items` | array of [`ShipmentItem`](#shipmentitem) |  |  |
| `_links` | object |  |  |

## `Shipment-2`

Basic info about the shipment.

| Field | Type | Req | Description |
|---|---|---|---|
| `departure_country` | string | ✓ | Two-letter code (ISO 3166-1 alpha-2) associated with the departure country. Example: `US` |
| `shipment_items` | array of [`ShipmentItem-2`](#shipmentitem-2) | ✓ | List of items included in the shipment. |
| `customs_fees_possible` | boolean | ✓ | Whether customs fees may be required for this shipment. |

## `ShipmentItem`

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer |  | Example: `10` |
| `order_item_id` | integer |  | Example: `20` |
| `order_item_external_id` | string |  | Example: `item-external-id` |
| `order_item_name` | string |  | Example: `Item name` |
| `quantity` | integer |  | Example: `1` |
| `_links` | object |  |  |

## `ShipmentItem-2`

Basic info about the shipment item.

| Field | Type | Req | Description |
|---|---|---|---|
| `catalog_variant_id` | number | ✓ | Catalog Variant ID of the shipment item. Example: `4011` |
| `quantity` | number | ✓ | List of items included in the shipment. Example: `3` |

## `ShippingCountry`

| Field | Type | Req | Description |
|---|---|---|---|
| `code` | string | ✓ | Country code Example: `AU` |
| `name` | string | ✓ | Country name Example: `Australia` |

## `ShippingRatesAddress`

Information about the address

| Field | Type | Req | Description |
|---|---|---|---|
| `address1` | string |  | Address line 1 Example: `19749 Dearborn St` |
| `address2` | string |  | Address line 2 |
| `city` | string |  | City Example: `Chatsworth` |
| `state_code` | string |  | State code this property is required for certain countries like the United States, Canada and Australia Example: `CA` |
| `country_code` | string | ✓ | Country code Example: `US` |
| `zip` | string |  | ZIP/Postal code Example: `91311` |

## `SizeTable`

Size table for the Product

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string | ✓ | Size table type Enum: `measure_yourself`, `product_measure`, `international` |
| `unit` | string | ✓ | The unit the size table values are in Enum: `inches`, `cm` |
| `description` | string | ✓ | The size table description (HTML) |
| `image_url` | string | ✓ | The URL of an image showing the measurements |
| `image_description` | string | ✓ | The description of the measurement image (HTML) |
| `measurements` | array of [`Measurement`](#measurement) | ✓ | The size table measurements |

## `StitchColorOption`

Specified what color should be used for stitches

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `stitch_color` Example: `stitch_color` |
| `value` | string | ✓ | Option value Example: `white` |

## `StoreSchema`

Information about the Store

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Store ID Example: `10` |
| `type` | string | ✓ | The type of the store is a reference to the type of integration used, Shopify, Etsy, etc. If no first party integration is used, the type will be `native`. Example: `native` |
| `name` | string | ✓ | The name given to the store, chosen by the user. Example: `My Store` |

## `StoreStatistics`

Statistics for a single store

| Field | Type | Req | Description |
|---|---|---|---|
| `store_id` | integer | ✓ | The ID of the store for which the statistics are returned |
| `currency` | string | ✓ | The code of the currency in which the statistics are returned Example: `USD` |
| `sales_and_costs` | [`SalesAndCosts`](#salesandcosts) |  |  |
| `sales_and_costs_summary` | [`SalesAndCostsSummary`](#salesandcostssummary) |  |  |
| `printful_costs` | [`PrintfulCosts`](#printfulcosts) |  |  |
| `profit` | [`Profit`](#profit) |  |  |
| `total_paid_orders` | [`TotalPaidOrders`](#totalpaidorders) |  |  |
| `costs_by_amount` | [`CostsByAmount`](#costsbyamount) |  |  |
| `costs_by_product` | [`CostsByProduct`](#costsbyproduct) |  |  |
| `costs_by_variant` | [`CostsByVariant`](#costsbyvariant) |  |  |
| `average_fulfillment_time` | [`AverageFulfillmentTime`](#averagefulfillmenttime) |  |  |

## `TaskSummary`

Order estimation task summary

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | string | ✓ | Task ID Example: `fc959efb-b3a0-4c12-9cc6-f54d3158291d` |
| `status` | string | ✓ | Task status Enum: `pending`, `failed`, `completed` |
| `costs` |  | ✓ |  |
| `retail_costs` |  | ✓ |  |
| `failure_reasons` | array of string | ✓ | Reasons why calculation failed. |

## `TechniqueEnum`

Type: `string` — enum.

Values:
- `dtg`
- `digital`
- `cut-sew`
- `uv`
- `embroidery`
- `sublimation`
- `dtfilm`


## `TechniqueStockAvailability`

| Field | Type | Req | Description |
|---|---|---|---|
| `technique` |  | ✓ |  |
| `selling_regions` | array of [`SellingRegionStockAvailability`](#sellingregionstockavailability) | ✓ | List of selling regions with stock availability |

## `Techniques`

Information about the available Product's technique

| Field | Type | Req | Description |
|---|---|---|---|
| `key` | string | ✓ | Technique key Example: `embroidery` |
| `display_name` | string | ✓ | Technique display name Example: `Embroidery` |
| `is_default` | boolean | ✓ | This is the default product technique Example: `True` |

## `TemplateMockupProduct`

_(no properties)_


## `ThreadColorsOption`

Specify thread colors for embroidery technique

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `thread_colors` Example: `thread_colors` |
| `value` | array of string | ✓ | Thread colors for embroidery technique |

## `TotalPaidOrders`

Total paid orders report

| Field | Type | Req | Description |
|---|---|---|---|
| `value` | integer | ✓ | Number of unique orders for period |
| `relative_difference` | string | ✓ | Relative difference from the value from the previous period. -1 means 100% decrease, 1 means 100% increase. 0 is returned if there is no change or the previous value was 0. |

## `TrackingEvent`

| Field | Type | Req | Description |
|---|---|---|---|
| `triggered_at` | string |  | Example: `2023-06-15T19:15:05Z` |
| `description` | string |  | Example: `Arrived At Destination` |

## `UnlimitedColorOption`

Specify if the design should use unlimited color technique

| Field | Type | Req | Description |
|---|---|---|---|
| `name` | string | ✓ | Option identifier Enum: `unlimited_color` Example: `unlimited_color` |
| `value` | boolean | ✓ | Whether the design should use unlimited color technique. Example: `True` |

## `Variant`

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Variant ID, use this to specify the product when creating orders Example: `100` |
| `catalog_product_id` | integer | ✓ | ID of the product that this variant belongs to Example: `12` |
| `name` | string | ✓ | Display name Example: `Gildan 64000 Unisex Softstyle T-Shirt with Tear Away (Black / 2XL)` |
| `size` | string | ✓ | Item size Example: `2XL` |
| `color` | string | ✓ | Item color Example: `Black` |
| `color_code` | string | ✓ | Hexadecimal RGB color code. May not exactly reflect the real-world color Example: `#14191e` |
| `color_code2` | string | ✓ | Secondary hexadecimal RGB color code. May not exactly reflect the real-world color |
| `placement_dimensions` |  |  | A list of placement configuration objects, each specifying the layout details for a particular placement. |
| `image` | string | ✓ | URL of a preview image for this variant Example: `https://files.cdn.printful.com/products/12/629_1517916489.jpg` |
| `_links` | object | ✓ | HATEOAS links |

## `VariantImage`

| Field | Type | Req | Description |
|---|---|---|---|
| `placement` | string | ✓ | Placement associated with the image Example: `front` |
| `image_url` | string | ✓ | image URL Example: `https://printful-mockups-dev.s3.amazonaws.com/239-nl4600/medium/flat/front/05_nl4600_flat_front_base_whitebg.png?v=1666248709` |
| `background_color` | string | ✓ | Background color of an image. Null if background transparent Example: `#0f0f0f` |
| `background_image` | string | ✓ | Background image of an image specified in the `image_url`. Null if no background image Example: `https://printful-mockups-dev.s3.amazonaws.com/239-nl4600/medium/flat/front/05_nl4600_flat_front_base_whitebg.png?v=1666248709` |

## `VariantImages`

| Field | Type | Req | Description |
|---|---|---|---|
| `catalog_variant_id` | integer | ✓ | Variant ID Example: `4017` |
| `color` | string | ✓ | Variant color Example: `Turquoise` |
| `primary_hex_color` | string | ✓ | Primary variant hex color used. Use this hex color to fill the mockup. Example: `#15d0d2` |
| `secondary_hex_color` | string | ✓ | Secondary variant hex color used. Use this hex color to fill the mockup. |
| `images` | array of [`VariantImage`](#variantimage) | ✓ | Variant's images |

## `VariantPrices`

Variant prices information

| Field | Type | Req | Description |
|---|---|---|---|
| `currency` | string | ✓ | Currency in which prices are returned Example: `EUR` |
| `product` | object | ✓ |  |
| `variant` | [`VariantsPriceData`](#variantspricedata) | ✓ |  |

## `VariantStockAvailability`

Stock availability data for a specific catalog variant

| Field | Type | Req | Description |
|---|---|---|---|
| `catalog_variant_id` | integer | ✓ | Catalog variant ID for which the the stock availability data apply Example: `4011` |
| `techniques` | array of [`TechniqueStockAvailability`](#techniquestockavailability) | ✓ | Stock availability data for specific techniques of a catalog variant |
| `_links` | object | ✓ | HATEOAS links |

## `VariantTechniquePrice`

Product prices information

| Field | Type | Req | Description |
|---|---|---|---|
| `technique_key` | string | ✓ | Key associated to the technique Example: `digital` |
| `technique_display_name` | string | ✓ | Full technique name Example: `Digital printing` |
| `price` | string | ✓ | Price converted to the region currency Example: `9.50` |
| `discounted_price` | string | ✓ | Discounted price per region Example: `8.50` |

## `VariantsPriceData`

Variant with the pricing information

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Variant id Example: `1` |
| `techniques` | array of [`VariantTechniquePrice`](#varianttechniqueprice) | ✓ | Array containing pricing information about available techniques per variant |

## `WarehouseItemReadonly`

`allOf` of:
- `object`
- [`ItemWithoutPlacementsReadonly`](#itemwithoutplacementsreadonly)


## `WarehouseItemSummary`

Simplified information about the Warehouse Item

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer |  | Item ID Example: `1234` |
| `type` | string |  | The item type Enum: `order_item`, `branding_item` Example: `order_item` |
| `source` | string |  | Item source Enum: `warehouse` Example: `warehouse` |
| `warehouse_product_variant_id` | integer |  | ID of warehouse product associated with the Item Example: `1123581321` |
| `external_id` | string |  | Item user specified external ID Example: `123_abc` |
| `quantity` | integer |  | Item quantity Example: `1` |
| `name` | string |  | Item custom name Example: `Custom name` |
| `price` | string |  | The price Printful charges for the Item Example: `8.00` |
| `retail_price` | string |  | Item retail price Example: `10.00` |
| `currency` | string |  | The price currency Example: `EUR` |
| `retail_currency` | string |  | The retail price currency Example: `USD` |
| `_links` | object |  | HATEOAS links |

## `WarehouseShippingRateItem`

`allOf` of:
- `object`


## `Webhook`

| Field | Type | Req | Description |
|---|---|---|---|
| `type` | string | ✓ | Event type |
| `occurred_at` | string | ✓ | Event time Example: `2023-04-05T06:07:08Z` |
| `retries` | integer | ✓ | Number of previous attempts to deliver this webhook event Example: `2` |
| `store_id` | integer | ✓ | ID of the store that the event occurred to Example: `12` |

## `WebhookCreated`

`allOf` of:
- `(inline)`
- [`WebhookInfoResponse`](#webhookinforesponse)
- `(inline)`


## `WebhookInfoRequest`

| Field | Type | Req | Description |
|---|---|---|---|
| `default_url` | string |  | Webhook URL (HTTPS-only) that will receive store's event notifications if no URL is set for the event. Example: `​https://www.example.com/printful/webhook` |
| `expires_at` | string |  | Date-time indicating when the configuration should expire. The default value is `null` meaning it won't expire. Example: `2023-04-05T06:07:08Z` |
| `events` | array of [`EventConfigurationRequest`](#eventconfigurationrequest) |  | Array of enabled webhook event configurations |

## `WebhookInfoResponse`

| Field | Type | Req | Description |
|---|---|---|---|
| `default_url` | string | ✓ | Webhook URL (HTTPS-only) that will receive store's event notifications if no URL is set for the event. Example: `​https://www.example.com/printful/webhook` |
| `expires_at` | string | ✓ | Date-time indicating when the configuration will expire. The default value is `null` meaning it won't expire. Example: `2023-04-05T06:07:08Z` |
| `events` | array of [`EventConfigurationResponse`](#eventconfigurationresponse) | ✓ | Array of enabled webhook event configurations |
| `public_key` | string |  | Public key used to identify the specific settings. Example: `SbF/9d/uWguI` |

## `WebhookOrderData`

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Order's ID |
| `external_id` | string | ✓ | Order's External ID |
| `status` | string | ✓ | Order's status |
| `store_id` | integer | ✓ | ID of the store associated with the order |
| `dashboard_url` | string | ✓ | The URL to view the order in Printful dashboard |
| `created_at` | string | ✓ | Order creation date-time Example: `2023-04-05T06:07:08Z` |
| `updated_at` | string | ✓ | Latest order's update date-time Example: `2023-04-05T06:07:08Z` |

## `WebhookShipmentData`

| Field | Type | Req | Description |
|---|---|---|---|
| `id` | integer | ✓ | Shipment's ID |
| `status` | string | ✓ | Shipment's status |
| `store_id` | integer | ✓ | ID of the store associated with the shipment |
| `tracking_number` | string | ✓ | The tracking code associated with the shipment |
| `tracking_url` | string | ✓ | Shipment tracking URL Example: `​https://www.fedex.com/fedextrack/?tracknumbers=0000000000` |
| `created_at` | string | ✓ | Shipment creation date-time Example: `2023-04-05T06:07:08Z` |
| `ship_date` | string | ✓ | Ship date (`Y-m-d`) Example: `2023-03-21` |
| `shipped_at` | string | ✓ | Date-time of when the shipment was sent Example: `2023-04-05T06:07:08Z` |
| `reshipment` | boolean | ✓ | Whether this is a reshipment Example: `False` |
