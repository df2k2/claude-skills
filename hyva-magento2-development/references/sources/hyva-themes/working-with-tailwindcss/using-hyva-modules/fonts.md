<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/fonts.html -->

# Self Hosting Fonts with hyva-fonts

Available in version 1.5.0 of the Hyvä NPM package and part of Hyvä Default Theme since 1.5.3

The `hyva-fonts` command downloads the fonts your theme uses and generates the `@font-face` rules for them.
Every font file is served from your own theme, so nothing is requested from a third party while a customer is on your store, which also keeps you clear of the [GDPR problem with loading fonts from Google](../../building-your-theme/custom-fonts.html#google-fonts).

To see what it produces, or to wire the same thing up by hand, see [Using Custom Fonts](../../building-your-theme/custom-fonts.html).

Run it from your theme's Tailwind directory:

```
npx hyva-fonts
```

This writes a `generated/hyva-fonts.css` file, and downloads the font files into `web/fonts/generated`.
The command prints nothing when everything worked, only warnings and errors, the same as the other `hyva-*` commands.

## Adding a Font

Fonts are configured as an array of font families in `hyva.config.json`:

hyva.config.json

```
{
    "fonts": [
        {
            "name": "Inter",
            "cssVariable": "--font-sans",
            "weights": ["100 900"]
        }
    ]
}
```

Import the generated file into your stylesheet:

tailwind-source.css

```
@import "./generated/hyva-fonts.css";
```

The family is then available as a Tailwind utility (`font-sans` in this example), because the CSS variable is declared inside `@theme`:

generated/hyva-fonts.css

```
@font-face {
    font-family: Inter;
    font-style: normal;
    font-weight: 100 900;
    font-display: swap;
    src: url("../fonts/generated/inter-latin-100-900-normal.woff2")
        format("woff2");
    unicode-range: U+0000-00FF, U+0131, U+0152-0153;
}

@theme {
    --font-sans: Inter, sans-serif;
}
```

Safe to import straight away

The file is generated even when no fonts are configured, so you can add the `@import` before you add your first font, and it keeps working after you remove your last one.

## Choosing a Provider

The `provider` key decides where a font comes from. Every provider takes the same options, so switching between them means changing one word.

| `provider` | Catalog |
| --- | --- |
| `fontsource` | [Fontsource](https://fontsource.org/), the default. Open source fonts, including everything on Google Fonts |
| `google-fonts` | [Google Fonts](https://fonts.google.com/) |
| `bunny-fonts` | [Bunny Fonts](https://fonts.bunny.net/), the same catalog as Google Fonts without the tracking |
| `fontshare` | [Fontshare](https://www.fontshare.com/), the ITF library including Satoshi and General Sans |
| `local` | Font files you already have in your theme |

`fontsource` is the default because it is built for self hosting. It publishes a catalog rather than a stylesheet, so asking for a weight, style or subset a family does not have is reported with a list of what it does have, before anything is downloaded.

Adobe Fonts is not supported, because its license does not allow the font files to be self hosted.

Static and variable catalogs

`bunny-fonts` and `fontshare` serve static files only. Asking them for a weight range is refused with a message telling you to list the weights instead.

## Configuration Options

Each entry in the `fonts` array accepts the following keys:

| Key | Default | Description |
| --- | --- | --- |
| `provider` | `fontsource` | Where the font comes from |
| `name` | (required) | The font family name, as the provider spells it |
| `id` | slugified `name` | How the provider addresses the family in a URL |
| `cssVariable` | `--font-` plus the slugified `name` | The CSS variable holding the font stack |
| `cssSelector` | `tokens.cssSelector`, else `@theme` | Where that variable is declared |
| `styles` | `["normal"]` | Any combination of `normal` and `italic` |
| `weights` | `["400"]` | The weights to download |
| `subsets` | `["latin"]` | The character subsets to download |
| `fallbacks` | `["sans-serif"]` | Appended to the font stack |
| `display` | `swap` | The `font-display` of the generated rules |
| `adjustFallback` | `true` | Match the fallback font's metrics to this family |
| `preload` | `false` | Include this family in the generated preload snippet |

Only `woff2` is downloaded. Every browser in use supports it, so an older format only adds weight to your theme.

### Character Subsets

Only the `latin` subset is downloaded unless you ask for more, which is the same choice Fontsource makes. Add `latin-ext` for most of the rest of Europe, or a script such as `cyrillic` or `greek`:

hyva.config.json

```
{
    "fonts": [{ "name": "Roboto", "subsets": ["latin", "latin-ext"] }]
}
```

Each subset is a separate file with its own `unicode-range`, so a visitor only downloads the ones their text actually needs. Adding a subset costs nothing for a customer who never sees a character in it.

`fontshare` serves one file per family covering every character it has, so `subsets` does not apply there.

### Variable Fonts

Most fonts in these catalogs are variable, which means a single file covers a whole weight axis. Pass a range instead of separate weights to use it as one:

hyva.config.json

```
{
    "fonts": [{ "name": "Roboto", "weights": ["300 700"] }]
}
```

Listing separate weights for a variable font works too. The same file is served for each of them, so it is downloaded once and the `@font-face` rules are collapsed into a single weight range.

The declared range comes from the file

A variable file always covers the whole weight axis of the font, so the generated `font-weight` is the range the file contains rather than the range you asked for.

### Font Family Ids

`fontsource` and `fontshare` address a family by an id in a URL, derived from `name` the same way as the CSS variable, so `IBM Plex Sans` becomes `ibm-plex-sans`.

For `fontsource` that derivation is exact for its entire catalog, so you never need to think about it. `fontshare` spells a few of its own ids inconsistently, so set `id` for those:

hyva.config.json

```
{
    "fonts": [
        {
            "provider": "fontshare",
            "name": "JetBrains Mono",
            "id": "jet-brains-mono"
        }
    ]
}
```

The `name` is always what ends up in the CSS, both in the `@font-face` rules and in the font stack, so `id` only changes where the files are fetched from.

## Using Your Own Font Files

Use the `local` provider for a font you already have, such as a licensed brand font. Nothing is downloaded, so you list the files yourself with a `variants` array. Each `src` is resolved against the `web/fonts` folder of your theme:

hyva.config.json

```
{
    "fonts": [
        {
            "provider": "local",
            "name": "Acme Sans",
            "variants": [
                {
                    "weight": "400",
                    "style": "normal",
                    "src": "acme-sans-regular.woff2"
                },
                {
                    "weight": "700",
                    "style": "normal",
                    "src": "acme-sans-bold.woff2"
                }
            ]
        }
    ]
}
```

Unlike a remote provider, a local variant may list several formats. They end up in the `src` in the order you list them, so put `woff2` first:

hyva.config.json

```
{
    "variants": [
        {
            "weight": "400",
            "src": ["acme-sans-regular.woff2", "acme-sans-regular.woff"]
        }
    ]
}
```

A variant also accepts `unicodeRange`, `stretch` and `display`.

## Where the CSS Variables Go

By default the variables are declared in `@theme`, which is what turns them into Tailwind utilities. Tailwind only keeps a `@theme` variable that something actually uses, either a `font-*` class in a template or a `var(--font-*)` in your own CSS, the same as it does for design tokens from [`hyva-tokens`](./tokens.html).

Use `cssSelector` to declare a family somewhere else instead. That output is plain CSS rather than a theme variable, so it is always emitted, and it lets you feed a variable another stylesheet already expects. For example, [Hyvä Prose](./prose.html) reads its heading font from `--h-family`:

hyva.config.json

```
{
    "fonts": [
        {
            "name": "Playfair Display",
            "cssVariable": "--h-family",
            "cssSelector": ".prose",
            "fallbacks": ["Georgia", "serif"]
        }
    ]
}
```

generated/hyva-fonts.css

```
.prose {
    --h-family: "Playfair Display", Georgia, serif;
}
```

Families that share a selector are grouped into one block. When a family does not set `cssSelector`, it falls back to `tokens.cssSelector` if your theme configured one, and to `@theme` otherwise.

No utility outside @theme

A family declared outside `@theme` has no `font-*` utility, because only `@theme` creates one. Reference the variable directly in that case, as with `--h-family` above.

### Tailwind v3 Projects

The `@theme` block is Tailwind v4 syntax, but it is the only part of the output that is, and it is the one part you can move. Set `tokens.cssSelector` to `:root` and everything `hyva-fonts` generates is plain CSS that any Tailwind version, or no Tailwind at all, can use:

hyva.config.json

```
{
    "tokens": { "cssSelector": ":root" },
    "fonts": [{ "name": "Inter", "cssVariable": "--font-body" }]
}
```

generated/hyva-fonts.css

```
@font-face {
    /* ... */
}

:root {
    --font-body: Inter, "Inter fallback", sans-serif;
}
```

That is the same setting [`hyva-tokens`](./tokens.html) uses, so a theme that already moved its design tokens to `:root` gets its fonts there without configuring anything else.

To turn the family into a utility class in v3, point your Tailwind config at the variable:

tailwind.config.js

```
module.exports = {
    theme: {
        extend: {
            fontFamily: {
                body: "var(--font-body)",
            },
        },
    },
};
```

## Reducing Layout Shift with Fallback Fonts

While a webfont is still loading, text is drawn in the next font in the stack. That font is a different width and height, so the page moves when the webfont arrives. This is a common cause of a poor Cumulative Layout Shift score.

To prevent that, the metrics of each family are read from the font file itself, and a second `@font-face` is generated that stretches an already installed font to occupy the same space:

generated/hyva-fonts.css

```
@font-face {
    font-family: "Inter fallback";
    src: local("Arial"), local("Liberation Sans"), local("Arimo");
    size-adjust: 107.3%;
    ascent-override: 90.28%;
    descent-override: 22.48%;
    line-gap-override: 0%;
}

@theme {
    --font-sans: Inter, "Inter fallback", ui-sans-serif, system-ui, sans-serif;
}
```

Nothing extra is downloaded for this, it only reshapes a font the visitor already has.

The font being matched is the first entry in `fallbacks` that is recognised. A generic name such as `sans-serif` stands in for a representative, so the default already does something sensible. Naming a specific font is more accurate:

hyva.config.json

```
{
    "fonts": [{ "name": "Inter", "fallbacks": ["Arial", "sans-serif"] }]
}
```

`Arial`, `Times New Roman`, `Courier New`, `Georgia`, `Verdana`, `Tahoma` and `Trebuchet MS` are recognised, each together with the families that are metrically compatible with it, so the adjustment still holds on a machine without the first one.

Set `adjustFallback` to `false` to leave the stack alone. A family whose fallbacks are not recognised, such as `cursive`, is left alone anyway.

## Preloading a Font

A preloaded font starts downloading with the page rather than after the browser has read your CSS, which removes the flash of fallback text for whatever is visible on load.

This cannot be generated into place, because preloading belongs to your theme's layout rather than to its CSS. Mark a family with `preload` and the command writes a snippet for you to copy:

hyva.config.json

```
{
    "fonts": [
        { "name": "Inter", "cssVariable": "--font-sans", "preload": true }
    ]
}
```

web/fonts/generated/hyva-fonts-preload.xml

```
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <head>
        <!-- hyva-fonts:start -->
        <!-- Inter -->
        <font src="fonts/generated/inter-latin-100-900-normal.woff2"/>
        <!-- hyva-fonts:end -->
    </head>
</page>
```

Copy the contents of the `head` into your theme's `Magento_Theme/layout/default_head_blocks.xml`, creating that file if your theme does not have one. Magento's `font` element renders as a `link` with `rel="preload"`, `as="font"` and `crossorigin="anonymous"`. That last attribute matters, because a font preloaded without it is downloaded a second time when the `@font-face` uses it.

Preload sparingly

Preload only what is needed to render the top of the page, usually a single body font. Every preload competes with the rest of the page for bandwidth, so preloading a font used further down makes the page slower rather than faster.

A family is preloaded with all of its files, so keep a preloaded family narrow. A variable font with one subset is a single file, which is the ideal case.

### Keeping the Preload Hints Up to Date

Keep the two `hyva-fonts` comments when you paste, and you only have to do this once. On every run the command rewrites whatever sits between them, so adding or removing a weight never leaves you preloading a file that is no longer there:

Magento\_Theme/layout/default\_head\_blocks.xml

```
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <css src="css/styles.css"/>
        <!-- hyva-fonts:start -->
        <!-- Inter -->
        <font src="fonts/generated/inter-latin-100-900-normal.woff2"/>
        <!-- hyva-fonts:end -->
    </head>
```

The comments are the opt in, and the region between them is the only part of the file that is ever touched. A theme without them, or without that layout file at all, is left alone entirely. Removing the comments stops it, and removing `preload` from every family empties the region but leaves the comments in place.

Anything ambiguous is refused rather than guessed at, because a broken layout file takes the whole storefront with it. A missing comment, a duplicated one or the two in the wrong order all report the problem and change nothing.

## Generated Files

Downloaded fonts are written to `web/fonts/generated`, next to the `web/tailwind` folder the command runs from. Files no longer covered by your config are removed from it, so keep your own font files directly in `web/fonts`, where the `local` provider looks for them.

Two more generated files sit next to them. `hyva-fonts.json` records what each provider returned, and `hyva-fonts-preload.xml` is the snippet described above, which only appears when a family asks to be preloaded.

You can commit `web/fonts/generated` so your build does not depend on a catalog being reachable. Commit `hyva-fonts.json` along with the font files, or neither, because it is what lets a later run rebuild the stylesheet from the files already on disk.

## Offline and Repeat Builds

A family whose font files are present, and whose config has not changed since they were fetched, is rebuilt from `hyva-fonts.json` without contacting its provider at all. A normal build therefore makes no network requests, and works with no connection.

Only a change that affects which files are needed causes a new request. Changing `fallbacks`, `cssVariable`, `cssSelector` or `display` does not, because those are applied when the stylesheet is written.

When a request is needed and the provider cannot be reached, the font files already on disk are used, and the command says so. If there are none, that family is skipped with a warning and the rest of the stylesheet is still generated. Its CSS variable is still declared, so text falls back to the next font in the stack instead of losing its styling.

The command succeeds in that case, so a warning never stops your CSS from building.

| Flag | Description |
| --- | --- |
| `--force` | Ignore `hyva-fonts.json` and fetch everything again |
| `--strict` | Exit with an error when there were warnings, which is what you want in CI |

Nothing is removed after a warning

A run that could not confirm every family does not know which files are still needed, so it leaves `web/fonts/generated` untouched.

## Related Topics

- **[Using Custom Fonts](../../building-your-theme/custom-fonts.html)** Setting a font up by hand, and what each part of the generated CSS does
- **[The hyva-tokens Command](./tokens.html)** Generating design tokens, which shares the `cssSelector` setting
- **[Hyvä Prose](./prose.html)** The typography styles that read `--h-family`
- **[Best practices for fonts](https://web.dev/font-best-practices/)** In depth guidance from web.dev on font loading performance
