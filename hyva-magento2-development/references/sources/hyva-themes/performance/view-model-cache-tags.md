<!-- source: https://docs.hyva.io/hyva-themes/performance/view-model-cache-tags.html -->

# View Model Cache Tags for Proper Cache Invalidation

Hyvä extends Magento's cache tag system to enable view models to contribute cache tags for Full Page Cache (FPC) invalidation and Block HTML cache invalidation. This feature solves a critical limitation in Magento's architecture: standard Magento view models cannot add cache tags to page responses, causing pages to serve stale cached content when underlying data changes.

When Hyvä view models implement `IdentityInterface` and return cache tags from `getIdentities()`, Hyvä's `ViewModelRegistry` automatically collects those cache tags during page rendering and adds them to both the `X-Magento-Tags` response header (for FPC invalidation via Varnish) and Block HTML cache records. This ensures proper cache invalidation when products, categories, or other entities referenced by view models are updated.

This document explains how to implement cache tags in view models and how Hyvä's `ViewModelRegistry` handles automatic cache tag collection. Familiarity with [Magento Block HTML and Full Page Caching](block-html-full-page-caching.html) is recommended.

## The Problem: View Models Cannot Contribute Cache Tags

Hyvä themes use [View Models](../writing-code/working-with-view-models/index.html) extensively to provide data to templates. Templates access view models through the Hyvä `ViewModelRegistry`:

```
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
$productPriceViewModel = $viewModels->require(\Hyva\Theme\ViewModel\ProductPrice::class);
```

Standard Magento provides no mechanism for view models to add cache tags to page responses. This means pages using view models may not invalidate properly when underlying data changes.

## Hyvä's Solution: IdentityInterface for View Models

Hyvä's `ViewModelRegistry` enables view models to contribute cache tags by implementing `Magento\Framework\DataObject\IdentityInterface` — the same interface blocks use for FPC cache tags. Any view model that implements `IdentityInterface` can return cache tags from its `getIdentities()` method, and those tags are automatically added to page responses for proper cache invalidation.

### Implementing Cache Tags in a View Model

The following example shows a view model that returns cache tags for the current product. When a template uses this view model via `$viewModels->require()`, the product's cache tags are automatically collected and added to the page's cache records. When the product is modified in Magento admin, all cached pages using this view model are invalidated:

```
class CurrentProduct implements
    ArgumentInterface,
    \Magento\Framework\DataObject\IdentityInterface
{
    private $registry;

    public function __construct(\Magento\Framework\Registry $registry)
    {
        $this->registry = $registry;
    }

    /**
     * Return cache tags for the current product
     * Called automatically by Hyvä's ViewModelRegistry during page rendering
     */
    public function getIdentities(): array
    {
        $currentProduct = $this->registry->registry('current_product');

        // Delegate to the product's own cache tags if it implements IdentityInterface
        return $currentProduct instanceof IdentityInterface
            ? $currentProduct->getIdentities()
            : [];
    }
}
```

This example delegates to the product's own `getIdentities()` method, which returns tags like `cat_p_123` for product ID 123. You can also construct cache tags manually using Magento's cache tag patterns.

### Automatic Cache Tag Collection by ViewModelRegistry

When a template calls `$viewModels->require()` to instantiate a view model, the `ViewModelRegistry` checks if the view model implements `IdentityInterface`. If so, the view model is registered for cache tag collection. Later, when Magento finalizes the page response, the view model's `getIdentities()` method is called and its return values are automatically added to the page response's `X-Magento-Tags` header (for FPC invalidation via Varnish) and to Block HTML cache records.

## Technical Implementation Details

Internal Documentation

The following content documents Hyvä's internal implementation of view model cache tag collection. Understanding these details is not required to use view model cache tags — simply implement `IdentityInterface` on your view models and return cache tags from `getIdentities()`.

### How ViewModelRegistry Collects Cache Tags

When `ViewModelRegistry::require()` instantiates a view model, it calls `Hyva\Theme\Model\ViewModelCacheTags::collectFrom($viewModel)` to register view models that implement `IdentityInterface`. The `ViewModelCacheTags` class stores references to these view models in memory and provides a `get()` method to retrieve all collected cache tags when the page response is finalized.

This registration happens during page rendering, so all view models instantiated via `$viewModels->require()` throughout the entire page render are tracked for cache tag collection.

### Lazy Evaluation of getIdentities() Method

View model cache tags are collected lazily — `getIdentities()` is not called until the response is being finalized by Magento. This lazy evaluation is important because some view models accumulate data progressively during rendering rather than loading all data upfront.

For example, the Navigation view model builds its cache tag list incrementally as it traverses the category tree during menu rendering. Calling `getIdentities()` too early would return incomplete cache tags, missing categories loaded later in the render process. Lazy evaluation ensures all view model data is fully loaded before cache tags are collected.

### Supported Cache Configurations

The view model cache tag system works correctly in all cache configurations:

- FPC only (Varnish or built-in)
- Block HTML cache only
- Both FPC and Block HTML cache enabled simultaneously

### Adding View Model Cache Tags to Page Responses

For standard page requests, Hyvä injects `Hyva\Theme\Block\ViewModelCacheTagsBlock` into every page via the `before.body.end` container in the `hyva_default` layout handle. This special block renders no visible output but implements `IdentityInterface` to participate in Magento's cache tag collection process.

When Magento collects block identities for the `X-Magento-Tags` response header during page response finalization, it calls `getIdentities()` on all blocks including `ViewModelCacheTagsBlock`. This block's `getIdentities()` method returns all cache tags collected from view models during page rendering, effectively merging view model cache tags into the page response's cache tag list.

Debugging Cache Tags in Developer Mode

In developer mode, `ViewModelCacheTagsBlock` renders an HTML comment listing all view model cache tags. Check the HTML source near `</body>` to verify correct cache tag propagation.

### Adding View Model Cache Tags to ESI Responses

ESI (Edge Side Includes) requests require special handling for view model cache tags because ESI content may be served from Block HTML cache without instantiating view models. Hyvä uses different strategies depending on whether the ESI block is also cached in Block HTML cache.

#### ESI Without Block HTML Cache

When ESI content is not cached in Block HTML cache, view model cache tags are added normally. Magento instantiates view models when rendering the ESI block, Hyvä's `ViewModelRegistry` collects their cache tags, and the tags are added to the ESI response's `X-Magento-Tags` header.

#### ESI With Block HTML Cache (Double-Cached Blocks)

When content is cached in both ESI cache and Block HTML cache (like the navigation menu), the Block HTML cache serves the ESI response directly without instantiating view models. Without special handling, no view model cache tags would be included in the ESI response, causing improper cache invalidation.

Hyvä solves this double-caching scenario with a two-part mechanism:

**Tag Storage During First Render**: A plugin on `Layout::getOutput()` identifies blocks cached in both the ESI and Block HTML cache. It stores their view model cache tags in a separate Block HTML cache record associated with the block's cache key.

**Tag Retrieval for ESI Responses**: The plugin `Hyva\Theme\Plugin\PageCache\AddViewModelCacheTagsToEsiResponse` on `Magento\PageCache\Controller\Block\Esi` retrieves the stored cache tags from the Block HTML cache record and adds them to the ESI response's `X-Magento-Tags` header.

This two-part mechanism ensures proper cache invalidation even when ESI content is served from Block HTML cache without view model instantiation.
