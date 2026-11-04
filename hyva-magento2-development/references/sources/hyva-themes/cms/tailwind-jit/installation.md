<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/installation.html -->

# Installing the CMS Tailwind JIT Module

Included with Hyvä CMS

The CMS Tailwind JIT module (`Hyva_CmsTailwindJit`) is automatically installed as a dependency of Hyvä CMS. When using Hyvä Theme with PageBuilder only, it must be installed explicitly.

## Installing

Install the CMS Tailwind JIT module using Composer:

```
composer require hyva-themes/magento2-cms-tailwind-jit
```

Then enable the module and apply database schema changes:

```
bin/magento setup:upgrade
```

## Selecting the Tailwind Compiler Version

The module ships both the Tailwind v3 and the Tailwind v4 in-browser compiler. A single global system configuration field selects which one the admin loads when CMS content is edited:

`Stores → Configuration → Hyvä Themes → PageBuilder → CMS Tailwind Compilation → PageBuilder Tailwind Compiler`

| Option | Config value | Per-theme source file |
| --- | --- | --- |
| Tailwind v3 (in-browser) | `v3` (default) | `web/tailwind/tailwind.browser-jit-config.js` (JavaScript) |
| Tailwind v4 (in-browser) | `v4` | `web/tailwind/tailwind.browser-jit.css` (CSS) |

The setting is stored at the config path `hyva_cms_tailwind_jit/general/compiler_version` and is **global scope only** — one compiler version applies to the entire Magento instance.

Use Tailwind v4 for new installations

For a new installation, select **Tailwind v4 (in-browser)** from the start. Tailwind v4 produces significantly smaller compiled CSS than v3, so less CSS is injected with each CMS entity. The resulting smaller page size improves page load performance, which benefits SEO. Set up your themes for v4 as described in [Configuration](configuration.html) before going live.

To select v4 from the command line — for example in a setup script or deployment pipeline — run:

```
bin/magento config:set --lock-config hyva_cms_tailwind_jit/general/compiler_version v4
```

The `--lock-config` flag writes the value to `app/etc/config.php` and locks it, so it can be committed to version control and is no longer editable in the admin.

Default is Tailwind v3 for backward compatibility

The default is `v3`, so installations that previously used the Tailwind v3 only version of the module behave exactly as before. To use Tailwind v4, switch the setting to **Tailwind v4 (in-browser)**. Any theme that has a `web/tailwind/tailwind.browser-jit-config.js` must first migrate its customizations to the Tailwind v4 CSS format in `web/tailwind/tailwind.browser-jit.css` (see [Configuration](configuration.html)); themes that rely only on the default Tailwind utility classes need no per-theme source file. See [Migrating from Tailwind v3 to v4](configuration.html#migrating-from-tailwind-v3-to-v4) for the full procedure.

Per-theme source files are optional. The default Tailwind utility classes work without one. When you save the configuration, the module emits an informational admin notice listing any Hyvä theme that lacks the active version's source file — this is a hint, not a warning.

See [Configuration](configuration.html) for the per-theme source file formats for each version.

## Edge Case: Instances Without PageBuilder

Skip this section unless PageBuilder is disabled on your instance — it does not apply to standard installations.

Required when PageBuilder modules are disabled

If your Magento instance has PageBuilder modules disabled, you must disable a JavaScript mixin in the CMS Tailwind JIT module to prevent admin errors.

Create a RequireJS configuration file in your custom module to disable the mixin:

app/code/My/Module/view/adminhtml/requirejs-config.js

```
var config = {
    config: {
        mixins: {
            // Disable the PageBuilder form mixin when PageBuilder is not installed
            'Magento_Ui/js/form/form': {
                'Hyva_CmsTailwindJit/js/form/pagebuilder-form-submit-mixin': false
            }
        }
    }
};
```

Add `Hyva_CmsTailwindJit` as a dependency in your custom module's `etc/module.xml` to ensure correct load order:

app/code/My/Module/etc/module.xml

```
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="My_Module">
        <sequence>
            <!-- Load after CMS Tailwind JIT module to override its mixin -->
            <module name="Hyva_CmsTailwindJit"/>
        </sequence>
    </module>
</config>
```

After creating these files, flush the Magento cache. In production mode, also deploy static content:

```
bin/magento cache:flush
bin/magento setup:static-content:deploy
```
