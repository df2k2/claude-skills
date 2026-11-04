# Hyvä Theme Setup and Child Themes

## When to read this

You're starting a new Hyvä install, creating a child theme, configuring Tailwind paths, or wiring up build tools.

## Installation overview

```bash
# 1. Configure auth (one-time per project)
composer config --auth http-basic.hyva-themes.repo.packagist.com token <licenseKey>
composer config repositories.private-packagist composer https://hyva-themes.repo.packagist.com/<projectName>/

# 2. Pull in the default theme + theme-module + email module + base-layout-reset
composer require hyva-themes/magento2-default-theme

# 3. Run Magento upgrade
bin/magento setup:upgrade
```

For the CSP-compliant theme, use `hyva-themes/magento2-default-theme-csp` instead.

After install:
- Activate the theme in **Content > Design > Configuration**, picking `Hyva/default` (or your child theme).
- **Always** also set a theme on the Website level. Leaving the Website on "-- No Theme --" while only the Store View has Hyvä causes weird fallback behavior.
- Run `bin/magento setup:static-content:deploy` in production mode. Nothing extra needed in developer mode.

## Required Magento config tweaks

Disable the legacy captcha (Hyvä uses ReCaptcha instead):
```bash
bin/magento config:set customer/captcha/enable 0
```

Disable Magento's built-in minification/bundling — they don't help Hyvä and can cause issues. Apply per-store-view if you also have a Luma store view that benefits:
```bash
bin/magento config:set dev/template/minify_html 0
bin/magento config:set dev/js/merge_files 0
bin/magento config:set dev/js/enable_js_bundling 0
bin/magento config:set dev/js/minify_files 0
bin/magento config:set dev/js/move_script_to_bottom 0
bin/magento config:set dev/css/merge_css_files 0
bin/magento config:set dev/css/minify_files 0
```

## Required GraphQL modules

Hyvä uses GraphQL for several features. If the install previously ran Luma, GraphQL modules may have been disabled.

**Since Default Theme 1.5.3** the storefront makes no GraphQL calls of its own: the review form, customer review list, and recently-viewed widget went server-side or browser-storage. The modules must still be **installed and enabled**, because `Hyva_Theme` still requires `magento/module-quote-graph-ql`. If nothing else uses GraphQL, the `/graphql` route can then be blocked. Two cases still call GraphQL:
- Overrides of those three templates keep calling it until they are updated.
- Modules that use `GraphqlViewModel` or the customer section's `signin_token` must now `require` `hyva-themes/magento2-graphql-view-model` / `magento2-graphql-tokens` themselves.

On 1.4.x and 1.5.1–1.5.2, the modules below are required at runtime. Required modules include:

`Magento_BundleGraphQl`, `Magento_CatalogCustomerGraphQl`, `Magento_CatalogGraphQl`, `Magento_CatalogRuleGraphQl`, `Magento_CatalogUrlRewriteGraphQl`, `Magento_ConfigurableProductGraphQl`, `Magento_CustomerGraphQl`, `Magento_DirectoryGraphQl`, `Magento_DownloadableGraphQl`, `Magento_EavGraphQl`, `Magento_GraphQl`, `Magento_GroupedProductGraphQl`, `Magento_QuoteGraphQl`, `Magento_GraphQlCache`, `Magento_RelatedProductGraphQl`, `Magento_ReviewGraphQl`, `Magento_SalesGraphQl`, `Magento_StoreGraphQl`, `Magento_SwatchesGraphQl`, `Magento_UrlRewriteGraphQl`, `Magento_WishlistGraphQl`.

Check status:
```bash
bin/magento module:status Magento_GraphQl Magento_CatalogGraphQl Magento_QuoteGraphQl
```

Enable any that are off:
```bash
bin/magento module:enable Magento_QuoteGraphQl
bin/magento setup:upgrade
```

## Creating a child theme

**Always work in a child theme.** Don't edit the vendor default theme. The directory layout follows Magento conventions:

```
app/design/frontend/Vendor/ThemeName/
├── theme.xml
├── registration.php
├── composer.json (optional)
├── etc/
│   └── view.xml
├── media/
│   └── preview.png  (Hyvä uses .png, not .jpg)
├── web/
│   ├── tailwind/   (full copy from parent)
│   ├── css/        (build output, gitignored is fine)
│   ├── images/
│   └── fonts/
├── Magento_Theme/
│   ├── layout/
│   ├── templates/
│   └── ...
└── (other Magento_* module directories as needed)
```

### `theme.xml`

```xml
<?xml version="1.0"?>
<theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
    <title>Acme Hyvä Child</title>
    <parent>Hyva/default</parent>
    <media>
        <preview_image>media/preview.png</preview_image>
    </media>
</theme>
```

For CSP-strict child:
```xml
<parent>Hyva/default-csp</parent>
```

### `registration.php`

```php
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::THEME,
    'frontend/Acme/default',
    __DIR__
);
```

## Copying the Tailwind build setup to the child theme

The child theme needs its own copy of the Tailwind build config — `package.json`, `hyva.config.json`, `tailwind-source.css`, etc.

```bash
mkdir -p app/design/frontend/Acme/default/web
cp -r vendor/hyva-themes/magento2-default-theme/web/* app/design/frontend/Acme/default/web/
```

Then point Tailwind at the parent theme so its templates are included in scanning.

`app/design/frontend/Acme/default/web/tailwind/hyva.config.json`:
```json
{
  "tailwind": {
    "include": [
      { "src": "vendor/hyva-themes/magento2-default-theme" }
    ]
  }
}
```

If the child is based on `magento2-default-theme-csp`, use that path instead:
```json
{
  "tailwind": {
    "include": [
      { "src": "vendor/hyva-themes/magento2-default-theme-csp" }
    ]
  }
}
```

You can include multiple sources (e.g., to scan classes used in third-party modules under `app/code`):
```json
{
  "tailwind": {
    "include": [
      { "src": "vendor/hyva-themes/magento2-default-theme" },
      { "src": "app/code/Acme/CustomModule" }
    ]
  }
}
```

## First Tailwind build

```bash
cd app/design/frontend/Acme/default/web/tailwind
npm ci
npm run build       # one-shot production build → web/css/styles.css
# or
npm run watch       # watch mode (alias: npm start since 1.4.0)
```

Run from anywhere using `--prefix`:
```bash
npm --prefix app/design/frontend/Acme/default/web/tailwind run build
```

## Activating the child theme

In Magento admin: **Content > Design > Configuration** → set the new theme on the appropriate Store View **and** at the Website level.

Or via CLI / DB:
```bash
bin/magento config:set design/theme/theme_id "Acme/default" --scope=stores --scope-code=default
```

## Verifying it worked

- **Developer mode**: Reload the storefront. May need `bin/magento cache:flush`.
- **Production mode**: `bin/magento setup:static-content:deploy -f Acme/default` (or omit theme to deploy all).
- **Default mode**: Don't run Magento in default mode for Hyvä.

If styles are missing, the most common causes are:
1. Tailwind hasn't been built (`npm run build` from the child's `web/tailwind`).
2. The parent theme path in `hyva.config.json` is wrong.
3. Static content wasn't deployed in production mode.
4. The Magento cache wasn't flushed.
5. The theme isn't set at the Website level.

## CI/CD

Build Tailwind during deployment, not at runtime. Sample steps:
```bash
composer install --no-dev --optimize-autoloader
bin/magento setup:upgrade --keep-generated
npm --prefix app/design/frontend/Acme/default/web/tailwind ci
npm --prefix app/design/frontend/Acme/default/web/tailwind run build
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f
```

Use packagist.com (not GitLab SSH) in CI/CD pipelines — GitLab availability isn't guaranteed.

## Original sources

If you need more depth than the above, the canonical docs are bundled at:

- `references/sources/hyva-themes/getting-started/index.md` — full installation guide
- `references/sources/hyva-themes/building-your-theme/index.md` — child theme creation
- `references/sources/hyva-themes/building-your-theme/ci-cd-hyva-installation.md` — CI/CD specifics
- `references/sources/hyva-themes/building-your-theme/deploying-hyva-to-production.md` — production deploy
- `references/sources/hyva-themes/building-your-theme/luma-theme-fallback.md` — running Hyvä next to Luma
- `references/sources/hyva-themes/faqs/configuring-packagist-and-gitlab.md` — repo configuration FAQs
- `references/sources/hyva-themes/faqs/sample-data.md` — sample data setup
