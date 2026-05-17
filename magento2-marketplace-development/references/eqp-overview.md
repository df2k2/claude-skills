# Extension Quality Program (EQP) Overview

The Extension Quality Program is the technical-and-marketing review pipeline that gates every Adobe Commerce Marketplace listing. It is operated by Adobe Commerce out of the Marketplace Developer Portal (`commercedeveloper.adobe.com`) and the matching sandbox portal. This document is the orientation reference — what the program is, what every check does, how the lifecycle flows, and how the pieces relate.

## What EQP is for

Adobe's stated reasons for running EQP:

1. **Block bad code from the storefront.** Static analysis (code sniffer), plagiarism detection (copy/paste), security checks (malware scan), and installation tests find broken or unsafe packages before merchants can buy them.
2. **Standardize what "good" looks like.** Adobe Commerce projects pull code from dozens of vendors — a consistent coding standard makes that code mutually readable.
3. **Curate the storefront.** Marketing review keeps listing titles, icons, and descriptions on-brand and professional.
4. **Keep listings current.** Continuous compatibility checks on every new Magento patch / minor make sure published listings still work with the latest Adobe Commerce.

EQP is **mandatory**. There is no fast lane or "skip the review" option. The closest thing is the Semantic Version Check fast-track for confirmed-PATCH submissions, which skips Manual QA but still runs every other check.

## Roles, environments, and identities

Several different identities and URLs are in play. Sellers regularly confuse them.

| Role / Identity | Where it lives | What it's for |
| --- | --- | --- |
| **Adobe ID** | `account.adobe.com` | Sign-on to all Adobe products (single sign-on). |
| **Adobe IMS organization** | `business.adobe.com` (partner side) | Groups Adobe IDs into a company; required for partner badges. |
| **Mage ID** | Marketplace Developer Portal | Marketplace-specific user ID. Looks like `MAG123456789`. Used in EQP API URLs. |
| **Developer Portal (production)** | https://commercedeveloper.adobe.com | The seller-facing tool. All submissions originate here. |
| **Developer Portal (sandbox)** | https://commercedeveloper-sandbox.adobe.com | Partner-only practice environment. |
| **Commerce Marketplace (storefront)** | https://commercemarketplace.adobe.com | What buyers see. Listings appear here after publication. |
| **`repo.magento.com`** | Composer repository | Where buyers `composer require` published extensions (auth via marketplace access keys, not EQP keys). |
| **EQP REST API (production)** | https://commercedeveloper-api.adobe.com | Programmatic equivalent of the Developer Portal. |
| **EQP REST API (sandbox)** | https://commercedeveloper-sandbox-api.adobe.com | Partner-only practice API. |

The single most confused pair is **Marketplace buyer access keys** vs. **EQP application ID + secret**. The first is what `repo.magento.com` accepts as `auth.json` credentials to download any extension a merchant has purchased. The second is what `commercedeveloper-api.adobe.com /rest/v1/app/session/token` accepts to mint a session bearer for the EQP API. Different format (32-char public/private pair vs. application ID like `AQ17NZ49WC` + 40-char secret), different endpoint, different purpose. Both are managed in the Developer Portal under Profile → "Marketplace Access Keys" and "Manage API Keys" respectively.

## What can be submitted

| Listing type | Composer `type` | Notes |
| --- | --- | --- |
| Extension (module) | `magento2-module` | The typical case. Must have `etc/module.xml`, `registration.php`. |
| Theme | `magento2-theme` | Must have `theme.xml`, `registration.php`. **Not** PSR-4 autoload. |
| Language pack | `magento2-language` | Must have `language.xml`, `registration.php`. Not PSR-4 autoload. |
| Metapackage | `metapackage` | Bundles other Composer packages. Must declare ≥ 1 dep. |
| Shared package | `magento2-module` / `magento2-theme` / `magento2-language` | A package whose only purpose is to be a dependency of one of *your other* listings. Not standalone in the storefront. |
| App Builder app | n/a (Node) | Zip of `install.yaml` + `package.json`. Submitted alongside extensions in the Developer Portal under the **Apps** tab. |

Each listing type is reviewed slightly differently (themes and language packs skip a couple of the code-sniffer rule subsets that only apply to PHP; shared packages skip Marketing Review because they aren't standalone storefront items; apps skip MFTF and the M2 install tests entirely).

## The submission lifecycle

```
                      ┌─────────────────────────────────────┐
                      │   Create Extension/Theme/etc. entry │  (one-time per listing)
                      └─────────────────┬───────────────────┘
                                        │
                                        ▼
                      ┌─────────────────────────────────────┐
                      │   Submit New Version                │  (every release)
                      │   - Version number                  │
                      │   - Compatibility (M2 minor list)   │
                      │   - License type                    │
                      │   - Documentation PDF               │
                      │   - Release notes                   │
                      └─────────────────┬───────────────────┘
                                        │
                  ┌─────────────────────┴────────────────────┐
                  ▼                                          ▼
        ┌────────────────────┐                  ┌────────────────────────┐
        │ Technical          │                  │ Marketing              │
        │ Submission         │                  │ Submission             │
        │ - Upload code zip  │                  │ - Title                │
        │                    │                  │ - Long description     │
        │                    │                  │ - Icon                 │
        │                    │                  │ - Gallery images       │
        │                    │                  │ - Category             │
        │                    │                  │ - Pricing              │
        │                    │                  │ - Support tiers        │
        └─────────┬──────────┘                  └────────────┬───────────┘
                  │                                          │
                  ▼                                          ▼
        ┌────────────────────────┐              ┌────────────────────────┐
        │ Automated pipeline     │              │ Manual marketing       │
        │ (see below)            │              │ review                 │
        └─────────┬──────────────┘              └────────────┬───────────┘
                  │                                          │
                  ▼                                          ▼
        ┌────────────────────────┐              ┌────────────────────────┐
        │ Manual QA              │              │ Marketing PASS or FAIL │
        │ (skipped on PATCH)     │              └────────────┬───────────┘
        └─────────┬──────────────┘                           │
                  │                                          │
                  ▼                                          │
        ┌────────────────────────┐                           │
        │ Technical PASS or FAIL │                           │
        └─────────┬──────────────┘                           │
                  └──────────────────┬───────────────────────┘
                                     ▼
                          ┌────────────────────┐
                          │ Both PASS → publish │
                          └────────────────────┘
```

Either review can fail independently; both must pass before the listing publishes. The seller can iterate on each side separately.

## The full automated check inventory

In approximately the order they run, every check in the technical pipeline:

| # | Check | Required? | What it does | Local equivalent |
| --- | --- | --- | --- | --- |
| 1 | **Malware Scan** | YES | Scan the zip for viruses, malware, malicious binaries, malicious links in docs/media. Fails ⇒ rejection, no further checks run. | Run any reputable AV on the zip. |
| 2 | **Package Verification** | YES | Validate zip structure, size (≤ 30 MB), composer.json contents, required files (module.xml/theme.xml/language.xml + registration.php), allowed types, forbidden deps, forbidden version constraints, FIXME/TODO comments. | Manual inspection + `composer validate`. |
| 3 | **Code Sniffer** | YES | `phpcs --standard=Magento2 --extensions=php,phtml --error-severity=10 --ignore-annotations` on the entire submission. | `phpcs --standard=Magento2 --severity=10 ...`. |
| 4 | **Copy/Paste Detector** | YES | Static detector that compares against Magento core and against existing Marketplace listings. Plagiarized code rejects unless properly OSL-3.0 attributed. | Public CPD tools approximate but Adobe's corpus is private. |
| 5 | **Installation + Varnish tests** | YES (not for apps) | Install on a clean M2 (each claimed PHP and M2 version), switch to production mode, reindex, hit cacheable pages through Varnish. | Magento Cloud Docker. |
| 6 | **MFTF Magento-supplied tests** | YES | Run Adobe's standard MFTF suite with the extension installed. | `vendor/bin/mftf run:group default`. |
| 7 | **MFTF Vendor-supplied tests** | NO (observed) | Run any MFTF tests the seller shipped in `Test/Mftf/`. Failures don't block publication today but are logged. | `vendor/bin/mftf run:test ...`. |
| 8 | **Extension Footprint Analysis** | INFO | Static analysis of which Magento APIs the extension exposes (number of REST/SOAP/GraphQL/programmatic interfaces). Beta. Cannot fail. | n/a. |
| 9 | **Semantic Version Check** | conditional | If the seller declared PATCH, runs `magento/magento-semver compare` against the previously-published version. Disagrees ⇒ submission demoted to full Manual QA (not failed). | `php vendor/bin/svc compare old/ new/ 1`. |
| 10 | **Manual QA** | YES (skipped on confirmed PATCH) | Human installs the extension, follows the user guide, exercises a checklist of merchant flows (place order as guest, create invoice, etc.). | n/a. |

Marketing review is entirely manual — there is no "automated marketing review" except in the sense that the sandbox is described as automated-only. Marketing reviewers read the title, long description, icon, screenshots, and documentation, and apply the rules in `references/marketing-review.md`.

## Sandbox vs. production

The sandbox exists so that **partner-tier sellers** can run integration tests against the EQP infrastructure without affecting their production listings. Key differences:

- **Eligibility**: Adobe Solution Partner (Bronze/Silver/Gold/Platinum) or Adobe Technology Partner (Silver/Gold/Platinum). Free sellers can't get sandbox keys.
- **No human reviews.** Only automated tools run in sandbox.
- **Copy/Paste Detector is disabled** in sandbox.
- **No Marketplace storefront.** Reports endpoints return mostly empty data because there's no associated commerce storefront.
- **Separate everything**: separate access keys, separate session tokens, separate profile (you must rebuild it on first sandbox login), separate listing IDs.
- **Logging out of one logs out of the other** in the same browser session.

Use the sandbox for CI/CD: scripted package validation, rehearsing the EQP API call sequence, regression-testing the build artifact before pushing to production.

## What the seller cannot control

- **Review queue position.** Submissions enter a FIFO queue. Pre-paid SLAs do not exist on Marketplace.
- **Manual QA reviewer assignment.** No way to request a specific reviewer.
- **Reporting cadence.** Email notifications fire on state transitions; you cannot make the queue go faster by polling.
- **The compatibility re-check schedule.** Adobe's monthly checks for abandoned/obsolete listings and per-patch re-tests run on Adobe's schedule.

## What the seller can control programmatically

The EQP REST API at `commercedeveloper-api.adobe.com` exposes:

- **Profile management** (`/rest/v1/users/{MAG_ID}`).
- **File uploads** (`/rest/v1/files`) — for code zips, documentation PDFs, gallery images, icons.
- **Package management** (`/rest/v1/products/packages`) — create, update, submit-for-review, list, filter.
- **Test results** (`/rest/v1/products/packages/{submission_id}/test-results`).
- **Reports** (sales, analytics — stubbed in sandbox).
- **Callbacks** — register a URL on the profile and receive POSTs when malware scans or EQP statuses change.

The API gives the same operations as the Developer Portal UI, modulo a few partner-only features. Full details in `references/eqp-rest-api.md`.

## How EQP communicates with the seller

Notifications arrive in three places:

1. **Email** — every state transition (received, malware-scanned, code-sniffer-failed, manual-QA-passed, published, etc.). The notification email is the system of record for the submission timeline.
2. **Developer Portal** — submission state, downloadable test reports, the marketing-submission preview, sales data.
3. **API callbacks** — POST to a registered URL on state changes (`malware_scan_complete`, `eqp_status_update`). Useful for CI/CD pipelines.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/extension-quality-program.md`
- `references/sources/commerce-marketplace/guides/sellers/seller-overview.md`
- `references/sources/commerce-marketplace/guides/sellers/before-you-begin.md`
- `references/sources/commerce-marketplace/guides/sellers/submit-for-review.md`
- `references/sources/commerce-marketplace/guides/sellers/technical-review-guidelines.md`
- `references/sources/commerce-marketplace/guides/sellers/marketing-review-guidelines.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/index.md`
- `references/sources/commerce-marketplace/guides/eqp/v1/sandbox.md`
