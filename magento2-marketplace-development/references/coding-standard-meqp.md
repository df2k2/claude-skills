# Magento Coding Standard (M2 EQP "MEQP")

The Marketplace code sniffer runs `phpcs --standard=Magento2 --extensions=php,phtml --error-severity=10 --ignore-annotations` on the entire submitted package. Any error at severity 10 rejects the submission. This reference explains the ruleset, the severities, the categories of severity-10 sniffs (which ones actually block), how to run it locally, how to fix the common violations, and how the historical "MEQP" name relates.

## The ruleset is `magento/magento-coding-standard`, not `magento/marketplace-eqp`

The historical name **MEQP** ("Magento Extension Quality Program coding standard") came from `magento/marketplace-eqp`, which has two rulesets — MEQP1 and MEQP2. Adobe consolidated MEQP2 into `magento/magento-coding-standard` years ago. The original repo's MEQP2 ruleset is gone; what remains there is MEQP1, **Magento 1.x only**. From the repo's own README:

> ⚠ Versions 3.0.0 and above of the MEQP Coding Standard are for Magento 1.x code only. To check Magento 2.x code use Consolidated Magento Coding Standard.

For Magento 2, run `phpcs --standard=Magento2` (or `--standard=Magento2Framework` if you're contributing to Magento core itself, which sellers normally aren't). Never `--standard=MEQP2` — that ruleset doesn't exist anymore.

## Severity levels

The Magento2 ruleset assigns each rule a severity that maps to its meaning:

| Type | Severity | Blocks Marketplace? | Description |
| --- | --- | --- | --- |
| Error | **10** | YES | Critical code issues that indicate a bug or security vulnerability. |
| Warning | 9 | no | Possible security issues that can cause bugs. |
| Warning | 8 | no | Magento-specific code issues and design violations. |
| Warning | 7 | no | General code issues. |
| Warning | 6 | no | Code style issues. |
| Warning | 5 | no | PHPDoc formatting and commenting issues. |

The Marketplace code sniffer runs with `--error-severity=10` — any error at level 10 fails the submission. Lower-severity warnings appear in the seller's report but do not block publication.

Setting `--severity=10` (covering both errors and warnings ≥ 10) gives the same result. The official command Adobe documents:

```bash
phpcs --standard=Magento2 \
      --extensions=php,phtml \
      --error-severity=10 \
      --ignore-annotations \
      --report=json \
      --report-file=report.json \
      <path-to-extension>
```

The `--ignore-annotations` flag is significant: Marketplace ignores `// phpcs:disable`, `// phpcs:ignore`, etc. If your code uses suppressions to make `phpcs` happy locally, Marketplace will still fail.

## How to install and run locally

Two install modes — global tool or project dev-dep.

### As a global Composer tool (recommended)

```bash
composer global require squizlabs/php_codesniffer
composer global require magento/magento-coding-standard

# Tell phpcs where to find the Magento standard:
phpcs --config-set installed_paths "$(composer global config home)/vendor/magento/magento-coding-standard"

# Verify:
phpcs -i
# Should list "Magento2" and "Magento2Framework" among the installed standards.
```

### As a project dev-dep

```bash
cd /path/to/your/extension
composer require --dev squizlabs/php_codesniffer magento/magento-coding-standard
```

Then add this to `composer.json` so the post-install script wires up the standard automatically:

```json
{
  "scripts": {
    "post-install-cmd": [
      "([ $COMPOSER_DEV_MODE -eq 0 ] || vendor/bin/phpcs --config-set installed_paths ../../magento/magento-coding-standard/)"
    ],
    "post-update-cmd": [
      "([ $COMPOSER_DEV_MODE -eq 0 ] || vendor/bin/phpcs --config-set installed_paths ../../magento/magento-coding-standard/)"
    ]
  }
}
```

Then run:

```bash
vendor/bin/phpcs --standard=Magento2 app/code/YourVendor/YourModule
```

### Auto-fix where possible

PHP_CodeSniffer ships `phpcbf` (PHP Code Beautifier and Fixer):

```bash
vendor/bin/phpcbf --standard=Magento2 app/code/YourVendor/YourModule
```

It fixes the mechanical violations (whitespace, line endings, simple style). It cannot fix design-level errors (raw SQL in code, XSS in templates, use of forbidden globals, etc.) — those need human attention.

### Run with the Marketplace-equivalent flags

To reproduce locally what Marketplace runs:

```bash
vendor/bin/phpcs --standard=Magento2 \
                 --extensions=php,phtml \
                 --error-severity=10 \
                 --ignore-annotations \
                 --report=json \
                 --report-file=marketplace-report.json \
                 /path/to/your/extension
```

If this produces zero errors, the Marketplace Code Sniffer check will pass. Run this before every submission.

## Severity-10 sniffs that actually block

These are the rule families assigned severity 10 in the current ruleset. A submission with any of them fails. Cluster them mentally by category — that's how to debug a failing report.

### Security (the highest-cost class)

- **`Magento2.Security.IncludeFile`** — `include`/`include_once`/`require`/`require_once` with a dynamic argument (`include $path`). Fix: use Magento's filesystem services, or hardcode the include.
- **`Magento2.Security.InsecureFunction`** — Calls to `eval()`, `system()`, `exec()`, `shell_exec()`, `passthru()`, `proc_open()`, `popen()`, `pcntl_exec()`, `assert()`. Fix: use the framework. There is rarely a legitimate reason to shell out from a Marketplace extension.
- **`Magento2.Security.LanguageConstruct`** + **`Magento2.Security.LanguageConstruct.DirectOutput`** — `echo`, `print`, `print_r`, `var_dump`, `var_export` outside `.phtml`. Fix: use the response object or `\Psr\Log\LoggerInterface`.
- **`Magento2.Security.Superglobal.SuperglobalUsageError`** — direct use of `$_GET`, `$_POST`, `$_REQUEST`, `$_FILES`, `$_COOKIE`, `$_SERVER`, `$_SESSION`. Fix: use `\Magento\Framework\App\RequestInterface`, `\Magento\Framework\Session\SessionManagerInterface`, etc.
- **`Magento2.Security.XssTemplate.FoundUnescaped`** — output in a `.phtml` template without escaping. Fix: pass through `$escaper->escapeHtml()`, `escapeHtmlAttr()`, `escapeJs()`, `escapeUrl()`, or `escapeCss()`.
- **`Squiz.PHP.Eval`** — Use of `eval()` from the upstream PSR ruleset; redundant with `InsecureFunction` but separately registered.

### PHP correctness

- **`Generic.PHP.CharacterBeforePHPOpeningTag`** — anything before `<?php`. Causes invisible "headers already sent" bugs.
- **`Generic.PHP.NoSilencedErrors`** — `@`-suppressed function calls (`@file_get_contents(...)`).
- **`Generic.PHP.Syntax`** — `php -l` syntax error in the file.
- **`Generic.Files.ByteOrderMark`** — UTF-8 BOM at the top of a PHP file.
- **`Magento2.PHP.AutogeneratedClassNotInConstructor`** — Use of an autogenerated class (Proxy, Factory) outside of `__construct`. They're meant for DI.
- **`Magento2.PHP.FinalImplementation`** — `final class` for non-API classes that Magento expects to be overrideable.
- **`Magento2.PHP.Goto`** — Use of `goto`. Forbidden.
- **`Magento2.PHP.ReturnValueCheck`** — `==` / `===` comparisons against function return values that should be type-checked.
- **`PSR1.Classes.ClassDeclaration`** — One class per file.
- **`PSR2.Files.ClosingTag`** — A `?>` at end of a pure-PHP file.

### Magento-specific legacy / API hygiene

- **`Magento2.Classes.DiscouragedDependencies`** — Direct dependency on classes that should be replaced with service contracts (e.g., depending on a concrete model when an interface exists).
- **`Magento2.Legacy.MageEntity`** — Any use of the `Mage::` class (M1 era). Hard block.
- **`Magento2.Legacy.AbstractBlock`** — Extending the deprecated `Mage_Core_Block_Abstract`.
- **`Magento2.Legacy.EmailTemplate`** — Old M1-style email template references.
- **`Magento2.Legacy.ObsoleteConfigNodes`** — XML nodes that don't exist in M2 config DTDs.
- **`Magento2.Legacy.InstallUpgrade`** — `InstallSchema.php`, `InstallData.php`, `UpgradeSchema.php`, `UpgradeData.php`, `RecurringData.php`. Declarative schema (`db_schema.xml`) + patches replaced these.
- **`Magento2.Legacy.Layout`** — Layout-XML nodes that are deprecated.
- **`Magento2.Legacy.RestrictedCode`** — Use of code on Magento's deny list.
- **`Magento2.Legacy.ClassReferencesInConfigurationFiles`** — Wrong format for class references in XML configs.
- **`Magento2.NamingConvention.ReservedWords`** — Using a PHP reserved word in a way Magento can't resolve.

### Templates / HTML

- **`Magento2.Html.HtmlSelfClosingTags`** — `<br />`, `<hr />`. Use HTML5 `<br>`, `<hr>` or proper close tags.
- **`Magento2.Html.HtmlClosingVoidTags`** — Closing tags on void elements (`</img>`).
- **`Magento2.Html.HtmlCollapsibleAttribute`** — Collapsible HTML attributes.

### Strings

- **`Magento2.Strings.ExecutableRegEx`** — Use of `e` modifier in `preg_*` (deprecated in PHP 7).

These categories cover the bulk of submissions that fail Code Sniffer. The complete sniff inventory is at `references/sources/magento-coding-standard/Sniffs/INDEX.md` — it's a flat list of every sniff class shipped by `Magento2/Sniffs/`. The full ruleset XML with per-rule severities is at `references/sources/magento-coding-standard/Magento2-ruleset.xml`.

## How to read the JSON report

The Marketplace JSON report (and the local `--report=json` output) has this shape:

```json
{
  "totals": {
    "errors": 12,
    "warnings": 47,
    "fixable": 23
  },
  "files": {
    "/path/to/Block/Form.php": {
      "errors": 3,
      "warnings": 5,
      "messages": [
        {
          "message": "$_POST is discouraged. Use Magento request object instead.",
          "source": "Magento2.Security.Superglobal.SuperglobalUsageError",
          "severity": 10,
          "fixable": false,
          "type": "ERROR",
          "line": 42,
          "column": 13
        }
      ]
    }
  }
}
```

Group by `source` to see which sniffs are failing most. Filter `severity >= 10` to see only blocking issues. The `fixable: true` entries can be auto-fixed with `phpcbf`.

## Auto-fix workflow

```bash
# First pass: auto-fix everything that's mechanically fixable.
vendor/bin/phpcbf --standard=Magento2 app/code/YourVendor/YourModule

# Re-run phpcs to see what's left.
vendor/bin/phpcs --standard=Magento2 --severity=10 app/code/YourVendor/YourModule

# Hand-fix the remaining errors using the source field to locate the docs/fix.
```

## Common severity-10 fixes (recipes)

### `Magento2.Security.XssTemplate.FoundUnescaped`

In a `.phtml`, this:

```php
<div><?= $block->getCustomMessage() ?></div>
```

Becomes:

```php
<?php /** @var \Magento\Framework\Escaper $escaper */ ?>
<div><?= $escaper->escapeHtml($block->getCustomMessage()) ?></div>
```

For attribute context: `escapeHtmlAttr()`. For JS: `escapeJs()`. For URLs in `href`: `escapeUrl()`. For inline CSS values: `escapeCss()`.

### `Magento2.Security.Superglobal.SuperglobalUsageError`

In a controller / block:

```php
$id = (int) $_GET['id'];   // ✗ severity 10
```

Becomes:

```php
public function __construct(
    \Magento\Framework\App\RequestInterface $request,
    ...
) {
    $this->request = $request;
}

$id = (int) $this->request->getParam('id');   // ✓
```

### `Magento2.Legacy.MageEntity`

```php
$config = Mage::getStoreConfig('catalog/frontend/list_mode');   // ✗
```

Becomes:

```php
public function __construct(
    \Magento\Framework\App\Config\ScopeConfigInterface $scopeConfig,
) {
    $this->scopeConfig = $scopeConfig;
}

$config = $this->scopeConfig->getValue(
    'catalog/frontend/list_mode',
    \Magento\Store\Model\ScopeInterface::SCOPE_STORE
);   // ✓
```

### `Magento2.SQL.RawQuery`

```php
$conn->query("SELECT * FROM sales_order WHERE customer_id = $customerId");   // ✗ severity 8 (warning, not blocking)
```

Severity 8 — not strictly blocking — but flagged in reports. Use `\Magento\Framework\DB\Sql\Expression` or a Collection / Repository.

### `Magento2.PHP.AutogeneratedClassNotInConstructor`

```php
public function doSomething()
{
    $factory = new \YourVendor\Module\Model\WidgetFactory(...);   // ✗
}
```

Becomes:

```php
public function __construct(
    \YourVendor\Module\Model\WidgetFactory $widgetFactory,
) {
    $this->widgetFactory = $widgetFactory;
}
```

### `Magento2.Legacy.InstallUpgrade`

If you ship a `Setup/InstallSchema.php` or `Setup/UpgradeSchema.php`, replace with `etc/db_schema.xml` + data/schema patches in `Setup/Patch/Data/` and `Setup/Patch/Schema/`. The legacy install/upgrade scripts haven't been valid since Magento 2.3 declarative-schema-mandatory.

### `Magento2.Html.HtmlSelfClosingTags`

```html
<br />          <!-- ✗ -->
<input type="text" name="x" />   <!-- ✗ -->
```

Becomes:

```html
<br>
<input type="text" name="x">
```

## Editor / CI integration

Add this CI step to GitHub Actions or your pipeline:

```yaml
- name: Run Magento Coding Standard
  run: |
    composer global require --dev squizlabs/php_codesniffer magento/magento-coding-standard
    PATH="$(composer global config bin-dir --absolute):$PATH"
    phpcs --config-set installed_paths "$(composer global config home)/vendor/magento/magento-coding-standard"
    phpcs --standard=Magento2 \
          --extensions=php,phtml \
          --error-severity=10 \
          --ignore-annotations \
          --report=json \
          --report-file=phpcs-report.json \
          ./
    test "$(jq '.totals.errors' phpcs-report.json)" = "0"
```

A failing CI build before submission saves a Marketplace rejection round-trip.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/code-sniffer.md`
- `references/sources/magento-coding-standard/README.md`
- `references/sources/magento-coding-standard/Magento2-ruleset.xml` (the canonical list of rules with per-rule severities)
- `references/sources/magento-coding-standard/Sniffs/INDEX.md` (flat list of every shipped sniff)
- https://developer.adobe.com/commerce/php/coding-standards/ (Adobe's high-level coding standards doc)
- https://github.com/magento/magento-coding-standard (live ruleset development)
