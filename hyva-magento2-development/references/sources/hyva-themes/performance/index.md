<!-- source: https://docs.hyva.io/hyva-themes/performance/index.html -->

# Performance

Hyvä is designed to be fast. Compared to Luma it ships far less JavaScript and CSS, avoids render-blocking resources, and includes features like [Speculation Rules](speculation-rules.html) and [bfcache](bfcache.html) out of the box. That said, a well-performing store still requires deliberate decisions throughout the project.

This chapter covers how to measure performance accurately, how to improve Core Web Vitals, and how to apply Hyvä-specific optimizations.

## What is in this chapter

- [Hyvä Performance Tips](hyva-performance-tips.html): Hyvä-specific techniques covering images, Alpine.js, CSS, and DOM size.
- [Core Web Vitals](core-web-vitals.html): practical guidance on improving LCP, CLS, and INP scores for Hyvä storefronts.
- [Measuring Performance](measuring-performance.html): the right tools for lab data and real-world field data, from Lighthouse to RUM solutions.
- [Speculation Rules](speculation-rules.html): prefetching and prerendering pages for near-instant navigation.
- [Back-Forward Cache](bfcache.html): configuring bfcache for instant back and forward navigation.
- [Magento Block HTML and Full Page Caching](block-html-full-page-caching.html): how Magento's caching layers work and how to use them correctly in Hyvä.
- [View Model Cache Tags](view-model-cache-tags.html): enabling proper cache invalidation for view models.

## Recommended configuration

These settings require no code changes and have the highest performance impact relative to the effort involved. They are the foundation for everything else in this chapter.

### Enable Varnish full page cache

Magento's built-in full page cache works, but Varnish dramatically reduces Time to First Byte by serving cached responses without hitting PHP at all. On a warm cache, responses under 200ms are common.

Enable it in the Magento admin under `Stores → Configuration → Advanced → System → Full Page Cache → Caching Application`.

For cache tag invalidation and ESI support to work correctly, follow the [Magento Varnish configuration guide](https://experienceleague.adobe.com/en/docs/commerce-operations/configuration-guide/cache/config-varnish).

### Configure Redis for cache and session storage

File-based cache is the default and is fine for development, but Redis is significantly faster under production load. Configure it for both the default cache and session storage.

See the [Magento Redis configuration guide](https://experienceleague.adobe.com/en/docs/commerce-operations/configuration-guide/cache/redis/config-redis) for setup instructions.
