<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/tokens.html -->

# The hyva-tokens Command

The `hyva-tokens` command generates a CSS file from a design tokens file.
It bridges the gap between design and development by letting you use values from design tools like Figma directly in your theme.

Design tokens are key-value pairs that store design-related information such as colors, spacing, and typography.
A similar concept was used in earlier JavaScript-based TailwindCSS configurations.
For a deeper dive, check out the [Design Tokens section](../design-tokens/index.html).

## Generating CSS from Design Tokens

While you can import a JSON file with design tokens directly into your `tailwind.config.js` in Tailwind v2 and v3, mapping the values can be cumbersome.
Instead, `hyva-tokens` focuses on CSS output, converting your design tokens into CSS custom properties (variables).
This approach is inspired by tools like [Fylgja CSS Props Builder](https://fylgja.dev/library/extensions/props-builder/) and [Style Dictionary](https://styledictionary.com/).

Run the command from your theme's Tailwind directory:

```
npx hyva-tokens
```

The `hyva-tokens` command reads a design tokens file and generates a `generated/hyva-tokens.css` file in your theme.

## Configuring hyva-tokens

By default, `hyva-tokens` looks for a file named `design.tokens.json` in your `tailwind/` directory. You can customize this and other options in a `hyva.config.json` file in the root of your Tailwind directory.

### Specifying a Custom Token Source File

If you're using a different file name for your tokens (for example, one exported from Figma), specify it with the `src` key in your `hyva.config.json` file:

hyva.config.json

```
{
  "tokens": {
    "src": "acme.tokens.json",
  }
}
```

### Setting the CSS Selector for Token Output

By default, `hyva-tokens` outputs CSS under the `@theme` selector for Tailwind v4.
Set `cssSelector` to `:root` for compatibility with Tailwind v2 and v3:

hyva.config.json

```
{
  "tokens": {
    "cssSelector": ":root"
  }
}
```

### Using the Legacy Figma Token Format

If your token file uses the older Figma/Tokens Studio format (`"value"` and `"type"` keys without a `$` prefix), set the `format` option to `"figma"`:

hyva.config.json

```
{
  "tokens": {
    "src": "tokens.json",
    "format": "figma"
  }
}
```

For a full guide on this format and its requirements, see [Using Tokens Studio](../design-tokens/figma.html).

Value key requirement

Each token in the legacy format must have a `"value"` key (not `"$value"`).
If your token objects use `"$value"`, use the default format instead - no `format` setting needed.

### Using Google Stitch as Token Source

If you use [Google Stitch](../design-tokens/google-stitch.html), point `tokens.src` at the exported Markdown file. No `format` key is needed - a `.md` source is automatically treated as a Stitch export:

hyva.config.json

```
{
  "tokens": {
    "src": "DESIGN.md"
  }
}
```

Only the YAML frontmatter block is used. The `colors` group is automatically renamed to `color` to match Hyvä's naming convention. For a full guide, see [Using Google Stitch](../design-tokens/google-stitch.html).

### Stripping Wrapper Keys and Renaming Groups

Some token sources wrap values in structural keys that should not become part of the CSS variable name. Use `stripPrefix` to drop those keys, and `rename` to align group names with Hyvä's convention:

hyva.config.json

```
{
  "tokens": {
    "src": "acme.tokens.json",
    "stripPrefix": "tokens.values",
    "rename": {
      "colors": "color"
    }
  }
}
```

Given a source file like this:

```
{
  "tokens": {
    "values": {
      "colors": {
        "primary": "#1d4ed8"
      }
    }
  }
}
```

This generates `--color-primary: #1d4ed8;` instead of `--tokens-values-colors-primary: #1d4ed8;`.

### Defining Simple Tokens Inline

If you're not using an external token file, you can define tokens directly in `hyva.config.json` using the `values` key.
This uses the [Simple Tokens](../design-tokens/simple-tokens.html) approach - plain key/value pairs that mirror a Tailwind CSS theme config, with built-in dark mode support via the `@media:dark-` prefix.

hyva.config.json

```
{
  "tokens": {
    "values": {}
  }
}
```

Warning

If you use the `values` option together with the `src` option, the `values` are ignored and a warning is displayed.

#### Dark Mode for Simple Tokens

Simple tokens support dark mode via the `@media:dark-` key prefix and the optional `mediaDark` option.
By default, dark mode styles are wrapped in `@media (prefers-color-scheme: dark)`.
Set `mediaDark` to use a CSS class selector instead:

hyva.config.json

```
{
  "tokens": {
    "mediaDark": ".dark",
    "values": {}
  }
}
```

For a full guide with examples, see [Simple Tokens - Dark Mode](../design-tokens/simple-tokens.html#dark-mode-with-simple-tokens).

### Example Token Files for Reference

Not sure where to start? These open-source token files are great references for exploring the structure and range of tokens you can use with `hyva-tokens`:

- [Fylgja CSS Tokens](https://cdn.jsdelivr.net/npm/@fylgja/tokens/tokens/fylgja.tokens.json)
- [Open Props Tokens](https://unpkg.com/open-props/open-props.tokens.json)

Potential conflicts with Tailwind

Some tokens in these files may conflict with Tailwind's built-in utility classes.
Spacing tokens are a common example - if your token names match Tailwind's spacing scale (e.g. `spacing.4`), they override those values in your theme.
Review the token names before using a file wholesale and remove or rename anything that conflicts with your Tailwind setup.
