# Extension Packaging (composer.json and zip structure)

Package Verification is the second technical check (after Malware Scan) and is the most common reason a submission fails before it even reaches the code sniffer. The rules are mechanical and unforgiving. This reference reproduces the full set, gives canonical `composer.json` templates for each package type, and lists every forbidden configuration.

## Hard package rules

A submitted zip must:

1. Be a zip archive.
2. Be **≤ 30 MB** uncompressed (Marketplace rejects oversized packages outright).
3. Contain a `composer.json` at the root of the archive (not inside a subfolder named `vendor/module/`).
4. Have a `composer.json` that declares all of: `name`, `type`, `version`.
5. Not contain `FIXME` / `TODO` style comments that suggest incomplete development (the verification scanner greps for these).

The `composer.json` must:

6. Have a `type` value of one of:
   - `magento2-module` — for extensions and shared modules.
   - `magento2-theme` — for themes (and shared themes).
   - `magento2-language` — for language packs (and shared language packs).
   - `metapackage` — for bundles.
7. Not declare `extra.map`.
8. Not declare `extra.magento-root-dir`.
9. Not exclude any PHP version supported by the Magento line(s) being claimed for compatibility (i.e., if you claim 2.4.7 compat, you must allow PHP 8.1, 8.2, and 8.3 in your `require.php`).
10. Not declare any of the following as a dependency, anywhere in `require` / `require-dev`:
    - `magento/magento-composer-installer`
    - `magento/magento2-base`
    - `magento/product-community-edition`
    - `magento/magento2-ee-base`
    - `magento/product-enterprise-edition`
11. Not use `*` as a version constraint for `magento/*` packages. Real version ranges only.
12. Not use Composer require-inline aliases (the `... as ...` syntax in `require`).

Then type-specific rules:

13. For `magento2-module`: must have valid `etc/module.xml` AND `registration.php`. `composer.json`'s `autoload.files` must include `registration.php`. `composer.json`'s `autoload.psr-4` must declare at least one namespace.
14. For `magento2-theme`: must have valid `theme.xml` AND `registration.php`. `composer.json`'s `autoload.files` must include `registration.php`. **`autoload.psr-4` must not be declared.**
15. For `magento2-language`: must have valid `language.xml` AND `registration.php`. `composer.json`'s `autoload.files` must include `registration.php`. **`autoload.psr-4` must not be declared.**
16. For `metapackage`: at least one entry in `require`.

Apps (App Builder) are submitted differently — see the app packaging section at the bottom.

## Canonical `composer.json` for `magento2-module`

```json
{
  "name": "yourvendor/module-awesome-connector",
  "description": "Connector for Awesome service in Adobe Commerce / Magento Open Source.",
  "type": "magento2-module",
  "version": "1.2.0",
  "license": [
    "OSL-3.0"
  ],
  "require": {
    "php": "~8.1.0||~8.2.0||~8.3.0||~8.4.0",
    "magento/framework": "^103.0",
    "magento/module-catalog": "^104.0",
    "magento/module-checkout": "^100.4"
  },
  "autoload": {
    "files": [
      "registration.php"
    ],
    "psr-4": {
      "YourVendor\\AwesomeConnector\\": ""
    }
  }
}
```

Notes:

- `name` is `vendor/package`. Lowercase, hyphens only, ASCII. `vendor` must match your developer name on the portal.
- `version` is required by Marketplace verification (`composer` itself doesn't strictly require it, but EQP does — Marketplace rejects packages without it).
- `license` is a SPDX identifier or array of identifiers. The Marketplace UI's license-type dropdown accepts: `OSL-3.0`, `AFL-3.0`, `Apache-2.0`, `BSD-2-Clause`, `GPL-3.0`, `LGPL-3.0`, `MIT`, `MPL-1.1`, or a custom license name with a URL. Match the SPDX identifier here to what you select in the UI.
- `require.php` must contain *every* PHP version your claimed Magento lines support. The verifier reads the Magento line list, derives the union of supported PHP versions, and checks your constraint covers it.
- `require` for Magento packages: use real ranges (`^103.0`, `~104.0.0`, `>=103.0.0 <104.0.0`), not `*`. Follow Adobe's recommendations in https://developer.adobe.com/commerce/php/development/versioning/dependencies.

## Canonical `composer.json` for `magento2-theme`

```json
{
  "name": "yourvendor/theme-frontend-aurora",
  "description": "Aurora storefront theme.",
  "type": "magento2-theme",
  "version": "2.0.1",
  "license": [
    "MIT"
  ],
  "require": {
    "php": "~8.1.0||~8.2.0||~8.3.0||~8.4.0",
    "magento/framework": "^103.0",
    "magento/theme-frontend-luma": "^100.4"
  },
  "autoload": {
    "files": [
      "registration.php"
    ]
  }
}
```

**Do not** add `autoload.psr-4` — themes don't have PHP namespaces, only XML/CSS/JS/templates. Package Verification will reject a theme package that declares `psr-4`.

## Canonical `composer.json` for `magento2-language`

```json
{
  "name": "yourvendor/language-fr-fr",
  "description": "French (France) language pack.",
  "type": "magento2-language",
  "version": "1.0.5",
  "license": [
    "OSL-3.0"
  ],
  "require": {
    "magento/framework": "^103.0"
  },
  "autoload": {
    "files": [
      "registration.php"
    ]
  }
}
```

Same rule as themes — no `autoload.psr-4`. Language packs may or may not have a PHP constraint; they typically need only `magento/framework`.

## Canonical `composer.json` for `metapackage`

```json
{
  "name": "yourvendor/suite-awesome",
  "description": "All-in-one Awesome suite for Adobe Commerce.",
  "type": "metapackage",
  "version": "3.0.0",
  "license": [
    "OSL-3.0"
  ],
  "require": {
    "yourvendor/module-awesome-connector": "^1.2.0",
    "yourvendor/module-awesome-reports": "^1.1.0",
    "yourvendor/theme-frontend-aurora": "^2.0.0"
  }
}
```

Metapackages must declare at least one `require`. They have no autoload (no files). They reference your own already-published shared/standalone packages (each of which goes through its own EQP review).

## `registration.php` shape per type

For `magento2-module`:

```php
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::MODULE,
    'YourVendor_AwesomeConnector',
    __DIR__
);
```

For `magento2-theme`:

```php
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::THEME,
    'frontend/YourVendor/aurora',
    __DIR__
);
```

For `magento2-language`:

```php
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::LANGUAGE,
    'fr_FR',
    __DIR__
);
```

## `etc/module.xml` shape (modules only)

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="YourVendor_AwesomeConnector">
        <sequence>
            <module name="Magento_Catalog"/>
        </sequence>
    </module>
</config>
```

If your module depends on another module, declare it under `<sequence>`. Don't declare a `setup_version` attribute on `<module>` — that's a Magento ≤ 2.2 artifact and is rejected by the modern code sniffer (`Magento2.Legacy.InstallUpgrade`).

## `theme.xml` shape (themes only)

```xml
<?xml version="1.0"?>
<theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
    <title>Aurora</title>
    <parent>Magento/luma</parent>
    <media>
        <preview_image>media/preview.jpg</preview_image>
    </media>
</theme>
```

## `language.xml` shape (language packs only)

```xml
<?xml version="1.0"?>
<language xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:noNamespaceSchemaLocation="urn:magento:framework:Setup/Declaration/Schema/etc/language.xsd">
    <code>fr_FR</code>
    <vendor>YourVendor</vendor>
    <package>fr_FR</package>
</language>
```

## Versioning constraints for Magento dependencies

The verifier rejects `*` constraints on `magento/*` packages. Use the constraints recommended by Adobe's PHP Developer Guide. A safe pattern is to look up the module version that shipped with the *oldest* Magento version you claim to support and use `^` from there.

Examples:

- `magento/framework`: `^103.0` (2.4.5+) — covers 2.4.5 through 2.4.9.
- `magento/module-catalog`: `^104.0` — covers 2.4.6 onwards.
- `magento/module-checkout`: `^100.4` — covers 2.4.x.

For a quick check of which module versions ship with which Magento release, see the meta-package composer.json at `vendor/magento/product-community-edition/composer.json` after a clean install of each minor.

## Forbidden composer.json patterns (cheat sheet)

| Pattern | Why it's banned | What to use instead |
| --- | --- | --- |
| `"type": "magento2-component"` | Not a valid M2 type | One of the four valid types. |
| `"type": "magento-module"` (no `2`) | M1 type | `magento2-module`. |
| `"require": { "magento/magento2-base": "*" }` | Forbidden dep | Don't depend on it; the merchant's own M2 install provides it. |
| `"require": { "magento/framework": "*" }` | Wildcard banned for magento/* | `^103.0` or similar concrete range. |
| `"extra": { "magento-root-dir": "." }` | M1-era hack | Remove. |
| `"extra": { "map": [["", "."]] }` | M1-era hack | Remove. |
| `"require": { "yourvendor/lib": "1.0 as 1.0.0" }` | Composer inline alias | Pin the version normally. |
| `magento2-theme` with `"autoload": { "psr-4": { ... } }` | Themes have no namespace classes | Drop the `psr-4` block. |
| `magento2-module` with `"autoload": { "files": ["bootstrap.php"] }` (no `registration.php`) | `registration.php` is mandatory in `files` | Add it. |
| `magento2-module` with no `autoload.psr-4` | Modules need their namespace declared | Add `"YourVendor\\Module\\": ""`. |
| `metapackage` with empty `require` | Empty metapackages are pointless | Add at least one dep. |
| `composer.json` missing `version` | EQP requires explicit version | Add it (matches the new-version field in the UI). |

## Directory layout

A typical `magento2-module` package zip:

```
yourvendor-module-awesome-connector-1.2.0.zip
├── composer.json
├── registration.php
├── etc/
│   ├── module.xml
│   ├── di.xml
│   ├── webapi.xml             (optional)
│   ├── events.xml             (optional)
│   ├── frontend/
│   │   └── routes.xml
│   └── adminhtml/
│       ├── menu.xml
│       ├── system.xml
│       └── acl.xml
├── Block/
├── Controller/
├── Model/
├── Helper/
├── Setup/
├── view/
│   ├── frontend/
│   │   ├── layout/
│   │   ├── templates/
│   │   └── web/
│   └── adminhtml/
└── Test/
    └── Mftf/
        ├── ActionGroup/
        ├── Page/
        ├── Section/
        └── Test/
```

A typical `magento2-theme` package zip:

```
yourvendor-theme-frontend-aurora-2.0.1.zip
├── composer.json
├── registration.php
├── theme.xml
├── media/
│   └── preview.jpg
├── web/
│   ├── css/
│   ├── images/
│   └── tailwind/   (if Hyvä-based)
├── etc/
│   └── view.xml
├── Magento_Theme/
│   └── layout/
└── ...
```

## How to build the zip

Recommend this from any extension repo:

```bash
# From the module root (where composer.json lives):
zip -r yourvendor-module-awesome-connector-1.2.0.zip . \
    -x '.git/*' \
    -x '.github/*' \
    -x 'tests/_output/*' \
    -x 'node_modules/*' \
    -x 'vendor/*' \
    -x '.idea/*' \
    -x '.vscode/*' \
    -x '*.log' \
    -x '.DS_Store'
```

Verify the zip:

```bash
# Must have composer.json at root:
unzip -l yourvendor-module-awesome-connector-1.2.0.zip | head -20

# Must be < 30 MB:
ls -lh yourvendor-module-awesome-connector-1.2.0.zip

# composer must validate it:
unzip -p yourvendor-module-awesome-connector-1.2.0.zip composer.json | composer validate --no-check-publish -
```

## App Builder app packaging (the alternative path)

App submissions are not Composer packages. The zip must contain:

- `install.yaml` — App Builder install descriptor.
- `package.json` — Node-side metadata. Must declare `name` and `version`.

Beyond those two, the App can ship whatever it needs (React source, App Builder action code, etc.). No coding standard runs against the JS, and there is no `etc/module.xml` requirement. See `https://developer.adobe.com/commerce/extensibility/` for the App Builder development guide; this skill covers only the marketplace submission angle for apps.

## Quick checklist before clicking "Upload Package"

- [ ] Zip ≤ 30 MB.
- [ ] `composer.json` at the root.
- [ ] `name`, `type`, `version` all set.
- [ ] `type` is one of `magento2-module` / `magento2-theme` / `magento2-language` / `metapackage`.
- [ ] No forbidden Magento deps in `require`.
- [ ] No `*` constraints on `magento/*`.
- [ ] No `extra.map` or `extra.magento-root-dir`.
- [ ] No require-inline aliases.
- [ ] `php` constraint covers every PHP version of every claimed Magento line.
- [ ] Type-appropriate files exist (`etc/module.xml` + `registration.php` for modules, etc.).
- [ ] Type-appropriate autoload shape (`psr-4` for modules only).
- [ ] No `FIXME` / `TODO` comments in source.
- [ ] `composer validate` passes.

## Original sources

- `references/sources/commerce-marketplace/guides/sellers/technical-review-guidelines.md` (the canonical rule list)
- `references/sources/commerce-marketplace/guides/sellers/extension-create.md`
- `references/sources/commerce-marketplace/guides/sellers/extension-version.md`
- `references/sources/commerce-marketplace/guides/sellers/technical-reference.md`
- https://developer.adobe.com/commerce/php/development/package/component (Adobe's "How to Package Magento Extensions" guide)
- https://developer.adobe.com/commerce/php/development/versioning/dependencies (versioning rules for `magento/*` deps)
