# Resubmission and Updates

A Marketplace listing rarely ships once and stays static. New features ship, bugs get fixed, Magento patches drop, and the listing's compatibility window erodes. This reference covers the four submission flavors — New, Update, Patch, Backporting — when each applies, what each triggers in EQP, and the operational mechanics of pushing a fix after a failed review.

## The four submission types

When you click **Submit a New Version** (or update marketing fields), the type of submission is determined by what you change and the version-number relationship:

| Type | Definition | EQP behavior |
| --- | --- | --- |
| **New** | First-ever version of a listing. | Full technical + marketing pipeline. |
| **Update** | Marketing-only update to an already-published listing. | Bypasses technical pipeline. Goes to marketing review only — and may bypass that if it's pricing-only. |
| **Patch** | New version where the seller declares the change is PATCH-level (per SemVer). Triggers Semantic Version Check (SVC). | If SVC confirms PATCH, Manual QA is skipped. If SVC disagrees, demoted to standard flow. All automated checks still run. |
| **Backporting** | New version submitted on an older line than the current latest. E.g., 1.0.1 after 2.0.0. | Pipeline runs against the backport's claimed compat versions. Listed alongside the latest line on the storefront. |

Pick the right type intentionally — picking wrong wastes review-queue time. The Developer Portal also tries to auto-detect via version-number comparison; e.g., a new version that semver-detects as a 0.0.1 increment prompts you "Is this a patch?".

## Mode-by-mode flow

### New: full first submission

This is the path covered end-to-end in `references/extension-information.md`. Summary:

1. Create the listing entry.
2. Click **Submit a New Version**.
3. Upload the zip, set version, supported M2 versions, license type, docs, release notes.
4. Submit for Technical Review.
5. Complete Marketing Submission (description, icon, screenshots, pricing).
6. Submit for Marketing Review.
7. Both reviews run in parallel.
8. Fix any failures, resubmit, repeat.
9. On both PASSes, listing publishes.

### Update: marketing-only changes after publication

The Update flow is for changing marketing content (description, icon, screenshots) without re-shipping code. Two sub-flavors:

#### Pricing-only Update (fastest path)

Modify **only**:
- Product price.
- Installation price.
- Support tier price.

Then submit. The change skips marketing review entirely and pushes to the storefront within minutes. This is the only EQP-bypass for an already-published listing.

#### Other marketing-field Update

Modify any marketing field (long description, icon, gallery, category, etc.) — alone or alongside pricing. The submission enters the marketing-review queue. Technical pipeline is not re-run because the code hasn't changed.

You **do not** need to un-publish the listing to make a marketing update — the storefront keeps showing the current approved marketing content until the new version is approved.

### Patch: PATCH-level code change with semver fast-track

The Patch flow is the cheat code for fast turnaround on a code fix:

1. Click **Submit a New Version**.
2. Bump only the patch digit (e.g., `1.2.3` → `1.2.4`).
3. When the system detects a PATCH-style increment, it asks: "Is this a patch?" → answer Yes.
4. Submit.
5. EQP runs the automated pipeline AND the Semantic Version Check (`magento/magento-semver`).
6. If SVC confirms PATCH and all automated checks pass → **Manual QA is skipped** → published.
7. If SVC disagrees with PATCH (you sneaked in a public API change) → submission demoted to standard flow → enters Manual QA.
8. If automated checks fail → submission fails, fix and resubmit.

Note that "patch" claim and "skips Manual QA" are gated by SVC's agreement. Just bumping the patch digit isn't enough — SVC has to look at the diff and agree.

### Backporting: security fix on an older line

For maintaining the 1.x line after 2.x has shipped:

1. Click **Submit a New Version**.
2. Set version: greater than the previous 1.x version (e.g., `1.0.1` after `1.0.0`) but less than the next major.
3. **Compatibility multi-select**: pick **only** the M2 versions the 1.x line supported.
4. Pick the "Patch" semantic if the backport is a true patch (typically yes — backports are usually security/bug fixes).
5. Submit.
6. Pipeline runs against the backport's claimed M2 versions.
7. On approval, the storefront displays both:
   - Latest version: `2.0.0`.
   - Backported version: `1.0.1`.
8. Buyers on the 1.x line can install `1.0.1` without upgrading their major.

You can maintain multiple backport lines simultaneously (1.x, 1.5.x, 2.0.x), though that gets unwieldy.

## What triggers re-review

After a published listing is updated:

| What changed | Technical re-runs? | Marketing re-runs? |
| --- | --- | --- |
| Pricing only | NO | NO |
| Installation price only | NO | NO |
| Support tier price only | NO | NO |
| Long description | NO | YES |
| Title | NO | YES |
| Icon | NO | YES |
| Gallery images / videos | NO | YES |
| Category | NO | YES |
| Stability flag | NO | YES |
| Additional details checkboxes | NO | YES (verification of claims) |
| Code package (new version) | YES | YES (unless PATCH-only with no marketing-field change) |
| Compatibility list | YES (because Installation tests need to re-run on the new versions) | NO |
| License type | YES | NO |
| Documentation PDFs | YES (re-tested in Manual QA) | maybe (depends if you re-uploaded to marketing slot too) |
| Release notes | NO | NO (release notes are merchant-visible but not subject to marketing-review re-run) |

## How to actually push a fix after a failure

The typical "Code Sniffer rejected my submission, now what?" loop:

1. **Open the rejection email.** Note the submission ID.
2. **Open the Developer Portal listing detail page.** Find the Test Reports section. Identify the failing check.
3. **Download the failing-check report.**
   - Code Sniffer → JSON report from PHPCS.
   - Installation → log of failing CLI step.
   - MFTF → Allure XML.
   - Manual QA → reviewer narrative.
4. **Reproduce locally.** Run the same check on the same code. If it passes locally but fails on EQP, look for environmental differences (PHP version, dev mode vs. production mode, missing dep).
5. **Fix the root cause.** Don't silence the symptom (`// phpcs:ignore` does nothing — EQP runs with `--ignore-annotations`).
6. **Bump the version.** Resubmissions must change the version. Even for "I'm just resubmitting the exact same code" cases, EQP requires version change.
   - For true bug fix: increment patch.
   - For sniff fix that doesn't change behavior: increment patch.
   - For functional change: appropriate bump per SemVer.
7. **Update release notes** to reflect the fix.
8. **Re-build the zip.** Verify size, structure, manifests.
9. **Upload via Developer Portal** (or `PUT /rest/v1/products/packages/{submission_id}` with new `artifact.file_upload_id`).
10. **Submit.** Full pipeline runs again from scratch — no partial restart.
11. **Watch email + portal for state changes.** Or use callbacks.
12. **Repeat** until all checks pass.

## Resubmission after marketing rejection

The marketing-side fix flow:

1. Open the marketing-review report (the reviewer typically lists each rule violation with quoted text).
2. Fix the marketing fields in the Developer Portal Marketing Submission form. Save Draft, Preview, iterate.
3. When ready, click **Submit**.
4. Marketing review re-enters the queue. Technical doesn't re-run (the code hasn't changed).

## Switching pricing model mid-life

You **cannot** change the pricing model (one-time vs. subscription) of an already-published listing. To switch from one-time to subscription, you'd have to:

1. Un-publish the existing listing (cancel from your end).
2. Create a new listing with the subscription model.
3. Migrate buyers — entirely on your own; Marketplace has no migration tools.

This is a major reason to choose pricing model carefully at listing creation.

## Cancelling / withdrawing a listing

If you decide to remove a listing entirely:

- Contact Marketplace support: `commercemarketplacesupport@adobe.com`.
- Provide the listing's submission ID(s) and explain.
- Adobe sets the listing to **Cancelled** state.
- Existing buyers retain access via `repo.magento.com` (you can ask Adobe to revoke that too, but that's typically reserved for security-driven recalls).

There's no UI button to self-cancel a published listing — it's a support-team operation.

## Re-submission timing patterns

When to push a fix after a rejection:

- **Immediately, if the fix is simple.** Tight loops are fine — Adobe's review queue handles resubmissions like first submissions.
- **Within the 30-day window**, if compat re-test triggered the failure (don't let the compatibility clock run out).
- **Within the 60-day window**, if a new Magento minor triggered the gap.
- **At least once every 11 months**, to reset the abandonment clock.

## Multi-extension portfolios

Sellers with many listings (e.g., 20 extensions) often hit operational pain:

- Each Magento patch may trigger compatibility re-tests on every listing.
- Each one that fails counts against its own 30-day window.
- Annual abandonment checks fire per-listing.
- Sub-managing this manually via the UI is hard; the EQP API is essential.

A common pattern is a CI job that monthly:

1. Lists all your packages via `GET /rest/v1/products/packages`.
2. Filters those with status indicating compat failure or approaching abandonment.
3. Auto-bumps a maintenance release per affected listing.
4. Uploads + submits.

See `references/eqp-rest-api.md` for the scripting patterns.

## Common resubmission rejections

| Symptom | Cause | Fix |
| --- | --- | --- |
| "Version must be greater than previously approved version" | Tried to resubmit same version string | Bump version. |
| "Compatibility list narrower than previous version" | Dropped a previously-supported M2 minor without justification | Either re-add it, or accept the legacy version will remain available for that line. |
| Manual QA says "doc doesn't match code" | You bumped the code but forgot to update the User Guide PDF | Re-upload updated PDF. |
| "Cannot change pricing model after publication" | Tried to switch one-time ↔ subscription | Cancel listing + create new. |
| SVC report says MINOR / MAJOR, you claimed PATCH | Public API changed; SVC caught it | Either accept the demotion to Manual QA, or restructure to be true PATCH. |
| New code fails Installation+Varnish on a version that previously passed | Magento patch update changed behavior; your code didn't follow | Update extension to match new Magento patch and re-submit. |
| Marketing review fails with "title changed unexpectedly" | You changed the title without thinking; reviewer compares to previous | Re-justify the title change in release notes, or revert. |

## Quick checklist before resubmitting

- [ ] Read the failing check's report; understand the root cause.
- [ ] Reproduce locally (zero local errors before pushing).
- [ ] Bump version appropriately (PATCH for code fixes that don't change public API).
- [ ] Update `composer.json`'s `version` to match the Developer Portal field.
- [ ] Update release notes to mention the fix.
- [ ] Re-zip with `composer validate` passing on the new tree.
- [ ] Compatibility list still includes everything you previously supported.
- [ ] PHP version constraint covers everything required by claimed Magento versions.
- [ ] If marketing fields changed too: spell-check the changes.
- [ ] Upload, set action=submit, watch the queue.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/extension-resubmit.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-update-information.md`
- `references/sources/commerce-marketplace/guides/sellers/review-report.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-version.md`
- `references/sources/commerce-marketplace/guides/sellers/submit-for-review.md`
- `references/sources/commerce-marketplace/guides/sellers/semantic-version-check.md`
