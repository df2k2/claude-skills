<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/csp-magento-configuration.html -->

# Configuring CSP in Magento

## Removing `unsafe-eval` and `unsafe-inline`

In Magento, when developing an Alpine component (or any JavaScript code) so it works with strict CSP, it is best to set up the development environment accordingly.

After this change, all code relying on `unsafe-eval` or `unsafe-inline` will cause a stack trace in the browser console.
Be sure to enable the "Warning" log level in the browser dev console to see helpful information from Alpine indicating the expression and the element causing the issue.

Disabling unsafe-eval forces alpine-csp

If `unsafe-eval` is disabled, Hyvä automatically uses the Alpine CSP build instead of regular Alpine.

Disabling unsafe-inline breaks scripts in CMS content

Be aware that using scripts in CMS content is not possible once `unsafe-inline` is disabled!

Strict CSP not supported by built-in PHP full page cache backend

Varnish - and other reverse proxy based solutions like Fastly - cache the CSP header together with the page content, and include it as part of the response.
The PHP based built-in full-page cache doesn’t store the CSP header, so when a page is served from the cache, inline scripts are not authorised.
Note: uncached pages, for example, the checkout, are not affected by this issue. Only cached pages with strict CSP will not work.

## Manual configuration

One way to do so is to add the following configuration to the `app/etc/env.php` file:

```
    'system' => [
        'default' => [
            'csp' => [
                'mode' => [
                    'storefront' => [
                        'report_only' => 0,
                    ]
                ],
                'policies' => [
                    'storefront' => [
                        'scripts' => [
                            'eval' => 0,
                            'inline' => 0,
                        ]
                    ]
                ]
            ]
        ]
    ]
```

Then run `bin/magento app:config:import`.

## CLI configuration

If you are using the [popular Magerun](https://github.com/netz98/n98-magerun2) tool, this can be done with the following commands:

```
n98-magerun config:env:set system/default/csp/policies/storefront/scripts/inline 0
n98-magerun config:env:set system/default/csp/policies/storefront/scripts/eval 0
n98-magerun config:env:set system/default/csp/mode/storefront/report_only 0
bin/magento app:config:import
```

## Strict CSP in website or store view scope

The config path includes the website or store view code, please adjust the following commands accordingly.

For example, assume a store view or website with the code `example`.

To set strict CSP for that **website** only, the `n98-magerun` commands are

```
n98-magerun config:env:set system/websites/example/csp/policies/storefront/scripts/inline 0
n98-magerun config:env:set system/websites/example/csp/policies/storefront/scripts/eval 0
n98-magerun config:env:set system/websites/example/csp/mode/storefront/report_only 0
bin/magento app:config:import
```

To set the values in a **store view scope**, use

```
n98-magerun config:env:set system/stores/example/csp/policies/storefront/scripts/inline 0
n98-magerun config:env:set system/stores/example/csp/policies/storefront/scripts/eval 0
n98-magerun config:env:set system/stores/example/csp/mode/storefront/report_only 0
bin/magento app:config:import
```

## Forcing strict CSP on specific routes

Magento allows enabling of disabling specific policies on a route basis.
The following example can be found in the `etc/config.xml` file of the `Magento_Checkout` module.
It enables strict mode and disables `unsafe-inline` for the `checkout_index_index` route.

```
    <csp>
        <mode>
            <storefront_checkout_index_index>
                <report_only>0</report_only>
            </storefront_checkout_index_index>
        </mode>
        <policies>
            <storefront_checkout_index_index>
                <scripts>
                    <inline>0</inline>
                    <event_handlers>1</event_handlers>
                </scripts>
            </storefront_checkout_index_index>
        </policies>
    </csp>
```
