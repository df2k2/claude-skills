<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/installation.html -->

# Installing Hyvä CMS

This guide covers installing Hyvä CMS with Composer, both with a license key and via the Hyvä Commerce GitLab repositories for agency and technology partners.

## Installing Hyvä CMS with Composer

For prerequisites, see [Hyvä Commerce Installation Page](../../getting-started/index.html#hyva-commerce-prerequisites).

Installation via Hyvä Commerce Metapackage Recommended

These steps install Hyvä CMS on its own. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

1. Require the `hyva-themes/commerce-module-cms` package:

   ```
   composer require hyva-themes/commerce-module-cms
   ```
2. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
3. Run Tailwind to generate storefront styles, replacing `vendor/hyva-themes/magento2-default-theme/web/tailwind/` with the path to your theme's `web/tailwind` folder:

   ```
   bin/magento hyva:config:generate
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci --ignore-scripts
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
   ```

### For Agency and Technology Partners

If you have access to the Hyvä Commerce GitLab repositories as a Gold/Platinum Agency Partner or a Technology Partner, you can install Hyvä Commerce in development environments using SSH key authentication.

You can configure the Git repositories in your root `composer.json` and use them directly as Git repos beneath your vendor directory. This lets you check out tags and branches, make commits, and push contributions.

Development Environments Only

This installation method is not suited for deployments, because GitLab requires SSH key authorization and project changes can break production deployments.

Installation Steps

1. Make sure your public SSH key is added to your account on `gitlab.hyva.io`.
2. Set minimum-stability to `dev` in the Magento `composer.json`:

   ```
   composer config minimum-stability dev
   ```
3. Add the Hyvä CMS and base Hyvä Commerce module repositories to the Magento `composer.json`:

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-cms git git@gitlab.hyva.io:hyva-commerce/module-cms.git
   composer config repositories.hyva-themes/commerce-module-cms-tailwind-jit-bridge git git@gitlab.hyva.io:hyva-commerce/commerce-module-cms-tailwind-jit-bridge.git
   composer config repositories.hyva-themes/commerce-module-cms-google-maps git git@gitlab.hyva.io:hyva-commerce/module-cms-google-maps.git
   ```
4. Require the `hyva-themes/commerce-module-cms` package using the `dev-main` branch:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-cms:dev-main'
   ```
5. Run a setup upgrade:

   ```
   bin/magento setup:upgrade
   ```
6. Run Tailwind to generate storefront styles, replacing `vendor/hyva-themes/magento2-default-theme/web/tailwind/` with the path to your theme's `web/tailwind` folder:

   ```
   bin/magento hyva:config:generate
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci --ignore-scripts
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
   ```

## Upgrading

For an existing CMS installation, follow [Upgrading to Hyvä Commerce 1.4.0](../../upgrading/upgrading-to-1.4.0.html#hyva-cms). That release includes CMS `1.3.0`; the guide covers the migration from CMS `1.2.x`, extension compatibility and the admin styles deployment step.

The [Media Gallery](features/media-gallery.html) is included as a dependency of CMS `1.3.0`. [AI integrations](../ai-worker/installation.html) remain optional packages. Installing CMS alone does not deploy an AI worker or configure provider credentials.

## Additional Hyvä CMS Setup

### Enable 'New' Media Gallery

Hyvä CMS only supports the 'New' Media Gallery, for handling image selection and editing (using the [Image Editor](../image-editor/index.html)). Enabling the 'New' Media Gallery can be [configured in the admin panel](https://experienceleague.adobe.com/en/docs/commerce-admin/content-design/wysiwyg/gallery/media-gallery#enable-the-new-media-gallery).

### Confirm Magento Cron

Hyvä CMS scheduling depends on Magento cron. Make sure cron is configured and running before relying on scheduled publication.

Default scheduling jobs check for due releases every 5 minutes and clean old completed scheduling history weekly. See [Content Scheduling](features/content-scheduling.html).

### Review Content Type Configuration

CMS pages, CMS blocks, product attributes, and category attributes are enabled by default in the core Hyvä CMS modules. Review the admin configuration if a content type should be disabled for a project.

Relevant configuration areas are all found in the Magento admin under `Stores → Settings → Configuration → Hyvä Commerce`:

- `Hyvä CMS → Magento CMS`
- `Hyvä CMS → Attributes`
- `Hyvä CMS → Templates`
- `Hyvä CMS → Scheduling`

### Multi-Store and Custom Admin Domain Setup

Since version `1.0.2` the required CSP frame policies for multi-domain setups are automatically applied in the Hyvä CMS Liveview Editor context.

This feature is enabled by default and requires no additional configuration.

**Configuration Path:** `hyva_cms/general/auto_csp_frame_policies`, found in the admin under `Stores → Settings → Configuration → Hyvä Commerce → Hyvä CMS → General → Enable Multi Domain CSP Frame Policies`.

Manual CSP Configuration (Legacy)

If you're using an older Hyvä CMS version, need to disable automatic CSP frame policies, or require custom configuration, you can configure [Magento CSP](https://developer.adobe.com/commerce/php/development/security/content-security-policies) manually:

1. Disable automatic policies in the admin configuration: `hyva_cms/general/auto_csp_frame_policies`, found under `Stores → Settings → Configuration → Hyvä Commerce → Hyvä CMS → General → Enable Multi Domain CSP Frame Policies`.
2. Add CSP Whitelist Rules in a `csp_whitelist.xml` file:

   ```
   <?xml version="1.0"?>
   <csp_whitelist xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Csp:etc/csp_whitelist.xsd">
       <policies>
           <policy id="frame-ancestors">
               <values>
                   <value id="magento-admin-domain" type="host">admin.example.com</value>
               </values>
           </policy>
           <policy id="frame-src">
               <values>
                   <value id="store-domain-uk" type="host">example-uk.com</value>
                   <value id="store-domain-fr" type="host">example-fr.com</value>
               </values>
           </policy>
       </policies>
   </csp_whitelist>
   ```
3. Enable CSP strict Mode by adding the following to `config.xml`:

   ```
   <?xml version="1.0"?>
   <config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Store:etc/config.xsd">
       <default>
           <csp>
               <mode>
                   <storefront>
                       <report_only>0</report_only>
                   </storefront>
               </mode>
           </csp>
       </default>
   </config>
   ```

or the following to `app/etc/env.php`:

```
'system' => [
    'default' => [
        'csp' => [
            'mode' => [
                'storefront' => [
                    'report_only' => '0'
                ]
            ]
        ]
    ]
]
```

Note: frame-ancestors overrides X-Frame-Options only in strict mode (Content-Security-Policy). In report-only mode, X-Frame-Options still applies (see [spec](https://w3c.github.io/webappsec-csp/#frame-ancestors-and-frame-options)).

Why do we need CSP frame policies?

For the Hyvä CMS Liveview Editor to be able to display the preview in a cross domain iframe, it requires the correct Content Security Policy (CSP) frame policies to be applied in the editor context.

For more information about CSP and Magento, see [CSP and Magento](../../../hyva-themes/writing-code/csp/index.html).

### Adobe Commerce Cloud WAF Exclusion

On Adobe Commerce Cloud, the Fastly Web Application Firewall (WAF) can block Hyvä CMS Liveview Editor preview requests. Ask Adobe Commerce support to exclude the `/liveview-editor/` path prefix from the WAF rules before editors start working on the site.

The Liveview Editor renders its preview by posting the page content as JSON to storefront endpoints under `/liveview-editor/`, for example `/liveview-editor/ajax/content`. This is deliberate: the preview is rendered with the storefront theme, which only a storefront request can do. Saving content goes through the admin path and is not affected.

The WAF inspects that JSON body. Content that resembles an injection attempt, such as a `{{widget ...}}` directive inside a text component, triggers a rule and the request receives a `403` response. In the Liveview Editor the preview stops updating, and the browser console shows a `403` for `/liveview-editor/ajax/content`.

To fix it, open a ticket with Adobe Commerce support and ask for a WAF path exclusion covering the whole `/liveview-editor/` prefix. Include the blocked request ID from the `403` page. The exclusion needs the full prefix rather than the single URL, because `/liveview-editor/ajax/single` and `/liveview-editor/preview/compile` post the same content. Once the exclusion is in place, no change to Hyvä CMS is needed. See [Adobe's WAF FAQ](https://experienceleague.adobe.com/en/docs/commerce-knowledge-base/kb/faq/web-application-firewall-waf-powered-by-fastly-the-faq) for the ticket details Adobe asks for.

Custom VCL snippets cannot bypass the WAF

Adobe and Fastly manage the WAF rules on Adobe Commerce Cloud, so a custom VCL snippet cannot exclude a path from them. The exclusion has to be added by Adobe support.

### Handling the Hyvä CMS Cache

The `hyva_cms` cache stores component declarations from `components.json` files for improved performance. It is automatically enabled in production environments and disabled in developer mode.

Depending on your deployment strategy, you may need to clear this cache on each deployment:

```
bin/magento cache:clean hyva_cms
```

### Tailwind CSS Compilation

Hyvä CMS generates Tailwind CSS for the classes used in CMS content, so components produce styles without a full theme rebuild. Compilation runs either **in-browser** (the default) or **server-side** through a Node-based Tailwind compiler. **For new projects, server-side compilation is recommended**, since it produces the smallest inline CSS payload.

See [Tailwind CSS Compilation](tailwind-compilation.html) for the full details: choosing the strategy, the in-browser compiler version, server-side setup, when styles are compiled, style priority (theme styles always win), and backward compatibility.

## Related Topics

- **[Accessing Hyvä CMS](accessing-hyva-cms-editor.html)** - Open the Liveview Editor from CMS pages, blocks, and product and category forms
- **[Tailwind CSS Compilation](tailwind-compilation.html)** - Choose between in-browser and server-side compilation for CMS content styles
- **[Content Scheduling](features/content-scheduling.html)** - The cron-based scheduling jobs that publish content releases
