<!-- source: https://docs.hyva.io/hyva-themes/performance/block-html-full-page-caching.html -->

# Magento Block HTML and Full Page Caching

This document explains Magento's multi-layered caching architecture for Hyvä theme development. Magento uses four distinct caching layers (low-level cache, full page cache (FPC), Edge Side Includes (ESI) cache, and browser cache), each serving different purposes. Understanding how Block HTML caching, FPC cache tags, and cache invalidation work is essential for Hyvä theme developers implementing custom view models and ensuring proper cache clearing when data changes.

Magento's view layer caching presents a specific challenge for view models rendering database entities: view models cannot natively contribute cache tags to the Block HTML cache or FPC responses. This architectural limitation affects Hyvä theme development. The [View Model Cache Tags](view-model-cache-tags.html) documentation explains Hyvä's solution for associating cache tags with view models.

## Magento Caching Layers Overview

Magento employs four distinct caching layers, each serving different purposes and using different storage backends:

### Low-Level Cache

Stores configuration data, layout XML, EAV attribute definitions, and database query results. Typically backed by Redis or the file system. This cache operates within PHP and is cleared using `bin/magento cache:clean` or `bin/magento cache:flush`.

### Full Page Cache (FPC)

Caches complete HTML page responses. Production environments typically use Varnish or Fastly as a reverse proxy cache. Development environments may use Redis or file-based FPC. The FPC dramatically reduces server load by serving cached responses without the Magento application.

### Edge Side Includes (ESI) Cache

Enables caching of page fragments that can be assembled "at the edge" by a reverse proxy like Varnish. ESI allows static pages to include dynamic blocks (like the top menu) that are cached separately with a different Time-to-Live (TTL). ESI is only available with Varnish-compatible FPC backends.

### Browser Cache

The visitor's browser stores content locally, including static assets (JavaScript, CSS, images), Customer Section Data in localStorage, session cookies, and store view preferences. Browser cache behavior is controlled via HTTP headers and JavaScript.

These caching layers interact in complex ways, and understanding their relationships is critical for debugging cache-related issues.

## How Magento Cache Invalidation Works with Cache Tags

When data changes in Magento (a product is edited, a category is updated, etc.), the caching system must remove stale cached content. Magento uses cache tags to group related cache records so they can be invalidated together when the underlying data changes.

### Understanding Cache Tags and Tagged Records

Cache tags are string identifiers that associate cache records with the data they contain. A single cache record can have multiple cache tags, and a single cache tag can be associated with many cache records. This many-to-many relationship enables efficient cache invalidation.

For example, every cache record containing product 123 data is tagged with `cat_p_123`. When product 123 is edited, Magento invalidates all cache records with that tag across all caching layers, ensuring no stale product data is served.

### Cache Invalidation Strategies by Backend Type

Each caching backend handles tag-based cache invalidation differently due to their distributed nature and different storage mechanisms:

#### Low-Level Cache Invalidation

Cache tags are stored in a backend-dependent index that maps tags to cache record IDs. When invalidation occurs, records are deleted synchronously within the same PHP process that triggered the cache clean command.

#### Full Page Cache Invalidation

Full page cache invalidation behavior depends on the FPC backend configuration:

**Built-in FPC (Redis/File)**: Cache tags are stored via the `X-Magento-Tags` response header. Records are cleaned in-process like low-level cache records, with tag-to-record mappings maintained in the same backend.

**Varnish FPC**: Cache tags are specified via the `X-Magento-Tags` response header as a comma-separated list. During cache invalidation, Magento sends an HTTP PURGE request with an `X-Magento-Tags-Pattern` header containing a regex pattern. Varnish evicts all records whose tags match the pattern.

#### ESI Cache Invalidation

ESI cache records use the same `X-Magento-Tags` header mechanism as Varnish FPC. ESI fragments are stored within the Varnish cache alongside full page responses, so Varnish's tag-based PURGE mechanism invalidates both types of cached content.

#### Browser Cache Invalidation

Browser-stored content uses different invalidation strategies that don't rely on cache tags:

**Cookies**: Cleared server-side by setting the cookie value to `null` or setting an expiry date in the past.

**LocalStorage (Customer Section Data)**: Refreshed by incrementing the `private_content_version` cookie, which triggers Magento's JavaScript to detect the version change and fetch fresh customer section data.

**Static assets (JS, CSS, translations)**: Invalidated by changing the version hash in the URL path (e.g., `/static/version1234567890/`). When Magento deploys new static assets, the version hash changes, causing browsers to request the new versions.

Cache TTL Expiration

In addition to tag-based invalidation, most cache records have a TTL (time-to-live) after which the cache backend automatically discards them.

## Associating Cache Tags with Frontend Cache Records

This section focuses on frontend cache records relevant to Hyvä theme development: Block HTML cache, FPC records, and ESI records.

### Block HTML Cache Tags

Blocks are responsible for declaring the cache tags that should invalidate their cached HTML output. The `Magento\Framework\View\Element\AbstractBlock::getCacheTags()` method returns an array of cache tag strings that associate the block's rendered HTML with the data it contains.

Block subclasses can override `getCacheTags()` to add entity-specific tags (e.g., product or category tags). Alternatively, cache tags can be set programmatically by calling `$block->setCacheTags($tagsArray)` before rendering.

#### The View Model Cache Tag Problem

Magento's architectural guidance discourages custom block classes in favor of generic `Template` blocks with view models providing data. However, this creates a cache tag problem for Hyvä theme development: view models have no standard API to add cache tags to the block rendering them.

The workaround options are limited:

- Call `$block->setCacheTags()` from within the template
- Create a custom view model method that sets cache tags on the block
- Avoid using Block HTML cache and rely solely on FPC

This architectural limitation is why Magento core makes minimal use of Block HTML caching, preferring FPC for most caching needs. Hyvä solves this problem with [View Model Cache Tags](view-model-cache-tags.html), which allows view models to declare cache tags declaratively.

### Full Page Cache and ESI Cache Tags

Full page cache (FPC) and ESI cache tags use a different mechanism than Block HTML cache tags. Instead of the `getCacheTags()` method, blocks must implement `Magento\Framework\DataObject\IdentityInterface` with its single method `getIdentities()`.

All identities returned by blocks rendered on a page are aggregated into the `X-Magento-Tags` response header, which is sent to Varnish or Fastly. This enables the reverse proxy cache to invalidate the cached page when any associated entity changes.

#### The Same View Model Cache Tag Problem

The `IdentityInterface` must be implemented by block classes, not view models. Since generic `Template` blocks cannot implement custom interfaces, there is no way for view models to contribute cache tags to FPC responses in standard Magento architecture.

This architectural gap means pages using view models for data may not be properly invalidated when underlying data changes. Without proper FPC cache tags, stale data can be served from Varnish or Fastly even after the underlying entities (products, categories, CMS blocks) have been updated.

Hyvä's [View Model Cache Tags](view-model-cache-tags.html) feature solves this problem by allowing view models to implement `IdentityInterface` and automatically adding their tags to the `X-Magento-Tags` response header.

FPC Segmentation

Besides cache tags, FPC supports URL segmentation for serving different cached versions based on customer group, currency, or other context. This topic is outside the scope of this document. See this [blog post on FPC segmentation](https://www.zynovo.com/blog/magento-2-full-page-cache-segmentation/) for details.
