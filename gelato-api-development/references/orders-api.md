# Orders API (v4)

Base URL: `https://order.gelatoapis.com`

The Orders API is where the money happens. This reference covers every endpoint, the full request/response shape, the `order` vs. `draft` distinction, the fulfillment + financial status state machines, and the operational patterns you'll need.

## Endpoint inventory

| Verb | Path | Purpose |
| --- | --- | --- |
| `POST`   | `/v4/orders` | Create an order or draft |
| `GET`    | `/v4/orders/{orderId}` | Get one order by Gelato ID |
| `POST`   | `/v4/orders:search` | Search / filter / paginate orders |
| `POST`   | `/v4/orders:quote` | Get a price + shipping quote without creating an order |
| `PATCH`  | `/v4/orders/{orderId}` | Patch a draft order (e.g., convert to production) |
| `POST`   | `/v4/orders/{orderId}:cancel` | Cancel a created order (only before `passed`/`printed`/`shipped`) |
| `DELETE` | `/v4/orders/{orderId}` | Delete a draft order (only draft orders are deletable) |

> **v3 vs. v4**: v3 is the previous generation, still callable for backward compatibility but missing some v4 capabilities. New work goes to v4. If a user is on v3, the migration is mostly a path swap (`/v3/` → `/v4/`) plus minor schema cleanup — check changelog / dashboard docs for specifics.

## Order types

| `orderType` | Behavior |
| --- | --- |
| `"order"` (default) | Real production order. Payment is attempted at creation. Enters fulfillment immediately on payment success. |
| `"draft"` | Saved order. **No payment is attempted, nothing goes to print.** Can be edited in the dashboard or via the Patch API. Convert to production with `PATCH /v4/orders/{id}` setting `orderType: "order"`. |

Draft orders are the right tool for:

- Validating the shape of an order programmatically (file URLs resolve, productUid is valid, address passes validation) without committing to charge.
- Letting a human review before production (custom merchandise approval flows).
- Building a cart UX where the user keeps editing the order before submitting.

Draft orders can be **deleted**; production orders can be **canceled** before they reach `passed`/`printed`/`shipped`.

## Create order

```http
POST /v4/orders
Content-Type: application/json
X-API-KEY: <key>
```

### Minimal valid body

```json
{
  "orderReferenceId": "your-internal-order-id-12345",
  "customerReferenceId": "your-customer-id-67890",
  "currency": "USD",
  "items": [
    {
      "itemReferenceId": "line-1",
      "productUid": "apparel_product_gca_t-shirt_gsc_crewneck_gcu_unisex_gqa_classic_gsi_s_gco_white_gpr_4-4",
      "files": [
        { "type": "default", "url": "https://cdn.example.com/print.pdf" }
      ],
      "quantity": 1
    }
  ],
  "shippingAddress": {
    "firstName": "Paul",
    "lastName": "Smith",
    "addressLine1": "451 Clarkson Ave",
    "city": "New York",
    "postCode": "11203",
    "state": "NY",
    "country": "US",
    "email": "paul@example.com"
  }
}
```

### Full body (every field)

```json
{
  "orderType": "order",
  "orderReferenceId": "your-internal-order-id-12345",
  "customerReferenceId": "your-customer-id-67890",
  "currency": "USD",
  "items": [
    {
      "itemReferenceId": "line-1",
      "productUid": "...",
      "pageCount": 116,
      "files": [
        { "type": "default",      "url": "https://..." },
        { "type": "back",         "url": "https://..." },
        { "type": "neck-inner",   "url": "https://..." },
        { "type": "sleeve-left",  "url": "https://..." }
      ],
      "quantity": 2
    }
  ],
  "metadata": [
    { "key": "campaign", "value": "summer-2026" },
    { "key": "channel",  "value": "instagram" }
  ],
  "shipmentMethodUid": "express",
  "shippingAddress": {
    "companyName": "Acme Inc",
    "firstName": "Paul",
    "lastName": "Smith",
    "addressLine1": "451 Clarkson Ave",
    "addressLine2": "Suite 200",
    "city": "New York",
    "postCode": "11203",
    "state": "NY",
    "country": "US",
    "email": "paul@example.com",
    "phone": "+12125551234",
    "isBusiness": true,
    "federalTaxId": "...",
    "stateTaxId": "...",
    "registrationStateCode": "..."
  },
  "returnAddress": {
    "companyName": "Acme Returns",
    "addressLine1": "...",
    "city": "...",
    "postCode": "...",
    "state": "...",
    "country": "US",
    "email": "returns@acme.com"
  }
}
```

### Field details

| Field | Required | Type | Notes |
| --- | --- | --- | --- |
| `orderType` | no | `"order"` \| `"draft"` | Default `"order"`. |
| `orderReferenceId` | YES | string | Your internal order ID. Acts as a soft idempotency key. |
| `customerReferenceId` | YES | string | Your internal customer ID. |
| `currency` | YES | string (ISO 4217) | One of ~40 supported currencies (see `references/pricing-currencies-charging.md`). |
| `items` | YES | array | One per line item. |
| `items[].itemReferenceId` | YES | string | Your internal line-item ID. Must be unique within the order. |
| `items[].productUid` | YES | string | Gelato product UID. See `references/product-uid-format.md`. |
| `items[].pageCount` | conditional | int | Required for multi-page products (photo books, notebooks). Count includes covers. |
| `items[].files` | conditional | array | Required for printable products. See `references/files-and-print-files.md` for the file shape. |
| `items[].quantity` | YES | int ≥ 1 | Number of copies. |
| `metadata` | no | array of `{key, value}` | Up to 20 entries. Free-form per-order tags. |
| `shipmentMethodUid` | no | string | `"normal"`, `"express"`, `"pallet"`, or a specific UID from Shipment Methods / Quote. Default: cheapest. |
| `shippingAddress` | YES | object | Where to deliver. See address fields below. |
| `returnAddress` | no | object | Override the parcel's return-to address (any subset of fields). |

### Shipping address fields

```
firstName             required, ≤ 25 chars
lastName              required, ≤ 25 chars
companyName           optional, ≤ 60 chars
addressLine1          required, ≤ 35 chars
addressLine2          optional, ≤ 35 chars
city                  required, ≤ 30 chars
postCode              required, ≤ 15 chars
state                 required if country is AU, CA, or US; ≤ 35 chars (US state code, etc.)
country               required, ISO 3166-1 alpha-2
email                 required
phone                 optional, E.123 format, ≤ 25 chars
isBusiness            optional, boolean (defaults false). For BR: distinguishes CPF vs CNPJ.
federalTaxId          required for BR; CPF for individual, CNPJ for business
stateTaxId            required for BR business; IE
registrationStateCode required for BR business; state where company is registered
```

### Response

`201 Created` (or `200 OK`) with the full Order object:

```json
{
  "id": "abc123-gelato-id",
  "orderType": "order",
  "orderReferenceId": "your-internal-order-id-12345",
  "customerReferenceId": "your-customer-id-67890",
  "fulfillmentStatus": "created",
  "financialStatus": "paid",
  "currency": "USD",
  "channel": "api",
  "createdAt": "2026-05-28T12:34:56Z",
  "updatedAt": "2026-05-28T12:34:56Z",
  "orderedAt": "2026-05-28T12:34:56Z",
  "items": [ ... ],
  "shipment": { ... },
  "shippingAddress": { "id": "...", ... },
  "receipts": [ { ... per-currency totals ... } ]
}
```

## Get order

```http
GET /v4/orders/{orderId}
```

Returns the full Order object (same shape as the Create response). Use this to poll status if you don't have webhooks set up.

Note: `orderId` here is Gelato's ID, not your `orderReferenceId`. To look up by your reference, use Search.

## Search orders

```http
POST /v4/orders:search
Content-Type: application/json
```

Body:

```json
{
  "ids":                   ["g-id-1", "g-id-2"],
  "orderReferenceId":       "your-id",
  "orderReferenceIds":      ["your-id-1", "your-id-2"],
  "fulfillmentStatuses":    ["passed", "printed"],
  "financialStatuses":      ["paid"],
  "channels":               ["api", "shopify"],
  "countries":              ["US", "CA"],
  "search":                 "free-text term",
  "startDate":              ["2026-05-01"],
  "endDate":                ["2026-05-31"],
  "offset":                 0,
  "limit":                  100
}
```

All fields optional; combine as needed.

Response:

```json
{
  "orders": [
    {
      "id": "...", "orderReferenceId": "...",
      "fulfillmentStatus": "...", "financialStatus": "...",
      "currency": "...", "channel": "...",
      "country": "...", "firstName": "...", "lastName": "...",
      "createdAt": "...", "updatedAt": "...", "orderedAt": "..."
    }
  ]
}
```

Search returns a slim Order summary, not the full Order object. To get full details, GET each by ID.

## Quote order

```http
POST /v4/orders:quote
Content-Type: application/json
```

Same shape as create, but uses `recipient` instead of `shippingAddress` and `products` instead of `items`:

```json
{
  "orderReferenceId": "quote-test-001",
  "customerReferenceId": "customer-001",
  "currency": "USD",
  "allowMultipleQuotes": false,
  "recipient": {
    "country": "US",
    "firstName": "Paul",
    "lastName": "Smith",
    "addressLine1": "451 Clarkson Ave",
    "city": "New York",
    "postCode": "11203",
    "state": "NY",
    "email": "paul@example.com"
  },
  "products": [
    {
      "itemReferenceId": "line-1",
      "productUid": "...",
      "pageCount": 116,
      "files": [{ "type": "default", "url": "https://..." }],
      "quantity": 1
    }
  ]
}
```

Response includes one or more "quotes" with available shipment methods and prices:

```json
{
  "orderReferenceId": "quote-test-001",
  "quotes": [
    {
      "id": "quote-123",
      "itemReferenceIds": ["line-1"],
      "fulfillmentCountry": "US",
      "products": [
        {
          "itemReferenceId": "line-1",
          "productUid": "...",
          "quantity": 1,
          "price": 12.5,
          "currency": "USD"
        }
      ],
      "shipmentMethods": [
        {
          "name": "UPS Ground",
          "shipmentMethodUid": "ups_ground",
          "price": 6.5,
          "currency": "USD",
          "minDeliveryDays": 3,
          "maxDeliveryDays": 5,
          "minDeliveryDate": "2026-05-31",
          "maxDeliveryDate": "2026-06-04",
          "type": "normal",
          "isPrivate": true,
          "isBusiness": true,
          "totalWeight": 250,
          "numberOfParcels": 1
        }
      ]
    }
  ]
}
```

When `allowMultipleQuotes: true`, an order spanning multiple production countries returns one quote per country.

Quote requests **do not** charge anything or create an order. Use them on cart pages or for live shipping calculation.

## Patch order (draft → production)

```http
PATCH /v4/orders/{orderId}
Content-Type: application/json
```

Only works on **draft** orders. Two main uses:

### Convert draft to production

```json
{
  "orderType": "order"
}
```

This locks in the order and attempts payment. After conversion, no further patches are possible.

### Update items in a draft

```json
{
  "orderType": "order",
  "items": [
    {
      "id": "existing-item-id-from-Get-Order-response",
      "files": [
        { "type": "default", "url": "https://updated-url..." }
      ]
    }
  ]
}
```

Note that `items[].id` here is the *Gelato-assigned* item ID returned in the Get Order response — not your `itemReferenceId`. Get the order first, then patch with the IDs from the response.

## Cancel order

```http
POST /v4/orders/{orderId}:cancel
```

Returns `true` on success.

**Constraints**:

- Order must not yet be `passed`, `printed`, or `shipped`.
- After cancel, `fulfillmentStatus` becomes `canceled`.
- A canceled order's payment is refunded automatically.
- If the order has already passed into production, this endpoint returns an error and you must contact Gelato support.

## Delete draft order

```http
DELETE /v4/orders/{orderId}
```

Only works on draft orders (`orderType === "draft"`). Production orders cannot be deleted — only canceled (with the constraint above).

## Status state machine

### `fulfillmentStatus`

| Status | Meaning |
| --- | --- |
| `draft` | Saved as draft; not in production. |
| `created` | Created as a production order; awaiting validation/payment. |
| `pending_approval` | Account requires manual review of orders; awaiting Gelato/admin approval. |
| `on_hold` | Held by Gelato (issue with order — contact support). |
| `not_connected` | Order from a connected store but missing connection details. |
| `passed` | Order passed validation; in print queue. **Past this point, cancellation is no longer possible.** |
| `failed` | Validation failed (bad productUid, file unreachable, etc.). Order will not produce. |
| `canceled` | Canceled by you (via Cancel API) or by Gelato. |
| `printed` | Items printed, awaiting shipment pickup. |
| `shipped` | Handed off to carrier; tracking codes available. |

### `financialStatus`

| Status | Meaning |
| --- | --- |
| `draft` | Draft order; no charge attempted. |
| `pending` | Charge in progress. |
| `paid` | Charge succeeded. |
| `to_be_invoiced` | Will be billed on next invoice cycle (invoice customers). |
| `invoiced` | Invoiced. |
| `partially_refunded` | Partial refund applied. |
| `refunded` | Fully refunded (e.g., after cancellation). |
| `canceled` | Charge canceled (e.g., draft deleted). |
| `refused` | Charge refused (insufficient funds, declined card, etc.). |

Webhook events fire on every transition of either status. See `references/webhooks.md`.

## Order object shape (Get response)

```typescript
interface GetOrderResponse {
  id: string;                          // Gelato ID
  orderType: 'order' | 'draft';
  orderReferenceId: string;             // your ID
  customerReferenceId: string;
  fulfillmentStatus: FulfillmentStatus;
  financialStatus: FinancialStatus;
  currency: Currency;                   // ISO 4217
  channel: 'ui' | 'api' | 'shopify' | 'etsy';
  storeId?: string;                     // null for direct API orders
  createdAt: string;                    // ISO 8601
  updatedAt: string;
  orderedAt: string;
  items: ItemObject[];
  shipment?: ShipmentObject;            // populated after shipping
  billingEntity?: BillingEntityObject;
  shippingAddress?: ShippingAddressWithId;
  returnAddress?: ReturnAddressObject;
  receipts: ReceiptObject[];            // per-currency totals + tax breakdown
  connectedOrderIds?: string[];         // for split orders produced in multiple locations
}
```

### Item object (in response)

```typescript
interface ItemObject {
  id: string;                           // Gelato-assigned
  itemReferenceId: string;              // your line ID
  productUid: string;
  pageCount?: number;
  quantity: number;
  fulfillmentStatus: FulfillmentStatus; // per-item, can differ from order-level
  files: { url: string; type?: FileType }[];
  processedFileUrl: string;             // Gelato's processed/imposed file
  previews: { type: 'preview_default' | 'preview_thumbnail'; url: string }[];
  options?: { id: string; type: 'envelope'; productUid: string; quantity: number }[];
}
```

### Shipment object (populated after `shipped`)

```typescript
interface ShipmentObject {
  id: string;
  shipmentMethodName: string;
  shipmentMethodUid: string;
  packageCount: number;
  minDeliveryDays: number;
  maxDeliveryDays: number;
  minDeliveryDate: string;              // ISO 8601
  maxDeliveryDate: string;
  totalWeight: number;
  fulfillmentCountry: string;
  packages: {
    id: string;
    orderItemIds: string[];
    trackingCode: string;
    trackingUrl: string;
  }[];
}
```

### Receipt object (financial breakdown)

```typescript
interface ReceiptObject {
  id: string;
  orderId: string;
  transactionType: string;
  currency: Currency;
  items: ReceiptItemObject[];
  productsPriceInitial: number;
  productsPriceDiscount: number;
  productsPrice: number;
  productsPriceVat: number;
  productsPriceInclVat: number;
  packagingPriceInitial: number;
  packagingPriceDiscount: number;
  packagingPrice: number;
  packagingPriceVat: number;
  packagingPriceInclVat: number;
  shippingPriceInitial: number;
  shippingPriceDiscount: number;
  shippingPrice: number;
  shippingPriceVat: number;
  shippingPriceInclVat: number;
  discount: number;
  discountVat: number;
  discountInclVat: number;
  totalInitial: number;
  total: number;
  totalVat: number;
  totalInclVat: number;
}
```

## Idempotency

Gelato uses `orderReferenceId` as a soft idempotency hint — repeating the same reference within a short window with the same payload typically returns the existing order, but this is not formally guaranteed. To be safe:

- Always use a UUID or unique per-request `orderReferenceId`.
- Wrap your `POST /v4/orders` in a transaction in your DB: write the `orderReferenceId` first, then make the API call, then store the Gelato `id` from the response.
- If you don't get a response (network error), retry the same request — Gelato will return the existing order if it was processed.
- Don't generate a new `orderReferenceId` on retry; that creates duplicate orders.

## Pagination (Search)

- `offset`: where to start (default 0).
- `limit`: max items per response (default 100, max varies).
- The response has a `pagination`-like header for total count on some endpoints; for `:search` you typically iterate by incrementing offset until you get fewer than `limit` results.

## Common create-order failures

| HTTP | Symptom | Fix |
| --- | --- | --- |
| 401 | `X-API-KEY` missing/wrong/revoked | Check + regenerate. |
| 422 | "Invalid productUid" | Query the catalog and use the exact UID returned. |
| 422 | "Missing files" | `files[]` required for printable products. |
| 422 | "File URL unreachable" | URL behind auth / expired / private network. Make it publicly fetchable. |
| 422 | "Invalid address" | Check state code (US/CA/AU require), postCode format, country ISO. |
| 422 | "currency not supported for this account" | Wallet/account configured for fewer currencies than you requested. |
| 422 | "shipmentMethodUid not available for destination" | Use Shipment Methods API filtered by country first. |
| 402 | "Payment refused" | Wallet empty / card declined / invoice limit exceeded. |
| 4xx | "Order with this reference already exists" | Idempotency — fetch the existing order or change the reference. |

See `references/common-pitfalls.md` for the full catalog.

## Original sources

- `references/sources/gelato-admin-node/src/services/orders/orders-api.ts` — endpoint paths + verbs (Apache-2.0).
- `references/sources/gelato-admin-node/src/services/orders/order.ts` — every request/response type definition with field-level docs.
- Official (gated): https://dashboard.gelato.com/docs/orders/v4/create/, /get/, /search/, /quote/, /patch/, /cancel/.
- Official "How orders work" (gated): https://dashboard.gelato.com/docs/orders/order_details/.
