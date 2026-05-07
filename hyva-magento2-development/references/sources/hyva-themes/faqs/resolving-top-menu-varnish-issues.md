<!-- source: https://docs.hyva.io/hyva-themes/faqs/resolving-top-menu-varnish-issues.html -->

# Resolving top-menu Varnish issues

## When Varnish is wrongly configured

If you run into the issue:

```
Uncaught ReferenceError: initHeaderNavigation is not defined
```

check whether the HTML of the topmenu is actually being rendered, or if the source code of your page contains:

```
<esi:include src="http://[YOUR-DOMAIN]/page_cache/block/esi/blocks/[...]
```

If that is the case, Varnish is not configured correctly and you might want to double-check [The Magento Docs](https://experienceleague.adobe.com/en/docs/commerce-operations/configuration-guide/cache/varnish/config-varnish) for the right configuration settings and make sure your VCL file is correct (and loaded).

## When Blocks are wrongly configured

Only relevant for themes based on Hyvä 1.1.8 and older

Hyvä supports view models implementing the IdentityInterface to supply the cache tags for ESI blocks since release 1.1.9. Before this release, ESI cache tags had to be supplied by the block class, as described below.

To read more, please refer to the [view model cache tags documentation](../performance/view-model-cache-tags.html).

Any block defined in Layout XML with a `ttl` value set will be turned into a Varnish ESI include, meaning it will be loaded with a separate request by Varnish.

If the block class you’re using doesn't implement right methods, then the block won’t be rendered.

For instance:

```
<block name="topmenu"
       as="topmenu"
       template="Magento_Theme::html/header/topmenu.phtml"
       ttl="3600"
/>
```

Won’t work, because it will use the default `Magento\Framework\View\Element\Template` block class.

Requirements for a Varnish-capable block are:

1. Implement `IdentityInterface`:
   `class Topmenu extends Template implements Magento\Framework\DataObject\IdentityInterface {`
2. A public `getIdentities()` method
   This should work since the standard Topmenu block class meets those requirements:

   ```
   <block class="Magento\Theme\Block\Html\Topmenu"
          name="topmenu"
          as="topmenu"
          template="Magento_Theme::html/header/topmenu.phtml"
          ttl="3600"
   />
   ```

## When the top menu is sometimes missing styles

When inspecting the page source on such pages, an `<esi:include>` tag can be seen.
This reportedly can happen if Varnish is used for full-page caching in combination with Brotli compression.
The solution is to disable Brotli compression.
On Hypernode this can be done in the `varnish.webroot.conf` file.
