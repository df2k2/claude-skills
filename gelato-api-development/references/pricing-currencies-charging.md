# Pricing, Currencies, and Charging

How Gelato charges you, which currencies are supported, how VAT is applied, what shows up in the receipt object, and how the wallet / credit card / invoice billing modes differ.

## Charging model in one paragraph

When you `POST /v4/orders` with `orderType: "order"`, Gelato attempts a charge **immediately** against your account's configured payment method (wallet, credit card, or invoice). On success, `financialStatus` becomes `paid` and `fulfillmentStatus` becomes `created` (then `passed` once validation completes). On failure, `financialStatus` becomes `refused` and the order doesn't enter production. Use `orderType: "draft"` to skip the charge entirely until you `PATCH` to convert.

## Supported currencies (ISO 4217)

40+ currencies, including all the majors:

```
EUR, USD, JPY, BGN, CZK, DKK, GBP, HUF, PLN, RON, SEK, CHF,
ISK, NOK, HRK, RUB, TRY, AUD, BRL, CAD, CNY, HKD, IDR, ILS,
INR, KRW, MXN, MYR, NZD, PHP, SGD, THB, ZAR, CLP, AED
```

The `currency` field on order create is **required**. It's the currency you want to be charged in (the merchant-facing currency). Gelato converts internally based on its FX rates at the moment of charge.

### Which currency to pick

| Customer segment | Recommendation |
| --- | --- |
| US merchants billing US customers | USD |
| EU merchants | EUR |
| UK merchants | GBP |
| Multi-currency storefront | Match the customer's checkout currency |
| Wallet-based billing | Pick the currency you fund the wallet in (avoids FX) |

## Payment methods

| Method | When to use | Behavior |
| --- | --- | --- |
| **Wallet** | High-volume sellers, prepaid balance | Funded by you in advance (any supported currency). Charge instantly debits balance. Cheapest method (no card-processing fees). |
| **Credit card** | Most direct-API sellers | Card on file. Charged at order creation. Standard card fees apply. |
| **Invoice** | High-volume B2B accounts (Gelato+/Enterprise) | Pay net-30 after a billing cycle. `financialStatus` goes `to_be_invoiced` → `invoiced`. Requires Gelato approval. |

Configure in https://dashboard.gelato.com/billing/. Switching methods generally requires a Gelato support ticket.

## Wallet specifics

- Top up with a credit card or bank transfer.
- Multiple sub-wallets per currency (e.g., one USD wallet, one EUR wallet) — orders in USD draw from USD wallet, etc.
- If balance is insufficient, the order is refused (`financialStatus: refused`).
- Monitor balance in dashboard or via account-level API (not part of the public Orders API).

## Multi-currency rules

| Rule | Applies to |
| --- | --- |
| Wallet customers: each currency you order in must have a matching wallet (or be auto-converted with fees). | wallet only |
| Credit card customers: you can request any supported currency; your card is charged in that currency (your card issuer may charge FX fees). | credit card |
| Invoice customers: typically locked to one billing currency by contract. | invoice |

## Pricing tiers

Product prices are **quantity-tiered**. From `GET /v3/products/{productUid}/prices`:

```json
[
  { "currency": "USD", "quantity": 1,   "price": 14.50 },
  { "currency": "USD", "quantity": 10,  "price": 11.00 },
  { "currency": "USD", "quantity": 50,  "price":  9.20 },
  { "currency": "USD", "quantity": 100, "price":  8.75 }
]
```

The price applies to the **total quantity in the order item**. So `quantity: 50` of the same UID costs `50 × $9.20 = $460`, not `50 × $14.50`.

## Receipts (what shows up after a charge)

Every paid order has a `receipts` array with one or more receipts (usually one per currency / charge transaction):

```json
{
  "id": "receipt-abc",
  "orderId": "g-order-id",
  "transactionType": "purchase",
  "currency": "USD",
  "items": [
    {
      "id": "receipt-item-1",
      "receiptId": "receipt-abc",
      "referenceId": "line-1",
      "type": "product",
      "title": "Crewneck T-Shirt White S",
      "currency": "USD",
      "priceBase": "14.50",
      "amount": "1",
      "priceInitial": 14.50,
      "discount": 0,
      "price": 14.50,
      "vat": 1.16,
      "priceInclVat": 15.66,
      "createdAt": "...",
      "updatedAt": "..."
    }
  ],
  "productsPriceInitial": 14.50,
  "productsPriceDiscount": 0,
  "productsPrice": 14.50,
  "productsPriceVat": 1.16,
  "productsPriceInclVat": 15.66,

  "packagingPriceInitial": 0.50,
  "packagingPriceDiscount": 0,
  "packagingPrice": 0.50,
  "packagingPriceVat": 0.04,
  "packagingPriceInclVat": 0.54,

  "shippingPriceInitial": 6.50,
  "shippingPriceDiscount": 0,
  "shippingPrice": 6.50,
  "shippingPriceVat": 0.52,
  "shippingPriceInclVat": 7.02,

  "discount": 0,
  "discountVat": 0,
  "discountInclVat": 0,

  "totalInitial": 21.50,
  "total": 21.50,
  "totalVat": 1.72,
  "totalInclVat": 23.22
}
```

### Fields by category

| Bucket | What it covers |
| --- | --- |
| `productsPrice*` | Sum of all line items. |
| `packagingPrice*` | Packaging cost (boxes, envelopes). |
| `shippingPrice*` | Shipping label cost. |
| `discount*` | Account-level / promo discounts applied. |
| `total*` | Grand total. |

For each bucket, four numbers:

| Suffix | Meaning |
| --- | --- |
| `Initial` | List price. |
| `Discount` | Discount applied. |
| (none) / `Price` | After-discount, before-VAT. |
| `Vat` | VAT amount. |
| `PriceInclVat` / `InclVat` | After VAT. |

So `totalInclVat` is what was actually charged.

## VAT (Value Added Tax)

- Gelato handles VAT calculation per destination country's rules.
- For B2C orders in the EU, VAT is included in the charge.
- For B2B orders (`isBusiness: true`) where you've provided a valid VAT number, reverse-charge rules may apply (no VAT on the invoice).
- For US orders, sales tax is handled at the production-state level by Gelato (it has nexus in multiple states).
- Brazil requires `federalTaxId` (CPF for individual, CNPJ for business) — VAT-equivalent is calculated by Gelato.

The receipt's `vat` field is the calculated tax. Your accounting system should mirror this.

## Discounts

Account-level discounts (Gelato+ tier, volume contracts, promo codes) apply automatically and show up in `discount*` fields. There is no per-order discount API — you can't apply a customer-facing discount through the API; that's a storefront concern.

For storefront integrations (Shopify, etc.), the customer's discount is a property of the storefront order, not the Gelato production order — Gelato just charges its own price; the customer's discount is your problem.

## Gelato+ subscription tiers

Gelato offers paid tiers (Gelato+, Gelato+ Gold) that unlock:

- **Discounted product prices** (up to 50% on apparel).
- **Discounted shipping**.
- **Negotiated wallet top-up rates**.
- **Priority production** (production-line priority).
- **Premium-only catalogs / products**.

Subscribing/unsubscribing is a dashboard operation. Your `priceBase` values are the list price; `price` reflects your tier's discount.

## Refunds

Refunds happen automatically when:

- An order is canceled before `passed`.
- Gelato support issues a refund (production defect, etc.).
- A partial refund applies for a partial defect.

`financialStatus` transitions to `refunded` or `partially_refunded`. The receipt shows the refunded amount in negative or a separate refund receipt.

## Payouts (for Marketplace, not relevant here)

Payouts are for selling-side platforms (Shopify, Etsy) where the storefront collects from the buyer and Gelato charges you, leaving you with margin. There's no Gelato-side payout to sellers — Gelato is the production partner, not a marketplace operator.

## Common pricing failures

| Symptom | Cause | Fix |
| --- | --- | --- |
| `financialStatus: refused` | Card declined / wallet empty / invoice limit reached | Top up wallet, update card, contact billing. |
| Cheaper than expected on order create | Hit a quantity-tier breakpoint | Re-check tier schedule via `/v3/products/.../prices`. |
| Way more expensive than expected | Forgot a quantity-tier (e.g., the order is 5 items so paid the qty-1 price each) | This is correct behavior — each line item is priced independently by its quantity. |
| Currency mismatch error | Account doesn't support the requested currency | Use a currency in your account's wallet/contract set. |
| VAT applied when reverse-charge expected | `isBusiness: false` or VAT number not on file | Set `isBusiness: true` and ensure account VAT number is configured in dashboard. |
| Discount not applied | Tier started after order; promo code not on this account | Check tier effective date; promos apply at the time of order creation. |

## Original sources

- `references/sources/gelato-admin-node/src/services/orders/order.ts` — `Currency`, `ReceiptObject`, `ReceiptItemObject` types.
- `references/sources/gelato-admin-node/src/services/products/prices.ts` — pricing object.
- Official (gated): https://dashboard.gelato.com/docs/get-started/ and `/billing/`.
