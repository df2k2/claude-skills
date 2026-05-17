# Listing Entry Information (Creating the Listing Slot)

Before you can submit a code package, you have to create a "listing entry" — the persistent slot that future versions are submitted into. This reference walks through every field of the listing-creation form, what it means, which choices have downstream consequences (e.g., partner-only options), and the two-step "basic info" then "version details" flow.

## Two stages: listing entry, then version submission

A Marketplace listing is two layers:

1. **Listing entry** (one-time per product) — basic info, title, pricing model, integration disclosure. Created once, lives forever.
2. **Version submissions** (every release) — version number, supported M2 versions, code package, license type, documentation. Many per listing.

The listing entry creates the slot. Every version submission goes through full EQP review. You don't re-fill the listing entry; you only submit new versions into it.

## Path to create

From the Developer Portal:

1. Top nav → **Extensions** / **Themes** / **Shared Packages** (whichever applies).
2. Click **Create New Extension** (or "Theme", "Shared Package").
3. Fill in the basic info form (described below).
4. Click **Submit and Continue**.
5. You land on the listing's Details page.
6. Click **Submit a New Version** to start the technical+marketing submission flow.

If your organization isn't an Adobe partner, the **Apps** menu shows a non-partner explanation screen rather than an App-creation form — partner badges gate app submission.

## Listing-entry fields

| Field | Required? | Listing types | Notes |
| --- | --- | --- | --- |
| **Title** | YES | All | The full listing title. Duplicate names are not allowed across the whole Marketplace. See `references/marketing-review.md` for naming rules. |
| **Adobe Commerce Platform Version** | YES | All | Choose **Adobe Commerce 2.x (M2)**. (There is also an M1 option preserved for legacy; do not use for new submissions.) Specific minor versions (2.4.5, 2.4.6, ...) are set during version submission, not here. |
| **How would you like to sell your Product?** | YES | Extensions, themes | **One time** or **Subscription**. Apps are one-time only. |
| **Does this extension enable an integration with a non-Adobe Commerce service?** | YES | Extensions | Yes/No. If Yes, expand the next four. |
| **Name of Service** | conditional | Extensions | Name of the non-Adobe service. |
| **URL of Service** | conditional | Extensions | Full URL of the service. |
| **Is this service owned/operated by you or a 3rd party** | conditional | Extensions | First-party or third-party. |
| **Does this Service require additional subscription payments to the 3rd party** | conditional | Extensions | Yes/No; if Yes you'll declare pricing details during submission. |
| **Are subscription payments ALSO required to your company for the integration** | conditional | Extensions | Yes/No. |

The integration-disclosure fields directly affect marketing review's content rules. If your integration requires an additional subscription to a third party (or to you for the integration itself), that fact must surface bold in the listing's long description's opening paragraph.

## Title rules (recap)

The full set is in `references/marketing-review.md`. Key constraints:

- ≤ 5 words.
- English.
- No "Magento", "Adobe", "M2".
- No "Extension", "Module", "Plugin", "App".
- "Connector", "Integration" allowed.
- Capitalized words, `&` not `and`.
- No version, no developer name (unless name == service brand).

Title duplicate-check is global — Adobe rejects "Mass Order Export" if another seller already has it.

## Pricing model (one-time vs. subscription)

| Model | Allowed for | Min price | Notes |
| --- | --- | --- | --- |
| **One time** | Extensions, themes, shared packages, apps | $25 (paid) | Single flat fee at install. |
| **Subscription** | Extensions, themes | $10/period | Auto-renews monthly/yearly. **Not supported for apps.** |

You can sell the listing for free at $0; subscription items must have a non-zero price.

Once chosen, the pricing model is hard to switch — Adobe's stance is that switching from one-time to subscription mid-life is unfair to existing customers, and the platform doesn't really support clean migration. Pick deliberately.

## After "Submit and Continue"

You land on the listing's Details page. It shows the listing as Draft with no versions submitted. Submit a new version next.

## Version-submission fields (per release)

When you click **Submit a New Version**, the following fields appear:

| Field | Required? | Notes |
| --- | --- | --- |
| **Marketplace Version Number** | YES | Free-text version like `1.0.0`. Must match `composer.json`'s `version`. See `references/version-and-semver.md` for the SVC rules. |
| **Compatibility** | YES | Multi-select of supported Magento Open Source minors (2.4.5, 2.4.6, ...). Adobe Commerce versions appear here only if you have partner/EE status. |
| **Requested Launch Date** | YES | **On Approval** (publish immediately on approval) or **Requested Launch Date** (earliest date this can launch, contingent on approvals). |
| **Code Package** | YES (technical submission) | Upload the zip. ≤ 30 MB. |
| **Magento Version Compatibility** | YES | Mirrors the compatibility multi-select; reviewer cross-references. |
| **License Type** | YES | Dropdown — see table below. Or custom (Name + URL). |
| **Documentation** | YES (≥ 1 of 3) | User Guide / Reference Manual / Installation Guide — PDF ≤ 5 MB each. User Guide is strongly recommended. |
| **Shared Packages** | conditional | Pick from your already-published Shared Packages if this extension depends on one. |
| **Release Notes** | YES | Up to 10,000 chars; simple HTML allowed; no CSS. |

A **Save Draft** button preserves progress without entering the queue.

## License Type options

The dropdown maps to standard SPDX identifiers. Pick one or pick **Custom License** and supply Name + URL:

| UI option | SPDX | Notes |
| --- | --- | --- |
| Custom License | (any) | Provide a Name and a URL. URL must be public. |
| Academic Free License 3.0 | AFL-3.0 | Permits free distribution and reuse with source available. |
| Apache License 2.0 | Apache-2.0 | Permissive, requires attribution. |
| BSD 2-Clause License | BSD-2-Clause | Permissive, minimal restrictions. |
| GNU General Public License 3.0 | GPL-3.0 | Strong copyleft; redistribution under same license. |
| GNU Lesser General Public License 3.0 | LGPL-3.0 | Slightly less restrictive than GPL-3.0. Requires installation instructions. |
| MIT License | MIT | Most permissive; very common. |
| Mozilla Public License 1.1 | MPL-1.1 | Patent rights explicit; derivative works can be other licenses. |
| **Open Software License 3.0** | OSL-3.0 | **Required** when you've copied source from Magento core. |

For a free, permissive license, MIT is typical. For copy of Magento core code, OSL-3.0 with attribution is **required** (see `references/marketing-review.md` Copy/Paste rules). For commercial pricing, OSL-3.0 or a custom commercial license is common.

Your `composer.json`'s `license` field should match what you select here (use the SPDX identifier, e.g., `"license": ["OSL-3.0"]`).

## Documentation requirements

Marketplace requires at least one of: User Guide, Reference Manual, Installation Guide (PDF, ≤ 5 MB).

Practical guidance:

- **User Guide** is the highest-value doc. Cover all features. Walk through the admin configuration screens.
- **Reference Manual** is useful for extensions with many fields/screens — it's the "every-field" doc.
- **Installation Guide** is sometimes required by your license (e.g., LGPL-3.0).

Manual QA reviewers literally follow your User Guide to test the extension. If the doc says "Click Save", that button must exist with that label in the version you've submitted. Mismatches between doc and code are a common Manual QA rejection.

PDF format only; the Developer Portal rejects other formats. If your doc lives on a wiki or knowledge base, upload a PDF that points to the wiki URL (and submit the wiki URL in Release Notes too).

## Shared Packages

If your extension depends on a Shared Package you've also submitted to Marketplace:

- The Shared Package must already be in **Ready to Use** status before you can link to it from your extension.
- The Shared Package has its own EQP review (technical only — no marketing).
- Link to it via the **Shared Packages** dropdown on the technical submission form.
- Your `composer.json` must `require` the Shared Package by its `vendor/name`.

## Release Notes

- Up to 10,000 chars.
- Simple HTML (`<b>`, `<i>`, `<ul>`, `<li>`, `<p>`, `<a>`). **No CSS.**
- Typical content: list of new features, bug fixes, breaking changes, upgrade notes.
- Release Notes are merchant-visible on the listing page after approval, so write them for end-users.

## Backporting flow

If you've already published v2.0 and want to issue a security fix to the v1.x line:

1. From the listing details page, click **Submit a New Version**.
2. Set the new version number as `1.0.1` (or similar; it must be greater than the previous 1.x version and less than the next major).
3. Compatibility multi-select: pick only the M2 versions that the 1.x line supported.
4. Submit. The version is treated as **Backporting**.
5. Marketplace shows both the latest line and the backported line side-by-side.

## Update vs. Patch vs. Backporting (formal definitions)

| Submission type | What it is | Special handling |
| --- | --- | --- |
| **New** | First version of a listing. | Full pipeline. See `references/technical-review.md`. |
| **Update** | Marketing-only update for an already-published listing. | Bypasses technical pipeline; goes straight to marketing review. |
| **Patch** | New version that the seller marks as a PATCH-level change. | Triggers Semantic Version Check. If SVC confirms, Manual QA is skipped. |
| **Backporting** | New version on an older line. | Treated like Patch for review purposes but listed separately on the storefront. |

## Marketing-information sections (separate flow)

Marketing submission is filled separately under **Marketing Submission** on the listing details page:

| Section | Required? |
| --- | --- |
| Description (Long Description + Category) | YES |
| Images and Videos (Icon + Gallery + optional YouTube) | YES |
| Compatibility (Browser checkboxes) | YES |
| Pricing (per M2 version, plus installation services) | YES |
| Support tiers | optional |
| Additional Details (stability + checkboxes) | YES |
| Documentation and Resources | YES — but typically uploaded during technical submission |

See `references/marketing-review.md` for what each field's content rules look like.

## Quick checklist for creating a new listing

- [ ] Have a title that passes the title rules. Check global uniqueness.
- [ ] Decide one-time or subscription pricing model (and stick with it).
- [ ] Declare any third-party service this extension integrates with.
- [ ] Click Submit and Continue → land on Details page.
- [ ] Have a properly-packaged zip ≤ 30 MB ready (see `references/extension-packaging.md`).
- [ ] Have a User Guide PDF ≤ 5 MB.
- [ ] Pick the right license (match `composer.json`'s `license` field).
- [ ] Pick supported Magento versions you've actually tested on.
- [ ] Have release notes drafted.
- [ ] Submit a New Version → fill the technical-submission form → Submit.
- [ ] In parallel, complete the marketing-submission sections → Submit.
- [ ] Watch for emails / portal status changes.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/extension-create.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-version.md`
- `references/sources/commerce-marketplace/guides/sellers/before-you-begin.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-information.md`
- `references/sources/commerce-marketplace/guides/sellers/submit-for-technical-review.md`
- `references/sources/commerce-marketplace/guides/sellers/submit-for-marketing-review.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-update-information.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-resubmit.md`
- `references/sources/commerce-marketplace/guides/sellers/shared-packages.md`
- `references/sources/commerce-marketplace/guides/sellers/themes.md`
