<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/design-tokens/simple-tokens.html -->

# Using Simple Tokens

Simple tokens let you define design tokens directly in `hyva.config.json` without needing a design tool like Figma or Penpot.

The structure mirrors a Tailwind CSS theme config - plain key/value pairs without the `$value`/`$type` wrapper that [W3C design token files](formats.html) normally require.

Tip

You can also keep your token values in a separate JSON file and point `tokens.src` at it. The simple token format uses plain key/value pairs with no type information, so no `format` key is needed.

## Defining Simple Tokens in `hyva.config.json`

Add your token values under the `values` key inside the `tokens` section of `hyva.config.json`:

tailwind/hyva.config.json

```
{
  "tokens": {
    "values": {
      "color": {
        "primary": {
          "lighter": "oklch(62.3% 0.214 259.815)",
          "DEFAULT": "oklch(54.6% 0.245 262.881)",
          "darker": "oklch(37.9% 0.146 265.522)"
        },
        "secondary": {
          "lighter": "oklch(72.3% .219 149.579)",
          "DEFAULT": "oklch(52.7% .154 150.069)",
          "darker": "oklch(39.3% .095 152.535)"
        }
      },
      "spacing": {
        "xs": "0.5rem",
        "sm": "0.75rem",
        "md": "1rem",
        "lg": "1.5rem",
        "xl": "2rem"
      }
    }
  }
}
```

Run `npx hyva-tokens` and the key paths become CSS custom properties:

```
@theme {
  --color-primary-lighter: oklch(62.3% 0.214 259.815);
  --color-primary: oklch(54.6% 0.245 262.881);
  --color-primary-darker: oklch(37.9% 0.146 265.522);
  --color-secondary-lighter: oklch(72.3% 0.219 149.579);
  --color-secondary: oklch(52.7% 0.154 150.069);
  --color-secondary-darker: oklch(39.3% 0.095 152.535);
  --spacing-xs: 0.5rem;
  --spacing-sm: 0.75rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
  --spacing-xl: 2rem;
}
```

## Dark Mode with Simple Tokens

The simple token `values` format supports dark mode inline using the `@media:dark-` key prefix.
This lets you define both light and dark values in the same file - no separate dark mode token file needed.

tailwind/hyva.config.json

```
{
  "tokens": {
    "values": {
      "color": {
        "background": "#ffffff",
        "@media:dark-background": "#1a202c",
        "text": "#1a202c",
        "@media:dark-text": "#f7fafc"
      },
      "shadow": {
        "color": "gray",
        "@media:dark-color": "hsl(220 40% 2%)",
        "weight": "1%",
        "@media:dark-weight": "25%"
      }
    }
  }
}
```

The `@media:dark-` prefix generates a `prefers-color-scheme: dark` media query:

```
@theme {
  --color-background: #ffffff;
  --color-text: #1a202c;
  --shadow-color: gray;
  --shadow-weight: 1%;
}

@media (prefers-color-scheme: dark) {
  @theme {
    --color-background: #1a202c;
    --color-text: #f7fafc;
    --shadow-color: hsl(220 40% 2%);
    --shadow-weight: 25%;
  }
}
```

To use a CSS class for dark mode instead of the media query (e.g. a `.dark` class on `<html>`), set the `mediaDark` option in your config:

tailwind/hyva.config.json

```
{
  "tokens": {
    "mediaDark": ".dark",
    "values": { }
  }
}
```

See the [`hyva-tokens` configuration reference](../using-hyva-modules/tokens.html#dark-mode-for-simple-tokens) for full details on dark mode support.

## Sharing Simple Token Values with Tailwind v2 and v3

Because the `values` structure mirrors a Tailwind theme object, you can import `hyva.config.json` directly into `tailwind.config.js`.
This gives you one source of truth for both your CSS custom properties and your Tailwind utility classes:

tailwind.config.js

```
const hyvaConfig = require('./hyva.config.json');

module.exports = {
    theme: {
        extend: {
            colors: hyvaConfig.tokens.values.color,
            spacing: hyvaConfig.tokens.values.spacing,
        },
    },
};
```

## Related Topics

- **[Token Formats](formats.html)** - Use W3C design token files from Figma or Penpot instead of simple tokens
- **[`hyva-tokens` Command Reference](../using-hyva-modules/tokens.html)** - Full configuration options including dark mode and CSS selector customization
