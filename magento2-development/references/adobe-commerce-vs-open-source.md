# Adobe Commerce vs Magento Open Source

Adobe Commerce (formerly **Magento Commerce** / **Magento Enterprise Edition**) is the paid, closed-source-extending version of Magento Open Source (formerly **Magento Community Edition**). The PHP framework, DI container, layout engine, EAV, and Web API are **identical** between editions. What's different is the bundle of extra modules shipped with Adobe Commerce.

A third tier — **Adobe Commerce on Cloud** — is Adobe Commerce + managed infrastructure (AWS via Adobe Cloud Manager, ECE-Tools, GitHub-style git-push deploys).

Before answering anything that depends on commerce-only features, **confirm the edition**.

## Quick detection

| Check | Magento Open Source | Adobe Commerce |
| --- | --- | --- |
| `composer.json` requires | `magento/product-community-edition` | `magento/product-enterprise-edition` |
| `bin/magento info:adminuri` | (same) | (same) |
| `vendor/magento/` directory contains | `module-catalog-rule`, `module-catalog`... | Same + `module-customer-segment`, `module-target-rule`, `module-banner`, `module-staging`, `module-company`, etc. |
| Admin > System > Configuration > Advanced > System | "Magento Open Source" branding | "Adobe Commerce" / Enterprise branding |
| In code: `if (class_exists('Magento\\TargetRule\\...'))` | false | true |

```bash
# Programmatic check
composer show magento/product-enterprise-edition 2>/dev/null && echo "Adobe Commerce" || echo "Open Source"
```

## Commerce-only modules

These ship ONLY with Adobe Commerce:

### Marketing & merchandising
- `Magento_TargetRule` — related-products / cross-sell / upsell driven by rules.
- `Magento_VisualMerchandiser` — drag/drop category product sort with rules.
- `Magento_Banner` — admin-managed banners (used by promotions, content blocks).
- `Magento_CustomerSegment` — define dynamic customer segments by attributes/behavior.
- `Magento_RewardPoints` (sometimes `Magento_Reward`) — points/redemption system.
- `Magento_GiftRegistry` — wedding registries.
- `Magento_GiftCard` — gift card products (Open Source has gift messages but not gift cards as products).
- `Magento_GiftWrapping` — gift wrap during checkout.
- `Magento_AdvancedCheckout` — admin-side order placement on behalf of customers ("Sell").
- `Magento_Invitation` — invite-friend campaigns.
- `Magento_ScalableInventory` — additional inventory tracking.
- `Magento_PromotionPermissions` — granular per-role access to promotions.

### Content
- `Magento_PageBuilder` — Page Builder is now Open Source as of 2.4.3 BUT some content types (Banner Slider with dynamic blocks, etc.) are still Commerce-only.
- `Magento_CmsStaging` — staged CMS content (preview future versions).
- `Magento_Staging` — schedule changes to products, categories, CMS pages.

### B2B (Adobe Commerce + the B2B module set)
- `Magento_Company` — company customer accounts (hierarchical).
- `Magento_NegotiableQuote` — request-for-quote workflow.
- `Magento_PurchaseOrder` — approval workflows for B2B orders.
- `Magento_RequisitionList` — saved shopping lists.
- `Magento_SharedCatalog` — different catalogs/prices per company.
- `Magento_CompanyCredit` — company line-of-credit.
- `Magento_QuickOrder` — bulk order entry by SKU.

### Operations / admin
- `Magento_Logging` — admin action audit log.
- `Magento_LoginAsCustomer` (partial overlap — Open Source has the basic version; Commerce has admin extensions).
- `Magento_Support` — Adobe support panel.
- `Magento_ScheduledImportExport` — schedule import/export jobs.

### Catalog
- `Magento_RmaSet` — return-merchandise-authorization workflows.
- `Magento_Rma` — RMA itself.
- `Magento_AdvancedRule` — extra rule conditions for promos.
- `Magento_AdvancedCatalog` — advanced catalog features.
- `Magento_CatalogPermissions` — per-customer-group category visibility/pricing visibility.
- `Magento_PricePermissions` — per-role pricing edit permissions.

### Sales
- `Magento_SalesArchive` — auto-archive old orders to a separate table.
- `Magento_AdminGws` — admin global website scope restrictions.

### Indexing & search
- `Magento_QuickOrder`, `Magento_Elasticsearch` Commerce-tuned variants.

### Cloud-only (only with Adobe Commerce on Cloud)
- `magento/ece-tools` — Cloud deployment scripts.
- `magento/magento-cloud-patches` — Adobe's curated patch bundle.
- `magento/cloud-docker` — local Docker dev images mirroring Cloud.

## Functional gaps in Open Source

Things Adobe Commerce can do that Open Source cannot:

- **Customer segments** — "all customers who bought >$500 in past 90 days." Open Source has only static customer groups.
- **Targeted promotions** — promo rules that apply only to a segment.
- **Scheduled content / staging** — schedule a product price change, CMS page swap, category visibility for a future date. Open Source can't (without third-party modules).
- **Targeted related products** — rules-driven cross-sell. Open Source has only manual cross-sell.
- **Gift cards** — Open Source doesn't have them.
- **B2B features** — companies, quotes, requisition lists, purchase orders, shared catalogs. None in Open Source.
- **Reward points** — Open Source needs a third-party module.
- **RMAs** — Open Source needs third-party.
- **Visual Merchandiser** — drag/drop category sort with rules. Open Source has only manual sort.
- **Page Builder dynamic blocks** — Banner with customer-segment targeting. Page Builder itself is Open Source, but the "dynamic block" content type is Commerce.

## Cloud-specific concerns

Adobe Commerce on Cloud adds operational constraints. If the user is on Cloud:

### Read-only file system in production
You CAN'T write to most of the filesystem at runtime. Only these paths are writable:
- `pub/media/`
- `pub/static/` (with `--read-only-file-system` flag, only `pub/static/_cache/` is writable during build)
- `var/`
- `app/etc/` for `env.php` only during deploy
- Mounts declared in `.magento.app.yaml`

Custom modules that try to write logs/data to `app/code/Vendor/...` will fail.

### `.magento.app.yaml` and `.magento.env.yaml`

Two YAML files at repo root configure Cloud:
- `.magento.app.yaml` — PHP version, extensions, hooks, cron schedule, mounts, relationships (services like RabbitMQ, Redis, OpenSearch).
- `.magento.env.yaml` — build/deploy stage settings (which static deploy strategy, skip steps, scope locales).
- `.magento/services.yaml` — service definitions (Redis version, MySQL version).
- `.magento/routes.yaml` — domain routing.

After editing, push to trigger a re-deploy.

### ECE-Tools deploy flow

Cloud's `magento-cloud` CLI runs:
1. **build** — `composer install`, `setup:di:compile`, static deploy. Runs in a build container.
2. **deploy** — file sync, `setup:upgrade`, `app:config:import`, cache flush.
3. **post-deploy** — warm caches.

You customize via `.magento.env.yaml`:
```yaml
stage:
  deploy:
    CACHE_CONFIGURATION:
      _merge: true
      frontend:
        default:
          backend_options:
            server: ${CACHE_BACKEND_SERVER}
    SCD_STRATEGY: compact
    SCD_THREADS: 4
```

### Git-push deploys

```
magento-cloud environment:branch new-feature
git push -u origin new-feature
```

Branch push triggers a build. Each branch is its own environment (`new-feature.<hash>.magentosite.cloud`).

### `magento-cloud` CLI quick reference
```
magento-cloud environments
magento-cloud env:checkout <env>
magento-cloud env:redeploy
magento-cloud db:dump          # download DB to local
magento-cloud db:sql           # interactive SQL
magento-cloud ssh
magento-cloud var:set MAGENTO_ENV_VARIABLE_NAME value
```

### Disabling code in production
`bin/magento module:disable` requires writing to `app/etc/config.php` — which is committed. In Cloud, disable modules by:
1. Editing `app/etc/config.php` locally.
2. Committing.
3. Pushing.

Not via the CLI on the live environment.

## Patches

Adobe ships **security patches** for both Open Source and Adobe Commerce. Cloud merchants apply them via the `magento/magento-cloud-patches` and `magento/quality-patches` Composer packages — `composer install` pulls the latest curated set.

For on-prem stores:
```
composer require magento/quality-patches
bin/magento setup:upgrade
```

Quality Patches has a CLI to apply individual fixes from Adobe's patch repository:
```
vendor/bin/magento-patches:apply MDVA-12345
```

## Pricing and licensing

- Open Source — free, MIT-style (Open Source License — actually a custom OSL 3.0).
- Adobe Commerce — annual license based on GMV (gross merchandise value) tier.
- Adobe Commerce on Cloud — license + infrastructure cost.

When a customer says "Magento Enterprise," they mean Adobe Commerce (legacy name).

## When `class_exists` checks matter

If your module wants to integrate with a Commerce-only feature optionally (e.g., extend Target Rules if installed), DON'T add it to `composer.json` `require`. Instead:

```php
if (class_exists(\Magento\TargetRule\Model\Rule::class)) {
    // use the Commerce class
}
```

And gate any `<sequence>` references behind a separate optional composer dependency. Magento's own modules do this — `Magento_CatalogStaging` extends Catalog only if Staging is installed.

## Common gotchas

### Module references a Commerce class, breaks on Open Source
Wrap in `class_exists` / `interface_exists`. Or split the module into two: `Acme_ProductDirectory` and `Acme_ProductDirectoryCommerce`. The Commerce variant has `Magento_Staging` in `composer.json` and `module.xml` `<sequence>`.

### Cloud build fails on local-only Composer plugins
Some Composer plugins try to write to the filesystem during install. On Cloud build phase, the FS is writable in `vendor/` but read-only elsewhere. Audit plugins for writes outside `vendor/`.

### Staging changes lost after deploy
On Cloud, `app/etc/env.php` is sometimes regenerated per-deploy from environment variables. If you set staging-only config there, it disappears. Use `MAGE_CLOUD_VARIABLES` or Cloud-specific env vars.

### Customer segment doesn't apply after creating
- Segments are re-evaluated on schedule (`magento_customer_segment_reindex` cron).
- Customer must have refreshed the page since being re-evaluated.
- Cache: `bin/magento cache:clean target_rule customer_segment`.

### B2B company users see Open Source-style customer account
- `Magento_Company` module is disabled.
- B2B features not enabled in **Stores → Configuration → General → B2B Features**.

## Original sources

- `references/sources/commerce-php/module-reference/` — every Magento module (Open Source AND Adobe Commerce) listed and documented.
- `references/sources/devdocs-v2.4/b2b/` — B2B development guide.
- `references/sources/devdocs-v2.4/inventory/` — MSI (multi-source inventory).
- `references/sources/devdocs-v2.4/release-notes/` — release notes per version per edition.
