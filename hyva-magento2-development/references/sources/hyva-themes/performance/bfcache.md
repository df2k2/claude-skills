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

### Step 1: Enable the setting

Enable bfcache in the Magento admin under `Stores → Configuration → Hyvä Themes → System → Cache Options → Enable Bfcache`.

This removes `no-store` from the `Cache-Control` header at the PHP level. For stores not using Varnish as the full page cache backend, this is the only step required.

### Step 2: Update the Varnish VCL

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

### Alternative: apply the Magento core patch

[magento/magento2#40750](https://github.com/magento/magento2/pull/40750) is an open pull request that fixes both the PHP header and all Varnish VCL versions at the core level. This covers both Step 1 and Step 2 in one go.

Until the PR is merged, use `magerun2` to generate the patch file:

```
magerun2 github:pr --patch 40750
```

Then apply the generated patch using a tool such as [cweagans/composer-patches](https://github.com/cweagans/composer-patches).

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
- [Example Gist: for pageshow event](https://gist.github.com/GrimLink/a7bfd9152cfb81d32cc8e2a183ff09ef)
