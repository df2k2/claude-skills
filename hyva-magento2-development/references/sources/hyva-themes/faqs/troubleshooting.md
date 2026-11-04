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
   npm install --ignore-scripts
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

For more information on a similar issue, refer to our guide on [Resolving Top-Menu Varnish Issues](./resolving-top-menu-varnish-issues.html).

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

## "Argument must be of type array, null given" TypeError after `setup:di:compile`

### Symptoms: HTTP 500 on every storefront page

After deploying to a production-mode environment (or building one in CI), **every storefront page** returns HTTP 500 and renders Magento's generic error page:

```
There has been an error processing your request

Exception printing is disabled by default for security reasons.
Error log record number: 82462993a0bd96355d69cba82165df648e947a73168214ddf481748c35176deb
```

Looking up the referenced record in `var/report/<record-number>` (or `var/log/exception.log`) shows a `TypeError` raised while the object manager builds a Hyvä service. The trace is most commonly one of these:

```
Type Error occurred when creating object:
Hyva\BaseLayoutReset\Model\Layout\SpecialCaseLayoutFileReset\SpecialCaseLayoutResetPool,
Hyva\BaseLayoutReset\Model\Layout\SpecialCaseLayoutFileReset\SpecialCaseLayoutResetPool::__construct():
Argument #1 ($specialCases) must be of type array, null given,
called in .../vendor/magento/framework/ObjectManager/Factory/AbstractFactory.php on line 126
```

```
Type Error occurred when creating object:
Hyva\Theme\Service\HyvaThemes,
Hyva\Theme\Service\HyvaThemes::__construct():
Argument #1 ($hyvaBaseThemes) must be of type array, null given,
called in .../vendor/magento/framework/ObjectManager/Factory/AbstractFactory.php on line 126
```

The tell-tale sign is a **required `array` constructor argument that receives `null`**, thrown through `ObjectManager/Factory/AbstractFactory.php`.

#### Variant: the same error during `setup:static-content:deploy`

In production mode JS/CSS minification is active, so Hyvä's minifier-skip plugin resolves `HyvaThemes` for **every** asset. When the compiled configuration is stale, `setup:static-content:deploy` fails with the same `TypeError` raised **once per minifiable file** (thousands of identical errors) and the deploy does not complete:

```
Type Error occurred when creating object: Hyva\Theme\Service\HyvaThemes,
Hyva\Theme\Service\HyvaThemes::__construct(): Argument #1 ($hyvaBaseThemes) must be of type array, null given

#0 .../vendor/magento/framework/ObjectManager/Factory/Compiled.php(108): Magento\Framework\ObjectManager\Factory\AbstractFactory->createObject('Hyva\\Theme\\Serv...', Array)
#1 .../vendor/magento/framework/ObjectManager/Factory/Compiled.php(...): ...->create('Hyva\\Theme\\Serv...')
#2 .../DisableJsAndCssMinifierForHyvaPlugin.php(29): ...->get('Hyva\\Theme\\Serv...')
#3 ...->DisableJsAndCssMinifierForHyvaPlugin->__construct(Object(...ThemeProvider), NULL)
   ... (repeats for every js/css asset)
```

The failure disables its own fix

Once the compiled metadata is poisoned, `bin/magento` itself hits the same `TypeError` while building its command list and silently falls back to a minimal set, so the cache commands disappear:

```
$ bin/magento cache:flush
There are no commands defined in the "cache" namespace.
```

A remediation script that just runs `bin/magento cache:flush` will therefore no-op. See [Resolution](#resolution-flush-the-config-cache-and-recompile) for how to recover.

### Cause: stale compiled DI configuration

`setup:di:compile` compiled a stale, pre-merged DI configuration that was cached before the Hyvä module was registered, so a required `array` argument was baked in as `null`. For the full explanation and how to prevent it in build pipelines, see [Why a stale DI config cache injects null into Hyvä services](stale-di-config-cache.html).

### Resolution: flush the config cache and recompile

Flush the config cache and recompile so the DI configuration is re-merged from the current `etc/di.xml` files:

```
bin/magento cache:flush
bin/magento setup:di:compile
```

If `bin/magento cache:flush` reports `There are no commands defined in the "cache" namespace` (see the warning above), the CLI is running on the poisoned compile and can't flush. Recover with either:

```
bin/magento setup:upgrade      # re-warms the config cache from a complete module list, then:
bin/magento setup:di:compile
```

or by clearing the stale entry from the cache backend directly (e.g. Redis) before recompiling:

```
redis-cli -n <config-cache-db> flushdb
bin/magento setup:di:compile
```

To prevent it in **build pipelines**, always flush the cache immediately before compiling:

```
bin/magento deploy:mode:set production --skip-compilation
bin/magento cache:flush            # drop the stale global::DiConfig
bin/magento setup:di:compile
```

## Hyvä head scripts missing on pages from controllers that don't extend `Action`

Info

This is caused by how Magento core builds the layout and only shows up in an edge case.
We document it here because the symptoms are only visible in Hyvä themes.

### Symptoms: Alpine components break on a single route

On some pages `hyva.js` and `hyva-variables.js` are missing from the `<head>`. The browser console shows errors such as:

```
hyva.alpineInitialized is not a function
hyva.createBooleanObject is not a function
```

Alpine components on that page stop working. For example, the customer account dropdown is open on page load and can't be closed.

The affected routes have a controller that implements `Magento\Framework\App\Action\HttpGetActionInterface` and returns a page result, but does **not** extend `Magento\Framework\App\Action\Action`. An example from Magento core is Login as Customer (`loginascustomer/login/index`).

The problem always occurs with the layout cache disabled. With the layout cache enabled it occurs when the cache is cold and an affected route is the first to build the layout. In that case the full page cache can store and serve the broken page.

### Cause: the layout is built twice

Controllers that extend `Action` get `Magento\Framework\App\ViewInterface` through their context, so it exists before the layout is built.
For other controllers, `ViewInterface` is first created while the layout is being generated (it is a dependency of blocks such as the swatch renderer in the `catalog_list_item` handle, which Hyvä loads on every page for Page Builder product widgets).

The constructor of `Magento\Framework\App\View` creates a new page, which registers a new layout builder, so the layout is built a second time.
During that second build the `head.additional` block declared in the Hyvä default theme is treated as an override, and Magento removes the children that were added to it by the `default_hyva` handle, including the Hyvä head scripts.

### Resolution: create the view before the layout is built

If you maintain the controller, inject `ViewInterface` in its constructor. You don't need to use it, requesting it is enough:

```
use Magento\Framework\App\Action\HttpGetActionInterface;
use Magento\Framework\App\ViewInterface;
use Magento\Framework\View\Result\PageFactory;

class Index implements HttpGetActionInterface
{
    public function __construct(
        private PageFactory $pageFactory,
        ViewInterface $view // Creates the view before the layout is built
    ) {}

    public function execute()
    {
        return $this->pageFactory->create();
    }
}
```

For controllers you can't change, such as Magento core or third party modules, add an observer for the `controller_action_predispatch` event in your own module.
The event is dispatched before any controller runs, so injecting `ViewInterface` there creates it in time for every route:

etc/frontend/events.xml

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd">
    <event name="controller_action_predispatch">
        <observer name="init_view_before_layout" instance="Vendor\Module\Observer\InitView"/>
    </event>
</config>
```

Observer/InitView.php

```
<?php

declare(strict_types=1);

namespace Vendor\Module\Observer;

use Magento\Framework\App\ViewInterface;
use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;

class InitView implements ObserverInterface
{
    // Requesting the view creates it before the first layout build
    public function __construct(private ViewInterface $view) {}

    public function execute(Observer $observer): void
    {
    }
}
```

After adding either fix, flush the layout and full page cache so no broken pages remain cached.
