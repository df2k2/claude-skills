<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/troubleshooting.html -->

# TailwindCSS Troubleshooting

## Missing CSS or Build Failures

### `@import` is not found with Tailwind v4

In Tailwind CSS v4, the path resolution for `@import` statements is stricter.
This can cause build errors if you are using older, non-standard import paths for local files.

To fix this, you must use an explicit relative path (`./` or `../`) for any local CSS files you import.

For example, the following will not work:

```
/* This works with Tailwind v3, but not v4! */
@import "acme/file.css";
```

Instead, the import path has to be explicitly marked as relative:

```
/* To import a local file, start the relative path with ./ or ../ */
@import "./acme/file.css";
```

Starting relative paths for `@import` with `./` or `../` works with Tailwind v3 and v4!

### `Unknown at rule: @screen` on Tailwind v4 builds

If your Tailwind v4 build warns on `@screen md` (for example in Hyvä Checkout CSS), the `@screen` directive was removed in Tailwind v4. Use the new breakpoint variants or upgrade to the Tailwind v4-ready CSS provided by Hyvä.

**Fixes**

- Hyvä Themes 1.4+: follow the Tailwind v4 guidance and replace `@screen md { ... }` with the new breakpoint variant syntax (for example `@variant md { ... }` or `md:` on utilities). See the Tailwind docs: <https://tailwindcss.com/docs/adding-custom-styles#using-variants>.
- Hyvä Checkout: upgrade to version `1.3.6` or newer, which ships Tailwind v4-compatible CSS. Older versions will emit this warning when built with Tailwind v4.

### `.gitignore` conflict with Tailwind v4 `@source`

Tailwind v4's `@source` directive applies patterns from `.gitignore` files.

This causes an issue in projects that use exclude files from git that should be matched.
Most commonly this happens in projects excluding everything from GIT and then selectively un-excluding the paths that should be stored.

For example, the following `.gitignore` would prevent files in `vendor/hyva-themes/magento2-default-theme` to be scanned by Tailwind v4:

```
# TW4 incompatible example:
*
!app/
!README.md
```

When it encounters the `*` pattern, it ignores all files that are not explicitly allowed,
including source files from other themes located in the `vendor/` directory (e.g., `vendor/hyva-themes/magento2-default-theme`).

This prevents Tailwind v4 from creating the necessary CSS, leading to missing styles and a broken build.

**Solution: use a "Deny-List" `.gitignore`**

To resolve this, switch to a "deny-list" approach in your `.gitignore`.
Instead of ignoring everything, explicitly list only the files and directories that should be ignored.

This ensures Tailwind v4 can correctly scan the project and resolve `@source` paths.

Example Tailwind v4 compatible `.gitignore`

A great starting point is the [official Magento 2 .gitignore file](https://raw.githubusercontent.com/magento/magento2/refs/heads/2.4-develop/.gitignore), which is well-maintained and follows best practices.

```
/.buildpath
/.cache
/.metadata
/.project
/.settings
/.vscode
atlassian*
/nbproject
/robots.txt
/pub/robots.txt
/sitemap
/sitemap.xml
/pub/sitemap
/pub/sitemap.xml
/.idea
/.gitattributes
/app/config_sandbox
/app/etc/config.php
/app/etc/env.php
/app/code/Magento/TestModule*
/lib/internal/flex/uploader/.actionScriptProperties
/lib/internal/flex/uploader/.flexProperties
/lib/internal/flex/uploader/.project
/lib/internal/flex/uploader/.settings
/lib/internal/flex/varien/.actionScriptProperties
/lib/internal/flex/varien/.flexLibProperties
/lib/internal/flex/varien/.project
/lib/internal/flex/varien/.settings
/node_modules
/.grunt
/Gruntfile.js
/package.json
/.php_cs
/.php_cs.cache
/.php-cs-fixer.php
/.php-cs-fixer.cache
/grunt-config.json
/pub/media/*.*
!/pub/media/.htaccess
/pub/media/attribute/*
!/pub/media/attribute/.htaccess
/pub/media/analytics/*
/pub/media/catalog/*
!/pub/media/catalog/.htaccess
/pub/media/customer/*
!/pub/media/customer/.htaccess
/pub/media/downloadable/*
!/pub/media/downloadable/.htaccess
/pub/media/favicon/*
/pub/media/import/*
!/pub/media/import/.htaccess
/pub/media/logo/*
/pub/media/custom_options/*
!/pub/media/custom_options/.htaccess
/pub/media/theme/*
/pub/media/theme_customization/*
!/pub/media/theme_customization/.htaccess
/pub/media/wysiwyg/*
!/pub/media/wysiwyg/.htaccess
/pub/media/tmp/*
!/pub/media/tmp/.htaccess
/pub/media/captcha/*
/pub/media/sitemap/*
!/pub/media/sitemap/.htaccess
/pub/static/*
!/pub/static/.htaccess

/var/*
!/var/.htaccess
/vendor/*
!/vendor/.htaccess
/generated/*
!/generated/.htaccess
.DS_Store
```

For more technical details, see the [related discussion (18303) on the Tailwind CSS GitHub](https://github.com/tailwindlabs/tailwindcss/discussions/18303).

## Disabling Core Plugins in Tailwind 4

A significant change in Tailwind CSS v4 is the removal of the ability to disable core plugins from the configuration file.

In v3, you could disable a plugin by setting it to `false` in the `corePlugins` object; this is no longer supported in v4.

A community-discovered, non-documented, workaround using `@source not inline("class-name")` exists, which can prevent *some* utilities (like `container`) from being included in the final CSS.
However, this method does not allow you to replace the disabled utility with a custom version.

This workaround should be treated with caution as it is not a complete solution and may stop working in future without notice.

Also, it does not work for all core plugins.

For example, disabling foundational plugins like `preflight` requires a different, more complex setup as detailed in the official Tailwind Docs: [Disabling Preflight](https://tailwindcss.com/docs/preflight#disabling-preflight).

For more background on this topic,
see the [related discussion (16132) on the Tailwind CSS GitHub](https://github.com/tailwindlabs/tailwindcss/discussions/16132).
