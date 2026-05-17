# Marketplace Developer Portal

The Marketplace Developer Portal (`commercedeveloper.adobe.com` for production, `commercedeveloper-sandbox.adobe.com` for sandbox) is the seller-facing web UI for every Marketplace operation other than installation. This reference is a map of the portal — what each menu does, how to navigate to common tasks, and which UI states map to which EQP pipeline states.

## Top-level navigation

After logging in, the portal header has these menus:

| Menu | Destination | Used for |
| --- | --- | --- |
| **Apps** | Adobe Developer Distribution page (App Builder, Admin UI SDK extensions, App-based listings) | Listing apps, not extensions |
| **Extensions** | Your Extensions page | The dashboard for every M2 module / metapackage you've ever submitted |
| **Themes** | Your Themes page | Same, for `magento2-theme` packages |
| **Shared Packages** | Your Shared Packages page | Same, for shared dependency packages |
| **Reports** | Sub-menu: Sales / Analytics | Revenue reports and aggregated analytics |
| **Resources** | Policies + doc links | Marketplace policies (compatibility, abandonment, obsolete, branding) |
| **Support** | mailto:commercemarketplacesupport@adobe.com | The Marketplace support channel |
| **Community** | Adobe Developer Magento Open Source page | Slack invite, community engineering |
| **Profile Information** | Account Information / Sign Out | Profile, access keys, API keys, taxes, EU trader info, partner status |

The Apps menu is different from the others — it bounces you to a separate Adobe Developer Distribution site (https://developer.adobe.com/distribute/home) where App Builder app submissions are managed.

## The listing dashboard

The Extensions / Themes / Shared Packages tabs all share the same layout:

- A table of every listing you've created.
- Columns: name, number of versions, latest version, latest version status, last changed, optional status indicators.
- Per-row controls to view, edit, or submit a new version.
- A **Create New Extension/Theme/Shared Package** button.

Status values that show up in the table:

| Status | Meaning |
| --- | --- |
| **Draft** | Listing created but never submitted. |
| **In Technical Review** | The submission is in the automated technical pipeline. |
| **Failed Technical Review** | At least one technical check rejected; report available. |
| **In Marketing Review** | The submission's marketing content is queued for human review. |
| **Failed Marketing Review** | Marketing review rejected the content; report available. |
| **In Manual QA** | Manual QA reviewer is testing the extension. |
| **Approved** | Both reviews passed. |
| **Ready for Release** | Approved and queued for launch (e.g., on a requested-launch-date). |
| **Published** | Live on the storefront. |
| **De-listed** | Removed from the storefront due to compatibility/abandonment/obsolescence policies. |
| **Cancelled** | Withdrawn from review (manually or by Adobe). |

## Per-listing detail page

Clicking a listing opens its detail page with two parallel submission sections:

```
Listing: My Awesome Connector
├── Basic Information          (Title, version, supported M2, type)
├── Technical Submission
│   ├── Code Package           (upload zip)
│   ├── Magento Version Compatibility
│   ├── License Type
│   ├── Documentation
│   ├── Shared Packages used
│   └── Release Notes
├── Marketing Submission
│   ├── Description (Title + Long Description)
│   ├── Images and Videos
│   ├── Compatibility (browser checkboxes)
│   ├── Pricing
│   ├── Support tiers
│   ├── Additional Details (checkboxes for setup scripts, service contracts, etc.)
│   └── Documentation and Resources
└── Test Reports               (one per check that ran on each submitted version)
```

Each subsection has a progress checkmark. The **Submit** button only enables when all subsections of a given side (technical or marketing) have their checkmarks.

## Reports

Two reports views:

- **Sales** — per-listing revenue, payouts, refunds, period filters.
- **Analytics** — aggregated page-view metrics for your listings on the storefront, category-specific clicks, EQP turnaround metrics.

Both are read-only and reflect data Adobe collects from the storefront. Sandbox typically shows empty Sales/Analytics because there is no associated storefront.

## Test Reports section

Each submission run produces a series of test reports. They appear under the listing's detail page on the Test Reports sub-section. Per check:

| Report | Format | Notable fields |
| --- | --- | --- |
| **Malware Scan** | pass/fail, plus a list of suspicious files (when fail) | One of: `passed`, `failed`, `awaiting_processing`. |
| **Package Verification** | pass/fail, plus error code + message | E.g., "Invalid composer.json: type must be one of magento2-module, magento2-theme, magento2-language, metapackage". |
| **Code Sniffer** | error counts by severity, plus a downloadable JSON report | The downloadable JSON is what `phpcs --report=json` produces. |
| **Copy/Paste Detector** | match locations against core / other listings | Plagiarized? Properly attributed (OSL-3.0)? |
| **Installation + Varnish** | per-PHP-version, per-M2-version pass/fail | Plus a log of the failing step (compile, deploy:static, mode:set production, reindex, page hit). |
| **MFTF Magento-supplied** | per-PHP-version pass/fail | Allure-style XML report. |
| **MFTF Vendor-supplied** | same | Same. Doesn't block. |
| **Extension Footprint** | counts of REST / SOAP / GraphQL / programmatic interfaces exposed | Informational. Cannot fail. |
| **Semantic Version Check** | PASS / FAIL with detail of MINOR/MAJOR-level changes detected | Only runs when seller declared PATCH. |
| **Manual QA** | reviewer's narrative + checklist | The most detailed report. |

Each report has a downloadable artifact. For Code Sniffer the artifact is the full PHPCS JSON; sellers should re-run `phpcs` locally with the same JSON output and diff to confirm a fix.

## Resources menu (policies)

The Resources menu links to Marketplace policy documents that aren't otherwise published as guides:

- Compatibility policy (overview of release-line / abandonment / obsoletion).
- Branding policy.
- Submission queue and review timing.
- Slack invite for community engineering.
- Documentation links.

## Profile Information

The Profile Information page from the top-right username menu houses all account-level state:

- Contact Info (addresses, PayPal, Adobe ID/IMS).
- EU Trader Information.
- Marketplace Profile (screen name, vendor name, partner status, social links, privacy policy URL).
- Tax Forms (W-8 / W-9 download + email).
- Partner Portal link (deep-link to Adobe partner page).
- **Marketplace Access Keys** — Composer-install credentials (different from EQP API keys).
- **Manage API Keys** — EQP REST API application ID + secret pairs.

Reads of these settings via the EQP REST API are at `GET /rest/v1/users/{MAG_ID}`. Most fields are also writable via `PUT /rest/v1/users/{MAG_ID}`.

## UI vs. EQP API: parity table

The Developer Portal UI and the EQP REST API expose most of the same surface. Quick reference for "where do I do X":

| Task | UI path | API endpoint |
| --- | --- | --- |
| Update profile | Profile Information | `PUT /rest/v1/users/{MAG_ID}` |
| Upload code zip | Listing detail → Technical Submission → Attach Package | `POST /rest/v1/files` (with file content) → reference in package |
| Upload icon / gallery images | Marketing Submission → Images and Videos | `POST /rest/v1/files` |
| Upload documentation PDF | Technical Submission → Documentation | `POST /rest/v1/files` |
| Create a new listing entry | Click Create New Extension | `POST /rest/v1/products/packages` |
| Submit for review | Click Submit | `PUT /rest/v1/products/packages/{submission_id}` with status change |
| List your packages | Extensions tab | `GET /rest/v1/products/packages` |
| Filter by submission_id | navigate to listing | `GET /rest/v1/products/packages?submission_id=...` |
| Read test results | Test Reports section | `GET /rest/v1/products/packages/{submission_id}/test-results` |
| Register a callback URL | (UI not available) | `PUT /rest/v1/users/{MAG_ID}` with `api_callbacks` array |
| Generate EQP API keys | Profile → Manage API Keys | (UI only) |
| Generate Marketplace access keys | Profile → Marketplace Access Keys | (UI only) |

The two operations that are UI-only are key generation (both EQP API and Marketplace access keys) — by design, those secrets must be revealed in a human-controlled context.

## Notifications

Three notification channels for state changes:

1. **Email**. Default; cannot be disabled. Fired on submission received, malware scan complete, code sniffer complete, marketing review accepted/rejected, manual QA accepted/rejected, published, delisted, abandoned warning, obsolete warning.
2. **In-portal status** on the listing detail page. Always reflects current state.
3. **API callbacks**. Registered per user profile via `api_callbacks` array on `PUT /rest/v1/users/{MAG_ID}`. POSTed with the events `malware_scan_complete` and `eqp_status_update`. Auth is Basic. See `references/eqp-rest-api.md`.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/developer-portal.md`
- `references/sources/commerce-marketplace/guides/sellers/extensions.md`
- `references/sources/commerce-marketplace/guides/sellers/themes.md`
- `references/sources/commerce-marketplace/guides/sellers/shared-packages.md`
- `references/sources/commerce-marketplace/guides/sellers/review-report.md`
- `references/sources/commerce-marketplace/guides/sellers/analytics.md`
- `references/sources/commerce-marketplace/guides/sellers/sales.md`
