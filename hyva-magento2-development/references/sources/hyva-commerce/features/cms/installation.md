<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/installation.html -->

# Installing Hyvä CMS

## Prerequisites

See [Hyvä Commerce Prerequisites](../../getting-started/index.html#hyva-commerce-prerequisites).

## Installation

Installation via Hyvä Commerce Metapackage Recommended

The below steps are for installing Hyvä CMS only. While this is supported to provide greater flexibility and control over installed features, in most cases, we recommend installing all Hyvä Commerce features using our [metapackage](../../getting-started/index.html).

### With a License Key

1. Require the `hyva-themes/commerce-module-cms` package

   ```
   composer require hyva-themes/commerce-module-cms
   ```
2. Run `bin/magento setup:upgrade`
3. Run tailwind to generate storefront styles, replacing `vendor/hyva-themes/magento2-default-theme/web/tailwind/` with the path to your theme's `web/tailwind` folder:

   ```
   bin/magento hyva:config:generate
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
   ```

### For Agency and Technology Partners

If you have access to the Hyvä Commerce GitLab repositories as Gold/Platinum Agency Partner, or a Technology Partner, you can install Hyvä Commerce in development environments using SSH key authentication.

You can configure the git repositories in your root composer.json and use the repositories directly as git repo's beneath your vendor directory. You can check out tags and branches, make commits and push contributions.

This installation method is not suited for deployments, because GitLab requires SSH key authorization.

1. Ensure your public SSH key is added to your account on gitlab.hyva.io.
2. Set minimum-stability to `dev` in the Magento composer.json

   ```
   composer config minimum-stability dev
   ```
3. Add the Hyvä CMS and base Hyvä Commerce module repositories to the Magento `composer.json`

   ```
   composer config repositories.hyva-themes/commerce-module-commerce git git@gitlab.hyva.io:hyva-commerce/module-commerce.git
   composer config repositories.hyva-themes/commerce-module-cms git git@gitlab.hyva.io:hyva-commerce/module-cms.git
   ```
4. Require the `hyva-themes/commerce-module-cms` packages using the `dev-main` branch version:

   ```
   composer require --prefer-source 'hyva-themes/commerce-module-cms:dev-main'
   ```
5. Run `bin/magento setup:upgrade`
6. Run tailwind to generate storefront styles, replacing `vendor/hyva-themes/magento2-default-theme/web/tailwind/` with the path to your theme's `web/tailwind` folder:

   ```
   bin/magento hyva:config:generate
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
   npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
   ```

## Additional Setup

### Enable 'New' Media Gallery

Hyvä CMS only supports the 'New' Media Gallery, for handling image selection and editing (using the [Image Editor](../image-editor/index.html)). Enabling the 'New' Media Gallery can be [configured in the admin panel](https://experienceleague.adobe.com/en/docs/commerce-admin/content-design/wysiwyg/gallery/media-gallery#enable-the-new-media-gallery).

### Multi-Store & Domain / Custom Admin Domain Setup

Since version `1.0.2` the required CSP frame policies required for multi-domain setups are automatically applied in the Hyvä CMS Liveview Editor context.

This feature is enabled by default and requires no additional configuration.

**Configuration Path:**
`hyva_cms/general/auto_csp_frame_policies`

> Stores > Configuration > Hyvä Themes > CMS > General > Enable Multi Domain CSP Frame Policies

Manual CSP Configuration (Legacy)

If you're using an older Hyvä CMS version, need to disable automatic CSP frame policies, or require custom configuration, you can configure [Magento CSP](https://developer.adobe.com/commerce/php/development/security/content-security-policies) manually:

1. Disable automatic policies in the admin configuration:
   `hyva_cms/general/auto_csp_frame_policies`
   > Stores > Configuration > Hyvä Themes > CMS > General > Enable Multi Domain CSP Frame Policies
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
3. Enable CSP strict Mode by adding the following to `config.xml` (or to app/etc/env.php):

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

   Note: frame-ancestors overrides X-Frame-Options only in strict mode (Content-Security-Policy). In report-only mode, X-Frame-Options still applies (see [spec](https://w3c.github.io/webappsec-csp/#frame-ancestors-and-frame-options)).

Why do we need CSP frame policies?

For the Hyvä CMS Liveview Editor to be able to display the preview in a cross domain iframe, it requires the correct Content Security Policy (CSP) frame policies to be applied in the editor context.

CSP and Magento

For more information about CSP and Magento, see [CSP and Magento](../../../hyva-themes/writing-code/csp/index.html).

### Handling the Hyva\_CMS Cache

The `hyva_cms` cache is automatically enabled in production environments and disabled in developer mode.
This cache stores component configurations for improved performance.

Depending on your deployment strategy, you may need to include a step to clear the cache on each deployment:

```
bin/magento cache:clean hyva_cms
```

### Component Cache Management

The component system includes caching for:
- Component declarations from `components.json` files

To clear component-specific cache:

```
bin/magento cache:clean hyva_cms
```

### Performance Optimization

#### JIT CSS Compilation

Hyvä CMS uses the `magento2-cms-tailwind-jit` module for compilation.

- Tailwind CSS styles are generated on save of Hyvä CMS content (can be changed to on edit in the editor preferences).
- Custom Tailwind configurations are supported per theme.
- Tailwind JIT compilation can be disabled/enabled globally in Magento store configuration or per Hyvä CMS entity in the editor settings.
- **Note:** Custom classes (e.g. the `.container` class) require extra configuration to produce the same styles as the frontend theme.

For detailed configuration options, see [CMS Tailwind JIT Module Documentation](../../../hyva-themes/cms/cms-tailwind-jit-module.html).

Best Practice: Avoid injecting CSS classes in CMS content

Keep it simple for merchants.

When building CMS components, avoid over-relying on Tailwind classes during content creation. Unlike traditional Page Builder approaches, merchants should never need to add CSS classes to add or edit content.

Build components with specific fields and variant templates so merchants can choose how to display content through simple options, not by adding custom CSS classes or code to fields.
We recommend applying Tailwind classes in the .phtml component templates instead of the CMS content.

**This helps provide a more consistent design system and better user experience for merchants.**
