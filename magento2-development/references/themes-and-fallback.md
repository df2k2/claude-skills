# Themes and Fallback

A Magento theme is a directory under `app/design/<area>/<Vendor>/<theme>/` that overrides templates, layout, CSS, and JS for a specific area (`frontend` or `adminhtml`). Themes inherit from a parent — most themes inherit from `Magento/blank` or `Magento/luma` (or `Hyva/default` if Hyvä). Customizations override individual files; everything else falls through to the parent.

## Minimum theme structure

```
app/design/frontend/Acme/storefront/
├── theme.xml
├── registration.php
├── composer.json           ← optional, for Composer-installable themes
├── etc/
│   └── view.xml            ← image sizes, JS bundling config
├── media/
│   └── preview.jpg         ← thumbnail in admin
├── web/
│   ├── css/
│   │   └── source/
│   │       ├── _theme.less    ← LESS variables (Luma child)
│   │       ├── _extend.less
│   │       └── _module.less
│   ├── images/
│   ├── fonts/
│   └── js/
└── Magento_Theme/          ← per-module override directory (multiple of these)
    ├── layout/
    │   └── default.xml
    └── templates/
        └── html/
            └── header.phtml
```

### `theme.xml`
```xml
<?xml version="1.0"?>
<theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
    <title>Acme Storefront</title>
    <parent>Magento/luma</parent>
    <media>
        <preview_image>media/preview.jpg</preview_image>
    </media>
</theme>
```

- `<parent>` — `Magento/blank`, `Magento/luma`, or `Hyva/default` for Hyvä, or another custom theme.
- `<title>` — display name shown in admin under Content → Design → Themes.

### `registration.php`
```php
<?php
use Magento\Framework\Component\ComponentRegistrar;

ComponentRegistrar::register(
    ComponentRegistrar::THEME,
    'frontend/Acme/storefront',
    __DIR__
);
```

The theme identifier is `<area>/<vendor>/<name>` — exactly matching the folder path.

## Inheritance and fallback

When Magento needs a file (template, layout XML, CSS, JS, locale file), it searches in this order:

1. Active theme: `app/design/frontend/Acme/storefront/Magento_Catalog/templates/product/view.phtml`
2. Parent theme: `app/design/frontend/Magento/luma/Magento_Catalog/templates/product/view.phtml`
3. Grandparent theme: `app/design/frontend/Magento/blank/Magento_Catalog/templates/product/view.phtml`
4. Module's `view/<area>/`: `vendor/magento/module-catalog/view/frontend/templates/product/view.phtml`
5. Module's `view/base/` (cross-area): `vendor/magento/module-catalog/view/base/templates/product/view.phtml`

The **first hit wins**. To override a Magento template, mirror its path inside your theme:

```
vendor/magento/module-catalog/view/frontend/templates/product/view.phtml
    ↓ override at:
app/design/frontend/Acme/storefront/Magento_Catalog/templates/product/view.phtml
```

Same for layout:
```
vendor/magento/module-customer/view/frontend/layout/customer_account.xml
    ↓ override at:
app/design/frontend/Acme/storefront/Magento_Customer/layout/customer_account.xml
```

(Theme-level layout XML is MERGED with module-level — not replaced. You only need to declare what you're changing.)

For CSS/JS, fallback works the same but bundling complicates things — covered below.

## Selecting an active theme

In admin: **Content → Design → Configuration** → choose a store view → **Edit** → set "Applied Theme".

Or by CLI: there's no direct CLI, but `bin/magento config:set design/theme/theme_id <ID>` works (the ID is the DB row, look it up first). On a clean install, `bin/magento config:set design/theme/theme_id` won't have your custom theme until it's been registered (which happens on `setup:upgrade`).

After changing themes:
```
bin/magento cache:flush
bin/magento setup:static-content:deploy -f <locale>   # production mode only
```

## Static content deployment

In **developer** mode, Magento generates static files (CSS, JS, images, locale files) on-demand into `pub/static/<area>/<theme>/<locale>/`. Slower per-request but no deploy needed.

In **production**, static content must be pre-deployed:

```
bin/magento setup:static-content:deploy -f en_US fr_FR
```

This:
- Compiles LESS → CSS.
- Resolves theme fallback and copies the resulting files into `pub/static/`.
- Generates RequireJS configs.
- Creates `requirejs-config.js` per area/theme/locale.

Flags:
- `-f` — force overwrite (default skips). Always pass `-f` in CI.
- `--jobs 4` — parallel.
- `--theme=Acme/storefront` — limit to one theme.
- `--area=frontend` — limit to one area.
- `--no-javascript`, `--no-css`, etc. — skip a content type during testing.

The output goes to `pub/static/frontend/Acme/storefront/en_US/`. Webserver serves it from there. Cache-busting versions are managed via `pub/static/version` (a file). Bump it (or run `setup:static-content:deploy` which bumps it) to invalidate browser caches.

If you see "404 on /static/version1234567890/frontend/.../mage/translate.json" after a deploy, the version file was bumped but caches didn't refresh — `cache:flush` and force-refresh the browser.

## LESS compilation (Luma stack only)

Luma's CSS is built from LESS. Two compilation modes:

### Server-side (default)
Magento compiles LESS to CSS on first request and on `setup:static-content:deploy`. Slower but no Node.js needed.

### Client-side
Magento sends LESS to the browser and compiles via `less.js` (in dev mode only — never for production). Faster iteration: edit `_theme.less`, refresh, see changes. Configure in admin: **Stores → Configuration → Advanced → Developer → Frontend Development Workflow Type → Client side less compilation**.

### Grunt (optional, faster CSS iteration in dev)
The bundled `Gruntfile.js` and `package.json.sample` set up Grunt for LESS watching:
```
cp package.json.sample package.json
cp Gruntfile.js.sample Gruntfile.js
cp grunt-config.json.sample grunt-config.json
npm install
grunt exec:<theme-alias>   # initial compile
grunt watch                # watch
```
Configure your theme as an alias in `dev/tools/grunt/configs/themes.js`. Grunt has been increasingly deprecated since 2.4.7 but still works.

### LESS overrides — `_extend.less` vs `_theme.less`

In your child theme's `web/css/source/`:
- `_theme.less` — REDEFINES variables. Replaces the parent's `_theme.less` entirely. If you only want to override a few variables, this is heavy.
- `_extend.less` — ADDS to the parent. The parent's `_theme.less` runs first, then yours runs. **Preferred** for small overrides.
- `_module.less` files inside `Magento_X/web/css/source/` — apply per-module CSS.

Variables: `@color-primary`, `@font-family-base`, `@breakpoint-md`, etc. See `vendor/magento/theme-frontend-luma/web/css/source/_theme.less` for the canonical list.

## RequireJS and JavaScript

Every theme can have a `requirejs-config.js` at `<theme>/<Magento_X>/requirejs-config.js` (per-module) or `<theme>/requirejs-config.js` (root). These get merged by Magento into a single config that's served to the browser.

```js
// app/design/frontend/Acme/storefront/Magento_Theme/requirejs-config.js
var config = {
    paths: {
        'acme/hello': 'Acme_Theme/js/hello'
    },
    shim: {
        'acme/hello': {
            deps: ['jquery']
        }
    },
    config: {
        mixins: {
            'Magento_Checkout/js/view/summary/cart-items': {
                'Acme_Theme/js/mixin/cart-items-mixin': true
            }
        }
    }
};
```

- `paths` — alias-to-file mappings. The path `Acme_Theme/js/hello` resolves to `pub/static/frontend/Acme/storefront/<locale>/Acme_Theme/js/hello.js` (file source: `app/design/frontend/Acme/storefront/Acme_Theme/web/js/hello.js`).
- `shim` — for non-AMD scripts, declare dependencies and exports.
- `config.mixins` — register a mixin (sits on top of another module). See `frontend-js-and-ui.md`.

## `view.xml` — theme-level image and bundle config

```xml
<?xml version="1.0"?>
<view xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/view.xsd">
    <media>
        <images module="Magento_Catalog">
            <image id="category_page_grid" type="small_image">
                <width>300</width>
                <height>375</height>
            </image>
            <image id="product_page_main_image" type="image">
                <width>700</width>
                <height>700</height>
            </image>
            <!-- ... -->
        </images>
    </media>
    <vars module="Js_Bundle">
        <var name="bundle_size">1MB</var>
    </vars>
</view>
```

The image entries here drive Magento's catalog image resizing — each combination of width/height creates a distinct cache key, and Magento generates a resized variant on the fly. After editing `view.xml`, run:

```
bin/magento catalog:images:resize   # background-friendly (queues to a process)
```

## Composer-installable themes

For distributing a theme as a package:

`composer.json`:
```json
{
    "name": "acme/theme-frontend-storefront",
    "type": "magento2-theme",
    "license": "proprietary",
    "version": "1.0.0",
    "require": {
        "php": "~8.1.0||~8.2.0||~8.3.0",
        "magento/framework": "*",
        "magento/theme-frontend-luma": "*"
    },
    "autoload": {
        "files": ["registration.php"]
    }
}
```

`type: magento2-theme` puts it into `app/design/<area>/<vendor>/<name>/` after `composer require`.

## Deploying static content to a CDN

A common production setup serves `pub/static/` from a CDN. Configure `MAGE_MODE=production` and:

```
bin/magento config:set web/secure/base_static_url https://cdn.example.com/static/
bin/magento config:set web/unsecure/base_static_url https://cdn.example.com/static/
bin/magento config:set web/secure/use_in_adminhtml 1
```

The CDN should pass through `?_=…` query strings unchanged. `setup:static-content:deploy` writes to local `pub/static/` — sync it to the CDN afterward.

## Common gotchas

### "My CSS change isn't appearing"
- Production mode: `setup:static-content:deploy -f` not run.
- Dev mode + LESS server-side: `pub/static/frontend/Acme/storefront/en_US/css/styles-m.css` was generated stale. Delete it and refresh.
- Browser cache. Hard-refresh.
- Wrong theme is active. Check `bin/magento config:show design/theme/theme_id --scope store --scope-code <code>`.

### "My template override isn't being picked up"
- Path mismatch — `Magento_Catalog/templates/product/view.phtml`, not `Magento_Catalog/template/product/view.phtml` (singular vs plural). Case matters on Linux.
- Theme isn't set as active for the right store view.
- `cache:clean layout block_html` not run.

### Static files served with version-string redirects (404s)
The `pub/static/version<ts>/` path is rewritten by webserver rules. Make sure your Nginx/Apache config matches Magento's stock config — these rules live in `nginx.conf.sample` / `.htaccess`.

### Child theme inheritance breaks after Magento upgrade
If your `_theme.less` redefines a variable that Magento renamed or removed, you'll get LESS compile errors. Use `_extend.less` for additions and only override what's truly necessary.

### "Cannot deploy static content, theme not found"
Run `bin/magento setup:upgrade` first — it registers the theme in the DB. Themes added to `app/design/` aren't usable until `setup:upgrade` discovers them.

### Browser console: "Unable to GET requirejs-config.js"
Probably:
- File doesn't exist at the expected path.
- Static deploy didn't run.
- File syntax error (a `var config = ` block must be valid JS).

### `pub/static/version` mismatch on multi-server
Two web nodes with different `version` files → browser caches diverge → users see broken assets. Either pin the version file post-deploy (rsync it last) or use a shared filesystem.

## Original sources

- `references/sources/commerce-frontend-core/guide/themes/` — theme guide.
- `references/sources/commerce-frontend-core/guide/themes/theme-inherit.md` — inheritance specifics.
- `references/sources/commerce-frontend-core/guide/themes/theme-apply.md` — applying a theme.
- `references/sources/devdocs-v2.4/frontend-dev-guide/themes/` — older theme docs.
- `references/sources/commerce-frontend-core/guide/css/` — CSS / LESS guide.
