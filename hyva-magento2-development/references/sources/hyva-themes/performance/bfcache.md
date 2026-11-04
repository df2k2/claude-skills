<!-- source: https://docs.hyva.io/hyva-themes/performance/bfcache.html -->

# Back-Forward Cache (bfcache)

When a user clicks the browser's back or forward buttons, the back-forward cache (bfcache) restores a complete in-memory snapshot of the page instead of reloading it. This gives near-instant navigation and improves Core Web Vitals scores. Google's Chrome data shows bfcache restores are on average 10x faster than a normal navigation.

Available from Hyvä Default Theme 1.4

Bfcache support is available from Hyvä Default Theme 1.4. It is not enabled by default because Magento core has two blockers that prevent it.

## Why it is not enabled by default

**1. The `Cache-Control: no-store` header**

Magento sets `Cache-Control: no-store` on all frontend responses. Browsers treat `no-store` as an explicit opt-out from bfcache regardless of any other headers. This header is set in two places: in PHP via `Framework\App\Response\Http::setNoCacheHeaders()`, and in the Varnish VCL for stores that use Varnish as a full page cache backend.

**2. Stale JavaScript state on restore**

When bfcache restores a page, JavaScript state is preserved exactly as it was when the user navigated away. Several Magento core JS components leave UI elements in a broken state after restore, such as disabled buttons, open drawers, or outdated cart counts. Without `pageshow` handlers to reset this state, the restored page can be in an inconsistent state.

Hyvä's theme module already handles the second blocker for all native Hyvä components. The remaining issue for Hyvä stores is the `no-store` header.

## Enabling bfcache

There are two ways to remove the `no-store` blocker. Pick one, there is no need to combine them.

### Option 1: apply the Magento core patch (recommended)

[magento/magento2#40750](https://github.com/magento/magento2/pull/40750) is an open pull request that fixes both the PHP header and all Varnish VCL versions at the core level.

Until the PR is merged, use the [magento-patch-bfcache](https://github.com/GrimLink/magento-patch-bfcache) repository, which provides ready-made patch files. Clone it into a `patches` directory in your Magento root and apply using a Composer patch tool such as [cweagans/composer-patches](https://github.com/cweagans/composer-patches) or [vaimo/composer-patches](https://github.com/vaimo/composer-patches):

```
git clone https://github.com/GrimLink/magento-patch-bfcache patches
mv patches/patches.json .
composer patches-relock
composer patches-repatch
```

With the patch applied, the Hyvä **Enable Bfcache** setting is not needed.

### Option 2: enable the Hyvä setting and update the Varnish VCL

#### Step 1: Enable the setting

Enable bfcache in the Magento admin under `Stores → Configuration → Hyvä Themes → System → Cache Options → Enable Bfcache`.

This removes `no-store` from the `Cache-Control` header at the PHP level. For stores not using Varnish as the full page cache backend, this is the only step required.

#### Step 2: Update the Varnish VCL

If you are using Varnish, the `no-store` directive is also set in the VCL and must be removed separately. The recommended option is the [Elgentos VarnishExtended](https://github.com/elgentos/magento2-varnish-extended) module, which generates an updated VCL that removes `no-store` along with other improvements.

Manual Varnish VCL patch

If you prefer to apply the change manually, the same single-line fix applies to Varnish 4, 5, and 6 in the `vcl_deliver` subroutine. This patch was generated using the default Magento VCL.

```
diff --git a/etc/varnish4.vcl b/etc/varnish4.vcl
index ffb489c..07e0fd6 100644
--- a/etc/varnish4.vcl
+++ b/etc/varnish4.vcl
@@ -212,7 +212,7 @@ sub vcl_deliver {
    if (resp.http.Cache-Control !~ "private" && req.url !~ "^/(pub/)?(media|static)/") {
        set resp.http.Pragma = "no-cache";
        set resp.http.Expires = "-1";
-        set resp.http.Cache-Control = "no-store, no-cache, must-revalidate, max-age=0";
+        set resp.http.Cache-Control = "no-cache, must-revalidate, max-age=0";
    }
    if (!resp.http.X-Magento-Debug) {
diff --git a/etc/varnish5.vcl b/etc/varnish5.vcl
index 3347b93..6f72ad0 100644
--- a/etc/varnish5.vcl
+++ b/etc/varnish5.vcl
@@ -209,7 +209,7 @@ sub vcl_deliver {
    if (resp.http.Cache-Control !~ "private" && req.url !~ "^/(pub/)?(media|static)/") {
        set resp.http.Pragma = "no-cache";
        set resp.http.Expires = "-1";
-        set resp.http.Cache-Control = "no-store, no-cache, must-revalidate, max-age=0";
+        set resp.http.Cache-Control = "no-cache, must-revalidate, max-age=0";
    }
    if (!resp.http.X-Magento-Debug) {
diff --git a/etc/varnish6.vcl b/etc/varnish6.vcl
index 4e07ac5..e32be55 100644
--- a/etc/varnish6.vcl
+++ b/etc/varnish6.vcl
@@ -215,7 +215,7 @@ sub vcl_deliver {
    if (resp.http.Cache-Control !~ "private" && req.url !~ "^/(pub/)?(media|static)/") {
        set resp.http.Pragma = "no-cache";
        set resp.http.Expires = "-1";
-        set resp.http.Cache-Control = "no-store, no-cache, must-revalidate, max-age=0";
+        set resp.http.Cache-Control = "no-cache, must-revalidate, max-age=0";
    }
    if (!resp.http.X-Magento-Debug) {
```

For Fastly-specific instructions, see the [Mage-OS Theme Optimization module documentation](https://github.com/mage-os/module-theme-optimization/blob/main/README.md#backforward-cache).

## Using the Mage-OS Theme Optimization module

The [Mage-OS Theme Optimization](https://github.com/mage-os/module-theme-optimization) module also ships bfcache support, and it is enabled by default. Besides removing the `no-store` header, it adds its own `pageshow` handler script to every page.

Do not combine the Mage-OS bfcache handler with Hyvä

Hyvä Default Theme already resets its components on a bfcache restore. It clears messages, closes the cart drawer, menus and popups, refreshes the form key and reloads the customer section data. The Mage-OS handler repeats this work, so every restore runs the same logic twice (including a second customer section data request) and the page loads JavaScript it does not need.

For the same reason, the Mage-OS settings **Update Mini Cart on User Interaction** and **Auto Close Menu** have no effect on Hyvä. Hyvä always closes the menus and reloads the mini cart on restore.

How to resolve this depends on which part of the module you rely on:

- **You use option 1 or option 2 above:** disable the Mage-OS bfcache feature under `Stores → Configuration → Advanced → System → Back/Forward Cache → Enable Back/Forward Cache`, or run:

  ```
  bin/magento config:set system/bfcache/general/enable 0
  ```
- **You use the Mage-OS module to remove the `no-store` header** (for example on Fastly): keep the setting enabled and only remove the handler script. Add the following to the `Magento_Theme/layout/default.xml` file in your theme:

  ```
  <?xml version="1.0"?>
  <page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
      <body>
          <referenceBlock name="theme-optimization.bfcache.main" remove="true"/>
      </body>
  </page>
  ```

Login state on restore

The Mage-OS handler reloads the full page when the login state changed after the page was cached. Hyvä does not reload the page. It refreshes the customer section data instead, which updates the customer menu and mini cart without losing the bfcache speed gain.

## Handling restored page state

When bfcache restores a page, JavaScript state is preserved from the moment the user navigated away. Use the `pageshow` event with `event.persisted` to detect a restore and reset any state that needs it.

```
window.addEventListener('pageshow', (event) => {
    if (event.persisted) {
        // page was restored from bfcache
    }
});
```

Built-in support in Hyvä Default Theme v1.4+

All native components in Hyvä Default Theme 1.4 and later already include `pageshow` handlers. Custom components and third-party scripts need their own handlers.

Resetting Alpine component state on bfcache restore

In your template, add `x-bind="eventListeners"` to the component's root element, then add the listener to the component's data:

```
eventListeners: {
    ['@pageshow.window'](event) {
        if (event.persisted) {
            this.closeMenu();
        }
    }
}
```

## Resources

- [web.dev: Back/forward cache](https://web.dev/articles/bfcache)
- [MDN Glossary: bfcache](https://developer.mozilla.org/en-US/docs/Glossary/bfcache)
- [Core Fix: magento/magento2#40750](https://github.com/magento/magento2/pull/40750)
- [Patch: magento-patch-bfcache](https://github.com/GrimLink/magento-patch-bfcache)
- [Example Gist: for pageshow event](https://gist.github.com/GrimLink/a7bfd9152cfb81d32cc8e2a183ff09ef)
