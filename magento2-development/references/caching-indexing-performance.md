# Caching, Indexing, and Performance

Magento has more cache types and more index types than any other PHP eCommerce framework — partly necessary (catalog of millions, EAV), partly historical baggage. Understanding what's cached, what's indexed, and what invalidates each is non-negotiable for both performance work and "my change isn't appearing" debugging.

## Cache types

`bin/magento cache:status` lists them:

```
Current status:
                        config: 1
                        layout: 1
                    block_html: 1
                   collections: 1
                    reflection: 1
                        db_ddl: 1
                compiled_config: 1
                           eav: 1
              customer_notification: 1
              config_integration: 1
        config_integration_api: 1
                full_page: 1
              config_webservice: 1
              translate: 1
                google_product: 1
                vertex: 1
```

The big ones:

| Type | What it caches | Cleared by |
| --- | --- | --- |
| `config` | Merged module configs (`di.xml`, `events.xml`, `module.xml`) | `cache:clean config` |
| `layout` | Merged layout XML per handle | `cache:clean layout` |
| `block_html` | Rendered block output (per identity key) | `cache:clean block_html`, save model, cache tag invalidation |
| `collections` | Some collection results that opt in | `cache:clean collections`, model save |
| `db_ddl` | DB schema introspection (column types, indexes) | `cache:clean db_ddl` (rare) |
| `compiled_config` | Generated DI compilation output | `cache:clean compiled_config`, `setup:di:compile` regenerates |
| `eav` | EAV attribute metadata | `cache:clean eav` |
| `full_page` | Page cache (whole rendered HTML pages) | FPC tag invalidation, save catalog entities, `cache:clean full_page` |
| `config_integration` / `config_integration_api` | Integration ACL maps | save Integration |
| `config_webservice` | `webapi.xml` merge, GraphQL schema cache | `cache:clean config_webservice` |
| `translate` | i18n CSVs | `cache:clean translate` |
| `target_rule` | (Adobe Commerce) Promo target rules | save catalog rule |
| `reflection` | PHP reflection metadata | rarely |

### Enabling/disabling individual cache types

```
bin/magento cache:enable layout block_html full_page
bin/magento cache:disable layout block_html full_page
```

In dev mode, disabling `layout`, `block_html`, `full_page`, and `translate` is common. Leave `config` and `config_webservice` on (or you'll wait 10 seconds per page).

### Clean vs flush

- `bin/magento cache:clean [type ...]` — invalidates specific cache types (their data is marked stale but persists until reread).
- `bin/magento cache:flush [type ...]` — empties the cache backend entirely (Redis/file/Varnish for FPC).

`cache:flush` without args clears everything including Redis/Memcached for ALL cache types (sometimes ALL applications using that Redis instance — be careful in shared Redis setups). Use `cache:clean` if you want surgical.

## Cache tags

Every cacheable thing in Magento gets **identity tags** — strings like `cat_p_42`, `cat_c_5`, `cms_b_homepage_promo`. When a product is saved, Magento invalidates all FPC entries (and `block_html` entries) tagged with that product's identity.

Tag conventions (incomplete list):

| Tag | Means |
| --- | --- |
| `cat_p` | All products |
| `cat_p_42` | Product 42 |
| `cat_c` | All categories |
| `cat_c_5` | Category 5 |
| `cms_p_3` | CMS page 3 |
| `cms_b_homepage` | CMS block `homepage` (by identifier) |
| `store` | Store config |
| `customer` | Customer entity (specific ID appended) |

When you save a model, its `getIdentities()` method returns the tags to invalidate:

```php
class Message extends \Magento\Framework\Model\AbstractModel implements \Magento\Framework\DataObject\IdentityInterface
{
    public const CACHE_TAG = 'acme_giftwrap_message';

    public function getIdentities(): array
    {
        return [self::CACHE_TAG . '_' . $this->getId()];
    }
}
```

Then in your block:
```php
class MessageBlock extends \Magento\Framework\View\Element\Template implements \Magento\Framework\DataObject\IdentityInterface
{
    public function getIdentities(): array
    {
        return $this->messageModel->getIdentities();
    }
}
```

Magento's render pipeline collects all `IdentityInterface` tags from blocks on a page and stamps them onto the FPC entry. Save the message → FPC entry invalidates → next request re-renders.

If your block renders dynamic content tied to a database entity and doesn't return identities, **FPC will serve stale HTML indefinitely**. Always implement `IdentityInterface`.

## Full Page Cache (FPC)

The `full_page` cache stores entire rendered HTML pages. Backed by:
- **Magento's built-in cache** (Redis / file / Memcached) — default, fine for small stores.
- **Varnish** — recommended for production. Configure in **Stores → Configuration → Advanced → System → Full Page Cache**. Generate VCL with `bin/magento varnish:vcl:generate-vcl` or copy from `var/`.

### What invalidates FPC

- Model `getIdentities()` tags on save.
- `bin/magento cache:flush full_page`.
- Direct PURGE to Varnish.

### Block caching

Add `cacheable="false"` to a block in layout XML to force a "hole punch" — the block is excluded from FPC and rendered per-request:

```xml
<block class="..." name="customer.greeting" cacheable="false"/>
```

Use sparingly — uncacheable blocks turn cached pages into uncached pages (the WHOLE page is not cached if it contains an uncacheable block). For customer-specific content, prefer **ESI** (configured automatically when Varnish is used + block declared as `_isScopePrivate`).

For ESI:
```php
class CustomerGreeting extends \Magento\Framework\View\Element\Template
{
    protected $_isScopePrivate = true;
}
```

This block is excluded from the FPC entry; the rendered page contains an `<esi:include>` placeholder; Varnish makes a separate request to render JUST that block. Customer-specific HTML, full-page cacheable rest.

### Customer-data sections — the better pattern

For most "show the customer's cart count / name" use cases, prefer **customer-data sections** over ESI. Customer-data is rendered client-side from `/customer/section/load/` and reflected via Knockout. The page itself stays fully cacheable. See `frontend-js-and-ui.md`.

## Indexers

Magento pre-computes data for performance: a category page wouldn't be fast if it had to JOIN 12 EAV tables per product on every request. Indexers materialize that data into flat tables.

Default indexers:

| Indexer | Materializes |
| --- | --- |
| `catalog_category_product` | category → product mapping |
| `catalog_product_category` | product → category (reverse) |
| `catalogrule_product` | which catalog rules apply per product |
| `catalogrule_rule` | which catalog rules are active |
| `catalogsearch_fulltext` | full-text search docs (sent to OpenSearch) |
| `cataloginventory_stock` | per-source stock aggregation (MSI) |
| `catalog_product_price` | computed prices per customer group / website |
| `customer_grid` | flattened customer admin grid table |
| `design_config_grid` | flat admin grid for design config |
| `targetrule_product_rule` (Commerce) | which target rules apply per product |
| `targetrule_rule_product` (Commerce) | reverse |
| `salesrule_rule` | active cart rules |

Run `bin/magento indexer:info` for the live list (varies per Commerce/Open Source).

### Indexer modes

```
bin/magento indexer:show-mode
```

Two modes per indexer:
- **Update on Save** — reindex happens synchronously whenever an entity is saved. Slows saves; index always fresh. Default in dev.
- **Update by Schedule (mview)** — saves enqueue a mview row; a cron job runs `bin/magento indexer:reindex` periodically (every minute) on the diff. Saves are fast; index has a small lag.

Switch:
```
bin/magento indexer:set-mode schedule catalog_product_price
bin/magento indexer:set-mode realtime catalog_product_price
```

**Production should be on schedule mode for all indexers** unless you have a specific reason. Otherwise admin saves get painfully slow.

### `mview.xml` — declarative changelog

`etc/mview.xml` declares which DB tables an indexer watches:

```xml
<config>
    <view id="catalog_product_price" class="Magento\Catalog\Model\Indexer\Product\Price" group="indexer">
        <subscriptions>
            <table name="catalog_product_entity_decimal" entity_column="entity_id"/>
            <table name="catalog_product_entity_tier_price" entity_column="entity_id"/>
        </subscriptions>
    </view>
</config>
```

When the indexer is in `schedule` mode, Magento creates DB triggers that write to a changelog table (`catalog_product_price_cl`) whenever the subscribed columns change. The cron processes the changelog.

If triggers are missing (common after restoring a DB dump without triggers), run:
```
bin/magento indexer:reset
bin/magento indexer:set-mode schedule <id>
```
…to recreate them. Or use `bin/magento queue:consumers:start` to leave realtime mode briefly.

### `indexer.xml` — declare a custom indexer

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Indexer/etc/indexer.xsd">
    <indexer id="acme_giftwrap_message" view_id="acme_giftwrap_message"
             class="Acme\GiftWrap\Model\Indexer\Message">
        <title translate="true">Gift wrap messages flat</title>
        <description translate="true">Flatten gift wrap messages into a search-friendly table</description>
        <fieldsets>
            <fieldset name="acme_giftwrap_message_source" provider="Acme\GiftWrap\Model\Indexer\Source">
                <field name="message" origin="message"/>
                <field name="order_id" origin="order_id"/>
            </fieldset>
        </fieldsets>
        <saveHandler class="Acme\GiftWrap\Model\Indexer\Save"/>
        <structure class="Acme\GiftWrap\Model\Indexer\Structure"/>
    </indexer>
</config>
```

The indexer class implements `\Magento\Framework\Indexer\ActionInterface` with `executeFull()`, `executeList(array $ids)`, `executeRow($id)`.

### Reindexing
```
bin/magento indexer:reindex                        # all indexers
bin/magento indexer:reindex catalog_product_price  # specific
bin/magento indexer:status                         # state of each
bin/magento indexer:reset                          # mark all invalid (forces full reindex on next run)
```

A full reindex on a large catalog (100k+ products) takes 30-60 minutes. Use queue-based incremental reindex (`mview`) for routine.

## OpenSearch / Elasticsearch

OpenSearch is the search engine on every supported line:
- OpenSearch 3 on 2.4.8+ (recommended on 2.4.9).
- OpenSearch 2.19 or 3 on the latest 2.4.6 / 2.4.7 patches.
- Elasticsearch 8 (`Magento_Elasticsearch8`) is still listed for 2.4.7 / 2.4.8, but not for 2.4.9. `Magento_Elasticsearch7` was deprecated in 2.4.7 (ES7 reached end-of-life in August 2023) and is gone from current code.

The `catalogsearch_fulltext` indexer pushes documents to the search engine.

Configure: **Stores → Configuration → Catalog → Catalog → Catalog Search**.

CLI:
```
bin/magento config:set catalog/search/engine opensearch
bin/magento config:set catalog/search/opensearch_server_hostname opensearch.local
bin/magento config:set catalog/search/opensearch_server_port 9200
bin/magento config:set catalog/search/opensearch_index_prefix magento2
```

`opensearch_enable_auth`, `opensearch_username`, `opensearch_password`, and `opensearch_server_timeout` sit under the same `catalog/search/` prefix. A store still on Elasticsearch 8 uses the equivalent `elasticsearch8_*` keys.

Inspect indexes:
```
curl http://opensearch.local:9200/_cat/indices?v
```

You should see `magento2_product_1`, `magento2_category_1`, etc.

### Search-Engine reindex
`bin/magento indexer:reindex catalogsearch_fulltext` rebuilds the index from scratch. Common after upgrading the engine, changing analyzers, or recovering from a corrupted index.

## Cache backends — Valkey / Redis, Memcached, file

**Valkey has replaced Redis on current releases.** It is a Redis-protocol-compatible fork. Valkey is *required* for cache on:
- 2.4.9
- patches after 2.4.5-p16, 2.4.6-p14, 2.4.7-p9, and 2.4.8-p4

Redis 7.2 is no longer supported on those patches. The `env.php` structure is the same as for Redis; only the backend name and the `setup:config:set` flags change:

```
bin/magento setup:config:set --cache-backend=valkey --cache-backend-valkey-server=127.0.0.1 --cache-backend-valkey-db=0
bin/magento setup:config:set --page-cache=valkey --page-cache-valkey-server=127.0.0.1 --page-cache-valkey-db=1
bin/magento setup:config:set --session-save=valkey --session-save-valkey-host=127.0.0.1 --session-save-valkey-db=2
```

These write the following into `env.php`:
- **2.4.9+**: `'backend' => 'valkey'`, the simplified name that runs on Symfony Cache.
- **Up to 2.4.8**: `'backend' => 'Magento\\Framework\\Cache\\Backend\\Valkey'`.
- **Session**: `'save' => 'valkey'`.

2.4.9 also replaced the Zend_Cache internals with `symfony/cache`. `cache:flush` and `cache:clean` behave the same, but custom code that extended Zend cache classes must move to Symfony cache adapters. On 2.4.9, phpredis is used when installed, with automatic fallback to Predis.

Older patches, and installs that predate the Valkey requirement, use the Redis form. Configure it in `app/etc/env.php`:

```php
'cache' => [
    'frontend' => [
        'default' => [
            'backend' => 'Magento\Framework\Cache\Backend\Redis',
            'backend_options' => [
                'server' => '127.0.0.1',
                'port' => '6379',
                'database' => '0',
                'compress_data' => '1',
                'compression_lib' => 'gzip'
            ],
            'id_prefix' => 'magento_'
        ],
        'page_cache' => [
            'backend' => 'Magento\Framework\Cache\Backend\Redis',
            'backend_options' => [
                'server' => '127.0.0.1',
                'port' => '6379',
                'database' => '1',
                'compress_data' => '0'
            ],
            'id_prefix' => 'magento_'
        ]
    ]
],
'session' => [
    'save' => 'redis',
    'redis' => [
        'host' => '127.0.0.1',
        'port' => '6379',
        'database' => '2',
        'timeout' => '2.5'
    ]
],
```

Three separate Redis/Valkey databases: `default` cache (db 0), FPC (db 1), session (db 2). Don't share databases — different eviction policies needed.

Use `bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=...` (or the `valkey` flags above) to write env.php for you.

## Performance checklist for production

1. **Mode: production** — `bin/magento deploy:mode:set production`.
2. **DI compilation** — `bin/magento setup:di:compile` ran on deploy.
3. **Static content deployed** — `bin/magento setup:static-content:deploy -f`.
4. **All cache types enabled** — `bin/magento cache:enable`.
5. **Indexers on schedule mode** — `bin/magento indexer:set-mode schedule --all`.
6. **Cron running** — `bin/magento cron:install` or systemd unit.
7. **Search engine** — OpenSearch running, indexed.
8. **PHP OPcache** — enabled, `opcache.validate_timestamps=0`, `opcache.memory_consumption=512+`.
9. **Valkey** (Redis on older patches) — cache, FPC, session moved off MySQL/file.
10. **Varnish** — in front of php-fpm for FPC. VCL from `bin/magento varnish:vcl:generate-vcl`.
11. **JS bundling/minification** — controversial; often disabled in HTTP/2 environments. Test before/after.
12. **CSS merge/minify** — usually on.
13. **Image optimization** — `bin/magento catalog:images:resize` after `view.xml` changes.
14. **HTTPS everywhere** — `bin/magento config:set web/secure/use_in_frontend 1 web/secure/use_in_adminhtml 1`.
15. **Database** — InnoDB buffer pool 70-80% of RAM, slow query log on.
16. **Cron consumers** — `cron_consumers_runner` in env.php for async/bulk and message queues.

## Common gotchas

### "I cleared cache but the change isn't showing"
- DI compilation needed (`bin/magento setup:di:compile`) — config changes don't propagate without it in production mode.
- Static content deploy needed for view/* changes.
- OPcache hasn't reloaded — `service php-fpm reload` or kill workers.
- Varnish still has the cached page — `varnishadm "ban req.url ~ /your/path"` or restart Varnish.
- Browser cache. Hard refresh.

### "Saves are taking 30 seconds"
- An indexer is in **realtime** mode and reindexing 10000 products synchronously. Switch to schedule.
- An observer is doing expensive work. Profile with Xdebug or New Relic.
- DB lock contention. Check `SHOW PROCESSLIST` while saving.

### "FPC serves stale content for hours"
- Your blocks don't implement `IdentityInterface`.
- A custom plugin sets `cacheable="false"` somewhere on the page, suppressing the cache entirely.
- Varnish purge isn't reaching Varnish — check the system config "Varnish Configuration" `Caching Application: Varnish Cache`, plus credentials/URLs.

### "Reindex hangs / never completes"
- A row in `cron_schedule` is stuck `running` — kill it.
- `MEMORY` engine table out of memory. Convert to InnoDB.
- DB deadlock — check `SHOW ENGINE INNODB STATUS`.
- For large catalogs, raise PHP `memory_limit` to 4G+ for the CLI.

### "Customer-data section doesn't refresh"
- The action URL in `sections.xml` doesn't match the actual URL.
- Custom section provider not registered in DI.
- Browser still has stale localStorage. Clear and reload.

### "I disabled `block_html` cache but pages are still cached"
FPC (`full_page`) caches whole pages. Disable that too in dev. `block_html` only matters when FPC is off.

### "Cache writes failing silently in Valkey / Redis"
- The server is full and `maxmemory-policy` is `noeviction` (default in both Valkey and Redis). Switch to `allkeys-lru` for cache databases, but NEVER for the session database.

### "Indexer:reindex throws OOM on large catalog"
- Raise CLI `memory_limit` (`php -d memory_limit=4G bin/magento indexer:reindex ...`).
- Use the message-queue async indexer (`amasty/magento2-async-indexer` or Magento's own queue consumers).

## Original sources

- `references/sources/commerce-php/development/cache/` — cache type guide.
- `references/sources/commerce-php/development/components/indexing/` — indexer architecture.
- `references/sources/devdocs-v2.4/extension-dev-guide/cache/` — older cache docs.
- `references/sources/devdocs-v2.4/extension-dev-guide/indexing.md` and `indexing-custom.md` — older indexer docs.
- `references/sources/commerce-php/development/backward-incompatible-changes/index.md` — 2.4.9 "Valkey 8.x CLI command" and "Zend_Cache replaced with symfony/cache"; 2.4.7 "Elasticsearch 7 deprecation".
- Valkey setup (not embedded): `AdobeDocs/commerce-operations.en` → `help/configuration/cache/valkey-pg-cache.md`, `valkey-session.md`.
- `references/sources/devdocs-v2.4/performance-best-practices/` — performance guide (essential reading).
- `references/sources/commerce-php/best-practices/` — best practices.
