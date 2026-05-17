# Technical Review (Pipeline + Every Check)

The technical review is the automated half of the EQP pipeline. It runs every time a code package is uploaded — first submission, resubmission, every patch / minor / backport — and its exit state determines whether the submission proceeds to (or skips) Manual QA. This reference is the per-check field guide: what triggers each check, what makes it fail, what report shape to expect, and how to reproduce it locally.

## Pipeline order (and what halts what)

A submission moves through these checks roughly in order. A failure at certain steps halts further automated checks; at other steps the pipeline keeps running and reports everything.

```
1.  Malware Scan                  ── halts on fail
2.  Package Verification          ── halts on fail
3.  Code Sniffer                  ── continues on fail
4.  Copy/Paste Detector           ── continues on fail
5.  Installation + Varnish        ── continues on fail
6.  MFTF Magento-supplied tests   ── continues on fail
7.  MFTF Vendor-supplied tests    ── never blocks (observed)
8.  Extension Footprint           ── never blocks (informational)
9.  Semantic Version Check        ── only on PATCH claim; doesn't block, demotes flow
10. Manual QA                     ── skipped on confirmed PATCH; otherwise mandatory
```

Halt vs. continue matters because if Malware Scan fails on file #1, you'll see zero data from the code sniffer and a vague rejection email. If Code Sniffer fails on a security violation but Package Verification passed, you'll get all of Installation + Varnish + MFTF results plus the Code Sniffer error — that's normal, fix Code Sniffer first.

## Submission state machine

```
       ┌─ Draft ──────┐
       │              ▼
       │      Technical Submitted ──► Marketing Submitted
       │              │                      │
       │              ▼                      ▼
       │      In Technical Review     In Marketing Review
       │              │                      │
       │       ┌──────┴──────┐         ┌─────┴─────┐
       │       ▼             ▼         ▼           ▼
       │  Tech Failed    Tech Pass  Mkt Failed  Mkt Pass
       │       │             │         │           │
       │       ▼             │         ▼           │
       │   Resubmit          │     Resubmit       │
       │       └──────┐      │         └────┐     │
       │              │      │              │     │
       │              ▼      ▼              ▼     ▼
       │           (back into review queues)
       │
       └─► Approved ──► Ready for Release ──► Published ─┐
                                                         ├─► De-listed (compatibility / abandonment / obsolete)
                                                         └─► Cancelled
```

## 1. Malware Scan

**What it does**: Scans the entire submitted zip (code + media + PDFs) for viruses, malicious code, and links to known malicious URLs. Run before all other checks.

**Required**: Yes. Halts the rest of the pipeline if it fails.

**Failure modes**:
- Hidden binary in `Test/Fixtures/` that flags a heuristic.
- Bundled minified JS that includes a known malicious library version.
- PDF documentation that links to a flagged URL.
- macOS `.DS_Store`, `__MACOSX/` resource forks, etc. don't fail malware scan but waste size against the 30 MB limit.

**Reproduce locally**: Run any reputable AV against the zip. `clamscan -r your-package.zip` is a reasonable proxy.

**Fixing**: Remove the flagged artifact. If a false positive on a legitimate file, contact Marketplace support with the submission ID.

## 2. Package Verification

**What it does**: Validates the zip's structural rules: archive integrity, size, `composer.json` shape, required files, forbidden constraints.

**Required**: Yes. Halts the pipeline if it fails.

**Failure modes** (full list lives in `references/extension-packaging.md`):
- Not a zip / corrupt zip.
- > 30 MB.
- No `composer.json` at root.
- `composer.json` missing `name` / `type` / `version`.
- `type` not in `magento2-module` / `magento2-theme` / `magento2-language` / `metapackage`.
- `extra.map` or `extra.magento-root-dir` declared.
- Forbidden dep (`magento/magento-composer-installer`, etc.).
- `*` constraint on `magento/*`.
- Require-inline-alias syntax.
- Missing `etc/module.xml` + `registration.php` for modules.
- Missing `theme.xml` + `registration.php` for themes.
- Missing `language.xml` + `registration.php` for language packs.
- `magento2-theme` or `magento2-language` declaring `autoload.psr-4`.
- Empty `metapackage.require`.
- `FIXME` / `TODO` comments anywhere in source.

**Reproduce locally**: `composer validate --no-check-publish path/to/composer.json`, plus manual inspection. See `references/extension-packaging.md` for the full canonical templates.

**Fixing**: Match the canonical `composer.json` template for your package type exactly.

## 3. Code Sniffer

**What it does**: Runs `phpcs --standard=Magento2 --extensions=php,phtml --error-severity=10 --ignore-annotations` on the entire package and rejects any submission with severity-10 errors.

**Required**: Yes. Continues running other checks even if it fails — you get a full report.

**Failure modes**: Any severity-10 violation. See `references/coding-standard-meqp.md` for the catalog (XSS in templates, raw superglobals, `eval()`, `Mage::`, dynamic `include`, `goto`, etc.).

**Reproduce locally** (must reproduce in CI before submission):

```bash
phpcs --standard=Magento2 \
      --extensions=php,phtml \
      --error-severity=10 \
      --ignore-annotations \
      --report=json \
      --report-file=marketplace-report.json \
      /path/to/your/extension
```

**Report**: JSON with per-file, per-line, per-source error entries. Adobe's UI presents the same data as a table.

**Fixing**: See the recipes section of `references/coding-standard-meqp.md`. `phpcbf` auto-fixes mechanical issues; design-level errors need hand fixes.

## 4. Copy/Paste Detector

**What it does**: Plagiarism detection. Two corpora:
- **Magento core code** — code matching Magento's own codebase must be licensed under OSL-3.0 and properly attributed to Adobe, Inc.
- **Other Marketplace listings** — copying another seller's code is rejected outright unless legitimately licensed.

**Required**: Yes (production only; disabled in sandbox).

**Failure modes**:
- Copied a Magento core class into your module verbatim and forgot to put the OSL-3.0 + attribution at the top.
- Copied another vendor's code without their license.
- Shared "library" files between your own extensions that look identical (acceptable, but make sure the file headers match what your shared package declares).

**Reproduce locally**: No public access to the corpus. Best you can do is grep the Magento core install for distinctive strings from your file:

```bash
grep -r "your distinctive string" vendor/magento/
```

**Fixing**: If the copy is legitimate, license your module as OSL-3.0 and prepend each copied file with:

```php
<?php
/**
 * Copyright © Adobe, Inc. All rights reserved.
 * See COPYING.txt for license details.
 *
 * Modified from: vendor/magento/module-foo/Bar.php
 */
```

If illegitimate, rewrite the code.

## 5. Installation + Varnish tests

**What it does**: Spins up a clean Magento 2 install for each combination of (claimed Magento version) × (claimed PHP version), Composer-installs your package, runs `setup:upgrade`, `setup:di:compile`, `setup:static-content:deploy`, `deploy:mode:set production`, `indexer:reindex`. Then hits cacheable storefront pages (product, category) through Varnish to confirm cache headers are intact.

**Required**: Yes for extensions and themes (not for apps).

**Failure modes**:
- `setup:upgrade` errors (missing dep, broken `db_schema.xml`, conflicting `events.xml`).
- `setup:di:compile` failures (cyclical DI, unresolvable Proxy/Factory references).
- `setup:static-content:deploy` failures (broken LESS, invalid `requirejs-config.js`).
- `deploy:mode:set production` fails on missing static deploy output.
- Cacheable pages return non-cacheable headers because your block declared `cacheable="false"` somewhere.
- Reindexer fails on an extension-introduced indexer with a bug.

**Reproduce locally** (using [Magento Cloud Docker](https://github.com/magento/magento-cloud-docker)):

```bash
# Clone cloud-docker and start a fresh 2.4.7 / PHP 8.2 stack
git clone https://github.com/magento/magento-cloud-docker.git
# ... follow the cloud-docker readme to bring up a stack for 2.4.7 ...
docker compose exec cli composer require yourvendor/module-awesome:1.0.0
docker compose exec cli bin/magento setup:upgrade
docker compose exec cli bin/magento setup:di:compile
docker compose exec cli bin/magento setup:static-content:deploy -f
docker compose exec cli bin/magento deploy:mode:set production
docker compose exec cli bin/magento indexer:reindex
# Then `curl -I http://your-stack/product-page` and look for "X-Magento-Cache-Debug: HIT"
```

Repeat for each (Magento, PHP) combination you claim compat with.

**Fixing**: Trace the failing CLI step in the report and fix the underlying issue. Cache misses usually trace to `cacheable="false"` in `view/frontend/layout/*.xml` — remove it unless absolutely necessary, and use ESI / private content instead for truly dynamic blocks.

## 6. MFTF Magento-supplied tests

**What it does**: Runs Adobe's standard MFTF (Magento Functional Testing Framework) suite — the same one Magento core uses — with your extension installed, against each claimed PHP version.

**Required**: Yes for extensions.

**Failure modes**: Your extension breaks core flows. Examples:
- A plugin on `\Magento\Catalog\Model\Product::save()` throws on a test fixture.
- An observer on `customer_register_success` crashes when test data lacks a custom field your extension reads.
- A layout XML override removes a button MFTF expects.

**Reproduce locally**:

```bash
# In a Magento 2 dev install with your extension:
vendor/bin/mftf build:project
vendor/bin/mftf generate:tests
vendor/bin/mftf run:group default --remove
```

**Report**: Allure-style XML. Test names point at the failing scenario.

**Fixing**: Run the failing test locally, follow the breadcrumb to your extension's hook into the flow, and either guard the hook or fix the bug.

## 7. MFTF Vendor-supplied tests

**What it does**: Runs any MFTF tests shipped by you in `Test/Mftf/` (note the singular `Test`, not `Tests`).

**Required**: **Not required to pass currently** — Adobe is observing this check. Pass/fail is reported but does not block publication.

**Failure modes**:
- Tests are in `Tests/Mftf/` instead of `Test/Mftf/`.
- MFTF version < 3.0.
- Magento target < 2.4.0.
- Test names collide with existing Magento test names.
- Missing referenced ActionGroups / Pages / Sections.
- Hardcoded credentials in tests.

**Best practices**:
- Put fixtures, action groups, page objects, and sections under `Test/Mftf/{ActionGroup,Data,Page,Section,Test}/`.
- Use the standard MFTF directory structure.
- Don't ship sensitive credentials in tests — use credential vault references.
- Add a `Test/README.md` if your tests need special setup.

**Reproduce locally**: Same `vendor/bin/mftf` flow as Magento-supplied tests, just scoped to `--filter testCaseId:Test_Mftf_YourTest`.

## 8. Extension Footprint analysis

**What it does**: Beta analyzer that statically inspects the package and reports counts of:
- Programmatic APIs (service contracts, interfaces).
- REST/SOAP Web APIs.
- GraphQL queries / mutations / types.

**Required**: No — informational only. Cannot fail.

**Use**: Sets expectations for merchants on the listing detail page about what surface area the extension exposes. Useful for security-conscious buyers.

## 9. Semantic Version Check

**What it does**: When a seller declares the new version as a PATCH-level change (from the Patch radio on resubmission), runs `magento/magento-semver` against the previously-published version to confirm the change really is patch-level.

**Required**: Conditional — only when the seller claims PATCH.

**Failure behavior**: A disagreement with the PATCH claim does **not** fail the submission. It demotes the submission's review flow to standard Manual QA (i.e., loses the fast-track). The submission can still pass.

**Reproduce locally**:

```bash
composer require --dev magento/magento-semver
php vendor/bin/svc compare /path/to/previous-version /path/to/new-version 1
```

The exit code reports the detected level (PATCH / MINOR / MAJOR). Compare against your claim.

**What counts as MINOR/MAJOR** (so isn't patch):
- Adding/removing a public method or property.
- Changing a public method's signature.
- Adding a new class or interface.
- Removing or renaming a constant.
- Public XML config changes (e.g., new `events.xml` or `webapi.xml` entries) — these count as MINOR.

**Fixing**: Either accept the demotion to Manual QA (the submission is fine), or restructure your changes to be true patch-level (the change is bigger than you thought).

## 10. Manual QA

**What it does**: Human reviewer installs your extension via Composer, follows your User Guide PDF, exercises the merchant flows, and confirms the extension works as documented.

**Required**: Yes — except when SVC confirms PATCH (then skipped).

**Standard manual checklist**:
- Installs cleanly with Composer.
- `setup:di:compile` succeeds.
- `deploy:mode:set production` succeeds.
- User guide is intelligible and covers all features.
- Documentation does not direct users to make purchases off Marketplace.

For each Magento version claimed, reviewer runs basic flows with your extension installed:
- Create order as guest (Simple + Configurable products).
- Create new customer.
- Create order as customer.
- Place order via "Check Out with Multiple Addresses".
- Re-order a previous order.
- Add to Wishlist.
- Add to Comparison list.
- Admin: create Invoice, Shipping, Credit Memo.
- Admin: create order (re-order).
- Admin: create new product (Simple + Configurable) with images.
- Admin: create new product category.

**Page Builder additional checks** (only if your extension claims Page Builder support):
- New/extended content types can be dragged to stage, edited, duplicated, moved, hidden, saved, deleted.
- Storefront renders new/extended content types without errors.
- All Page Builder content-creation flows still work in admin and storefront.

**Failure exit criteria**:
- At least one major issue in Magento functionality affected by the extension.
- A blocking issue affecting the entire extension.
- Two blocker-level issues in different feature areas.

**Reproduce locally**: Do exactly what the reviewer will do. Install your extension on a fresh M2.4.x, follow your own User Guide, run the checklist. Don't ship documentation that doesn't match the code.

## What to do when a report comes back failed

1. Open the report. The Developer Portal listing detail page has a Test Reports section with one entry per check.
2. Find the offending check by reading the email and the in-portal status.
3. Open the matching reference here:
    - Malware → `references/common-rejections.md`.
    - Package Verification → `references/extension-packaging.md`.
    - Code Sniffer → `references/coding-standard-meqp.md`.
    - Copy/Paste → `references/common-rejections.md`.
    - Installation + Varnish → `references/testing-mftf-and-installation.md`.
    - MFTF → `references/testing-mftf-and-installation.md`.
    - Semantic Version → `references/version-and-semver.md`.
    - Manual QA → `references/common-rejections.md`.
4. Reproduce the failure locally.
5. Fix the root cause. Bump the version (PATCH for true bug fix, MINOR/MAJOR otherwise — see `references/version-and-semver.md`).
6. Re-upload via "Submit a New Version" → upload new zip → Submit.
7. The full pipeline re-runs. No partial restart.

## A note on Apps

Apps go through a manual technical review instead of this automated pipeline. The pipeline above is for extensions / themes / shared packages / language packs / metapackages. Sandbox restrictions vary slightly: human reviews never happen in sandbox, Copy/Paste is disabled in sandbox.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/technical-review-guidelines.md`
- `references/sources/commerce-marketplace/guides/sellers/submit-for-technical-review.md`
- `references/sources/commerce-marketplace/guides/sellers/malware-scan.md`
- `references/sources/commerce-marketplace/guides/sellers/code-sniffer.md`
- `references/sources/commerce-marketplace/guides/sellers/copy-paste-detector.md`
- `references/sources/commerce-marketplace/guides/sellers/installation-and-varnish-tests.md`
- `references/sources/commerce-marketplace/guides/sellers/mftf-magento.md`
- `references/sources/commerce-marketplace/guides/sellers/mftf-vendor.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-footprint.md`
- `references/sources/commerce-marketplace/guides/sellers/semantic-version-check.md`
- `references/sources/commerce-marketplace/guides/sellers/assurance.md`
