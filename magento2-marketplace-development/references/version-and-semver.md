# Versioning, Semantic Versioning, and Dependency Constraints

Every Marketplace submission must declare a version. Marketplace uses [Semantic Versioning](https://semver.org) and validates it via `magento/magento-semver` when the seller flags an update as PATCH-level. This reference covers the version field on submissions, what counts as PATCH/MINOR/MAJOR in Magento's interpretation, how to constrain Magento dependencies in `composer.json`, the backporting flow, and the local commands to reproduce the Semantic Version Check before submitting.

## Marketplace's version model

- The version in your `composer.json`'s `version` field is the canonical version.
- The same string must match the **Marketplace Version Number** field on the version-submission form in the Developer Portal.
- Strict SemVer is expected: `MAJOR.MINOR.PATCH`, e.g., `1.2.3`. Pre-release tags (`-alpha`, `-beta`) are permitted but you probably want **Beta Build** marked under Additional Details if so.
- Versions must always increase on resubmission. You can't ship `1.2.3` twice.

## What counts as PATCH / MINOR / MAJOR in Magento's SemVer

Magento adopts SemVer with one important wrinkle: it inspects **public API surface area**, not just behavior. The boundary is what `magento/magento-semver` enforces. Roughly:

| Change | Magento SemVer classification |
| --- | --- |
| Internal-only refactor of a `protected` method body | PATCH |
| Fix to a private method | PATCH |
| Bug fix that doesn't alter signatures | PATCH |
| Add new public method | MINOR |
| Add new class | MINOR |
| Add new interface | MINOR |
| Add new `events.xml` entry | MINOR |
| Add new `webapi.xml` endpoint | MINOR |
| Add new GraphQL query / mutation / type | MINOR |
| Add new `db_schema.xml` table or column | MINOR (data) |
| Add new constant | MINOR |
| Remove or rename public method | MAJOR |
| Remove or rename class | MAJOR |
| Change public method signature (param add/remove, type change) | MAJOR |
| Remove a `webapi.xml` entry | MAJOR |
| Remove a GraphQL type/field | MAJOR |
| Drop support for a Magento minor (e.g., 2.4.5 → 2.4.6+) | MAJOR |
| Drop support for a PHP minor | MAJOR |

The "what changes are public" question is enforced by the `@api` annotation: classes / methods / interfaces marked `@api` are public; everything else is private to your extension. If you've been careful with `@api`, the semver check rarely surprises you.

## The Semantic Version Check (SVC)

What runs in the Marketplace pipeline when you declare PATCH:

```bash
php magento-semver/bin/svc compare \
    <path-to-latest-published-extension-version> \
    <path-to-submitted-extension-version> \
    1
```

It analyzes the diff and reports the detected change level. Output is one of `patch`, `minor`, `major`.

**Failure behavior**: If SVC says the change is MINOR/MAJOR but you declared PATCH, the submission **does not fail**. It loses the PATCH fast-track and falls back to full Manual QA. Annoying but recoverable.

If SVC agrees with PATCH, Manual QA is skipped entirely. This is the dominant value of SemVer adherence for Marketplace — it cuts review turnaround from days/weeks to hours/days.

## Reproducing SVC locally

```bash
# Install the tool
composer require --dev magento/magento-semver

# Run against two source dirs (not zips)
php vendor/bin/svc compare /tmp/prev-version /tmp/new-version 1
```

The `1` is the verbosity level (1 = errors, 2 = errors + warnings). The exit status reports detected level:

| Exit code | Meaning |
| --- | --- |
| 0 | PATCH-level change detected (or no change). |
| 1 | MINOR-level change detected. |
| 2 | MAJOR-level change detected. |

Requires PHP 7.2.29 or later (any modern PHP works). Doesn't need a running Magento instance.

If you're using a Composer git workflow, extract the previous version with:

```bash
git worktree add /tmp/prev-version v1.2.0
git worktree add /tmp/new-version HEAD
php vendor/bin/svc compare /tmp/prev-version /tmp/new-version 1
```

## When to claim PATCH

Claim PATCH when:

- Pure bug fix, no public API change.
- Internal refactor with no exposed signature changes.
- Documentation-only change in code comments.
- Security fix that doesn't change a public method's behavior visibly.

Don't claim PATCH when:

- You added any new feature, even a small one.
- You added a method, class, event, route, GraphQL field, db_schema column.
- You bumped the minimum required Magento version.
- You bumped the minimum required PHP version.

A failed PATCH claim is no worse than not having claimed it — the submission still progresses, it just does so through full Manual QA. There's no penalty for trying, except the time spent reviewing the report.

## Backporting (security fix on an older line)

The Marketplace storefront supports listing multiple version lines side-by-side. To ship `1.0.1` after `2.0.0` is already published:

1. From the listing detail page, click **Submit a New Version**.
2. Version: `1.0.1` (greater than the previous `1.0.x`, less than the existing `2.0.0`).
3. Compatibility: pick the M2 versions the 1.x line supported.
4. Set the release notes to call out the security fix.
5. Submit. The pipeline runs. On approval, the storefront displays:
    - Latest version: `2.0.0`.
    - Backported version: `1.0.1`.
6. Buyers on the 1.x line can install the patched 1.0.1 without upgrading to 2.x.

The SVC compares the backport against the previous version of the **same line** (1.0.0 → 1.0.1), not against the latest published line (2.0.0). Claim PATCH on backports — they're almost always patch-level by definition.

## Dependency version constraints in `composer.json`

Marketplace rejects `*` constraints on `magento/*` packages and requires real ranges. Adobe documents the recommended versioning at https://developer.adobe.com/commerce/php/development/versioning/dependencies. Practical patterns:

### Strategy A: Tilde-bound on framework

```json
"require": {
    "php": "~8.1.0||~8.2.0||~8.3.0",
    "magento/framework": "^103.0"
}
```

`^103.0` allows 103.x and rejects 104.x. This is the common choice for extensions that work across 2.4.5 through 2.4.9 (framework didn't break compat in that range).

### Strategy B: Explicit constraint per claimed module

```json
"require": {
    "php": "~8.1.0||~8.2.0||~8.3.0",
    "magento/framework": ">=103.0.0 <104.0.0",
    "magento/module-catalog": "^104.0",
    "magento/module-checkout": "^100.4"
}
```

Use this when you depend on specific features of a specific module version.

### Strategy C: Star-version (FORBIDDEN)

```json
"require": {
    "magento/framework": "*"   ← rejected by Package Verification
}
```

Never. Always a real range.

### PHP version constraint

Must cover **every PHP version supported by the Magento line(s) you claim compat with**. Reference:

| Magento line | PHP versions supported |
| --- | --- |
| 2.4.5 | 7.4 (initial), 8.1 (from 2.4.5-p1) |
| 2.4.6 | 8.1, 8.2 |
| 2.4.7 | 8.1, 8.2, 8.3 |
| 2.4.8 | 8.1, 8.2, 8.3, 8.4 |
| 2.4.9 | 8.1, 8.2, 8.3, 8.4 |

If you claim compat with 2.4.7 onwards, your PHP constraint must allow 8.1, 8.2, and 8.3:

```json
"require": {
    "php": "~8.1.0||~8.2.0||~8.3.0"
}
```

If you also claim 2.4.8+, add 8.4. **Don't exclude versions** that the Magento line supports — Package Verification rejects that.

## Versioning examples

| Previous | New | Claim | Why |
| --- | --- | --- | --- |
| `1.0.0` | `1.0.1` | PATCH | Bug fix, no public API change. |
| `1.0.0` | `1.1.0` | MINOR | Added new public method. |
| `1.0.0` | `2.0.0` | MAJOR | Removed deprecated class. |
| `1.0.0` | `1.0.0` | rejected | Versions must increase. |
| `1.0.0` | `0.9.0` | rejected | Versions must increase. |
| `1.0.0` | `1.0.0-beta` | rejected | Pre-release before stable is wrong direction. |
| `1.0.0` | `1.0.1-alpha.1` | allowed | Pre-release of patch. |
| `2.0.0` | `1.0.1` (after) | allowed (Backporting) | Patches on older line; treated as backport, not a regression. |

## Magento module-version cheat sheet

For composer constraints on Magento-shipped modules:

| Module | 2.4.5 | 2.4.6 | 2.4.7 | 2.4.8 | 2.4.9 |
| --- | --- | --- | --- | --- | --- |
| `magento/framework` | 103.0.x | 103.0.x | 103.0.x | 103.0.x | 103.0.x |
| `magento/module-catalog` | 104.0.x | 104.0.x | 104.0.x | 104.0.x | 104.0.x |
| `magento/module-checkout` | 100.4.x | 100.4.x | 100.4.x | 100.4.x | 100.4.x |
| `magento/module-customer` | 103.0.x | 103.0.x | 103.0.x | 103.0.x | 103.0.x |
| `magento/module-sales` | 103.0.x | 103.0.x | 103.0.x | 103.0.x | 103.0.x |

(Magento bumps these per line; check the meta-package `composer.json` of a clean install of each minor to confirm exact patch versions.)

So `"magento/framework": "^103.0"` covers 2.4.5 → 2.4.9. Done.

## Annotations to keep your SVC reports clean

Adding `@api` to classes / methods / interfaces tells the semver tool which surface is public. Without `@api`, methods are treated as internal, and adding/removing them is PATCH-safe.

```php
namespace YourVendor\Module\Api;

/**
 * @api
 */
interface AwesomeServiceInterface
{
    /**
     * @api
     */
    public function doSomething(string $arg): bool;
}
```

Caveat: once you mark something `@api`, you've committed to back-compat for it. Reviewers expect future changes to that method to honor SemVer.

## Common version-related rejections

| Symptom | Cause | Fix |
| --- | --- | --- |
| Submission rejected: "Versions must increase" | Tried to re-submit same version | Bump the version. |
| SVC says MINOR, but I marked PATCH | New public method added | Bump MINOR instead, or hide method behind `@internal`. |
| Package Verification: "Star version used for magento/framework" | `composer.json` has `"magento/framework": "*"` | Use a real constraint like `^103.0`. |
| Package Verification: "PHP version excludes 8.2 but 2.4.6 requires 8.2" | `"php": "~8.1.0"` while claiming 2.4.6 compat | Expand to `"~8.1.0||~8.2.0"`. |
| Manual QA report mentions "version mismatch between composer.json and submission" | `composer.json`'s `version` doesn't match Developer Portal field | Set both to the same string. |

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/semantic-version-check.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-version.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-update-information.md`
- https://github.com/magento/magento-semver (the SemVer tool itself)
- https://developer.adobe.com/commerce/php/development/versioning/dependencies (Adobe's dependency-versioning guide)
