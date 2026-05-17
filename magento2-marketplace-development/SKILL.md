---
name: magento2-marketplace-development
description: "Build, package, submit, and maintain Adobe Commerce Marketplace listings — Magento 2 extensions, themes, language packs, shared packages, and App Builder apps — through the full Extension Quality Program (EQP) pipeline. Use this skill whenever the user is preparing an extension for Marketplace submission, debugging a failed technical/marketing review, packaging a `magento2-module` / `magento2-theme` / `magento2-language` / `metapackage`, writing/fixing `composer.json` for Marketplace requirements, running the Magento Coding Standard (`magento/magento-coding-standard`) and severity-10 PHPCS sniffs, writing MFTF tests for vendor-supplied checks, working through semantic version checks (`magento/magento-semver`), installation/Varnish tests, malware scans, copy-paste detection, extension footprint analysis, listing branding/title/icon/description rules, pricing & 85/15 revenue share, subscription pricing, OSL-3.0 / AFL-3.0 / Apache-2.0 / MIT licensing choices, compatibility/release-line rules (latest 2.x.y patch within 30 days, minor within 60), abandonment & obsolete listing policies, seller / developer-portal onboarding (Mage ID, Adobe ID, IMS, partner tiers, PayPal payout, W-8/W-9, EU DSA trader info, DUNS), or the Marketplace EQP REST API (`commercedeveloper-api.adobe.com`, sandbox `commercedeveloper-sandbox-api.adobe.com`, session tokens, packages/files/users/callbacks endpoints). Trigger on mentions of Adobe Commerce Marketplace, Magento Marketplace, Marketplace EQP, Extension Quality Program, MEQP, technical review, marketing review, commercedeveloper.adobe.com, Marketplace Developer Portal, `commercedeveloper-sandbox.adobe.com`, EQP API, EQP callback, malware scan rejection, code sniffer report, semantic version check failure, MFTF vendor tests, magento-semver, magento-coding-standard, Magento2 ruleset, shared package, magento2-module, magento2-theme, metapackage, `registration.php`, repo.magento.com, public/private access keys for installs, `etc/module.xml` packaging, `auto_increment`, OSL-3.0, marketplace icon, marketplace screenshots, listing description, listing rejected, listing delisted, abandoned listing, obsolete listing, 85/15 revenue share, Adobe Partner tier (Platinum/Gold/Silver/Bronze), Adobe IMS organization. NOTE: this skill is about MARKETPLACE submission and EQP, not general Magento 2 module development — for plugins, observers, layout XML, GraphQL resolvers, db_schema, EAV, admin UI, etc., use the `magento2-development` skill (this skill assumes the extension already builds and runs; it covers getting it accepted on the storefront)."
---

# Adobe Commerce Marketplace — Extension Quality Program (EQP)

This skill covers the Adobe Commerce Marketplace — formerly Magento Marketplace — and its Extension Quality Program (EQP). It is about getting a Magento 2 / Adobe Commerce extension (or theme, language pack, shared package, or App Builder app) **accepted and published** on the Marketplace, not about building the extension itself. For the latter (modules, plugins, observers, layout XML, GraphQL resolvers, db_schema, etc.), use the **`magento2-development`** skill instead.

The skill ships with two layers of documentation:

1. **Curated references** in `references/*.md` — synthesized, opinionated guides for the patterns and gotchas you'll hit most. Read these first.
2. **Embedded source docs** in `references/sources/` — the full official AdobeDocs `commerce-marketplace` doc set plus the `magento/magento-coding-standard` rulesets and sniff inventory. Grep these when the curated reference isn't enough.

Each curated reference ends with an "Original sources" pointer to the embedded files. The source tree is small enough (~80 markdown files) to browse, but search with Grep first.

## Scope and versions

This skill targets the **modern (2026)** Marketplace EQP pipeline that operates against Adobe Commerce / Magento Open Source 2.4.5+ — the lines that are currently supported and accepted as new submissions:

- **Adobe Commerce / Magento Open Source**: 2.4.5 through 2.4.9 (the active and recent EOL lines that EQP still tests). 2.4.4 and earlier (including all 2.3.x) are **out of scope** — Marketplace no longer accepts submissions targeting only those versions, and extensions whose entire compatibility window has aged out are de-listed under the [obsolete listings](references/compatibility-requirements.md) policy.
- **PHP**: 8.1, 8.2, 8.3, 8.4 (8.4 from 2.4.8+). PHP 7.4 is gone; Marketplace will reject `composer.json` files whose `require.php` excludes the PHP versions of the Magento line being claimed for compatibility.
- **Composer**: 2.7+.
- **Marketplace EQP API**: v1 (`/rest/v1/...`).
- **Magento Coding Standard**: latest `magento/magento-coding-standard` from the `develop` branch, run as `phpcs --standard=Magento2 --error-severity=10`. The legacy `magento/marketplace-eqp` (MEQP/MEQP1) ruleset is **Magento 1.x only** and is not used for M2 submissions — do not confuse the two.

If the user asks about Magento 1.x marketplace submission, MEQP1, or pre-2.4.5 compatibility, stop and confirm scope before continuing — those flows are deprecated and largely unsupported.

## When to consult this skill vs. just answer

Trigger on any of these signals, even if Marketplace isn't named:

- Submitting a third-party extension or theme to Adobe Commerce / Magento Marketplace.
- A failed Technical Review / Marketing Review report, or a "delisted" / "abandoned" / "obsolete" email from Marketplace.
- Severity-10 PHPCS errors from `magento/magento-coding-standard` (XSS, raw SQL, `eval`, superglobals, `Mage::`, `goto`, etc.).
- `composer.json` packaging questions for `magento2-module`, `magento2-theme`, `magento2-language`, or `metapackage` types.
- Semantic version mismatch reports from `magento/magento-semver`.
- MFTF Vendor-supplied test placement (`Test/Mftf` vs. `Tests/Mftf`).
- Anything mentioning `commercedeveloper.adobe.com`, `commercedeveloper-sandbox.adobe.com`, the Marketplace Developer Portal, Mage ID, EQP access keys (application ID + secret), or the EQP REST API.
- Branding rules: when to write "Magento®", "for Adobe Commerce", or "Magento Open Source" in a listing title.
- Pricing, 85/15 revenue share, subscription pricing, support tiers, installation services.

If the work is general Magento 2 module / theme development (not submission-related), defer to the `magento2-development` skill. This skill assumes the code already works on a developer's local instance.

## How the EQP pipeline fits together (mental model)

A Marketplace submission goes through **two parallel reviews** — Technical and Marketing — both of which must pass before the listing is published. Submission flows from a Developer Portal listing entry into a sequence of automated and manual checks:

```
Developer Portal listing entry  (extension-information.md)
        │
        ├─►  Technical Submission ──► Upload code zip ──► Malware Scan
        │                                                       │
        │                                                       ▼
        │                                            Package Verification
        │                                                       │
        │      ┌────────────────────────────────────────────────┤
        │      ▼                                                │
        │  Code Sniffer (magento-coding-standard, severity ≥ 10)│
        │      │                                                │
        │      ▼                                                │
        │  Copy/Paste Detector                                  │
        │      │                                                │
        │      ▼                                                │
        │  Installation + Varnish tests (per PHP / per M2 line) │
        │      │                                                │
        │      ▼                                                │
        │  MFTF Magento-supplied tests   (mandatory pass)       │
        │      │                                                │
        │      ▼                                                │
        │  MFTF Vendor-supplied tests    (observed, not blocking yet)
        │      │                                                │
        │      ▼                                                │
        │  Extension Footprint analysis  (informational)        │
        │      │                                                │
        │      ▼                                                │
        │  Semantic Version Check        (only on PATCH claim — fast-tracks Manual QA)
        │      │                                                │
        │      ▼                                                │
        │  Manual QA                     (skipped on confirmed PATCH only)
        │      │                                                │
        │      ▼                                          ◄─────┘
        │   TECHNICAL  ✔
        │
        └─►  Marketing Submission ──► Title / Long Description / Icon / Screenshots
                                            │
                                            ▼
                                     Manual Marketing Review
                                            │
                                            ▼
                                       MARKETING  ✔
                                            │
                                            ▼
                                 PUBLISHED on commercemarketplace.adobe.com
                                 + downloadable from repo.magento.com via the
                                   buyer's marketplace access keys
```

A submission is **only** published once both reviews pass. A failed check anywhere in the chain returns the submission to "Failed" state with a report; the seller corrects and resubmits. The same package re-runs the full pipeline; there is no partial resubmit.

A few non-obvious behaviors that come up a lot:

- **Patch submissions can skip Manual QA.** If the seller marks an update as PATCH and `magento/magento-semver` confirms only patch-level changes, Manual QA is bypassed (still must pass all automated checks). If SVC disagrees with the PATCH claim it produces a soft failure — the submission does **not** fail, it just enters Manual QA like a non-patch update.
- **Compatibility erosion is automatic.** Every patch release of Magento (e.g., 2.4.9 → 2.4.9-p1) re-runs the installation + code-sniffer pipeline against every published listing. Listings that fail get a 30-day grace; new minors give 60 days. The listing is de-listed on expiry — the seller has no chance to manually re-validate first.
- **Sandbox is partner-only.** The `commercedeveloper-sandbox.adobe.com` portal and its EQP API are gated to Adobe Partner tiers (Bronze Solution and above, or any Technology Partner). Free / unaffiliated sellers cannot use the sandbox and must submit directly to production. They can still get access keys for the production API.
- **A listing has two "access key" concepts and they are completely separate.** The Marketplace **buyer's** access keys (the 32-char public + private repo.magento.com tokens that anyone needs to `composer require magento/product-community-edition` or to install any purchased extension) are different from the **seller's EQP API** access keys (application ID + application secret used to obtain session tokens against the EQP REST API). Don't confuse them.

## Confirm before assuming

Before doing anything else, confirm these things if they aren't obvious:

1. **Listing type.** Extension (`magento2-module`), theme (`magento2-theme`), language pack (`magento2-language`), shared package (a `magento2-module/theme/language` that other extensions depend on), metapackage (`metapackage`), or App Builder app (no Composer — Node `package.json` + `install.yaml` in a zip). The composer.json requirements differ sharply for each. See `references/extension-packaging.md`.
2. **Open Source vs. Adobe Commerce.** Default sellers can only submit Open Source (CE) extensions. Adobe Commerce (EE) submissions require partner status or a developer-license request. The supported version list shown on the submission form reflects this.
3. **Seller account status.** Mage ID exists? Adobe ID and IMS org linked? PayPal email on file? W-8/W-9 submitted? EU DSA trader info filled in (required since 17 Feb 2025 for EU visibility)? Without these the listing cannot publish.
4. **Has the seller already submitted this listing before?** If the listing slot already exists, the flow is "Submit a New Version", not "Create New Extension". Version field rules and what triggers a marketing re-review change accordingly. See `references/resubmission-and-updates.md`.
5. **Is this a fresh review or a fix for a failed report?** If the latter, the right entry point is `references/common-rejections.md` plus the specific check that failed (code-sniffer.md, semantic-version-check.md, malware-scan.md, etc.) in `references/sources/commerce-marketplace/guides/sellers/`.
6. **Production or sandbox EQP API?** The two environments have separate access keys, separate session tokens, separate Mage IDs effectively (you re-build your profile in sandbox), and the base URL differs (`commercedeveloper-api.adobe.com` vs. `commercedeveloper-sandbox-api.adobe.com`).

## How to find what you need

The curated references below cover the patterns deeply. Read the one(s) that match the task before writing code or a recommendation — they have the current rules, current URLs, current severity thresholds, and the named pitfalls.

| Task | Reference |
| --- | --- |
| What the Extension Quality Program is, the full submission lifecycle, what's automated vs. manual | `references/eqp-overview.md` |
| Setting up the developer account (Mage ID, Adobe ID, IMS, PayPal, taxes, EU trader info, partner status) | `references/seller-onboarding.md` |
| Navigating the Marketplace Developer Portal — listings dashboard, reports, sales, support, profile | `references/developer-portal.md` |
| Composer packaging — `composer.json` shape, package types, registration.php, autoload, forbidden deps | `references/extension-packaging.md` |
| Running `phpcs --standard=Magento2 --error-severity=10`, understanding severities, severity-10 sniffs, fixing common violations | `references/coding-standard-meqp.md` |
| Technical review pipeline — every check that runs, what triggers it, and what makes it fail | `references/technical-review.md` |
| Marketing review — title / icon / long description / branding rules, what gets a listing rejected | `references/marketing-review.md` |
| Filling out the listing entry — categories, browser compat, license type, support tiers, additional details checkboxes | `references/extension-information.md` |
| Versioning, `magento/magento-semver`, PATCH vs. MINOR vs. MAJOR, backporting, dependency version constraints | `references/version-and-semver.md` |
| Release-line compatibility rules — 30/60-day windows, abandoned listings, obsolete listings, what re-runs automatically | `references/compatibility-requirements.md` |
| MFTF Vendor-supplied tests, MFTF Magento-supplied tests, Installation + Varnish tests, Extension Footprint | `references/testing-mftf-and-installation.md` |
| Pricing, 85/15 revenue share, subscriptions, installation services, support tiers, app commission waiver | `references/pricing-revenue-distribution.md` |
| Marketplace EQP REST API — base URLs, auth, session tokens, users / files / packages / callbacks, sandbox vs prod | `references/eqp-rest-api.md` |
| Resubmission flow, Update vs. Patch vs. Backporting, what triggers marketing re-review | `references/resubmission-and-updates.md` |
| The reasons listings get rejected — the rejection-pattern catalog with fixes | `references/common-rejections.md` |

`references/sources/INDEX.md` maps topics to the embedded source files.

The four trees in `references/sources/`:

- `commerce-marketplace/` — `AdobeDocs/commerce-marketplace`, the official seller and EQP API guide. ~70 markdown files. This is the authoritative current spec.
- `magento-coding-standard/` — `magento/magento-coding-standard` rulesets (`Magento2-ruleset.xml`, `Magento2Framework-ruleset.xml`), the project `README.md`, and `Sniffs/INDEX.md` — a flat list of every sniff class that ships with the standard.

## Critical things to know up-front

These come up over and over. Internalize them.

### 1. Marketplace and EQP are not the same thing

- **Commerce Marketplace** (`commercemarketplace.adobe.com`) is the storefront where merchants browse and buy extensions.
- **Extension Quality Program (EQP)** is the *review process* that gates what lands on the Marketplace. It runs at the **Marketplace Developer Portal** (`commercedeveloper.adobe.com`) and via the EQP REST API.
- Sellers always work in the Developer Portal, not the storefront. The storefront is what their customers see.

### 2. The MEQP rulesets are not for Magento 2

The historical name "Magento Extension Quality Program coding standard" is `magento/marketplace-eqp` on GitHub. Its MEQP1 ruleset is **Magento 1.x only**. For Magento 2, the EQP code sniffer uses `magento/magento-coding-standard` and the `Magento2` ruleset. Every time someone says "I'm running MEQP locally" for an M2 extension, they actually mean `phpcs --standard=Magento2 ...`. Confirm before debugging — running the wrong ruleset will produce noise that nobody on the EQP side cares about.

### 3. Only severity-10 errors block publication

`magento/magento-coding-standard` classifies violations by severity:

| Type | Severity | Blocking? | Meaning |
| --- | --- | --- | --- |
| Error | 10 | YES | Critical bug or security vulnerability |
| Warning | 9 | no | Possible security issue |
| Warning | 8 | no | Magento-specific design issues |
| Warning | 7 | no | General code issues |
| Warning | 6 | no | Code style |
| Warning | 5 | no | PHPDoc formatting |

The EQP code sniffer runs with `--error-severity=10`, so only severity-10 violations cause a Marketplace rejection. Sellers who want a clean local result run `phpcs --standard=Magento2 --severity=10`. Strict teams may want `--severity=8` or `--severity=6` for stylistic cleanliness, but EQP only enforces 10.

### 4. Composer requirements are strict and unforgiving

A package will fail Package Verification (and the entire technical review halts) if any of these are true:

- The submission isn't a zip ≤ 30 MB containing a `composer.json` at the root.
- `composer.json` declares `extra.map` or `extra.magento-root-dir` (these are M1-era keys; pure rejection).
- `type` isn't one of: `magento2-module`, `magento2-theme`, `magento2-language`, or `metapackage`.
- The package requires `magento/magento-composer-installer`, `magento/magento2-base`, `magento/product-community-edition`, `magento/magento2-ee-base`, or `magento/product-enterprise-edition` (these are forbidden as direct deps).
- Any `magento/*` constraint uses `*` as the version. Constraints must follow Adobe's published versioning rules (e.g., `~104.0.0` for `magento/module-catalog` ≥ 2.4.7).
- The package uses Composer "require inline aliases" (`foo/bar 1.0 as 1.0.0`).
- A `magento2-module` is missing a valid `etc/module.xml` or `registration.php`, or `composer.json` doesn't include `registration.php` in `autoload.files` and at least one PSR-4 namespace in `autoload.psr-4`.
- A `magento2-theme` has a `autoload.psr-4` (themes must not — they only use `autoload.files`). Same for `magento2-language`.
- A `metapackage` declares zero entries in `require`.

There is no "just barely failed" — Package Verification is a hard gate.

### 5. Patch submissions are the cheat code for fast turnaround

Marking a submission as PATCH and having `magento/magento-semver compare` agree skips Manual QA entirely. This drops a normal 1-2 week review to days. Use PATCH for true bug fixes only — adding a class method, changing a public signature, or adding a config field is **not** a patch and the SVC will catch it. A failed PATCH claim doesn't fail the submission, it just demotes the flow to full Manual QA.

### 6. The Magento name is a trademark; lots of branding mistakes are auto-rejected

The marketing-review heuristics around the Magento name catch most sellers on first submission:

- ❌ "Magento Extension for X" → product title cannot contain "Magento" or "M2".
- ❌ "We are a Magento development agency." → must be "We specialize in Magento."
- ❌ Title contains "Extension", "Module", "Plugin", "App" (but `Connector`, `Integration` are OK).
- ❌ Title > 5 words, or has version number, or has developer name (unless developer == integrated service brand).
- ❌ Listing icon or screenshots include the Adobe or Magento logo.
- ❌ First mention of "Magento" anywhere in the long description without "®" (use `&reg;`).

The whole list lives in `references/marketing-review.md`. Run through it before submitting marketing.

### 7. Compatibility is a moving target

Once published, the listing is automatically re-tested every time a new Magento patch (`2.4.x-pN`) or minor (`2.5.0`) drops. The seller doesn't get to opt out:

- **Patch release**: 30-day window to submit a new version that passes EQP on the new patch, or the listing is de-listed.
- **Minor release**: 60-day window.
- **Annual abandonment check**: if no update in 12 months, the listing is de-listed.
- **Obsolete check**: a listing whose entire compatibility window is on EOL Magento lines gets a 30-day window to add support for a current line.

"De-listed" means removed from search and category pages on the storefront — the product page is still reachable by direct link and `repo.magento.com` still serves it to existing customers, but no new merchant will discover it.

### 8. The EQP REST API is independent of Magento's Web APIs

The Marketplace EQP API at `commercedeveloper-api.adobe.com` has nothing to do with Magento's REST / SOAP / GraphQL stack — same protocol family, completely separate auth (application ID + secret → session token), no shared identity with the merchant store. Anything in `Magento\Webapi\*` is a different world. If a seller is confused about whether to use a Magento integration token vs. an EQP application ID + secret, the answer depends entirely on which side of the storefront/portal divide they're on.

### 9. Apps are not extensions

App Builder apps are submitted differently: zip with `install.yaml` + Node `package.json` (no Composer), no malware scan in the same way, no MFTF tests, no Manual QA in the storefront sense, and they enjoy a commission-waiver window. They share the EQP submission *plumbing* (technical/marketing reviews, Developer Portal, callbacks API) but almost no actual checks. Most of this skill assumes extensions/themes/shared packages, and flags the App differences where they apply.

## Workflow for a typical "fix the EQP report and resubmit" task

1. **Identify which check failed.** The Developer Portal lists the result of every check; the email notification usually points at the right report. The reports break down by check name — Code Sniffer, Copy/Paste, Installation/Varnish, MFTF Magento, MFTF Vendor, Semantic Version, Footprint.
2. **Open the matching reference**. E.g., a Code Sniffer failure → `references/coding-standard-meqp.md`; a `composer.json` validation error → `references/extension-packaging.md`; a "supported Commerce versions excluded" failure → `references/compatibility-requirements.md`.
3. **Reproduce locally first.** Every EQP check has a local-reproducible command. Sellers should never push a fix without re-running the check locally:
    - Code sniffer: `phpcs --standard=Magento2 --extensions=php,phtml --error-severity=10 --ignore-annotations --report=json --report-file=report.json <path>`.
    - Semver: `php vendor/bin/svc compare <old-version-dir> <new-version-dir> 1` (uses `magento/magento-semver`).
    - Installation+Varnish: run on Magento Cloud Docker against each claimed PHP version.
    - MFTF vendor: run from a Magento 2.4.x install with the extension installed, against `Test/Mftf/...` tests.
4. **Fix the root cause, not the surface symptom.** Don't add a suppress annotation to silence a severity-10 sniff; that sniff is severity-10 because it represents a real bug class. (`--ignore-annotations` on the EQP side disables suppressions anyway.)
5. **Bump the version**. Any resubmission must change the version. If it's a true bug-fix and you want fast-tracked QA, increment the patch digit and declare PATCH on submission.
6. **Run a local clean-room install.** `composer create-project --repository=https://repo.magento.com magento/project-community-edition` in a fresh dir, install your package, switch to production mode. If that fails locally, EQP will fail too.
7. **Re-upload via the Developer Portal** (or `PUT /rest/v1/products/packages/<submission_id>` via the EQP API). The full pipeline re-runs.

## Workflow for a fresh first-time submission

1. **Account ready?** `references/seller-onboarding.md` — Mage ID, Adobe ID, IMS, PayPal, partner status, tax forms, EU trader info.
2. **Package ready?** `references/extension-packaging.md` — composer.json shape, required files, version number, dependencies, type.
3. **Code clean?** Run `phpcs --standard=Magento2 --severity=10` locally and fix everything. `references/coding-standard-meqp.md`.
4. **Plagiarism / OSL?** `references/common-rejections.md` — if you copied from Magento core, you must license under OSL-3.0 and attribute Adobe.
5. **MFTF tests?** Optional but encouraged. `references/testing-mftf-and-installation.md`.
6. **Local install check.** Composer + `setup:upgrade` + `deploy:mode:set production` must succeed.
7. **Create the Developer Portal listing.** Pick the listing type, fill in basic info (`references/extension-information.md`).
8. **Submit a new version.** Specify version, supported Magento versions, license type, documentation PDF, release notes.
9. **Submit for technical review.** Upload the zip. The pipeline starts immediately.
10. **Submit for marketing review.** In parallel. `references/marketing-review.md` for content rules.
11. **Watch the email + Developer Portal status** for failures, fix the report, resubmit, repeat until both reviews pass.
12. **Released.** The listing appears on `commercemarketplace.adobe.com` and can be installed via `composer require <vendor>/<name>` against `repo.magento.com` after the merchant authenticates with their own marketplace access keys.

## A note on App Builder

App Builder apps share the EQP infrastructure (Developer Portal, callbacks, submission pipeline) but their packaging rules and tests differ:

- **Package**: zip containing `install.yaml` + `package.json` (Node, not Composer). No `composer.json`.
- **No PHP code sniffer.** No MFTF. No Installation/Varnish tests (limited install automation only).
- **Manual technical review** rather than fully automated.
- **Commission**: Apps submitted in 2023 have a 2-year commission waiver from listing date. Apps submitted in later years are subject to a commission TBD by Adobe at the time.
- **Resources** for App Builder are linked from `references/sources/commerce-marketplace/guides/sellers/compatibility/requirements.md`.

Most of this skill is extension-oriented; when an App differs significantly, the relevant reference calls it out.

## Source repos and where to refresh them

The `scripts/magento2-marketplace/fetch_docs.sh` script re-clones the source repos. Run it when the official docs have moved:

- `AdobeDocs/commerce-marketplace` — main current spec, MIT-style license per repo's terms.
- `magento/magento-coding-standard` — coding-standard rulesets and sniffs, OSL-3.0.

The legacy `magento/marketplace-eqp` (M1-only) is intentionally **not** included — including it would cause more confusion than clarity for M2 work. If a user asks about MEQP1 specifically, point them at https://github.com/magento/marketplace-eqp directly.
