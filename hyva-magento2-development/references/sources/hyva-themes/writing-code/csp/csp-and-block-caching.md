<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/csp-and-block-caching.html -->

# CSP & block\_html Cache

If `unsafe-inline` is excluded from the `script-src` CSP policy, blocks with scripts cached in the `block_html` cache can cause issues.
This is also true for cached blocks where the inline script is rendered by a child block.

How the issue materializes depends on whether the page is cached in the full-page cache.

## Uncached pages

On pages excluded from the full-page cache, a `nonce` attribute is injected into all registered `<script>` tags.
However, the value of the nonce attribute has to be different for every request.

On the request during which the block output is generated and written to the `block_html` cache, all works. The script tag contains the correct `nonce`.

However, on subsequent requests to the page, the cached record of the block will be used, but the nonce in the cached HTML will not match the nonce for the current request, so the script will not be executed by the browser.

Disabling the Full Page Cache

Disabling the full page cache will cause these errors due to invalid nonces from scripts cached in the `block_html` cache to occur on **all pages**. If you are using strict CSP for the full site, be sure to keep the full page cache enabled, or disable the `full_page` cache **and** the `block_html` cache.

## Cached pages

On pages cached in the full-page cache, the SHAs of all registered scripts are added to the CSP HTTP header.

If a block is not stored in the `block_html` cache when the page is rendered, the script is registered, the SHA is added to the header, and everything works.

On subsequent requests, as long as the page is served from the full-page cache, the SHAs are returned together with the page content, and all is well.

However, if the block is already stored in the `block_html` cache before the cached page is rendered, the inline script will not be registered.
In this scenario, the SHA will be missing from the CSP header.

This scenario happens frequently when a cached block is used on both pages included and excluded from the full-page cache.

The only solution is to exclude scripts from the blocks cached in the `block_html` cache.
Excluding the whole block from the `block_html` cache is the fastest solution, however, it does mean the block content will be generated on every page request.
If that is too resource-expensive, extracting the script from the cached block into a separate template block that isn't cached maintains the scalability benefits of the `block_html` cache while also resolving the problem.

## What causes a block to be cached in the `block_html` cache?

A block with a `cache_lifetime` data record that is not `false` or `null` will be cached (where a value of `0` means the cache record will never expire).
Often the value is set with layout XML, but it can also be set in the block class or even in the template. For example

```
<block name="example" template="Magento_Theme::block-with-a-script.phtml">
    <arguments>
        <argument name="cache_lifetime" xsi:type="string">3600</argument>
    </arguments>
</block>
```

## Excluding a block from the `block_html` cache on uncached pages

This can be done by setting the `cache_lifetime` data record to `false`.
This has to be done on the same level, where it is set in the first place (that is, layout XML, the block class, or the template).

To expand on the example from above, in a layout handle for the uncached page, the block cache could be deactivated with

```
<referenceBlock name="example">
    <arguments>
        <argument name="cache_lifetime" xsi:type="boolean">false</argument>
    </arguments>
</referenceBlock>
```

In PHP, determining if the page will be stored in the full page cache can be done via the layout instance using `$this->layout->isCacheable()`.

## The top-menu navigation block

One such cached block that is used on all pages is the top menu.
If you have custom uncached pages in your store, be sure to exclude it from the `block_html` cache on those routes using.

```
<referenceBlock name="topmenu_generic">
    <arguments>
        <argument name="cache_lifetime" xsi:type="boolean">false</argument>
    </arguments>
</referenceBlock>
```
