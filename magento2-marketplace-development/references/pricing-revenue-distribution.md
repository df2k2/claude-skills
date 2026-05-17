# Pricing, Revenue Share, Distribution, Subscriptions

Marketplace is a paid storefront with a fixed 85/15 revenue split, a minimum-price floor, a PayPal-only payout, and a complex billing model for subscription extensions. This reference covers pricing constraints, the 85/15 share, subscription mechanics, support tiers, installation services, app commission, and the buyer-facing distribution flow.

## The 85/15 revenue share

The fundamental commercial term:

- **85%** of every Marketplace sale goes to the seller (the "provider").
- **15%** goes to Adobe.
- This applies to every paid extension, theme, language pack, shared package (when sold), and subscription.
- It also applies to converted indirect leads (e.g., a free extension that bundles a paid subscription, or a free trial that converts to a paid subscription).
- All product/service bundles fall under the same 85/15 rule.

Adobe pays 85% **minus any amounts required to be withheld by the U.S. IRS** (handled via your W-8 / W-9 on file). Payment is via **PayPal**, monthly.

If the seller is in a country where the IRS requires withholding, Adobe withholds and remits — the 85% you receive will be after that withholding.

## Apps: temporary commission waiver

App Builder apps have a separate commission model:

- **Apps submitted in 2023**: 2-year commission waiver from listing date — seller keeps 100% of revenue for 2 years.
- **Apps submitted after 2023**: Adobe has reserved the right to charge commission; the model has been communicated to developers separately and is in the Developer Portal terms.

This waiver applies only to App Builder apps, not extensions/themes.

## Pricing floor and ceiling

| Pricing model | Min | Max |
| --- | --- | --- |
| One-time, flat-fee | **$25** | **$999,999** |
| Subscription | **$10/period** | $999,999/period |
| Free | $0 | $0 |

All prices are in **USD**. There is no multi-currency pricing.

The minimum is enforced — Marketplace will not accept a $5 listing. Adobe's stated reason is to enforce price fidelity (cheap-looking extensions diminish storefront perception); the practical effect is a $25 floor on every paid item.

Adobe's published price recommendations:

- $99 for Magento Open Source extensions.
- $199 for Adobe Commerce extensions.

These are recommendations, not requirements. Many extensions price much higher.

## Pricing-by-version

The Marketplace pricing UI lets you set a different price for each Adobe Commerce version the extension supports:

```
| Pricing       | 2.4.5 | 2.4.6 | 2.4.7 | 2.4.8 | 2.4.9 |
| Open Source   |  $99  |  $99  |  $99  | $109  | $109  |
| Commerce      | $199  | $199  | $199  | $219  | $219  |
| Cloud         | $249  | $249  | $249  | $269  | $269  |
```

Common patterns:

- Same price across the board.
- Higher price for Adobe Commerce vs. Open Source.
- Higher price for newer versions if you put significant new features only in the latest.

Adobe Commerce (EE) pricing only appears as a row if you have partner status / EE submission rights.

## Subscription mechanics

Sellable as subscription if pricing model is **Subscription** at listing-entry time. Subscription pricing supports:

- **Monthly** billing.
- **Annual** billing.
- A first-time setup fee (treated as a separate one-time charge alongside the recurring subscription).

The buyer's experience:

- They install the extension via Composer using their marketplace access keys.
- Their subscription auto-renews each period.
- If they don't pay, the extension stops downloading from `repo.magento.com` (existing installs continue to run; they just can't redownload).

The seller's experience:

- Monthly payout includes that month's subscription revenue.
- Refunds and cancellations subtract from payout (no clawback rules beyond what Adobe applies in the Master Terms).

Subscriptions are not supported for App Builder apps — apps are one-time only.

## Third-party / external service fees

If your extension is a connector to an external service that has its own subscription pricing — e.g., Klarna, Stripe, Mailchimp — the listing entry's "Does this enable integration with a non-Adobe service?" answer is **Yes**, and:

- The third-party fee schedule must be disclosed in the listing's long description, in **bold** in the opening paragraph.
- The seller may also charge for the connector itself (or give it away). Independent of the third-party fee.
- Subscription pricing for your own connector applies on top of (or separately from) the third-party service fee.

Marketing review rejects listings that bury third-party fees deeper in the description. Bold + opening paragraph or it doesn't pass.

## Installation services

Optional add-on service:

- On the Marketing Submission → Pricing screen, check **Yes, I want to sell installation services** and enter the price.
- This is sold as a one-time add-on alongside the extension purchase.
- Same 85/15 split applies.

For complex extensions that need merchant-side configuration, this is a real revenue stream. Many sellers offer free installation as a way to upsell support tiers.

## Support tiers

Optional add-on service:

- On Marketing Submission → Support, check **Yes, I want to sell support**.
- Define up to **3 support tiers**, each with:
   - Number of months in contract.
   - Price for the tier.
- Same 85/15 split.

Typical tier structure:

| Tier | Length | Price |
| --- | --- | --- |
| Basic | 3 months | $99 |
| Standard | 6 months | $179 |
| Premium | 12 months | $299 |

The buyer purchases the support tier at extension checkout. Tier expirations and renewals are tracked by Marketplace.

## Free extensions

Free extensions are explicitly supported. The pricing model is still chosen (one-time at $0), but no revenue flows. Free extensions still:

- Require W-8/W-9 (so Adobe can verify identity, though no payment is made).
- Require a PayPal email (this is enforced by the developer-account setup).
- Require valid tax forms before publication.

Free + subscription model is also allowed — a free extension that paywalls features behind a subscription is the "freemium" pattern.

## Distribution: how a buyer installs

The full flow from purchase to install:

1. **Buyer browses** `commercemarketplace.adobe.com`, adds extensions to cart, checks out.
2. **Payment** — Adobe processes the credit card.
3. **License granted** — Adobe marks the buyer's Mage ID as licensed for the purchased SKU.
4. **Buyer generates their own Marketplace access keys** in their Marketplace profile.
5. **Buyer adds keys to `~/.composer/auth.json`**:
   ```json
   {
     "http-basic": {
       "repo.magento.com": {
         "username": "<buyer-public-key>",
         "password": "<buyer-private-key>"
       }
     }
   }
   ```
6. **Buyer adds the repository to `composer.json`** (typically already there if they installed Magento via Composer):
   ```json
   {
     "repositories": [
       { "type": "composer", "url": "https://repo.magento.com" }
     ]
   }
   ```
7. **Buyer runs** `composer require yourvendor/your-package:^1.2.0`. The Composer client authenticates against `repo.magento.com`, checks the license, downloads the package.
8. **Buyer runs** `bin/magento setup:upgrade` + `setup:di:compile` + `cache:flush`.

The seller's involvement ends at "license granted" — `repo.magento.com` handles the actual delivery. Sellers never see the buyer's email or contact info from this flow; if support is needed, it's via the support tier or out-of-band.

## Marketplace access keys vs. EQP API access keys (recap)

Two different "access keys" concepts, both managed in Profile Information. Don't confuse:

| Type | Format | Endpoint | Purpose |
| --- | --- | --- | --- |
| **Marketplace access keys** (Composer install) | 32-char public + 32-char private | `repo.magento.com` | Authenticate Composer downloads. Buyers use these. Sellers also use them to install their own extensions on test environments. |
| **EQP API access keys** (Developer Portal API) | application ID (~10 chars) + application secret (40 chars) | `commercedeveloper-api.adobe.com` | Authenticate API calls to the EQP REST API. Only sellers use these. |

A buyer never has a reason to generate EQP API access keys. A seller may have both.

## Payment timing and reports

- Payouts happen **monthly**, typically in the first half of the following month.
- The Developer Portal **Reports → Sales** view shows your transactions per period.
- The **Reports → Analytics** view aggregates non-revenue metrics (page views, conversion, EQP review timing).
- Sandbox has no associated storefront and therefore Sales/Analytics return mostly empty data.

The Marketplace EQP REST API exposes reports at `/rest/v1/reports/metrics` and `/rest/v1/reports/metrics/:metric_name`. The schema is in flux (Adobe's docs note: "The Marketplace reports API specification is under refinement").

## Refunds

- Adobe processes refunds per the Master Terms. The seller's payout reflects refunds (i.e., they are deducted from the next monthly payout).
- Sellers don't directly process refunds — they're handled by Adobe support.
- A refunded purchase typically means the buyer loses access to the extension on `repo.magento.com`.

## Subscription cancellation

- Buyers can cancel at any time from their Marketplace account.
- Cancellation stops the next auto-renewal. The current period remains active.
- A cancelled subscription is recorded; the seller sees the cancellation in Sales reports.

## Pricing-only updates bypass marketing review

A common operational ease: if you only want to change the **price**, **installation price**, or **support tier price** (and nothing else in the marketing submission), the update bypasses marketing review:

1. Go to listing → Marketing Submission → Update.
2. Modify price fields.
3. Submit.
4. The new prices push to the storefront within minutes — no review queue.

If you also modify the long description, icon, screenshots, or any other field, the update goes back into the marketing review queue.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/revenue-share.md`
- `references/sources/commerce-marketplace/guides/sellers/submit-for-marketing-review.md` (pricing section)
- `references/sources/commerce-marketplace/guides/sellers/marketing-review-guidelines.md` (pricing rules)
- `references/sources/commerce-marketplace/guides/sellers/content.md` (third-party fees in description)
- `references/sources/commerce-marketplace/guides/sellers/subscriptions/buying-subscriptions.md`
- `references/sources/commerce-marketplace/guides/sellers/subscriptions/selling-subscriptions.md`
- `references/sources/commerce-marketplace/guides/sellers/subscriptions/extension-subscriptions.md`
- `references/sources/commerce-marketplace/guides/sellers/sales.md`
- `references/sources/commerce-marketplace/guides/sellers/analytics.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-update-information.md`
