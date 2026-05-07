<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-0.4.0.html -->

# Upgrading to Hyvä Commerce 0.4.0

This is a feature release for Hyvä CMS that introduces new console commands for URL generation and version-specific patches, along with several improvements to the link handling system.

## Notable news

### Hyvä CMS

#### Backward incompatible changes

##### 1. Link field component changes

Link field type format changes

The format for link field types in CMS content has been updated to be more consistent and portable. This affects existing content in the database.

The following changes have been made to link type values:
- `"Page"` → `"cms_page"`
- `"Product"` → `"product"`
- `"Category"` → `"category"`
- `"URL"` → `"custom_url"`

Additionally, product links now use SKUs instead of IDs, and CMS page links use URL keys instead of IDs for better portability.

```
// Before
{
  "link": {
    "value": "123",
    "type": "Product"
  }
}
// After
{
  "link": {
    "value": "product-sku-123",
    "type": "product"
  }
}
```

###### UPGRADING THE TEMPLATES

We have now included a utility function for your link to function with the new updates (Suffix, Prefix and Label).

If you pass the data into `getLinkData` function, it will return the data in the new format.

```
<?php
    $link = $block->getLinkData($block->getData('link') ?? []);
?>
```

and your link item in the .phtml file will look like this

```
<a href="<?= $escaper->escapeHtmlAttr($link['url']) ?>"
    <?= $link['open_in_new'] ? 'target="_blank" rel="noopener"' : '' ?>>
    <?= $escaper->escapeHtml($link['label']) ?>
</a>
```

###### UPGRADING THE DATABASE

We have now included a temporary [console command](#patch-command) to update any existing data in the database to the new format.

```
bin/magento hyva:liveview:patch 0.4.0
```

##### 2. Tailwind JIT compilation support

Only affects custom integrations of Hyvä CMS with other content types

This change only impacts projects that have [extended Hyvä CMS for other content types](../features/cms/extending-for-other-content-types.html).
You can skip this section if you not extended Hyvä CMS in this way.

Hyvä CMS now uses the [The CMS Tailwind JIT module](../../hyva-themes/cms/cms-tailwind-jit-module.html) for Tailwind JIT compilation.
If you've extended Hyvä CMS for custom content types, update your `Hyva\CmsLiveviewEditor\Api\ProviderInterface` implementations to support Tailwind JIT compilation.

Also review [Extending for Other Content Types](../features/cms/extending-for-other-content-types.html) and the Hyva\_CmsMagento module to see how to include TW JIT compilation in your integration.

#### New Console Commands

Two new console commands have been introduced to help manage Hyvä CMS:

1. `hyva:liveview:generate-urls` - Generates URLs from module controllers for the link handler
2. `hyva:liveview:patch` - Applies version-specific patches for upgrades

For detailed information about these commands, see the [Console Commands](#console-commands) section below.

## Console Commands

### URL Generation Command

#### `hyva:liveview:generate-urls`

Generates URLs from module controllers to add to the Magento section in the link handler (`link-handler.phtml`). This command scans specified modules for frontend routes and controllers, then outputs a JSON file with all discovered URLs.

##### Usage

```
bin/magento hyva:liveview:generate-urls [module1] [module2] [...]
```

##### Examples

Generate URLs for a single module:

```
bin/magento hyva:liveview:generate-urls Magento_Customer
```

##### Output

The command creates a timestamped JSON file in the `var/` directory with the following format:

```
{
    "customer_account_login": {
        "name": "Customer Account Login",
        "value": "customer/account/login"
    },
    "customer_account_create": {
        "name": "Customer Account Create",
        "value": "customer/account/create"
    }
}
```

##### Code Usage

You can now use the generated JSON in your own custom module in `VENDOR/MODULE/etc/hyva_cms/magento_paths.json` to add your own custom paths to the link handler.
See `src/liveview-editor/etc/hyva_cms/magento_paths.json` for an example.

### Patch Command

This patch command will be removed in the future.

During Early Access, we're avoiding adding legacy features to templates to ensure we can keep existing codebase clean. As a temporary solution, we've added a new console command to apply version-specific patches to the database instead of manually running an SQL upgrade script.

#### `hyva:liveview:patch`

Applies version-specific patches for Hyvä Liveview upgrades. This tool helps maintain data compatibility when upgrading between versions by applying necessary database and content transformations.

##### Usage

```
bin/magento hyva:liveview:patch [version] [--confirm]
```

##### Parameters

- `version` (optional): Specific version to patch (e.g., `0.4.0`)
- `--confirm` (flag): Skip confirmation prompt for automated environments

##### Examples

List available patch versions:

```
bin/magento hyva:liveview:patch
```

Apply patches for version 0.4.0 with confirmation:

```
bin/magento hyva:liveview:patch 0.4.0
```

Apply patches without confirmation (for CI/CD):

```
bin/magento hyva:liveview:patch 0.4.0 --confirm
```

Important Safety Guidelines

- Always test patches on a development/staging environment first
- Take a complete database backup before running patches
- Review the patch description to understand what changes will be made
- Monitor the output for any error messages during patch execution

Automation Support

Use the `--confirm` flag when running patches in automated deployment pipelines to skip the interactive confirmation prompt.

## Changelogs

The changelog is available [here](changelog.html#040-2025-05-29).

## Known Issues

See bugfixes in the [0.5.0 release](upgrading-to-0.5.0.html).
