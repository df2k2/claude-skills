# Shipment Methods API (v1)

Base URL: `https://shipment.gelatoapis.com`

This API tells you which shipping options are available, what they cost (when combined with the Quote API), what their delivery windows are, and whether they support tracking. Used both to display shipping choices to customers and to pick a `shipmentMethodUid` for order creation.

## Endpoint

```http
GET /v1/shipment-methods
GET /v1/shipment-methods?country=US
X-API-KEY: <key>
```

That's the entire endpoint surface.

The `country` query parameter filters by destination — typically the right thing to send, since you only care about methods that can actually deliver where the customer lives. Without `country`, you get every method Gelato supports globally.

## Response

```json
{
  "shipmentMethods": [
    {
      "shipmentMethodUid": "ups_ground",
      "type": "normal",
      "name": "UPS Ground",
      "isBusiness": true,
      "isPrivate": true,
      "hasTracking": true,
      "supportedCountries": ["US"]
    },
    {
      "shipmentMethodUid": "ups_2nd_day_air",
      "type": "express",
      "name": "UPS 2nd Day Air",
      "isBusiness": true,
      "isPrivate": true,
      "hasTracking": true,
      "supportedCountries": ["US"]
    },
    {
      "shipmentMethodUid": "fedex_freight_pallet",
      "type": "pallet",
      "name": "FedEx Freight Pallet",
      "isBusiness": true,
      "isPrivate": false,
      "hasTracking": true,
      "supportedCountries": ["US", "CA"]
    }
  ]
}
```

## Field semantics

| Field | Meaning |
| --- | --- |
| `shipmentMethodUid` | Unique identifier. Pass this verbatim to `POST /v4/orders` as the `shipmentMethodUid` field. |
| `type` | One of `"normal"`, `"express"`, `"pallet"`. You can pass the type string in place of a specific UID on order create (see below). |
| `name` | Human-readable name; show this to your customer. |
| `isBusiness` | True if the method ships to business addresses. |
| `isPrivate` | True if the method ships to residential addresses. |
| `hasTracking` | True if Gelato will return a tracking code + URL in the order's `shipment.packages` after dispatch. |
| `supportedCountries` | ISO-3166 alpha-2 codes for destinations the method can deliver to. |

## Method types

| Type | Use case |
| --- | --- |
| `normal` | Standard ground / economy. Cheapest, longest delivery window. |
| `express` | Expedited. Faster, more expensive. |
| `pallet` | Pallet-level freight. For bulk orders (large quantities of apparel, posters, etc.). |

## Picking a method on order create

In `POST /v4/orders`, the `shipmentMethodUid` field accepts:

| Value | Behavior |
| --- | --- |
| (omitted) | Cheapest available method, regardless of type. |
| `"normal"` | Cheapest method with `type: "normal"`. |
| `"express"` | Cheapest method with `type: "express"`. |
| `"pallet"` | Cheapest method with `type: "pallet"`. |
| `"ups_ground"` (specific UID) | Use this exact method. |

The string-type form (`"normal"` / `"express"` / `"pallet"`) is convenient when you don't know the exact UIDs but want the type-tier. The specific-UID form is for when the user picks a specific option from a quote.

## Typical usage patterns

### Pattern A: Cart-page shipping selector

Most common. On the cart page:

1. `GET /v1/shipment-methods?country={destinationCountry}` to learn what's available.
2. Use the `name` to show a dropdown / radio list of options.
3. Use `POST /v4/orders:quote` to get the actual prices for those methods + the items in the cart.
4. Combine: show "{name} — ${price} ({minDeliveryDays}-{maxDeliveryDays} business days)" per method.
5. When the user picks one, store the `shipmentMethodUid` in your cart state.
6. On checkout, pass that UID to `POST /v4/orders`.

### Pattern B: Auto-pick cheapest

For a "we'll choose the best shipping" experience:

1. Skip the Shipment Methods API entirely.
2. POST `/v4/orders` without `shipmentMethodUid` (or with `"normal"`).
3. Gelato picks the cheapest qualifying method.

### Pattern C: Always express

For a high-margin / premium product:

```json
{
  "shipmentMethodUid": "express",
  ...
}
```

### Pattern D: Bulk B2B with tracking

For wholesale orders where tracking is required and pallet shipping is acceptable:

1. `GET /v1/shipment-methods?country={...}` → filter to `hasTracking: true` and `isBusiness: true`.
2. If shipping a large quantity, include `type: "pallet"` options.
3. Choose based on price + delivery window.

## Combining with the Quote API

The Shipment Methods API tells you *what's possible*. The Quote API tells you *what it costs*.

```bash
# Get available methods (fast, free)
curl -H "X-API-KEY: $KEY" \
  "https://shipment.gelatoapis.com/v1/shipment-methods?country=US"

# Get actual prices for those methods given the cart contents
curl -X POST -H "X-API-KEY: $KEY" -H "Content-Type: application/json" \
  -d '{
    "orderReferenceId": "cart-1",
    "customerReferenceId": "user-42",
    "currency": "USD",
    "recipient": { "country": "US", "firstName": "...", ... },
    "products": [{ "itemReferenceId": "l1", "productUid": "...", "quantity": 1 }]
  }' \
  https://order.gelatoapis.com/v4/orders:quote
```

Quote response includes per-method `price`, `minDeliveryDays`, `maxDeliveryDays`, `minDeliveryDate`, `maxDeliveryDate`, plus the method's `name`/`type`/etc.

## Tracking on shipped orders

When a method has `hasTracking: true` and the order ships, the order's `shipment.packages` array populates:

```json
{
  "shipment": {
    "id": "...",
    "shipmentMethodName": "UPS Ground",
    "shipmentMethodUid": "ups_ground",
    "packageCount": 1,
    "minDeliveryDays": 3,
    "maxDeliveryDays": 5,
    "minDeliveryDate": "2026-06-01",
    "maxDeliveryDate": "2026-06-03",
    "totalWeight": 280,
    "fulfillmentCountry": "US",
    "packages": [
      {
        "id": "pkg-1",
        "orderItemIds": ["g-id-item-1"],
        "trackingCode": "1Z999AA10123456784",
        "trackingUrl": "https://www.ups.com/track?tracknum=1Z999AA10123456784"
      }
    ]
  }
}
```

Multi-item orders may have multiple packages — e.g., an apparel item + a poster might ship separately. The `orderItemIds` array tells you which items are in each package.

## Common failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| Empty `shipmentMethods` array | Country has no available methods (rare, or wrong country code) | Verify ISO 3166-1 alpha-2 (e.g., "GB" not "UK"). |
| 422 on order create: "shipmentMethodUid not available for destination" | UID is real but doesn't serve that country | Pre-filter by `country` first. |
| 422 on order create: "Invalid shipmentMethodUid" | Typo, or UID has been retired | Re-fetch the list. |
| No `trackingCode` after shipped | Method has `hasTracking: false` | Choose a tracked method if tracking matters. |

## A note on cost

Shipment Methods API doesn't return prices — for prices, use the Quote API or place a draft order. Prices vary by:

- Destination.
- Item weight + dimensions.
- Currency.
- Account-level shipping discounts (negotiated rates with Gelato+).

There's no "give me a price for this method" endpoint independent of an actual cart.

## Original sources

- `references/sources/gelato-admin-node/src/services/shipment/shipment-api.ts` — endpoint path + verb.
- `references/sources/gelato-admin-node/src/services/shipment/shipment.ts` — `ShipmentMethod` + `ShipmentMethodType` types.
- Official (gated): https://dashboard.gelato.com/docs/shipment/methods/.
