# MFTF Tests, Installation + Varnish Tests, and Extension Footprint

EQP runs three different categories of behavioral tests against every submission: Installation + Varnish, MFTF Magento-supplied, and MFTF Vendor-supplied. Plus an informational Extension Footprint analyzer. This reference covers what each does, what infrastructure they assume, how to reproduce them locally, and how to ship MFTF tests with your extension that EQP can run.

## Installation + Varnish tests

### What they do

Spin up a clean Magento 2 instance for each combination of (claimed Magento version, claimed PHP version), `composer require` your package, run the full deployment cycle, then verify cacheable pages still cache through Varnish.

The full cycle, in order:

1. `composer require yourvendor/your-package:version` against `repo.magento.com`.
2. `bin/magento setup:upgrade`.
3. `bin/magento setup:di:compile`.
4. `bin/magento setup:static-content:deploy -f`.
5. `bin/magento deploy:mode:set production`.
6. `bin/magento indexer:reindex`.
7. Hit cacheable storefront pages (product, category) with HTTP requests through Varnish.
8. Verify each response includes `X-Magento-Cache-Debug: HIT` on second request (i.e., Varnish actually cached it).
9. Edit a product, hit it again, verify the cache invalidated and now reflects the edit.

### Required?

**Yes** for extensions, themes, language packs, metapackages. Not for App Builder apps (only limited installation testing on the app side).

### What makes it fail

| Symptom | Common cause |
| --- | --- |
| `composer require` fails | Package Verification didn't catch a dep issue; Magento can't resolve your constraints |
| `setup:upgrade` fails | Broken `db_schema.xml`, missing patch dep, broken events.xml |
| `setup:di:compile` fails | Cyclic DI, unresolved Proxy / Factory targets, invalid type config in `di.xml` |
| `setup:static-content:deploy` fails | Broken LESS, broken `requirejs-config.js`, invalid layout XML referencing missing block |
| `deploy:mode:set production` fails | Code generation can't write under `generated/`, or upstream step left state behind |
| `indexer:reindex` fails | Your custom indexer throws; or a `mview` declaration is malformed |
| Cacheable page returns `MISS` on second request | Your block declared `cacheable="false"` in layout XML, breaking FPC |
| Edit doesn't invalidate cache | Your model doesn't emit the right cache-tag identities |

### Local reproduction

Use [Magento Cloud Docker](https://github.com/magento/magento-cloud-docker):

```bash
git clone https://github.com/magento/magento-cloud-docker.git
# Follow cloud-docker readme; pick the docker-compose for your target Magento version & PHP.
docker compose up -d

# Wait for services. Then:
docker compose exec cli composer require yourvendor/your-module:1.2.0
docker compose exec cli bin/magento setup:upgrade
docker compose exec cli bin/magento setup:di:compile
docker compose exec cli bin/magento setup:static-content:deploy -f en_US
docker compose exec cli bin/magento deploy:mode:set production
docker compose exec cli bin/magento indexer:reindex

# Check caching:
curl -I http://magento.docker/some-product.html | grep -i cache
# Second request should show: x-magento-cache-debug: HIT
```

Repeat for each Magento × PHP combination you claim. The cloud-docker stack lets you swap by changing the docker-compose `image` references.

### Common cache-related failures (and fixes)

**`cacheable="false"` on a wrapping container**:

```xml
<!-- view/frontend/layout/catalog_product_view.xml -->
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      cacheable="false">    <!-- ← kills FPC for the entire product view page -->
    ...
</page>
```

This declaration tells Magento "this page can't be cached"; Varnish stops caching the route. EQP rejects it because cacheable pages must remain cacheable. Fix: remove the `cacheable="false"`, and use **ESI** or **private content** (sections.xml / customer-data.js) for blocks that legitimately need per-user content. See `references/sources/devdocs-v2.4` (if loaded via the `magento2-development` skill) for FPC architecture.

**A block emits no cache tags, so edits don't invalidate**:

```php
class CustomBlock extends \Magento\Framework\View\Element\Template
{
    // no getIdentities() — Varnish has no way to know when to flush this block
}
```

Fix: implement `\Magento\Framework\DataObject\IdentityInterface` and return product / category / CMS identities from `getIdentities()`.

## MFTF Magento-supplied tests

### What they do

Run Adobe's standard MFTF (Magento Functional Testing Framework) suite — the same one Magento core uses — with your extension installed. Tests run in a real browser via Selenium against a fresh Magento install.

### Required?

**Yes** for extensions. Not for themes/language packs/metapackages/apps.

### What makes it fail

Your extension breaks a core flow that Magento's own tests rely on. Common failures:

- A plugin on `\Magento\Catalog\Model\Product::save()` throws on Magento's test product fixtures.
- An observer on `customer_register_success` reads a field the test fixture doesn't set.
- A layout XML override deletes / renames a button that core MFTF tests click.
- A new admin route conflicts with an existing route.
- A `system.xml` config breaks the System Configuration screen.

### Local reproduction

```bash
# In a Magento 2 dev install (developer mode, with your extension):
vendor/bin/mftf build:project
vendor/bin/mftf generate:tests --remove
vendor/bin/mftf run:group default
```

To run a specific MFTF group (the EQP standard one is `default`):

```bash
vendor/bin/mftf run:group default --remove --debug
```

The `--debug` flag preserves screenshots and full Codeception output on failure. Use it to diagnose locally.

### Best practices to avoid breaking core MFTF

- **Plugins are defensive.** Check the arguments your plugin receives match the expected type *before* doing anything destructive.
- **Observers are defensive.** Same — check the event data before acting on it.
- **Layout overrides are minimal.** Don't `<referenceBlock remove="true">` core blocks unless you have to.
- **Test against the same MFTF version EQP runs** (3.0+).
- **Don't ship code that conflicts with core entity types** (e.g., a new product type with the same code as `simple`).

## MFTF Vendor-supplied tests

### What they do

Run any MFTF tests you ship in `Test/Mftf/` (note: singular `Test`, not plural `Tests`).

### Required?

**Not required to pass currently.** Adobe runs them and reports results but doesn't block publication on failure. This may change in the future.

### Directory structure

```
your-module/
└── Test/
    └── Mftf/
        ├── ActionGroup/
        │   └── YourVendorAwesomeActionGroup.xml
        ├── Data/
        │   └── YourVendorAwesomeData.xml
        ├── Page/
        │   └── YourVendorAwesomePage.xml
        ├── Section/
        │   └── YourVendorAwesomeSection.xml
        └── Test/
            └── YourVendorAwesomeFeatureTest.xml
```

### Constraints

- **MFTF version**: 3.0 or greater. Older MFTF tests won't be run.
- **Magento version**: 2.4.0+.
- **Path**: `Test/Mftf/` exactly — not `Tests/Mftf/`, not `Test/MFTF/`, not `test/mftf/`.
- **Test names must not collide** with existing Magento test names. Prefix with your vendor.
- **No hardcoded credentials.** Use `vendor/bin/mftf set:credentials` and reference `{{_CREDS.<key>}}`.
- **If you extend or merge into a Magento test**, your `composer.json` must `require` the Magento module that defines the test (or its dev-dependency).
- **A `Test/README.md`** is encouraged to explain setup steps or caveats. EQP reviewers don't read it, but Manual QA might.

### Example test

```xml
<!-- Test/Mftf/Test/YourVendorAwesomeFeatureTest.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<tests xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="urn:magento:mftf:Test/etc/testSchema.xsd">
    <test name="YourVendorAwesomeFeatureTest">
        <annotations>
            <stories value="Awesome Feature"/>
            <title value="Verify Awesome Feature configures and renders"/>
            <description value="Tests the basic configure→storefront flow."/>
            <severity value="CRITICAL"/>
            <group value="awesome"/>
        </annotations>
        <before>
            <createData entity="SimpleProduct2" stepKey="createProduct"/>
        </before>
        <after>
            <deleteData createDataKey="createProduct" stepKey="deleteProduct"/>
        </after>
        <amOnPage url="{{StorefrontHomePage.url}}" stepKey="goToStorefront"/>
        <see selector="{{StorefrontHomePageSection.welcomeText}}" userInput="Welcome" stepKey="seeWelcome"/>
    </test>
</tests>
```

### Local reproduction

```bash
vendor/bin/mftf generate:tests YourVendorAwesomeFeatureTest --remove
vendor/bin/mftf run:test YourVendorAwesomeFeatureTest --debug
```

### Reading the EQP MFTF report

The Developer Portal returns:

- A simplified pass/fail per test.
- The full Allure XML results, downloadable as an artifact.

To view the Allure report locally:

```bash
# After running MFTF locally
vendor/bin/mftf generate:tests
vendor/bin/mftf run:test YourVendorAwesomeFeatureTest
# Open the Allure report
allure serve dev/tests/acceptance/tests/_output/allure-results
```

(Allure CLI from https://docs.qameta.io/allure/.)

The EQP-side Allure output downloads as a zip; unzip and `allure serve` against it.

## Extension Footprint analysis

### What it does

Static analyzer (beta) that reports counts of:

- **Programmatic API and data interfaces** — number of `*Interface.php` service contracts you ship.
- **Web API** — REST and SOAP endpoints declared in `webapi.xml`.
- **GraphQL** — GraphQL queries / mutations / types declared in `schema.graphqls`.

The numbers appear on the listing detail page in the Quality Report section, helping merchants estimate the surface area of the extension.

### Required?

**No.** Pure informational. Cannot fail.

### Notes

- Beta — Adobe documents that "some of the information may not be completely accurate or present at all."
- Beta status is also indicated on the product listing page.

You can't reproduce the analyzer locally (Adobe hasn't open-sourced it). Just be aware your listing will show counts derived from your code.

## Test coverage as a marketing signal

The Additional Details checkbox **Test coverage supported** is the only way to surface, on the marketing side, that you've tested your extension. Checking it falsely is flagged during marketing review if your `Test/` directory is empty or trivial.

Real test coverage adds value in two places:

1. EQP's MFTF Vendor-supplied check actually runs your tests.
2. Marketing review reads "Test coverage supported" as a quality signal.

A handful of MFTF Vendor tests covering your extension's happy paths is the highest-leverage testing investment.

## Local CI integration

A complete pre-submission CI pipeline:

```yaml
# .github/workflows/marketplace-precheck.yml
name: Marketplace pre-check
on: [push]
jobs:
  precheck:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        magento: [2.4.7, 2.4.8, 2.4.9]
        php:     [8.1, 8.2, 8.3]
    steps:
      - uses: actions/checkout@v4
      - name: phpcs Magento2 severity-10
        run: |
          composer global require squizlabs/php_codesniffer magento/magento-coding-standard
          PATH="$(composer global config bin-dir --absolute):$PATH"
          phpcs --config-set installed_paths "$(composer global config home)/vendor/magento/magento-coding-standard"
          phpcs --standard=Magento2 \
                --extensions=php,phtml \
                --error-severity=10 \
                --ignore-annotations \
                --report=json \
                --report-file=phpcs.json \
                ./
          test "$(jq '.totals.errors' phpcs.json)" = "0"
      - name: composer validate
        run: composer validate --no-check-publish
      - name: Magento Cloud Docker install test
        run: |
          # Pull the cloud-docker images for matrix.magento and matrix.php
          # docker compose up
          # composer require .
          # bin/magento setup:upgrade && setup:di:compile && deploy:mode:set production
          # (full sequence)
```

The MFTF and Varnish checks are harder to wire into CI (they need a full Magento instance with Varnish in front), but the static checks — phpcs and composer validate — are cheap and catch the majority of EQP rejections.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/installation-and-varnish-tests.md`
- `references/sources/commerce-marketplace/guides/sellers/mftf-magento.md`
- `references/sources/commerce-marketplace/guides/sellers/mftf-vendor.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-footprint.md`
- https://developer.adobe.com/commerce/testing/functional-testing-framework/ (the official MFTF doc)
- https://developer.adobe.com/commerce/testing/functional-testing-framework/test-writing/best-practices
- https://github.com/magento/magento-cloud-docker (the canonical local test environment)
