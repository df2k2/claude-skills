<!-- source: https://docs.hyva.io/hyva-themes/faqs/troubleshooting.html -->

# Troubleshooting

## My CSS styles are broken

There are several possible reasons this can happen. Check each one until you find the cause.

1. Force a hard browser-reload bypassing the browser cache. In Chrome that can be done by opening the developer console, right-clicking on the reload button, and selecting "Clear cache and reload".
2. Check the HTTP request to the `styles.css` file in the browser developer tools networking tab.

   - If it is a 200 or 50x HTTP response, check the response preview. It may be a PHP error causing issues.
   - If it's a 404 response, check if the site is running in production mode (with `bin/magento deploy:mode:show`), and if so check if the static content was successfully deployed with `bin/magento setup:static-content:deploy`.
3. Check if TailwindCSS compilation works. If you compiled your styles with `npm run watch`, try running `npm run build`. Check the output of the command for errors or warnings.
4. If you confirmed the `styles.css` file is loading correctly, but the styles still look broken, this is an indication there is an issue on the HTML or CSS level. Check the browser console for errors or warnings, and use the DOM inspector Styles tab to debug the issue further.

## Compilation from source: LESS file is empty: …/email-fonts.less

When running static content deploy the error occurs:

```
Compilation from source: LESS file is empty: frontend/Hyva/reset/xx_XX/css/email-fonts.less
```

This warning can be safely ignored, as it doesn’t cause the compilation to abort.

However, to properly resolve the issue, upgrade the module `hyva-themes/magento2-email-module` to release 1.0.4 or later.

## “Incorrect CAPTCHA” error messages

Hyvä does not support the old legacy Magento Captcha or reCAPTCHA V1, as is documented in the [Feature Matrix](https://hyva.io/hyva-themes-feature-matrix) and in the [Getting Started section](../getting-started/index.html).

Please disable the legacy Captcha, which unfortunately still is enabled by default:

```
bin/magento config:set customer/captcha/enable 0
```

## `tailwindcss: Permission Denied` Error

This error commonly occurs after upgrading to macOS Sonoma and updating Xcode. It is often triggered by an outdated npm installation, leading to a "Permission Denied" error or a similar issue.

**Solution:**

The simplest way to resolve this issue is to remove the outdated `node_modules` folder and reinstall the required packages.

**Steps to Fix:**

1. Navigate to your project theme directory.
2. Run the following commands in your terminal:

   ```
   rm -rf node_modules
   npm install
   ```

This will remove the existing `node_modules` folder and install the packages again,
ensuring compatibility with your updated environment.

## Child theme throws exception "Overriding view file '...xml' does not match to any of the files."

This error occurs after creating and loading a child theme.

> Exception #0 (LogicException): Overriding view file 'vendor/hyva-themes/magento2-reset-theme/.../layout/override/base/....xml' does not match to any of the files.

The exact path to the layout override XML file might vary.
If that happens, check the `Hyva_Theme` module is active.

```
bin/magento module:status Hyva_Theme
```

If the output is

```
Hyva_Theme : Module is disabled
```

then enable the module and run `setup:upgrade`.

```
bin/magento module:enable Hyva_Theme
bin/magento setup:upgrade
```

## Missing Page Header Styling

**Troubleshooting Steps:**

1. **Verify TailwindCSS Purge Settings:**
   Ensure that the TailwindCSS purge settings are correctly configured.
   This is often the first place to check before exploring other potential solutions.
2. **Check for `esi` Tags in the Header:**
   If your header appears broken but the rest of your styling is functioning properly,
   the issue may be caused by `esi` tags in the header. This indicates that Varnish is enabled in your Magento 2 admin.
3. **Handling Varnish in Local Development:**
   For local development, you can disable Varnish unless you specifically need it.
   If you choose to keep Varnish enabled, ensure it is correctly configured to avoid conflicts with your styling.
4. **Disabling Varnish for Local Development:**
5. Navigate to `Stores → Configuration → Advanced → System → Full Page Cache`.
6. Set the **Caching Application** to **Built-in Cache** to disable Varnish for local environments.

Note

For more information on a similar issue, refer to our guide on [Resolving Top-Menu Varnish Issues](resolving-top-menu-varnish-issues.html).

## How to fix "Invalid form key" issue with enabled Cloudflare Rocket Loader?

The Hyvä releases up to 1.2.3 do not work with [Cloudflare Rocket Loader](https://developers.cloudflare.com/fundamentals/speed/rocket-loader/).

According to [cloudflare docs](https://developers.cloudflare.com/fundamentals/speed/rocket-loader/ignore-javascripts/) all that is needed is to add `data-cfasync="false"` to the corresponding javascript(s).

```
<script data-cfasync="false" src="/javascript.js"></script>
```

## Visitors see the wrong store view and are unable to switch

Info

This is a core Magento issue and not related to Hyvä.
However, since it can also occur with Hyvä, we have decided to add it to our documentation.

This happens for requests that have a `store` cookie set, but no `X-Magento-Vary` cookie, and the FPC record for the requested default store URL is expired.
This might happen when a visitors' session times out after they select a non-default store view.

Varnish caches the page based on the `X-Magento-Vary` cookie, while Magento decides on which store view to render based on the `store` cookie.
For the default store view with the customer group `guest` neither cookie will be set.
This means, that when a request with the `store` cookie set to a non-default store view, has no `X-Magento-Vary` cookie set, the result will be cached in Varnish as the default store view page.

A possible fix is to adjust the default Varnish configuration. Instead of

```
sub vcl_hash {
    if (req.http.cookie ~ "X-Magento-Vary=") {
        hash_data(regsub(req.http.cookie, "^.*?X-Magento-Vary=([^;]+);*.*$", "\1"));
    }
```

use the following:

```
sub vcl_hash {
    if (req.http.cookie ~ "X-Magento-Vary=") {
            hash_data(regsub(req.http.cookie, "^.*?X-Magento-Vary=([^;]+);*.*$", "\1"));
        } else {
            # If there is no 'X-Magento-Vary' cookie set, then there should also be no 'store' cookie
            # This check prevents requests with illegal cookie state from polluting the cache for default store view:
            if (req.http.cookie ~ "store=") {
                hash_data(regsub(req.http.cookie, "^.*?store=([^;]+);*.*$", "\1"));
            }
        }
```

(Thanks to Maximilian Fickers from basecom.de to allow us to share their solution)
