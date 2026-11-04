<!-- source: https://docs.hyva.io/hyva-ui-library/presets.html -->

# Design Token Presets - Hyvä UI

Hyvä UI presets are ready-made design token files that restyle your whole theme at once.
Each preset sets the colors and shadows of your theme through
[design tokens](../hyva-themes/working-with-tailwindcss/design-tokens/index.html),
so you get a new look without touching any templates.

Presets live in the `presets` folder of Hyvä UI, next to the `components` folder.
They were introduced in Hyvä UI 2.9.0.

## Available Presets

| Preset | Folder | Description |
| --- | --- | --- |
| Hyvä Dark | `presets/hyva-dark` | A dark-only version of the **Dark Mode A** palette, with no toggle. |
| Koti | `presets/koti` | Based on the Koti sample data theme, with a sage green primary. |

Hyvä Dark versus Dark Mode A

The **Hyvä Dark** preset makes dark the default and only theme. If you want visitors to switch
between a light and dark theme, use the **Dark Mode A** component instead.

## Requirements

Presets require Hyvä Default Theme 1.4 or higher. This version introduced the semantic color tokens
and the `npx hyva-tokens` design tokens setup.

## Using a Preset

1. Copy `src/web/tailwind/design.tokens.json` from the preset into your theme's `web/tailwind` directory.
2. Remove the `tokens.values` from your theme's `web/tailwind/hyva.config.json`.
   Inline values take precedence over the tokens file.
3. In your theme's `web/tailwind/tailwind-source.css`, remove the `--color-bg`, `--color-surface`,
   `--color-ink`, `--color-ink-muted`, `--color-fg` and `--color-fg-secondary` lines from the
   `@theme` block, if present. This block comes after the generated tokens and would otherwise
   override the preset.
4. Adjust the tokens to fit your own needs.
5. Build your styles by running `npm run watch` or `npm run build` in your theme's `web/tailwind`
   directory. Both commands generate the tokens with `npx hyva-tokens` before building.

For all options of the token generator, see the
[`hyva-tokens` command reference](../hyva-themes/working-with-tailwindcss/using-hyva-modules/tokens.html).

Some presets need extra CSS for theme elements that do not fully adapt to the new palette.
The **Hyvä Dark** preset, for example, lists these fixes in its `README.md`.

## Token Formats

The `design.tokens.json` file uses the
[simple token format](../hyva-themes/working-with-tailwindcss/design-tokens/simple-tokens.html),
plain key and value pairs that mirror a Tailwind theme config.

Each preset also has a `tokens` folder with the same preset in two other formats, for use in design tools:

| File | Format |
| --- | --- |
| `{preset}.tokens.json` | Design Tokens (draft syntax), as used by Figma and Tokens Studio |
| `{preset}.resolver.json` | [Design Tokens 2025.10](https://www.designtokens.org/tr/2025.10/) Resolver |

See [Token File Formats](../hyva-themes/working-with-tailwindcss/design-tokens/formats.html) for how
Hyvä handles each format, and [Using Tokens Studio](../hyva-themes/working-with-tailwindcss/design-tokens/figma.html)
for importing tokens into Figma or Penpot.

## Related Topics

- **[Design Tokens](../hyva-themes/working-with-tailwindcss/design-tokens/index.html)** - Overview of design tokens in Hyvä and the supported formats.
- **[Using Simple Tokens](../hyva-themes/working-with-tailwindcss/design-tokens/simple-tokens.html)** - The token format the presets use, including dark mode.
- **[Components included in Hyvä UI](included-components.html)** - All components available in Hyvä UI.
