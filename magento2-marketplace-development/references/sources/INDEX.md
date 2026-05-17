# Embedded Source Docs — Topic Index

This is the topic-to-file map for the official source documentation embedded in this skill. There are two trees:

- `commerce-marketplace/` — clone of `AdobeDocs/commerce-marketplace`, the official seller and EQP API guide.
- `magento-coding-standard/` — extract of `magento/magento-coding-standard`: rulesets, README, composer.json, and a flat index of every shipped sniff.

Use Grep against these trees when the curated reference in `references/*.md` isn't enough detail. Each curated reference's "Original sources" footer points at the relevant files here.

## commerce-marketplace tree

### Seller workflow (top of the docs)
- `commerce-marketplace/guides/sellers/index.md` — landing
- `commerce-marketplace/guides/sellers/seller-overview.md` — the 4-step overview (account → build → submit → manage)
- `commerce-marketplace/guides/sellers/before-you-begin.md` — pre-submission checklist
- `commerce-marketplace/guides/sellers/business-value.md` — Marketplace business value pitch
- `commerce-marketplace/guides/sellers/assurance.md` — assurance / overall quality
- `commerce-marketplace/guides/sellers/faq.md` — FAQ

### Account / profile / onboarding
- `commerce-marketplace/guides/sellers/account-setup.md` — onboarding landing
- `commerce-marketplace/guides/sellers/account-setup-process.md` — step-by-step
- `commerce-marketplace/guides/sellers/developer-register.md` — registering as a developer
- `commerce-marketplace/guides/sellers/developer-portal.md` — top-level portal navigation
- `commerce-marketplace/guides/sellers/profile-information.md` — full profile reference (PayPal, Marketplace access keys, EU trader, tax forms, partner status)

### EQP program
- `commerce-marketplace/guides/sellers/extension-quality-program.md` — what EQP is
- `commerce-marketplace/guides/sellers/extension-create.md` — creating a listing
- `commerce-marketplace/guides/sellers/extension-version.md` — specifying a version
- `commerce-marketplace/guides/sellers/extension-information.md` — listing entry information / fields
- `commerce-marketplace/guides/sellers/extension-update-information.md` — update vs. patch vs. backporting
- `commerce-marketplace/guides/sellers/extension-resubmit.md` — resubmitting after a failed review
- `commerce-marketplace/guides/sellers/submit-for-review.md` — overall review process

### Submission types
- `commerce-marketplace/guides/sellers/extensions.md` — extension flow
- `commerce-marketplace/guides/sellers/themes.md` — theme flow
- `commerce-marketplace/guides/sellers/shared-packages.md` — shared package flow

### Technical review (the pipeline)
- `commerce-marketplace/guides/sellers/submit-for-technical-review.md` — the technical submission UI flow
- `commerce-marketplace/guides/sellers/technical-review-guidelines.md` — the canonical rule list (composer.json, packaging, what runs)
- `commerce-marketplace/guides/sellers/technical-reference.md` — pointers to Adobe's PHP / Frontend / WebAPI dev guides
- `commerce-marketplace/guides/sellers/malware-scan.md` — first check
- `commerce-marketplace/guides/sellers/code-sniffer.md` — magento-coding-standard usage + severity table
- `commerce-marketplace/guides/sellers/copy-paste-detector.md` — plagiarism check
- `commerce-marketplace/guides/sellers/installation-and-varnish-tests.md` — install + Varnish FPC tests
- `commerce-marketplace/guides/sellers/mftf-magento.md` — Adobe's MFTF suite against your extension
- `commerce-marketplace/guides/sellers/mftf-vendor.md` — your own MFTF tests in `Test/Mftf/`
- `commerce-marketplace/guides/sellers/extension-footprint.md` — beta footprint analyzer
- `commerce-marketplace/guides/sellers/semantic-version-check.md` — magento-semver-driven PATCH fast-track

### Marketing review
- `commerce-marketplace/guides/sellers/submit-for-marketing-review.md` — marketing-submission UI flow
- `commerce-marketplace/guides/sellers/marketing-review-guidelines.md` — full content rules
- `commerce-marketplace/guides/sellers/marketing-submission-preview.md` — preview flow
- `commerce-marketplace/guides/sellers/branding.md` — Magento name and logo rules
- `commerce-marketplace/guides/sellers/content.md` — content / description rules
- `commerce-marketplace/guides/sellers/product-descriptions.md` — example descriptions
- `commerce-marketplace/guides/sellers/image-tips.md` — image guidelines
- `commerce-marketplace/guides/sellers/video-tips.md` — video guidelines
- `commerce-marketplace/guides/sellers/review-report.md` — reading the review report

### Pricing, sales, analytics, subscriptions
- `commerce-marketplace/guides/sellers/revenue-share.md` — 85/15 split + app commission waiver
- `commerce-marketplace/guides/sellers/sales.md` — sales reports
- `commerce-marketplace/guides/sellers/analytics.md` — analytics reports
- `commerce-marketplace/guides/sellers/subscriptions/buying-subscriptions.md` — buyer-side subscription
- `commerce-marketplace/guides/sellers/subscriptions/selling-subscriptions.md` — seller-side subscription
- `commerce-marketplace/guides/sellers/subscriptions/extension-subscriptions.md` — extension subscription model

### Compatibility / lifecycle
- `commerce-marketplace/guides/sellers/compatibility/requirements.md` — overview of compatibility policies + App resources
- `commerce-marketplace/guides/sellers/compatibility/releases.md` — release-line compat (30/60-day windows)
- `commerce-marketplace/guides/sellers/compatibility/abandoned-extensions.md` — 11/12-month rule
- `commerce-marketplace/guides/sellers/compatibility/obsolete-extensions.md` — EOL-line rule

### EQP REST API v1
- `commerce-marketplace/guides/eqp/v1/index.md` — API landing + eligibility
- `commerce-marketplace/guides/eqp/v1/getting-started.md` — auth bootstrap
- `commerce-marketplace/guides/eqp/v1/auth.md` — session-token flow
- `commerce-marketplace/guides/eqp/v1/access-keys.md` — generating EQP API access keys
- `commerce-marketplace/guides/eqp/v1/rest-api.md` — REST conventions + batch
- `commerce-marketplace/guides/eqp/v1/sandbox.md` — sandbox vs. production
- `commerce-marketplace/guides/eqp/v1/users.md` — `/rest/v1/users/{mage_id}` + access-keys + reports
- `commerce-marketplace/guides/eqp/v1/files.md` — `/rest/v1/files/uploads`
- `commerce-marketplace/guides/eqp/v1/packages.md` — `/rest/v1/products/packages` (the big one)
- `commerce-marketplace/guides/eqp/v1/test-results.md` — `/rest/v1/products/packages/{id}/status`
- `commerce-marketplace/guides/eqp/v1/callbacks.md` — webhook callbacks
- `commerce-marketplace/guides/eqp/v1/reports.md` — `/rest/v1/reports/metrics`
- `commerce-marketplace/guides/eqp/v1/filtering.md` — pagination, sort, filter
- `commerce-marketplace/guides/eqp/v1/handling-errors.md` — error response shapes
- `commerce-marketplace/guides/eqp/v1/help.md` — Slack / email contacts

### Top-level
- `commerce-marketplace/config.md` — site config
- `commerce-marketplace/index.md` — top-level landing

## magento-coding-standard tree

- `magento-coding-standard/README.md` — install + usage instructions
- `magento-coding-standard/LICENSE.txt` — OSL-3.0 license
- `magento-coding-standard/composer.json` — package shape
- `magento-coding-standard/Magento2-ruleset.xml` — **the canonical Magento2 ruleset** with per-rule severities and exclude-patterns
- `magento-coding-standard/Magento2Framework-ruleset.xml` — the stricter ruleset used for Magento core development
- `magento-coding-standard/Sniffs/INDEX.md` — flat list of every sniff class shipped by the standard (auto-generated by `scripts/magento2-marketplace/fetch_docs.sh`)

## Search patterns

Common Grep targets when you need to find something fast:

```bash
# Find anything about the 30-day window for patch incompatibility
grep -rn "30 days\|patch release\|30-day" references/sources/commerce-marketplace/

# Find every endpoint definition in the EQP API
grep -rn -E "^(POST|PUT|GET|DELETE) /rest/v1" references/sources/commerce-marketplace/guides/eqp/

# Find what severity a specific sniff has
grep -B1 -A3 "Magento2.Security.XssTemplate" references/sources/magento-coding-standard/Magento2-ruleset.xml

# Find all forbidden composer dependencies
grep -A3 "magento-composer-installer\|magento2-base\|product-community-edition" references/sources/commerce-marketplace/guides/sellers/technical-review-guidelines.md
```

## Refresh

`scripts/magento2-marketplace/fetch_docs.sh` re-clones both source repos and re-populates this tree. Run it when Adobe ships new versions of these repos.
