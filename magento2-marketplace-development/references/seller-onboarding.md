# Seller Onboarding

Before any code can be submitted, the seller's account must be set up: Adobe ID linked, Mage ID issued, profile completed, tax forms uploaded, EU trader info filled in (if relevant), PayPal email recorded for payouts, and — for Adobe Commerce (EE) submissions — a partner status or developer license. This reference walks through every prerequisite in the order they're typically encountered.

## Identity chain: Adobe ID → IMS organization → Mage ID

Three distinct identities show up across the Marketplace ecosystem; they connect like this:

- **Adobe ID** — your sign-on for any Adobe product, created at `account.adobe.com`. Email + password. Single sign-on across the Adobe surface.
- **Adobe IMS organization** — Adobe's identity-management abstraction for "a company". A given Adobe ID can be a member of zero, one, or many IMS orgs. Required for Adobe Partner badges, for shared resources, and for using one of your orgs as the scope of an access key.
- **Mage ID** — the Marketplace-specific user ID, of the form `MAG123456789`. Created when you complete developer registration. Used in EQP API URLs (`/rest/v1/users/MAG123456789`).

A typical individual seller has: one Adobe ID, no IMS orgs (or possibly a personal one), one Mage ID. A typical agency / vendor has: one Adobe ID per employee, all rolled up into a single IMS organization that owns the partner badge, and one Mage ID for the company.

Marketplace access keys created at the IMS-org level are shared between all members of that org. Access keys created at the Mage ID level ("Myself") are individual.

## Step 1: Create or link a Marketplace developer account

Two paths to a developer account:

- **No Adobe Commerce account yet** — go to https://commercedeveloper.adobe.com, click **Create Account** → **Register**. Fill in personal info (name, email, country), company info (focus area, role), password (8–16 chars, ≥ 1 uppercase, ≥ 1 number, ≥ 1 special or lowercase), accept the Terms of Service.
- **Existing Adobe Commerce account** — sign in. In the top-right corner click **My Account** → look for the **Marketplace** menu → **Developer Portal**. Complete the developer registration there.

Either way, you must accept:
- Commerce Marketplace Master Terms (https://commercemarketplace.adobe.com/legal/terms/master-terms)
- Commerce Marketplace Development Terms (https://commercemarketplace.adobe.com/legal/terms/development-terms)

After ToS, choose **Individual** or **Business** account type. All listings from a single company should be under one Business account.

> All new developer accounts default to Open Source (CE) submissions only. To submit Adobe Commerce (EE) extensions you need either Adobe Partner status or a developer-license request to Marketplace support — the same email address must be used for the Developer Portal account and for the partner status.

## Step 2: Complete the personal profile

The personal profile is what shows up as "Author" on every listing you publish. Fields:

| Field | Required? | Notes |
| --- | --- | --- |
| Personal URL | optional | Your personal website (skip if you'll only use the company profile). |
| Personal Bio | optional | Same. |
| Personal Addresses | 1 minimum | At least one; up to three. Designate one primary if more than one. |
| Login Credentials | implicit | Click "Go to My Account" to manage password/email. |
| **PayPal Email** | YES | Even for sellers offering only free extensions. This is the payout account. |

The PayPal email is non-negotiable. Adobe pays the 85% revenue share into this PayPal account every month for paid extensions. If left blank, the account cannot pass review for paid listings.

## Step 3: Complete the company profile

The company profile is shown on every listing as the "By Company" attribution. Fields:

| Field | Required? | Notes |
| --- | --- | --- |
| Company Name | YES | Appears on each listing as a clickable link to your company page. |
| Primary Contact | YES | Lead contact name. |
| Support Email | YES | Public-facing support address. |
| Company URL | YES | Public website. |
| Company Bio | YES | ≤ 1500 chars. Don't list specific products or promote other listings — marketing review will flag it. |
| Company Addresses | 1 minimum | Up to three; one primary. |
| PayPal Email | YES | Can match personal PayPal or be company-owned. |

The company bio commonly trips marketing review when it lists specific products, includes phrases like "We are a Magento agency" (use "specializing in Magento" — see `references/marketing-review.md`), or claims affiliation with Adobe / Magento that isn't substantiated by a partner badge.

## Step 4: EU DSA trader information (required since 17 Feb 2025)

If your listings are to be visible to merchants in the European Union, the EU Digital Services Act requires you to supply trader information that is then published on each listing's detail page when viewed from an EU IP:

| Field | Required? | Notes |
| --- | --- | --- |
| Business Name | YES | Your legal business name. |
| Business Email | YES | Public business email. |
| Business Address | YES | Legal business address. |
| DUNS Number | optional | Free-tier D-U-N-S available at https://www.dnb.com/en-us/smb/duns/get-a-duns.html. |

Without trader info, listings will not appear to EU customers. Submitting it after the fact restores EU visibility — no need to re-submit existing listings.

## Step 5: Tax forms

Adobe is the payment processor of record for Marketplace sales, so it must collect W-8 (non-US) or W-9 (US) tax forms before any payout can be made.

- **US sellers**: W-9 (request via Profile → Tax Forms → Email Tax Forms).
- **Non-US sellers**: W-8BEN (individual) or W-8BEN-E (business).
- The form is emailed back to Marketplace support; the seller's account is then marked as tax-compliant. Payouts queue otherwise.

## Step 6: Partner status (only for Adobe Commerce / EE extensions and Sandbox)

Two partner programs apply:

- **Adobe Solution Partner** — Bronze, Silver, Gold, Platinum. For agencies / sellers / consultancies. https://business.adobe.com/support/adobe-partners.html
- **Adobe Technology Partner** — Silver, Gold, Platinum. For software vendors building integrations.

Required for:

- Submitting **Adobe Commerce (EE)** listings (otherwise restricted to Open Source).
- Using the **Sandbox** Developer Portal and EQP API.
- Getting a **partner badge** that can appear on company / personal documentation.

Without partner status:

- You can still submit Magento Open Source extensions, themes, language packs, shared packages, and App Builder apps.
- You will not see the EE versions in the supported-versions dropdown when creating a listing.
- You cannot use the sandbox.

Upgrading partner status is a separate process handled by Adobe's partner organization, not the Marketplace team — apply via Profile → "Upgrade Partner Status" which redirects to `business.adobe.com/support/adobe-partners.html`.

## Step 7: Marketplace access keys (for installs)

Don't confuse this section with EQP API access keys — these are entirely separate. Marketplace access keys are the 32-char public + 32-char private pair that `repo.magento.com` uses for Composer authentication. Each merchant who installs your extension uses *their own* set of keys, not yours. As a seller, you'd use them too if you wanted to install your own extension on a test environment.

Generation steps:

1. Profile → Marketplace Access Keys (or Manage Keys depending on UI).
2. Pick a scope: **Myself** (associated with your Mage ID) or an IMS organization (shared across that org's members).
3. Click **Create New Access Key**, give it a name (≤ 32 chars), submit.
4. Copy the public + private key pair. Treat the private one like a password.
5. Paste into the project's `~/.composer/auth.json` (or `auth.json` in the project root):
   ```json
   {
     "http-basic": {
       "repo.magento.com": {
         "username": "<public-key>",
         "password": "<private-key>"
       }
     }
   }
   ```

The keys can be disabled, re-enabled, or deleted from the same screen. Keys are not the same as the [Magento encryption key](https://experienceleague.adobe.com/en/docs/commerce-admin/systems/security/encryption-key) stored in `app/etc/env.php`.

## Step 8: EQP API access keys (for the EQP REST API)

Only relevant if the seller plans to script submissions or get callbacks.

1. Profile → **Manage API Keys**.
2. Enter an API key name (≤ 32 chars). Submit.
3. Adobe issues an **application ID** (e.g., `AQ17NZ49WC`) and an **application secret** (e.g., `8820c99614d65f923df7660276f20e029d73e2ca`).
4. Limit: 3 active EQP API access keys per Developer Portal environment.
5. Sandbox keys are separate from production — generate one of each if scripting against both.

The keys can be regenerated or deleted from the same screen. Regenerating invalidates the previous app-ID/secret pair but **does not** invalidate session tokens already issued — they remain valid until their natural expiry. The seller cannot regenerate from the API, only from the UI. See `references/eqp-rest-api.md`.

## Status check: are we ready to submit?

By the time you can submit a listing, this checklist must be true:

- [ ] Adobe ID exists and is linked to Marketplace.
- [ ] Personal profile complete (address + PayPal).
- [ ] Company profile complete (name, URL, address, support email, bio without forbidden phrases).
- [ ] EU trader info if EU visibility is desired.
- [ ] W-8/W-9 submitted (for paid listings; not strictly required for free).
- [ ] Partner status if submitting EE or using sandbox.
- [ ] At least one Marketplace access key (for installing your own extension on test instances).
- [ ] An EQP API access key (only if scripting; UI-only sellers can skip).

## Common onboarding rejections

| Symptom | Cause | Fix |
| --- | --- | --- |
| Cannot select "Adobe Commerce" in version dropdown | No partner badge | Upgrade partner status, or request a developer license from Marketplace support. |
| "Sandbox not eligible" splash on Profile → Manage API Keys | No partner badge | Same. |
| Marketing review rejects long description for "agency claims" | Company bio reads "We are a Magento development agency" | Rewrite as "We are a development agency specializing in Magento". |
| Payout queued indefinitely | W-8/W-9 not submitted | Email the form back to Marketplace support. |
| Listing not visible to EU buyers | DSA trader info missing | Fill in Business Name / Email / Address (and optionally DUNS). |
| `repo.magento.com` 401 when installing own extension | Marketplace access keys not in `auth.json` | Generate keys + add to `~/.composer/auth.json`. |
| EQP API returns 401 on first call | Session token not exchanged from app-ID/secret | See `references/eqp-rest-api.md` — call `/rest/v1/app/session/token` first. |

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/account-setup.md`
- `references/sources/commerce-marketplace/guides/sellers/account-setup-process.md`
- `references/sources/commerce-marketplace/guides/sellers/developer-register.md`
- `references/sources/commerce-marketplace/guides/sellers/profile-information.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/access-keys.md`
