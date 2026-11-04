<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/design-tokens/google-stitch.html -->

# Using Google Stitch

[Google Stitch](https://stitch.withgoogle.com) is a design token tool that lets designers export tokens straight from their design environment as a Markdown file with YAML frontmatter. This makes it a natural fit for `hyva-tokens` - the gap between design and development closes without any manual conversion step.

## Exporting Tokens from Google Stitch

From your Stitch project, export your tokens as a Markdown file. The exported file uses YAML frontmatter to define the token values; the rest of the document (brand voice, component notes, and so on) is ignored by `hyva-tokens`.

A typical Stitch export looks like this:

```
---
name: My Theme
colors:
  primary: oklch(54.6% 0.245 262.881)
  secondary: oklch(45% 0.18 200)
  background: oklch(100% 0 0)
  surface: oklch(97% 0 0)
---

# Brand Voice
...
```

## Configuring hyva-tokens for Google Stitch

Place the exported file in your `tailwind/` directory and point `tokens.src` at it. No `format` key is needed - `hyva-tokens` automatically detects the `.md` extension and treats it as a Stitch export:

hyva.config.json

```
{
  "tokens": {
    "src": "DESIGN.md"
  }
}
```

Run `npx hyva-tokens` to generate the CSS.

## Automatic Group Renaming

Stitch exports the color group as `colors` (plural). `hyva-tokens` automatically renames it to the singular `color` to match Hyvä's naming convention (`--color-primary` instead of `--colors-primary`). No `rename` config is needed for this.

## Missing Tint Variants

By default, Stitch follows the Material Design 3 specification, which does include color variants but uses MD3 tonal palette stops rather than Hyvä's `lighter`/`darker` naming convention. A default Stitch export will not produce the tint structure Hyvä expects for hover states and UI accents.

The default `theme.css` included with `@hyva-themes/hyva-modules` v1.4 fills in the missing tints automatically using `color-mix()`, so nothing breaks out of the box.

For full control over your tints, you have two options. You can use an AI agent such as Gemini or Claude to generate a Hyvä-compatible token file. Stitch itself does not understand the Hyvä structure, but an AI agent can produce the correct output when given the right reference. Use the [Hyvä example DESIGN.md](https://github.com/hyva-themes/hyva-modules-tailwind-js/blob/main/examples/DESIGN.md) as your prompt reference. The example shows how to define `lighter` and `darker` nested under each color group, along with the `ink`, `ink-muted`, `surface`, and `form` tokens Hyvä expects.

Alternatively, keep the Stitch export as-is and use the `rename` option in `hyva.config.json` to align any group names that differ from Hyvä's convention, while relying on `tailwind-source.css` to fill in the tint variants. See Additional Adjustments below.

## Additional Adjustments with `stripPrefix` and `rename`

If your Stitch export includes extra structural keys or group names that need adjusting, use the `stripPrefix` and `rename` options in `hyva.config.json`. See the [`hyva-tokens` command reference](../using-hyva-modules/tokens.html#stripping-wrapper-keys-and-renaming-groups) for details.
