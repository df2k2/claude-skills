<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/custom-fonts.html -->

# Using Custom Fonts

There are a few ways to add a custom font to your Hyvä theme. The steps are always the same: load the font, register it in your CSS, then use it in your styles. Done carelessly though, font loading can hurt your Google ranking metrics — so let's walk through it properly.

## Step 1: Load a font

Before you can use a custom font, the browser needs to know where to find it. You have two options: serve the font files directly from your own server, or load them from Google Fonts.

### Google Fonts

When you select a font on [fonts.google.com](https://fonts.google.com), Google gives you a snippet like this:

```
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
```

To add this to your Hyvä theme, include it in `Magento_Theme/layout/default_head_blocks.xml`. Note that ampersands in XML must be written as `&amp;`:

```
<link src="https://fonts.googleapis.com/css2?family=Roboto&amp;display=swap" rel="stylesheet" type="text/css" src_type="url"/>
```

For the preconnect hints, add a custom block to the head:

```
<referenceBlock name="head.additional">
    <block class="Magento\Framework\View\Element\Text" name="custom.fonts">
        <arguments>
            <argument name="text" xsi:type="string">
                <![CDATA[
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                ]]>
            </argument>
        </arguments>
    </block>
</referenceBlock>
```

Google Fonts and GDPR

Loading fonts directly from Google servers is not GDPR-compliant by default. German websites have been fined for this. If you're serving a European audience, host the font files yourself instead. Use [Google Webfonts Helper](https://gwfh.mranftl.com/fonts) to download the files and get the CSS you need.

### Local font files

Hosting font files on your own server gives you full control and avoids GDPR concerns. You can use custom typefaces or font files downloaded from Google Webfonts Helper.

Add your font files to the `fonts/` folder inside your theme's `web/` directory:

```
web/
└── fonts/
    ├── roboto-regular.woff2
    └── roboto-bold.woff2
```

Stick to `woff2` format. Browser support is universal now, and the older formats (`.ttf`, `.otf`, `.eot`) are no longer necessary.

## Step 2: Register the font in CSS

Once your font files are in place, you need to register them with `@font-face` so the browser knows how to use them. Add these declarations to a CSS file in your theme, for example `web/tailwind/theme/typography.css`.

Each font weight and style needs its own `@font-face` block:

```
/* Regular weight */
@font-face {
    font-family: 'Roboto';
    font-style: normal;
    font-weight: 400;
    font-display: swap;
    src: url('../fonts/roboto-regular.woff2') format('woff2');
}

/* Bold weight */
@font-face {
    font-family: 'Roboto';
    font-style: normal;
    font-weight: 700;
    font-display: swap;
    src: url('../fonts/roboto-bold.woff2') format('woff2');
}
```

The paths are relative to the generated CSS file in `web/css/`, so `../fonts/` resolves to `web/fonts/`.

`@font-face` only registers the font — it doesn't load it. The browser fetches the file only when the font is actually used in a `font-family` declaration.

### font-display options

The `font-display` property controls what the browser shows while the font is loading. For most sites, `swap` is the right choice: text appears immediately using a fallback font, then swaps to the custom font once it's ready.

| Value | Behavior |
| --- | --- |
| `swap` | Show fallback instantly, swap when font loads — recommended for most cases |
| `optional` | Use the font only if it loads very quickly, otherwise stick with the fallback |
| `block` | Hide text briefly while the font loads — avoid unless you have a good reason |
| `fallback` | Short block period, then swap — a middle ground |

## Step 3: Use the font in your CSS

With the font registered, apply it using a standard CSS `font-family` declaration. Add this where you want the font to take effect — typically on the `body` or a specific component:

```
body {
    font-family: 'Roboto', sans-serif;
}
```

### Using the font as a Tailwind utility class

To use the font through Tailwind utility classes (like `font-sans` or a custom class), register it in your Tailwind configuration. The approach differs between Tailwind v3 and v4.

Tailwind v4Tailwind v3

In Tailwind v4, font families are registered directly in CSS using the `--font-*` theme variable namespace. Add this to your `web/tailwind/theme/typography.css`:

```
@theme {
    /* Override the default sans-serif stack with Roboto */
    --font-sans: 'Roboto', ui-sans-serif, system-ui, sans-serif;
}
```

You can also define a custom utility class by adding a new key:

```
@theme {
    --font-brand: 'Roboto', ui-sans-serif, system-ui, sans-serif;
}
```

This generates a `font-brand` utility class automatically.

In Tailwind v3, font families are registered in `tailwind.config.js`. This example replaces the default sans-serif stack:

```
// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
    theme: {
        extend: {
            fontFamily: {
                // Prepend Roboto, keep the default fallback stack
                sans: ['Roboto', ...defaultTheme.fontFamily.sans],
            },
        },
    },
};
```

You can also add a custom key to create your own utility class — for example `font-brand` — instead of overriding `font-sans`.

With either version, the resulting utility class (`font-sans` or your custom key) can be applied directly in your templates.

## Preloading fonts

Preloading fonts sounds like a good idea, but it comes with a real trade-off.

Preloading can hurt LCP

Preloading fonts blocks the first render, which negatively impacts your Largest Contentful Paint (LCP) score. For fonts used above the fold, this can actually make things worse, not better.

A better approach is to set accurate fallback fonts with matching `line-height` values to reserve space. You can also use `size-adjust` and `ascent-override` on the fallback font to minimize layout shift without blocking render. Some tools can [calculate these values dynamically](https://www.industrialempathy.com/perfect-ish-font-fallback/?font=Montserrat) for Google Fonts.

If you've tested your setup and preloading is the right call, add this to the `<head>` section of `Magento_Theme/layout/default_head_blocks.xml`:

```
<font src="fonts/roboto.woff2"/>
```

For preconnect hints to a font server, use a custom template block:

```
<referenceBlock name="head.additional">
    <block
        class="Magento\Framework\View\Element\Template"
        name="custom.fonts"
        template="Magento_Theme::head.phtml"
    />
</referenceBlock>
```

Then in `head.phtml`:

```
<link rel="preconnect" href="<?= $block->getViewFileUrl('fonts/roboto.woff2') ?>">
```

## Related Topics

- **[Tailwind CSS in Hyvä](../working-with-tailwindcss/index.html)** - Overview of how Tailwind CSS is set up in Hyvä Theme
- **[Best practices for fonts](https://web.dev/font-best-practices/)** - In-depth guidance from web.dev on font loading performance
