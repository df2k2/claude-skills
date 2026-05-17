# Compatibility Requirements (Release Lines, Abandonment, Obsoletion)

Once a listing is published, Marketplace doesn't stop checking it. Every new Magento patch / minor triggers automated re-runs of EQP tests; lack of updates triggers abandonment; aging out of supported lines triggers obsoletion. This reference covers the three compatibility policies that govern a published listing's continued visibility, with timelines, automated behaviors, and what the seller can do to preserve a listing.

## The three policies at a glance

| Policy | Trigger | Grace window | Outcome |
| --- | --- | --- | --- |
| **Release-line compatibility** | New Magento patch (e.g., 2.4.9-p1) | **30 days** | De-listed if not re-validated |
| **Release-line compatibility** | New Magento minor (e.g., 2.5.0) | **60 days** | De-listed if no compatible version submitted |
| **Abandonment** | No update in 11+ months | warning at 11 months, de-list at 12 months | De-listed |
| **Obsolescence** | All supported lines are EOL | **30 days** after notification | De-listed |

"De-listed" means:
- Removed from search and category pages on the storefront.
- The product detail page is still reachable by direct URL.
- `repo.magento.com` still serves the package to existing customers.
- New merchants will not discover the listing.

It's not deletion — restoring is possible by submitting a compliant new version.

## Release-line compatibility

This is the most active policy. Marketplace runs EQP tests on every published listing automatically when a new Magento patch or minor drops.

### What runs

The same automated checks as a fresh submission:

- Installation + Varnish tests against the new Magento version.
- Code Sniffer (the standard evolves; new severity-10 sniffs added between Magento releases can cause previously-passing extensions to fail).
- Some subset of MFTF Magento-supplied tests.

Manual QA and Marketing Review do not re-run unless the seller submits a new version.

### Patch release flow (e.g., 2.4.9 → 2.4.9-p1)

1. Adobe ships a Magento patch.
2. Marketplace re-runs the automated checks on every listing claiming compat with the prior patch of the same minor.
3. **Listings that pass** are automatically marked compatible with the new patch. **No action needed** — the storefront updates without seller involvement.
4. **Listings that fail** trigger a notification email to the seller. The listing has **30 days** from that email to submit a new version that passes against the new patch.
5. After 30 days, no compatible version → de-list.

### Minor release flow (e.g., 2.4.x → 2.5.0)

1. Adobe ships a Magento minor.
2. The seller has **60 days** to submit a new version that explicitly claims compat with the new minor and passes EQP against it.
3. After 60 days, no compatible version → de-list.

Note: a passed automated re-test does not automatically extend compat to a new minor. Minor compat requires an explicit new submission by the seller (Marketplace will not silently add the new minor to your existing version's compatibility list).

### Example timeline

```
Today: Listing claims 2.4.7, 2.4.8 compat.

Adobe ships 2.4.8-p1.
  → Marketplace re-runs automated checks against 2.4.8-p1.
  → They pass. Listing is now marked "2.4.7, 2.4.8, 2.4.8-p1 compat" — automatic.

Adobe ships 2.4.9.
  → Marketplace does NOT automatically extend compat to 2.4.9.
  → Seller has 60 days to submit a new version with 2.4.9 in the compatibility multi-select.
  → If submitted and passing, listing is now compat with 2.4.7, 2.4.8, 2.4.8-p1, 2.4.9.
  → If not submitted within 60 days, listing is de-listed.

Adobe ships 2.4.9-p1.
  → Marketplace re-runs against 2.4.9-p1.
  → They fail (e.g., new severity-10 sniff added to magento-coding-standard).
  → Seller has 30 days to submit a new version that passes.
  → If they do, listing is restored.
  → If not, listing is de-listed.
```

## Abandonment

Even if a listing remains compatible with all current Magento patches, Marketplace requires evidence of active maintenance:

- **11 months without an update** → Marketplace sends a warning email.
- **12 months without an update** → Listing is de-listed.

This runs as a monthly automated check (Adobe scans for listings that haven't been updated in ≥ 11 months and haven't already been notified).

"Update" means any submitted new version that passes EQP. A trivial patch fix is enough to reset the abandonment clock. The point of the policy is to weed out listings whose vendors have moved on without de-listing themselves.

To preserve a listing: submit any version (even a small README change) at least once every 11 months. Many sellers ship a small annual patch just to reset the clock.

## Obsolescence

A listing whose entire supported-version set is on EOL Magento lines is considered "obsolete":

- Monthly automated check identifies listings whose compatibility-list intersection with currently-supported Magento lines is empty.
- Affected sellers get an email instructing them to submit a version compatible with the latest line.
- **30-day window** to submit and pass EQP.
- After 30 days → de-listed.

What counts as EOL: any Magento line that Adobe has marked EOL on its release calendar. As of 2026:

- **EOL**: 2.3.x (all), 2.4.4 and earlier.
- **Active**: 2.4.5+ (with the usual security-only and full-support distinction within that range).

If you have an older listing whose compatibility list says "2.4.3, 2.4.4" — both EOL — you're already on the obsolete clock. Submit a 2.4.5+ compatible version urgently.

## What the seller controls

| Action | Effect |
| --- | --- |
| Submit any new compatible version | Restarts abandonment clock, addresses patch/minor compat |
| Submit a backported security fix on an older line | Doesn't change the main-line abandonment clock; does extend that older line's life |
| Withdraw a listing manually | The opposite of de-listing — you can voluntarily un-publish |
| Add new M2 versions to compatibility on next submission | Extends release-line coverage |
| Drop old M2 versions from compatibility | Reduces test surface; OK as long as ≥ 1 active line is covered |

## Adobe Commerce on Cloud caveat

Listings that work on stock Magento Open Source / Adobe Commerce don't automatically work on Adobe Commerce on Cloud (ECE-Tools). EQP's installation tests do not include a cloud-deploy step. Sellers are responsible for testing on cloud separately if they claim cloud compatibility.

There is no "cloud-only" listing tier — cloud compat is implicit and not separately validated. Sellers who break on cloud get bug reports from buyers.

## Notification examples (what the seller sees)

The Marketplace docs include screenshots of the actual delisting notifications. Examples:

- "Your listing X is being de-listed due to incompatibility with the latest Adobe Commerce patch."
- "Your listing X has not been updated in 11 months. Submit a new version within 30 days or it will be removed."
- "Your listing X is only compatible with EOL Adobe Commerce versions. Submit a compatible version within 30 days."

These come from `commercemarketplacesupport@adobe.com`. Treat them as actionable, not informational.

## App Builder differences

App Builder apps have their own compatibility track aligned with Adobe Developer Console / App Builder runtime versions, not Magento minors. The policies above apply to extensions/themes/language packs; apps follow a parallel set of rules in the App Builder docs (linked from `references/sources/commerce-marketplace/guides/sellers/compatibility/requirements.md`).

Key resources for App Builder compatibility:

- Setting up I/O Events for Adobe Commerce — https://developer.adobe.com/commerce/extensibility/events/
- Configuring Events for Adobe Commerce — https://developer.adobe.com/commerce/extensibility/events/configure-commerce/
- Setting up Admin UI SDK — https://developer.adobe.com/commerce/extensibility/admin-ui-sdk/
- API Mesh for App Builder — https://developer.adobe.com/graphql-mesh-gateway/gateway/getting-started/
- Deploying App Builder apps — https://developer.adobe.com/app-builder/docs/guides/app_builder_guides/deployment/deployment
- CI/CD for App Builder apps — https://developer.adobe.com/app-builder/docs/guides/app_builder_guides/deployment/cicd-for-app-builder-apps
- App Builder Get Started — https://developer.adobe.com/app-builder/docs/get_started/app_builder_get_started/first-app
- App Builder Projects and Workspaces — https://developer.adobe.com/app-builder/docs/resources/videos/exploring/projects-and-workspaces

## How to recover a de-listed listing

1. Open the de-listing email. Identify the failing automated check or expired window.
2. Reproduce locally on Magento Cloud Docker against the current Magento minor / patch.
3. Fix.
4. Submit a new version via the Developer Portal. Use the existing listing slot (don't create a new entry).
5. The full pipeline re-runs. On approval, the listing is **restored** to the storefront, including search/category visibility.

Listings de-listed for cause and never re-submitted remain de-listed indefinitely; they're not deleted, but they are invisible to new buyers.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/compatibility/requirements.md`
- `references/sources/commerce-marketplace/guides/sellers/compatibility/releases.md`
- `references/sources/commerce-marketplace/guides/sellers/compatibility/abandoned-extensions.md`
- `references/sources/commerce-marketplace/guides/sellers/compatibility/obsolete-extensions.md`
