<!-- source: https://docs.hyva.io/hyva-themes/cms/using-tailwind-classes-in-cms-content.html -->

# Using Tailwind Classes in CMS Content

Tldr

The easiest way to use Tailwind classes in CMS content is to install the **CMS Tailwind JIT** module:

```
composer require hyva-themes/magento2-cms-tailwind-jit
```

Tailwindcss v2 or v3

The CMS Tailwind JIT module releases 1.0.x support Tailwindcss v2, and releases 1.1.x support Tailwindcss v3.

Run the following command in your Magento root directory to see a list of all available versions:

```
composer show --all hyva-themes/magento2-cms-tailwind-jit | grep versions
```

Using Tailwind classes in CMS content requires the classes to be present in the compiled `styles.css` file.
Out of the box, only classes will work that also happen to be used in some frontend template file that is included in the Tailwind purge content configuration.

## Automatic inline styles for Tailwind classes in CMS content

To automatically generate the styles for Tailwind classes used in CMS content and render them as inline styles next to the CMS content, Hyvä provides the **CMS Tailwind JIT** module.

Both PageBuilder and WYSIWYG CMS content is supported.

The CMS Tailwind-JIT module is installed by default with Hyvä CMS, but not with Hyvä Theme.
To check if it is installed, run `composer show hyva-themes/magento2-cms-tailwind-jit`.

To install, please run

```
composer require hyva-themes/magento2-cms-tailwind-jit
bin/magento setup:upgrade
```

Contributors and Tech Partners, please head over to **CMS Tailwind JIT** module repository on GitLab and refer to the `README` file for more information.

## Custom Tailwind Configuration

You may specify a custom configuration for the in-browser compilation in a `web/tailwind/tailwind.browser-jit-config.js` file.

Only a subset of the regular tailwind configuration is supported in the browser!

The reason only a subset can be used is that the configuration needs to be evaluated in the browser context.
For this to work, the config has to be serialized to JSON. Many JavaScript expressions, for example functions, regular expressions or file imports, can not be expressed or evaluated as JSON.

### Browser Tailwind Config Limitations

Only `module.exports.theme` may be specified.

No calls to `require()` or `resolveConfig()` are allowed inside the `module.exports` object.

Two plugins are available during the config processing in the browser (with exactly these constant names):

```
const { spacing } = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');
```

No other imports are available in the in-browser configuration.

### Example tailwind.browser-jit-config.js

```
const { spacing } = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');

module.exports = {
  theme: {
    container: {
      center: true
    },
    extend: {
        colors: {
            'my-gray': '#888877',
            primary: {
                lighter: colors.purple['300'],
                "DEFAULT": colors.purple['800'],
                darker: colors.purple['900'],
            },
        }
    },
  }
}
```

### Merging tailwind configs

To avoid declaring the same theme extends in both the `tailwind.config.js` and the `tailwind.browser-jit-config.js`, the
jit-config can be merged into the regular config by appending the following snippet to the end of the
`tailwind.config.js` file:

```
if (require('fs').existsSync('./tailwind.browser-jit-config.js')) {

    function isObject(item) {
        return (item && typeof item === 'object' && !Array.isArray(item));
    }

    function mergeDeep(target, ...sources) {
        if (!sources.length) return target;
        const source = sources.shift();

        if (isObject(target) && isObject(source)) {
            for (const key in source) {
                if (isObject(source[key])) {
                    if (!target[key]) Object.assign(target, { [key]: {} });
                    mergeDeep(target[key], source[key]);
                } else {
                    Object.assign(target, { [key]: source[key] });
                }
            }
        }

        return mergeDeep(target, ...sources);
    }

    mergeDeep(module.exports, require('./tailwind.browser-jit-config.js'));
}
```

Note the browser JIT config must be imported into the regular `tailwind.config.js`, not the other way around.

### Sharing `tailwind.browser-jit-config.js` between themes

Optionally, an alternative `tailwind.browser-jit-config.js` file name can be specified for a theme by creating a file `etc/cms-tailwind-jit-theme-config.json` in the theme.

This is useful in projects with multiple store views and multiple themes, since it can be used to point to a shared `tailwind.browser-jit-config.js` file:

```
{
  "tailwindBrowserJitConfigPath": "../../../../../app/design/frontend/My/theme/web/tailwind/tailwind.browser-jit-config.js"
}
```

A relative path will be evaluated based on the theme's directory. An absolute path is evaluated as specified.
If the path begins with a `/` character, it is treated as an absolute path. Any other character will cause the path to be treated as relative.
If a specified file doesn't exist or can't be read, it is silently ignored, and no custom tailwind config will be used for that theme.

## Custom User CSS

The normal `tailwind-source.css` is completely ignored.
However, it is possible to add custom CSS by creating a `web/tailwind/tailwind.browser-jit.css` file in your theme.

The contents will be passed to the JIT compiler in the browser and included in the styles for the CMS content.

### Sharing `tailwind.browser-jit.css` between themes

The path to the file for the custom CSS can be configured for a theme by creating a file `etc/cms-tailwind-jit-theme-config.json` in a theme.
This allows sharing custom CSS between themes.

```
{
  "tailwindBrowserJitCssPath": "../../../../../app/design/frontend/My/theme/web/tailwind/tailwind.browser-jit.css"
}
```

A relative path will be evaluated based on the theme's directory. An absolute path is evaluated as specified.
If the path begins with a `/` character, it is treated as an absolute path. Any other character will cause the path to be treated as relative.

If a specified file doesn't exist or can't be read, it is silently ignored, and no custom CSS will be used for that theme.

## Further Information

Please refer to the `README` file in the **CMS Tailwind JIT** module repository on GitLab for further information.

## Alternatives to the CMS Browser JIT module

If you choose to not use the CMS Tailwind JIT module for some reason, please refer to [this page](using-tailwind-classes-in-cms-content-without-browser-compilation.html) for strategies on how to be able to work with Tailwind classes in CMS content without browser styles compilation.
