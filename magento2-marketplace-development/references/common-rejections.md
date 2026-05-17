# Common Rejections (Failure-Pattern Catalog)

This is the catalog of "why was my listing rejected?" cases, with the rule cited, the fix, and a pointer to the deep reference. Use this first when a rejection email arrives — most failures map to one of the entries below.

## Malware Scan rejections

Halts the rest of the pipeline. Email subject usually reads "Malware detected in submission".

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Generic "malware found" | An older minified JS library bundled in your extension matches a known-bad signature | Remove the JS or update to a clean version |
| Specific file path called out | Test fixture, sample data, or stray binary triggered AV heuristic | Delete the file; rebuild zip |
| Documentation PDF flagged | Embedded link to a flagged URL | Remove / replace the link in the PDF |
| `.DS_Store`, `Thumbs.db`, `__MACOSX/` | Not actually malware but bloat | `zip -x '.DS_Store' -x '__MACOSX/*' ...` |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/malware-scan.md`. **Recovery**: see `references/technical-review.md`.

## Package Verification rejections

Halts the rest of the pipeline. These are mechanical and the report tells you exactly which rule failed.

| Symptom | Cause | Fix |
| --- | --- | --- |
| "Submitted package is not a zip archive" | Submitted `.tar.gz` or unpacked dir | Re-zip. |
| "Submitted package exceeds 30 MB" | Bundled vendor dir / node_modules / large media | Strip them. |
| "composer.json not found" | Zip has a subfolder root | Re-zip from inside the module dir. |
| "Invalid composer.json type" | `type` is `magento2-component` or missing | One of `magento2-module` / `magento2-theme` / `magento2-language` / `metapackage`. |
| "Forbidden dependency declared" | `magento/magento2-base` etc. in `require` | Remove that dep entirely; Magento core provides it. |
| "Star version restriction" | `"magento/framework": "*"` | Use a real range, e.g., `"^103.0"`. |
| "extra.map / extra.magento-root-dir is set" | M1-era keys | Remove them. |
| "Require inline alias detected" | `require: { x: "1.0 as 1.0.0" }` | Pin normally. |
| "module.xml not found" | Module package missing `etc/module.xml` | Add it. |
| "registration.php not in autoload.files" | `composer.json` autoload misconfigured | Add `"files": ["registration.php"]`. |
| "Theme package has psr-4 autoload" | Themes can't have PSR-4 | Drop the `psr-4` block. |
| "Metapackage has no dependencies" | Empty `require` on metapackage | Add at least one dep. |
| "PHP version constraint excludes supported PHP" | `"php": "~8.1.0"` but claimed 2.4.7 (needs 8.1/8.2/8.3) | Expand to `~8.1.0||~8.2.0||~8.3.0`. |
| "FIXME / TODO comment in source" | Forgotten dev marker | Remove all `FIXME`/`TODO`/`XXX`. |
| "composer.json version field missing" | `version` not in composer.json | Add it; match Developer Portal field. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/technical-review-guidelines.md` + `references/extension-packaging.md`. **Recovery**: `references/extension-packaging.md`.

## Code Sniffer rejections

The largest category. Any severity-10 error stops publication.

### Security

| Sniff | Symptom | Fix |
| --- | --- | --- |
| `Magento2.Security.XssTemplate.FoundUnescaped` | `<?= $block->getX() ?>` in `.phtml` | Wrap with `$escaper->escapeHtml()` / `escapeHtmlAttr()` / `escapeJs()` / `escapeUrl()`. |
| `Magento2.Security.Superglobal.SuperglobalUsageError` | `$_GET`, `$_POST`, `$_REQUEST`, etc. used directly | Inject `\Magento\Framework\App\RequestInterface`; use `$this->request->getParam('x')`. |
| `Magento2.Security.InsecureFunction` | `eval()`, `system()`, `exec()`, `shell_exec()`, `passthru()`, `assert()` | Replace with framework code. There's rarely a legitimate reason for shell-out in a Marketplace extension. |
| `Magento2.Security.IncludeFile` | `include $path`, `require_once $f` with dynamic argument | Hardcode the include or use Magento's filesystem services. |
| `Magento2.Security.LanguageConstruct` / `DirectOutput` | `echo`, `print_r`, `var_dump`, `var_export` outside `.phtml` | Use the response object or a logger. |
| `Squiz.PHP.Eval` | `eval(...)` anywhere | Refactor. |

### Legacy / Magento-specific

| Sniff | Symptom | Fix |
| --- | --- | --- |
| `Magento2.Legacy.MageEntity` | `Mage::...` (M1-era) | Use DI. |
| `Magento2.Legacy.AbstractBlock` | `extends Mage_Core_Block_Abstract` | `extends \Magento\Framework\View\Element\Template`. |
| `Magento2.Legacy.InstallUpgrade` | `Setup/InstallSchema.php` etc. | Migrate to `etc/db_schema.xml` + `Setup/Patch/Data/`. |
| `Magento2.Legacy.EmailTemplate` | M1-style email templates | Re-author per M2 conventions. |
| `Magento2.Legacy.ObsoleteConfigNodes` | XML nodes from old config DTDs | Remove. |
| `Magento2.Legacy.RestrictedCode` | Code on Magento's deny list | Refactor. |
| `Magento2.Classes.DiscouragedDependencies` | Concrete-class dep where service contract exists | Inject the interface. |
| `Magento2.PHP.AutogeneratedClassNotInConstructor` | `new YourVendor\Module\Model\WidgetFactory(...)` outside `__construct` | Inject the factory. |
| `Magento2.PHP.FinalImplementation` | `final class X` on non-API class | Drop `final` (Magento extends it). |
| `Magento2.PHP.Goto` | `goto` statement | Refactor. |

### PHP / HTML

| Sniff | Symptom | Fix |
| --- | --- | --- |
| `Generic.PHP.CharacterBeforePHPOpeningTag` | Whitespace/BOM before `<?php` | Strip leading whitespace; check encoding. |
| `Generic.PHP.NoSilencedErrors` | `@function_call()` | Handle the error properly. |
| `Generic.Files.ByteOrderMark` | UTF-8 BOM | Re-save without BOM. |
| `Magento2.Html.HtmlSelfClosingTags` | `<br />`, `<input ... />` | Use `<br>`, `<input>`. |
| `Magento2.Html.HtmlClosingVoidTags` | `</img>`, `</input>` | Remove the close tag. |
| `Magento2.Strings.ExecutableRegEx` | `preg_*` with `e` modifier | Replace with `preg_replace_callback`. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/code-sniffer.md` + `references/sources/magento-coding-standard/Magento2-ruleset.xml`. **Recipes**: `references/coding-standard-meqp.md`.

## Copy/Paste Detector rejections

| Symptom | Cause | Fix |
| --- | --- | --- |
| "Copied from Magento core" | Verbatim Magento class included | License as OSL-3.0 + add attribution comment at top of copied file. |
| "Copied from existing Marketplace listing" | Plagiarized another vendor's code | Rewrite. There's no legitimate fix unless you have the other vendor's written license. |
| "Multiple of your packages are identical" | Same code in two of your listings | Either factor into a Shared Package, or make sure each package has distinct content. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/copy-paste-detector.md`. **Note**: this check is disabled in sandbox.

## Installation + Varnish rejections

| Symptom | Cause | Fix |
| --- | --- | --- |
| `setup:upgrade` fails | Broken `db_schema.xml`, conflicting events.xml, missing dep | Local repro on Cloud Docker; fix the file. |
| `setup:di:compile` fails | Cyclic DI, bad type config | Inspect the failing class in DI logs; restructure. |
| `setup:static-content:deploy` fails | Broken LESS, invalid requirejs config, layout XML references missing block | Validate each artifact locally. |
| `deploy:mode:set production` fails | Static deploy left state inconsistent | Clean `pub/static/`, re-run deploy. |
| Reindex fails | Custom indexer has a bug | Inspect the indexer code; test with `indexer:reindex your_indexer`. |
| Cacheable page returns `MISS` on second request | `cacheable="false"` set in layout XML on a page that shouldn't disable FPC | Remove `cacheable="false"`; use ESI / private content for genuinely dynamic blocks. |
| Edit doesn't invalidate cache | Block doesn't return identities for cache tags | Implement `IdentityInterface` and return product/category identities. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/installation-and-varnish-tests.md`. **Recovery**: `references/testing-mftf-and-installation.md`.

## MFTF rejections

| Symptom | Cause | Fix |
| --- | --- | --- |
| Magento-supplied MFTF fails on `CreateOrderTest` | Your plugin/observer breaks core flow | Local: install your extension, run `vendor/bin/mftf run:group default`; fix the breaking hook. |
| Vendor MFTF reports "test not generated" | Tests placed under `Tests/Mftf/` instead of `Test/Mftf/` | Rename directory to singular `Test`. |
| Vendor MFTF reports MFTF version too old | MFTF < 3.0 | Bump test syntax to MFTF 3.x. |
| Vendor MFTF test name conflicts with core test | Used name like `CreateCustomerTest` | Rename with vendor prefix. |
| Vendor MFTF references missing ActionGroup | Composer dep on Magento module not declared | Add the module as a Composer dep. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/mftf-magento.md`, `references/sources/commerce-marketplace/guides/sellers/mftf-vendor.md`. Vendor MFTF currently doesn't block publication.

## Semantic Version Check observations

A SVC mismatch is not a failure — it just demotes the flow to standard Manual QA.

| Symptom | Cause | Fix |
| --- | --- | --- |
| SVC says MINOR, you claimed PATCH | Added a public method or class | Either accept Manual QA, or hide the new code behind `@internal` annotation. |
| SVC says MAJOR, you claimed PATCH | Removed/renamed a public method | Restore the old signature (add a wrapper) or accept the MAJOR bump on next submission. |
| SVC says MAJOR, you claimed MINOR | Dropped support for a Magento version | Re-add that version's compat or bump to MAJOR. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/semantic-version-check.md`. **Recovery**: `references/version-and-semver.md`.

## Manual QA rejections

Manual QA is the most detailed report — a human reviewer writes a narrative.

| Reviewer's note | Likely root cause | Fix |
| --- | --- | --- |
| "Installation failed via Composer" | Bad `composer.json` constraint that wasn't caught by Package Verification | Test locally with a clean `composer create-project magento/project-community-edition`, then `composer require yourvendor/package`. |
| "User guide doesn't match observed behavior" | Doc says "Click Save" but the button is labeled "Apply" | Rewrite doc to match code, or rename button to match doc. |
| "Configuration screen errors with [trace]" | `system.xml` config breaks the admin screen | Validate `system.xml` syntax; check field types are valid. |
| "Place order as guest broke" | Plugin/observer crashes on guest checkout | Add guard for `null` customer; test guest flow locally. |
| "Doc references non-Marketplace purchase URL" | Banned by content rules | Remove off-Marketplace URLs from documentation. |
| "Page Builder content type doesn't render" | Your content type's renderer has a bug | Test the content type drag-drop in admin and storefront. |
| Multiple blockers in 2 different feature areas | Extension is too broken to continue testing | Reviewer stops; fix urgently. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/technical-review-guidelines.md` (Manual QA checklist section). **Recovery**: triage the narrative; reproduce each issue; fix; resubmit.

## Marketing Review rejections

These vary widely. The reviewer cites the rule.

| Reviewer cites | Cause | Fix |
| --- | --- | --- |
| "Title contains 'Magento'" | Marketing title rules | Rename. |
| "Title contains 'Extension' / 'Module' / 'M2'" | Same | Rename. |
| "First mention of Magento missing ®" | Branding | Add `&reg;` to first mention. |
| "Description suggests buying off-Marketplace" | Content rules | Remove the off-platform CTA. |
| "Description promotes other extensions" | Content rules | Strip cross-promotion. |
| "Third-party fees not in opening paragraph bold" | Pricing transparency | Move fee disclosure to bold + opening paragraph. |
| "Screenshots include URL/address bar" | Image rules | Re-crop screenshots. |
| "Icon includes Magento logo" | Branding | Replace icon. |
| "Icon is company logo" | Icon rules | Make a product-specific icon. |
| "Documentation includes Adobe logo" | Branding | Remove Adobe logo (unless partner badge in appropriate context). |
| "Document directs to off-Marketplace purchases" | Content rules | Remove off-Marketplace links from doc. |
| "Long description has grammar/spelling errors" | Content rules | Spell-check and resubmit. |
| "Title duplicates another listing" | Uniqueness rule | Rename. |
| "Listing in wrong category" | Category accuracy | Choose correct main category + subcategories. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/marketing-review-guidelines.md`. **Recovery**: `references/marketing-review.md`.

## De-listing notifications (post-publication)

These aren't EQP rejections — they're policy enforcement on published listings.

| Email subject | Trigger | Window | Fix |
| --- | --- | --- | --- |
| "Compatibility test failed on Magento 2.x.y-pN" | New Magento patch broke automated re-tests on your listing | 30 days | Submit new version that passes on the new patch. |
| "New Magento minor 2.x.0 released" | New minor, no version of yours claims compat with it | 60 days | Submit new version with the new minor in compat list. |
| "Listing not updated in 11 months" | Abandonment warning | 30 days (until 12 months) | Submit any new version to reset clock. |
| "Listing only compatible with EOL versions" | All your compat versions are EOL | 30 days | Submit new version with a current Magento line. |

**Where the rules live**: `references/sources/commerce-marketplace/guides/sellers/compatibility/`. **Recovery**: `references/compatibility-requirements.md`.

## Operational / account rejections

| Symptom | Cause | Fix |
| --- | --- | --- |
| Cannot select Adobe Commerce in version dropdown | No partner badge / EE license | Apply for partner status, or request developer license. |
| Sandbox login splash says "not eligible" | No partner badge | Same. |
| Payout queued indefinitely | W-8/W-9 not submitted | Email tax form to support. |
| Listing not visible to EU buyers | DSA trader info missing | Complete trader info on profile. |
| Pricing change submitted but not reflected | Forgot to click Submit (Save Draft only) | Click Submit. |
| Listing in "Cancelled" without my action | Adobe-initiated cancel (security recall, ToS violation) | Contact support. |

## What to do if you can't identify the cause

If the report is opaque (rare but happens):

1. Email `commercemarketplacesupport@adobe.com` with the submission ID.
2. Specify what you've already tried.
3. Ask for a more detailed report.
4. The marketplace-eqp Slack channel (`#marketplace-eqp-api` in the Magento Open Source workspace) is also responsive — Adobe engineers monitor it.

## Original sources

This reference distills patterns from across the source docs:

- `references/sources/commerce-marketplace/guides/sellers/technical-review-guidelines.md`
- `references/sources/commerce-marketplace/guides/sellers/marketing-review-guidelines.md`
- `references/sources/commerce-marketplace/guides/sellers/malware-scan.md`
- `references/sources/commerce-marketplace/guides/sellers/code-sniffer.md`
- `references/sources/commerce-marketplace/guides/sellers/copy-paste-detector.md`
- `references/sources/commerce-marketplace/guides/sellers/installation-and-varnish-tests.md`
- `references/sources/commerce-marketplace/guides/sellers/mftf-magento.md`
- `references/sources/commerce-marketplace/guides/sellers/mftf-vendor.md`
- `references/sources/commerce-marketplace/guides/sellers/semantic-version-check.md`
- `references/sources/commerce-marketplace/guides/sellers/compatibility/*.md`
- `references/sources/commerce-marketplace/guides/sellers/branding.md`
- `references/sources/commerce-marketplace/guides/sellers/content.md`
