# Marketing Review

Marketing review is the human half of EQP. It runs in parallel with technical review and is entirely manual — a Marketplace marketing reviewer reads your listing's title, long description, icon, screenshots, videos, category, support tiers, and documentation, and judges them against branding, content, and presentation guidelines. This reference is the rule catalog with examples of what passes and what fails.

## Mental model

Marketing reviewers are filtering out two failure modes from the storefront:

1. **Listings that mislead or under-represent the product.** Buyers want clear, honest descriptions of what the extension does, who it's for, and what it costs in total (including any third-party subscriptions).
2. **Listings that misuse the Magento / Adobe Commerce brand.** Adobe protects the marks aggressively. Names, icons, and copy must respect trademark and partnership boundaries.

Almost every marketing rejection traces to one of these two. The complete rule set below is in service of those two goals.

## Title rules

The title is the field with the strictest constraints. Get this right first.

**Length & language**:
- Up to **five words** (content.md says "up to four words" in the older revision, but the current technical-review guideline allows up to five — write tight either way).
- **English only.**

**Forbidden in title**:
- Version numbers ("v2", "2.4 Edition").
- Your developer name (unless your developer name *is* the integrated service brand — e.g., `Visa` is OK in Visa's own integration title).
- "Adobe", "Adobe Commerce", "Magento", "M2".
- The words "Extension", "Module", "Plugin", "App".
- All-caps words ("ORDER EXPORT" is forbidden).
- Underscores between words (`Mass_Order_Export`).
- Punctuation other than parts of a brand name (`InstantSearch+`, `Yahoo!`) and `/` or `-` in compound terms (`Two-Factor`, `Import / Export`).

**Allowed in title**:
- "Connector".
- "Integration".
- `&` instead of "And" (`Order & Save`, not `Order and Save`).
- Capitalization on each word (`Mass Order Export`, not `Mass order export`).
- The Commerce minor version *only* when you genuinely have two separate listings for two M2 lines (`Awesome Connector 2.3` vs. `Awesome Connector 2.4`).

**Examples**:

| Title | Verdict | Why |
| --- | --- | --- |
| `Mass Order Export` | ✓ | Three words, capitalized, no forbidden terms. |
| `Awesome Magento Extension` | ✗ | Contains "Magento" and "Extension". |
| `Klarna Payments Integration` | ✓ | Service name + "Integration" is fine. |
| `M2 Two-Factor Auth Module` | ✗ | "M2" and "Module" both forbidden. |
| `Stripe Connector for M2` | ✗ | "M2". Just say "Stripe Connector". |
| `Print Order PDF v3` | ✗ | Version number. |
| `Fooman Print Order PDF` | ✗ | Developer name. |
| `Yahoo! Shopping Feed` | ✓ | Punctuation is part of brand. |

## Product icon rules

The icon is what appears in search results and on the listing card. Constraints:

- Must reflect the listing through words and/or images.
- If text is on the icon, it must exactly match the product title (no slogans, no features).
- Do **not** use "Adobe", "Magento", or "M2".
- Do **not** use the Adobe or Magento logo.
- Do **not** use your developer logo as the icon (it identifies you, not the product).
- Do **not** specify a version on the icon.
- Limit "Pro" / "Premium" / similar marketing modifiers.
- Less detail is better — icons render small.
- For first-party companies, reusing a recognizable square logo (the one you'd use on Twitter, LinkedIn) is encouraged.

Icon format: JPG or PNG, max 5 MB.

## Long description rules

The long description is where you sell the product. The constraints below come from the marketing guidelines plus the content rules.

**Length & format**:
- Maximum **25,989 characters** (counts text + numbers + symbols + spaces).
- Simple HTML formatting is allowed. **No CSS** anywhere.
- Use default body style for the opening paragraph (don't start with an `<h2>`).
- Use **bold** only for pricing information.
- Detailed features should be vertical bullet lists.
- All URLs converted to working hyperlinks.

**Required content (opening paragraph)**:
- Clearly state what the extension does for the merchant.
- State what makes it distinct from competitors.
- If any **third-party subscription fees** apply — including those charged by an integrated SaaS service — they must appear **bold** in the opening paragraph.

**Second-language note**:
- The default and required language is English.
- You may include a second-language version **below** the English one, separated by a horizontal line. Both versions must contain the same content, links, and images.

**Forbidden**:
- Promotion of other extensions you sell (the "Check out our other product!" pitch — banned).
- Directing users to purchase outside Marketplace.
- Misuse of the "Magento" / "Adobe Commerce" name (see Branding below).
- Spelling or grammatical errors. Reviewers do read.
- Offensive / discriminatory language, sexual content, nudity.

**Markdown is not the format** — the description is HTML in the Developer Portal's WYSIWYG. If you compose in Markdown first, paste the rendered HTML.

## Branding rules (the Magento name)

Magento is a registered trademark of Adobe. Reviewers strictly enforce:

**First use**:
- The first mention of "Magento" in any user-facing surface — personal profile, company profile, product profile, standalone document — must include the registration symbol: **Magento®**.
- In HTML, that's `Magento&reg;` or `Magento&#174;`.
- Subsequent mentions in the same document don't need `®`.

**Phrasing**:
- ✓ "I create extensions for Magento."
- ✗ "I create Magento extensions."
- ✓ "We are a development agency specializing in Magento."
- ✗ "We are a Magento development agency."
- ✗ "My Magento Extension..."

**Where "Magento" is banned entirely**:
- Name or title of the extension.
- Extension icon.
- Developer branding.
- Your domain name.
- Your username or screen name.
- Your email address or email domain.

**Magento / Adobe logo**:
- Approved Magento trademarks can be used in your listing or website only to refer to related Magento products or services.
- The logo must be the current one provided by Magento (i.e., Adobe's current Magento brand asset).
- The logo must not be altered in any way.
- The Magento logo must be **half the size** of your own branding (so as not to imply affiliation).
- Partners may also use their Adobe partner badge.

**For Adobe Commerce vs. Magento Open Source distinctions**:
- ✓ "For Adobe Commerce" after a product name (if needed).
- ✓ "For Magento Open Source" after a product name (if needed).
- ✗ "Adobe Commerce Mass Order Export" — title can't include "Adobe Commerce".

## Category

The Marketplace storefront is faceted by category and subcategory. The reviewer will reject a listing in the wrong category.

- Choose **one Main Category** and up to **three Subcategories**.
- These must accurately reflect what the extension does.
- A theme should not be filed under Payment Processing, even if it has payment-page customizations.

## Images and videos

**Icon**: required. JPG/PNG ≤ 5 MB.

**Gallery images**:
- **At least 2** required.
- Up to **15** total.
- JPG/PNG, ≤ 5 MB each.
- The first uploaded image is the main image (front of listings).
- Crop to relevant content — no browser chrome, no URL bars, no unnecessary white space.
- Don't include URLs in screenshots (the reviewer will reject for "directing users away").
- Use high resolution; pixelated screenshots are rejected.

**Videos** (optional):
- Up to **3 YouTube URLs**.
- See `references/sources/commerce-marketplace/guides/sellers/video-tips.md` for production tips.

## Documentation rules

The user guide PDF is reviewed during technical review for technical accuracy and during marketing review for content tone.

Marketing-review constraints on documentation:

- Must not direct users to make purchases off Marketplace.
- If the product title appears in the doc, it must not contain "Adobe Commerce" or "Magento Open Source" — use "For Adobe Commerce" / "For Magento Open Source" suffix instead.
- No Adobe or Magento logos (partners may use their partner badge).
- At least one uploaded doc must be in English.
- No duplicate uploads (don't submit the same PDF as both User Guide and Reference Manual).

## Pricing (visible in marketing review)

- Free or paid; paid range is **$25 — $999,999** in **USD**.
- Subscription minimum: **$10/period**.
- Adobe recommends $99 for Open Source listings, $199 for Adobe Commerce listings (these are recommendations, not requirements).
- Any additional fees or subscription pricing — including third-party SaaS fees — must appear bold in the opening paragraph of the long description.
- All revenue is subject to the 85/15 split — see `references/pricing-revenue-distribution.md`.
- The price listed on Marketplace must match your own website (no underpricing on Marketplace to drive sales elsewhere).

## Support tiers

If you offer paid support, fill in up to three Support Tiers with prices and contract lengths. Free support uses the support email from your company profile.

## Additional details checkboxes

The Additional Details section has flags that the marketing reviewer may verify against the actual code:

- **Released with setup scripts** — true if you ship `Setup/Patch/Data/...` or similar.
- **Service contracts included** — true if you ship `Api/*Interface.php` service contracts.
- **External service contracts included** — true if you depend on `Api/Data/*` from a separate package.
- **Custom UI implementation** — true if you ship admin UI components.
- **Web API supported** — true if you ship REST/SOAP/GraphQL endpoints.
- **Test coverage supported** — true if your `Test/` directory contains real tests.
- **Responsive design supported** — true for responsive themes / theme-affecting modules.

Checking these falsely is an integrity issue and gets flagged — reviewers can grep the source for the corresponding files.

## Stability flag

- **Beta Build**: internal testing done, public-tested in production by early adopters.
- **Stable Build**: production-ready, all known critical issues fixed.

This affects how the listing appears in search and on the listing card (Beta gets a tag).

## What triggers a re-review

| Change | Re-review? |
| --- | --- |
| Change price only | NO (bypasses marketing) |
| Change installation price only | NO |
| Change support-tier price only | NO |
| Change long description | YES |
| Change icon | YES |
| Change screenshots | YES |
| Change title | YES |
| Change category | YES |
| New version technical-only changes | Depends — PATCH skips marketing if no marketing fields changed; otherwise marketing re-runs only if marketing fields changed. |

If you only update prices, the new prices push to the storefront within minutes. Anything else in the marketing-submission form triggers a full re-review.

## Marketing-review report

Marketing review reports are a narrative from the human reviewer, listed under Test Reports on the listing detail page. They typically point at specific fields and quote your text. Reviewers will explicitly cite which guideline you tripped — read the citation, fix that one issue, re-submit.

## Common marketing rejections (cheat sheet)

| Symptom | Rule violated | Fix |
| --- | --- | --- |
| Title contains "Magento" / "M2" / "Extension" | Title rules | Rename. |
| Title is "Awesome Magento 2 Connector v3" | Title rules — version, "Magento", "2" | Drop version, drop M2 reference. |
| Icon contains the Magento logo | Branding | Replace icon. |
| Icon is your company logo | Icon rules — must reflect product, not developer | Make a product-specific icon. |
| First mention of "Magento" without `®` | Branding | Add `&reg;` on first use. |
| "We are a Magento agency" | Branding phrasing | Rewrite to "specializing in Magento". |
| Description suggests buying off-Marketplace | Content rules | Remove the off-Marketplace CTA. |
| Description promotes other extensions | Content rules | Remove. |
| Description has a third-party fee buried in paragraph 7 | Pricing transparency rules | Move it to bold in the opening paragraph. |
| Screenshots include the browser address bar | Image rules | Re-crop. |
| User guide says "Buy now at example.com" | Doc rules | Remove the off-Marketplace link. |
| Documentation is duplicated | Doc rules | Upload distinct files. |
| Description is < 200 chars or feels generic | Quality / presentation | Rewrite with real opening + bullet feature list. |
| Title is 8 words | Length rule | Tighten to ≤ 5. |
| Listing icon and screenshots include partner logo | Branding | Use only Adobe partner badge if partner; otherwise drop. |

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/marketing-review-guidelines.md`
- `references/sources/commerce-marketplace/guides/sellers/submit-for-marketing-review.md`
- `references/sources/commerce-marketplace/guides/sellers/branding.md`
- `references/sources/commerce-marketplace/guides/sellers/content.md`
- `references/sources/commerce-marketplace/guides/sellers/product-descriptions.md`
- `references/sources/commerce-marketplace/guides/sellers/image-tips.md`
- `references/sources/commerce-marketplace/guides/sellers/video-tips.md`
- `references/sources/commerce-marketplace/guides/sellers/marketing-submission-preview.md`
