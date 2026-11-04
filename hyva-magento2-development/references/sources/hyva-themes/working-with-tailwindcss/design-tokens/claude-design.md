<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/design-tokens/claude-design.html -->

# Using Claude Design

[Claude Design](https://claude.ai/design) is a design tool that can generate a W3C DTCG-compatible JSON token file from your design. This format is the default format for `hyva-tokens`, so no `format` key is needed in your configuration.

## Exporting Tokens from Claude Design

Claude Design does not generate a token file by default. You need to explicitly ask it to produce one. When asked for a `design.tokens.json`, Claude will normally output a DTCG-compatible file, though the exact structure can vary depending on your prompt.

The output will normally follow the W3C Design Tokens Community Group (DTCG) format, using `$value` and `$type` keys:

Example Claude Design export

```
{
  "color": {
    "primary": {
      "$value": "oklch(54.6% 0.245 262.881)",
      "$type": "color"
    },
    "secondary": {
      "$value": "oklch(45% 0.18 200)",
      "$type": "color"
    }
  }
}
```

## Configuring hyva-tokens for Claude Design

Point `tokens.src` at your exported file. Since the output is standard DTCG JSON, no `format` key is required:

hyva.config.json

```
{
  "tokens": {
    "src": "claude.tokens.json"
  }
}
```

Run `npm run build` to run the full build, or `npx hyva-tokens` if you only want to generate the tokens CSS.

## Handling Wrapper Keys

If Claude Design wraps the token values in structural keys that should not appear in the CSS variable names, use `stripPrefix` to drop them and `rename` to align group names with Hyvä's convention. See the [`hyva-tokens` command reference](../using-hyva-modules/tokens.html#stripping-wrapper-keys-and-renaming-groups) for details.

## Adjusting the Output

Since the token file is AI-generated, the structure may not always be exactly what you need. If the generated file contains entries that cause issues or don't match the expected format, you can go back to Claude Design and ask it to adjust the output. For example, you can ask it to remove specific token groups, change how values are structured, or use a different naming convention. Claude Design is conversational, so refining the token file is just a matter of following up in the same session.
